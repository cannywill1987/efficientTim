import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import 'DialogRouter.dart';
import 'LoadingWidget.dart';

class Loading {
  static void show(BuildContext context, {bool? mateStyle}) {
    Navigator.of(context).push(DialogRouter(LoadingDialog()));
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: Center(
            //保证控件居中效果
            child: _dialog(),
          ),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  Widget _dialog() {
    // print("val:" + animationCloud1.value.toString());
    return WidgetManager.getLoadingWidget();
  }
}
