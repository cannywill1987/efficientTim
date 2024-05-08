import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../page/CreateAIChatGptMissionPage/CreateAIChatGptMissionPage.dart';
import '../util/LoginManager.dart';
import '../util/Utility.dart';

class CircleWidget extends StatelessWidget {
  OnTapListener? onTapListener;
  late Color color;

  CircleWidget({this.onTapListener, Color? color}) {
    if(color == null) {
      this.color = ThemeManager.getInstance().getDefautThemeColor();
    } else {
      this.color = color;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (this.onTapListener != null) {
    //   return GestureDetector(
    //     onTap: () {
    //       if (this.onTapListener != null) {
    //         this.onTapListener!(null);
    //       }
    //     },
    //     child: getWidget(),
    //   );
    // } else {
    return getWidget(context);
    // }
  }

  Card getWidget(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: this.onTapListener == null ? getCircleChild(): InkWell(
        onTap: () {
          if (this.onTapListener != null) {
            this.onTapListener!(null);
          }
        },
        child: getCircleChild(),
      ),
    );
  }

  Container getCircleChild() {
    return Container(
        width: 40,
        height: 40,
        decoration:
        BoxDecoration(
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: color), borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.center,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 14,
        ),
      );
  }
}
