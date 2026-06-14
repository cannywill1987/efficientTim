/**
 * 文件类型：基础组件
 * 文件作用：为项目内页面提供统一 Scaffold、响应式布局、移动端导航栏和通用生命周期入口。
 * 主要职责：保持旧页面默认行为不变，同时允许新页面按需配置更现代的移动端顶部/底部导航。
 */

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

/**
 * 功能：描述移动端顶部导航栏的可配置内容。
 * 说明：默认不启用，子页面只有主动赋值给 BaseWidgetState.mobileNavigationConfig 才会替换旧 AppBar。
 */
class BaseMobileNavigationConfig {
  final Widget? leading;
  final Widget? logo;
  final Widget? titleWidget;
  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final double toolbarHeight;
  final double leadingWidth;
  final double logoSize;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry actionsPadding;
  final SystemUiOverlayStyle systemOverlayStyle;

  const BaseMobileNavigationConfig({
    this.leading,
    this.logo,
    this.titleWidget,
    this.title,
    this.subtitle,
    this.actions = const <Widget>[],
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xFF1F1F1F),
    this.subtitleColor = const Color(0xFF8C8C8C),
    this.toolbarHeight = 86,
    this.leadingWidth = 72,
    this.logoSize = 34,
    this.titlePadding = const EdgeInsets.only(left: 2),
    this.actionsPadding = const EdgeInsets.only(right: 14),
    this.systemOverlayStyle = SystemUiOverlayStyle.dark,
  });

  /**
   * 功能：根据公共配置生成 AppBar。
   * 说明：defaultLeading/defaultActions 来自 BaseWidget 旧字段，保证未显式配置时仍能沿用页面原来的按钮。
   */
  AppBar buildAppBar(
    BuildContext context, {
    required Widget defaultLeading,
    required List<Widget> defaultActions,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      titleSpacing: 0,
      centerTitle: false,
      leading: leading ?? defaultLeading,
      title: Padding(
        padding: titlePadding,
        child: titleWidget ??
            BaseMobileNavigationTitle(
              logo: logo,
              title: title ?? '',
              subtitle: subtitle,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              logoSize: logoSize,
            ),
      ),
      actions: <Widget>[
        Padding(
          padding: actionsPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions.isEmpty ? defaultActions : actions,
          ),
        ),
      ],
    );
  }
}

/**
 * 功能：移动端顶部导航栏标题区，负责展示 logo、标题和副标题。
 */
class BaseMobileNavigationTitle extends StatelessWidget {
  final Widget? logo;
  final String title;
  final String? subtitle;
  final Color titleColor;
  final Color subtitleColor;
  final double logoSize;

  const BaseMobileNavigationTitle({
    Key? key,
    this.logo,
    required this.title,
    this.subtitle,
    this.titleColor = const Color(0xFF1F1F1F),
    this.subtitleColor = const Color(0xFF8C8C8C),
    this.logoSize = 34,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logo != null) ...[
          SizedBox(width: logoSize, height: logoSize, child: logo),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5),
                Text(
                  subtitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    height: 1.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/**
 * 功能：描述公共胶囊底部导航栏的单个入口。
 */
class BaseFloatingNavigationItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;

  const BaseFloatingNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/**
 * 功能：移动端底部胶囊导航栏。
 * 说明：作为独立子组件放在 BaseWidget 中，页面可按需引用，避免直接影响现有 BottomNavigationBar 页面。
 */
class BaseFloatingNavigationBar extends StatelessWidget {
  final List<BaseFloatingNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final EdgeInsetsGeometry margin;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const BaseFloatingNavigationBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.activeColor = const Color(0xFFFF7800),
    this.inactiveColor = const Color(0xFF6F6F6F),
    this.backgroundColor = Colors.white,
    this.selectedBackgroundColor = Colors.white,
    this.margin = const EdgeInsets.fromLTRB(18, 0, 18, 6),
    this.height = 74,
    this.borderRadius = const BorderRadius.all(Radius.circular(34)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: height,
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: List<Widget>.generate(items.length, (int index) {
            final BaseFloatingNavigationItem item = items[index];
            final bool isSelected = index == currentIndex;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  onTap(index);
                },
                child: AnimatedContainer(
                  key: isSelected
                      ? ValueKey<String>('base_floating_nav_selected_$index')
                      : null,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBackgroundColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : const [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: isSelected ? activeColor : inactiveColor,
                          size: isSelected ? 30 : 26,
                        ),
                        child: isSelected ? item.activeIcon : item.icon,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? activeColor : inactiveColor,
                          fontSize: 12,
                          height: 1,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

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
  BaseMobileNavigationConfig? mobileNavigationConfig; // 仅移动端启用的新版顶部导航配置。
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
    // tag = tag + curPage.toString() + "_";
    // print(tag + "initState\n");
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
    final Widget defaultLeading = Container(
        width: 60,
        child: this.isNavBackBtnVisible == true && this.leftNavChildren == null
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ThemeManager.getInstance().getIconColor(),
                ),
                onPressed: () {
                  Utility.popNavigator(context);
                },
              )
            : Row(children: this.leftNavChildren ?? []));
    if (Utility.isHandsetBySize() == true && mobileNavigationConfig != null) {
      return mobileNavigationConfig!.buildAppBar(
        context,
        defaultLeading: defaultLeading,
        defaultActions: this.rightNavChildren ?? <Widget>[SizedBox.shrink()],
      );
    }
    return AppBar(
      leading: defaultLeading,
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
