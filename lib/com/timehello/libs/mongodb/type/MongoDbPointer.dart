import 'package:json_annotation/json_annotation.dart';

part 'MongoDbPointer.g.dart';

@JsonSerializable()
class MongoDbPointer {
  factory MongoDbPointer.fromJson(Map<String, dynamic> json) =>
      _$MongoDbPointerFromJson(json);

  Map<String, dynamic> toJson() => _$MongoDbPointerToJson(this);

  @JsonKey(name: "__type")
  String? type = "Pointer";
  String? className;
  String? objectId;

  MongoDbPointer();
}
