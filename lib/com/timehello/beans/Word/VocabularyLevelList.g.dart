// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VocabularyLevelList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyLevelList _$VocabularyLevelListFromJson(Map<String, dynamic> json) =>
    VocabularyLevelList()
      ..list = (json['list'] as List<dynamic>?)
          ?.map((e) => VocabularyLevelBean.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$VocabularyLevelListToJson(
        VocabularyLevelList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
