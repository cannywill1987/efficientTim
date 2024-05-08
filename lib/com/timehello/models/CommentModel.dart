/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'CommentModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class CommentModel extends MongoDbObject{
  String? title = ''; //标题
  String? content = ''; //标题
  String? avatar = ''; //标题
  String? uid = ''; //标题
  String? device_id = ''; //标题
  String? username = ''; //标题
  String? countryCode = '';
  int? update_time;
  int? create_time;
  int? status = 0; // 0-未处理 1-处理中 2-开发中 3-处理完成 4-不予处理
  // BmobUser author;
  CommentModel();

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}