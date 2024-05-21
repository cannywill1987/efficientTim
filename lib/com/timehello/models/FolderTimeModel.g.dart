// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FolderTimeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderTimeModel _$FolderTimeModelFromJson(Map<String, dynamic> json) =>
    FolderTimeModel(
      numTomatoesUnfinished: json['numTomatoesUnfinished'] as int?,
      numMissionDelayed: json['numMissionDelayed'] as int?,
      numTomatoesFinished: json['numTomatoesFinished'] as int?,
      finishedTimeString: json['finishedTimeString'] as String? ?? '',
      previewTimeString: json['previewTimeString'] as String? ?? '',
      previewTime: json['previewTime'] as int?,
      numMissionToFinished: json['numMissionToFinished'] as int?,
      finishedTime: json['finishedTime'] as int?,
      numMissionFinished: json['numMissionFinished'] as int?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?;

Map<String, dynamic> _$FolderTimeModelToJson(FolderTimeModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'previewTimeString': instance.previewTimeString,
      'numMissionToFinished': instance.numMissionToFinished,
      'previewTime': instance.previewTime,
      'finishedTime': instance.finishedTime,
      'finishedTimeString': instance.finishedTimeString,
      'numMissionFinished': instance.numMissionFinished,
      'numMissionDelayed': instance.numMissionDelayed,
      'numTomatoesUnfinished': instance.numTomatoesUnfinished,
      'numTomatoesFinished': instance.numTomatoesFinished,
    };
