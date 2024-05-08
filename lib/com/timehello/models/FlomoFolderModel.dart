/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'FlomoFolderModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class FlomoFolderModel extends MongoDbObject{
  int? order_index;
  String? title = ''; //标题
  String? description; //描述
  String? device_id; //设备id 用于没用登录时的搜索
  int? number;
  String? uid;
  String? noteUrl; //笔记url
  int? update_time;
  int? create_time;
  int? tag; //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来
  int color = 0;
  int? tagColor;
  int? icon = 0; //左侧图标
  // bool hasTag = false; //是否有标签
  String? tagName; //标签名称
  int? iconType = 0; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他
  // BmobUser author;
  FlomoFolderModel();

  factory FlomoFolderModel.fromJson(Map<String, dynamic> json) => _$FlomoFolderModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlomoFolderModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }


  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}