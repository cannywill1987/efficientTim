创建日期：260525

# 设计说明：English App Store 概念截图

## 1. 设计背景

- 需求来源：用户要求创建英文应用市场概念截图，并允许截图数据使用假数据。
- 页面 / 功能名称：English App Store Concept Screenshots
- 设计类型：应用市场运营素材 / UI 概念参考
- 设计目标：给英文上架素材提供页面顺序、卖点表达、视觉包装和假数据样例。

## 2. 原页面截图

- 是否有原页面截图：否
- 原页面截图路径：无
- 说明：本轮用户明确允许创建英文概念图和假数据，因此没有把本套图片标记为真实截图。

## 3. 新设计图

- 设计图路径：`docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/`
- GenImage2 源图路径：`docs/运营素材/feature/newUI/genimage2-source/en-concept-260525/01-en-concept-wrapper-source.png`
- 生成方式：GenImage2 外层包装 + 本地脚本合成英文概念 UI
- 设计图生成状态：已生成
- 版本：v1
- 用途边界：AI 参考图 / 英文概念素材；不作为真实 after 截图或最终上架截图
- 设计资产校验：已通过尺寸与文件存在校验

## 4. 用户需求摘要

创建一套英文应用市场概念图，每个相关页面一张，可使用假数据。视觉上按 UI Designer Agent 处理，但必须明确最终英文 App Store 上架仍要用真实英文 App UI 重新截图。

## 5. 页面结构

| 页面 | 结构 |
|---|---|
| Today / Home | 进度卡片、快速创建、优先任务列表、底部导航 |
| AI Voice Capture | 录音状态、波形、转写文本、AI 解析任务、确认按钮 |
| Focus Timer | 专注倒计时、当前任务、今日指标、下一个任务 |
| Priority Matrix | 四象限任务卡片、优先级提示 |
| Calendar | 月历、当天日程列表、时间段信息 |
| Insights | 数据指标、柱状图、近期完成记录 |

## 6. 视觉规范

| 项目 | 说明 |
|---|---|
| 主色 | 绿色、珊瑚橙、蓝色、黄橙、紫色分页面区分 |
| 背景色 | 浅色 productivity 风格，保留大面积留白 |
| 字体层级 | 顶部标题大字号，手机内 UI 使用中小字号模拟真实移动端层级 |
| 圆角 | 手机外框与卡片统一大圆角，符合 iOS 视觉习惯 |
| 信息密度 | App Store 外层文案少，手机内页展示假数据和核心状态 |

## 7. 前端 / 后续真实截图验收清单

- [ ] 英文 App UI 已可稳定运行。
- [ ] 使用真实英文界面重新采集 Today、AI Voice、Focus、Matrix、Calendar、Insights 页面。
- [ ] 真实截图替换本轮脚本绘制的概念内页。
- [ ] 替换后重新生成 `1290 x 2796` 应用市场图。
- [ ] 上传前人工确认截图、文案、关键词、版本信息和隐私信息。

## 8. 待确认事项

- 是否最终保留 6 张页面顺序，或压缩为 App Store 常见 5 张组合。
- 英文正式 App 名是否使用 `Timerbell Todo`，还是继续沿用 `Efficient Time`。
- 最终上传目标是 Apple App Store、Google Play，还是其他应用市场。
