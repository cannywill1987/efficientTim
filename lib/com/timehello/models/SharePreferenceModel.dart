/**
 * 文件类型：Mongo 模型
 * 文件作用：保存云端同步的用户偏好设置，兼容 bool/int/string/list 多种值类型。
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
class SharePreferenceModel extends MongoDbObject {
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

  factory SharePreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$SharePreferenceModelFromJson(_normalizeJson(json));
  Map<String, dynamic> toJson() => _$SharePreferenceModelToJson(this);

  /**
   * 功能：兼容历史偏好数据里 int/bool 字段以字符串形式保存的情况。
   *
   * 说明：真机登录账号启动时会加载 SharePreferenceModel；如果云端返回 `"1"`、
   * `"true"` 这类字符串，generated fromJson 的强转会打断启动链路。
   */
  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final Map<String, dynamic> normalized = Map<String, dynamic>.from(json);
    normalized['intVal'] = _parseNullableInt(normalized['intVal']);
    normalized['update_time'] = _parseNullableInt(normalized['update_time']);
    normalized['create_time'] = _parseNullableInt(normalized['create_time']);
    normalized['boolVal'] = _parseNullableBool(normalized['boolVal']);
    return normalized;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final String trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return int.tryParse(trimmed) ?? double.tryParse(trimmed)?.toInt();
    }
    return null;
  }

  static bool? _parseNullableBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final String lower = value.trim().toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return null;
  }

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}
