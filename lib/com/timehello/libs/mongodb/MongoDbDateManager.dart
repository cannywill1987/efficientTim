
import 'package:time_hello/com/timehello/libs/mongodb/MongoDbDio.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/server_time.dart';


import 'MongoDb.dart';

class MongoDbDateManager {
  ///查询服务器时间
  static Future<ServerTime> getServerTimestamp() async {
    Map<String, dynamic> data = await MongoDbDio.getInstance()
        .get(MongoDb.MONGODB_API_VERSION + MongoDb.MONGODB_API_TIMESTAMP);
    ServerTime serverTime = ServerTime.fromJson(data);
    return serverTime;
  }
}
