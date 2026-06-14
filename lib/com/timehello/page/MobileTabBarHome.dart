import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/TimeContainerPage/TimeContainerPage.dart';
import 'package:time_hello/com/timehello/page/statisticPage/StatisticPage.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../common/provider/Env.dart';
import 'MinePage/MinePage.dart';
import 'MobileMissionContainerPage/MobileMissionContainerPage.dart';
import 'calendarPage/CalendarContainerPage.dart';

PageStorageBucket pageStorageBucket = PageStorageBucket();

class MobileTabBarHome extends BaseWidget {
  // static PageStorageKey pageStorageKey =  PageStorageKey<String>("key_Page2");
  @override
  BottomTabBarHomeState getState() {
    // TODO: implement createState
    return new BottomTabBarHomeState();
  }
}

class BottomTabBarHomeState extends BaseWidgetState<MobileTabBarHome> {
  // body展示的数据
  Widget buildBodyFunction(int _selectedIndex) {
    ///帧布局结合透明布局
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _selectedIndex == 0 ? false : true,
          child: const MobileMissionContainerPage(
              key: ValueKey("ejifejif")), // 任务页面
          // child: FoldersPage(key: PageStorageKey<String>("key_FoldersPage")),
        ),
        Offstage(
          offstage: _selectedIndex == 1 ? false : true,
          child: const StatisticPage(), // 数据页面
        ),
        Offstage(
            offstage: _selectedIndex == 2 ? false : true,
            // child: GamesPage(key: PageStorageKey<String>("key_GamesPage")),
            child: const TimeContainerPage(title: "")), // 时间页面
        Offstage(
          offstage: _selectedIndex == 3 ? false : true,
          child: const CalendarContainerPage(title: ""), //日历容器页面
        ),
        Offstage(
          offstage: _selectedIndex == 4 ? false : true,
          child: const MinePage(), // 我的页面
        ),
      ],
    );
  }

  componentDidMount() {
    OverlayManagement.getInstance()
        .openMissionDetailBottomCounterOverlay(context);
    print('componentDidMount');
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    // TODO: implement build
    Env env = context.watch<Env>();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        //4个tabpage的appbar
        // appBar: AppBar(
        //   title: new Text(getI18NKey().app_name, style: TextStyle(color: Colors.transparent),),
        //   iconTheme: IconThemeData(
        //     color: Colors.black, //修改颜色
        //   ),
        //   backgroundColor: Colors.white,
        // ),
        // 底部导航统一复用 BaseWidget 中的胶囊组件，避免首页单独维护一套视觉逻辑。
        bottomNavigationBar: BaseFloatingNavigationBar(
          activeColor:
              Color(SharePreferenceUtil.getSyncInstance().getCommonColor()),
          inactiveColor: ThemeManager.getInstance().getIconColor(),
          currentIndex: env.curMobileTab,
          onTap: (index) {
            context.read<Env>().curMobileTab = index;
          },
          items: [
            BaseFloatingNavigationItem(
              activeIcon: Utility.getSVGPicture(R.assetsImgIcTab1Selected,
                  size: iconSize),
              icon: Utility.getSVGPicture(R.assetsImgIcTab1Unselected,
                  size: iconSize,
                  color: ThemeManager.getInstance().getIconColor()),
              label: getI18NKey().tomatoClock,
            ),
            BaseFloatingNavigationItem(
              activeIcon: Utility.getSVGPicture(R.assetsImgIcTab2Selected,
                  size: iconSize),
              icon: Utility.getSVGPicture(R.assetsImgIcTab2Unselected,
                  size: iconSize,
                  color: ThemeManager.getInstance().getIconColor()),
              label: getI18NKey().curAnalytics,
            ),
            BaseFloatingNavigationItem(
              activeIcon: Utility.getSVGPicture(R.assetsImgIcTab3Selected,
                  size: iconSize),
              icon: Utility.getSVGPicture(R.assetsImgIcTab3Selected,
                  size: iconSize),
              label: getI18NKey().four_quadrant,
            ),
            BaseFloatingNavigationItem(
              activeIcon: Utility.getSVGPicture(R.assetsImgIcTab4Selected,
                  size: iconSize),
              icon: Utility.getSVGPicture(R.assetsImgIcTab4Unselected,
                  size: iconSize,
                  color: ThemeManager.getInstance().getIconColor()),
              label: Utility.isHandsetBySize() == true
                  ? getI18NKey().calendar
                  : getI18NKey().schedule,
            ),
            BaseFloatingNavigationItem(
              activeIcon: Utility.getSVGPicture(R.assetsImgIcTab5Selected,
                  size: iconSize),
              icon: Utility.getSVGPicture(R.assetsImgIcTab5Unselected,
                  size: iconSize,
                  color: ThemeManager.getInstance().getIconColor()),
              label: getI18NKey().mine,
            ),
          ],
        ),
        body: PageStorage(
          child: buildBodyFunction(env.curMobileTab),
          bucket: pageStorageBucket,
        ),
      ),
    );
  }
}
