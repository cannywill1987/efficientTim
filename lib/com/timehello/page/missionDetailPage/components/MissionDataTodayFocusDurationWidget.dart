/// Package import
import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_hello/com/timehello/util/StatisticUtility.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../common/database/apis/MongoApisManager.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../config/Params.dart';
import '../../../models/BarModel.dart';
import '../../../models/EventFn.dart';
import '../../../models/MissionModel.dart';
import '../../../models/StatsModel.dart';
import 'dart:math' as math;

import '../../../util/ThemeManager.dart';
import '../../../util/Utility.dart';

/// Local import

///Renders default line series chart
class MissionDataTodayFocusDurationWidget extends StatefulWidget {
  // List<StatsModel> listStatsModelFinished = [];


  ///Creates default line series chart
  MissionDataTodayFocusDurationWidget() {
    // this.data = data;
  }

  @override
  _MissionDataTodayFocusDurationWidgetState createState() => _MissionDataTodayFocusDurationWidgetState();
}

class _MissionDataTodayFocusDurationWidgetState extends State<MissionDataTodayFocusDurationWidget> {
  // _MissionDataTodayFocusDurationWidgetState();
  BarModelList? data;
  CalendarTypeEnum calendarTypeEnum = CalendarTypeEnum.day;
  List<StatsModel> listStatsModel = [];
  // List<StatsModel> listStatsModelFinished = []; //用于StatsPage头部的数据
  // List<StatsModel> listStatsModelFinishedPrev = []; //用于StatsPage头部的数据
  int horizontalLineInterVal = 1;
  int verticalInterVal = 1;
  double interval = 1;
  int maxYVal = 10;
  int base = 1;
  String unit = ''; //单位
  // double width = 0;
  double barWidth = 4;
  double groupSpace = 10;
  List<String> xList = [];
  String totalDurationHours = "00";
  String totalDurationMins = "00";
  // List<ResourceDeliveryInfoBean> pcRightTopResourceDataList =
  // CONSTANTS.getPCRightTopDefaultRessourceData();
  TooltipBehavior? _tooltipBehavior;
  // BarModelList dataMissionNumbers = BarModelList(); //用于显示任务数的chart
  // BarModelList dataPrev = BarModelList();

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    // List<BarChartGroupData> listBarChartGroupData = getBarGroups();
    super.initState();
    this.requestDatas(1);

    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_STATISTIC) {
        if(mounted)
        requestDatas(1);
        // Future.delayed(Duration(seconds: 1), () {
        //   // this.requestDatas();
        // });
      }
    });
  }

  void requestDatas(int segmentControl) {
    DateTime dateTime = DateTime.now();
    // DateTime dateTimeStart = DateTime(dateTime.year, dateTime.month, dateTime.day);
    //这次完成任务总数
    DateTime dateTimeStart = Utility.getDateTimeFromTimeStamp(segmentControl ==
        1
        ? Utility.getFilterDateTimeFromTimeStamp(
        dateTime.millisecondsSinceEpoch)
        .millisecondsSinceEpoch
        : segmentControl == 2
        ? Utility.getFilterDateTimeFromTimeStamp(
        dateTime.millisecondsSinceEpoch - 7 * 24 * 60 * 60 * 1000)
        .millisecondsSinceEpoch
        : Utility.getFilterDateTimeFromTimeStamp(
        dateTime.millisecondsSinceEpoch - 30 * 24 * 60 * 60 * 1000)
        .millisecondsSinceEpoch);
    DateTime dateTimePrev = Utility.getDateTimeFromTimeStamp(segmentControl == 1
        ? (dateTimeStart.millisecondsSinceEpoch - 24 * 60 * 60 * 1000)
        : segmentControl == 2
        ? (dateTimeStart.millisecondsSinceEpoch - 7 * 24 * 60 * 60 * 1000)
        : (dateTimeStart.millisecondsSinceEpoch -
        30 * 24 * 60 * 60 * 1000)); //和上周比
    // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
    listStatsModel = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
        start_endTime: dateTimeStart.millisecondsSinceEpoch,
        end_endTime: dateTime.millisecondsSinceEpoch); //用于charts数据
    // listStatsModelFinished = MongoApisManager.getInstance()
    //     .queryWhereEqual_statModelsByTime(
    //     type: 1,
    //     start_endTime: dateTimeStart.millisecondsSinceEpoch,
    //     end_endTime: dateTime.millisecondsSinceEpoch); //用于StatsPage头部的数据
    // listStatsModelFinishedPrev = MongoApisManager.getInstance()
    //     .queryWhereEqual_statModelsByTime(
    //     type: 1,
    //     start_endTime: dateTimePrev.millisecondsSinceEpoch,
    //     end_endTime:
    //     dateTimeStart.millisecondsSinceEpoch); //用于StatsPage头部的数据

    Map<String, BarModelList>? map = StatisticUtility.filterStatsModelToBarModel(
        segmentControl == 1
            ? DateTypeEnum.day //今天数据
            : segmentControl == 2
            ? DateTypeEnum.last7Days //近七天数据
            : DateTypeEnum.lastMonth, //本月数据
        listStatsModel,
        StatisticTypeEnum.time);
    double duration = 0;
    for (int i =0; i < listStatsModel.length; i++) {
      duration += listStatsModel[i].duration ?? 0;
    }
    // Map<String, BarModelList>? mapDataMissionNumbers =
    // StatisticUtility.filterStatsModelToBarModel(
    //     segmentControl == 1
    //         ? DateTypeEnum.day //今天数据
    //         : segmentControl == 2
    //         ? DateTypeEnum.last7Days //近七天数据
    //         : DateTypeEnum.lastMonth, //本月数据
    //     listStatsModelFinished,
    //     StatisticTypeEnum.number);

    this.data = map?['BarModelList'] ?? BarModelList();
    // this.dataPrev = map?['BarModelListPrev'] ?? BarModelList();
    this.totalDurationHours = Utility.getHour(duration.toInt());
    this.totalDurationMins = Utility.getMins(duration.toInt());
    // dataMissionNumbers = mapDataMissionNumbers?['BarModelList'] ?? BarModelList();

    // int totalTimePrev =
    // Utility.getTotalTime(listBarModel: dataPrev.listBarModel ?? {});
    // int totalTime = Utility.getTotalTime(listBarModel: data.listBarModel ?? {});
    //
    // int numTomatoes = data.listStatsModel?.length ?? 0;
    // int numTomatoesPrev = dataPrev.listStatsModel?.length ?? 0;
    //
    // int missionCompleted = listStatsModelFinished.length;
    // int missionCompletedPrev = listStatsModelFinishedPrev.length;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    const double redFontSize = 26;

    const double extensionFontSize = 12;
    return Selector<GlobalStateEnv, List<MissionModel>>(
        selector: (_, globalStateEnv) => globalStateEnv.listMissionModels,
        builder: (_, listMissionModels, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: totalDurationHours,
                      style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize)),
                  TextSpan(
                      text: getI18NKey().hour,
                      style: TextStyle(
                          color: ColorsConfig.gray_a7, fontSize: extensionFontSize)),
                  TextSpan(
                      text: totalDurationMins,
                      style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize)),
                  TextSpan(
                      text: getI18NKey().mins2,
                      style: TextStyle(
                          color: ColorsConfig.gray_a7, fontSize: extensionFontSize)),
                ],
              )),
              SizedBox(height: 5),
              Container(height: 150, child: _buildMissionDataTodayFocusDurationWidgetChart())
            ],
          );
        });

  }

  @override
  void didUpdateWidget(MissionDataTodayFocusDurationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.xList =
        this.data?.listBarModel?.keys.toList(growable: true) ?? [];
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildMissionDataTodayFocusDurationWidgetChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      // title: ChartTitle(
      //     text: isCardView ? '' : 'Average monthly temperature of London'),
      primaryXAxis:
      CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          labelFormat: getI18NKey().num_mins('{value}'),
          minimum: 0,
          maximum: maxYVal.toDouble() + 20,
          interval: 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      tooltipBehavior: _tooltipBehavior,
      series: _getMissionDataTodayFocusDurationWidgetSeries(),
    );
  }

  /// The method returns line series to chart.
  List<CartesianSeries<_ChartData, String>> _getMissionDataTodayFocusDurationWidgetSeries() {
    return <CartesianSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(
        dataSource: getChartDataList(),
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter,
              details.rect.bottomCenter,
              ThemeManager.getInstance().isDark() ? const <Color>[Color(0xff1FA2FF), Color(0xff12d8fa)] : const <Color>[Color(0xff232526), Color(0xff414345)],
              <double>[0.3, 0.6]);
        },
        name: '',
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5), topLeft: Radius.circular(5)),
        xValueMapper: (_ChartData sales, index) {
          try {
            if (calendarTypeEnum == CalendarTypeEnum.day) {
              return sales.x.toString();
            } else {
              int timestamp = int.parse(sales.x);
              DateTime dateTime1 = Utility.getDateTimeFromTimeStamp(timestamp);
              DateTime dateTime2 = DateTime.now();
              int days = ((dateTime2.millisecondsSinceEpoch -
                  dateTime1.millisecondsSinceEpoch) ~/
                  (1000 * 24 * 60 * 60))
                  .ceil() +
                  1;
              if (days < 40) {
                if (Utility.isToday(
                    datetime1: dateTime1, datetime2: dateTime2) ==
                    true) {
                  return getI18NKey().today;
                } else {
                  return Utility.getYearMonthAndDay(dateTime1);
                }
              }
              return Utility.getYearMonthAndDay(dateTime1);
              // return getI18NKey().year_month(Utility.getMonthName(dateTime1.month), dateTime1.year);
            }
          } catch(e) {
            return '';
          }
        },
        yValueMapper: (_ChartData sales, _) {
          // if(sales.y > 0) {
          //   print("1111111111");
          // }
          return sales.y;
        },
        dataLabelSettings:
        DataLabelSettings(isVisible: true, offset: const Offset(0, -5)),
      ),
    ];
  }

  // List<_ChartData> getChartDataList() {
  //   List<BarChartGroupData> listZ = getBarGroups();
  //   List<_ChartData> list = [];
  //   this.xList.forEach((element) {
  //     list.add(_ChartData(Utility.filterXAxis(this.xList(j)), 4.3));
  //   });
  //   return list;
  // }

  List<_ChartData> getChartDataList() {
    getRatio();
    List<_ChartData> list = [];
    for (int i = 0; i < xList.length; i++) {
      String key = xList[i];
      double yWithBase = 0;
      for (int j = 0;
      j < (this.data?.listBarModel?[key]?.length ?? 0);
      j++) {
        BarModel barModel =
            this.data?.listBarModel?[key]![j] ?? BarModel();
        yWithBase += ((barModel.fromToYValue ?? 0) - (barModel.fromYValue ?? 0));
      }
      // if(yWithBase > 0) {
      //   yWithBase = 0;
      // }
      list.add(_ChartData(this.xList[i], yWithBase));
    }
    return list;
  }

  getRatio() {
    int maxVal = this.data?.maxValue?.ceil() ?? 0 + 30;
    var res = getUnit(maxVal);
    base = res['base']; //算出base 10 100 k M B
    // maxYVal = (maxVal / base).ceil() + 1; //y最大值
    maxYVal = (maxVal).ceil(); //y最大值
    horizontalLineInterVal = (maxYVal / 10).ceil();
    unit = res['unit']; //显示单位
  }

  getUnit(int value) {
    if (value < 1000) {
      return {
        "unit": "",
        "base": math.pow(10, value.toString().length - 1),
        "interval": 1
      };
    } else if (value >= 1000 && value < 1000000) {
      return {
        "unit": "k",
        "base": math.pow(10, value.toString().length - 1),
        "interval": 1
      };
    } else if (value >= 1000000 && value < 1000000000) {
      return {
        "unit": "M",
        "base": math.pow(10, value.toString().length - 1),
        "interval": 1
      };
    } else if (value >= 1000000000 && value < 1000000000000) {
      return {
        "unit": "B",
        "base": math.pow(10, value.toString().length - 1),
        "interval": 1
      };
    }
  }

// double getGroupSpace() {
//   if (this.xList.length < 8) {
//     return 36;
//   } else if (this.xList.length < 26) {
//     return 7;
//   } else if (this.xList.length < 32) {
//     return 5;
//   }
// }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
