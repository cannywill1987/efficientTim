/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/demoPages/sample_view.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/FolderModelWithExtraData.dart';

/// Local imports

/// Renders the doughnut chart with legend
class FocusDistributionMissionCircleChart extends StatefulWidget {
  List<FolderModelWithExtraData>? datasFolderModelWithExtraData = [];
  Function onTapItem;
  /// Creates the doughnut chart with legend
  FocusDistributionMissionCircleChart({Key? key,this.datasFolderModelWithExtraData, required this.onTapItem}) : super(key: key);

  @override
  _FocusDistributionMissionCircleChartState createState() =>
      _FocusDistributionMissionCircleChartState();
}

class _FocusDistributionMissionCircleChartState
    extends State<FocusDistributionMissionCircleChart> {
  _FocusDistributionMissionCircleChartState();

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
      width: double.infinity,
      height: 300,
      child: _buildFocusDistributionMissionCircleChartChart(),
    );
  }

  ///Get the default circular series with legend
  SfCircularChart _buildFocusDistributionMissionCircleChartChart() {
    return SfCircularChart(
      onDataLabelRender: (DataLabelRenderArgs args) {
        int maxLength = 7;
        String title = args.dataPoints[args.viewportPointIndex].x.length > maxLength ?  (args.dataPoints[args.viewportPointIndex].x.toString().substring(0, maxLength) + "..."):args.dataPoints[args.viewportPointIndex].x;
        args.text = title + "\n" + Utility.formatHourAndMin(args.dataPoints[args.viewportPointIndex].y);
        // args.text = getI18NKey()
        //     .num_tasks(args.dataPoints[args.viewportPointIndex].y.toString());
        // args.dataPoints[args.viewportPointIndex].y.toString() + ' m';
      },
      //就是点击chart里的text 提示框
      tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: false,
          header: '',
          format: 'point.x : point.y '),
      // title:ChartTitle(text: "123", textStyle: TextStyle(decoration: TextDecoration.none, fontSize: 12)),
      // onDataLabelRender: (DataLabelRenderArgs args) => "123",
      margin: EdgeInsets.only(bottom: 120),
      //右边的分类栏目
      legend: Legend(
        width: '120%',
        title: LegendTitle(text: "123"),
        position: LegendPosition.bottom,
        isVisible: false,
        orientation: LegendItemOrientation.vertical,
        textStyle: TextStyle(
            fontWeight: FontWeight.w900,
            color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
            fontSize: 11,
            decoration: TextDecoration.none),
        // title: LegendTitle(text: "123"), //栏目标题
        overflowMode: LegendItemOverflowMode.wrap,
        // shouldAlwaysShowScrollbar: _shouldAlwaysShowScrollbar
      ),
      series: getDatas(),
      //就是点击chart里的text数值
      // tooltipBehavior:
      //     TooltipBehavior(enable: false, textAlignment: ChartAlignment.center),
    );
  }

  List<ChartSampleData> getChartSampleData() {
    double height = 10;
    List<ChartSampleData> list = [];
    this
        .widget
        .datasFolderModelWithExtraData
        ?.forEach((FolderModelWithExtraData data) {
      list.add(ChartSampleData(

          x: data.folderModel.title,
          size: height,
          y: data.folderTimeModel.finishedTime,
          pointColor: Color(data.folderModel.color == 0 ? 0xffff8800 : data.folderModel.color )));
    });
    return list;
  }


  ///Get the default circular series
  List<DoughnutSeries<ChartSampleData, String>> getDatas() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          onPointTap: (ChartPointDetails pointInteractionDetails) {
            int pointIndex = pointInteractionDetails.pointIndex ?? 0;
            this.widget.onTapItem.call();
            // this.widget.onTapPriority.call(
            //     pointIndex,
            //     pointIndex == 0
            //         ? this.widget.listSessionMissionModelRed1
            //         : pointIndex == 1
            //         ? this.widget.listSessionMissionModelYellow2
            //         : pointIndex == 2
            //         ? this.widget.listSessionMissionModelBlue3
            //         : this.widget.listSessionMissionModelGreen4);
            //
            // print("onPointTap");
          },
          enableTooltip: true,
          // pointRenderMode: PointRenderMode.gradient,
          dataSource: getChartSampleData(),
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          //用于比例设置
          startAngle: 0,
          endAngle: 0,

          dataLabelSettings:  DataLabelSettings(
              overflowMode: OverflowMode.shift,
              textStyle: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black), fontSize: 11),
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside)),
      //显示数字是否在外面
    ];
  }
}
