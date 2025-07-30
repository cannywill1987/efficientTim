import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoDetailHeaderWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../common/database/apis/MongoApisManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomTitileWidget.dart';
import '../../config/ColorsConfig.dart';
import '../../util/DialogManagement.dart';
import '../../util/Utility.dart';
import 'FlomoCreatePage.dart';
import 'components/FlomoClockInSilverListWidget.dart';
import 'components/FlomoDetailCalendarWidget.dart';
import 'components/FlomoDetailHeaderStatWidget.dart';
import 'components/FlomoDetailObjectiveInfo.dart';
import 'components/FlomoDetailStatsWidget.dart';
import 'components/FlomoSelectDateWidget.dart';
import 'components/FlomoWhiteBorderContainer.dart';

class FlomoDetailPage extends BaseWidget {
  FlomoMissionModel flomoMissionModel;
  late DateTime curDateTime;

  FlomoDetailPage(
      {Key? key, required this.flomoMissionModel, DateTime? curDateTime})
      : super(key: key) {
    // if (curDateTime != null) {
    //   this.curDateTime = curDateTime;
    // } else {
    this.curDateTime = Utility.getFilterDateTimeFromTimeStamp(
        DateTime.now().millisecondsSinceEpoch);
    // }
  }

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return FlomoDetailPageState(curDateTime: this.curDateTime);
  }
}

class FlomoDetailPageState extends BaseWidgetState<FlomoDetailPage> {
  PageController pageController = PageController();
  late CalendarModel calendarModel;
  DateTime curDateTime;
  bool shouldTriggerOnPageChanged = true;
  bool isRequesting = false;

  FlomoDetailPageState({required this.curDateTime});

  @override
  void didUpdateWidget(covariant FlomoDetailPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.curDateTime != widget.curDateTime) {
    //   setState(() {
    //     curDateTime = widget.curDateTime;
    //   });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.rightNavChildren = [
      TextButton(
          onPressed: () async {
            Utility.openPagePCAndMobile(context,
                child: FlomoCreatePage(
                  pageModeEnum: 1,
                  flomoMissionModel: this.widget.flomoMissionModel,
                ));
            // await onClickSave();
          },
          child: Text(
            getI18NKey().edit,
            style: TextStyle(color: Colors.red),
          ))
    ];
  }

  @override
  componentDidMount() {
    // TODO: implement componentDidMount
    super.componentDidMount();
    jumpToToday();
  }

  jumpToDateTime(DateTime dateTime) {
    this.curDateTime = dateTime;
    List<MonthModel> listMonthModel = calendarModel.monthModelList;
    int curMonthIndex = 0;
    for (int i = 0; i < listMonthModel.length; i++) {
      MonthModel monthModel = calendarModel.monthModelList[i];
      if (monthModel.dateTime?.year == dateTime.year &&
          monthModel.dateTime?.month == dateTime.month) {
        curMonthIndex = i;
        break;
      }
    }
    shouldTriggerOnPageChanged = false;
    pageController.jumpToPage(curMonthIndex);
    shouldTriggerOnPageChanged = true;
  }

  jumpToToday() {
    List<MonthModel> listMonthModel = calendarModel.monthModelList;
    int curMonthIndex = 0;
    for (int i = 0; i < listMonthModel.length; i++) {
      MonthModel monthModel = calendarModel.monthModelList[i];
      if (monthModel.isCurrent == true) {
        curMonthIndex = i;
        break;
      }
    }
    pageController.jumpToPage(curMonthIndex);
  }

  @override
  Widget baseBuild(BuildContext context) {
    print("~~~~~~~~~~~~~~~baseBuild~~~~~~~~~~~~~~~~~${this.curDateTime}");
    return Selector<GlobalStateEnv, List<FlomoMissionModel>>(
        selector: (_, globalStateEnv) => globalStateEnv.listFlomoMissionModel,
        builder: (_, listFlomoMissionModel, __) {
          calendarModel = context.read<GlobalStateEnv>().calendarModel;
          return Container(
            color: ThemeManager.getInstance().getBackgroundColor(defaultColor: ColorsConfig.standardPageBackground),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: FlomoDetailHeaderWidget(
                          flomoMissionModel: this.widget.flomoMissionModel)),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SizedBox(height: 10,),
                  FlomoDetailHeaderStatWidget(
                    missionModel: this.widget.flomoMissionModel,
                    curDateTime: this.curDateTime,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTitileWidget(
                    color: ThemeManager.getInstance().getDefautThemeColor(),
                    text: getI18NKey().clock_in_calendar,
                    borderRadius: 4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlomoWhiteBorderContainer(
                      paddingTopBtm: 4,
                      child: Column(
                        children: [
                          FlomoSelectDateWidget(
                            minDatetime:
                                this.calendarModel.dayModelList.first.dateTime,
                            maxDatetime:
                                this.calendarModel.dayModelList.last.dateTime,
                            onChange: (DateTime value) {
                              this.curDateTime = value;
                              print("~~~~~~~~~~value~~~~~~~~~~~:$curDateTime");
                              jumpToDateTime(value);
                              updateUI();
                            },
                            currentDateTime: this.curDateTime,
                          ),
                          FlomoDetailCalendarWidget(
                            flomoMissionModel: this.widget.flomoMissionModel,
                            onTapListener: (dayModel) async {
                              if(isRequesting == true) {
                                return;
                              }
                              isRequesting = true;
                              await MongoApisManager.getInstance()
                                  ?.update_FlomoMissionModelClocksIn(
                                      flomoMissionModel:
                                          this.widget.flomoMissionModel,
                                      ymd: Utility.getYMD(
                                          dayModel.dateTime ?? DateTime.now()),
                                      callback: () {
                                        updateUI();
                                      });
                              isRequesting = false;
                              if (Utility.isFlomoMissionClockInFinishedAtYMD(
                                  flomoMissionModel: this.widget.flomoMissionModel, ymd: Utility.getYMD(curDateTime)) ==
                                  true) {
                                DialogManagement.showFlomoRatingDialog(
                                  context,
                                  flomoMissionModel: this.widget.flomoMissionModel,
                                  onSubmitted: (val) async {
                                    await MongoApisManager.getInstance()
                                        .update_FlomoMissionModelMessage(
                                        flomoMissionModel: this.widget.flomoMissionModel,
                                        ymd: Utility.getYMD(curDateTime),
                                        satisfaction: val['code'],
                                        message: val['content']);
                                    DialogManagement.getInstance().hideDialog(context);
                                  },
                                );
                              }
                            },
                            calendarModel: calendarModel,
                            onMonthChanged: (DateTime value) {
                              // jumpToDateTime(value);
                              if (shouldTriggerOnPageChanged) {
                                curDateTime = value;
                                // updateUI();
                              }
                            },
                            pageController: pageController,
                            // onMonthChanged: (DateTime dateTime) {
                            //   this.widget.curDateTime = dateTime;
                            //   updateUI();
                            // }
                          ),
                        ],
                      )),

                  SizedBox(
                    height: 10,
                  ),
                  CustomTitileWidget(
                    color: ThemeManager.getInstance().getDefautThemeColor(),
                    text: getI18NKey()
                        .month_clockin_rate(this.curDateTime.month.toString()),
                    borderRadius: 4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlomoDetailStatsWidget(
                    curDateTime: this.curDateTime,
                    flomoMissionModel: this.widget.flomoMissionModel,
                    calendarModel: calendarModel,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  CustomTitileWidget(
                    color: ThemeManager.getInstance().getDefautThemeColor(),
                    text: getI18NKey().month_clockin_record(
                        this.curDateTime.month.toString()),
                    borderRadius: 4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlomoClockInSilverListWidget(
                      this.widget.flomoMissionModel.messages ?? []),
                  SizedBox(
                    height: 10,
                  ),

                  CustomTitileWidget(
                    color: ThemeManager.getInstance().getDefautThemeColor(),
                    text: getI18NKey().target_details,
                    borderRadius: 4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlomoDetailObjectiveInfo(
                    missionModel: this.widget.flomoMissionModel,
                  )
                ],
              ),
            ),
          );
        });
  }
}
