import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/HorizontalNumberPickerWrapper.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnChangeListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/BlackCheckButtonListWidget.dart';
import '../../../components/CustomFolderModelSelectPopupWidget.dart';
// import '../../../components/CustomTagFolderModelSelectPopupWidget.dart';
import '../../../components/CustomPopupWidget.dart';
import '../../../components/SelectDatePeriodDialogUtil.dart';
import '../../../components/WQBCustomFolderModelSelectPopupWidget.dart';
import '../../../components/WQBCustomTagFolderModelSelectPopupWidget.dart';
import '../../../config/Params.dart';
import '../../../models/DateTimeModel.dart';
import '../../CreateAIChatGptMissionPage/CreateAIChatGptMissionPage.dart';

typedef OnTapDateListener = void Function({dynamic data});
typedef OnTapUpdateDateListener = void Function(
    {dynamic startDate,
    dynamic alertDate,
    dynamic dailyStartDate,
    dynamic dailyEndDate});
// typedef OnTapDailyEndDateListener = void Function({dynamic endDate});
typedef OnTapPriorityListener = void Function(dynamic data);
typedef OnTapTagListener = void Function(dynamic data);
typedef OnTapCircleListener = void Function(dynamic data);
typedef OnTapFinishListener = void Function({dynamic data});
typedef OnTapEndTimeListener = void Function({dynamic data});
typedef OnTapChangeStateListener = void Function(int data);

class WQBBottomBar extends StatefulWidget {
  bool isVisible = false;
  OnTapUpdateDateListener? onTapUpdateDateListener;
  OnTapChangeStateListener? onTapChangeStateListener;
  int initIndexState = 0; // state初始化状态
  // OnTapDailyEndDateListener? onTapDailyEndDateListener;
  OnChangeListener? onChangeListener;
  OnTapDateListener? onTapDateListener;
  OnTapEndTimeListener? onTapEndTimeListener;
  OnTapPriorityListener? onTapPriorityListener;
  OnTapTagListener? onTapTagListener;
  OnTapCircleListener? onTapCircleListener;
  OnTapFinishListener? onTapFinishListener;
  int iconType = 0; // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
  int priority = 0;
  String? tagName = "";
  int dateStatus = 0;
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

  WQBBottomBar(
      {Key? key,
      this.isVisible = false,
      this.onChangeListener,
        this.initIndexState = 0,
        this.onTapChangeStateListener,
      this.onTapFinishListener,
      this.onTapDateListener,
      this.tagName,
      this.onTapPriorityListener,
      this.dateStatus = 0,
      this.onTapEndTimeListener,
      required this.tagColor,
      this.iconCircle,
      this.onTapTagListener,
      this.circleTitle = "",
      required this.circleColor,
      this.iconType = 0,
      this.priority = 0,
      this.onTapCircleListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBBottomBarState(
        iconCircle: this.iconCircle,
        dateStatus: this.dateStatus,
        iconType: this.iconType,
        tagName: this.tagName,
        priority: this.priority,
        tagColor: this.tagColor,
        circleTitle: this.circleTitle,
        circleColor: this.circleColor);
  }
}

class WQBBottomBarState extends State<WQBBottomBar> {
  // NumberFormat _numberFormat = NumberFormat(',0');
  int? mCurPage;
  PageController? _pageController = PageController();
  int? iconType = 0;
  int? priority = 0;
  String? tagName = "";
  Color? tagColor = ColorsConfig.gray_cc_cancel;
  String? circleTitle = "";
  Color? circleColor = ColorsConfig.gray_cc_cancel;
  int? dateStatus = 0;
  Icon? iconCircle;
  int? end_time;
  int? daily_start_time;
  int? daily_end_time;
  int? alert_time;
  double paddingTop = 3;
  double marginRight = 10;
  double iconSize = 20;
  int repetiveType = 0;
  int repetiveValue = 0;
  GlobalKey<BlackCheckButtonListWidgetState> _blackCheckButtonListWidgetStateKey =
      GlobalKey<BlackCheckButtonListWidgetState>();
  List repetiveWeekDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  WQBBottomBarState(
      {this.iconCircle,
      this.dateStatus,
      this.tagColor,
      this.tagName,
      this.iconType,
      this.priority,
      this.circleTitle,
      this.circleColor});

  @override
  void didUpdateWidget(WQBBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.iconCircle = this.widget.iconCircle;
    this.dateStatus = this.widget.dateStatus;
    this.iconType = this.widget.iconType;
    this.tagColor = this.widget.tagColor;
    this.tagName = this.widget.tagName;
    this.priority = this.widget.priority;
    this.circleColor = this.widget.circleColor;
    this.circleTitle = this.widget.circleTitle;
  }

  @override
  void initState() {
    this.end_time = CONSTANTS.getDeadLineTme(this.widget.dateStatus + 1);
  } // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void updateAlertTime() {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Offstage(
        offstage: !this.widget.isVisible,
        child: getMobileWidget(context));
  }

  setCurIndex(int index) {
    _blackCheckButtonListWidgetStateKey.currentState?.setCurIndex(index);
  }

  Container getMobileWidget(BuildContext context) {
    return Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
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
                              getPriorityWidget(),
                              SizedBox(
                                width: marginRight,
                              ),
                              getCircleFolderModelWidget(),
                              SizedBox(
                                width: marginRight,
                              ),
                              getTagNameWidget(),
                            ],
                          ),
                          Spacer(),
                          BlackCheckButtonListWidget(key: _blackCheckButtonListWidgetStateKey,initIndex: this.widget.initIndexState, list: CONSTANTS.getWQBButtonList(), onTapListener: (obj) {
                            // this. = obj;
                            // MongoApisManager.getInstance().updateWQBButtonList();
                            String codeS = CONSTANTS.getWQBButtonList()[obj].code ?? "";
                            int code = int.parse(codeS);
                            this.widget.onTapChangeStateListener?.call(code);
                          },)
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
                          //       Text(
                          //         getI18NKey().ai_helper,
                          //         style: TextStyle(
                          //             color: Color(0xffac92ec),
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.bold),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: paddingTop),
                    //   child: Row(
                    //     children: [
                    //       getDailyStartTimeWidget(context),
                    //       SizedBox(
                    //         width: 0,
                    //       ),
                    //       getDailyEndTimeWidget(context),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ));
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
              this.daily_end_time != null
                  ? Utility.formatHourAndMin2(this.daily_end_time ?? 0)
                  : getI18NKey().none,
              style: TextStyle(color: Colors.black87, fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: Colors.black87,
          )
        ],
      ),
      onTap: () async {
        if (this.daily_start_time == null) {
          Utility.showToastMsg(
              context: context,
              msg: getI18NKey().please_select_daily_start_time);
          return;
        }
        TimeOfDay? timeOfDay;
        timeOfDay = await Utility.showTimePickerDialog(context);
        if (timeOfDay == null) {
          return;
        }
        int endTime =
            timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
        if (endTime < (this.daily_start_time ?? 0)) {
          Utility.showToastMsg(
              context: context,
              msg: getI18NKey().end_time_cannot_before_start_time);
          this.daily_end_time = null;
          return;
        }
        this.daily_end_time = endTime;
        if (this.widget.onTapUpdateDateListener != null) {
          this.widget.onTapUpdateDateListener!(
              startDate: this.daily_start_time,
              alertDate: this.alert_time,
              dailyStartDate: this.daily_start_time,
              dailyEndDate: this.daily_end_time);
        }
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
              this.daily_start_time != null
                  ? Utility.formatHourAndMin2(this.daily_start_time ?? 0)
                  : getI18NKey().none,
              style: TextStyle(color: Colors.black87, fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: Colors.black87,
          )
        ],
      ),
      onTap: () async {
        TimeOfDay? timeOfDay;
        timeOfDay = await Utility.showTimePickerDialog(context);
        if (timeOfDay == null) {
          return;
        }
        int startTime =
            timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
        if (this.daily_end_time != null) {
          if ((this?.daily_end_time ?? 0) < startTime) {
            Utility.showToastMsg(
                context: context,
                msg: getI18NKey().end_time_cannot_before_start_time);
            this.daily_end_time = null;
            return;
          }
        }
        this.daily_start_time = startTime;
        updateAlertTime();
        if (this.widget.onTapUpdateDateListener != null) {
          this.widget.onTapUpdateDateListener!(
              startDate: this.daily_start_time,
              alertDate: this.alert_time,
              dailyStartDate: this.daily_start_time,
              dailyEndDate: this.daily_end_time);
        }
      },
    );
  }

  Widget getPriorityWidget() {
    return CustomPopupWidget(
      onSelected: (v) {
        if (this.widget.onTapPriorityListener != null) {
          this.widget.onTapPriorityListener?.call(v.value);
        }
      },
      list: CONSTANTS.getPriorityList(),
      child: CONSTANTS.getPriorityIcon(this.priority ?? 3, size: iconSize),
    );
  }

  // InkWell getPriorityWidget() {
  //   return InkWell(
  //       onTap: () {
  //         if (this.widget.onTapPriorityListener != null) {
  //           this.widget.onTapPriorityListener!();
  //         }
  //       },
  //       child: CONSTANTS.getPriorityIcon(this.priority ?? 3, size: iconSize));
  // }

  WQBCustomTagFolderModelSelectPopupWidget getTagNameWidget() {
    return WQBCustomTagFolderModelSelectPopupWidget(
      onSelected: (v) {
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

  // InkWell getTagNameWidget() {
  //   return InkWell(
  //     onTap: () {
  //       if (this.widget.onTapTagListener != null) {
  //         this.widget.onTapTagListener!();
  //       }
  //     },
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           Icons.local_offer,
  //           size: iconSize,
  //           color: this.tagColor,
  //         ),
  //         SizedBox(
  //           width: 5,
  //         ),
  //         ConstrainedBox(
  //             constraints: BoxConstraints(maxWidth: 300),
  //             child: Text(
  //               this.tagName ?? "",
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(fontSize: 12),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  Widget getCircleFolderModelWidget() {
    return WQBCustomFolderModelSelectPopupWidget(
      onSelected: (v) {
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
