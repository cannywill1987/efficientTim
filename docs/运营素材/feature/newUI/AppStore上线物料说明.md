创建日期：260521

# 时间管理局 Todo App Store 上线物料说明

## 产出范围

本次已生成 iPhone 6.7 英寸 App Store 竖屏推广图，尺寸统一为 `1290x2796`。

中文素材：

- `docs/运营素材/feature/newUI/appstore/zh/01-cn-home.png`
- `docs/运营素材/feature/newUI/appstore/zh/02-cn-voice-ai.png`
- `docs/运营素材/feature/newUI/appstore/zh/03-cn-today.png`
- `docs/运营素材/feature/newUI/appstore/zh/04-cn-focus.png`
- `docs/运营素材/feature/newUI/appstore/zh/05-cn-stats.png`

英文素材：

- `docs/运营素材/feature/newUI/appstore/en/01-en-home.png`
- `docs/运营素材/feature/newUI/appstore/en/02-en-voice-ai.png`
- `docs/运营素材/feature/newUI/appstore/en/03-en-today.png`
- `docs/运营素材/feature/newUI/appstore/en/04-en-focus.png`
- `docs/运营素材/feature/newUI/appstore/en/05-en-stats.png`

## 素材来源说明

- 已尝试启动 iOS 模拟器并采集真实移动端页面。
- 当前模拟器可启动 App，隐私弹窗已在本地测试环境通过偏好设置跳过，但主界面停留白屏，无法稳定采集完整真实页面。
- 因用户明确允许“没有就造数据”，本次推广图使用运营 mock 数据绘制，功能结构基于当前产品能力：任务管理、AI 语音创建、今日清单、专注计时、时间复盘。
- 这些图片可作为应用商店营销截图草案使用；若要作为最终审核素材，建议在 App 真机页面可稳定打开后，用真实页面截图替换 mock 手机界面部分。

## 中文 App Store 元数据草案

应用名称：时间管理局Todo

副标题：
AI 任务清单与番茄专注

关键词：
时间管理,待办清单,任务管理,番茄钟,专注计时,日程计划,效率工具,AI助手,语音记录,习惯打卡

截图文案：

1. 把待办、日程、专注放进一个移动工作台
2. 说出来，自动整理成任务
3. 今天要做什么，一眼看清
4. 让每个任务都有执行节奏
5. 复盘时间投入，找到真正的重点

简短描述：
时间管理局 Todo 帮你把待办、计划、专注计时和复盘统计放在一个移动工作台里。用清单安排任务，用番茄钟推进执行，用 AI 语音快速捕捉临时想法。

版本更新文案：
本次优化移动端任务创建体验，补充 AI 语音创建入口，减少录入成本；同时整理任务    管理、专注计时和复盘统计的移动端展示素材。

## English App Store Metadata Draft

App Name:
Timerbell Todo

Subtitle:
AI tasks and focus timer

Keywords:
time management,todo list,task manager,pomodoro,focus timer,daily planner,productivity,AI assistant,voice notes,habit tracker

Screenshot copy:

1. Tasks, schedule and focus in one mobile workspace
2. Speak it. Turn it into tasks.
3. See today at a glance
4. Give every task a rhythm
5. Review where your time goes

Short description:
Timerbell Todo brings tasks, planning, focus sessions and time review into one mobile workspace. Plan your day, capture ideas by voice, focus with Pomodoro sessions and understand where your time goes.

What’s New:
Improved the mobile task creation flow with an AI voice entry, making it easier to capture tasks quickly. This update also prepares clearer App Store visuals for tasks, focus and time review.

## App Store 上线动作

当前已完成本地素材准备，尚未执行 App Store Connect 上传或提交审核。

上线前需要确认：

- App Store Connect 登录账号和二次验证可用。
- 当前版本号、构建号和 TestFlight/正式构建已准备好。
- 是否允许使用本次 mock 推广图作为审核素材，或先等真实页面截图替换。
- 是否只更新“时间管理局 Todo”的截图与文案，还是同步提交新版构建。

建议下一步：

1. 若只是先更新截图和元数据，进入 App Store Connect 对应 App 的版本页面上传上述 `zh` / `en` 截图并填入文案。
2. 若要提交新版构建，先完成 iOS release build、上传 TestFlight，再在版本页绑定构建并提交审核。
3. 提交审核前需要人工最终确认，避免误提交未确认的版本、价格、地区或隐私信息。
