import 'package:flutter/cupertino.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../beans/BaseBean.dart';
import '../beans/ResourceLocationInfoBean.dart';
import '../config/Params.dart';
import 'LoginUtil.dart';
import 'SharePreferenceUtil.dart';

typedef onResourceComplete = void Function(List<ResourceLocationInfoBean> response, bool isFromCache);
typedef onResourceFailNoCache = void Function();
typedef onResourceFail = void Function();

abstract class OnResourceDeliveryComplete {
  void onComplete(List<ResourceLocationInfoBean> response, bool isFromCache);

  void onFailNoCache();

  void onFail();
}

class GetResourceDeliveryManager {
  OnResourceDeliveryComplete? mOnResourceDeliveryComplete;
  Container? container;
  String? mScene;
  String? mSceneCache;
  Lock lock = Lock();
  BaseBean? getResourceDeliveryResponseCache;
  static GetResourceDeliveryManager? mGetResourceDeliveryManager;

  static GetResourceDeliveryManager? getInstance() {
    if (mGetResourceDeliveryManager == null) {
      mGetResourceDeliveryManager = new GetResourceDeliveryManager();
    }
    // mGetResourceDeliveryManager.init();
    return mGetResourceDeliveryManager;
  }

  Future<GetResourceDeliveryManager?> requestGetResourceDelivery(String scene,
      {BuildContext? context,
      Container? layoutContainer,
      bool isCachableOn: true,
      onResourceComplete? onResourceComplete,
      onResourceFail? onResourceFail,
      onResourceFailNoCache? onResourceFailNoCache,
      }) async {
    // if (context == null) return mGetResourceDeliveryManager;
    await lock.synchronized(() async {
      HttpManager.getInstance().doPostRequest(Apis.getResourceList,
          context: context,
          params: {"scene_code": scene ?? 'cms_home_page'},
          isCachableOn: isCachableOn,
          callback: (BaseBean baseBean, String scene, bool isFromCache) {
        if (isFromCache == true) {
          //从缓存回来
          if (baseBean == null || baseBean.success == false) {
            if (onResourceFailNoCache != null) {
              onResourceFailNoCache();
            }
          } else {
            List<ResourceLocationInfoBean> list = Utility.parseResourceBean(baseBean.data);
            if (onResourceComplete != null) {
              onResourceComplete(list, isFromCache);
            }
          }
        } else {
          //正常请求回来
          if (baseBean != null && baseBean.success == true) {
            List<ResourceLocationInfoBean> list = Utility.parseResourceBean(baseBean.data);
            // if (onResourceDeliveryComplete != null) {
            //   onResourceDeliveryComplete.onComplete(list, isFromCache);
            // }
            if (onResourceComplete != null) {
              onResourceComplete(list, isFromCache);
            }
          } else {
            // if (onResourceDeliveryComplete != null) {
            //   onResourceDeliveryComplete.onFail();
            // }
            if (onResourceFail != null) {
              onResourceFail();
            }
          }
        }
        // print(baseBean.toString());
      });
    });
    return mGetResourceDeliveryManager;
  }

  void processGetResourceDeliveryResponse(
      {BaseBean? getResourceDeliveryResponse,
      bool? shouldCache,
      OnResourceDeliveryComplete? onComplete}) {}

  void loadResouceDelivery() async {
    // SharePreferenceUtil.getInstance();
  }

  init() {}
}
