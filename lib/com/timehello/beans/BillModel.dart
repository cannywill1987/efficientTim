import 'package:json_annotation/json_annotation.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';

import '../libs/mongodb/table/MongoDbObject.dart';

part 'BillModel.g.dart';

@JsonSerializable(nullable: false)
class BillModel extends MongoDbObject {
  String? creditCardId; //信用卡object id
  int? status = 0; // 0 是创建 1 是更新
  int? paymentMethod = 0; // 0 银行 1 支付宝 2 微信 3 现金
  double? value = 0; // 金额 +表示存钱 -表示花钱
  double? amount = 0;
  double? billAmount = 0;
  double? repayAmount = 0;
  String? uid;
  String? device_id;
  String? product;
  Map? extendMap; //扩展字段 用于存放
  BillModel({this.value, this.amount, this.extendMap, this.paymentMethod, this.status, this.product, this.creditCardId, this.billAmount, this.repayAmount, this.uid,
      this.device_id});

  factory BillModel.fromJson(Map<String, dynamic> json) => _$BillModelFromJson(json);
  Map<String, dynamic> toJson() => _$BillModelToJson(this);

  @override
  Map<String, dynamic> getParams() {
    // TODO: implement getParams
    return toJson();
  }
}