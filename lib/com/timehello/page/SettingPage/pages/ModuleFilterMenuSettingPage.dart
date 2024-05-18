import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/MenuItem2.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/SettingModel.dart';
import 'package:time_hello/com/timehello/util/SettingManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class ModuleFilterMenuSettingPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    // TODO: implement getState
    return ModuleFilterMenuSettingPageState();
  }
}

class ModuleFilterMenuSettingPageState
    extends BaseWidgetState<ModuleFilterMenuSettingPage> {
  List<CheckButtonStateModel> list = CONSTANTS.getModuleFilerintCheckButtonStateModelList();

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: getList(),
        ),
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> listWidgets = [];
    for (int i = 0; i < list.length; i++) {
      listWidgets.add(getItem(list[i]));
    }
    return listWidgets;
  }

  Widget getItem(CheckButtonStateModel data) {
    return MenuItem2(
        title: data.title ?? "",
        onTapListener: (data) async {
        },
        rightPartContainer:
            getDropDown(data, (CheckButtonStateModel checkButtonStateModel) {
          checkButtonStateModel.value;
          setSettingModel(data.code ?? "", checkButtonStateModel.value);
        }),
        icon: data.checkIcon ?? SizedBox.shrink());
  }

  /**
   * today tomorrow this_week all_unfinished_missions todo_listing_mission fragment_listing_mission
   */
  setSettingModel(String code, value) {
    switch (code) {
      case "TomatoPage":
        SettingManager.getSyncInstance().setIsTomatoPageOn(value);
        break;
      case "TimeManagementPage":
        SettingManager.getSyncInstance().setIsTimeManagementPageOn(value);
        break;
      case "CalendarContainerPage":
        SettingManager.getSyncInstance().setIsCalendarContainerPageOn(value);
        break;
      case "FourQuadrantPage":
        SettingManager.getSyncInstance().setIsFourQuadrantPageOn(value);
        break;
      case "TimelinePage":
        SettingManager.getSyncInstance().setIsTimelinePageOn(value);
        break;
      case "ClockInPCPage":
        SettingManager.getSyncInstance().setIsClockInPCPageOn(value);
        break;
      case "WQBContainer":
        SettingManager.getSyncInstance().setIsWQBContainerOn(value);
        break;
      case "CountDownListViewPage":
        SettingManager.getSyncInstance().setIsCountDownListViewPageOn(value);
        break;
        case "GamePage":
        SettingManager.getSyncInstance().setIsGamePageOn(value);
          break;

      case "LockScreenPage":
        SettingManager.getSyncInstance().setIsLockScreenPageOn(value);
        break;
      case "StatisticPage":
        SettingManager.getSyncInstance().setIsStatisticPageOn(value);
        break;
        case "AIHelper":
        SettingManager.getSyncInstance().setIsAIHelperPageOn(value);
          break;

    }
    updateUI();
  }

  int getSettingModelVal(String code) {
    switch (code) {
      case "TomatoPage":
        return SettingManager.getSyncInstance().isTomatoPageOn;
      case "TimeManagementPage":
        return SettingManager.getSyncInstance().isTimeManagementPageOn;
      case "CalendarContainerPage":
        return SettingManager.getSyncInstance().isCalendarContainerPageOn;
      case "FourQuadrantPage":
        return SettingManager.getSyncInstance().isFourQuadrantPageOn;
      case "TimelinePage":
        return SettingManager.getSyncInstance().isTimelinePageOn;
      case "ClockInPCPage":
        return SettingManager.getSyncInstance().isClockInPCPageOn;
      case "WQBContainer":
        return SettingManager.getSyncInstance().isWQBContainerOn;
      case "CountDownListViewPage":
        return SettingManager.getSyncInstance().isCountDownListViewPageOn;
      case "GamePage":
        return SettingManager.getSyncInstance().isGamePageOn;
      case "LockScreenPage":
        return SettingManager.getSyncInstance().isLockScreenPageOn;
      case "StatisticPage":
        return SettingManager.getSyncInstance().isStatisticPageOn;
      case "SettingPage":
        return SettingManager.getSyncInstance().isSettingPageOn;
      case "AIHelper":
        return SettingManager.getSyncInstance().isAIHelperPageOn;
    }
    return 1;
  }

  /**
   * 下拉框 三个选择， 有内容显示，显示，隐藏
   */
  Widget getDropDown(CheckButtonStateModel data, Function onTapListener) {
    int viewStatus = getSettingModelVal(data.code ?? "");
    return Container(
      padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ThemeManager.getInstance().getBackgroundColor(),
        border: Border.all(
            color: ThemeManager.getInstance().getDefautThemeColor(), width: 1),
      ),
      child: CustomPopupWidget(
        onSelected: (v) {
          onTapListener.call(v);
          // if (this.widget.onTapDateListener != null) {
          //   this.widget.onTapDateListener?.call(v.value);
          // }
        },
        list: CONSTANTS.getModuleCheckButtonStateModelList(),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              viewStatus == 1
                  ? getI18NKey().popup_visible2
                  : viewStatus == 0
                      ? getI18NKey().popup_invisible3
                      : getI18NKey().popup_select1,
              style: TextStyle(
                  fontSize: 11,
                  color: ThemeManager.getInstance().getTextColor()),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: ThemeManager.getInstance().getDefautThemeColor(),
            )
          ],
        ),
      ),
      // child: Row(
      //   children: [
      //     Text("显示"),

      //   ],
      // ),
    );
  }
}
