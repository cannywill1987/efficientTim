import 'package:json_annotation/json_annotation.dart';

part 'BaseBean.g.dart';

@JsonSerializable(nullable: false)
class BaseBean {
  final bool success;
   String? code;
  int? sysTime;
  String? message;
  dynamic? data;
  BaseBean({ this.message, required this.success,  this.code,  this.data, this.sysTime});
  factory BaseBean.fromJson(Map<String, dynamic> json) => _$BaseBeanFromJson(json);
  Map<String, dynamic> toJson() => _$BaseBeanToJson(this);
}