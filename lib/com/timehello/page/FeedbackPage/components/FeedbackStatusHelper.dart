/**
 * 文件类型：Flutter 反馈状态工具
 * 文件作用：集中维护 CommentModel.status 的文案和颜色。
 * 主要职责：避免反馈页面和卡片里散落状态魔法数字。
 */
import 'package:flutter/material.dart';

class FeedbackStatusHelper {
  static const int unhandled = 0;
  static const int processing = 1;
  static const int developing = 2;
  static const int resolved = 3;
  static const int rejected = 4;

  static String getTitle(int? status) {
    switch (status) {
      case processing:
        return "处理中";
      case developing:
        return "开发中";
      case resolved:
        return "已解决";
      case rejected:
        return "不予处理";
      case unhandled:
      default:
        return "未处理";
    }
  }

  static Color getTextColor(int? status) {
    switch (status) {
      case processing:
      case developing:
        return const Color(0xff2878ff);
      case resolved:
        return const Color(0xff16a34a);
      case rejected:
        return const Color(0xff7a8194);
      case unhandled:
      default:
        return const Color(0xffff6a00);
    }
  }

  static Color getBackgroundColor(int? status) {
    switch (status) {
      case processing:
      case developing:
        return const Color(0xffeaf2ff);
      case resolved:
        return const Color(0xffeaf8ef);
      case rejected:
        return const Color(0xfff1f3f7);
      case unhandled:
      default:
        return const Color(0xfffff0df);
    }
  }
}
