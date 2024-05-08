import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'WordBean.dart';

part 'WordBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class WordBean {
  int? id;
  String? word;
  String? meaning;
  String? am;
  String? em;
  String? am_url;
  String? em_url;
  String? zh_url;
  String? unit;
  String? level;
  String? translateBasic;
  String? translateBaidu;
  bool? isCheck;
  WordBean({isCheck:false});

  factory WordBean.fromJson(Map<String, dynamic> json) => _$WordBeanFromJson(json);
  Map<String, dynamic> toJson() => _$WordBeanToJson(this);
}
