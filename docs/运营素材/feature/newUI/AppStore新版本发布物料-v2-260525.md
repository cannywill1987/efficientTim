创建日期：260525

# App Store 新版本发布物料 v2

## AI Workflow 执行记录

- 使用入口：`ai-workflow`
- 使用子 Agent：`app-store-marketing-image-operator`
- 任务类型：App Store 上线运营素材、ASO 文案、版本更新说明
- 发布版本：`Release v2 - calendar play button`
- 平台与语言：iOS，中文

## 本次版本变化

- 日程页任务卡右侧由火焰标识调整为播放按钮。
- 播放按钮点击进入 Mission Detail / 专注浮层，用户能从日程页直接开始处理任务。
- App Store 第 4 张日程推广图已替换为播放按钮版，避免旧图里入口表达不清。

## 真实截图与生成边界

| 类型 | 路径 | 说明 |
| --- | --- | --- |
| 真实 App 截图 | `docs/运营素材/feature/newUI/real-screenshots/calendar-play-button-260525/calendar-forced-tab.png` | iPhone 16 模拟器截图，已显示日程页任务卡播放按钮 |
| GenImage2 外层包装源 | `docs/运营素材/feature/newUI/genimage2-source/zh/01-cn-home-wrapper-blank-source.png` | 作为统一手机壳、背景、标题和装饰的运营包装源 |
| 本地后处理图 | `docs/运营素材/feature/newUI/appstore-release-v2-260525/zh/04-cn-calendar-play-button-release-v2-gen2-wrapper-1290x2796.png` | 将真实日程截图嵌入 GenImage2 外层包装，输出 App Store 上传尺寸 |

说明：App 内部 UI 来自真实模拟器截图，没有用图片生成工具重画或伪造产品页面。本轮发布动作复用已落盘的 Generation Image 2 外层包装源，并通过本地后处理替换真实日程截图。

## 新版本上传图目录

目录：`docs/运营素材/feature/newUI/appstore-release-v2-260525/zh/`

| 顺序 | 文件 | 页面卖点 |
| --- | --- | --- |
| 1 | `01-cn-home-release-v2-gen2-wrapper-1290x2796.png` | 今日任务、专注、日程一屏掌控 |
| 2 | `02-cn-stats-release-v2-gen2-wrapper-1290x2796.png` | 数据复盘专注与完成情况 |
| 3 | `03-cn-quadrant-release-v2-gen2-wrapper-1290x2796.png` | 四象限优先级管理 |
| 4 | `04-cn-calendar-play-button-release-v2-gen2-wrapper-1290x2796.png` | 日程页直接播放进入任务详情 |
| 5 | `05-cn-tomato-counter-release-v2-gen2-wrapper-1290x2796.png` | 番茄钟与任务计时 |

预览图：`docs/运营素材/feature/newUI/previews/zh/appstore-release-v2-260525-preview.png`

## ASO / SEO 文案包

### App 标题候选

| 方案 | 标题 | 关键词 |
| --- | --- | --- |
| A | 时间管理局 ToDo | 时间管理、待办、番茄钟 |
| B | Timerbell Todo | todo、focus、calendar |
| C | Efficient Time | productivity、focus timer、tasks |

### 副标题候选

| 方案 | 副标题 | 强调卖点 |
| --- | --- | --- |
| A | 任务、专注、日程一屏掌控 | 中文市场主推效率工具定位 |
| B | AI tasks and focus timer | 海外市场突出 AI 与专注计时 |
| C | Plan tasks, focus, review progress | 强调计划、执行、复盘闭环 |

### 关键词池

| 类型 | 中文关键词 | 英文关键词 |
| --- | --- | --- |
| 核心关键词 | 时间管理, 待办清单, 番茄钟 | time management, todo, focus timer |
| 功能关键词 | 四象限, 日程, 数据统计, 任务详情 | Eisenhower matrix, calendar, analytics, task detail |
| 场景关键词 | 学习计划, 工作安排, 专注复盘 | study planner, work planning, productivity review |
| 长尾关键词 | 番茄钟待办, 四象限任务管理, 日程专注工具 | todo focus timer, Eisenhower task manager, calendar productivity |

### 版本更新文案

```text
日程页体验优化：任务卡新增播放入口，可从日程视图直接进入任务详情与专注流程。
优化 App Store 展示素材，突出任务、专注、日程一体化管理体验。
```

### 截图标题文案

| 截图 | 标题 | 副标题 |
| --- | --- | --- |
| 1 | 任务、专注、日程一屏掌控 | 用番茄钟管理待办，让每天更清晰 |
| 2 | 用数据复盘效率 | 专注时长、任务完成情况一目了然 |
| 3 | 四象限抓住重点 | 重要和紧急任务分区管理 |
| 4 | 日程里直接开始任务 | 点击播放进入任务详情，计划和执行不脱节 |
| 5 | 番茄钟专注执行 | 把任务落到每一次专注计时里 |

## 发布检查清单

- [x] 真实日程截图已采集。
- [x] 日程页播放按钮已在真实截图中可见。
- [x] 上传图均为 `1290 x 2796`。
- [x] 上传目录已生成。
- [x] 预览图已生成。
- [x] ASO 文案与版本更新文案已整理。
- [ ] App Store Connect 截图上传与提交审核：待用户确认后执行。

## 待确认

- 是否把 v2 素材作为本次 App Store Connect 的最终上传版本。
- 是否需要同步英文版截图和英文 ASO 文案。
- 是否需要重新调用 Generation Image 2 生成全新外层包装，而不是复用当前已落盘包装源。
