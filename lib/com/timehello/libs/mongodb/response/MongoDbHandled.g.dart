// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbHandled.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbHandled _$MongoDbHandledFromJson(Map<String, dynamic> json) =>
    MongoDbHandled()
      ..success = json['success'] as bool?
      ..code = json['code'] as String?
      ..sysTime = json['sysTime'] as int?
      ..message = json['message'] as String?
      ..data = json['data'];

Map<String, dynamic> _$MongoDbHandledToJson(MongoDbHandled instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'sysTime': instance.sysTime,
      'message': instance.message,
      'data': instance.data,
    };
