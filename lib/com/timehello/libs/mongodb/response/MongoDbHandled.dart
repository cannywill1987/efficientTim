import 'package:json_annotation/json_annotation.dart';


//此处与类名一致，由指令自动生成代码
part 'MongoDbHandled.g.dart';


@JsonSerializable()
class MongoDbHandled{
   bool? success;
   String? code;
   int? sysTime;
   String? message;
   dynamic? data;

  MongoDbHandled();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbHandled.fromJson(Map<String, dynamic> json) =>
      _$MongoDbHandledFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbHandledToJson(this);



}