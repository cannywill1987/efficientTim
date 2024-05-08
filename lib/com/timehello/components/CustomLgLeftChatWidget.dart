import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class CustomLgLeftChatPainter extends CustomPainter {
  double percent;
  Size? sizeT;
  double width = 0;
  double? height = 0;
  String? title = "";
  int duration = 100000;
  int loadingDuration = 1000;
  int endingDuration = 2000;
  int curTime = 0;

  // int progressWidth = 0;
  double radius = 30;
  int heightExtra = 200;
  int interval = 20;
  int count = 0;

  CustomLgLeftChatPainter({this.percent: 0.0, sizeT}) {
    this.sizeT = sizeT ?? Size(300, 45);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    double radius = this.radius;
    double width = this.sizeT!.width;
    double height = this.sizeT!.height;
    
    Path path = Path();
    //1.左边的往下45度圆弧
    Utility.drawPathArc(path, centerX: -radius / 1.4, centerY: radius, radius: radius, startAngle: -45, sweepAngle: 45);
    //2.左下角直线
    path.lineTo(radius - radius / 1.4, height-radius);
    // //3.左下角90度圆弧
    Utility.drawPathArc(path, centerX: radius  -radius / 1.4 + radius, centerY: radius, radius: radius, startAngle: 180, sweepAngle: -90);
    // //4.下面直线
    path.lineTo(width - radius, height);
    // //5.右下角圆弧
    Utility.drawPathArc(path, centerX: width-radius, centerY: height-radius, radius:  radius, startAngle: 90, sweepAngle: -180);
    //6.右边直线
    path.lineTo(width, radius);
    //7.右上角圆弧
    Utility.drawPathArc(path, centerX: width-radius, centerY: height-radius, radius:  radius, startAngle: 90, sweepAngle: -180);
    // //8.上角直线
    path.lineTo(radius - radius / 1.4 + radius, 0);
    // //9.左上角
    Utility.drawPathArc(path, centerX: radius - radius / 1.4 + radius, centerY: radius, radius:  radius, startAngle: -90, sweepAngle: -45);
    //
    path.lineTo(-radius / 1.4, radius / 5);
    path.close();

    var colors = [
      Color(0xff3499DD),
      Color(0xff2fe2c2),
      Color(0xff3499DD),
      Color(0xff3499DD),
    ];

    //绘制渐变色初始x点
    // var x = (width - 2 * radius) * percent + radius - radius / 1.4;
  double x = 20;
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    canvas.clipPath(path);
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), Paint()
      ..isAntiAlias = true
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..color = Colors.red);
    Rect rect = Rect.fromLTRB(x, 0, x+20, 2 * radius);
    paint.shader = LinearGradient(
      colors: colors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    //
    // Paint paint = Paint();
    // paint.ca
    // canvas.



    // //背景圆环
    // Utility.drawArc(canvas, centerX: sizeT!.width / 2, centerY: sizeT!.height / 2, radius: 20, startAngle:0, sweepAngle: 360, paint: new Paint()..color = this.backgroundColor
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = 3
    //   ..isAntiAlias = true);
    // //进度条圆环
    // Utility.drawArc(canvas, centerX: sizeT!.width / 2, centerY: sizeT!.height / 2, radius: 20, startAngle:-90, sweepAngle: progress * 360 , paint: new Paint()..color = this.progressColor
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = 3
    //   ..isAntiAlias = true);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
