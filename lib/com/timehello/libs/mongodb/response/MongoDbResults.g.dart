// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbResults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbResults _$MongoDbResultsFromJson(Map<String, dynamic> json) =>
    MongoDbResults()
      ..results = json['results'] as List<dynamic>?
      ..count = (json['count'] as num?)?.toInt();

Map<String, dynamic> _$MongoDbResultsToJson(MongoDbResults instance) =>
    <String, dynamic>{
      'results': instance.results,
      'count': instance.count,
    };
