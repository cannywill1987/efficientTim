// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VocabularyUnitList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyUnitList _$VocabularyUnitListFromJson(Map<String, dynamic> json) =>
    VocabularyUnitList()
      ..list = (json['list'] as List<dynamic>?)
          ?.map((e) => VocabularyUnitBean.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$VocabularyUnitListToJson(VocabularyUnitList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
