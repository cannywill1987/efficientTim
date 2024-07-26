import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
// {"uid": LoginManager.getInstance().userBean.uid, "avatar": LoginManager.getInstance().userBean.avatar, "username": LoginManager.getInstance().userBean.username, "numTomatoesFcoused":0,"numTasksDone": 0, "totalDurationFocus": 0, "onlineStatus": 0}
part 'UserInfoBean.g.dart';

@JsonSerializable(nullable: false)
class UserInfoBean {
  String? uid;
  String? avatar;
  String? username;
  int? numTomatoesFcoused = 0;
  int? numTasksDone = 0;
  int? totalDurationFocus = 0;
  int? onlineStatus = 0;
  int? role = 0; // 0-创建者 1-管理员 2-普通用户
  @JsonKey(ignore: true)
  OnlineStatusEnum? onlineStatusEnum;

  UserInfoBean({this.uid, this.avatar, this.username, this.numTomatoesFcoused = 0, this.numTasksDone = 0, this.totalDurationFocus = 0, this.onlineStatus = 0});

  factory UserInfoBean.fromJson(Map<String, dynamic> json) => _$UserInfoBeanFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoBeanToJson(this);

}