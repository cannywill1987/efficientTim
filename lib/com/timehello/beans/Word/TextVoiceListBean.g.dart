// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TextVoiceListBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextVoiceListBean _$TextVoiceListBeanFromJson(Map<String, dynamic> json) =>
    TextVoiceListBean()
      ..list = (json['list'] as List<dynamic>?)
          ?.map((e) => TextVoiceBean.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TextVoiceListBeanToJson(TextVoiceListBean instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
