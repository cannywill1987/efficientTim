# MongoDB 模型生成与查询对齐规范

## 目标

这份文档用于约束 `Flutter 模型`、`Egg 后台 Model`、`Mongo 查询层`、`爬虫/同步脚本` 之间的命名和字段映射，避免再次出现以下问题：

- Flutter 请求的 class 名和 Egg Model 名不一致
- Egg 写入的 collection 和 API 查询的 collection 不一致
- Flutter 模型字段少一半，导致 UI 读取错字段
- `totalCount` 写死、分页失真
- 只改了爬虫或只改了前端，三端没有同步

当前 Skill 场景的真实集合为：

- Mongo namespace: `timehello.skillitemmodel`
- Egg classes API: `SkillItemModel`

## 必看参考

实现 MongoDB 新模型或改已有模型时，必须先看这几份参考：

- Flutter 模型参考：
  - [FolderModel.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/FolderModel.dart)
  - [SkillItemModel.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/SkillItemModel.dart)
- Flutter 查询层参考：
  - [MongoApisManager.dart](/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/lib/com/timehello/common/database/apis/MongoApisManager.dart)
  - [SkillMongoApisManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/database/apis/SkillMongoApisManager.dart)
- Egg Model 参考：
  - [FolderModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/FolderModel.js)
  - [SkillItemModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillItemModel.js)
- 数据同步脚本参考：
  - [skillhubJsonSync.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/crawlBin/skillhub/skillhubJsonSync.js)

## 一、命名对齐规则

### 1. Flutter 查询的是 class 名，不是 collection 名

在当前项目里，Flutter 通过 `/api/1/classes/:className` 访问 Egg 通用 Mongo 路由。

所以查询层应写：

```dart
static const String modelName = 'SkillItemModel';
```

不要写：

```dart
static const String modelName = 'skillitemmodel';
static const String modelName = 'timehello.skillitemmodel';
```

原因：

- `SkillItemModel` 是 classes API 的 className
- `timehello.skillitemmodel` 是 Mongo 里的 collection 名
- 两者不是一回事

### 2. collection 名只在 Egg Model / 同步脚本里显式指定

Egg 侧必须明确写死 collection：

```js
{
  versionKey: false,
  collection: 'timehello.skillitemmodel',
}
```

不要依赖 Mongoose 自动推导，不然很容易落到：

- `skillitemmodels`
- `skill_items`
- 其他错误集合

### 3. Flutter Model 类名、Egg API className、Egg 文件名要统一

当前推荐统一成：

- Flutter class: `SkillItemModel`
- Egg file: `app/model/SkillItemModel.js`
- Flutter query className: `SkillItemModel`

## 二、Flutter Model 写法规范

参考 [FolderModel.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/FolderModel.dart)。

### 必须满足

- 继承 `MongoDbObject`
- 使用 `@JsonSerializable()`
- 提供 `fromJson`
- 提供 `toJson`
- 覆盖 `getParams()`
- 复杂字段需要 getter / setter 做二次转换时，优先参考 `FolderModel`

### 推荐模板

```dart
@JsonSerializable()
class XxxModel extends MongoDbObject {
  String? name;
  int? updatedAt;

  XxxModel({
    this.name,
    this.updatedAt,
  });

  factory XxxModel.fromJson(Map<String, dynamic> json) =>
      _$XxxModelFromJson(json);

  Map<String, dynamic> toJson() => _$XxxModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    return toJson();
  }
}
```

### SkillItemModel 当前字段基线

如果是 Skills 相关，至少要同步这些字段：

- `name`
- `slug`
- `description`
- `descriptionZh`
- `version`
- `featured`
- `categoryLabels`
- `tags`
- `homepage`
- `owner`
- `downloads`
- `stars`
- `installs`
- `score`
- `sourceJsonUrl`
- `sourceGeneratedAt`
- `sourceUpdatedAt`
- `status`

### 展示字段不要直接散落在 UI 里拼

像 Skills 这种多来源字段，应该在 Model 里提供统一 getter：

- `displayName`
- `displayDescription`
- `displayVersion`
- `displayCategoryLabels`

不要在多个页面里各自写：

```dart
skill.descriptionZh ?? skill.description ?? skill.readmeSummary
```

## 三、Egg Model 写法规范

参考 [FolderModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/FolderModel.js) 和 [SkillItemModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillItemModel.js)。

### 必须满足

- 文件放在 `egg/app/model/`
- 文件名与类名保持一致，如 `SkillItemModel.js`
- `Schema` 里显式声明所有核心字段
- 在 schema options 中显式写 `collection`
- 需要查询的字段补索引

### 当前 SkillItemModel 推荐结构

至少包含：

- `slug + source` 唯一索引
- `status + updatedAt` 索引
- `featured + updatedAt` 索引
- `categoryLabels` 索引

### 一个易错点

`FolderModel.js` 里有旧注释提到 `mongoose.model('timeHello.FolderModel', PostSchema)` 这种写法。  
在当前 Skills 这条链路里，不要再依赖这种带库名前缀的 model name 习惯。

优先使用：

```js
return mongoose.model('SkillItemModel', SkillItemSchema);
```

然后通过 `collection: 'timehello.skillitemmodel'` 明确绑定真实集合。

## 四、查询层写法规范

参考 [MongoApisManager.dart](/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/lib/com/timehello/common/database/apis/MongoApisManager.dart) 中的 `queryWhereEqual_folderModel()`。

### 推荐模式

1. Manager 内维护本地列表缓存
2. 请求成功后同步到 `GlobalStateEnv`
3. `shouldRefresh == false` 时优先返回缓存
4. 查询结果统一 `map(fromJson)`

### Skills 查询层应满足

- 列表缓存：`listSkillModels`
- 全局缓存：`GlobalStateEnv.listSkillModels`
- 列表查询：`querySkills` / `querySkillsPaged`
- 详情查询：`querySkillDetail`
- 行为更新：`addDownloadCount` / `addFavoriteCount` / `addInstallCount`

### totalCount 不能写死

分页场景里必须走真实 count：

```dart
final int totalCount = await countQuery.queryCount();
```

不要再写：

```dart
final int totalCount = 13000;
```

## 五、同步脚本写法规范

如果数据来源是静态 JSON，优先像 [skillhubJsonSync.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/crawlBin/skillhub/skillhubJsonSync.js) 这样直接同步。

### 推荐流程

1. 拉取 JSON
2. 解析顶层字段
3. 映射每条 skill/document
4. `bulkWrite` 批量 upsert
5. 补 inactive 标记
6. 输出 summary

### 针对腾讯 SkillHub JSON 的字段映射

JSON 真实结构关键字段：

- 顶层：
  - `total`
  - `generated_at`
  - `featured`
  - `categories`
  - `skills`
- 每条 skill：
  - `slug`
  - `name`
  - `description`
  - `description_zh`
  - `version`
  - `homepage`
  - `tags`
  - `downloads`
  - `stars`
  - `installs`
  - `updated_at`
  - `score`
  - `owner`

映射时建议：

- `descriptionZh <- description_zh`
- `description <- description_zh || description`
- `version <- version`
- `categoryLabels <- 根据 categories 反推`
- `featured <- featured 列表命中`
- `sourceJsonUrl <- 当前 json 地址`
- `sourceGeneratedAt <- generated_at`
- `sourceUpdatedAt <- updated_at`

## 六、每次改 Mongo 模型必须同步检查的文件

当你新建或修改一个 MongoDB 业务模型时，至少检查这几层：

1. Egg Model
2. 同步脚本 / 爬虫脚本
3. Flutter Model
4. Flutter 查询层
5. `GlobalStateEnv`
6. UI 里是否还在读旧字段

## 七、落地检查清单

改完后至少执行：

### Egg

```bash
node --check /Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillItemModel.js
node --check /Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/crawlBin/skillhub/skillhubJsonSync.js
```

### Flutter

```bash
flutter analyze lib/com/timehello/models/SkillItemModel.dart
flutter analyze lib/com/timehello/common/database/apis/SkillMongoApisManager.dart
```

### 数据库

检查连接和集合时，优先按 repo skill：

- [$repo-db-access](/Users/linzhibin/.codex/skills/repo-db-access/SKILL.md)

## 八、强制提醒

以后凡是出现以下需求，必须先读这份文档：

- “帮我新建一个 MongoDB Model”
- “帮我把 Egg 和 Flutter 的 Mongo 查询打通”
- “帮我写爬虫入 Mongo”
- “帮我做分页、详情、count”
- “为什么接口有数据但 Flutter 查不到”

如果是 Codex 执行，优先同时参考：

- 本文档
- [FolderModel.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/FolderModel.dart)
- [FolderModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/FolderModel.js)
- [MongoApisManager.dart](/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/lib/com/timehello/common/database/apis/MongoApisManager.dart)
