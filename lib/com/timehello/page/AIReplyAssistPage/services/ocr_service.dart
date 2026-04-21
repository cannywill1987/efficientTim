import 'dart:typed_data';

import 'native_assist_bridge.dart';

/// OCR 服务（当前 MVP 使用纯文本返回）。
class OcrService {
  final NativeAssistBridge _bridge;

  OcrService({NativeAssistBridge? bridge})
      : _bridge = bridge ?? NativeAssistBridge();

  /// 识别图片文字。
  ///
  /// - `lang` 默认 `zh-Hans`
  /// - 返回值为按行拼接后的文本
  Future<String> recognizeText(Uint8List png, {String lang = 'zh-Hans'}) async {
    final Map<String, dynamic> res = await _bridge.visionOcr(
      pngBase64: _bridge.encodePng(png),
      lang: lang,
      returnType: 'text',
    );
    return res['text']?.toString() ?? '';
  }
}
