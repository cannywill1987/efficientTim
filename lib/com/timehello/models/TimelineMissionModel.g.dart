// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimelineMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineMissionModel _$TimelineMissionModelFromJson(
        Map<String, dynamic> json) =>
    TimelineMissionModel(
      extra: json['extra'] as String?,
      picUrl: json['picUrl'] as String?,
      url: json['url'] as String?,
      color: json['color'] as int?,
      tagColor: json['tagColor'] as int?,
      icon: json['icon'] as int?,
      tagName: json['tagName'] as String?,
      timelineMessage: json['timelineMessage'] as String?,
      sceneType: json['sceneType'] as String?,
      eventType: json['eventType'] as String?,
      folder_id: json['folder_id'] as String?,
      title: json['title'] as String?,
      device_id: json['device_id'] as String?,
      tagNames: json['tagNames'] as String?,
      tagIds: json['tagIds'] as String?,
      no_tomotoes_finished: json['no_tomotoes_finished'] as int?,
      total_tomotoes: json['total_tomotoes'] as int?,
      tomato_duration: json['tomato_duration'] as int?,
      order_index: json['order_index'] as int?,
      end_time_before_finished: json['end_time_before_finished'] as int?,
      end_time: json['end_time'] as int?,
      alert_time: json['alert_time'] as int?,
      time_finished: json['time_finished'] as int?,
      dateStatus: json['dateStatus'] as int?,
      priorityStatus: json['priorityStatus'] as int?,
      message: json['message'] as String?,
      isFinished: json['isFinished'] as bool?,
      isDelayed: json['isDelayed'] as bool?,
      repetiveType: json['repetiveType'] as int?,
      repetiveValue: json['repetiveValue'] as int?,
      repetiveWeekDay: json['repetiveWeekDay'] as List<dynamic>?,
      uid: json['uid'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..mission_id = json['mission_id'] as String?
      ..object_id = json['object_id'] as String?
      ..indexSearchingStart = json['indexSearchingStart'] as int?
      ..indexSearchingEnd = json['indexSearchingEnd'] as int?;

Map<String, dynamic> _$TimelineMissionModelToJson(
        TimelineMissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'sceneType': instance.sceneType,
      'eventType': instance.eventType,
      'timelineMessage': instance.timelineMessage,
      'extra': instance.extra,
      'picUrl': instance.picUrl,
      'url': instance.url,
      'color': instance.color,
      'tagColor': instance.tagColor,
      'icon': instance.icon,
      'tagName': instance.tagName,
      'mission_id': instance.mission_id,
      'object_id': instance.object_id,
      'folder_id': instance.folder_id,
      'title': instance.title,
      'indexSearchingStart': instance.indexSearchingStart,
      'indexSearchingEnd': instance.indexSearchingEnd,
      'device_id': instance.device_id,
      'tagNames': instance.tagNames,
      'tagIds': instance.tagIds,
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
      'message': instance.message,
      'isFinished': instance.isFinished,
      'isDelayed': instance.isDelayed,
      'repetiveType': instance.repetiveType,
      'repetiveValue': instance.repetiveValue,
      'repetiveWeekDay': instance.repetiveWeekDay,
      'uid': instance.uid,
    };
