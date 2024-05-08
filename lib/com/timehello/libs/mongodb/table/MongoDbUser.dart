import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_hello/com/timehello/libs/mongodb/MongoDbDio.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';

import '../../../util/Utility.dart';
import '../MongoDb.dart';
import '../response/MongoDbHandled.dart';
import '../response/MongoDbRegistered.dart';

//此处与类名一致，由指令自动生成代码
part 'MongoDbUser.g.dart';

@JsonSerializable()
class MongoDbUser extends MongoDbObject {
  String? username;
  String? password;
  String? email;
  bool? emailVerified;
  String? mobilePhoneNumber;
  bool? mobilePhoneNumberVerified;
  String? sessionToken;

  MongoDbUser();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbUser.fromJson(Map<String, dynamic> json) =>
      _$MongoDbUserFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbUserToJson(this);

  ///用户账号密码注册
  Future<MongoDbRegistered> register() async {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    String params = json.encode(data);
    //发送请求
    Map<String, dynamic> responseData =
        await MongoDbDio.getInstance().post(MongoDb.MONGODB_API_USERS, data: params);
    MongoDbRegistered bmobRegistered = MongoDbRegistered.fromJson(responseData);
    MongoDbDio.getInstance().setSessionToken(bmobRegistered.sessionToken);
    return bmobRegistered;
  }

  ///账号密码登录
  Future<MongoDbUser> login() async {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await MongoDbDio.getInstance()
        .get(MongoDb.MONGODB_API_LOGIN + getUrlParams(data));
    MongoDbUser bmobUser = MongoDbUser.fromJson(result);
    // obtain shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setString("user", result.toString());
    prefs.setString("user", json.encode(bmobUser));
    Utility.print(result.toString());

    MongoDbDio.getInstance().setSessionToken(bmobUser.sessionToken);
    return bmobUser;
  }

  ///手机短信验证码登录
  Future<MongoDbUser> loginBySms(String smsCode) async {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    data["smsCode"] = smsCode;
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await MongoDbDio.getInstance()
        .post(MongoDb.MONGODB_API_USERS, data: getParamsJsonFromParamsMap(data));
    Utility.print(result);
    MongoDbUser bmobUser = MongoDbUser.fromJson(result);
    MongoDbDio.getInstance().setSessionToken(bmobUser.sessionToken);
    return bmobUser;
  }

  ///发送邮箱重置密码的请求
  Future<MongoDbHandled> requestPasswordResetByEmail() async {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await MongoDbDio.getInstance().post(
        MongoDb.MONGODB_API_REQUEST_PASSWORD_RESET,
        data: getParamsJsonFromParamsMap(data));
    Utility.print(result);
    MongoDbHandled bmobHandled = MongoDbHandled.fromJson(result);
    return bmobHandled;
  }

  ///短信重置密码
  Future<MongoDbHandled> requestPasswordResetBySmsCode(String smsCode) async {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await MongoDbDio.getInstance().put(
        MongoDb.MONGODB_API_REQUEST_PASSWORD_BY_SMS_CODE +
            MongoDb.MONGODB_API_SLASH +
            smsCode,
        data: getParamsJsonFromParamsMap(data));
    Utility.print(result);
    MongoDbHandled bmobHandled = MongoDbHandled.fromJson(result);
    return bmobHandled;
  }

  ///发送验证邮箱
  static Future<MongoDbHandled> requestEmailVerify(String email) async {
    Map<String, dynamic> data = new Map();

    data["email"] = email;

    //Map转String
    //发送请求
    Map<String, dynamic> result = await MongoDbDio.getInstance()
        .post(MongoDb.MONGODB_API_REQUEST_REQUEST_EMAIL_VERIFY, data: data);
    Utility.print(result);
    MongoDbHandled mongoDbHandled = MongoDbHandled.fromJson(result);
    return mongoDbHandled;
  }

  ///旧密码重置密码
  Future<MongoDbHandled> updateUserPassword(
      String oldPassword, String newPassword) async {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();

    data["oldPassword"] = oldPassword;
    data["newPassword"] = newPassword;
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await MongoDbDio.getInstance().put(
        MongoDb.MONGODB_API_REQUEST_UPDATE_USER_PASSWORD + objectId!,
        data: getParamsJsonFromParamsMap(data));
    Utility.print(result);
    MongoDbHandled bmobHandled = MongoDbHandled.fromJson(result);
    return bmobHandled;
  }

  ///获取在url中的请求参数
  String getUrlParams(Map data) {
    String urlParams = "";
    int index = 0;
    data.forEach((key, value) {
      if (index == 0) {
        urlParams = '$urlParams?$key=$value';
      } else {
        urlParams = '$urlParams&$key=$value';
      }
      index++;
    });
    return urlParams;
  }

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getJson
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    return map;
  }
}
