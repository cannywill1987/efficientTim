// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillModel _$BillModelFromJson(Map<String, dynamic> json) => BillModel(
      value: (json['value'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      extendMap: json['extendMap'] as Map<String, dynamic>?,
      paymentMethod: json['paymentMethod'] as int?,
      status: json['status'] as int?,
      product: json['product'] as String?,
      creditCardId: json['creditCardId'] as String?,
      billAmount: (json['billAmount'] as num?)?.toDouble(),
      repayAmount: (json['repayAmount'] as num?)?.toDouble(),
      uid: json['uid'] as String?,
      device_id: json['device_id'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?;

Map<String, dynamic> _$BillModelToJson(BillModel instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'creditCardId': instance.creditCardId,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'value': instance.value,
      'amount': instance.amount,
      'billAmount': instance.billAmount,
      'repayAmount': instance.repayAmount,
      'uid': instance.uid,
      'device_id': instance.device_id,
      'product': instance.product,
      'extendMap': instance.extendMap,
    };
