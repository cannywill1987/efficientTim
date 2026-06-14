# GenImage2 Prompt - 项目架构图

> 日期：2026-06-06  
> 目标产物：`docs/架构/genimage2/timehello-architecture-genimage2-260606.png`

## Prompt

Create a polished product-engineering architecture infographic for a Flutter multi-platform app named "TimeHello / Efficient Time".

Use case: infographic-diagram
Asset type: engineering architecture diagram for a Markdown project document
Primary request: show the current app architecture clearly, with layered modules and data flow.

Canvas and style:
- 16:9 landscape infographic.
- Clean white or very light neutral background.
- Professional SaaS/product engineering style.
- Use distinct but restrained colors for layers: app shell, pages, domain services, data state, external services.
- Keep it readable, modern, and technical.
- Avoid decorative gradients, mascots, cartoon characters, fake code, watermarks, and tiny unreadable text.

Diagram content:
1. Top layer: "Users: Mobile / Desktop / Web".
2. App shell layer:
   - "lib/main.dart"
   - "AdaptiveTheme"
   - "MaterialApp"
   - "Provider"
   - "i18n"
3. Page layer:
   - "MobileTabBarHome"
   - "DesktopRouter"
   - "Mission"
   - "Calendar"
   - "Timeline"
   - "Statistic"
   - "AI"
   - "Wrong Question Book"
   - "Settings"
4. State layer:
   - "Env: route and UI state"
   - "GlobalStateEnv: business list cache"
   - "SharePreferenceUtil: local settings"
5. Domain/service layer:
   - "MongoApisManager"
   - "HttpManager + HttpTask"
   - "AIInterfaceManager"
   - "MobileVoiceTaskManager"
   - "AliyunStoreManager"
   - "Notification / Widget / MethodChannel"
6. Model/resource layer:
   - "models/*.dart + *.g.dart"
   - "assets/"
   - "lib/l10n/*.arb"
7. External services:
   - "Egg.js Backend"
   - "MongoDB / MySQL / Redis"
   - "Aliyun OSS"
   - "Firebase Auth"
   - "LLM Gateway"

Flow:
- Users point into Flutter App.
- Flutter App points into App shell.
- App shell points into Page layer.
- Pages read Env and GlobalStateEnv.
- Pages call Domain/service layer.
- MongoApisManager updates GlobalStateEnv.
- HttpManager talks to Egg.js backend.
- AliyunStoreManager talks to OSS.
- AI managers talk to LLM Gateway and then write business data through AIInterfaceManager / MongoApisManager.

Text policy:
- Use the exact English labels above where possible.
- Keep text large enough to read.
- Prefer boxes, arrows, grouped sections, and concise labels.

## Negative Prompt

No fictional APIs, no extra product names, no secret keys, no source code snippets, no blurry small text, no dark background, no decorative characters, no emoji.

