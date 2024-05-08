


import 'package:time_hello/com/timehello/libs/mongodb/table/MongoDbObject.dart';


class MongoDbUtils {
  ///获取BmobObject对象的表名
  static String getTableName(MongoDbObject object) {
    // if (!(object is MongoDb)) {
    //   throw new BmobError(1002, "The object is not a BmobObject.");
    // }
    // String tableName;
    // if (object is BmobUser) {
    //   tableName = Bmob.BMOB_TABLE_USER;
    // } else if (object is BmobInstallation) {
    //   tableName = Bmob.BMOB_TABLE_INSTALLATION;
    // } else if (object is BmobRole) {
    //   tableName = Bmob.BMOB_TABLE_TOLE;
    // } else {
    String tableName = object.runtimeType.toString();
    // }
    //替换掉本身$
    tableName = tableName.replaceAll("\$", "");
    return tableName;
  }
}
