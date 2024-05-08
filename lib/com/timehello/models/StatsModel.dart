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
class StatsModel extends MongoDbObject{

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
    StatsModel statsModel = _$StatsModelFromJson(json);
    //value是默认番茄钟的值， 如果其实时间和结束时间花的时间很多证明期间有展厅 ，以value为准， 小的话证明提前完成
    statsModel.duration = (json['finish_time'] - json['begin_time']) > json['value'] ? json['value'] : (json['finish_time'] - json['begin_time']);
    return statsModel;
  }
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$StatsModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


}