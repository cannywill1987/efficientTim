/**
 * 每个folderModel下有多个PushDataModelList
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import 'PushDataModel.dart';
import 'RepetiveWeekDay.dart';

part 'PushDataModelList.g.dart';

@JsonSerializable()
class PushDataModelList {
  List<PushDataModel> list = [];

  PushDataModelList() {

  }

  refresh() {
    list = [];
  }

  //此处与类名一致，由指令自动生成代码
  factory PushDataModelList.fromJson(Map<String, dynamic> json) =>
      _$PushDataModelListFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$PushDataModelListToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}