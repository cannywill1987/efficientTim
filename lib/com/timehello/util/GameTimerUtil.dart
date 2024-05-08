import 'dart:async';

import 'package:time_hello/com/timehello/util/NotificationUtil.dart';

///timer callback.(millisUntilFinished 毫秒).
typedef void OnTimerTickCallback(int millisUntilFinished, int totalTime, int timeUsed, int timeLeft, bool isFirstTime);

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Timer Util.
 * @Date: 2018/9/28
 */

/// TimerUtil.
class GameTimerUtil {

  /// Timer.
  Timer? _mTimer;

  /// Is Timer active.
  /// Timer是否启动.
  bool _isActive = false;

  /// Timer interval (unit millisecond，def: 1000 millisecond).
  /// Timer间隔 单位毫秒，默认1000毫秒(1秒).
  int mInterval;

  /// countdown totalTime.
  /// 倒计时总时间
  int mCurTime = 0; //单位毫秒

  int mTotalTime = 0;

  OnTimerTickCallback? _onTimerTickCallback;


  GameTimerUtil(
      {this.mInterval = Duration.millisecondsPerSecond, mCurTime = 0}) {
    this.mCurTime = mCurTime ?? 0;
    this.mTotalTime = this.mCurTime;
  }

  /// set Timer interval. (unit millisecond).
  /// 设置Timer间隔.
  void setInterval(int interval) {
    if (interval <= 0) interval = Duration.millisecondsPerSecond;
    mInterval = interval;
  }

  /// set countdown totalTime. (unit millisecond).
  /// 设置倒计时总时间.
  void setTotalTime(int totalTime) {
    if (totalTime <= 0) return;
    mCurTime = totalTime;
  }

  /// start Timer.
  /// 启动定时Timer.
  void startTimer() {
    if (_isActive || mInterval <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(0, this.mTotalTime, this.mTotalTime - mCurTime, mCurTime, true);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      _doCallback(timer.tick, this.mTotalTime, this.mTotalTime - mCurTime, mCurTime, false);
    });
  }

  /// start countdown Timer.
  /// 启动倒计时Timer.
  void startCountDown() {
    if (_isActive || mInterval <= 0 || mCurTime <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(mCurTime, this.mTotalTime, this.mTotalTime, 0, true);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      int time = mCurTime - mInterval;
      mCurTime = time;
      if (time >= mInterval) {
        _doCallback(time, this.mTotalTime, mCurTime, this.mTotalTime - mCurTime, false);
      } else if (time == 0) {
        _doCallback(time, this.mTotalTime, mCurTime, this.mTotalTime - mCurTime, false);
        cancel();
      } else {
        timer.cancel();
        Future.delayed(Duration(milliseconds: time), () {
          mCurTime = 0;
          _doCallback(0, this.mTotalTime, mCurTime, this.mTotalTime - mCurTime, false);
          cancel();
        });
      }
    });
  }


  void _doCallback(int time, int totalTime, int timeLeft, int timeUsed, bool isFirstTime) {
    if (_onTimerTickCallback != null) {
      // print('totalTime:${totalTime}, timeUsed: ${timeUsed}');
      _onTimerTickCallback!(time, totalTime, timeLeft, timeUsed, isFirstTime);
    }
  }

  /// update countdown totalTime.
  /// 重设倒计时总时间.
  // void updateTotalTimeAndStartCountDown(int totalTime) {
  //   cancel();
  //   mCurTime = totalTime;
  //   mTotalTime = mCurTime;
  //   startCountDown();
  // }

  // void updateTotalTime(int totalTime) {
  //   cancel();
  //   mCurTime = totalTime;
  //   mTotalTime = mCurTime;
  // }

  /// timer is Active.
  /// Timer是否启动.
  bool isActive() {
    return _isActive;
  }

  /// Cancels the timer.
  /// 取消计时器.
  void cancel() {
    if (_mTimer != null) {
      _mTimer?.cancel();
      _mTimer = null;
      _isActive = false;
      mCurTime = 0;
    }
  }

  /// Cancels the timer.
  /// 暂停计时器.
  void pause() {
    _mTimer?.cancel();
    _mTimer = null;
    _isActive = false;
  }

  /// set timer callback.
  void setOnTimerTickCallback(OnTimerTickCallback callback) {
    _onTimerTickCallback = callback;
  }
}