注意: 加清楚中文注释方便阅读

功能: Organization / Group / 我的技能 / Skill 共享与刷新方案

以下计划应该是完整的, 但在开始实施之前, 验证文档和代码库模式以及任务的合理性非常重要。

特别注意现有工具、类型和模型的命名。从正确的文件导入等。

功能描述

当前 Skills 桌面端已经具备了浏览、安装、项目管理、自定义 Skill 上传、收藏、社区入口这些基础能力，但整体仍然是“个人工作台”视角。这个功能的目标，是把它升级成“个人 + 团队协作”的 Skill Hub，让 Skill 不只是装在我本地，而是可以围绕 `organization（组织）`、`group（小组）`、`project（项目）` 形成共享、分发、版本比较和刷新同步机制。

这个规划的重点不是简单增加几张 Mongo 表，而是先把几类关系梳理清楚：谁拥有 Skill、Skill 归属哪个项目、哪些 Skill 可以共享给组织或群组、用户如何通过群组号加入 group、以及“我的技能”页面如何按项目聚合展示并和当前已安装版本对比。只有这一层设计先稳定，后续代码实施才不会边做边改表。

用户故事

作为个人用户
我想上传和管理自己的 Skill，并按项目查看它们的安装状态
以便我知道哪些 Skill 是我自己在维护、哪些需要更新

作为组织管理员
我想创建 organization 和 group，并决定哪些 Skill 可以共享给哪些成员
以便团队能统一使用一套 Skill 标准

作为组织成员
我想通过群组号加入一个 group，并获得这个 group 共享的 Skill
以便快速接入团队已有能力，而不是自己重复安装和维护

问题陈述

问题1: 当前 Skill 的拥有关系只到“个人上传”层，没有 organization 和 group 这层协作模型。
问题2: 当前没有“我的技能”视图，用户无法从项目维度看到自己维护的 Skill 与安装状态。
问题3: 当前安装完成后，缺少“本地安装版本 vs 最新 Skill 版本”的比较机制，也就无法提示 refresh。
问题4: 当前没有团队加入机制，组织内共享 Skill 也没有权限边界。
问题5: `organization`、`group`、`project`、`skill` 之间的关系如果不先定义清楚，后面很容易出现共享边界混乱、权限难补、列表难查的问题。

解决方案陈述

解决方案1: 引入 `organization -> group -> member` 的组织模型，把团队协作能力放在独立的组织体系里，而不是直接揉进现有项目管理。
解决方案2: 新增“我的技能”页面，按项目做 section header 聚合展示，并补充版本比较、刷新状态和更新动作。
解决方案3: 新增 Skill 共享关系模型，让 Skill 可以按“仅自己 / 组织共享 / 群组共享”三种范围进行分发。
解决方案4: 用 6 位随机群组号作为 group 的轻量加入方式，优先解决“邀请加入”问题，不先做复杂邀请链接。
解决方案5: 先做 MVP 权限模型，明确谁能建组织、谁能建组、谁能改共享范围、谁能刷新共享 Skill。

功能元数据

功能类型: 新功能 + 增强
预估复杂度: 高
受影响的主要系统: Flutter 桌面端 UI, Flutter Mongo 查询层, Egg Model / 业务接口, MongoDB 权限与关系表, 安装与版本同步机制
依赖项: [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart), [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/ProjectManagerPage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/ProjectManagerPage.dart), [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart), [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/database/apis/SkillMongoApisManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/database/apis/SkillMongoApisManager.dart), [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/LoginManager.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/util/LoginManager.dart)

上下文引用

相关代码库文件 - 实施前必读!

文件	行数	阅读原因
[/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillHubSection.dart)	1-2200	Skills 首页顶部导航、右上角入口、详情与安装入口都在这里
[/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/ProjectManagerPage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/ProjectManagerPage.dart)	1-900	项目管理和自定义 Skill 上传弹窗，是组织/群组管理入口最自然的延展点
[/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillProjectStorageService.dart)	1-450	当前项目与上传记录都由它管理，后续“我的技能”页面要强依赖这里的项目数据
[/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillInstallDialog.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/components/skillhub/SkillInstallDialog.dart)	1-320	版本刷新和安装到项目的逻辑最终会和这里关联
[/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillFavoritePage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillFavoritePage.dart)	1-260	“我的技能”页面在信息架构上可以参考“我的收藏”
[/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/provider/GlobalStateEnv.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/provider/GlobalStateEnv.dart)	1-220	后续组织、群组、我的技能都建议走统一缓存
[/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md)	1-260	这次新加的 Mongo 模型必须严格按这份规范走

要创建的新文件

/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/
├── SkillOrganizationModel.dart
├── SkillGroupModel.dart
├── SkillGroupMemberModel.dart
├── SkillShareModel.dart
└── SkillProjectInstalledModel.dart

/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/common/database/apis/
└── SkillOrganizationMongoApisManager.dart

/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/
├── SkillMySkillsPage.dart
├── OrganizationManagerPage.dart
└── GroupJoinDialog.dart

/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/
├── SkillOrganizationModel.js
├── SkillGroupModel.js
├── SkillGroupMemberModel.js
├── SkillShareModel.js
└── SkillProjectInstalledModel.js

Mongo collection 绑定

- `SkillOrganizationModel` -> `timehello.skillsorganizationmodel`
- `SkillGroupModel` -> `timehello.skillsgroupmodel`
- `SkillGroupMemberModel` -> `timehello.skillsgroupmembermodel`
- `SkillShareModel` -> `timehello.skillssharemodel`
- `SkillProjectInstalledModel` -> `timehello.skillsprojectinstalledmodel`

说明:

- `className` 继续保持 `SkillOrganizationModel / SkillGroupModel / ...`
- 真实 collection 统一增加 `skills` 前缀，便于和其他业务域的 organization / group / share 表区分
- Flutter 查询层仍然查 `className`，不要把 `collection` 名直接写到 Flutter 里

相关文档

[/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/main-skills-project/规划.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/main-skills-project/规划.md) - 当前 Skills / 项目管理 / 社区基线
[/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/MongoDB模型生成与查询对齐规范.md) - 三层模型对齐
[/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/页面如何跳转.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/页面如何跳转.md) - 右上角入口和桌面导航接入方式
[/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/ThemeManager暗黑模式.md](/Users/linzhibin/Desktop/code/MangaKingFlutter/docs/知识库/ThemeManager暗黑模式.md) - 新页面和弹窗主题适配

要遵循的模式

模式名称1 (来自 SkillMongoApisManager.dart:1-260 / SkillCommunityMongoApisManager.dart:1-240):

- Manager 内维护本地列表缓存
- 查询成功后同步到 `GlobalStateEnv`
- 页面优先消费统一 getter 和缓存，不在 UI 里直接拼底层字段
- count 必须走真实查询，不允许写死常量

模式名称2 (来自 SkillHubSection.dart:120-380 / ProjectManagerPage.dart:1-220):

- 右上角多入口
- 大圆角弹窗
- 先弹窗管理，再进入独立页做深操作

模式名称3 (来自 SkillFavoritePage.dart:1-220):

- 顶部摘要
- 列表卡片
- 支持再次安装 / 详情 / 分页

实施计划

阶段 1: 组织与群组数据模型基线

目标是先把 organization、group、member、share、installed 五层模型定稳。

任务:

- 明确 Mongo Model、Egg Model、Flutter Model 的 className 与 collection 绑定
- 明确 owner / admin / member 角色
- 明确 group joinCode 生成和唯一性策略
- 明确 shareScope 和 refresh 状态机

阶段 2: 组织与群组管理入口

目标是让组织和群组先能被创建和管理。

任务:

- Skills 首页右上角新增 `组织/群组管理`
- 完成 organization/group 管理弹窗或页面
- 完成 6 位群组号加入流程
- 完成 group 是否共享的开关

阶段 3: 我的技能页面

目标是让用户从项目维度看到自己当前在用和维护的 Skill。

任务:

- 新增 `我的技能` 入口
- 按项目做 section header 展示 Skill
- 展示当前安装版本、最新版本、共享状态
- 支持 refresh 动作和状态动画

阶段 4: Skill 共享机制

目标是让“我的 Skill”可以共享给组织和群组。

任务:

- 增加共享设置 UI
- 写入 `SkillShareModel`
- group 成员可看到共享 Skill 列表
- 和项目安装流程打通

阶段 5: 刷新与版本比对增强

目标是让 Skill 同步状态真正可运营。

任务:

- 版本 / file hash 比较
- `need_refresh` 检测
- 刷新成功 / 失败状态记录
- 后续可补批量刷新

分步任务

重要: 按顺序从上到下执行每个任务。每个任务都是原子的且可独立测试。

任务 1: 定义组织与群组数据结构

实施内容: 新增 5 个模型的字段和索引草案
模式: 参考 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/SkillUploadModel.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/models/SkillUploadModel.dart) 中的 MongoDbObject 模式
导入: `MongoDbObject`, `json_annotation`
注意点: `organization` 与 `group` 不要混成一张表
验证: 数据关系图可以独立解释清楚

任务 2: 设计加入群组机制

实施内容: 定义 `joinCode` 生成、校验、失效规则
模式: 参考现有邀请码/短码类业务思路
导入: 登录态与组织查询层
注意点: 先 6 位数字码，后续再考虑邀请码链接
验证: 能用一句话说明“用户如何加入一个 group”

任务 3: 设计“我的技能”列表结构

实施内容: 明确 section header、Skill 行字段、状态图标、刷新动作
模式: 参考 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillFavoritePage.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/page/skillhub/SkillFavoritePage.dart) 的列表页结构
导入: 项目服务、安装记录、Skill 查询层
注意点: 项目分组优先级高于 Skill 分组
验证: 能画出一屏结构，不需要再猜布局

任务 4: 设计版本比较与刷新逻辑

实施内容: 定义 `installedVersion / sourceVersion / installedFileHash / sourceFileHash` 对比策略
模式: 参考 [/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillInstallService.dart](/Users/linzhibin/Desktop/code/MangaKingFlutter/lib/com/timehello/services/skillhub/SkillInstallService.dart) 里的安装目标路径模式
导入: 项目安装记录模型、SkillUploadModel、SkillItemModel
注意点: 不建议只看文件大小
验证: 能明确何时显示红色刷新图标，何时显示绿色对勾

任务 5: 设计共享权限

实施内容: 定义 `private / organization / group` 三种共享范围
模式: 参考 organization/group/member 层级关系
导入: 组织模型、群组模型、登录用户信息
注意点: 权限边界先保守，不要第一版就做复杂继承
验证: 能回答“谁能共享、谁能看、谁能刷新”

测试策略

单元测试

[组织与共享模型测试]:

- joinCode 生成与碰撞校验
- 版本比较策略
- shareScope 权限判断
- Project section grouping 逻辑
运行: `flutter test`

集成测试

[组织共享集成测试]:

- 创建 organization -> 创建 group -> 生成群组号 -> 加入 group
- 上传自定义 Skill -> 共享给 group -> 成员看到共享 Skill
- 我的技能页面显示 need_refresh -> 点击 refresh -> 状态变更
运行: Flutter 页面联调 + Egg 本地接口验证

E2E 测试(手动)

[测试场景1]
- 用户创建 organization 和 group
- 生成群组号
- 另一个用户加入

[测试场景2]
- 用户上传一个 Skill 并共享到 group
- group 成员安装到项目
- Skill 新版本发布后显示 refresh 状态

验证命令

级别 1: 文档与模型对齐验证

```bash
git branch --show-current
```

级别 2: Flutter 页面结构验证

```bash
flutter analyze
```

级别 3: Egg Model 与接口验证

```bash
node --check /Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg/app/model/SkillOrganizationModel.js
```

验收标准

- 用户可以创建 organization
- organization 下可以创建 group
- group 可以生成并展示 6 位群组号
- 用户可以通过群组号加入 group
- 右上角存在 `我的技能` 入口
- 我的技能页按项目分组展示 Skill
- 每个 Skill 能展示当前安装状态与是否需要 refresh
- Skill 可以设置共享范围为私有 / 组织 / 群组
- group 共享开关可以控制成员是否可见共享 Skill

完成清单

- 完成组织模型设计
- 完成群组模型设计
- 完成共享模型设计
- 完成我的技能页面结构定义
- 完成 refresh 状态机定义
- 完成群组号加入流程定义
- 完成权限边界定义

注意事项

设计决策

决策1: 先做 `organization -> group` 两层，而不是只做 group
决策2: “我的技能”按项目分组，不按 Skill 类型分组
决策3: refresh 判断优先比版本与 hash，不只比文件大小
决策4: 共享对象第一版以“我的自定义 Skill”为主
决策5: 加入入口优先做 group，不先做 organization

潜在问题

问题1: organization、group、project 三层容易让用户混淆；解决方案是 UI 文案必须明确“组织 / 小组 / 项目”的职责
问题2: 共享 Skill 和本地项目安装记录可能不一致；解决方案是单独维护 `SkillProjectInstalledModel`
问题3: 权限容易越做越复杂；解决方案是第一版只保留 owner / admin / member 三角色
问题4: refresh 动作涉及文件覆盖，风险较高；解决方案是第一版只做单条 refresh，不做批量静默更新

未来改进

- organization 邀请链接
- group 二维码加入
- 共享 Skill 审批流
- 批量 refresh
- 组织级 Skill 推荐位
- group 维度使用统计和活跃度排行
