import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import 'package:time_hello/com/timehello/models/MissionModel.dart';

part 'SessionMissionModel.g.dart';
/**
 * MissionPages排序每个MissionModels后的数据
 */
@JsonSerializable()
class SessionMissionModel{
  String? folder_id;
  String? title = ''; //标题 比如时间排序就是 2022-01 2022-02
  DateTime? date; // 时间戳
  @JsonKey(ignore: true)
  int? color;
  List<MissionModel>? datas;
  List<SessionMissionModel>? listSessionMissionModel;
  SessionMissionModel({this.listSessionMissionModel ,this.date, this.color, this.title, this.datas, this.folder_id});

  //反序列化
  factory SessionMissionModel.fromJson(Map<String, dynamic> json) => _$SessionMissionModelFromJson(json);
//序列化
  Map<String, dynamic> toJson() => _$SessionMissionModelToJson(this);
}

