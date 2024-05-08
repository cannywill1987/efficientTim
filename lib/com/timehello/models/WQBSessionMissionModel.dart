import 'package:json_annotation/json_annotation.dart';

import 'package:time_hello/com/timehello/models/MissionModel.dart';

import 'WQBMissionModel.dart';

part 'WQBSessionMissionModel.g.dart';
/**
 * MissionPages排序每个MissionModels后的数据
 */
@JsonSerializable()
class WQBSessionMissionModel{
  String? title = ''; //标题 比如时间排序就是 2022-01 2022-02
  List<WQBMissionModel>? datas;
  WQBSessionMissionModel({this.title, this.datas});

  //反序列化
  factory WQBSessionMissionModel.fromJson(Map<String, dynamic> json) => _$WQBSessionMissionModelFromJson(json);
//序列化
  Map<String, dynamic> toJson() => _$WQBSessionMissionModelToJson(this);
}

