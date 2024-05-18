import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/common/provider/GlobalStateEnv.dart';
import 'package:time_hello/com/timehello/components/GPTCreateMissionWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/page/CreateAIChatGptMissionPage/CreateAIChatGptMissionWidget.dart';
import 'package:time_hello/com/timehello/page/CreateAIChatGptMissionPage/CreateAIMissionContainerWidget.dart';
import 'package:time_hello/com/timehello/page/statisticPage/pages/FolderSummaryPage.dart';
import 'package:time_hello/com/timehello/util/CloudSharepreferenceManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../components/CustomAnimation.dart';
import '../config/Params.dart';
import '../models/FolderModelWithExtraData.dart';
import '../models/MissionModel.dart';
import '../page/statisticPage/pages/SummaryPage.dart';
import 'BeanParser.dart';
import 'DeviceInfoManagement.dart';

class ChatGptManager {
  static ChatGptManager? chatGptManager;
  OnStreamResponseListener? onStreamResponseListener;
  String curCacheText = "";
  String userSettingDefaultSystemMessage =
      getI18NKey().gpt_system_msg_forbidden;

  static getInstance() {
    if (chatGptManager == null) {
      chatGptManager = ChatGptManager();
      chatGptManager?.init();
    }
    return chatGptManager;
  }

  init() {
    this.userSettingDefaultSystemMessage =
        CloudSharepreferenceManagement.getInstance()
            .getString(ShareprefrenceKeys.gptUserSystemMessage, "");
  }

  void showCreateMissionDialog(BuildContext context, ChatGptMessageModel? chatGptMessageModelGpt) {
    var listTmp = List<Map<String, dynamic>>.from(chatGptMessageModelGpt?.function_call_arguments?['datas'] ?? []);
    List<MissionModel> list = BeanParser.parseMissionModelListFromGpt(
        listTmp ?? []);
    list.forEach((element) {
      element.isFinished = false;
      element.isDelayed = false;
      //如果没有time_mode则默认为1 时间段模式
      if(element.time_mode == null) {
        element.time_mode = 1;
        if (element.start_time == null) {
          element.start_time = DateTime
              .now()
              .millisecondsSinceEpoch + Duration(hours: 1).inMilliseconds;
        }
        if (element.end_time == null) {
          element.end_time = DateTime
              .now()
              .add(Duration(hours: 1))
              .millisecondsSinceEpoch + Duration(hours: 1).inMilliseconds;
        }
      }
    });
    Utility.openPagePCAndMobile(context, child: CreateAIMissionContainerWidget(list: list,));
    // DialogManagement.getInstance()
    //     .showCustomDialogWithSmallButtons(context,
    //   okTitle: getI18NKey().i_know,
    //   children: [
    //     // Text(getI18NKey().preview, style: TextStyle(fontSize: 13),),
    //     SizedBox(height: 10,),
    //     Expanded(
    //       child: Container(
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //               color: ThemeManager.getInstance().getBackgroundColor(),
    //               borderRadius: BorderRadius.circular(10)),
    //           child: GPTCreateMissionWidget(
    //               list: list)),
    //     )],
    //   // title: getI18NKey().trainee_give_your_advice(this.role),
    //   okCallback: () {
    //     DialogManagement.getInstance().hideDialog(context);
    //     Utility.openPagePCAndMobile(context, child: CreateAIMissionContainerWidget(listMissionModel: list,));
    //     // DialogManagement.showRatingDialog(context, scene: EVENTNAME.CreateAIChatGptMissionPage);
    //   }, title: getI18NKey().preview,
    // );
  }

  /**
   * 从服务器缓存获取聊天信息
   */
  Future<ChatGptMessageModel?> getChatMessage() async {
    // BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
    //     Apis.getChatGptRedis,
    //     params: {
    //     }, CONNECT_TIMEOUT: 2 * 60000, RECEIVE_TIMEOUT: 2 * 60000);
    // // print("1111111111 ${baseBean.data}");
    if (curCacheText.indexOf("~~~~~~~~~~") == -1) {
      ChatGptMessageModel chatGptMessageModel = ChatGptMessageModel();
      chatGptMessageModel.isUser = false;
      chatGptMessageModel.text = curCacheText;
      chatGptMessageModel.uid = LoginManager.getInstance().userBean.uid;
      chatGptMessageModel.username = getI18NKey().chatgpt;
      return chatGptMessageModel;
    } else {
      return null;
    }
  }

  openStatsPage(BuildContext context,
      {required ChatGptMessageModel chatGptMessageModel}) {
    ChatModeEnum chatModeEnum =
        ChatModeEnum.values[chatGptMessageModel.chatModeEnum ?? 0];
    if (chatModeEnum == ChatModeEnum.statistic) {
      if (chatGptMessageModel.function_call == "showChartStats") {
        showChartStatsPage(
          context,
          // title: chatGptMessageModel?.function_call_arguments?['title'],
          startTime:
              Utility.getGPTUTCDateTimeFromStringYToTimestamp(chatGptMessageModel.function_call_arguments?['startTime'],defaultDateTime: DateTime.now()
                  .subtract(Duration(days: 365))) ?? DateTime.now()
                  .subtract(Duration(days: 365)).millisecondsSinceEpoch,
          endTime:
          Utility.getGPTUTCDateTimeFromStringYToTimestamp(chatGptMessageModel.function_call_arguments?['endTime'],defaultDateTime: DateTime.now()
              .add(Duration(days: 1))) ?? DateTime.now()
              .add(Duration(days: 1)).millisecondsSinceEpoch,
        );
      } else if (chatGptMessageModel.function_call == "showChartFolderStats") {
        showChartFolderStatsPage(
          context,
          title: chatGptMessageModel?.function_call_arguments?['title'],
          startTime:
          Utility.getGPTUTCDateTimeFromStringYToTimestamp(chatGptMessageModel.function_call_arguments?['startTime'],defaultDateTime: DateTime.now()
              .subtract(Duration(days: 365))) ?? DateTime.now()
              .subtract(Duration(days: 365)).millisecondsSinceEpoch,
          endTime:
          Utility.getGPTUTCDateTimeFromStringYToTimestamp(chatGptMessageModel.function_call_arguments?['endTime'],defaultDateTime: DateTime.now()
              .add(Duration(days: 1))) ?? DateTime.now()
              .add(Duration(days: 1)).millisecondsSinceEpoch,
        );
      }
    }
  }

  showChartStatsPage(BuildContext context,
      {required int startTime, required int endTime}) {
    // FolderModel? folderModel =
    // MongoApisManager.getInstance()?.queryfolderModelWithFolderTitle(title);
    // if (folderModel == null) {
    //   // EasyLoading.showToast(getI18NKey().folder_not_exist);
    //   return;
    // }
    DateTime startTimeLocal = DateTime.fromMillisecondsSinceEpoch(startTime);
    DateTime endTimeLocal = DateTime.fromMillisecondsSinceEpoch(endTime);
    // CalendarModel calendarModel = context.read<GlobalStateEnv>().calendarModel;
    // // Utility.getFolderModelWithExtraDataByObjectId
    // FolderTimeModel folderTimeModel = CONSTANTS.getFolderTime(
    //     folderStatusDate: folderModel.iconType ?? 0,
    //     calendarModel: calendarModel,
    //     folderStatus: 0);
    // FolderModelWithExtraData res = FolderModelWithExtraData(
    //     folderModel: folderModel, folderTimeModel: folderTimeModel);
    Utility.openPagePCAndMobile(context,
        child: SummaryPage(
          calendarTypeEnum: CalendarTypeEnum.custom,
          // folderModelWithExtraData: res,
          dateTimePickerDateRange: PickerDateRange(
            startTimeLocal,
            endTimeLocal,
          ),
          shouldShowNav: Utility.isHandsetBySize(),
        ));
  }

  showChartFolderStatsPage(BuildContext context,
      {required String title, required int startTime, required int endTime}) {
    FolderModel? folderModel =
        MongoApisManager.getInstance()?.queryfolderModelWithFolderTitle(title);
    if (folderModel == null) {
      // EasyLoading.showToast(getI18NKey().folder_not_exist);
      return;
    }
    DateTime startTimeLocal = DateTime.fromMillisecondsSinceEpoch(startTime);
    DateTime endTimeLocal = DateTime.fromMillisecondsSinceEpoch(endTime);
    CalendarModel calendarModel = context.read<GlobalStateEnv>().calendarModel;
    // Utility.getFolderModelWithExtraDataByObjectId
    FolderTimeModel folderTimeModel = CONSTANTS.getFolderTime(
        folderStatusDate: folderModel.iconType ?? 0,
        calendarModel: calendarModel,
        folderStatus: 0);
    FolderModelWithExtraData res = FolderModelWithExtraData(
        folderModel: folderModel, folderTimeModel: folderTimeModel);
    Utility.openPagePCAndMobile(context,
        child: FolderSummaryPage(
          folderModelWithExtraData: res,
          calendarTypeEnum: CalendarTypeEnum.custom,
          dateTimePickerDateRange: PickerDateRange(
            startTimeLocal,
            endTimeLocal,
          ),
          shouldShowNav: Utility.isHandsetBySize(),
        ));
  }

  Future<ChatGptMessageModel?> sendMessages(
      {required String systemMessage,
      String? scene,
        ChatGptFolderModel? chatGptFolderModel,
      required List<Map<String, String>> messages}) async {
    this.userSettingDefaultSystemMessage =
        await CloudSharepreferenceManagement.getInstance()
            .getString(ShareprefrenceKeys.gptUserSystemMessage, "");
    //放到messages第一个
    if (messages.length > 0) {
      messages.insert(0, {
        'role': 'system',
        'content': systemMessage +
            "\n" +
            this.userSettingDefaultSystemMessage +
            "\ntimestamp now:" +
            Utility.getTimeStampToday().toString() +
            "\nutc datetime:" +
            Utility.getDateTimeNowUtc().toString(),
      });
    } else {
      messages.add({'role': 'system', 'content': systemMessage});
    }
    String textRes = await HttpManager.getInstance().doStreamRequest(
        Apis.chatGptWithOpenAi,
        CONNECT_TIMEOUT: 3 * 60000,
        RECEIVE_TIMEOUT: 3 * 60000,
        shouldShowErrorToast: false,
        callback: (String res, String scene, int requestStatus) {
      print("res: $res");
      this.curCacheText = res;
      this.onStreamResponseListener?.call(res, scene, requestStatus);
    }, params: {
      "scene": scene,
      "messages": messages,
    });
    this.curCacheText = "";

    Map? resMap = Utility.extractContent(textRes);
    try {
      String role = "assistant";
      String text = resMap?['choices'][0]['content'] ?? "";
      String conversationId = resMap?['id'] ?? "";
      dynamic arguments = resMap?['choices']?[0]?['message']?['function_call']
                  ?['arguments'] !=
              null
          ? jsonDecode(resMap?['choices']?[0]?['message']?['function_call']
              ?['arguments'])
          : {};
      ChatGptMessageModel chatGptMessageModel = ChatGptMessageModel();
      chatGptMessageModel.function_call =
          resMap?['function_call']?['name'] ?? "";
      chatGptMessageModel.countryCode = DeviceInfoManagement.getCountryCode();
      chatGptMessageModel.uid = LoginManager.getInstance().userBean.uid;
      chatGptMessageModel.fid = chatGptFolderModel?.objectId ?? "";
      chatGptMessageModel.username = getI18NKey().chatgpt;
      //判断如果arguments是map则直接负值，如果是list数组则改成{datas: list}
      Map? args = null;
      if (arguments is Map) {
        args = arguments;
      }
      if (chatGptMessageModel.function_call == "createMissionData") {
        if (arguments is List) {
          args = {
            "datas": [...arguments]
          };
        } else if (arguments is Map) {
          args = {
            "datas": [arguments]
          };
        }
      }

      chatGptMessageModel.function_call_arguments = args;
      int prompt_tokens =
          Utility.calPromptTokensForMessages(messages: messages);
      int completion_tokens = Utility.calTokensForResponse(text);
      String finishReason = resMap?['choices'][0]['finish_reason'] ?? "";
      chatGptMessageModel.role = role;
      chatGptMessageModel.id = conversationId;
      chatGptMessageModel.conversationId = conversationId;
      chatGptMessageModel.text = text;
      chatGptMessageModel.fid = chatGptFolderModel?.objectId ?? "";
      chatGptMessageModel.isUser = false;
      chatGptMessageModel.detailUsagePromptToken = prompt_tokens;
      chatGptMessageModel.detailUsageCompletionToken = completion_tokens;
      chatGptMessageModel.choicesFinishReason = finishReason;
      // chatGptMessageModel.uid = LoginManager.getInstance().userBean.uid;
      chatGptMessageModel.username = getI18NKey().chatgpt;
      chatGptMessageModel.chatModeEnum = getChatModeEnum(chatGptMessageModel);
      return chatGptMessageModel;
    } catch (e) {
      return null;
    }
  }

  int getChatModeEnum(ChatGptMessageModel chatGptMessageModel) {
    if (!TextUtil.isEmpty(chatGptMessageModel.function_call)) {
      if (chatGptMessageModel.function_call == "showChartStats" ||
          chatGptMessageModel.function_call == "showChartFolderStats") {
        return ChatModeEnum.statistic.index;
      } else if (chatGptMessageModel.function_call == "createMissionData") {
        return ChatModeEnum.create_missions.index;
      }
    }
    return ChatModeEnum.text.index;
  }

  Future<ChatGptMessageModel?> sendMessage(
      {bool showForbiddenMsg: true,
      bool? newChatGptObject: false,
      String? conversationIdParams,
      String? parentMessageIdParam,
      String? systemMessage,
      required String textParam}) async {
    BaseBean baseBean =
        await HttpManager.getInstance().doPostRequest(Apis.chatGpt,
            shouldShowErrorToast: false,
            params: {
              "newChatGptObject": newChatGptObject,
              "conversationId": conversationIdParams,
              "parentMessageId": parentMessageIdParam ?? "",
              "systemMessage":
                  systemMessage ?? getI18NKey().gpt_system_msg_forbidden,
              "text": "$textParam" +
                  (showForbiddenMsg
                      ? '(${getI18NKey().gpt_system_msg_forbidden})'
                      : "")
            },
            CONNECT_TIMEOUT: 3 * 60000,
            RECEIVE_TIMEOUT: 3 * 60000);
    // ChatGptMessageModel model = baseBean.data;
    try {
      if (baseBean.success) {
        String role = baseBean.data['role'];
        String id = baseBean.data['id'];
        String conversationId = baseBean.data['id'];
        String parentMessageId = baseBean.data['parentMessageId'];
        String text = baseBean.data['text'];
        String detailId = baseBean.data['detail']['id'];
        String detailObject = baseBean.data['detail']['object'];
        String detailCreated = baseBean.data['detail']['created'].toString();
        String detailModel = baseBean.data['detail']['model'];

        int prompt_tokens = baseBean.data['detail']['usage']['prompt_tokens'];
        int completion_tokens =
            baseBean.data['detail']['usage']['completion_tokens'];
        int total_tokens = baseBean.data['detail']['usage']['total_tokens'];

        // String choicesRole = baseBean.data['detail']['choices'][0]['message']['role'];
        // String choicesContent = baseBean.data['detail']['choices'][0]['message']['content'];
        String finishReason =
            baseBean.data['detail']['choices'][0]['finish_reason'];

        ChatGptMessageModel chatGptMessageModel = ChatGptMessageModel();
        chatGptMessageModel.role = role;
        chatGptMessageModel.id = id;
        chatGptMessageModel.conversationId = conversationId;
        chatGptMessageModel.parentMessageId = parentMessageId;
        chatGptMessageModel.text = text;
        chatGptMessageModel.detailId = detailId;
        chatGptMessageModel.isUser = false;
        chatGptMessageModel.detailObject = detailObject;
        chatGptMessageModel.detailCreated = detailCreated;
        chatGptMessageModel.detailModel = detailModel;
        chatGptMessageModel.detailUsagePromptToken = prompt_tokens;
        chatGptMessageModel.detailUsageCompletionToken = completion_tokens;
        chatGptMessageModel.detailUsageTotalToken = total_tokens;
        // chatGptMessageModel.choicesMessageRole = choicesRole;
        // chatGptMessageModel.choicesMessageContent = choicesContent;
        chatGptMessageModel.choicesFinishReason = finishReason;
        chatGptMessageModel.countryCode = DeviceInfoManagement.getCountryCode();
        chatGptMessageModel.uid = LoginManager.getInstance().userBean.uid;
        chatGptMessageModel.username = getI18NKey().chatgpt;
        return chatGptMessageModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
