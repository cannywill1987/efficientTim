// 一个组件a
// 传入一个月的List<datetime> 通过gridview展示出来
// 第一行是 一 到 日
// 其他的是根据datetime生成的 day 日，按顺序排列
// 每个item 圆形背景色f3f3f3 container 里面有个黑色333333 text加粗的居中字体

// 另外一个组件b有多个组件a组成
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../components/CustomPainterCircleProgressWidget.dart';
import '../../../util/Utility.dart';

class FlomoDetailCalendarWidget extends StatefulWidget {
  // final List<DateTime> monthDates;
  FlomoMissionModel? flomoMissionModel;
  ValueChanged<DateTime>? onMonthChanged;
  ValueChanged<DayModel>? onTapListener;
  CalendarModel calendarModel;
  PageController pageController;

  // Function? onMonthChanged;
  double maxWidth = 400;

  FlomoDetailCalendarWidget(
      {this.onTapListener,
      this.flomoMissionModel,
      this.onMonthChanged,
      required this.calendarModel,
      required this.pageController});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FlomoDetailCalendarWidgetState();
  }
}

class FlomoDetailCalendarWidgetState extends State<FlomoDetailCalendarWidget> {
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
          height: 350,
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
                  monthModel: this.widget.calendarModel.monthModelList[index + 1]);
            },
          ),
        ),
      ],
    );
  }

}

class FlomoDetailCalendarWidgetItemHeader extends StatelessWidget {
  List<String> dateList = [
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
    return GridView.builder(
      itemCount: dateList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: dateList.length, // 一行显示7个日期
      ),
      itemBuilder: (context, index) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: 40,
            maxWidth: 40,
          ),
          margin: EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: Color(0xFFF3F3F3),
          // ),
          child: Center(
            child: Text(
              dateList[index],
              style: TextStyle(
                color: (index == 5 || index == 6)
                    ? Color(ThemeManager.getInstance().getDefautThemeColorInt())
                    : ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF333333)),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

class FlomoDetailCalendarWidgetItem extends StatelessWidget {
  MonthModel monthModel;
  late List<DateTime> monthDates;
  int deltaWeekDay = 0;
  ValueChanged<DayModel>? onTapListener;
  FlomoMissionModel? flomoMissionModel;

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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: monthDates.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 一行显示7个日期
      ),
      itemBuilder: (context, index) {
        DateTime date = monthDates[index];
        String day = date?.day.toString() ?? "";
        if (date.year == -1) {
          return Container();
        } else {
          DayModel dayModel = monthModel.dayModelList[index - deltaWeekDay + 1];
          // if (dayModel.isCurrent) {}
          // bool isFinished = Utility.getNumClocksMissionFinished(dayModel) >= (this.flomoMissionModel?.daily_num_times ?? 0) ? true : false;
          bool isFinished = false;
          if(this.flomoMissionModel != null) {
             isFinished = Utility.isFlomoMissionModelFinished(
                flomoMissionModel: this.flomoMissionModel ??
                    FlomoMissionModel(),
                ymd: Utility.getYMD(dayModel.dateTime ?? DateTime.now()));
          }
          return InkWell(
            onTap: () {
              onTapListener?.call(dayModel);
            },
            child: Stack(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  constraints: BoxConstraints(
                    maxHeight: 45,
                    maxWidth: 45,
                  ),
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFinished == true ? ThemeManager.getInstance().getDefautThemeColor() : ThemeManager.getInstance().getBackgroundColor(defaultColor: Color(0xFFF3F3F3)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayModel.isCurrent ? getI18NKey().today : day,
                          style: TextStyle(
                              color: isFinished == true ? Colors.white : ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF333333)),
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        Utility.isFlomoMissionModelExistFromList(dayModel.flomoMissionModelList, this.flomoMissionModel ?? FlomoMissionModel())
                            ? Text(
                                getI18NKey().num_of_total(
                                    Utility.getNumClocksMissionFinishedByFlomoMissionModel(flomoMissionModel: this.flomoMissionModel ?? FlomoMissionModel(), ymd: Utility.getYMD(dayModel.dateTime ?? DateTime.now())),
                                    (this.flomoMissionModel?.daily_num_times ?? 0)
                                        .toString()),
                                style: TextStyle(
                                    color: isFinished == true ? Colors.white : ThemeManager.getInstance().getTextColor(defaultColor: ThemeManager.getInstance().getDefautThemeColor()), fontSize: 10),
                              )
                            : SizedBox.shrink()
                      ]),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomPaint(
                    size: Size(40, 40),
                    painter: CustomPainterCircleProgressWidget(
                      progressColor: ThemeManager.getInstance().getDefautThemeColor(),
                      backgroundColor: ThemeManager.getInstance().getSliderInactiveColor(),
                      thickness: 1,
                      progress: Utility.getNumClocksMissionFinishedByFlomoMissionModel(flomoMissionModel: this.flomoMissionModel ?? FlomoMissionModel(), ymd: Utility.getYMD(dayModel.dateTime ?? DateTime.now())) / (this.flomoMissionModel?.daily_num_times ?? 100),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
