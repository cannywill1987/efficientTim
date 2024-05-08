// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameAnswerJsonBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameAnswerJsonBean _$GameAnswerJsonBeanFromJson(Map<String, dynamic> json) =>
    GameAnswerJsonBean(
      widthGuide: (json['widthGuide'] as num).toDouble(),
      heightGuide: (json['heightGuide'] as num).toDouble(),
      mode: json['mode'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      offsetX: (json['offsetX'] as num).toDouble(),
      offsetY: (json['offsetY'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
    )
      ..widthWidgetHere = (json['widthWidgetHere'] as num?)?.toDouble()
      ..heightWidgetHere = (json['heightWidgetHere'] as num?)?.toDouble()
      ..widthGuideHere = (json['widthGuideHere'] as num?)?.toDouble()
      ..heightGuideHere = (json['heightGuideHere'] as num?)?.toDouble()
      ..offsetXHere = (json['offsetXHere'] as num?)?.toDouble()
      ..offsetYHere = (json['offsetYHere'] as num?)?.toDouble()
      ..radiusHere = (json['radiusHere'] as num?)?.toDouble()
      ..isChecked = json['isChecked'] as bool?;

Map<String, dynamic> _$GameAnswerJsonBeanToJson(GameAnswerJsonBean instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'width': instance.width,
      'height': instance.height,
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
      'radius': instance.radius,
      'widthGuide': instance.widthGuide,
      'heightGuide': instance.heightGuide,
      'widthWidgetHere': instance.widthWidgetHere,
      'heightWidgetHere': instance.heightWidgetHere,
      'widthGuideHere': instance.widthGuideHere,
      'heightGuideHere': instance.heightGuideHere,
      'offsetXHere': instance.offsetXHere,
      'offsetYHere': instance.offsetYHere,
      'radiusHere': instance.radiusHere,
      'isChecked': instance.isChecked,
    };
