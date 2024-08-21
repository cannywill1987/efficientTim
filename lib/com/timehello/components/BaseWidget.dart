import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import '../util/EventCollection.dart';
import '../util/KeyboardListenerManager.dart';
import '../util/PrivacyProtocolManager.dart';
import '../util/ScreenUtil.dart';
import 'ResponsiveLayout.dart';

abstract class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  const BaseWidget({Key? key}) : super(key: key);

  @override
  BaseWidgetState createState() {
    return getState();
  }

  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with WidgetsBindingObserver {
  String? curPage;
  String tag = "BaseWidgetState_";
  bool isAppBarVisible = true; //只对移动端有效
  bool forceAppBarVisible = false; //不管移动端或者pc 可以强制设置这个让他显示
  double? screenWidth = 0;
  Widget? mobileBody;
  Widget? tabletBody;
  Widget? desktopbody;
  List<Widget>? leftNavChildren; //一定要用basebuild baseXXX才能起作用
  Widget? centerNavChild; //一定要用basebuild baseXXX才能起作用
  List<Widget>? rightNavChildren; //一定要用basebuild baseXXX才能起作用
  bool isNavBackBtnVisible = true; //一定要用basebuild baseXXX才能起作用
  // Widget? leftNavWidget; //左边导航栏图标
  BuildContext? mContext;
  bool shouldShowSafeArea = true; //默认显示
  //判断键盘是否显示
  StreamSubscription? keyboardSubscription;
  Color color = Colors.white;
  SafeArea? saveArea = null;
  String? title;
  Widget? baseBuildWidget;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DragStartBehavior drawerDirection = DragStartBehavior.down;

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    onCreate();
    AnalyticsEventsManager.getInstance()
        .sendAnalyticsEvent(name: "initState_${curPage}");
    EventCollection.onResume();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      componentDidMount();
    });
    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_GLOBAL_THEME) {
        setState(() {});
      }
    });
    tag = tag + curPage.toString() + "_";
    print(tag + "initState\n");
  }

  //相当于onResume 子类如果用了Initstate 一定要写super.initState();
  componentDidMount() {
    print(tag + "componentDidMount\n");
    AnalyticsEventsManager.getInstance()
        .sendAnalyticsEvent(name: "componentDidMount_${curPage}");
  }

  void onClick(type, data) async {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // TODO: 应用程序不可见，后台
      // The application is not currently visible to the user, not responding to
      // user input, and running in the background.
      // 不可见，不可操作
      print("paused");
    }
    if (state == AppLifecycleState.resumed) {
      //TODO: 应用程序可见，前台
      // The application is visible and responding to user input.
      // 可见，可操作
      print("resumed");
    }
    if (state == AppLifecycleState.inactive) {
      // TODO: 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
      // The application is in an inactive state and is not receiving user input.
      // 可见，不可操作
      print("inactive");
    }
    if (state == AppLifecycleState.detached) {
      //TODO: Handle this case.
      // The application is still hosted on a flutter engine but is detached from any host views.
      // 虽然还在运行，但已经没有任何存在的界面。
      print("detached");
    }
    if (state == AppLifecycleState.paused) {
      //  TODO: 应用程序不可见，后台
      // The application is still hosted on a flutter engine but is detached from any host views.
      // 虽然还在运行，但已经没有任何存在的界面。
      print("paused");
    }
  }

  @override
  void didChangeDependencies() {
    print(tag + "didChangeDependencies\n");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // this.context = context;
    Params.curContext = context;
    mContext = context;
    AppBar? appBar =
        (Utility.isHandsetBySize() == true && this.isAppBarVisible) ||
                forceAppBarVisible
            ? baseAppBar(context)
            : null;
    // print(
    //     "BaswWidget ${curPage} Build screenType: ${(screenType == ScreenType.Handset && this.isAppBarVisible) || forceAppBarVisible} appBar: ${appBar}");
    // if (curPage == "FoldersPage") {
    //   // print(1111111);
    // }
    // if(baseBuildWidget == null){
    baseBuildWidget = this.baseBuild(context);
    // }
    // baseBuildWidget = this.baseBuild(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: appBar,
        drawerDragStartBehavior: drawerDirection,
        drawer: baseDrawerBuild(context),
        endDrawer: baseEndDrawerBuild(context),
        body: getSafeArea(
          child: ResponsiveLayout(
            onResizeListener: (ScreenType screenType, BoxConstraints obj) {
              Future.delayed(Duration(seconds: 0), () {
                if (mounted == true) {
                  didOnSizeChangeWidget(screenType, obj);
                }
              });
            },
            onOSListener: (ScreenType screenType, BoxConstraints obj) {
              this.screenWidth = obj.maxWidth;
            },
            mobileBody: baseMobileBuild(context) ?? baseBuildWidget,
            tabletBody: baseTabletBuild(context) ??
                baseDesktoptBuild(context) ??
                baseBuildWidget,
            desktopbody: baseDesktoptBuild(context) ?? baseBuildWidget,
          ),
        ));
  }

  Widget getSafeArea({required Widget child}) {
    // ios 11 以上才有安全区域 且只有手机才有安全区域
    if ((Utility.isHandsetBySize() == true && shouldShowSafeArea == true) ||
        saveArea != null) {
      return saveArea = SafeArea(child: child);
    } else {
      return child;
    }
  }

  @override
  void didOnSizeChangeWidget(ScreenType screenType, BoxConstraints obj) {
    print(tag + "didUpdateWidget\n");
  }

  @override
  void didUpdateWidget(T oldWidget) {
    print(tag + "didUpdateWidget\n");
    super.didUpdateWidget(oldWidget);
    // Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
  }

  @override
  void reassemble() {
    print(tag + "reassemble\n");
    super.reassemble();
  }

  @override
  void deactivate() {
    print(tag + "deactivate\n");
    if (PrivacyProtocolManager.getInstance().isProtocolAgreed(context) ==
        true) {
      EventCollection.onStop();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    print(tag + "dispose\n");
    onDes();
    // Keyboardlistenermanager.getInstance()?.removeListener(handleKeyEvent);
    if (keyboardSubscription != null) {
      keyboardSubscription?.cancel();
      keyboardSubscription = null;
    }
    super.dispose();
  }

  void onCreate() {}

  Widget? baseDrawerBuild(BuildContext context) {
    return null;
  }

  Widget? baseEndDrawerBuild(BuildContext context) {
    return null;
  }

  baseBuild(BuildContext context) {}

  baseMobileBuild(BuildContext context) {}

  baseTabletBuild(BuildContext context) {}

  baseDesktoptBuild(BuildContext context) {}

  AppBar baseAppBar(BuildContext context) {
    return AppBar(
      leading: Container(
          width: 60,
          child:
              this.isNavBackBtnVisible == true && this.leftNavChildren == null
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ThemeManager.getInstance().getIconColor(),
                      ),
                      onPressed: () {
                        Utility.popNavigator(context);
                      },
                    )
                  : Row(children: this.leftNavChildren ?? [])),
      iconTheme: IconThemeData(
        color: ThemeManager.getInstance()
            .getColor(defaultColor: Colors.black), //修改颜色
      ),
      backgroundColor: ThemeManager.getInstance()
          .getNavigationBarColor(defaultColor: Colors.white),
      title: title != null
          ? Text(
              title ?? "",
              style: TextStyle(
                fontSize: 14,
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Color(0xff404040))),
            )
          : Container(
                  margin: EdgeInsets.only(right: 60),
                  alignment: Alignment.center,
                  child: centerNavChild) ??
              SizedBox.shrink(),
      // title: this.centerNavChildren == null
      //     ? SizedBox.shrink()
      //     : Row(children: this.centerNavChildren!),
      actions: this.rightNavChildren == null
          ? [SizedBox.shrink()]
          : this.rightNavChildren,
    );
  }

  void onDes() {}
}
