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
  ..layoutType = (json['layoutType'] as num?)?.toInt()
  ..order_index = (json['order_index'] as num?)?.toInt()
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..device_id = json['device_id'] as String?
  ..number = (json['number'] as num?)?.toInt()
  ..uid = json['uid'] as String?
  ..noteUrl = json['noteUrl'] as String?
  ..timelineNoteObjectId = json['timelineNoteObjectId'] as String?
  ..numberNoteWords = (json['numberNoteWords'] as num?)?.toInt()
  ..start_time = (json['start_time'] as num?)?.toInt()
  ..end_time = (json['end_time'] as num?)?.toInt()
  ..update_time = (json['update_time'] as num?)?.toInt()
  ..create_time = (json['create_time'] as num?)?.toInt()
  ..tag = (json['tag'] as num?)?.toInt()
  ..color = (json['color'] as num).toInt()
  ..tagColor = (json['tagColor'] as num?)?.toInt()
  ..icon = (json['icon'] as num?)?.toInt()
  ..tagName = json['tagName'] as String?
  ..type = (json['type'] as num?)?.toInt()
  ..iconType = (json['iconType'] as num?)?.toInt()
  ..groupModelObjectIdOrderList =
      (json['groupModelObjectIdOrderList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
  ..folderTeamWorkId = json['folderTeamWorkId'] as String?
  ..introText = json['introText'] as String?
  ..groupChatPassword = json['groupChatPassword'] as String?
  ..otherUids = json['otherUids'] as List<dynamic>?
  ..isOtherUserEditable = json['isOtherUserEditable'] as bool?
  ..isSharing = (json['isSharing'] as num?)?.toInt()
  ..folderStatus = (json['folderStatus'] as num?)?.toInt()
  ..cryptoVersion = (json['cryptoVersion'] as num?)?.toInt()
  ..folderModelObjectIdOrderList =
      (json['folderModelObjectIdOrderList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
  ..filterType = (json['filterType'] as num?)?.toInt()
  ..userInfo = json['userInfo'] as Map<String, dynamic>?
  ..filterConditionMap = json['filterConditionMap'] as Map<String, dynamic>?
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
      'filterType': instance.filterType,
      'userInfo': instance.userInfo,
      'filterConditionMap': instance.filterConditionMap,
      'otherUserInfo': instance.otherUserInfo,
    };

FilterConditionBean _$FilterConditionBeanFromJson(Map<String, dynamic> json) =>
    FilterConditionBean(
      priority: (json['priority'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      keyword: json['keyword'] as String?,
      missionType: (json['missionType'] as num?)?.toInt(),
      startTime: (json['startTime'] as num?)?.toInt(),
      valueBefore: (json['valueBefore'] as num?)?.toInt(),
      valueAfter: (json['valueAfter'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      listingId: (json['listingId'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      unit: (json['unit'] as num?)?.toInt(),
      value: (json['value'] as num?)?.toInt(),
    )..dateType = (json['dateType'] as num?)?.toInt();

Map<String, dynamic> _$FilterConditionBeanToJson(
        FilterConditionBean instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'keyword': instance.keyword,
      'missionType': instance.missionType,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'dateType': instance.dateType,
      'value': instance.value,
      'valueBefore': instance.valueBefore,
      'valueAfter': instance.valueAfter,
      'unit': instance.unit,
      'listingId': instance.listingId,
    };
