# 需求文档-Skills桌面端与项目管理社区扩展

注意: 加清楚中文注释方便阅读

功能: Skills 桌面端首页、安装体系、项目管理、自定义 Skill 上传与社区扩展

以下计划应该是完整的,但在开始实施之前,验证文档和代码库模式以及任务的合理性非常重要。

特别注意现有工具、类型和模型的命名。从正确的文件导入等。

## 功能描述

本功能围绕桌面端 `Skills` 能力中心展开，目标是在现有 Flutter 桌面应用中提供一个类似腾讯 SkillHub 的技能市场首页，支持搜索、分类、排序、分页、详情弹窗、安装到 Claude/OpenCode/自定义路径/项目目录，并进一步支持项目管理与登录用户上传自定义 Skill 到 OSS。它解决的是“桌面端用户发现 Skill、安装 Skill、沉淀项目工作流、扩展自定义 Skill 能力”的一体化需求。

在当前实现基础上，首页已经具备桌面化 UI、真实 Mongo 数据读取、卡片详情、安装弹窗、项目管理入口、分页与分类呈现等能力。为了支撑后续更完整的生态，还需要继续扩展社区模块，让用户可以浏览社区、发帖讨论、围绕 Skill 进行交流与沉淀。

该功能横跨 Flutter、Egg 与 Mongo 三层。Flutter 负责桌面端 UI 与交互，Egg 通过通用 `/api/1/classes/:className` 提供 Mongo 模型访问，Mongo 则承担 Skill 列表、项目记录、自定义上传记录以及未来社区内容的持久化。

## 用户故事

作为桌面端用户  
我想浏览、筛选、安装和管理各种 Skill，并上传自己的 Skill 文档参与生态  
以便快速在 Claude、OpenCode 或项目目录中使用这些能力，并逐步参与社区讨论。

## 问题陈述

问题1: 现有应用缺少一个面向桌面端的 Skill 市场入口，用户无法统一浏览和发现可安装能力。  
问题2: 用户安装 Skill 的目标路径多样，缺少项目管理和历史偏好记忆，重复操作成本高。  
问题3: 自定义 Skill 与社区讨论缺少统一承载，用户难以沉淀自己的内容，也无法围绕 Skill 进行交流。

## 解决方案陈述

解决方案1: 构建桌面端 Skills 首页，参考腾讯 SkillHub 的视觉结构，提供固定七分类、搜索、排序、分页、详情弹窗与安装流程。  
解决方案2: 提供项目管理与自定义 Skill 上传，登录后把项目与上传记录同步到 Mongo，并把文件上传到 OSS 的 `skills/**` 目录。  
解决方案3: 规划社区模块，新增社区列表、帖子详情、发帖回帖等模型与页面，让 Skill 生态从“安装”延展到“讨论与分享”。

## 功能元数据

- 功能类型: 新功能 + 增强
- 预估复杂度: 高
- 受影响的主要系统: Flutter 桌面端、Egg Mongo 模型层、OSS 上传链路、Mongo 数据结构
- 依赖项: `LoginManager`、`HttpManager.uploadOSSFile`、通用 Mongo classes API、`SharedPreferences`

## 上下文引用

### 相关代码库文件 - 实施前必读!

| 文件 | 阅读原因 |
| --- | --- |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/SkillHomePage/SkillHomePage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/SkillHomePage/SkillHomePage.dart) | Skills 桌面端入口页面，已接入 `BaseWidget` 体系 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart) | 当前 Skills 首页主 UI、分类、分页、详情弹窗与项目入口 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillCardWidget.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillCardWidget.dart) | Skill 卡片外观、颜色体系与按钮样式 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillInstallDialog.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillInstallDialog.dart) | 安装目标选择、上次安装方式记忆 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/ProjectManagerPage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/ProjectManagerPage.dart) | 项目管理与自定义 Skill 上传入口 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart) | 项目列表、本地缓存、Mongo 同步、OSS 上传记录 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/database/apis/SkillMongoApisManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/database/apis/SkillMongoApisManager.dart) | Skill 列表、详情、分页、计数更新逻辑 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart) | OSS 文件上传公共方法 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/LoginManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/LoginManager.dart) | 登录用户 UID / 用户名 / 头像来源 |
| [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillItemModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillItemModel.js) | 当前 Skill 列表对应 Egg Model 与 collection 绑定 |
| [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillProjectModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillProjectModel.js) | 项目管理 Mongo 模型 |
| [/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillUploadModel.js](/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillUploadModel.js) | 自定义 Skill 上传记录 Mongo 模型 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md) | Mongo 三层命名与查询对齐规范 |
| [/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/oss上传方法.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/oss上传方法.md) | OSS 上传实现方式与调用约束 |

### 要创建的新文件

```text
lib/com/timehello/models/
├── SkillProjectModel.dart
└── SkillUploadModel.dart

Egg app/model/
├── SkillProjectModel.js
└── SkillUploadModel.js

docs/main-skills-project/
├── 需求文档-Skills桌面端与项目管理社区扩展.md
└── 规划.md
```

### 相关文档

- [/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/main-skills-project/规划-ai-skill-hub-桌面端.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/main-skills-project/规划-ai-skill-hub-桌面端.md) - 已有桌面端 Skills 总体规划基线  
- [/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/PLAN_TEMPLATE.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/PLAN_TEMPLATE.md) - 本次需求与规划文档模板来源

## 要遵循的模式

### 模式名称1: Mongo 类名与 collection 分离

来自 [/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md):

- Flutter 查询使用 className，例如 `SkillItemModel`
- Egg schema 显式绑定 collection，例如 `timehello.skillitemmodel`
- 不允许把 className 直接写成 collection 名

### 模式名称2: 项目记录本地缓存 + 登录后云同步

来自 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart):

- 本地 `SharedPreferences` 保存项目条目
- 登录后读取/写入 Mongo 模型
- UI 统一消费 `SkillProjectEntry`

### 模式名称3: OSS 上传统一走公共 HttpManager

来自 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/httpclient/HttpManager.dart):

- 上传文件统一走 `uploadFile()`
- 通过 `key` 控制服务端落盘目录
- `uploadOSSFile` 接口返回最终可访问的 OSS URL

## 已完成实现

### 阶段 1: Skills 桌面端首页

目标: 搭建桌面化 Skill 市场首页并接入真实数据。

任务:
- 新增桌面端 `SkillHomePage`
- 接入左侧导航与桌面路由
- 构建顶部导航、主标题、分类区、搜索栏、排序栏与 Grid 列表
- 通过 Mongo 查询 `SkillItemModel` 真实数据
- 增加分页、详情弹窗与安装弹窗

### 阶段 2: 安装、项目管理与上传能力

目标: 打通下载/安装、自定义项目管理、自定义 Skill 上传。

任务:
- 支持安装到 Claude / OpenCode / 自定义路径 / 项目目录
- 项目管理支持本地缓存与 Mongo 同步
- 自定义 Skill 文件上传到 OSS 的 `skills/**` 目录
- Mongo 新增项目记录与上传记录
- 安装弹窗记住上次安装方式

### 阶段 3: 社区扩展规划

目标: 为社区列表、帖子详情、讨论入口留出完整扩展空间。

任务:
- 设计社区主页、帖子列表、帖子详情的页面结构
- 设计社区、帖子、回复、关注表
- 规划登录用户发帖、回帖与头像昵称落库逻辑

## 分步任务

### 任务 1: 完成桌面端 Skills 首页与分类体验

实施内容:
- 构建符合腾讯 SkillHub 风格的桌面端首页
- 分类固定为七大类，并给卡片按分类统一色系
- 支持搜索、排序、分页、当前筛选胶囊提示

模式: 参考 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart) 中的首页布局模式  
导入: `SkillHubSection`、`SkillCardWidget`、`SkillMongoApisManager`  
注意点: 分类不要直接依赖脏标签，需要额外做归类规则  
验证: Skills 首页可正常展示七分类与分页卡片

### 任务 2: 完成安装与项目管理

实施内容:
- 安装弹窗支持四种安装方式
- 记住上次安装方式，并在弹窗中显示“(上次安装)”
- 项目管理入口支持项目新增、删除和安装时复用

模式: 参考 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillInstallDialog.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillInstallDialog.dart) 与 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart)  
导入: `SharePreferenceUtil`、`SkillInstallService`、`SkillProjectStorageService`  
注意点: 只记住安装方式，不强制记住上次目录与项目，避免临时路径污染偏好  
验证: 再次打开安装弹窗时默认选中上次安装方式

### 任务 3: 完成自定义 Skill 上传

实施内容:
- 登录用户选择本地 Skill 文件后上传到 OSS
- 上传完成后写入 Mongo 上传记录
- 支持在项目管理弹窗中查看最近上传列表

模式: 参考 [/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/oss上传方法.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/oss上传方法.md)  
导入: `HttpManager.uploadFile()`、`LoginManager`、`SkillUploadModel`  
注意点: `uploadFile()` 必须使用传入的 `key`，确保落到 `skills/**` 目录  
验证: 上传后返回 OSS URL，Mongo 中出现一条 `SkillUploadModel` 记录

### 任务 4: 规划社区模块

实施内容:
- 新增 `社区` 顶部入口
- 设计社区列表页、帖子详情页和未来讨论流
- 采用贴吧式结构承载 Skill 社区内容

模式: 参考贴吧列表页与帖子详情页的三段式信息结构  
导入: `LoginManager.getUid()`、`LoginManager.getUserBean()`  
注意点: 第一阶段建议先做帖子/回复型论坛，不直接做实时聊天室  
验证: 完成需求文档与规划文档，后续按文档实施

## 数据模型与表设计

### 当前已落地

- Skill 列表
  - className: `SkillItemModel`
  - collection: `timehello.skillitemmodel`
- 项目记录
  - className: `SkillProjectModel`
  - collection: `timehello.skillproject`
- 自定义上传记录
  - className: `SkillUploadModel`
  - collection: `timehello.skillupload`

### 规划中的社区表

- `SkillCommunityBoardModel` -> `timehello.skillcommunityboard`
- `SkillCommunityPostModel` -> `timehello.skillcommunitypost`
- `SkillCommunityReplyModel` -> `timehello.skillcommunityreply`
- `SkillCommunityBoardFollowModel` -> `timehello.skillcommunityboardfollow`

## 测试策略

### 单元测试

- Mongo 模型对齐验证:
  - SkillProjectModel / SkillUploadModel 字段序列化
  - Skills 分类归类规则
- 运行:
  - `flutter analyze`

### 集成测试

- 项目管理:
  - 本地项目保存与读取
  - 登录后 Mongo 查询与同步
- 自定义上传:
  - OSS 上传成功后写入 Mongo
- 运行:
  - `flutter analyze`
  - `node --check app/model/SkillProjectModel.js`
  - `node --check app/model/SkillUploadModel.js`

### E2E 测试(手动)

- Skills 首页浏览
  - 打开 Skills 页面
  - 切换七分类与搜索关键词
- 安装弹窗
  - 选择一种安装方式并确认
  - 重新打开弹窗，验证默认选中与“(上次安装)”文案
- 项目管理
  - 添加项目并在安装弹窗里选择该项目
- 自定义上传
  - 登录后选择本地 Skill 文件上传
  - 在上传列表里看到记录并复制链接

## 验证命令

### 级别 1: Flutter 静态检查

```bash
flutter analyze lib/com/timehello/page/skillhub/SkillHubSection.dart lib/com/timehello/components/skillhub/SkillCardWidget.dart lib/com/timehello/components/skillhub/SkillInstallDialog.dart lib/com/timehello/page/skillhub/ProjectManagerPage.dart lib/com/timehello/services/skillhub/SkillProjectStorageService.dart
```

### 级别 2: Egg 模型语法检查

```bash
node --check /Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillProjectModel.js
node --check /Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillUploadModel.js
```

### 级别 3: 真实链路验证

```bash
# 重启 Egg 后手动验证 classes API 与 OSS 上传链路
```

## 验收标准

- Skills 首页在桌面端可正常展示并支持七分类筛选
- 卡片颜色与分类色系一致，不再纯随机跳色
- 安装弹窗支持默认记住上次安装方式，并显示“(上次安装)”
- 项目管理支持本地项目与登录后云同步
- 自定义 Skill 上传可成功落到 OSS `skills/**` 目录并写入 Mongo
- 社区模块有清晰的数据模型与实施规划，可直接进入下一阶段开发

## 完成清单

- [x] Skill 桌面端首页与路由接入
- [x] Mongo 真数据接入与分页
- [x] 安装弹窗与详情弹窗
- [x] 项目管理与自定义 Skill 上传
- [x] 安装方式偏好记忆
- [x] 文档化当前实现与后续规划

## 注意事项

### 设计决策

决策1: 首页分类不直接依赖 Mongo 原始标签，而是增加一层归类规则，换取稳定的设计落地。  
决策2: 项目管理同时保留本地缓存与 Mongo 同步，兼顾离线体验和登录后的多入口一致性。  
决策3: 社区模块先走论坛式帖子/回复结构，不在第一阶段直接做实时聊天，降低复杂度与风险。

### 潜在问题

问题1: Mongo 原始标签不规范，归类规则可能需要继续补关键词。  
问题2: OSS 上传依赖登录态与服务端 token，未登录场景只能展示能力不能真正上传。  
问题3: 社区模块一旦进入实现，范围容易扩大，需要严格按阶段交付。

### 未来改进

- 把自定义上传的 Skill 直接合并回首页列表中展示  
- 增加社区发帖、回帖、点赞、关注社区等真实交互  
- 增加审核、举报、精品贴、置顶贴与通知中心
