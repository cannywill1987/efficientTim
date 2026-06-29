import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/provider/GlobalStateEnv.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/page/AppFlowyPage/components/AppFlowyControlWidget.dart';
import 'package:time_hello/com/timehello/page/MobileTabBarHome.dart';
import 'package:time_hello/com/timehello/page/PCMainHomePage.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../common/database/apis/MongoApisManager.dart';
import '../config/CONSTANTS.dart';
import '../config/ENUMS.dart';
import '../config/EVENTNAME.dart';
import '../models/EventFn.dart';
import '../models/MissionModel.dart';
import '../util/AnalyticsEventsManager.dart';
import '../util/CloudSharepreferenceManagement.dart';
import '../util/LoginManager.dart';
import '../util/NumTimesAppOpenManager.dart';
import '../util/OverlayManagement.dart';

class MainContainerWidget extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return new MainContainerWidgetState();
  }
}

class MainContainerWidgetState extends BaseWidgetState<MainContainerWidget> {
  @override
  void onCreate() {
    super.onCreate();
    curPage = "MainContainerWidget";
  }

  @override
  void initState() {
    super.initState();
    isAppBarVisible = false;
    //用于初始化Ios的liveActivity
    initIOSLiveActivity();
    //结束当前liveActivity
    CounterMethodChannelManager.getInstance().stopLiveActivity();
    // App Store 审核要求首启和 onboarding 阶段不要主动弹系统授权/评分类请求。
    // 通知授权保留在用户创建提醒、番茄钟或设置页主动开启时再触发，避免 macOS 审核机启动后被系统弹窗卡住。
    // CounterMethodChannelManager.getInstance().grantNotificationPermission();
    //没登录且deviceId为空，尝试重新获取一次deviceId
    if ((MongoApisManager.getInstance().device_id == null ||
            MongoApisManager.getInstance().device_id?.isEmpty == true) &&
        LoginManager.isLogin() == false) {
      MongoApisManager.getInstance().init(); //跨手机登录等需要重新同步数据会获取android id
    }


    // FlutterBugly.postCatchedException(() {
    //   // 如果需要 ensureInitialized，请在这里运行。
    //   // WidgetsFlutterBinding.ensureInitialized();
    //   FlutterBugly.init(
    //     androidAppId: "d65a6ede04",
    //     iOSAppId: "d65a6ede04",
    //   );
    // });
  }


  //ios销毁时
  void initIOSLiveActivity() {
    if (Utility.isIOS() == true) {
      CounterMethodChannelManager.getInstance().addOnRequestFinishListener(
          onMethodChannelResponseLisntener: (String method, Map arguments, MethodChannel channel) {
            switch (method) {
              case "pushToPage":
              //要加这个 否则报错
                CounterStatus counterStatusEnum = CounterStatus.values[0];
                if (arguments['counterStatusEnum'] == 3) {
                  counterStatusEnum = CounterStatus.focusing;
                } else if (arguments['counterStatusEnum'] == 4) {
                  counterStatusEnum = CounterStatus.relaxing;
                }

                int lastStartTimeBySecond = arguments['lastStartTime'];
                int timeHasUsed =
                    Utility.getTimeStampToday() - lastStartTimeBySecond * 1000;
                String objectId = arguments['objectId'];
                // int time = arguments['time'];
                if (objectId != null) {
                  print(
                      "~~~~~~~~~~~~~~~~~~~~~~~~~~ ${arguments['counterStatusEnum']} ~~~~~~~~~~~~~~~~~~~~~~~~~~");
                  // print("objectId ${objectId},counterStatusEnum ${counterStatusEnum.toString()},lastStartTime ${lastStartTime.toString()},time ${timeHasUsed.toString()} ");
                  MissionModel missionModel;
                  CounterManagement.getInstance().removeAllListeners();
                  if (CounterManagement.getInstance().missionModel != null) {
                    missionModel = CounterManagement.getInstance()?.missionModel ?? MissionModel();
                  } else {
                    missionModel = MongoApisManager.getInstance()
                        ?.queryWhereEqual_missionDataByObjectId(objectId: objectId) ?? MissionModel();
                  }
                  FolderModel folderModel = MongoApisManager.getInstance()
                      ?.queryfolderModelWithFolderId(missionModel?.folder_id) ?? FolderModel();
                  OverlayManagement.getInstance().openMissionDetailPageOverlay(
                      context: context,
                      timeHasUsed: timeHasUsed,
                      pageEnum: PageEnum.LiveActivity,
                      counterStatusFromLiveActivity: counterStatusEnum,
                      missionModel: missionModel,
                      folderModel: folderModel);
                }
                break;
            }
          });

      CounterMethodChannelManager.getInstance().getLiveActivityData(
          result: (BaseBean res) {
        try {
          String objectId = res.data['objectId'];
          int lastStartTime = res.data['lastStartTime'];
          int counterStatusEnumValue = res.data['counterStatusEnum'];
          int time = res.data['time'];

          if (TextUtil.isEmpty(objectId) == true) {
            return;
          }
          CounterStatus counterStatusEnum =
              CounterStatus.values[counterStatusEnumValue];
          if (counterStatusEnumValue == 3) {
            counterStatusEnum = CounterStatus.focusing;
          } else if (counterStatusEnumValue == 4) {
            counterStatusEnum = CounterStatus.relaxing;
          }

          int lastStartTimeBySecond = lastStartTime;
          int timeHasUsed =
              Utility.getTimeStampToday() - lastStartTimeBySecond * 1000;
          // String objectId = arguments['objectId'];
          // int time = arguments['time'];
          if (objectId != null) {
            print(
                "~~~~~~~~~~~~~~~~~~~~~~~~~~ ${counterStatusEnum} ~~~~~~~~~~~~~~~~~~~~~~~~~~");
            // print("objectId ${objectId},counterStatusEnum ${counterStatusEnum.toString()},lastStartTime ${lastStartTime.toString()},time ${timeHasUsed.toString()} ");
            MissionModel missionModel;
            CounterManagement.getInstance().removeAllListeners();
            if (CounterManagement.getInstance().missionModel != null) {
              missionModel = CounterManagement.getInstance()?.missionModel ?? MissionModel();
            } else {
              missionModel = MongoApisManager.getInstance()
                  ?.queryWhereEqual_missionDataByObjectId(objectId: objectId) ??MissionModel();
            }
            FolderModel folderModel = MongoApisManager.getInstance()
                ?.queryfolderModelWithFolderId(missionModel?.folder_id) ?? FolderModel();
            OverlayManagement.getInstance().openMissionDetailPageOverlay(
                context: context,
                timeHasUsed: timeHasUsed,
                pageEnum: PageEnum.LiveActivity,
                counterStatusFromLiveActivity: counterStatusEnum,
                missionModel: missionModel,
                folderModel: folderModel);
          }
        } catch (e) {}
      });
    }
  }

  @override
  didUpdateWidget(MainContainerWidget oldWidget) {
    if (Params.env == EnvEnum.dev) {
      Utility.showToastMsg(msg: "更新成功");
    }
    super.didUpdateWidget(oldWidget);
  }

  componentDidMount() {
    initData();
    if(LoginManager.getInstance().isLogin2() && SharePreferenceUtil.getSyncInstance().getDefault9DigitPasswordsNeedShowWhenLogin() == true && ScreenLockManager.getInstance().hasPassword()) {
      ScreenLockManager.getInstance().showPasword();
    }
    if(ABTestSetting.isOpenAiOn == true && Utility.isAndroid() == true && Utility.isIOS()) {
      Utility.openRightSideDesktopNavigator(
          context, 'ChatGptPage', {});
    }
  }

  initData() async {
    //app打开次数统计 等于3次先显示引导弹窗
    if(NumTimesAppOpenManager.getInstance().numTimesOpen == 3) {
      // App Store 审核要求：暂时隐藏首轮使用期间的评分弹窗，避免在用户充分体验前请求评分。
      // DialogManagement.showRatingDialog(context, scene: EVENTNAME.MainContainerWidget);
    }

    //todo 应该用不上了 机子是否第一次启动
    CounterMethodChannelManager.getInstance()
        .requestPreVerify(result: (BaseBean) {});
    // sharesdk秒验预登陆 应该用不上
    LoginManager.getInstance().requestPreVerify();
    try {
      Params.isFirstTime = await CloudSharepreferenceManagement.getInstance()
          .getBool("IsFirstTime", true);
      if (Params.isFirstTime == true) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "SplashPage","eventType": "uv"});
      }

      //没登录 历史没数据 且是第一次
      // Params.hasGuidMissionDataInit == false &&
      //     isFirstTime == true &&
      //     MongoApisManager.getInstance().listMissionModels.length == 0 &&
      // Future.delayed(Duration(seconds: 3), (){
      //
      // });
      if (
      LoginManager.isLogin() == false) {
        MongoApisManager.getInstance().listMissionModels = CONSTANTS.getGuideMissionModels();
        context.read<GlobalStateEnv>().listMissionModels = MongoApisManager.getInstance().listMissionModels;
        Utility.initCalendarModel();
      }
    } catch (e) {
      print("");
    }
  }

  /**
   * 测试环境 用于通知代码是否编译完成
   */
  showUpdateToast() {
    if (Params.env == EnvEnum.dev) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Utility.showToastMsg(msg: "编译完成");
      });
    }
  }

  @override
  baseMobileBuild(BuildContext context) {
    showUpdateToast();
    return MobileTabBarHome();
  }

  @override
  baseTabletBuild(BuildContext context) {
    showUpdateToast();
    return PCMainHomePage();
  }

  @override
  baseDesktoptBuild(BuildContext context) {
    showUpdateToast();
    return PCMainHomePage();
  }

  @override
  baseBuild(BuildContext context) {
    showUpdateToast();
    return PCMainHomePage();
  }
}
