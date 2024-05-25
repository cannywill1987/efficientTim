// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FolderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) => FolderModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..originalFolderId = json['originalFolderId'] as String?
  ..courseModelId = json['courseModelId'] as String?
  ..layoutType = json['layoutType'] as int?
  ..order_index = json['order_index'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..device_id = json['device_id'] as String?
  ..number = json['number'] as int?
  ..uid = json['uid'] as String?
  ..noteUrl = json['noteUrl'] as String?
  ..timelineNoteObjectId = json['timelineNoteObjectId'] as String?
  ..numberNoteWords = json['numberNoteWords'] as int?
  ..start_time = json['start_time'] as int?
  ..end_time = json['end_time'] as int?
  ..update_time = json['update_time'] as int?
  ..create_time = json['create_time'] as int?
  ..tag = json['tag'] as int?
  ..color = json['color'] as int
  ..tagColor = json['tagColor'] as int?
  ..icon = json['icon'] as int?
  ..tagName = json['tagName'] as String?
  ..type = json['type'] as int?
  ..iconType = json['iconType'] as int?
  ..groupModelObjectIdOrderList =
      (json['groupModelObjectIdOrderList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
  ..folderTeamWorkId = json['folderTeamWorkId'] as String?
  ..introText = json['introText'] as String?
  ..groupChatPassword = json['groupChatPassword'] as String?
  ..otherUids = json['otherUids'] as List<dynamic>?
  ..isOtherUserEditable = json['isOtherUserEditable'] as bool?
  ..isSharing = json['isSharing'] as int?
  ..folderStatus = json['folderStatus'] as int?
  ..cryptoVersion = json['cryptoVersion'] as int?
  ..folderModelObjectIdOrderList =
      (json['folderModelObjectIdOrderList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
  ..otherUserInfo = json['otherUserInfo'] as List<dynamic>?;

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'originalFolderId': instance.originalFolderId,
      'courseModelId': instance.courseModelId,
      'layoutType': instance.layoutType,
      'order_index': instance.order_index,
      'title': instance.title,
      'description': instance.description,
      'device_id': instance.device_id,
      'number': instance.number,
      'uid': instance.uid,
      'noteUrl': instance.noteUrl,
      'timelineNoteObjectId': instance.timelineNoteObjectId,
      'numberNoteWords': instance.numberNoteWords,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
      'tag': instance.tag,
      'color': instance.color,
      'tagColor': instance.tagColor,
      'icon': instance.icon,
      'tagName': instance.tagName,
      'type': instance.type,
      'iconType': instance.iconType,
      'groupModelObjectIdOrderList': instance.groupModelObjectIdOrderList,
      'folderTeamWorkId': instance.folderTeamWorkId,
      'introText': instance.introText,
      'groupChatPassword': instance.groupChatPassword,
      'otherUids': instance.otherUids,
      'isOtherUserEditable': instance.isOtherUserEditable,
      'isSharing': instance.isSharing,
      'folderStatus': instance.folderStatus,
      'cryptoVersion': instance.cryptoVersion,
      'folderModelObjectIdOrderList': instance.folderModelObjectIdOrderList,
      'otherUserInfo': instance.otherUserInfo,
    };
