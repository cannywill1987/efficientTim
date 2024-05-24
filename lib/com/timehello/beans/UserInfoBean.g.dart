// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfoBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoBean _$UserInfoBeanFromJson(Map<String, dynamic> json) => UserInfoBean(
      uid: json['uid'] as String?,
      avatar: json['avatar'] as String?,
      username: json['username'] as String?,
      numTomatoesFcoused: json['numTomatoesFcoused'] as int? ?? 0,
      numTasksDone: json['numTasksDone'] as int? ?? 0,
      totalDurationFocus: json['totalDurationFocus'] as int? ?? 0,
      onlineStatus: json['onlineStatus'] as int? ?? 0,
    );

Map<String, dynamic> _$UserInfoBeanToJson(UserInfoBean instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'avatar': instance.avatar,
      'username': instance.username,
      'numTomatoesFcoused': instance.numTomatoesFcoused,
      'numTasksDone': instance.numTasksDone,
      'totalDurationFocus': instance.totalDurationFocus,
      'onlineStatus': instance.onlineStatus,
    };
