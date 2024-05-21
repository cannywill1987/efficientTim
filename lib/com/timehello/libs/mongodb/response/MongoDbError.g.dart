// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbError.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbError _$MongoDbErrorFromJson(Map<String, dynamic> json) => MongoDbError(
      json['code'] as int,
      json['error'] as String,
    );

Map<String, dynamic> _$MongoDbErrorToJson(MongoDbError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'error': instance.error,
    };
