// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IPApiLocationBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPApiLocationBean _$IPApiLocationBeanFromJson(Map<String, dynamic> json) =>
    IPApiLocationBean()
      ..id = json['_id'] as String?
      ..country = json['country'] as String?
      ..countryCode = json['countryCode'] as String?
      ..region = json['region'] as String?
      ..regionName = json['regionName'] as String?
      ..city = json['city'] as String?
      ..lat = (json['lat'] as num?)?.toDouble()
      ..lon = (json['lon'] as num?)?.toDouble()
      ..timezone = json['timezone'] as String?
      ..isp = json['isp'] as String?
      ..org = json['org'] as String?
      ..as = json['as'] as String?
      ..query = json['query'] as String?;

Map<String, dynamic> _$IPApiLocationBeanToJson(IPApiLocationBean instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'region': instance.region,
      'regionName': instance.regionName,
      'city': instance.city,
      'lat': instance.lat,
      'lon': instance.lon,
      'timezone': instance.timezone,
      'isp': instance.isp,
      'org': instance.org,
      'as': instance.as,
      'query': instance.query,
    };
