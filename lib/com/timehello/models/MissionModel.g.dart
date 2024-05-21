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
      ..folder_id = json['folder_id'] as String?
      ..group_id = json['group_id'] as String?
      ..time_mode = json['time_mode'] as int?
      ..title = json['title'] as String?
      ..indexSearchingStart = json['indexSearchingStart'] as int?
      ..indexSearchingEnd = json['indexSearchingEnd'] as int?
      ..device_id = json['device_id'] as String?
      ..tagNames = json['tagNames'] as String?
      ..tagIds = json['tagIds'] as String?
      ..background_url = json['background_url'] as String?
      ..no_tomotoes_finished = json['no_tomotoes_finished'] as int?
      ..total_tomotoes = json['total_tomotoes'] as int?
      ..color = json['color'] as int?
      ..tomato_duration = json['tomato_duration'] as int?
      ..order_index = json['order_index'] as int?
      ..end_time_before_finished = json['end_time_before_finished'] as int?
      ..start_time = json['start_time'] as int?
      ..end_time = json['end_time'] as int?
      ..finish_time = json['finish_time'] as int?
      ..alert_time = json['alert_time'] as int?
      ..time_finished = json['time_finished'] as int?
      ..dateStatus = json['dateStatus'] as int?
      ..priorityStatus = json['priorityStatus'] as int?
      ..daily_start_time = json['daily_start_time'] as int?
      ..mission_value = json['mission_value'] as int?
      ..do_it_now = json['do_it_now'] as List<dynamic>?
      ..daily_end_time = json['daily_end_time'] as int?
      ..isFinished = json['isFinished'] as bool?
      ..isDelayed = json['isDelayed'] as bool?
      ..repetiveType = json['repetiveType'] as int?
      ..repeativeDate = (json['repeativeDate'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList()
      ..repetiveValue = json['repetiveValue'] as int?
      ..repetiveWeekDay = json['repetiveWeekDay'] as List<dynamic>?
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
      ..notePoint = json['notePoint'] as int?
      ..noteRichContentUrl = json['noteRichContentUrl'] as String?
      ..noteRecordUrls = json['noteRecordUrls'] as List<dynamic>?
      ..cryptoVersion = json['cryptoVersion'] as int?
      ..hasDecrypted = json['hasDecrypted'] as bool?
      ..subMissions = json['subMissions'] as List<dynamic>?;

Map<String, dynamic> _$MissionModelToJson(MissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
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
      'end_time': instance.end_time,
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
      'uid': instance.uid,
      'noteSmallUrls': instance.noteSmallUrls,
      'noteBigUrls': instance.noteBigUrls,
      'noteOriginUrls': instance.noteOriginUrls,
      'notePoint': instance.notePoint,
      'noteRichContentUrl': instance.noteRichContentUrl,
      'noteRecordUrls': instance.noteRecordUrls,
      'cryptoVersion': instance.cryptoVersion,
      'hasDecrypted': instance.hasDecrypted,
      'subMissions': instance.subMissions,
    };
