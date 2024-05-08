/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'EventCollectionModel.g.dart';
/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class EventCollectionModel extends MongoDbObject{
  String sceneType = ''; //场景名称
  String? eventType; //事件名称
  String? resultType; //结果名称
  String? testType; //ab名称
  String? message; //消息名称
  double? value1; //值
  String? deviceId; //ab名称
  int? create_time;
  int? update_time;
  String? create_time_utc; //用于标准化上报时间
  String? timeZoneOffset; //时区 //8:00:00.000000  缩写为+8.00
  String? country;
  String? timezoneName;
  String? uid;
  String? sysCode;
  String? appVersion;
  String? systemVersion;
  String? deviceKey; //即deviceId
  String? appChannel;
  String? productType;
  String? productName;
  String? appType;
  String? lang;
  String? networkType;
  String? brand;

  String? region;
  String? regionName;
  String? city;
  double? lat;
  double? lon;
  String? countryCode;
  String? ip;
  EventCollectionModel();

  factory EventCollectionModel.fromJson(Map<String, dynamic> json) => _$EventCollectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventCollectionModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}