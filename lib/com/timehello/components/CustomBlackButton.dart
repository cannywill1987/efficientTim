import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';

class CustomBlackButton extends StatelessWidget {
  String text;
  double fontSize;
  Color? color;
  CustomBlackButton({required this.text, this.fontSize = 14, this.color}) {
    if (this.color == null) {
      this.color = ColorsConfig.chartTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Color color = this.color ?? ColorsConfig.chartTextColor;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        this.text,
        style: TextStyle(
            color: this.color, fontSize: this.fontSize),
      ),
    );
  }
}
