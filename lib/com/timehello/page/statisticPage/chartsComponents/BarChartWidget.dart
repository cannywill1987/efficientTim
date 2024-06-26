import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/BarModel.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/CardContainer.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'dart:math' as math;





class BarChartWidget extends StatefulWidget {
  BarModelList? datas;

  BarChartWidget({this.datas});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState(
      xList: datas?.listBarModel?.keys.toList(growable: true));
}

class BarChartWidgetState extends State<BarChartWidget> {
  List<String> xList = [];
  int horizontalLineInterVal = 1;
  int verticalInterVal = 1;
  double interval = 1;
  int maxYVal = 10;
  int base = 1;
  String unit = ''; //单位
  // double width = 0;
  double barWidth = 4;
  double groupSpace = 10;

  BarChartWidgetState({xList}) {
    this.xList = xList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(BarChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.xList = this.widget.datas?.listBarModel?.keys.toList(growable: true) ?? [];
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
        y = (barModel.fromToYValue?? 0) / this.base;
        listBarChartRodStackItem.add(BarChartRodStackItem(
            (barModel.fromYValue??0) / this.base,
            y,
            barModel.color != null? Color(barModel.color ?? 0xffff8800) : const Color(0xff2bdb90)));
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

  double getGroupSpace() {
    if (this.xList.length < 8) {
      return 36;
    } else if (this.xList.length < 26) {
      return 7;
    } else if (this.xList.length < 32) {
      return 5;
    }
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    getRatio();
    List<BarChartGroupData> listBarChartGroupData = getBarGroups();
    // print("maxVal:" + this.maxYVal.toString());
    // width = context.findRenderObject().paintBounds.size.width;
    return CardContainer(title: getI18NKey().tomatoNums, child:BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (spot) => ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              // tooltip提示点这里需要在处理乘以base
              return BarTooltipItem(
                '${(rod.toY * this.base).toStringAsFixed(0)}',
                const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'NeueMontreal',
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        alignment: BarChartAlignment.center,
        minY: 0,
        maxY: (this.maxYVal.toDouble() < 5) ? this.maxYVal.toDouble() * 4 : this.maxYVal.toDouble(),
        groupsSpace: this.getGroupSpace(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                //根据bargroups数量返回
                if (this.xList.length > value.toInt()) {
                  return Text(
                    Utility.filterXAxis(this.xList[value.toInt()]),
                    style: TextStyle(color: ColorsConfig.statisticText, fontSize: 10),
                  );
                }
                return Text("");
              },
              reservedSize: 30,
              // margin: 10,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                //每一格都是5的跳动
                if (value == 0) {
                  return Text('0');
                }
                return Text('${value.toInt() * base}$unit');
              },
              reservedSize: 30,
              // margin: 8,
              interval: this.interval,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          verticalInterval: verticalInterVal.toDouble(),
          checkToShowVerticalLine: (value) {
            return value % verticalInterVal == 0;
          },
          checkToShowHorizontalLine: (value) {
            return value % horizontalLineInterVal == 0;
          },
          getDrawingVerticalLine: (value) {
            if (value == 0) {
              return FlLine(
                  color: ColorsConfig.statisticLine, strokeWidth: 3);
            }
            return FlLine(
              color: ColorsConfig.statisticLine,
              strokeWidth: 0.8,
            );
          },
          getDrawingHorizontalLine: (value) {
            // if (value == 0) {
            //   return FlLine(
            //       color: const Color(0xff363753), strokeWidth: 3);
            // }
            return FlLine(
              color: ColorsConfig.statisticLine,
              strokeWidth: 0.8,
            );
          },
        ),
        borderData: FlBorderData(
            show: true,
            border:  Border.all(
              color: ColorsConfig.statisticLine,
              width: 1.0,
              style: BorderStyle.solid,
            )
        ),
        barGroups: listBarChartGroupData,
      ),
    ),);
  }
}
