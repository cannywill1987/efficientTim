import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/ChartTitleWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/ProgressBarWidget.dart';
import '../../../models/FolderModelWithExtraData.dart';
import '../../../models/StatsModel.dart';
import '../chartsComponents/FocusDistributionMissionCircleChart.dart';

class FocusDurationDistributionWidget extends StatelessWidget {
  // String title;
  // String value;
  // double percent;
  // Color color;
  // List<StatsModel> list;
  List<FolderModelWithExtraData>? datasFolderModelWithExtraData = [];
  String totalFocusTimeValue;
  FocusDurationDistributionWidget({
    required this.datasFolderModelWithExtraData,
    this.totalFocusTimeValue = "",
    // required this.title,
    // required this.value,
    // required this.percent,
    // required this.color
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: getList(),
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> list = [];
    list.add(ChartTitleWidget(
        key: ValueKey('12133ze'),
        title: getI18NKey().total_focus_duration, value: this.totalFocusTimeValue));
    list.add(FocusDistributionMissionCircleChart(
      key: ValueKey('12133zg'),
      datasFolderModelWithExtraData: datasFolderModelWithExtraData, onTapItem: (v){

    },
    ));
    for (int i = 0;
        i < ((datasFolderModelWithExtraData?.length ?? 0) - 1);
        i = i + 2) {
      FolderModelWithExtraData data1 = datasFolderModelWithExtraData![i];
      FolderModelWithExtraData data2 = datasFolderModelWithExtraData![i + 1];
      list.add(Row(
        key: ValueKey('12133zeq$i'),
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              key: ValueKey('12133zegw$i'),
              child: FocusProgressBarWidgetItem(
                key: ValueKey('12133zegwx$i'),
            title: data1.folderModel.title ?? "",
            color: Color(data1.folderModel.color == 0
                ? 0xffff8800
                : data1.folderModel.color),
            percent: data1.folderTimeModel.numMissionToFinished == 0
                ? 0
                : (data1.folderTimeModel?.numMissionToFinished ?? 0)
                        .toDouble() /
                    ((data1.folderTimeModel?.numMissionToFinished ?? 0)
                            .toDouble() +
                        (data1.folderTimeModel?.numMissionFinished ?? 0)
                            .toDouble()),
            value: Utility.formatHourAndMin(data1.folderTimeModel.finishedTime ?? 0),
          )),
          SizedBox(
            width: 25,
          ),
          Expanded(
              child: FocusProgressBarWidgetItem(
            title: data2.folderModel.title ?? "",
            color: Color(data2.folderModel.color == 0
                ? 0xffff8800
                : data2.folderModel.color),
            percent: data2.folderTimeModel.numMissionToFinished == 0
                ? 0
                : (data2.folderTimeModel?.numMissionToFinished ?? 0)
                        .toDouble() /
                    ((data2.folderTimeModel?.numMissionToFinished ?? 0) +
                        (data2.folderTimeModel?.numMissionFinished ?? 0)
                            .toDouble()),
            value: Utility.formatHourAndMin(data2.folderTimeModel.finishedTime ?? 0),
          )),
        ],
      ));
    }
    if (((datasFolderModelWithExtraData?.length ?? 0) % 2) == 1) {
      FolderModelWithExtraData data = datasFolderModelWithExtraData![
          datasFolderModelWithExtraData!.length - 1];
      list.add(Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: FocusProgressBarWidgetItem(
            title: data.folderModel.title ?? "",
            color: Color(data.folderModel.color == 0
                ? 0xffff8800
                : data.folderModel.color),
            percent: data.folderTimeModel.numMissionToFinished == 0
                ? 0
                : (data.folderTimeModel?.numMissionToFinished ?? 0) /
                    ((data.folderTimeModel?.numMissionToFinished ?? 0) +
                        (data.folderTimeModel?.numMissionFinished ?? 0)),
            value: Utility.formatHourAndMin(data.folderTimeModel.finishedTime ?? 0),
          )),
          SizedBox(
            width: 25,
          ),
          Expanded(child: Container()),
        ],
      ));
    }

    list.add(SizedBox(
      height: 10,
    ));
    return list;
  }
}

class FocusProgressBarWidgetItem extends StatelessWidget {
  String title;
  Color color;
  String value;
  double percent;

  FocusProgressBarWidgetItem(
      {Key? key, required this.color,
      required this.title,
      required this.percent,
      required this.value}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      key: ValueKey('12133zegwfw'),
      children: [
        Row(
          key: ValueKey('12133zegwfzw'),
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                key: ValueKey('12133zegwfwq'),
                child: Text(
              this.title,
                  key: ValueKey('12133zegwfwz'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  decoration: TextDecoration.none),
            )),
            Text(
              this.value,
              key: ValueKey('12133zegwfwe'),
              style: TextStyle(
                  color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.none),
            )
          ],
        ),
        Row(
          key: ValueKey('121q33zegwfw'),
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                key: ValueKey('12133zeggwfw'),
                child: ProgressBarWidget(
              percent: this.percent,
              color: color,
            )),
            SizedBox(
              key: ValueKey('121aewfw'),
              width: 8,
            ),
            Container(
              key: ValueKey('12aw1aewfw'),
              width: 30,
              child: Text(
                Utility.getPercent(this.percent),
                key: ValueKey('121aewfg'),
                style: TextStyle(
                    color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff9a9b9e)),
                    fontSize: 11,
                    decoration: TextDecoration.none),
              ),
            )
          ],
        ),
      ],
    );
  }
}
