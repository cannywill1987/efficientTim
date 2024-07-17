// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ColorsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorsModel _$ColorsModelFromJson(Map<String, dynamic> json) => ColorsModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..title = json['title'] as String?
  ..color = (json['color'] as num).toInt()
  ..code = json['code'] as String?;

Map<String, dynamic> _$ColorsModelToJson(ColorsModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'title': instance.title,
      'color': instance.color,
      'code': instance.code,
    };
