import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

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
      : super(key: key) {
  }

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
    return TextButton(
        style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(200))),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                this.widget.icon ?? SizedBox.shrink(),
                SizedBox(
                  width: 2,
                ),
                Text(
                  this.widget.text ?? "",
                  style: TextStyle(
                      fontSize: 22,
                      color: ColorsConfig.white,
                      fontWeight: FontWeight.w600),
                )
              ],
            )));
  }

  Widget getCustomButtunPauseStatus() {
    return TextButton(
        style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: FittedBox(
            child: Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(200))),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      this.widget.text ?? '',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ))));
  }
}
