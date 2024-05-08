/**
 * 每个folderModel下有多个missionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'ChatGptMessageModel.g.dart';

@JsonSerializable()
class ChatGptMessageModel extends MongoDbObject{

  String? fid = "";

  int? modelType = 0; // 0 - 消息 1 - 文件夹

  bool? isCurrentSelectFolder = false; // 是否是当前选择的文件夹

  String? system_message = ""; //系统消息

  String? folderTitle = ''; //modelType为1时 文件夹标题

  String? folder_objectId = ''; //modelType为1时 文件夹id modelType为0也有值 1 没有值 但是为了显示 需要把_objectId也索引

  String? function_call;

  int? chatModeEnum = 0; //聊天模式 0 - 普通聊天 1 - 问答模式

  Map? function_call_arguments;
  //用户名
  String? username;
  //用户头像
  String? avatar;

  String? uid;

  bool? isUser = true; //是否是用户发起聊天

  //博客作者
  String? title = ''; //标题

  String? content = ''; //用不上 可以考虑放到图片Url

  String? choicesUid; //用不上

  String? chatGptFolderModelId; //用不上

  String? role = ''; //角色

  String? id = '';

  String? conversationId = ''; // 会话id 每个都不一样

  String? parentMessageId = '';

  String? text = ''; //沟通内容

  String? detailId = ''; // chatcmpl-7Oint4JpOhilPNcvdDxNTJNGJ45rm 不懂干啥的 每个都不一样

  String? detailObject = ''; //chat.completion.chunk 感觉没有用

  String? detailCreated = ''; //创建时间 秒为单位

  String? detailModel = ''; // gpt-3.5-turbo-0301 模型

  int? detailUsagePromptToken = 0; //感觉没有用

  int? detailUsageCompletionToken = 0; //完成token数量

  int? detailUsageTotalToken = 0;

  String? choicesMessageRole;

  String? choicesMessageContent;

  String? choicesFinishReason; // 完成原因 征程完成会有stop

  String? countryCode = ''; //国家码

  int? created_at = -1; // 创建时间戳

  int? updated_at = -1; // 更新时间戳

  ChatGptMessageModel();

  //此处与类名一致，由指令自动生成代码
  factory ChatGptMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatGptMessageModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ChatGptMessageModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}