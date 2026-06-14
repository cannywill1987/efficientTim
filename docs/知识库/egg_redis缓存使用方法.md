# Egg Redis 缓存使用方法

## 适用范围

这份文档用于约束 Egg.js 后台里和 Redis 缓存相关的实现方式，避免重复手写一套缓存逻辑，或者只加读取不做失效清理。

当前项目里 Redis 常见用途分两类：

- `读缓存`：把查询结果先读 Redis，未命中时再查 MySQL / 其他服务
- `临时值`：验证码、session 关系、短时状态标记等，直接 `set/get/del`

如果是“接口列表结果缓存”，优先复用项目里已经封装好的：

- `ctx.helper.readWithMainRedisCache(...)`

如果是“保存一个简单 key/value”，优先复用：

- `ctx.helper.setRedis(...)`
- `ctx.helper.getRedis(...)`

## 必看参考

- Redis helper 封装：
  - [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/extend/helper.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/extend/helper.js)
- 完整示例接口：
  - [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/controller/resources/LocationScene.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/controller/resources/LocationScene.js)
  - [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/resources/LocationScene.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/resources/LocationScene.js)
- 其他读缓存参考：
  - [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/resources/LocationInfo.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/resources/LocationInfo.js)
  - [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/console/Keyword.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/console/Keyword.js)
  - [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/time_hello/VocabularyService.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/time_hello/VocabularyService.js)

## 一、推荐的缓存模式

### 1. 列表或详情结果缓存

适用于：

- `/api/resource/scene/getList`
- 某个资源详情页
- 某个固定筛选条件下的聚合结果

标准写法：

```js
const result = await ctx.helper.readWithMainRedisCache(app, {
  buildCacheKey: 'cache-prefix:' + businessKey,
  resolveData: async () => {
    // 这里写真实数据查询逻辑
    return await app.mysql.select('table_name', { where: {} });
  },
  expiredMinutes: 30,
}, true);
```

### 2. 简单 key/value 临时缓存

适用于：

- 手机验证码
- email 验证码
- session 与 uid 映射
- 限流标记

标准写法：

```js
await ctx.helper.setRedis(app, {
  key: 'scene:key',
  value: 'xxx',
  expiredTime: 5 * 60,
});

const value = await ctx.helper.getRedis(app, {
  key: 'scene:key',
});
```

## 二、`/api/resource/scene/getList` 的参考实现

路由：

- [router.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/router.js)
  - `router.post('/api/resource/scene/getList', controller.resources.locationScene.getList);`

Controller 层职责：

- 参数校验
- 调 service
- 不直接写缓存逻辑

代码位置：

- [LocationScene.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/controller/resources/LocationScene.js)

Service 层职责：

- 拼缓存 key
- 调 `readWithMainRedisCache(...)`
- 在 `resolveData` 里查 MySQL
- 更新/删除数据后执行缓存失效

代码位置：

- [LocationScene.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/service/resources/LocationScene.js)

它当前的关键模式是：

```js
let lang = ctx.get("LANGUAGE") ? ctx.get("LANGUAGE") : 'all';
const result = await ctx.helper.readWithMainRedisCache(app, {
  buildCacheKey: this.LATEST_20_CACHE_KEY + params.scene_code + lang,
  resolveData: async () => {
    // 查场景
    // 查 location
    // 查 delivery
    // 拼结构
    return sortedDataLocation;
  },
  expiredMinutes: 30,
}, true);
```

## 三、缓存 key 怎么设计

缓存 key 设计原则：

- 必须带业务前缀
- 必须带影响结果的关键参数
- 如果结果和语言、用户、地区有关，必须进 key

推荐格式：

```txt
cache-模块-动作:关键参数1:关键参数2
```

像 `LocationScene.getList` 这种按 `scene_code + lang` 返回不同结果的接口，至少要把：

- `scene_code`
- `LANGUAGE`

拼进缓存 key。

### 不推荐

```js
buildCacheKey: 'scene-list'
```

原因：

- 不同 `scene_code` 会互相污染
- 不同语言会串缓存

## 四、缓存失效必须一起做

只加读取，不做失效，是最容易出脏数据的地方。

以 `LocationSceneService` 为例：

- `create()`
- `update()`
- `delete()`
- `clearCache()`

都会调用：

```js
await this.cleanLatest20Cache(...)
```

并且它不是只删一个 key，而是会把多语言版本一起删掉：

- `all`
- `zh`
- `en`
- `es`
- `fr`

这很重要，因为这个接口的缓存和语言有关。

## 五、什么时候应该放在 helper，什么时候直接用 `app.redis`

### 优先用 helper 的情况

- 读缓存 + miss 后重新查数据库
- 统一设置过期时间
- 统一 JSON 序列化 / 反序列化
- 简单的 set/get 封装

### 可以直接用 `app.redis` 的情况

- 删除缓存：

```js
await this.app.redis.del(key);
```

- 很底层、一次性的 Redis 操作
- helper 当前没有封装到的特殊命令

## 六、当前 helper 的真实封装

### `readWithMainRedisCache`

位置：

- [helper.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/extend/helper.js)

行为：

1. `isRedisOn == false` 时，直接执行 `resolveData()`
2. 先 `redis.get(cacheKey)`
3. 命中则 `JSON.parse(cacheData)` 返回
4. 未命中则执行 `resolveData()`
5. `redis.set(key, JSON.stringify(data), 'EX', expiredMinutes * 60)`

注意点：

- 返回数据必须能被 JSON 序列化
- `Date` 类型会丢失真实对象能力
- `expiredMinutes` 单位是分钟，helper 内部会转秒

### `setRedis`

行为：

- `expiredTime == -1 || null` 时，不设置过期时间
- 否则使用 `EX expiredTime`

注意：

- 这里的 `expiredTime` 单位是秒，不是分钟

### `getRedis`

行为：

- 直接 `app.redis.get(key)`
- 出错时返回 `null`

## 七、推荐写法模板

### 列表接口缓存模板

```js
async getList(params = { scene_code: '' }) {
  const { ctx, app } = this;
  const lang = ctx.get('LANGUAGE') ? ctx.get('LANGUAGE') : 'all';

  const result = await ctx.helper.readWithMainRedisCache(app, {
    buildCacheKey: `cache-scene-list:${params.scene_code}:${lang}`,
    resolveData: async () => {
      // 真实查询逻辑
      return await app.mysql.select('xxx', { where: {} });
    },
    expiredMinutes: 30,
  }, true);

  return ctx.result(ctx, { data: result });
}
```

### 变更接口失效模板

```js
async update(param = {}) {
  const { ctx, app } = this;

  await app.mysql.update('xxx', param);

  await this.app.redis.del(`cache-scene-list:${param.scene_code}:all`);
  await this.app.redis.del(`cache-scene-list:${param.scene_code}:zh`);
  await this.app.redis.del(`cache-scene-list:${param.scene_code}:en`);

  return ctx.result(ctx, { data: null });
}
```

## 八、实现规则

如果后续要在 Egg 里加 Redis 缓存，默认遵守：

1. Controller 不写缓存逻辑，放在 Service
2. 优先复用 `ctx.helper.readWithMainRedisCache(...)`
3. 缓存 key 必须带上影响结果的业务参数
4. 写缓存的同时，必须设计失效策略
5. 结果对象必须可 JSON 序列化
6. 如果接口有语言、地区、用户差异，key 里必须包含这些维度

## 九、完成后最少验证

### 接口行为验证

第一次请求：

- 命中 `resolveData`
- Redis 写入成功

第二次请求：

- 命中 Redis
- 返回结果正确

### 变更接口验证

执行 `create/update/delete` 后：

- 对应 key 被删除
- 下一次读取重新查数据库

### Redis 调试命令

```bash
redis-cli
KEYS *scene*
GET cache-article-latest-20your_scene_codezh
```

## 十、最容易犯错的点

- 把缓存逻辑写进 Controller
- key 没带语言、用户等维度
- `expiredMinutes` 和 `expiredTime` 单位混淆
- 只加缓存读取，不写缓存删除
- 返回 `Date`、复杂对象导致 JSON 序列化后结构变化
