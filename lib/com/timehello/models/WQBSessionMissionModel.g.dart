// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WQBSessionMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WQBSessionMissionModel _$WQBSessionMissionModelFromJson(
        Map<String, dynamic> json) =>
    WQBSessionMissionModel(
      title: json['title'] as String?,
      datas: (json['datas'] as List<dynamic>?)
          ?.map((e) => WQBMissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WQBSessionMissionModelToJson(
        WQBSessionMissionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'datas': instance.datas,
    };
