import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
// import 'dart:convert' as convert;

import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/ENUMS.dart';

/// Screen Util.
class SharePreferenceUtil {
  static SharePreferenceUtil? _instance;
  SharedPreferences? mSharedPreferences;
  Set<String> listKeysHttps = Set();
  static Lock _lock = Lock();

  static SharePreferenceUtil getSyncInstance() {
    if (_instance == null) {
      _instance = new SharePreferenceUtil();
      _instance?.initShareprerence();
    }
    return _instance!;
  }

  static Future<SharePreferenceUtil> getAsyncInstance() async {
    await _lock.synchronized(() async {
      if (_instance == null) {
        _instance = new SharePreferenceUtil();
        await _instance?.initShareprerence();
      }
    });
    return _instance!;
  }

   initShareprerence() async {
    if (mSharedPreferences == null) {
      mSharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<SharedPreferences> init() async {
    mSharedPreferences = await SharedPreferences.getInstance();
    return mSharedPreferences!;
  }

   setString({required String key, required String content}) {
    if(mSharedPreferences != null) {
    mSharedPreferences?.setString(key, content);
    }
  }

  String getString({required String key, String defaultVal = ""}) {
    if (mSharedPreferences == null || key == null) {
      return '';
    }
    return mSharedPreferences?.getString(key) ?? defaultVal;
  }

  void setInt({required String key, required int value}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setInt(key, value);
    }
  }

  int getInt({required String key, int defaultVal = 0}) {
    try {
      if (mSharedPreferences == null || key == null) {
        return defaultVal;
      }
      return mSharedPreferences?.getInt(key) ?? defaultVal;
    } catch(e) {
      return defaultVal;
    }
  }

  void setBool({required String key, required bool val}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool(key, val);
    }
  }

  bool getBool({required String key, bool defaultVal = false}) {
    if (mSharedPreferences == null || key == null) {
      return defaultVal;
    }
    return mSharedPreferences?.getBool(key) ?? defaultVal;
  }

  void setCompleteMissionVisible({visible: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('CompleteMissionVisible', visible);
    }
  }

  bool getCompleteMissionVisible() {
    return mSharedPreferences?.getBool('CompleteMissionVisible') ?? true;
  }

  void setWQBCompleteMissionVisible({visible: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('WQBCompleteMissionVisible', visible);
    }
  }

  bool getWQBCompleteMissionVisible() {
    return mSharedPreferences?.getBool('WQBCompleteMissionVisible') ?? true;
  }

  void setLoopOnFocusing({isOn: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('LoopOnFocusing', isOn);
    }
  }

  bool getLoopOnFocusing() {
    return mSharedPreferences?.getBool('LoopOnFocusing') ?? true;
  }

  void setLoopOnRelaxing({isOn: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('LoopOnRelaxing', isOn);
    }
  }
  bool getDefault9DigitPasswordsNeedShowWhenLogin() {
    return mSharedPreferences?.getBool(ShareprefrenceKeys.default9DigitPasswordsNeedShowWhenLogin) ?? true;
  }

  void setDefault9DigitPasswordsNeedShowWhenLogin({isOn: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool(ShareprefrenceKeys.default9DigitPasswordsNeedShowWhenLogin, isOn);
    }
  }
  bool getDefault9DigitPasswordsNeedShowWhenLoginAppLock() {
    return mSharedPreferences?.getBool(ShareprefrenceKeys.default9DigitPasswordsNeedShowWhenLoginAppLock) ?? true;
  }

  void setDefault9DigitPasswordsNeedShowWhenLoginAppLock({isOn: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool(ShareprefrenceKeys.default9DigitPasswordsNeedShowWhenLoginAppLock, isOn);
    }
  }

  /**
   * 计时器样式 0 Flip 1 oswald 2 kablammo
   */
  int getFontMode() {
    return mSharedPreferences?.getInt('FontMode') ?? 1;
  }

  /**
   * 计时器样式 0 Flip 1 oswald 2 kablammo
   */
  void setFontMode(int bgMode) {
    mSharedPreferences?.setInt('FontMode', bgMode);
  }

  //背景模式 0 手动 1 自动 2 纯净
  int getBgMode() {
    return mSharedPreferences?.getInt('BgMode') ?? 1;
  }

  /**
   * 背景模式 0 手动 1 自动 2 纯净
   */
  void setBgMode(int bgMode) {
    mSharedPreferences?.setInt('BgMode', bgMode);
  }


  bool getLoopOnRelaxing() {
    return mSharedPreferences?.getBool('LoopOnRelaxing') ?? true;
  }

  /**
   * 休息结束铃声开关
   */
  bool isFocusBGMusicOn() {
    return mSharedPreferences?.getBool('isFocusBGMusicOn') ?? true;
  }

  /**
   * 休息结束铃声开关
   */
  void setFocusBGMusicOn({bool isOn = true}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('isFocusBGMusicOn', isOn);
    }
  }


  /**
   * 休息结束铃声开关
   */
  bool isRestBGMusicOn() {
    return mSharedPreferences?.getBool('isRestBGMusicOn') ?? true;
  }

  /**
   * 休息结束铃声开关
   */
  void setRestBGMusicOn({bool isOn = true}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('isRestBGMusicOn', isOn);
    }
  }

  /**
   * 休息结束铃声开关
   */
  bool isRestFinishAlertOn() {
    return mSharedPreferences?.getBool('restFinishAlertOn') ?? true;
  }

  /**
   * 休息结束铃声开关
   */
  void setRestFinishAlertOn({bool isOn = true}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('restFinishAlertOn', isOn);
    }
  }


  /**
   * 专注结束铃声开关
   */
  bool isFocusFinishAlertOn() {
    return mSharedPreferences?.getBool('focusFinishAlertOn') ?? true;
  }

  /**
   * 专注结束铃声开关
   */
  void setFocusFinishAlertOn({bool isOn = true}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('focusFinishAlertOn', isOn);
    }
  }

  void setAlipushOn({isOn: false}) {
    if(mSharedPreferences != null) {
      mSharedPreferences?.setBool('AlipushOn', isOn);
    }
  }

  bool getAlipushOn() {
    return mSharedPreferences?.getBool('AlipushOn') ?? true;
  }

  void setUserBean({required UserBean userBean}) {
    if (userBean != null) {
      this.setString(
          key: 'loginInfoModel', content: jsonEncode(userBean.toJson()));
      LoginManager.getInstance().init();
    }
  }

  UserBean? getUserBean() {
    String s = this.getString(key: 'loginInfoModel');
    if (s != null) {
      try {
        Map<String, dynamic> res = jsonDecode(s);
        UserBean loginInfoModel = UserBean.fromJson(res);
        return loginInfoModel;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  double getMobileCounterPosX() {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    try {
      initShareprerence();
      return mSharedPreferences?.getDouble('MobileCounterPosX' + size.width.toString()) ?? size.width - 72;
    } catch (e) {
      return (size.width)/ 2 - 50/5;
    }
  }

  double getMobileCounterPosY() {
      final size = MediaQuery.of(Utility.getGlobalContext()).size;
    try {
      initShareprerence();
      return mSharedPreferences?.getDouble('MobileCounterPosY' + size.height.toString()) ?? size.height - 102;
    } catch (e) {
      return size.height - 102;
    }
  }

  void setMobileCounterPosX(double x) {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    initShareprerence();
    mSharedPreferences?.setDouble('MobileCounterPosX' + size.width.toString(), x);
  }

  void setMobileCounterPosY(double y) {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    initShareprerence();
    mSharedPreferences?.setDouble('MobileCounterPosY' + size.height.toString(), y);
  }

  void setLocalMobileCounterPosX(double x) {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    initShareprerence();
    mSharedPreferences?.setDouble('LocalMobileCounterPosX' + size.width.toString(), x);
  }

  void setLocalMobileCounterPosY(double y) {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    initShareprerence();
    mSharedPreferences?.setDouble('LocalMobileCounterPosY' + size.height.toString(), y);
  }

  double getLocalMobileCounterPosX() {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    try {
      initShareprerence();
      return mSharedPreferences?.getDouble('LocalMobileCounterPosX' + size.width.toString()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  double getLocalMobileCounterPosY() {
    final size = MediaQuery.of(Utility.getGlobalContext()).size;
    try {
      initShareprerence();
      return mSharedPreferences?.getDouble('LocalMobileCounterPosY' + size.height.toString()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  int getLocalMoney() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('LocalMoney') ?? 1;
    } catch (e) {
      return 1;
    }
  }

  void setLocalMoney(int money) {
    initShareprerence();
    mSharedPreferences?.setInt('LocalMoney', money);
  }

  int getPresentValue() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('PresentValue') ?? 1;
    } catch (e) {
      return 1;
    }
  }

  void setPresentValue(int money) {
    initShareprerence();
    mSharedPreferences?.setInt('PresentValue', money);
  }

  int getGameTime({String? gameCode}) {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('GameTime') ?? 25 * 60 * 1000;
    } catch (e) {
      return 25 * 60 * 1000;
    }
    return 0;
  }

  int getTomatoTime() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('tomatoTime') ?? 25 * 60 * 1000;
    } catch (e) {
      return 25 * 60 * 1000;
    }
  }

  void setTomatoTime(int time) {
    initShareprerence();
    mSharedPreferences?.setInt('tomatoTime', time);
  }

  String getGameMode({required String gameCode, required String defaultGameMode}) {
    initShareprerence();
    return mSharedPreferences?.getString('gameModeWithGameCode:${gameCode}') ?? defaultGameMode;
  }

  void setGameMode({required String gameCode, required String gameMode}) {
    initShareprerence();
    mSharedPreferences?.setString('gameModeWithGameCode:${gameCode}', gameMode);
  }

  int getAudioVolume() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('audioVolume') ?? 100;
    } catch (e) {
      return 100;
    }
  }

  void setAudioVolume(int volume) {
    initShareprerence();
    mSharedPreferences?.setInt('audioVolume', volume);
  }

  int getTomatoRestTime() {
    try {
      initShareprerence();
      int curCounter = this.getTomatoLongDurationCurCounter();
      int interval = this.getTomatoLongDurationInterval();
      // 长计时休息触发
      if (curCounter > 0&& curCounter % interval == 0) {
        return this.getTomatoLongDurationRestTime();
      }
      return mSharedPreferences?.getInt('TomatoRestTime') ?? 5 * 60 * 1000;
    } catch (e) {
      return 5 * 60 * 1000;
    }
  }

  void setTomatoRestTime(int time) {
    initShareprerence();
    mSharedPreferences?.setInt('TomatoRestTime', time);
  }

  int getTomatoLongDurationRestTime() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('TomatoLongDurationRestTime') ?? 5 * 60 * 1000;
    } catch (e) {
      return 5 * 60 * 1000;
    }
  }

  void setTomatoLongDurationInterval(int times) {
    initShareprerence();
    mSharedPreferences?.setInt('TomatoLongDurationInterval', times);
  }


  int getTomatoLongDurationCurCounter() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('getTomatoLongDurationCurCounter') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  void incTomatoLongDurationCurCounter() {
    initShareprerence();
    int curTime = this.getTomatoLongDurationCurCounter() ?? 0;
    mSharedPreferences?.setInt('getTomatoLongDurationCurCounter', ++curTime);
  }

  int getTomatoLongDurationInterval() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('TomatoLongDurationInterval') ?? 1;
    } catch (e) {
      return 5 * 60 * 1000;
    }
  }

  void setTomatoLongDurationRestTime(int time) {
    initShareprerence();
    mSharedPreferences?.setInt('TomatoLongDurationRestTime', time);
  }

  /**
   * 用于设置颜色
   */
  void setCommonColor(int color) {
    initShareprerence();
    mSharedPreferences?.setInt('CommonColor', color);
  }

  int getCommonColor() {
    try {
      initShareprerence();
      return mSharedPreferences?.getInt('CommonColor') ?? 0xffff8800;
    } catch (e) {
      return 0xffff8800;
    }
  }

  /**
   * 更新点击跳转这个版本
   */
  void setJumpToVersion(String version) {
    initShareprerence();
    mSharedPreferences?.setBool('JumpToVersion' + version, true);
  }

  bool getJumpToVersion(String version) {
    try {
      initShareprerence();
      return mSharedPreferences?.getBool('JumpToVersion' + version) ?? false;
    } catch (e) {
      return false;
    }
  }

  /**
   * 保存音乐Model
   */
  void setFinishRestingMusicModel(MusicModel model) {
    try {
      initShareprerence();
      mSharedPreferences?.setString(
          'MusicModelStartFinishResting', jsonEncode(model));
    } catch (e) {}
  }

  MusicModel getFinishRestingMusicModel() {
    try {
      initShareprerence();
      String? musicModelString =
          mSharedPreferences?.getString('MusicModelStartFinishResting') ?? null;
      if (musicModelString != null) {
        Map<String, dynamic> responseJson = jsonDecode(musicModelString);
        MusicModel musicModel = MusicModel.fromJson(responseJson);
        return musicModel;
      }
    } catch (e) {}
    return MusicModel();
  }

  /**
   * 设置专注完成音乐
   */
  setFinishFocusingMusicModel(MusicModel model) {
    initShareprerence();
    mSharedPreferences?.setString(
        'MusicModelStartFinishFocusing', jsonEncode(model));
  }

  MusicModel getFinishFocusingMusicModel() {
    initShareprerence();
    try {
      String musicModelString =
          mSharedPreferences?.getString('MusicModelStartFinishFocusing') ?? "";
      if (musicModelString != null) {
        Map<String, dynamic> responseJson = jsonDecode(musicModelString);
        MusicModel musicModel = MusicModel.fromJson(responseJson);
        return musicModel;
      }
    } catch (e) {}
    return MusicModel();
  }

  setRestingBGMusicModel(MusicModel model) {
    initShareprerence();
    try {
      mSharedPreferences?.setString('RestingBGMusicModel', jsonEncode(model));
    } catch (e) {}
  }

  MusicModel getRestingBGMusicModel() {
    initShareprerence();
    try {
      String musicModelString =
          mSharedPreferences?.getString('RestingBGMusicModel') ?? "";
      if (musicModelString != null) {
        Map<String, dynamic> responseJson = jsonDecode(musicModelString);
        MusicModel musicModel = MusicModel.fromJson(responseJson);
        return musicModel;
      }
    } catch (e) {}
    return MusicModel();
  }

  void setMissionOrderEnum(MissionOrderEnum enumVal, {String mode = ''}) {
    initShareprerence();
    mSharedPreferences?.setInt('MissionOrderEnum${mode}', enumVal.index);
  }

  void setGameLevelModel(String game, int level) {
    initShareprerence();
    mSharedPreferences?.setInt('game:' + game + level.toString(), level);
  }


  MissionOrderEnum getMissionOrderEnum({String mode = ''}) {
    initShareprerence();
    int index = mSharedPreferences?.getInt('MissionOrderEnum${mode}') ?? 2;
    switch (index) {
      case 0:
        return MissionOrderEnum.orderByWords;
      case 1:
        return MissionOrderEnum.orderByTime;
      default:
        return MissionOrderEnum.orderByPriority;
    }
  }

  void setFocusingBGMusicModel(MusicModel model) {
    initShareprerence();
    mSharedPreferences?.setString('FocusingBGMusicModel', jsonEncode(model));
  }

  MusicModel? getFocusingBGMusicModel() {
    try {
      initShareprerence();
      String musicModelString =
          mSharedPreferences?.getString('FocusingBGMusicModel') ?? "";
      if (musicModelString != null) {
        Map<String, dynamic> responseJson = jsonDecode(musicModelString);
        MusicModel musicModel = MusicModel.fromJson(responseJson);
        return musicModel;
      }
    } catch (e) {}
    return null;
  }

  void setHttpCache({required String key,  BaseBean? baseBean, String mode = "GET"}) {
    if (baseBean != null && key != null) {
      listKeysHttps.add('HttpCache' + mode + key);
      this.setString(
          key: 'HttpCache' + mode + key, content: jsonEncode(baseBean.toJson()));
      LoginManager.getInstance().init();
    }
  }

  resetCacheList() {
    for (String key in listKeysHttps) {
      this.setString(key: key, content: '');
    }
  }

  void setHttpCacheDynamic({required String key, required Map map}) {
    if (map != null && key != null) {
      listKeysHttps.add('HttpCache' + key);
      this.setString(
          key: 'HttpCache' + key, content: jsonEncode(map));
      LoginManager.getInstance().init();
    }
  }

  Map getHttpCacheDynamic({required String key, Map? map}) {
    if (key != null) {
      listKeysHttps.add('HttpCache' + key);
      String s = this.getString(key: 'HttpCache' + key);
      if (s != null) {
        try {
          Map<String, dynamic> res = jsonDecode(s);
          return res;
        } catch (e) {
          print(e);
        }
      }
    }
    return {};
  }

  BaseBean getHttpCache({String? key, String mode = "GET"}) {
    if (key != null) {
      String s = this.getString(key: 'HttpCache' + mode + key);
      listKeysHttps.add('HttpCache' + mode + key);

      if (s != null) {
        try {
          Map<String, dynamic> res = jsonDecode(s);
          BaseBean bean = BaseBean.fromJson(res);
          return bean;
        } catch (e) {
          print(e);
        }
      }
    }
    return BaseBean(success: false);
  }

  String? getHttpGetFileCache({String? key, String mode = "GET"}) {
    if (key != null) {
      String s = this.getString(key: 'HttpCache' + mode + key);
      if (s != null) {
        try {
          return s;
          // Map<String, dynamic> res = jsonDecode(s);
          // BaseBean bean = BaseBean.fromJson(res);
          // return bean;
        } catch (e) {
          print(e);
        }
      }
    }
    return null;
  }
}
