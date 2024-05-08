import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../util/ScreenUtil.dart';

part 'GameAnswerJsonBean.g.dart';

@JsonSerializable(nullable: false)
class GameAnswerJsonBean {
  String mode; // "circle" 圆形 用 radius "rectangle" 长方形widthGuide和heightGuide
  double width;
  double height;
  double offsetX;
  double offsetY;
  double radius;
  double widthGuide; //正方形位置
  double heightGuide; //长方形位置

  // double? widthFactor;
  // double? heightFactor;
  // double? radiusFactor;
  // double? offsetXfactor;
  // double? offsetYfactor;

  double? widthWidgetHere; //长方形图片
  double? heightWidgetHere;
  double? widthGuideHere; //指引宽度
  double? heightGuideHere; //指引高度

  double? offsetXHere;
  double? offsetYHere;
  double? radiusHere;

  bool? isChecked = false; //是否勾选

  static parseData(
      {required GameAnswerJsonBean bean,
      required double screenHeight,
      required double screenWidth}) {
    // bean.isChecked = false;

    if (bean.mode == "circle") {
      double screenHeightFinal = 0;
      if (Utility.isMobile() == true) {
        screenHeightFinal = screenHeight < screenWidth ? screenHeight : screenWidth; //横屏时的屏幕高度
      } else {
        screenHeightFinal = screenWidth / screenHeight < 3 ? (screenWidth - 200) : screenHeight;
      }
      if (bean == null) return;
      bean.heightWidgetHere = screenHeightFinal * 3 / 10;
      bean.widthWidgetHere = bean.heightWidgetHere! *
          bean.width /
          bean.height; //c端组件宽=c端组件高 * b端组件宽 / b端组件高
      bean.radiusHere = bean.radius *
          bean.heightWidgetHere! /
          bean.height /
          2; // c端组件半径 = admin的半径 * c端组件的高 / admin图片的高 / 2-不知道为啥要除以2
      bean.offsetXHere = (bean.offsetX) *
          bean.widthWidgetHere! /
          bean.width; // c端x位置 = admin端左上角x位置 * c端组件宽度 / admin端宽度 -
      bean.offsetYHere = (bean.offsetY) * bean.heightWidgetHere! / bean.height;
    } else {
      //长方形
      double screenHeightFinal = 0;
      if (Utility.isMobile() == true) {
        screenHeightFinal = screenHeight < screenWidth ? screenHeight : screenWidth; //横屏时的屏幕高度
      } else {
        screenHeightFinal = screenWidth / screenHeight < 3 ? (screenWidth - 200) : screenHeight;
        // screenHeightFinal = screenWidth - 200;
      }

      if (bean == null) return;
      bean.heightWidgetHere = screenHeightFinal * 3 / 10; //c组件高度height
      bean.widthWidgetHere = bean.heightWidgetHere! *
          bean.width /
          bean.height; //c端组件宽=c端组件高 * b端组件宽 / b端组件高
      bean.widthGuideHere = bean.widthGuide *
          bean.heightWidgetHere! /
          bean.height; // 指引长方形宽度 = 屏幕宽度 * c组件高度 / 屏幕高度
      bean.heightGuideHere = bean.heightGuide *
          bean.heightWidgetHere! /
          bean.height; // 指引长方形高度 = 屏幕宽度 * c组件高度 / 屏幕高度
      bean.offsetXHere = (bean.offsetX) *
          bean.widthWidgetHere! /
          bean.width; // c端x位置 = admin端左上角x位置 * c端组件宽度 / admin端宽度 -
      bean.offsetYHere = (bean.offsetY) * bean.heightWidgetHere! / bean.height;
    }
    return bean;
  }

  GameAnswerJsonBean(
      {required this.widthGuide,
      required this.heightGuide,
      required this.mode,
      required this.width,
      required this.height,
      required this.offsetX,
      required this.offsetY,
      required this.radius});

  factory GameAnswerJsonBean.fromJson(Map<String, dynamic> json) {
    return _$GameAnswerJsonBeanFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GameAnswerJsonBeanToJson(this);
  }
}
