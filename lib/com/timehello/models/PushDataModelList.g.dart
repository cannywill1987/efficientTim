// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PushDataModelList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushDataModelList _$PushDataModelListFromJson(Map<String, dynamic> json) =>
    PushDataModelList()
      ..list = (json['list'] as List<dynamic>)
          .map((e) => PushDataModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PushDataModelListToJson(PushDataModelList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
