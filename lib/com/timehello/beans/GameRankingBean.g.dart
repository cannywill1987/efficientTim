// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameRankingBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameRankingBean _$GameRankingBeanFromJson(Map<String, dynamic> json) =>
    GameRankingBean(
      id: json['_id'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      gameCode: json['gameCode'] as String?,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      gameTitle: json['gameTitle'] as String?,
      gameTitleEn: json['gameTitleEn'] as String?,
      time: (json['time'] as num?)?.toInt(),
      deviceId: json['deviceId'] as String?,
      val1: (json['val1'] as num?)?.toDouble(),
      val2: (json['val2'] as num?)?.toDouble(),
      val3: (json['val3'] as num?)?.toDouble(),
      val4: (json['val4'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GameRankingBeanToJson(GameRankingBean instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'gameCode': instance.gameCode,
      'username': instance.username,
      'avatar': instance.avatar,
      'gameTitle': instance.gameTitle,
      'gameTitleEn': instance.gameTitleEn,
      'time': instance.time,
      'val1': instance.val1,
      'val2': instance.val2,
      'val3': instance.val3,
      'val4': instance.val4,
      'score': instance.score,
      'deviceId': instance.deviceId,
    };
