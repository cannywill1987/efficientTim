// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlomoFolderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlomoFolderModel _$FlomoFolderModelFromJson(Map<String, dynamic> json) =>
    FlomoFolderModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..order_index = json['order_index'] as int?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..device_id = json['device_id'] as String?
      ..number = json['number'] as int?
      ..uid = json['uid'] as String?
      ..noteUrl = json['noteUrl'] as String?
      ..update_time = json['update_time'] as int?
      ..create_time = json['create_time'] as int?
      ..tag = json['tag'] as int?
      ..color = json['color'] as int
      ..tagColor = json['tagColor'] as int?
      ..icon = json['icon'] as int?
      ..tagName = json['tagName'] as String?
      ..iconType = json['iconType'] as int?;

Map<String, dynamic> _$FlomoFolderModelToJson(FlomoFolderModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'order_index': instance.order_index,
      'title': instance.title,
      'description': instance.description,
      'device_id': instance.device_id,
      'number': instance.number,
      'uid': instance.uid,
      'noteUrl': instance.noteUrl,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
      'tag': instance.tag,
      'color': instance.color,
      'tagColor': instance.tagColor,
      'icon': instance.icon,
      'tagName': instance.tagName,
      'iconType': instance.iconType,
    };
