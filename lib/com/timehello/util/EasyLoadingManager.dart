import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../components/CustomAnimation.dart';

class EasyLoadingManager {
  static EasyLoadingManager? easyLoadingManager;
  static getInstance() {
    if(easyLoadingManager == null) {
      easyLoadingManager = EasyLoadingManager();
      easyLoadingManager?.init();
    }
    return easyLoadingManager;
  }

  init() {
    EasyLoading.init();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
    ..dismissOnTap = false
      ..customAnimation = CustomAnimation();
  }

  void showLoading([String? loading]) async {
    if (loading == null) {
      loading =  getI18NKey().loading;
    }
    await EasyLoading.show(
      status: loading,
      maskType: EasyLoadingMaskType.clear, //设置背景是否可点击
    );
    print('EasyLoading show');
  }

  void hideLoading() async {
    await EasyLoading.dismiss(
    );
  }

  void dismiss() {
    EasyLoading.dismiss();
  }

  void showSuccess(String msg) async {
    await EasyLoading.showSuccess(msg);
  }

  void showInfo(String msg) async {
    await EasyLoading.showInfo(msg);
  }

  void showProgress(double progress) async {
    EasyLoading.showProgress(progress,
        status: '${(progress * 100).toStringAsFixed(0)}%');
  }
}