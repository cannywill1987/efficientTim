import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/StartTimeMissionModel.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CircleWidget.dart';
import '../../config/ENUMS.dart';
import '../../util/DialogManagement.dart';
import '../../util/Utility.dart';
import '../createStartTimePage/CreateStartTimePage.dart';
import 'components/CountUpListView.dart';
import 'models/Countup.dart';

class CountUpListViewPage extends BaseWidget {
  final PageFromEnum pageFromEnum = PageFromEnum.Normal;

  const CountUpListViewPage({required PageFromEnum pageFromEnum});
  // {
  //   // if(pageFromEnum == null) {
  //   //   this.pageFromEnum = PageFromEnum.Normal;
  //   // } else {
  //   //   this.pageFromEnum = pageFromEnum;
  //   // }
  // }

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _CountUpListViewPageState();
  }
}

class _CountUpListViewPageState extends BaseWidgetState<CountUpListViewPage> {
  List<StartTimeMissionModel>? listStartTimeMissionModel;

  void onClick(type, data) async {
    switch(type) {
      case 'onTapFinishListener':
        this.onClickFinishItem(data);
        break;
      case 'onTapUnFinishListener':
        break;
      case 'onTapEditListener':
        Utility.openPagePCAndMobile(context, child:CreateStartTimePage(missionModel: data,));
        break;
      case 'onTapDeleteListener':
        this.onClickDeleteItem(data);
        break;
      case 'onTapListener':
        break;
    }
  }

  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(data) async {
    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().delete,
        message: getI18NKey().confirmToDelete,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      await MongoApisManager.getInstance()
          .delete_StartTimeMissionModel(currentObjectId: data.objectId);
    }
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(data) async {
    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().confirmToFinished,
        message: getI18NKey().confirmToFinishMission,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      await MongoApisManager.getInstance()
          .finishStartTimeMissionModel(missionModel: data);
    }
  }

  @override
  void initState() {
    super.initState();
    if(this.widget.pageFromEnum == PageFromEnum.Normal) { //正常push
      this.isNavBackBtnVisible = true; //从首页过来
    } else {
      this.isAppBarVisible = false;
      this.isNavBackBtnVisible = false; //从首页过来
    }
  }

  @override
  baseBuild(BuildContext context) {
    listStartTimeMissionModel =
        context.watch<GlobalStateEnv>().listStartTimeMissionModel;
    listStartTimeMissionModel = Utility.sortStartTimeMissionModel(listStartTimeMissionModel ?? []);
    return  Stack(
        children: [
          CountUpListView(
            list: listStartTimeMissionModel ?? [],
            onTapFinishListener: (data) {
                this.onClick("onTapFinishListener", data);
            },
            onTapUnFinishListener: (data) {
              this.onClick("onTapUnFinishListener", data);
            },
            onTapEditListener: (data) {
              this.onClick("onTapEditListener", data);
            },
            onTapDeleteListener: (data) {
              this.onClick("onTapDeleteListener", data);
            },
            onTapListener: (data) {
              this.onClick("onTapListener", data);
            },
          ),
          Positioned(
              bottom: 30,
              right: 20,
              child: CircleWidget(
                onTapListener: (obj) {
                  Utility.openPagePCAndMobile(context, child:CreateStartTimePage());
                },
              ))
        ],
    );
  }
} 