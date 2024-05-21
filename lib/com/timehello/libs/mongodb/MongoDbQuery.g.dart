// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbQuery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbQuery<T> _$MongoDbQueryFromJson<T>(Map<String, dynamic> json) =>
    MongoDbQuery<T>()
      ..include = json['include'] as String?
      ..limit = json['limit'] as int?
      ..skip = json['skip'] as int?
      ..order = json['order'] as String?
      ..orderValue = json['orderValue'] as int?
      ..count = json['count'] as int?
      ..c = json['c'] as String?
      ..where = json['where'] as Map<String, dynamic>?
      ..having = json['having'] as Map<String, dynamic>?
      ..groupby = json['groupby'] as String?
      ..sum = json['sum'] as String?
      ..average = json['average'] as String?
      ..max = json['max'] as String?
      ..min = json['min'] as String?
      ..groupcount = json['groupcount'] as bool?;

Map<String, dynamic> _$MongoDbQueryToJson<T>(MongoDbQuery<T> instance) =>
    <String, dynamic>{
      'include': instance.include,
      'limit': instance.limit,
      'skip': instance.skip,
      'order': instance.order,
      'orderValue': instance.orderValue,
      'count': instance.count,
      'c': instance.c,
      'where': instance.where,
      'having': instance.having,
      'groupby': instance.groupby,
      'sum': instance.sum,
      'average': instance.average,
      'max': instance.max,
      'min': instance.min,
      'groupcount': instance.groupcount,
    };
