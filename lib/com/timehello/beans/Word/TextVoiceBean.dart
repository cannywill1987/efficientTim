import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'WordBean.dart';

part 'TextVoiceBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class TextVoiceBean {
  int? id;
  String? code;
  String? text;
  @JsonKey(name: 'text_voice_url')
  String? textVoiceUrl;
  @JsonKey(name: 'text_chn')
  String? textChn;
  @JsonKey(name: 'text_chn_voice_url')
  String? textChnVoiceUrl;
  @JsonKey(name: 'text_en')
  String? textEn;
  @JsonKey(name: 'text_en_voice_url')
  String? textEnVoiceUrl;


  TextVoiceBean();

  factory TextVoiceBean.fromJson(Map<String, dynamic> json) => _$TextVoiceBeanFromJson(json);
  Map<String, dynamic> toJson() => _$TextVoiceBeanToJson(this);
}
