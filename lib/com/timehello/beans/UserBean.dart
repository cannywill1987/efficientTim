import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';

part 'UserBean.g.dart';

@JsonSerializable(nullable: false)
class UserBean {
  String? token;
  int? gptToken=0;
  String? authorIntro; // 作者简介
  String? mobilePhoneNumber;
  String? email;
  String? uid;
  String? avatar;
  String username;
  int? level = 0; //0 普通用户 1 付费用户 todo 还没加逻辑
  int? valuePerHour = 0; //每小时赚多少钱
  int? totalFocusTime = 0;
  int? totalFocusTimeRanking = 0;
  int? localMoney = 1;
  int? appMoney = 0;
  UserBean({this.level, this.authorIntro, this.totalFocusTimeRanking = -1, this.totalFocusTime = 0, this.appMoney = 0, this.localMoney = 1, this.username = '', this.token, this.mobilePhoneNumber, this.email, this.uid, this.avatar});

  factory UserBean.fromJson(Map<String, dynamic> json) => _$UserBeanFromJson(json);
  Map<String, dynamic> toJson() => _$UserBeanToJson(this);
}