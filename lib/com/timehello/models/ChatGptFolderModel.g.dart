// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatGptFolderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGptFolderModel _$ChatGptFolderModelFromJson(Map<String, dynamic> json) =>
    ChatGptFolderModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..title = json['title'] as String?
      ..promptTitle = json['promptTitle'] as String?
      ..prompt = json['prompt'] as String?
      ..uid = json['uid'] as String?
      ..isCollect = json['isCollect'] as bool?
      ..update_time = json['update_time'] as int?
      ..create_time = json['create_time'] as int?
      ..color = json['color'] as int?
      ..tagColor = json['tagColor'] as int?;

Map<String, dynamic> _$ChatGptFolderModelToJson(ChatGptFolderModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'title': instance.title,
      'promptTitle': instance.promptTitle,
      'prompt': instance.prompt,
      'uid': instance.uid,
      'isCollect': instance.isCollect,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
      'color': instance.color,
      'tagColor': instance.tagColor,
    };
