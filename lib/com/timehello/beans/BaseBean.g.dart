// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseBean _$BaseBeanFromJson(Map<String, dynamic> json) => BaseBean(
      message: json['message'] as String?,
      success: json['success'] as bool,
      code: json['code'] as String?,
      data: json['data'],
      sysTime: (json['sysTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BaseBeanToJson(BaseBean instance) => <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'sysTime': instance.sysTime,
      'message': instance.message,
      'data': instance.data,
    };
