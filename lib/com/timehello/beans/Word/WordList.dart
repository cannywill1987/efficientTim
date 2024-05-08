import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'WordBean.dart';


part 'WordList.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class WordList {
  List<WordBean>? list;
  WordList();

  factory WordList.fromJson(Map<String, dynamic> json) => _$WordListFromJson(json);
  Map<String, dynamic> toJson() => _$WordListToJson(this);
}
