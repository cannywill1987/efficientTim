// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';

import '../beans/BaseBean.dart';
import '../beans/PriceProductModel.dart';
import '../beans/UserBean.dart';
import '../common/database/apis/MongoApisManager.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/ENUMS.dart';
import '../config/Params.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import 'CloudSharepreferenceManagement.dart';
import 'LoginManager.dart';
import 'Utility.dart';

/**
 * 文件类型：服务管理器
 * 文件作用：统一管理 Apple 内购商品、恢复购买、订阅状态、永久 VIP 和 VIP Code 状态。
 * 主要职责：拉取 StoreKit 商品，购买/恢复后同步用户 VIP 商品列表，并向业务侧提供 isVIP 判断。
 */
class SubscriptionAndPriceManager {
  static const String _iapLogTag = 'SUBSCRIPTION_MANAGER';
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
  static final String mangaHelloVip = "com.moonrainbowsoft.time.flutterTimeHello.vip.lifetimeIOS";
  // Timerbell 一次性买断的新 Product ID，非消耗型；保留旧 ID 兼容历史/老版本购入记录。
  static final String mangaHelloVipLifetime =
      "com.moonrainbowsoft.time.flutterTimeHello.vip.lifetime";

  bool isRequesting = false;
  List<PriceProductModel>? listPriceProductModel;
  bool subscriptionState = false;
  bool isVipByVipCode = false;
  static SubscriptionAndPriceManager getInstance() {
    if (instance == null) {
      instance = SubscriptionAndPriceManager();
      instance?.init();
    }
    return instance!;
  }

  /// 功能：根据当前平台返回需要向 StoreKit 拉取的商品 ID。
  /// 说明：会员弹窗支持年订阅、月订阅和一次性解锁，必须一次性拉全，UI 才能展示多个可选项。
  List<String> _getStoreKitProductIds() {
    if (DeviceInfoManagement.isMacOs()) {
      return _dedupeIds([
        ..._getProductIdCandidatesForAnnual(),
        ..._getProductIdCandidatesForMonthly(),
        ..._getOneTimeProductIdCandidates(),
      ]);
    }
    return _dedupeIds([
      ..._getProductIdCandidatesForAnnualMobile(),
      ..._getProductIdCandidatesForMonthlyMobile(),
      ..._getOneTimeProductIdCandidates(),
    ]);
  }

  List<String> _getProductIdCandidatesForAnnual() {
    // 当前保留旧 ID 作为主候选；后续需要迁移时可在此追加新 ID。
    return [priceAnnual];
  }

  List<String> _getProductIdCandidatesForMonthly() {
    return [priceMonthly];
  }

  List<String> _getProductIdCandidatesForAnnualMobile() {
    return [priceAnnualMobile];
  }

  List<String> _getProductIdCandidatesForMonthlyMobile() {
    return [priceMonthlyMobile];
  }

  List<String> _getOneTimeProductIdCandidates() {
    return [mangaHelloVipLifetime, mangaHelloVip];
  }

  List<String> _dedupeIds(Iterable<String> ids) {
    return ids.toSet().toList();
  }

  /// 功能：统一输出订阅管理层关键日志。
  /// 说明：用于串联 UI、订阅管理器、MethodChannel 和后端同步结果，定位 Unknown Error 出现在哪一层。
  void _logIap(String message,
      {String event = 'subscription-log',
      Object? error,
      StackTrace? stackTrace}) {
    final String now = _logTimestamp();
    debugPrint('[$now][$_iapLogTag][$event] $message');
    if (error != null) {
      debugPrint('[$now][$_iapLogTag][$event] error=$error');
    }
    if (stackTrace != null) {
      debugPrint('[$now][$_iapLogTag][$event] stackTrace=$stackTrace');
    }
  }

  /// 功能：生成统一日志时间前缀，格式固定为 MMDD HH:mm:ss，方便按时间段搜索。
  String _logTimestamp() {
    final DateTime now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(now.month)}${two(now.day)} ${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
  }

  /// 功能：输出 BaseBean 核心字段，避免日志里出现完整 receipt。
  void _logBaseBean(String scene, BaseBean bean,
      {String event = 'subscription-result'}) {
    _logIap(
      '$scene success=${bean.success}, code=${bean.code}, '
      'message=${bean.message}, data=${_safeData(bean.data)}',
      event: event,
    );
  }

  /// 功能：对订阅链路中的敏感字段做脱敏。
  String _safeData(dynamic data) {
    if (data is Map) {
      final Map safe = Map.from(data);
      for (final key in ['res', 'receipt', 'receiptString']) {
        if (safe[key] is String) {
          safe[key] = '<redacted length=${(safe[key] as String).length}>';
        }
      }
      return safe.toString();
    }
    if (data is String && data.length > 120) {
      return '<redacted string length=${data.length}>';
    }
    return data.toString();
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
    _logIap(
        'init start isIOS=${DeviceInfoManagement.isIOS()}, isMac=${DeviceInfoManagement.isMacOs()}, env=${Params.env}',
        event: 'product-init-start');
    if (isIOSAndMacOS() == false) {
      _logIap('init skipped: current platform does not support StoreKit',
          event: 'product-init-skip');
      return;
    }
    listPriceProductModel = await CounterMethodChannelManager.getInstance()
        .IAPManagerFetchProducts(listProducts: _getStoreKitProductIds());
    _logIap(
        'init fetchedProducts count=${listPriceProductModel?.length ?? 0}, identifiers=${listPriceProductModel?.map((e) => e.identifier).toList()}',
        event: 'product-init-result');
    // 0 未开始 1 请求中 2 请求成功 3 restore成功
    await initSubscriptionState();
    _logIap('init done subscriptionState=$subscriptionState',
        event: 'product-init-done');
  }

  /// 功能：强制重新拉取 StoreKit 商品列表。
  /// 说明：会员弹窗可能在单例旧状态下打开，商品为空时主动刷新一次，避免 UI 只能显示 Unknown Error。
  Future<List<PriceProductModel>> refreshProducts(
      {String source = 'unknown'}) async {
    _logIap('refreshProducts start source=$source',
        event: 'product-refresh-start');
    if (isIOSAndMacOS() == false) {
      _logIap('refreshProducts skipped: unsupported platform source=$source',
          event: 'product-refresh-skip');
      return [];
    }
    listPriceProductModel = await CounterMethodChannelManager.getInstance()
        .IAPManagerFetchProducts(listProducts: _getStoreKitProductIds());
    _logIap(
        'refreshProducts done source=$source, count=${listPriceProductModel?.length ?? 0}, identifiers=${listPriceProductModel?.map((e) => e.identifier).toList()}',
        event: 'product-refresh-result');
    return listPriceProductModel ?? [];
  }

  bool isIOSAndMacOS() {
    return DeviceInfoManagement.isIOS() == true ||
        DeviceInfoManagement.isMacOs() == true;
  }

  /**
   * 检查是否有订阅
   */
  Future<void> checkAndUpdateAutosubscriptionByReceipt(
      {required BuildContext context}) async {
    if (DeviceInfoManagement.isMacOs() == true ||
        DeviceInfoManagement.isIOS() == true) {
      BaseBean baseBean =
          await CounterMethodChannelManager.getInstance().getReceipt();
      _logBaseBean(
          'checkAndUpdateAutosubscriptionByReceipt.getReceipt', baseBean,
          event: 'receipt-check-result');
      String ticket = baseBean.data["res"];
      _logIap(
          'checkAndUpdateAutosubscriptionByReceipt receiptLength=${ticket.length}',
          event: 'receipt-check-length');
      if (ticket.isEmpty) {
        _logIap('checkAndUpdateAutosubscriptionByReceipt skipped empty receipt',
            event: 'receipt-check-skip');
        return;
      }
      HttpManager.getInstance().doPostRequest(Apis.getReceipt,
          params: {
            "receiptString": ticket,
            "isSandbox": !Utility.isProductEnv()
          },
          context: context,
          callback: (BaseBean response, String scene, bool isFromCache) {
        _logBaseBean(
            'checkAndUpdateAutosubscriptionByReceipt.verifyReceipt scene=$scene isFromCache=$isFromCache',
            response,
            event: 'receipt-verify-result');
        if (response.success == true) {
          Map map = Utility.getLatestExpireDateOfReceipt(
              response.data['latest_receipt_info'],
              DeviceInfoManagement.isMacOs()
                  ? _dedupeIds([
                      ..._getProductIdCandidatesForMonthly(),
                      ..._getProductIdCandidatesForAnnual(),
                      ..._getOneTimeProductIdCandidates(),
                    ])
                  : _dedupeIds([
                      ..._getProductIdCandidatesForMonthlyMobile(),
                      ..._getProductIdCandidatesForAnnualMobile(),
                      ..._getOneTimeProductIdCandidates(),
                    ]));
          String original_transaction_id = map['originalTransactionId'];
          int latestExpireDate = map['latestExpireDate'];
          String productId = map['productId'];
          _logIap(
              'checkAndUpdateAutosubscriptionByReceipt latest productId=$productId, latestExpireDate=$latestExpireDate, originalTransactionId=$original_transaction_id',
              event: 'receipt-verify-latest');
          SubscriptionAndPriceManager.getInstance()
              .addPurchasedProductToUserModel(
                  context: context,
                  receipt: ticket,
                  identifier: productId,
                  list: [],
                  expireDateMillis: latestExpireDate,
                  orignalTransactionId: original_transaction_id,
                  callback: (BaseBean baseBean) {
                    _logBaseBean(
                        'checkAndUpdateAutosubscriptionByReceipt.addPurchasedProductToUserModel',
                        baseBean,
                        event: 'receipt-sync-result');
                  });
        }
        // Utility.getLatestExpireDateOfReceipt(response.data['receipt']['in_app']);
      });
    }
  }

  Future<void> initSubscriptionState() async {
    _logIap('initSubscriptionState start', event: 'subscription-state-start');
    if (isIOSAndMacOS() == false) {
      _logIap('initSubscriptionState skipped: unsupported platform',
          event: 'subscription-state-skip');
      return;
    }
    final List<String> subscriptionProductIds =
        _dedupeIds(DeviceInfoManagement.isMacOs()
            ? [
                ..._getProductIdCandidatesForAnnual(),
                ..._getProductIdCandidatesForMonthly(),
              ]
            : [
                ..._getProductIdCandidatesForAnnualMobile(),
                ..._getProductIdCandidatesForMonthlyMobile(),
              ]);
    for (final productId in subscriptionProductIds) {
      BaseBean baseBean = await CounterMethodChannelManager.getInstance()
          .checkSubscriptionState(productId);
      _logBaseBean('initSubscriptionState check productId=$productId', baseBean,
          event: 'subscription-state-check');
      if (baseBean.data == "2") {
        subscriptionState = true;
        break;
      }
    }

    // baseBean = await CounterMethodChannelManager.getInstance()
    //     .getSubscriptionDetails();
    _logIap('initSubscriptionState done subscriptionState=$subscriptionState',
        event: 'subscription-state-done');
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

  PriceProductModel? getProductByCandidateIds({
    required List<String> candidateIds,
  }) {
    for (final String id in _dedupeIds(candidateIds)) {
      final PriceProductModel? product = getProduct(identifier: id);
      if (product != null) {
        return product;
      }
    }
    return null;
  }

  restorePurchases() async {
    _logIap('restorePurchases start', event: 'restore-start');
    BaseBean bean =
        await CounterMethodChannelManager.getInstance().restorePurchases();
    _logBaseBean('restorePurchases channelResult', bean,
        event: 'restore-result');
    if (bean.success == false) {
      //恢复失败
      _logIap('restorePurchases failed before user sync',
          event: 'restore-failed');
      Utility.showToastMsg(msg: getI18NKey().restore_failed);
    } else if (bean.data != null) {
      //恢复成功 返回productId
      _logIap(
          'restorePurchases success productId=${bean.data["productId"]}, expireDate=${bean.data["expireDate"]}, originalTransactionId=${bean.data["originalTransactionId"]}',
          event: 'restore-success');
      SubscriptionAndPriceManager.getInstance().addPurchasedProductToUserModel(
          identifier: bean.data["productId"],
          list: [],
          context: Utility.getGlobalContext(),
          callback: (res) async {
            _logBaseBean('restorePurchases addPurchasedProductToUserModel', res,
                event: 'restore-sync-result');
            await initSubscriptionState();
          },
          expireDateMillis: bean.data["expireDate"],
          orignalTransactionId: bean.data["originalTransactionId"]);
    } else {
      _logIap('restorePurchases returned success but data is null',
          event: 'restore-empty-data');
    }
  }

  purchase(
      {required String identifier,
      required Function(BaseBean) callback}) async {
    try {
      _logIap('purchase start identifier=$identifier', event: 'purchase-start');
      //data: -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功 4 用户取消
      BaseBean bean = await CounterMethodChannelManager.getInstance()
          .IAPPurchase(id: identifier);
      _logBaseBean('purchase channelResult identifier=$identifier', bean,
          event: 'purchase-result');
      final dynamic data = bean.data;
      final dynamic status = data is Map ? data["status"] : null;
      _logIap(
          'purchase status=$status identifier=$identifier, rawData=${_safeData(data)}',
          event: 'purchase-status');
      if (data is Map && data["status"] == 2) {
        SubscriptionAndPriceManager.getInstance()
            .addPurchasedProductToUserModel(
                identifier: identifier,
                list: [],
                context: Utility.getGlobalContext(),
                callback: (res) async {
                  _logBaseBean('purchase addPurchasedProductToUserModel', res,
                      event: 'purchase-sync-result');
                  await initSubscriptionState();
                  callback(res);
                },
                expireDateMillis: data["expireDate"],
                orignalTransactionId: data["originalTransactionId"]);
      } else {
        //失败
        _logIap(
            'purchase did not reach success status identifier=$identifier, status=$status',
            event: 'purchase-failed-status');
        callback(bean);
      }
    } catch (e, stackTrace) {
      _logIap('purchase exception identifier=$identifier',
          event: 'purchase-error', error: e, stackTrace: stackTrace);
      callback(BaseBean(success: false, message: e.toString()));
    }
  }

  // 检查用户是否通过VIP Code绑定
  // bool isVipByVipCode() {
  //   String? vipCode = LoginManager.getInstance().getUserBean().vipCode;
  //   return !TextUtil.isEmpty(vipCode);
  // }

  // 检查VIP Code并更新VIP状态
  Future<void> checkVipCodeAndUpdateStatus(
      {required BuildContext context,
      required String vipCode,
      Function(bool isVip)? callback}) async {
    final String trimmedVipCode = vipCode.trim();
    if (trimmedVipCode.isEmpty) {
      // VIP Code 是可选能力，空值不应该请求后端，否则启动阶段会稳定产生 VIP_CODE_PARAM_MISSING。
      isVipByVipCode = false;
      callback?.call(false);
      return;
    }
    HttpManager.getInstance().doGetRequest(
      Apis.vipCodeInfo,
      params: {"vipCode": trimmedVipCode},
      context: context,
      shouldShowErrorToast: false,
      callback: (BaseBean response, String scene, bool isFromCache) {
        bool isVip = false;
        final dynamic responseData = response.data;
        if (response.success == true && responseData is Map) {
          // 检查当前用户是否在绑定列表中
          String? phone =
              LoginManager.getInstance().getUserBean().mobilePhoneNumber;
          String? deviceId = MongoApisManager.getInstance().device_id;

          List? bindings = responseData['bindings'];
          if (bindings != null && bindings.length > 0) {
            for (var binding in bindings) {
              if (binding is Map &&
                  binding['phone'] == phone &&
                  binding['deviceId'] == deviceId) {
                // 用户已绑定此VIP Code，设置为VIP
                isVipByVipCode = true;
                isVip = true;
                Utility.getGlobalContext().read<Env>().isVip = true;
                break;
              }
            }
          }
          callback?.call(isVip);
        } else if (response.success == false &&
            response.code == CONSTANTS.CODE_ALREADY_BIND_VIPCODE) {
          isVipByVipCode = true;
          isVip = true;
          Utility.getGlobalContext().read<Env>().isVip = true;
          callback?.call(true);
        } else {
          isVipByVipCode = false;
          callback?.call(false);
        }
      },
    );
  }

  bool isVIP() {
    //生产环境 先不走vip
    if (EnvEnum.uat == Params.env) {
      return false;
    } else {
      if (Utility.isIOS() == true || Utility.isMacOS() == true) {
        if (Utility.getGlobalContext().read<Env>().isVip == true) {
          return true;
        }
        // 资源位拉取的本地开关
        if (Utility.isVipSwitchOn() == true) {
          return Utility.getGlobalContext().read<Env>().isVip = true;
        }
        // 未登录状态下 也可以看成vip
        if (LoginManager.getInstance().isLogin2() == false) {
          return Utility.getGlobalContext().read<Env>().isVip = false;
        }

        // 检查是否通过VIP Code绑定
        if (isVipByVipCode) {
          // 如果用户有VIP Code，返回Env中的isVip状态（会在登录后通过接口更新）
          return Utility.getGlobalContext().read<Env>().isVip;
        }

        return Utility.getGlobalContext().read<Env>().isVip =
            containUserBeanIdentifierAlreadyBuyForever(
                    identifier: mangaHelloVipLifetime) ||
                containUserBeanIdentifierAlreadyBuyForever(
                    identifier: mangaHelloVip) ||
                _containsVipProductWithIdentifier(
                    productIds: [
                      ..._getProductIdCandidatesForAnnual(),
                      ..._getProductIdCandidatesForMonthly(),
                      ..._getProductIdCandidatesForAnnualMobile(),
                      ..._getProductIdCandidatesForMonthlyMobile(),
                    ],
                    predicate: (identifier) {
                      return containUserBeanIdentifierAlreadyBuyAndNotExpired(
                          identifier: identifier);
                    });
      } else {
        return true;
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

  // 一次性永久购买
  containUserBeanIdentifierAlreadyBuyForever({required identifier}) {
    for (var item
        in (LoginManager.getInstance().getUserBean().vipProductList ?? [])) {
      if (item['serviceName'] == identifier && item["expiredTimestamp"] == 0) {
        return true;
      }
    }
    return false;
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
    if (identifier == priceAnnual ||
        identifier == priceAnnualMobile ||
        _getProductIdCandidatesForAnnual().contains(identifier) ||
        _getProductIdCandidatesForAnnualMobile().contains(identifier)) {
      return 365 * 24 * 60 * 60 * 1000;
    } else if (identifier == priceMonthly ||
        identifier == priceMonthlyMobile ||
        _getProductIdCandidatesForMonthly().contains(identifier) ||
        _getProductIdCandidatesForMonthlyMobile().contains(identifier)) {
      return 30 * 24 * 60 * 60 * 1000;
    } else {
      return 0;
    }
  }

  bool _containsVipProductWithIdentifier(
      {required List<String> productIds,
      required bool Function(String identifier) predicate}) {
    for (final identifier in productIds) {
      if (predicate(identifier)) {
        return true;
      }
    }
    return false;
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
    _logIap(
        'addPurchasedProductToUserModel start identifier=$identifier, expireDateMillis=$expireDateMillis, originalTransactionId=$orignalTransactionId, receiptLength=${receipt?.length ?? 0}',
        event: 'purchase-sync-start');
    //注意判断有可能一年也有365或366天 判断
    if (containUserBeanIdentifierAlreadyBuyAndNotExpired(
        identifier: identifier)) {
      _logIap(
          'addPurchasedProductToUserModel skipped: already purchased and not expired identifier=$identifier',
          event: 'purchase-sync-skip-already');
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
      _logIap('addPurchasedProductToUserModel params=${_safeData(params)}',
          event: 'purchase-sync-params');
      try {
        // if (bean.success == true && bean.data != null) {
        isRequesting = true;
        _logIap(
            'addPurchasedProductToUserModel post ${Apis.updateVipProductList} start',
            event: 'purchase-sync-post-start');
        HttpManager.getInstance().doPostRequest(Apis.updateVipProductList,
            params: {'data': updateUserList(params)}, context: context,
            callback: (BaseBean response, String scene, bool isFromCache) {
          isRequesting = false;
          _logBaseBean(
              'addPurchasedProductToUserModel response scene=$scene isFromCache=$isFromCache',
              response,
              event: 'purchase-sync-post-result');
          if (response.success == true) {
            Utility.getGlobalContext().read<Env>().isVip = true;
            Utility.popupPagePCAndMobile(Utility.getGlobalContext());
            LoginManager.getInstance()
                .setUserBean(UserBean.fromJson(response.data));
            callback(response);
          } else {
            _logIap(
                'addPurchasedProductToUserModel backend rejected identifier=$identifier',
                event: 'purchase-sync-post-rejected');
          }
        });
      } catch (e, stackTrace) {
        isRequesting = false;
        _logIap(
            'addPurchasedProductToUserModel exception identifier=$identifier',
            event: 'purchase-sync-error',
            error: e,
            stackTrace: stackTrace);
      }
    } else {
      _logIap(
          'addPurchasedProductToUserModel skipped: local expireTimestamp is not newer identifier=$identifier, expireTimestamp=$expireTimestamp',
          event: 'purchase-sync-skip-expire');
    }
  }
}
