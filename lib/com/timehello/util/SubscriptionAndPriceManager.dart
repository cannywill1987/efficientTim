import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/models/lib/ali_auth.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';

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
import 'CloudSharepreferenceManagement.dart';
import 'LoginManager.dart';
import 'Utility.dart';

/**
 *
 * 号码认证服务
 */
class SubscriptionAndPriceManager {
  static SubscriptionAndPriceManager? instance;

  // static final String vip = "com.moonrainbowsoft.time.flutterTimeHello.vip"; // vip
  // static final String priceMonthly = "com.moonrainbowsoft.time.flutterTimeHello.subscriptionMonthly"; // 按月订阅
  static final String priceAnnual =
      "com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual"; // 按年订阅
  static final String priceMonthly =
      "com.moonrainbowsoft.time.flutterTimeHello.subscriptionhMonthly"; // 按月订阅
  static final String priceAnnualMobile =
      "com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnualMobile"; // 按年订阅 移动端
  static final String priceMonthlyMobile =
      "com.moonrainbowsoft.time.flutterTimeHello.subscriptionhMonthlyMobile"; // 按月订阅 移动端

  bool isRequesting = false;
  List<PriceProductModel>? listPriceProductModel;
  bool subscriptionState = false;

  static SubscriptionAndPriceManager getInstance() {
    if (instance == null) {
      instance = SubscriptionAndPriceManager();
      instance?.init();
    }
    return instance!;
  }

  /**
   * subscribed	2	用户已订阅，状态正常
      inBillingRetryPeriod	3	用户订阅处于账单重试期
      inGracePeriod	4	用户订阅处于宽限期
      expired	1	用户订阅已过期
      revoked	0	用户订阅被撤销
      unknown	-1	未知订阅状态
   */
  init() async {
    listPriceProductModel = await CounterMethodChannelManager.getInstance()
        .IAPManagerFetchProducts(listProducts: DeviceInfoManagement.isMacOs() ? [priceAnnual, priceMonthly] : [priceAnnualMobile, priceMonthlyMobile]); // 获取产品
    // 0 未开始 1 请求中 2 请求成功 3 restore成功
    await initSubscriptionState();
    print("");
  }

  /**
   * 检查是否有订阅
   */
  Future<void> checkAndUpdateAutosubscriptionByReceipt(
      {required BuildContext context}) async {
    if (DeviceInfoManagement.isMacOs() == true || DeviceInfoManagement.isIOS() == true) {
      BaseBean baseBean =
          await CounterMethodChannelManager.getInstance().getReceipt();
      String ticket = baseBean.data["res"];
      print("baseBean: $baseBean");
      if (ticket == null || ticket.isEmpty) {
        return;
      }
      HttpManager.getInstance().doPostRequest(Apis.getReceipt,
          params: {"receiptString": ticket, "isSandbox": !Utility.isProductEnv()},
          context: context,
          callback: (BaseBean response, String scene, bool isFromCache) {
        print("receipt String response: $response");
        if (response.success == true) {
          Map map = Utility.getLatestExpireDateOfReceipt(
              response.data['latest_receipt_info'],
              DeviceInfoManagement.isMacOs() ? [SubscriptionAndPriceManager.priceMonthly, SubscriptionAndPriceManager.priceAnnual] : [SubscriptionAndPriceManager.priceMonthlyMobile, SubscriptionAndPriceManager.priceAnnualMobile]);
          String original_transaction_id = map['originalTransactionId'];
          int latestExpireDate = map['latestExpireDate'];
          String productId = map['productId'];
          print("latestExpireDate: $latestExpireDate");
          SubscriptionAndPriceManager.getInstance().addPurchasedProductToUserModel(
              context: context,
              receipt: ticket,
              identifier: productId,
              list: [],
              expireDateMillis: latestExpireDate,
              orignalTransactionId: original_transaction_id,
              callback: (BaseBean baseBean) {
                print("addPurchasedProductToUserModel: $baseBean");
              });
        }
        // Utility.getLatestExpireDateOfReceipt(response.data['receipt']['in_app']);
      });
    }
  }

  Future<void> initSubscriptionState() async {
    BaseBean baseBean = await CounterMethodChannelManager.getInstance()
        .checkSubscriptionState(DeviceInfoManagement.isMacOs() ? priceAnnual: priceAnnualMobile);
    if (baseBean.data == "2") {
      subscriptionState = true;
    }
    baseBean = await CounterMethodChannelManager.getInstance()
        .checkSubscriptionState(priceMonthly);
    if (subscriptionState == false && baseBean.data == "2") {
      subscriptionState = true;
    }

    // baseBean = await CounterMethodChannelManager.getInstance()
    //     .getSubscriptionDetails();
    print(baseBean.data);
  }

  // 获取产品
  PriceProductModel? getProduct({required String identifier}) {
    if (listPriceProductModel != null) {
      for (var item in listPriceProductModel!) {
        if (item.identifier == identifier) {
          return item;
        }
      }
    }
    return null;
  }

  restorePurchases() async {
    BaseBean bean =
        await CounterMethodChannelManager.getInstance().restorePurchases();
    if (bean.success == false) {
      //恢复失败
      Utility.showToastMsg(msg: getI18NKey().restore_failed);
    } else if (bean.data != null) {
      //恢复成功 返回productId
      SubscriptionAndPriceManager.getInstance().addPurchasedProductToUserModel(
          identifier: bean.data["productId"],
          list: [],
          context: Utility.getGlobalContext(),
          callback: (res) async {
            await initSubscriptionState();
          },
          expireDateMillis: bean.data["expireDate"],
          orignalTransactionId: bean.data["originalTransactionId"]);
    }
  }

  purchase(
      {required String identifier,
      required Function(BaseBean) callback}) async {
    try {
      //data: -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功 4 用户取消
      BaseBean bean = await CounterMethodChannelManager.getInstance()
          .IAPPurchase(id: identifier);
      if (bean.data["status"] == 2) {
        SubscriptionAndPriceManager.getInstance().addPurchasedProductToUserModel(
            identifier: identifier,
            list: [],
            context: Utility.getGlobalContext(),
            callback: (res) async {
              await initSubscriptionState();
              callback(res);
            },
            expireDateMillis: bean.data["expireDate"],
            orignalTransactionId: bean.data["originalTransactionId"]);
      } else {
        //失败
        callback(bean);
      }
    } catch (e) {
      print(e);
    }
  }

  bool isVIP() {
    //生产环境 先不走vip
    if (EnvEnum.uat == Params.env) {
      return false;
    } else {
      if (Utility.isIOS() == true || Utility.isMacOS() == true) {
        if (Utility
            .getGlobalContext()
            .read<Env>()
            .isVip == true) {
          return true;
        }
        // 资源位拉取的本地开关
        if (Utility.isVipSwitchOn() == true) {
          return Utility
              .getGlobalContext()
              .read<Env>()
              .isVip = true;
        }
        // 未登录状态下 也可以看成vip
        if (LoginManager.getInstance().isLogin2() == false) {
          return Utility
              .getGlobalContext()
              .read<Env>()
              .isVip = true;
        }
        return Utility
            .getGlobalContext()
            .read<Env>()
            .isVip =
            containUserBeanIdentifierAlreadyBuyAndNotExpired(
                identifier: priceAnnual) ||
                containUserBeanIdentifierAlreadyBuyAndNotExpired(
                    identifier: priceMonthly) || containUserBeanIdentifierAlreadyBuyAndNotExpired(
                identifier: priceAnnualMobile) ||
                containUserBeanIdentifierAlreadyBuyAndNotExpired(
                    identifier: priceMonthlyMobile) ;
      } else {
        return false;
      }
      }

  }

  //判断 (LoginManager.getInstance().getUserBean().vipProductList ?? [])) 的 时间是否超过当前提供的expireTime的时间
  bool isVIPExpiredTimeNeedUpdate(
      {required identifier, required int expireTimestamp}) {
    for (var item
        in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
      if (item['serviceName'] == identifier &&
          item["expiredTimestamp"] >= expireTimestamp) {
        //expireTimestamp 为新的超时时间
        return false;
      }
    }
    return true;
  }

  // 是否已经购买并且没有过期
  containUserBeanIdentifierAlreadyBuyAndNotExpired({required identifier}) {
    for (var item
        in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
      if (item['serviceName'] == identifier &&
          item["expiredTimestamp"] > DateTime.now().millisecondsSinceEpoch) {
        return true;
      }
    }
    return false;
  }

  // 是否已经购买
  bool containUserBeanIdentifierAlreadyBuy({required identifier}) {
    for (var item
        in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
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
    for (var item
        in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
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

  getExpiredTimestampByIdentifier({required String identifier}) {
    if (identifier == priceAnnual || identifier == priceAnnualMobile) {
      return 365 * 24 * 60 * 60 * 1000;
    } else if (identifier == priceMonthly || identifier == priceMonthlyMobile) {
      return 30 * 24 * 60 * 60 * 1000;
    } else {
      return 0;
    }
  }

  // 添加到 [{"serviceName":name, list: [moduleName1, moduleName2], timestamp: timestamp, expiredTimestamp}] 并且 timestamp开始购买时间，expiredTimestamp过期时间
  addPurchasedProductToUserModel(
      {required BuildContext context,
      required String identifier,
      required List<String> list,
      required int? expireDateMillis,
      required String orignalTransactionId,
      String? receipt,
      required Function(BaseBean) callback}) async {
    //注意判断有可能一年也有365或366天 判断
    if (containUserBeanIdentifierAlreadyBuyAndNotExpired(
        identifier: identifier)) {
      Utility.showToastMsg(msg: getI18NKey().already_purchased);
      return;
    }
    // BaseBean bean = await CounterMethodChannelManager.getInstance()
    //     .getSubscriptionDetails();
    num expireTimestamp = expireDateMillis != null
        ? expireDateMillis
        : (DateTime.now().millisecondsSinceEpoch +
            (Utility.isProductEnv()
                ? getExpiredTimestampByIdentifier(identifier: identifier)
                : 3 * 60 * 1000));
    if (isVIPExpiredTimeNeedUpdate(
            identifier: identifier, expireTimestamp: expireTimestamp.toInt()) ==
        true) {
      Map params = {
        'serviceName': identifier,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'originalTransactionId': orignalTransactionId,
        'expiredTimestamp': expireTimestamp,
        'receipt': receipt ?? "",
        'list': list
      };
      // if (bean.success == true && bean.data != null) {
      CloudSharepreferenceManagement.getInstance()
          .setString(orignalTransactionId, identifier);
      // }
      print("params: $params");
      try {
        // if (bean.success == true && bean.data != null) {
        isRequesting = true;
        HttpManager.getInstance().doPostRequest(Apis.updateVipProductList,
            params: {'data': updateUserList(params)}, context: context,
            callback: (BaseBean response, String scene, bool isFromCache) {
          isRequesting = false;
          if (response.success == true) {
            Utility.getGlobalContext().read<Env>().isVip = true;
            Utility.popupPagePCAndMobile(Utility.getGlobalContext());
            LoginManager.getInstance()
                .setUserBean(UserBean.fromJson(response.data));
            callback(response);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
