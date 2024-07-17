// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResourceDeliveryInfoBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceDeliveryInfoBean _$ResourceDeliveryInfoBeanFromJson(
        Map<String, dynamic> json) =>
    ResourceDeliveryInfoBean(
      resourceContent: json['resource_content'] as String?,
      resourceTitle: json['resource_title'] as String?,
      deliveryName: json['delivery_name'] as String?,
      locationInfoId: (json['location_info_id'] as num?)?.toInt(),
      resourcePictureUrl: json['resource_picture_url'] as String?,
      resourceIconUrl: json['resource_icon_url'] as String?,
      extendParamsMap: json['extendParamsMap'] as Map<String, dynamic>?,
      isChecked: json['isChecked'] as bool?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..extendParamsString = json['extend_params'] as String?
      ..resourceRedirectUrl = json['resource_redirect_url'] as String?
      ..resourceRedirectUrlType =
          (json['resource_redirect_url_type'] as num?)?.toInt();

Map<String, dynamic> _$ResourceDeliveryInfoBeanToJson(
        ResourceDeliveryInfoBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delivery_name': instance.deliveryName,
      'location_info_id': instance.locationInfoId,
      'resource_title': instance.resourceTitle,
      'resource_content': instance.resourceContent,
      'resource_picture_url': instance.resourcePictureUrl,
      'resource_icon_url': instance.resourceIconUrl,
      'extend_params': instance.extendParamsString,
      'extendParamsMap': instance.extendParamsMap,
      'resource_redirect_url': instance.resourceRedirectUrl,
      'resource_redirect_url_type': instance.resourceRedirectUrlType,
      'isChecked': instance.isChecked,
    };
