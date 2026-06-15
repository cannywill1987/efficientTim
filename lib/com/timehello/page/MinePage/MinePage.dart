// import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/GridMenuItem.dart';
import 'package:time_hello/com/timehello/components/LoginAvatarWidget.dart';
import 'package:time_hello/com/timehello/components/MissionSearchBar.dart';
import 'package:time_hello/com/timehello/components/PCLeftMenuBarWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';

// import 'package:time_hello/com/timehello/page/ChatGptPage/GPTContainer.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/FlomoPage.dart';
import 'package:time_hello/com/timehello/page/LockScreenPage/LockScreenPage.dart';
import 'package:time_hello/com/timehello/page/SettingPage/pages/FilterMenuSettingPage.dart';
import 'package:time_hello/com/timehello/page/ThemePage/ThemePage.dart';
import 'package:time_hello/com/timehello/page/gamesPage/GamesPage.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/JumpNavigator.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
// import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../../../../r.dart';
import '../../beans/BaseBean.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/ConsumeMoneyButtonWidget.dart';
import '../../components/DownloadListwidget.dart';
import '../../components/EventModel.dart';
import '../../components/MoneyHandlerWidget.dart';
import '../../components/ThirdPartyLoginWidget.dart';
import '../../config/ENUMS.dart';
import '../../util/MoneyManager.dart';
import '../ChatGptPage/GPTContainer.dart';
import '../FeedbackPage/FeedbackPage.dart';
import '../PrivacySettingPage/PrivacySettingPage.dart';

import '../SettingPage/SettingPage.dart';
import '../SettingPage/SettingPermissionPage.dart';
import '../SettingUserInfoPage/SettingUserInfoPage.dart';
import '../WrongQuestionBookPage/WQBContainer.dart';

/**
 * 文件类型：页面
 * 文件作用：展示“我的”个人中心，承接用户资料、快捷工具入口、设置入口和登录退出能力。
 * 主要职责：移动端按个人中心视觉稿渲染资料卡和宫格工具，桌面端继续复用左侧菜单布局。
 */
class MinePage extends BaseWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _MinePageState();
  }
}

class _MobileMineMenuEntry {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MobileMineMenuEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _MinePageState extends BaseWidgetState<MinePage> {
  static const Color _mobileMineAccentColor = Color(0xFFA7DE2B);
  static const Color _mobileMineAccentDarkColor = Color(0xFF7DAE1B);
  static const Color _mobileMineBackgroundColor = Color(0xFFFBFFF2);
  static const Color _mobileMineCardColor = Color(0xFFFFFFFF);
  static const Color _mobileMineTextColor = Color(0xFF202124);
  static const Color _mobileMineSubTextColor = Color(0xFF8C8C8C);

  double iconSize = 20;

  @override
  void onCreate() {
    super.onCreate();
    curPage = "MinePage";
  }

  @override
  void initState() {
    super.initState();
    isNavBackBtnVisible = false;
    // this.requestUpdateTotalFocusTime(page: 1, pageSize: 2);
    isAppBarVisible = false;
    shouldShowSafeArea = false;
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    eventBus.on<EventFn>().listen((event) {
      if (event.type == Params.ACTION_UPDATE_USERINFO_AVATAR) {
        Future.delayed(new Duration(seconds: 1), () {
          this.updateUI();
        });
      } else if (event.type == Params.ACTION_UPDATE_TOTAL_FOCUS_TIME &&
          mounted) {
        this.updateUI();
      }
    });
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickToLogin':
        this.onClickToLogin();
        break;
      case 'onClickToChangeAvatar':
        // onClickToChangeAvatar();
        break;
    }
  }

  Future<void> requestUpdateTotalFocusTime(
      {required int page, required int pageSize}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.getUserRankingList,
        params: {"page": page, "pageSize": pageSize},
        context: context,
        shouldShowErrorToast: false);
    if (response.success == true) {
    } else {}
  }

  void onClickToLogin() {
    LoginManager.getInstance().doAliSdkSecVerifyLogin(context);
    // Utility.pushNavigator(context, const LoginPage(), callback: (res) {
    // this.requestDatas();
    // });
  }

  List<Widget> getGridViewService(int numGridItems) {
    List<Widget> list = [];
    if (Utility.isProductEnv() == false) {
      list.add(GridMenuItem(
          icon:
              Utility.getSVGPicture(R.assetsImgIcFocusTraining, size: iconSize),
          title: "推荐目标",
          onTapListener: () async {
            Utility.pushNavigator(context, LockScreenPage());
            // print("result ${Utility.getLunarCalendar()}");
            // CounterMethodChannelManager.getInstance().requestPushToTimeline();
            // DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(context,
            //     child: ClockInSentenceDialog(onSubmitted: () {}));

            // DialogManagement.showFlomoRatingDialog(context, flomoMissionModel: FlomoMissionModel());
            // DialogManagement.getInstance()
            //     .showCustomDialogWithSmallButtons(context,
            //   okTitle: getI18NKey().i_know,
            //   children: [
            //     Text(getI18NKey().trainee_advice_notice(""), style: TextStyle(color: Colors.grey, fontSize: 13),),
            //     SizedBox(height: 10,),
            //     Expanded(
            //       child: Container(
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(10)),
            //           child: GPTCreateMissionWidget(
            //               list: [])),
            //     )],
            //   title: getI18NKey().trainee_give_your_advice(""),
            //   okCallback: () {
            //     // DialogManagement.getInstance().hideDialog(context);
            //     // DialogManagement.showRatingDialog(context, scene: EVENTNAME.CreateAIChatGptMissionPage);
            //   },
            //   // cancelCallback: () {
            //   //   DialogManagement.getInstance().hideDialog(context);
            //   // }
            // );

            // DialogManagement.getInstance().showCustomDialogWithSmallButtons(context, title: title, child: child, okCallback: okCallback, cancelCallback: cancelCallback)
            // DialogManagement.getInstance()
            //     .showCustomDialogWithSmallButtons(context,
            //         // okTitle: getI18NKey().i_know,
            //         child: Container(
            //             child: FlomoPickPeriodDialogWidget(
            //                 onChange: (code, isCheck, endTime) {})),
            //         title: "目标持续周期", okCallback: () {
            //   DialogManagement.getInstance().hideDialog(context);
            // }, cancelCallback: () {
            //   DialogManagement.getInstance().hideDialog(context);
            // });
            // DialogManagement.getInstance().showCustomDialog(context,
            //     title: getI18NKey().trainee_give_your_advice("我给你的"),
            //     child: Container(
            //         width: double.infinity,
            //         height: 400,
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(10)),
            //         child: GPTCreateMissionWidget(
            //             list: MongoApisManager.getInstance()
            //                 .listMissionModels)));

            // CounterMethodChannelManager.getInstance().shareToQQ(title: "title", subtitle: 'subtitle', iconUrl: 'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg', url: "https://www.timerbell.com/qq_conn/1112263382");

            // CounterMethodChannelManager.getInstance().shareToWeChat(title: "title", subtitle: 'subtitle', iconUrl: 'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg', url: "https://www.timerbell.com/app/welcome");
            // Utility.pushNavigator(context, CreateAIChatGptMissionPage());
            // String str = "[\n{\n\"title\": \"早上锻炼\",\n\"total_tomotoes\": 1,\n\"tomato_duration\": 1500000,\n\"end_time\": 25200000,\n\"alert_time\": 25200000,\n\"time_finished\": 0,\n\"priorityStatus\": 3,\n\"daily_start_time\": 25200000,\n\"daily_end_time\": 27000000,\n\"message\": \"\"\n},\n{\n\"title\": \"工作\",\n\"total_tomotoes\": 4,\n\"tomato_duration\": 1500000,\n\"end_time\": 28800000,\n\"alert_time\": 25200000,\n\"time_finished\": 0,\n\"priorityStatus\": 3,\n\"daily_start_time\": 27000000,\n\"daily_end_time\": 30600000,\n\"message\": \"\"\n}\n]";
            // RegExp regExp = RegExp(r'\{(.*)\}', multiLine: true);
            // Iterable<RegExpMatch> matches = regExp.allMatches(str);
            // for (final m in matches) {
            //   print(m[0]);
            // }

            // String jsonString = "[{\"title\": \"早上锻炼\",\"total_tomotoes\": 1,\"tomato_duration\": 1500000,\"end_time\": 25200000,\"alert_time\": 25200000,\"time_finished\": 0,\"priorityStatus\": 3,\"daily_start_time\": 25200000,\"daily_end_time\": 27000000,\"message\": \"\"},{\"title\": \"工作\",\"total_tomotoes\": 4,\"tomato_duration\": 1500000,\"end_time\": 28800000,\"alert_time\": 25200000,\"time_finished\": 0,\"priorityStatus\": 3,\"daily_start_time\": 27000000,\"daily_end_time\": 30600000,\"message\": \"\"}]";
            //
            // RegExp regExp = new RegExp(r'\{(.*?)\}');
            // Iterable<Match> matches = regExp.allMatches(jsonString);
            //
            // for (Match match in matches) {
            //   String? matchString = match.group(0);
            //   // Map<String, dynamic> json = jsonDecode(matchString);
            //   print(matchString);
            // }

            // return [];
            // String str = "[xx\nxx]";
            // str = str.replaceAll("\n", "");
            // RegExp exp = RegExp(r'\[(.*?)\]', multiLine: true);
            // // RegExp exp = RegExp(r'```(.*+)```');
            // // String str = '[Parse my string]';
            // Iterable<RegExpMatch> matches = exp.allMatches(str);
            // for (final m in matches) {
            //   print(m[0]);
            // }
          }));
    }
    if (Utility.isProductEnv() == false) {
      list.add(GridMenuItem(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          title: "测试用2" +
              ' countryCode:' +
              (Params.local?.countryCode ?? '') +
              ' languageCode:' +
              (Params.local?.languageCode ?? ''),
          onTapListener: () async {
            Utility.showToastMsg(
                context: context,
                msg: ' countryCode:' +
                    (Params.local?.countryCode ?? '') +
                    ' languageCode:' +
                    (Params.local?.languageCode ?? ''));
            // ScreenLockManager.getInstance().showPasword();
            // screenLockCreate(
            //   context: context,
            //   onConfirmed: (value) {
            //     CloudSharepreferenceManagement.getInstance().setString(ShareprefrenceKeys.default9DigitPasswords, value);
            //     // print(value)
            //   }, // store new passcode somewhere here
            // );
            //
            // screenLock(
            //   context: context,
            //   correctString: '1234',
            //   canCancel: false,
            // );

            // Utility.openWebViewLaunch(context: context, url: Utility.getTokenUrl(url: '${(Urls.mgmHomeUrl ?? "")}?qd=timehello_app&cy=mgm'));
            // Utility.pushNavigator(
            //     context,
            //     WebviewPage(
            //       title: title ?? "",
            //       url: Urls.mgmHomeUrl ?? "",
            //     ));

            // DialogManagement.getInstance().showMissionListDialog(context, list: []);
            // CounterMethodChannelManager.getInstance().shareToWeChat(title: "title", subtitle: 'subtitle', iconUrl: 'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg', url: "https://www.timerbell.com/qq_conn/1112263382");
            // CounterMethodChannelManager.getInstance().shareToQQ(title: "title", subtitle: 'subtitle', iconUrl: 'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg', url: "https://www.timerbell.com/qq_conn/1112263382");
            // ChatGptManager.getInstance().sendMessages(messages: [
            //   {
            //     'role': 'system',
            //     'content': 'give short message',
            //   },
            //   {'role': 'user', 'content': '你好'}
            // ]);
            // String s = await HttpManager.getInstance().doStreamRequest(Apis.chatGptWithOpenAi,shouldShowErrorToast: false,
            //     callback: (
            //         String res, String scene, int requestStatus) {
            //       print("res: $res");
            //     },
            //     params: {
            //       "messages": [{'role': 'system', 'content': 'give short message', }, {'role': 'user', 'content': '你好'}],
            //     });
            // print(s);
            // FolderModel folderModel = FolderModel();
            // folderModel.title = "测试用2";
            // DialogManagement.getInstance().showCustomIconTitleAndDescDialog(
            //    Utility.getGlobalContext(),
            //     folderModel: folderModel,);
            // print(result);

            // CryptoManager.getInstance().showPasswordDialog(okCallback: (val) {});
            // OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
            //     context,
            //     title: getI18NKey().mission_value,
            //     okCallBack: (valuePerHour) async {
            //   OverlayManagement.getInstance().removeSelectDialogOverlay();
            //   BaseBean response = await HttpManager.getInstance().doPostRequest(
            //       Apis.updateValuePerHour,
            //       params: {"valuePerHour": valuePerHour},
            //       context: context,
            //       shouldShowErrorToast: false);
            //   if (response.success == true) {
            //     LoginManager.getInstance()
            //         .setUserBean(UserBean.fromJson(response.data));
            //   }
            // });
            // if(SharePreferenceUtil.getSyncInstance().getBool(key: ShareprefrenceKeys.hasCameraPermissionRequested, defaultVal: false) == false) {
            //   SharePreferenceUtil.getSyncInstance().setBool(key: ShareprefrenceKeys.hasCameraPermissionRequested, val: true);
            //   // Utility.showAwsomeDialog(context, btnOkText: getI18NKey().i_know,
            //   //     cancelCallback: () {},
            //   //     confirmCallback: () {},
            //   //     content: getI18NKey().camera_permission_description,
            //   //     title: getI18NKey().request_permission);
            //   GetResourceDeliveryManager.getInstance()
            //       ?.requestGetResourceDelivery(
            //       'timehello_init', isCachableOn: true,
            //       onResourceComplete:
            //           (List<ResourceLocationInfoBean> response,
            //           bool isFromCache) {
            //         ResourceInfo.clockInSentenceResourceLocationInfoBeanList =
            //             response;
            //       });
            // }
            // DialogManagement.getInstance().showCustomDialogWithSmallButtons(
            //     context,
            //     // okTitle: getI18NKey().i_know,
            //     child: Container(
            //         child: FlomoPickPeriodDialogWidget(
            //             onChange: (code, isCheck, endTime) {})),
            //     title: "目标持续周期", okCallback: () {
            //   DialogManagement.getInstance().hideDialog(context);
            // }, cancelCallback: () {
            //   DialogManagement.getInstance().hideDialog(context);
            // });

            // CounterMethodChannelManager.getInstance().shareToQQ(title: "title", subtitle: 'subtitle', iconUrl: 'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg', url: "https://www.timerbell.com/qq_conn/1112263382");

            // MongoApisManager.getInstance().queryWhereEqual_folderModel(shouldRefresh: true);
            // DialogManagement.getInstance().showCustomDialogWithOnlyChild(context, child: SharePopupWidget());
            // showMaterialModalBottomSheet(
            //   context: context,
            //   builder: (context) => Container(),
            // );
            // await MongoApisManager.getInstance()
            //     .batchUpdate_FolderModelSync();
            // await MongoApisManager.getInstance()
            //     .batchUpdate_MissionModelSync();
            // MongoApisManager.getInstance().queryWhereEqual_TimelineMissionModel(shouldRefresh: true);
            // LoginManager.getInstance().doAliSdkSecVerifyLogin(context);
            // EventCollection.onCollection(sceneType: EVENT.SYSTEM, eventType: EVENT.REQUEST_ERROR, message: "12345", resultType: "54321");
            // AliOneKeyLoginManager.getInstance().login();
            // CounterMethodChannelManager.getInstance()
            //     .storeMissionDataList("你好哦~~~~~~~~~~~~~~");
            // Utility.showToast(context: context, msg: "menu1");
            // Utility.pushNavigator(context, MinePage());
            // EasyLoadingManager.getInstance().hideLoading();
            // LoginManager.getInstance().thirdPartyLoginWithFacebook(context);
            // FirebaseManager.getInstance().signInWithFacebook();
            // EasyLoadingManager.getInstance().dismiss();
            // String? path = await RecorderManager.getInstance().stop();
            // File file = new File(path ?? "");
            // // BaseBean baseBean = await HttpManager.getInstance().uploadImage(key: 'key', file:new File(path ?? ""), url: Apis.upload);
            // BaseBean res = await HttpManager.getInstance()
            //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
            // String url = res.data;
            // print("path: ${path ?? ""}");
            // NotificationManager.getInstance()?.cancelAllPendingNotification();
            // Utility.showToast(context: context, msg: "321");
            // NotificationManager.getInstance()?.pushNotificationWithWhen(title: "title", content: "content", whenMilliseconds: (DateTime.now().millisecondsSinceEpoch + 10 * 1000), id: Params.PUSH_NOTIFICATION_ID);
          }));
    }
    if (Utility.isProductEnv() == false) {
      list.add(GridMenuItem(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          title: "测试用-获取权限",
          onTapListener: () async {
            await CounterMethodChannelManager.getInstance()
                .requestEventReminderAccess();

            // CounterMethodChannelManager.getInstance().shareToWeChat(
            //     title: "title",
            //     subtitle: 'subtitle',
            //     iconUrl:
            //         'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg',
            //     url: "https://www.timerbell.com/qq_conn/1112263382",
            //     toWhere: 1);
            // NotificationManager.getInstance()?.pushNotificationWithdelay(title: "title", content: "content", delay: 1000, extendsParams: "", id: "3");
            // NotificationManager.getInstance()?.pushNotificationWithWhen(
            //     title: "title",
            //     content: "content",
            //     whenMilliseconds:
            //         (DateTime.now().millisecondsSinceEpoch + 10 * 1000),
            //     id: Params.PUSH_NOTIFICATION_ID);
            // Utility.showToast(context: context, msg: "123");
          }));
    }
    if (Utility.isProductEnv() == false) {
      list.add(GridMenuItem(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          title: "测试用-获取事件",
          onTapListener: () async {
            List<EventModel> list =
                await CounterMethodChannelManager.getInstance()
                    .fetchCalendarEvents(
                        startDate: 1701940406000, endDate: 1765098806000);
            Utility.convertListEventModelToListMissionModel(list);
            // Utility.initCalendarModel();

            // final perf = Perf();
            // perf.start();
            // await Future.wait([
            //   MongoApisManager.getInstance().queryWhereEqual_folderModel(),
            //   MongoApisManager.getInstance().queryWhereEqual_missionData(),
            //   MongoApisManager.getInstance().queryWhereEqual_statsModel(),
            //   MongoApisManager.getInstance()
            //       .queryWhereEqual_TimelineMissionModel(),
            //   MongoApisManager.getInstance()
            //       .queryWhereEqual_EndTimeMissionModel(),
            //   MongoApisManager.getInstance().queryWhereEqual_CourseModel(),
            // ]);
            // perf.stop();
          }));
    }
    if (Utility.isProductEnv() == false) {
      list.add(GridMenuItem(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          title: "测试用-获取提醒",
          onTapListener: () async {
            CounterMethodChannelManager.getInstance().fetchReminderReminders(
                startDate: 1701940406000, endDate: 1765098806000);
          }));
    }
    list.add(GridMenuItem(
        icon:
            Utility.getSVGPicture(R.assetsImgIcClockinSelected, size: iconSize),
        title: getI18NKey().clock_in,
        onTapListener: () {
          Utility.pushNavigator(context, FlomoPage());
        }));
    if (Utility.isIOS()) {
      list.add(GridMenuItem(
          icon: Utility.getSVGPicture(R.assetsImgIcLockscreenView,
              size: iconSize),
          title: getI18NKey().lock_app_setting,
          onTapListener: () {
            if (LoginManager.getInstance().isVIP(
                shouldShowDialog: true,
                paymentPromotionAdsModeEnum:
                    PaymentPromotionAdsModeEnum.Lockscreen)) {
              Utility.pushNavigator(context, LockScreenPage());
            }
          }));
    }
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcFocusTraining, size: iconSize),
        title: getI18NKey().focus_campus,
        onTapListener: () {
          Utility.pushNavigator(context, GamesPage());
        }));

    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcTimeline, size: iconSize + 10),
        title: Utility.isHuaWei()
            ? getI18NKey().tasks_list
            : getI18NKey().timeline,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'timeline');
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcAddnote, size: iconSize + 10),
        title: getI18NKey().add_note,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'addnote');
        }));

    list.add(GridMenuItem(
        icon:
            Utility.getSVGPicture(R.assetsImgIcVoiceNote, size: iconSize + 10),
        title: getI18NKey().note_diary,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'voicenote');
        }));

    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcNote, size: iconSize + 10),
        title: getI18NKey().write_diary,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'writediary');
        }));

    list.add(GridMenuItem(
        icon:
            Utility.getSVGPicture(R.assetsImgIcVoiceDiary, size: iconSize + 10),
        title: getI18NKey().voice_diary,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'voicediary');
        }));

    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcCountdownTimerSelected,
            size: iconSize),
        title: getI18NKey().count_down_text,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(
              context, 'CountDownListViewPage');
        }));
    list.add(GridMenuItem(
        icon:
            Utility.getSVGPicture(R.assetsImgIcMemoDayChecked, size: iconSize),
        title: getI18NKey().count_up_text,
        onTapListener: () {
          JumpNavigator.onClickCustomHeaderGridView(
              context, 'CountUpListViewPage');
        }));
    if (Utility.isHuaWei() == false && ABTestSetting.isOpenAiOn) {
      list.add(GridMenuItem(
          icon: Utility.getSVGPicture(R.assetsImgIcAiHelper, size: iconSize),
          title: getI18NKey().ai_helper,
          // subtitle: getI18NKey().cloud_sync_content,
          onTapListener: () async {
            // WQBModeEnum modeEnum = WQBModeEnum.memorandum;
            // context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
            Utility.pushNavigator(context, const GPTContainer());
          }));
    }
    // list.add(GridMenuItem(
    //     icon: Utility.getSVGPicture(R.assetsImgIcCreditCard, size: iconSize),
    //     title: getI18NKey().credit_bag,
    //     onTapListener: () {
    //       JumpNavigator.onClickCustomHeaderGridView(context, 'CreditCardPage');
    //     }));
    // if(!Utility.isChina()) {
    //   list.add(GridMenuItem(
    //       icon: Utility.getSVGPicture(
    //           R.assetsImgIcChatgptSelect, size: iconSize + 6),
    //       title: getI18NKey().chatgpt,
    //       onTapListener: () {
    //         Utility.pushNavigator(context, ChatGptPage());
    //       }));
    // }
    List<Row> listRows = [];
    //根据numGridItems 生成行数 numGridItems是代表几列
    for (int i = 0; i < list.length; i++) {
      List<Widget> columns = [];
      for (int j = 0; j < numGridItems; j++) {
        if (i * 3 + j < list.length) {
          columns.add(Expanded(
            child: list[i * 3 + j],
          ));
        }
      }
      listRows.add(Row(
        children: columns,
      ));
    }
    return listRows;
  }

  /**
   * 笔记本
   */
  List<Widget> getGridViewNote(int numGridItems) {
    List<Widget> list = [];
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcSuperNote, size: iconSize),
        title: getI18NKey().super_notebook,
        onTapListener: () {
          Utility.pushNavigator(context, const WQBContainer());
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcNote3, size: iconSize),
        title: getI18NKey().note_n,
        onTapListener: () {
          WQBModeEnum modeEnum = WQBModeEnum.note;
          context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
          Utility.pushNavigator(context, const WQBContainer());
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcWrongQuestionBook,
            size: iconSize),
        title: getI18NKey().wrong_question_book,
        onTapListener: () {
          WQBModeEnum modeEnum = WQBModeEnum.wrong_question_book;
          context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
          Utility.pushNavigator(context, const WQBContainer());
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcCard, size: iconSize),
        title: getI18NKey().card,
        // subtitle: getI18NKey().copy_sub_title,
        onTapListener: () {
          WQBModeEnum modeEnum = WQBModeEnum.card;
          context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
          Utility.pushNavigator(context, const WQBContainer());
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcMemorandum, size: iconSize),
        title: getI18NKey().memorandum,
        // subtitle: getI18NKey().cloud_sync_content,
        onTapListener: () async {
          WQBModeEnum modeEnum = WQBModeEnum.memorandum;
          context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
          Utility.pushNavigator(context, const WQBContainer());
        }));

    List<Row> listRows = [];
    //根据numGridItems 生成行数 numGridItems是代表几列
    for (int i = 0; i < list.length; i++) {
      List<Widget> columns = [];
      for (int j = 0; j < numGridItems; j++) {
        if (i * 3 + j < list.length) {
          columns.add(Expanded(
            child: list[i * 3 + j],
          ));
          //增加灰色分界线
          // if (j < numGridItems - 1) {
          //   columns.add(Container(
          //     width: 1,
          //     height: 60,
          //     color: Colors.grey[200],
          //   ));
          // }
        }
        //增加灰色分界线
        // if (i < list.length - 1) {
        //   columns.add(Container(
        //     width: double.infinity,
        //     height: 1,
        //     color: Colors.grey[200],
        //   ));
        // }
      }
      listRows.add(Row(
        children: columns,
      ));
    }
    return listRows;
  }

  List<Widget> getGridViewSetting(int numGridItems) {
    List<Widget> list = [];
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked,
            size: iconSize + 5),
        title: getI18NKey().tomatoClockSetting,
        onTapListener: () {
          Utility.pushNavigator(
              context, const SettingPage(pageFrom: PageFromEnum.Normal));
        }));

    list.add(GridMenuItem(
        icon: Icon(Icons.filter_alt, size: iconSize + 5),
        title: getI18NKey().filtering_setting,
        onTapListener: () {
          Utility.pushNavigator(context, FilterMenuSettingPage());
        }));

    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcTheme, size: iconSize + 10),
        title: getI18NKey().theme,
        onTapListener: () {
          Utility.pushNavigator(context, ThemePage());
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcPermission, size: iconSize),
        title: getI18NKey().permission_setting,
        onTapListener: () {
          Utility.pushNavigator(context, SettingPermissionPage());
        }));
    if (Utility.isHuaWei() == false)
      list.add(GridMenuItem(
          icon:
              Utility.getSVGPicture(R.assetsImgIcFeedback, size: iconSize + 7),
          title: getI18NKey().feedback,
          onTapListener: () {
            Utility.pushNavigator(context, FeedbackPage());
          }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcFeedback2, size: iconSize + 7),
        title: getI18NKey().copy_qq,
        // subtitle: getI18NKey().copy_sub_title,
        onTapListener: () {
          if (Localizations.localeOf(Utility.getGlobalContext()).languageCode !=
              "zh") {
            Utility.openExternalWebView(url: Urls.facebook);
          } else {
            Utility.copyToClipboard("563144208", shouldShowToast: false);
            Utility.showToastMsg(
                context: context, msg: getI18NKey().copy_qq_success);
          }
        }));
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcCloudSync, size: iconSize),
        title: getI18NKey().cloud_sync,
        subtitle: getI18NKey().cloud_sync_content,
        onTapListener: () async {
          await onClickSyncCloud(context);
        }));
    if (Utility.isHandsetBySize() && LoginManager.isLogin()) {
      list.add(GridMenuItem(
          icon: Utility.getSVGPicture(R.assetsImgIcPrivacySetting,
              size: iconSize),
          title: getI18NKey().privacy_management,
          onTapListener: () {
            Utility.pushNavigator(context, PrivacySettingPage());
            // Utility.pushNavigator(context, SettingPage());
          }));
    }
    List<Row> listRows = [];
    //根据numGridItems 生成行数 numGridItems是代表几列
    for (int i = 0; i < list.length; i++) {
      List<Widget> columns = [];
      for (int j = 0; j < numGridItems; j++) {
        if (i * 3 + j < list.length) {
          columns.add(Expanded(
            child: list[i * 3 + j],
          ));
          //增加灰色分界线
          // if (j < numGridItems - 1) {
          //   columns.add(Container(
          //     width: 1,
          //     height: 60,
          //     color: Colors.grey[200],
          //   ));
          // }
        }
        //增加灰色分界线
        // if (i < list.length - 1) {
        //   columns.add(Container(
        //     width: double.infinity,
        //     height: 1,
        //     color: Colors.grey[200],
        //   ));
        // }
      }
      listRows.add(Row(
        children: columns,
      ));
    }
    return listRows;
  }

  Widget baseMobileBuild(BuildContext context) {
    // CalendarModel list = context.watch<GlobalStateEnv>().calendarModel;
    context.watch<GlobalStateEnv>().calendarModel;
    // context.watch<GlobalStateEnv>().calendarModel;
    return Selector<Env, bool>(
        selector: (_, env) => env.isVip,
        builder: (_, isVip, __) {
          final bool isDark = ThemeManager.getInstance().isDark();
          final Color pageBackground = isDark
              ? ThemeManager.getInstance().getBackgroundColor(context: context)
              : _mobileMineBackgroundColor;

          return Container(
            color: pageBackground,
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                // 底部是全局悬浮胶囊导航，内容必须预留可滚动安全距离，否则宫格最后一行会被导航盖住。
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 112),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildMobileMineTopBar(),
                        const SizedBox(height: 18),
                        _buildMobileMineProfileCard(),
                        Transform.translate(
                          offset: const Offset(0, -26),
                          child: _buildMobileMineMenuPanel(),
                        ),
                        if (LoginManager.isLogin())
                          getLogoutItem(onTapListener: () {
                            LoginManager.getInstance().logout(context);
                          }),
                        getProtocolWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// 功能：构建移动端“我的”页顶部品牌栏。
  /// 说明：参考设计图保留番茄 Logo、应用名和右侧快捷操作，避免复用桌面菜单导致移动端视觉过重。
  Widget _buildMobileMineTopBar() {
    return Row(
      children: [
        Utility.getSVGPicture(R.assetsImgIcTomato, size: 32),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            '时间管理局 ToDo',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _mobileMineTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _buildMobileMineTopIconButton(
          icon: Icons.search_rounded,
          onTap: _showMobileMissionSearchDialog,
        ),
        _buildMobileMineNotificationButton(),
        _buildMobileMineTopIconButton(
          icon: Icons.settings_outlined,
          onTap: () {
            Utility.pushNavigator(
              context,
              const SettingPage(pageFrom: PageFromEnum.Normal),
            );
          },
        ),
      ],
    );
  }

  /// 功能：构建顶部普通图标按钮。
  /// 说明：统一点击热区，保证搜索、通知和设置在移动端有足够的可点面积。
  Widget _buildMobileMineTopIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(
          icon,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }

  /// 功能：构建带红点的通知入口。
  /// 说明：当前页面仅提供入口样式，点击后沿用轻提示，后续接入消息中心时可替换 onTap。
  Widget _buildMobileMineNotificationButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildMobileMineTopIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {
            Utility.showToastMsg(msg: getI18NKey().offer_next_version);
          },
        ),
        Positioned(
          top: 7,
          right: 8,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFFFF4D4F),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  /// 功能：弹出移动端任务搜索面板。
  /// 说明：复用已有 MissionSearchBar，同时由外层 GestureDetector 接管黑色遮罩点击关闭。
  void _showMobileMissionSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Utility.popNavigator(dialogContext);
          },
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: GestureDetector(
                // 内容区自己处理点击，避免点输入框或列表时把外层遮罩关闭。
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
                  constraints: const BoxConstraints(maxWidth: 520),
                  decoration: BoxDecoration(
                    color: ThemeManager.getInstance().getCardBackgroundColor(
                      defaultColor: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MissionSearchBar(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 功能：构建移动端用户资料卡。
  /// 说明：绿色大卡片承接头像、用户名、排名、专注时长、收益和平台入口，贴近设计稿的个人中心首屏。
  Widget _buildMobileMineProfileCard() {
    return Container(
      // 移动端首屏还要容纳功能宫格和悬浮底栏，资料卡不能过高，否则第三行入口会被底栏压住。
      height: LoginManager.isLogin() ? 198 : 190,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _mobileMineAccentColor,
            Color(0xFFE2F6A5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _mobileMineAccentDarkColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LoginManager.isLogin()
          ? _buildMobileMineLoginProfileContent()
          : _buildMobileMineUnLoginProfileContent(),
    );
  }

  /// 功能：构建已登录用户资料区。
  /// 说明：移动端卡片空间很窄，采用左头像、中信息、右收益的三栏结构，避免文案被挤成零散碎片。
  Widget _buildMobileMineLoginProfileContent() {
    final int? ranking =
        LoginManager.getInstance().getUserBean().totalFocusTimeRanking;
    final int totalFocusTime =
        LoginManager.getInstance().getUserBean().totalFocusTime ?? 0;
    final String username = LoginManager.getInstance().getUserBean().username;
    final bool shouldShowRanking = ranking != null && ranking >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildMobileMineAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMobileMineIdentityBlock(
                  username: username,
                  ranking: shouldShowRanking ? ranking : null,
                  totalFocusTime: totalFocusTime,
                ),
              ),
              const SizedBox(width: 10),
              _buildMobileMineMoneyBlock(),
            ],
          ),
        ),
        // Windows 桌面端与 macOS 共用新版桌面壳层，避免继续展示旧版移动/桌面混合菜单入口。
        if (!(Utility.isIOS() || Utility.isMacOS() || Utility.isWindows())) ...[
          const SizedBox(height: 10),
          // iOS/Mac 端不展示客户端下载入口，否则会把移动端个人卡底部撑出黑黄溢出标记。
          Align(
            alignment: Alignment.centerRight,
            child: DownloadListwidget(
              shouldShowWinAndAndroid: true,
            ),
          ),
        ],
      ],
    );
  }

  /// 功能：构建资料卡中间身份信息区。
  /// 说明：用户名、排名、专注时长使用固定层级展示，避免旧版在窄屏里出现“12 / 第213 / 名”的断裂排版。
  Widget _buildMobileMineIdentityBlock({
    required String username,
    required int? ranking,
    required int totalFocusTime,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextUtil.isEmpty(username)
            ? _buildMobileMineAddUsernameButton()
            : Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                ),
              ),
        const SizedBox(height: 9),
        if (ranking != null)
          _buildMobileMineInfoPill(getI18NKey().my_ranking(ranking.toString())),
        const SizedBox(height: 7),
        Text(
          '${getI18NKey().total_focus_time} ${Utility.formatHourAndMin(totalFocusTime)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// 功能：构建资料卡里的小信息胶囊。
  /// 说明：排名这类短状态独立成胶囊，便于扫读，也避免和专注时长混在一起。
  Widget _buildMobileMineInfoPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// 功能：构建资料卡右侧收益区。
  /// 说明：复用金额组件和“我要花”入口，但用固定宽度约束它们，防止挤压中间身份信息。
  Widget _buildMobileMineMoneyBlock() {
    return SizedBox(
      width: 104,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            getI18NKey().mine_hourly_value(
              MoneyManager.getInstance().localMoneyMake,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
              height: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Utility.getSVGPicture(R.assetsImgIcMoney2, size: 15),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  MoneyManager.getInstance().getLocalMoney().toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Transform.translate(
            offset: const Offset(15, 0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: ConsumeMoneyButtonWidget(
                pageFrom: PageFromEnum.MobileMinePage,
                onTapListener: (obj) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能：构建未登录资料区。
  /// 说明：保留原登录入口和第三方登录能力，只把视觉放入新的绿色卡片。
  Widget _buildMobileMineUnLoginProfileContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _mobileMineAccentDarkColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () {
              this.onClick('onClickToLogin', null);
            },
            child: Text(
              getI18NKey().login,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ThirdPartyLoginWidget(
          onTapGoogle: () {},
          onTapFacebook: () {},
        ),
      ],
    );
  }

  /// 功能：构建移动端头像容器。
  /// 说明：LoginAvatarWidget 原始尺寸较小，这里只在“我的”资料卡中放大显示，不改变公共组件默认尺寸。
  Widget _buildMobileMineAvatar() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: SizedBox(
          width: 66,
          height: 66,
          child: FittedBox(
            fit: BoxFit.cover,
            child: LoginAvatarWidget(),
          ),
        ),
      ),
    );
  }

  /// 功能：构建添加用户名按钮。
  /// 说明：沿用进入用户资料页的老入口，视觉改成资料卡中的白色描边按钮。
  Widget _buildMobileMineAddUsernameButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Utility.pushNavigator(context, SettingUserInfoPage());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_add_alt_1_outlined,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              getI18NKey().add_username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 功能：构建移动端功能宫格面板。
  /// 说明：把旧的三组 GridMenuItem 收敛成一个白色面板，四列展示更接近设计图且滚动更紧凑。
  Widget _buildMobileMineMenuPanel() {
    final List<_MobileMineMenuEntry> entries = _getMobileMineMenuEntries();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 24),
      decoration: BoxDecoration(
        color: _mobileMineCardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 18,
          crossAxisSpacing: 10,
          // 四列宫格里包含图标、双行标题和副标题，原 0.98 高度不足会在真机 Debug 下溢出。
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          return _buildMobileMineMenuItem(entries[index]);
        },
      ),
    );
  }

  /// 功能：构建单个功能入口。
  /// 说明：图标放在独立小白卡内，标题和副标题固定行数，避免长文案挤压整体宫格。
  Widget _buildMobileMineMenuItem(_MobileMineMenuEntry entry) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: entry.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF2F2F2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SizedBox(
              width: 34,
              height: 34,
              child: FittedBox(
                fit: BoxFit.contain,
                child: entry.icon,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            entry.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _mobileMineTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            entry.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _mobileMineSubTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 功能：汇总移动端“我的”页工具入口。
  /// 说明：保留原三组菜单的跳转能力，并按设计图顺序合并为一个四列宫格。
  List<_MobileMineMenuEntry> _getMobileMineMenuEntries() {
    final double menuIconSize = 30;
    final List<_MobileMineMenuEntry> entries = [
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcClockinSelected,
          size: menuIconSize,
        ),
        title: getI18NKey().clock_in,
        subtitle: getI18NKey().mine_menu_subtitle_habit_building,
        onTap: () {
          Utility.pushNavigator(context, FlomoPage());
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcFocusTraining,
          size: menuIconSize,
        ),
        title: getI18NKey().focus_campus,
        subtitle: getI18NKey().mine_menu_subtitle_focus_training,
        onTap: () {
          Utility.pushNavigator(context, GamesPage());
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcTimeline, size: menuIconSize),
        title: Utility.isHuaWei()
            ? getI18NKey().tasks_list
            : getI18NKey().timeline,
        subtitle: getI18NKey().mine_menu_subtitle_time_record,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'timeline');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcAddnote, size: menuIconSize),
        title: getI18NKey().add_note,
        subtitle: getI18NKey().mine_menu_subtitle_capture_ideas,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'addnote');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcVoiceNote, size: menuIconSize),
        title: getI18NKey().note_diary,
        subtitle: getI18NKey().mine_menu_subtitle_voice_to_text,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'voicenote');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcNote, size: menuIconSize),
        title: getI18NKey().write_diary,
        subtitle: getI18NKey().mine_menu_subtitle_daily_record,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'writediary');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcVoiceDiary,
          size: menuIconSize,
        ),
        title: getI18NKey().voice_diary,
        subtitle: getI18NKey().mine_menu_subtitle_voice_record,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(context, 'voicediary');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcCountdownTimerSelected,
          size: menuIconSize,
        ),
        title: getI18NKey().count_down_text,
        subtitle: getI18NKey().mine_menu_subtitle_focus_timing,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(
              context, 'CountDownListViewPage');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcMemoDayChecked,
          size: menuIconSize,
        ),
        title: getI18NKey().count_up_text,
        subtitle: getI18NKey().mine_menu_subtitle_important_days,
        onTap: () {
          JumpNavigator.onClickCustomHeaderGridView(
              context, 'CountUpListViewPage');
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcNote3, size: menuIconSize),
        title: getI18NKey().note_n,
        subtitle: getI18NKey().mine_menu_subtitle_note_management,
        onTap: () {
          context.read<GlobalStateEnv>().wqbModeEnum = WQBModeEnum.note;
          Utility.pushNavigator(context, const WQBContainer());
        },
      ),
      _MobileMineMenuEntry(
        icon:
            Utility.getSVGPicture(R.assetsImgIcMemorandum, size: menuIconSize),
        title: getI18NKey().memorandum,
        subtitle: getI18NKey().mine_menu_subtitle_memo_reminder,
        onTap: () {
          context.read<GlobalStateEnv>().wqbModeEnum = WQBModeEnum.memorandum;
          Utility.pushNavigator(context, const WQBContainer());
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcWrongQuestionBook,
          size: menuIconSize,
        ),
        title: getI18NKey().wrong_question_book,
        subtitle: getI18NKey().mine_menu_subtitle_wrong_question_review,
        onTap: () {
          context.read<GlobalStateEnv>().wqbModeEnum =
              WQBModeEnum.wrong_question_book;
          Utility.pushNavigator(context, const WQBContainer());
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcCard, size: menuIconSize),
        title: getI18NKey().card,
        subtitle: getI18NKey().mine_menu_subtitle_knowledge_cards,
        onTap: () {
          context.read<GlobalStateEnv>().wqbModeEnum = WQBModeEnum.card;
          Utility.pushNavigator(context, const WQBContainer());
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(
          R.assetsImgIcTomatoChecked,
          size: menuIconSize,
        ),
        title: getI18NKey().tomatoClockSetting,
        subtitle: getI18NKey().mine_menu_subtitle_pomodoro_focus,
        onTap: () {
          Utility.pushNavigator(
            context,
            const SettingPage(pageFrom: PageFromEnum.Normal),
          );
        },
      ),
      _MobileMineMenuEntry(
        icon: const Icon(Icons.filter_alt, color: Colors.black, size: 30),
        title: getI18NKey().filtering_setting,
        subtitle: getI18NKey().mine_menu_subtitle_task_filter,
        onTap: () {
          Utility.pushNavigator(context, FilterMenuSettingPage());
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcTheme, size: menuIconSize),
        title: getI18NKey().theme,
        subtitle: getI18NKey().mine_menu_subtitle_interface_theme,
        onTap: () {
          Utility.pushNavigator(context, ThemePage());
        },
      ),
      _MobileMineMenuEntry(
        icon:
            Utility.getSVGPicture(R.assetsImgIcPermission, size: menuIconSize),
        title: getI18NKey().permission_setting,
        subtitle: getI18NKey().mine_menu_subtitle_privacy_permission,
        onTap: () {
          Utility.pushNavigator(context, SettingPermissionPage());
        },
      ),
    ];

    if (Utility.isIOS()) {
      entries.insert(
        1,
        _MobileMineMenuEntry(
          icon: Utility.getSVGPicture(
            R.assetsImgIcLockscreenView,
            size: menuIconSize,
          ),
          title: getI18NKey().lock_app_setting,
          subtitle: getI18NKey().mine_menu_subtitle_lock_screen_widget,
          onTap: () {
            if (LoginManager.getInstance().isVIP(
              shouldShowDialog: true,
              paymentPromotionAdsModeEnum:
                  PaymentPromotionAdsModeEnum.Lockscreen,
            )) {
              Utility.pushNavigator(context, LockScreenPage());
            }
          },
        ),
      );
    }

    if (Utility.isHuaWei() == false) {
      entries.add(
        _MobileMineMenuEntry(
          icon:
              Utility.getSVGPicture(R.assetsImgIcFeedback, size: menuIconSize),
          title: getI18NKey().feedback,
          subtitle: getI18NKey().mine_menu_subtitle_user_feedback,
          onTap: () {
            Utility.pushNavigator(context, FeedbackPage());
          },
        ),
      );
    }

    entries.addAll([
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcFeedback2, size: menuIconSize),
        title: getI18NKey().copy_qq,
        subtitle: getI18NKey().mine_menu_subtitle_community,
        onTap: () {
          if (Localizations.localeOf(Utility.getGlobalContext()).languageCode !=
              'zh') {
            Utility.openExternalWebView(url: Urls.facebook);
          } else {
            Utility.copyToClipboard('563144208', shouldShowToast: false);
            Utility.showToastMsg(
                context: context, msg: getI18NKey().copy_qq_success);
          }
        },
      ),
      _MobileMineMenuEntry(
        icon: Utility.getSVGPicture(R.assetsImgIcCloudSync, size: menuIconSize),
        title: getI18NKey().cloud_sync,
        subtitle: getI18NKey().cloud_sync_content,
        onTap: () async {
          await onClickSyncCloud(context);
        },
      ),
    ]);

    if (Utility.isHuaWei() == false && ABTestSetting.isOpenAiOn) {
      entries.add(
        _MobileMineMenuEntry(
          icon:
              Utility.getSVGPicture(R.assetsImgIcAiHelper, size: menuIconSize),
          title: getI18NKey().ai_helper,
          subtitle: getI18NKey().mine_menu_subtitle_ai_assistant,
          onTap: () {
            Utility.pushNavigator(context, const GPTContainer());
          },
        ),
      );
    }

    if (Utility.isHandsetBySize() && LoginManager.isLogin()) {
      entries.add(
        _MobileMineMenuEntry(
          icon: Utility.getSVGPicture(
            R.assetsImgIcPrivacySetting,
            size: menuIconSize,
          ),
          title: getI18NKey().privacy_management,
          subtitle: getI18NKey().mine_menu_subtitle_data_management,
          onTap: () {
            Utility.pushNavigator(context, PrivacySettingPage());
          },
        ),
      );
    }

    return entries;
  }

  Future<void> onClickSyncCloud(BuildContext context) async {
    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().confirm,
        message: getI18NKey().confirmToSyncCloudData,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      EasyLoadingManager.getInstance().showLoading();
      await Future.wait([
        MongoApisManager.getInstance().batchUpdate_FolderModelSync(),
        MongoApisManager.getInstance().batchUpdate_MissionModelSync()
      ]).then((value) {});
      EasyLoadingManager.getInstance().hideLoading();
    }
  }

  Widget baseDesktoptBuild(BuildContext context) {
    return PCLeftMenuBarWidget(
      onTapAvatarWidgetListener: (data) {
        if (!LoginManager.isLogin()) {
          this.onClick("onClickToLogin", null);
        }
      },
      onTapListener: (sceneCode) {
        // if (sceneCode == "CalendarPage"){
        //   Utility.pushDesktopNavigator(context, sceneCode, {});
        // } else {
        Utility.setDesktopMiddileMissionPage(context, isVisible: true);
        Utility.popupDesktopRightNavigator(context);
        Utility.pushDesktopMainContainerNavigator(context, sceneCode, {});
        // }
      },
    );
  }

  Widget getUnloginHeaderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 200,
            height: 45,
            child: new ElevatedButton(
              child: new Text(getI18NKey().login,
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: ThemeManager.getInstance().getTextColor())),
              style: TextButton.styleFrom(
                backgroundColor:
                    ThemeManager.getInstance().getButtonBackgroundColor(),
                foregroundColor: Colors.white,
                side: BorderSide(
                    color: ThemeManager.getInstance().getButtonBorderColor(),
                    width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(23))),
              ),
              onPressed: () async {
                this.onClick("onClickToLogin", null);
              },
            )),
        SizedBox(
          height: 10,
        ),
        ThirdPartyLoginWidget(
          onTapGoogle: () {},
          onTapFacebook: () {},
        )
      ],
    );
  }

  Widget getLoginHeaderWidget() {
    return TextButton(
      onPressed: () {
        Utility.pushNavigator(context, SettingUserInfoPage());
      },
      style: StylesConfig.transparentTextButtonStyle,
      child: Row(
        children: [
          LoginAvatarWidget(),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !TextUtil.isEmpty(LoginManager.getInstance().userBean.username)
                  ? Text(
                      LoginManager.getInstance().userBean.username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  : TextButton(
                      onPressed: () {
                        Utility.pushNavigator(context, SettingUserInfoPage());
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              getI18NKey().add_username,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          )
                        ],
                      )),
              SizedBox(
                height: 3,
              ),
              LoginManager.getInstance().getUserBean().totalFocusTimeRanking !=
                          null &&
                      LoginManager.getInstance()
                              .getUserBean()
                              .totalFocusTimeRanking! >=
                          0
                  ? Wrap(
                      direction: Axis.vertical,
                      children: [
                        Text(
                          getI18NKey().my_ranking(LoginManager.getInstance()
                              .getUserBean()
                              .totalFocusTimeRanking
                              .toString()),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          getI18NKey().total_focus_time +
                              ":" +
                              Utility.formatHourAndMin(
                                  LoginManager.getInstance()
                                          .getUserBean()
                                          .totalFocusTime ??
                                      0),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    )
                  : SizedBox.shrink()
            ],
          ),
          Spacer(),
          MoneyHandlerWidget(
            pageFrom: PageFromEnum.MobileMinePage,
          ),
          SizedBox(
            width: 5,
          ),
          ConsumeMoneyButtonWidget(
            pageFrom: PageFromEnum.MobileMinePage,
            onTapListener: (obj) {},
          )
        ],
      ),
    );
  }

  Widget getProtocolWidget() {
    return GestureDetector(
      onTap: () {
        Utility.openWebViewLaunch(
            context: context,
            title: getI18NKey().privacy_protocol_title,
            url: Utility.getPrivacyProtocolUrl());
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getI18NKey().privacy_protocol_title,
            style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget getItem({Icon? icon, String? title, Function? onTapListener}) {
    return InkWell(
      onTap: () {
        if (onTapListener != null) {
          onTapListener();
        }
      },
      child: SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              icon != null ? icon : SizedBox.shrink(),
              SizedBox(
                width: 5,
              ),
              Text(
                title ?? '',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: ColorsConfig.gray_cc_cancel,
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )),
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
