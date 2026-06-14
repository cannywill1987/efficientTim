import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/GlobalStateEnv.dart';
import 'package:time_hello/com/timehello/common/provider/MissionDetailEnv.dart';
import 'package:time_hello/com/timehello/components/BackNavigator.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CheckContainer.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/MissionDetailSettingTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/MoneyHandlerWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/CreateMissionPage/CreateMissionPage.dart';
import 'package:time_hello/com/timehello/page/missionDetailPage/components/DayTimeManagementPage.dart';
import 'package:time_hello/com/timehello/page/missionDetailPage/components/MobileFlipCounterWidget.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:flutter/gestures.dart';

import '../../../../r.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../components/BlackCheckButtonListWidget.dart';
import '../../components/CustomBackgroundWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/Params.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../models/EventFn.dart';
import '../../models/MusicModel.dart';
import '../../util/AudioPlayUtil.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/KeyboardListenerManager.dart';
import '../../util/SharePreferenceUtil.dart';
import '../../util/ThemeManager.dart';
import '../SettingPage/SettingPage.dart';
import '../missionPage/MissionPage.dart';
import 'components/BakgroundWidget.dart';
import 'components/CounterModeButtonListWidget.dart';
import 'components/CounterWidget.dart';
import 'components/CustomButtonWidget.dart';
import 'components/FlipCounterWidget.dart';
import 'components/FocusRankingWidget.dart';
import 'components/HeaderStatusMissionDetailWidget.dart';
import 'components/HeaderStatusWidget.dart';
import 'components/MissionDataTodayFocusDurationWidget.dart';
import 'components/MissionDetailMissionPageWidget.dart';
import 'components/MissionDetailTitleContainerWidget.dart';

/**
 * 任务详情页
 */
class MissionDetailPage extends BaseWidget {
  // MissionModel missionModel; //任务
  // FolderModel folderModel; //folderModel
  // CounterEnum counterEnum = CounterEnum.chronograph;
  // PageEnum? pageEnum = PageEnum.Normal;
  // int timeHasUsed = 0; //从live activity过来需要计算
  // CounterStatus counterStatusFromLiveActivity =
  //     CounterStatus.none; //用于继续某个时间段的计时

  MissionDetailPage(// {
      //   required this.missionModel,
      // required this.folderModel,
      // required this.timeHasUsed,
      // required this.counterStatusFromLiveActivity,
      // this.pageEnum = PageEnum.Normal}
      ) {
    // if (this.pageEnum == null) {
    //   this.pageEnum = PageEnum.Normal;
    // }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return MissionDetailPageState();
  }
}

class MissionDetailPageState<T> extends BaseWidgetState<MissionDetailPage> {
  bool isMissionDetailStatsOpen = false;
  int isFromPush = -1;
  MissionModel missionModel = MissionModel(); //任务
  FolderModel folderModel = FolderModel(); //folderModel
  // CounterEnum counterEnum = CounterEnum.chronograph;
  PageEnum? pageEnum = PageEnum.Normal;
  int timeHasUsed = 0; //从live activity过来需要计算
  CounterStatus counterStatusFromLiveActivity =
      CounterStatus.none; //用于继续某个时间段的计时
  CounterEnum counterEnum = CounterEnum.chronograph;

  Function? onRequestFinish;
  Function? onTimerTick;
  Function? onUpdateUI;
  int curBackgoundModeIndex = 0;
  int fontMode = SharePreferenceUtil.getSyncInstance().getFontMode();
  int bgMode = SharePreferenceUtil.getSyncInstance().getBgMode();
  List<CheckButtonStateModel> lissionDetailSettingButtonList =
      CONSTANTS.getMissionDetailSettingButtonList();
  String famousSentence = "";
  double rightStatsChildWidth = 300; //右侧宽度
  double rightChildMargin = 20;

  // GlobalKey<CustomBackgroundWidgetState> customBackgroundWidgetStatekey =
  //     GlobalKey<CustomBackgroundWidgetState>();
  double screenWidthPrevious = -1;
  double screenHeightPrevious = -1;
  bool isResizing = false; // 是否正在屏幕调整大小

  Function func = Utility.debounceWithMissionDetailPage(
      (MissionDetailPageState state) async {
    state.resetScreenSize();
    // print("result: $val");
    // missionModel.message = val;
    // String valTrim = val.trim();
    // state.updateEditMode(EditorEditModeEnum.saving);
    // MongoDbUpdated? update = await MongoApisManager.getInstance()
    //     .update_MissionModel(missionModel: missionModel, shouldQueryMissionModel: false);
    // // CounterMethodChannelManager.getInstance()
    // //     .storeWQBNoteMissionData(missionModel);
    // if (update != null) {
    //   state.updateEditMode(EditorEditModeEnum.saved_success);
    // } else {
    //   state.updateEditMode(EditorEditModeEnum.saved_fail);
    // }
  }, Duration(milliseconds: 500));

  resetScreenSize() {
    this.isResizing = false;
    updateUI();
  }

  GlobalKey<CustomBackgroundWidgetState> bgKey =
      GlobalKey<CustomBackgroundWidgetState>();

  // MissionDetailPageState() {}

  @override
  void onClick(type, data) async {
    switch (type) {
      case 'onCickBtn':
        CounterManagement.getInstance().nextStatus(true);
        break;
      case 'onClickBack':
        this.onClickBack();
        break;
      case 'onCickStopBtn':
        CounterManagement.getInstance().stopFromFocusingStatus();
        break;
      case 'onClickSettingItem':
        if (data == 'screen_rorate') {
          // if(DeviceInfoManagement.getInstance()?.isLandScape()) {
          DeviceInfoManagement.getInstance()
              ?.setLandScape(!Utility.isLandscape(context));
          // }
        } else if (data == 'background') {
          //背景设置
          OverlayManagement.getInstance().showSelectBgDialog(context,
              list: Utility.isHandsetBySize()
                  ? ResourceInfo.mobileMissionBackgroundResourceLocationInfoBean
                          ?.deliveryList ??
                      []
                  : ResourceInfo.pcMissionBackgroundResourceLocationInfoBean
                          ?.deliveryList ??
                      [], onTapListener: (String imgUrl) {
            SharePreferenceUtil.getSyncInstance().setString(
                key: ShareprefrenceKeys.pcBackground, content: imgUrl);
            OverlayManagement.getInstance().hideSelectBgDialog();
            bgKey.currentState?.next();
          });
        } else if (data == 'focus_vibration') {
          final bool nextValue =
              !SharePreferenceUtil.getSyncInstance().isFocusVibrationOn();
          SharePreferenceUtil.getSyncInstance()
              .setFocusVibrationOn(isOn: nextValue);
          Utility.showToastMsg(
              context: context,
              msg: nextValue
                  ? getI18NKey().turn_on_vibration
                  : getI18NKey().turn_off_vibration);
          OverlayManagement.getInstance().removeMissionDetailPageOverlay();
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!mounted) {
              return;
            }
            OverlayManagement.getInstance().openMissionDetailPageOverlay(
                context: context,
                missionModel: this.missionModel,
                folderModel: this.folderModel);
          });
        } else if (data == 'auto_next') {
          //选择自动循环
          OverlayManagement.getInstance().removeSelectDialogOverlay();
          OverlayManagement.getInstance()
              .removeSelectSliderVolumeDialogOverlay();
          OverlayManagement.getInstance().removeMissionDetailPageOverlay();
          if (Utility.isHandsetBySize() == true) {
            Utility.pushNavigator(context,
                const SettingPage(pageFrom: PageFromEnum.MissionDetailPage));
            OverlayManagement.getInstance().removeMissionDetailPageOverlay();
          } else {
            Utility.pushDesktopMainContainerNavigator(
                context, "SettingPage", {});
          }
        } else if (data == 'focus_duration') {
          OverlayManagement.getInstance().removeSelectDialogOverlay();
          OverlayManagement.getInstance()
              .removeSelectSliderVolumeDialogOverlay();
          OverlayManagement.getInstance().openSelectTimeDialogOverlay(
              Utility.getGlobalContext(),
              counterEnum: CounterEnum.chronograph,
              title: getI18NKey().focus_duration,
              initVal: SharePreferenceUtil.getSyncInstance().getTomatoTime() ~/
                  (60 * 1000), okCallBack: (CounterEnum counterEnum, int time) {
            // SharePreferenceUtil.getSyncInstance()
            //     .setTomatoTime(time * 60 * 1000);
            this.missionModel.tomato_duration = time * 60 * 1000;
            requestMongoDbUpdateData();
            OverlayManagement.getInstance().removeSelectDialogOverlay();
          }, cancelCallBack: () {
            OverlayManagement.getInstance().removeSelectDialogOverlay();
          });
        } else if (data == 'rest_duration') {
          //修改休息时间
          //隐藏所有对话框
          OverlayManagement.getInstance().removeSelectDialogOverlay();
          OverlayManagement.getInstance()
              .removeSelectSliderVolumeDialogOverlay();
          //打开选择对话框
          OverlayManagement.getInstance().openSelectTimeDialogOverlay(
              Utility.getGlobalContext(),
              counterEnum: CounterEnum.chronograph,
              title: getI18NKey().rest_duration,
              initVal: SharePreferenceUtil.getSyncInstance()
                      .getTomatoRestTime() ~/
                  (60 * 1000), okCallBack: (CounterEnum counterEnum, int time) {
            //选择的数值
            SharePreferenceUtil.getSyncInstance()
                .setTomatoRestTime(time * 60 * 1000);
            OverlayManagement.getInstance().removeSelectDialogOverlay();
          }, cancelCallBack: () {
            OverlayManagement.getInstance().removeSelectDialogOverlay();
          });
        } else if (data == 'music') {
          //选择音乐
          OverlayManagement.getInstance().removeSelectDialogOverlay();
          OverlayManagement.getInstance()
              .removeSelectSliderVolumeDialogOverlay();
          OverlayManagement.getInstance().removeMissionDetailPageOverlay();
          if (Utility.isHandsetBySize() == true) {
            Utility.pushNavigator(context,
                const SettingPage(pageFrom: PageFromEnum.MissionDetailPage));
            OverlayManagement.getInstance().removeMissionDetailPageOverlay();
          } else {
            Utility.pushDesktopMainContainerNavigator(
                context, "SettingPage", {});
          }
        } else if (data == 'volume') {
          //选择音量
          OverlayManagement.getInstance().removeSelectDialogOverlay();
          OverlayManagement.getInstance()
              .removeSelectSliderVolumeDialogOverlay();
          OverlayManagement.getInstance().openSelectSliderVolumeDialogOverlay(
              Utility.getGlobalContext(),
              title: getI18NKey().volume,
              initVal: SharePreferenceUtil.getSyncInstance().getAudioVolume(),
              okCallBack: (int volume) async {
            AudioPlayUtil.getInstance()?.setVolume(volume);
            MusicModel? musicModel =
                SharePreferenceUtil.getSyncInstance().getFocusingBGMusicModel();
            try {
              if (volume > 0) {
                if (CounterManagement.getInstance().counterStatus ==
                    CounterStatus.focusing) {
                  musicModel = SharePreferenceUtil.getSyncInstance()
                      .getFocusingBGMusicModel();
                } else if (CounterManagement.getInstance().counterStatus ==
                    CounterStatus.relaxing) {
                  musicModel = SharePreferenceUtil.getSyncInstance()
                      .getRestingBGMusicModel();
                }
                // String localPath = await Utility.downloadFileByUrl(musicModel.url, title: musicModel.title);
                if (CounterManagement.getInstance().counterStatus ==
                        CounterStatus.focusing ||
                    CounterManagement.getInstance().counterStatus ==
                        CounterStatus.relaxing) {
                  //专注中或者休息中音量大于0都需要设置
                  AudioPlayUtil.getInstance()
                      ?.play(musicModel?.localPath ?? "");
                }
              } else {
                AudioPlayUtil.getInstance()?.stop();
              }
            } catch (e) {
              print(e.toString());
            }
            OverlayManagement.getInstance()
                .removeSelectSliderVolumeDialogOverlay();
          }, cancelCallBack: () {
            OverlayManagement.getInstance()
                .removeSelectSliderVolumeDialogOverlay();
          });
        }
        break;
      case 'onTapFinishListener': //点击头部完成 有bug 下面点击没反应 且在上一页面弹出 需要重新写成overlaymanager
        // Utility.onClickFinishItem(missionModel: data['missionModel'], folderModel: data?['folderModel'] ?? null, timestampCurrent: null, context: context, finishCallback: () {
        // });
        this.onClickFinishItem(this.missionModel);
        // OkCancelResult result = await showOkCancelAlertDialog(
        //     context: context,
        //     title: getI18NKey().confirmToFinished,
        //     message: getI18NKey().confirmToFinishedContent,
        //     okLabel: getI18NKey().confirm,
        //     cancelLabel: getI18NKey().cancel,
        //     onWillPop: () async {
        //       //点击对话框外围黑色区域才会走这里
        //       return true;
        //     });
        // if (result == OkCancelResult.ok) {
        //   eventBus.fire(EventFn(
        //       Params.ACTION_FINISH_MISSIONMODEL, this.widget.missionModel));
        //   this.onClickBack();
        // }

        break;
    }
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(MissionModel data) async {
    await onClickFinishMission(data);
  }

  Future<void> onClickFinishMission(MissionModel data) async {
    bool didFinish =
        await MongoApisManager.getInstance().handleFinishMissionModel(
      missionModel: data,
      context: context,
      folderModel: this.folderModel,
    );
    if (!didFinish) {
      return;
    }
    // this.requestDatas();
    CounterManagement counterManagement = CounterManagement.getInstance();
    //不是同一个就重置重新开始计数
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    onClickBack();
    // Utility.popNavigator(context);
    //关闭的是同一个任务那就停止计时器
    if (counterManagement?.missionModel?.objectId == data.objectId) {
      // counterManagement.reset();
      CounterManagement.getInstance().reset();
    }
  }

  onClickBack() {
    // Utility.popNavigator(context, null);
    OverlayManagement.getInstance()?.removeMissionDetailPageOverlay();
  }

  // ctrl+b&cmd+b begin, 开始专注
  // ctrl+s&cmd+s stop,停止拴住
  // ctrl+p&cmd+p pause,暂停专属拴住
  // ctrl+r&cmd+r resume,继续专注
  // ctrl+f&cmd+f finish,完成专注
  // 空格 下一个状态
  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyB)) {
        // ctrl+b&cmd+b begin, 开始专注 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().startFocusing();
      } else if ((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyS) {
        // ctrl+s&cmd+s stop,停止拴住 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().stopFromFocusingStatus();
      } else if ((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyP) {
        // ctrl+p&cmd+p pause,暂停专属拴住 ok
        // CounterManagement.getInstance().pauseTimer();
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().nextStatus(true);
      } else if ((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyR) {
        // ctrl+r&cmd+r resume,继续专注 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().nextStatus(false);
      } else if (key == LogicalKeyboardKey.space) {
        // 空格 下一个状态 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().nextStatus(true);
      }
      // else if (
      // (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) || HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyF) { // ctrl+f&cmd+f finish,完成专注
      //   this.onClickFinishItem(this.missionModel);
      // }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
    // this.drawerDirection = DrawerDirection.down;
    this.shouldShowSafeArea = false;
    this.isAppBarVisible = false;
    this.forceAppBarVisible = false;
    this.isMissionDetailStatsOpen = SharePreferenceUtil.getSyncInstance()
        .getBool(
            key: ShareprefrenceKeys.isMissionDetailStatsOpen,
            defaultVal: Utility.isHandsetBySize() ? false : true);
  }

  @override
  void didUpdateWidget(MissionDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    Keyboardlistenermanager.getInstance()?.removeListener(handleKeyEvent);
    if (Utility.isHandsetBySize()) {
      DeviceInfoManagement.getInstance()?.setLandScape(false);
    }
    OverlayManagement.getInstance().dismissMissionDetailPageSettingEntry();
    OverlayManagement.getInstance().hideSelectBgDialog();
    // Notification∂Util.getInstance().hideAllNotification();
    OverlayManagement.getInstance().removeSelectDialogOverlay();
    CounterManagement.getInstance().removeOnRequestFinishListener(
        onRequestFinishListener: onRequestFinish!);
    CounterManagement.getInstance()
        .removeOnTimerTickListenerList(onTimerTickListenerList: onTimerTick!);
    CounterManagement.getInstance()
        .removeOnUpdateUIListener(onUpdateUIListener: onUpdateUI!);

    // CounterManagement.getInstance().dispose();
  }

  void requestMongoDbUpdateData() async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.missionModel.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    await MongoApisManager.getInstance()
        .update_MissionModel(missionModel: this.missionModel);
    //todo 敢做这个没用了 因为用env了
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  @override
  componentDidMount() {
    // TODO: implement componentDidMount
    // super.componentDidMount();

    curPage = "_MissionDetailPageState";
    fontMode = SharePreferenceUtil.getSyncInstance().getFontMode();
    this.counterEnum = CounterEnum.values[SharePreferenceUtil.getSyncInstance()
        .getInt(key: ShareprefrenceKeys.timerModel, defaultVal: 0)];
    this.famousSentence = Utility.getFamousSentence();
    onRequestFinish = (MissionModel missionModel) {
      //背景模式 0 手动 1 自动 2 纯净
      int bgMode = SharePreferenceUtil.getSyncInstance().getBgMode();
      if (bgMode == 1) {
        bgKey.currentState?.next();
      } else if (bgMode == 2) {
        nextFamousSentenceForPureVersion();
      }
      this.updateUI();
    };
    onTimerTick = (int time) {
      // this.updateUI();
    };
    onUpdateUI = () {
      this.updateUI();
    };

    CounterManagement counterManagement = CounterManagement.getInstance();
    counterManagement.addOnRequestFinishListener(
        onRequestFinishListener: onRequestFinish!);
    counterManagement.addOnTimerTickListener(onTimerTickListener: onTimerTick!);
    counterManagement.addOnUpdateUIListener(onUpdateUIListener: onUpdateUI!);
    //不是同一个就重置重新开始计数
    if (this.pageEnum == PageEnum.Normal) {
      if (counterManagement.missionModel?.objectId !=
          this.missionModel.objectId) {
        // counterManagement.missionModel?.objectId 表示第一次开始计时
        // if (counterManagement.missionModel?.objectId == null ) {
        // ||
        // SharePreferenceUtil.getSyncInstance().getSwitchMissionTitle()
        counterManagement.reset();
        counterManagement.init(
          counterEnum: this.counterEnum,
          missionModel: this.missionModel,
          folderModel: this.folderModel,
          missionDetailPageState: this,
        );
        // CounterManagement.getInstance()!.startTimer();
        CounterManagement.getInstance().nextStatus(false);
        // } else {
        //   // 主要是为了计数中的任务重新重这里进来
        //   counterManagement.set(
        //       missionModel: this.missionModel, folderModel: this.folderModel);
        // }
      }
    } else {
      //liveactivity过来
      counterManagement.reset();
      CounterManagement.getInstance().continueFromStartTime(
          missionModel: this.missionModel,
          counterStatus: this.counterStatusFromLiveActivity,
          counterEnum: this.counterEnum,
          timeHasUsed: this.timeHasUsed);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      updateUI();
    });
  }

  @override
  Widget? baseEndDrawerBuild(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().screenWidth * 0.8,
      child: SingleChildScrollView(
        child: Column(
          children: getDayTimeManagementPage(null),
        ),
      ),
    );
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    MissionDetailEnv globalStateEnv = context.watch<MissionDetailEnv>();
    if (MissionDetailEnv.isFromPushTimes != isFromPush) {
      isFromPush = MissionDetailEnv.isFromPushTimes;
      this.counterEnum = globalStateEnv.counterEnum;
      this.folderModel = globalStateEnv.folderModel ?? FolderModel();
      this.missionModel = globalStateEnv.missionModel ?? MissionModel();
      this.timeHasUsed = globalStateEnv.timeHasUsed;
      this.pageEnum = globalStateEnv.pageEnum;
    }
    // bgMode 背景模式 0 手动 1 自动 2 纯净
    // FontMode 计时器样式 0 Flip 1 oswald 2 kablammo
    if (Utility.isHandsetBySize()) {
      return getBody();
      // return Scaffold(
      //     key: _scaffoldKey,
      //     drawer: SafeArea(child: ),
      //     body: getBody());
    } else {
      return getBody();
    }
  }

  GestureDetector getBody() {
    return GestureDetector(
      onTap: () {
        OverlayManagement.getInstance().dismissMissionDetailPageSettingEntry();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        if (Utility.isHandsetBySize() == true) {
          this.isMissionDetailStatsOpen = false;
          this.rightStatsChildWidth = constraints.maxWidth;
        }
        if ((screenWidthPrevious != screenWidth) ||
            (screenHeightPrevious != screenHeight)) {
          if (screenWidthPrevious != -1 && screenHeightPrevious != -1) {
            this.isResizing = true;
            func(this);
          }
          screenWidthPrevious = screenWidth;
          screenHeightPrevious = screenHeight;
        }
        if (((Utility.isHandsetBySize() || DeviceInfoManagement.isMoible()) &&
                bgMode == 2 &&
                fontMode == 0) ||
            (DeviceInfoManagement.isMoible() && Utility.isLandscape(context))) {
          //手机纯净版展示
          return getPureCounterWidget(context, screenWidth, screenHeight);
        } else {
          //以前老版本展示
          return getNormalCounterWidget(context, screenWidth, screenHeight);
        }
      }),
    );
  }

  nextFamousSentenceForPureVersion() {
    // 背景模式 0 手动 1 自动 2 纯净
    this.famousSentence = Utility.getFamousSentence();
    setState(() {});
  }

  /**
   * 纯净版
   */
  Widget getPureCounterWidget(
      BuildContext context, double screenWidth, double screenHeight) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          Column(
            children: [
              if (Utility.isLandscape(context) == false)
                getBackNavigator(context),
              Expanded(
                child: MobileFlipCounterWidget(
                  headChild: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getHeaderWidget(context),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 50),
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          this.famousSentence ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  bottomChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [getSwitchFont(), ...getBottomSettingBtns()],
                  ),
                  min:
                      Utility.getMins(CounterManagement.getInstance().curTimeF),
                  sec: Utility.getSeconds(
                      CounterManagement.getInstance().curTimeF),
                ),
              ),
            ],
          ),
          if (Utility.isLandscape(context) == true)
            Container(height: 80, child: getBackNavigator(context)),
        ],
      ),
    );
  }

  Stack getNormalCounterWidget(
      BuildContext context, double screenWidth, double screenHeight) {
    return Stack(
      children: [
        CustomBackgroundWidget(
            key: bgKey,
            bgMode: bgMode,
            fontMode: fontMode,
            onSizedChange: (size) {
              // setState(() {
              //
              // });
            },
            shouldShowProgressBar: fontMode != 0,
            progress: _getCounterProgress(),
            headerChildrenWidget: [
              getBackNavigator(context),
              HeaderStatusMissionDetailWidget(
                  onTapFinishListener: () {
                    this.onClick('onTapFinishListener', null);
                  },
                  // rightChild: ,
                  onTapCloseListener: () {},
                  missionModel: CounterManagement.getInstance().missionModel),
              getHeaderWidget(context)
            ],
            centerChildrenWidget: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getCounterWidget(widgetWidth: screenWidth),
                      SizedBox(
                        height: 10,
                      ),
                      getSwitchFont(),
                    ],
                  ),
                ],
              )
            ],
            rightChildrenWidget: this.isMissionDetailStatsOpen
                ? getDayTimeManagementPage(screenHeight)
                : null,
            bottomChildrenWidget: getBottomSettingBtns(),
            text: ""),
        // BakgroundWidget(type: Utility.isDay() ? 1 : 0), //背景
        // Container(
        //   constraints: BoxConstraints.expand(
        //       width: double.infinity, height: double.infinity),
        //   child:
        // )
      ],
    );
  }

  List<Widget> getDayTimeManagementPage([double? screenHeight]) {
    if (screenHeight == null) {
      screenHeight = MediaQuery.of(context).size.height;
    }
    return [
      SizedBox(
        height: 60,
      ),
      MissionDetailTitleContainerWidget(
          title: getI18NKey().today_focus_duration,
          child: Container(
            color: ThemeManager.getInstance()
                .getCardBackgroundColor(defaultColor: Colors.white),
            width: rightStatsChildWidth,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: getFocusDurationToday(),
          )),
      SizedBox(
        height: rightChildMargin,
      ),
      MissionDetailTitleContainerWidget(
          title: getI18NKey().focus_companion,
          child: FocusRankingWidget(
            width: rightStatsChildWidth,
            height: 260,
          )),
      SizedBox(
        height: rightChildMargin,
      ),
      MissionDetailTitleContainerWidget(
          title: getI18NKey().today,
          child: Container(
            color: ThemeManager.getInstance()
                .getCardBackgroundColor(defaultColor: Colors.white),
            width: rightStatsChildWidth,
            padding: EdgeInsets.only(top: 10),
            height: 160,
            child: MissionDetailMissionPageWidget(
                onTapNavMenuListener: (v) {},
                folderModel: FolderModel(),
                folderStatusDate: 1),
          )),
      SizedBox(
        height: rightChildMargin,
      ),
      MissionDetailTitleContainerWidget(
        title: getI18NKey().today_focus_record,
        child: Container(
            width: rightStatsChildWidth,
            height: screenHeight - 200,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: ThemeManager.getInstance()
                  .getCardBackgroundColor(defaultColor: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DayTimeManagementPage(
              key: ValueKey("12121"),
              onCreateMissionListener: (missionModel) {
                onClickCreateMission(missionModel);
              },
              // pageEnum: PageEnum.Normal,
              // missionModel: this.missionModel,
              // folderModel: this.folderModel,
              // counterEnum: this.counterEnum,
              // timeHasUsed: this.timeHasUsed,
            )),
      )
    ];
  }

  void onClickCreateMission(missionModel) {
    OverlayManagement.getInstance().removeSelectDialogOverlay();
    OverlayManagement.getInstance().removeSelectSliderVolumeDialogOverlay();
    OverlayManagement.getInstance().removeMissionDetailPageOverlay();
    if (Utility.isHandsetBySize() == true) {
      Utility.pushNavigator(
          context, CreateMissionPage(missionModel: missionModel));
      OverlayManagement.getInstance().removeMissionDetailPageOverlay();
    } else {
      DialogManagement.getInstance().showPCCustomDialog(
          context: context,
          widget: CreateMissionPage(missionModel: missionModel));
    }
  }

  Widget getFocusDurationToday() {
    return MissionDataTodayFocusDurationWidget();
    // const double redFontSize = 26;
    //
    // const double extensionFontSize = 12;
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text.rich(TextSpan(
    //       children: <TextSpan>[
    //         TextSpan(
    //             text: "12",
    //             style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize)),
    //         TextSpan(
    //             text: getI18NKey().hour,
    //             style: TextStyle(
    //                 color: ColorsConfig.gray_a7, fontSize: extensionFontSize)),
    //         TextSpan(
    //             text: "12",
    //             style: TextStyle(color: ColorsConfig.red, fontSize: redFontSize)),
    //         TextSpan(
    //             text: getI18NKey().mins2,
    //             style: TextStyle(
    //                 color: ColorsConfig.gray_a7, fontSize: extensionFontSize)),
    //       ],
    //     )),
    //     Container(height: 200, child: )
    //   ],
    // );
  }

  Padding getHeaderWidget(BuildContext context) {
    final Color focusTextColor = Colors.white.withValues(alpha: 0.88);
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 28, right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                getI18NKey().background,
                style: TextStyle(
                  color: focusTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              BlackCheckButtonListWidget(
                // initIndex: 1,
                initIndex: SharePreferenceUtil.getSyncInstance().getBgMode(),
                useFocusDetailStyle: true,
                list: CONSTANTS.getBGOnAndOffButtonList(
                    defaultVal:
                        SharePreferenceUtil.getSyncInstance().getBgMode()),
                onTapListener: (index) async {
                  // this.bgMode = index;
                  SharePreferenceUtil.getSyncInstance().setBgMode(index);
                  this.bgMode =
                      SharePreferenceUtil.getSyncInstance().getBgMode();
                  if (index == 0) {
                    Utility.showToastMsg(
                        context: context,
                        msg: getI18NKey().background_change_auto_prompt_off);
                    SharePreferenceUtil.getSyncInstance().setString(
                        key: ShareprefrenceKeys.pcBackground,
                        content: bgKey.currentState?.getCurBackground() ?? "");
                  } else if (index == 1) {
                    Utility.showToastMsg(
                        context: context,
                        msg: getI18NKey().background_change_auto_prompt_on);
                    SharePreferenceUtil.getSyncInstance().setString(
                        key: ShareprefrenceKeys.pcBackground, content: "");
                  }
                  setState(() {});
                },
              )
            ],
          ),
          MoneyHandlerWidget(
            pageFrom: PageFromEnum.MissionDetailPage,
          ),
        ],
      ),
    );
  }

  List<Widget> getBottomSettingBtns() {
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButtonWidget(
              //按钮
              icon: Icon(
                Icons.play_arrow,
                size: 27,
                color: ColorsConfig.white,
              ),
              text: CounterManagement.getInstance().btnText ?? "",
              status: CounterManagement.getInstance().isTimerActive(),
              onTapListener: (data) {
                this.onClick('onCickBtn', null);
              }),
          CounterManagement.getInstance().counterStatus ==
                  CounterStatus.pausingFocusing
              ? SizedBox(
                  width: 5,
                )
              : SizedBox.shrink(),
          CounterManagement.getInstance().counterStatus ==
                  CounterStatus.pausingFocusing
              ? CustomButtonWidget(
                  //按钮
                  icon: Icon(
                    Icons.stop,
                    size: 27,
                    color: ColorsConfig.white,
                  ),
                  text: getI18NKey().stop,
                  status: false,
                  onTapListener: (data) {
                    this.onClick('onCickStopBtn', null);
                  })
              : SizedBox.shrink()
        ],
      ),
      Container(
        child: Text(
          "(" + CONSTANTS.getMissionDetailCounterStatusTitle() + ")",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      SizedBox(
        height: Utility.isHandsetBySize() ? 60 : 80,
      ),
    ];
  }

  InkWell getSwitchFont() {
    final Color themeColor = ThemeManager.getInstance().getDefautThemeColor();
    return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          fontMode = Utility.switchCounterFont();
          updateUI();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xff121820).withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Aa',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                getI18NKey().switch_font,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.86),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ));
  }

  BackNavigator getBackNavigator(BuildContext context) {
    return BackNavigator(
      rightChild: InkWell(
        onTap: () {
          OverlayManagement.getInstance().openMissionDetailPageSettingOverlay(
              context,
              list: lissionDetailSettingButtonList, onTapListener: (model) {
            OverlayManagement.getInstance()
                .dismissMissionDetailPageSettingEntry();
            this.onClick("onClickSettingItem", model.code);
          },
              right:
                  (this.isMissionDetailStatsOpen && !Utility.isHandsetBySize())
                      ? 40 + rightStatsChildWidth + rightChildMargin
                      : 40);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.settings,
                size: 22,
                color: ColorsConfig.white,
              ),
            ),
            // if(Utility.isHandsetBySize() == false)
            Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: CheckContainer(
                  checked: this.isMissionDetailStatsOpen,
                  onCheckedListener: (bool isChecked, data) {
                    if (Utility.isHandsetBySize() == true) {
                      scaffoldKey.currentState?.openEndDrawer();
                      // OverlayManagement.getInstance().showPCCustomOverlay(
                      //     context: context,
                      //     child: Container(
                      //       child: ,
                      //     ));
                    } else {
                      this.isMissionDetailStatsOpen = isChecked;
                      OverlayManagement.getInstance()
                          .dismissMissionDetailPageSettingEntry();
                      SharePreferenceUtil.getSyncInstance()?.setBool(
                          key: ShareprefrenceKeys.isMissionDetailStatsOpen,
                          val: isChecked);
                      updateUI();
                    }
                  },
                  width: 30,
                  height: 30,
                  checkWidget:
                      Utility.getSVGPicture(R.assetsImgIcStatistic, size: 30),
                  uncheckWidget:
                      Utility.getSVGPicture(R.assetsImgIcStatistic, size: 30),
                )),
          ],
        ),
      ),
      centerChild: CounterModeButtonListWidget(
        initIndex: CounterManagement.getInstance().counterEnum.index,
        list: CONSTANTS.getCounterModeButtonList(),
        onTapListener: (obj) {
          this.counterEnum = CounterEnum.values[obj];
          SharePreferenceUtil.getSyncInstance().setInt(
              key: ShareprefrenceKeys.timerModel,
              value: this.counterEnum.index);
          CounterManagement.getInstance().switchMode(this.counterEnum);
          CounterManagement.getInstance().counterEnum = this.counterEnum;
          updateUI();
        },
      ),
      onTapListener: (data) {
        this.onClick('onClickBack', null);
      },
      backColor: Colors.white,
    );
  }

  Widget getCounterWidget({required double widgetWidth}) {
    if (fontMode == 0 && this.isResizing == false) {
      return FlipCounterWidget(
        min: Utility.getMins(CounterManagement.getInstance().curTimeF),
        sec: Utility.getSeconds(CounterManagement.getInstance().curTimeF),
        widgetWidth:
            (this.isMissionDetailStatsOpen && !Utility.isHandsetBySize())
                ? widgetWidth - rightStatsChildWidth - rightChildMargin
                : widgetWidth,
      );
    } else {
      return CounterWidget(
        fontSize: bgKey.currentState?.getHeightCircleSize() != null
            ? (bgKey.currentState?.getHeightCircleSize() ?? 60) / 6
            : 60,
        min: Utility.getMins(CounterManagement.getInstance().curTimeF),
        sec: Utility.getSeconds(CounterManagement.getInstance().curTimeF),
        fontMode: this.fontMode,
      );
    }
  }

  /// 统一计算专注页大圆环进度，正计时和倒计时都使用已用时占比。
  double _getCounterProgress() {
    final manager = CounterManagement.getInstance();
    if (manager.totalTime <= 0) return 0;
    return (manager.timeUsed / manager.totalTime).clamp(0.0, 1.0).toDouble();
  }
}
