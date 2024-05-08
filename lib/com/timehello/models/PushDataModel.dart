/**
 * 每个folderModel下有多个PushDataModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import 'RepetiveWeekDay.dart';

part 'PushDataModel.g.dart';

@JsonSerializable()
class PushDataModel {
  //博客标题
  //博客内容
  String title;
  //博客作者
  String content = '';

  String? summaryText = '';

  int whenMilliseconds = -1;

  String id;


  PushDataModel({required this.title, required this.content, this.summaryText,
      required this.whenMilliseconds, required this.id});


  //此处与类名一致，由指令自动生成代码
  factory PushDataModel.fromJson(Map<String, dynamic> json) =>
      _$PushDataModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$PushDataModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}