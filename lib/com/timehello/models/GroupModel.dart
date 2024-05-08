/**
 * 每个folderModel下有多个missionModel
 */
//此处与类名一致，由指令自动生成代码
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/models/SubmissionModel.dart';

import '../libs/mongodb/table/MongoDbObject.dart';
import '../util/BeanParser.dart';
import '../util/Utility.dart';
import 'MissionModel.dart';
import 'RepetiveWeekDay.dart';

part 'GroupModel.g.dart';

/**
 * 一个foldermodel有多个GroupModel
 * 一个GroupModel多个MissionModel
 */
@JsonSerializable()
class GroupModel extends MongoDbObject {
  //博客内容
  String? folder_id; //folderModel的ObjectId

  //博客作者
  String? title = ''; //标题

  int? color = 0xfff7f2f9; // foldermodel的颜色

  int? order_index; //顺序，好像用不上

  String? message;

  String? device_id; //设备Id

  bool? isAdd = false;

  bool? isCheck = false;

  String? uid;

  List<String>? missionModelObjectIdOrderList = []; //用于objectId的排序

  List<MissionModel>? missionModelList = []; //用于存储missionModel

  GroupModel({this.message});

  // bool get isAdd => _isAdd ?? false;

  // String? icon = ""; //左侧图标

  // set isAdd(bool? value) {
  //   _isAdd = value;
  // }

  //此处与类名一致，由指令自动生成代码
  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
