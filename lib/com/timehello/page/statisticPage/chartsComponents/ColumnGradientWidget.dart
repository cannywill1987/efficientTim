/// Package import
import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/ENUMS.dart';
import '../../../models/BarModel.dart';
import '../../../models/StatsModel.dart';
import 'dart:math' as math;

import '../../../util/Utility.dart';

/// Local import

///Renders default line series chart
class ColumnGradientWidget extends StatefulWidget {
  // List<StatsModel> listStatsModelFinished = [];
  BarModelList? data;
  CalendarTypeEnum calendarTypeEnum;
  Function onTapItem;

  ///Creates default line series chart
  ColumnGradientWidget({required this.onTapItem, BarModelList? data, required this.calendarTypeEnum}) {
    this.data = data;
  }

  @override
  _ColumnGradientWidgetState createState() => _ColumnGradientWidgetState();
}

class _ColumnGradientWidgetState extends State<ColumnGradientWidget> {
  _ColumnGradientWidgetState();

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

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    // List<BarChartGroupData> listBarChartGroupData = getBarGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildColumnGradientWidgetChart();
  }

  @override
  void didUpdateWidget(ColumnGradientWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.xList =
        this.widget.data?.listBarModel?.keys.toList(growable: true) ?? [];
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildColumnGradientWidgetChart() {
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
      series: _getColumnGradientWidgetSeries(),
    );
  }

  /// The method returns line series to chart.
  List<CartesianSeries<_ChartData, String>> _getColumnGradientWidgetSeries() {
    return <CartesianSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(
        onPointTap: (ChartPointDetails pointInteractionDetails) {
          int pointIndex = pointInteractionDetails.pointIndex ?? 0;
          this.widget.onTapItem.call();
        },
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
            if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
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
          j < (this.widget.data?.listBarModel?[key]?.length ?? 0);
          j++) {
        BarModel barModel =
            this.widget.data?.listBarModel?[key]![j] ?? BarModel();
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
    int maxVal = this.widget.data?.maxValue?.ceil() ?? 0 + 30;
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
