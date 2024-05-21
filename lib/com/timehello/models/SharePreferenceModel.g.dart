// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SharePreferenceModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharePreferenceModel _$SharePreferenceModelFromJson(
        Map<String, dynamic> json) =>
    SharePreferenceModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..key = json['key'] as String?
      ..boolVal = json['boolVal'] as bool?
      ..intVal = json['intVal'] as int?
      ..stringVal = json['stringVal'] as String?
      ..arrayVal = json['arrayVal'] as List<dynamic>?
      ..uid = json['uid'] as String?
      ..device_id = json['device_id'] as String?
      ..update_time = json['update_time'] as int?
      ..create_time = json['create_time'] as int?;

Map<String, dynamic> _$SharePreferenceModelToJson(
        SharePreferenceModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'key': instance.key,
      'boolVal': instance.boolVal,
      'intVal': instance.intVal,
      'stringVal': instance.stringVal,
      'arrayVal': instance.arrayVal,
      'uid': instance.uid,
      'device_id': instance.device_id,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
    };
