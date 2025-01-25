import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbResults.dart';
import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';

import '../../util/DeviceInfoManagement.dart';
import '../../util/Utility.dart';
import 'MongoDb.dart';
import 'MongoDbDio.dart';

part 'MongoDbQuery.g.dart';

@JsonSerializable()
class MongoDbQuery<T> {
  factory MongoDbQuery.fromJson(Map<String, dynamic> json) =>
      _$MongoDbQueryFromJson(json);

  Map<String, dynamic> toJson() => _$MongoDbQueryToJson(this);

  String? include;
  int? limit;
  int? skip;
  String? order;
  int? orderValue = 1; // 排序顺序 如果是时间，-1 则是最新时开始 1 最远时间开始
  int? count;

  String? c;

  Map<String, dynamic>? where;

  Map<String, dynamic>? having;

  /// 统计查询
  String? groupby;
  String? sum;
  String? average;
  String? max;
  String? min;
  bool? groupcount;

  MongoDbQuery() {
    where = Map();
    having = Map();
  }


  //添加等于条件查询
  MongoDbQuery addWhereEqualTo(String key, Object value) {
    addCondition(key, null, value);
    return this;
  }

  //添加不等于查询
  MongoDbQuery addWhereNotEqualTo(String key, Object value) {
    addCondition(key, "\$ne", value);
    return this;
  }

  //添加小于查询
  MongoDbQuery addWhereLessThan(String key, Object value) {
    addCondition(key, "\$lt", value);
    return this;
  }

  //添加小于等于查询
  MongoDbQuery addWhereLessThanOrEqualTo(String key, Object value) {
    addCondition(key, "\$lte", value);
    return this;
  }

  //添加大于查询
  MongoDbQuery addWhereGreaterThan(String key, Object value) {
    addCondition(key, "\$gt", value);
    return this;
  }

  //添加大于等于查询
  MongoDbQuery addWhereGreaterThanOrEqualTo(String key, Object value) {
    addCondition(key, "\$gte", value);
    return this;
  }


  //复合查询条件or
  MongoDbQuery or(List<MongoDbQuery<T>> queries){
    List<Map<String, dynamic>> list = [];
    for(MongoDbQuery<T> bmobQuery in queries){
      list.add(bmobQuery.where!);
    }
    addCondition("\$or", null,list);
    return this;
  }


  //复合查询条件and
  MongoDbQuery and(List<MongoDbQuery<T>> queries) {
    List<Map<String, dynamic>> list = [];
    for(MongoDbQuery<T> bmobQuery in queries){
      list.add(bmobQuery.where!);
    }
    addCondition("\$and", null, list);
    return this;
  }


  MongoDbQuery addWhereContains(String key, Object value) {
    String regex = "\\Q"+value.toString()+"\\E";
    addWhereMatches(key, regex);
    return this;
  }

  void addWhereMatches(String key, String regex) {
    addCondition(key, "\$regex", regex);
  }


  MongoDbQuery addWhereExists(String key) {
    addCondition(key, "\$exists", true);
    return this;
  }
  MongoDbQuery addWhereDoesNotExists(String key) {
    addCondition(key, "\$exists", false);
    return this;
  }



  ///是否返回统计的记录个数
  MongoDbQuery hasGroupCount(bool has) {
    this.groupcount = has;
    return this;
  }

  ///分组 多个分组的列名
  MongoDbQuery groupByKeys(String keys) {
    this.groupby = keys;
    return this;
  }

  ///求和  多个求和的列名
  MongoDbQuery sumKeys(String keys) {
    this.sum = keys;
    return this;
  }

  ///求均值 多个求平均值的列名
  MongoDbQuery averageKeys(String keys) {
    this.average = keys;
    return this;
  }

  ///求最大值 多个求最大值的列名
  MongoDbQuery maxKeys(String keys) {
    this.max = keys;
    return this;
  }

  ///求最小值 多个求最小值的列名
  MongoDbQuery minKeys(String keys) {
    this.min = keys;
    return this;
  }

  ///获取数据个数
  Future<int> queryCount() async {
    this.count = 1;
    this.limit = 0;

    String tableName = T.toString();
    String url = MongoDb.MONGODB_API_CLASSES + tableName;
    url = url + "?";
    if (where != null && where!.isNotEmpty) {
      url = url + "where=" + json.encode(where);
    }
    Map<String, dynamic> map = await MongoDbDio.getInstance().get(url, data: getParams());
    Utility.print(map);
    MongoDbResults mongoDbResults = MongoDbResults.fromJson(map);
    return mongoDbResults.count!;
  }

  ///添加分组过滤条件
  MongoDbQuery havingFilter(Map<String, dynamic> having) {
    this.having = having;
    return this;
  }

  String addStatistics(String key, Object value) {
    if (value == null) {
      return "";
    }
    String params = "";
    if (value is String) {
      String str = value;
      params = key + "=" + str + "&";
    } else if (value is Map) {
      Map map = value;
      if (map.isNotEmpty) {
        params = key + "=" + json.encode(map) + "&";
      }
    }
    return params;
  }

  String getStatistics() {
    String statistics = "";
    if(this.sum != null) {
      statistics += addStatistics("sum", this.sum ?? "");
    }
    if(this.max != null) {
      statistics += addStatistics("max", this.max ?? "");
    }
    if(this.min != null) {
      statistics += addStatistics("min", this.min ?? "");
    }
    if(this.average != null) {
      statistics += addStatistics("average", this.average ?? "");
    }
    if(this.groupby != null) {
      statistics += addStatistics("groupby", this.groupby ?? "");
    }
    if(this.having != null) {
      statistics += addStatistics("having", this.having ?? "");
    }
    if(this.groupcount != null) {
      statistics += addStatistics("groupcount", this.groupcount ?? "");
    }
    return statistics;
  }

  void addCondition(String key, String? condition, Object? value) {
    if (condition == null) {
      if (value is MongoDbObject) {
        MongoDbObject bmobObject = value;
        Map<String, dynamic> map = new Map();
        map["__type"] = "Pointer";
        map["objectId"] = bmobObject.objectId;
        map["className"] = value.runtimeType.toString();
        where![key] = map;
      } else {
        where![key] = value;
      }
    } else {
      if (value is MongoDbObject) {
        MongoDbObject bmobObject = value;
        Map<String, dynamic> map = new Map();
        map["__type"] = "Pointer";
        map["objectId"] = bmobObject.objectId;
        map["className"] = value.runtimeType.toString();

        Map<String, dynamic> map1 = new Map();
        map1[condition] = map;
        where![key] = map1;
      } else {
        Map<String, dynamic> map = new Map();
        map[condition] = value;
        where![key] = map;
      }
    }
  }

  //查询关联字段
  MongoDbQuery setInclude(String value) {
    include = value;
    return this;
  }

  //按字段排序
  MongoDbQuery setOrderValue(int value) {
    orderValue = value;
    return this;
  }

  //按字段排序
  MongoDbQuery setOrder(String value) {
    order = value;
    return this;
  }

  //返回条数
  MongoDbQuery setLimit(int value) {
    limit = value;
    return this;
  }

  //忽略条数
  MongoDbQuery setSkip(int value) {
    skip = value;
    return this;
  }

  ///查询单条数据
  Future<dynamic> queryUser(objectId) async {
    return queryObjectByTableName(objectId, "_User");
  }

  ///查询单条数据
  Future<dynamic> queryInstallation(objectId) async {
    return queryObjectByTableName(objectId, "_Installation");
  }

  ///查询单条数据
  Future<dynamic> queryObject(objectId) async {
    String tableName = T.toString();
    Map res = await queryObjectByTableName(objectId, tableName);
    return res['data'];
  }

  ///查询单条数据
  Future<dynamic> queryObjectByTableName(objectId, String tableName) async {
//    String tableName = T.toString();
//    if (T.runtimeType is BmobUser) {
//      tableName = "_User";
//    } else if (T.runtimeType is BmobInstallation) {
//      tableName = "_Installation";
//    }
    return MongoDbDio.getInstance().get(
        MongoDb.MONGODB_API_CLASSES + tableName + MongoDb.MONGODB_API_SLASH + objectId,
        data: getParams());
  }

  ///查询多条数据
  Future<List<dynamic>> queryUsers() async {
    return queryObjectsByTableName("_User");
  }

  ///查询多条数据
  Future<List<dynamic>> queryInstallations() async {
    return queryObjectsByTableName("_Installation");
  }

  ///查询多条数据
  Future<List<dynamic>> queryObjects() async {
    String tableName = T.toString().replaceAll("\$", "");
    return queryObjectsByTableName(tableName);
  }

  ///查询多条数据
  Future<List<dynamic>> queryObjectsByTableName(String tableName) async {
//    String tableName = T.toString();
//    if (T.runtimeType is BmobUser) {
//      tableName = "_User";
//    } else if (T.runtimeType is BmobInstallation) {
//      tableName = "_Installation";
//    }

    String url = MongoDb.MONGODB_API_CLASSES + tableName;
    if (where!.isNotEmpty) {
      url = url + "?";
      url = url + "where=" + json.encode(where);
    }
    url = url + getStatistics();
    Map<String, dynamic> map = await MongoDbDio.getInstance().get(url, data: getParams()) ?? {};
    MongoDbResults mongoDbResults = MongoDbResults.fromJson(map["data"] ?? {});
    Utility.print(mongoDbResults.results);
    return mongoDbResults.results ?? [];
  }

  ///获取请求参数
  Map getParams() {
    Map map = toJson();
    Map params = toJson();
    map.forEach((k, v) {
      if (v == null) {
        params.remove(k);
      }
    });
    return params;
  }
}
