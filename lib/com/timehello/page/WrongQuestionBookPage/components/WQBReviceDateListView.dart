import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/components/WQBTitle.dart';

import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/FlomoMissionModel.dart';
import '../../../util/Utility.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';


class WQBReviceDateListView extends StatefulWidget {
  FlomoMissionModel flomoMissionModel;
  final ValueChanged<bool?>? onCheckboxChanged;

  WQBReviceDateListView({
    required this.flomoMissionModel,
    this.onCheckboxChanged,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBReviceDateListViewState();
  }
}

class WQBReviceDateListViewState extends State<WQBReviceDateListView> {
  List<DateTime> dateTimeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.widget.flomoMissionModel?.clocks_days = 21;
    this.widget.flomoMissionModel?.start_time = Utility.getTimeStampToday();
    this.widget.flomoMissionModel?.end_time =
        (this.widget.flomoMissionModel?.start_time ?? 0) +
            (this.widget.flomoMissionModel?.clocks_days ?? 21) *
                24 *
                60 *
                60 *
                1000;
    setEbbingList(this.widget.flomoMissionModel);
  }

  void setEbbingList(FlomoMissionModel flomoMissionModel) {
    // if (extraTimeList.length == 0) {
    flomoMissionModel.alert_times.clear();
    flomoMissionModel.alert_times
        .add(DateTime.now().millisecondsSinceEpoch + 20 * 60 * 1000);
    flomoMissionModel.alert_times
        .add(DateTime.now().millisecondsSinceEpoch + 60 * 60 * 1000);
    flomoMissionModel.alert_times
        .add(DateTime.now().millisecondsSinceEpoch + 8 * 60 * 60 * 1000);

    CONSTANTS
        .generateEbbinghausDatesByDayByDay(
            Utility.getDateTimeFromTimeStamp(flomoMissionModel?.start_time ??
                DateTime.now().millisecondsSinceEpoch),
            flomoMissionModel?.end_time != null
                ? Utility.getDateTimeFromTimeStamp(
                    flomoMissionModel?.end_time ?? 0)
                : DateTime.now().add(Duration(days: 20)))
        .forEach((element) {
      if (element != null) {
        dateTimeList.add(element);
      }
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // WQBTitle(title: "复习周期"),
    return Column(children: [
      TitleContainerWidget(
        title: "复习周期",
      ),
      Container(
          width: double.infinity,
          height: 2,
          color: ColorsConfig.borderLineColor),
      Container(
        constraints: BoxConstraints(minHeight: 100, maxHeight: 120),
          child: SingleChildScrollView(
              child: Column(
        children: getWidgetList(),
      ))),
    ]);
  }

  List<Widget> getWidgetList() {
    return List.generate(dateTimeList.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Color(0xff404040), width: 1),
              ),
              child: Center(
                child: Text(
                  '${Utility.getDifTime(dateTimeList[index])}',
                  style: TextStyle(color: Color(0xff404040)),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '${dateTimeList[index].month}',
              style: TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              getI18NKey().month,
              style: TextStyle(color: Color(0xff404040)),
            ),
            Text(
              '${dateTimeList[index].day}',
              style: TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              getI18NKey().day,
              style: TextStyle(color: Color(0xff404040)),
            ),
            SizedBox(
              width: 10,
            ),
            Checkbox(
              value: false,
              onChanged: this.widget.onCheckboxChanged,
            ),
          ],
        ),
      );
    });
  }
}
