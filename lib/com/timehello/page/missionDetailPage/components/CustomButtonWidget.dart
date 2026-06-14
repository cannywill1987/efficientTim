import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class CustomButtonWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  bool? status; //未开始 进行中
  String? text;
  Icon? icon = Icon(
    Icons.play_arrow,
    size: 27,
    color: ColorsConfig.white,
  );

  CustomButtonWidget(
      {Key? key, this.onTapListener, this.status, this.text, this.icon})
      : super(key: key) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomButtonState();
  }
}

class CustomButtonState extends State<CustomButtonWidget> {
  CustomButtonState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.widget.status == null || this.widget.status == false) {
      return getCustomButtunStartStatus();
    } else if (this.widget.status == true) {
      return getCustomButtunPauseStatus();
    }
    return SizedBox.shrink();
  }

  Widget getCustomButtunStartStatus() {
    final Color themeColor = ThemeManager.getInstance().getDefautThemeColor();
    return TextButton(
        style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: Container(
            margin: const EdgeInsets.fromLTRB(15, 18, 15, 0),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            alignment: Alignment.center,
            height: 54,
            decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                border: Border.all(color: themeColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(200)),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.24),
                    blurRadius: 22,
                    spreadRadius: -8,
                  )
                ]),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  size: 25,
                  color: ColorsConfig.white,
                ),
                const SizedBox(width: 8),
                Text(
                  this.widget.text ?? "",
                  style: TextStyle(
                      fontSize: 21,
                      color: ColorsConfig.white,
                      fontWeight: FontWeight.w600),
                )
              ],
            )));
  }

  Widget getCustomButtunPauseStatus() {
    final Color themeColor = ThemeManager.getInstance().getDefautThemeColor();
    return TextButton(
        style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: FittedBox(
            child: Container(
                margin: const EdgeInsets.fromLTRB(15, 18, 15, 0),
                padding: const EdgeInsets.symmetric(horizontal: 36),
                alignment: Alignment.center,
                height: 54,
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    border: Border.all(color: themeColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(200)),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.24),
                        blurRadius: 22,
                        spreadRadius: -8,
                      )
                    ]),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    Icon(
                      Icons.pause_rounded,
                      size: 23,
                      color: ColorsConfig.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      this.widget.text ?? '',
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ))));
  }
}
