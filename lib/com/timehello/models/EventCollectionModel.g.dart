// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventCollectionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventCollectionModel _$EventCollectionModelFromJson(
        Map<String, dynamic> json) =>
    EventCollectionModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..sceneType = json['sceneType'] as String
      ..eventType = json['eventType'] as String?
      ..resultType = json['resultType'] as String?
      ..testType = json['testType'] as String?
      ..message = json['message'] as String?
      ..value1 = (json['value1'] as num?)?.toDouble()
      ..deviceId = json['deviceId'] as String?
      ..create_time = json['create_time'] as int?
      ..update_time = json['update_time'] as int?
      ..create_time_utc = json['create_time_utc'] as String?
      ..timeZoneOffset = json['timeZoneOffset'] as String?
      ..country = json['country'] as String?
      ..timezoneName = json['timezoneName'] as String?
      ..uid = json['uid'] as String?
      ..sysCode = json['sysCode'] as String?
      ..appVersion = json['appVersion'] as String?
      ..systemVersion = json['systemVersion'] as String?
      ..deviceKey = json['deviceKey'] as String?
      ..appChannel = json['appChannel'] as String?
      ..productType = json['productType'] as String?
      ..productName = json['productName'] as String?
      ..appType = json['appType'] as String?
      ..lang = json['lang'] as String?
      ..networkType = json['networkType'] as String?
      ..brand = json['brand'] as String?
      ..region = json['region'] as String?
      ..regionName = json['regionName'] as String?
      ..city = json['city'] as String?
      ..lat = (json['lat'] as num?)?.toDouble()
      ..lon = (json['lon'] as num?)?.toDouble()
      ..countryCode = json['countryCode'] as String?
      ..ip = json['ip'] as String?;

Map<String, dynamic> _$EventCollectionModelToJson(
        EventCollectionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'sceneType': instance.sceneType,
      'eventType': instance.eventType,
      'resultType': instance.resultType,
      'testType': instance.testType,
      'message': instance.message,
      'value1': instance.value1,
      'deviceId': instance.deviceId,
      'create_time': instance.create_time,
      'update_time': instance.update_time,
      'create_time_utc': instance.create_time_utc,
      'timeZoneOffset': instance.timeZoneOffset,
      'country': instance.country,
      'timezoneName': instance.timezoneName,
      'uid': instance.uid,
      'sysCode': instance.sysCode,
      'appVersion': instance.appVersion,
      'systemVersion': instance.systemVersion,
      'deviceKey': instance.deviceKey,
      'appChannel': instance.appChannel,
      'productType': instance.productType,
      'productName': instance.productName,
      'appType': instance.appType,
      'lang': instance.lang,
      'networkType': instance.networkType,
      'brand': instance.brand,
      'region': instance.region,
      'regionName': instance.regionName,
      'city': instance.city,
      'lat': instance.lat,
      'lon': instance.lon,
      'countryCode': instance.countryCode,
      'ip': instance.ip,
    };
