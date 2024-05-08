import 'dart:async';

import 'package:time_hello/com/timehello/util/NotificationUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/ENUMS.dart';

///timer callback.(millisUntilFinished 毫秒).
typedef void OnTimerTickCallback(
    int millisUntilFinished, int totalTime, int timeUsed, bool isFirstTime);

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Timer Util.
 * @Date: 2018/9/28
 */

/// TimerUtil.
class TimerUtil {
  /// Timer.
  Timer? _mTimer;

  /// Is Timer active.
  /// Timer是否启动.
  bool _isActive = false;

  /// Timer interval (unit millisecond，def: 1000 millisecond).
  /// Timer间隔 单位毫秒，默认1000毫秒(1秒).
  int mInterval = 1000;

  /// countdown totalTime.
  /// 倒计时总时间
  int mCurTime = 0; //单位毫秒

  int startTimeStamp1970 = -1;

  int mTotalTime = 0;

  CounterEnum counterEnum = CounterEnum.chronograph;

  OnTimerTickCallback? _onTimerTickCallback;

  TimerUtil({this.mInterval = Duration.millisecondsPerSecond, mCurTime = 0}) {
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
    this.mCurTime = totalTime;
  }

  /// start Timer.
  /// 启动定时Timer.
  // void startTimer() {
  //   if (_isActive || mInterval <= 0) return;
  //   _isActive = true;
  //   Duration duration = Duration(milliseconds: mInterval);
  //   _doCallback(0, this.mTotalTime, this.mTotalTime - mCurTime, true);
  //   startTimeStamp1970 = Utility.getTimeStampToday();
  //   _mTimer = Timer.periodic(duration, (Timer timer) {
  //     print("time1970: ${Utility.getTimeStampToday() - startTimeStamp1970}, time: ${timer.tick}");
  //
  //     _doCallback(timer.tick, this.mTotalTime, this.mTotalTime - mCurTime, false);
  //   });
  // }

  /// start countdown Timer.
  /// 启动倒计时Timer.
  /// isPause true表示从暂停点继续过来 mCurTime 为上一次的值 false 表示停止 点开始 mCurTime为0
  void startCountUp({isPause: false}) {
    if (_isActive || mInterval <= 0 || this.mCurTime < 0) return;
    _isActive = true;
    if (isPause == false) {
      //false 表示停止 点开始 mCurTime为0
      startTimeStamp1970 = Utility.getTimeStampToday(); //参考值
      this.mCurTime = 0;
    } else {
      startTimeStamp1970 = Utility.getTimeStampToday() - this.mCurTime; //参考值
    }
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(mCurTime, this.mTotalTime, mCurTime, false);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      // int time2 = mCurTime - mInterval;
      int timeNow = Utility.getTimeStampToday();
      mCurTime = ((timeNow - startTimeStamp1970) / 1000).toInt() * 1000;
      // print("time1970: ${mCurTime}");
      // int time = ((Utility.getTimeStampToday() - startTimeStamp1970) / 1000).toInt();
      // mCurTime = time;
      // if (mCurTime >= mInterval) {
      _doCallback(mCurTime, this.mTotalTime, mCurTime, false);
      // } else if (mCurTime == 0) {
      //   _doCallback(mCurTime, this.mTotalTime, this.mTotalTime - mCurTime, false);
      //   cancel();
      // } else {
      //   timer.cancel();
      //   Future.delayed(Duration(milliseconds: time), () {
      //     mCurTime = 0;
      //     _doCallback(0, this.mTotalTime, this.mTotalTime - mCurTime, false);
      //     cancel();
      //   });
      // }
    });
  }

  /// start countdown Timer.
  /// timeHasUsed 0表示没有设置值 非0表示从什么时间开始算 已经消耗的时间
  /// 启动倒计时Timer.
  void startCountDown() {
    // || mCurTime < 0
    if (_isActive || mInterval <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(mCurTime, this.mTotalTime, this.mTotalTime - mCurTime, true);
    //如果不同代表点击了继续 需要重新复制mTotalTime
    if (mTotalTime != mCurTime) {
      mTotalTime = mCurTime;
    }
    startTimeStamp1970 = Utility.getTimeStampToday();
    _mTimer = Timer.periodic(duration, (Timer timer) {
      int time2 = mCurTime - mInterval;
      int timeNow = Utility.getTimeStampToday();
      int time = this.mTotalTime -
          ((timeNow - startTimeStamp1970) / 1000).toInt() * 1000;
      // print("curTime: ${mCurTime}， time1970: ${time}, time: ${time2}");
      // int time = ((Utility.getTimeStampToday() - startTimeStamp1970) / 1000).toInt();
      mCurTime = time;
      if (time >= mInterval) {
        _doCallback(time, this.mTotalTime, this.mTotalTime - mCurTime, false);
      } else if (time == 0) {
        _doCallback(time, this.mTotalTime, this.mTotalTime - mCurTime, false);
        cancel();
      } else {
        timer.cancel();
        Future.delayed(Duration(milliseconds: time), () {
          mCurTime = 0;
          _doCallback(0, this.mTotalTime, this.mTotalTime - mCurTime, false);
          cancel();
        });
      }
    });
  }

  void _doCallback(int time, int totalTime, int timeUsed, bool isFirstTime) {
    if (_onTimerTickCallback != null) {
      // print('totalTime:${totalTime}, timeUsed: ${timeUsed}');
      _onTimerTickCallback!(time, totalTime, timeUsed, isFirstTime);
    }
  }

  /// update countdown totalTime.
  /// 重设倒计时总时间.
  void updateTotalTimeAndStartCountDown(int totalTime) {
    cancel();
    mCurTime = totalTime;
    mTotalTime = mCurTime;
    startCountDown();
  }

  void updateTotalTime(int totalTime) {
    cancel();
    mCurTime = totalTime;
    mTotalTime = mCurTime;
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
      if (this.counterEnum == CounterEnum.chronograph) {
        mCurTime = 0;
      }
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
