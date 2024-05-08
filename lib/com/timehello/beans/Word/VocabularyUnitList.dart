import 'package:json_annotation/json_annotation.dart';

import 'VocabularyUnitBean.dart';


part 'VocabularyUnitList.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class VocabularyUnitList {
  List<VocabularyUnitBean>? list;
  VocabularyUnitList();

  factory VocabularyUnitList.fromJson(Map<String, dynamic> json) => _$VocabularyUnitListFromJson(json);
  Map<String, dynamic> toJson() => _$VocabularyUnitListToJson(this);
}
