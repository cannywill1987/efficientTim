import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/GridMenuItem.dart';
import 'package:time_hello/com/timehello/components/LoginAvatarWidget.dart';
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
import 'package:time_hello/com/timehello/util/CloudSharepreferenceManagement.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/JumpNavigator.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
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
import '../../components/MoneyHandlerWidget.dart';
import '../../components/GridMenuItem.dart';
import '../../components/ThirdPartyLoginWidget.dart';
import '../../config/ENUMS.dart';
import '../../util/DialogManagement.dart';
import '../../util/GetResourceDeliveryManager.dart';
import '../../util/Perf.dart';
import '../FeedbackPage/FeedbackPage.dart';
import '../FlomoPage/components/FlomoPickPeriodDialogWidget.dart';
import '../PrivacySettingPage/PrivacySettingPage.dart';

import '../SettingPage/SettingPage.dart';
import '../SettingPage/SettingPermissionPage.dart';
import '../SettingUserInfoPage/SettingUserInfoPage.dart';
import '../WrongQuestionBookPage/WQBContainer.dart';
import 'components/MineHeaderWidget.dart';

/**
 * 我的叶绵绵
 */
class MinePage extends BaseWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _MinePageState();
  }
}

class _MinePageState extends BaseWidgetState<MinePage> {
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
          title: "测试用2",
          onTapListener: () async {
            ScreenLockManager.getInstance().showPasword();
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
          title: "测试用3",
          onTapListener: () async {
            CounterMethodChannelManager.getInstance().shareToWeChat(
                title: "title",
                subtitle: 'subtitle',
                iconUrl:
                    'https://static.smyfinancial.com/_pc_proj/shengbeiTech_new/release/static/img/about1.jpg',
                url: "https://www.timerbell.com/qq_conn/1112263382",
                toWhere: 1);
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
          title: "测试用4",
          onTapListener: () async {
            final perf = Perf();
            perf.start();
            await Future.wait([
              MongoApisManager.getInstance().queryWhereEqual_folderModel(),
              MongoApisManager.getInstance().queryWhereEqual_missionData(),
              MongoApisManager.getInstance().queryWhereEqual_statsModel(),
              MongoApisManager.getInstance()
                  .queryWhereEqual_TimelineMissionModel(),
              MongoApisManager.getInstance()
                  .queryWhereEqual_EndTimeMissionModel(),
              MongoApisManager.getInstance().queryWhereEqual_CourseModel(),
            ]);
            perf.stop();
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
            Utility.pushNavigator(context, LockScreenPage());
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
    // if(Utility.isHuaWei() == false) {
    //   list.add(GridMenuItem(
    //       icon: Utility.getSVGPicture(R.assetsImgIcAiHelper, size: iconSize),
    //       title: getI18NKey().ai_helper,
    //       // subtitle: getI18NKey().cloud_sync_content,
    //       onTapListener: () async {
    //         // WQBModeEnum modeEnum = WQBModeEnum.memorandum;
    //         // context.read<GlobalStateEnv>().wqbModeEnum = modeEnum;
    //         Utility.pushNavigator(context, const GPTContainer());
    //       }));
    // }
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
        icon: Utility.getSVGPicture(R.assetsImgIcMemoryCard, size: iconSize),
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
        icon: Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: iconSize + 5),
        title: getI18NKey().tomatoClockSetting,
        onTapListener: () {
          Utility.pushNavigator(
              context, const SettingPage(pageFrom: PageFromEnum.Normal));
        }));

    list.add(GridMenuItem(
        icon: Icon(Icons.filter_alt, size: iconSize + 5),
        title: getI18NKey().filtering_setting,
        onTapListener: () {
          Utility.pushNavigator(
              context,  FilterMenuSettingPage());
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
    list.add(GridMenuItem(
        icon: Utility.getSVGPicture(R.assetsImgIcFeedback, size: iconSize + 7),
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
    return Container(
      child: ListView(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: ThemeManager.getInstance().isDark()
                ? null
                : ThemeManager.getInstance().getDefautThemeColor(),
            // gradient:
          ),
          height: 200,
          child: Stack(
            children: [
              Center(
                  child: LoginManager.isLogin()
                      ? getLoginHeaderWidget()
                      : getUnloginHeaderWidget()),
              Positioned(
                  bottom: 3,
                  right: 10,
                  child: DownloadListwidget(
                    shouldShowWinAndAndroid:
                        !(Utility.isIOS() || Utility.isMacOS()),
                  ))
            ],
          ),
        ),
        // MineHeaderWidget(),
        ...getGridViewService(3),
        Container(
          height: 10,
        ),
        ...getGridViewNote(3),
        Container(
          height: 10,
        ),
        ...getGridViewSetting(3),
        // ...getGridView(3),
        LoginManager.isLogin()
            ? getLogoutItem(onTapListener: () {
                LoginManager.getInstance().logout(context);
              })
            : SizedBox.shrink(),
        getProtocolWidget(),
        SizedBox(
          height: 30,
        ),
      ]),
    );
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
              !TextUtil.isEmpty(LoginManager.getInstance().userBean?.username)
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
                        )
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
