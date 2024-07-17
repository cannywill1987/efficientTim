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
      ..order_index = (json['order_index'] as num?)?.toInt()
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..device_id = json['device_id'] as String?
      ..number = (json['number'] as num?)?.toInt()
      ..uid = json['uid'] as String?
      ..noteUrl = json['noteUrl'] as String?
      ..update_time = (json['update_time'] as num?)?.toInt()
      ..create_time = (json['create_time'] as num?)?.toInt()
      ..tag = (json['tag'] as num?)?.toInt()
      ..color = (json['color'] as num).toInt()
      ..tagColor = (json['tagColor'] as num?)?.toInt()
      ..icon = (json['icon'] as num?)?.toInt()
      ..tagName = json['tagName'] as String?
      ..iconType = (json['iconType'] as num?)?.toInt();

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
