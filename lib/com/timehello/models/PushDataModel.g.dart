// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PushDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushDataModel _$PushDataModelFromJson(Map<String, dynamic> json) =>
    PushDataModel(
      title: json['title'] as String,
      content: json['content'] as String,
      summaryText: json['summaryText'] as String?,
      whenMilliseconds: json['whenMilliseconds'] as int,
      id: json['id'] as String,
    );

Map<String, dynamic> _$PushDataModelToJson(PushDataModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'summaryText': instance.summaryText,
      'whenMilliseconds': instance.whenMilliseconds,
      'id': instance.id,
    };
