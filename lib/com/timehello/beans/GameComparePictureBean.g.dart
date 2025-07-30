// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameComparePictureBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameComparePictureBeanList _$GameComparePictureBeanListFromJson(
        Map<String, dynamic> json) =>
    GameComparePictureBeanList(
      list: (json['list'] as List<dynamic>)
          .map(
              (e) => GameComparePictureBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameComparePictureBeanListToJson(
        GameComparePictureBeanList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

GameComparePictureBean _$GameComparePictureBeanFromJson(
        Map<String, dynamic> json) =>
    GameComparePictureBean(
      json['_id'] as String,
      (json['answerJson'] as List<dynamic>?)
          ?.map((e) => GameAnswerJsonBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pic1_ref'] as String,
      json['pic2'] as String,
    );

Map<String, dynamic> _$GameComparePictureBeanToJson(
        GameComparePictureBean instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'answerJson': instance.answerJson,
      'pic1_ref': instance.pic1_ref,
      'pic2': instance.pic2,
    };
