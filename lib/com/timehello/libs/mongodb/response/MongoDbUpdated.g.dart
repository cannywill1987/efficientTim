// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbUpdated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbUpdated _$MongoDbUpdatedFromJson(Map<String, dynamic> json) =>
    MongoDbUpdated()
      ..success = json['success'] as bool?
      ..code = json['code'] as String?
      ..sysTime = json['sysTime'] as int?
      ..message = json['message'] as String?
      ..data = json['data'];

Map<String, dynamic> _$MongoDbUpdatedToJson(MongoDbUpdated instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'sysTime': instance.sysTime,
      'message': instance.message,
      'data': instance.data,
    };
