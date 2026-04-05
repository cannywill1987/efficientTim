import 'dart:convert';
import 'dart:typed_data';

import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';

/// AI 回复助手原生桥接层。
///
/// 责任边界：
/// 1. 统一封装 MethodChannel 调用。
/// 2. 统一处理 PNG 的 base64 编解码。
/// 3. 不做业务编排（编排在 State 层）。
class NativeAssistBridge {
  final CounterMethodChannelManager _channelManager =
      CounterMethodChannelManager.getInstance();

  /// 将原生返回的 base64 PNG 解码为字节数组。
  Uint8List decodePng(String pngBase64) {
    return base64Decode(pngBase64);
  }

  /// 将字节数组编码为 base64 PNG 字符串。
  String encodePng(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// 调用原生全屏截图。
  Future<Map<String, dynamic>> captureScreen({int displayId = 0}) {
    return _channelManager.assistCaptureScreen(displayId: displayId);
  }

  /// 调用原生裁剪（逻辑坐标 + scale）。
  Future<Map<String, dynamic>> cropPng({
    required String pngBase64,
    required Map<String, dynamic> roi,
    required double scale,
    String coordSpace = 'logical',
  }) {
    return _channelManager.assistCropPng(
      pngBase64: pngBase64,
      roi: roi,
      coordSpace: coordSpace,
      scale: scale,
    );
  }

  /// 调用 Vision OCR。
  Future<Map<String, dynamic>> visionOcr({
    required String pngBase64,
    required String lang,
    String returnType = 'text',
  }) {
    return _channelManager.assistVisionOcr(
      pngBase64: pngBase64,
      lang: lang,
      returnType: returnType,
    );
  }

  /// 调用“聚焦 + 粘贴”（不发送）。
  Future<Map<String, dynamic>> focusAndPaste({
    required double x,
    required double y,
    required String text,
    String coordSpace = 'logical',
  }) {
    return _channelManager.assistFocusAndPaste(
      x: x,
      y: y,
      text: text,
      coordSpace: coordSpace,
    );
  }

  /// 查询所需权限状态。
  Future<Map<String, dynamic>> checkPermissions() {
    return _channelManager.assistCheckPermissions();
  }

  /// 打开系统设置对应权限页。
  Future<Map<String, dynamic>> openSystemSettings({required String page}) {
    return _channelManager.assistOpenSystemSettings(page: page);
  }
}
