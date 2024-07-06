import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/SettingModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/ChatGptPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/GPTContainer.dart';
import 'package:time_hello/com/timehello/page/CountDownListViewPage/CountDownListViewPage.dart';
import 'package:time_hello/com/timehello/page/CoursePage/CoursePage.dart';
import 'package:time_hello/com/timehello/page/CreditCardManagementPage/pages/CreditCardContainer.dart';
import 'package:time_hello/com/timehello/page/FourQuadrant/FourQuadrantContainer.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/GroupChatPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/CalendarPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/TimeManagementContainer.dart';
import 'package:time_hello/com/timehello/page/gamesPage/GamesPage.dart';
import 'package:time_hello/com/timehello/page/statisticPage/StatisticPage.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../util/AnalyticsEventsManager.dart';
import 'CreditCardManagementPage/pages/CreditCardPage.dart';
import 'FlomoPage/FlomoPCContainerPage.dart';
import 'FourQuadrant/FourQuadrantPage.dart';
import 'LockScreenPage/LockScreenPage.dart';
import 'PCMainHomePage.dart';
import 'SettingItemDetailPage/SettingItemDetailPage.dart';
import 'SettingPage/SettingPage.dart';
import 'TimeLinePage/TimeLinePage.dart';
import 'WrongQuestionBookPage/WQBContainer.dart';
import 'WrongQuestionBookPage/WrongQuestionBookPage.dart';
import 'calendarPage/TimeManagementPage.dart';
import 'createFolderPage/CreateFolderPage.dart';
import 'missionPage/MissionContainerPage.dart';
import 'missionPage/MissionPage.dart';

getMainPage([String? page]) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(child: buildBodyFunction(page)),
      Container(
        height: double.infinity,
        width: 2,
        color: Color(0xff3d8f8),
      ),
      RightSide()
    ],
  );
}

// getMainTomatoPage(String page) {
//   return Row(
//     mainAxisSize: MainAxisSize.max,
//     children: [
//       FolderPageMainContainer(page: page,),
//       // Container(height: double.infinity, width: 2, color: Color(0xff3d8f8),),
//       // RightSide()
//     ],
//   );
// }

Widget getListWithLeftSideWidget(Widget child) {
  return Row(
    children: [
      LeftSideFolderPage(),
      Expanded(child: child),
    ],
  );
}

Widget buildBodyFunction([String? page]) {
  // return FolderPageMainContainer(page: 'TomatoPage',);
  //第一次进来默认是null 默认就设置成是首页 TomatoPage
  if (TextUtil.isEmpty(page)) page = "TomatoPage";
  // int i = 0;
  ///帧布局结合透明布局
  return Selector<Env, SettingModel>(
      selector: (_, env) => env.settingModel ?? SettingModel(),
      builder: (_, settingModel, __) {
        reportEvent(page);
        // i++;
        return Stack(
          children: <Widget>[
            settingModel.isStatisticPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'StatisticPage'),
                child: const StatisticPage()),
            //统计页面
            settingModel.isWQBContainerOn != 1 ? SizedBox.shrink() : Offstage(
                offstage: !(page == 'WQBContainer'),
                child: const WQBContainer()),
            //错题本容器

            settingModel.isCountDownListViewPageOn != 1 ? SizedBox.shrink() :!(page == 'CountDownListViewPage')
                ? SizedBox.shrink()
                : const CountDownListViewPage(
                    pageFromEnum: PageFromEnum.Normal),
            //倒计时
            settingModel.isTomatoPageOn != 1 ? SizedBox.shrink() : Offstage(
                offstage: !(page == 'TomatoPage'),
                child: const FolderPageMainContainer(
                  page: 'TomatoPage',
                )),
            //番茄页面
            settingModel.isClockInPCPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'ClockInPCPage'),
                child: const FlomoPCContainerPage()),
            //打卡页面
            settingModel.isCalendarContainerPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'CalendarContainerPage'),
                child: CalendarPage(key: ValueKey("12dzdeaf"))),
            //日历页面
            settingModel.isFourQuadrantPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'FourQuadrantPage'),
                child: const FourQuadrantContainer()),

            settingModel.isAIHelperPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'AIHelper'),
                child: const GPTContainer()),
            //四象限页面
            settingModel.isTimelinePageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'TimelinePage'),
                child: const TimeLinePage(
                  key: ValueKey("vezfaf"),
                  timelinePageFromEnum: 0,
                )),
            //时间线页面
            // Offstage(offstage: !(page=='TimeManagementPage'),child: TimeManagementPage(key: ValueKey("12dzd"), onRefresh: (){},)), //时间管理页面
            settingModel.isTimeManagementPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'TimeManagementPage'),
                child: TimeManagementContainer(
                  key: ValueKey("12dz32d"),
                )),
            //时间管理页面

            !(page == 'CoursePage') ? SizedBox.shrink() : const CoursePage(),
            //课程页面
            settingModel.isGamePageOn != 1 ? SizedBox.shrink() :!(page == 'GamePage') ? SizedBox.shrink() : const GamesPage(),
            //游戏页面

            // Offstage(offstage: !(page=='CoursePage'),child: const CoursePage()), //课程页面
            // Offstage(offstage: !(page=='ChatGptPage'),child: const ChatGptPage()), //gpt聊天页面
            // !(page=='CreditCardPage') ? SizedBox.shrink() : const CreditCardContainer(), //信用卡页面

            settingModel.isLockScreenPageOn != 1 ? SizedBox.shrink() :Offstage(
                offstage: !(page == 'LockScreenPage'),
                child: const LockScreenPage()),
            // Offstage(offstage: !(page=='CalendarPage'),child: Container()),
            settingModel.isSettingPageOn != 1 ? SizedBox.shrink() :Offstage(

                offstage: !(page == 'SettingPage'),
                child: const SettingPage(
                  pageFrom: PageFromEnum.Normal,
                )),
            //设置页面
            // Offstage(offstage: !(page=='GamePage'),child: const GamesPage()), //游戏页面
          ],
        );
      });
}

void reportEvent(String? page) {
   switch (page) {
    case "StatisticPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_analysis","description": "分析",});
      break;
    case "WQBContainer":
      break;
    case "TomatoPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_focus_god","description": "番茄钟",});
      break;
    case "ClockInPCPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_punch_card","description": "打卡",});
      break;
    case "CalendarContainerPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_calendar","description": "日历",});
      break;
    case "FourQuadrantPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_four_quadrants","description": "四象限",});
      break;
    case "AIHelper":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_ai_assistant","description": "AI助手",});
      break;
    case "TimelinePage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_timeline","description": "时间轴",});
      break;
    case "TimeManagementPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_time_management","description": "时间管理",});
      break;
    case "CoursePage":
      break;
    case "GamePage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_training","description": "训练",});
      break;
    case "LockScreenPage":
      break;
    case "SettingPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_settings","description": "设置",});
      break;
    case "CountDownListViewPage":
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "pc_left_menu_bar","eventType": "pc_left_menu_bar_reversal_timing","description": "倒计时",});
      break;
  }
}

//
// Widget getPCCenterWidget(page) {
//   switch(page) {
//     default:
//       return ;
//   }
// }

// Widget desktopMainContainerRouter(String page, Map data){
//   // return buildBodyFunction(page);
//   switch(page) {
//     case 'StatisticPage':
//       return StatisticPage();
//     case 'TomatoPage':
//       return getMain();
//     case 'CalendarPage':
//       return CalendarPage();
//       // return Container();
//     case 'SettingPage':
//       return SettingPage();
//     case 'GamePage':
//       return GamesPage();
//     default:
//       return getMain();
//   }
// }

/**
 * PC 中间主内容区 包含了创建页面 任务页面
 */
Widget desktopCenterRouter(String page, Map data) {
  switch (page) {
    case 'CreateFolderPage':
      return getListWithLeftSideWidget(CreateFolderPage(
          folderModel: data['folderModel'],
          pageEnum: data['PageEnum'],
          folderModelForFolder: data['folderModelForFolder']));
    case 'MissionPage':
      return getListWithLeftSideWidget(MissionContainerPage(
          key: ValueKey('MissionPage213'),
          folderModel: data['data'],
          folderStatusDate: data['folderStatus']));
    // case 'WrongQuestionBookPage':
    //   return getListWithLeftSideWidget(WrongQuestionBookPage(key: ValueKey('MissionPage21312'), wqbMissionModel: WQBMissionModel(), saveModeEnum: SaveModeEnum.normal,));
    // case 'MissionPage':
    //   return getListWithLeftSideWidget(MissionPage(folderModel: data['data'], folderStatus: data['folderStatus']));
    // case 'CalendarPage':
    //   return Expanded(child: CalendarPage());
    // CreateFolderPage(folderModel: data['data'], folderStatus: data['folderStatus']);

    default:
      return getListWithLeftSideWidget(MissionContainerPage(
          key: ValueKey('MissionPage2131'),
          folderModel: CONSTANTS.getTodayFolderModel(),
          folderStatusDate: 1));
  }
}

/**
 * PC 右侧区域路由配置
 */
Widget desktopRightRouter(String page, Map data) {
  // 得到屏幕宽度
  double width  = 300;
  double screenWidth = MediaQuery.of(Utility.getGlobalContext()).size.width;
  print("screenWidth: $screenWidth");
  double minScreenWidth = 600;
  double maxScreenWidrth = 1200;
  if(screenWidth > maxScreenWidrth) {
    width = 400;
  } else if (screenWidth <= maxScreenWidrth && screenWidth < minScreenWidth) {
    width = 300 * (1 +  (maxScreenWidrth - screenWidth) / 200) ;
  }else {
    width = 300;
  }
  Widget getContainer(Widget child) {
    return Container(width: width, child: child);
  }

  switch (page) {
    case 'SettingItemDetailPage':
      return getContainer(new SettingItemDetailPage(
        key: ValueKey("ejzifjf123"),
        missionModel: data['missionModel'],
      ));
    case 'ChatGptPage':
      return getContainer(ChatGptPage(
        key: ValueKey("ejzifjf123zefzef"),
      ));
    case 'GroupChatPage':
      return getContainer(GroupChatPage(
        key: ValueKey("ejzifjf123zefzef"),
      ));
    default:
      return SizedBox.shrink();
  }
}
