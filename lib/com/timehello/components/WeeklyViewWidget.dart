import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MissionGridView.dart';

import '../common/provider/CalendarMssionEnv.dart';
import '../common/provider/GlobalStateEnv.dart';
import '../config/ColorsConfig.dart';
import '../config/ENUMS.dart';
import '../interface/OnCallbackListener.dart';
import '../libs/calendar_date_picker3/src/models/calendar_date_picker2_config.dart';
import '../libs/calendar_date_picker3/src/widgets/calendar_date_picker2.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../models/SessionMissionModel.dart';
import '../page/WrongQuestionBookPage/WQBMissionPage.dart';
import '../page/missionPage/componnents/GridMissionSilverList.dart';
import '../page/missionPage/componnents/MissionSilverList.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';
import 'GridSectionTitleWidget.dart';
import 'MoreWidget.dart';

class WeeklyViewWidget extends StatefulWidget {
  Function(DateTime?, DateTime?)? onDateRangeSelected;

  MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByWords;
  MultiSelectModeEnum multiSelectModeEnum = MultiSelectModeEnum.normal;
  int folderStatusIsArchived = 0;
  Function onClick;
  int folderStatusDate = 0;
  FolderModel folderModel = FolderModel();
  OnTapListener? onTapListener;
  // MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  Function? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function? onTapDoItNow;
  List<MissionModel> missionModelList = [];
  Function(DateTime)? onTapCreateMission;
  CalendarModel calendarModel = CalendarModel();
  WeeklyViewWidget({
    Key? key,
    required this.missionOrderEnum,
    required this.onClick,
    required this.folderModel,
    required this.multiSelectModeEnum,
    required this.missionModelList,
    this.onTapListener,
    this.onTapEditTitleListener,
    this.onTapEditListener,
    this.onTapDeleteListener,
    this.onTapFinishListener,
    this.onTapPlayListener,
    this.onTapMultiSelectListener,
    this.onTapUnFinishListener,
    this.onTapDoItNow,
    this.onTapCreateMission,
  }) : super(key: key) {
    calendarModel = Utility.initCalendarModelWithMissionList(missionModelList);
  }

  @override
  State<WeeklyViewWidget> createState() => WeeklyViewWidgetState();
}

class WeeklyViewWidgetState extends State<WeeklyViewWidget> {
  DateTime? startDateTime;
  DateTime? endDateTime;

  String getDateString(DateTime dateTime) {
    return "(" + Utility.getFormattedDate(dateTime) + ")";
  }

  @override
  Widget build(BuildContext context) {
    WeekModel currentWeek =
        findCurrentWeek(this.widget.calendarModel, dateTime: startDateTime) ?? WeekModel();
    // return Selector<GlobalStateEnv, WeekModel?>(
    //   selector: (context, globalState) {
    //     return findCurrentWeek(this.widget.calendarModel);
    //   },
    //   builder: (context, currentWeek, child) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // 第一行
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: _buildCalendarCard()), // 第一行第一列：日历
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[0],
                      Colors.redAccent,
                      getI18NKey().sunday +
                          getDateString(
                              currentWeek?.dayModelList[0]?.dateTime ??
                                  DateTime.now()))), // 第一行第二列：周日的任务列表
            ],
          ),
        ),
        // 第二行
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[1],
                      Colors.orangeAccent,
                      getI18NKey().monday +
                          getDateString(
                              currentWeek?.dayModelList[1]?.dateTime ??
                                  DateTime.now()))), // 第二行第一列：周一的任务列表
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[2],
                      Colors.yellowAccent,
                      getI18NKey().tuesday +
                          getDateString(
                              currentWeek?.dayModelList[2]?.dateTime ??
                                  DateTime.now()))), // 第二行第二列：周二的任务列表
            ],
          ),
        ),
        // 第三行
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[3],
                      Colors.greenAccent,
                      getI18NKey().wednesday +
                          getDateString(
                              currentWeek?.dayModelList[3]?.dateTime ??
                                  DateTime.now()))), // 第三行第一列：周三的任务列表
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[4],
                      Colors.blueAccent,
                      getI18NKey().thursday +
                          getDateString(
                              currentWeek?.dayModelList[4]?.dateTime ??
                                  DateTime.now()))), // 第三行第二列：周四的任务列表
            ],
          ),
        ),
        // 第四行
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[5],
                      Colors.indigoAccent,
                      getI18NKey().friday +
                          getDateString(
                              currentWeek?.dayModelList[5]?.dateTime ??
                                  DateTime.now()))), // 第四行第一列：周五的任务列表
              Expanded(
                  child: _buildTaskListCard(
                      currentWeek?.dayModelList[6],
                      Colors.purpleAccent,
                      getI18NKey().saturday +
                          getDateString(
                              currentWeek?.dayModelList[6]?.dateTime ??
                                  DateTime.now()))), // 第四行第二列：周六的任务列表
            ],
          ),
        ),
      ],
      // );
      // },
    );
  }

  /// 日历卡片组件
  Widget _buildCalendarCard() {
    return Card(
        color: Colors.teal, // 日历卡片背景色
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1)),
          // borderRadius: BorderRadius.circular(10)), // 圆角边框
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalendarDatePicker3(
                    // maxDayPickerHeight: 300,
                    config: CalendarDatePicker3Config(
                      shouldShowHeader:
                          Utility.isHandsetBySize() ? false : true,
                      shouldShowLunarDay: false,
                      controlsHeight: 40,
                      rowHeight: 24,
                      // weekdayLabels: ["111", "222", "111", "222", "111", "222", "111", "222"],
                      selectedDayHighlightColor:
                          ThemeManager.getInstance().getDefautThemeColor(),
                      todayTextStyle: TextStyle(
                          color:
                              ThemeManager.getInstance().getDefautThemeColor()),
                      calendarType: CalendarDatePicker3Type.range,
                    ),
                    value: this.startDateTime == null
                        ? []
                        : (this.startDateTime != null &&
                                this.endDateTime != null &&
                                this.startDateTime?.year ==
                                    this.endDateTime?.year &&
                                this.startDateTime?.month ==
                                    endDateTime?.month &&
                                this.startDateTime?.day ==
                                    this.endDateTime?.day)
                            ? [this.startDateTime]
                            : [this.startDateTime, this.endDateTime],
                    // value: _dates,
                    onValueChanged: (dates) {
                      if (dates.length == 1) {
                        Map<String, DateTime> currentWeekRange =
                            Utility.getCurrentThisWeekRange(
                                dates[0] ?? DateTime.now());
                        this.startDateTime = currentWeekRange['startOfWeek'];
                        this.endDateTime = currentWeekRange['endOfWeek'];
                        // DateTime dateTime = dates[0] ?? DateTime.now();

                        // this.startDateTime = dateTime;
                        // this.endDateTime = DateTime(dateTime.year, dateTime.month,
                        //     dateTime.day, 23, 59, 59);
                        // context.read<CalendarMssionEnv>().startDateTime =
                        //     this.startDateTime;
                        // context.read<CalendarMssionEnv>().endDateTime =
                        //     this.endDateTime;
                      } else if (dates.length == 2) {
                        this.startDateTime = dates[0];
                        DateTime endDateTime = dates[1] ?? DateTime.now();
                        this.endDateTime = DateTime(endDateTime!.year,
                            endDateTime!.month, endDateTime!.day, 23, 59, 59);
                        context.read<CalendarMssionEnv>().startDateTime =
                            dates[0];
                        context.read<CalendarMssionEnv>().endDateTime =
                            this.endDateTime;
                        print(dates);
                      }
                      // else {
                      //   context.read<CalendarMssionEnv>().startDateTime = null;
                      //   context.read<CalendarMssionEnv>().endDateTime = null;
                      // }
                      setState(() {

                      });
                      this
                          .widget
                          .onDateRangeSelected
                          ?.call(this.startDateTime, this.endDateTime);
                    },
                  ), // 文本标签
                ],
              ),
            ),
          ),
        ));
  }

  /// 通用的任务列表卡片组件
  Widget _buildTaskListCard(DayModel? dayModel, Color color, String weekName) {
    final tasks = dayModel?.missionModelList ?? []; // Use DayModel to get tasks
    return Card(
      // color: Colors.white, // 卡片背景色设为白色
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // 圆角背景
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 卡片顶部显示星期标签
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weekName, // 使用提供的 weekName
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    // 调用暴露的 onTapCreateMission 回调函数并传入 DayModel 的时间
                    this
                        .widget
                        .onTapCreateMission
                        ?.call(dayModel?.dateTime ?? DateTime.now());
                  },
                  child: Text(
                    getI18NKey().create, // 创建功能的文本
                    style: TextStyle(
                        color: ThemeManager.getInstance().getDefautThemeColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Expanded(
                child: CustomScrollView(
                    slivers: [...getList(dayModel?.missionModelList ?? [])]))

            // // 列表区域，列出任务项
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: tasks.length,
            //     itemBuilder: (context, index) {
            //       return TaskItem(
            //         mission: tasks[index], // Pass MissionModel to TaskItem
            //         color: color,
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> getList(List<MissionModel> datas) {
    List<Widget> listWidget = [];
    listWidget.addAll(buildListWidget(
        Utility.getListAfterOrder(
                this.widget.missionOrderEnum,
                Utility.filterMissionModelByFinishedState(
                    list: datas ?? [], isFinished: false),
                this.widget.folderModel.folderStatus ?? 0) ??
            [],
        false));
    listWidget.add(MoreWidget(
      text: getI18NKey().missionCompleted,
      // onTapListener: () {
      //   this.onTapMoreListener.call();
      // },
    ));
    listWidget.addAll(buildListWidget(
        Utility.getListAfterOrder(
                this.widget.missionOrderEnum,
                Utility.filterMissionModelByFinishedState(
                    list: datas ?? [], isFinished: true),
                this.widget.folderModel.folderStatus ?? 0) ??
            [],
        true));
    return listWidget;
  }

  List<Widget> buildListWidget(List<SessionMissionModel> list, bool isFinish) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      SessionMissionModel model = list[i];
      if ((model.datas?.length ?? 0) > 0) {
        listWidget.add(SliverToBoxAdapter(
          child: GridSectionTitleWidget(
            title: model.title ?? "",
          ),
        ));
        listWidget.add(GridMissionSilverList(
          datas: Utility.parseMissionModelsByIsFinishedAndPriority(
              model.datas ?? []),
          onTapListener: (v) {
            this.widget.onTapListener?.call(v);
          },
          onTapDoItNow: (v) {
            this.widget.onTapDoItNow?.call(v);
          },
          multiSelectModeEnum: this.widget.multiSelectModeEnum,
          onTapMultiSelectListener: (MissionModel? list) {
            this
                .widget
                .onTapMultiSelectListener
                ?.call(list, model?.datas ?? []);
          },
          //未完成任务列表
          onTapUnFinishListener: (data) {
            this.widget.onTapUnFinishListener?.call(data);
          },
          onTapEditTitleListener: (obj) {
            this.widget.onTapEditTitleListener?.call(obj);
          },
          onTapPlayListener: (obj) {
            this.widget.onTapPlayListener?.call(obj);
          },
          onTapDeleteListener: (data) async {
            this.widget.onTapDeleteListener?.call(data);
          },
          onTapEditListener: (data) {
            this.widget.onTapEditListener?.call(data);
          },
          onTapFinishListener: (data) {
            this.widget.onTapFinishListener?.call(data);
          },
        ));
      }
    }
    return listWidget;
    // return [
    //   SliverPadding(padding: EdgeInsets.only(top: 3)),
    //   SliverToBoxAdapter(
    //     child: SectionTitleWidget(
    //       title: '优先级',
    //     ),
    //   ),
    //
    // ];
  }

  void onTapCreateMission(DateTime dateTime) {
    // 在这里添加创建任务的逻辑
    print('创建任务的时间: ' + dateTime.toString());
  }
}

WeekModel? findCurrentWeek(CalendarModel calendarModel, {DateTime? dateTime}) {
  // Get the current date with time set to midnight
  DateTime currentDate = dateTime??DateTime.now();
  currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

  // Find the current week
  for (WeekModel week in calendarModel.weekModelList) {
    if (week.dayModelList
        .any((day) => day.dateTime?.isAtSameMomentAs(currentDate) ?? false)) {
      return week; // Return the found WeekModel
    }
  }

  return null; // Return null if no week is found
}

void displayCurrentWeekMissionTitles(CalendarModel calendarModel) {
  WeekModel? currentWeek = findCurrentWeek(calendarModel);

  if (currentWeek != null) {
    // Iterate over each DayModel in the current week
    for (DayModel day in currentWeek.dayModelList) {
      // Iterate over each MissionModel in the DayModel
      for (MissionModel mission in day.missionModelList) {
        // Display the title of the MissionModel
        print(mission.title);
      }
    }
  } else {
    print("No missions found for the current week.");
  }
}
