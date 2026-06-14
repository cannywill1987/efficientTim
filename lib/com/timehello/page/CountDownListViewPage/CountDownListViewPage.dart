import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/EndTimeMissionModel.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CircleWidget.dart';
import '../../config/ENUMS.dart';
import '../../util/Utility.dart';
import '../createEndTimePage/CreateEndTimePage.dart';
import 'components/CountDownListView.dart';

/**
 * 文件类型：页面
 * 文件作用：倒计时入口页，负责从全局状态读取倒计时列表并承接新增、编辑、删除和完成操作。
 * 主要职责：保持原有数据操作链路，把新版列表视觉交给 CountDownListView 和 CountdownItem 渲染。
 */
class CountDownListViewPage extends BaseWidget {
  final PageFromEnum pageFromEnum = PageFromEnum.Normal;

  const CountDownListViewPage({required PageFromEnum pageFromEnum});
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
    return _CountDownListViewPageState();
  }
}

class _CountDownListViewPageState
    extends BaseWidgetState<CountDownListViewPage> {
  List<EndTimeMissionModel>? listEndTimeMissionModel;

  void onClick(type, data) async {
    switch (type) {
      case 'onTapFinishListener':
        this.onClickFinishItem(data);
        break;
      case 'onTapUnFinishListener':
        break;
      case 'onTapEditListener':
        Utility.openPagePCAndMobile(context,
            child: CreateEndTimePage(
              missionModel: data,
            ));
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
          .delete_EndTimeMissionModel(currentObjectId: data.objectId);
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
          .finishEndTimeMissionModel(missionModel: data);
    }
  }

  @override
  void initState() {
    super.initState();
    if (this.widget.pageFromEnum == PageFromEnum.Normal) {
      //正常push
      this.isNavBackBtnVisible = true; //从首页过来
    } else {
      this.isAppBarVisible = false;
      this.isNavBackBtnVisible = false; //从首页过来
    }
  }

  @override
  baseBuild(BuildContext context) {
    // 列表数据仍来自 GlobalStateEnv，避免 UI 改版影响原有同步和排序逻辑。
    listEndTimeMissionModel =
        context.watch<GlobalStateEnv>().listEndTimeMissionModel;
    listEndTimeMissionModel =
        Utility.sortEndTimeMissionModel(listEndTimeMissionModel ?? []);
    return Stack(
      children: [
        CountDownListView(
          list: listEndTimeMissionModel ?? [],
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
                Utility.openPagePCAndMobile(context,
                    child: CreateEndTimePage());
              },
            ))
      ],
    );
  }
}
