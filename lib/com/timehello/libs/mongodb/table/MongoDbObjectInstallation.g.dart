// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbObjectInstallation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbObjectInstallation _$MongoDbObjectInstallationFromJson(
        Map<String, dynamic> json) =>
    MongoDbObjectInstallation()
      ..deviceType = json['deviceType'] as String?
      ..installationId = json['installationId'] as String?
      ..timeZone = json['timeZone'] as String?
      ..deviceToken = json['deviceToken'] as String?;

Map<String, dynamic> _$MongoDbObjectInstallationToJson(
        MongoDbObjectInstallation instance) =>
    <String, dynamic>{
      'deviceType': instance.deviceType,
      'installationId': instance.installationId,
      'timeZone': instance.timeZone,
      'deviceToken': instance.deviceToken,
    };
