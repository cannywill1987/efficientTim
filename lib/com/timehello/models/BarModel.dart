import 'StatsModel.dart';

/**
 * 每个bar
 */
class BarModelList {
  List<BarModel>? list = [];
  Map<String, List<BarModel>>? listBarModel; //key title值 value y值
  List<StatsModel>? listStatsModel;
  double maxValue = 0;
  BarModelList({this.listStatsModel, this.maxValue = 0,  this.listBarModel}) {}



}

/**
 * 每个bar的一格
 */
class BarModel {
  String? title;
  double? fromYValue;
  double? fromToYValue;
  int? xValue;
  String? yString;
  String? xString;
  int? color;

  BarModel(
      {this.title,
      this.fromYValue,
      this.fromToYValue,
      this.xValue,
      this.yString,
      this.xString,
      this.color});
}
