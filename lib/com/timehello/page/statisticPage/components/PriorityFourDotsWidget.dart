import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class PriorityFourDotsWidget extends StatelessWidget {
  String priorityRed1;
  String priorityYellow2;
  String priorityBlue3;
  String priorityGreen4;

  PriorityFourDotsWidget(
      {required this.priorityRed1,
      required this.priorityYellow2,
      required this.priorityBlue3,
      required this.priorityGreen4});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(padding: EdgeInsets.symmetric(horizontal: 10), child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: PriorityFourDotsWidgetItem(title: getI18NKey().four_quadrant_priority1 + priorityRed1, color: Utility.getTextColorByPriority(PriorityEnum.values[0]),)),
            Expanded(child: PriorityFourDotsWidgetItem(title: getI18NKey().four_quadrant_priority2 + priorityYellow2, color: Utility.getTextColorByPriority(PriorityEnum.values[1]),))
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: PriorityFourDotsWidgetItem(title: getI18NKey().four_quadrant_priority3 + priorityBlue3, color: Utility.getTextColorByPriority(PriorityEnum.values[2]),)),
            Expanded(child: PriorityFourDotsWidgetItem(title: getI18NKey().four_quadrant_priority4 + priorityGreen4, color: Utility.getTextColorByPriority(PriorityEnum.values[3]),))
          ],
        ),
      ],
    ),);
  }
}

class PriorityFourDotsWidgetItem extends StatelessWidget {
  String title;
  Color color;

  PriorityFourDotsWidgetItem({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(20)),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyle(color: ColorsConfig.chartTextColor, fontSize: 11, decoration: TextDecoration.none),
        )
      ],
    );
  }
}
