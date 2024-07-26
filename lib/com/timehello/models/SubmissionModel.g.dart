// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubmissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionModel _$SubmissionModelFromJson(Map<String, dynamic> json) =>
    SubmissionModel(
      isFinished: json['isFinished'] as bool,
      id: (json['id'] as num).toInt(),
      shouldFocus: json['shouldFocus'] as bool,
      title: json['title'] as String,
      notificationTime: (json['notificationTime'] as num).toInt(),
      numToamatoesFocused: (json['numToamatoesFocused'] as num).toInt(),
      numToamatoTotal: (json['numToamatoTotal'] as num).toInt(),
      create_time: (json['create_time'] as num).toInt(),
      update_time: (json['update_time'] as num).toInt(),
    );

Map<String, dynamic> _$SubmissionModelToJson(SubmissionModel instance) =>
    <String, dynamic>{
      'isFinished': instance.isFinished,
      'id': instance.id,
      'shouldFocus': instance.shouldFocus,
      'title': instance.title,
      'notificationTime': instance.notificationTime,
      'numToamatoesFocused': instance.numToamatoesFocused,
      'numToamatoTotal': instance.numToamatoTotal,
      'create_time': instance.create_time,
      'update_time': instance.update_time,
    };
