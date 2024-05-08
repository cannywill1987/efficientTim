import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class CustomTitileWidget extends StatelessWidget {
  double size = 15;
  String text;
  double borderRadius = 5;
  Color? color = ColorsConfig.chartTextColor;

  CustomTitileWidget(
      {this.size = 14, this.borderRadius: 0, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Container(
          width: 5,
          decoration:
              BoxDecoration(color: color ?? Colors.red,borderRadius: BorderRadius.circular(borderRadius)),
          height: size,

        ),
        SizedBox(
          width: 8,
        ),
        Text(
          this.text,
          style: TextStyle(
              color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
              fontSize: this.size,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
