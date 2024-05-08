// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) => UserBean(
      level: json['level'] as int?,
      authorIntro: json['authorIntro'] as String?,
      totalFocusTimeRanking: json['totalFocusTimeRanking'] as int? ?? -1,
      totalFocusTime: json['totalFocusTime'] as int? ?? 0,
      appMoney: json['appMoney'] as int? ?? 0,
      localMoney: json['localMoney'] as int? ?? 1,
      username: json['username'] as String? ?? '',
      token: json['token'] as String?,
      mobilePhoneNumber: json['mobilePhoneNumber'] as String?,
      email: json['email'] as String?,
      uid: json['uid'] as String?,
      avatar: json['avatar'] as String?,
    )
      ..gptToken = json['gptToken'] as int?
      ..valuePerHour = json['valuePerHour'] as int?;

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'token': instance.token,
      'gptToken': instance.gptToken,
      'authorIntro': instance.authorIntro,
      'mobilePhoneNumber': instance.mobilePhoneNumber,
      'email': instance.email,
      'uid': instance.uid,
      'avatar': instance.avatar,
      'username': instance.username,
      'level': instance.level,
      'valuePerHour': instance.valuePerHour,
      'totalFocusTime': instance.totalFocusTime,
      'totalFocusTimeRanking': instance.totalFocusTimeRanking,
      'localMoney': instance.localMoney,
      'appMoney': instance.appMoney,
    };
