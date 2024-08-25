import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/components/CustomCloseButton.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/HorizontalNumberPickerWrapper.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnChangeListener.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/KeyboardListenerManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../beans/BaseBean.dart';
import '../../../beans/UserBean.dart';
import '../../../common/httpclient/HttpManager.dart';
import '../../../components/CustomFolderModelSelectPopupWidget.dart';
import '../../../components/CustomTagFolderModelSelectPopupWidget.dart';
import '../../../components/SelectDatePeriodDialogUtil.dart';
import '../../../config/Params.dart';
import '../../../models/DateTimeModel.dart';
import '../../../models/EventFn.dart';
import '../../../util/OverlayManagement.dart';
import '../../CreateAIChatGptMissionPage/CreateAIChatGptMissionPage.dart';

typedef OnTapDateListener = void Function(dynamic data);
typedef OnTapUpdateDateListener = void Function(
    {dynamic startDate,
    dynamic alertDate,
    dynamic dailyStartDate,
    dynamic dailyEndDate,
    int time_mode});
// typedef OnTapDailyEndDateListener = void Function({dynamic endDate});
typedef OnTapBottomBarPriorityListener = void Function(dynamic data);
typedef OnTapBottomBarTagListener = void Function(dynamic data);
typedef OnTapBottomBarCircleListener = void Function(dynamic data);
typedef OnTapBottomBarFinishListener = void Function({dynamic data});
typedef OnTapBottomBarEndTimeListener = void Function({dynamic data});
typedef OnTapBottomBarMissionValueListener = void Function({dynamic data});

class BottomBar extends StatefulWidget {
  bool isVisible = false;
  OnTapUpdateDateListener? onTapUpdateDateListener;

  // OnTapDailyEndDateListener? onTapDailyEndDateListener;
  OnChangeListener? onChangeListener;
  OnTapDateListener? onTapDateListener;
  OnTapBottomBarEndTimeListener? onTapEndTimeListener;
  OnTapBottomBarPriorityListener? onTapPriorityListener;
  OnTapBottomBarTagListener? onTapTagListener;
  OnTapBottomBarCircleListener? onTapCircleListener;
  OnTapBottomBarFinishListener? onTapFinishListener;
  OnTapBottomBarMissionValueListener? onTapMissionValueListener;
  int iconType = 0; // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
  int priority = 0;
  String? tagName = "";
  int dateStatus = 0;
  int time_mode = 0;
  int? mission_value;
  int totalTomatoes;
  int end_time = 0;
  int start_time = 0;
  Color tagColor = ColorsConfig.gray_cc_cancel;
  String circleTitle = "";
  Color circleColor = ColorsConfig.gray_cc_cancel;
  Icon? iconCircle;
  List? repetiveWeekDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  BottomBar(
      {Key? key,
      this.isVisible = false,
      this.start_time = 0,
      this.end_time = 0,
      this.mission_value,
      this.onChangeListener,
      this.onTapFinishListener,
      this.onTapDateListener,
      this.onTapUpdateDateListener,
      this.time_mode = 0,
      this.tagName,
      this.onTapPriorityListener,
      required this.totalTomatoes,
      this.dateStatus = 0,
      this.onTapEndTimeListener,
      required this.tagColor,
      this.iconCircle,
      this.onTapTagListener,
      this.circleTitle = "",
      required this.circleColor,
      this.iconType = 0,
      this.priority = 0,
      this.onTapMissionValueListener,
      this.onTapCircleListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BottomBarState(
        iconCircle: this.iconCircle,
        dateStatus: this.dateStatus,
        iconType: this.iconType,
        totalTomatoes: this.totalTomatoes,
        tagName: this.tagName,
        mission_value: this.mission_value,
        priority: this.priority,
        tagColor: this.tagColor,
        time_mode: this.time_mode,
        circleTitle: this.circleTitle,
        circleColor: this.circleColor);
  }
}

class BottomBarState extends State<BottomBar> {
  // NumberFormat _numberFormat = NumberFormat(',0');
  int? mCurPage;
  PageController? _pageController = PageController();
  int time_mode = 0;
  int? iconType = 0;
  int? priority = 0;
  String? tagName = "";
  Color? tagColor = ColorsConfig.gray_cc_cancel;
  String? circleTitle = "";
  Color? circleColor = ColorsConfig.gray_cc_cancel;
  int? dateStatus = 0;
  Icon? iconCircle;
  int? end_time;
  int? mission_value;
  int? daily_start_time;
  int totalTomatoes;
  int? daily_end_time;
  int start_time = 0;

  GlobalKey<CustomTabBarWidgetState> _tabBarKey = GlobalKey();

  // int totalTomatoes = 1;
  int? alert_time;
  double paddingTop = 3;
  double marginRight = 10;
  double iconSize = 20;
  int repetiveType = 0;
  int repetiveValue = 0;
  List repetiveWeekDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  BottomBarState(
      {this.iconCircle,
      this.dateStatus,
      this.time_mode = 0,
      required this.totalTomatoes,
      this.tagColor,
      this.tagName,
      this.mission_value,
      // this.totalTomatoes = 1,
      this.iconType,
      this.priority,
      this.circleTitle,
      this.circleColor});

  @override
  void didUpdateWidget(BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.iconCircle = this.widget.iconCircle;
    this.dateStatus = this.widget.dateStatus;
    this.mission_value = this.widget.mission_value;
    this.iconType = this.widget.iconType;
    this.tagColor = this.widget.tagColor;
    this.tagName = this.widget.tagName;
    this.priority = this.widget.priority;
    this.circleColor = this.widget.circleColor;
    this.circleTitle = this.widget.circleTitle;
  }

  @override
  void initState() {
    Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
    this.end_time = CONSTANTS.getDeadLineTme(this.widget.dateStatus + 1);
    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_VALUE_PER_DAY && mounted) {
        setState(() {
          this.totalTomatoes = event.obj['numTomatoes'];
        });
      }
    });
  } // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单

  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if ((
          (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) ||  HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyB)) { // ctrl+b&cmd+b begin, 开始专注 ok
        CounterManagement.getInstance().startFocusing();
      } else if (
      (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) ||  HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyS) { // ctrl+s&cmd+s stop,停止拴住 ok
        CounterManagement.getInstance().stopFromFocusingStatus();
      } else if (
      (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) || HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyP) {  // ctrl+p&cmd+p pause,暂停专属拴住 ok
        // CounterManagement.getInstance().pauseTimer();
        CounterManagement.getInstance().nextStatus(true);
      } else if (
      (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) || HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyR) { // ctrl+r&cmd+r resume,继续专注 ok
        CounterManagement.getInstance().nextStatus(false);
      } else if (key == LogicalKeyboardKey.space) { // 空格 下一个状态 ok
        CounterManagement.getInstance().nextStatus(true);
      }
      // else if (
      // (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) || HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyF) { // ctrl+f&cmd+f finish,完成专注
      //   this.onClickFinishItem(this.missionModel);
      // }


    }
    return false;
  }


  @override
  void dispose() {
    Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
    _pageController?.dispose();
    super.dispose();
  }

  void updateAlertTime() {
    if (this.time_mode == 1) {
      this.alert_time = (this.start_time ?? 0);
    } else {
      if (this.repetiveType == 0 && this.end_time != null) {
        this.alert_time = (this.daily_start_time ?? 0) + (this.end_time ?? 0);
      } else {
        this.alert_time = (this.daily_start_time ?? 0);
      }
      if ((this.alert_time ?? 0) > 0) {
        //加了这个 才会刷新提醒时间
        Params.shouldRefreshPushModelList = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Offstage(
        offstage: !this.widget.isVisible, child: getMobileWidget(context));
  }

  Container getMobileWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        color: ThemeManager.getInstance()
            .getBackgroundColor(defaultColor: ColorsConfig.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expanded(
            // child: PageView(
            //     controller: _pageController,
            //     onPageChanged: (page) {
            //       setState(() {
            //         mCurPage = page;
            //       });
            //     },
            //     children: [
            //   getWidgetOfHorizontalNumberPickerWrapper(),
            // ])),
            // Divider(),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: paddingTop),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            CustomPopupWidget(
                              onSelected: (v) {
                                AnalyticsEventsManager.getInstance()
                                    .sendAnalyticsEventMap({
                                  "sceneType": "missionpage",
                                  "eventType": "missionpage_date_type",
                                  "description": "任务时间类型",
                                });
                                if (this.widget.onTapDateListener != null) {
                                  this.widget.onTapDateListener?.call(v.value);
                                }
                              },
                              list: CONSTANTS.getCheckButtonStateModelList(),
                              child: CONSTANTS.getDateIcon(
                                  this.dateStatus ?? 0, iconSize - 2),
                            ),
                            SizedBox(
                              width: marginRight,
                            ),
                            getPriorityWidget(),
                            SizedBox(
                              width: marginRight,
                            ),
                            getTagNameWidget(),
                            SizedBox(
                              width: marginRight,
                            ),
                            getCircleFolderModelWidget(),
                          ],
                        ),
                        Spacer(),
                        // InkWell(
                        //   onTap: () {
                        //     Utility.pushNavigator(
                        //         context, CreateAIChatGptMissionPage());
                        //   },
                        //   child: Wrap(
                        //     children: [
                        //       Utility.getSVGPicture(R.assetsImgIcBrainstorm,
                        //           size: 20),
                        //       SizedBox(
                        //         width: 5,
                        //       ),
                        //       // Text(
                        //       //   getI18NKey().ai_helper,
                        //       //   style: TextStyle(
                        //       //       color: Color(0xffac92ec),
                        //       //       fontSize: 12,
                        //       //       fontWeight: FontWeight.bold),
                        //       // )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  CustomTabBarWidget(
                    key: _tabBarKey,
                    list: CONSTANTS.getSettingItemDetailCheckButtonList(
                        defaultVal: 0),
                    onCheckedListener: (int index) {
                      this.daily_start_time = null;
                      this.daily_end_time = null;
                      this.time_mode = index;
                      this.end_time = 0;
                      this.start_time = 0;
                      setState(() {});
                    },
                    fontSize: 14,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: paddingTop),
                    child: Row(
                      children: [
                        getDailyStartTimeWidget(context),
                        SizedBox(
                          width: 0,
                        ),
                        getDailyEndTimeWidget(context),
                      ],
                    ),
                  ),
                  this.time_mode == 1
                      ? SizedBox.shrink()
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: paddingTop),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getRepeativeWidget(context),
                              SizedBox(
                                width: 0,
                              ),
                              getEndTimeWidget(context),
                            ],
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: paddingTop),
                    child: getBottomWidget(context),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Row getBottomWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getMissionValueWidget(context),
        InkWell(
          child: new Text(
            getI18NKey().create,
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
              "sceneType": "missionpage",
              "eventType": "missionpage_create_button",
              "description": "创建",
            });
            if (this.widget.onTapFinishListener != null) {
              this.widget.onTapFinishListener!();
            }
          },
        ),
      ],
    );
  }

  InkWell getEndTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().deadLine,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              end_time == null ? getI18NKey().none : CONSTANTS.getWeekDayString(
                  Utility.getDateTimeModelFromTimeStamp(end_time ?? 0)),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.end_time = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        DateTimeModel? model = await Utility.showDatePickerDialog(
            context, CONSTANTS.getDeadLineTme(this.widget.dateStatus) ?? 0);
        this.setState(() {
          this.end_time = model?.datetime?.millisecondsSinceEpoch; //计划到期日
        });
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_end_time",
          "description": "完成时间",
        });
        if (this.widget.onTapEndTimeListener != null) {
          this.widget.onTapEndTimeListener!(data: this.end_time);
        }
      },
    );
  }

  InkWell getMissionValueWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().mission_value,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.widget.mission_value == null
                  ? getI18NKey().none
                  : (this.widget.mission_value!.toString() +
                          getI18NKey().dollar) +
                      " (" +
                      getI18NKey()
                          .value_per_hour(Utility.getMissionValuePerHour(
                        totalTomatoes: this.totalTomatoes,
                        missionValue: this.widget.mission_value ?? 0,
                      )) +
                      ")",
              style: TextStyle(color: ColorsConfig.colorGold, fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.widget.mission_value = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_task_duration",
          "description": "任务价值",
        });
        if (LoginManager.getInstance().userBean.valuePerHour == null ||
            LoginManager.getInstance().userBean.valuePerHour == 0) {
          OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
              context,
              title: getI18NKey().mission_value,
              okCallBack: (valuePerHour) async {
            OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
            BaseBean response = await HttpManager.getInstance().doPostRequest(
                Apis.updateValuePerHour,
                params: {"valuePerHour": valuePerHour},
                context: context,
                shouldShowErrorToast: false);
            if (response.success == true) {
              LoginManager.getInstance()
                  .setUserBean(UserBean.fromJson(response.data));
            }
          });
          return;
        }

        OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
            context,
            title: getI18NKey().mission_value, cancelCallBack: () {
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
        }, okCallBack: (data) {
          this.setState(() {
            this.widget.mission_value = data;
          });
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
          this
              .widget
              .onTapMissionValueListener
              ?.call(data: this.widget.mission_value);
        });

        // DateTimeModel? model = await Utility.showDatePickerDialog(
        //     context, CONSTANTS.getDeadLineTme(this.widget.dateStatus) ?? 0);
        // this.setState(() {
        //   this.end_time = model?.datetime?.millisecondsSinceEpoch; //计划到期日
        // });
        // if (this.widget.onTapFinishListener != null) {
        //   this.widget.onTapEndTimeListener!(data: this.end_time);
        // }
      },
    );
  }

  InkWell getRepeativeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().repetive,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              CONSTANTS.getRepetiveDateString3(
                  repetiveType: this.repetiveType,
                  repetiveValue: this.repetiveValue,
                  repetiveWeekDay: this.repetiveWeekDay),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.repetiveType = 0;
              this.repetiveValue = 0;
              this.repetiveWeekDay = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
              ];

              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_repeative",
          "description": "重复",
        });

        SelectDatePeriodDialogUtil.show(context, okCallBack:
            (valueMiddleSelected, valueRightSelected, listCheckModels) {
          this.repetiveValue = valueMiddleSelected; //更新值
          if (this.repetiveType != valueRightSelected) {
            this.alert_time = 0;
          }
          this.repetiveType =
              valueRightSelected; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复
          if (this.repetiveWeekDay == null || this.repetiveWeekDay?.length == 0)
            this
              ..repetiveWeekDay = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
              ];
          this.repetiveWeekDay?[0] = listCheckModels[0].isChecked;
          this.repetiveWeekDay?[1] = listCheckModels[1].isChecked;
          this.repetiveWeekDay?[2] = listCheckModels[2].isChecked;
          this.repetiveWeekDay?[3] = listCheckModels[3].isChecked;
          this.repetiveWeekDay?[4] = listCheckModels[4].isChecked;
          this.repetiveWeekDay?[5] = listCheckModels[5].isChecked;
          this.repetiveWeekDay?[6] = listCheckModels[6].isChecked;
          // requestMongoDbUpdateData();
          updateAlertTime();
          setState(() {});
          // this.isNeedUpdateBmob = true;
        });
      },
    );
  }

  InkWell getDailyEndTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().end_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.time_mode == 1
                  ? CONSTANTS.getAlertDateString(
                      Utility.getDateTimeModelFromTimeStamp(this.end_time ?? 0))
                  : this.daily_end_time != null
                      ? Utility.formatHourAndMin2(this.daily_end_time ?? 0)
                      : getI18NKey().none,
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.daily_end_time = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        if (this.time_mode == 1) {
          // DateTimeModel? model =
          //     await Utility.showDateTimePickerDialog(context);
          // updateAlertTime();
          DateTimeModel? model =
              await Utility.showDateTimePickerDialog(context);
          if ((model?.datetime?.millisecondsSinceEpoch ?? 0) <
              (this.start_time ?? 0)) {
            Utility.showToastMsg(
                context: context,
                msg: getI18NKey().end_time_cannot_before_start_time);
            this.end_time = null;
            return;
          }
          this.setState(() {
            this.end_time =
                model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          });
        } else {
          TimeOfDay? timeOfDay;
          timeOfDay = await Utility.showTimePickerDialog(context);
          if (timeOfDay == null) {
            return;
          }

          int? startTime = this.daily_start_time;
          int? endTime =
              timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
          if (startTime != null && endTime != null) {
            bool isBefore = (startTime > endTime);
            if (isBefore) {
              Utility.showToastMsg(
                  msg: getI18NKey().end_time_cannot_before_start_time);
              return;
            }
          }
          this.daily_end_time = endTime;
        }
        if (this.widget.onTapUpdateDateListener != null) {
          this.widget.onTapUpdateDateListener!(
              startDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              alertDate: this.alert_time,
              dailyStartDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
              time_mode: this.time_mode);
        }
        setState(() {});
      },
    );
  }

  InkWell getDailyStartTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().start_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.time_mode == 1
                  ? CONSTANTS.getAlertDateString(
                      Utility.getDateTimeModelFromTimeStamp(
                          this.start_time ?? 0))
                  : this.daily_start_time != null
                      ? Utility.formatHourAndMin2(this.daily_start_time ?? 0)
                      : getI18NKey().none,
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.daily_start_time = null;
              this.daily_end_time = null;
              this.start_time = 0;
              this.end_time = 0;
              if (this.widget.onTapUpdateDateListener != null) {
                this.widget.onTapUpdateDateListener!(
                    startDate: this.time_mode == 0
                        ? this.daily_start_time
                        : this.start_time,
                    alertDate: this.alert_time,
                    dailyStartDate: this.time_mode == 0
                        ? this.daily_start_time
                        : this.start_time,
                    dailyEndDate:
                        this.time_mode == 0 ? this.end_time : this.end_time,
                    time_mode: this.time_mode);
              }
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_start_time",
          "description": "开始时间",
        });
        if (this.time_mode == 1) {
          DateTimeModel? model =
              await Utility.showDateTimePickerDialog(context);
          // updateAlertTime();
          this.setState(() {
            this.start_time =
                model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          });
        } else {
          TimeOfDay? timeOfDay;
          timeOfDay = await Utility.showTimePickerDialog(context);
          if (timeOfDay == null) {
            return;
          }
          int? startTime =
              timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
          int? endTime = this.daily_end_time;
          if (startTime != null && endTime != null) {
            bool isBefore = (startTime > endTime);
            if (isBefore) {
              Utility.showToastMsg(
                  msg: getI18NKey().end_time_cannot_before_start_time);
              return;
            }
          }

          this.daily_start_time = startTime;
        }
        updateAlertTime();
        if (this.widget.onTapUpdateDateListener != null) {
          this.widget.onTapUpdateDateListener!(
              startDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              alertDate: this.alert_time,
              dailyStartDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
              time_mode: this.time_mode);
        }
        setState(() {});
      },
    );
  }

  Widget getPriorityWidget() {
    return CustomPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_priority",
          "description": "优先级",
        });
        if (this.widget.onTapPriorityListener != null) {
          this.widget.onTapPriorityListener?.call(v.value);
        }
      },
      list: CONSTANTS.getPriorityList(),
      child: CONSTANTS.getPriorityIcon(this.priority ?? 0, size: iconSize + 2),
    );
  }

  CustomTagFolderModelSelectPopupWidget getTagNameWidget() {
    return CustomTagFolderModelSelectPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_tags",
          "description": "标签",
        });
        if (this.widget.onTapTagListener != null) {
          this.widget.onTapTagListener!(v);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer,
            size: iconSize,
            color: this.tagColor,
          ),
          SizedBox(
            width: 5,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 65),
              child: Text(
                this.tagName ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ))
        ],
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     if (this.widget.onTapTagListener != null) {
    //       this.widget.onTapTagListener!();
    //     }
    //   },
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Icon(
    //         Icons.local_offer,
    //         size: iconSize,
    //         color: this.tagColor,
    //       ),
    //       SizedBox(
    //         width: 5,
    //       ),
    //       ConstrainedBox(
    //           constraints: BoxConstraints(maxWidth: 65),
    //           child: Text(
    //             this.tagName ?? "",
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(fontSize: 12),
    //           ))
    //     ],
    //   ),
    // );
  }

  Widget getCircleFolderModelWidget() {
    return CustomFolderModelSelectPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_select_list",
          "description": "选择清单",
        });
        if (this.widget.onTapCircleListener != null) {
          this.widget.onTapCircleListener?.call(v);
        }
      },
      child: Wrap(
        children: [
          this.iconCircle ??
              Icon(Icons.fiber_manual_record,
                  size: iconSize, color: this.circleColor),
          SizedBox(
            width: 5,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text(
                this.circleTitle ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ))
        ],
        crossAxisAlignment: WrapCrossAlignment.center,
      ),
    );
  }

  getWidgetOfHorizontalNumberPickerWrapper() {
    return HorizontalNumberPickerWrapper(
      initialValue: 0,
      minValue: 0,
      maxValue: 1000,
      step: 1,
      unit: getI18NKey().tomato,
      widgetWidth: MediaQuery.of(context).size.width.round() - 68,
      subGridCountPerGrid: 2,
      subGridWidth: 50,
      scaleTextColor: ColorsConfig.red,
      //刻度下的文字颜色
      titleTextColor: ColorsConfig.red,
      indicatorColor: ColorsConfig.red,
      //指示器颜色
      //   scaleColor:ColorsConfig.red,
      onSelectedChanged: (value) {
        if (this.widget.onChangeListener != null) {
          this.widget.onChangeListener!(value);
        }
        print(value);
      },
      titleTransformer: (value) {
        return value.toString();
      },
      scaleTransformer: (value) {
        return value.toString();
        // return '${value ~/ 1000}k';
      },
    );
  }
}

class MissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionWidgetState();
  }
}

class MissionWidgetState extends State<MissionWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw Container();
  }
}
