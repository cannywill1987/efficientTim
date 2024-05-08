/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'SharePreferenceModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class SharePreferenceModel extends MongoDbObject{
  String? key;
  bool? boolVal;
  int? intVal;
  String? stringVal;
  List? arrayVal = [];
  String? uid = ''; //标题
  String? device_id = ''; //标题
  int? update_time;
  int? create_time;
  // BmobUser author;
  SharePreferenceModel();

  factory SharePreferenceModel.fromJson(Map<String, dynamic> json) => _$SharePreferenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$SharePreferenceModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}