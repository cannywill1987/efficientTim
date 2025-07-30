// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WordList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordList _$WordListFromJson(Map<String, dynamic> json) => WordList()
  ..list = (json['list'] as List<dynamic>?)
      ?.map((e) => WordBean.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$WordListToJson(WordList instance) => <String, dynamic>{
      'list': instance.list,
    };
