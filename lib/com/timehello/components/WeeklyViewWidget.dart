/// 文件类型：周视图组件。
/// 文件作用：在任务页中按一周维度展示日历与每天的任务列表。
/// 主要职责：根据当前选择日期聚合周数据，提供创建、编辑、完成和查看任务的入口。
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';

import '../common/provider/CalendarMssionEnv.dart';
import '../config/ENUMS.dart';
import '../interface/OnCallbackListener.dart';
import '../libs/calendar_date_picker3/src/models/calendar_date_picker2_config.dart';
import '../libs/calendar_date_picker3/src/widgets/calendar_date_picker2.dart';
import '../models/SessionMissionModel.dart';
import '../page/missionPage/componnents/GridMissionSilverList.dart';
import '../page/missionPage/componnents/MissionSilverList.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';
import 'GridSectionTitleWidget.dart';

// ignore: must_be_immutable
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
    final WeekModel currentWeek =
        findCurrentWeek(this.widget.calendarModel, dateTime: startDateTime) ??
            WeekModel();

    // 周视图需要沿用提交前的四行两列布局：每一行用 Expanded 均分父容器高度，
    // 避免 GridView 按宽高比计算出过矮的卡片，导致桌面端内容区被压扁。
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: _buildCalendarCard()),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 0),
                  const Color(0xFFFF5656),
                  getI18NKey().sunday +
                      getDateString(_getDayModel(currentWeek, 0)?.dateTime ??
                          DateTime.now()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 1),
                  const Color(0xFFFF9326),
                  getI18NKey().monday +
                      getDateString(_getDayModel(currentWeek, 1)?.dateTime ??
                          DateTime.now()),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 2),
                  const Color(0xFFE8D900),
                  getI18NKey().tuesday +
                      getDateString(_getDayModel(currentWeek, 2)?.dateTime ??
                          DateTime.now()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 3),
                  const Color(0xFF33CE7B),
                  getI18NKey().wednesday +
                      getDateString(_getDayModel(currentWeek, 3)?.dateTime ??
                          DateTime.now()),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 4),
                  const Color(0xFF4F86FF),
                  getI18NKey().thursday +
                      getDateString(_getDayModel(currentWeek, 4)?.dateTime ??
                          DateTime.now()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 5),
                  const Color(0xFF6366F1),
                  getI18NKey().friday +
                      getDateString(_getDayModel(currentWeek, 5)?.dateTime ??
                          DateTime.now()),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTaskListCard(
                  _getDayModel(currentWeek, 6),
                  const Color(0xFFE044F5),
                  getI18NKey().saturday +
                      getDateString(_getDayModel(currentWeek, 6)?.dateTime ??
                          DateTime.now()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 安全读取一周中的某一天，避免日历数据初始化不完整时周视图直接越界。
  DayModel? _getDayModel(WeekModel weekModel, int index) {
    if (index < 0 || index >= weekModel.dayModelList.length) {
      return null;
    }
    return weekModel.dayModelList[index];
  }

  /// 日历卡片组件
  Widget _buildCalendarCard() {
    // Row 只会给子组件最大高度约束，日历内部 Stack 会按内容收缩；这里强制撑满网格单元高度。
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF008A7E),
              Color(0xFF0A9D8F),
              Color(0xFF06796F),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF006F65).withValues(alpha: 0.20),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                right: -34,
                top: -42,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const double controlsHeight = 32;
                    final double availableHeight = constraints.maxHeight;
                    // CalendarDatePicker3 的日期网格是“星期标题 + 6 行日期”，所以用 7 等分填满内部高度。
                    final double rowHeight =
                        ((availableHeight - controlsHeight) / 7)
                            .clamp(22.0, 48.0)
                            .toDouble();

                    return CalendarDatePicker3(
                      config: CalendarDatePicker3Config(
                        shouldShowHeader: !Utility.isHandsetBySize(),
                        shouldShowLunarDay: false,
                        controlsHeight: controlsHeight,
                        rowHeight: rowHeight,
                        controlsTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        lastMonthIcon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        nextMonthIcon: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        weekdayLabelTextStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                        dayTextStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        selectedDayTextStyle: const TextStyle(
                          color: Color(0xFF17352F),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                        selectedRangeDayTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        disabledDayTextStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                        ),
                        selectedDayHighlightColor: const Color(0xFFDDF082),
                        selectedRangeHighlightColor:
                            Colors.white.withValues(alpha: 0.13),
                        todayTextStyle: const TextStyle(
                          color: Color(0xFFDDF082),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                        dayBorderRadius: BorderRadius.circular(18),
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
                      onValueChanged: (dates) {
                        if (dates.length == 1) {
                          // 单击某一天时自动扩展为整周，周视图始终保持完整的一周上下文。
                          Map<String, DateTime> currentWeekRange =
                              Utility.getCurrentThisWeekRange(
                                  dates[0] ?? DateTime.now());
                          this.startDateTime = currentWeekRange['startOfWeek'];
                          this.endDateTime = currentWeekRange['endOfWeek'];
                        } else if (dates.length == 2) {
                          this.startDateTime = dates[0];
                          DateTime endDateTime = dates[1] ?? DateTime.now();
                          this.endDateTime = DateTime(endDateTime.year,
                              endDateTime.month, endDateTime.day, 23, 59, 59);
                          context.read<CalendarMssionEnv>().startDateTime =
                              dates[0];
                          context.read<CalendarMssionEnv>().endDateTime =
                              this.endDateTime;
                          print(dates);
                        }
                        setState(() {});
                        this
                            .widget
                            .onDateRangeSelected
                            ?.call(this.startDateTime, this.endDateTime);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 通用的任务列表卡片组件
  Widget _buildTaskListCard(DayModel? dayModel, Color color, String weekName) {
    final List<MissionModel> tasks = dayModel?.missionModelList ?? [];
    final int unfinishedCount = Utility.filterMissionModelByFinishedState(
            list: tasks, isFinished: false)
        .length;
    final Color cardColor = ThemeManager.getInstance()
        .getCardBackgroundColor(defaultColor: Colors.white);
    final Color mutedTextColor = ThemeManager.getInstance()
        .getTextColor(defaultColor: const Color(0xFF9B928B));

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.13),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 卡片头部同时展示日期、未完成数量和创建入口，让周计划信息密度更高。
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          weekName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (unfinishedCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$unfinishedCount',
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    // 调用暴露的 onTapCreateMission 回调函数并传入 DayModel 的时间
                    this
                        .widget
                        .onTapCreateMission
                        ?.call(dayModel?.dateTime ?? DateTime.now());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: ThemeManager.getInstance()
                          .getDefautThemeColor()
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 14,
                          color:
                              ThemeManager.getInstance().getDefautThemeColor(),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          getI18NKey().create,
                          style: TextStyle(
                            color: ThemeManager.getInstance()
                                .getDefautThemeColor(),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState(color, mutedTextColor)
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        ...getList(tasks),
                      ],
                    ),
            ),

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

  /// 空任务状态：只给轻量提示，避免空卡片里出现突兀的大块居中内容。
  Widget _buildEmptyState(Color accentColor, Color textColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.task_alt_rounded,
              size: 18,
              color: accentColor.withValues(alpha: 0.30),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            getI18NKey().missionCompleted,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.72),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getList(List<MissionModel> datas) {
    List<Widget> listWidget = [];
    final List<SessionMissionModel> unfinishedList = Utility.getListAfterOrder(
          this.widget.missionOrderEnum,
          Utility.filterMissionModelByFinishedState(
              list: datas, isFinished: false),
          this.widget.folderModel.folderStatus ?? 0,
        ) ??
        [];
    final List<SessionMissionModel> finishedList = Utility.getListAfterOrder(
          this.widget.missionOrderEnum,
          Utility.filterMissionModelByFinishedState(
              list: datas, isFinished: true),
          this.widget.folderModel.folderStatus ?? 0,
        ) ??
        [];

    listWidget.addAll(buildListWidget(unfinishedList, false));
    if (_hasSessionMission(finishedList)) {
      listWidget.add(_buildCompletedDivider());
      listWidget.addAll(buildListWidget(finishedList, true));
    }
    return listWidget;
  }

  /// 判断分组后的任务数据里是否真的存在任务，避免空分组也显示完成分割线。
  bool _hasSessionMission(List<SessionMissionModel> list) {
    return list.any((model) => (model.datas?.length ?? 0) > 0);
  }

  /// 已完成任务分割线：比原来的胶囊提示更轻，不抢未完成任务的视觉焦点。
  Widget _buildCompletedDivider() {
    final Color lineColor = ThemeManager.getInstance()
        .getTextColor(defaultColor: const Color(0xFFE7DDD5))
        .withValues(alpha: 0.70);
    final Color textColor = ThemeManager.getInstance()
        .getTextColor(defaultColor: const Color(0xFF9B928B));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Container(height: 1, color: lineColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                getI18NKey().missionCompleted,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: lineColor)),
          ],
        ),
      ),
    );
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
            this.widget.onTapMultiSelectListener?.call(list, model.datas ?? []);
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
  DateTime currentDate = dateTime ?? DateTime.now();
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
