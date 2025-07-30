// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FolderTimeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderTimeModel _$FolderTimeModelFromJson(Map<String, dynamic> json) =>
    FolderTimeModel(
      objectivePercentString: json['objectivePercentString'] as String?,
      tag: json['tag'] as String?,
      folderObjectId: json['folderObjectId'] as String?,
      folderTitle: json['folderTitle'] as String?,
      numTomatoesUnfinished: (json['numTomatoesUnfinished'] as num?)?.toInt(),
      numMissionDelayed: (json['numMissionDelayed'] as num?)?.toInt(),
      numTomatoesFinished: (json['numTomatoesFinished'] as num?)?.toInt(),
      finishedTimeString: json['finishedTimeString'] as String? ?? '',
      previewTimeString: json['previewTimeString'] as String? ?? '',
      previewTime: (json['previewTime'] as num?)?.toInt(),
      numMissionToFinished: (json['numMissionToFinished'] as num?)?.toInt(),
      finishedTime: (json['finishedTime'] as num?)?.toInt(),
      numMissionFinished: (json['numMissionFinished'] as num?)?.toInt(),
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..listDatas = (json['listDatas'] as List<dynamic>?)
          ?.map((e) => MissionModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..numMissionCalendarToFinished =
          (json['numMissionCalendarToFinished'] as num?)?.toInt()
      ..numMissionCalendarTotalFinished =
          (json['numMissionCalendarTotalFinished'] as num?)?.toInt();

Map<String, dynamic> _$FolderTimeModelToJson(FolderTimeModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'tag': instance.tag,
      'folderTitle': instance.folderTitle,
      'folderObjectId': instance.folderObjectId,
      'listDatas': instance.listDatas,
      'previewTimeString': instance.previewTimeString,
      'objectivePercentString': instance.objectivePercentString,
      'numMissionToFinished': instance.numMissionToFinished,
      'previewTime': instance.previewTime,
      'finishedTime': instance.finishedTime,
      'finishedTimeString': instance.finishedTimeString,
      'numMissionFinished': instance.numMissionFinished,
      'numMissionCalendarToFinished': instance.numMissionCalendarToFinished,
      'numMissionCalendarTotalFinished':
          instance.numMissionCalendarTotalFinished,
      'numMissionDelayed': instance.numMissionDelayed,
      'numTomatoesUnfinished': instance.numTomatoesUnfinished,
      'numTomatoesFinished': instance.numTomatoesFinished,
    };
