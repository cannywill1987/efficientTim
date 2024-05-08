import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/PCSettingTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/SectionHeaderWidget.dart';
import 'package:time_hello/com/timehello/components/SelectMinutesDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectMusicDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SettingMenuItem.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/page/CreateShareFolderPage/CreateShareFolderPage.dart';
import 'package:time_hello/com/timehello/page/FeedbackPage/FeedbackPage.dart';
import 'package:time_hello/com/timehello/page/SettingPage/PCSettingContainerPage.dart';
import 'package:time_hello/com/timehello/page/SettingPage/SettingPermissionPage.dart';
import 'package:time_hello/com/timehello/page/SettingPage/pages/TomatoesSettingPage.dart';
import 'package:time_hello/com/timehello/page/ThemePage/ThemePage.dart';
import 'package:time_hello/com/timehello/util/AudioPlayUtil.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/PermissionManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../beans/ResourceLocationInfoBean.dart';
import '../../components/SelectMoneySettingDialogUtil.dart';
import '../../components/SelectPresentDialogUtil.dart';
import '../../config/ENUMS.dart';
import '../../util/CounterManagement.dart';
import '../../util/GetResourceDeliveryManager.dart';
import '../../util/OverlayManagement.dart';
import '../PrivacySettingPage/PrivacySettingPage.dart';
import 'components/PCAccountWidget.dart';

/**
 * 设置页面
 */
class SettingPage extends BaseWidget {
  final PageFromEnum pageFrom;

  const SettingPage({required this.pageFrom});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SettingPageWidgetState();
  }
}

class _SettingPageWidgetState<T> extends BaseWidgetState<SettingPage> {

  String tabBarSceneCode = ''; // PC端设置页面点击番茄钟或者账号tab时来回切换

  bool isNotificationOn = false;

  _SettingPageWidgetState() {}

  @override
  void onCreate() {
    super.onCreate();
    curPage = "SettingPage";
  }

  @override
  void initState() {
  }

  @override
  void didUpdateWidget(SettingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onClick(type, data) async {
    switch (type) {
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {}

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                child: TomatoesSettingPage())),
      ],
    );
  }

  Widget baseDesktoptBuild(BuildContext context) {
    return Column(
      children: [
        PCSettingTabBarWidget(
          list: CONSTANTS.getPCSettingButtonList(),
          onTapListener: (data) {
            CheckButtonStateModel checkButtonStateModel = data['data'];
            this.tabBarSceneCode = checkButtonStateModel.code ?? "";
            this.updateUI();
          },
        ),
        Container(
          height: 1,
          color: ThemeManager.getInstance()
              .getLineColor(defaultColor: ColorsConfig.dividerLine),
        ),
        Expanded(
            child: this.tabBarSceneCode == 'theme'
                ? ThemePage()
                : this.tabBarSceneCode == 'privacy'
                    ? PrivacySettingPage()
                    : this.tabBarSceneCode == 'permission'
                        ? Container(height: 200, child: SettingPermissionPage())
                        : this.tabBarSceneCode == 'feedback'
                            ? FeedbackPage()
                            : this.tabBarSceneCode == 'account' ? SingleChildScrollView(
                                // PC端设置页面点击番茄钟或者账号tab时来回切换
                                child:
                                    PCAccountWidget()
                                    ) : PCSettingContainerPage()),
        Utility.isHandsetBySize() || !LoginManager.isLogin()
            ? SizedBox.shrink()
            : Container(
                //PC才显示退出登录
                child: getLogoutItem(onTapListener: () {
                  LoginManager.getInstance().logout(context);
                }),
              )
      ],
    );
  }



  Widget getLogoutItem({Function? onTapListener}) {
    return InkWell(
      onTap: () {
        if (onTapListener != null) {
          onTapListener();
        }
      },
      child: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              getI18NKey().logout,
              style: TextStyle(color: Colors.red),
            ),
          )),
    );
  }
}
