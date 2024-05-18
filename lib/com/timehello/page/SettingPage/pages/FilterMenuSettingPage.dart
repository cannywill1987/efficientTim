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

class FilterMenuSettingPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    // TODO: implement getState
    return FilterMenuSettingPageState();
  }
}

class FilterMenuSettingPageState
    extends BaseWidgetState<FilterMenuSettingPage> {
  List<CheckButtonStateModel> list = CONSTANTS.getCheckButtonStateModelList();

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
        // subTitle: "(${getI18NKey().optional})",
        onTapListener: (data) async {
          // onTapListener.call(data);
          print(11111);
        },
        rightPartContainer:
            getDropDown(data, (CheckButtonStateModel checkButtonStateModel) {
          checkButtonStateModel.value;
          print(11111);
          setSettingModel(data.code ?? "", checkButtonStateModel.value);
        }),
        icon: data.checkIcon ?? SizedBox.shrink());
  }

  /**
   * today tomorrow this_week all_unfinished_missions todo_listing_mission fragment_listing_mission
   */
  setSettingModel(String code, value) {
    switch (code) {
      case "today":
        SettingManager.getSyncInstance().setIsListingTodayOn(value);
        break;
      case "do_it_now":
        SettingManager.getSyncInstance().setIsListingDoItNowOn(value);
        // SettingManager.getSyncInstance().isListingDoItNowOn = value;
        break;
      case "tomorrow":
        SettingManager.getSyncInstance().setIsListingTomorrowOn(value);
        // SettingManager.getSyncInstance().isListingTomorrowOn = value;
        break;
      case "this_week":
        SettingManager.getSyncInstance().setIsListingLatest7DaysOn(value);
        // SettingManager.getSyncInstance().isListingLatest7DaysOn = value;
        break;
      case "all_unfinished_missions":
        SettingManager.getSyncInstance()
            .setIsListingAllUnfinishedMIssion(value);
        // SettingManager.getSyncInstance().isListingAllUnfinishedMIssion = value;
        break;
      case "todo_listing_mission":
        SettingManager.getSyncInstance().setIsListingTodoListOn(value);
        // SettingManager.getSyncInstance().isListingTodoListOn = value;
        break;
      case "fragment_listing_mission":
        SettingManager.getSyncInstance().setIsListingFragmentOn(value);
        // SettingManager.getSyncInstance().isListingFragmentOn = value;
        break;
      case "all_finished_missions":
        SettingManager.getSyncInstance().setIsListingFinishedOn(value);
        break;
      case "all_missions":
        SettingManager.getSyncInstance().setIsListingAllOn(value);
        break;
      case 'AIHelper':
        SettingManager.getSyncInstance().setIsAIHelperPageOn(value);
        break;
    }
    updateUI();
  }

  // int isListingTodayOn = 1;
  // int isListingDoItNowOn = 1;
  // int isListingTomorrowOn = 1;
  // int isListingLatest7DaysOn = 1;
  // int isListingTodoListOn = 1;
  // int isListingFragmentOn = 1;
  // int isListingAllUnfinishedMIssion = 1;
  // int isListingFinishedOn = 1;
  // int isListingAllOn = 1;
  int getSettingModelVal(String code) {
    switch (code) {
      case "today":
        return SettingManager.getSyncInstance().isListingTodayOn;
      case "tomorrow":
        return SettingManager.getSyncInstance().isListingTomorrowOn;
      case "this_week":
        return SettingManager.getSyncInstance().isListingLatest7DaysOn;
      case "all_unfinished_missions":
        return SettingManager.getSyncInstance().isListingAllUnfinishedMission;
      case "todo_listing_mission":
        return SettingManager.getSyncInstance().isListingTodoListOn;
      case "fragment_listing_mission":
        return SettingManager.getSyncInstance().isListingFragmentOn;
      case "all_finished_missions":
        return SettingManager.getSyncInstance().isListingFinishedOn;
      case "all_missions":
        return SettingManager.getSyncInstance().isListingAllOn;
      case "do_it_now":
        return SettingManager.getSyncInstance().isListingDoItNowOn;
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
        list: CONSTANTS.getMenuCheckButtonStateModelList(),
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
