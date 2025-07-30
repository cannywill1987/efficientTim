import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/GlobalStateEnv.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModelWithExtraData.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/date_util.dart';

import '../components/GPTHistorySectionTitleWidget.dart';

class GptChatHistoryPage extends BaseWidget {
  Function(ChatGptMessageModel) onTapListener;

  GptChatHistoryPage({required this.onTapListener});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return GptChatHistoryPageState();
  }
}

class GptChatHistoryPageState extends BaseWidgetState<GptChatHistoryPage> {
  List<ChatGptMessageModelWithExtraData> listChatGptMessageModelWithExtraData =
      [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void requestDatas({required List<ChatGptMessageModel> list}) {
    listChatGptMessageModelWithExtraData =
        Utility.filterChatGptMessageModelWithExtraData(list) ?? [];
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // listview实现历史列表
    // 1. 顶部是一个搜索框
    // 2. 下面是一个listview
    // 3. listview的item是一个container，里面有一个row，row里面有一个头像，一个column，column里面有一个row，row里面有一个text，一个text
    // 顶部一个圆角矩形的搜索框固定在顶部
    // customScrollView 里面有多个sliverList 每个sliverList间有个header 如 17 hours ago, 1 day ago

    return Selector<GlobalStateEnv, List<ChatGptMessageModel>>(
        selector: (_, env) => env.listChatGptMessageModel,
        builder: (_, listChatGptMessageModel, __) {
          // this.list = listChatGptMessageModel;
          requestDatas(list: listChatGptMessageModel);
          return Container(
              child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // 顶部搜索框 hint
              Container(
                height: 30,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: getI18NKey().hint_search_chat,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: getSliverList(),
                ),
              ),
            ],
          ));
        });
  }

  //获取sliverList, 每个item 左边一个symbol.chat 然后是只能显示一行的text,text超出会显示...
  List<Widget> getSliverList() {
    List<Widget> listWidgets = [];
    for (int i = 0; i < listChatGptMessageModelWithExtraData.length; i++) {
      ChatGptMessageModelWithExtraData item =
          listChatGptMessageModelWithExtraData[i];
      listWidgets.add(SliverToBoxAdapter(
          child: GPTHistorySectionTitleWidget(title: item.timeAgo)));
      listWidgets.add(SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
        ChatGptMessageModel chatGptMessageModel = item.list[index];
        return InkWell(
          onTap: () {
            widget.onTapListener.call(chatGptMessageModel);
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Icon(
                    Icons.chat_bubble,
                    size: 14,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  //最多50个字符
                  Text(
                    (chatGptMessageModel.folderTitle?? "").length > 20 ? (chatGptMessageModel.folderTitle ?? "").substring(0, 20) : (chatGptMessageModel.folderTitle ?? ""),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: ThemeManager.getInstance().getTextColor()),
                  ),
                ]),
                Text(
                  DateUtil.formatDateMs(chatGptMessageModel.updated_at ?? 0,
                      format: DateFormats.mo_d_h_m),
                  style: TextStyle(
                      fontSize: 14,
                      color: ThemeManager.getInstance().getTextColor()),
                ),
              ],
            ),
          ),
        );
      }, childCount: item.list.length)));
    }
    return listWidgets;
  }
}
