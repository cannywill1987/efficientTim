import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class ProgressBarWidget extends StatelessWidget {
  Color? color;
  double percent = 0.5;
  double height;
  ProgressBarWidget({Color? color, this.height = 6, required this.percent}) {
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (percent > 1) {
      percent = 1;
    }
    return CustomPaint(
        size: Size(double.infinity, height),
        painter: DashPainter(percent: percent, color: color ?? Color(0xffff8800)));
  }
}

class DashPainter extends CustomPainter {
  Color? color;
  double percent = 0.5;
  Color shadowColor = ThemeManager.getInstance().isDark() ? Color(0xffc0c0c0) : Color(0xff28292f);

  DashPainter({Color? color, required double percent}) {
    this.color = color;
    this.percent = percent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, size.width, size.height), Radius.circular(10)),
        new Paint()
          ..color = shadowColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1
          ..isAntiAlias = true);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(0, 0, size.width * this.percent, size.height), Radius.circular(10)),
        new Paint()
          ..color = color ?? Color(0xffff8800)
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
