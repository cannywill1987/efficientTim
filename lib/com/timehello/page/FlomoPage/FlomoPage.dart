import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../common/provider/Env.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../config/Params.dart';
import '../../config/StylesConfig.dart';
import '../../models/CalendarModel.dart';
import '../../models/EventFn.dart';
import '../../models/FlomoMissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/Utility.dart';
import 'FlomoCreatePage.dart';
import 'FlomoDetailPage.dart';
import 'components/ClockInSentenceDialog.dart';
import 'components/FlomoDatePagerWidget.dart';
import 'components/FlomoCircleWidget.dart';
import 'components/FlomoMissionSilverList.dart';

class FlomoPage extends BaseWidget {
  Function? onTapListener;

  FlomoPage({this.onTapListener});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return FlomoPageSate();
  }
}

class FlomoPageSate extends BaseWidgetState<FlomoPage> {
  List<FlomoMissionModel> datas = [];
  CalendarModel? calendarModel;
  DateTime curDateTime = DateTime.now();
  bool hasJump = false;
  int curDayIndex = 0;
  bool isFinished = false;
  bool isRequesting = false;
  GlobalKey<FlomoDatePagerWidgetState> flomoDatePagerWidgetStateKey =
      GlobalKey<FlomoDatePagerWidgetState>();

  initState() {
    super.initState();
  }

  componentDidMount() {
    super.componentDidMount();
    curDateTime = DateTime.now();
    requestDatas(curDateTime);
  }

  requestDatas(DateTime dateTime, {bool isRefresh = true}) {
    curDateTime = Utility.getFilterDateTimeFromTimeStamp(
        curDateTime.millisecondsSinceEpoch);
    calendarModel = context.read<GlobalStateEnv>().calendarModel;
    if (this.isFinished == false) {
      calendarModel?.dayModelList.forEach((element) {
        element.isCheck = false;
        if (element.dateTime!.isAtSameMomentAs(dateTime)) {
          datas = Utility.filterFlomoMissionModelByFinishedState(
              list: element.flomoMissionModelList, isFinished: this.isFinished);
          // datas = element.flomoMissionModelList ?? [];
        }
      });
      if ((calendarModel?.dayModelList.length ?? 0) > curDayIndex) {
        calendarModel?.dayModelList[curDayIndex].isCheck = true;
      }
    } else {
      datas = Utility.filterFlomoMissionModelByFinishedState(
          list: MongoApisManager.getInstance().listFlomoMissionModel,
          isFinished: this.isFinished);
    }
    // CounterMethodChannelManager.getInstance().storeFlomoMissionList(context);
    // datas = MongoApisManager.getInstance().listFlomoMissionModel;
    if (isRefresh) {
      this.updateUI();
    }
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // context.select((GlobalStateEnv e) => requestDatas());
    // Env env = context.watch<Env>();
    // calendarModel = Provider.of<GlobalStateEnv>(context).calendarModel;
    return Selector<GlobalStateEnv, List<FlomoMissionModel>>(
      selector: (_, globalStateEnv) => globalStateEnv.listFlomoMissionModel,
      builder: (_, listFlomoMissionModel, __) {
        requestDatas(curDateTime, isRefresh: false);
        if (hasJump == false) {
          hasJump = true;
          Future.delayed(Duration(seconds: 3), () {
            flomoDatePagerWidgetStateKey.currentState?.jumpToTodayPage();
          });
        }
        return Stack(
          children: [
            Container(
              color: ThemeManager.getInstance().getLeftMenuColor(defaultColor: ThemeManager.getInstance().getLightDefaultThemeColor()),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  FlomoDatePagerWidget(
                    key: flomoDatePagerWidgetStateKey,
                    dataModels: calendarModel?.dayModelList ?? [],
                    dataWeekModel: calendarModel?.weekModelList ?? [],
                    onTapTodayListener: (dayModel) {
                      curDayIndex =
                          calendarModel?.dayModelList.indexOf(dayModel) ?? 0;
                      this.requestDatas(curDateTime = dayModel.dateTime!);
                    },
                    onTapCheckBoxListener: (value) {
                      this.isFinished = (value != 0);
                      this.requestDatas(curDateTime);
                      if (this.isFinished == false) {
                        jumpToToday();
                      }
                    },
                    isFinished: this.isFinished,
                  ),
                  SizedBox(
                    height: this.isFinished == true ? 4 : 0,
                  ),
                  Expanded(
                      child: Container(
                          // clipBehavior: Clip.antiAlias,
                          // padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CustomScrollView(
                    slivers: buildList(),
                  )))
                ],
              ),
            ),
            Positioned(right: 20, bottom: 30, child: FlomoCircleWidget(color: ThemeManager.getInstance().getDefautThemeColor(),))
          ],
        );
      },
    );
  }

  void jumpToToday() {
    Future.delayed(Duration(seconds: 1), () {
      flomoDatePagerWidgetStateKey.currentState
          ?.jumpToTodayPage();
    });
  }

  List<Widget> buildList() {
    List<Widget> listWidget = [];
    // listWidget
    //     .add(initSliverPersistentHeader(getI18NKey().missionToBeComplete));
    listWidget.add(FlomoMissionSilverList(
      ymd: Utility.getYMD(curDateTime),
      onTapClockInListener: (data) async {
        if(isRequesting == true) {
          return;
        }
        isRequesting = true;
        await MongoApisManager.getInstance()?.update_FlomoMissionModelClocksIn(
            flomoMissionModel: data,
            ymd: Utility.getYMD(curDateTime),
            callback: () {
              updateUI();
            });
        isRequesting = false;
        if (Utility.isFlomoMissionClockInFinishedAtYMD(
                flomoMissionModel: data, ymd: Utility.getYMD(curDateTime)) ==
            true) {
          DialogManagement.showFlomoRatingDialog(
            context,
            flomoMissionModel: data,
            onSubmitted: (val) async {
              await MongoApisManager.getInstance()
                  .update_FlomoMissionModelMessage(
                      flomoMissionModel: data,
                      ymd: Utility.getYMD(curDateTime),
                      satisfaction: val['code'],
                      message: val['content']);
              DialogManagement.getInstance().hideDialog(context);
            },
          );
        }
      },
      bottomChild: Padding(
        padding: EdgeInsets.only(top: 30, left: 10, right: 10),
        child: InkWell(
          onTap: () {
            DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(context,
                child: ClockInSentenceDialog(onSubmitted: () {}));
            // Utility.openPagePCAndMobile(context, child: FlomoCreatePage());
            // this.onClick("onClickUpdate", null);
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemeManager.getInstance().getDefautThemeColor(),
              // gradient: LinearGradient(
              //     colors: ThemeManager.getInstance().getButtonLinearGradientBackgroundColor()),
            ),
            width: 260,
            height: 45,
            child: Text(
              getI18NKey().create,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
      // quadrantWidgetGlobalKey: this.widget.quadrantWidgetGlobalKey,
      onDragEndListener: (data) {
        this.onClick("onDragEndListener", data);
      },
      //未完成任务列表
      datas: datas,
      onTapEditTitleListener: (obj) {
        // this.onClick('onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
      },
      onTapPlayListener: (obj) {
        this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
      },
      onTapListener: (obj) {
        // DialogManagement.showFlomoRatingDialog(context, flomoMissionModel: obj, onSubmitted: (val) async {
        //   await MongoApisManager.getInstance().update_FlomoMissionModelMessage(flomoMissionModel: obj,  satisfaction: val['code'], message: val['content']);
        //   DialogManagement.getInstance().hideDialog(context);
        // }, );
        if (Utility.isHandsetBySize() == true) {
          Utility.pushNavigator(
              context,
              FlomoDetailPage(
                  flomoMissionModel: obj, curDateTime: curDateTime));
        } else {
          this
              .widget
              .onTapListener
              ?.call({"data": obj, "curDateTime": curDateTime});
        }
      },
      onTapDeleteListener: (data) async {
        await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.value,
                object_id: data?.objectId,
                sceneType: "mission",
                eventType: "clockin_time",
                timelineMessage: getI18NKey().delete_flomo_mission( data.title ?? "?")));

        MongoApisManager.getInstance()
            .delete_FlomoMissionModel(currentObjectId: data?.objectId);
      },
      onTapEditListener: (data) {
        // DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(context,
        //     child: ClockInSentenceDialog(onSubmitted: () {}));
        Utility.openPagePCAndMobile(context,
            child: FlomoCreatePage(
              pageModeEnum: 1,
              flomoMissionModel: data,
            ));
        this.onClick('onClickMissionSetting', data);
      },
      onTapFinishListener: (data) async {
        FlomoMissionModel missionModel = data;
        await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.value,
                object_id: data?.objectId,
                sceneType: "mission",
                eventType: "clockin_time",
                timelineMessage: getI18NKey().complete_flomo_mission( data.title ?? "?")));


        missionModel.isFinished = true;
        MongoApisManager.getInstance()
            .update_FlomoMissionModel(missionModel: missionModel);
        this.onClick('onClickFinishItem', data); //点击完成任务
      },
      curDateTime: curDateTime, onTapCancelClockInListener: (missionModel) async {
      if(isRequesting == true) {
        return;
      }
      isRequesting = true;
      await MongoApisManager.getInstance()?.update_FlomoMissionModelClocksIn(
        shouldInc: false,
          flomoMissionModel: missionModel,
          ymd: Utility.getYMD(curDateTime),
          callback: () {
            updateUI();
          });
      isRequesting = false;
    }, onTapUnfinishListener: (data) async {
      FlomoMissionModel missionModel = data;
      await MongoApisManager.getInstance()
          .insertTimelineMissionModel(
          missionModel: Utility.getTimelineMissionModelFromMissionModel(
              icon: Icons.check_circle.codePoint,
              color: Colors.greenAccent.value,
              object_id: data?.objectId,
              sceneType: "mission",
              eventType: "clockin_time",
              timelineMessage: getI18NKey().uncomplete_flomo_mission( data.title ?? "?")));


      missionModel.isFinished = false;
      MongoApisManager.getInstance()
          .update_FlomoMissionModel(missionModel: missionModel);
    },
    ));
    return listWidget;
  }
}
