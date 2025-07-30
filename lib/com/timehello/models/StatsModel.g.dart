// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsModel _$StatsModelFromJson(Map<String, dynamic> json) => StatsModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..title = json['title'] as String?
  ..type = (json['type'] as num?)?.toInt()
  ..focus_duration = (json['focus_duration'] as num?)?.toInt()
  ..tagNames = json['tagNames'] as String?
  ..category = json['category'] as String?
  ..color = (json['color'] as num?)?.toInt()
  ..icon = (json['icon'] as num?)?.toInt()
  ..device_id = json['device_id'] as String?
  ..value = (json['value'] as num?)?.toDouble()
  ..begin_time = (json['begin_time'] as num?)?.toInt()
  ..finish_time = (json['finish_time'] as num?)?.toInt()
  ..duration = (json['duration'] as num?)?.toInt()
  ..folder_id = json['folder_id'] as String?
  ..mission_id = json['mission_id'] as String?
  ..uid = json['uid'] as String?;

Map<String, dynamic> _$StatsModelToJson(StatsModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'title': instance.title,
      'type': instance.type,
      'focus_duration': instance.focus_duration,
      'tagNames': instance.tagNames,
      'category': instance.category,
      'color': instance.color,
      'icon': instance.icon,
      'device_id': instance.device_id,
      'value': instance.value,
      'begin_time': instance.begin_time,
      'finish_time': instance.finish_time,
      'duration': instance.duration,
      'folder_id': instance.folder_id,
      'mission_id': instance.mission_id,
      'uid': instance.uid,
    };
