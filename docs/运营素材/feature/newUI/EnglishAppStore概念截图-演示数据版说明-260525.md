创建日期：260525

# English App Store 概念截图演示数据版说明

## 1. 本次产出

本次按 `ai-workflow` 的 App Store Marketing 路径和 UI Designer Agent 规则执行，已实际调用 GenImage2 生成英文外层包装参考图，并用本地脚本合成一套英文概念截图。

产出目录：

- App Store 竖屏概念图：`docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/`
- 英文概念 App 内页图：`docs/运营素材/feature/newUI/concept-screenshots/en-demo-data-260525/`
- 总览预览图：`docs/运营素材/feature/newUI/previews/en/appstore-en-concept-demo-data-260525-preview.png`
- 打包文件：`docs/运营素材/feature/newUI/efficienttime-en-concept-demo-data-260525.zip`
- 生成脚本：`docs/运营素材/feature/newUI/scripts/generate_english_concept_demo_data.py`
- GenImage2 源图：`docs/运营素材/feature/newUI/genimage2-source/en-concept-260525/01-en-concept-wrapper-source.png`

## 2. 页面清单

| 序号 | 页面 | 概念图路径 | 页面目的 |
|---|---|---|---|
| 1 | Today / Home | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/01-en-concept-home-1290x2796.png` | 展示任务、日程和专注进度集中工作台 |
| 2 | AI Voice Capture | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/02-en-concept-voice-ai-1290x2796.png` | 展示语音输入转任务的 AI 能力 |
| 3 | Focus Timer | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/03-en-concept-focus-1290x2796.png` | 展示番茄专注计时与任务执行节奏 |
| 4 | Priority Matrix | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/04-en-concept-matrix-1290x2796.png` | 展示四象限优先级规划 |
| 5 | Calendar | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/05-en-concept-calendar-1290x2796.png` | 展示日程、月历和提醒规划 |
| 6 | Insights | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/06-en-concept-insights-1290x2796.png` | 展示专注时长、完成率和任务复盘 |

## 3. 素材来源与边界

| 类型 | 路径 | 说明 |
|---|---|---|
| GenImage2 外层包装源 | `docs/运营素材/feature/newUI/genimage2-source/en-concept-260525/01-en-concept-wrapper-source.png` | 用于背景氛围和外层包装参考 |
| 本地合成英文概念页 | `docs/运营素材/feature/newUI/concept-screenshots/en-demo-data-260525/` | 由脚本绘制英文 UI 与假数据，便于控制文本准确性 |
| App Store 尺寸概念图 | `docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/` | 统一输出 `1290 x 2796` 竖屏尺寸 |

本套图片是英文概念参考图，内部 App UI 和数据不是从真实英文 App 页面采集。可以用于内部确认英文视觉方向、页面卖点和应用市场排版节奏。

## 4. 上传状态

本次没有上传到 App Store Connect 或其他应用市场。

原因：

- 这套图包含脚本绘制的英文假数据页面，不是英文 App 真实运行截图。
- App Store 官方截图槽位应使用真实 App UI；最终上架英文版需要把 App 切到英文 UI 后重新采集真实页面截图。
- 当前仓库没有发现可直接执行的 Fastlane `deliver` / `Fastfile` 上传链路。

可上传前置条件：

- App 已能在英文环境下稳定进入相关页面。
- 使用真实账号或可审核演示数据重新采集英文截图。
- 确认 App Store Connect 登录、二次验证、版本号、构建号和截图槽位。
- 人工确认截图、描述、关键词、隐私信息和价格地区后再提交。

## 5. 建议下一步

1. 用本套概念图确认英文素材方向和页面顺序。
2. 切换 App 到英文 UI，按相同 6 个页面重新截真实图。
3. 复用当前脚本的外层包装和排版，把真实英文截图替换进手机框。
4. 真实素材确认后再进入 App Store Connect 上传。
