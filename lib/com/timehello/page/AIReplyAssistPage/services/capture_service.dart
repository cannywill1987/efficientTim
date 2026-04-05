import 'dart:typed_data';

import '../models/capture_result.dart';
import '../models/roi.dart';
import 'native_assist_bridge.dart';

/// 截图与裁剪服务。
///
/// 说明：
/// - `captureScreenPng` 返回完整截图和坐标系元数据。
/// - `cropPng` 按逻辑 ROI 裁剪聊天区域。
class CaptureService {
  final NativeAssistBridge _bridge;

  CaptureService({NativeAssistBridge? bridge})
      : _bridge = bridge ?? NativeAssistBridge();

  /// 获取全屏截图。
  ///
  /// 返回值包含：
  /// 1. PNG 字节
  /// 2. scale
  /// 3. 物理/逻辑尺寸
  Future<CaptureResult> captureScreenPng() async {
    final Map<String, dynamic> res = await _bridge.captureScreen(displayId: 0);
    final String? base64 = res['pngBase64']?.toString();
    if (base64 == null || base64.isEmpty) {
      throw Exception('captureScreen returned empty pngBase64');
    }

    final double scale = (res['scale'] as num?)?.toDouble() ?? 1.0;
    final int widthPx = (res['width'] as num?)?.toInt() ?? 0;
    final int heightPx = (res['height'] as num?)?.toInt() ?? 0;
    // 如果原生没返回逻辑尺寸，这里按像素/scale兜底计算。
    final double widthLogical =
        (res['widthLogical'] as num?)?.toDouble() ?? (widthPx / scale);
    final double heightLogical =
        (res['heightLogical'] as num?)?.toDouble() ?? (heightPx / scale);

    return CaptureResult(
      png: _bridge.decodePng(base64),
      scale: scale,
      widthPx: widthPx,
      heightPx: heightPx,
      widthLogical: widthLogical,
      heightLogical: heightLogical,
    );
  }

  /// 按逻辑坐标 ROI 裁剪 PNG。
  ///
  /// 注意：真正的坐标转换在 Swift 层完成，这里只透传参数。
  Future<Uint8List> cropPng({
    required Uint8List png,
    required Roi roi,
    required double scale,
  }) async {
    final Map<String, dynamic> res = await _bridge.cropPng(
      pngBase64: _bridge.encodePng(png),
      roi: roi.toJson(),
      coordSpace: 'logical',
      scale: scale,
    );

    final String? base64 = res['pngBase64']?.toString();
    if (base64 == null || base64.isEmpty) {
      throw Exception('cropPng returned empty pngBase64');
    }

    return _bridge.decodePng(base64);
  }
}
