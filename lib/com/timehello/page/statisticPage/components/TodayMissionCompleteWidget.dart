import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/DimensConfig.dart';

class TodayMissionCompleteWidget extends StatelessWidget {
  String numMissionToFinished = "2";
  String numMissionFinished = "1";
  String percentCompareWithTomorrow = "5%";

  TodayMissionCompleteWidget(
      {required this.numMissionToFinished,
      required this.numMissionFinished,
      required this.percentCompareWithTomorrow});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            new Text.rich(
              //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
              new TextSpan(
                  text: numMissionFinished,
                  //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                  style: TextStyle(
                      color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor), fontSize: 24, fontWeight: FontWeight.w700),
                  //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                  //子 TextSpan，可以指定多个
                  children: <TextSpan>[
                    new TextSpan(
                        text: "/",
                        style: TextStyle(
                            color: ColorsConfig.colorTextField,
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                    new TextSpan(
                        text: numMissionToFinished,
                        style: TextStyle(
                            color: ColorsConfig.colorTextField,
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                  ]),
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
        SizedBox(
          width: 8,
        ),
        //和昨天比较组件
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   getI18NKey().compare_to_tomorrow,
            //   style:
            //       TextStyle(color: ColorsConfig.chartTextColor, fontSize: 12),
            // ),
            // SizedBox(
            //   height: DimensConfig.chartItemMargin,
            // ),
            // Text(
            //   percentCompareWithTomorrow,
            //   style:
            //       TextStyle(color: ColorsConfig.chartTextColor, fontSize: 12),
            // ),
          ],
        )
      ],
    );
  }
}
