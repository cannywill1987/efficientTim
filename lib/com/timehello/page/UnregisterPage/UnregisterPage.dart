import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../beans/BaseBean.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../components/MSNWidget.dart';
import '../../config/Params.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';

/**
 * 注销账号
 */
class UnregisterPage extends BaseWidget {

  @override
  UnregisterPageState getState() {
    // TODO: implement getState
    // throw UnimplementedError();
    return UnregisterPageState();
  }
}

class UnregisterPageState extends BaseWidgetState<UnregisterPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.title = getI18NKey().unregister;
  }

  Future onClickUnregisterAccount(data) async {
    String dynamicCode = data['msn'];
    String password = data['password']; //已经加密
    BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
      Apis.unregisterAccount,
      context: context,
      params: {
        "scene": Params.MSN_UNREGISTER_SCENE,
        "dynamicCode": dynamicCode,
        "password": password
      },
    );
    if (baseBean.success == true) {
      MongoApisManager.getInstance().batchDelete_FolderModel(
          listParam: MongoApisManager
              .getInstance()
              .listFolderModels);
      MongoApisManager.getInstance().batchDelete_MissionModel(
          listParam: MongoApisManager
              .getInstance()
              .listMissionModels);
      MongoApisManager.getInstance().batchdelete_EndTimeMissionModel(listParam: MongoApisManager
              .getInstance().listEndTimeMissionModels);
      MongoApisManager.getInstance().batchdelete_FlomoMissionModel(listParam: MongoApisManager
          .getInstance().listFlomoMissionModel);
      MongoApisManager.getInstance().batchDelete_PresentModel(listParam: MongoApisManager
          .getInstance().listPresentModel);
      MongoApisManager.getInstance().batchdelete_TimelineMissionModel(listParam: MongoApisManager
          .getInstance().listTimelineMissionModel);
      MongoApisManager.getInstance().batchDelete_WQBMissionModel(listParam: MongoApisManager
          .getInstance().listWQBMissionModel);
      MongoApisManager.getInstance().batchDelete_WQBFolderModel(listParam: MongoApisManager
          .getInstance().listWQBFolderModel);
      MongoApisManager.getInstance().batchDelete_EventCollectionModel(listParam: MongoApisManager.getInstance().listEventCollectionModel);

      MongoApisManager.getInstance().batchDelete_StatisticModel(
          listParam: MongoApisManager
              .getInstance()
              .listStatsModels);
      // MongoApisManager.getInstance().batchdelete_TimelineMissionModel(
      //     listParam: MongoApisManager
      //         .getInstance()
      //         .listTimelineMissionModel);
      LoginManager.getInstance().logout(context);
    };

    // OkCancelResult result = await showOkCancelAlertDialog(
    //     context: context,
    //     title: getI18NKey(context).unregister_title,
    //     message: getI18NKey(context).unregister_content,
    //     okLabel: getI18NKey(context).confirm_unregister,
    //     cancelLabel: getI18NKey(context).consider_it,
    //     onWillPop: () async {
    //       //点击对话框外围黑色区域才会走这里
    //       return true;
    //     });
    // if (result == OkCancelResult.ok) {
    //   DialogManagement.getInstance()?.showMsnDialog(
    //       context, title: getI18NKey().account_unregister,
    //       okCallback: (data) async {
    //
    //       });
    // }
  }

  baseBuild(context) {
    return Column(
      children: [
        // Text(
        //   getI18NKey().unregister,
        //   style: TextStyle(
        //       fontSize: 16,
        //       decoration: TextDecoration.none,
        //       fontWeight: FontWeight.bold),
        // ),
        SizedBox(
          height: 30,
        ),
        MSNWidget(
          onTapListener: (data) {
            this.onClickUnregisterAccount(data);
          },
        ),
      ],
    );
  }
  // @override
  // BaseWidgetState<BaseWidget> getState() {
  //
  // }
}