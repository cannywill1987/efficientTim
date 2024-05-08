/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/FolderModelWithExtraData.dart';
import '../../../util/Utility.dart';
import '../../demoPages/sample_view.dart';

/// Renders the chart with sorting options sample.
class CompletePlanClassificationChartWidget extends StatefulWidget {
  List<FolderModelWithExtraData>? datasFolderModelWithExtraData;
  CompleteStatusEnum completePlanStatusEnum;
  Function onTapItem;
  DateTime? startDateTime;
  DateTime? endDateTime;

  /// Creates the chart with sorting options sample.
  CompletePlanClassificationChartWidget({ this.startDateTime,  this.endDateTime , required this.onTapItem, required this.completePlanStatusEnum, this.datasFolderModelWithExtraData});

  @override
  _CompletePlanClassificationChartWidgetState createState() =>
      _CompletePlanClassificationChartWidgetState();
}

/// State class the chart with sorting options.
class _CompletePlanClassificationChartWidgetState
    extends State<CompletePlanClassificationChartWidget> {
  _CompletePlanClassificationChartWidgetState();

  late bool isSorting;
  List<String>? _labelList;
  List<String>? _sortList;
  late String _selectedType;
  late String _selectedSortType;
  late SortingOrder _sortingOrder;
  TooltipBehavior? _tooltipBehavior;
  late String _sortby;

  @override
  void initState() {
    isSorting = true;
    _labelList = <String>['y', 'x'].toList();
    _sortList = <String>['none', 'descending', 'ascending'].toList();
    _selectedType = 'y';
    _selectedSortType = 'none';
    _sortingOrder = SortingOrder.none;
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        format: getI18NKey().num_tasks('point.x : point.y')
        // format: 'point.x : point.y m'
        );
    _sortby = 'y';
    super.initState();
  }

  @override
  void dispose() {
    _labelList!.clear();
    _sortList!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultSortingChart();
  }

  /// Returns the Cartesian chart with sorting options.
  SfCartesianChart _buildDefaultSortingChart() {
    List<ChartSampleData> list = getChartSampleData();
    return SfCartesianChart(
      margin: EdgeInsets.only(top: 20, right: 10),
      // title: ChartTitle(text: "World's tallest buildings"),
      plotAreaBorderWidth: 0,
      legend: Legend(
        width: '100%',
        position: LegendPosition.bottom,
        isVisible: false,
        orientation: LegendItemOrientation.vertical,
        textStyle: TextStyle(
            fontWeight: FontWeight.w900,
            color: ColorsConfig.chartTextColor,
            fontSize: 11,
            decoration: TextDecoration.none),
        // title: LegendTitle(text: "123"), //栏目标题
        overflowMode: LegendItemOverflowMode.wrap,
        // shouldAlwaysShowScrollbar: _shouldAlwaysShowScrollbar
      ),

      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 1)),
      onDataLabelRender: (DataLabelRenderArgs args) {
        args.text = getI18NKey()
            .num_tasks(args.dataPoints[args.viewportPointIndex].y.toString());
        // args.dataPoints[args.viewportPointIndex].y.toString() + ' m';
      },
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: getMaxVal(list).toDouble(),
          interval: 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSortingSeries(list),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  int getMaxVal(List<ChartSampleData> list) {
    int maxVal = 0;
    list.forEach((ChartSampleData data) {
      maxVal =
          maxVal > (data.y?.toInt() ?? 0) ? maxVal : (data.y?.toInt() ?? 0);
    });
    return maxVal + 10;
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
          y: this.widget.completePlanStatusEnum == CompleteStatusEnum.finished ? data.folderTimeModel.numMissionFinished :data.folderTimeModel.numMissionToFinished,
          pointColor: Color(data.folderModel.color == 0 ? 0xffff8800 : data.folderModel.color )));
    });
    return list;
  }

  /// Returns the list of chart series which need to
  /// render on the chart with sorting options.
  List<BarSeries<ChartSampleData, String>> _getDefaultSortingSeries(
      List<ChartSampleData> list) {
    double height = 10;
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        onPointTap: (ChartPointDetails pointInteractionDetails) async {
          int pointIndex = pointInteractionDetails.pointIndex ?? 0;
          String folderTitle = pointInteractionDetails.dataPoints?[pointIndex].x;
          FolderModelWithExtraData? folderModelWithExtraData =
          this.widget.datasFolderModelWithExtraData?.firstWhere((element) => element.folderModel.title == folderTitle);
          List<MissionModel> list;
          if (TextUtil.isEmpty(folderModelWithExtraData?.folderModel.objectId)) {
            // list = MongoApisManager.getInstance()
            //     .queryMissioinModelsByOtherFolderId(isFinished: this.widget.completePlanStatusEnum == CompleteStatusEnum.finished ? true : false);
            list=  await MongoApisManager.getInstance()
                .queryWhereEqual_missionDataByEndTime(

              isFinished: this.widget.completePlanStatusEnum == CompleteStatusEnum.finished ? true : false,
              //todo 这个还没用的上
              start_endTime: this.widget.startDateTime?.millisecondsSinceEpoch,
              end_endTime: this.widget.endDateTime?.millisecondsSinceEpoch,
            );
          } else {
            list=  await MongoApisManager.getInstance()
                .queryWhereEqual_missionDataByEndTime(
              fid: folderModelWithExtraData?.folderModel.objectId ?? "",
              isFinished: this.widget.completePlanStatusEnum == CompleteStatusEnum.finished ? true : false,
              //todo 这个还没用的上
              start_endTime: this.widget.startDateTime?.millisecondsSinceEpoch,
              end_endTime: this.widget.endDateTime?.millisecondsSinceEpoch,
            );
            // list = MongoApisManager.getInstance().queryMissioinModelsByFolderId(
            //     folderId: folderModelWithExtraData.folderModel.objectId ?? "", isFinished: this.widget.completePlanStatusEnum == CompleteStatusEnum.finished ? true : false);
          }

          DialogManagement.getInstance()
              .showMissionListDialog(context, list: list);
        },
        // onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
        //   return _CustomColumnSeriesRenderer(color: Colors.red);
        // },
        // isTrackVisible: true,
        animationDuration: 0,
        dataSource: list,
        sortingOrder: SortingOrder.ascending,
        // dataLabelMapper: (ChartSampleData data, _) => data.x,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        // sortingOrder: _sortingOrder,
        // dataLabelSettings: const DataLabelSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
            overflowMode: OverflowMode.shift,
            textStyle: TextStyle(color: Colors.black, fontSize: 11),
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside),
        sortFieldValueMapper: (ChartSampleData sales, _) =>
            _sortby == 'x' ? sales.x : sales.y,
      )
    ];
  }

  //
  // /// Method to update the selected sortBy type in the chart on change.
  // void _onPositionTypeChange(String item) {
  //   _selectedType = item;
  //   if (_selectedType == 'y') {
  //     _sortby = 'y';
  //   }
  //   if (_selectedType == 'x') {
  //     _sortby = 'x';
  //   }
  //   setState(() {
  //     /// update the sorting by value change
  //   });
  // }

  /// Method to update the selected sording order in the chart on change.
  void _onSortingTypeChange(String item) {
    _selectedSortType = item;
    if (_selectedSortType == 'descending') {
      _sortingOrder = SortingOrder.descending;
    } else if (_selectedSortType == 'ascending') {
      _sortingOrder = SortingOrder.ascending;
    } else {
      _sortingOrder = SortingOrder.none;
    }
    setState(() {
      /// update the sorting order type change
    });
  }
}

// class _CustomColumnSeriesRenderer extends BarSeriesRenderer {
//   Color color = Color(0xff8800);
//
//   _CustomColumnSeriesRenderer({required Color color});
//
//   @override
//   BarSegment createSegment() {
//     return _ColumnCustomPainter();
//   }
// }

class _ColumnCustomPainter extends BarSegment {
  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;

  @override
  void onPaint(Canvas canvas) {
    Paint? myPaint = fillPaint;
    if (currentSegmentIndex == 0) {
      myPaint = Paint()..color = const Color.fromRGBO(192, 33, 39, 1);
    } else if (currentSegmentIndex == 1) {
      myPaint = Paint()..color = const Color.fromRGBO(26, 157, 235, 1);
    } else if (currentSegmentIndex == 2) {
      myPaint = fillPaint;
    } else if (currentSegmentIndex == 3) {
      myPaint = Paint()..color = const Color.fromRGBO(254, 250, 55, 1);
    } else if (currentSegmentIndex == 4) {
      myPaint = Paint()..color = const Color.fromRGBO(60, 92, 156, 1);
    }
    final RRect rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(segmentRect!.left, segmentRect!.top,
            segmentRect!.right * animationFactor, segmentRect!.bottom),
        Radius.circular(8));

    canvas.drawRRect(rect, myPaint!);
  }
}
