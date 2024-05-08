import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'WordBean.dart';

part 'VocabularyUnitBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class VocabularyUnitBean {
  int? id;
  int? level_id;
  String? unit;
  int? numWords;
  String? level;
  String? levelName;
  String? unitName;
  String? url;
  VocabularyUnitBean();

  factory VocabularyUnitBean.fromJson(Map<String, dynamic> json) => _$VocabularyUnitBeanFromJson(json);
  Map<String, dynamic> toJson() => _$VocabularyUnitBeanToJson(this);
}
