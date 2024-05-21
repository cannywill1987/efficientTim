// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbRelation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbRelation _$MongoDbRelationFromJson(Map<String, dynamic> json) =>
    MongoDbRelation()
      ..op = json['__op'] as String?
      ..objects = (json['objects'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

Map<String, dynamic> _$MongoDbRelationToJson(MongoDbRelation instance) =>
    <String, dynamic>{
      '__op': instance.op,
      'objects': instance.objects,
    };
