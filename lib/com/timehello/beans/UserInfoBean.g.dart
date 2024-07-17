// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfoBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoBean _$UserInfoBeanFromJson(Map<String, dynamic> json) => UserInfoBean(
      uid: json['uid'] as String?,
      avatar: json['avatar'] as String?,
      username: json['username'] as String?,
      numTomatoesFcoused: (json['numTomatoesFcoused'] as num?)?.toInt() ?? 0,
      numTasksDone: (json['numTasksDone'] as num?)?.toInt() ?? 0,
      totalDurationFocus: (json['totalDurationFocus'] as num?)?.toInt() ?? 0,
      onlineStatus: (json['onlineStatus'] as num?)?.toInt() ?? 0,
    )..role = (json['role'] as num?)?.toInt();

Map<String, dynamic> _$UserInfoBeanToJson(UserInfoBean instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'avatar': instance.avatar,
      'username': instance.username,
      'numTomatoesFcoused': instance.numTomatoesFcoused,
      'numTasksDone': instance.numTasksDone,
      'totalDurationFocus': instance.totalDurationFocus,
      'onlineStatus': instance.onlineStatus,
      'role': instance.role,
    };
