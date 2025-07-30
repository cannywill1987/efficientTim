// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) => SettingModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..isListingAppleCalendarOn =
      (json['isListingAppleCalendarOn'] as num?)?.toInt()
  ..isListingAppleAlarmOn = (json['isListingAppleAlarmOn'] as num?)?.toInt()
  ..isListingTodayOn = (json['isListingTodayOn'] as num?)?.toInt()
  ..isListingDoItNowOn = (json['isListingDoItNowOn'] as num?)?.toInt()
  ..isListingTomorrowOn = (json['isListingTomorrowOn'] as num?)?.toInt()
  ..isListingLatest7DaysOn = (json['isListingLatest7DaysOn'] as num?)?.toInt()
  ..isListingTodoListOn = (json['isListingTodoListOn'] as num?)?.toInt()
  ..isListingFragmentOn = (json['isListingFragmentOn'] as num?)?.toInt()
  ..isListingAllUnfinishedMIssion =
      (json['isListingAllUnfinishedMIssion'] as num?)?.toInt()
  ..isListingFinishedOn = (json['isListingFinishedOn'] as num?)?.toInt()
  ..isListingAllOn = (json['isListingAllOn'] as num?)?.toInt()
  ..isListingCalendarVisibleOn =
      (json['isListingCalendarVisibleOn'] as num?)?.toInt()
  ..isListingAlarmVisibleOn = (json['isListingAlarmVisibleOn'] as num?)?.toInt()
  ..isTomatoPageOn = (json['isTomatoPageOn'] as num).toInt()
  ..isTimeManagementPageOn = (json['isTimeManagementPageOn'] as num).toInt()
  ..isCalendarContainerPageOn =
      (json['isCalendarContainerPageOn'] as num).toInt()
  ..isFourQuadrantPageOn = (json['isFourQuadrantPageOn'] as num).toInt()
  ..isTimelinePageOn = (json['isTimelinePageOn'] as num).toInt()
  ..isClockInPCPageOn = (json['isClockInPCPageOn'] as num).toInt()
  ..isWQBContainerOn = (json['isWQBContainerOn'] as num).toInt()
  ..isCountDownListViewPageOn =
      (json['isCountDownListViewPageOn'] as num).toInt()
  ..isCountUpListViewPageOn = (json['isCountUpListViewPageOn'] as num).toInt()
  ..isGamePageOn = (json['isGamePageOn'] as num).toInt()
  ..isLockScreenPageOn = (json['isLockScreenPageOn'] as num).toInt()
  ..isStatisticPageOn = (json['isStatisticPageOn'] as num).toInt()
  ..isAIHelperPageOn = (json['isAIHelperPageOn'] as num).toInt()
  ..isSettingPageOn = (json['isSettingPageOn'] as num).toInt();

Map<String, dynamic> _$SettingModelToJson(SettingModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'isListingAppleCalendarOn': instance.isListingAppleCalendarOn,
      'isListingAppleAlarmOn': instance.isListingAppleAlarmOn,
      'isListingTodayOn': instance.isListingTodayOn,
      'isListingDoItNowOn': instance.isListingDoItNowOn,
      'isListingTomorrowOn': instance.isListingTomorrowOn,
      'isListingLatest7DaysOn': instance.isListingLatest7DaysOn,
      'isListingTodoListOn': instance.isListingTodoListOn,
      'isListingFragmentOn': instance.isListingFragmentOn,
      'isListingAllUnfinishedMIssion': instance.isListingAllUnfinishedMIssion,
      'isListingFinishedOn': instance.isListingFinishedOn,
      'isListingAllOn': instance.isListingAllOn,
      'isListingCalendarVisibleOn': instance.isListingCalendarVisibleOn,
      'isListingAlarmVisibleOn': instance.isListingAlarmVisibleOn,
      'isTomatoPageOn': instance.isTomatoPageOn,
      'isTimeManagementPageOn': instance.isTimeManagementPageOn,
      'isCalendarContainerPageOn': instance.isCalendarContainerPageOn,
      'isFourQuadrantPageOn': instance.isFourQuadrantPageOn,
      'isTimelinePageOn': instance.isTimelinePageOn,
      'isClockInPCPageOn': instance.isClockInPCPageOn,
      'isWQBContainerOn': instance.isWQBContainerOn,
      'isCountDownListViewPageOn': instance.isCountDownListViewPageOn,
      'isCountUpListViewPageOn': instance.isCountUpListViewPageOn,
      'isGamePageOn': instance.isGamePageOn,
      'isLockScreenPageOn': instance.isLockScreenPageOn,
      'isStatisticPageOn': instance.isStatisticPageOn,
      'isAIHelperPageOn': instance.isAIHelperPageOn,
      'isSettingPageOn': instance.isSettingPageOn,
    };
