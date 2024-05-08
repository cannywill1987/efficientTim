import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class ChartTitleWidget extends StatelessWidget {
  String title;
  String value;

  ChartTitleWidget({Key? key, required this.title, required this.value}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      key: ValueKey('12133'),
      mainAxisSize: MainAxisSize.min, children: [
      Text(title, key: ValueKey('121334'), style: TextStyle(decoration: TextDecoration.none, fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff999a9d))),),
      Text(value, key: ValueKey('121354'),style: TextStyle(decoration: TextDecoration.none, fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor, defaultDarkColor: Color(0xffc0c0c0))),)
    ],);
  }
  
}