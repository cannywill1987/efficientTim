import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/ENUMS.dart';

class InnerContainerWidget extends StatelessWidget {
  Widget child;
  double paddingTop;
  double paddingBottom;
  ColorShadowEnum colorShadowEnum;
  String? title;
  double margin = 5;

  InnerContainerWidget(
      {required this.child,
      this.title,
      this.paddingBottom: 5,
      this.paddingTop: 5,
      this.colorShadowEnum = ColorShadowEnum.red});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding:
            EdgeInsets.only(top: this.paddingTop, bottom: this.paddingBottom),
        constraints: BoxConstraints(minHeight: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(
              defaultColor: ColorsConfig.chartBgColor),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 2, color: ColorsConfig.borderLineColor)),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
            color: ThemeManager.getInstance().getCardBackgroundColor(
                defaultColor: ColorsConfig.chartBgColor),
            margin: EdgeInsets.all(0),
            shadowColor: getShadowColor(),
            elevation: 4,
            child: Padding(
                padding: EdgeInsets.all(4),
                child: this.title == null
                    ? child
                    : InnerContainerTitleSubtitleWidget(
                        title: title ?? "", child: child))));
  }

  Color getShadowColor() {
    switch (colorShadowEnum) {
      case ColorShadowEnum.red:
        return Color(0xffff0000);
      case ColorShadowEnum.blue:
        return Colors.lightBlue;
      default:
        return Color(0xffff8800);
    }
  }
}

class InnerContainerTitleSubtitleWidget extends StatelessWidget {
  double margin = 5;
  Widget? child; //child有更高优先级 value不会起做作用, value有值 child需要为null
  String title;
  String? value;

  InnerContainerTitleSubtitleWidget(
      {this.child, required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    // List<Widget> list = [
    //   SizedBox(
    //     height: 4,
    //   ),
    //   Text(
    //     "100%",
    //     style: TextStyle(
    //         color: ColorsConfig.chartTextColor,
    //         fontSize: 16,
    //         fontWeight: FontWeight.w900),
    //   )
    // ];
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InnerContainerTitleWidget(title: title),
        SizedBox(
          height: margin,
        ),
        child ??
            Wrap(
              children: [
                SizedBox(
                  height: 4,
                ),
                Text(
                  value ?? "",
                  style: TextStyle(
                      color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                )
              ],
            )
        // child ?? ,
      ],
    );
  }
}

class InnerContainerTitleWidget extends StatelessWidget {
  String title;

  InnerContainerTitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      this.title,
      style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff3f3f3f)), fontSize: 12),
    );
  }
}
