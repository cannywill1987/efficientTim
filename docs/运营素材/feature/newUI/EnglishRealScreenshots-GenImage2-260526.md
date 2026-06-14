创建日期：260526

# English Real Screenshots + GenImage2 包装说明

## 本次交付

- 产品：Timerbell Todo / 时间管理局 ToDo
- 平台：iOS Simulator, iPhone 16, 英文系统语言 `en_US`
- 登录凭据来源：本机凭据别名 `efficient_time_app`
- 外层包装底板：`docs/运营素材/feature/newUI/genimage2-source/en-real-260526/01-en-real-wrapper-background-source.png`
- 真实英文截图目录：`docs/运营素材/feature/newUI/real-screenshots/en-real-260526/`
- 最终英文营销图目录：`docs/运营素材/feature/newUI/appstore-en-real-genimage2-260526/en/`
- 总览预览图：`docs/运营素材/feature/newUI/previews/en/appstore-en-real-genimage2-260526-preview.png`

## 本次 4 张图

| 页面 | 真实截图 | 最终图 |
| --- | --- | --- |
| Home | `real-screenshots/en-real-260526/00-home-clean.png` | `appstore-en-real-genimage2-260526/en/01-en-home-real-genimage2-1290x2796.png` |
| Create Mission | `real-screenshots/en-real-260526/01-create-task.png` | `appstore-en-real-genimage2-260526/en/02-en-create-task-real-genimage2-1290x2796.png` |
| Charts | `real-screenshots/en-real-260526/02-charts.png` | `appstore-en-real-genimage2-260526/en/03-en-charts-real-genimage2-1290x2796.png` |
| AI Note | `real-screenshots/en-real-260526/03-ai-note.png` | `appstore-en-real-genimage2-260526/en/04-en-ai-note-real-genimage2-1290x2796.png` |

## 执行边界

- 真实 App 内页来自 iOS 模拟器真实截图，不是概念页。
- GenImage2 只参与外层包装底板。
- 本地脚本只做后处理：标题、副文案、标签排版，以及把真实截图放进最终 `1290 x 2796` 画布。

## 当前问题

- 这次已经切到英文系统语言，但 App 内仍有部分中文或中英混排文案，说明产品当前英文 UI 还没有完全打通。
- `Home` 页这次拿到的是干净英文空态；它更适合表达入口和布局，不代表真实账号数据最丰富的状态。
- `Charts`、`Create Mission`、`AI Note` 三页可读性更强，但 `Charts` 里仍混入少量中文时间线内容。
- 登录态在调试态和纯启动态之间有不稳定现象，导致复采时会出现白屏或数据回填不一致。

## 适用范围

- 适合先给你确认“真实英文截图 + 生成图包装”的视觉方向。
- 还不建议直接作为英文版最终上架全套截图，因为英文 UI 仍有残余中文，且页面覆盖数目前只有 4 张。

## 下一步建议

1. 先补齐 App 英文文案，把品牌、副标题、Tab 和任务内容的残余中文清干净。
2. 在稳定账号态下重新采集 Home / Charts / Calendar / Mine / AI / Create Mission 六张真实英文图。
3. 复用本次同一套底板和脚本，只替换真实截图源文件即可重新出图。
