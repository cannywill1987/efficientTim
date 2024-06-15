import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/page/FourQuadrant/FourQuadrantPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/TimeManagementPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/components/CalendarMissionListWidget.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

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

class _FourQuadrantContainerState extends State<FourQuadrantContainer> {

  GlobalKey<FourQuadrantPageState> TimeManagementPageStateGlobalKey = GlobalKey();
  // final CalendarController _calendarController = CalendarController();


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 300,
          child: CalendarMissionListWidget(onDateRangeSelected:(DateTime? startDateTime, DateTime? endDateTime) {
            TimeManagementPageStateGlobalKey.currentState?.selectDate(startDateTime, endDateTime == null ? null : Utility.getFilterDateTimeFromDateTime(endDateTime!, true));
          }),
        ),
        Expanded(child: FourQuadrantPage(key: TimeManagementPageStateGlobalKey)),
      ],
    );
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
