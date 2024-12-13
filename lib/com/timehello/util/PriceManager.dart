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
import '../common/database/apis/MongoApisManager.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/Params.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../page/loginPage/LoginPage.dart';
import 'Utility.dart';

/**
 * https://dypns.console.aliyun.com/solution/All
 * 号码认证服务
 */
class PriceManager {
  static PriceManager? instance;
  static final String priceAnnual = "com.moonrainbowsoft.time.flutterTimeHello.subscriptionAnnual";
  List<PriceProductModel>? listPriceProductModel;
  static PriceManager getInstance() {
    if (instance == null) {
      instance = PriceManager();
      instance?.init();
    }
    return instance!;
  }

  init() async {
    listPriceProductModel = await CounterMethodChannelManager.getInstance().IAPManagerFetchReceipt(listProducts: [priceAnnual]);
    print("");
  }
  // 获取产品
  PriceProductModel? getProduct({required String identifier}) {
    for ( var item in listPriceProductModel!) {
      if (item.identifier == identifier) {
        return item;
      }
    }
    return null;
  }

}
