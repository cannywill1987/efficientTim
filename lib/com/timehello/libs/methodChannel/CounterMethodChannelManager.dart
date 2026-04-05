import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';

// import 'package:secverify_plugin/secverify.dart';
// import 'package:secverify_plugin/secverify_UIConfig.dart';
import 'package:time_hello/com/timehello/models/PushDataModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/NotificationManager.dart';
import 'package:time_hello/com/timehello/util/PermissionManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../beans/BaseBean.dart';
import '../../beans/PriceProductModel.dart';
import '../../beans/ReminderModel.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/EventModel.dart';
import '../../config/CONSTANTS.dart';
import '../../config/Params.dart';
import '../../interface/OnMethodChannelResponseListener.dart';
import '../../models/EndTimeMissionModel.dart';
import '../../models/StartTimeMissionModel.dart';
import '../../models/FlomoMissionModel.dart';
import '../../models/MissionModel.dart';
import '../../models/PushDataModelList.dart';
import '../../models/SessionMissionModel.dart';
import '../../util/DeviceInfoManagement.dart';

import 'dart:convert';

class CounterMethodChannelManager {
  static const MethodChannel _channel =
      const MethodChannel('com.efficienttime.counter');
  static CounterMethodChannelManager? _instance;
  List<OnMethodChannelResponseListener> onMethodChannelResponseLisntenerList =
      [];

  static CounterMethodChannelManager getInstance() {
    if (_instance == null) {
      _instance = new CounterMethodChannelManager();
      _instance?.init();
    }
    return _instance!;
  }

  Future logs({String TAG = "", String msg = ""}) async {
    try {
      (_channel.invokeMethod<bool>('Logs', [
        {
          "TAG": TAG,
          "msg": msg,
        }
      ]));
    } catch (e) {}
  }

  Future<bool> shareToQQ(
      {String title = "",
      String subtitle = "",
      String iconUrl = "",
      String url = ""}) async {
    return (await _channel.invokeMethod<bool>('shareToQQ', [
          {
            "title": title,
            "subtitle": subtitle,
            "url": url,
            "iconUrl": iconUrl,
            "isOn": true,
          }
        ])) ??
        false;
  }

  Future<bool> shareToWeChat(
      {String title = "",
      String subtitle = "",
      int toWhere = 0,
      String iconUrl = "",
      String url = "",
      bool isOn = false}) async {
    return (await _channel.invokeMethod<bool>('shareToWechat', [
          {
            "title": title,
            "subtitle": subtitle,
            "url": url,
            "iconUrl": iconUrl,
            "toWhere": toWhere,
            "isOn": isOn
          }
        ])) ??
        false;
  }

  triggerOnMethodChannelResponseListener(String method, Map arguments) {
    for (int i = 0; i < this.onMethodChannelResponseLisntenerList.length; i++) {
      OnMethodChannelResponseListener f =
          this.onMethodChannelResponseLisntenerList[i];
      f(method, arguments, _channel);
    }
  }

  addOnRequestFinishListener(
      {required OnMethodChannelResponseListener
          onMethodChannelResponseLisntener}) {
    this
        .onMethodChannelResponseLisntenerList
        .add(onMethodChannelResponseLisntener);
  }

  removeOnRequestFinishListener(
      {required OnMethodChannelResponseListener
          onMethodChannelResponseListener}) {
    this
        .onMethodChannelResponseLisntenerList
        .remove(onMethodChannelResponseListener);
  }

  void init() async {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map args = call.arguments ?? {};
      triggerOnMethodChannelResponseListener(call.method, args);
    });
    Params.appName = await getAppName();
    Utility.initChannel(await getBrand());
  }

  void setUserBean() async {
    // _channel.setMethodCallHandler((MethodCall call) async {
    //   Map args = call.arguments ?? {};
    //   triggerOnMethodChannelResponseListener(call.method, args);
    // });
    await _channel.invokeMethod('setUserBean', [
      {
        "uid": LoginManager.getInstance().isLogin2()
            ? LoginManager.getInstance().userBean.uid
            : ""
      }
    ]);

    Params.appName = await getAppName();
    Utility.initChannel(await getBrand());
  }

  Future<BaseBean> getLiveActivityData({Function? result}) async {
    if (Utility.isIOS() == true || Utility.isMacOS() == true) {
      String res =
          (await _channel.invokeMethod<String>('getLiveActivityData') ?? "");
      BaseBean bean = BaseBean.fromJson(jsonDecode(res));
      if (result != null) {
        result(bean);
      }
      return bean;
    } else {
      BaseBean bean =
          BaseBean(message: "", success: false, code: "", data: null);
      if (result != null) {
        result(bean);
      }
      return bean;
    }
  }

  /**
   * 用于项目初始化
   */
  Future<String> requestInit() async {
    try {
      print("requestInit");
      await _channel.invokeMethod('init', [
        {"env": Utility.isProductEnv()}
      ]);
    } catch (e) {}
    return "";
  }

  Future<String> getAppName() async {
    try {
      String version = await _channel.invokeMethod('getAppName');
      return version;
    } catch (e) {}
    return "";
  }

  Future<String> getBrand() async {
    try {
      String brand = await _channel.invokeMethod('getBrand');
      return brand;
    } catch (e) {}
    return "";
  }

  Future<String> requestPushToTimeline() async {
    // 请求评论
    try {
      _channel.invokeMethod('pushToTimeline');
    } catch (e) {}
    return "";
  }

  Future<String> requestReview() async {
    // 请求评论
    try {
      _channel.invokeMethod('requestReview');
    } catch (e) {}
    return "";
  }

  Future<String> aliyunDeviceId() async {
    try {
      String version = await _channel.invokeMethod('getAliyunDeviceId');
      return version;
    } catch (e) {}
    return "";
  }

  Future<String> test() async {
    try {
      String version = await _channel.invokeMethod('test');
      return version;
    } catch (e) {}
    return "";
  }

  Future scheduleShutdown({required int delaySeconds}) async {
    await _channel
        .invokeMethod('scheduleShutdown', {"delaySeconds": delaySeconds});
  }

  Future<String> grantNotificationPermission() async {
    try {
      await _channel.invokeMethod('grantNotificationPermission');
    } catch (e) {}
    return "";
  }

  Future<bool> isNotificationOn() async {
    try {
      bool isOn = await _channel.invokeMethod('isNotificationOn');
      return isOn;
    } catch (e) {}
    return true;
  }

  Future<String> initPushNotification() async {
    try {
      await _channel.invokeMethod('initPushNotification');
    } catch (e) {}
    return "";
  }

  Future<BaseBean> updateMissionModelToCalendar(BuildContext context,
      {required MissionModel missionModel}) async {
    try {
      String res = await _channel.invokeMethod(
          'updateMissionModelToCalendar', missionModel.toJson());
      BaseBean bean = BaseBean.fromJson(jsonDecode(res));
      return bean;
    } catch (e) {}
    return BaseBean(success: false);
  }

  Future<BaseBean> updateMissionModelToReminder(BuildContext context,
      {required MissionModel missionModel}) async {
    try {
      missionModel.title =
          missionModel.title?.replaceAll("(${getI18NKey().from_calendar})", "");
      String res = await _channel.invokeMethod(
          'updateMissionModelToReminder', missionModel.toJson());
      BaseBean bean = BaseBean.fromJson(jsonDecode(res));
      return bean;
    } catch (e) {}
    return BaseBean(success: false);
  }

  /**
   * 跳转到ios reminder app
   */
  Future<void> openReminderApp({required String id}) async {
    try {
      _channel.invokeMethod('openReminderApp', id);
    } catch (e) {}
  }

  Future<void> openCalendarApp({required int timestamp}) async {
    try {
      _channel.invokeMethod('openCalendarApp', timestamp);
    } catch (e) {}
  }

  Future<bool> createMissionModelToCalendar(BuildContext context,
      {required MissionModel missionModel}) async {
    try {
      missionModel.title =
          missionModel.title?.replaceAll("(${getI18NKey().from_reminder})", "");
      await _channel.invokeMethod(
          'createMissionModelToCalendar', missionModel.toJson());
    } catch (e) {}
    return false;
  }

  /**
   * 今日任务列表
   */
  Future<bool> storeMyCalendarMissionList(BuildContext context) async {
    try {
      List<Map> listTmp = [];
      CalendarModel calendarModel =
          context.read<GlobalStateEnv>().calendarModel;

      calendarModel?.monthModelList.forEach((monthModel) {
        monthModel.dayModelList.forEach((element) {
          element.isCheck = false;
          List<Map> listMissionModel = [];
          // if (element.missionModelList.length > 0) {
          List<MissionModel> datasMissionModel =
              Utility.filterMissionModelByFinishedState(
                  list: element.missionModelList, isFinished: false);
          // if (element.dateTime?.year == 2024 && element.dateTime?.month == 11 && element.dateTime?.day == 19) {
          //   print("2024-11-19");
          // }
          datasMissionModel.forEach((MissionModel model) {
            FolderModel? folderModel =
                Utility.getFolderModelByObjId(model.folder_id ?? "");
            model.color = folderModel?.color ?? 0xffff8800;
            Map item = model.toJson();
            // if(model.title == "网球") {
            //   print(element.dateTime?.toString());
            // }
            // item["percent"] = Utility.getPercentOfNumClocksIn(missionModel: model, ymd: Utility.getYMD(element.dateTime ?? DateTime.now()));
            listMissionModel.add(item);
          });
          listTmp.add({
            "time": element.dateTime?.millisecondsSinceEpoch,
            "lunar": Utility.isChina() ? element.lunarDay : "",
            // "lunar": element.lunarDay,
            "data": listMissionModel
          });
          // }
        });
      });
      if (listTmp.length > 0) {
        return (await _channel.invokeMethod<bool>(
                'storeMyCalendarMissionList', listTmp)) ??
            false;
      }
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  /**
   * 今日任务列表
   */
  Future<bool> storeFlomoMissionList(BuildContext context) async {
    try {
      List<Map> listTmp = [];
      CalendarModel calendarModel =
          context.read<GlobalStateEnv>().calendarModel;

      calendarModel?.dayModelList.forEach((element) {
        element.isCheck = false;
        List<Map> listFlomoMissionModel = [];
        if (element.flomoMissionModelList.length > 0) {
          List<FlomoMissionModel> datasFlomoMissionModel =
              Utility.filterFlomoMissionModelByFinishedState(
                  list: element.flomoMissionModelList, isFinished: false);
          datasFlomoMissionModel.forEach((FlomoMissionModel model) {
            Map item = model.toJson();
            item["percent"] = Utility.getPercentOfNumClocksIn(
                missionModel: model,
                ymd: Utility.getYMD(element.dateTime ?? DateTime.now()));
            listFlomoMissionModel.add(item);
            // if(model.title == "早起") {
            //   print("早期");
            // }
            item["percent"] = Utility.getPercentOfNumClocksIn(
                missionModel: model,
                ymd: Utility.getYMD(element.dateTime ?? DateTime.now()));
          });
          listTmp.add({
            "time": element.dateTime?.millisecondsSinceEpoch,
            "data": listFlomoMissionModel
          });
        }
      });
      if (listTmp.length > 0) {
        return (await _channel.invokeMethod<bool>(
                'storeFlomoMissionList', listTmp)) ??
            false;
      }
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  Future<BaseBean> requestEventReminderAccess() async {
    try {
      String res =
          (await _channel.invokeMethod<String>('requestEventReminderAccess')) ??
              "";
      BaseBean bean = BaseBean.fromJson(jsonDecode(res));
      return bean;
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<BaseBean> deleteEvent({id = ""}) async {
    try {
      String res =
          (await _channel.invokeMethod<String>('deleteEvent', id)) ?? "";
      BaseBean bean = BaseBean.fromJson(jsonDecode(res));
      return bean;
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<BaseBean> deleteReminder({id = ""}) async {
    try {
      String res =
          (await _channel.invokeMethod<String>('deleteReminder', id)) ?? "";
      BaseBean bean = BaseBean.fromJson(jsonDecode(res));
      return bean;
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<List<EventModel>> fetchCalendarEvents(
      {required double startDate, required double endDate}) async {
    String res = (await _channel.invokeMethod<String>(
            'fetchEventReminderEvents',
            {"startDate": startDate, "endDate": endDate})) ??
        "";
    // Utility.showToastMsg(msg: res);
    // Object result = (await _channel.invokeMethod<String>(
    //     'fetchEventReminderEvents',  {"startDate": startDate, "endDate": endDate})) ??
    //     false;
    Map<String, dynamic> json = jsonDecode(res);
    final events =
        (json['data'] as List).map((e) => EventModel.fromJson(e)).toList();
    return events;
  }

  Future<List<ReminderModel>> fetchReminderReminders(
      {required double startDate, required double endDate}) async {
    // return (await _channel.invokeMethod<bool>('fetchEventReminderReminders',
    //         {"startDate": startDate, "endDate": endDate})) ??
    //     false;
    // Object obj = (await _channel.invokeMethod(
    //     'fetchEventReminderReminders',
    //     {"startDate": startDate, "endDate": endDate}));
    String res = (await _channel.invokeMethod<String>(
            'fetchEventReminderReminders',
            {"startDate": startDate, "endDate": endDate})) ??
        "";
    Map<String, dynamic> json = jsonDecode(res);
    // Utility.showToastMsg(msg: res);
    // Object result = (await _channel.invokeMethod<String>(
    //     'fetchEventReminderEvents',  {"startDate": startDate, "endDate": endDate})) ??
    //     false;
    List<ReminderModel> eventsRemindModel = [];
    for (int i = 0; i < (json['data'] as List).length; i++) {
      try {
        ReminderModel model = ReminderModel.fromJson(json['data'][i]);
        if (model.isCompleted == false) {
          eventsRemindModel.add(model);
        }
      } catch (e) {
        print(e);
      }
    }
    // final events = (json['data'] as List).map((e) {
    //   try {
    //     return ReminderModel.fromJson(e);
    //   } catch (e) {
    //     return ReminderModel();
    //   }
    // }).toList();
    return eventsRemindModel;
  }

  Future<BaseBean> IAPPurchase({required String id}) async {
    try {
      String res =
          (await _channel.invokeMethod<String>('IAPpurchase', id)) ?? "";
      return BaseBean.fromJson(jsonDecode(res));
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  /**
   * subscribed	2	用户已订阅，状态正常
      inBillingRetryPeriod	3	用户订阅处于账单重试期
      inGracePeriod	4	用户订阅处于宽限期
      expired	1	用户订阅已过期
      revoked	0	用户订阅被撤销
      unknown	-1	未知订阅状态
   */
  Future<BaseBean> checkSubscriptionState(String id) async {
    try {
      String res =
          (await _channel.invokeMethod<String>('checkSubscriptionState', id)) ??
              "";
      return BaseBean.fromJson(jsonDecode(res));
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<BaseBean> getReceipt() async {
    try {
      String res = (await _channel.invokeMethod<String>('getReceipt')) ?? "";
      return BaseBean.fromJson(jsonDecode(res));
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  /**
   * 返回productId
   * "-1" 字符串表示失败
   */
  Future<BaseBean> restorePurchases() async {
    try {
      String res =
          (await _channel.invokeMethod<String>('restorePurchases')) ?? "";
      return BaseBean.fromJson(jsonDecode(res));
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<BaseBean> getSubscriptionDetails() async {
    try {
      String res =
          (await _channel.invokeMethod<String>('getSubscriptionDetails')) ?? "";
      return BaseBean.fromJson(jsonDecode(res));
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<List<PriceProductModel>> IAPManagerFetchProducts(
      {required List<String> listProducts}) async {
    try {
      if (listProducts.length > 0) {
        String res = (await _channel.invokeMethod<String>(
                'IAPManagerFetchProducts', listProducts)) ??
            "";
        Map<String, dynamic> json = jsonDecode(res);
        final events = (json['data'] as List).map((e) {
          e['price'] = e['price'].toDouble() ?? 0.0;
          return PriceProductModel.fromJson(e);
        }).toList();
        return events;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  /**
   * 今日任务列表
   */
  Future<bool> storeMissionList(List<SessionMissionModel> list) async {
    try {
      List<Map> listTmp = [];
      List<Map> listModellistMap =
          parseMissionModelList2(listMissionModels: list);
      if (listModellistMap.length > 0) {
        return (await _channel.invokeMethod<bool>(
                'storeMissionList', listModellistMap)) ??
            false;
      }
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  /**
   * 今日任务列表
   */
  Future<bool> storeEndTimeMissionList(List<EndTimeMissionModel> list) async {
    try {
      List<Map> listTmp = [];
      List<Map> listModellistMap =
          parseEndTimeMissionModelList(listMissionModels: list);
      if (listModellistMap.length > 0) {
        return (await _channel.invokeMethod<bool>(
                'storeEndTimeMissionList', listModellistMap)) ??
            false;
      }
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  /**
   * 开始时间任务列表 - 用于iOS桌面组件数据透传
   */
  Future<bool> storeStartTimeMissionList(
      List<StartTimeMissionModel> list) async {
    try {
      List<Map> listModellistMap =
          parseStartTimeMissionModelList(listMissionModels: list);
      if (listModellistMap.length > 0) {
        return (await _channel.invokeMethod<bool>(
                'storeStartTimeMissionList', listModellistMap)) ??
            false;
      }
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  Future<bool> storeCustomizeMissionList(
      List<SessionMissionModel> list, String? title) async {
    try {
      List<Map> listTmp = [];
      List<Map> listModellistMap =
          parseMissionModelList2(listMissionModels: list);
      if (listModellistMap.length > 0) {
        return (await _channel.invokeMethod<bool>('storeCustomizeMissionList',
                {"datas": listModellistMap, "title": title ?? ""})) ??
            false;
      }
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  /**
   * 用于展示四象限桌面widget
   */
  Future<bool> storeWQBNoteMissionData(WQBMissionModel missionData) async {
    try {
      String subtitle = "";
      if (missionData.order_index != null) {
        if (missionData.order_index == 1) {
          subtitle = getI18NKey().note_1;
        } else if (missionData.order_index == 2) {
          subtitle = getI18NKey().note_2;
        } else if (missionData.order_index == 3) {
          subtitle = getI18NKey().note_3;
        } else if (missionData.order_index == 4) {
          subtitle = getI18NKey().note_4;
        } else if (missionData.order_index == 5) {
          subtitle = getI18NKey().note_5;
        } else if (missionData.order_index == 6) {
          subtitle = getI18NKey().note_6;
        } else if (missionData.order_index == 7) {
          subtitle = getI18NKey().note_7;
        }
      }

      Map map = missionData.toJson();
      map['key'] = "${missionData.order_index}";
      map['subtitle'] = subtitle;
      return (await _channel
              .invokeMethod<bool>('storeWQBNoteMissionData', [map])) ??
          false;
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  /**
   * 用于展示四象限桌面widget
   */
  Future<bool> storeMissionDataList(List<SessionMissionModel> list) async {
    try {
      List<Map> listTmp = [];
      list.forEach((element) {
        Map map = element.toJson();
        // print(map);
        map['datas'] = parseMissionModelListToMap(
            map['datas'], Utility.isAndroid() == true ? 100 : 6);
        listTmp.add(map);
      });
      return (await _channel.invokeMethod<bool>(
              'storeMissionDataList', listTmp)) ??
          false;
    } catch (e) {
      Utility.print(e);
    }
    return false;
  }

  List<Map> parseMissionModelListToMap(List<MissionModel> listMissionModels,
      [int maxNums = 6]) {
    List<Map> list = [];
    for (int i = 0; i < listMissionModels.length; i++) {
      MissionModel missionModel = listMissionModels[i];
      if (missionModel.isFinished == false) {
        // if (i > maxNums) {
        //   MissionModel missionModel = MissionModel();
        //   missionModel.title = "......";
        //   list.add(missionModel.toJson());
        //   break;
        // }
        list.add(listMissionModels[i].toJson());
      }
    }
    return list;
  }

  List<Map> parseMissionModelList2(
      {required List<SessionMissionModel> listMissionModels}) {
    List<Map> list = [];
    listMissionModels.forEach((element) {
      for (int i = 0; i < (element.datas?.length ?? 0); i++) {
        MissionModel missionModel = element.datas![i];
        if (missionModel.isFinished == false) {
          list.add(missionModel.toJson());
        }
      }
    });
    return list;
  }

  List<Map> parseEndTimeMissionModelList(
      {required List<EndTimeMissionModel> listMissionModels}) {
    List<Map> list = [];
    listMissionModels.forEach((missionModel) {
      // if (missionModel.isFinished == false) {
      list.add(missionModel.toJson());
      // }
    });
    return list;
  }

  /**
   * 解析开始时间任务模型列表为Map格式 - 用于iOS桌面组件数据透传
   */
  List<Map> parseStartTimeMissionModelList(
      {required List<StartTimeMissionModel> listMissionModels}) {
    List<Map> list = [];
    listMissionModels.forEach((missionModel) {
      // 过滤未完成的任务，只显示进行中的任务
      if (missionModel?.isFinished == false) {
        list.add(missionModel!.toJson());
      }
    });
    return list;
  }

  Future<bool> requestStatusBar(CounterModelRequest focusRequest) async {
    try {
      return (await _channel.invokeMethod<bool>(
              'requestStatusBar', [focusRequest.toJson()])) ??
          false;
    } catch (e) {}
    return false;
  }

  Future<BaseBean> isNotificationEnabled({Function? result}) async {
    if (Utility.isIOS() == true || Utility.isMacOS() == true) {
      String res =
          (await _channel.invokeMethod<String>('isNotificationEnabled')) ?? "";
      // print(res);
      return BaseBean.fromJson(jsonDecode(res));
    } else {
      bool isNotificationOn =
          await PermissionManager.getInstance().isNotificationOn();
      return BaseBean(
          message: "", success: true, code: "", data: isNotificationOn);
    }
  }

  Future<BaseBean> turnOnPushChannel({Function? result}) async {
    String res =
        (await _channel.invokeMethod<String>('turnOnPushChannel')) ?? "";
    // print(res);
    return BaseBean.fromJson(jsonDecode(res));
  }

  Future<BaseBean> turnOffPushChannel({Function? result}) async {
    String res =
        (await _channel.invokeMethod<String>('turnOnPushChannel')) ?? "";
    // print(res);
    return BaseBean.fromJson(jsonDecode(res));
  }

  void shareSdkSubmitPolicyGrantResult() async {
    // Secverify.submitPrivacyGrantResult(true, null);
    // (await _channel
    //     .invokeMethod<String>('shareSdkSubmitPolicyGrantResult'));
  }

  Future<BaseBean> cancelAllPendingNotification({Function? result}) async {
    try {
      String res = (await _channel
              .invokeMethod<String>('cancelAllPendingNotification')) ??
          "";
      return BaseBean.fromJson(jsonDecode(res));
    } catch (e) {}
    // }

    return BaseBean(success: false);
  }

  Future<BaseBean> requestPreVerify({Function? result}) async {
    if (result != null) {
      result(BaseBean(message: "", success: false, code: null, data: null));
    }
    return BaseBean(success: true);
  }

  Future<BaseBean?> requestSecVerify({Function? result}) async {
    if (result != null) {
      result(BaseBean(message: "", success: false, code: "", data: null));
    }
    // Secverify.verify(Utility.getSecVerifyUIConfig(), (rt, err) {
    //   if (err != null) {
    //     // 拉起授权页面失败
    //     result(BaseBean(message: "", success: false, code: "", data: null));
    //     // _showAlert(err.toString());
    //   } else {
    //     print('Open Auth Page Result: ${rt.toString()}');
    //   }
    // }, (rt, err) {
    //   if (err != null) {
    //     result(BaseBean(message: "", success: false, code: "", data: null));
    //     // _showAlert(err.toString());
    //   }
    // }, (rt, err) {
    //   if ((config.iOSConfig.manualDismiss)) {
    //     Secverify.manualDismissLoading();
    //     Secverify.manualDismissLoginVC(flag: true).then((value) {
    //       print('Manual Dismiss Loading VC Success');
    //     });
    //   }
    //   // 登录验证结果回调
    //   if (rt != null && err == null) {
    //     String resultStr = rt.toString();
    //     if (resultStr.length != 0 &&
    //         resultStr.contains('token') &&
    //         resultStr.contains('opToken') &&
    //         resultStr.contains('operator')) {
    //       // 结果检验成功，进行网络请求
    //       result(BaseBean(message: "", success: true, code: "0000", data: rt));
    //       // _doLoginWith(rt);
    //     } else {
    //       result(BaseBean(message: "", success: false, code: "", data: null));
    //     }
    //   } else if (err != null) {
    //     result(BaseBean(message: "", success: false, code: "", data: null));
    //     // _showAlert(err.toString());
    //   } else {
    //     result(BaseBean(message: "", success: false, code: "", data: null));
    //     // _showAlert('登录验证失败');
    //   }
    // }, (rt, err) {
    //   // 自定义控件点击事件结果回调
    //   print("自定义控件点击事件结果回调:" + rt.toString() + err.toString());
    // }, (rt, err) {
    //   if (rt != null && err == null) {
    //     String resultStr = rt['ret'].toString();
    //     if (resultStr.length != 0) {
    //       if (resultStr.contains('onOtherLogin')) {
    //         result(BaseBean(message: "", success: false, code: "", data: null));
    //         // _showAlert('其他方式登录');
    //       } else if (resultStr.contains('onUserCanceled')) {
    //         result(BaseBean(message: "", success: false, code: "", data: null));
    //         // _showAlert('用户取消登录');
    //       } else {
    //         if (resultStr.contains('token') &&
    //             resultStr.contains('opToken') &&
    //             resultStr.contains('operator')) {
    //           result(BaseBean(
    //               message: "", success: true, code: "0000", data: rt['ret']));
    //           // _doLoginWith(rt['ret']);
    //         }
    //       }
    //     }
    //   } else {
    //     if (err != null) {
    //       result(BaseBean(message: "", success: false, code: "", data: null));
    //       // _showAlert('取号失败 ${err['err'].toString()}');
    //     }
    //   }
    // });
    // String res =   (await _channel
    //     .invokeMethod<String>('secVerify'));
    // return BaseBean.fromJson(jsonDecode(res));
  }

  Future<BaseBean> mobileAuthToken({Function? result}) async {
    if (result != null) {
      result(BaseBean(message: "", success: false, code: null, data: null));
    }
    // Secverify.mobileAuthToken(
    //     timeout: 5.0,
    //     result: (Map ret, Map err) {
    //       if (ret != null && err == null) {
    //         // 显示本机认证Token信息
    //         String retDetail = ret.toString();
    //         if (retDetail.length != 0 &&
    //             retDetail.contains('token') &&
    //             retDetail.contains('opToken') &&
    //             retDetail.contains('operator')) {
    //           result(BaseBean(
    //               message: "", success: true, code: '0000', data: ret));
    //
    //           // 结果检验成功，进行本地设置
    //           // _mobileAuthToken = Map.from(ret);
    //           // _showAlert(_mobileAuthToken.toString());
    //         } else {
    //           result(BaseBean(
    //               message: "", success: false, code: null, data: null));
    //           // _showAlert('请求本机认证Token失败 $retDetail');
    //         }
    //
    //         print('Request Mobile Auth Token Info: $retDetail');
    //       } else if (err != null) {
    //         String errDetail = err.toString();
    //         result(BaseBean(
    //             message: errDetail, success: false, code: null, data: null));
    //         // _showAlert(errDetail);
    //       } else {
    //         result(BaseBean(
    //             message: null, success: false, code: null, data: null));
    //         // _showAlert('请求本机认证Token失败');
    //       }
    //     });
    // String res =   (await _channel
    //     .invokeMethod<String>('secVerify'));
    // return BaseBean.fromJson(jsonDecode(res));
    return BaseBean(success: true);
  }

  Future<bool> requestPushNotificationWithDelay(
      {String title = "",
      String content = "",
      int delay = 0,
      String extendsParams = "",
      String id = ""}) async {
    // if(DeviceInfoManagement.getInstance()?.isIOS() == true || DeviceInfoManagement.getInstance()?.isMacOs()) {
    // {title, content, delay, extendsParams}
    return (await _channel.invokeMethod<bool>('pushCounterNotification', [
          {
            "title": title,
            "content": content,
            "delay": delay,
            "extendsParams": extendsParams,
            "id": id
          }
        ])) ??
        false;
    // }
  }

  /**
   * [
      {
      "title": title,
      "content": content,
      "summaryText": summaryText,
      "when": whenMilliseconds ~/ 1000,
      "id": id,
      // "action": action ?? Params.ACTION_COUNTER_PUSH_NOTIFICATION
      }
      ]
   */
  Future<bool> pushListNotificationWithWhen(
      {required PushDataModelList pushDataModelList}) async {
    // String js = jsonEncode(pushDataModelList.list.sublist(0, 100));
    List<Map> list = [];
    int length = pushDataModelList.list.length > 500
        ? 500
        : pushDataModelList.list.length;
    for (int i = 0; i < length; i++) {
      PushDataModel map = pushDataModelList.list[i];
      DateTime dateTime =
          Utility.getDateTimeFromTimeStamp(map.whenMilliseconds);
      // String idExt = dateTime.year + dateTime.month + dateTime.day + dateTime.hour + dateTime.minute;
      //必须要加这个判断 否则以前设置的通知也会响起来
      if (map.whenMilliseconds > Utility.getTimeStampToday()) {
        String idTmp = map.id + (map.whenMilliseconds ~/ 1000).toString();
        if (idTmp.length > 10) {
          idTmp = idTmp.substring(0, 10);
        }
        // if(map.title.indexOf("1111111111111") != -1) {
        //   print("1111111111");
        // }
        list.add({
          "title": map.title + "-" + dateTime.toString(),
          "content": map.content,
          "summaryText": map.summaryText,
          "when": map.whenMilliseconds ~/ 1000,
          "id": idTmp
        });
      }
    }
    list.sort((val1, val2) {
      return val1['when'] > val2['when']
          ? 1
          : val1['when'] < val2['when']
              ? -1
              : 0;
    });
    // return (await _channel.invokeMethod<bool>(
    //     'pushListNotificationWithWhen', pushDataModelList.list.sublist(0, 100)));
    //30个的目的是为了ios不能同时设置64个以上 否则出错
    int times = list.length % 40;
    NotificationManager.getInstance()?.cancelAllPendingNotification();
    await Future.delayed(Duration(seconds: 3));
    if (times > 1 && (Utility.isIOS() == true || Utility.isMacOS() == true)) {
      times = 1;
    }
    for (int i = 0; i < times; i++) {
      print("Pushing List To Notifications: $i");
      try {
        List<Map> subList = list.sublist(40 * i, 40 * (i + 1));
        (_channel.invokeMethod<bool>('pushListNotificationWithWhen', subList));
        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        List<Map> subList = list.sublist(30 * i, list.length);
        (_channel.invokeMethod<bool>('pushListNotificationWithWhen', subList));
      }
    }
    return true;
  }

  /**
   * 按天推送不需要缓存
   */
  Future<bool> pushNotificationWithWhen(
      {String title = '',
      String content = '',
      String summaryText = '', //android才有， 右上角的标题
      int whenMilliseconds = 0,
      String id = ''}) async {
    try {
      DateTime dateTime = Utility.getDateTimeFromTimeStamp(whenMilliseconds);
      String idTmp = id + (whenMilliseconds ~/ 1000).toString();
      // if (idTmp.length > 10) {
      //   idTmp = idTmp.substring(0, 10);
      // }
      return (await _channel.invokeMethod<bool>('pushNotificationWithWhen', [
            {
              "title": title + "-" + dateTime.toString(),
              "content": content,
              "summaryText": summaryText ?? "",
              "when": whenMilliseconds ~/ 1000,
              "id": id,
              // "action": action ?? Params.ACTION_COUNTER_PUSH_NOTIFICATION
            }
          ])) ??
          false;
    } catch (e) {
      return false;
    }
    // }
  }

  Future<bool> cancelPushNotificationWidthId({String id = ""}) async {
    // if(DeviceInfoManagement.getInstance()?.isIOS() == true || DeviceInfoManagement.getInstance()?.isMacOs()) {
    // {title, content, delay, extendsParams}
    return (await _channel.invokeMethod<bool>('cancelPushCounterNotification', [
          {"action": id, 'id': id}
        ])) ??
        false;
    // }
  }

  Future<bool> openSetting() async {
    // if(DeviceInfoManagement.getInstance()?.isIOS() == true || DeviceInfoManagement.getInstance()?.isMacOs()) {
    // {title, content, delay, extendsParams}
    await _channel.invokeMethod('openSetting', [
      {"action": Params.ACTION_COUNTER_PUSH_NOTIFICATION}
    ]);
    return true;
    // }
  }

  /// 统一把原生返回转为 `Map<String, dynamic>`。
  ///
  /// 兼容三种形态：
  /// 1. 原生直接回 Map
  /// 2. 原生回弱类型 Map
  /// 3. 原生回 JSON 字符串
  Map<String, dynamic> _decodeAssistMapResult(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String) {
      try {
        final dynamic decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  /// `assistCaptureScreen`
  ///
  /// args: `{displayId}`
  /// returns: `{pngBase64, scale, width, height, widthLogical, heightLogical}`
  Future<Map<String, dynamic>> assistCaptureScreen({int displayId = 0}) async {
    final dynamic raw = await _channel.invokeMethod<dynamic>(
      'assistCaptureScreen',
      <String, dynamic>{'displayId': displayId},
    );
    return _decodeAssistMapResult(raw);
  }

  /// `assistCropPng`
  ///
  /// args: `{pngBase64, roi, coordSpace, scale}`
  /// returns: `{pngBase64}`
  Future<Map<String, dynamic>> assistCropPng({
    required String pngBase64,
    required Map<String, dynamic> roi,
    String coordSpace = 'logical',
    double scale = 1.0,
  }) async {
    final dynamic raw = await _channel.invokeMethod<dynamic>(
      'assistCropPng',
      <String, dynamic>{
        'pngBase64': pngBase64,
        'roi': roi,
        'coordSpace': coordSpace,
        'scale': scale,
      },
    );
    return _decodeAssistMapResult(raw);
  }

  /// `assistVisionOcr`
  ///
  /// args: `{pngBase64, lang, returnType}`
  /// returns: `{text}` or `{lines:[...]}`
  Future<Map<String, dynamic>> assistVisionOcr({
    required String pngBase64,
    String lang = 'zh-Hans',
    String returnType = 'text',
  }) async {
    final dynamic raw = await _channel.invokeMethod<dynamic>(
      'assistVisionOcr',
      <String, dynamic>{
        'pngBase64': pngBase64,
        'lang': lang,
        'returnType': returnType,
      },
    );
    return _decodeAssistMapResult(raw);
  }

  /// `assistFocusAndPaste`
  ///
  /// args: `{point:{x,y}, text, coordSpace}`
  /// returns: `{ok:true}`
  ///
  /// 注意：该方法只负责聚焦和粘贴，不自动发送。
  Future<Map<String, dynamic>> assistFocusAndPaste({
    required double x,
    required double y,
    required String text,
    String coordSpace = 'logical',
  }) async {
    final dynamic raw = await _channel.invokeMethod<dynamic>(
      'assistFocusAndPaste',
      <String, dynamic>{
        'point': <String, dynamic>{'x': x, 'y': y},
        'text': text,
        'coordSpace': coordSpace,
      },
    );
    return _decodeAssistMapResult(raw);
  }

  /// `assistCheckPermissions`
  ///
  /// returns: `{screenRecording, accessibility}`
  Future<Map<String, dynamic>> assistCheckPermissions() async {
    final dynamic raw = await _channel.invokeMethod<dynamic>(
      'assistCheckPermissions',
      <String, dynamic>{},
    );
    return _decodeAssistMapResult(raw);
  }

  /// `assistOpenSystemSettings`
  ///
  /// args: `{page: screenRecording|accessibility}`
  /// returns: `{ok:true|false}`
  Future<Map<String, dynamic>> assistOpenSystemSettings(
      {required String page}) async {
    final dynamic raw = await _channel.invokeMethod<dynamic>(
      'assistOpenSystemSettings',
      <String, dynamic>{'page': page},
    );
    return _decodeAssistMapResult(raw);
  }

  Future<bool> hideAliyunStatusBar() async {
    return (await _channel.invokeMethod<bool>('hideAliyunStatusBar', [])) ??
        false;
  }

  Future<bool> startLiveActivity() async {
    try {
      return (await _channel.invokeMethod<bool>('startLiveActivity', [])) ??
          false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> stopLiveActivity() async {
    try {
      return (await _channel.invokeMethod<bool>('stopLiveActivity', [])) ??
          false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateLiveActivity() async {
    return (await _channel.invokeMethod<bool>('updateLiveActivity', [])) ??
        false;
  }

  static Future<String> get platformVersion async {
    String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get installationId async {
    String version = await _channel.invokeMethod('getInstallationId');
    return version;
  }

  static void toast(String msg) async {
    try {
      Map<String, dynamic> args = {
        "msg": msg,
      };
      await _channel.invokeMethod("showToast", args);
    } on PlatformException catch (e) {
      print(e);
// batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
  }
}

class CounterModelRequest {
  String? objectId;
  String? title;
  int? status;
  String? statusString;
  String? text;
  int? time;
  bool? shouldShowRedFocusStatus;
  bool? isCountDown;
  String? focusedDuration;
  String? bgUrl;
  int? numTomatees;
  int? totalTomatees;
  int focusedDurationInt;
  int? restingDurationInt;

  CounterModelRequest({
    this.objectId = "",
    this.statusString = "",
    this.numTomatees = 0,
    this.totalTomatees = 0,
    this.focusedDuration = "",
    this.isCountDown = false,
    this.bgUrl = "",
    this.title = "",
    this.time = 0,
    this.shouldShowRedFocusStatus = false,
    this.status = 0,
    this.text = "",
    this.focusedDurationInt = 1500,
    this.restingDurationInt = 300,
  });

  Map toJson() => {
        'objectId': objectId,
        'statusString': statusString,
        'bgUrl': bgUrl,
        'numTomatees': numTomatees,
        'totalTomatees': totalTomatees,
        'focusedDuration': focusedDuration,
        'isCountDown': isCountDown,
        'time': time,
        'title': title,
        'shouldShowRedFocusStatus': shouldShowRedFocusStatus,
        'status': status,
        'text': text,
        'focusedDurationInt': focusedDurationInt,
        'restingDurationInt': restingDurationInt,
      };
}
