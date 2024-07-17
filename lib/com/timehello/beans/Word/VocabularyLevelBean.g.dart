// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VocabularyLevelBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyLevelBean _$VocabularyLevelBeanFromJson(Map<String, dynamic> json) =>
    VocabularyLevelBean()
      ..id = (json['id'] as num?)?.toInt()
      ..numWords = (json['numWords'] as num?)?.toInt()
      ..level = json['level'] as String?
      ..levelName = json['levelName'] as String?
      ..url = json['url'] as String?;

Map<String, dynamic> _$VocabularyLevelBeanToJson(
        VocabularyLevelBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numWords': instance.numWords,
      'level': instance.level,
      'levelName': instance.levelName,
      'url': instance.url,
    };
