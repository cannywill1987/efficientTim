//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'ColorsModel.g.dart';


@JsonSerializable()
class ColorsModel extends MongoDbObject{

  //博客标题
  String? title;
  //博客内容
  int color = 0;

  String? code;
  ColorsModel();

  //此处与类名一致，由指令自动生成代码
  factory ColorsModel.fromJson(Map<String, dynamic> json) =>
      _$ColorsModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ColorsModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


}