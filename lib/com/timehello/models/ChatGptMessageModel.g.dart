// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatGptMessageModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGptMessageModel _$ChatGptMessageModelFromJson(Map<String, dynamic> json) =>
    ChatGptMessageModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..fid = json['fid'] as String?
      ..modelType = (json['modelType'] as num?)?.toInt()
      ..isCurrentSelectFolder = json['isCurrentSelectFolder'] as bool?
      ..system_message = json['system_message'] as String?
      ..folderTitle = json['folderTitle'] as String?
      ..folder_objectId = json['folder_objectId'] as String?
      ..function_call = json['function_call'] as String?
      ..chatModeEnum = (json['chatModeEnum'] as num?)?.toInt()
      ..function_call_arguments =
          json['function_call_arguments'] as Map<String, dynamic>?
      ..username = json['username'] as String?
      ..avatar = json['avatar'] as String?
      ..uid = json['uid'] as String?
      ..isUser = json['isUser'] as bool?
      ..title = json['title'] as String?
      ..content = json['content'] as String?
      ..choicesUid = json['choicesUid'] as String?
      ..chatGptFolderModelId = json['chatGptFolderModelId'] as String?
      ..role = json['role'] as String?
      ..id = json['id'] as String?
      ..conversationId = json['conversationId'] as String?
      ..parentMessageId = json['parentMessageId'] as String?
      ..text = json['text'] as String?
      ..detailId = json['detailId'] as String?
      ..detailObject = json['detailObject'] as String?
      ..detailCreated = json['detailCreated'] as String?
      ..detailModel = json['detailModel'] as String?
      ..detailUsagePromptToken =
          (json['detailUsagePromptToken'] as num?)?.toInt()
      ..detailUsageCompletionToken =
          (json['detailUsageCompletionToken'] as num?)?.toInt()
      ..detailUsageTotalToken = (json['detailUsageTotalToken'] as num?)?.toInt()
      ..choicesMessageRole = json['choicesMessageRole'] as String?
      ..choicesMessageContent = json['choicesMessageContent'] as String?
      ..choicesFinishReason = json['choicesFinishReason'] as String?
      ..countryCode = json['countryCode'] as String?
      ..created_at = (json['created_at'] as num?)?.toInt()
      ..updated_at = (json['updated_at'] as num?)?.toInt();

Map<String, dynamic> _$ChatGptMessageModelToJson(
        ChatGptMessageModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'fid': instance.fid,
      'modelType': instance.modelType,
      'isCurrentSelectFolder': instance.isCurrentSelectFolder,
      'system_message': instance.system_message,
      'folderTitle': instance.folderTitle,
      'folder_objectId': instance.folder_objectId,
      'function_call': instance.function_call,
      'chatModeEnum': instance.chatModeEnum,
      'function_call_arguments': instance.function_call_arguments,
      'username': instance.username,
      'avatar': instance.avatar,
      'uid': instance.uid,
      'isUser': instance.isUser,
      'title': instance.title,
      'content': instance.content,
      'choicesUid': instance.choicesUid,
      'chatGptFolderModelId': instance.chatGptFolderModelId,
      'role': instance.role,
      'id': instance.id,
      'conversationId': instance.conversationId,
      'parentMessageId': instance.parentMessageId,
      'text': instance.text,
      'detailId': instance.detailId,
      'detailObject': instance.detailObject,
      'detailCreated': instance.detailCreated,
      'detailModel': instance.detailModel,
      'detailUsagePromptToken': instance.detailUsagePromptToken,
      'detailUsageCompletionToken': instance.detailUsageCompletionToken,
      'detailUsageTotalToken': instance.detailUsageTotalToken,
      'choicesMessageRole': instance.choicesMessageRole,
      'choicesMessageContent': instance.choicesMessageContent,
      'choicesFinishReason': instance.choicesFinishReason,
      'countryCode': instance.countryCode,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
