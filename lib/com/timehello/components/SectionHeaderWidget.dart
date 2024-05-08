import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';

/**
 * 设置页面的sectionHeader
 */
class SectionHeaderWidget extends StatefulWidget {
  String title;

  SectionHeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SectionHeaderWidgetState();
  }
}

class SectionHeaderWidgetState extends State<SectionHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Icon(this.widget.checkIcon, size: this.widget.width,)

    return Container(
        height: 30,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: ColorsConfig.backgroundColor),
        alignment: Alignment(-1, 0),
        child: Text(
          this.widget.title,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 13,
              color: Color(0xffa3a3a3),
              shadows: ThemeManager.getInstance().isDark() ? null : [Shadow(color: Colors.white, offset: Offset(1, 1))]),
        ));
    // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }
}
