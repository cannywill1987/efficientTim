/// Package import
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/ENUMS.dart';
import '../../../models/BarModel.dart';
import '../../../models/FolderModelWithExtraData.dart';
import '../../demoPages/sample_view.dart';
import 'dart:math' as math;

/**
 * 用不上
 */
/// Renders the stacked column chart sample.
class StackedColumnChart extends StatefulWidget {
  BarModelList? datas;
  CalendarTypeEnum calendarTypeEnum;

  /// Creates the stacked column chart sample.
  StackedColumnChart({required this.datas, required this.calendarTypeEnum}) : super();

  @override
  _StackedColumnChartState createState() => _StackedColumnChartState();
}

/// State class of the stacked column chart.
class _StackedColumnChartState extends State<StackedColumnChart> {
  _StackedColumnChartState();
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

  List<ChartSampleData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    List<BarChartGroupData> listBarChartGroupData = getBarGroups();

    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Q1',
          y: 50,
          yValue: 55,
          secondSeriesYValue: 72,
          thirdSeriesYValue: 65),
      ChartSampleData(
          x: 'Q2',
          y: 80,
          yValue: 75,
          secondSeriesYValue: 70,
          thirdSeriesYValue: 60),
      ChartSampleData(
          x: 'Q3',
          y: 35,
          yValue: 45,
          secondSeriesYValue: 55,
          thirdSeriesYValue: 52),
      ChartSampleData(
          x: 'Q4',
          y: 65,
          yValue: 50,
          secondSeriesYValue: 70,
          thirdSeriesYValue: 65),
    ];
    super.initState();
  }

  // List<ChartSampleData> getChartSampleDataList() {
  //   this.xList = this.widget.datas?.listBarModel.keys.toList(growable: true) ?? [];
  //   List<ChartSampleData> list = [];
  //   this.xList.forEach((element) {
  //     list.add(ChartSampleData(
  //         x: 'Q1',
  //         y: 50,
  //         yValue: 55,
  //         secondSeriesYValue: 72,
  //         thirdSeriesYValue: 65));
  //   });
  // }

  @override
  void didUpdateWidget(StackedColumnChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.xList = this.widget.datas?.listBarModel?.keys.toList(growable: true) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedColumnChart();
  }

  /// Returns the cartesian Stacked column chart.
  SfCartesianChart _buildStackedColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Quarterly wise sales of products'),
      legend: Legend(
          isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}K',
          maximum: 300,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart serie which need to render
  /// on the stacked column chart.
  List<StackedColumnSeries<ChartSampleData, String>> _getStackedColumnSeries() {
    return <StackedColumnSeries<ChartSampleData, String>>[
      StackedColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Product A'),
      StackedColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Product B'),
      StackedColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Product C'),
      StackedColumnSeries<ChartSampleData, String>(
          dataSource: chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Product D')
    ];
  }

  getBarGroups() {
    List<BarChartGroupData> list = [];
    // this.groupSpace = (this.width - 20 - barWidth * xList.length) / ((xList.length + 1));
    for (int i = 0; i < xList.length; i++) {
      String key = xList[i];
      double y = 0;
      List<BarChartRodStackItem> listBarChartRodStackItem = [];
      for (int j = 0; j < (this.widget.datas?.listBarModel?[key]?.length ?? 0); j++) {
        BarModel barModel = this.widget.datas?.listBarModel![key]![j] ?? BarModel();
        y = (barModel.fromToYValue ?? 0) / this.base;
        listBarChartRodStackItem.add(BarChartRodStackItem(
            (barModel.fromYValue ?? 0)/ this.base,
            y,
            barModel.color != null? Color(barModel.color ?? 0) : const Color(0xff2bdb90)));
      }

      list.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            width: barWidth,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            rodStackItems: listBarChartRodStackItem, toY: y,
          ),
        ],
      ));
    }
    return list;
  }

  getRatio() {
    int maxVal = this.widget.datas?.maxValue.ceil() ?? 0;
    var res = getUnit(maxVal);
    base = res['base']; //算出base 10 100 k M B
    maxYVal = (maxVal / base).ceil() + 1; //y最大值
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


  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}
