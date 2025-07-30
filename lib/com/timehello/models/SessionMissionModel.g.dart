// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SessionMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionMissionModel _$SessionMissionModelFromJson(Map<String, dynamic> json) =>
    SessionMissionModel(
      listSessionMissionModel: (json['listSessionMissionModel']
              as List<dynamic>?)
          ?.map((e) => SessionMissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      title: json['title'] as String?,
      datas: (json['datas'] as List<dynamic>?)
          ?.map((e) => MissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      folder_id: json['folder_id'] as String?,
    );

Map<String, dynamic> _$SessionMissionModelToJson(
        SessionMissionModel instance) =>
    <String, dynamic>{
      'folder_id': instance.folder_id,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'datas': instance.datas,
      'listSessionMissionModel': instance.listSessionMissionModel,
    };
