import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

//此处与类名一致，由指令自动生成代码
part 'MongoDbError.g.dart';

@JsonSerializable()
class MongoDbError extends Error {
  int code;
  String error;

  MongoDbError(this.code, this.error);

  //此处与类名一致，由指令自动生成代码
  factory MongoDbError.fromJson(Map<String, dynamic> json) =>
      _$MongoDbErrorFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbErrorToJson(this);

  String toString() => "MongoDbError [$code]:" + error;

  //转化DioError错误为MongoDbError类型
  static MongoDbError? convert(e) {
    MongoDbError? mongoDbError;

    if (e is MongoDbError) {
      mongoDbError = e;
    } else if (e is DioError) {
      DioError dioError = e;
      switch (dioError.type) {
        case DioErrorType.sendTimeout:
          mongoDbError = MongoDbError(9015, dioError.message ?? "");
          break;
        case DioErrorType.unknown:
          mongoDbError = MongoDbError(9015, dioError.message ?? "");
          break;
        case DioErrorType.cancel:
          mongoDbError = MongoDbError(9015, dioError.message ?? "");
          break;
        case DioErrorType.receiveTimeout:
          mongoDbError = MongoDbError(9015, dioError.message ?? "");
          break;
        case DioErrorType.badResponse:
          mongoDbError = MongoDbError(
              dioError.response?.data?['code'] ?? "", dioError.response?.data['error'] ?? "");
          break;
        case DioErrorType.connectionTimeout:
          mongoDbError = MongoDbError(9015, dioError.message ?? "");
          break;
      }
    } else {
      mongoDbError = MongoDbError(9015, e.toString());
    }

    return mongoDbError;
  }
}
