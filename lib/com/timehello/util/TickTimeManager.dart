import 'dart:async';

/**
 * 用于整个app时间计数刷新组件 降低不必要计时器生成和销毁 比如现在做 番茄钟等
 */
class TickTimeManager {
  static TickTimeManager? mTickTimeManager;
  int cpt = 0;
  Timer? _timer;
  List<Function> onCallbackList =
  [];
  static TickTimeManager getInstance() {
    if (mTickTimeManager == null) {
      mTickTimeManager = new TickTimeManager();
      mTickTimeManager?.init();
    }
    return mTickTimeManager!;
  }

  init() {
    startTimer();
  }

  triggerCallback(int cpt) {
    for (int i = 0; i < this.onCallbackList.length; i++) {
      Function f =
      this.onCallbackList[i];
      f();
    }
  }

  dispose() {
    if(_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    if(onCallbackList != null && onCallbackList.length > 0) {
      onCallbackList.removeRange(0, onCallbackList.length);
    }
  }

  addCallback(
      {required Function
      callback}) {
    if(this.onCallbackList.indexOf(callback) == -1) {
    this
        .onCallbackList
        .add(callback);
    };
  }

  removeCallback(
      {required Function
      callback}) {
    this
        .onCallbackList
        .remove(callback);
  }

  void startTimer() {
    if(_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      triggerCallback(cpt);
    });
  }
}
