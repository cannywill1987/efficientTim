import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/RankingListWidget.dart';
import 'package:time_hello/com/timehello/page/statisticPage/pages/SubStatisticPage.dart';
import 'package:time_hello/com/timehello/page/statisticPage/pages/SummaryPage.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomMarquee.dart';
import '../../models/TimelineMissionModel.dart';
import '../../util/ThemeManager.dart';
import 'components/StatisticTabbarButtonListWidget.dart';

class StatisticPage extends BaseWidget {

  const StatisticPage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _StatisticPageWidgetState();
  }
}

class _StatisticPageWidgetState<T> extends BaseWidgetState<StatisticPage> {
  int curIndex = 0;
  List<TimelineMissionModel>? list;
  @override
  void onCreate() {
    super.onCreate();
    curPage = "StatisticPage";
  }

  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
    // nineLotteryController = null;
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<EventFn>().listen((EventFn event) {
      /**
       * 完成任务更新这里
       */
      if (event.type == Params.ACTION_FINISH_MISSIONMODEL_DETAIL) {}
    });

    this.isAppBarVisible = false;
    isNavBackBtnVisible = false;
    requestDatas(1);
  }

  // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
  void requestDatas(int segmentControl) {
    this.updateUI();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSegmentControl':
        break;
      case 'onClickPCValueType':
        break;
    }
  }

  Widget baseBuild(BuildContext context) {
    list = context.watch<GlobalStateEnv>().listTimelineMissionModel;

    return Container(
        color: ThemeManager.getInstance().getBackgroundColor(defaultColor: ColorsConfig.chartBgColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomMarquee(
              bean: MarqueInfo.marqueStatispage,
            ),
            StatisticTabbarButtonListWidget(
              list: CONSTANTS.getStatsDateButtonList(),
              onTapListener: (obj) {
                curIndex = obj["index"];
                Future.delayed(Duration(milliseconds: 100), () {
                  updateUI();
                });
              },
            ),
            Expanded(
              child: getWidget(),
            ),
          ],
        ));
  }

  Widget getWidget() {
    ///帧布局结合透明布局
    return Stack(
      children: <Widget>[
        Offstage(
          key: ValueKey('Offstage1'),
          offstage: curIndex == 0 ? false : true,
          child: SummaryPage(key: ValueKey('SummaryPage'),),
        ),
        Offstage(
          key: ValueKey('Offstage2'),
          offstage: curIndex == 1 ? false : true,
          child: SingleChildScrollView(child: RankingListWidget(key: ValueKey('RankingListWidget'),)),
        ),
        Offstage(
          key: ValueKey('Offstage3'),
          offstage: curIndex == 2 ? false : true,
          child: const SubStatisticPage(key: ValueKey('SubStatisticPage'),),
        ),
      ],
    );
  }
}
