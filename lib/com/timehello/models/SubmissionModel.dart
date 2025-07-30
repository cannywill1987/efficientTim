import 'package:encrypt/encrypt.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'SubmissionModel.dart';

part 'SubmissionModel.g.dart';

@JsonSerializable(nullable: false)
class SubmissionModel {
  @JsonKey(ignore: true)
  ValueKey? key;
  bool isFinished;
  int id;
  bool shouldFocus = false;
  String title;
  int notificationTime;
  int numToamatoesFocused;
  int numToamatoTotal;
  int create_time;
  int update_time;

  SubmissionModel(
      { this.key,
      required this.isFinished,
      required this.id,
      required this.shouldFocus,
      required this.title,
      // required this.key,
      required this.notificationTime,
      required this.numToamatoesFocused,
      required this.numToamatoTotal,
      required this.create_time,
      required this.update_time});

  factory SubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubmissionModelToJson(this);
}
