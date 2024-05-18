import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/GPTCreateMissionWidget.dart';
import 'package:time_hello/com/timehello/components/IconButtonListWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/EVENTNAME.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/ChatGptHeaderWidget.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GPTRoleGridViewPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GptChatHistoryPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GptMorePage.dart';
import 'package:time_hello/com/timehello/page/CreateAIChatGptMissionPage/CreateAIChatGptMissionWidget.dart';
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/ChatGptManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../components/BlackCheckButtonListWidget.dart';
import '../../components/ChatInputWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../config/CONSTANTS.dart';
import '../../config/Params.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/ThemeManager.dart';
import '../../util/Utility.dart';
import 'components/ChatGptListView.dart';

/**
 * 设置页面
 */
class ChatGptPage extends BaseWidget {
  PageGPTFromEnum pageGPTFromEnum = PageGPTFromEnum.RightBarPage;
  String fid = "";

  ChatGptPage(
      {Key? key,
      String fid = "",
      PageGPTFromEnum pageGPTFromEnum = PageGPTFromEnum.RightBarPage})
      : super(key: key) {
    this.fid = fid;
    this.pageGPTFromEnum = pageGPTFromEnum;
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ChatGptPageWidgetState();
  }
}

class _ChatGptPageWidgetState<T> extends BaseWidgetState<ChatGptPage> {
  List<ChatGptMessageModel> listChatGptMessageModels = [];
  FocusNode _contentFocusNode = FocusNode();
  ChatGptMessageModel? chatGptMessageModelRedisCache;
  String value = "";
  bool enableInteractiveSelection = true;
  int isLoading2 = 0; //0 - 没有Loading  1 - loading 用户消息 2 - loading gpt消息
  // Timer? _timer;
  ChatGptPageEnum chatGptPageEnum = ChatGptPageEnum.chatGptPage;
  String folderIdForRightBar = ''; //右侧边栏的文件夹id PageGPTFromEnum.RightBarPage才有用
  ChatGptMessageModel? chatGptMessageModelCurSelected;
  OnStreamResponseListener? onStreamResponseListener;
  CheckButtonStateModel? curCheckButtonStateModel;
  List<CheckButtonStateModel> listCheckButtonStateModel =
      CONSTANTS.getChatGptMessageButtonList(defaultVal: 0);
  GlobalKey<ChatInputWidgetState> chatInputWidgetStateGlobalKey = GlobalKey();
  ChatGptFolderModel? _curChatGptFolderModel;

  ChatGptPageWidgetState() {}

  // TextEditingController inputController = TextEditingController();
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide: BorderSide(
      color: ThemeManager.getInstance()
          .getInputBorderColor(defaultColor: Colors.white),
    ),
  );

  GlobalKey<ChatGptListViewState> ChatGptListViewGlobalKey = GlobalKey();

  @override
  void onCreate() {
    super.onCreate();
    curPage = "ChatGPTPage";
  }

  showPage({page = ChatGptPageEnum.none}) {
    this.chatGptPageEnum = page;
    updateUI();
  }

  @override
  void initState() {
    // this.requestDatas();
    this.isAppBarVisible = false;
    this.forceAppBarVisible = false;
    curCheckButtonStateModel = listCheckButtonStateModel[0];
    ChatGptManager.getInstance()?.onStreamResponseListener =
        (String res, String scene, int requestStatus) async {
      ChatGptMessageModel? chatGptMessageModel =
          await ChatGptManager.getInstance().getChatMessage();
      if (chatGptMessageModel != null) {
        this.chatGptMessageModelRedisCache = chatGptMessageModel;
        updateUI();
        toBottom(); //滑动到底部
        print("res: $res");
      }
      // this.onStreamResponseListener?.call(res, scene, requestStatus);
    };
  }

  void requestDatas({bool shouldUpdateUI = false}) async {
    if (this.widget.pageGPTFromEnum == PageGPTFromEnum.RightBarPage) {
      if (MongoApisManager.getInstance().hasLoadedChatGptMessageModel) {
        if (chatGptMessageModelCurSelected == null) {
          chatGptMessageModelCurSelected =
              MongoApisManager.getInstance().getCurChatGptMessageModel();
          if (chatGptMessageModelCurSelected != null) {
            this.folderIdForRightBar =
                chatGptMessageModelCurSelected?.objectId ?? "";
          } else {
            // await createEmptyChatGptMessageModel();
          }
        }
        //请求时发现没有创建就去创建
        if (TextUtil.isEmpty(this.folderIdForRightBar)) {
          await createEmptyChatGptMessageModel();
          return;
        }
        this.listChatGptMessageModels = MongoApisManager.getInstance()
            .getChatGptMessageModelListByFolderId(folderIdForRightBar);
        // list = await MongoApisManager.getInstance()
        //     .queryWhereEqual_ChatGptMessageModel();
        if (shouldUpdateUI == true) {
          updateUI();
        }
      }
    } else {
      if(!TextUtil.isEmpty(_curChatGptFolderModel?.objectId)) {
        this.listChatGptMessageModels = MongoApisManager.getInstance()
            .getChatGptMessageModelListByObjectId(
            _curChatGptFolderModel?.objectId ?? "");
      } else {
        this.listChatGptMessageModels = [];
      }
    }
    // toBottom();
  }


  /**
   * AIHelperPage创建文件夹 没消息才创建
   */
  Future<void> createFolder(String text) async {
    if(this.widget.pageGPTFromEnum == PageGPTFromEnum.AIHelperPage && this.listChatGptMessageModels.length == 0) {
      ChatGptFolderModel chatGptFolderModel = ChatGptFolderModel();
      chatGptFolderModel.title = text;
      // text = Utility.getPromptsText(text:text, prompts: item?.resourceContent ?? "");
      // chatGptFolderModel.prompt = item?.resourceContent;
      // chatGptFolderModel.promptTitle = item?.resourceTitle;
      MongoDbSaved? res = await MongoApisManager.getInstance().insertChatGptFolderModel(chatGptFolderModel: chatGptFolderModel);
      chatGptFolderModel.objectId = res?.objectId ?? "";
      this._curChatGptFolderModel = chatGptFolderModel;
      context.read<Env>().curChatGptFolderModel = chatGptFolderModel;
    }
    return;
  }

  void toBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      ChatGptListViewGlobalKey.currentState?.toBottom();
    });
  }

  // @override
  // void didUpdateWidget(Widget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {}

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // this.list = context.read<GlobalStateEnv>().listChatGptMessageModel;
    return Selector<Env, ChatGptFolderModel>(
        selector: (_, env) => env.curChatGptFolderModel,
        builder: (_, curChatGptFolderModel, __) {
          //PageGPTFromEnum.RightBarPage 不用 主要用于ai助手
          _curChatGptFolderModel = curChatGptFolderModel;
          return Selector<GlobalStateEnv, List<ChatGptMessageModel>>(
              selector: (_, env) => env.listChatGptMessageModel,
              builder: (_, listChatGptMessageModel, __) {
                // this.list = listChatGptMessageModel;
                requestDatas();
                return Column(
                  children: [
                    CustomMarquee(
                      bean: MarqueInfo.marqueGPTPage,
                    ),
                    if(this.widget.pageGPTFromEnum == PageGPTFromEnum.RightBarPage)
                    ChatGptHeaderWidget(
                      key: ValueKey("ejzifizejf"),
                      onTapListener: (CheckButtonStateModel model) async {
                        switch (model.code) {
                          case 'chat':
                            showPage(page: ChatGptPageEnum.chatGptPage);
                            break;
                          case 'more':
                            showPage(page: ChatGptPageEnum.morePage);
                            break;
                          case 'previous_chat':
                            showPage(page: ChatGptPageEnum.historyPage);
                            break;
                          case 'new_chat':
                            // ChatGptMessageModel? chatGptMessageModelCurSelected =
                            //     MongoApisManager.getInstance()
                            //         .getCurChatGptMessageModel();
                            //如果当前选中的是文件夹在编辑中 且没有内容为空 就不需要重新创建一个空的ChatGptMessageModel 直接打开页面就好了
                            // if (chatGptMessageModelCurSelected != null &&
                            //     TextUtil.isEmpty(
                            //             chatGptMessageModelCurSelected.folderTitle) ==
                            //         true) {
                            //   this.chatGptMessageModelCurSelected = chatGptMessageModelCurSelected;
                            // } else {
                            await createEmptyChatGptMessageModel();
                            // }
                            showPage(page: ChatGptPageEnum.chatGptPage);
                            break;
                          case 'close':
                            if (this.chatGptPageEnum ==
                                    ChatGptPageEnum.chatGptPage ||
                                this.chatGptPageEnum ==
                                    ChatGptPageEnum.morePage) {
                              Utility.popupDesktopRightNavigator(context);
                            } else {
                              showPage(page: ChatGptPageEnum.chatGptPage);
                            }
                            break;
                        }
                      },
                      chatGptPageEnum: this.chatGptPageEnum,
                    ),
                    (this.widget.pageGPTFromEnum ==
                                PageGPTFromEnum.AIHelperPage &&
                            listChatGptMessageModels.length == 0)
                        ? Expanded(
                            child: GPTRoleGridViewPage(
                            onClickCreated: (text, ChatGptFolderModel chatGptFolderModel) {
                              this._curChatGptFolderModel = chatGptFolderModel;
                              onClickSendMsg(text);
                            },
                          ))
                        : getPageBody(),
                    if (this.chatGptPageEnum == ChatGptPageEnum.chatGptPage)
                      ChatInputWidget(
                          key: chatInputWidgetStateGlobalKey,
                          listSuggest: curCheckButtonStateModel?.list ?? [],
                          headerWidget: this.widget.pageGPTFromEnum == PageGPTFromEnum.RightBarPage ? IconButtonListWidget(
                            wrapMode: WrapModeEnum.wrap,
                            initIndex: 0,
                            list: listCheckButtonStateModel,
                            onTapListener: (obj) {
                              curCheckButtonStateModel =
                                  listCheckButtonStateModel[obj['index']];
                              chatInputWidgetStateGlobalKey.currentState
                                  ?.refresh();
                              updateUI();
                            },
                          ) : SizedBox.shrink(),
                          onClickSendMsg: (val) {
                            this.onClickSendMsg(val);
                          }),
                  ],
                );
              });
        });
  }

  Future<void> createEmptyChatGptMessageModel() async {
    await MongoApisManager.getInstance()
        .resetAllChatGptMessageModelIsCurrentSelectFolder();
    ChatGptMessageModel chatGptMessageModel = ChatGptMessageModel();
    chatGptMessageModel.isCurrentSelectFolder = true;
    chatGptMessageModel.text = "";
    chatGptMessageModel.modelType = 1;
    chatGptMessageModel.username =
        chatGptMessageModel.fid = _curChatGptFolderModel?.objectId;
        LoginManager.getInstance().getUserBean().username;
    chatGptMessageModel.avatar =
        LoginManager.getInstance().getUserBean().avatar;
    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertChatGptMessageModel(chatGptMessageModel: chatGptMessageModel);
    this.folderIdForRightBar = res?.objectId ?? "";
  }

  Future<void> batchDeleteChatGptMessageModel() async {
    await MongoApisManager.getInstance().batchDelete_BillModel();
  }

  Widget getPageBody() {
    if (chatGptPageEnum == ChatGptPageEnum.none) {
      return Expanded(
        child: Container(),
      );
    } else if (chatGptPageEnum == ChatGptPageEnum.chatGptPage) {
      return Expanded(
        child: getChatPage(),
      );
    } else if (chatGptPageEnum == ChatGptPageEnum.morePage) {
      return Expanded(
        child: GptMorePage(
          onEnterSystemExtraListener: (String res) {},
        ),
      );
    } else if (chatGptPageEnum == ChatGptPageEnum.historyPage) {
      return Expanded(
        child: GptChatHistoryPage(
          onTapListener: (ChatGptMessageModel chatGptMessageModel) async {
            chatGptMessageModel.isCurrentSelectFolder = true;
            this.chatGptMessageModelCurSelected = chatGptMessageModel;
            await MongoApisManager.getInstance().update_ChatGptMessageModel(
                chatGptMessageModel: chatGptMessageModel,
                shouldQueryModel: false);
            this.folderIdForRightBar = chatGptMessageModel.objectId ?? "";
            requestDatas(shouldUpdateUI: true);
            showPage(page: ChatGptPageEnum.chatGptPage);
          },
        ),
      );
    }
    return Spacer();
  }

  Container getChatPage() {
    return Container(
      child: ChatGptListView(
        key: ChatGptListViewGlobalKey,
        onTapStatisticListener: (chatGptMessageModel) {
          ChatGptManager.getInstance()
              .openStatsPage(context, chatGptMessageModel: chatGptMessageModel);
          // this.chatGptMessageModelCurSelected = chatGptMessageModel;
          // showPage(page: ChatGptPageEnum.morePage);
        },
        onTapSendAgainListener: (chatGptMessageModel) {
          ChatGptMessageModel? chatMessageModel = Utility.getLastSentence(
              this.listChatGptMessageModels, chatGptMessageModel);
          if (chatMessageModel != null &&
              !TextUtil.isEmpty(chatMessageModel.text)) {
            this.onClickSendMsg(chatMessageModel.text ?? "");
            toBottom(); //滑动到底部
          }
        },
        chatGptMessageModelChatGptRedisCache:
            this.chatGptMessageModelRedisCache,
        isLoading: this.isLoading2,
        datas: this.listChatGptMessageModels,
        onTapCreateMissionListener: (chatGptMessageModelGpt) {
          ChatGptManager.getInstance()
              .showCreateMissionDialog(context, chatGptMessageModelGpt);
        },
      ),
    );
  }

  // getLastParentMessageId() {
  //   for (int i = this.list.length - 1; i > 0; i--) {
  //     ChatGptMessageModel chatGptMessageModelGpt = this.list[i];
  //     if (!TextUtil.isEmpty(chatGptMessageModelGpt.parentMessageId)) {
  //       return {
  //         "parentMessageId": chatGptMessageModelGpt.id,
  //         "conversationId": chatGptMessageModelGpt.conversationId
  //       };
  //     }
  //   }
  //   return {};
  // }

  // void startCountdownTimer() {
  //   const oneSec = const Duration(seconds: 3);
  //
  //   var callback = (Timer timer) async {
  //
  //     print("tick: ${timer.tick}");
  //     if (timer.tick > 150) {
  //       stopTimer();
  //     }
  //   };
  //   _timer = Timer.periodic(oneSec, callback);
  // }
  //
  // void stopTimer() {
  //   _timer?.cancel();
  // }

  updateFolderTitle(String title) {
    if (chatGptMessageModelCurSelected != null &&
        TextUtil.isEmpty(chatGptMessageModelCurSelected?.folderTitle)) {
      chatGptMessageModelCurSelected?.title = title;
      chatGptMessageModelCurSelected?.folderTitle = title;
      MongoApisManager.getInstance()?.update_ChatGptMessageModel(
          chatGptMessageModel: chatGptMessageModelCurSelected,
          shouldQueryModel: false);
    }
  }

  /**
   * 从消息列表中选择最后6条数据
   */
  List<Map<String, String>> getChatMessageList(
      {int maxLines = 4, required String latestMessage}) {
    List<Map<String, String>> list = [];
    int cpt = 0;
    List<String> listText = [];
    bool hasCallback = false;
    List<ChatGptMessageModel> listChatGptMessageModels = [];
    for (int i = this.listChatGptMessageModels.length - 1; i >= 0; i--) {
      ChatGptMessageModel chatGptMessageModelGpt =
          this.listChatGptMessageModels[i];
      if (!TextUtil.isEmpty(chatGptMessageModelGpt.function_call) &&
          chatGptMessageModelGpt.function_call != 'end') {
        hasCallback = true;
        break;
      }
      listChatGptMessageModels.add(chatGptMessageModelGpt);
    }
    if (hasCallback == false) {
      listChatGptMessageModels = listChatGptMessageModels.reversed.toList();
      for (int i = listChatGptMessageModels.length - 1; i >= 0; i--) {
        ChatGptMessageModel chatGptMessageModelGpt =
            listChatGptMessageModels[i];
        bool isUser = chatGptMessageModelGpt.isUser ?? true;
        String text = chatGptMessageModelGpt.text ?? "";
    // || listText.contains(text)
        if (TextUtil.isEmpty(text)) {
          continue;
        }
        cpt++;
        if (isUser) {
          listText.add(text);
          list.add({"role": "user", "content": text});
        } else {
          list.add({"role": "assistant", "content": text});
        }
        if (cpt >= maxLines) {
          break;
        }
      }
      list = list.reversed.toList();
    }

    list.add({"role": "user", "content": latestMessage});
    return list;
  }

  void onClickSendMsg(String value) async {
    if (TextUtil.isEmpty(value)) {
      Utility.showToast(context: context, msg: getI18NKey().comment_not_empty);
      return;
    }
    await createFolder(value);
    // Map lastParentId = getLastParentMessageId();
    this.isLoading2 = 0;
    ChatGptMessageModel chatGptMessageModel = ChatGptMessageModel();
    chatGptMessageModel.isUser = true;
    chatGptMessageModel.fid = _curChatGptFolderModel?.objectId;
    chatGptMessageModel.text = value;
    //更新标题
    this.updateFolderTitle(value);
    chatGptMessageModel.folder_objectId = this.folderIdForRightBar;
    chatGptMessageModel.fid = _curChatGptFolderModel?.objectId;
    chatGptMessageModel.username =
        LoginManager.getInstance().getUserBean().username;
    chatGptMessageModel.avatar =
        LoginManager.getInstance().getUserBean().avatar;
    chatGptMessageModel.uid = LoginManager.getInstance().getUserBean().uid;
    chatGptMessageModel.countryCode = DeviceInfoManagement.getCountryCode();
    this.isLoading2 = 1;
    updateUI();
    toBottom(); //滑动到底部
    // //发送gpt消息
    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertChatGptMessageModel(
            chatGptMessageModel: chatGptMessageModel, shouldUpdate: false);
    if (res?.objectId != null) {
      // this.folderId = res?.objectId ?? "";
      chatGptMessageModel?.folder_objectId = this.folderIdForRightBar;
    }
    this.isLoading2 = 0;
    updateUI();
    // // // String parentMessageIdParam = this.list.last.parentMessageId ?? "";
    this.isLoading2 = 2;
    // startCountdownTimer();
    ChatGptMessageModel? chatGptMessageModelGpt;
    try {
      chatGptMessageModelGpt = await ChatGptManager.getInstance().sendMessages(
        scene: curCheckButtonStateModel?.code,
          chatGptFolderModel: _curChatGptFolderModel,
        systemMessage:  CONSTANTS
            .getSystemMessage(this.widget.pageGPTFromEnum == PageGPTFromEnum.AIHelperPage ? "" : getI18NKey().gpt_role(getI18NKey().app_name)),
        messages: getChatMessageList(latestMessage: value),
      );
    } catch (e) {
      chatGptMessageModelGpt = this.chatGptMessageModelRedisCache;
      print(e);
    } finally {}
    handleFuncCallResult(chatGptMessageModelGpt);

    if (chatGptMessageModelGpt == null) {
      this.chatGptMessageModelRedisCache?.choicesFinishReason = "error";
      chatGptMessageModelGpt = this.chatGptMessageModelRedisCache;
    }
    chatGptMessageModelGpt?.folder_objectId = this.folderIdForRightBar;
    chatGptMessageModel.fid = _curChatGptFolderModel?.objectId;
    await MongoApisManager.getInstance()
        .insertChatGptMessageModel(chatGptMessageModel: chatGptMessageModelGpt);
    // this.chatGptMessageModelRedisCache = ChatGptMessageModel();
    // stopTimer();
    toBottom(); //滑动到底部
    this.isLoading2 = 0;
    updateUI();
  }

  /**
   * 如果是function_call的话就处理
   */
  void handleFuncCallResult(ChatGptMessageModel? chatGptMessageModelGpt) {
    if (chatGptMessageModelGpt?.chatModeEnum == ChatModeEnum.statistic.index) {
      ChatGptManager.getInstance()
          .openStatsPage(context, chatGptMessageModel: chatGptMessageModelGpt);
    } else if (chatGptMessageModelGpt?.chatModeEnum ==
        ChatModeEnum.create_missions.index) {
      ChatGptManager.getInstance()
          .showCreateMissionDialog(context, chatGptMessageModelGpt);
    }
  }
}
