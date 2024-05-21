// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EndTimeMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndTimeMissionModel _$EndTimeMissionModelFromJson(Map<String, dynamic> json) =>
    EndTimeMissionModel(
      message: json['message'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..folder_id = json['folder_id'] as String?
      ..title = json['title'] as String?
      ..time_format = json['time_format'] as String?
      ..indexSearchingStart = json['indexSearchingStart'] as int?
      ..indexSearchingEnd = json['indexSearchingEnd'] as int?
      ..device_id = json['device_id'] as String?
      ..tagNames = json['tagNames'] as String?
      ..tagIds = json['tagIds'] as String?
      ..background_url = json['background_url'] as String?
      ..no_tomotoes_finished = json['no_tomotoes_finished'] as int?
      ..total_tomotoes = json['total_tomotoes'] as int?
      ..tomato_duration = json['tomato_duration'] as int?
      ..order_index = json['order_index'] as int?
      ..end_time_before_finished = json['end_time_before_finished'] as int?
      ..end_time = json['end_time'] as int?
      ..alert_time = json['alert_time'] as int?
      ..time_finished = json['time_finished'] as int?
      ..dateStatus = json['dateStatus'] as int?
      ..priorityStatus = json['priorityStatus'] as int?
      ..finish_time = json['finish_time'] as int?
      ..daily_start_time = json['daily_start_time'] as int?
      ..daily_end_time = json['daily_end_time'] as int?
      ..isFinished = json['isFinished'] as bool?
      ..isDelayed = json['isDelayed'] as bool?
      ..repetiveType = json['repetiveType'] as int?
      ..repetiveValue = json['repetiveValue'] as int?
      ..repetiveWeekDay = json['repetiveWeekDay'] as List<dynamic>?
      ..uid = json['uid'] as String?;

Map<String, dynamic> _$EndTimeMissionModelToJson(
        EndTimeMissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'folder_id': instance.folder_id,
      'title': instance.title,
      'time_format': instance.time_format,
      'indexSearchingStart': instance.indexSearchingStart,
      'indexSearchingEnd': instance.indexSearchingEnd,
      'device_id': instance.device_id,
      'tagNames': instance.tagNames,
      'tagIds': instance.tagIds,
      'background_url': instance.background_url,
      'no_tomotoes_finished': instance.no_tomotoes_finished,
      'total_tomotoes': instance.total_tomotoes,
      'tomato_duration': instance.tomato_duration,
      'order_index': instance.order_index,
      'end_time_before_finished': instance.end_time_before_finished,
      'end_time': instance.end_time,
      'alert_time': instance.alert_time,
      'time_finished': instance.time_finished,
      'dateStatus': instance.dateStatus,
      'priorityStatus': instance.priorityStatus,
      'finish_time': instance.finish_time,
      'daily_start_time': instance.daily_start_time,
      'daily_end_time': instance.daily_end_time,
      'message': instance.message,
      'isFinished': instance.isFinished,
      'isDelayed': instance.isDelayed,
      'repetiveType': instance.repetiveType,
      'repetiveValue': instance.repetiveValue,
      'repetiveWeekDay': instance.repetiveWeekDay,
      'uid': instance.uid,
    };
