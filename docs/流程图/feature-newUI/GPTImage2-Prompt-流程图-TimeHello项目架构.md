创建日期：260606

# GPTImage2 Prompt - 流程图-TimeHello项目架构

## 生成目标

- 图名：TimeHello / Efficient Time Flutter App Architecture
- 读者：接手 Flutter 客户端、AI 能力、数据同步或桌面端路由的研发同学
- 用途：工程交接、架构白板、AI Workflow 视觉说明

## 真实代码依据

- 前端入口：`lib/main.dart`
- 状态管理：`lib/com/timehello/common/provider/Env.dart`、`lib/com/timehello/common/provider/GlobalStateEnv.dart`
- 路由文件：`lib/com/timehello/page/DesktopRouter.dart`、`lib/com/timehello/util/Utility.dart`
- 请求接口：`lib/com/timehello/common/httpclient/HttpManager.dart`
- 数据层：`lib/com/timehello/common/database/apis/MongoApisManager.dart`
- AI 能力：`lib/com/timehello/util/AIInterfaceManager.dart`、`lib/com/timehello/util/MobileVoiceTaskManager.dart`
- 上传能力：`lib/com/timehello/util/AliyunStoreManager.dart`
- 模型目录：`lib/com/timehello/models/`
- 后端边界：`/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg`

## 生成 Prompt

Create a clean 16:9 engineering architecture infographic for a Flutter multi-platform app named "TimeHello / Efficient Time".

Use GPT Image 2 / ChatGPT Images 2.0 style image generation. The output should look like a professional product engineering whiteboard, not a marketing poster.

Visual style:
- Light neutral background.
- Crisp grouped sections with large readable labels.
- Minimal icons only when helpful.
- Use restrained colors: blue for Flutter app shell, purple for pages, green for state/cache, orange for services, red for external services.
- No decorative characters, no dark background, no watermark, no fake source code.

Must show these layers from top to bottom:
1. Users: Mobile / Desktop / Web.
2. Flutter App Shell:
   - lib/main.dart
   - ThemeManager + AdaptiveTheme
   - MaterialApp
   - Provider
   - i18n
3. Pages and Routing:
   - MobileTabBarHome
   - DesktopRouter
   - Mission
   - Calendar
   - Timeline
   - Statistic
   - AI
   - Wrong Question Book
   - Settings
4. State and Cache:
   - Env: route and UI state
   - GlobalStateEnv: business list cache
   - SharePreferenceUtil: local settings
5. Services:
   - MongoApisManager
   - HttpManager + HttpTask
   - AIInterfaceManager
   - MobileVoiceTaskManager
   - AliyunStoreManager
   - Notification / Widget / MethodChannel
6. Models and Resources:
   - models/*.dart + *.g.dart
   - assets/
   - lib/l10n/*.arb
7. External Services:
   - Egg.js Backend /api
   - MongoDB / MySQL / Redis
   - Aliyun OSS
   - Firebase Auth
   - LLM Gateway

Arrows:
- Users point into Flutter App Shell.
- App Shell points into Pages and Routing.
- Pages read State and Cache.
- Pages call Services.
- Services update State and Cache.
- Services talk to External Services.
- Egg.js Backend connects to MongoDB / MySQL / Redis.

Add a small right-side note box titled "Key Rules":
- Desktop routing uses Env, not only Navigator.
- MongoApisManager refreshes GlobalStateEnv.
- AI writes business data through AIInterfaceManager.
- Real backend logic lives in Egg.js.

Text quality requirements:
- Large readable text.
- Keep labels concise.
- Do not invent modules.
- Do not use secret keys.

## 本次生成结果

- 生成工具：GPT Image 2（当前会话内置图片生成入口）
- 生成图路径：`docs/流程图/feature-newUI/流程图-TimeHello项目架构-GPTImage2.png`
- 状态：已生成
- 校验说明：PNG 文件已复制到项目目录；视觉图用于沟通，精确代码路径以架构说明 Markdown 为准
