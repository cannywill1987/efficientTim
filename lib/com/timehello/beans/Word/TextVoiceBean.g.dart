// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TextVoiceBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextVoiceBean _$TextVoiceBeanFromJson(Map<String, dynamic> json) =>
    TextVoiceBean()
      ..id = (json['id'] as num?)?.toInt()
      ..code = json['code'] as String?
      ..text = json['text'] as String?
      ..textVoiceUrl = json['text_voice_url'] as String?
      ..textChn = json['text_chn'] as String?
      ..textChnVoiceUrl = json['text_chn_voice_url'] as String?
      ..textEn = json['text_en'] as String?
      ..textEnVoiceUrl = json['text_en_voice_url'] as String?;

Map<String, dynamic> _$TextVoiceBeanToJson(TextVoiceBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'text': instance.text,
      'text_voice_url': instance.textVoiceUrl,
      'text_chn': instance.textChn,
      'text_chn_voice_url': instance.textChnVoiceUrl,
      'text_en': instance.textEn,
      'text_en_voice_url': instance.textEnVoiceUrl,
    };
