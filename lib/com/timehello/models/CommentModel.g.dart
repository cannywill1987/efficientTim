// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..title = json['title'] as String?
  ..content = json['content'] as String?
  ..avatar = json['avatar'] as String?
  ..uid = json['uid'] as String?
  ..device_id = json['device_id'] as String?
  ..username = json['username'] as String?
  ..countryCode = json['countryCode'] as String?
  ..update_time = (json['update_time'] as num?)?.toInt()
  ..create_time = (json['create_time'] as num?)?.toInt()
  ..status = (json['status'] as num?)?.toInt();

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'title': instance.title,
      'content': instance.content,
      'avatar': instance.avatar,
      'uid': instance.uid,
      'device_id': instance.device_id,
      'username': instance.username,
      'countryCode': instance.countryCode,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
      'status': instance.status,
    };
