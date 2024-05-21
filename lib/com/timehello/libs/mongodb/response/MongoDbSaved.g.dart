// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbSaved.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbSaved _$MongoDbSavedFromJson(Map<String, dynamic> json) => MongoDbSaved()
  ..createdAt = json['createdAt'] as String?
  ..objectId = json['_id'] as String?;

Map<String, dynamic> _$MongoDbSavedToJson(MongoDbSaved instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      '_id': instance.objectId,
    };
