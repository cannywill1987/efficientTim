// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StartTimeMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartTimeMissionModel _$StartTimeMissionModelFromJson(
        Map<String, dynamic> json) =>
    StartTimeMissionModel(
      title: json['title'] as String?,
      time_format: json['time_format'] as String?,
      background_url: json['background_url'] as String?,
      device_id: json['device_id'] as String?,
      start_time: (json['start_time'] as num?)?.toInt(),
      isFinished: json['isFinished'] as bool?,
      uid: json['uid'] as String?,
      message: json['message'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..finish_time = (json['finish_time'] as num?)?.toInt();

Map<String, dynamic> _$StartTimeMissionModelToJson(
        StartTimeMissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'title': instance.title,
      'time_format': instance.time_format,
      'device_id': instance.device_id,
      'start_time': instance.start_time,
      'finish_time': instance.finish_time,
      'isFinished': instance.isFinished,
      'uid': instance.uid,
      'background_url': instance.background_url,
      'message': instance.message,
    };
