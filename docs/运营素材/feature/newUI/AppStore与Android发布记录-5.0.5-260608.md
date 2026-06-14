创建日期：260608

# App Store 与 Android 发布记录：5.0.5

## 发布版本

- 版本号：`5.0.5`
- 构建号：`243`
- iOS Bundle ID：`com.timespeed.timehello`
- Android Application ID：`com.timespeed.time_hello.efficienttime`
- 当前分支：`feature/newUI`

## 本次已完成

1. 已同步 Flutter 版本：
   - `pubspec.yaml`：`5.0.5+243`
   - `android/app/build.gradle.kts`：`versionName = "5.0.5"`、`versionCode = 243`
   - iOS / macOS Xcode 工程：`MARKETING_VERSION = 5.0.5`、`CURRENT_PROJECT_VERSION = 243`

2. 已修复 iOS App Store 归档阻塞：
   - `ios/Podfile` 增加 `.xcprivacy` 从 Compile Sources 移除的 `post_install` 修正。
   - 原因：Xcode 16 会把部分插件的 `PrivacyInfo.xcprivacy` 当作源文件处理，导致归档出现 `no rule to process file ... PrivacyInfo.xcprivacy` 或 `Internal Inconsistency`。

3. 已修复 Android AAB 构建阻塞：
   - `thirdPartyLib/record_android/android/build.gradle` 增加 `namespace 'com.llfbandit.record'`。
   - 原因：新版 Android Gradle Plugin 要求每个 Android module 显式声明 `namespace`。

4. iOS App Store IPA 已构建并上传成功：
   - IPA：`build/ios/ipa/TimerBell.ipa`
   - 上传日志：`build/ios/upload-5.0.5-243/upload.log`
   - Delivery UUID：`5c8716df-89fd-46c7-a9c4-b5a9b963bc06`
   - 上传结果：`UPLOAD SUCCEEDED with no errors`

5. Android AAB 已构建成功：
   - AAB：`build/app/outputs/bundle/release/app-release.aab`
   - 文件大小：约 `95.8MB`

## 验证记录

```bash
flutter pub get
flutter analyze
flutter analyze lib test
flutter build ios --release --no-codesign --no-tree-shake-icons --build-name 5.0.5 --build-number 243
flutter build ipa --release --no-tree-shake-icons --build-name 5.0.5 --build-number 243 --export-options-plist=ios/ExportOptions-AppStore.plist
xcrun altool --upload-app --type ios -f build/ios/ipa/TimerBell.ipa
flutter build appbundle --release --no-tree-shake-icons --build-name 5.0.5 --build-number 243
```

## 注意事项

- `flutter analyze` 当前未通过，原因是项目历史 analyzer warning/info 很多，并且全量分析会扫到 `thirdPartyPackages/test_core` 等本地 vendored 包。
- iOS 构建校验提示 Launch image 仍是默认占位图；本次不阻塞 IPA 上传，但后续建议替换。
- App Store Connect 上传成功不等于已正式上线；仍需等待 Apple 处理构建，然后在 App Store Connect 选择构建并提交审核或发布。
- Android AAB 只完成本地生产包构建，尚未上传 Google Play 或国内应用市场。
