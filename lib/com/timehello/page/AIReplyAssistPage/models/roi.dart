/// ROI（Region of Interest）矩形区域。
///
/// 说明：
/// 1. 全部使用 Flutter 逻辑坐标（logical pixel）。
/// 2. 坐标原点约定为屏幕左上角。
/// 3. 裁剪时由原生层按 `scale` 换算到物理像素。
class Roi {
  /// 左上角 X。
  final double x;

  /// 左上角 Y。
  final double y;

  /// 宽度。
  final double w;

  /// 高度。
  final double h;

  const Roi({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  /// 兜底空区域常量。
  static const Roi zero = Roi(x: 0, y: 0, w: 0, h: 0);

  /// 从 JSON 反序列化 ROI。
  factory Roi.fromJson(Map<String, dynamic> json) {
    return Roi(
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      w: (json['w'] as num?)?.toDouble() ?? 0,
      h: (json['h'] as num?)?.toDouble() ?? 0,
    );
  }

  /// 序列化 ROI。
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'w': w,
      'h': h,
    };
  }

  /// 基于当前 ROI 生成一个带局部修改的新实例。
  Roi copyWith({double? x, double? y, double? w, double? h}) {
    return Roi(
      x: x ?? this.x,
      y: y ?? this.y,
      w: w ?? this.w,
      h: h ?? this.h,
    );
  }

  /// 返回 ROI 中心点，供“聚焦输入框 + 粘贴”使用。
  Map<String, double> centerPoint() {
    return {
      'x': x + (w / 2),
      'y': y + (h / 2),
    };
  }
}
