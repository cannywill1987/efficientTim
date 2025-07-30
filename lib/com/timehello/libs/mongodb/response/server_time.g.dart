// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerTime _$ServerTimeFromJson(Map<String, dynamic> json) => ServerTime()
  ..timestamp = (json['timestamp'] as num?)?.toInt()
  ..datetime = json['datetime'] as String?;

Map<String, dynamic> _$ServerTimeToJson(ServerTime instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'datetime': instance.datetime,
    };
