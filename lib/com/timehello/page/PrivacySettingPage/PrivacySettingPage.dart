import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:synchronized/extension.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/PCSettingTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/SectionHeaderWidget.dart';
import 'package:time_hello/com/timehello/components/SelectMinutesDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectMusicDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SettingMenuItem.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/util/AudioPlayUtil.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../beans/BaseBean.dart';
import '../../beans/ResourceLocationInfoBean.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../components/NavMenuItem.dart';
import '../../components/SelectMoneySettingDialogUtil.dart';
import '../../components/SelectPresentDialogUtil.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../util/CounterManagement.dart';
import '../../util/EasyLoadingManager.dart';
import '../../util/GetResourceDeliveryManager.dart';
import '../../util/OverlayManagement.dart';
import '../WebviewPage/WebviewPage.dart';
import 'components/PCAccountWidget.dart';

/**
 * 设置页面
 */
class PrivacySettingPage extends BaseWidget {
  PageFromEnum pageFrom = PageFromEnum.Normal;

  PrivacySettingPage({this.pageFrom = PageFromEnum.Normal});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _PrivacySettingPageWidgetState();
  }
}

class _PrivacySettingPageWidgetState<T> extends BaseWidgetState<PrivacySettingPage> {
  _PrivacySettingPageWidgetState() {}

  @override
  void onCreate() {
    super.onCreate();
    curPage = "Privacy Page";
  }

  @override
  void initState() {
  }

  void onClick(type, data) async {
    switch (type) {
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
        DialogManagement.getInstance().showMsnDialog(context, title: getI18NKey().account_unregister, okCallback: (data) async {
          String dynamicCode = data['msn'];
          String password = data['password']; //已经加密
          BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
            Apis.unregisterAccount,
            context: context,
            params: {"scene": Params.MSN_UNREGISTER_SCENE, "dynamicCode": dynamicCode, "password": password},
          );
          if(baseBean.success == true) {
            MongoApisManager.getInstance().batchDelete_FolderModel(
                listParam: MongoApisManager
                    .getInstance()
                    .listFolderModels);
            MongoApisManager.getInstance().batchDelete_MissionModel(
                listParam: MongoApisManager
                    .getInstance()
                    .listMissionModels);
            MongoApisManager.getInstance().batchDelete_StatisticModel(
                listParam: MongoApisManager
                    .getInstance()
                    .listStatsModels);
            MongoApisManager.getInstance().batchdelete_TimelineMissionModel(
                listParam: MongoApisManager
                    .getInstance()
                    .listTimelineMissionModel);
            MongoApisManager.getInstance().batchdelete_FlomoMissionModel(
                listParam: MongoApisManager
                    .getInstance()
                    .listFlomoMissionModel);

            LoginManager.getInstance().logout(context);
          }
        });

    }
  }

  @override
  void dispose() {
    super.dispose();
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
                child: Column(children: [
                  NavMenuItem(
                      title: getI18NKey().cloud_sync,
                      onTapListener: () async {
                        EasyLoadingManager.getInstance().showLoading();
                        await Future.wait([
                          MongoApisManager.getInstance().batchUpdate_FolderModelSync(),
                          MongoApisManager.getInstance().batchUpdate_MissionModelSync()
                        ]).then((value) {
                          // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
                          // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
                        });
                        EasyLoadingManager.getInstance().hideLoading();
                        // Utility.pushNavigator(context, WebviewPage(title: getI18NKey().privacy_protocol_title, url: Utility.getPrivacyProtocolUrl(),));
                        // this.onClick('onClickUnregisterAccount', null);
                      }),
                  NavMenuItem(
                      title: getI18NKey().privacy_protocol_title,
                      onTapListener: () {
                        Utility.openWebViewLaunch(context: context, title: getI18NKey().privacy_protocol_title, url: Utility.getPrivacyProtocolUrl());
                        // Utility.pushNavigator(context, WebviewPage(title: getI18NKey().privacy_protocol_title, url: Utility.getPrivacyProtocolUrl(),));
                        // this.onClick('onClickUnregisterAccount', null);
                      }),
                ],))),
      ],
    );
  }

  Widget getLogoutItem({Function? onTapListener}) {
    return InkWell(
      onTap: () {
        if (onTapListener != null) {
          onTapListener();
        }
      },
      child: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              getI18NKey().logout,
              style: TextStyle(color: Colors.red),
            ),
          )),
    );
  }
}
