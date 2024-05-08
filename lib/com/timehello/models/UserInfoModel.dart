/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'UserInfoModel.g.dart';

/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class UserInfoModel extends MongoDbObject{
  int? coins; // 当前金币 敏感数据 设置为Null 没有，一定要从服务器拉取数据
  //邀请好友列表
  List? inviteFriends; // 邀请用户Uid, 奖励金额 coins, 手机号缩写 phone updatedAt

  String? uid;

  // BmobUser author;
  UserInfoModel();

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}