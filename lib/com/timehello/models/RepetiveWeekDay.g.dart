// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RepetiveWeekDay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepetiveWeekDay _$RepetiveWeekDayFromJson(Map<String, dynamic> json) =>
    RepetiveWeekDay()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..isRepetiveMonday = json['isRepetiveMonday'] as bool?
      ..isRepetiveTuesday = json['isRepetiveTuesday'] as bool?
      ..isRepetiveWednesday = json['isRepetiveWednesday'] as bool?
      ..isRepetiveThursday = json['isRepetiveThursday'] as bool?
      ..isRepetiveFriday = json['isRepetiveFriday'] as bool?
      ..isRepetiveSaturday = json['isRepetiveSaturday'] as bool?
      ..isRepetiveSunday = json['isRepetiveSunday'] as bool?
      ..author = json['author'] == null
          ? null
          : MongoDbUser.fromJson(json['author'] as Map<String, dynamic>);

Map<String, dynamic> _$RepetiveWeekDayToJson(RepetiveWeekDay instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'isRepetiveMonday': instance.isRepetiveMonday,
      'isRepetiveTuesday': instance.isRepetiveTuesday,
      'isRepetiveWednesday': instance.isRepetiveWednesday,
      'isRepetiveThursday': instance.isRepetiveThursday,
      'isRepetiveFriday': instance.isRepetiveFriday,
      'isRepetiveSaturday': instance.isRepetiveSaturday,
      'isRepetiveSunday': instance.isRepetiveSunday,
      'author': instance.author,
    };
