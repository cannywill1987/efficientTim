import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'TextVoiceBean.dart';
import 'WordBean.dart';

part 'TextVoiceListBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class TextVoiceListBean {
  List<TextVoiceBean>? list;

  TextVoiceListBean();

  factory TextVoiceListBean.fromJson(Map<String, dynamic> json) => _$TextVoiceListBeanFromJson(json);
  Map<String, dynamic> toJson() => _$TextVoiceListBeanToJson(this);
}
