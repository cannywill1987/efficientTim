// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResourceLocationInfoBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceLocationInfoBean _$ResourceLocationInfoBeanFromJson(
        Map<String, dynamic> json) =>
    ResourceLocationInfoBean(
      locationCode: json['location_code'] as String? ?? "",
      id: (json['id'] as num?)?.toInt(),
      locationTitle: json['location_title'] as String?,
      locationLinkTxt: json['location_link_txt'] as String?,
      locationLinkUrl: json['location_link_url'] as String?,
      orderIndex: (json['order_index'] as num?)?.toInt(),
      extendParams: json['extendParams'] as Map<String, dynamic>?,
      deliveryList: (json['deliveryList'] as List<dynamic>?)
          ?.map((e) =>
              ResourceDeliveryInfoBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..isCheck = json['isCheck'] as bool;

Map<String, dynamic> _$ResourceLocationInfoBeanToJson(
        ResourceLocationInfoBean instance) =>
    <String, dynamic>{
      'location_code': instance.locationCode,
      'id': instance.id,
      'location_title': instance.locationTitle,
      'location_link_txt': instance.locationLinkTxt,
      'location_link_url': instance.locationLinkUrl,
      'order_index': instance.orderIndex,
      'deliveryList': instance.deliveryList,
      'extendParams': instance.extendParams,
      'isCheck': instance.isCheck,
    };
