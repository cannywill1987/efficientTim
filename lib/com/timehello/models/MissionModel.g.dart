// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionModel _$MissionModelFromJson(Map<String, dynamic> json) => MissionModel(
      message: json['message'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..missionModelType = (json['missionModelType'] as num?)?.toInt()
      ..folder_id = json['folder_id'] as String?
      ..group_id = json['group_id'] as String?
      ..time_mode = (json['time_mode'] as num?)?.toInt()
      ..title = json['title'] as String?
      ..indexSearchingStart = (json['indexSearchingStart'] as num?)?.toInt()
      ..indexSearchingEnd = (json['indexSearchingEnd'] as num?)?.toInt()
      ..device_id = json['device_id'] as String?
      ..tagNames = json['tagNames'] as String?
      ..tagIds = json['tagIds'] as String?
      ..background_url = json['background_url'] as String?
      ..no_tomotoes_finished = (json['no_tomotoes_finished'] as num?)?.toInt()
      ..total_tomotoes = (json['total_tomotoes'] as num?)?.toInt()
      ..color = (json['color'] as num?)?.toInt()
      ..tomato_duration = (json['tomato_duration'] as num?)?.toInt()
      ..order_index = (json['order_index'] as num?)?.toInt()
      ..end_time_before_finished =
          (json['end_time_before_finished'] as num?)?.toInt()
      ..start_time = (json['start_time'] as num?)?.toInt()
      ..finish_time = (json['finish_time'] as num?)?.toInt()
      ..alert_time = (json['alert_time'] as num?)?.toInt()
      ..time_finished = (json['time_finished'] as num?)?.toInt()
      ..dateStatus = (json['dateStatus'] as num?)?.toInt()
      ..priorityStatus = (json['priorityStatus'] as num?)?.toInt()
      ..daily_start_time = (json['daily_start_time'] as num?)?.toInt()
      ..mission_value = (json['mission_value'] as num?)?.toInt()
      ..do_it_now = json['do_it_now'] as List<dynamic>?
      ..daily_end_time = (json['daily_end_time'] as num?)?.toInt()
      ..isFinished = json['isFinished'] as bool?
      ..isDelayed = json['isDelayed'] as bool?
      ..repetiveType = (json['repetiveType'] as num?)?.toInt()
      ..repeativeDate = (json['repeativeDate'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList()
      ..repetiveValue = (json['repetiveValue'] as num?)?.toInt()
      ..repetiveWeekDay = json['repetiveWeekDay'] as List<dynamic>?
      ..repetive_end_time = (json['repetive_end_time'] as num?)?.toInt()
      ..uid = json['uid'] as String?
      ..noteSmallUrls = (json['noteSmallUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..noteBigUrls = (json['noteBigUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..noteOriginUrls = (json['noteOriginUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..notePoint = (json['notePoint'] as num?)?.toInt()
      ..noteRichContentUrl = json['noteRichContentUrl'] as String?
      ..noteRecordUrls = json['noteRecordUrls'] as List<dynamic>?
      ..attachmentUrls = json['attachmentUrls'] as List<dynamic>?
      ..newRichEditorUrl = json['newRichEditorUrl'] as String?
      ..cryptoVersion = (json['cryptoVersion'] as num?)?.toInt()
      ..hasDecrypted = json['hasDecrypted'] as bool?
      ..end_time = (json['end_time'] as num?)?.toInt()
      ..subMissions = json['subMissions'] as List<dynamic>?;

Map<String, dynamic> _$MissionModelToJson(MissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'missionModelType': instance.missionModelType,
      'folder_id': instance.folder_id,
      'group_id': instance.group_id,
      'time_mode': instance.time_mode,
      'title': instance.title,
      'indexSearchingStart': instance.indexSearchingStart,
      'indexSearchingEnd': instance.indexSearchingEnd,
      'device_id': instance.device_id,
      'tagNames': instance.tagNames,
      'tagIds': instance.tagIds,
      'background_url': instance.background_url,
      'no_tomotoes_finished': instance.no_tomotoes_finished,
      'total_tomotoes': instance.total_tomotoes,
      'color': instance.color,
      'tomato_duration': instance.tomato_duration,
      'order_index': instance.order_index,
      'end_time_before_finished': instance.end_time_before_finished,
      'start_time': instance.start_time,
      'finish_time': instance.finish_time,
      'alert_time': instance.alert_time,
      'time_finished': instance.time_finished,
      'dateStatus': instance.dateStatus,
      'priorityStatus': instance.priorityStatus,
      'daily_start_time': instance.daily_start_time,
      'mission_value': instance.mission_value,
      'do_it_now': instance.do_it_now,
      'daily_end_time': instance.daily_end_time,
      'message': instance.message,
      'isFinished': instance.isFinished,
      'isDelayed': instance.isDelayed,
      'repetiveType': instance.repetiveType,
      'repeativeDate': instance.repeativeDate,
      'repetiveValue': instance.repetiveValue,
      'repetiveWeekDay': instance.repetiveWeekDay,
      'repetive_end_time': instance.repetive_end_time,
      'uid': instance.uid,
      'noteSmallUrls': instance.noteSmallUrls,
      'noteBigUrls': instance.noteBigUrls,
      'noteOriginUrls': instance.noteOriginUrls,
      'notePoint': instance.notePoint,
      'noteRichContentUrl': instance.noteRichContentUrl,
      'noteRecordUrls': instance.noteRecordUrls,
      'attachmentUrls': instance.attachmentUrls,
      'newRichEditorUrl': instance.newRichEditorUrl,
      'cryptoVersion': instance.cryptoVersion,
      'hasDecrypted': instance.hasDecrypted,
      'end_time': instance.end_time,
      'subMissions': instance.subMissions,
    };
