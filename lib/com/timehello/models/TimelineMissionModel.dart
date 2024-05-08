/**
 * 每个folderModel下有多个TimelineMissionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import 'RepetiveWeekDay.dart';

part 'TimelineMissionModel.g.dart';

@JsonSerializable()
class TimelineMissionModel extends MongoDbObject{
  //
  String? sceneType; //场景

  String? eventType; //事件

  String? timelineMessage;

  String? extra; //用于放额外数据

  String? picUrl;

  String? url;

  int? color = 0;
  int? tagColor;
  int? icon = 0; //左侧图标
  String? tagName; //标签名称

  String? mission_id; //missionModel的id

  String? object_id; //用于关联其他表的id

  // String id;
  //博客内容
  String? folder_id; //folderModel的ObjectId
  //博客作者
  String? title = ''; //标题

  int? indexSearchingStart = -1; //不存储 用于搜索

  int? indexSearchingEnd = -1; //不存储 用于搜索

  String? device_id; //设备Id

  String? tagNames; //通过逗号,分割

  String? tagIds; //通过逗号,分割

  int? no_tomotoes_finished = 0; //完成番茄的数量

  int? total_tomotoes; //总番茄数

  int? tomato_duration = 0; //每个任务的默认番茄时间 默认25分钟 单位ms 来着sharepreference

  int? order_index; //顺序，好像用不上

  int? end_time_before_finished; //isFinish=false为空 true则为完成任务前end_time设置的时间 end_time变成真实时间 方便initCalendar计算end_time值，这个则是方便用来展示任务完成时了解到的预置时间

  int? end_time; //默认空是0 isFinished = false 计划到期日 isFinished = true 实际到期日

  int? alert_time; //通知推送时间 年 月 日 时 分 秒

  int? time_finished = 0; // 已经完成的时间 用于statistic 的时间统计

  int? dateStatus; // 0 今天 1 明天 2 7天后 3待定

  int? priorityStatus; //3 无优先级  2 低优先级 1 中优先级 0 高优先级

  String? message;
  //是否完成
  bool? isFinished = false;
  //是否延期
  bool? isDelayed = false; // repetiveType 0 为0时是否有延期完成任务

  int? repetiveType = 0; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复 如果0 关闭 end_time不会作用 重复拥有更高优先级
  int? repetiveValue = 0; //天 月 年
  List? repetiveWeekDay = [false, false, false, false, false, false, false, ];
  String? uid;


  TimelineMissionModel({
    this.extra,
    this.picUrl,
    this.url,
    this.color,
    this.tagColor,
    this.icon,
    this.tagName,
    this.timelineMessage,
      this.sceneType,
      this.eventType,
      this.folder_id,
      this.title,
      this.device_id,
      this.tagNames,
      this.tagIds,
      this.no_tomotoes_finished,
      this.total_tomotoes,
      this.tomato_duration,
      this.order_index,
      this.end_time_before_finished,
      this.end_time,
      this.alert_time,
      this.time_finished,
      this.dateStatus,
      this.priorityStatus,
      this.message,
      this.isFinished,
      this.isDelayed,
      this.repetiveType,
      this.repetiveValue,
      this.repetiveWeekDay,
      this.uid});

  get repetiveWeekDayGetSet {
    if (repetiveWeekDay == null) {
      return  RepetiveWeekDay();
    }
    return this.repetiveWeekDay;
  }

  // BmobUser author;
  // BmobGeoPoint addr;
  // BmobDate time;
  // BmobFile pic;

  //此处与类名一致，由指令自动生成代码
  factory TimelineMissionModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineMissionModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$TimelineMissionModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


}