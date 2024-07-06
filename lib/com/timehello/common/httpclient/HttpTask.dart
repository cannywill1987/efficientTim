import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../config/EVENTNAME.dart';
import '../../util/EventCollection.dart';
import '../../util/Perf.dart';
import 'HttpManager.dart';
import 'Oberver.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

class HttpTask extends Observable {
  bool? isCanceled;
  late String mUrl;
  int request_timeOut = Params.REQUEST_TIMEOUT;
  int connect_timeOut = Params.REQUEST_TIMEOUT;
  int receive_timeOut = Params.REQUEST_TIMEOUT;

  HttpManager? mHttpManager;
  Observer? mObserver;

  // BaseBean response;
  String? scene;

  BaseOptions? options;

  HttpTask(HttpManager baseManager, String url, Observer? observer) {
    this.mUrl = url;
    this.mHttpManager = baseManager;
    this.mObserver = observer;

    // this.response = response;
    if (this.mObserver != null) {
      this.addObserver(this.mObserver);
    }
  }

  //get请求
  // Function callBack,
  Future<String> stream(Map<String, dynamic> params,
      {String? scene,
      bool? shouldShowToast,
      int? CONNECT_TIMEOUT,
      int? RECEIVE_TIMEOUT,
      bool isLocalServer: true,
      bool isCachableOn: false,
      BuildContext? context,
      OnStreamResponseListener? callBack}) async {
    String? urlTmp = this.mUrl?.indexOf("http") != -1
        ? this.mUrl
        : Params.mBaseUrl + this.mUrl;
    this.scene = scene ?? "";
    mHttpManager?.mHttpTasks.add(this);
    // if (isCachableOn == true) {
    //   S resCache = SharePreferenceUtil.getSyncInstance()
    //       .getHttpCache(key: (urlTmp ?? "") + params.toString(), mode: "GET");
    //   if (callBack != null) {
    //     callBack(resCache, scene == null ? this.mUrl : scene, 2);
    //   }
    // }
    String res = await _requestStream(urlTmp,
        method: HttpManager.POST,
        scene: scene == null ? this.mUrl : scene,
        context: context,
        isLocalServer: isLocalServer,
        CONNECT_TIMEOUT: CONNECT_TIMEOUT,
        RECEIVE_TIMEOUT: RECEIVE_TIMEOUT,
        shouldShowToast: shouldShowToast,
        params: params,
        callBack: callBack);
    // if (isCachableOn == true) {
    //   // SharePreferenceUtil.getSyncInstance().setHttpCache(
    //   //     key: urlTmp + params.toString(), baseBean: res, mode: "GET");
    // }
    // notifyObserver(mObserver, res, scene == null ? this.mUrl : scene);
    if (this.mObserver != null) {
      this.addObserver(this.mObserver);
    }
    if (callBack != null) {
      callBack(res, scene == null ? this.mUrl : scene, 2);
    }
    mHttpManager?.mHttpTasks.remove(this);
    return res;
  }

  //get请求
  // Function callBack,
  Future<BaseBean> get(Map<String, dynamic> params,
      {String? scene,
      bool? shouldShowToast,
      int? CONNECT_TIMEOUT,
      int? RECEIVE_TIMEOUT,
      bool isLocalServer: true,
      bool isCachableOn: false,
      BuildContext? context,
      OnHttpResponseListener? callBack}) async {
    String? urlTmp = this.mUrl?.indexOf("http") != -1
        ? this.mUrl
        : Params.mBaseUrl + this.mUrl;
    this.scene = scene ?? "";
    mHttpManager?.mHttpTasks.add(this);
    if (isCachableOn == true) {
      BaseBean resCache = SharePreferenceUtil.getSyncInstance()
          .getHttpCache(key: (urlTmp ?? "") + params.toString(), mode: "GET");
      if (callBack != null) {
        callBack(resCache, scene == null ? this.mUrl : scene, true);
      }
    }
    BaseBean res = await _request(urlTmp,
        method: HttpManager.GET,
        context: context,
        isLocalServer: isLocalServer,
        CONNECT_TIMEOUT: CONNECT_TIMEOUT,
        RECEIVE_TIMEOUT: RECEIVE_TIMEOUT,
        shouldShowToast: shouldShowToast,
        params: params,
        callBack: callBack);
    if (isCachableOn == true) {
      SharePreferenceUtil.getSyncInstance().setHttpCache(
          key: urlTmp + params.toString(), baseBean: res, mode: "GET");
    }
    notifyObserver(mObserver, res, scene == null ? this.mUrl : scene);
    if (this.mObserver != null) {
      this.addObserver(this.mObserver);
    }
    if (callBack != null) {
      callBack(res, scene == null ? this.mUrl : scene, false);
    }
    mHttpManager?.mHttpTasks.remove(this);
    return res;
  }

  //get请求
  // Function callBack,
  Future<BaseBean> getFileContent(Map<String, dynamic> params,
      {String? scene,
      bool shouldShowToast = false,
      bool isCachableOn: false,
      int? CONNECT_TIMEOUT,
      int? RECEIVE_TIMEOUT,
      BuildContext? context,
      bool isLocalServer: true,
      OnHttpResponseListener? callBack}) async {
    String urlTmp = this.mUrl.indexOf("http") != -1
        ? this.mUrl
        : Params.mBaseUrl + this.mUrl;
    this.scene = scene ?? "";
    mHttpManager?.mHttpTasks.add(this);
    if (isCachableOn == true) {
      BaseBean resCache = SharePreferenceUtil.getSyncInstance()
          .getHttpCache(key: urlTmp + params.toString(), mode: "GET");
      if (callBack != null) {
        callBack(resCache, scene == null ? this.mUrl : scene, true);
      }
    }
    BaseBean res = await _requestFileContent(urlTmp,
        method: HttpManager.GET,
        context: context ?? Utility.getGlobalContext(),
        shouldShowToast: shouldShowToast,
        params: params,
        callBack: callBack);
    if (isCachableOn == true) {
      SharePreferenceUtil.getSyncInstance().setHttpCache(
          key: urlTmp + params.toString(), mode: "GET", baseBean: null);
    }
    notifyObserver(mObserver, res, scene == null ? this.mUrl : scene);
    if (this.mObserver != null) {
      this.addObserver(this.mObserver);
    }
    if (callBack != null) {
      callBack(res, scene == null ? this.mUrl : scene, false);
    }
    mHttpManager?.mHttpTasks.remove(this);
    return res;
  }

  //post请求
  Future<BaseBean> post(Map<String, dynamic> params,
      {String? scene,
      int? CONNECT_TIMEOUT,
      int? RECEIVE_TIMEOUT,
      bool shouldShowToast = false,
      bool isCachableOn: false,
      BuildContext? context,
      isLocalServer: true,
      OnHttpResponseListener? callBack}) async {
    String urlTmp = this.mUrl.indexOf("http") != -1
        ? this.mUrl
        : Params.mBaseUrl + this.mUrl;
    this.scene = scene ?? "";
    mHttpManager?.mHttpTasks.add(this);
    if (isCachableOn == true) {
      BaseBean resCache = SharePreferenceUtil.getSyncInstance()
          .getHttpCache(key: urlTmp + params.toString(), mode: "POST");
      if (callBack != null) {
        callBack(resCache, scene == null ? this.mUrl : scene, true);
      }
    }
    BaseBean res = await _request(urlTmp,
        method: HttpManager.POST,
        params: params,
        context: context,
        CONNECT_TIMEOUT: CONNECT_TIMEOUT,
        RECEIVE_TIMEOUT: RECEIVE_TIMEOUT,
        isLocalServer: isLocalServer,
        shouldShowToast: shouldShowToast,
        callBack: callBack);
    if (isCachableOn == true) {
      SharePreferenceUtil.getSyncInstance().setHttpCache(
          key: urlTmp + params.toString(), baseBean: res, mode: "POST");
    }
    if (callBack != null) {
      callBack(res, scene == null ? this.mUrl : scene, false);
    }
    notifyObserver(mObserver, res, scene == null ? this.mUrl : scene);
    mHttpManager?.mHttpTasks.remove(this);
    // deleteObserver(mObserver);
    return res;
  }

  static Future<String> _requestStream(
    String url, {
    OnStreamResponseListener? callBack,
    int? CONNECT_TIMEOUT,
    int? RECEIVE_TIMEOUT,
    String? scene,
    String method = "GET",
    BuildContext? context,
    bool? shouldShowToast,
    Map<String, dynamic>? params,
    bool isLocalServer = true, //是否是本地服务 true 是，false 外地服务
  }) async {
    BaseBean baseBean;
    if (params != null && params.isNotEmpty) {
      print("<网络请求> url:<" + method + ">" + url);
      print("<网络请求> params:" + params.toString());
    }

    String errorMsg = "";
    // int statusCode;
    int perfTimeStart = Utility.getTimeStampToday();
    try {
      // final perf = Perf();
      // perf.start();

      Response<ResponseBody> responseTmp;
      Dio dio = Dio(new BaseOptions(
        responseDecoder: Utility.getGzipDecoder,
        headers: {"accept-encoding": "gzip"},
        //连接服务器的超时时间，单位是毫秒。
        connectTimeout:
            Duration(milliseconds: CONNECT_TIMEOUT ?? Params.CONNECT_TIMEOUT),
        //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
        receiveTimeout:
            Duration(milliseconds: RECEIVE_TIMEOUT ?? Params.RECEIVE_TIMEOUT),
      ));
      // ..interceptors.add(LogInterceptor());
      // if(Utility.getHttp2Adapter() != null) {
      //   dio.httpClientAdapter = Utility.getHttp2Adapter()!;
      // }
      dio.options.headers['accept-encoding'] = "gzip, deflate";

      dio.options.headers['USER-TOKEN'] =
          LoginManager.getInstance().userBean?.token;
      dio.options.headers['Accept-Language'] =
          DeviceInfoManagement.getLanguage() + ";q=0.5";
      dio.options.headers['LANGUAGE'] = DeviceInfoManagement.getLanguage();
      dio.options.headers['COUNTRY-CODE'] =
          DeviceInfoManagement.getCountryCode();
      String requestUrl = url;
      if (method == HttpManager.GET) {
        //组合GET请求的参数
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          requestUrl = url + paramStr;
        }
        responseTmp = await dio.get(
          requestUrl,
          options: Options(
            responseType: ResponseType.stream, // 设置响应类型为stream
          ),
        );
      } else {
        if (params != null && params.isNotEmpty) {
          responseTmp = await dio.post(
            requestUrl,
            data: params,
            options: Options(
              responseType: ResponseType.stream, // 设置响应类型为stream
            ),
          );
        } else {
          responseTmp = await dio.post(
            requestUrl,
            options: Options(
              responseType: ResponseType.stream, // 设置响应类型为stream
            ),
          );
        }
      }
      // 获取stream
      Stream<Uint8List> stream = responseTmp.data!.stream;
      // 创建一个用于接收数据的List
      List<int> dataBytes = [];
      // 创建一个Completer，用于在数据接收完毕时返回结果
      Completer<String> completer = Completer<String>();
      bool isComplete = false;
      // 监听stream
      stream.listen(
        (Uint8List chunk) {
          // 处理接收到的数据块
          String chunkData = utf8.decode(chunk);
          print("data:" + chunkData);
          // dataBytes.addAll(chunk);
          dataBytes.addAll(chunk);
          //发起回调
          callBack?.call(utf8.decode(dataBytes), scene ?? "", 1);
          String result = utf8.decode(dataBytes);
          print("stream listen:" + result);
          if (result.indexOf("CompleteEnd") != -1) {
            // 完成completer，返回结果
            if (isComplete == false) {
              isComplete = true;
              completer.complete(result);
              dio.close(force: true);
            }
            return;
          } else if (result.indexOf("\n") != -1) {
            if (isComplete == false) {
              isComplete = true;
              completer.complete(result);
              dio.close(force: true);
            }
          } else {
            callBack?.call(result, scene ?? "", 2);
          }
        },
        onDone: () {
          if (isComplete == false) {
            isComplete = true;
            // 当接收完成时调用
            print('Stream is done');
            // 将接收到的完整数据转换为字符串
            String result = utf8.decode(dataBytes);
            print("stream listen done:" + result);
            // 完成completer，返回结果
            completer.complete(result);
          }
        },
        onError: (error) {
          // 处理错误
          print('Error: $error');
          // 在出错时完成completer，返回错误
          completer.completeError(error);
          callBack?.call(error.toString(), scene == null ? url : scene, 3);
        },
        cancelOnError: true,
      );

      // 等待completer完成并返回结果
      return completer.future;
      // perf.stop();

      // if (isLocalServer == true) {
      //   baseBean = BaseBean.fromJson(responseTmp.data);
      // } else {
      //   baseBean = BaseBean(message: '', success: true, data: responseTmp.data);
      // }

      // print("response data:" + responseTmp.toString());
    } catch (exception) {
      print(exception);
      print(getI18NKey().network_error);
      // if (errorCallBack != null) {
      //   errorCallBack(errorMsg);
      // }
      // print("<net> errorMsg :" + errorMsg);

      EventCollection.onCollection(
          sceneType: EVENTNAME.SYSTEM,
          eventType: EVENTNAME.REQUEST_ERROR,
          message: url + params.toString(),
          resultType: getI18NKey().network_error);
      // 出现异常时返回错误信息
      return Future.error(exception.toString());
    }
  }

  //具体的还是要看返回数据的基本结构
  //公共代码部分
  static Future<BaseBean> _request(
    String url, {
    Function? callBack,
    int? CONNECT_TIMEOUT,
    int? RECEIVE_TIMEOUT,
    String method = "GET",
    BuildContext? context,
    bool? shouldShowToast,
    Map<String, dynamic>? params,
    bool isLocalServer = true, //是否是本地服务 true 是，false 外地服务
  }) async {
    BaseBean baseBean;
    if (params != null && params.isNotEmpty) {
      print("<网络请求> url:<" + method + ">" + url);
      print("<网络请求> params:" + params.toString());
    }

    String errorMsg = "";
    // int statusCode;
    int perfTimeStart = Utility.getTimeStampToday();
    try {
      // final perf = Perf();
      // perf.start();

      Response responseTmp;
      Dio dio = Dio(new BaseOptions(
        responseDecoder: Utility.getGzipDecoder,
        headers: {"accept-encoding": "gzip"},
        //连接服务器的超时时间，单位是毫秒。
        connectTimeout:
            Duration(milliseconds: CONNECT_TIMEOUT ?? Params.CONNECT_TIMEOUT),
        //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
        receiveTimeout:
            Duration(milliseconds: RECEIVE_TIMEOUT ?? Params.RECEIVE_TIMEOUT),
      ));
      // ..interceptors.add(LogInterceptor());
      // if(Utility.getHttp2Adapter() != null) {
      //   dio.httpClientAdapter = Utility.getHttp2Adapter()!;
      // }
      dio.options.headers['accept-encoding'] = "gzip, deflate";

      dio.options.headers['USER-TOKEN'] =
          LoginManager.getInstance().userBean?.token;
      dio.options.headers['Accept-Language'] =
          DeviceInfoManagement.getLanguage() + ";q=0.5";
      dio.options.headers['LANGUAGE'] = DeviceInfoManagement.getLanguage();
      dio.options.headers['COUNTRY-CODE'] =
          DeviceInfoManagement.getCountryCode();
      if (method == HttpManager.GET) {
        //组合GET请求的参数
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }

        responseTmp = await dio.get(url);
      } else {
        if (params != null && params.isNotEmpty) {
          responseTmp = await dio.post(url, data: params);
        } else {
          responseTmp = await dio.post(url);
        }
      }
      // perf.stop();

      if (isLocalServer == true) {
        baseBean = BaseBean.fromJson(responseTmp.data);
      } else {
        baseBean = BaseBean(message: '', success: true, data: responseTmp.data);
      }

      // print("response data:" + responseTmp.toString());
    } catch (exception) {
      print(exception);
      print(getI18NKey().network_error);
      // if (errorCallBack != null) {
      //   errorCallBack(errorMsg);
      // }
      // print("<net> errorMsg :" + errorMsg);

      EventCollection.onCollection(
          sceneType: EVENTNAME.SYSTEM,
          eventType: EVENTNAME.REQUEST_ERROR,
          message: url + params.toString(),
          resultType: getI18NKey().network_error);
      baseBean = BaseBean(
          success: false, code: "-1", message: getI18NKey().network_error);
      // _handError(errorCallBack, exception.toString());
    }
    if (params != null && params.isNotEmpty) {
      try {
        print("<网络返回> response: code是" +
            (baseBean.code ?? "") +
            " message是" +
            (baseBean?.message ?? ""));
      } catch (e) {}
    }
    if (shouldShowToast == true &&
        CONSTANTS.getErrorMessage(baseBean.code).isEmpty == false) {
      Utility.showToastMsg(
          context: context ?? Utility.getGlobalContext(),
          msg: CONSTANTS.getErrorMessage(baseBean.code));
    } else if (shouldShowToast == true &&
        baseBean.success == false &&
        baseBean.message?.isEmpty == false) {
      Utility.showToastMsg(
          context: context ?? Utility.getGlobalContext(),
          msg: baseBean.message);
    }
    int perfTimeEnd = Utility.getTimeStampToday();
    if (Utility.isProductEnv() == false) {
      print("api性能:");
      print("<网络请求> url:<" + method + ">" + url);
      print("请求耗时:${(perfTimeEnd - perfTimeStart)}");
    }
    return baseBean;
  }

  //具体的还是要看返回数据的基本结构
  //公共代码部分
  static Future<BaseBean> _requestFileContent(
    String url, {
    Function? callBack,
    String? method,
    BuildContext? context,
    bool? shouldShowToast,
    Map<String, dynamic>? params,
  }) async {
    BaseBean baseBean;
    if (params != null && params.isNotEmpty) {
      print("<网络请求> url:<" + (method ?? "") + ">" + url);
      print("<网络请求> params:" + params.toString());
    }

    String errorMsg = "";
    // int statusCode;

    try {
      Response responseTmp;
      Dio dio = Dio();
        // ..interceptors.add(LogInterceptor());
      //
      // dio.options.headers['USER-TOKEN'] =
      //     LoginManager.getInstance().userBean?.token;
      // dio.options.headers['LANGUAGE'] = DeviceInfoManagement.getLanguage();
      // dio.options.headers['COUNTRY-CODE'] =
      //     DeviceInfoManagement.getCountryCode();

      if (method == HttpManager.GET) {
        //组合GET请求的参数
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }

        responseTmp = await dio.get(url);
      } else {
        if (params != null && params.isNotEmpty) {
          responseTmp = await dio.post(url, data: params);
        } else {
          responseTmp = await dio.post(url);
        }
      }
      baseBean = BaseBean(data: responseTmp.data, success: true, code: "0");

      // print("response data:" + responseTmp.toString());
    } catch (exception) {
      // if (errorCallBack != null) {
      //   errorCallBack(errorMsg);
      // }
      // print("<net> errorMsg :" + errorMsg);
      baseBean = BaseBean(data: "", success: false, code: "-1");
      // _handError(errorCallBack, exception.toString());
    }
    if (params != null && params.isNotEmpty) {
      try {
        print("<网络返回> response: code是" +
            (baseBean.code ?? "") +
            " message是" +
            (baseBean?.message ?? ""));
      } catch (e) {}
    }
    if (shouldShowToast == true &&
        CONSTANTS.getErrorMessage(baseBean.code).isEmpty == false) {
      Utility.showToastMsg(
          context: context ?? Utility.getGlobalContext(),
          msg: CONSTANTS.getErrorMessage(baseBean.code));
    } else if (shouldShowToast == true &&
        baseBean.success == false &&
        baseBean.message?.isEmpty == false) {
      Utility.showToastMsg(
          context: context ?? Utility.getGlobalContext(),
          msg: baseBean.message);
    }
    return baseBean;
  }

  //处理异常
  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print("<net> errorMsg :" + errorMsg);
  }

// operator == (Object o) {
//   HttpTask task = o as HttpTask;
//   if (task == null) {
//     return false;
//   }
//   return this == task;
// }
}
