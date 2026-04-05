# Repository Guidelines

## 项目结构与模块组织
本仓库是一个 Flutter 多端项目。主要业务代码位于 `lib/`，其中核心逻辑集中在 `lib/com/timehello/`，共享组件在 `lib/widgets/`，生成代码在 `lib/generated/` 与 `lib/gen/`，国际化资源在 `lib/l10n/`。静态资源统一放在 `assets/`，常见子目录包括 `assets/img/`、`assets/fonts/`、`assets/opencc/`。平台工程位于 `android/`、`ios/`、`macos/`、`web/`、`windows/`，脚本放在 `scripts/`，测试放在 `test/`。

## 构建、测试与开发命令
在仓库根目录执行以下命令：

- `flutter pub get`：安装依赖。
- `flutter run`：在当前选择的设备上启动应用。
- `flutter analyze`：按 `analysis_options.yaml` 执行静态检查。
- `flutter test`：运行 `test/` 下的测试。
- `flutter pub run build_runner build --delete-conflicting-outputs`：重新生成 `*.g.dart` 模型文件。
- `pub global run intl_utils:generate`：在修改 ARB 后重新生成国际化代码。
- `flutter build apk --release --no-tree-shake-icons`：生成 Android 发布包。

## 代码风格与命名规范
遵循 Dart 默认风格，使用 2 空格缩进，并在 Flutter 组件参数较多时保留尾随逗号以提升格式化可读性。类名使用 `PascalCase`，方法和变量使用 `camelCase`，文件名使用 `snake_case.dart`。不要手动修改 `*.g.dart` 等生成文件，应通过 `build_runner` 重新生成。提交前至少运行一次 `flutter analyze`。

生成或修改代码时，默认补充必要的中文注释，特别是以下场景必须写清楚：

- 数据模型字段用途与兼容关系
- Mongo 查询层、分页、缓存同步逻辑
- 爬虫或同步脚本里的字段映射与 collection 绑定
- 结构较复杂的桌面端 UI 组件

注释要求：

- 优先写“为什么这样做”，不要只写表面动作
- 使用中文，便于团队后续维护
- 只在关键位置添加，避免无意义注释堆积

## 测试规范
新增测试优先使用 `flutter_test`，文件放在 `test/` 下，并以 `_test.dart` 结尾。优先补充解析、持久化、数据模型和源适配相关的单元测试，再考虑组件测试。当前仓库自动化测试覆盖较薄，新增功能至少补一项相关测试；若确实无法测试，需要在 PR 描述里说明原因。

## 提交与 Pull Request 规范
最近提交记录同时存在占位式提交和较规范的 Conventional Commit，例如 `feat(android): ...`、`fix(android): ...`。新提交建议统一使用 `feat:`、`fix:`、`refactor:`、`docs:` 这类前缀，并保持一次提交只做一类改动。PR 应包含变更摘要、影响平台、验证步骤（如 `flutter analyze`、`flutter test`、真机或模拟器验证），UI 改动附截图或录屏。

## 配置与资源注意事项
`build/`、`ios/Pods/`、`.dart_tool/` 等构建产物或依赖目录不要手动编辑。新增图片、字体或其他资源时，需要同步更新 `pubspec.yaml`，并至少在一个移动端目标上确认资源可正常加载。

## 后台代码位置
当前仓库是 Flutter 客户端仓库。如果需求涉及后台数据、接口返回、数据库读写或服务端业务逻辑，请到 Egg.js 后台仓库修改：`/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg`。提交前先确认问题属于客户端还是服务端，避免在当前仓库误改接口适配代码。

## 服务端优先排查规则
如果用户的问题涉及以下任一内容，应优先到 Egg.js 后台仓库排查，而不是先查看 Flutter 客户端代码：

- 数据库位置、库名、账号、连接方式
- MongoDB / MySQL / Redis 的集合、表、键、配置
- 接口返回逻辑、服务端数据结构、爬虫入库、后台任务
- “这条数据从哪里来”“为什么数据库里没有/有这条数据”这类问题

后台仓库路径：`/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg`

只有在确认服务端配置、数据来源或接口逻辑后，才回到 Flutter 仓库查看接口适配、字段映射和页面展示逻辑。

## MongoDB 模型生成规则
如果任务涉及 MongoDB 模型新增、Egg model 字段修改、Flutter `MongoDbObject` 模型、Mongo 查询层、分页 count、或爬虫/同步脚本，请先阅读：

- `docs/知识库/MongoDB模型生成与查询对齐规范.md`

并优先使用本地 skill：

- `~/.codex/skills/mongodb-egg-flutter-sync-guard/SKILL.md`

实现时必须同步检查以下几层：

- Egg model className
- Mongo collection 名
- Flutter model class
- Flutter query manager 的 `modelName`
- `GlobalStateEnv` 缓存
- UI 读取字段

严禁再次出现以下问题：

- collection 对了但 className 错了
- 只改了爬虫/只改了 Flutter，未三端对齐
- `totalCount` 写死

## OSS 上传规则
如果任务涉及图片上传、文件上传、OSS 上传、阿里云 OSS 直传、上传头像、上传音频、上传文档或查找公共上传方法，请先阅读：

- `docs/知识库/oss上传方法.md`

并优先使用本地 skill：

- `~/.codex/skills/oss-upload-implementation-guard/SKILL.md`

默认优先复用现有实现：

- `HttpManager.uploadImage(...)`
- `HttpManager.uploadFile(...)`
- `Utility.dart` 里的选图 / 裁剪 / 压缩方法
- `AliyunStoreManager` 的 OSS 直传方法

不要在未确认现有链路前，重新手写一套上传逻辑。

## Flutter 网络请求规则
如果任务涉及 Flutter 客户端里的网络请求、接口调用、GET/POST、流式请求、文件上传、图片上传、请求缓存、observer 回调，或查找项目现有网络层实现，请先阅读：

- `docs/HttpManager使用说明.md`

并优先使用本地 skill：

- `~/.codex/skills/httpmanager-network-request-guard/SKILL.md`

默认优先复用现有实现：

- `HttpManager.getInstance().doGetRequest(...)`
- `HttpManager.getInstance().doPostRequest(...)`
- `HttpManager.getInstance().doStreamRequest(...)`
- `HttpManager.getInstance().uploadFile(...)`
- `HttpManager.getInstance().uploadImage(...)`
- `HttpTask`

不要在未确认现有封装不满足需求前，直接重新手写一套 `Dio` 网络层。

## Egg Redis 缓存规则
如果任务涉及 Egg.js 后台里的 Redis 缓存、列表接口缓存、详情接口缓存、缓存 key 设计、缓存失效、或查找现有 Redis helper，请先阅读：

- `docs/知识库/egg_redis缓存使用方法.md`

并优先使用本地 skill：

- `~/.codex/skills/egg-redis-cache-usage-guard/SKILL.md`

默认优先复用现有实现：

- `ctx.helper.readWithMainRedisCache(app, {...}, true)`
- `ctx.helper.setRedis(app, {...})`
- `ctx.helper.getRedis(app, {...})`
- 参考接口 `/api/resource/scene/getList`

实现时默认遵守：

- Controller 不写缓存逻辑，放在 Service
- Redis key 必须带业务参数维度
- 读取缓存时必须同步考虑失效策略
- 不要在未确认 helper 封装前重新手写一套 `redis.get/set`

## Flutter 主题与暗黑模式规则
如果任务涉及 Flutter 客户端里的暗黑模式、亮色模式、ThemeManager、页面换肤、弹窗暗色适配、输入框暗色适配、或桌面端页面主题统一，请先阅读：

- `docs/知识库/ThemeManager暗黑模式.md`

并优先使用本地 skill：

- `~/.codex/skills/theme-manager-dark-mode-guard/SKILL.md`

默认优先复用现有实现：

- `ThemeManager.getInstance().getThemeMode()`
- `ThemeManager.getInstance().setThemeMode(...)`
- `ThemeManager` 里的输入框和文本颜色方法

实现时默认遵守：

- 不要只改页面背景，卡片、文字、输入框、弹窗、分页也要一起适配
- 功能色可以保留，但表面色必须跟随主题切换
- 复杂页面优先抽局部调色板或统一 `isDark` 判断

## Flutter 页面跳转规则
如果任务涉及 Flutter 客户端里的页面跳转、桌面端左侧菜单切页、DesktopRouter、`Env.routerMainContainerData`、`Env.routerData`、默认首页、或“页面点了没反应/菜单高亮不对”这类问题，请先阅读：

- `docs/知识库/页面如何跳转.md`

并优先使用本地 skill：

- `~/.codex/skills/page-navigation-desktop-guard/SKILL.md`

默认优先复用现有实现：

- `Utility.pushDesktopMainContainerNavigator(...)`
- `Utility.pushDesktopNavigator(...)`
- `DesktopRouter.buildBodyFunction(...)`
- `PCLeftMenuBarWidget`

实现时默认遵守：

- 主菜单切页改 `routerMainContainerData`
- 内容区内部跳页改 `routerData`
- 新增桌面主页面时，菜单、路由、埋点和默认页要一起检查
