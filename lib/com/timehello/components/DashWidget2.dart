import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashWidget2 extends StatelessWidget {
  Color? color;

  DashWidget2({Color? color}) {
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPaint(
        size: Size(300, 1),
        painter: DashPainter(color: color ?? Color(0xff28292f)));
  }
}

class DashPainter extends CustomPainter {
  Color? color;
  double strokeWidth = 1;

  DashPainter({Color? color}) {
    this.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = this.color ?? Color(0xff28292f)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    ;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(Rect.fromLTRB(0, 0, size.height, size.width), Radius.circular(10)),
    //     new Paint()..color = this.color ?? Color(0xff28292f));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
