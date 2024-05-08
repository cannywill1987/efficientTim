/**
 * 每个folderModel下有多个missionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'ChatGptFolderModel.g.dart';

@JsonSerializable()
class ChatGptFolderModel extends MongoDbObject{
  String? title = ''; //标题
  String? promptTitle; //描述
  String? prompt; //描述
  String? uid;
  @JsonKey(ignore: true)
  bool? isHover = false;
  int? update_time;
  int? create_time;
  int color = 0;
  int? tagColor;

  ChatGptFolderModel();

  //此处与类名一致，由指令自动生成代码
  factory ChatGptFolderModel.fromJson(Map<String, dynamic> json) =>
      _$ChatGptFolderModelFromJson(json);
  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ChatGptFolderModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}