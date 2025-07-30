// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbRegistered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbRegistered _$MongoDbRegisteredFromJson(Map<String, dynamic> json) =>
    MongoDbRegistered()
      ..createdAt = json['createdAt'] as String?
      ..objectId = json['objectId'] as String?
      ..sessionToken = json['sessionToken'] as String?;

Map<String, dynamic> _$MongoDbRegisteredToJson(MongoDbRegistered instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'objectId': instance.objectId,
      'sessionToken': instance.sessionToken,
    };
