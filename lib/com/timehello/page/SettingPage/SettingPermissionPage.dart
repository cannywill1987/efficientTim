import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/SectionHeaderWidget.dart';
import 'package:time_hello/com/timehello/components/SettingMenuItem.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';
import '../UnregisterPage/UnregisterPage.dart';

/**
 * 设置页面
 */
class SettingPermissionPage extends BaseWidget {
  PageFromEnum pageFrom = PageFromEnum.Normal;

  SettingPermissionPage({this.pageFrom = PageFromEnum.Normal});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SettingPermissionPageWidgetState();
  }
}

class _SettingPermissionPageWidgetState<T>
    extends BaseWidgetState<SettingPermissionPage> {
  bool isNotificationOn = false;
  bool? aliPushOn;
  Timer? _timer;
  int _countdownTime = 50;

  _SettingPermissionPageWidgetState() {}

  @override
  void onCreate() {
    super.onCreate();
    curPage = "SettingPermissionPage";
  }

  @override
  void initState() {
    this.requestNotificationStatus();
    this.requestAlipushOn();

    CounterMethodChannelManager.getInstance().addOnRequestFinishListener(
        onMethodChannelResponseLisntener: (String method, Map arguments, MethodChannel channel) {
      switch (method) {
        case "settingResult":
          requestNotificationStatus();
          break;
      }
    });
  }

  void requestNotificationStatus() async {
    BaseBean res =
        await CounterMethodChannelManager.getInstance().isNotificationEnabled();
    bool isNotificationOn = res.data;
    if (this.isNotificationOn != isNotificationOn) {
      this.isNotificationOn = isNotificationOn;
      if(_timer != null) {
        _timer?.cancel();
      }
    }
    updateUI();
  }

  void requestAlipushOn() async {
    bool aliPushOn = SharePreferenceUtil.getSyncInstance().getAlipushOn();
    if (this.aliPushOn != aliPushOn) {
      this.aliPushOn = aliPushOn;
    }
    updateUI();
  }

  @override
  void didUpdateWidget(SettingPermissionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    requestNotificationStatus();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickAlipushOn':
        this.onClickAlipushOn(context);
        break;
      case "onClickUnregisterAccount":
        this.onClickUnregisterAccount();
        break;
    }
  }

  Future onClickUnregisterAccount() async {
    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey(context).unregister_title,
        message: getI18NKey(context).unregister_content,
        okLabel: getI18NKey(context).confirm_unregister,
        cancelLabel: getI18NKey(context).consider_it,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      Utility.openPagePCAndMobile(context, child: UnregisterPage());
      // DialogManagement.getInstance()?.showMsnDialog(context, title: getI18NKey().account_unregister, okCallback: (data) async {
      //   String dynamicCode = data['msn'];
      //   String password = data['password']; //已经加密
      //   BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
      //     Apis.unregisterAccount,
      //     context: context,
      //     params: {"scene": Params.MSN_UNREGISTER_SCENE, "dynamicCode": dynamicCode, "password": password},
      //   );
      //   if(baseBean.success == true) {
      //     MongoApisManager.getInstance().batchDelete_FolderModel(
      //         listParam: MongoApisManager
      //             .getInstance()
      //             .listFolderModels);
      //     MongoApisManager.getInstance().batchDelete_MissionModel(
      //         listParam: MongoApisManager
      //             .getInstance()
      //             .listMissionModels);
      //     MongoApisManager.getInstance().batchDelete_StatisticModel(
      //         listParam: MongoApisManager
      //             .getInstance()
      //             .listStatsModels);
      //     MongoApisManager.getInstance().batchdelete_TimelineMissionModel(
      //         listParam: MongoApisManager
      //             .getInstance()
      //             .listTimelineMissionModel);
      //     LoginManager.getInstance().logout(context);
      //   }
      // });

    }
  }


  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  void deactivate() {}

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                child: getPermissionSettingWidget(context))),
      ],
    );
  }

  Column getPermissionSettingWidget(BuildContext context) {
    return Column(children: [
      SectionHeaderWidget(
        title: getI18NKey().setting,
      ),
      SettingMenuItem(
        title: getI18NKey().notification_setting,
        description: getI18NKey().notification_setting_content,
        onTapListener: (data) async {
          await CounterMethodChannelManager.getInstance().openSetting();
          if (Utility.isIOS() == true) {
            startCountdownTimer();
          }
        },
        // icon: Icon(Icons.music_note_outlined,
        //     color: ColorsConfig.gray_a3_icon),
        rightPartContainer: CheckImage(
          checked: this.isNotificationOn,
          checkIcon: Icon(Icons.check_box),
          uncheckIcon: Icon(Icons.check_box_outline_blank),
        ),
      ),
      // SettingMenuItem(
      //   title: getI18NKey().is_push_setting,
      //   description: getI18NKey().is_push_setting_detail,
      //   onTapListener: (data) async {
      //     this.onClick('onClickAlipushOn', data);
      //     // await onClickAlipushOn(context);
      //   },
      //   // icon: Icon(Icons.music_note_outlined,
      //   //     color: ColorsConfig.gray_a3_icon),
      //   rightPartContainer: CheckImage(
      //     checked: this.aliPushOn ?? false,
      //     checkIcon: Icon(Icons.check_box),
      //     uncheckIcon: Icon(Icons.check_box_outline_blank),
      //   ),
      // ),
      SettingMenuItem(
          title: getI18NKey().unregister_account,
          onTapListener: (data) {
            this.onClick('onClickUnregisterAccount', null);
          }),
    ]);
  }

  void startCountdownTimer() {
    if(_timer!= null) {
      _timer?.cancel();
    }
    _countdownTime = 120;
    const oneSec = const Duration(seconds: 5);

    var callback = (timer) => {
          if (_timer != null && mounted)
            {
              setState(() {
                requestNotificationStatus();
                if (_countdownTime < 2) {
                  _timer?.cancel();
                  _timer = null;
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            }
        };

    _timer = Timer.periodic(oneSec, callback);
  }

  Future<void> onClickAlipushOn(BuildContext context) async {
    if (this.aliPushOn == false) {
      BaseBean baseBean =
          await CounterMethodChannelManager.getInstance().turnOnPushChannel();
      if (baseBean.success == true) {
        SharePreferenceUtil.getSyncInstance().setAlipushOn(isOn: true);
        this.aliPushOn = SharePreferenceUtil.getSyncInstance().getAlipushOn();
        updateUI();
      } else {
        Utility.showToast(context: context, msg: getI18NKey().setting_fail);
      }
    } else if (this.aliPushOn == true) {
      BaseBean baseBean =
          await CounterMethodChannelManager.getInstance().turnOffPushChannel();
      if (baseBean.success == true) {
        SharePreferenceUtil.getSyncInstance().setAlipushOn(isOn: false);
        this.aliPushOn = SharePreferenceUtil.getSyncInstance().getAlipushOn();
        updateUI();
      } else {
        Utility.showToast(context: context, msg: getI18NKey().setting_fail);
      }
    }
  }
}
