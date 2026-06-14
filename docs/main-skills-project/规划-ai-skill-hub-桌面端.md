功能: AI Skill Hub 桌面端技能市场与安装系统

以下计划应该是完整的,但在开始实施之前,验证文档和代码库模式以及任务的合理性非常重要。

特别注意现有工具、类型和模型的命名。从正确的文件导入等。优先复用当前仓库已经存在的 `provider`、桌面导航和 MongoDB 查询封装。

功能描述

在当前 `MangaKingFlutter` Flutter 仓库中新增一个仅面向 Windows 和 macOS 的 AI Skill Hub 桌面模块,用于浏览、搜索、查看和安装 AI Skills。该模块以独立桌面入口接入,不替换现有移动端和既有桌面业务入口,以减少对当前业务流程的扰动。

技能数据由外部爬虫抓取后写入 MongoDB。Flutter 端参考 `lib/com/timehello/common/database/apis/MongoApisManager.dart` 的方式直接查询 MongoDB,不为 MVP 新建一套独立 REST 查询链路。EggJS 侧负责爬虫、数据清洗、去重和入库。

用户故事

作为项目维护者和桌面端用户
我想浏览并安装 AI Skills
以便把技能快速安装到 Claude、OpenCode、指定目录或本地项目中

问题陈述

问题1: 当前仓库没有 AI Skill Marketplace 的桌面端入口和完整交互流程。
问题2: 技能安装目标存在多个平台和目录规则,缺少统一的安装服务。
问题3: 技能数据需要持续抓取、标准化并写入 MongoDB,同时客户端需要复用现有 Mongo 查询模式。
解决方案陈述

新增桌面专用 Marketplace 页面、安装弹窗和项目管理页面,使用现有 `provider` 与桌面导航风格完成 UI 集成。
新增 `SkillModel` 和 `SkillMongoApisManager`,参考 `MongoApisManager` 使用 `MongoDbQuery` / `MongoDbObject` 进行技能数据读取。
在 `/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/crawlBin` 新增技能抓取任务,将标准化数据 upsert 到 `skill_items` 等 `skill_*` 集合。
功能元数据

功能类型: 新功能
预估复杂度: 高
受影响的主要系统: Flutter 桌面端,本地文件安装服务,MongoDB 数据层,EggJS 爬虫
依赖项: `provider`, `dio`, `shared_preferences`, 现有 MongoDB SDK, 本机 `git` 命令, 文件选择器/路径工具

上下文引用

相关代码库文件 - 实施前必读!

文件	行数	阅读原因
docs/PLAN_TEMPLATE.md	1-200	作为计划文档结构模板
lib/com/timehello/common/database/apis/MongoApisManager.dart	1-260	复用 Mongo 查询、保存和 manager 组织方式
lib/main.dart	529-680	确认 MaterialApp、桌面入口、路由和现有 provider 注入点
lib/com/timehello/page/DesktopRouter.dart	1-200	参考桌面端路由和页面承载方式
pubspec.yaml	24-70,246-290	确认依赖、资源和现有工具链
要创建的新文件

path/to/new/
├── lib/com/timehello/page/skillhub/SkillMarketplacePage.dart
├── lib/com/timehello/page/skillhub/ProjectManagerPage.dart
├── lib/com/timehello/components/skillhub/SkillCardWidget.dart
├── lib/com/timehello/components/skillhub/SkillInstallDialog.dart
├── lib/com/timehello/models/SkillModel.dart
├── lib/com/timehello/common/database/apis/SkillMongoApisManager.dart
└── lib/com/timehello/services/skillhub/SkillInstallService.dart
相关文档

docs/PLAN_TEMPLATE.md - 本计划格式基准
lib/com/timehello/common/database/apis/MongoApisManager.dart - MongoDB 查询模式基准
/Users/linzhibin/.codex/skills/.system/skill-creator/SKILL.md - skill 创建规范
要遵循的模式

模式名称1 (来自 lib/com/timehello/common/database/apis/MongoApisManager.dart:211-229):

```dart
MongoDbQuery<SharePreferenceModel> query = MongoDbQuery();
query.or(list);
query.skip = 0;
query.limit = 100000;
List<dynamic> data = await query.queryObjects();
List<SharePreferenceModel> result =
    data.map((i) => SharePreferenceModel.fromJson(i)).toList();
```

模式名称2 (来自 lib/main.dart:534-662):

```dart
builder: (lightTheme, darkTheme) => MaterialApp(
  home: SplashPage(),
  routes: {
    ...
  },
)
```

实施计划

阶段 1: 桌面入口与技能浏览

建立桌面独立入口、Marketplace 页面、技能卡片和 MongoDB 查询链路,先完成“能看”。

任务:

新增 `SkillModel` 与 `SkillMongoApisManager`
新增桌面入口页面和 Marketplace GridView
支持关键词搜索与详情弹窗基础信息展示
阶段 2: 安装与项目管理

完成技能安装目标选择、自定义路径、项目管理、本地持久化和安装执行链路,实现“能装”。

任务:

新增项目管理页和本地项目存储
实现 Claude / OpenCode / 自定义 / 项目路径解析
实现 ZIP 下载、解压、git 回退安装
阶段 3: 爬虫入库与联调

完成爬虫标准化入库、Mongo 数据结构稳定化和桌面联调,实现“数据可持续更新”。

任务:

在 EggJS 爬虫目录新增技能抓取任务
统一 `skill_items` 文档结构和 upsert 规则
联调 Flutter Mongo 查询与真实数据
分步任务

重要: 按顺序从上到下执行每个任务。每个任务都是原子的且可独立测试。

任务 1: 建立 Skill 数据模型与 Mongo 查询管理器

创建 `SkillModel` 和 `SkillMongoApisManager`,参考现有 `MongoApisManager` 完成列表、搜索、详情查询。

实施内容: 创建 `SkillModel extends MongoDbObject` 和 `SkillMongoApisManager`,提供 `querySkills`、`querySkillDetail`、`queryFeaturedSkills`
模式: 参考 lib/com/timehello/common/database/apis/MongoApisManager.dart:211-229 中的 Mongo 查询模式
导入: `MongoDbQuery`, `MongoDbObject`
注意点: 集合命名使用 `skill_items`; 模型字段至少包含 `objectId`, `name`, `slug`, `description`, `icon`, `repoUrl`, `downloadUrl`, `tags`, `source`, `updatedAt`
验证: 能从 MongoDB 拉取列表并正确映射成 `SkillModel`

任务 2: 新增桌面 Skill Hub 独立入口

在当前桌面路由体系中新增 Skill Hub 入口,仅在 `Platform.isWindows || Platform.isMacOS` 时展示。

实施内容: 新增桌面入口页面并接入 DesktopRouter 或当前桌面路由承载页
模式: 参考 lib/main.dart:534-662 中的 MaterialApp 与 routes 组织方式
导入: 现有 provider、桌面页面组件
注意点: 不替换现有桌面首页; 作为新增入口接入
验证: 桌面端可进入 Marketplace,移动端不受影响

任务 3: 实现 Marketplace 页面与搜索

开发搜索框、GridView 技能卡片、加载态、空态和基础错误态。

实施内容: 开发 Marketplace 页面,调用 `SkillMongoApisManager.querySkills`
模式: 参考现有页面和组件风格,避免引入新状态管理框架
导入: `provider`
注意点: 搜索直接查询 MongoDB; 分页先用 `skip/limit` 简单实现
验证: 输入关键词后列表刷新; 卡片显示 icon、name、description、tags

任务 4: 实现安装弹窗与目标路径解析

开发安装弹窗,支持 Claude、OpenCode、自定义路径、安装到项目。

实施内容: 开发安装弹窗和路径解析服务
模式: 参考现有 Dialog 工具类组织方式
导入: 文件选择器、路径相关工具
注意点: 路径规则固定为 Claude macOS、Claude Windows、OpenCode 和自定义/项目追加 `/skills/<slug>`
验证: 不同目标下返回正确最终安装路径

任务 5: 实现项目管理与本地存储

新增项目列表页,支持添加目录、删除项目、项目多选安装。

实施内容: 用 `shared_preferences` 保存 `{ name, path, createdAt }[]`
模式: 参考现有 `shared_preferences` 使用方式
导入: `shared_preferences`
注意点: 路径去重; 名称默认取目录名
验证: 重启应用后项目列表仍存在,可多选项目执行安装

任务 6: 实现 Skill 安装服务

实现下载 ZIP、解压、复制到目标目录;ZIP 失败时回退 `git clone`。

实施内容: 封装安装服务,最终目录统一 `<target>/skills/<slug>/`
模式: 服务层独立封装,UI 只消费状态和结果
导入: `dio`, 文件系统工具,压缩工具,外部 `git` 调用能力
注意点: 安装默认覆盖同名目录; `git` 缺失时明确报错
验证: 同一 skill 可安装到 Claude、自定义目录和项目目录

任务 7: 在 EggJS 爬虫中新增技能抓取任务

在 `/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/crawlBin` 中新增 skill 抓取脚本,抓取后写入 MongoDB。

实施内容: 抓取 GitHub、Claude/OpenCode skill 源和社区站点,标准化后写入 `skill_items`
模式: 复用现有 EggJS 爬虫目录结构和日志方式
导入: 当前爬虫公共工具、Mongo 客户端
注意点: upsert 规则为 `slug + source`; 字段缺失时补默认值
验证: 爬虫运行后 MongoDB 中有标准化技能数据,Flutter 端可查询
测试策略

单元测试

Flutter 数据与安装:

`SkillModel.fromJson/toJson`
`SkillMongoApisManager` 列表、搜索、详情查询
Claude/OpenCode/自定义/项目路径解析
ZIP 成功安装与 ZIP 失败回退 git
运行: `flutter test`

集成测试

桌面联调:

Flutter 连接 MongoDB 后可展示技能列表
项目管理页新增项目后可执行安装
安装完成后目标目录出现 `skills/<slug>`
运行: `flutter analyze && flutter test`

E2E 测试(手动)

浏览并安装到 Claude
启动桌面应用,打开 Skill Marketplace,搜索一个 skill 并安装到 Claude,检查目标目录
安装到多个本地项目
添加两个项目目录,选择一个 skill 安装到多个项目,检查两个项目下的 `skills/<slug>`
验证命令

级别 1: 静态检查

```bash
flutter analyze
```

级别 2: 单元测试

```bash
flutter test
```

级别 3: 桌面运行验证

```bash
flutter run -d macos
flutter run -d windows
```

验收标准

桌面端存在独立 AI Skill Hub 入口,且不影响现有移动端流程
技能列表、搜索、详情可直接通过现有 Mongo 查询模式读取
安装目标支持 Claude、OpenCode、自定义路径和多个项目
ZIP 下载失败时可自动回退到 `repoUrl` 安装
爬虫可将标准化技能数据写入 `skill_items` 并被客户端读取
完成清单

已新增 `SkillModel` 和 `SkillMongoApisManager`
已新增桌面 Marketplace、安装弹窗、项目管理页
已实现本地项目存储和目标路径解析
已实现 ZIP + git 双模式安装
已完成爬虫入库与 Flutter 联调
注意事项

设计决策

决策1: Flutter 端直接复用现有 MongoDB 查询体系,因为仓库已经有成熟的 `MongoApisManager` 模式,新建 REST 查询链路会增加重复工作
决策2: Skill Hub 以桌面独立入口接入,因为当前仓库已有复杂主业务流程,直接替换桌面首页风险更高
决策3: 安装采用 ZIP 优先、git 回退,因为技能源并不总能稳定提供统一下载包
潜在问题

问题1: 部分 skill 源缺少标准 metadata
问题2: 用户本机未安装 `git`
问题3: 直接查 MongoDB 的权限和网络配置可能受环境限制
未来改进

增加技能分类、精选、排序和版本信息
增加安装历史云同步和更新检测
增加后台管理页面与定时抓取调度
