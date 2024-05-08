/**
 * 文件列表也
 */
import 'package:json_annotation/json_annotation.dart';

import '../libs/mongodb/table/MongoDbObject.dart';


part 'MgmInvitationFriendModel.g.dart';
/**
 * 字符串不能加默认值 加默认值更新update 会自动清空
 */
@JsonSerializable()
class MgmInvitationFriendModel extends MongoDbObject{
  String? uid = ''; //标题
  String? avatar;
  String? username;
  String? mobilePhoneNumber;
  String? email;
  double? coins = 0; // 邀请好友获得的虚拟币
  String? countryCode;
  int? gender; // 1男 2女

  int? update_time;
  int? create_time;
  // BmobUser author;
  MgmInvitationFriendModel();

  factory MgmInvitationFriendModel.fromJson(Map<String, dynamic> json) => _$MgmInvitationFriendModelFromJson(json);
  Map<String, dynamic> toJson() => _$MgmInvitationFriendModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

  // Person({this.firstName, this.lastName, this.dateOfBirth});
  // factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  // Map<String, dynamic> toJson() => _$PersonToJson(this);
}