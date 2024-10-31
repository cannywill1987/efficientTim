import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/page/missionDetailPage/MissionDetailPage.dart';
import 'package:time_hello/com/timehello/util/AudioPlayUtil.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/MoneyManager.dart';
import 'package:time_hello/com/timehello/util/NotificationManager.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../beans/BaseBean.dart';
import '../beans/UserBean.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/CONSTANTS.dart';
import '../config/EVENTNAME.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../models/TimelineMissionModel.dart';
import 'DialogManagement.dart';
import 'SharePreferenceUtil.dart';
import 'TimerUtil.dart';
import 'Utility.dart';

class CounterManagement {
  static CounterManagement? mCounterManagement;
  TimerUtil? _timerUtil;
  int missionBeginTimeStamp = 0;
  int missionEndTimeStamp = 0;
  int curTimeF = 0; //当前专注时间
  int totalTime = 0;
  int timeUsed = 0;

  // int timeRest = 0;
  MissionModel? missionModel;
  FolderModel? folderModel;
  CounterStatus counterStatus = CounterStatus.waitingToFocus;
  String? btnText;
  MissionDetailPageState? missionDetailPageState;
  List onRequestFinishListenerList = [];
  List onTimerTickListenerList = [];
  List onUpdateUIList = [];
  int focusedDuration = 0; //已经专注的时间
  CounterEnum counterEnum;
  bool isCounterTimerExecuting = true;
  int timeUsedByMinute = 0; //离开app的 消耗时间
  CounterManagement(
      {this.counterEnum = CounterEnum.chronograph,
      this.missionModel,
      this.folderModel,
      this.missionDetailPageState}) {
    if (btnText == null) {
      btnText = getBtnText(counterStatus);
    }
  }

  isTimerActive() {
    return _timerUtil?.isActive();
  }

  static CounterManagement getInstance() {
    if (mCounterManagement == null) {
      mCounterManagement = new CounterManagement();
      //处理从app传过来的事件
      CounterMethodChannelManager.getInstance().requestStatusBar(
          CounterModelRequest(
              objectId: '',
              statusString: "",
              totalTomatees: 0,
              numTomatees: 0,
              focusedDuration: "",
              bgUrl: "",
              isCountDown: true,
              time: 0,
              title:
                  Utility.isHandsetBySize() ? getI18NKey().waitingToStart : "",
              status: CounterStatus.none.index,
              text:
                  Utility.isHandsetBySize() ? "" : getI18NKey().waitingToStart,
              shouldShowRedFocusStatus: false));
      CounterMethodChannelManager.getInstance().addOnRequestFinishListener(
          onMethodChannelResponseLisntener:
              (String method, Map arguments, MethodChannel methodChannel) {
        switch (method) {
          case "handleStatusBarStartBtn":
            CounterMethodChannelManager.getInstance().hideAliyunStatusBar();
            CounterManagement.getInstance().nextStatus(true);
            break;
          case "handleStatusBarPauseBtn":
            CounterManagement.getInstance().nextStatus(true);
            break;
          case "handleStatusBarStopBtn":
            CounterManagement.getInstance().stopFromFocusingStatus();
            break;
          case "handleStatusBarDoneBtn":
            CounterManagement.getInstance().nextStatus(true);
            break;
        }
      });
    }
    return mCounterManagement!;
  }

  switchMode(CounterEnum counterEnum) {
    this.counterEnum = counterEnum;
    if (this.counterEnum == CounterEnum.timer) {
      //启动timer计时
      stopRelaxing();
      startFocusing();
    } else {
      //启动倒计时
      stopRelaxing();
      startFocusing();
    }
    counterStatus = CounterStatus.focusing;
  }

  init(
      {CounterEnum counterEnum: CounterEnum.chronograph,
      MissionModel? missionModel,
      FolderModel? folderModel,
      MissionDetailPageState? missionDetailPageState}) {
    // this.timeRest =  SharePreferenceUtil.getInstance().getTomatoRestTime();
    this.counterEnum = counterEnum;
    this.missionModel = missionModel;
    this.folderModel = folderModel;
    this.btnText = getBtnText(counterStatus);
    //顺序不能乱  this.missionModel 有更高优先级
    this.curTimeF = this.missionModel?.tomato_duration ??
        SharePreferenceUtil.getSyncInstance().getTomatoTime();
    if (_timerUtil == null) {
      _timerUtil = new TimerUtil(mCurTime: curTimeF);
    }
    _timerUtil?.mCurTime = curTimeF;
    return mCounterManagement;
  }

  set(
      {
        MissionModel? missionModel,
        FolderModel? folderModel,
        }) {
    // this.timeRest =  SharePreferenceUtil.getInstance().getTomatoRestTime();
    this.missionModel = missionModel;
    this.folderModel = folderModel;
    return mCounterManagement;
  }

  updateMissionModel(MissionModel missionModel) {
    if (this.missionModel?.objectId == missionModel.objectId) {
      this.missionModel = missionModel;
    }
  }

  continueFromStartTime(
      {required MissionModel missionModel,
      required CounterStatus counterStatus,
      int timeHasUsed = 0,
      required CounterEnum counterEnum}) {
    this.missionModel = missionModel;
    this.counterStatus = counterStatus;
    this.counterEnum = counterEnum;
    if (counterStatus == CounterStatus.relaxing) {
      this.curTimeF = SharePreferenceUtil.getSyncInstance().getTomatoRestTime();
    } else {
      //focusing
      this.curTimeF = this.missionModel?.tomato_duration ??
          SharePreferenceUtil.getSyncInstance().getTomatoTime();
      this.curTimeF = this.missionModel?.tomato_duration ??
          SharePreferenceUtil.getSyncInstance().getTomatoTime();
    }

    if (_timerUtil == null) {
      _timerUtil = new TimerUtil(
          mCurTime: this.counterEnum == CounterEnum.timer
              ? timeHasUsed
              : curTimeF - timeHasUsed);

      // _timerUtil?.mCurTime = timeHasUsed;
    }
    AudioPlayUtil.getInstance()?.stop();
    if (SharePreferenceUtil.getSyncInstance().isFocusBGMusicOn()) {
      AudioPlayUtil.getInstance()?.play(
          (SharePreferenceUtil.getSyncInstance().getFocusingBGMusicModel())
                  ?.localPath ??
              CONSTANTS.getFocusAndRestingMusicModelList()[0].url!,
          isLocal: true);
    }
    this.startTimer(this.counterEnum, isPause: true);
  }

  reset() {
    this.dispose();
    counterStatus = CounterStatus.waitingToFocus;
    this._timerUtil?.cancel();
    this._timerUtil = null;
    this.missionModel = null;
    this.folderModel = null;
    this.curTimeF = this.missionModel?.tomato_duration ??
        SharePreferenceUtil.getSyncInstance().getTomatoTime();
    // this.timeRest =  SharePreferenceUtil.getInstance().getTomatoRestTime();
    triggerOnUpateUIListener();
  }

  addOnRequestFinishListener({required Function onRequestFinishListener}) {
    this.onRequestFinishListenerList.add(onRequestFinishListener);
  }

  addOnTimerTickListener({required Function onTimerTickListener}) {
    this.onTimerTickListenerList.add(onTimerTickListener);
  }

  addOnUpdateUIListener({required Function onUpdateUIListener}) {
    this.onUpdateUIList.add(onUpdateUIListener);
  }

  triggerOnRequestFinishListener(MissionModel missionModel) {
    for (int i = 0; i < this.onRequestFinishListenerList.length; i++) {
      Function f = this.onRequestFinishListenerList[i];
      f(missionModel);
    }
  }

  triggerOnTimerTickListener(int time, int moneyLocal) {
    for (int i = 0; i < this.onTimerTickListenerList.length; i++) {
      Function f = this.onTimerTickListenerList[i];
      f(time);
    }
    if (timeUsed > 0 && timeUsed ~/ 1000 / 60 % 1 == 0) {
      MoneyManager.getInstance().updateIncLocalMonneyWithoutRequest(
          localMoneyParam:
              SharePreferenceUtil.getSyncInstance().getLocalMoney());
    }

    CounterMethodChannelManager.getInstance().requestStatusBar(
        CounterModelRequest(
            objectId: missionModel?.objectId ?? '',
            statusString: "",
            totalTomatees: missionModel?.total_tomotoes ?? 0,
            numTomatees: missionModel?.no_tomotoes_finished ?? 0,
            focusedDuration: Utility.formatTimestampHourAndMins(
                missionModel?.time_finished ?? 0),
            bgUrl: missionModel?.background_url ?? "",
            isCountDown: this.counterEnum == CounterEnum.timer ? false : true,
            time: CounterManagement.getInstance().curTimeF,
            title: missionModel?.title ?? '',
            status: counterStatus.index,
            text: getTimeStringValue(),
            shouldShowRedFocusStatus: shouldShowRedFocusStatus()));
  }

  triggerOnUpateUIListener() {
    for (int i = 0; i < this.onUpdateUIList.length; i++) {
      Function f = this.onUpdateUIList[i];
      f();
    }
    CounterMethodChannelManager.getInstance().requestStatusBar(
        CounterModelRequest(
            statusString: "",
            objectId: missionModel?.objectId ?? '',
            totalTomatees: missionModel?.total_tomotoes ?? 0,
            numTomatees: missionModel?.no_tomotoes_finished ?? 0,
            focusedDuration: Utility.formatTimestampHourAndMins(
                missionModel?.time_finished ?? 0),
            bgUrl: missionModel?.background_url ?? "",
            isCountDown: this.counterEnum == CounterEnum.timer ? false : true,
            time: this.counterEnum == CounterEnum.timer
                ? CounterManagement.getInstance().curTimeF
                : CounterManagement.getInstance().curTimeF,
            title: missionModel?.title ?? '',
            status: counterStatus.index,
            text: getTimeStringValue(),
            shouldShowRedFocusStatus: shouldShowRedFocusStatus()));
  }

  removeAllListeners() {
    this.removeAllOnRequestFinishListener();
    this.removeAllOnTimerTickListenerList();
    this.removeAllOnUpdateUIListener();
  }

  removeAllOnRequestFinishListener() {
    this
        .onRequestFinishListenerList
        .removeRange(0, this.onRequestFinishListenerList.length);
  }

  removeOnRequestFinishListener({required Function onRequestFinishListener}) {
    this.onRequestFinishListenerList.remove(onRequestFinishListener);
  }

  removeAllOnTimerTickListenerList() {
    this
        .onTimerTickListenerList
        .removeRange(0, this.onTimerTickListenerList.length);
  }

  removeOnTimerTickListenerList({required Function onTimerTickListenerList}) {
    this.onTimerTickListenerList.remove(onTimerTickListenerList);
  }

  removeAllOnUpdateUIListener() {
    this.onUpdateUIList.removeRange(0, this.onUpdateUIList.length);
  }

  removeOnUpdateUIListener({required Function onUpdateUIListener}) {
    this.onUpdateUIList.remove(onUpdateUIListener);
  }

  shouldShowRedFocusStatus() {
    return (counterStatus == CounterStatus.focusing ||
        counterStatus == CounterStatus.pausingFocusing ||
        counterStatus == CounterStatus.waitingToFocus);
  }

  /**
   * h获取时间 用于状态栏等
   */
  static String getTimeStringValue() {
    return CounterManagement.getInstance().curTimeF == 0
        ? ""
        : (Utility.getMins(CounterManagement.getInstance().curTimeF) +
            ":" +
            Utility.getSeconds(CounterManagement.getInstance().curTimeF));
  }

  /**
   * 阿里云推送文案， 开始专注给下个状态休息时间，开始休息给下个状态专注时间
   */
  String getAliyunTimeTimeValue() {
    //专注时长
    int time = this.missionModel?.tomato_duration ??
        SharePreferenceUtil.getSyncInstance().getTomatoTime();
    if (CounterStatus.focusing == counterStatus ||
        CounterStatus.pausingFocusing == counterStatus ||
        CounterStatus.waitingToFocus == counterStatus) {
      time = SharePreferenceUtil.getSyncInstance().getTomatoRestTime();
    }
    return (Utility.getMins(time) + ":" + Utility.getSeconds(time));
    return "";
  }

  /**
   * 阿里云下个推送状态
   */
  int getAliyunCounterStatus() {
    //专注时长
    CounterStatus counterStatus = CounterStatus.waitingToStartRelaxing;
    if (CounterStatus.focusing == counterStatus ||
        CounterStatus.pausingFocusing == counterStatus ||
        CounterStatus.waitingToFocus == counterStatus) {
      counterStatus = CounterStatus.waitingToFocus;
    }

    return counterStatus.index;
  }

  /**
   * 显示状态颜色
   */
  bool getAliyunShouldShowRedFocusStatus() {
    //专注时长
    bool shouldShowRedFocusStatus = true;
    if (CounterStatus.focusing == counterStatus ||
        CounterStatus.pausingFocusing == counterStatus ||
        CounterStatus.waitingToFocus == counterStatus) {
      shouldShowRedFocusStatus = false;
    }
    return shouldShowRedFocusStatus;
  }

  /**
   * 不同的状态通知栏返回的文案
   */
  String getNotificationTitleText(CounterStatus counterStatus) {
    if (CounterStatus.pausingFocusing == counterStatus) {
      pauseTimer();
      //专注暂停中
      return getI18NKey().focusPausing;
    } else if (CounterStatus.waitingToStartRelaxing == counterStatus) {
      pauseTimer();
      //等待开始休息中
      return getI18NKey().focusFinished;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      pauseTimer();
      //休息暂停中
      return getI18NKey().continueTxt;
    } else if (CounterStatus.relaxing == counterStatus) {
      // Wakelock.enable();
      WakelockPlus.toggle(enable: true);
      //休息中
      return getI18NKey().resting;
    } else if (CounterStatus.waitingToFocus == counterStatus) {
      pauseTimer();
      //等待开始专注
      _timerUtil?.updateTotalTimeAndStartCountDown(curTimeF =
          this.missionModel?.tomato_duration ??
              SharePreferenceUtil.getSyncInstance().getTomatoTime());
      return getI18NKey().restingFinished;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      pauseTimer();
      //等待开始休息
      return getI18NKey().restPausing;
    } else if (CounterStatus.focusing == counterStatus) {
      WakelockPlus.toggle(enable: true);
      // Wakelock.enable();
      //专注中
      return getI18NKey().focusing;
    }
    return '';
  }

  /**
   * 启动计时器
   */
  void startTimer(CounterEnum counterEnum, {bool isPause = false}) {
    if (counterEnum == CounterEnum.chronograph) {
      if (!_timerUtil!.isActive()) {
        this.missionBeginTimeStamp =
            Utility.getTimeStampToday(); //用于数据保存 没有计算属性
        _timerUtil?.setOnTimerTickCallback(
            (curTime, int totalTime, int timeUsed, bool isFirstTime) {
          isCounterTimerExecuting = false;
          // todo
          this.curTimeF = curTime;
          this.totalTime = totalTime;
          this.timeUsed = timeUsed;
          updateExitAppCacheData();

          this.focusedDuration = this.timeUsed;
          // title: missionModel?.title ?? '',
          // status: counterStatus.index,
          // text: getTimeStringValue(),
          if (isFirstTime == true && (totalTime - timeUsed) > 0) {
            NotificationManager.getInstance()?.pushAliyunNotificationWithAlias(
                title: getI18NKey().mission_title(missionModel?.title ?? ''),
                duration: getAliyunTimeTimeValue(),
                delay: (totalTime - timeUsed) ~/ 1000,
                extendsParams: Utility.mapToJsonString({
                  'action': 'UpdateCounterStatusAction',
                  'status': getAliyunCounterStatus(),
                  'shouldShowRedFocusStatus':
                      getAliyunShouldShowRedFocusStatus()
                }));
          }
          this.triggerOnTimerTickListener(curTimeF, (timeUsed));

          if (curTimeF == 0) {
            if (counterStatus == CounterStatus.focusing ||
                counterStatus == CounterStatus.relaxing) {
            } else {}
            nextStatus(false);
          } else {
            if (counterStatus == CounterStatus.focusing ||
                counterStatus == CounterStatus.relaxing) {
            } else {
              if (counterStatus == CounterStatus.waitingToStartRelaxing ||
                  counterStatus == CounterStatus.waitingToFocus) {}
            }
          }
        });
        _timerUtil!.startCountDown();
      }
    } else {
      if (!_timerUtil!.isActive()) {
        this.missionBeginTimeStamp = Utility.getTimeStampToday();
        _timerUtil?.setOnTimerTickCallback(
            (curTime, int totalTime, int timeUsed, bool isFirstTime) {
          // todo
          isCounterTimerExecuting = true;
          this.curTimeF = curTime;
          this.totalTime = totalTime;
          this.timeUsed = timeUsed;
          updateExitAppCacheData();
          this.focusedDuration = this.timeUsed;
          // title: missionModel?.title ?? '',
          // status: counterStatus.index,
          // text: getTimeStringValue(),
          if (isFirstTime == true && (totalTime - timeUsed) > 0) {
            NotificationManager.getInstance()?.pushAliyunNotificationWithAlias(
                title: getI18NKey().mission_title(missionModel?.title ?? ''),
                duration: getAliyunTimeTimeValue(),
                delay: (totalTime - timeUsed) ~/ 1000,
                extendsParams: Utility.mapToJsonString({
                  'action': 'UpdateCounterStatusAction',
                  'status': getAliyunCounterStatus(),
                  'shouldShowRedFocusStatus':
                      getAliyunShouldShowRedFocusStatus()
                }));
          }
          this.triggerOnTimerTickListener(curTimeF, timeUsed);

          if (curTimeF == 0) {
            if (counterStatus == CounterStatus.focusing ||
                counterStatus == CounterStatus.relaxing) {
            } else {}
            nextStatus(false);
          } else {
            if (counterStatus == CounterStatus.focusing ||
                counterStatus == CounterStatus.relaxing) {
            } else {
              if (counterStatus == CounterStatus.waitingToStartRelaxing ||
                  counterStatus == CounterStatus.waitingToFocus) {}
            }
          }
        });
        _timerUtil!.startCountUp(isPause: isPause);
      }
    }
  }

  /**
   * 用于缓存专注时离开app再次进入时的数据 防止销毁的情况发生
   * reinitBottomCounter
   */
  void updateExitAppCacheData() async {
    try {
      if(counterStatus == CounterStatus.focusing && this.timeUsed % 10 == 0) {
        SharePreferenceUtil.getSyncInstance().setInt(
            key: ShareprefrenceKeys.curFocusingMissionObjectIdForTimeUsedKey,
            value: this.timeUsed);
        SharePreferenceUtil.getSyncInstance().setInt(
            key: ShareprefrenceKeys.curFocusingMissionObjectIdForCurTimeFKey,
            value: this.curTimeF);
        SharePreferenceUtil.getSyncInstance().setInt(
            key: ShareprefrenceKeys.curFocusingMissionObjectIdForTotalTimeFKey,
            value: this.totalTime);
      }
    } catch (e) {

    }
  }

  void stopFromRelaxingStatus() {
    pauseTimer();
    //等待开始专注
    _timerUtil?.updateTotalTimeAndStartCountDown(curTimeF =
        this.missionModel?.tomato_duration ??
            SharePreferenceUtil.getSyncInstance().getTomatoTime());
    counterStatus = CounterStatus.waitingToFocus;
    this.btnText = getBtnText(counterStatus);
    this.updateUI();
  }

  void leaveAppWhenFocusing() {
    this.timeUsedByMinute = (this.timeUsed / (1000 * 60)).toInt();
    //时间够了提升值
    int localMoney = timeUsedByMinute *
        SharePreferenceUtil.getSyncInstance().getLocalMoney();
    if (timeUsedByMinute > 0) {
      MoneyManager.getInstance().requestUpdateLocalMoney(
          context: Utility.getGlobalContext(),
          localMoney: localMoney,
          shouldShowToast: false);
    }
    MongoApisManager.getInstance().insertTimelineMissionModel(
        missionModel: Utility.getTimelineMissionModelFromMissionModel(
            sceneType: 'mission',
            eventType: 'stop_focusing_mission',
            timelineMessage: getI18NKey().exist_app_focusing_mission_name(
                missionModel?.title ?? "",
                Utility.formatHourAndMinAndSec(this.timeUsed),
                localMoney),
            missionModel: missionModel ?? MissionModel()));
  }

  void stopFromFocusingStatus() {
    //初始化放关机缓存
    SharePreferenceUtil.getSyncInstance().setString(key: ShareprefrenceKeys.curFocusingMissionObjectIdKey, content: "");
    _timerUtil!.updateTotalTime(
        curTimeF = SharePreferenceUtil.getSyncInstance().getTomatoRestTime());
    counterStatus = CounterStatus.waitingToStartRelaxing;
    this.btnText = getBtnText(counterStatus);
    if (this.timeUsed > 5 * 60 * 1000) {
      DialogManagement.showRatingDialog(Utility.getGlobalContext(),
          scene: EVENTNAME.missiondetailpage);
    }
    AudioPlayUtil.getInstance()?.pause();
    MoneyManager.getInstance().resetLocalMoney();
    this.updateUI();
  }

  void nextStatus(bool pressPauseButton) {
    // focusing, //专注中
    // pausingFucusing, //专注暂停中
    // relaxing, //休息中
    // waitingToFocus, //等待专注中
    // waitingToStartRelaxing, //等待休息启动
    // pausingRelaixing  //暂停休息中
    // 用于记录是否专注中
    //初始化放关机缓存
    SharePreferenceUtil.getSyncInstance().setString(key: ShareprefrenceKeys.curFocusingMissionObjectIdKey, content: "");
    // SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.curFocusingMissionObjectIdForTimeUsedKey, value: 0);
    // SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.curFocusingMissionObjectIdForCurTimeFKey, value: 0);
    // SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.curFocusingMissionObjectIdForTotalTimeFKey, value: 0);

    //用于保存当前专注中的MissionModel 如果用户下次进来有值 那就证明上次是被系统关机的 通过判断missionId来判断上次是否正常退出
    if((counterStatus == CounterStatus.focusing && pressPauseButton == true) || counterStatus == CounterStatus.pausingFocusing || counterStatus == CounterStatus.waitingToFocus) { // 马上开始专注
      SharePreferenceUtil.getSyncInstance().setString(key: ShareprefrenceKeys.curFocusingMissionObjectIdKey, content: this.missionModel?.objectId ?? "");
    }
    //休息完成或者专注完成执行这个
    if(pressPauseButton == false && (counterStatus == CounterStatus.relaxing || counterStatus == CounterStatus.focusing)) {
      DeviceInfoManagement.vibrate();
    }
    print(
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~nextstatus~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    if (CounterStatus.focusing == counterStatus) {
      if (pressPauseButton) {
        //如果计时点击按钮就是暂停休息 点击继续
        counterStatus = CounterStatus.pausingFocusing;
        AudioPlayUtil.getInstance()?.pause();
        pauseTimer();
      } else {
        //到这个状态证明完成一个任务
        if (this.curTimeF == 0) {
          //表示自动暂停才播放音乐
          // 开关开了才执行
          AudioPlayUtil.getInstance()?.stop();
          // bool isOn = SharePreferenceUtil.getSyncInstance().isFocusFinishAlertOn();
          if (SharePreferenceUtil.getSyncInstance().isFocusFinishAlertOn()) {
            MusicModel musicModel = SharePreferenceUtil.getSyncInstance()
                .getFinishFocusingMusicModel();
            AudioPlayUtil.getInstance()?.play(musicModel.localPath ?? "",
                isLocal: true, duration: Params.RINGTONE_DURATION);
          }
          if (SharePreferenceUtil.getSyncInstance().getLoopOnFocusing() ==
              true) {
            Future.delayed(Duration(milliseconds: 100), () {
              nextStatus(true);
            });
          }
        }
        this.curTimeF =
            SharePreferenceUtil.getSyncInstance().getTomatoRestTime();
        counterStatus = CounterStatus.waitingToStartRelaxing;
      }
    } else if (CounterStatus.waitingToStartRelaxing == counterStatus) {
      AudioPlayUtil.getInstance()?.stop();
      if (SharePreferenceUtil.getSyncInstance().isRestBGMusicOn()) {
        AudioPlayUtil.getInstance()?.play(
            (SharePreferenceUtil.getSyncInstance().getRestingBGMusicModel())
                    ?.localPath ??
                CONSTANTS.getFocusAndRestingMusicModelList()[0].url!,
            isLocal: true);
      }
      WakelockPlus.toggle(enable: true);
      this.startTimer(CounterEnum.chronograph);
      MongoApisManager.getInstance().insertTimelineMissionModel(
          missionModel: Utility.getTimelineMissionModelFromMissionModel(
              sceneType: 'mission',
              eventType: 'start_resting_mission',
              timelineMessage:
                  getI18NKey().start_resting_name(missionModel?.title ?? ""),
              missionModel: missionModel ?? MissionModel()));
      counterStatus = CounterStatus.relaxing; //开始放松
    } else if (CounterStatus.pausingFocusing == counterStatus) {
      WakelockPlus.toggle(enable: true);
      if (SharePreferenceUtil.getSyncInstance().isFocusBGMusicOn()) {
        AudioPlayUtil.getInstance()?.continuePlayer();
      }
      this.startTimer(this.counterEnum, isPause: true); //之前暂停 继续专注
      counterStatus = CounterStatus.focusing;
    } else if (CounterStatus.relaxing == counterStatus) {
      //休息中不需要暂停
      // if (pressPauseButton) {
      //   counterStatus = CounterStatus.pausingRelaixing;
      //   pauseTimer();
      // } else {
      if (SharePreferenceUtil.getSyncInstance().getLoopOnRelaxing() == false) {
        //休息结束走这里
        stopRelaxing();
      } else {
        if (this.curTimeF == 0) {
          Future.delayed(Duration(milliseconds: 100), () {
            CounterManagement.getInstance().nextStatus(true);
          });
        }
        stopRelaxing();
        // nextStatus(true);
      }
      // }
    } else if (CounterStatus.waitingToFocus == counterStatus) {
      WakelockPlus.toggle(enable: true);
      startFocusing();
      counterStatus = CounterStatus.focusing; //专注中
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      if (SharePreferenceUtil.getSyncInstance().isRestBGMusicOn()) {
        AudioPlayUtil.getInstance()?.continuePlayer();
      }
      this.startTimer(CounterEnum.chronograph); //休息种
      counterStatus = CounterStatus.relaxing;
    }
    this.btnText = getBtnText(counterStatus);
    this.updateUI();
    print(CounterStatus.focusing);
  }

  void startFocusing() {
    AudioPlayUtil.getInstance()?.stop();
    if (SharePreferenceUtil.getSyncInstance().isFocusBGMusicOn() == true) {
      AudioPlayUtil.getInstance()?.play(
          (SharePreferenceUtil.getSyncInstance().getFocusingBGMusicModel())
                  ?.localPath ??
              CONSTANTS.getFocusAndRestingMusicModelList()[0].url!,
          isLocal: true);
    }
    this.startTimer(this.counterEnum);
    MongoApisManager.getInstance().insertTimelineMissionModel(
        missionModel: Utility.getTimelineMissionModelFromMissionModel(
            sceneType: 'mission',
            eventType: 'start_focusing_mission',
            timelineMessage: getI18NKey()
                .start_focusing_mission_name(missionModel?.title ?? ""),
            missionModel: missionModel ?? MissionModel()));
  }

  void stopRelaxing() {
    SharePreferenceUtil.getSyncInstance().incTomatoLongDurationCurCounter();
    if (this.curTimeF == 0) {
      //表示自动暂停才播放音乐
      AudioPlayUtil.getInstance()?.stop();
      if (SharePreferenceUtil.getSyncInstance().isRestBGMusicOn()) {
        AudioPlayUtil.getInstance()?.play(
            (SharePreferenceUtil.getSyncInstance().getFinishRestingMusicModel())
                    .localPath ??
                "",
            isLocal: true,
            duration: Params.RINGTONE_DURATION);
      }
      MongoApisManager.getInstance().insertTimelineMissionModel(
          missionModel: Utility.getTimelineMissionModelFromMissionModel(
              sceneType: 'mission',
              eventType: 'complete_resting_mission',
              timelineMessage: getI18NKey()
                  .complete_resting_mission_name(missionModel?.title ?? ""),
              missionModel: missionModel ?? MissionModel()));
    } else {
      MongoApisManager.getInstance().insertTimelineMissionModel(
          missionModel: Utility.getTimelineMissionModelFromMissionModel(
              sceneType: 'mission',
              eventType: 'stop_resting_mission',
              timelineMessage: getI18NKey()
                  .stop_resting_mission_name(missionModel?.title ?? ""),
              missionModel: missionModel ?? MissionModel()));
    }
    AudioPlayUtil.getInstance()?.stop();
    pauseTimer();
    if (this.counterEnum == CounterEnum.chronograph) {
      _timerUtil!.updateTotalTime(curTimeF =
          this.missionModel?.tomato_duration ??
              SharePreferenceUtil.getSyncInstance().getTomatoTime());
    } else {
      _timerUtil!.updateTotalTime(curTimeF = 0);
    }
    counterStatus = CounterStatus.waitingToFocus;
  }

  updateUI() {
    // CounterMethodChannel.getInstance().requestStatusBar(
    //     CounterModelRequest(status: counterStatus.index, text: getTimeStringValue()));
    triggerOnUpateUIListener();
  }

  String getBtnText(CounterStatus counterStatus) {
    if (counterStatus == null) counterStatus = this.counterStatus;
    if (CounterStatus.pausingFocusing == counterStatus) {
      //专注暂停中
      return getI18NKey().continueTxt;
    } else if (CounterStatus.waitingToStartRelaxing == counterStatus) {
      int timeUsedByMinute =
          (this.timeUsed / (1000 * 60)).toInt() - this.timeUsedByMinute;
      //时间够了提升值
      int localMoney = timeUsedByMinute *
          SharePreferenceUtil.getSyncInstance().getLocalMoney();
      if (timeUsedByMinute > 0) {
        MoneyManager.getInstance().requestUpdateLocalMoney(
            context: Utility.getGlobalContext(),
            localMoney: localMoney,
            shouldShowToast: false);
      }
      this.timeUsedByMinute = 0;
      if (curTimeF <= 0) {
        MongoApisManager.getInstance().insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                sceneType: 'mission',
                eventType: 'complete_focusing_mission',
                timelineMessage: getI18NKey()
                    .complete_one_time_focusing_mission_name(
                        missionModel?.title ?? "",
                        Utility.formatHourAndMinAndSec(this.timeUsed),
                        localMoney),
                missionModel: missionModel ?? MissionModel()));
      } else {
        MongoApisManager.getInstance().insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                sceneType: 'mission',
                eventType: 'stop_focusing_mission',
                timelineMessage: getI18NKey().stop_focusing_mission_name(
                    missionModel?.title ?? "",
                    Utility.formatHourAndMinAndSec(this.timeUsed),
                    localMoney),
                missionModel: missionModel ?? MissionModel()));
      }

      if (this.timeUsed > 0 && LoginManager.isLogin() == true) {
        requestUpdateTotalFocusTime(value: this.timeUsed);
      }
      // 播放声音
      //等待开始休息中
      _timerUtil?.updateTotalTime(
          SharePreferenceUtil.getSyncInstance().getTomatoRestTime());
      //更新MissionData完成了一个番茄
      this.missionModel?.time_finished =
          this.missionModel?.time_finished == null
              ? this.timeUsed
              : (this.missionModel!.time_finished ?? 0) + this.timeUsed;
      this.missionModel?.no_tomotoes_finished =
          (this.missionModel?.no_tomotoes_finished ?? 0) + 1;
      this.missionModel?.tomato_duration = this.missionModel!.tomato_duration;
      // if(this.folderModel == null && this.missionModel?.objectId != null) {
      //   this.folderModel =
      //       MongoApisManager.getInstance().queryWhereEqualFolderModelByObjectId(
      //           objectId: this.missionModel?.objectId ?? "");
      // }
      //更新 StatisticPage的数据
      this.missionEndTimeStamp = Utility.getTimeStampToday();
      if (this.missionBeginTimeStamp != 0 && this.missionEndTimeStamp != 0) {
        MongoApisManager.getInstance().insertStatsModel(
            title: this.missionModel?.title,
            type: 0,
            mission_id: this.missionModel?.objectId,
            fid: this.folderModel?.objectId ?? this.missionModel?.folder_id,
            icon: this.folderModel?.icon,
            color: this.folderModel?.color,
            tagName: this.missionModel?.tagNames,
            value: this.focusedDuration.toDouble(),
            //用于计算消耗时间
            category: this.folderModel?.title,
            begin_time: this.missionBeginTimeStamp,
            finish_time: this.missionEndTimeStamp,
            callback: (data) {
              eventBus.fire(EventFn(
                  Params.ACTION_FINISH_MISSIONMODEL_DETAIL, this.missionModel));
              this.requestData();
            });
      }
      MongoApisManager.getInstance().update_MissionModel(
          missionModel: this.missionModel ?? MissionModel(),
          shouldCheckPermission: false,
          callback: (data) {
            // this.requestData();
          });
      return getI18NKey().startResting;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      //休息暂停中
      return getI18NKey().continueTxt;
    } else if (CounterStatus.relaxing == counterStatus) {
      //休息中
      return getI18NKey().complete;
    } else if (CounterStatus.waitingToFocus == counterStatus) {
      //等待开始专注
      // _timerUtil?.updateTotalTimeAndStartCountDown(
      //     time =  SharePreferenceUtil.getInstance().getTomatoTime());
      return getI18NKey().startFocusing;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      //等待开始休息
      return getI18NKey().continueTxt;
    } else if (CounterStatus.focusing == counterStatus) {
      //专注中
      return getI18NKey().pause;
    }
    return '';
  }

  Future<void> requestUpdateTotalFocusTime({required int value}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.updateTotalFocusTime,
        params: {"totalFocusTime": value},
        shouldShowErrorToast: false);
    if (response.success == true) {
      LoginManager.getInstance().setUserBean(UserBean.fromJson(response.data));
      UserBean userBean = LoginManager.getInstance().getUserBean();
      eventBus.fire(EventFn(Params.ACTION_UPDATE_TOTAL_FOCUS_TIME, {}));
      //用于消费提示
      if (value < 0) {
        Utility.showToastMsg(msg: getI18NKey().consume_success);
      }
    } else {
      //用于消费提示
      if (value < 0) {
        Utility.showToastMsg(msg: getI18NKey().consume_failure);
      }
    }
  }

  /**
   * todo 如果放在首页
   * 根据objecId请求任务
   */
  void requestData() async {
    MissionModel? missionModelTmp = await MongoApisManager.getInstance()
        .queryWhereEqual_missionDataByObjectId(
            objectId: this.missionModel?.objectId ?? "");
    // todo
    // setState(() {
    //   this.missionModel = missionModelTmp[0];
    // });
    this.triggerOnRequestFinishListener(missionModelTmp ?? MissionModel());
    // eventBus.fire(EventFn('updateMissionPage', {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  /**
   * 暂停计时器
   */
  void pauseTimer() {
    CounterMethodChannelManager.getInstance().stopLiveActivity();
    // WakelockPlus.disable();
    WakelockPlus.toggle(enable: false);

    if (this.curTimeF != 0) {
      //不为0是人为暂停
      NotificationManager.getInstance()?.delAliyunSchedule();
    }
    if (_timerUtil!.isActive()) _timerUtil!.pause();
  }

  void dispose() {}
}
