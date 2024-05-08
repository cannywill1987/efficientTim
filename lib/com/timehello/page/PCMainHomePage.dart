import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/pages/WQBFoldersPage/WQBFoldersPage.dart';
import 'package:time_hello/com/timehello/page/folderspage/FoldersPage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../components/PCTopMenuWidget.dart';
import '../util/DeviceInfoManagement.dart';
import '../util/OverlayManagement.dart';
import 'DesktopRouter.dart';
import 'MinePage/MinePage.dart';

PageStorageBucket pageStorageBucket = PageStorageBucket();

class PCMainHomePage extends BaseWidget {
  // static PageStorageKey pageStorageKey =  PageStorageKey<String>("key_Page2");
  @override
  PCMainHomePageState getState() {
    // TODO: implement createState
    return new PCMainHomePageState();
  }
}

const borderColor = Color(0xFF805306);

class PCMainHomePageState extends BaseWidgetState<PCMainHomePage> {
  componentDidMount() {
    OverlayManagement.getInstance()
        .openMissionDetailBottomCounterOverlay(context);
    print('componentDidMount');
  }

  void initState() {
    super.initState();
    print('initState');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Env env = context.watch<Env>();
    // print("111111111111111111");
    // print(env.routerMainContainerData);
    // print("2222222222222222222222");
    // print(env.routerMainContainerData != null
    //     ? (env.routerMainContainerData?['page'] ?? "")
    //     : "");

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        LeftSettingSide(),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            decoration: BoxDecoration(
                color: ThemeManager.getInstance().getNavigationBarColor(defaultColor: ThemeManager.getInstance().getLightDefaultThemeColor()),
                border: Border(
                    bottom: BorderSide(color: ThemeManager.getInstance().getLineColor(defaultColor: Color(0xfff0f0f0)), width: 1))),
            child: PCTopMenuWidget(),
          ),
          Expanded(
              child: getMainPage(env.routerMainContainerData != null
                  ? (env.routerMainContainerData?['page'] ?? "")
                  : ""))
        ]))
      ],
    );
  }
}

const sidebarColor = Color(0xFFF6A00C);

/**
 * lzb 左边的菜单栏 番茄钟 分析 日程 设置
 */
class LeftSettingSide extends StatelessWidget {
  const LeftSettingSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = DeviceInfoManagement.getLanguage() == 'zh' ? 55 : 80;
    //页面来自MinePage
    return Container(width: width, decoration: BoxDecoration(border:  ThemeManager.getInstance().isDark() ? Border(right:BorderSide(color: ThemeManager.getInstance().getLineColor())) : null), child: MinePage());
  }
}

class LeftSideFolderPage extends StatelessWidget {
  const LeftSideFolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 350,
        child: Container(
            decoration: ThemeManager.getInstance().isDark() ? BoxDecoration(
              color: sidebarColor,
                border: Border(
                    right: BorderSide(color: ThemeManager.getInstance().getLineColor(), width: 1))) : null,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        child: FoldersPage(
                          onTapListener: (Map<dynamic, dynamic> obj) {},
                        ),
                        color: Colors.white)),
                // WindowTitleBarBox(child: MoveWindow()),
                // Expanded(child: Container())
              ],
            )));
  }
}

class LeftSideWQBFolderPage extends StatelessWidget {
  const LeftSideWQBFolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 350,
        child: Container(
            color: sidebarColor,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        child: WQBFoldersPage(
                          onTapItemListener: () {},
                        ),
                        color: Colors.white)),
                // WindowTitleBarBox(child: MoveWindow()),
                // Expanded(child: Container())
              ],
            )));
  }
}

class MainContainerSide extends StatelessWidget {
  String? page;

  MainContainerSide({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Env env = context.watch<Env>();
    return desktopCenterRouter(
        env.routerMainContainerData != null
            ? (env.routerMainContainerData?['page'])
            : page,
        env.routerMainContainerData ?? {});
  }
}

/**
 * 用于pc端首页tomato
 */
class FolderPageMainContainer extends StatelessWidget {
  final String page;

  const FolderPageMainContainer({required this.page});

  @override
  Widget build(BuildContext context) {
    Env env = context.watch<Env>();
    return desktopCenterRouter(
        env.routerData != null ? (env.routerData?['page'] ?? "") : (page ?? ""),
        env.routerData ?? {});
  }
}

/**
 * SettingItemDetailPage用得上
 * 包含了创建页面 任务页面
 */
class RightSide extends StatelessWidget {
  const RightSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Env env = context.watch<Env>();
    return desktopRightRouter(
        env.routerRightSideData != null
            ? (env.routerRightSideData?['page'] ?? "")
            : "",
        env.routerRightSideData ?? {});
  }
}
