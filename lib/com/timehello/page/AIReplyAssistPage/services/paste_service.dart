import '../models/roi.dart';
import 'native_assist_bridge.dart';

/// 粘贴服务。
///
/// 行为边界：
/// 1. 聚焦输入框
/// 2. 粘贴文本
/// 3. 不自动发送（不会触发 Enter）
class PasteService {
  final NativeAssistBridge _bridge;

  PasteService({NativeAssistBridge? bridge})
      : _bridge = bridge ?? NativeAssistBridge();

  /// 计算输入 ROI 中心点并执行原生“聚焦 + 粘贴”。
  Future<void> focusAndPaste({
    required Roi inputRoi,
    required String text,
  }) async {
    final Map<String, double> point = inputRoi.centerPoint();
    final Map<String, dynamic> res = await _bridge.focusAndPaste(
      x: point['x'] ?? 0,
      y: point['y'] ?? 0,
      text: text,
      coordSpace: 'logical',
    );

    final bool ok = res['ok'] == true;
    if (!ok) {
      throw Exception('focusAndPaste failed');
    }
  }
}
