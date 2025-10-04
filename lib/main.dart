import 'dart:async';

// import 'package:appflowy_editor/appflowy_editor.dart';
// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

// import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:time_hello/com/timehello/common/provider/CalendarMssionEnv.dart';

// import 'package:sharesdk_plugin/sharesdk_plugin.dart';
// import 'package:sharesdk_plugin/sharesdk_register.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/UnregisterPage/UnregisterPage.dart';
import 'package:time_hello/com/timehello/page/splashPage/SplashPage.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/HtmlUtility.dart';
import 'package:time_hello/com/timehello/util/NumTimesAppOpenManager.dart';
import 'package:time_hello/com/timehello/util/PrivacyProtocolManager.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/SettingManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// import 'package:wakelock/wakelock.dart';
import 'com/timehello/common/database/apis/MongoApisManager.dart';
import 'com/timehello/common/provider/Env.dart';
import 'com/timehello/common/provider/GlobalStateEnv.dart';
import 'com/timehello/common/provider/MissionDetailEnv.dart';
import 'com/timehello/config/ENUMS.dart';
import 'com/timehello/config/Params.dart';
import 'com/timehello/config/StylesConfig.dart';
import 'com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'com/timehello/libs/mongodb/MongoDb.dart';
import 'com/timehello/models/EventFn.dart';
import 'com/timehello/util/AnalyticsEventsManager.dart';
import 'com/timehello/util/CounterManagement.dart';
import 'com/timehello/util/EasyLoadingManager.dart';
import 'com/timehello/util/EventCollection.dart';
import 'com/timehello/util/FirebaseAuthManager.dart';
import 'com/timehello/util/LocaleProvider.dart';
import 'com/timehello/util/LoginManager.dart';
import 'com/timehello/util/NotificationManager.dart';
import 'com/timehello/util/SharePreferenceUtil.dart';
import 'com/timehello/util/SubscriptionAndPriceManager.dart';
import 'com/timehello/util/TextUtil.dart';
import 'com/timehello/util/TickTimeManager.dart';
import 'generated/l10n.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (DeviceInfoManagement.isWEB() == false) {
    // Wakelock.enable();
    // The following line will enable the Android and iOS wakelock.
    WakelockPlus.enable();
  }
  //需要加try catch 否则部分机型打不开
  try {
    await SharePreferenceUtil.getSyncInstance().init();
  } catch (e) {
    // CounterMethodChannelManager.getInstance().logs(TAG: "11111111111111111", msg: "error:" + e.toString());
  }
  if (!Utility.isXiaoMi()) {
    await FirebaseAuthManager.initialized();
  }

  // runZoned(() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => MissionDetailEnv()),
    ChangeNotifierProvider(create: (_) => Env()),
    ChangeNotifierProvider(create: (_) => GlobalStateEnv()),
    ChangeNotifierProvider(create: (_) => CalendarMssionEnv()),
  ], child: MyApp()));
  // }, onError: (error, stackTrace) {
  //   //  自定义处理错误
  //   CounterMethodChannelManager.getInstance().logs(TAG: "11111111111111111", msg: "error:" + stackTrace.toString());
  // });
}
//设置window最小尺寸和打开默认尺寸
// doWhenWindowReady(() {
//   final win = appWindow;
//   final initialSize = Size(1200, 1200);
//   final minSize = Size(1000, 600);
//   win.minSize = minSize;
//   win.size = initialSize;
//   win.alignment = Alignment.center;
//   win.title = "Custom window with Flutter";
//   win.show();
// });
// }

Future<void> initThirdparty(BuildContext context, bool isFirstTime) async {
  // print('1111111111111 initThirdparty');
  //初始化如果依赖sharePreference
  if (PrivacyProtocolManager.getInstance().isProtocolAgreed(context) == true) {
    if (Utility.isXiaoMi()) {
      await FirebaseAuthManager.initialized();
    }
    // ios价格初始化
    SubscriptionAndPriceManager.getInstance();
    NotificationManager.getInstance()?.init();
    MongoDb.initMasterKey(
        Params.mBaseUrl + "/api",
        "0f3592baa6ce18dcab13dde4660a0ed1",
        "8057ce55d5a89d7a",
        "cfe56bc01ee90da9285ec62e6ba2b698");
    //android id
    await MongoApisManager.getInstance();
    initDatas();
    //延时是为了躲避隐私规则提前执行bugly //会读取android id
    DeviceInfoManagement.getInstance();
    // if (ChannelEnum.huawei != Params.channelEnum) {
    Future.delayed(Duration(milliseconds: isFirstTime == true ? 2000 : 0), () {
      // Utility.showToast(context: context, msg: "toast");
      // iOSAppId: "your iOS app id",
      //这里会经过 Utility的getDeviceId()函数走device_info_plus上传android id
      // FirebaseManager.getInstance().init();
      EventCollection.init();
      if (Utility.isGooglePlay() == false) {
        // FlutterBugly.postCatchedException(() {
        //   // 如果需要 ensureInitialized，请在这里运行。
        //   // WidgetsFlutterBinding.ensureInitialized();
        //   FlutterBugly.init(
        //     androidAppId: "d65a6ede04",
        //     iOSAppId: "d65a6ede04",
        //   );
        // });
      }
    });
    // }
  }
}

initDatas() async {
  NumTimesAppOpenManager.getInstance().incTimes();
  try {
    Utility.getCurrentVersion();
  } catch (e) {}
  try {
    Utility.initMusicModel();
  } catch (e) {}
  //初始化计数器
  CounterManagement.getInstance();
  // DeviceInfoManagement.getInstance();
  NotificationManager.getInstance(); //有获取deviceId
  CounterMethodChannelManager.getInstance(); //
  CounterMethodChannelManager.getInstance().shareSdkSubmitPolicyGrantResult();
  // 一个计数器始终在后台运行
  TickTimeManager.getInstance();
  //日历的item pc和移动端会有所区别
  if (Utility.isHandsetBySize() == true) {
    StylesConfig.heightItemOfCalendar = 120;
  } else {
    StylesConfig.heightItemOfCalendar = 120;
  }

  // ShareSDKRegister register = ShareSDKRegister();
  // register.setupWechat(
  //     "wxb74e3f117aec1616", "d723b4ff42b4c5c2831cadf3c81b3b77", "https://www.timerbell.com/");
  // register.setupQQ("1112263382", "mVR98boYmSbBow72");
  // SharesdkPlugin.regist(register);
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends BaseWidget {
  // static CalendarModel calendarModel;
  static BuildContext? context;

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _MyAppState();
  }
}

class _MyAppState extends BaseWidgetState<MyApp> {
  int counter = 0;
  String appName = '';

  // This widget is the root of your application.
  void _initAsync() async {
    // await UserModel().getUserInfo(); //获取本地存储：用户信息
    // // 将获取到的库位数据保存到状态
    // var positionRes =
    // await getPositionListVm(UserModel.singleton.jwtToken, context);
    // context.read<CartModel>().savePositionList(positionRes.positions);
  }

  @override
  void initState() {
    super.initState();
    // if(DeviceInfoManagement.isWEB() == true) {
    //   EasyLoadingManager.getInstance().showLoading();
    // }

    HtmlUtility.dismissLoading();
    try {
      //app 生命周期
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        switch (msg) {
          // 从后台切换到前台，界面可见
          case "AppLifecycleState.resumed":
            break;
// 界面不可见，后台运行中
          case "AppLifecycleState.inactive":
            break;
// 界面不可见，后台不可见
          case "AppLifecycleState.paused":
            if (Utility.isMobile() &&
                CounterManagement.getInstance().counterStatus ==
                    CounterStatus.focusing) {
              CounterManagement.getInstance().leaveAppWhenFocusing();
            }
            break;
// App结束时调用
          case "AppLifecycleState.detached":
            break;
        }
        // debugPrint('SystemChannels> $msg');
        // msg是个字符串，是下面的值
        // AppLifecycleState.resumed
        // AppLifecycleState.inactive
        // AppLifecycleState.paused
        // AppLifecycleState.detached
        return msg;
      });
    } catch (e) {}
    // CounterMethodChannelManager.getInstance().logs(TAG: "11111111111111111", msg: "initState");
    // print('1111111111111 initState');
    // tz.initializeTimeZones();
    // setWindowMinSize(Size(1000, 1200));
    // tz.setLocalLocation(tz.getLocation(timeZoneName));
    //用于项目初始化 告诉app端当前环境
    CounterMethodChannelManager.getInstance().requestInit();
  }

  componentDidMount() {
    // CounterMethodChannelManager.getInstance().logs(TAG: "11111111111111111", msg: "main componentDidMount");
    // print('1111111111111 main componentDidMount');
    if(context != null) {
      MyApp.context = context;
    }
    if(!Utility.isChina()) {
      Params.useGmail = true;
    }

    try {
      LoginManager.getInstance().init();
      Future.delayed(Duration(milliseconds: 500), () {
        // AdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
        //   setState(() {
        //
        //   });
        // });
        //华为app名称
        //用于设置名称 比如滑动到切换应用页面 会显示这个名称
        if (Utility.isWindows() == false) appName = getI18NKey().app_name;
        updateUI();
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // 计数器结束
    TickTimeManager.getInstance().dispose();
  }

  List<NavigatorObserver> getObservers() {
    // if (DeviceInfoManagement.isWEB() == false) {
    //   return [AnalyticsEventsManager.getInstance().observer];
    // }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if(context != null) {
      MyApp.context = context;
    }
    // Bmob.init("https://api2.bmob.cn", "0f3592baa6ce18dcab13dde4660a0ed1", "d20617f5d73c96a94509a77e3856ef39");
    /**
     * 超级权限加密方式初始化
     */
    print(
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("code has been refreshed！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！");
    print(
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    // CounterMethodChannelManager.getInstance().logs(TAG: "11111111111111111", msg: "code has been refreshed");
    Locale? local = null;
    String curLocal = SharePreferenceUtil.getSyncInstance()
        .getString(key: ShareprefrenceKeys.curLocaleLanguage, defaultVal: '');
    String curLocalCountry = SharePreferenceUtil.getSyncInstance().getString(
        key: ShareprefrenceKeys.curLocaleCountryCode, defaultVal: '');
    if (!TextUtil.isEmpty(curLocal) || !TextUtil.isEmpty(curLocalCountry)) {
      S.load(local = Locale.fromSubtags(
          languageCode: curLocal ?? '',
          countryCode:
              TextUtil.isEmpty(curLocalCountry) ? null : curLocalCountry));
    }
    // local = Locale('fr');
    return AdaptiveTheme(
      light: ThemeManager.getInstance().getLightThemeData(),
      dark: ThemeManager.getInstance().getDarkThemeData(),
      initial: ThemeManager.getInstance().getThemeMode(),
      builder: (lightTheme, darkTheme) => MaterialApp(
        theme:
            ThemeManager.getInstance().getThemeMode() == AdaptiveThemeMode.light
                ? lightTheme
                : darkTheme,
        // theme: ThemeManager.getInstance().getThemeData(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        builder: EasyLoading.init(),
        navigatorObservers: getObservers(),
        // darkTheme: ThemeData(
        //   visualDensity: VisualDensity.adaptivePlatformDensity, //用于适配不同机型
        //   cupertinoOverrideTheme: const CupertinoThemeData(
        //     textTheme: CupertinoTextThemeData(), // This is required
        //   ),
        // ),
        locale: local,
        // const Locale.fromSubtags(
        //   languageCode: 'en')
        // ,
        // 自动检测设备语言
        localeResolutionCallback: (locale, supportedLocales) {
          // 检查设备当前语言是否在支持的语言列表中
          Params.local = locale;
          // Utility.showToastMsg(context: context, msg: "countryCode:" + (locale?.countryCode ?? '') + ' locale:' + (locale?.languageCode ?? ''));
          for (var supportedLocale in supportedLocales) {
            if (locale?.languageCode == 'zh') {
              // 中文走这里 因为有繁体
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            } else {
              if (supportedLocale.languageCode == locale?.languageCode) {
                //外语直接语言
                return supportedLocale;
              }
            }
          }
          // 如果设备语言不支持，默认使用英文
          return supportedLocales.first;
        },
        localizationsDelegates: const [
          // 很强大的记事本
          // AppFlowyEditorLocalizations.delegate,
          //用于国际化
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // This is required
          SfGlobalLocalizations.delegate,
          S.delegate
        ],
        // locale: Locale("en"),
        supportedLocales: [
          // ...L10n.all,
          Locale("en"),
          // 英语 默认选择第一个
          Locale("zh", 'CN'),
          //台湾
          Locale("zh"),
          //中文
          Locale("zh", 'HK'),
          //香港
          Locale("zh", 'TW'),
          //台湾
          Locale("zh", 'Hant'),
          //台湾
          Locale("fr"),
          //法语
          Locale("de"),
          //de
          Locale("ko"),
          //韩语
          Locale("ja"),
          //日语
          //日语
          // const Locale.fromSubtags(languageCode: 'ja'),
          //
          // //韩语
          // const Locale.fromSubtags(languageCode: 'ko'),
          // //德语
          // const Locale.fromSubtags(languageCode: 'de'),
          // // 法语
          // const Locale.fromSubtags(languageCode: 'fr'),
          //
          // const Locale.fromSubtags(languageCode: 'zh'),
          // // generic Chinese 'zh'
          // // const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
          // // // generic simplified Chinese 'zh_Hans'
          // // const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
          // // generic traditional Chinese 'zh_Hant'
          // const Locale.fromSubtags(
          //     languageCode: 'zh',  countryCode: 'CN'),
          // // 'zh_Hans_CN'
          // // const Locale.fromSubtags(
          // //     languageCode: 'zh',  countryCode: 'TW'),
          // // 'zh_Hant_TW'
          // const Locale.fromSubtags(
          //     languageCode: 'zh',  countryCode: 'HK'),
          // 'zh_Hant_HK'
        ],
        title: appName,
        // theme: ThemeData(
        //     primaryColor: Colors.black
        // ),
        home: SplashPage(),
        routes: {
          "unregister": (BuildContext context) => new UnregisterPage(),
          // web会以hash展示  https://www.timerbell.com/#unregister
          // "BottomTabBarHome": (BuildContext context) => new BottomTabBarHome(),
        },
      ),
    );
  }
}
