import 'dart:math';

import 'package:flutter/material.dart';

/// 专注详情页的大圆点进度环。
///
/// 这个组件只用于大尺寸计时场景，避免影响列表、悬浮计时器等位置已有的小圆弧进度。
class DottedCircularProgressWidget extends StatelessWidget {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final int dotCount;
  final double dotRadius;
  final double activeDotRadius;

  const DottedCircularProgressWidget({
    Key? key,
    required this.progress,
    this.activeColor = const Color(0xffffa726),
    this.inactiveColor = const Color(0x88ffffff),
    this.dotCount = 108,
    this.dotRadius = 3.0,
    this.activeDotRadius = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedCircularProgressPainter(
        progress: progress.clamp(0.0, 1.0),
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        dotCount: dotCount,
        dotRadius: dotRadius,
        activeDotRadius: activeDotRadius,
      ),
    );
  }
}

class _DottedCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final int dotCount;
  final double dotRadius;
  final double activeDotRadius;

  _DottedCircularProgressPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.dotCount,
    required this.dotRadius,
    required this.activeDotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        min(size.width, size.height) / 2 - max(activeDotRadius + 8, 14);
    if (radius <= 0 || dotCount <= 0) return;

    final activeCount = (progress * dotCount).round().clamp(0, dotCount);
    final activeIndex = activeCount == 0 ? -1 : activeCount - 1;

    for (int index = 0; index < dotCount; index++) {
      final angle = -pi / 2 + (pi * 2 * index / dotCount);
      final offset = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      final isActive = index < activeCount;
      final isHandle = index == activeIndex && progress > 0;

      // 当前进度点带一点微光，接近参考图里的橙色游标。
      if (isHandle) {
        canvas.drawCircle(
          offset,
          activeDotRadius + 8,
          Paint()
            ..color = activeColor.withValues(alpha: 0.18)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      canvas.drawCircle(
        offset,
        isHandle ? activeDotRadius : dotRadius,
        Paint()
          ..color = isActive ? activeColor : inactiveColor
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DottedCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.activeDotRadius != activeDotRadius;
  }
}
