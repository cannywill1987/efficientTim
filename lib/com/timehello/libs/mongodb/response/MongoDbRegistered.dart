import 'package:json_annotation/json_annotation.dart';


//此处与类名一致，由指令自动生成代码
part 'MongoDbRegistered.g.dart';


@JsonSerializable()
class MongoDbRegistered{
  String? createdAt;
  String? objectId;
  String? sessionToken;

  MongoDbRegistered();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbRegistered.fromJson(Map<String, dynamic> json) =>
      _$MongoDbRegisteredFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbRegisteredToJson(this);



}