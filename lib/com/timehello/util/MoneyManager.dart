import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import '../beans/BaseBean.dart';
import '../beans/UserBean.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import 'LoginManager.dart';
import 'Utility.dart';

/**
 * 用于金额管理
 */
class MoneyManager {
  static MoneyManager? mMoneyManager;
  int localMoneyMake = 0;

  static MoneyManager getInstance() {
    if (mMoneyManager == null) {
      mMoneyManager = new MoneyManager();
    }
    return mMoneyManager!;
  }

  int getLocalMoney() {
    return LoginManager?.getInstance()?.userBean?.localMoney ?? 0;
  }

  updateIncLocalMonneyWithoutRequest({required int localMoneyParam}) {
    localMoneyMake += localMoneyParam;
    LoginManager?.getInstance()?.userBean?.localMoney = (LoginManager?.getInstance()?.userBean?.localMoney ?? 0) + localMoneyParam.abs();
  }

  resetLocalMoney() {
    localMoneyMake = 0;
  }

  Future<MoneyManager?> requestUpdateLocalMoney(
      {required BuildContext context, required int localMoney,bool shouldShowToast = true}) async {
    //消费
    if (shouldShowToast == true && localMoney.abs() > MoneyManager.getInstance().getLocalMoney()) {
      Utility.showToastMsg(context: context, msg: getI18NKey().money_not_enough_toast);
      return mMoneyManager;
    }
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.updateLocalMoney,
        params: {"localMoney": localMoney},
        context: context,
        shouldShowErrorToast: false);
    if (response.success == true) {
      LoginManager.getInstance().setUserBean(UserBean.fromJson(response.data));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_MONEY, {}));
      //用于消费提示
      if(localMoney < 0) {
        Utility.showToastMsg(msg: getI18NKey().consume_success);
      }
    } else {
      //用于消费提示
      if(localMoney < 0) {
        Utility.showToastMsg(msg: getI18NKey().consume_failure);
      }
    }
    return mMoneyManager;
  }

  init() {}
}
