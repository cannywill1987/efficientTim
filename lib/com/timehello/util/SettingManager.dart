
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../models/SettingModel.dart';

/**
 * app设置管理
 */
class SettingManager {
  static SettingManager? _instance;
  SettingModel settingModel = SettingModel();
  SharedPreferences? mSharedPreferences;
  int isListingTodayOn = 1;
  int isListingDoItNowOn = 1;
  int isListingTomorrowOn = 1;
  int isListingLatest7DaysOn = 1;
  int isListingTodoListOn = 1;
  int isListingFragmentOn = 1;
  int isListingAllUnfinishedMission = 1;
  int isListingFinishedOn = 1;
  int isListingAllOn = 1;

  int isTomatoPageOn = 1;
  int isTimeManagementPageOn = 1;
  int isCalendarContainerPageOn = 1;
  int isFourQuadrantPageOn = 1;
  int isTimelinePageOn = 1;
  int isClockInPCPageOn = 1;
  int isWQBContainerOn = 1;
  int isCountDownListViewPageOn = 1;
  int isGamePageOn = 1;
  int isLockScreenPageOn = 1;
  int isStatisticPageOn = 1;
  int isSettingPageOn = 1;



  static SettingManager getSyncInstance() {
    if (_instance == null) {
      _instance = new SettingManager();
      _instance?.init();
      // _instance?.initShareprerence();
    }
    return _instance!;
  }

  init() {
    //登录才初始化数据
    if(LoginManager.getInstance().isLogin2()) {
      getSettingModel();
    }
  }

  getSettingModel() {
    String value = SharePreferenceUtil.getSyncInstance().getString(key: ShareprefrenceKeys.SettingModelKey);
      if (value != null && value.isNotEmpty) {
        try {
          settingModel = SettingModel.fromJson(jsonDecode(value));
          isListingTodayOn = settingModel.isListingTodayOn ?? 1;
          isListingDoItNowOn = settingModel.isListingDoItNowOn ?? 1;
          isListingTomorrowOn = settingModel.isListingTomorrowOn ?? 1;
          isListingLatest7DaysOn = settingModel.isListingLatest7DaysOn ?? 1;
          isListingTodoListOn = settingModel.isListingTodoListOn ?? 1;
          isListingFragmentOn = settingModel.isListingFragmentOn ?? 1;
          isListingAllUnfinishedMission =
              settingModel.isListingAllUnfinishedMIssion ?? 1;
          isListingFinishedOn = settingModel.isListingFinishedOn ?? 1;
          isListingAllOn = settingModel.isListingAllOn ?? 1;

          isTomatoPageOn = settingModel.isTomatoPageOn ?? 1;
          isTimeManagementPageOn = settingModel.isTimeManagementPageOn ?? 1;
          isCalendarContainerPageOn = settingModel.isCalendarContainerPageOn ?? 1;
          isFourQuadrantPageOn = settingModel.isFourQuadrantPageOn ?? 1;
          isTimelinePageOn = settingModel.isTimelinePageOn ?? 1;
          isClockInPCPageOn = settingModel.isClockInPCPageOn ?? 1;
          isWQBContainerOn = settingModel.isWQBContainerOn ?? 1;
          isCountDownListViewPageOn = settingModel.isCountDownListViewPageOn ?? 1;
          isGamePageOn = settingModel.isGamePageOn ?? 1;
          isLockScreenPageOn = settingModel.isLockScreenPageOn ?? 1;
          isStatisticPageOn = settingModel.isStatisticPageOn ?? 1;
          isSettingPageOn = settingModel.isSettingPageOn ?? 1;

        } catch(e) {
          print(e);
        }
      }
  }

  updateSettingModel() {
    settingModel.isListingTodayOn = isListingTodayOn;
    settingModel.isListingDoItNowOn = isListingDoItNowOn;
    settingModel.isListingTomorrowOn = isListingTomorrowOn;
    settingModel.isListingLatest7DaysOn = isListingLatest7DaysOn;
    settingModel.isListingTodoListOn = isListingTodoListOn;
    settingModel.isListingFragmentOn = isListingFragmentOn;
    settingModel.isListingAllUnfinishedMIssion = isListingAllUnfinishedMission;
    settingModel.isListingFinishedOn = isListingFinishedOn;
    settingModel.isListingAllOn = isListingAllOn;

    settingModel.isTomatoPageOn = isTomatoPageOn;
    settingModel.isTimeManagementPageOn = isTimeManagementPageOn;
    settingModel.isCalendarContainerPageOn = isCalendarContainerPageOn;
    settingModel.isFourQuadrantPageOn = isFourQuadrantPageOn;
    settingModel.isTimelinePageOn = isTimelinePageOn;
    settingModel.isClockInPCPageOn = isClockInPCPageOn;
    settingModel.isWQBContainerOn = isWQBContainerOn;
    settingModel.isCountDownListViewPageOn = isCountDownListViewPageOn;
    settingModel.isGamePageOn = isGamePageOn;
    settingModel.isLockScreenPageOn = isLockScreenPageOn;
    settingModel.isStatisticPageOn = isStatisticPageOn;
    settingModel.isSettingPageOn = isSettingPageOn;



    String s = jsonEncode(settingModel.toJson());
    SharePreferenceUtil.getSyncInstance().setString(key:ShareprefrenceKeys.SettingModelKey , content: s);
    Utility.getGlobalContext()?.read<Env>().settingModel = settingModel;
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 今天 清单是否显示
   */
  setIsListingTodayOn(int value) {
    isListingTodayOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 现在做 清单是否显示
   */
  setIsListingDoItNowOn(int value) {
    isListingDoItNowOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 明天 清单是否显示
   */
  setIsListingTomorrowOn(int value) {
    isListingTomorrowOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 最近7天 清单是否显示
   */
  setIsListingLatest7DaysOn(int value) {
    isListingLatest7DaysOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 代办清单 清单是否显示
   */
  setIsListingTodoListOn(int value) {
    isListingTodoListOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 碎片 清单是否显示
   */
  setIsListingFragmentOn(int value) {
    isListingFragmentOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 所有未完成任务 清单是否显示
   */
  setIsListingAllUnfinishedMIssion(int value) {
    isListingAllUnfinishedMission = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 已完成 清单是否显示
   */
  setIsListingFinishedOn(int value) {
    isListingFinishedOn = value;
    updateSettingModel();
  }

  /**
   * 1默认显示 0 隐藏 -1 有数据显示
   * 所有 清单是否显示
   */
  setIsListingAllOn(int value) {
    isListingAllOn = value;
    updateSettingModel();
  }

  setIsTomatoPageOn(int value) {
    isTomatoPageOn = value;
    updateSettingModel();
  }

  setIsTimeManagementPageOn(int value) {
    isTimeManagementPageOn = value;
    updateSettingModel();
  }

  setIsCalendarContainerPageOn(int value) {
    isCalendarContainerPageOn = value;
    updateSettingModel();
  }

  setIsFourQuadrantPageOn(int value) {
    isFourQuadrantPageOn = value;
    updateSettingModel();
  }

  setIsTimelinePageOn(int value) {
    isTimelinePageOn = value;
    updateSettingModel();
  }

  setIsClockInPCPageOn(int value) {
    isClockInPCPageOn = value;
    updateSettingModel();
  }

  setIsWQBContainerOn(int value) {
    isWQBContainerOn = value;
    updateSettingModel();
  }

  setIsCountDownListViewPageOn(int value) {
    isCountDownListViewPageOn = value;
    updateSettingModel();
  }

  setIsGamePageOn(int value) {
    isGamePageOn = value;
    updateSettingModel();
  }

  setIsLockScreenPageOn(int value) {
    isLockScreenPageOn = value;
    updateSettingModel();
  }

  setIsStatisticPageOn(int value) {
    isStatisticPageOn = value;
    updateSettingModel();
  }

  setIsSettingPageOn(int value) {
    isSettingPageOn = value;
    updateSettingModel();
  }



}