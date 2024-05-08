import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/DimensConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class InnerTitleWidget extends StatelessWidget {
  String title;
  Widget? child;

  InnerTitleWidget({Key? key, required this.title, this.child}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(right: DimensConfig.chartItemPadding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 15,
                  color: ThemeManager.getInstance().getColor(defaultColor: ColorsConfig.chartTextColor),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      decoration: TextDecoration.none,
                      color: ThemeManager.getInstance().getColor(defaultColor: ColorsConfig.chartTextColor)),
                )
              ],
            ),
            this.child == null ? SizedBox.shrink() : this.child!
          ],
        ));
  }
}
