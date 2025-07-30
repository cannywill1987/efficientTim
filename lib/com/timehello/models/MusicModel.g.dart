// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MusicModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) => MusicModel(
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      isChecked: json['isChecked'] as bool?,
      localPath: json['localPath'] as String? ?? '',
    );

Map<String, dynamic> _$MusicModelToJson(MusicModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'isChecked': instance.isChecked,
      'localPath': instance.localPath,
    };
