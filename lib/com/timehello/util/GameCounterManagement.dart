import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import '../beans/BaseBean.dart';
import '../common/httpclient/HttpManager.dart';
import 'GameTimerUtil.dart';
import 'SharePreferenceUtil.dart';

class GameCounterManagement {
  static GameCounterManagement? mCounterManagement;
  GameTimerUtil? _mGameTimerUtil; //开始计算的时间
  GameTimerUtil? _mReadyGameTimerUtil; //前期准备时间计时器
  int curTimeF = 0; //当前专注时间
  int totalTime = 0;
  int timeUsed = 0; //展示在计时器的时间
  int readyTime = 0;
  int defaultReadyTime = 5000;
  // int timeRest = 0;
  GameStatusModeEnum gameStatusModeEnum = GameStatusModeEnum.WaitingToStart;
  List onRequestFinishListenerList = [];
  List onGameModeChangeListenerList = [];
  List onTimerTickListenerList = [];
  List onUpdateUIList = [];

  GameCounterManagement();

  isTimerActive() {
    return _mGameTimerUtil?.isActive();
  }

  static GameCounterManagement getInstance() {
    if (mCounterManagement == null) {
      mCounterManagement = new GameCounterManagement();
      // mCounterManagement!.init();
    }
    return mCounterManagement!;
  }

  init({int? duration, int? readyTime}) {
    // if (this.readyTime == 0) {
      this.readyTime = readyTime ?? defaultReadyTime;
      this.defaultReadyTime = this.readyTime;
    // }
    this.curTimeF =
        duration ?? SharePreferenceUtil.getSyncInstance().getGameTime();
    // if (_mGameTimerUtil == null) {
      _mGameTimerUtil = new GameTimerUtil(mCurTime: this.curTimeF);
    // }
    // if (_mReadyGameTimerUtil == null) {
      _mReadyGameTimerUtil = new GameTimerUtil(mCurTime: readyTime ?? defaultReadyTime);
    // }
    _mReadyGameTimerUtil!.mCurTime = this.readyTime;
    _mGameTimerUtil!.mCurTime = this.curTimeF;
    return mCounterManagement;
  }

  reset() {
    pauseReadyTimer();
    // this.onRequestFinishListenerList = [];
    // this.onGameModeChangeListenerList = [];
    // this.onTimerTickListenerList = [];
    // this.onUpdateUIList = [];
    _mGameTimerUtil = null;
    _mReadyGameTimerUtil = null;
    this.curTimeF = 0; //当前专注时间
    this.totalTime = 0;
    this.timeUsed = defaultReadyTime;
    // _mReadyGameTimerUtil?.cancel();
    // _mReadyGameTimerUtil?.cancel();
    // defaultReadyTime = 5000;
    init();
    gameStatusModeEnum = GameStatusModeEnum.WaitingToStart;
    this.dispose();
  }

  addOnRequestFinishListener({required Function onRequestFinishListener}) {
    this.onRequestFinishListenerList.add(onRequestFinishListener);
  }

  addOnTimerTickListener({required Function onTimerTickListener}) {
    this.onTimerTickListenerList.add(onTimerTickListener);
  }

  addOnGameModeChangeLister({required Function onGameModeChangeLister}) {
    this.onGameModeChangeListenerList.add(onGameModeChangeLister);
  }


  remoteTimerTickListener({required Function onTimerTickListener}) {
    this.onTimerTickListenerList.remove(onTimerTickListener);
  }

  removeRequestFinishListener({required Function onRequestFinishListener}) {
    this.onRequestFinishListenerList.remove(onRequestFinishListener);
  }

  triggerOnGameModeChangeListener(GameStatusModeEnum gameStatusModeEnum) {
    for (int i = 0; i < this.onGameModeChangeListenerList.length; i++) {
      Function f = this.onGameModeChangeListenerList[i];
      f(gameStatusModeEnum.index);
    }
  }

  triggerOnTimerTickListener(int time) {
    for (int i = 0; i < this.onTimerTickListenerList.length; i++) {
      Function f = this.onTimerTickListenerList[i];
      f(time);
    }
  }

  void nextStatus() {
    if (gameStatusModeEnum == GameStatusModeEnum.WaitingToStart) {
      gameStatusModeEnum = GameStatusModeEnum.ReadyTimeCounting;
      startReadyTimer();
    } else if (gameStatusModeEnum == GameStatusModeEnum.ReadyTimeCounting) {
      gameStatusModeEnum = GameStatusModeEnum.Starting;
      pauseReadyTimer();
      startTimer();
    } else if (gameStatusModeEnum == GameStatusModeEnum.Starting) {
      gameStatusModeEnum = GameStatusModeEnum.Finished;
      pauseTimer();
    } else if (gameStatusModeEnum == GameStatusModeEnum.Finished) {
      reset();
      gameStatusModeEnum = GameStatusModeEnum.ReadyTimeCounting;
      startReadyTimer();
    }
    triggerOnGameModeChangeListener(gameStatusModeEnum);
  }

  /**
   * 启动计时器
   */
  void startTimer() {
    if (!_mGameTimerUtil!.isActive()) {
      _mGameTimerUtil?.setOnTimerTickCallback((curTime, int totalTime,
          int timeLeft, int timeUsed, bool isFirstTime) {
        // todo
        this.curTimeF = curTime;
        this.totalTime = totalTime;
        this.timeUsed = timeUsed;
        print("${this.timeUsed}");
        if (isFirstTime == true && (totalTime - timeUsed) > 0) {}
        this.triggerOnTimerTickListener(curTimeF);
      });
      _mGameTimerUtil!.startCountDown();
    }
  }

  void startReadyTimer() {
    if(!_mReadyGameTimerUtil!.isActive()) {
      _mReadyGameTimerUtil?.setOnTimerTickCallback((curTime, int totalTime,
          int timeLeft, int timeUsed, bool isFirstTime) {
        // todo
        // this.curTimeF = timeLeft;
        this.timeUsed = timeLeft;
        // this.totalTime = totalTime;
        // this.timeUsed = timeUsed;
        // if (isFirstTime == true && (totalTime - timeUsed) > 0) {}
        this.triggerOnTimerTickListener(curTimeF);
        if (timeLeft == 0) {
          nextStatus();
          // startTimer();
        }
      });
      _mReadyGameTimerUtil!.startCountDown();
    }
  }

  updateUI() {
    // CounterMethodChannel.getInstance().requestStatusBar(
    //     CounterModelRequest(status: counterStatus.index, text: getTimeStringValue()));
  }

  Future<void> requestUpdateTotalFocusTime({required int value}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.updateTotalFocusTime,
        params: {"totalFocusTime": value},
        shouldShowErrorToast: false);
    if (response.success == true) {
    } else {
      //用于消费提示
    }
  }

  /**
   * 暂停计时器
   */
  void pauseTimer() {
    if (_mGameTimerUtil!.isActive()) _mGameTimerUtil!.cancel();
  }

  /**
   * 暂停等待中计时器
   */
  void pauseReadyTimer() {
    if (_mReadyGameTimerUtil!.isActive()) _mReadyGameTimerUtil!.cancel();
  }


  void dispose() {}
}
