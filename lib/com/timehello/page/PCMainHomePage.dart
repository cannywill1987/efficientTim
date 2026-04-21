import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/pages/WQBFoldersPage/WQBFoldersPage.dart';
import 'package:time_hello/com/timehello/page/folderspage/NewFolderPage.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../components/PCTopMenuWidget.dart';
import '../config/ColorsConfig.dart';
import '../util/DeviceInfoManagement.dart';
import '../util/KeyboardListenerManager.dart';
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
    Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Keyboardlistenermanager.getInstance()?.removeListener(handleKeyEvent);
  }

  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.backquote) {
        Utility.toggleCurDesktopFolderPageVisibility(context);
      } else if (((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyF)) {
        DialogManagement.getInstance()?.showAISearchBarMenuWithoutText(
          context: context,
        );
        print("space");
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Env env = context.watch<Env>();
    // print("111111111111111111");
    // print(env.routerMainContainerData);
    // print("2222222222222222222222");
    // print(env.routerMainContainerData != null
    //     ? (env.routerMainContainerData?['page'] ?? "")
    //     : "");

    return Selector<Env, Map?>(
        selector: (_, env) => env.routerMainContainerData,
        builder: (_, routerMainContainerData, __) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              LeftSettingSide(),
              Expanded(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                Container(
                  decoration: BoxDecoration(
                      color: ColorsConfig.mineLeftRailBackground,
                      border: Border(
                          bottom: BorderSide(
                              color: ThemeManager.getInstance().getLineColor(
                                  defaultColor: Color(0xfff0f0f0)),
                              width: 1))),
                  child: PCTopMenuWidget(),
                ),
                Expanded(
                    child: getMainPage(routerMainContainerData != null
                        ? (routerMainContainerData?['page'] ?? "")
                        : ""))
              ]))
            ],
          );
        });
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
    double width = DeviceInfoManagement.getLanguage() == 'zh' ? 74 : 82;
    //页面来自MinePage
    return Container(
        width: width,
        decoration: BoxDecoration(
            border: ThemeManager.getInstance().isDark()
                ? Border(
                    right: BorderSide(
                        color: ThemeManager.getInstance().getLineColor()))
                : null),
        child: MinePage());
  }
}

class LeftSideFolderPage extends StatelessWidget {
  const LeftSideFolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<Env, bool>(
        selector: (_, env) => env.isFolderPageVisible,
        builder: (_, isFolderPageVisible, __) {
          if (!isFolderPageVisible) {
            return SizedBox();
          }
          return SizedBox(
              width: 350,
              child: Container(
                  decoration: ThemeManager.getInstance().isDark()
                      ? BoxDecoration(
                          color: sidebarColor,
                          border: Border(
                              right: BorderSide(
                                  color:
                                      ThemeManager.getInstance().getLineColor(),
                                  width: 1)))
                      : null,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              child: NewFolderPage(
                                onTapListener: (Map<dynamic, dynamic> obj) {},
                              ),
                              color: Colors.transparent)),
                      // WindowTitleBarBox(child: MoveWindow()),
                      // Expanded(child: Container())
                    ],
                  )));
        });
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
    // Env env = context.watch<Env>();
    return Selector<Env, Map?>(
        selector: (_, env) => env.routerMainContainerData,
        builder: (_, routerMainContainerData, __) {
          // return Selector<Env, int>(
          //     selector: (_, env) => env.isFolderPageVisible,
          //     builder: (_, isFolderPageVisible, __) {
          //       print(
          //           "MainContainerSide isFolderPageVisible $isFolderPageVisible");
          return desktopCenterRouter(
              routerMainContainerData != null
                  ? (routerMainContainerData?['page'])
                  : page,
              routerMainContainerData ?? {});
          // });
        });
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
    // Env env = context.watch<Env>();
    return Selector<Env, Map?>(
        selector: (_, globalStateEnv) => globalStateEnv.routerData,
        builder: (_, routerData, __) {
          return desktopCenterRouter(
              routerData != null ? (routerData?['page'] ?? "") : (page ?? ""),
              routerData ?? {});
        });
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
    // Env env = context.watch<Env>();
    return Selector<Env, Map?>(
        selector: (_, globalStateEnv) => globalStateEnv.routerRightSideData,
        builder: (_, routerRightSideData, __) {
          return desktopRightRouter(
              routerRightSideData != null
                  ? (routerRightSideData?['page'] ?? "")
                  : "",
              routerRightSideData ?? {});
        });
  }
}
