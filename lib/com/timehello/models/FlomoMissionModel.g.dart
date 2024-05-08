// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlomoMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlomoMissionModel _$FlomoMissionModelFromJson(Map<String, dynamic> json) =>
    FlomoMissionModel(
      message: json['message'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..folder_id = json['folder_id'] as String?
      ..title = json['title'] as String?
      ..device_id = json['device_id'] as String?
      ..icon = json['icon'] as int?
      ..color = json['color'] as int?
      ..tagNames = json['tagNames'] as String?
      ..daily_num_times = json['daily_num_times'] as int
      ..tagIds = json['tagIds'] as String?
      ..background_url = json['background_url'] as String?
      ..clocks_days = json['clocks_days'] as int?
      ..start_time = json['start_time'] as int?
      ..end_time = json['end_time'] as int?
      ..is_alert_on = json['is_alert_on'] as bool
      ..clockIn = json['clockIn'] as Map<String, dynamic>?
      ..alert_times =
          (json['alert_times'] as List<dynamic>).map((e) => e as int).toList()
      ..messages = json['messages'] as List<dynamic>?
      ..inspration_message = json['inspration_message'] as String?
      ..isFinished = json['isFinished'] as bool?
      ..repetiveType = json['repetiveType'] as int?
      ..repetiveValue = json['repetiveValue'] as int?
      ..repetiveWeekDay = json['repetiveWeekDay'] as List<dynamic>?
      ..uid = json['uid'] as String?
      ..finish_time = json['finish_time'] as int?
      ..order_index = json['order_index'] as int?
      ..isDelayed = json['isDelayed'] as bool?
      ..indexSearchingStart = json['indexSearchingStart'] as int?
      ..indexSearchingEnd = json['indexSearchingEnd'] as int?
      ..no_tomotoes_finished = json['no_tomotoes_finished'] as int?
      ..total_tomotoes = json['total_tomotoes'] as int?
      ..tomato_duration = json['tomato_duration'] as int?
      ..end_time_before_finished = json['end_time_before_finished'] as int?
      ..alert_time = json['alert_time'] as int?
      ..time_finished = json['time_finished'] as int?
      ..dateStatus = json['dateStatus'] as int?
      ..priorityStatus = json['priorityStatus'] as int?;

Map<String, dynamic> _$FlomoMissionModelToJson(FlomoMissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'folder_id': instance.folder_id,
      'title': instance.title,
      'device_id': instance.device_id,
      'icon': instance.icon,
      'color': instance.color,
      'tagNames': instance.tagNames,
      'daily_num_times': instance.daily_num_times,
      'tagIds': instance.tagIds,
      'background_url': instance.background_url,
      'clocks_days': instance.clocks_days,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'is_alert_on': instance.is_alert_on,
      'clockIn': instance.clockIn,
      'alert_times': instance.alert_times,
      'messages': instance.messages,
      'inspration_message': instance.inspration_message,
      'isFinished': instance.isFinished,
      'repetiveType': instance.repetiveType,
      'repetiveValue': instance.repetiveValue,
      'repetiveWeekDay': instance.repetiveWeekDay,
      'uid': instance.uid,
      'finish_time': instance.finish_time,
      'order_index': instance.order_index,
      'isDelayed': instance.isDelayed,
      'message': instance.message,
      'indexSearchingStart': instance.indexSearchingStart,
      'indexSearchingEnd': instance.indexSearchingEnd,
      'no_tomotoes_finished': instance.no_tomotoes_finished,
      'total_tomotoes': instance.total_tomotoes,
      'tomato_duration': instance.tomato_duration,
      'end_time_before_finished': instance.end_time_before_finished,
      'alert_time': instance.alert_time,
      'time_finished': instance.time_finished,
      'dateStatus': instance.dateStatus,
      'priorityStatus': instance.priorityStatus,
    };
