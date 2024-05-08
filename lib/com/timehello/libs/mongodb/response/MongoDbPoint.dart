import 'package:json_annotation/json_annotation.dart';


//此处与类名一致，由指令自动生成代码
part 'MongoDbPoint.g.dart';


@JsonSerializable()
class MongoDbPointer{
  String? __type;
  String? className;
  String? objectId;

  MongoDbPointer();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbPointer.fromJson(Map<String, dynamic> json) =>
      _$MongoDbPointerFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbPointerToJson(this);



}