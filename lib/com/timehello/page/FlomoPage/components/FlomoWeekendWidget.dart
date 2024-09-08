import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/CheckContainer.dart';
import '../../../models/CalendarModel.dart';
import 'FlomoCheckContainer.dart';

typedef OnCheckedListener = void Function(dynamic obj);

class FlomoWeekendWidget extends StatelessWidget {
  Function onCheckedListener;
  List<DayModel> list;
  Color? colorCheck = Color(ThemeManager.getInstance().getDefautThemeColorInt());
  Color colorUncheck = Color(ThemeManager.getInstance().getDefautThemeColorInt() - 0xf0000000);
  double margin = 3;

  FlomoWeekendWidget(
      {Key? key,
      Color? colorCheck,
      Color? colorUncheck,
      required this.list,
      required this.onCheckedListener})
      : super(key: key) {
    if (colorCheck == null) {
      this.colorCheck = Color(ThemeManager.getInstance().getDefautThemeColorInt());
    } else {
      this.colorCheck = colorCheck;
    }
    if (colorUncheck == null) {
      this.colorUncheck = Color(ThemeManager.getInstance().getDefautThemeColorInt() - 0xf0000000);
    } else {
      this.colorCheck = colorUncheck;
    }
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return new FlomoWeekendWidgetState(list = this.list);
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...getListWidget()
      ],
    );
  }

  List<Widget> getListWidget() {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      DayModel dayModel = list[i];
      listWidget.add(
        Expanded(
          child: FlomoCheckContainer(
            height: 75,
            checked: dayModel.isCheck,
            onCheckedListener: (bool isChecked, dynamic data) {
              // dayModel.isCheck = true;
              if (this.onCheckedListener != null) {
                this.onCheckedListener(dayModel);
              }
            },
            checkWidget: getDayWidget(dayModel),
            uncheckWidget: getDayWidget(dayModel),
          ),
        ),
      );
      listWidget.add(
        SizedBox(
          width: this.margin,
        ),
      );
    }
    return listWidget;
  }

  Widget getDayWidget(DayModel dayModel) {
    double fontSize = 11;
    double fontSize2 = 10;
    return Container(
      // width: 85,
      // height: 85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Utility.getWeekendDayStringByWeekend(
                  dayModel.weekday ?? -1),
              textAlign: TextAlign.center,
              style:TextStyle(
                  color: ThemeManager.getInstance().getDefautThemeColor(), fontSize: fontSize),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: dayModel.isCheck
                          ? this.colorCheck
                          : this.colorUncheck,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dayModel.isCurrent ? getI18NKey().today :
                      Utility.formatDecimal(dayModel.day ?? 1,
                          shouldAddZero: true),
                        textAlign: TextAlign.center,
                        style: dayModel.isCheck
                            ? TextStyle(color: Colors.white, fontSize: fontSize2)
                            : TextStyle(
                            color: this.colorCheck, fontSize: fontSize2),
                      ),
                      if(Utility.isChina())
                      Text(dayModel?.lunarDay ?? "",
                        textAlign: TextAlign.center,
                        style: dayModel.isCheck
                            ? TextStyle(color: Colors.white, fontSize: fontSize2-3)
                            : TextStyle(
                            color: this.colorCheck, fontSize: fontSize2-3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            dayModel.flomoMissionModelList.length > 0 ? Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: ThemeManager.getInstance().getLeftMenuColor(defaultColor: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(200)),
                border: Border.all(color: Color(ThemeManager.getInstance().getDefautThemeColorInt()), width: 1),
              ),
              child: Text(getI18NKey().num_of_total(Utility.getNumClocksMissionFinished(dayModel), Utility.filterFlomoMissionModelByFinishedState(list: dayModel.flomoMissionModelList, isFinished: false).length), style: TextStyle(color: ThemeManager.getInstance().getDefautThemeColor(), fontSize: 10),),

            ) : SizedBox(height: 15,)
          ],
        ));
  }
}

