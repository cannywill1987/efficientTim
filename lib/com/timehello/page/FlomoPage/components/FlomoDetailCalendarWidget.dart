import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../components/CustomPainterCircleProgressWidget.dart';
import '../../../util/Utility.dart';
import 'FlomoDetailResponsiveLayout.dart';

/**
 * 文件类型：组件
 * 文件作用：展示单个习惯任务的月度打卡日历。
 * 主要职责：用 PageView 承载月份切换，并在每一天上展示完成状态、当日进度和点击打卡入口。
 */
class FlomoDetailCalendarWidget extends StatefulWidget {
  // final List<DateTime> monthDates;
  final FlomoMissionModel? flomoMissionModel;
  final ValueChanged<DateTime>? onMonthChanged;
  final ValueChanged<DayModel>? onTapListener;
  final CalendarModel calendarModel;
  final PageController pageController;

  // Function? onMonthChanged;
  final double maxWidth;

  FlomoDetailCalendarWidget(
      {this.onTapListener,
      this.flomoMissionModel,
      this.onMonthChanged,
      required this.calendarModel,
      required this.pageController,
      this.maxWidth = double.infinity});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FlomoDetailCalendarWidgetState();
  }
}

class FlomoDetailCalendarWidgetState extends State<FlomoDetailCalendarWidget> {
  /**
   * 功能：构建月历 PageView。
   * 说明：右侧详情页改成宽屏仪表盘后，日历要跟随父容器伸展，而不是固定 400 宽。
   */
  @override
  Widget build(BuildContext context) {
    //使用page view支持FlomoDetailCalendarWidgetItem左右滑动
    return Column(
      children: [
        Container(
            height: 50,
            constraints: BoxConstraints(
              maxWidth: this.widget.maxWidth,
            ),
            child: FlomoDetailCalendarWidgetItemHeader()),
        Container(
          height: 360,
          constraints: BoxConstraints(
            maxWidth: this.widget.maxWidth,
          ),
          child: PageView.builder(
            controller: this.widget.pageController,
            onPageChanged: (int page) {
              this.widget.onMonthChanged?.call(
                  this.widget.calendarModel.monthModelList[page].dateTime ??
                      DateTime.now());
              // setState(() {
              //   _currentPage = page;
              // });
            },
            itemCount: this.widget.calendarModel.monthModelList.length,
            itemBuilder: (context, index) {
              return FlomoDetailCalendarWidgetItem(
                  flomoMissionModel: this.widget.flomoMissionModel,
                  onTapListener: this.widget.onTapListener,
                  monthModel: this.widget.calendarModel.monthModelList[index]);
            },
          ),
        ),
      ],
    );
  }
}

class FlomoDetailCalendarWidgetItemHeader extends StatelessWidget {
  final List<String> dateList = [
    getI18NKey().mondayShort,
    getI18NKey().tuesdayShort,
    getI18NKey().wednesdayShort,
    getI18NKey().thursdayShort,
    getI18NKey().fridayShort,
    getI18NKey().saturdayShort,
    getI18NKey().sundayShort
  ];

  @override
  Widget build(BuildContext context) {
    // 星期栏只需要一行等分布局，不能使用默认 Grid 方格，否则宽屏时文字会被 1:1 单元格挤出可视区域。
    return Row(
      children: List.generate(dateList.length, (index) {
        return Expanded(
          child: Center(
            child: Text(
              dateList[index],
              style: TextStyle(
                color: (index == 5 || index == 6)
                    ? Color(ThemeManager.getInstance().getDefautThemeColorInt())
                    : ThemeManager.getInstance()
                        .getTextColor(defaultColor: Color(0xFF333333)),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class FlomoDetailCalendarWidgetItem extends StatelessWidget {
  final MonthModel monthModel;
  late final List<DateTime> monthDates;
  late final int deltaWeekDay;
  final ValueChanged<DayModel>? onTapListener;
  final FlomoMissionModel? flomoMissionModel;

  FlomoDetailCalendarWidgetItem(
      {this.flomoMissionModel, required this.monthModel, this.onTapListener}) {
    bool hasFirstDay = false;
    int weekDay = 0;
    List l = monthModel.dayModelList.map((e) {
      if (!hasFirstDay) {
        weekDay = e.dateTime?.weekday ?? 0;
        hasFirstDay = true;
      }
      return e.dateTime;
    }).toList();
    deltaWeekDay = weekDay;
    monthDates = l.cast<DateTime>();
    for (int i = 0; i < weekDay - 1; i++) {
      monthDates.insert(0, DateTime(0, 0, 0));
    }
  }

  /**
   * 功能：构建某个月的 7 列日期格。
   * 说明：每个日期内容居中放置，避免宽屏日历单元格变宽后日期圆点贴到左上角。
   */
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        itemCount: monthDates.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 一行显示7个日期
          childAspectRatio:
              FlomoDetailResponsiveLayout.calendarDayChildAspectRatio(
                  constraints.maxWidth),
        ),
        itemBuilder: (context, index) {
          DateTime date = monthDates[index];
          String day = date.day.toString();
          if (date.year == -1) {
            return Container();
          } else {
            DayModel dayModel =
                monthModel.dayModelList[index - deltaWeekDay + 1];
            // if (dayModel.isCurrent) {}
            // bool isFinished = Utility.getNumClocksMissionFinished(dayModel) >= (this.flomoMissionModel?.daily_num_times ?? 0) ? true : false;
            bool isFinished = false;
            if (this.flomoMissionModel != null) {
              isFinished = Utility.isFlomoMissionModelFinished(
                  flomoMissionModel:
                      this.flomoMissionModel ?? FlomoMissionModel(),
                  ymd: Utility.getYMD(dayModel.dateTime ?? DateTime.now()));
            }
            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                onTapListener?.call(dayModel);
              },
              child: Center(
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        constraints: BoxConstraints(
                          maxHeight: 45,
                          maxWidth: 45,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFinished == true
                              ? ThemeManager.getInstance().getDefautThemeColor()
                              : ThemeManager.getInstance().getBackgroundColor(
                                  defaultColor: Color(0xFFF3F3F3)),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayModel.isCurrent ? getI18NKey().today : day,
                                style: TextStyle(
                                    color: isFinished == true
                                        ? Colors.white
                                        : ThemeManager.getInstance()
                                            .getTextColor(
                                                defaultColor:
                                                    Color(0xFF333333)),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                              Utility.isFlomoMissionModelExistFromList(
                                      dayModel.flomoMissionModelList,
                                      this.flomoMissionModel ??
                                          FlomoMissionModel())
                                  ? Text(
                                      getI18NKey().num_of_total(
                                          Utility
                                              .getNumClocksMissionFinishedByFlomoMissionModel(
                                                  flomoMissionModel:
                                                      this.flomoMissionModel ??
                                                          FlomoMissionModel(),
                                                  ymd: Utility.getYMD(
                                                      dayModel.dateTime ??
                                                          DateTime.now())),
                                          (this
                                                      .flomoMissionModel
                                                      ?.daily_num_times ??
                                                  0)
                                              .toString()),
                                      style: TextStyle(
                                          color: isFinished == true
                                              ? Colors.white
                                              : ThemeManager.getInstance()
                                                  .getTextColor(
                                                      defaultColor: ThemeManager
                                                              .getInstance()
                                                          .getDefautThemeColor()),
                                          fontSize: 10),
                                    )
                                  : SizedBox.shrink()
                            ]),
                      ),
                      CustomPaint(
                        size: Size(48, 48),
                        painter: CustomPainterCircleProgressWidget(
                          progressColor:
                              ThemeManager.getInstance().getDefautThemeColor(),
                          backgroundColor: ThemeManager.getInstance()
                              .getSliderInactiveColor(),
                          thickness: 1,
                          progress: Utility
                                  .getNumClocksMissionFinishedByFlomoMissionModel(
                                      flomoMissionModel:
                                          this.flomoMissionModel ??
                                              FlomoMissionModel(),
                                      ymd: Utility.getYMD(dayModel.dateTime ??
                                          DateTime.now())) /
                              (this.flomoMissionModel?.daily_num_times ?? 100),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
    });
  }
}
