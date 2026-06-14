/**
 * 每个folderModel下有多个missionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/models/SubmissionModel.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import '../util/BeanParser.dart';
import '../util/Utility.dart';
import 'RepetiveWeekDay.dart';

part 'MissionModel.g.dart';

@JsonSerializable()
class MissionModel extends MongoDbObject {
  int? missionModelType = 0; //null 或者 0是默认的 1是苹果日历 2是苹果提醒 3.google日历

  //博客内容
  String? folder_id; //folderModel的ObjectId

  @JsonKey(ignore: true)
  String? folder_title; //folderModel的ObjectId

  //分组展示时的groupid
  String? group_id; //folderModel的ObjectId

  //子任务
  @JsonKey(name: 'subMissions')
  List? _subMissions =
      []; // [{"id":id, isFinished: false, "title": "title", "notificationTime": timestamp, "numToamatoesFocused": 0, "numToamatoTotal": 0, "create_time": 0, "update_time": 0}]

  @JsonKey(ignore: true)
  List<SubmissionModel>? _subMissionModels = [];

  @JsonKey(ignore: true)
  int localDuration = 0;

  @JsonKey(ignore: true)
  String? localDurationString;

  // @JsonKey(ignore: true)
  // List<SubmissionModel> subMissionModels = [];

  // Map? get subMissions() {return _jumpFromFolderPageToMissionPage ?? null};

  // set subMissions(List? value) {
  //   subMissions = value;
  //   // notifyListeners();
  // }

  int? time_mode = 0; // 0 日期 1 时间段 2 目标

  //博客作者
  String? title = ''; //标题

  int? indexSearchingStart = -1; //不存储 用于搜索

  int? indexSearchingEnd = -1; //不存储 用于搜索

  String? device_id; //设备Id

  String? tagNames; //通过逗号,分割 但是如果folderModel是tags好像

  String? tagIds; //通过逗号,分割

  String? background_url; //背景url

  int? no_tomotoes_finished = 0; //完成番茄的数量

  int? total_tomotoes; //总番茄数

  int? color = 0xffff8800; // foldermodel的颜色

  int? tomato_duration = 0; //每个任务的默认番茄时间 默认25分钟 单位ms 来着sharepreference

  int? order_index; //顺序，好像用不上

  int?
      end_time_before_finished; //不用了 isFinish=false为空 true则为完成任务前end_time设置的时间 end_time变成真实时间 方便initCalendar计算end_time值，这个则是方便用来展示任务完成时了解到的预置时间

  int? start_time; //开始时间

  int? _end_time =
      0; //设置的预期完成时间 默认空是0 isFinished = false 计划到期日 isFinished = true 实际到期日

  int? finish_time; //最后完成任务的真实事件

  int?
      alert_time; //通知推送时间 年 月 日 时 分 秒 如果是重复 那这个时间是relative 如果不重复 时间是absolute的毫秒时间戳

  int? time_finished = 0; // 已经完成的时间 用于statistic 的时间统计

  int? dateStatus; // 1 今天 2 明天 3 7天后 4 所有为完成任务 12 待定任务 13 碎片清单

  int? priorityStatus; //3 无优先级  2 低优先级 1 中优先级 0 高优先级

  int? daily_start_time; //每日开始时间

  int? mission_value; //任务价值

  List? do_it_now =
      []; //现在开始做的时间 map {"end_time": 毫秒时间戳, "buffer_end_time": 缓冲时间戳, money: 0, "real_end_time": 0}

  int? daily_end_time; //每日结束时间

  String? message;
  //是否完成
  bool? isFinished = false;
  //是否延期
  bool? isDelayed = false; // repetiveType 0 为0时是否有延期完成任务

  int? repetiveType =
      0; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复 如果0 关闭 end_time不会作用 重复拥有更高优先级

  List<Map<String, dynamic>>? repeativeDate =
      []; // 重复模式的日期 [{date:"2020-12-12", isFinished: true}]等

  int? repetiveValue = 0; // 0 没有重复 1 天 2 周 3月 4年
  List? repetiveWeekDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  int? repetive_end_time = 0; // 结束重复的时间 毫秒时间戳

  String? uid;

  //下面的用于做笔记
  List<String>? noteSmallUrls = []; // 数组用于存储图片url

  List<String>? noteBigUrls = []; // 数组用于存储图片url

  List<String>? noteOriginUrls = []; // 数组用于存储原始图片url

  int? notePoint = 0; //知识点错题本的三种格式 0 图片 1 录音 2 纯文本 3 富文本 4新富文本

  // String? noteContent = ""; //知识点错题本 如果是富文本就是Url

  String? noteRichContentUrl = ""; //知识点错题本 如果是富文本就是Url

  List? noteRecordUrls =
      []; //录音列表，单条 map 支持 url、duration、localUrl、fileSize、recordText 等字段

  List? attachmentUrls = []; //附件url {}

  String? newRichEditorUrl = ""; //新富文本url

  int? cryptoVersion = -1; // -1代表没有设置加密 0代表设置了加密版本 1代表设置了加密版本并且加密了

  bool? hasDecrypted =
      false; //是否解密过 cryptoVersion = 0 hasDecrypted = true 代表解密过

  String? objectiveUnit = ""; //目标单位

  double? _objectiveValue = 0; //目标值

  double? objectiveStartValue = 0; //目标值

  double? _objectiveTotalValue = 0; //目标值完成

  @JsonKey(ignore: true)
  double? objectivePercent = 0;

  @JsonKey(ignore: true)
  String? objectivePercentString = "0%";

  @JsonKey(ignore: true)
  bool isSelected = false; //用于多选

  set objectiveTotalValue(double? val) {
    if (val != null && val != 0) {
      objectivePercent = ((objectiveValue ?? 0) / val) * 100;
    } else {
      objectivePercent = 0;
    }
    if (objectivePercent != null) {
      objectivePercentString = "${objectivePercent?.toStringAsFixed(1)}%";
    } else {
      objectivePercentString = "0%";
    }
    _objectiveTotalValue = val;
  }

  double? get objectiveTotalValue {
    return _objectiveTotalValue ?? 0;
  }

  set objectiveValue(double? val) {
    if (objectiveTotalValue != null && objectiveTotalValue != 0) {
      objectivePercent = ((val ?? 0) / objectiveTotalValue!) * 100;
    } else {
      objectivePercent = 0;
    }
    if (objectivePercent != null) {
      objectivePercentString = "${objectivePercent?.toStringAsFixed(1)}%";
    } else {
      objectivePercentString = "0%";
    }
    _objectiveValue = val;
  }

  double? get objectiveValue {
    return _objectiveValue ?? 0;
  }

  int? get end_time {
    return _end_time;
  }

  set end_time(int? value) {
    if (value == null) {
      return;
    }
    // 如果没有设置结束重复时间，那么重复结束时间就会是结束时间
    if (repetive_end_time == null) {
      repetive_end_time = value;
    }
    _end_time = value;
  }

  // get subMissions {
  //   return this.subMissions
  // }

  List? get subMissions {
    // this.subMissionModels = BeanParser.parseSubmissionModelList(value ?? []);
    return this._subMissions ?? [];
  }

  set subMissions(List? value) {
    this._subMissionModels = BeanParser.parseSubmissionModelList(value ?? []);
    if (this._subMissionModels?.length == 0) {
      int id = Utility.getRandom(from: 0, max: 100000);
      this._subMissionModels?.add(SubmissionModel(
          isFinished: false,
          id: id,
          shouldFocus: false,
          title: "",
          key: ValueKey(id.toString()),
          notificationTime: -1,
          numToamatoesFocused: 0,
          numToamatoTotal: 0,
          create_time: Utility.getTimeStampToday(),
          update_time: Utility.getTimeStampToday()));
    }
    _subMissions = value;
  }

  @JsonKey(ignore: true)
  List<SubmissionModel> get subMissionModels {
    // this._subMissionModels = BeanParser.parseSubmissionModelList(value ?? []);
    return this._subMissionModels ?? [];
  }

  @JsonKey(ignore: true)
  set subMissionModels(List<SubmissionModel> value) {
    this._subMissions =
        BeanParser.parseSubmissionModelListToJsonMap(value ?? []);
    _subMissionModels = value;
  }

  get repetiveWeekDayGetSet {
    if (repetiveWeekDay == null) {
      return RepetiveWeekDay();
    }
    return this.repetiveWeekDay;
  }

  // BmobUser author;
  // BmobGeoPoint addr;
  // BmobDate time;
  // BmobFile pic;
  MissionModel({this.message});

  //此处与类名一致，由指令自动生成代码
  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MissionModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
