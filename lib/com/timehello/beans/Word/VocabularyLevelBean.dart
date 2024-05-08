import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'WordBean.dart';

part 'VocabularyLevelBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class VocabularyLevelBean {
  int? id;
  int? numWords;
  String? level;
  String? levelName;
  String? url;
  VocabularyLevelBean();

  factory VocabularyLevelBean.fromJson(Map<String, dynamic> json) => _$VocabularyLevelBeanFromJson(json);
  Map<String, dynamic> toJson() => _$VocabularyLevelBeanToJson(this);
}
