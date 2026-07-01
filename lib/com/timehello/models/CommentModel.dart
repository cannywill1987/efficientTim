/**
 * 文件类型：Flutter MongoDB 好评与反馈模型
 * 文件作用：承载 CommentModel 的用户反馈、五星评分和处理状态字段。
 * 主要职责：与 Egg CommentModel 保持字段对齐，并通过 appScene 隔离不同 App 的反馈数据。
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
class CommentModel extends MongoDbObject {
  @JsonKey(defaultValue: 'efficientTime')
  String? appScene = 'efficientTime'; // 多 App 共用后台时用于隔离反馈数据
  String? title = ''; //标题
  String? content = ''; //标题
  String? avatar = ''; //标题
  String? uid = ''; //标题
  String? device_id = ''; //标题
  String? username = ''; //标题
  String? countryCode = '';
  int? rating = 0; // 1-5 星评分，0 表示普通反馈或未评分
  String? contact = ''; // 用户可选联系方式：手机号或邮箱
  String? platform = ''; // iOS / macOS / Android / Web 等平台来源
  String? market = ''; // Google Play / App Store / 华为等应用市场来源
  bool? storeReviewPrompted = false; // 是否已经触发过商店好评引导
  int? storeReviewPromptedAt; // 触发商店好评引导的时间戳
  String? officialReply = ''; // 官方回复内容
  int? officialReplyAt; // 官方回复时间戳
  int? handledAt; // 状态被处理/关闭的时间戳
  int? update_time;
  int? create_time;
  int? status = 0; // 0-未处理 1-处理中 2-开发中 3-处理完成 4-不予处理
  // BmobUser author;
  CommentModel();

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
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
