import 'dart:typed_data';

/// 原生截图结果。
///
/// 同时保留物理像素和逻辑尺寸，避免 ROI 校准时坐标系混乱。
class CaptureResult {
  /// PNG 字节数据。
  final Uint8List png;

  /// 屏幕缩放比（例如 Retina 通常为 2.0）。
  final double scale;

  /// 物理像素宽度。
  final int widthPx;

  /// 物理像素高度。
  final int heightPx;

  /// 逻辑宽度（= widthPx / scale）。
  final double widthLogical;

  /// 逻辑高度（= heightPx / scale）。
  final double heightLogical;

  const CaptureResult({
    required this.png,
    required this.scale,
    required this.widthPx,
    required this.heightPx,
    required this.widthLogical,
    required this.heightLogical,
  });
}
