/**
 * 文件类型：Flutter 反馈页兼容入口
 * 文件作用：保留旧 `FeedbackPage()` 路由名，并统一跳转到新的 MyFeedbackPage。
 * 主要职责：避免旧反馈页和新反馈页并行维护导致 appScene、提交状态和 UI 表现不一致。
 */
import 'package:flutter/material.dart';

import 'MyFeedbackPage.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  /**
   * 功能：把历史反馈入口统一转发到新版反馈页。
   * 说明：外部仍可继续调用 FeedbackPage()，但实际只维护 MyFeedbackPage 一套 UI 和数据链路。
   */
  @override
  Widget build(BuildContext context) {
    return const MyFeedbackPage();
  }
}
