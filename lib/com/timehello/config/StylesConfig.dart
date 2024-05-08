import 'package:flutter/material.dart' as StyleConfig;
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';

import '../util/ThemeManager.dart';
import 'DimensConfig.dart';

const Color kCanvasColor = Color(0xfff2f3f7);

class StylesConfig {
  static double heightItemOfCalendar = 120;
  static double iconSize = 15;
  static TextStyle textStyleMenuItemTextStyle =
      TextStyle(fontSize: 14, color: Color(0xff999999));

  // static final ThemeData lightTheme = ThemeData.light().copyWith(
  //   primaryColor: Colors.pink,
  //   primaryColorDark: Colors.pink.withOpacity(0.8),
  //   indicatorColor: Colors.black,
  //   hintColor: Colors.deepOrange,
  //   primaryColorLight: Colors.black,
  // );
  //
  // static final ThemeData darkTheme = ThemeData.dark().copyWith(
  //   primaryColor: Colors.greenAccent,
  //   primaryColorDark: Colors.greenAccent.withOpacity(0.8),
  //   indicatorColor: Colors.grey,
  //   accentColor: Colors.orange,
  //   primaryColorLight: Colors.white,
  // );

  static OutlineInputBorder borderSide = OutlineInputBorder(
  borderSide: BorderSide(
  color: ThemeManager.getInstance().getInputBorderColor(),
  width: 1),
  );

  static OutlineInputBorder enableBorderSide = OutlineInputBorder(
    borderSide: BorderSide(
        color: ThemeManager.getInstance().getInputBorderColor(),
        width: 1),
  );

  static OutlineInputBorder focusBorderSide = OutlineInputBorder(
    borderSide: BorderSide(
        color: ThemeManager.getInstance().getInputBorderColor(),
        width: 1),
  );

  static Color filledInputColor = Color(0x028b97a2);

  static InputDecoration getInputDecoration({String hintText = ''}) {
    return InputDecoration(
      labelText: hintText,
      labelStyle: TextStyle(
          color: ThemeManager.getInstance()
              .getTextColor(
              defaultColor: Color(0xff8b97a2)),
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat'),
      floatingLabelStyle: TextStyle(
          color: ThemeManager.getInstance()
              .getIconColor(),
          fontSize: 14),
      border: StylesConfig.borderSide,
      enabledBorder:StylesConfig.enableBorderSide,
      focusedBorder:StylesConfig.focusBorderSide,
      filled: true,
      fillColor: filledInputColor,
    );
  }

  static BoxDecoration getDecoration(
      {double radius = 12, Color? color}) {
    color = ThemeManager.getInstance().getDialogBackgroundColor(defaultColor: Colors.white);
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }

  static BoxDecoration getBackButtonDecoration({double radius = 6}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border.all(color: ColorsConfig.red, width: 1),
    );
  }

  static BoxDecoration getCloseButtonDecoration() {
    return BoxDecoration(
        color: ColorsConfig.red,
        borderRadius: BorderRadius.all(Radius.circular(20)));
  }

  static BoxDecoration getConfirmButtonDecoration() {
    return BoxDecoration(
        color: ColorsConfig.red,
        borderRadius: BorderRadius.all(Radius.circular(6)));
  }

  //默认有个左右Padding6px左右
  static ButtonStyle transparentTextButtonStyle = ButtonStyle(
    overlayColor: StyleConfig.MaterialStateProperty.all(Colors.transparent),
    alignment: Alignment.center,
    // foregroundColor: StyleConfig.MaterialStateProperty.resolveWith((states) {
    //   return states.contains(MaterialState.pressed)
    //       ? Colors.transparent
    //       : Colors.transparent;
    // }),
  );

  //button有默认尺寸 所以需要和子组件尺寸大小一样那就需要手动设置
  static ButtonStyle transparentTextButtonStyleWithSize(Size size) =>
      ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          //按钮的默认padding
          minimumSize: MaterialStateProperty.all(size),
          fixedSize: MaterialStateProperty.all(size),
          overlayColor:
              StyleConfig.MaterialStateProperty.all(Colors.transparent),
          alignment: Alignment.center,
          foregroundColor:
              StyleConfig.MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.pressed)
                ? Colors.transparent
                : Colors.transparent;
          }),
          backgroundColor:
              StyleConfig.MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.pressed)
                ? Colors.transparent
                : Colors.transparent;
          }));
// static TextStyle listTitle = TextStyle(
//   fontSize: Dimens.font_sp16,
//   color: Colours.text_dark,
//   fontWeight: FontWeight.bold,
// );
// static TextStyle listContent = TextStyle(
//   fontSize: Dimens.font_sp14,
//   color: Colours.text_normal,
// );
// static TextStyle listExtra = TextStyle(
//   fontSize: Dimens.font_sp12,
//   color: Colours.text_gray,
// );
}

//  间隔
class Gaps {
  // 水平间隔
  static StyleConfig.Widget hGap5 =
      new StyleConfig.SizedBox(width: DimensConfig.gap_dp5);
  static StyleConfig.Widget hGap10 =
      new StyleConfig.SizedBox(width: DimensConfig.gap_dp10);

  // 垂直间隔
  static StyleConfig.Widget vGap5 =
      new StyleConfig.SizedBox(height: DimensConfig.gap_dp5);
  static StyleConfig.Widget vGap10 =
      new StyleConfig.SizedBox(height: DimensConfig.gap_dp10);
}
