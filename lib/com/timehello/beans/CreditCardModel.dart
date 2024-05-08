import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'CreditCardModel.g.dart';

@JsonSerializable(nullable: false)
class CreditCardModel extends MongoDbObject {
  String? bankId;
  String? bankName;
  String? name;
  String? logoUrl;
  int? billDay;
  String? cardId; //卡id 0000
  int? repayDay;
  int? creditAmount = 0;
  String? servicePhone;
  List? repaymentData = []; //还款数据 [{month:"2023-01-01", bill: 1,amount: 12, repaymentStatus: 0}] 还款状态 repaymentStatus 0 未还款 1 逾期 2 已还款 bill 账单 还款状态 repaymentStatus 0 未还款 1 逾期 2 已还款 这个应该没有用
  List? eventList = []; //事件列表 [{{eventType: "", value1: }] 事件
  String? uid;
  String? device_id;

  CreditCardModel({this.bankId, this.bankName, this.logoUrl, this.billDay,
      this.cardId, this.repayDay,
      this.servicePhone}); // CreditCardModel({this.level, this.authorIntro, this.totalFocusTimeRanking = -1, this.totalFocusTime = 0, this.appMoney = 0, this.localMoney = 1, this.username = '', this.token, this.mobilePhoneNumber, this.email, this.uid, this.avatar});

  factory CreditCardModel.fromJson(Map<String, dynamic> json) => _$CreditCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreditCardModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }

}