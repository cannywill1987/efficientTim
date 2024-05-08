import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/models/CommentModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/ChatCreateMissionItem.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/ChatStatisticItem.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/ChatTextItem.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';

class ChatGptListView extends StatefulWidget {
  List<ChatGptMessageModel> datas;
  int isLoading = 0; //0 - 没有Loading  1 - loading 用户消息 2 - loading gpt消息
  Function? onTapSendAgainListener;
  Function(ChatGptMessageModel)? onTapStatisticListener;
  Function(ChatGptMessageModel)? onTapCreateMissionListener;

  ChatGptMessageModel? chatGptMessageModelChatGptRedisCache;

  ChatGptListView(
      {Key? key,
      required this.onTapStatisticListener,
        required this.onTapCreateMissionListener,
      this.onTapSendAgainListener,
      this.chatGptMessageModelChatGptRedisCache,
      required this.datas,
      required this.isLoading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatGptListViewState();
  }
}

class ChatGptListViewState extends State<ChatGptListView> {
  ScrollController _scrollController = ScrollController();

  toBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // List list = CONSTANTS.getCommentModelsList(datas!);
    print(
        "isLoading: ${this.widget.isLoading}， length: ${this.widget.isLoading == 0 ? (this.widget.datas?.length ?? 0) : (this.widget.datas?.length ?? 0 + 1)}");
    return SelectionArea(
      child: new ListView.builder(
        controller: _scrollController,
        itemCount: this.widget.isLoading == 0
            ? (this.widget.datas?.length ?? 0)
            : ((this.widget.datas?.length ?? 0) + 1),
        padding: EdgeInsets.only(top: 10),
        //整个listview的top bottom margin
        itemBuilder: (context, int index) {
          if (index < (this.widget.datas?.length ?? 0)) {
            return ChatGptListViewItem(
              isLoading: 0,
              onTapSendAgainListener: this.widget.onTapSendAgainListener,
              onTapCreateMissionListener: (chatMessageModel) {
                this.widget.onTapCreateMissionListener?.call(chatMessageModel);
              },
              chatGptMessageModelChatGptRedisCache:
                  this.widget.chatGptMessageModelChatGptRedisCache,
              chatGptMessageModel: this.widget.datas[index],
              onTapStatisticListener: (ChatGptMessageModel) {
                this.widget.onTapStatisticListener?.call(ChatGptMessageModel);
              },
            );
          } else {
            ChatGptMessageModel model = ChatGptMessageModel();
            model.username = this.widget.isLoading == 1
                ? LoginManager.getInstance().userBean.username
                : getI18NKey().chatgpt;
            model.avatar = this.widget.isLoading == 1
                ? LoginManager.getInstance().userBean.avatar
                : "";
            model.isUser = this.widget.isLoading == 1 ? true : false;
            return ChatGptListViewItem(
              isLoading: this.widget.isLoading,
              onTapStatisticListener: (chatMessageModel) {
                this.widget.onTapStatisticListener?.call(chatMessageModel);
              },
              onTapCreateMissionListener: (chatMessageModel) {
                this.widget.onTapCreateMissionListener?.call(chatMessageModel);
              },
              onTapSendAgainListener: this.widget.onTapSendAgainListener,
              chatGptMessageModelChatGptRedisCache:
                  this.widget.chatGptMessageModelChatGptRedisCache,
              chatGptMessageModel: model,
            );
          }
        },
      ),
    );
  }
}

class ChatGptListViewItem extends StatelessWidget {
  int isLoading = 0;
  ChatGptMessageModel chatGptMessageModel;
  ChatGptMessageModel? chatGptMessageModelChatGptRedisCache;
  bool enableInteractiveSelection = true;
  Function? onTapSendAgainListener;
  Function(ChatGptMessageModel) onTapStatisticListener;
  Function(ChatGptMessageModel)? onTapCreateMissionListener;

  ChatGptListViewItem(
      {required this.isLoading,
      required this.onTapStatisticListener,
        this.onTapCreateMissionListener,
      required this.chatGptMessageModel,
      this.chatGptMessageModelChatGptRedisCache,
      this.onTapSendAgainListener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (isLoading == 2) {
      print(" ");
    }
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15),
      color: this.chatGptMessageModel.isUser == true
          ? ThemeManager.getInstance()
              .getBackgroundColor(defaultColor: Colors.white)
          : ThemeManager.getInstance().getBackgroundColor(
              defaultDarkColor: Color(0xff303030),
              defaultColor: Color(0xfff3f3f3)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // this.chatGptMessageModel.username ?? ""
                    (this.chatGptMessageModel?.isUser ?? true)
                        ? getI18NKey().me
                        : "",
                    style: TextStyle(fontSize: 12, color: Color(0xffff8800)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  getWidget(),
                ],
              ),
            ),
            // getResponse(content: this.commentModel.content),
          ],
        ),
        // getResponse(chatGptMessageModel: this.chatGptMessageModel),
      ]),
    );
  }

  Widget getWidget() {
    ChatModeEnum chatModeEnum =
        ChatModeEnum.values[this.chatGptMessageModel?.chatModeEnum ?? 0];
    if(chatModeEnum == ChatModeEnum.create_missions) {
      return ChatCreateMissionItem(
        isLoading: this.isLoading,
        chatGptMessageModel: this.chatGptMessageModel,
        chatGptMessageModelChatGptRedisCache:
        this.chatGptMessageModelChatGptRedisCache,
        onTapCreateMissionListener: (data) {
          this.onTapCreateMissionListener?.call(data);
        },
        onTapSendAgainListener: (data) {
          if (this.onTapSendAgainListener != null) {
            this.onTapSendAgainListener?.call(data);
          }
        },
        isUser: this.chatGptMessageModel.isUser ?? true,
        text: this.chatGptMessageModel.text ?? "",
      );
    } else if (chatModeEnum == ChatModeEnum.statistic) {
      return ChatStatisticItem(
        isLoading: this.isLoading,
        chatGptMessageModel: this.chatGptMessageModel,
        chatGptMessageModelChatGptRedisCache:
            this.chatGptMessageModelChatGptRedisCache,
        onTapStatisticListener: (data) {
          this.onTapStatisticListener?.call(data);
        },
        onTapSendAgainListener: (data) {
          if (this.onTapSendAgainListener != null) {
            this.onTapSendAgainListener?.call(data);
          }
        },
        isUser: this.chatGptMessageModel.isUser ?? true,
        text: this.chatGptMessageModel.text ?? "",
      );
    } else {
      return ChatTextItem(
        isLoading: this.isLoading,
        chatGptMessageModel: this.chatGptMessageModel,
        chatGptMessageModelChatGptRedisCache:
            this.chatGptMessageModelChatGptRedisCache,
        onTapSendAgainListener: (data) {
          if (this.onTapSendAgainListener != null) {
            this.onTapSendAgainListener?.call(data);
          }
        },
        isUser: this.chatGptMessageModel.isUser ?? true,
        text: this.chatGptMessageModel.text ?? "",
      );
    }
  }
}
