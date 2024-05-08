import 'package:json_annotation/json_annotation.dart';


//此处与类名一致，由指令自动生成代码
part 'MongoDbSaved.g.dart';


@JsonSerializable()
class MongoDbSaved{
  String? createdAt;
  @JsonKey(name: '_id')
  String? objectId;

  MongoDbSaved();

  //此处与类名一致，由指令自动生成代码
  factory MongoDbSaved.fromJson(Map<String, dynamic> json) =>
      _$MongoDbSavedFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$MongoDbSavedToJson(this);



}