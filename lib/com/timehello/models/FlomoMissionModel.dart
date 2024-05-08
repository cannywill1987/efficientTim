/**
 * 每个folderModel下有多个FlomoMissionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import 'RepetiveWeekDay.dart';

part 'FlomoMissionModel.g.dart';

@JsonSerializable()
class FlomoMissionModel extends MongoDbObject{
  //博客内容
  String? folder_id; //folderModel的ObjectId
  //博客作者
  String? title = ''; //标题

  String? device_id; //设备Id

  int? icon = 0; //左侧图标

  int? color;

  String? tagNames; //通过逗号,分割

  int daily_num_times = 1; //每天打卡次数

  String? tagIds; //通过逗号,分割

  String? background_url; //背景url

  int? clocks_days = 0; //打卡次数（天数）

  int? start_time; //todo 开始时间

  int? end_time; //设置的预期完成时间 默认空是0 isFinished = false 计划到期日 isFinished = true 实际到期日


  // int? end_time; //todo 结束时间


  bool is_alert_on = true; // todo 通知开关是否打开

  Map? clockIn = {}; // todo 打卡次数 [{numClock, totalClocks, timestamp} ]

  List<int> alert_times = []; // 数组 通知推送时间 年 月 日 时 分 秒

  List? messages = []; // todo [date, satisfaction, message]

  String? inspration_message; // todo 鼓励语

  //是否完成
  bool? isFinished = false;

  int? repetiveType = 0; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 艾宾浩斯学习法
  int? repetiveValue = 0; //天 月 年
  List? repetiveWeekDay = [false, false, false, false, false, false, false, ];
  String? uid;

  int? finish_time; //最后完成任务的真实事件


  int? order_index; //顺序，好像用不上

  //是否延期
  bool? isDelayed = false; //todo 这个用不上  repetiveType 0 为0时是否有延期完成任务
  String? message; //todo 这个用不上

  int? indexSearchingStart = -1; //todo 这个用不上 不存储 用于搜索

  int? indexSearchingEnd = -1; //todo 这个用不上 不存储 用于搜索

  int? no_tomotoes_finished = 0; //todo 这个用不上 完成番茄的数量

  int? total_tomotoes; //todo 这个用不上 总番茄数

  int? tomato_duration = 0; //todo 这个用不上 每个任务的默认番茄时间 默认25分钟 单位ms 来着sharepreference

  int? end_time_before_finished; //todo 这个用不上 不用了 isFinish=false为空 true则为完成任务前end_time设置的时间 end_time变成真实时间 方便initCalendar计算end_time值，这个则是方便用来展示任务完成时了解到的预置时间


  int? alert_time; // todo 这个应该用不上了 通知推送时间 年 月 日 时 分 秒

  int? time_finished = 0; // todo 这个应该用不上 已经完成的时间 用于statistic 的时间统计

  int? dateStatus; // todo 这个用不上 0 今天 1 明天 2 7天后 3待定

  int? priorityStatus; //todo 这个用不上 3 无优先级  2 低优先级 1 中优先级 0 高优先级


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
  FlomoMissionModel({this.message});

  //此处与类名一致，由指令自动生成代码
  factory FlomoMissionModel.fromJson(Map<String, dynamic> json) =>
      _$FlomoMissionModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FlomoMissionModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}