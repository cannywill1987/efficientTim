import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import '../models/SharePreferenceModel.dart';

class CloudSharepreferenceManagement {
  static CloudSharepreferenceManagement? mCloudSharepreferenceManagement;
  CloudSharepreferenceManagement();


  static CloudSharepreferenceManagement getInstance() {
    if (mCloudSharepreferenceManagement == null) {
      mCloudSharepreferenceManagement = new CloudSharepreferenceManagement();
    }
    return mCloudSharepreferenceManagement!;
  }

  init() {
    return mCloudSharepreferenceManagement;
  }

  setBool(String key, bool value) async {
    List<SharePreferenceModel>?  val = MongoApisManager.getInstance().get_SharePrefenceModel(key: key);
    if (val != null && val.length > 0) {
      val[0].boolVal = value ;
      await MongoApisManager.getInstance().update_SharePrefenceModel(objectId: val[0].objectId, key: key, valueBool: value);
    } else {
      await MongoApisManager.getInstance().insert_SharePrefenceModel( key: key, valueBool: value);
    }
  }

  /**
   * 断网请用try catch捕获
   */
  bool getBool(String key, [bool defaultVal = false])  {
    List<SharePreferenceModel>?  val;
    try {
        val = MongoApisManager.getInstance()
          .get_SharePrefenceModel(key: key);
    } catch(e) {
      throw "no network";
    }
    if (val != null && val.length > 0) {
      return  val[0].boolVal ?? defaultVal;
    } else {
      return defaultVal;
    }
  }

  setArray(String key, List value) async {
    List<SharePreferenceModel>?  val = MongoApisManager.getInstance().get_SharePrefenceModel(key: key);
    if (val != null && val.length > 0) {
      val[0].arrayVal = value ;
      await MongoApisManager.getInstance().update_SharePrefenceModel(objectId: val[0].objectId, key: key, valueArray: value);
    } else {
      await MongoApisManager.getInstance().insert_SharePrefenceModel( key: key, valueArray: value);
    }
  }

  /**
   * 断网请用try catch捕获
   */
  List getArray(String key, [List? defaultVal])  {
    if (defaultVal == null) {
      defaultVal = [];
    }
    List<SharePreferenceModel>?  val;
    try {
      val =  MongoApisManager.getInstance()
          .get_SharePrefenceModel(key: key);
    } catch(e) {
      throw "no network";
    }
    if (val != null && val.length > 0) {
      return  val[0].arrayVal ?? defaultVal;
    } else {
      return defaultVal;
    }
  }

  setString(String key, String value) async{
    List<SharePreferenceModel>?  val = MongoApisManager.getInstance().get_SharePrefenceModel(key: key);
    if (val != null && val.length > 0) {
      val[0].stringVal = value ;
      await MongoApisManager.getInstance().update_SharePrefenceModel(objectId: val[0].objectId, key: key, valueString: value);
    } else {
      await MongoApisManager.getInstance().insert_SharePrefenceModel( key: key, valueString: value);
    }
  }

  /**
   * 断网请用try catch捕获
   */
  String getString(String key, [String defaultVal = ""]) {
    List<SharePreferenceModel>?  val;
    try {
      val =  MongoApisManager.getInstance()
          .get_SharePrefenceModel(key: key);
    } catch(e) {
      throw "no network";
    }
    if (val != null && val.length > 0) {
      return  val[0].stringVal ?? defaultVal;
    } else {
      return defaultVal;
    }
  }


  setInt(String key, int value) async{
    List<SharePreferenceModel>?  val = MongoApisManager.getInstance().get_SharePrefenceModel(key: key);
    if (val != null && val.length > 0) {
      val[0].intVal = value ;
      await MongoApisManager.getInstance().update_SharePrefenceModel(objectId: val[0].objectId, key: key, valueInt: value);
    } else {
      await MongoApisManager.getInstance().insert_SharePrefenceModel( key: key, valueInt: value);
    }
  }

  /**
   * 断网请用try catch捕获
   */
  int getInt(String key, [int defaultVal = 0])  {
    List<SharePreferenceModel>?  val;
    try {
      val = MongoApisManager.getInstance()
          .get_SharePrefenceModel(key: key);
    } catch(e) {
      throw "no network";
    }
    if (val != null && val.length > 0) {
      return  val[0].intVal ?? defaultVal;
    } else {
      return defaultVal;
    }
  }
}
