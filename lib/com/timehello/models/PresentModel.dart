/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'PresentModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class PresentModel extends MongoDbObject{
  String title = ''; //标题
  String? imageUrl; //图片url
  int? value; //金额
  int? icon = 0; //左侧图标
  int? color = 0;
  bool? isLottery = false;
  String? uid;
  String? device_id;
  int? update_time;
  int? create_time;
  PresentModel();

  factory PresentModel.fromJson(Map<String, dynamic> json) => _$PresentModelFromJson(json);
  Map<String, dynamic> toJson() => _$PresentModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}