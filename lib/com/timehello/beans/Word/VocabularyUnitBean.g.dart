// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VocabularyUnitBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyUnitBean _$VocabularyUnitBeanFromJson(Map<String, dynamic> json) =>
    VocabularyUnitBean()
      ..id = json['id'] as int?
      ..level_id = json['level_id'] as int?
      ..unit = json['unit'] as String?
      ..numWords = json['numWords'] as int?
      ..level = json['level'] as String?
      ..levelName = json['levelName'] as String?
      ..unitName = json['unitName'] as String?
      ..url = json['url'] as String?;

Map<String, dynamic> _$VocabularyUnitBeanToJson(VocabularyUnitBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level_id': instance.level_id,
      'unit': instance.unit,
      'numWords': instance.numWords,
      'level': instance.level,
      'levelName': instance.levelName,
      'unitName': instance.unitName,
      'url': instance.url,
    };
