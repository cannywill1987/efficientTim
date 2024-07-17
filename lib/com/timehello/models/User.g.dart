// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?
  ..objectId = json['_id'] as String?
  ..username = json['username'] as String?
  ..password = json['password'] as String?
  ..email = json['email'] as String?
  ..emailVerified = json['emailVerified'] as bool?
  ..mobilePhoneNumber = json['mobilePhoneNumber'] as String?
  ..mobilePhoneNumberVerified = json['mobilePhoneNumberVerified'] as bool?
  ..sessionToken = json['sessionToken'] as String?
  ..age = (json['age'] as num?)?.toInt()
  ..gender = (json['gender'] as num?)?.toInt()
  ..nickname = json['nickname'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
      'age': instance.age,
      'gender': instance.gender,
      'nickname': instance.nickname,
    };
