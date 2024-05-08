import 'package:json_annotation/json_annotation.dart';

part 'WebViewBaseBean.g.dart';

@JsonSerializable(nullable: false)
class WebViewBaseBean {
  String? api;
  final bool success;
   String? code;
  int? sysTime;
  String? message;
  Map? data;
  WebViewBaseBean({ this.api, this.message, required this.success,  this.code,  this.data, this.sysTime});
  factory WebViewBaseBean.fromJson(Map<String, dynamic> json) => _$WebViewBaseBeanFromJson(json);
  Map<String, dynamic> toJson() => _$WebViewBaseBeanToJson(this);
}