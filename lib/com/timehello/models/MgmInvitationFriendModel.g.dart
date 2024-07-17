// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MgmInvitationFriendModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MgmInvitationFriendModel _$MgmInvitationFriendModelFromJson(
        Map<String, dynamic> json) =>
    MgmInvitationFriendModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..uid = json['uid'] as String?
      ..avatar = json['avatar'] as String?
      ..username = json['username'] as String?
      ..mobilePhoneNumber = json['mobilePhoneNumber'] as String?
      ..email = json['email'] as String?
      ..coins = (json['coins'] as num?)?.toDouble()
      ..countryCode = json['countryCode'] as String?
      ..gender = (json['gender'] as num?)?.toInt()
      ..update_time = (json['update_time'] as num?)?.toInt()
      ..create_time = (json['create_time'] as num?)?.toInt();

Map<String, dynamic> _$MgmInvitationFriendModelToJson(
        MgmInvitationFriendModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'uid': instance.uid,
      'avatar': instance.avatar,
      'username': instance.username,
      'mobilePhoneNumber': instance.mobilePhoneNumber,
      'email': instance.email,
      'coins': instance.coins,
      'countryCode': instance.countryCode,
      'gender': instance.gender,
      'update_time': instance.update_time,
      'create_time': instance.create_time,
    };
