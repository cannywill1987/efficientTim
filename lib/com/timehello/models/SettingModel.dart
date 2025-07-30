/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'SettingModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class SettingModel extends MongoDbObject{
  int? isListingAppleCalendarOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingAppleAlarmOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingTodayOn = 1; // 1默认显示 0 隐藏 -1 有数据显示
  int? isListingDoItNowOn = 1;  // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingTomorrowOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingLatest7DaysOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingTodoListOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingFragmentOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingAllUnfinishedMIssion = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingFinishedOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingAllOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingCalendarVisibleOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int? isListingAlarmVisibleOn = 1;
  int isTomatoPageOn = 1; // 1默认显示 0 隐藏 -1  有数据显示
  int isTimeManagementPageOn = 1;
  int isCalendarContainerPageOn = 1;
  int isFourQuadrantPageOn = 1;
  int isTimelinePageOn = 1;
  int isClockInPCPageOn = 1;
  int isWQBContainerOn = 1;
  int isCountDownListViewPageOn = 1;
  int isCountUpListViewPageOn = 1;
  int isGamePageOn = 1;
  int isLockScreenPageOn = 1;
  int isStatisticPageOn = 1;
  int isAIHelperPageOn = 1;
  int isSettingPageOn = 1;

  // BmobUser author;
  SettingModel();

  factory SettingModel.fromJson(Map<String, dynamic> json) => _$SettingModelFromJson(json);
  Map<String, dynamic> toJson() => _$SettingModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}