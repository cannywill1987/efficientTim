
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/UserInfoModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * app设置管理
 */
class UserInfoManager {
  static UserInfoManager? _instance;
  UserInfoModel? userInfoModel = null;
  SharedPreferences? mSharedPreferences;
  int? coins = null; // 当前金币

  static UserInfoManager getSyncInstance() {
    if (_instance == null) {
      _instance = new UserInfoManager();
      // _instance?.init();
      // _instance?.initShareprerence();
    }
    return _instance!;
  }

  init() {
    //登录才初始化数据
    if(LoginManager.getInstance().isLogin2()) {
      getUserInfoModel();
    }
  }

  getUserInfoModel() async {
    this.userInfoModel = await MongoApisManager.getInstance().queryWhereEqual_UserInfoModel();
    Utility.getGlobalContext().read<Env>().userInfoModel =
        UserInfoManager.getSyncInstance().userInfoModel;
  }

  updateUserInfoModelWithCoins({required int coins}) async {
    UserInfoModel userInfoModel = this.userInfoModel ?? UserInfoModel();
    userInfoModel?.coins = coins;
    await MongoApisManager.getInstance().insertAndUpdateUserInfoModel(userInfoModel: userInfoModel);
    Utility.getGlobalContext()?.read<Env>().userInfoModel = userInfoModel;
  }


}