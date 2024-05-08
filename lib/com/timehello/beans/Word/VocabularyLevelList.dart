import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'VocabularyLevelBean.dart';
import 'WordBean.dart';


part 'VocabularyLevelList.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class VocabularyLevelList {
  List<VocabularyLevelBean>? list;
  VocabularyLevelList();

  factory VocabularyLevelList.fromJson(Map<String, dynamic> json) => _$VocabularyLevelListFromJson(json);
  Map<String, dynamic> toJson() => _$VocabularyLevelListToJson(this);
}
