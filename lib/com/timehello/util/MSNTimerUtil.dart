import 'dart:async';

import 'package:time_hello/com/timehello/util/NotificationUtil.dart';

///timer callback.(millisUntilFinished 毫秒).
typedef void OnTimerTickCallback(int millisUntilFinished, int totalTime);

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Timer Util.
 * @Date: 2018/9/28
 */

/// TimerUtil.
class MSNTimerUtil {

  /// Timer.
  Timer? _mTimer;

  /// Is Timer active.
  /// Timer是否启动.
  bool _isActive = false;

  /// Timer interval (unit millisecond，def: 1000 millisecond).
  /// Timer间隔 单位毫秒，默认1000毫秒(1秒).
  int? mInterval;

  /// countdown totalTime.
  /// 倒计时总时间
  int? mCurTime; //单位毫秒

  int? mTotalTime;

  OnTimerTickCallback? _onTimerTickCallback;


  MSNTimerUtil(
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
    if (_isActive || (mInterval ?? 0) <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval ?? 0);
    _doCallback(0, this.mTotalTime ?? 0);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      _doCallback(timer.tick, this.mTotalTime ?? 0);
    });
  }

  /// start countdown Timer.
  /// 启动倒计时Timer.
  void startCountDown() {
    if (_isActive || (mInterval ?? 0) <= 0 || (mCurTime ?? 0) <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval ?? 0);
    _doCallback(mCurTime ?? 0, this.mTotalTime ?? 0);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      int time = (mCurTime ?? 0) - (mInterval ?? 0);
      mCurTime = time;
      if (time >= (mInterval ?? 0)) {
        _doCallback(time, (this.mTotalTime ?? 0));
      } else if (time == 0) {
        _doCallback(time, (this.mTotalTime ?? 0));
        cancel();
      } else {
        timer.cancel();
        Future.delayed(Duration(milliseconds: time), () {
          mCurTime = 0;
          _doCallback(0, (this.mTotalTime ?? 0));
          cancel();
        });
      }
    });
  }


  void _doCallback(int time, int totalTime) {
    if (_onTimerTickCallback != null) {
      _onTimerTickCallback!(time, totalTime);
    }
  }

  /// update countdown totalTime.
  /// 重设倒计时总时间.
  void updateTotalTime(int totalTime) {
    cancel();
    mCurTime = totalTime;
    mTotalTime = mCurTime;
    startCountDown();
  }

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