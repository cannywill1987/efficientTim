import 'dart:convert';

import '../../../util/Utility.dart';
import '../MongoDb.dart';
import '../MongoDbDio.dart';
import '../MongoDbUtils.dart';
import '../response/MongoDbError.dart';
import '../response/MongoDbHandled.dart';
import '../response/MongoDbSaved.dart';
import '../response/MongoDbUpdated.dart';
import '../type/MongoDbDate.dart';
import '../type/MongoDbRelation.dart';
import 'package:json_annotation/json_annotation.dart';


///Bmob对象基本类型
@JsonSerializable(nullable: false)
abstract class MongoDbObject {

  //创建时间
  String? createdAt;


  // String getModelName();

  void setCreatedAt(String createdAt) {
    this.createdAt = createdAt;
  }

  String? getCreatedAt() {
    return this.createdAt;
  }

  //更新时间
  String? updatedAt;

  void setUpdatedAt(String updatedAt) {
    this.updatedAt = updatedAt;
  }

  String? getUpdatedAt() {
    return this.updatedAt;
  }

  //唯一标志
  @JsonKey(name: '_id')
  String? objectId;

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  String? getObjectId() {
    return this.objectId;
  }

  // BmobObject();

  Map<String, dynamic> getParams();

  ///新增一条数据
  Future<MongoDbSaved?> save() async {
    Map<String, dynamic> map = getParams();
    String params = getParamsJsonFromParamsMap(map);
    Utility.print(params);
    String tableName = MongoDbUtils.getTableName(this);
    switch (tableName) {
      case "BmobInstallation":
        tableName = "_Installation";
        break;
    }
    Map<String, dynamic> responseData = await MongoDbDio.getInstance()
        .post(MongoDb.MONGODB_API_CLASSES + tableName, data: params);
    MongoDbSaved bmobSaved = MongoDbSaved.fromJson(responseData["data"]);
    return bmobSaved;
  }

  ///修改一条数据
  Future<MongoDbUpdated> update() async {
    Map<String, dynamic> map = getParams();
    String objectId = map[MongoDb.MONGODB_PROPERTY_OBJECT_ID];
    if (objectId.isEmpty || objectId == null) {
      MongoDbError bmobError =
          new MongoDbError(MongoDb.MONGODB_ERROR_CODE_LOCAL, MongoDb.MONGODB_ERROR_OBJECT_ID);
      throw bmobError;
    } else {
      String params = getParamsJsonFromParamsMap(map);
      Utility.print(params);
      String tableName = MongoDbUtils.getTableName(this);
      Map<String, dynamic> responseData = await MongoDbDio.getInstance().put(
          MongoDb.MONGODB_API_CLASSES + tableName + MongoDb.MONGODB_API_SLASH + objectId,
          data: params);
      MongoDbUpdated bmobUpdated = MongoDbUpdated.fromJson(responseData);
      return bmobUpdated;
    }
  }

  ///删除一条数据
  Future<MongoDbHandled> delete() async {
    Map<String, dynamic> map = getParams();
    String objectId = map[MongoDb.MONGODB_PROPERTY_OBJECT_ID];
    if (objectId.isEmpty || objectId == null) {
      MongoDbError bmobError =
          new MongoDbError(MongoDb.MONGODB_ERROR_CODE_LOCAL, MongoDb.MONGODB_ERROR_OBJECT_ID);
      throw bmobError;
    } else {
      String tableName = MongoDbUtils.getTableName(this);
      Map<String, dynamic> responseData = await MongoDbDio.getInstance().delete(
          MongoDb.MONGODB_API_CLASSES + tableName + MongoDb.MONGODB_API_SLASH + objectId);
      MongoDbHandled bmobHandled = MongoDbHandled.fromJson(responseData);
      return bmobHandled;
    }
  }

  ///删除某条数据的某个字段的值
  Future<MongoDbUpdated> deleteFieldValue(String fieldName) async {
    Map<String, dynamic> map = getParams();
    String objectId = map[MongoDb.MONGODB_PROPERTY_OBJECT_ID];
    if (objectId.isEmpty || objectId == null) {
      MongoDbError bmobError =
          new MongoDbError(MongoDb.MONGODB_ERROR_CODE_LOCAL, MongoDb.MONGODB_ERROR_OBJECT_ID);
      throw bmobError;
    } else {
      String tableName = MongoDbUtils.getTableName(this);
      Map<String, String> delete = Map();
      delete['__op'] = 'Delete';
      Map<String, dynamic> params = Map();
      params[fieldName] = delete;
      String body = json.encode(params);
      Map<String, dynamic> responseData = await MongoDbDio.getInstance().put(
          MongoDb.MONGODB_API_CLASSES + tableName + MongoDb.MONGODB_API_SLASH + objectId,
          data: "$body");
      MongoDbUpdated bmobUpdated = MongoDbUpdated.fromJson(responseData);
      return bmobUpdated;
    }
  }

  ///获取请求参数，去掉服务器生成的字段值，将对象类型修改成pointer结构，去掉空值
  String getParamsJsonFromParamsMap(map) {
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    if(map==null){
      Utility.print("请先在继承类中实现BmobObject中的Map getParams()方法！");
    }
    map.remove(MongoDb.MONGODB_PROPERTY_OBJECT_ID);
    map.remove(MongoDb.MONGODB_PROPERTY_CREATED_AT);
    map.remove(MongoDb.MONGODB_PROPERTY_UPDATED_AT);
    map.remove(MongoDb.MONGODB_PROPERTY_SESSION_TOKEN);

    map.forEach((key, value) {
      //去除空值
      if (value != null) {
        if (value is MongoDbObject) {
          //Pointer类型
          MongoDbObject bmobObject = value;
          String? objectId = bmobObject.objectId;
          if (objectId == null) {
            data.remove(key);
          } else {
            Map pointer = new Map();
            pointer[MongoDb.MONGODB_PROPERTY_OBJECT_ID] = objectId;
            pointer[MongoDb.MONGODB_KEY_TYPE] = MongoDb.MONGODB_TYPE_POINTER;
            pointer[MongoDb.MONGODB_KEY_CLASS_NAME] = MongoDbUtils.getTableName(value as MongoDbObject);
            data[key] = pointer;
          }
        } else if (value is MongoDbDate) {
          MongoDbDate bmobDate = value;
          data[key] = bmobDate.toJson();
        } else if (value is MongoDbRelation) {
          MongoDbRelation mongoDbRelation = value;
          data[key] = mongoDbRelation.toJson();
        } else {
          //非Pointer类型
          data[key] = value;
        }
      }
    });
    //dart:convert，Map转String
    String params = json.encode(data);
    return params;
  }
}
