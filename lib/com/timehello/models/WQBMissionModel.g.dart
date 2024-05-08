// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WQBMissionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WQBMissionModel _$WQBMissionModelFromJson(Map<String, dynamic> json) =>
    WQBMissionModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..indexSearchingStart = json['indexSearchingStart'] as int?
      ..state = json['state'] as int
      ..indexSearchingEnd = json['indexSearchingEnd'] as int?
      ..background_url = json['background_url'] as String?
      ..title = json['title'] as String?
      ..folder_id = json['folder_id'] as String?
      ..flomo_object_id = json['flomo_object_id'] as String?
      ..type = json['type'] as int
      ..masterScore = (json['masterScore'] as num).toDouble()
      ..update_time = json['update_time'] as int?
      ..causeAnalysis = json['causeAnalysis'] as List<dynamic>?
      ..wqbTypeKnowledgePoint = json['wqbTypeKnowledgePoint'] as int
      ..wqbKnowledgeContent = json['wqbKnowledgeContent'] as String
      ..wqbKnowledgeRichContentUrl =
          json['wqbKnowledgeRichContentUrl'] as String
      ..wqbKnowledgeRecordUrls = json['wqbKnowledgeRecordUrls'] as List<dynamic>
      ..wqbKnowledgeSmallUrls =
          (json['wqbKnowledgeSmallUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..wqbKnowledgeBigUrls = (json['wqbKnowledgeBigUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..wqbKnowledgeOriginUrls =
          (json['wqbKnowledgeOriginUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..wqbTypeWrongQuestion = json['wqbTypeWrongQuestion'] as int
      ..wqbWrongQuestionContent = json['wqbWrongQuestionContent'] as String
      ..wqbWrongQuestionRichContentUrl =
          json['wqbWrongQuestionRichContentUrl'] as String
      ..wqbWrongQuestionRecordUrls =
          json['wqbWrongQuestionRecordUrls'] as List<dynamic>
      ..wqbWrongQuestionSmallUrls =
          (json['wqbWrongQuestionSmallUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..wqbWrongQuestionBigUrls =
          (json['wqbWrongQuestionBigUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..wqbWrongQuestionOriginUrls =
          (json['wqbWrongQuestionOriginUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..wqbTypeAnswer = json['wqbTypeAnswer'] as int
      ..wqbAnswerRecordUrls = json['wqbAnswerRecordUrls'] as List<dynamic>
      ..wqbAnswerSmallUrls = (json['wqbAnswerSmallUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..wqbAnswerBigUrls = (json['wqbAnswerBigUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..wqbAnswerOriginUrls = (json['wqbAnswerOriginUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..wqbAnswerContent = json['wqbAnswerContent'] as String
      ..wqbAnswerRichContentUrl = json['wqbAnswerRichContentUrl'] as String
      ..content = json['content'] as String
      ..device_id = json['device_id'] as String?
      ..tagNames = json['tagNames'] as List<dynamic>?
      ..tagIds = json['tagIds'] as String?
      ..isFinished = json['isFinished'] as bool?
      ..color = json['color'] as int?
      ..order_index = json['order_index'] as int?
      ..status = json['status'] as int?
      ..priorityStatus = json['priorityStatus'] as int?
      ..uid = json['uid'] as String?;

Map<String, dynamic> _$WQBMissionModelToJson(WQBMissionModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'indexSearchingStart': instance.indexSearchingStart,
      'state': instance.state,
      'indexSearchingEnd': instance.indexSearchingEnd,
      'background_url': instance.background_url,
      'title': instance.title,
      'folder_id': instance.folder_id,
      'flomo_object_id': instance.flomo_object_id,
      'type': instance.type,
      'masterScore': instance.masterScore,
      'update_time': instance.update_time,
      'causeAnalysis': instance.causeAnalysis,
      'wqbTypeKnowledgePoint': instance.wqbTypeKnowledgePoint,
      'wqbKnowledgeContent': instance.wqbKnowledgeContent,
      'wqbKnowledgeRichContentUrl': instance.wqbKnowledgeRichContentUrl,
      'wqbKnowledgeRecordUrls': instance.wqbKnowledgeRecordUrls,
      'wqbKnowledgeSmallUrls': instance.wqbKnowledgeSmallUrls,
      'wqbKnowledgeBigUrls': instance.wqbKnowledgeBigUrls,
      'wqbKnowledgeOriginUrls': instance.wqbKnowledgeOriginUrls,
      'wqbTypeWrongQuestion': instance.wqbTypeWrongQuestion,
      'wqbWrongQuestionContent': instance.wqbWrongQuestionContent,
      'wqbWrongQuestionRichContentUrl': instance.wqbWrongQuestionRichContentUrl,
      'wqbWrongQuestionRecordUrls': instance.wqbWrongQuestionRecordUrls,
      'wqbWrongQuestionSmallUrls': instance.wqbWrongQuestionSmallUrls,
      'wqbWrongQuestionBigUrls': instance.wqbWrongQuestionBigUrls,
      'wqbWrongQuestionOriginUrls': instance.wqbWrongQuestionOriginUrls,
      'wqbTypeAnswer': instance.wqbTypeAnswer,
      'wqbAnswerRecordUrls': instance.wqbAnswerRecordUrls,
      'wqbAnswerSmallUrls': instance.wqbAnswerSmallUrls,
      'wqbAnswerBigUrls': instance.wqbAnswerBigUrls,
      'wqbAnswerOriginUrls': instance.wqbAnswerOriginUrls,
      'wqbAnswerContent': instance.wqbAnswerContent,
      'wqbAnswerRichContentUrl': instance.wqbAnswerRichContentUrl,
      'content': instance.content,
      'device_id': instance.device_id,
      'tagNames': instance.tagNames,
      'tagIds': instance.tagIds,
      'isFinished': instance.isFinished,
      'color': instance.color,
      'order_index': instance.order_index,
      'status': instance.status,
      'priorityStatus': instance.priorityStatus,
      'uid': instance.uid,
    };
