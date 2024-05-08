import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbUser.dart';

import '../../util/Utility.dart';
import 'MongoDb.dart';
import 'MongoDbDio.dart';




class MongoDbBatch {
  Future<List> insertBatch(List<MongoDbObject> bmobObjects) async {
    return process("POST", bmobObjects);
  }

  Future<List> deleteBatch(List<MongoDbObject> bmobObjects) async {
    return process("DELETE", bmobObjects);
  }

  Future<List> updateBatch(List<MongoDbObject> bmobObjects) async {
    return process("PUT", bmobObjects);
  }

  Future<List> process(String method, List<MongoDbObject> mongoDbObjects) async {
    List list = [];
    Map params = Map();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.get("user") as String?;
    Utility.print(userJson);
    MongoDbUser? mongoDbUser;
    if (userJson != null) {
      mongoDbUser = MongoDbUser.fromJson(json.decode(userJson));
    }

    for (MongoDbObject mongoDbObject in mongoDbObjects) {
      if (mongoDbObject is MongoDbUser) {
        //过滤BmobUser类型的处理，因为批处理操作不支持对User表的操作
        Utility.print("BmobUser does not support batch operations");
      } else {
        Map single = Map();
        single["method"] = method;
        if (method == "PUT" || method == "DELETE") {
          //批量更新和批量删除
          if (userJson != null) {
            single["token"] = mongoDbUser?.sessionToken ?? "";
          }
          single["path"] = "/api" + MongoDb.MONGODB_API_CLASSES +
              mongoDbObject.runtimeType.toString() +
              "/" +
              (mongoDbObject.objectId ?? "");
        } else {
          //批量添加
          single["path"] =
              MongoDb.MONGODB_API_CLASSES + mongoDbObject.runtimeType.toString();
        }

        Map body = mongoDbObject.getParams();
        Map tmp = mongoDbObject.getParams();
        tmp.forEach((key, value) {
          if (value == null) {
            body.remove(key);
          }
        });
        single["body"] = body;

        body.remove("objectId");
        body.remove("createdAt");
        body.remove("updatedAt");

        list.add(single);
      }
    }
    params["requests"] = list;
    Utility.print(params.toString());

    List responseData =
    await MongoDbDio.getInstance().post(MongoDb.MONGODB_API_BATCH, data: params) ?? [];

    Utility.print(responseData.toString());

    return responseData;
  }
}
