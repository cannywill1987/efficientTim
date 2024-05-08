import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import '../beans/BaseBean.dart';
import '../beans/UserBean.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import 'LoginManager.dart';
import 'SharePreferenceUtil.dart';
import 'Utility.dart';

/**
 * 用于金额管理
 */
class NumTimesAppOpenManager {
  static NumTimesAppOpenManager? mNumTimesAppOpenManager;
  int numTimesOpen = 0;

  static NumTimesAppOpenManager getInstance() {
    if (mNumTimesAppOpenManager == null) {
      mNumTimesAppOpenManager = new NumTimesAppOpenManager();
    }
    return mNumTimesAppOpenManager!;
  }

  void incTimes() {
    int numTimesOpen = SharePreferenceUtil.getSyncInstance().getInt(key: ShareprefrenceKeys.numTimesOpen, defaultVal: 0);
    SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.numTimesOpen, value: ++numTimesOpen);
    this.numTimesOpen = numTimesOpen;
  }
  init() {}
}
