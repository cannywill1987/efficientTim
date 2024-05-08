/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/demoPages/sample_view.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/SessionMissionModel.dart';

/// Local imports

/// Renders the doughnut chart with legend
class PriorityDistributionOfCompletionPlayCircleChart extends StatefulWidget {
  SessionMissionModel listSessionMissionModelRed1;
  SessionMissionModel listSessionMissionModelYellow2;
  SessionMissionModel listSessionMissionModelBlue3;
  SessionMissionModel listSessionMissionModelGreen4;
  CompleteStatusEnum completeStatusEnum = CompleteStatusEnum.finished;
  Function onTapPriority;

  PriorityDistributionOfCompletionPlayCircleChart(
      {required this.completeStatusEnum,
      required this.onTapPriority,
      required this.listSessionMissionModelRed1,
      required this.listSessionMissionModelYellow2,
      required this.listSessionMissionModelBlue3,
      required this.listSessionMissionModelGreen4});

  /// Creates the doughnut chart with legend
  // PriorityDistributionOfCompletionPlayCircleChart() : super();

  @override
  _PriorityDistributionOfCompletionPlayCircleChartState createState() =>
      _PriorityDistributionOfCompletionPlayCircleChartState();
}

class _PriorityDistributionOfCompletionPlayCircleChartState
    extends State<PriorityDistributionOfCompletionPlayCircleChart> {
  _PriorityDistributionOfCompletionPlayCircleChartState();

  late LegendItemOverflowMode _overflowMode;
  late LegendPosition _position;

  @override
  void initState() {
    _position = LegendPosition.auto;
    _overflowMode = LegendItemOverflowMode.wrap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: _buildFinishedPriorityMissionCircleChartChart(),
    );
  }

  ///Get the default circular series with legend
  SfCircularChart _buildFinishedPriorityMissionCircleChartChart() {
    return SfCircularChart(
      onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
        print("onChartTouchInteractionUp");
      },
      onLegendTapped: (LegendTapArgs legendTapArgs) {
        print("onSelectionChanged");
      },
      onSelectionChanged: (SelectionArgs selectionArgs) {
        print("onSelectionChanged");
      },
      onDataLabelRender: (DataLabelRenderArgs args) => "123",
      margin: EdgeInsets.all(35),
      //右边的分类栏目
      legend: Legend(
        width: '120%',
        position: LegendPosition.bottom,
        isVisible: true,
        orientation: LegendItemOrientation.vertical,
        textStyle: TextStyle(
            fontWeight: FontWeight.w900,
            color: ThemeManager.getInstance()
                .getTextColor(defaultColor: ColorsConfig.chartTextColor),
            fontSize: 11,
            decoration: TextDecoration.none),
        // title: LegendTitle(text: "123"), //栏目标题
        overflowMode: LegendItemOverflowMode.wrap,
        // shouldAlwaysShowScrollbar: _shouldAlwaysShowScrollbar
      ),
      series: getDatas(),
      //就是点击chart里的text数值
      tooltipBehavior:
          TooltipBehavior(enable: true, textAlignment: ChartAlignment.center),
    );
  }

  ///Get the default circular series
  List<DoughnutSeries<ChartSampleData, String>> getDatas() {
    int numRed1 = this.widget.completeStatusEnum == CompleteStatusEnum.finished
        ? getCompleteNums(this.widget.listSessionMissionModelRed1)
        : getUncompleteNums(this.widget.listSessionMissionModelRed1);
    int numYellow2 =
        this.widget.completeStatusEnum == CompleteStatusEnum.finished
            ? getCompleteNums(this.widget.listSessionMissionModelYellow2)
            : getUncompleteNums(this.widget.listSessionMissionModelYellow2);
    int numBlue3 = this.widget.completeStatusEnum == CompleteStatusEnum.finished
        ? getCompleteNums(this.widget.listSessionMissionModelBlue3)
        : getUncompleteNums(this.widget.listSessionMissionModelBlue3);
    int numGreen4 =
        this.widget.completeStatusEnum == CompleteStatusEnum.finished
            ? getCompleteNums(this.widget.listSessionMissionModelGreen4)
            : getUncompleteNums(this.widget.listSessionMissionModelGreen4);
    ;
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          onPointTap: (ChartPointDetails pointInteractionDetails) {
            int pointIndex = pointInteractionDetails.pointIndex ?? 0;
            this.widget.onTapPriority.call(
                pointIndex,
                pointIndex == 0
                    ? this.widget.listSessionMissionModelRed1
                    : pointIndex == 1
                        ? this.widget.listSessionMissionModelYellow2
                        : pointIndex == 2
                            ? this.widget.listSessionMissionModelBlue3
                            : this.widget.listSessionMissionModelGreen4);

            print("onPointTap");
          },
          dataSource: <ChartSampleData>[
            ChartSampleData(
                pointColor:
                    Utility.getTextColorByPriority(PriorityEnum.values[0]),
                text:
                    "${getI18NKey().four_quadrant_priority1_abbr}\n${numRed1} tasks",
                x: getI18NKey().four_quadrant_priority1,
                y: numRed1),
            ChartSampleData(
                pointColor:
                    Utility.getTextColorByPriority(PriorityEnum.values[1]),
                text:
                    "${getI18NKey().four_quadrant_priority2_abbr}\n${numYellow2} tasks",
                x: getI18NKey().four_quadrant_priority2,
                y: numYellow2),
            ChartSampleData(
                pointColor:
                    Utility.getTextColorByPriority(PriorityEnum.values[2]),
                text:
                    "${getI18NKey().four_quadrant_priority3_abbr}\n${numBlue3} tasks",
                x: getI18NKey().four_quadrant_priority3,
                y: numBlue3),
            ChartSampleData(
                pointColor:
                    Utility.getTextColorByPriority(PriorityEnum.values[3]),
                text:
                    "${getI18NKey().four_quadrant_priority4_abbr}\n${numGreen4} tasks",
                x: getI18NKey().four_quadrant_priority4,
                y: numGreen4),
          ],
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          //用于比例设置
          startAngle: 0,
          endAngle: 0,
          dataLabelSettings: DataLabelSettings(
              textStyle: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black),
                  fontSize: 10),
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside)),
      //显示数字是否在外面
    ];
  }

  int getUncompleteNums(SessionMissionModel model) {
    int num = 0;
    model.datas?.forEach((MissionModel model) {
      if (model.isFinished == false) {
        num += 1;
      }
    });
    return num;
  }

  int getCompleteNums(SessionMissionModel model) {
    int num = 0;
    model.datas?.forEach((MissionModel model) {
      if (model.isFinished == true) {
        num += 1;
      }
    });
    return num;
  }

  int getUncompleteRate(SessionMissionModel model) {
    int num = 0;
    model.datas?.forEach((MissionModel model) {
      if (model.isFinished == false) {
        num += 1;
      }
    });
    return num;
  }

  int getCompleteRate(SessionMissionModel model) {
    int num = 0;
    model.datas?.forEach((MissionModel model) {
      if (model.isFinished == true) {
        num += 1;
      }
    });
    return num;
  }
}
