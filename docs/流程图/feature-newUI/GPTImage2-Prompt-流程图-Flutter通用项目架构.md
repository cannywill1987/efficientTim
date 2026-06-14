创建日期：260606

# GPTImage2 Prompt - 流程图-Flutter通用项目架构

## 生成目标

- 图名：Flutter 通用项目架构模板
- 读者：准备搭建或重构 Flutter 项目的研发团队
- 用途：作为其他 Flutter 项目的架构参考图，不绑定任何具体业务 App
- 重点：目录规范、组件命名、公共能力、国际化、网络请求、Mongo 通用接口、资源位 Manager

## 生成 Prompt

生成一张中文 16:9 横版 Flutter 通用项目架构图。主题是“Flutter 通用项目架构模板”，不是某个具体 App 的业务架构。

画面风格：

- 白色或浅灰背景。
- 工程白板风格，清晰、理性、可复用。
- 中文大字，文字尽量短，必须可读。
- 使用分区卡片 + 箭头 + 轻量泳道。
- 不要出现参考项目名、具体产品名或任何具体业务模块名。
- 不要使用密钥、账号、真实接口地址。
- 不要做营销海报，不要卡通人物，不要暗色背景。

画面分成 6 个主区域：

### 1. 目录与命名规范

放在左侧或顶部，展示推荐目录：

- `main.dart`
- `app/`
- `core/`
- `shared/widgets/`
- `features/xxx/`
- `features/xxx/presentation/pages/XxxPage.dart`
- `features/xxx/presentation/widgets/`
- `common/httpclient/`
- `common/database/apis/`
- `common/provider/`
- `models/`
- `config/`
- `util/`

旁边加命名规则：

- 页面：`XxxPage`
- 页面目录：`page/XxxPage/XxxPage.dart`
- 页面私有组件：`page/XxxPage/components/XxxHeaderWidget`
- 全局公共组件：`components/AppXxxWidget`
- 弹窗：`XxxDialog`
- Manager：`XxxManager`
- Repository：`XxxRepository`

### 2. 页面与组件规范

表现层区域展示：

- `Page 页面入口`
- `Header`
- `Toolbar`
- `List`
- `Item`
- `Form`
- `Empty`
- `Skeleton`
- `DetailPanel`

用一条分隔线标明：

- 页面私有组件放当前页面 `components/`
- 跨页面复用组件放全局 `components/`
- 页面负责组装，子组件负责展示

### 3. 应用壳层与状态

展示：

- `main.dart`
- `AppRoot`
- `Router / Shell`
- `Theme`
- `i18n`
- `Lifecycle`
- `AppState`
- `FeatureState`
- `ViewState`

箭头：

- `AppRoot -> Router / Shell -> Page`
- `State -> UI 刷新`

### 4. 公共能力层

展示 Utility 和 Manager 的边界：

- `Utility：纯工具`
- `时间格式化`
- `字符串处理`
- `平台判断`
- `路由辅助`

Manager 区域展示：

- `HttpManager`
- `ThemeManager`
- `ResourceDeliveryManager`
- `UploadManager`
- `NotificationManager`
- `LoginManager`
- `AiGatewayManager`

标注：

- Utility 放纯函数
- Manager 放有状态、有缓存、有外部依赖的能力

### 5. 网络与 Mongo 请求链路

画一条清晰的数据链路：

`Page -> XxxApisManager / Repository -> MongoDbQuery -> HttpManager -> /api/1/classes/:className -> Egg Model -> Mongo collection`

返回链路：

`Mongo collection -> JSON -> fromJson -> XxxModel -> GlobalStateEnv / FeatureState -> Page`

关键标签：

- `className 不是 collection`
- `Egg Model 显式绑定 collection`
- `Model 使用 fromJson / toJson`
- `分页 totalCount 真实 count`
- `页面不直接 new Dio`
- `请求统一带 token / language / country`
- `HttpManager 统一处理缓存、错误、日志、上传、流式请求`

### 6. 国际化与资源位

国际化链路：

`lib/l10n/*.arb -> intl generate -> lib/generated/* -> getI18NKey().xxx -> UI`

标注：

- 先改 ARB
- 再生成代码
- 业务代码统一入口

资源位链路：

`Scene -> Location -> Delivery -> ResourceDeliveryManager -> HttpManager -> Backend -> AppConfigState -> UI`

标注：

- 远程配置不硬编码
- `scene_code`
- `location_code`
- `delivery_name`
- 支持开关、Banner、版本、Prompt、模板、多语言内容

## 箭头关系

- 用户操作 -> Page。
- Page -> State。
- Page -> Manager / Repository。
- Manager / Repository -> HttpManager。
- HttpManager -> Backend API。
- Backend API -> Database / Redis / Object Storage / Third-party SDK / LLM Provider。
- Backend 返回 -> Model -> State -> UI 刷新。
- ResourceDeliveryManager -> AppConfigState。
- ARB -> generated -> getI18NKey -> UI。

## 右侧架构原则框

右侧放一个“架构原则”说明框，包含以下短句：

- 页面只负责展示和交互。
- 公共组件和页面私有组件分开放。
- Utility 放纯工具。
- Manager 放有状态能力。
- 网络请求统一走 HttpManager。
- Mongo className 与 collection 必须区分。
- 资源位承载远程配置，不硬编码。
- 多语言先改 ARB，再生成代码。
- 新功能按 Feature 拆分。

## 输出要求

- 中文标签清晰。
- 结构适合放进 Markdown。
- 不出现具体业务功能。
- 不出现过多小字。
- 优先表达工程边界和调用链路。

## 本次生成结果

- 生成工具：GPT Image 2（当前会话内置图片生成入口）
- 生成图路径：`docs/流程图/feature-newUI/流程图-Flutter通用项目架构-GPTImage2-v3.png`
- 状态：已生成
- 校验说明：PNG 文件已复制到项目目录；图中不包含本项目具体业务模块，应作为通用 Flutter 架构参考
