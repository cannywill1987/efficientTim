创建日期：260523

# App Store 真实截图推广图说明

## 输出目录

- 中文推广图：`docs/运营素材/feature/newUI/appstore-real/zh/`
- 英文推广图：`docs/运营素材/feature/newUI/appstore-real/en/`
- 打包文件：`docs/运营素材/feature/newUI/appstore-real-images-260523.zip`
- 生成脚本：`docs/运营素材/feature/newUI/scripts/generate_real_appstore_images.py`

## 生成原则

- App 手机画面使用 iPhone 16 模拟器真实截图，不使用 AI 生成假的 App 界面。
- 外层背景、手机壳、标题和卖点文案属于 App Store 运营包装。
- 尺寸统一为 `1284 x 2778`，对应 App Store 6.5 英寸截图规格。
- 中英文各 5 张，英文文案按单词换行，避免断词。

## 本次使用的真实截图

- `real-screenshots/zh/real-06-create-task.png`：移动端创建任务页
- `real-screenshots/zh/real-03-quadrant.png`：四象限页面
- `real-screenshots/zh/real-04-calendar.png`：日程页面
- `real-screenshots/zh/real-02-stats.png`：实时数据页面

## 注意事项

- 首页和我的页的 debug 模式截图存在 Flutter overflow 红字，本次已从推广图和 zip 包中排除。
- 如果要最终提交 App Store，建议后续用 release/TestFlight 包重新截首页、我的页，再补充更完整的页面覆盖。
