//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'StatsModel.g.dart';

/**
 * 用来统计任务图形
 */
/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class StatsModel extends MongoDbObject {
  String? title; //任务标题

  int? type = 0; // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel

  int? focus_duration = 0;

  String? tagNames; //标签名称

  String? category; //分类 文件夹名称

  int? color;

  int? icon;

  String? device_id; //设备ID

  double? value; //

  int? begin_time; //任务开始时间,如果是type=1，及这个mission

  int? finish_time; //任务完成时间

  int? duration = 0;

  //博客内容
  String? folder_id; //folderModel的ObjectId

  String? mission_id; //folderModel的ObjectId

  String? uid;

  // int get mType {
  //   return this.type == null ? 0 : type;
  // }

  // BmobUser? author;
  // BmobGeoPoint addr;
  // BmobDate time;
  // BmobFile pic;
  StatsModel();

  //此处与类名一致，由指令自动生成代码
  factory StatsModel.fromJson(Map<String, dynamic> json) {
    final StatsModel statsModel = _$StatsModelFromJson(_normalizeJson(json));
    final int? beginTime = statsModel.begin_time;
    final int? finishTime = statsModel.finish_time;
    final double? targetValue = statsModel.value;

    // 历史数据里 value 可能是 double，开始/结束时间也可能为空；统一用解析后的字段计算，
    // 避免启动时被 raw json 的动态类型打断。
    if (beginTime != null && finishTime != null) {
      final int elapsedDuration = finishTime - beginTime;
      statsModel.duration = targetValue != null && elapsedDuration > targetValue
          ? targetValue.toInt()
          : elapsedDuration;
    } else if (statsModel.duration == null && targetValue != null) {
      statsModel.duration = targetValue.toInt();
    }
    return statsModel;
  }

  /**
   * 功能：兼容 Mongo 历史数据中数字字段为字符串、double 或空值的情况。
   *
   * 说明：StatsModel 会在启动统计链路里批量解析，不能让单条历史脏数据影响首页进入。
   */
  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final Map<String, dynamic> normalized = Map<String, dynamic>.from(json);
    const List<String> intFields = [
      'type',
      'focus_duration',
      'color',
      'icon',
      'begin_time',
      'finish_time',
      'duration',
    ];
    for (final String field in intFields) {
      normalized[field] = _parseNullableInt(normalized[field]);
    }
    normalized['value'] = _parseNullableDouble(normalized['value']);
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

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      final String trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() {
    return _$StatsModelToJson(this);
  }

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
