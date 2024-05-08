// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
      message: json['message'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..folder_id = json['folder_id'] as String?
      ..title = json['title'] as String?
      ..color = json['color'] as int?
      ..order_index = json['order_index'] as int?
      ..device_id = json['device_id'] as String?
      ..isAdd = json['isAdd'] as bool?
      ..isCheck = json['isCheck'] as bool?
      ..uid = json['uid'] as String?
      ..missionModelObjectIdOrderList =
          (json['missionModelObjectIdOrderList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..missionModelList = (json['missionModelList'] as List<dynamic>?)
          ?.map((e) => MissionModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'folder_id': instance.folder_id,
      'title': instance.title,
      'color': instance.color,
      'order_index': instance.order_index,
      'message': instance.message,
      'device_id': instance.device_id,
      'isAdd': instance.isAdd,
      'isCheck': instance.isCheck,
      'uid': instance.uid,
      'missionModelObjectIdOrderList': instance.missionModelObjectIdOrderList,
      'missionModelList': instance.missionModelList,
    };
