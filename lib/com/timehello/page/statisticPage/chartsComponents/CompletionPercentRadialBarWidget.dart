/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../components/AvatarWidget.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../models/MissionModel.dart';
import '../../../models/SessionMissionModel.dart';
import '../../../util/LoginManager.dart';
import '../../../util/Utility.dart';
import '../../demoPages/sample_view.dart';

/// Render the radial bar customization.
class CompletionPercentRadialBarWidget extends StatefulWidget {
  SessionMissionModel listSessionMissionModelRed1;
  SessionMissionModel listSessionMissionModelYellow2;
  SessionMissionModel listSessionMissionModelBlue3;
  SessionMissionModel listSessionMissionModelGreen4;
  CompleteStatusEnum completeStatusEnum = CompleteStatusEnum.finished;
  Function onTapPriority;

  /// Cretaes customised  radial bar series.
  CompletionPercentRadialBarWidget(
      {required this.completeStatusEnum,
      required this.listSessionMissionModelRed1,
        required this.onTapPriority,
      required this.listSessionMissionModelYellow2,
      required this.listSessionMissionModelBlue3,
      required this.listSessionMissionModelGreen4})
      : super();

  @override
  _CompletionPercentRadialBarWidgetState createState() =>
      _CompletionPercentRadialBarWidgetState();
}

/// State class of radial bar customization.
class _CompletionPercentRadialBarWidgetState
    extends State<CompletionPercentRadialBarWidget> {
  _CompletionPercentRadialBarWidgetState();

  TooltipBehavior? _tooltipBehavior;
  // List<ChartSampleData>? dataSources;
  List<CircularChartAnnotation>? _annotationSources;
  List<Color>? colors;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y%');
    _annotationSources = <CircularChartAnnotation>[
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Icon(Icons.golf_course,
            size: 20,
            color: Utility.getTextColorByPriority(PriorityEnum.green4)),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Icon(Icons.golf_course,
            size: 20,
            color: Utility.getTextColorByPriority(PriorityEnum.blue3)),
      ),
      CircularChartAnnotation(
        angle: 0,
        radius: '0%',
        widget: Icon(Icons.golf_course,
            size: 20,
            color: Utility.getTextColorByPriority(PriorityEnum.yellow2)),
      ),
      CircularChartAnnotation(
        angle: 10,
        radius: '10%',
        widget: Icon(Icons.golf_course,
            size: 20, color: Utility.getTextColorByPriority(PriorityEnum.red1)),
      ),
    ];
    colors = <Color>[
      Utility.getTextColorByPriority(PriorityEnum.green4),
      Utility.getTextColorByPriority(PriorityEnum.blue3),
      Utility.getTextColorByPriority(PriorityEnum.yellow2),
      Utility.getTextColorByPriority(PriorityEnum.red1),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCustomizedRadialBarChart();
  }

  /// Return the circular chart with radial customization.
  SfCircularChart _buildCustomizedRadialBarChart() {
    return SfCircularChart(
      title: ChartTitle(text: ''),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.none,
        position: Utility.isHandsetBySize() ? LegendPosition.right : LegendPosition.bottom,
        legendItemBuilder:
            (String name, dynamic series, dynamic point, int index) {
          return SizedBox(
              height: 60,
              width: 150,
              child: Row(
                  children: <Widget>[
                SizedBox(
                    height: 65,
                    width: 65,
                    child: SfCircularChart(
                      annotations: <CircularChartAnnotation>[
                        _annotationSources![index],
                      ],
                      series: <RadialBarSeries<ChartSampleData, String>>[
                        RadialBarSeries<ChartSampleData, String>(
                            animationDuration: 0,
                            trackColor: ThemeManager.getInstance().getSliderInactiveColor(defaultColor: const Color.fromRGBO(234, 236, 239, 1.0)),
                            dataSource: <ChartSampleData>[getDatas()[index]],
                            maximumValue: 100,
                            radius: '100%',
                            gap: '3%',
                            cornerStyle: CornerStyle.bothCurve,
                            xValueMapper: (ChartSampleData data, _) =>
                                point.x as String,
                            yValueMapper: (ChartSampleData data, _) => data.y,
                            pointColorMapper: (ChartSampleData data, _) =>
                                data.pointColor,
                            innerRadius: '85%',
                            //内部宽度
                            pointRadiusMapper: (ChartSampleData data, _) =>
                                data.text),
                      ],
                    )),
                SizedBox(
                    width: 85,
                    child: Text(
                      "${point.x} \n${getDatas()[index].xValue}",
                      style: TextStyle(
                          color: colors![index], fontSize: 10, fontWeight: FontWeight.w500),
                    )),
              ]));
        },
      ),
      series: _getCompletionPercentRadialBarWidgetSeries(),
      tooltipBehavior: _tooltipBehavior,
      // onTooltipRender:(TooltipArgs args) {
      //   args.text = "111";
      // },
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          angle: 0,
          radius: '0%',
          height: '90%',
          width: '90%',
          widget: AvatarWidget(
              borderColor: Colors.transparent,
              width: 100,
              borderWidth: 0,
              avatar: LoginManager.getInstance().getUserBean().avatar),
          // Image.asset(
          //   'images/person.png',
          //   height: 100.0,
          //   width: 100.0,
          // ),
        ),
      ],
    );
  }

  /// Returns radial bar which need to be customized.
  List<RadialBarSeries<ChartSampleData, String>>
      _getCompletionPercentRadialBarWidgetSeries() {

    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        onPointTap: (ChartPointDetails pointInteractionDetails) {
          this.widget.onTapPriority.call(pointInteractionDetails.pointIndex ?? 0);
        },
        animationDuration: 0,
        maximumValue: 100,
        gap: '10%',
        radius: '100%',
        dataSource: getDatas(),
        cornerStyle: CornerStyle.bothCurve,
        innerRadius: '50%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,

        /// Color mapper for each bar in radial bar series,
        /// which is get from datasource.
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        legendIconType: LegendIconType.circle,
      ),
    ];
  }

  ///Get the default circular series
  List<ChartSampleData> getDatas() {
    int numCompleteRed1 = getCompleteNums(this.widget.listSessionMissionModelRed1);
    int numUncompleteRed1 = getUncompleteNums(this.widget.listSessionMissionModelRed1);
    int numCompleteYellow2 = getCompleteNums(this.widget.listSessionMissionModelYellow2);
    int numUncompleteYellow2 = getUncompleteNums(this.widget.listSessionMissionModelYellow2);
    int numCompleteBlue3 = getCompleteNums(this.widget.listSessionMissionModelBlue3);
    int numUncompleteBlue3 = getUncompleteNums(this.widget.listSessionMissionModelBlue3);
    int numCompleteGreen4 = getCompleteNums(this.widget.listSessionMissionModelGreen4);
    int numUncompleteGreen4 = getUncompleteNums(this.widget.listSessionMissionModelGreen4);
    // print("~~~~~~~~~~~~~~~~~~~~~~~~~ ${numCompleteYellow2} ${numUncompleteYellow2}");
    // print((numCompleteYellow2 == 0&& numUncompleteYellow2 == 0) ? getI18NKey().no_task :"${numCompleteYellow2}/${(numCompleteYellow2 + numUncompleteYellow2)}");
    // print("~~~~~~~~~~~~~~~~~~~~~~~~~");
    double completionRateRed1 = 0;
    double completionRateYellow2 = 0;
    double completionRateBlue3 = 0;
    double completionRateGreen4 = 0;
    if (!(numCompleteRed1 == 0 && numUncompleteRed1 == 0)) {
      completionRateRed1 =
      this.widget.completeStatusEnum == CompleteStatusEnum.finished
          ? (numCompleteRed1.toDouble() / (numCompleteRed1 + numUncompleteRed1))
          : (numUncompleteRed1.toDouble() /
          (numCompleteRed1 + numUncompleteRed1));
    }
    if (!(numCompleteYellow2 == 0 && numUncompleteYellow2 == 0)) {
      completionRateYellow2 =
      this.widget.completeStatusEnum == CompleteStatusEnum.finished
          ? (numCompleteYellow2.toDouble() /
          (numCompleteYellow2 + numUncompleteYellow2))
          : (numUncompleteYellow2.toDouble() /
          (numCompleteYellow2 + numUncompleteYellow2));
    }
    if (!(numCompleteBlue3 == 0 && numUncompleteBlue3 == 0)) {
      completionRateBlue3 =
      this.widget.completeStatusEnum == CompleteStatusEnum.finished
          ? (numCompleteBlue3.toDouble() /
          (numCompleteBlue3 + numUncompleteBlue3))
          : (numUncompleteBlue3.toDouble() /
          (numCompleteBlue3 + numUncompleteBlue3));
    }
    if (!(numCompleteGreen4 == 0 && numUncompleteGreen4 == 0)) {
      completionRateGreen4 =
      this.widget.completeStatusEnum == CompleteStatusEnum.finished
          ? (numCompleteGreen4.toDouble() /
          (numCompleteGreen4 + numUncompleteGreen4))
          : (numUncompleteGreen4.toDouble() /
          (numCompleteGreen4 + numUncompleteGreen4));
    }

    return <ChartSampleData>[
      ChartSampleData(
          x: getI18NKey().four_quadrant_priority4_abbr,
          y: 100 * completionRateGreen4, //legend的值
          text: Utility.getPercent(completionRateGreen4),
          xValue: (numCompleteGreen4 == 0&& numUncompleteGreen4 == 0) ? getI18NKey().no_task :"${numCompleteGreen4}/${(numCompleteGreen4 + numUncompleteGreen4)}" ,
          pointColor:
          Utility.getTextColorByPriority(PriorityEnum.green4)),
      ChartSampleData(
          x: getI18NKey().four_quadrant_priority3_abbr,
          y: 100 * completionRateBlue3, //legend的值
          text: Utility.getPercent(completionRateBlue3),
          xValue: (numCompleteBlue3 == 0&& numUncompleteBlue3 == 0) ? getI18NKey().no_task :"${numCompleteBlue3}/${(numCompleteBlue3 + numUncompleteBlue3)}",
          pointColor:
          Utility.getTextColorByPriority(PriorityEnum.blue3)),
      ChartSampleData(
          x: getI18NKey().four_quadrant_priority2_abbr,
          y: 100 * completionRateYellow2, //legend的值
          text: Utility.getPercent(completionRateYellow2),
          xValue:(numCompleteYellow2 == 0&& numUncompleteYellow2 == 0) ? getI18NKey().no_task : "${numCompleteYellow2}/${(numCompleteYellow2 + numUncompleteYellow2)}",
          pointColor: Utility.getTextColorByPriority(PriorityEnum.yellow2)),
      ChartSampleData(
          x: getI18NKey().four_quadrant_priority1_abbr,
          y: 100 * completionRateRed1, //legend的值
          xValue: (numCompleteRed1 == 0&& numUncompleteRed1 == 0) ? getI18NKey().no_task :"${numCompleteRed1}/${(numCompleteRed1 + numUncompleteRed1)}",
          text: Utility.getPercent(completionRateRed1),
          pointColor: Utility.getTextColorByPriority(PriorityEnum.red1)),
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

  @override
  void dispose() {
    // dataSources!.clear();
    _annotationSources!.clear();
    super.dispose();
  }
}
