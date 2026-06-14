/// 文件类型：工具类
/// 文件作用：统一输出 AI 语音链路的诊断日志。
/// 主要职责：按全局日志格式记录资源位配置、实时识别、录音转写和降级状态，避免泄露 API key。
import 'package:flutter/foundation.dart';

class AiVoiceDebugLog {
  AiVoiceDebugLog._();

  static const String _tag = 'AI_VOICE';

  static String _now() {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(now.month)}${two(now.day)} ${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
  }

  /// 功能：输出可 grep 的 AI 语音链路日志。
  /// 说明：只记录状态和长度等安全信息，禁止输出完整 token、API key、音频 URL 等敏感数据。
  static void log(
    String event,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint('[${_now()}][$_tag][$event] $message');
    if (error != null) {
      debugPrint('[${_now()}][$_tag][$event] error=$error');
    }
    if (stackTrace != null) {
      debugPrint('[${_now()}][$_tag][$event] stackTrace=$stackTrace');
    }
  }
}
