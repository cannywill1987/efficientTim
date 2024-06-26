import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/BarModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'dart:math' as math;

import 'package:time_hello/com/timehello/util/Utility.dart';

import '../components/CardContainer.dart';

class LineCharWidget extends StatefulWidget {
  BarModelList? datas;

  LineCharWidget({this.datas});

  @override
  _LineCharWidgetState createState() => _LineCharWidgetState();
}

class _LineCharWidgetState extends State<LineCharWidget> {
  List<String> xList = [];
  List<FlSpot> listFlSpot = [];
  bool showAvg = false;
  int maxYVal = 10;
  int base = 1;
  String unit = ''; //单位
  double totalY = 0;
  List<Color> gradientColors = [
    const Color(0xff847ada),
    const Color(0xff847ada),
    const Color(0xffb9aac7),
  ];

  _LineCharWidgetState({xList}) {
    this.xList = xList ?? [];
  }

  getRatio() {
    int maxVal = this.widget.datas?.maxValue.ceil() ?? 0;
    var res = getUnit(maxVal);
    base = res['base']; //算出base 10 100 k M B
    // maxYVal = (maxVal / base).ceil() + 1; //y最大值
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

  static getBarGroups(
      {int type = 0,
      int base = 0,
      required Map<String, List<BarModel>> listBarModel}) {
    List<FlSpot> listFlSpot = [];
    List<String> xList = listBarModel.keys.toList(growable: true);
    double totalYWithBase = 0;
    // this.groupSpace = (this.width - 20 - barWidth * xList.length) / ((xList.length + 1));
    for (int i = 0; i < xList.length; i++) {
      String key = xList[i];
      double yWithBase = 0;
      // List<BarChartRodStackItem> listBarChartRodStackItem = [];
      for (int j = 0; j < (listBarModel[key]?.length ?? 0); j++) {
        BarModel barModel = listBarModel[key]![j];
        yWithBase =
            ((barModel.fromToYValue ?? 0) - (barModel.fromYValue ?? 0)) / base;
      }
      totalYWithBase += yWithBase;
      listFlSpot.add(FlSpot(i.toDouble(), totalYWithBase));
    }
    return {
      "totalYWithBase": totalYWithBase,
      "xList": xList,
      "listFlSpot": listFlSpot
    };
  }

  @override
  void didUpdateWidget(LineCharWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.listFlSpot = [];
    this.totalY = 0;
    this.xList =
        this.widget.datas?.listBarModel?.keys.toList(growable: true) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    getRatio();
    Map res = Utility.getTotalTime(
        type: 1,
        listBarModel: this.widget.datas?.listBarModel ?? {},
        base: this.base);
    this.maxYVal = res['totalYWithBase'].toInt();
    this.listFlSpot = res['listFlSpot'];
    this.xList = res['xList'];
    // this.totalYWithBase = res['totalYWithBase'];

    return CardContainer(
        title: getI18NKey().totalTimeMinute,
        child: LineChart(
          mainData(),
        ));
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              final FlSpot spot = barData.spots[spotIndex];
              if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
                return null;
              }
              return TouchedSpotIndicatorData(
                  FlLine(color: Colors.transparent, strokeWidth: 0),
                  FlDotData());
            }).toList();
          },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x == 0 || flSpot.x == 30 || flSpot.x == 29) {
                return null;
              }
              //tooltip提示点这里需要在处理乘以base
              return LineTooltipItem(
                '${(flSpot.y * this.base).toStringAsFixed(0)}',
                TextStyle(
                  color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black87),
                  fontFamily: 'NeueMontreal',
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ColorsConfig.statisticLine, //横向参考颜色
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ColorsConfig.statisticLine, //纵向参考颜色
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              if (this.xList.length > value.toInt()) {
                return Text(
                  Utility.filterXAxis(this.xList[value.toInt()]), //底部时间
                  style: TextStyle(color: ColorsConfig.statisticText, fontSize: 10),
                );
              }
              return Text('');
            },
            // margin: 8,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              if (value == 0) {
                return Text('0');
              }
              return Text(
                '${value.toInt() * base}$unit', //左侧unit文案分类
                style: TextStyle(
                  color: ColorsConfig.statisticText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
            // margin: 12,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: ColorsConfig.statisticLine, width: 1)),
      //最外城边的颜色
      minX: 0,
      maxX: listFlSpot.length.toDouble() - 1,
      minY: 0,
      maxY: this.maxYVal.toDouble() + 1,
      // y轴最大值
      lineBarsData: [
        LineChartBarData(
          spots: listFlSpot,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          // curveSmoothness: .09,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            //底部渐变色
            show: true,
            gradient: LinearGradient(colors: gradientColors.map((color) => color.withOpacity(0.3)).toList())
          ),
        ),
      ],
    );
  }
}
