import 'package:json_annotation/json_annotation.dart';

part 'ResourceDeliveryInfoBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: false)
class ResourceDeliveryInfoBean {
  int? id;
  @JsonKey(name: 'delivery_name')
  String? deliveryName;
  @JsonKey(name: 'location_info_id')
  int? locationInfoId;
  @JsonKey(name: 'resource_title')
  String? resourceTitle;
  @JsonKey(name: 'resource_content')
  String? resourceContent;
  @JsonKey(name: 'resource_picture_url')
  String? resourcePictureUrl;
  @JsonKey(name: 'resource_icon_url')
  String? resourceIconUrl;
  @JsonKey(name: 'extend_params')
  String? extendParamsString;
  Map<dynamic, dynamic>? extendParamsMap;
  @JsonKey(name: 'resource_redirect_url')
  String? resourceRedirectUrl;
  @JsonKey(name: 'resource_redirect_url_type')
  int? resourceRedirectUrlType;
  bool? isChecked;
  ResourceDeliveryInfoBean(
      { this.resourceContent,
       this.resourceTitle,
       this.deliveryName,
       this.locationInfoId,
       this.resourcePictureUrl,
       this.resourceIconUrl,
         this.extendParamsMap,
      this.isChecked});

  factory ResourceDeliveryInfoBean.fromJson(Map<String, dynamic> json) => _$ResourceDeliveryInfoBeanFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceDeliveryInfoBeanToJson(this);
}
