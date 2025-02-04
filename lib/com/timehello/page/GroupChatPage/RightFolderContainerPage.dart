import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/GroupChatPage.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupAnnouncement.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupChatFriendsList.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupInfoPage.dart';
import 'package:time_hello/com/timehello/page/TimeLinePage/TimeLinePage.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/ChatGptManager.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../beans/UserInfoBean.dart';
import '../../components/CustomTabBarWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../models/FolderModel.dart';

class RightFolderContainerPage extends BaseWidget {
  const RightFolderContainerPage({Key? key}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _GroupChatPageState();
  }
}

class _GroupChatPageState extends BaseWidgetState<RightFolderContainerPage> {
  FolderModel? folderModel;
  String? curSearchWords = null;
  int curTab = 0;
  List<CheckButtonStateModel> tabList = CONSTANTS.getFolderTabBarSetting();

  @override
  Widget baseBuild(BuildContext context) {
    return Selector<Env, FolderModel>(
        selector: (_, globalStateEnv) => globalStateEnv.curFolderSelected,
        builder: (_, folderModel, __) {
          this.folderModel = folderModel;
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTabBarWidget(
                checkIndex: curTab,
                list: tabList,
                onCheckedListener: (int index, CheckButtonStateModel model) {
                  this.curTab = index;
                  updateUI();
                },
                fontSize: 14,
              ),
              Expanded(
                  child: this.curTab == 0
                      ? GroupChatPage()
                      : TimeLinePage(
                          key: ValueKey("jezifzjifew"),
                          timelinePageFromEnum:
                              TimelinePageFromEnum.ObjectivePage.index, folderObjectId: folderModel.objectId ?? "",))
            ],
          );
        });
  }
}
