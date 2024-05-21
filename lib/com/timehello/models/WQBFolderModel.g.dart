// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WQBFolderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WQBFolderModel _$WQBFolderModelFromJson(Map<String, dynamic> json) =>
    WQBFolderModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..originalFolderId = json['originalFolderId'] as String?
      ..courseModelId = json['courseModelId'] as String?
      ..order_index = json['order_index'] as int?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..device_id = json['device_id'] as String?
      ..number = json['number'] as int?
      ..uid = json['uid'] as String?
      ..noteUrl = json['noteUrl'] as String?
      ..timelineNoteObjectId = json['timelineNoteObjectId'] as String?
      ..numberNoteWords = json['numberNoteWords'] as int?
      ..update_time = json['update_time'] as int?
      ..create_time = json['create_time'] as int?
      ..tag = json['tag'] as int?
      ..color = json['color'] as int
      ..tagColor = json['tagColor'] as int?
      ..icon = json['icon'] as int?
      ..tagName = json['tagName'] as String?
      ..type = json['type'] as int?
      ..iconType = json['iconType'] as int?
      ..otherUids = json['otherUids'] as List<dynamic>?
      ..otherUserInfo = json['otherUserInfo'] as List<dynamic>?
      ..isOtherUserEditable = json['isOtherUserEditable'] as bool?
      ..isSharing = json['isSharing'] as int?;

Map<String, dynamic> _$WQBFolderModelToJson(WQBFolderModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'originalFolderId': instance.originalFolderId,
      'courseModelId': instance.courseModelId,
      'order_index': instance.order_index,
      'title': instance.title,
      'description': instance.description,
      'device_id': instance.device_id,
      'number': instance.number,
      'uid': instance.uid,
      'noteUrl': instance.noteUrl,
      'timelineNoteObjectId': instance.timelineNoteObjectId,
      'numberNoteWords': instance.numberNoteWords,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
      'tag': instance.tag,
      'color': instance.color,
      'tagColor': instance.tagColor,
      'icon': instance.icon,
      'tagName': instance.tagName,
      'type': instance.type,
      'iconType': instance.iconType,
      'otherUids': instance.otherUids,
      'otherUserInfo': instance.otherUserInfo,
      'isOtherUserEditable': instance.isOtherUserEditable,
      'isSharing': instance.isSharing,
    };
