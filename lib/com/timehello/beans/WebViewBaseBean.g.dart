// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WebViewBaseBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebViewBaseBean _$WebViewBaseBeanFromJson(Map<String, dynamic> json) =>
    WebViewBaseBean(
      api: json['api'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool,
      code: json['code'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      sysTime: (json['sysTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WebViewBaseBeanToJson(WebViewBaseBean instance) =>
    <String, dynamic>{
      'api': instance.api,
      'success': instance.success,
      'code': instance.code,
      'sysTime': instance.sysTime,
      'message': instance.message,
      'data': instance.data,
    };
