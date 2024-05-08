import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class DashLineWidget extends StatelessWidget {
   Color? color;

  final double strokeWidth;

  final double gap;

  final Map paintrect;

  DashLineWidget({
    Color? color,
    this.strokeWidth = 1.0,
    /*边框的宽度*/

    this.gap = 2,
    /*虚边框的间隙*/

    this.paintrect = const {
      "left": true,
      "top": true,
      "right": true,
      "bottom": true
    },
    /*左右上下，代表是否要描绘边框*/
  }) {
    this.color = ThemeManager.getInstance().getColor(defaultColor: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 1),
      painter: DashLineWidgetPainter(
          color: this.color ?? Colors.black, strokeWidth: this.strokeWidth, gap: this.gap),
    );
  }
}

class DashLineWidgetPainter extends CustomPainter {
  double strokeWidth;

  Color color;

  double gap;

  DashLineWidgetPainter(
      {this.strokeWidth = 5.0, this.color = Colors.red, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;

    double y = size.height;

    Path _topPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);

    // if(this.paintrect["top"]){
    //
    //
    //
    // }
    //
    // if(this.paintrect['right']){
    //
    //   Path _rightPath = getDashedPath(
    //
    //     a: math.Point(x, 0),
    //
    //     b: math.Point(x, y),
    //
    //     gap: gap,
    //
    //   );
    //
    //   canvas.drawPath(_rightPath, dashedPaint);
    //
    // }
    //
    // if(this.paintrect['bottom']){
    //
    //   Path _bottomPath = getDashedPath(
    //
    //     a: math.Point(0, y),
    //
    //     b: math.Point(x, y),
    //
    //     gap: gap,
    //
    //   );
    //
    //   canvas.drawPath(_bottomPath, dashedPaint);
    //
    // }
    //
    // if(this.paintrect['left']){
    //
    //   Path _leftPath= getDashedPath(
    //
    //     a: math.Point(0, 0),
    //
    //     b: math.Point(0.001, y),
    //
    //     gap: gap,
    //
    //   );
    //
    //   canvas.drawPath(_leftPath, dashedPaint);

    // }
  }

  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);

    Path path = Path();

    path.moveTo(a.x, a.y);

    bool shouldDraw = true;

    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x.toDouble(), currentPoint.y.toDouble())
          : path.moveTo(currentPoint.x.toDouble(), currentPoint.y.toDouble());

      shouldDraw = !shouldDraw;

      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
