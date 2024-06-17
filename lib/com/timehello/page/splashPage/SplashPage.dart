import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/CreditCardModel.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/ChatGptPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GPTRoleGridViewPage.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/pages/GptChatHistoryPage.dart';
import 'package:time_hello/com/timehello/page/CreateAIChatGptMissionPage/CreateAIChatGptMissionPage.dart';
import 'package:time_hello/com/timehello/page/MainContainerWidget.dart';
import 'package:time_hello/com/timehello/page/folderspage/FoldersPage.dart';
import 'package:time_hello/com/timehello/page/registerPage/pages/RegisterEmailVerificationPage.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/PrivacyProtocolManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../../../main.dart';
import '../../../../r.dart';
import '../../beans/ResourceDeliveryInfoBean.dart';
import '../../beans/ResourceLocationInfoBean.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/FamousSentenceWidget.dart';
import '../../components/SubmissionSliverList.dart';
import '../../config/ColorsConfig.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../util/AutoUpdateManager.dart';
import '../../util/GetResourceDeliveryManager.dart';
import '../CreateAIChatGptMissionPage/CreateAIChatGptMissionWidget.dart';
import '../CreditCardManagementPage/components/RepayDialogWidget.dart';
import '../CreditCardManagementPage/pages/CreateCreditCardPage.dart';
import '../CreditCardManagementPage/pages/CreditCardDetailPage.dart';
import '../CreditCardManagementPage/pages/CreditCardPage.dart';
import '../DrawPage/DrawingPage.dart';
import '../FlomoPage/FlomoCreatePage.dart';
import '../FlomoPage/FlomoPage.dart';
import '../RecorderPage/RecordPage2.dart';
import '../TestPage/Test3Page.dart';
import '../TestPage/Test5Page.dart';
import '../TestPage/TestPage.dart';
import '../ThemePage/ThemePage.dart';
import '../UnregisterPage/UnregisterPage.dart';
import '../WebviewPage/WebviewPage.dart';
import '../WrongQuestionBookPage/WrongQuestionBookPage.dart';
import '../demoPages/SampleView2.dart';
import '../missionDetailPage/components/MobileFlipCounterWidget.dart';
import '../missionPage/GroupMissionPage.dart';
import 'components/BakgroundSplashWidget.dart';

class SplashPage extends BaseWidget {
  SplashPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SplashPageState();
  }
}

//1 进行中 - 红色
class _SplashPageState<T> extends BaseWidgetState<SplashPage> {
  Timer? _timer;
  int _countdownTime = 3;

  // BuildContext? context;

  @override
  void onCreate() {
    super.onCreate();
    this.isAppBarVisible = false;
    curPage = "SplashPage";
  }

  void initData() async {
    //登录初始化token等数据
    // AnalyticsEventsManager.getInstance().sendAnalyticsEvent(name:"SplashPage");


    await LoginManager.getInstance().init();
    //登录就重新刷新sessionId等
    if (LoginManager.isLogin() == true) {
      LoginManager.getInstance().requestFromSplashScreen();
    }
    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('prompts', isCachableOn: true,
        onResourceComplete:
            (List<ResourceLocationInfoBean> response, bool isFromCache) {
          if(response.length > 0) {
            ResourceInfo.promptsGptResourceLocationInfoBean = response[0];
          }
        });

    /**
     * 打卡的默认数据
     */
    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('clockin_sentence', isCachableOn: true,
            onResourceComplete:
                (List<ResourceLocationInfoBean> response, bool isFromCache) {
      ResourceInfo.clockInSentenceResourceLocationInfoBeanList = response;
    });

    // 获取名言名句
    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('famous_sentence', isCachableOn: true,
            onResourceComplete:
                (List<ResourceLocationInfoBean> response, bool isFromCache) {
      ResourceInfo.famousSentenceResourceLocationInfoBean =
          Utility.getResourceDeliveryItemFromList('famous_sentence', response);
      Utility.getSplashFamousSentence();
    });

    // 获取背景
    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('background', isCachableOn: true,
            onResourceComplete:
                (List<ResourceLocationInfoBean> response, bool isFromCache) {
      ResourceInfo.allMissionBackgroundResourceLocationInfoBean =
          Utility.getResourceDeliveryItemFromList(
              'mission_background', response);
      ResourceInfo.pcMissionBackgroundResourceLocationInfoBean =
          Utility.getResourceDeliveryItemFromList(
              'pc_mission_background', response);
      ResourceInfo.mobileMissionBackgroundResourceLocationInfoBean =
          Utility.getResourceDeliveryItemFromList(
              'mobile_mission_background', response);
      ResourceInfo.missionItemBackgroundLocationInfoBean =
          Utility.getResourceDeliveryItemFromList(
              'mission_item_background', response);
    });
    //初始化所需要的参数
    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('timehello_init', isCachableOn: true,
            onResourceComplete:
                (List<ResourceLocationInfoBean> response, bool isFromCache) {
      try {
        List<ResourceDeliveryInfoBean>? deliveryList =
            Utility.getResourceDeliveryItemFromList('versionInfo', response)
                    ?.deliveryList ??
                [];

        Params.curLatestVersionAndroid =
            Utility.getResourceDeliveryInfoBeanByKey(
                        deliveryList ?? [], 'android')
                    ?.extendParamsMap?['versions'] ??
                "";
        Params.curLatestVersionIOS =
            Utility.getResourceDeliveryInfoBeanByKey(deliveryList ?? [], 'ios')
                    ?.extendParamsMap?['versions'] ??
                "";
        Params.curLatestVersionMAC = Utility.getResourceDeliveryInfoBeanByKey(
                    deliveryList ?? [], 'macos')
                ?.extendParamsMap?['versions'] ??
            "";
        Params.curLatestVersionWin = Utility.getResourceDeliveryInfoBeanByKey(
                    deliveryList ?? [], 'windows')
                ?.extendParamsMap?['versions'] ??
            "";
        // ResourceDeliveryInfoBean? deliveryInfoBean =
        //     DeviceInfoManagement.isAndroid() == true
        //         ? Utility.getResourceDeliveryInfoBeanByKey(
        //             deliveryList ?? [], 'android')
        //         : DeviceInfoManagement.isIOS() == true
        //             ? Utility.getResourceDeliveryInfoBeanByKey(
        //                 deliveryList ?? [], 'ios')
        //             : DeviceInfoManagement.isMacOs()
        //                 ? Utility.getResourceDeliveryInfoBeanByKey(
        //                     deliveryList ?? [], 'macos')
        //                 : DeviceInfoManagement.isWindows()
        //                     ? Utility.getResourceDeliveryInfoBeanByKey(
        //                         deliveryList ?? [], 'windows')
        //                     : null;
        // if (deliveryInfoBean != null) {
        //   Params.updateInfoDeliveryInfoBean = deliveryInfoBean;
        //   //获取最新版本
        //   String latestVersion =
        //       deliveryInfoBean.extendParamsMap?['versions'] ?? "";
        //   Params.latestVersion = latestVersion;
        // }
        if (ResourceInfo.famousSentenceResourceLocationInfoBean == null) {
          ResourceInfo.famousSentenceResourceLocationInfoBean =
              Utility.getResourceDeliveryItemFromList(
                  'famous_sentence', response);
        }
        if (ResourceInfo.chatGptRolesResourceLocationInfoBean == null) {
          ResourceInfo.chatGptRolesResourceLocationInfoBean =
              Utility.getResourceDeliveryItemFromList(
                  'chatgpt_roles', response);
        }

        if (ResourceInfo.chatGptRolesForCreateMissionResourceLocationInfoBean ==
            null) {
          ResourceInfo.chatGptRolesForCreateMissionResourceLocationInfoBean =
              Utility.getResourceDeliveryItemFromList(
                  'chatgpt_roles_for_create_mission', response);
        }

        MarqueInfo.marqueFolderpage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_folderpage');
        MarqueInfo.marqueMissionpage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_missionpage');
        MarqueInfo.marqueCalendarpage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_calendarpage');
        MarqueInfo.marqueGamepage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_gamepage');
        MarqueInfo.marqueStatispage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_statispage');
        MarqueInfo.marqueFourQuadrantPage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'FourQuadrantPage');
        MarqueInfo.marqueExportXls = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_export_xls');
        MarqueInfo.marqueSettingVolume = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_volume');
        MarqueInfo.marqueSettingVolume = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_volume');
        MarqueInfo.marqueChatGptPage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_ChatGptPage');
        MarqueInfo.marqueGPTPage = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_gpt_page');

        MarqueInfo.marqueSettingItemDetail = Utility.getDeliveryInfoBean(
            response: response,
            key: 'marque',
            code: 'marque_setting_item_detail');
        MarqueInfo.marqueTimemanagement = Utility.getDeliveryInfoBean(
            response: response, key: 'marque', code: 'marque_time_management');

        MarqueInfo.marqueCreateAIChatGptMissionPage =
            Utility.getDeliveryInfoBean(
                response: response,
                key: 'marque',
                code: 'marque_create_ai_chat_gpt_mission_page');

        ResourceDeliveryInfoBean? bean_register_dynamic_code =
            Utility.getDeliveryInfoBean(
                response: response,
                key: 'ab_setting',
                code: 'register_dynamic_code');
        ResourceDeliveryInfoBean? isOpenOn = Utility.getDeliveryInfoBean(
            response: response, key: 'ab_setting', code: 'isOpenAiOn');
        ResourceDeliveryInfoBean? isCourseOn = Utility.getDeliveryInfoBean(
            response: response, key: 'ab_setting', code: 'isCourseOn');

        ResourceDeliveryInfoBean? bean_huawei_secverify_on =
            Utility.getDeliveryInfoBean(
                response: response,
                key: 'ab_setting',
                code: 'huawei_secverify_on');
        ResourceDeliveryInfoBean? facebook_login_on =
            Utility.getDeliveryInfoBean(
                response: response,
                key: 'ab_setting',
                code: 'facebook_login_on');
        ResourceDeliveryInfoBean? google_login_on = Utility.getDeliveryInfoBean(
            response: response, key: 'ab_setting', code: 'google_login_on');

        bool isLatestVersion = Utility.isLatestVersion(
            isOpenOn?.extendParamsMap?['version'] ?? "",
            defaultval: false);
        //华为最新版本 会根据开关判断
        // if (isLatestVersion && Utility.isHuaWei() == true) {
        //   ABTestSetting.isOpenAiOn = (isOpenOn?.extendParamsMap?['isOn'] ??
        //       true); // 开关默认开 且不是最新ban'ben
        // } else {
        //   ABTestSetting.isOpenAiOn = true;
        // }
        ABTestSetting.isOpenAiOn =  (isOpenOn?.extendParamsMap?['isOn'] ??
            true); // 开关默认开 且不是最新版本
        if (isLatestVersion && Utility.isHuaWei() == true) {
          ABTestSetting.isCourseOn = (isOpenOn?.extendParamsMap?['isOn'] ??
              true); // 开关默认开 且不是最新ban'ben
        } else {
          ABTestSetting.isCourseOn = true;
        }

        print(
            'isLatestVersion $isLatestVersion extendParamsMap ${(isOpenOn?.extendParamsMap?['isOn'] ?? true)} absetting:${ABTestSetting.isOpenAiOn}');
        ABTestSetting.isRegisterDynamicCode =
            bean_register_dynamic_code?.extendParamsMap?['isOn'] ?? false;
        ABTestSetting.isHuaweiSecVerifyOn =
            bean_huawei_secverify_on?.extendParamsMap?['isOn'] ?? false;
        ABTestSetting.isFacebookOn =
            facebook_login_on?.extendParamsMap?['isOn'] ?? false;
        ABTestSetting.isGoogleOn =
            google_login_on?.extendParamsMap?['isOn'] ?? false;

        print('');
      } catch (e) {}
    });

    //获取游戏初始化数据
    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('timerhello_game', isCachableOn: true,
            onResourceComplete:
                (List<ResourceLocationInfoBean> response, bool isFromCache) {
      try {
        // = response;
        context.read<GlobalStateEnv>().gamePagesResourceDeliveryInfoBeanList =
            Utility.getResourceDeliveryItemFromList('vision_focus', response)
                    ?.deliveryList ??
                [];
        context.read<GlobalStateEnv>().gameBackgroundDeliveryInfoBeanList =
            Utility.getResourceDeliveryItemFromList('game_background', response)
                    ?.deliveryList ??
                [];
      } catch (e) {}
    });
  }

  @override
  void onClick(type, data) {}

  @override
  void initState() {
    super.initState();
    // sets theme mode to dark
    // AdaptiveTheme.of(context).setDark();
    this.shouldShowSafeArea = false;
    this.isAppBarVisible = false;
    try {
      CounterMethodChannelManager.getInstance();
    } catch (e) {}
    // try {
    //   AnalyticsManager.getInstance().sendAnalyticsEvent(name: "test_event");
    // } catch(e) {
    //
    // }
    // this.initData();
  }

  componentDidMount() {
    print('componentDidMount');
    // 如果第一次打开app需要有隐私协议
    PrivacyProtocolManager.getInstance().showDialog(this.context,
        jumpCallback: () {
      startCountdownTimer();
      this.initData();
      //各种授权
      CounterMethodChannelManager.getInstance().requestInit();
      CounterMethodChannelManager.getInstance().initPushNotification();
      initThirdparty(Utility.getGlobalContext(), false);
      // AutoUpdateManager.getInstance()
      //     .checkVersionCode(context, Params.latestVersion);
    }, okCallback: () {
      PrivacyProtocolManager.getInstance().hideDialog(context);
      startCountdownTimer();
      //测试android id是否在同意后获取
      // Future.delayed(Duration(milliseconds: 500), () {
      CounterMethodChannelManager.getInstance().initPushNotification();
      initThirdparty(Utility.getGlobalContext(), true);
      this.initData();
      // });
    }, cancelCallback: () {
      Utility.exitApp();
    }, onClickLink: () {
      //点击隐私协议上面的链接会实现跳转
      Utility.pushNavigator(
          context,
          WebviewPage(
            title: getI18NKey().privacy_protocol_title,
            url: Utility.getPrivacyProtocolUrl(),
          ));
    });
  }

  @override
  void didUpdateWidget(SplashPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // this.context = context;
    //return super.baseBuild(context);
    return Stack(children: [
      Container(
        color: Color(0xfff9dd4b),
      ),
      // Positioned(right: 20, top: 400, child: ),
      Positioned(
        child: Image.asset(R.assetsImgIcSplashDuck),
        bottom: 0,
        right: 0,
      ),
      // BakgroundSplashWidget(),
      Positioned(
        top: 160,
        left: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getI18NKey().hello,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: ColorsConfig.textColorSplashPage),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              getI18NKey().welcome_to_time_department(getI18NKey().app_name),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: ColorsConfig.textColorSplashPage),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              getI18NKey().your_time_prof,
              style: TextStyle(
                  fontSize: 20, color: ColorsConfig.textColorSplashPage),
            ),
            SizedBox(
              height: 100,
            ),
            FamousSentenceWidget()
          ],
        ),
      ),

      Positioned(
          top: 50,
          right: 30,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                border: new Border.all(width: 1.0, color: Color(0xff999999)),
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
              _countdownTime.toString(),
              style: TextStyle(fontSize: 14, color: Color(0xff777777)),
            )),
          )),
    ]);
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          if (_timer != null && mounted)
            {
              setState(() {
                if (_countdownTime < 2) {
                  _timer?.cancel();
                  _timer = null;
                  // Utility.pushReplacement(context, MinePage());
                  // Utility.pushReplacement(context, ReadOnlyPage());
                  // Utility.pushReplacement(context, RecordPage());
                  // Utility.pushReplacement(context, ForgetPasswordPage());
                  // Utility.pushReplacement(context, CreateEndTimePage());
                  // Utility.pushReplacement(context, ChatGptPage());
                  // Utility.pushReplacement(context, CreateAIChatGptMissionPage());
                  // Utility.pushReplacement(context, RepayDialogWidget());
                  // Utility.pushReplacement(context, CreditCardDetailPage());
                  // Utility.pushReplacement(context, TestPage());
                  // Utility.pushReplacement(context, MobileFlipCounterWidget());
                  // Utility.pushReplacement(context, Test3Page());
                  //   Utility.pushReplacement(context, FoldersPage2(onTapListener: (Map<dynamic, dynamic> obj) {
                  //
                  //   },));
                  // Utility.pushReplacement(context, ThemePage());

                  // Utility.pushReplacement(context, GptChatHistoryPage());
                  // Utility.pushReplacement(context, GPTRoleGridViewPage());
                  // Utility.pushReplacement(context, ChatGptPage());
                  // Utility.pushReplacement(context, RegisterEmailVerificationPage(pageFromEnum: PageFromEnum.RegisterPage, email: '', password: '',));
                  Utility.pushReplacement(context, MainContainerWidget());
                  // Utility.pushReplacement(context, GroupChatSharingWidget());
                  // Utility.pushReplacement(context, MainContainerWidget());
                  // Utility.pushReplacement(context, CreateAIChatGptMissionWidget(listMissionModel: [],));

                  // Utility.pushReplacement(context, CreateAIChatGptMissionPage());

                  // Utility.pushReplacement(context, GroupMissionPage());

                  // Utility.pushReplacement(context, CreditCardPage());
                  // Utility.pushReplacement(context, CreateCreditCardPage(creditCardModel: CreditCardModel(),));
                  // Utility.pushReplacement(context, UnregisterPage());

                  // Utility.pushReplacement(context, SubmissionSliverList());

                  // Utility.pushReplacement(context, DrawingPage());

                  // Utility.pushReplacement(context, RecordPage2());
                  // Utility.pushReplacement(context, RecorderPageWidget());
                  // Utility.pushReplacement(context, WrongQuestionBookPage(key: ValueKey("12432"),));

                  // Utility.pushReplacement(context, FlomoCreatePage());
                  // Utility.pushReplacement(context, FlomoPage());
                  // Utility.pushReplacement(context, FlomoDetailPage(flomoMissionModel: FlomoMissionModel()));
                  // Utility.pushReplacement(context, SelectShareFolderPage());
                  // Utility.pushReplacement(context, CarouselPage());
                  // Utility.pushReplacement(context, CreateShareFolderPage());

                  // Utility.pushReplacement(context, TimeListViewPage());

                  // Utility.pushReplacement(context, TimeLinePage());
                  // Utility.pushReplacement(context, TestPage());
                  // Utility.pushReplacement(context, SummaryPage());
                  // Utility.pushReplacement(context, CreateMissionPage());
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            }
        };

    _timer = Timer.periodic(oneSec, callback);
  }
}
