// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WordBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBean _$WordBeanFromJson(Map<String, dynamic> json) => WordBean(
      isCheck: json['isCheck'] ?? false,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..word = json['word'] as String?
      ..meaning = json['meaning'] as String?
      ..am = json['am'] as String?
      ..em = json['em'] as String?
      ..am_url = json['am_url'] as String?
      ..em_url = json['em_url'] as String?
      ..zh_url = json['zh_url'] as String?
      ..unit = json['unit'] as String?
      ..level = json['level'] as String?
      ..translateBasic = json['translateBasic'] as String?
      ..translateBaidu = json['translateBaidu'] as String?;

Map<String, dynamic> _$WordBeanToJson(WordBean instance) => <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'meaning': instance.meaning,
      'am': instance.am,
      'em': instance.em,
      'am_url': instance.am_url,
      'em_url': instance.em_url,
      'zh_url': instance.zh_url,
      'unit': instance.unit,
      'level': instance.level,
      'translateBasic': instance.translateBasic,
      'translateBaidu': instance.translateBaidu,
      'isCheck': instance.isCheck,
    };
