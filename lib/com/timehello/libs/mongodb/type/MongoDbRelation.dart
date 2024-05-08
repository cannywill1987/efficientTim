
import 'package:json_annotation/json_annotation.dart';
import '../MongoDbUtils.dart';

import '../response/MongoDbPoint.dart';
import '../table/MongoDbObject.dart';

part 'MongoDbRelation.g.dart';

@JsonSerializable()
class MongoDbRelation {
  factory MongoDbRelation.fromJson(Map<String, dynamic> json) =>
      _$MongoDbRelationFromJson(json);

  Map<String, dynamic> toJson() => _$MongoDbRelationToJson(this);

  @JsonKey(name: "__op")
  String? op;

  //关联关系列表
  List<Map<String, dynamic>>? objects;

  MongoDbRelation() {
    objects = [];
  }

  //添加某个关联关系
  void add(MongoDbObject value) {
    op = "AddRelation";
    MongoDbPointer bmobPointer = MongoDbPointer();
    bmobPointer.className = MongoDbUtils.getTableName(value);
    bmobPointer.objectId = value.objectId!;
    objects!.add(bmobPointer.toJson());
  }

  //移除某个关联关系
  void remove(MongoDbObject value) {
    op = "RemoveRelation";
    MongoDbPointer bmobPointer = MongoDbPointer();
    bmobPointer.className = MongoDbUtils.getTableName(value);
    bmobPointer.objectId = value.objectId!;
    objects!.add(bmobPointer.toJson());
  }
}
