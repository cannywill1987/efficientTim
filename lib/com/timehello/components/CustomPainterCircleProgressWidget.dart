import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class CustomPainterCircleProgressWidget extends CustomPainter {
  late Color progressColor;
  late Color backgroundColor;
  double progress;
  double thickness;
  // late Size sizeT;
  CustomPainterCircleProgressWidget({this.thickness: 3,this.progress: 0.1, Color? progressColor, Color? backgroundColor}) {
    // this.sizeT = sizeT ?? Size(50, 50);
    this.progressColor = progressColor ?? Colors.white;
    this.backgroundColor = ThemeManager.getInstance().getSliderInactiveColor(defaultColor: backgroundColor ?? Color(0xa0e0e0e0));
  }

  @override
  void paint(Canvas canvas, Size size) {
    //背景圆环
    Utility.drawArc(canvas, centerX: size.width / 2, centerY: size.height / 2, radius: size.width / 2, startAngle:0, sweepAngle: 360, paint: new Paint()..color = this.backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = this.thickness
      ..isAntiAlias = true);
    // //进度条圆环
    // Utility.drawArc(canvas, centerX: size.width / 2, centerY: size.height / 2, radius: size.width / 2, startAngle:0, sweepAngle: progress * 360, paint: new Paint()..color = this.backgroundColor
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = 3
    //   ..isAntiAlias = true);
    Utility.drawArc(canvas, centerX: size.width / 2, centerY: size.height / 2, radius: size.width / 2, startAngle:-90, sweepAngle: progress * 360 , paint: new Paint()..color = this.progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness
      ..isAntiAlias = true);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
