import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class BackNavigator extends StatelessWidget {
  OnTapListener onTapListener;
  Widget? centerChild;
  Widget? rightChild;
  Color? backColor;
  String? title;

  BackNavigator(
      {this.backColor,
      required this.onTapListener,
      this.title,
      this.centerChild,
      this.rightChild});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(children: [

      title != null
          ? Container(
        color: ThemeManager.getInstance().getNavigationBarColor(defaultColor: Colors.transparent),
        padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
                title ?? '',
                style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black), fontSize: 18),
              )),
          )
          : this.centerChild == null
              ? SizedBox.shrink()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: DeviceInfoManagement.isMoible() ? 40 : 0),
                      height: 50,
                      child: this.centerChild)),
      Align(
          alignment: Alignment.centerLeft,
          child: Container(
              margin: EdgeInsets.only(
                  top: DeviceInfoManagement.isMoible() ? 40 : 0),
              height: 50,
              width: 50,
              child: BackButton(
                color: ThemeManager.getInstance().getIconColor(defaultColor: this.backColor ?? Color(0xff404040)),
                onPressed: () {
                  this.onTapListener(null);
                },
              ))),
      this.rightChild == null
          ? SizedBox.shrink()
          : Align(
              alignment: Alignment.centerRight,
              child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(
                      right: 20, top: DeviceInfoManagement.isMoible() ? 40 : 0),
                  height: 50,
                  child: this.rightChild)),
    ]);
  }
}
