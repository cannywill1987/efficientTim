import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/page/FourQuadrant/FourQuadrantPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/TimeManagementPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/components/CalendarMissionListWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * 四象限容器
 */
class FourQuadrantContainer extends StatefulWidget {
  // int? folderStatusDate = 1; // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 6 已完成

  const FourQuadrantContainer({
    Key? key,
    FolderModel? folderModel,
    // this.folderStatusDate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FourQuadrantContainerState();
  }
}

/**
 * 四象限容器状态
 */
class _FourQuadrantContainerState extends State<FourQuadrantContainer> {
  GlobalKey<FourQuadrantPageState> TimeManagementPageStateGlobalKey =
      GlobalKey(); // 时间管理页面状态全局key
  GlobalKey<FourQuadrantPageState> FourQuadrantPageStateGlobalKey =
      GlobalKey(); // 四象限页面状态全局key
  // final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeManager.getInstance().isDark();
    return Container(
      // 四象限页左侧日历/清单栏跟随页面主背景，浅色模式保持纯白，避免和右侧白底页面割裂。
      color: isDark ? const Color(0xFF171312) : Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 300,
            child: CalendarMissionListWidget(onDateRangeSelected:
                (DateTime? startDateTime, DateTime? endDateTime) {
              TimeManagementPageStateGlobalKey.currentState?.selectDate(
                  startDateTime,
                  endDateTime == null
                      ? null
                      : Utility.getFilterDateTimeFromDateTime(
                          endDateTime!, true));
            }),
          ),
          Expanded(
              child: FourQuadrantPage(key: TimeManagementPageStateGlobalKey)),
        ],
      ),
    );

    // return Row(
    //   mainAxisSize: MainAxisSize.max,
    //   children: [
    //     Container(
    //       width: 300,
    //       child: CalendarMissionListWidget(onDateRangeSelected:
    //           (DateTime? startDateTime, DateTime? endDateTime) {
    //         TimeManagementPageStateGlobalKey.currentState?.selectDate(
    //             startDateTime,
    //             endDateTime == null
    //                 ? null
    //                 : Utility.getFilterDateTimeFromDateTime(
    //                     endDateTime!, true));
    //       }),
    //     ),
    //     Expanded(
    //         child: FourQuadrantPage(key: TimeManagementPageStateGlobalKey)),
    //   ],
    // );

    // return Selector<CalendarMssionEnv, MissionModel?>(
    //     selector: (_, env) => env.curSelectedMissionModel,
    // builder: (_, curSelectedMissionModel, __) {
    // return  Selector<CalendarMssionEnv, FolderModel?>(
    // selector: (_, env) => env.curSelectedFolderModel,
    // builder: (_, curSelectedFolderModel, __) {
    // return  Selector<CalendarMssionEnv, DateTime?>(
    // selector: (_, env) => env.startDateTime,
    // builder: (_, startDateTime, __) {
    // return  Selector<CalendarMssionEnv, DateTime?>(
    // selector: (_, env) => env.endDateTime,
    // builder: (_, endDateTime, __) {
    //   this.folderModel = curSelectedFolderModel ?? FolderModel();
    //   requestDatas(shouldUpdate: false);
    //
    // });
    // });
    // });
    // });
  }
}
