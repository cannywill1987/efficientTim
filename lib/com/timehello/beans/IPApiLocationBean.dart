import 'package:json_annotation/json_annotation.dart';

part 'IPApiLocationBean.g.dart';

@JsonSerializable(nullable: false)
class IPApiLocationBean {
  @JsonKey(name: '_id')
  String? id;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  double? lat;

  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? as;
  String? query;
  IPApiLocationBean();

  factory IPApiLocationBean.fromJson(Map<String, dynamic> json) => _$IPApiLocationBeanFromJson(json);
  Map<String, dynamic> toJson() => _$IPApiLocationBeanToJson(this);
}