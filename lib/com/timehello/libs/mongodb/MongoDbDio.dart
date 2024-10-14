import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:time_hello/com/timehello/libs/mongodb/MongoDb.dart';

import '../../config/ENUMS.dart';
import '../../config/EVENTNAME.dart';
import '../../config/Params.dart';
import '../../util/EventCollection.dart';
import '../../util/SharePreferenceUtil.dart';
import '../../util/Utility.dart';

//    post or put:
//		md5(url + timeStamp + safeToken + noncestr+ body + sdkVersion)
//
//		get or delete:
//		md5(url + timeStamp + safeToken + noncestr+ sdkVersion)
class MongoDbDio {
  ///网络请求框架
  Dio? dio;

  ///网络请求元素
  BaseOptions? options;

  ///单例
  static MongoDbDio? instance;

  void setSessionToken(bmobSessionToken) {
    options?.headers["X-Bmob-Session-Token"] = bmobSessionToken;
  }

  ///无参构造方法
  MongoDbDio() {
    // Dio dio = Dio(new BaseOptions(
    //   responseDecoder: Utility.getGzipDecoder,
    //   headers: {"accept-encoding": "gzip"},
    //   //连接服务器的超时时间，单位是毫秒。
    //   connectTimeout:
    //   Duration(milliseconds: CONNECT_TIMEOUT ?? Params.CONNECT_TIMEOUT),
    //   //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
    //   receiveTimeout:
    //   Duration(milliseconds: RECEIVE_TIMEOUT ?? Params.RECEIVE_TIMEOUT),
    // ))
    // // ..options.baseUrl = 'https://pub-web.flutter-io.cn'
    //   ..interceptors.add(LogInterceptor())
    //   ..httpClientAdapter = Http2Adapter(
    //     ConnectionManager(
    //       idleTimeout: Duration(seconds: 10), // Enable gzip compression
    //
    //       onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    //
    //       // onClientCreate: (client) { return client.gzip()},
    //     ),
    //   );

    initDioInstance();
  }

  void initDioInstance() {
      options = new BaseOptions(
      responseDecoder: Utility.getGzipDecoder,
      headers: {"accept-encoding": "gzip"},
      //基地址
      baseUrl: MongoDb.mongoHost,
      //连接服务器的超时时间，单位是毫秒。
      connectTimeout: Duration(milliseconds: Params.mongoDBTimeout),
      //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
      receiveTimeout: Duration(milliseconds: Params.mongoDBTimeout),
      //请求头部
    //      headers: {
    //        "Content-Type": "application/json",
    //      },
    );


    dio = new Dio(options)  ..interceptors.add(LogInterceptor());
    // if(Utility.getHttp2Adapter() != null) {
    //   dio?.httpClientAdapter = Utility.getHttp2Adapter()!;
    // }
  }

  ///获取16位随机字符串
  getNoncestrKey() {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int length = 16;

    /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < length; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    Utility.print(left);
    return left;
  }

  ///md5(url(域名之外的url) + timeStamp + safeToken(后台设置) + noncestr(随机值)+ body(body json) + sdkVersion)
  getSafeSign(path, nonceStrKey, safeTimeStamp, data) {
    var origin = path +
        safeTimeStamp +
        MongoDb.mongoApiSafe +
        nonceStrKey +
        data.toString() +
        MongoDb.mongoSDKVersion;
    Utility.print(origin);
    var md5 = generateMd5(origin);
    Utility.print(md5);
    return md5;
  }

  ///md5编码
  String generateMd5(String origin) {
    var content = new Utf8Encoder().convert(origin);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  ///获取时间戳 秒
  getSafeTimestamp() {
    int second = (new DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    Utility.print(second);
    return second.toString();
  }

  ///单例模式
  static MongoDbDio getInstance() {
    if (instance == null) {
      instance = MongoDbDio();
    }
    return instance!;
  }

  ///GET请求
  Future<dynamic> get(path, {data, cancelToken}) async {
    options?.headers.addAll(getHeaders(path, ""));
    int perfTimeStart = Utility.getTimeStampToday();

    var requestUrl = (options?.baseUrl ?? "") + path;
    var headers = options?.headers.toString();
    Utility.print('Get请求启动! url：$requestUrl ,body: $data ,headers:$headers');
    try {
      Response? response = await dio?.get(
        requestUrl,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      int perfTimeEnd = Utility.getTimeStampToday();
      if (Utility.isProductEnv() == false) {
        Utility.print("api性能:");
        Utility.print("<网络请求> url:mongodb get ${path}");
        Utility.print("请求耗时:${(perfTimeEnd - perfTimeStart)}");
      }

      Utility.print('Get请求结果：' + response.toString());
      SharePreferenceUtil.getSyncInstance().setHttpCacheDynamic(
          key: requestUrl + data.toString(), map: response?.data);

      return response?.data;
    } catch (e) {
      Map res = await SharePreferenceUtil.getSyncInstance()
          .getHttpCacheDynamic(key: requestUrl + data.toString());
      EventCollection.onCollection(
          sceneType: EVENTNAME.SYSTEM,
          eventType: EVENTNAME.REQUEST_ERROR_MONGODB_ERROR_GET,
          message: requestUrl,
          resultType: e.toString());
      Utility.print(e);
      return res;
    }
  }

  /// 没地方用 POST请求
  Future<dynamic> upload(path,
      {required Future<List<int>> data, cancelToken}) async {
    options?.headers.addAll(getHeaders(path, data));
    int perfTimeStart = Utility.getTimeStampToday();

    var requestUrl = (options?.baseUrl ?? "") + path;
    var headers = options?.headers.toString();
    Utility.print('Post请求启动! url：$requestUrl ,body: $data ,headers:$headers');
    Response? response = await dio?.post(
      requestUrl,
      data: Stream.fromFuture(data),
      cancelToken: cancelToken,
    );
    int perfTimeEnd = Utility.getTimeStampToday();

    if (Utility.isProductEnv() == false) {
      Utility.print("api性能:");
      Utility.print("<网络请求> url:mongodb upload ${path}");
      Utility.print("请求耗时:${(perfTimeEnd - perfTimeStart)}");
    }
    Utility.print('Post请求结果：' + response.toString());

    return response?.data;
  }

  ///POST请求
  Future<dynamic> post(path, {data, cancelToken}) async {
    options?.headers.addAll(getHeaders(path, data));

    var requestUrl = (options?.baseUrl ?? "") + path;
    try {
      var headers = options?.headers.toString();
      Utility.print('Post请求启动! url：$requestUrl ,body: $data ,headers:$headers');
      Response? response = await dio?.post(
        requestUrl,
        data: data,
        cancelToken: cancelToken,
      );
      // EventCollection.onCollection(sceneType: EVENT.SYSTEM, eventType: EVENT.REQUEST_ERROR_MONGODB_ERROR_POST, message: requestUrl);
      Utility.print('Post请求结果：' + response.toString());
      return response?.data;
    } catch (e) {
      //todo 这里会造成死循环 若断网 问题不是特别啊
      // initDioInstance();
      EventCollection.onCollection(
          sceneType: EVENTNAME.SYSTEM,
          eventType: EVENTNAME.REQUEST_ERROR_MONGODB_ERROR_POST,
          message: requestUrl,
          resultType: e.toString());
      Utility.print(e);
      return null;
    }
  }

  ///Delete请求
  Future<dynamic> delete(
    path, {
    data,
    cancelToken,
  }) async {
    options?.headers.addAll(getHeaders(path, ""));
    int perfTimeStart = Utility.getTimeStampToday();

    var requestUrl = (options?.baseUrl ?? "") + path;
    try {
      Utility.print('Delete请求启动! url：$requestUrl ,body: $data');
      Response? response =
          await dio?.delete(requestUrl, data: data, cancelToken: cancelToken);
      Utility.print('Delete请求结果：' + response.toString());

      int perfTimeEnd = Utility.getTimeStampToday();

      if (Utility.isProductEnv() == false) {
        Utility.print("api性能:");
        Utility.print("<网络请求> url:mongodb delete ${path}");
        Utility.print("请求耗时:${(perfTimeEnd - perfTimeStart)}");
      }
      return response?.data;
    } catch (e) {
      EventCollection.onCollection(
          sceneType: EVENTNAME.SYSTEM,
          eventType: EVENTNAME.REQUEST_ERROR_MONGODB_ERROR_DELETE,
          message: requestUrl,
          resultType: e.toString());
      Utility.print(e);
      return null;
    }
  }

  ///Put请求
  Future<dynamic> put(path, {data, cancelToken}) async {
    options?.headers.addAll(getHeaders(path, data));
    int perfTimeStart = Utility.getTimeStampToday();

    var requestUrl = (options?.baseUrl ?? "") + path;
    try {
      Utility.print('Put请求启动! url：$requestUrl ,body: $data');
      Response? response =
          await dio?.put(requestUrl, data: data, cancelToken: cancelToken);
      Utility.print('Put请求结果：' + response.toString());
      int perfTimeEnd = Utility.getTimeStampToday();

      if (Utility.isProductEnv() == false) {
        Utility.print("api性能:");
        Utility.print("<网络请求> url:mongodb put ${path}");
        Utility.print("请求耗时:${(perfTimeEnd - perfTimeStart)}");
      }

      return response?.data;
    } catch (e) {
      EventCollection.onCollection(
          sceneType: EVENTNAME.SYSTEM,
          eventType: EVENTNAME.REQUEST_ERROR_MONGODB_ERROR_PUT,
          message: requestUrl,
          resultType: e.toString());
      Utility.print(e);
      return null;
    }
  }

  ///GET请求，自带请求路径，数据监听
  Future<dynamic> getByUrl(requestUrl, {data, cancelToken}) async {
    options?.headers.addAll(getHeaders(requestUrl, data));

    var headers = options?.headers.toString();
    Utility.print('Get请求启动! url：$requestUrl ,body: $data ,headers:$headers');
    Response? response = await dio?.get(
      requestUrl,
      queryParameters: data,
      cancelToken: cancelToken,
    );
    Utility.print('Get请求结果：' + response.toString());
    return response?.data;
  }

  ///获取请求头
  getHeaders(path, data) {
    Map<String, dynamic> map = Map();

    if (MongoDb.mongoAppId.isNotEmpty) {
      //没有加密
      map["X-MongoDb-Application-Id"] = MongoDb.mongoAppId;
      map["X-MongoDb-REST-API-Key"] = MongoDb.mongoRestApiKey;
    } else if (MongoDb.mongoSecretKey.isNotEmpty) {
      //加密
      int indexQuestion = path.indexOf("?");

      if (indexQuestion != -1) {
        path = path.substring(0, indexQuestion);
      }
      var nonceStrKey = getNoncestrKey();
      var safeTimeStamp = getSafeTimestamp();

      map["X-MongoDb-SDK-Type"] = MongoDb.mongoSDKType;
      map["X-MongoDb-SDK-Version"] = MongoDb.mongoSDKVersion;
      map["X-MongoDb-Secret-Key"] = MongoDb.mongoSecretKey;
      map["X-MongoDb-Safe-Timestamp"] = safeTimeStamp;
      map["X-MongoDb-Noncestr-Key"] = nonceStrKey;
      map["X-MongoDb-Safe-Sign"] =
          getSafeSign(path, nonceStrKey, safeTimeStamp, data);
    } else {
      //没有初始化
      Utility.print("请先进行SDK的初始化，再进行网络请求。");
    }

    map["Content-Type"] = "application/json";

    if (MongoDb.mongoMasterKey.isNotEmpty) {
      map["X-MongoDb-Master-Key"] = MongoDb.mongoMasterKey;
    }

    return map;
  }
}
