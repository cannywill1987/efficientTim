// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreditCardModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardModel _$CreditCardModelFromJson(Map<String, dynamic> json) =>
    CreditCardModel(
      bankId: json['bankId'] as String?,
      bankName: json['bankName'] as String?,
      logoUrl: json['logoUrl'] as String?,
      billDay: (json['billDay'] as num?)?.toInt(),
      cardId: json['cardId'] as String?,
      repayDay: (json['repayDay'] as num?)?.toInt(),
      servicePhone: json['servicePhone'] as String?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..name = json['name'] as String?
      ..creditAmount = (json['creditAmount'] as num?)?.toInt()
      ..repaymentData = json['repaymentData'] as List<dynamic>?
      ..eventList = json['eventList'] as List<dynamic>?
      ..uid = json['uid'] as String?
      ..device_id = json['device_id'] as String?;

Map<String, dynamic> _$CreditCardModelToJson(CreditCardModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'bankId': instance.bankId,
      'bankName': instance.bankName,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'billDay': instance.billDay,
      'cardId': instance.cardId,
      'repayDay': instance.repayDay,
      'creditAmount': instance.creditAmount,
      'servicePhone': instance.servicePhone,
      'repaymentData': instance.repaymentData,
      'eventList': instance.eventList,
      'uid': instance.uid,
      'device_id': instance.device_id,
    };
