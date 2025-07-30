import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/BlackCheckButtonListWidget.dart';
import '../../../config/CONSTANTS.dart';
import 'FlomoSelectDateWidget.dart';
import 'FlomoWeekendWidget.dart';

class FlomoDatePagerWidget extends StatefulWidget {
  final List<WeekModel> dataWeekModel;
  final List<DayModel> dataModels;
  Function onTapTodayListener;
  ValueChanged onTapCheckBoxListener;
  bool isFinished = false;
  FlomoDatePagerWidget(
      {Key? key,
        required this.isFinished,
        required this.onTapCheckBoxListener,
      required this.onTapTodayListener,
      required this.dataModels,
      required this.dataWeekModel})
      : super(key: key);

  @override
  FlomoDatePagerWidgetState createState() => FlomoDatePagerWidgetState();
}

class FlomoDatePagerWidgetState extends State<FlomoDatePagerWidget> {
  DayModel? dayModdel;
  int _currentPage = 0;
  PageController pageController = PageController();
  int curWeekIndex = 0;
  DateTime lastDatetimeOfCurrentWeek = DateTime.now();

  void resetDayModel() {
    for (var i = 0; i < widget.dataWeekModel.length; i++) {
      WeekModel weekModel = widget.dataWeekModel[i];
      for (int j = 0; j < weekModel.dayModelList.length; j++) {
        weekModel.dayModelList[j].isCheck = false;
      }
    }
  }

  int getTodayCurIndex() {
    if (dayModdel != null) {
      return this.widget.dataModels.indexOf(dayModdel!);
    } else {
      int curIndex = 0;
      for (var i = 0; i < widget.dataWeekModel.length; i++) {
        for (int j = 0; j < widget.dataWeekModel[i].dayModelList.length; j++) {
          if (widget.dataWeekModel[i].dayModelList[j].isCurrent) {
            curIndex = j;
            break;
          }
        }
      }
      return curIndex;
    }
  }

  /**
   * 今天时间
   */
  int getCurWeek() {
    int curWeek = 0;
    for (var i = 0; i < widget.dataWeekModel.length; i++) {
      for (int j = 0; j < widget.dataWeekModel[i].dayModelList.length; j++) {
        if (widget.dataWeekModel[i].dayModelList[j].isCurrent) {
          curWeek = i;
          dayModdel = widget.dataWeekModel[i].dayModelList[j];
          widget.dataWeekModel[i].dayModelList[j].isCheck = true; //顺便是今天的日子给设置了
          break;
        }
      }
    }
    return curWeekIndex = curWeek;
  }

  DayModel? getTodayDayModel() {
    for (int i = 0; i < this.widget.dataModels.length; i++) {
      DayModel dayModel = this.widget.dataModels[i];
      if (dayModel.isCurrent == true) {
        return dayModel;
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      jumpToTodayPage();
      setState(() {});
    });
    // Future.delayed(Duration(milliseconds: 500), () {
    //   pageController.animateToPage(5, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    // });
    // setState(() {
    //   _currentPage = 2;
    // });
  }

  int getWeekIndexFromDateTime(DateTime dateTime) {
    for (var i = 0; i < widget.dataWeekModel.length; i++) {
      for (int j = 0; j < widget.dataWeekModel[i].dayModelList.length; j++) {
        DateTime? dateTimeTmp =
            widget.dataWeekModel[i].dayModelList[j].dateTime;
        if (dateTimeTmp?.year == dateTime.year &&
            dateTimeTmp?.month == dateTime.month) {
          curWeekIndex = i;
          break;
        }
      }
    }
    return curWeekIndex;
  }

  void jumpToPageByIndex(int index) {
    pageController.jumpToPage(_currentPage = index);
    setUpWeekModelFromIndex(_currentPage);
  }

  void jumpToTodayPage() {
    resetDayModel();
    _currentPage = getCurWeek();
    setUpWeekModelFromIndex(_currentPage);
    pageController.jumpToPage(_currentPage);
    setState(() {

    });
  }

  void jumpToNextPage() {
    pageController.animateToPage(curWeekIndex = curWeekIndex + 1,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  void jumpToPrevPage() {
    pageController.animateToPage(curWeekIndex = curWeekIndex - 1,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  /**
   * lastDatetimeOfCurrentWeek 为当前周的最后一天
   */
  setUpWeekModelFromIndex(int index) {
    if(widget.dataWeekModel.length > 0) {
      WeekModel weekModel = widget.dataWeekModel[index];
      if (weekModel.dayModelList.length > 0) {
        lastDatetimeOfCurrentWeek =
            weekModel.dayModelList[weekModel.dayModelList.length - 1]
                .dateTime ??
                DateTime.now();
        return lastDatetimeOfCurrentWeek;
      } else {
        lastDatetimeOfCurrentWeek = DateTime.now();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        this.widget.isFinished == true ? SizedBox.shrink() : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${lastDatetimeOfCurrentWeek.year}.${lastDatetimeOfCurrentWeek.month.toString().padLeft(2, '0')}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.getInstance().getDefautThemeColor(),
                        fontSize: 14),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 10,
                  ),
                  // Spacer(),
                  InkWell(
                      onTap: () {
                        int curIndex = getCurWeek();
                        this.widget.onTapTodayListener.call(getTodayDayModel());
                        jumpToPageByIndex(curIndex);
                      },
                      child: Utility.getSVGPicture(R.assetsImgIcCalendarToday,
                          size: 16, color: ThemeManager.getInstance().getDefautThemeColor())),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Color(0xFF959595),
                    size: 16,
                  ),
                  onPressed: () {
                    jumpToPrevPage();
                  },
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                          setUpWeekModelFromIndex(_currentPage);
                        });
                      },
                      itemCount: widget.dataWeekModel.length,
                      itemBuilder: (context, index) {
                        return FlomoWeekendWidget(
                            list: this.widget.dataWeekModel[index].dayModelList,
                            // key: weekendWidgetStateGlobalKey,
                            onCheckedListener: (DayModel days) async {
                              resetDayModel();
                              days.isCheck = true;
                              dayModdel = days;
                              this.widget.onTapTodayListener(days);
                              setState(() {});
                            });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xFF959595),
                    size: 16,
                  ),
                  onPressed: () {
                    jumpToNextPage();
                  },
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: BlackCheckButtonListWidget(
            initIndex: 0,
            backgroundColor: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: ThemeManager.getInstance().getDefautThemeColor()),
            list: CONSTANTS.getArchivedButtonList(),
            onTapListener: (index) async {
              this.widget.onTapCheckBoxListener.call(index);
              // this.widget.folderModel?.isOtherUserEditable =
              // (index == 0);
              // print(this.widget.folderModel?.isOtherUserEditable);
              // setState(() {});
            },
          ),
        ),
      ],
    );
  }
}

class DatePagerWidgetItem extends StatelessWidget {
  String weekday;
  String dd;

  DatePagerWidgetItem(this.weekday, this.dd);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          weekday ?? "",
          style: TextStyle(color: Color(0xff404040)),
        ),
        Text(
          dd ?? "",
          style: TextStyle(color: Color(0xff404040)),
        ),
      ],
    );
  }
}
