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
    final bool isDark = ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
    final Color panelBackground = isDark
        ? const Color(0xFF1F1915)
        : const Color(0xFFFDF7EE).withValues(alpha: 0.96);
    final Color panelBorder =
        isDark ? const Color(0xFF443931) : const Color(0xFFEBDCCB);
    return Selector<Env, FolderModel>(
        selector: (_, globalStateEnv) => globalStateEnv.curFolderSelected,
        builder: (_, folderModel, __) {
          this.folderModel = folderModel;
          return Container(
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              color: panelBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: panelBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: CustomTabBarWidget(
                      checkIndex: curTab,
                      list: tabList,
                      onCheckedListener:
                          (int index, CheckButtonStateModel model) {
                        this.curTab = index;
                        updateUI();
                      },
                      fontSize: 13,
                      useUnifiedStyle: true,
                    ),
                  ),
                  Expanded(
                      child: this.curTab == 0
                          ? GroupChatPage()
                          : TimeLinePage(
                              key: ValueKey("jezifzjifew"),
                              timelinePageFromEnum:
                                  TimelinePageFromEnum.ObjectivePage.index,
                              folderObjectId: folderModel.objectId ?? "",
                            ))
                ],
              ),
            ),
          );
        });
  }
}
