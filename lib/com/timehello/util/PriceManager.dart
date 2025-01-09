import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/models/lib/ali_auth.dart';

import '../../../r.dart';
import '../beans/BaseBean.dart';
import '../beans/PriceProductModel.dart';
import '../beans/UserBean.dart';
import '../common/database/apis/MongoApisManager.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/ENUMS.dart';
import '../config/Params.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../page/loginPage/LoginPage.dart';
import 'LoginManager.dart';
import 'Utility.dart';

/**
 * https://dypns.console.aliyun.com/solution/All
 * 号码认证服务
 */
class PriceManager {
  static PriceManager? instance;
  // static final String vip = "com.moonrainbowsoft.time.flutterTimeHello.vip"; // vip
  // static final String priceMonthly = "com.moonrainbowsoft.time.flutterTimeHello.subscriptionMonthly"; // 按月订阅
  static final String priceAnnual = "com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"; // 按年订阅
  static final String priceMonthly = "com.moonrainbowsoft.time.flutterTimeHello.subscriptionhMonthly"; // 按月订阅

  bool isRequesting = false;
  List<PriceProductModel>? listPriceProductModel;
  static PriceManager getInstance() {
    if (instance == null) {
      instance = PriceManager();
      instance?.init();
    }
    return instance!;
  }

  init() async {
    listPriceProductModel = await CounterMethodChannelManager.getInstance().IAPManagerFetchProducts(listProducts: [priceAnnual, priceMonthly]);
    print("");
  }
  // 获取产品
  PriceProductModel? getProduct({required String identifier}) {
    if(listPriceProductModel != null) {
      for (var item in listPriceProductModel!) {
        if (item.identifier == identifier) {
          return item;
        }
      }
    }
    return null;
  }

  purchase({required String identifier, required Function(BaseBean) callback}) async {
    try {
      //data: -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功
      // BaseBean bean = await CounterMethodChannelManager.getInstance()
      //     .IAPPurchase(id: identifier);

      PriceManager.getInstance().addPurchasedProductToUserModel(
          identifier: identifier,
          list: [],
          context: Utility.getGlobalContext(),
          callback: callback);
    } catch (e) {
      print(e);
    }
  }

  bool isVIP() {
    //生产环境 先不走vip
    if(EnvEnum.prd == Params.env) {
      return true;
    } else {
      return containUserBeanIdentifierAlreadyBuyAndNotExpired(
          identifier: priceAnnual);
    }
  }

  // 是否已经购买并且没有过期
  containUserBeanIdentifierAlreadyBuyAndNotExpired({required identifier}) {
    for ( var item in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
      if (item['serviceName'] == identifier && item["expiredTimestamp"] > DateTime.now().millisecondsSinceEpoch) {
        return true;
      }
    }
    return false;
  }

  // 是否已经购买
  bool containUserBeanIdentifierAlreadyBuy({required identifier}) {
    for ( var item in (LoginManager.getInstance().getUserBean().vipProductList ??[])) {
      if (item.identifier == identifier) {
        return true;
      }
    }
    return false;
  }

  /**
   * 移除原来的 添加新的
   */
  List updateUserList(Map data) {
    List list = [];
    bool hasAddData = false;
    for ( var item in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
      if (item['serviceName'] == data['serviceName']) {
        hasAddData = true;
        list.add(data);
      } else {
        list.add(item);
      }
    }
    if (!hasAddData) {
      list.add(data);
    }
    return list;
  }

  // 添加到 [{"serviceName":name, list: [moduleName1, moduleName2], timestamp: timestamp, expiredTimestamp}] 并且 timestamp开始购买时间，expiredTimestamp过期时间
  addPurchasedProductToUserModel({required BuildContext context, required String identifier, required List<String> list, required Function(BaseBean) callback}) async {
    //注意判断有可能一年也有365或366天 判断
    if (containUserBeanIdentifierAlreadyBuyAndNotExpired(identifier: identifier)) {
      Utility.showToastMsg(msg: getI18NKey().already_purchased);
      return;
    }
    Map params = {
      'serviceName': identifier,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiredTimestamp': DateTime.now().millisecondsSinceEpoch + (Utility.isProductEnv() ? 365 * 24 * 60 * 60 * 1000 : 3 * 60 * 1000),
      'list': list
    };
    try {
      isRequesting = true;
      HttpManager.getInstance()
          .doPostRequest(Apis.updateVipProductList, params: {'data': updateUserList(params)},
          context: context,
          callback: (BaseBean response, String scene, bool isFromCache) {
            isRequesting = false;
            if (response.success == true) {
              // eventBus.fire(EventFn(Params.ACTION_UPDATE_USERINFO_AVATAR, {}));
              Utility.showToastMsg(msg: getI18NKey().update_success);
              LoginManager.getInstance()
                  .setUserBean(UserBean.fromJson(response.data));
              // DialogManagement.getInstance().hideDialog(context);
              // if (this.onAvatarUpdatedComplete != null) {
              //   this.onAvatarUpdatedComplete();
              // }
            }
          });
    } catch (e) {
      print(e);
    }
  }

}
