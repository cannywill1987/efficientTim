创建日期：260525

# Generation Image 2 真实截图合成说明

## 本次交付

- 产品：Efficient Time / 时间管理局 ToDo
- 平台：iOS 模拟器，iPhone 16，中文界面
- 登录态来源：本机凭据别名 `efficient_time_app`，已写入 iOS SharedPreferences；账号 UID 为 `089f8c2d-85b9-45f1-899c-d1159ca9e6f3`
- 真实产品截图：`docs/运营素材/feature/newUI/real-screenshots/zh/real-09-fresh-home-before-gen2.png`
- Generation Image 2 空白包装源图：`docs/运营素材/feature/newUI/genimage2-source/zh/01-cn-home-wrapper-blank-source.png`
- 真实截图合成图：`docs/运营素材/feature/newUI/appstore-genimage2-composited/zh/01-cn-home-real-screenshot-gen2-wrapper.png`
- App Store 上传尺寸图：`docs/运营素材/feature/newUI/appstore-upload-genimage2-composited/zh/01-cn-home-real-screenshot-gen2-wrapper-1290x2796.png`

## 多页面版本

本次继续沿用同一张 Generation Image 2 空白包装源图，生成四张同风格页面图：

| 页面 | 真实截图来源 | 合成图 | App Store 上传尺寸图 |
| --- | --- | --- | --- |
| 实时数据 | `docs/运营素材/feature/newUI/real-screenshots/zh/real-02-stats.png` | `docs/运营素材/feature/newUI/appstore-genimage2-composited/zh/02-cn-stats-real-screenshot-gen2-wrapper.png` | `docs/运营素材/feature/newUI/appstore-upload-genimage2-composited/zh/02-cn-stats-real-screenshot-gen2-wrapper-1290x2796.png` |
| 四象限 | `docs/运营素材/feature/newUI/real-screenshots/zh/real-03-quadrant.png` | `docs/运营素材/feature/newUI/appstore-genimage2-composited/zh/03-cn-quadrant-real-screenshot-gen2-wrapper.png` | `docs/运营素材/feature/newUI/appstore-upload-genimage2-composited/zh/03-cn-quadrant-real-screenshot-gen2-wrapper-1290x2796.png` |
| 日程 | `docs/运营素材/feature/newUI/real-screenshots/zh/real-04-calendar.png` | `docs/运营素材/feature/newUI/appstore-genimage2-composited/zh/04-cn-calendar-real-screenshot-gen2-wrapper.png` | `docs/运营素材/feature/newUI/appstore-upload-genimage2-composited/zh/04-cn-calendar-real-screenshot-gen2-wrapper-1290x2796.png` |
| 番茄钟 / 计数器 | `docs/UI测试/feature-newUI/screenshots/tomato-list-mobile-after-readable.png` | `docs/运营素材/feature/newUI/appstore-genimage2-composited/zh/05-cn-tomato-counter-real-screenshot-gen2-wrapper.png` | `docs/运营素材/feature/newUI/appstore-upload-genimage2-composited/zh/05-cn-tomato-counter-real-screenshot-gen2-wrapper-1290x2796.png` |

总览预览图：`docs/运营素材/feature/newUI/previews/zh/appstore-genimage2-multi-page-preview.png`

## 执行边界

- Generation Image 2 只生成外层运营包装：标题、卖点标签、设备框、背景装饰和推广氛围。
- App 内部 UI 不由 Generation Image 2 生成，来自登录后的 iOS 模拟器真实截图。
- 本地 Pillow 仅做后处理：把真实截图嵌入 GenImage2 的空白手机屏幕，并输出 App Store 所需的 `1290 x 2796` 版本。

## 当前截图状态

这张图已经满足“真实登录截图 + Generation Image 2 外层包装”的流程要求，适合先给用户确认视觉方向。

截图里仍保留测试环境痕迹，例如左上角 `SkillDock` 返回提示和测试任务文案。正式提交 App Store 前，建议重新采集一组干净演示数据截图，再复用同一套 GenImage2 包装方式合成。

多页面版本中的实时数据、四象限、日程截图来自已有真实产品截图，采集时间早于本次登录截图；它们适合先确认页面视觉与推广图版式。正式上架前建议统一重新采集同一账号、同一时间段、干净演示数据的截图。
