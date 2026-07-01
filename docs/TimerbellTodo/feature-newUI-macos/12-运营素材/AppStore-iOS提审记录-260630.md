# Timerbell Todo iOS App Store 提审记录

## 基本信息

- App Name: Timerbell todo-Podomoro
- App ID: 1663610373
- Bundle ID: com.timespeed.timehello
- Platform: iOS
- Version: 5.0.8
- Build: 253
- IPA: build/ios/ipa/TimerBell.ipa

## 执行记录

- 本地版本号已更新到 5.0.8 (253)
- `flutter build ipa --release --no-tree-shake-icons --export-options-plist=ios/ExportOptions-AppStore.plist` 构建成功
- altool validate 通过，结果为 `VERIFY SUCCEEDED`
- altool upload 成功，Delivery UUID: 81c0eb92-bdd5-49d3-a320-65534f783297
- Apple build 处理完成后状态为 `VALID`
- App Store Connect 已创建 iOS 5.0.8 版本页
- 已选择 build 253
- 已补齐 11 个 localization 的 `whats_new`
- Review Submission ID: 5645b9c6-e00c-4bf8-a3fe-26bde83d2f7b
- Submitted Date: 2026-06-30T08:50:14.171Z
- 当前状态: WAITING_FOR_REVIEW

## 注意

这表示已提交 Apple 审核，不代表已经审核通过或正式上架。
