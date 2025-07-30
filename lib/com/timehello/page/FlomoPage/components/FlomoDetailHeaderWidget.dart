import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../components/IconWidget.dart';
import '../../../config/ColorsConfig.dart';

class FlomoDetailHeaderWidget extends StatelessWidget {
  FlomoMissionModel flomoMissionModel;
  bool isDialog = false;
  FlomoDetailHeaderWidget({required this.flomoMissionModel, this.isDialog = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> childrenRow = <Widget>[
      Container(
          width: isDialog ? 24 : 36,
          height: isDialog ? 24 : 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(

              color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white), borderRadius: BorderRadius.circular(40)),
          child: IconWidget(
            icon: flomoMissionModel.icon ?? 0,
            iconSize: isDialog ? 24 : 36,
            color: flomoMissionModel.color,
          )),
      Text(TextUtil.isEmpty(flomoMissionModel.title) ? "123" : flomoMissionModel.title ?? "",
          textAlign: TextAlign.left,
          maxLines: 1,
          style: TextStyle(
              decoration: null,
              decorationStyle: TextDecorationStyle.solid,
              // decorationColor: Utility.getTextColorByPriority(this.widget.priorityEnum),
              decorationThickness: 3,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)))),
    ];
    // throw UnimplementedError();
    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: isDialog == true? MainAxisAlignment.center : MainAxisAlignment.start, children: childrenRow);
  }
}
