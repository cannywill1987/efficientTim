// 创建FlomoCreatePage页面
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/MonthCalendar.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../../r.dart';
import '../../components/IconWidget.dart';
import '../../components/IconsHorizontalListView.dart';
import '../../components/InputNumber.dart';
import '../../components/WeekendWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../config/StylesConfig.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../models/FlomoMissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/Utility.dart';
import '../createFolderPage/components/ColorsGridViewWidget.dart';
import 'components/FlomoCard.dart';
import 'components/FlomoMenuItem.dart';
import 'components/FlomoPickPeriodDialogWidget.dart';
import 'components/TimeSelectWidget.dart';
import 'components/TimesGridViewWidget.dart';

class FlomoCreatePage extends BaseWidget {
  FlomoMissionModel? flomoMissionModel;
  int pageModeEnum; //0创建 1编辑
  FlomoCreatePage({this.flomoMissionModel, this.pageModeEnum: 0}) {
    if (this.flomoMissionModel == null) {
      this.flomoMissionModel = FlomoMissionModel();
      this.flomoMissionModel?.start_time =
          Utility.getFilterDateTimeFromTimeStamp(Utility.getTimeStampToday())
              .millisecondsSinceEpoch;
    }
  }

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return FlomoCreatePageState();
  }
}

class FlomoCreatePageState extends BaseWidgetState<FlomoCreatePage> {
  double marginTop = 10;
  List<CheckModel> listWeekendCheckModels = CONSTANTS.getWeekendCheckModels();
  FlomoRepeatModeEnum flomoRepeatModeEnum = FlomoRepeatModeEnum.byWeek;
  bool shouldRefreshPushModelList = false;
  GlobalKey<FlomoPickPeriodDialogWidgetState>
      FlomoPickPeriodDialogWidgetStateGlobalKey = GlobalKey();
  List<int> extraTimeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listWeekendCheckModels = CONSTANTS.getWeekendCheckModels(
        defaultChecked: this.widget.flomoMissionModel?.repetiveWeekDay ?? null);
    forceAppBarVisible = true;
    isAppBarVisible = true;
    if (this.widget.flomoMissionModel?.end_time == null) {
      this.widget.flomoMissionModel?.end_time =
          (this.widget.flomoMissionModel?.start_time ??
                  Utility.getFilterDateTimeFromTimeStamp(
                          Utility.getTimeStampToday())
                      .millisecondsSinceEpoch) +
              21 * 24 * 60 * 60 * 1000;
    }
    //来自于创建
    if (this.widget.pageModeEnum == 0) {
      if(this.widget.flomoMissionModel?.icon == null) {
        this.widget.flomoMissionModel?.icon =
            CONSTANTS.getSelectIcons()[0].icon?.codePoint;
      }
      this.widget.flomoMissionModel?.color = CONSTANTS.getColors()[0].color;
      this.widget.flomoMissionModel?.repetiveType = 1; //默认 按天重复
      this.widget.flomoMissionModel?.clocks_days = 21;
    } else {
      //来自于更新
      flomoRepeatModeEnum = getFlomoRepeatModeEnumByRepetiveType(
          this.widget.flomoMissionModel?.repetiveType ?? 1);
    }
    // if (Utility.isHandsetBySize() == false) {
    //   isNavBackBtnVisible = false;
    // }
    this.rightNavChildren = [
      TextButton(
          onPressed: () async {
            await onClickSave();
          },
          child: Text(
            this.widget.pageModeEnum == PageModeEnum.create
                ? getI18NKey().publish
                : getI18NKey().save,
            style: TextStyle(color: Colors.red),
          ))
    ];
  }

  Future<void> onClickSave() async {
    if (TextUtil.isEmpty(this.widget.flomoMissionModel?.title) == true) {
      Utility.showToast(msg: getI18NKey().pleaseInputTitle);
      return;
    }
    Params.shouldRefreshPushModelList = true;
    if (flomoRepeatModeEnum == FlomoRepeatModeEnum.byWeek) {
      //判断 repetiveWeekDay 这个数组是否都为false
      bool isAllFalse = true;
      for (bool val in this.widget.flomoMissionModel?.repetiveWeekDay ?? []) {
        if (val == true) {
          isAllFalse = false;
          break;
        }
      }
      if (isAllFalse == true) {
        Utility.showToast(msg: getI18NKey().please_select_at_least_one_option_in_repeat_cycle);
        return;
      }
    }
    if (this.widget.flomoMissionModel?.end_time == null) {
      Utility.showToast(msg: getI18NKey().please_select_content(getI18NKey().end_time));
      return;
    }
    if (flomoRepeatModeEnum == FlomoRepeatModeEnum.byEbbinghaus &&
        this.widget.pageModeEnum == 1) {
      setEbbingList();
      // this.widget.flomoMissionModel.alert_times.insert(0, extraTimeList)
    }
    addExtraTimeListToAlertTimes();
    if (this.widget.pageModeEnum == 1) {
      //更新
      await MongoApisManager.getInstance().update_FlomoMissionModel(
          missionModel: this.widget.flomoMissionModel ?? FlomoMissionModel());
    } else {
      //创建
      // this.widget.flomoMissionModel?.alert_times.add(value)
      await MongoApisManager.getInstance().insertFlomoMissionModel(
          missionModel: this.widget.flomoMissionModel ?? FlomoMissionModel());
    }
    Utility.popupPagePCAndMobile(context);
  }

  //把extraTimeList加到alert_times前面
  addExtraTimeListToAlertTimes() {
    if (this.widget.flomoMissionModel?.alert_times == null) {
      this.widget.flomoMissionModel?.alert_times = [];
    }
    this.widget.flomoMissionModel?.alert_times.insertAll(0, extraTimeList);
  }

  void setEbbingList() {
    if (extraTimeList.length == 0) {
      extraTimeList.clear();
      extraTimeList.add(DateTime.now().millisecondsSinceEpoch + 20 * 60 * 1000);
      extraTimeList.add(DateTime.now().millisecondsSinceEpoch + 60 * 60 * 1000);
      extraTimeList
          .add(DateTime.now().millisecondsSinceEpoch + 8 * 60 * 60 * 1000);
    }
  }

  //通过repetiveType得到flomoRepeatModeEnum
  FlomoRepeatModeEnum getFlomoRepeatModeEnumByRepetiveType(int repetiveType) {
    switch (repetiveType) {
      case 1:
        return FlomoRepeatModeEnum.byDay;
      case 2:
        return FlomoRepeatModeEnum.byWeek;
      // case 2:
      //   break;
      case 3:
        return FlomoRepeatModeEnum.byEbbinghaus;
    }
    return FlomoRepeatModeEnum.byDay;
  }

  int getCurIndexByFlomoRepeatModeEnum(
      FlomoRepeatModeEnum flomoRepeatModeEnum) {
    switch (flomoRepeatModeEnum) {
      case FlomoRepeatModeEnum.byDay:
        return 0;
      case FlomoRepeatModeEnum.byWeek:
        return 1;
      // case FlomoRepeatModeEnum.byMonth:
      //   return 2;
      case FlomoRepeatModeEnum.byEbbinghaus:
        return 2;
    }
    return 0;
  }

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    // 提供一个column布局
    return SingleChildScrollView(
      child: Container(
        color: ThemeManager.getInstance().getBackgroundColor(defaultColor: ColorsConfig.backgroundColor),
        child: Column(
          children: <Widget>[
            // 圆角是10 placeholder是"输入您想要坚持的目标吧~"一个白色输入框 高度50左右
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
              ),
              height: 50,
              child: TextField(
                controller: TextEditingController(
                    text: this.widget.flomoMissionModel?.title),
                onChanged: (value) {
                  this.widget.flomoMissionModel?.title = value;
                },
                decoration: InputDecoration(
                  hintText: getI18NKey().input_your_goal,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(5),
                ),
              ),
            ),
            SizedBox(
              height: marginTop,
            ),
            // FlomoCard title推荐目标 rightChild是一个Wrap里有Icon和一个灰色的右箭头
            // child是一个Text
            FlomoCard(
              title: getI18NKey().icon,
              rightChild: Wrap(
                children: <Widget>[
                  this.widget.flomoMissionModel?.icon == null ? SizedBox.shrink() : IconWidget(icon: this.widget.flomoMissionModel!.icon!, color:  this.widget.flomoMissionModel?.color ?? 0xffff8800,)
                  // Icon(
                  //   Icons.add_circle_outline,
                  //   color: Colors.grey,
                  // ),
                  // Icon(
                  //   Icons.arrow_forward_ios,
                  //   color: Colors.grey,
                  // ),
                ],
              ),
              child: Column(
                children: [
                  ColorsGridViewWidget(
                      defaultIndexColor:
                          this.widget.flomoMissionModel?.color ?? -1,
                      onTapListener: (value) {
                        this.widget.flomoMissionModel?.color = value.color;
                        updateUI();
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 50,
                      child: IconsHorizontalListView(
                        defaultIndex: CONSTANTS.getSelectIconIndex(
                            this.widget.flomoMissionModel?.icon ?? -1),
                        onTapListener: (data) {
                          this.widget.flomoMissionModel?.icon =
                              data.icon.codePoint;
                          updateUI();
                        },
                        color: Color(this.widget.flomoMissionModel?.color ??
                            CONSTANTS.getColors()[0].color),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: marginTop,
            ),
            FlomoCard(
              title: getI18NKey().repeat_period,
              rightChild: Wrap(
                children: <Widget>[
                  BlackCheckButtonListWidget(
                    // flomoRepeatModeEnum.index
                    initIndex:
                        getCurIndexByFlomoRepeatModeEnum(flomoRepeatModeEnum),
                    backgroundColor: ThemeManager.getInstance().getDefautThemeColor(),
                    list: CONSTANTS.getFlomoRepeativeButtonList(),
                    onTapListener: (index) {
                      CheckButtonStateModel checkButtonStateModel =
                          CONSTANTS.getFlomoRepeativeButtonList()[index];
                      switch (checkButtonStateModel.code) {
                        case "byDay":
                          if (this.widget.pageModeEnum == 0) {
                            extraTimeList.clear();
                          }
                          this.widget.flomoMissionModel?.repetiveType = 1;
                          flomoRepeatModeEnum = FlomoRepeatModeEnum.byDay;
                          break;
                        case "byWeek":
                          if (this.widget.pageModeEnum == 0) {
                            extraTimeList.clear();
                          }
                          this.widget.flomoMissionModel?.repetiveType = 2;
                          flomoRepeatModeEnum = FlomoRepeatModeEnum.byWeek;
                          break;
                        case "byEbbinghaus":
                          if (this.widget.pageModeEnum == 0) {
                            setEbbingList();
                          }
                          this.widget.flomoMissionModel?.repetiveType = 3;
                          flomoRepeatModeEnum =
                              FlomoRepeatModeEnum.byEbbinghaus;
                          break;
                      }
                      updateUI();
                    },
                  ),
                  // Icon(
                  //   Icons.arrow_forward_ios,
                  //   color: Colors.grey,
                  // ),
                ],
              ),
              // child: Container(height: 50, child: Container(child: InputNumber(onValueChangeListener: (obj, int? durationEachTomato) {  },),)),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  height:
                      flomoRepeatModeEnum == FlomoRepeatModeEnum.byEbbinghaus
                          ? 220
                          : null,
                  child: flomoRepeatModeEnum == FlomoRepeatModeEnum.byEbbinghaus
                      ? MonthCalendar(
                          monthDates:
                              CONSTANTS.generateEbbinghausDatesByDayByDay(
                                  Utility.getDateTimeFromTimeStamp(this
                                          .widget
                                          .flomoMissionModel
                                          ?.start_time ??
                                      DateTime.now().millisecondsSinceEpoch),
                                  this.widget.flomoMissionModel?.end_time !=
                                          null
                                      ? Utility.getDateTimeFromTimeStamp(this
                                              .widget
                                              .flomoMissionModel
                                              ?.end_time ??
                                          0)
                                      : DateTime.now().add(Duration(days: 20))))
                      : flomoRepeatModeEnum == FlomoRepeatModeEnum.byWeek
                          ? WeekendWidget(
                              colorCheck: ThemeManager.getInstance().getDefautThemeColor(),
                              colorUncheck: Color(ThemeManager.getInstance().getDefautThemeColorInt() - 0x60000000),
                              list: listWeekendCheckModels,
                              onCheckedListener: (obj) {
                                if (this
                                            .widget
                                            .flomoMissionModel
                                            ?.repetiveWeekDay ==
                                        null ||
                                    this
                                            .widget
                                            .flomoMissionModel
                                            ?.repetiveWeekDay
                                            ?.length ==
                                        0)
                                  this
                                      .widget
                                      .flomoMissionModel
                                      ?.repetiveWeekDay = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                  ];
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[0] =
                                    listWeekendCheckModels[0].isChecked;
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[1] =
                                    listWeekendCheckModels[1].isChecked;
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[2] =
                                    listWeekendCheckModels[2].isChecked;
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[3] =
                                    listWeekendCheckModels[3].isChecked;
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[4] =
                                    listWeekendCheckModels[4].isChecked;
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[5] =
                                    listWeekendCheckModels[5].isChecked;
                                this
                                        .widget
                                        .flomoMissionModel
                                        ?.repetiveWeekDay?[6] =
                                    listWeekendCheckModels[6].isChecked;
                              },
                            )
                          : SizedBox.shrink()),
            ),
            SizedBox(
              height: marginTop,
            ),
            FlomoCard(
              title: getI18NKey().alert_time,
              // child: Container(height: 50, child: Container(child: InputNumber(onValueChangeListener: (obj, int? durationEachTomato) {  },),)),
              rightChild: Wrap(children: <Widget>[
                BlackCheckButtonListWidget(
                  initIndex: this.widget.flomoMissionModel?.is_alert_on == true
                      ? 1
                      : 0,
                  backgroundColor: ThemeManager.getInstance().getDefautThemeColor(),
                  list: CONSTANTS.getOnAndOffButtonList(),
                  onTapListener: (obj) {
                    this.widget.flomoMissionModel?.is_alert_on =
                        CONSTANTS.getOnAndOffButtonList()[obj].isCheck;
                  },
                ),
                // Icon(
                //   Icons.arrow_forward_ios,
                //   color: Colors.grey,
                // ),
              ]),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: TimesGridViewWidget(
                    onTapDeleteTagListener: (data) {
                      //加了这个 才会刷新提醒时间
                      shouldRefreshPushModelList = true;
                      this.widget.flomoMissionModel?.alert_times?.remove(data);
                      updateUI();
                    },
                    onTapAddTimeListener: (datas) {
                      this.widget.flomoMissionModel?.alert_times = datas;
                      shouldRefreshPushModelList = true;
                      updateUI();
                    },
                    datas: (this.widget.flomoMissionModel?.alert_times ?? []), extraDatasWithoutAction: extraTimeList,
                  )),
            ),

            SizedBox(
              height: marginTop,
            ),
            FlomoCard(
              title: getI18NKey().target_time,
              child: Column(
                children: [
                  FlomoMenuItem(
                    title: "",
                    subTitle: "",
                    onTapListener: (data) {
                      this.onClick('onClickSelectTomatoes', null);
                    },
                    rightPartContainers: [
                      Expanded(
                          child: FlomoTimeWidget(
                        title: getI18NKey().start_time,
                        date: this.widget.flomoMissionModel?.start_time != null
                            ? Utility.getDateTimeYMD(
                                Utility.getDateTimeFromTimeStamp(
                                    this.widget.flomoMissionModel?.start_time ??
                                        0))
                            : getI18NKey().please_select_content(getI18NKey().start_time),
                        today: Utility.isTodayByTimestamp(
                                this.widget.flomoMissionModel?.start_time ?? 0)
                            ? getI18NKey().today
                            : "",
                      )),
                      // Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.grey,
                      // ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onClickPickPeriod(context);
                          },
                          child: FlomoTimeWidget(
                            title: getI18NKey().end_time,
                            date:
                                this.widget.flomoMissionModel?.end_time != null
                                    ? Utility.getDateTimeYMD(
                                        Utility.getDateTimeFromTimeStamp(this
                                                .widget
                                                .flomoMissionModel
                                                ?.end_time ??
                                            0))
                                    : getI18NKey().please_select_content(getI18NKey().end_time),
                            today: getI18NKey().num_days(
                                this.widget.flomoMissionModel?.clocks_days ??
                                    0),
                          ),
                        ),
                      )
                    ],
                    icon: Utility.getSVGPicture(R.assetsImgIcThisWeek,
                        size: StylesConfig.iconSize),
                  ),
                  FlomoMenuItem(
                      title: getI18NKey().daily_completion_times,
                      subTitle: "",
                      onTapListener: (data) {
                        this.onClick('onClickSelectTomatoes', null);
                      },
                      rightPartContainer: InputNumber(
                        defaultVal:
                            this.widget.flomoMissionModel?.daily_num_times ?? 1,
                        onValueChangeListener: (v, duration) {
                          print("onValueChangeListener");
                          this.widget.flomoMissionModel?.daily_num_times = v;
                          // this.onClick('onClickChangeTomatoesNum',
                          //     {"count": v, "duration": duration});
                        },
                        unit: getI18NKey().times,
                      ),
                      icon: Utility.getSVGPicture(R.assetsImgIcFocusOrange,
                          size: StylesConfig.iconSize)),
                  FlomoMenuItem(
                      icon: Utility.getSVGPicture(R.assetsImgIcLoudspeaker,
                          size: StylesConfig.iconSize),
                      title: "",
                      onTapListener: (data) {
                        this.onClick('onClickSelectTomatoes', null);
                      },
                      rightPartContainer: TextField(
                        controller: TextEditingController(
                            text: this
                                .widget
                                .flomoMissionModel
                                ?.inspration_message),
                        onChanged: (v) {
                          this.widget.flomoMissionModel?.inspration_message =
                              v;
                        },
                        decoration: InputDecoration(
                          hintText: getI18NKey().encourage_yourself,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(5),
                        ),
                      )),
                ],
              ),
            ),
            // FlomoCard title我的目标 rightChild是一个Wrap里有Icon和一个灰色的右箭头
            // child是一个Text
          ],
        ),
      ),
    );
  }

  void onClickPickPeriod(BuildContext context) {

    DialogManagement.getInstance()
        .showCustomDialogWithSmallButtons(context,
            // okTitle: getI18NKey().i_know,
            child: Container(
                child: FlomoPickPeriodDialogWidget(
                    key:
                        FlomoPickPeriodDialogWidgetStateGlobalKey,
                    onChange:
                        (code, isCheck, endTime) {})),
            title: getI18NKey().target_duration_period, okCallback: () {
      switch (FlomoPickPeriodDialogWidgetStateGlobalKey
          .currentState?.code) {
        case "21":
          this.widget.flomoMissionModel?.clocks_days =
              21;
          this.widget.flomoMissionModel?.end_time =
              (this
                          .widget
                          .flomoMissionModel
                          ?.start_time ??
                      0) +
                  21 * 24 * 60 * 60 * 1000;
          break;
        case "one_month":
          this.widget.flomoMissionModel?.clocks_days =
              30;
          this.widget.flomoMissionModel?.end_time =
              (this
                          .widget
                          .flomoMissionModel
                          ?.start_time ??
                      0) +
                  30 * 24 * 60 * 60 * 1000;
          break;
        case "three_month":
          this.widget.flomoMissionModel?.clocks_days =
              90;
          this.widget.flomoMissionModel?.end_time =
              (this
                          .widget
                          .flomoMissionModel
                          ?.start_time ??
                      0) +
                  90 * 24 * 60 * 60 * 1000;
          break;
        case "six_month":
          this.widget.flomoMissionModel?.clocks_days =
              180;
          this.widget.flomoMissionModel?.end_time =
              (this
                          .widget
                          .flomoMissionModel
                          ?.start_time ??
                      0) +
                  180 * 24 * 60 * 60 * 1000;
          break;
        case "one_year":
          this.widget.flomoMissionModel?.clocks_days =
              365;
          this.widget.flomoMissionModel?.end_time =
              (this
                          .widget
                          .flomoMissionModel
                          ?.start_time ??
                      0) +
                  365 * 24 * 60 * 60 * 1000;
          break;
        case "customize":
          // this.widget.flomoMissionModel?.clocks_days = end
          this.widget.flomoMissionModel?.end_time =
              FlomoPickPeriodDialogWidgetStateGlobalKey
                      .currentState?.endTime ??
                  -1;
          this.widget.flomoMissionModel?.clocks_days =
              Utility.getDayDiffByDayFromTimeStamp(
                  FlomoPickPeriodDialogWidgetStateGlobalKey
                          .currentState?.endTime ??
                      0,
                  this
                          .widget
                          .flomoMissionModel
                          ?.start_time ??
                      0);
          break;
      }
      updateUI();
      DialogManagement.getInstance()
          .hideDialog(context);
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(context);
    });
  }
}
