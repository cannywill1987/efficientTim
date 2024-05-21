// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PresentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresentModel _$PresentModelFromJson(Map<String, dynamic> json) => PresentModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..title = json['title'] as String
  ..imageUrl = json['imageUrl'] as String?
  ..value = json['value'] as int?
  ..icon = json['icon'] as int?
  ..color = json['color'] as int?
  ..isLottery = json['isLottery'] as bool?
  ..uid = json['uid'] as String?
  ..device_id = json['device_id'] as String?
  ..update_time = json['update_time'] as int?
  ..create_time = json['create_time'] as int?;

Map<String, dynamic> _$PresentModelToJson(PresentModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'value': instance.value,
      'icon': instance.icon,
      'color': instance.color,
      'isLottery': instance.isLottery,
      'uid': instance.uid,
      'device_id': instance.device_id,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
    };
