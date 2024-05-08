// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MongoDbUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MongoDbUser _$MongoDbUserFromJson(Map<String, dynamic> json) => MongoDbUser()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..username = json['username'] as String?
  ..password = json['password'] as String?
  ..email = json['email'] as String?
  ..emailVerified = json['emailVerified'] as bool?
  ..mobilePhoneNumber = json['mobilePhoneNumber'] as String?
  ..mobilePhoneNumberVerified = json['mobilePhoneNumberVerified'] as bool?
  ..sessionToken = json['sessionToken'] as String?;

Map<String, dynamic> _$MongoDbUserToJson(MongoDbUser instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'mobilePhoneNumber': instance.mobilePhoneNumber,
      'mobilePhoneNumberVerified': instance.mobilePhoneNumberVerified,
      'sessionToken': instance.sessionToken,
    };
