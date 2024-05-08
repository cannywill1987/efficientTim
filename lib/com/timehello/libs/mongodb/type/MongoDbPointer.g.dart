// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbPointer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbPointer _$MongoDbPointerFromJson(Map<String, dynamic> json) =>
    MongoDbPointer()
      ..type = json['__type'] as String?
      ..className = json['className'] as String?
      ..objectId = json['objectId'] as String?;

Map<String, dynamic> _$MongoDbPointerToJson(MongoDbPointer instance) =>
    <String, dynamic>{
      '__type': instance.type,
      'className': instance.className,
      'objectId': instance.objectId,
    };
