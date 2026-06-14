import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class CircleWidget extends StatelessWidget {
  final OnTapListener? onTapListener;
  final VoidCallback? onLongPress;
  final Color color;

  CircleWidget({this.onTapListener, this.onLongPress, Color? color})
      : color = color ?? ThemeManager.getInstance().getDefautThemeColor();

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
      child: this.onTapListener == null && this.onLongPress == null
          ? getCircleChild()
          : InkWell(
              onTap: () {
                if (this.onTapListener != null) {
                  this.onTapListener!(null);
                }
              },
              onLongPress: this.onLongPress,
              child: getCircleChild(),
            ),
    );
  }

  Container getCircleChild() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: ThemeManager.getInstance()
              .getCardBackgroundColor(defaultColor: color),
          borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 14,
      ),
    );
  }
}
