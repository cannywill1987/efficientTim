import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/page/calendarPage/TimeManagementPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/components/CalendarMissionListWidget.dart';

class TimeManagementContainer extends StatefulWidget {
  // int? folderStatusDate = 1; // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 6 已完成

  TimeManagementContainer({
    Key? key,
    FolderModel? folderModel,
    // this.folderStatusDate,
  }) : super(key: key) {
    // this.folderModel = folderModel ?? FolderModel();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TimeManagementContainerState();
  }
}

class _TimeManagementContainerState extends State<TimeManagementContainer> {
  bool isLeftBarVisible = true;
  GlobalKey<TimeManagementPageState> TimeManagementPageStateGlobalKey = GlobalKey();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // print("MyPage: didChangeDependencies - Page dependencies changed or opened again");
    // 每次页面打开或依赖发生变化时执行的操作
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if(isLeftBarVisible)
        Container(
          width: 300,
          child: CalendarMissionListWidget(onDateRangeSelected:(DateTime? startDateTime, DateTime? endDateTime) {
            TimeManagementPageStateGlobalKey.currentState?.selectDate(startDateTime ?? DateTime.now());
          }),
        ),
        Expanded(child: TimeManagementPage(key: TimeManagementPageStateGlobalKey, onKeyBackquoteListener: () {
          setState(() {
            isLeftBarVisible = !isLeftBarVisible;
          });
        },)),
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
