import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/LoginManager.dart';
import 'HttpTask.dart';
import 'Oberver.dart';
import 'Observable.dart';

/**
 * requestStatus 0 未开始 1 请求中 2 请求成功 3 请求失败
 */
typedef OnStreamResponseListener = void Function(
    String res, String scene, int requestStatus);
typedef OnHttpResponseListener = void Function(
    BaseBean baseBean, String scene, bool isFromCache);
typedef OnHttpGetFileContentResponseListener = void Function(
    String baseBean, String scene, bool isFromCache);

class HttpManager extends Observable {
  int request_timeOut = 20000;
  static HttpManager mManager = new HttpManager();
  List<dynamic> mHttpTasks = <dynamic>[];
  static const String GET = "get";
  static const String POST = "post";

  static HttpManager getInstance() {
    return mManager;
  }

  void deleteObserver(Observer o) {
    super.deleteObserver(o);
    this.cancel(o);
  }

  void cancel(Observer observer) {
    List<dynamic> removeTasks = <dynamic>[]; //todo 这个removeTasks没用呢
    try {
      if (mHttpTasks != null && mHttpTasks.length > 0) {
        for (int i = 0; i < mHttpTasks.length; i++) {
          HttpTask task = mHttpTasks[i];
          if (mHttpTasks[i] == observer) {
            mHttpTasks[i].cancel();
            removeTasks.add(task);
          }
        }
      }
    } catch (e) {
      mHttpTasks = <dynamic>[];
    }
  }

  Future<BaseBean> uploadFile(
      {String? key, required File file, required String url}) async {
    try {
      bool isExistsSync = file.existsSync();
      //针对Ios不能有file
      if (isExistsSync == false) {
        file = new File(file.path?.replaceFirst("file:/", "") ?? "");
      }
      if (Params.env != EnvEnum.prd) {
        print("file length is: ${file.lengthSync()}");
      }
      Dio dio = Dio(new BaseOptions(
        responseDecoder: Utility.getGzipDecoder,
        headers: {"accept-encoding": "gzip"},
        //连接服务器的超时时间，单位是毫秒。
        // connectTimeout:
        // Duration(milliseconds: CONNECT_TIMEOUT ?? Params.CONNECT_TIMEOUT),
        // //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
        // receiveTimeout:
        // Duration(milliseconds: RECEIVE_TIMEOUT ?? Params.RECEIVE_TIMEOUT),
      ))
        // ..options.baseUrl = 'https://pub-web.flutter-io.cn'
        // ..interceptors.add(LogInterceptor())
        // ..httpClientAdapter = Http2Adapter(
        //   ConnectionManager(
        //     idleTimeout: Duration(seconds: 10), // Enable gzip compression
        //     onClientCreate: (_, config) =>
        //         config.onBadCertificate = (_) => true,
        //     // onClientCreate: (client) { return client.gzip()},
        //   ),
        // )
      ;

      // Dio dio = Dio(BaseOptions(
      //   responseDecoder: Utility.getGzipDecoder,
      //   headers: {"accept-encoding": "gzip"},
      // ));
      dio.options.headers['USER-TOKEN'] =
          LoginManager.getInstance().userBean?.token;
      dio.options.headers['LANGUAGE'] = DeviceInfoManagement.getLanguage();
      FormData formData =
          FormData.fromMap({"key": MultipartFile.fromFileSync(file.path)});
      var result = await dio.post(Params.mBaseUrl + url, data: formData);
      BaseBean baseBean = BaseBean.fromJson(result.data);
      return baseBean;
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<BaseBean> uploadImage(
      {String? key, required File file, required String url}) async {
    try {
      FormData formData =
          FormData.fromMap({"key": await MultipartFile.fromFile(file.path)});

      Dio dio = Dio(new BaseOptions(
        responseDecoder: Utility.getGzipDecoder,
        headers: {"accept-encoding": "gzip"},
        //连接服务器的超时时间，单位是毫秒。
        // connectTimeout:
        // Duration(milliseconds: CONNECT_TIMEOUT ?? Params.CONNECT_TIMEOUT),
        // //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
        // receiveTimeout:
        // Duration(milliseconds: RECEIVE_TIMEOUT ?? Params.RECEIVE_TIMEOUT),
      ))
        // ..options.baseUrl = 'https://pub-web.flutter-io.cn'
        // ..interceptors.add(LogInterceptor())
        // ..httpClientAdapter = Http2Adapter(
        //   ConnectionManager(
        //     idleTimeout: Duration(seconds: 10), // Enable gzip compression
        //     onClientCreate: (_, config) =>
        //         config.onBadCertificate = (_) => true,
        //     // onClientCreate: (client) { return client.gzip()},
        //   ),
        // )
      ;
      var result = await dio.post(Params.mBaseUrl + url, data: formData);
      dio.options.headers['USER-TOKEN'] =
          LoginManager.getInstance().userBean?.token;
      dio.options.headers['LANGUAGE'] = DeviceInfoManagement.getLanguage();
      BaseBean baseBean = BaseBean.fromJson(result.data);
      return baseBean;
    } catch (e) {
      return BaseBean(success: false);
    }
  }

  Future<String> doStreamRequest(dynamic url,
      {String? scene,
        Map<String, dynamic> params = const {},
        bool isLocalServer: true,
        BuildContext? context, //用于显示toast 可选
        Observer? observer,
        bool isCachableOn: false,
        int? CONNECT_TIMEOUT,
        int? RECEIVE_TIMEOUT,
        bool shouldShowErrorToast = true,
        OnStreamResponseListener? callback}) async {
    print("url:" + url);
    int timeUsed = 0;
    if (Utility.isProductEnv() != true) {
      timeUsed = Utility.getTimeStampToday();
    }
    if(scene == Apis.gameRankingGetList) {
      print("url:" + url);
    }
    String res = await new HttpTask(this, url, observer).stream(
      params,
      scene: scene,
      context: context,
      isLocalServer: isLocalServer,
      CONNECT_TIMEOUT: CONNECT_TIMEOUT,
      RECEIVE_TIMEOUT: RECEIVE_TIMEOUT,
      isCachableOn: isCachableOn,
      shouldShowToast: shouldShowErrorToast,
      callBack: callback,
    );
    if (Utility.isProductEnv() != true) {
      print("url: ${url}, timeUsed: ${Utility.getTimeStampToday() - timeUsed}");
    }
    return res;
  }

  Future<BaseBean> doGetRequest(dynamic url,
      {String? scene,
      Map<String, dynamic> params = const {},
      bool isLocalServer: true,
      BuildContext? context, //用于显示toast 可选
      Observer? observer,
      bool isCachableOn: false,
      int? CONNECT_TIMEOUT,
      int? RECEIVE_TIMEOUT,
      bool shouldShowErrorToast = true,
      OnHttpResponseListener? callback}) async {
    print("url:" + url);
    int timeUsed = 0;
    if (Utility.isProductEnv() != true) {
      timeUsed = Utility.getTimeStampToday();
    }
    if(scene == Apis.gameRankingGetList) {
      print("url:" + url);
    }
    BaseBean baseBean = await new HttpTask(this, url, observer).get(
      params,
      scene: scene,
      context: context,
      isLocalServer: isLocalServer,
      CONNECT_TIMEOUT: CONNECT_TIMEOUT,
      RECEIVE_TIMEOUT: RECEIVE_TIMEOUT,
      isCachableOn: isCachableOn,
      shouldShowToast: shouldShowErrorToast,
      callBack: callback,
    );
    if (Utility.isProductEnv() != true) {
      print("url: ${url}, timeUsed: ${Utility.getTimeStampToday() - timeUsed}");
    }
    return baseBean;
  }

  Future<BaseBean> doPostRequest(dynamic url,
      {String? scene,
      BuildContext? context, //用于显示toast 可选
      bool isLocalServer: true,
      Map<String, dynamic> params = const {},
      Observer? observer,
      bool isCachableOn: false,
      int? CONNECT_TIMEOUT,
      int? RECEIVE_TIMEOUT,
      bool shouldShowErrorToast = true,
      OnHttpResponseListener? callback}) async {
    int timeUsed = 0;
    if(scene == Apis.gameRankingGetList) {
      print("url:" + url);
    }
    if (Utility.isProductEnv() != true) {
      timeUsed = Utility.getTimeStampToday();
    }
    BaseBean baseBean = await new HttpTask(this, url, observer).post(
      params,
      context: context,
      isCachableOn: isCachableOn,
      isLocalServer: isLocalServer,
      CONNECT_TIMEOUT: CONNECT_TIMEOUT,
      RECEIVE_TIMEOUT: RECEIVE_TIMEOUT,
      scene: scene,
      shouldShowToast: shouldShowErrorToast,
      callBack: callback,
    );
    if (Utility.isProductEnv() != true) {
      print("url: ${url}, timeUsed: ${Utility.getTimeStampToday() - timeUsed}");
    }
    return baseBean;
  }

  Future<BaseBean> doGetFileContentRequest(dynamic url,
      {String? scene,
      BuildContext? context, //用于显示toast 可选
      Map<String, dynamic> params = const {},
      Observer? observer,
      bool isCachableOn: false,
      bool shouldShowErrorToast = true,
      OnHttpResponseListener? callback}) async {
    return await new HttpTask(this, url, observer).getFileContent(
      params,
      context: context,
      isCachableOn: isCachableOn,
      scene: scene,
      shouldShowToast: shouldShowErrorToast,
      callBack: callback,
    );
  }
}
