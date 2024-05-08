import 'package:json_annotation/json_annotation.dart';

//此处与类名一致，由指令自动生成代码
part 'MongoDbUpdated.g.dart';


@JsonSerializable()
class MongoDbUpdated{
  bool? success;
  String? code;
  int? sysTime;
  String? message;
  dynamic? data;

  MongoDbUpdated();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbUpdated.fromJson(Map<String, dynamic> json) =>
      _$MongoDbUpdatedFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbUpdatedToJson(this);



}