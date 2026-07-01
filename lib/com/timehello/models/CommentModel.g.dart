// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..appScene = json['appScene'] as String? ?? 'efficientTime'
  ..title = json['title'] as String?
  ..content = json['content'] as String?
  ..avatar = json['avatar'] as String?
  ..uid = json['uid'] as String?
  ..device_id = json['device_id'] as String?
  ..username = json['username'] as String?
  ..countryCode = json['countryCode'] as String?
  ..rating = (json['rating'] as num?)?.toInt()
  ..contact = json['contact'] as String?
  ..platform = json['platform'] as String?
  ..market = json['market'] as String?
  ..storeReviewPrompted = json['storeReviewPrompted'] as bool?
  ..storeReviewPromptedAt = (json['storeReviewPromptedAt'] as num?)?.toInt()
  ..officialReply = json['officialReply'] as String?
  ..officialReplyAt = (json['officialReplyAt'] as num?)?.toInt()
  ..handledAt = (json['handledAt'] as num?)?.toInt()
  ..update_time = (json['update_time'] as num?)?.toInt()
  ..create_time = (json['create_time'] as num?)?.toInt()
  ..status = (json['status'] as num?)?.toInt();

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'appScene': instance.appScene,
      'title': instance.title,
      'content': instance.content,
      'avatar': instance.avatar,
      'uid': instance.uid,
      'device_id': instance.device_id,
      'username': instance.username,
      'countryCode': instance.countryCode,
      'rating': instance.rating,
      'contact': instance.contact,
      'platform': instance.platform,
      'market': instance.market,
      'storeReviewPrompted': instance.storeReviewPrompted,
      'storeReviewPromptedAt': instance.storeReviewPromptedAt,
      'officialReply': instance.officialReply,
      'officialReplyAt': instance.officialReplyAt,
      'handledAt': instance.handledAt,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
      'status': instance.status,
    };
