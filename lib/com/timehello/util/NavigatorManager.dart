import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/SettingItemDetailPage/SettingItemDetailPage.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../models/MissionModel.dart';

class NavigatorManager {
  static NavigatorManager? navigatorManager;
  Function? popCallback;

  static getInstance() {
    if (navigatorManager == null) {
      navigatorManager = NavigatorManager();
      navigatorManager?.init();
    }
    return navigatorManager;
  }

  init() {}

  pushToSettingItemDetailPage(BuildContext context,
      {required MissionModel missionModel,
      int fromNormal = 0,
      required Function popOkCallback,
      required Function onClickDeleteCallback}) {
    // if (this.popCallback != null) {
    //   this.popCallback!(missionModel);
    // }
    Utility.openPagePCAndMobile(
        context,
         child: SettingItemDetailPage(
             fromNormal: fromNormal,
             popOkCallback: popOkCallback,
             onClickDeleteCallback: onClickDeleteCallback,
             missionModel: missionModel));
  }

  popupSettingItemDetailPage(BuildContext context,
      {MissionModel? missionModel}) {
    if (this.popCallback != null) {
      this.popCallback!(missionModel);
    }
    Utility.popNavigator(context, missionModel);
    // if (Utility.isHandsetBySize()) {
    // } else {
    //   Utility.popupDesktopRightNavigator(context);
    // }
  }

  setPopCallback(Function popCallback) {
    this.popCallback = popCallback;
  }
}
