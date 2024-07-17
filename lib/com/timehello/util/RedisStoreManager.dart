import 'dart:convert';
import 'dart:io';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../beans/BaseBean.dart';

/**
 * https://help.aliyun.com/zh/oss/developer-reference/use-temporary-access-credentials-provided-by-sts-to-access-oss
 * https://ram.console.aliyun.com/permissions
 * https://help.aliyun.com/zh/ram/developer-reference/sts-sdk-overview?spm=a2c4g.11186623.0.i9#reference-w5t-25v-xdb
 * 这里配置bucket
 * https://help.aliyun.com/zh/oss/developer-reference/use-temporary-access-credentials-provided-by-sts-to-access-oss#p-osc-r0m-u63
 * https://www.npmjs.com/package/@alicloud/sts20150401?activeTab=code
 * 处理完还需呀设置上传服务器oss回到告诉服务器做记录
 * https://help.aliyun.com/zh/oss/user-guide/upload-callbacks-12?spm=api-workbench.Troubleshoot.0.0.13c47185fL7mxk
 */
class RedisManager {
  static RedisManager? mRedisManagerr;

  static RedisManager getInstance() {
    if (mRedisManagerr == null) {
      mRedisManagerr = new RedisManager();
      mRedisManagerr?.init();
    }
    return mRedisManagerr!;
  }

  Future<void> init() async {
    return;
  }

  setString({required String scene, required String key, required String value, required int time}) async {
    BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
        Apis.setRedis, params: {"scene": scene, "key": key, "text": value, "delay": time});
    if (baseBean.code == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getString({required String scene, required String key}) async {
    BaseBean baseBean =
    await HttpManager.getInstance().doGetRequest(Apis.getRedis, params: {"scene": scene, "key": key});
    if (baseBean.code == 200) {
      return baseBean.data;
    } else {
      return null;
    }
  }

}
