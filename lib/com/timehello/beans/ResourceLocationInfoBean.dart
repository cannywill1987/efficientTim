import 'package:json_annotation/json_annotation.dart';

import 'ResourceDeliveryInfoBean.dart';

part 'ResourceLocationInfoBean.g.dart';
/**
 * ResourceLocationModel
 */
@JsonSerializable(nullable: true)
class ResourceLocationInfoBean {
  @JsonKey(name: 'location_code')
  String? locationCode;
  int? id;
  @JsonKey(name: 'location_title')
  String? locationTitle;
  @JsonKey(name: 'location_link_txt')
  String? locationLinkTxt;
  @JsonKey(name: 'location_link_url')
  String? locationLinkUrl;
  @JsonKey(name: 'order_index')
  int? orderIndex;
  List<ResourceDeliveryInfoBean>? deliveryList;
  Map? extendParams;

  bool isCheck = false;
  ResourceLocationInfoBean(
      { this.locationCode = "",
       this.id,
       this.locationTitle,
       this.locationLinkTxt,
       this.locationLinkUrl,
       this.orderIndex,
         this.extendParams,
      this.deliveryList});

  factory ResourceLocationInfoBean.fromJson(Map<String, dynamic> json) => _$ResourceLocationInfoBeanFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceLocationInfoBeanToJson(this);
}
