/**
 * 文件类型：MongoDB 数据模型
 * 文件作用：记录用户 AI 提问权益，避免 AIPage 生命周期或 WebView localStorage 重置导致次数绕过。
 * 字段约定：
 * - entitlementType 固定为 app_ai_chat，后续可扩展到其他 AI 能力。
 * - totalQuota / usedQuota / remainingQuota 是普通用户可扣减次数；VIP 用户不扣减。
 * - uid 优先作为权益归属，未登录场景退化到 device_id，便于匿名试用。
 */
import '../libs/mongodb/table/MongoDbObject.dart';

class AIUsageEntitlementModel extends MongoDbObject {
  String? uid = '';
  String? device_id = '';
  String? entitlementType = 'app_ai_chat';
  String? source = 'free_default';
  int? totalQuota = 0;
  int? usedQuota = 0;
  int? remainingQuota = 0;
  bool? defaultGranted = false;
  int? status = 1; // 1=有效，0=停用
  int? create_time;
  int? update_time;
  int? lastUsedAt;
  int? expire_time;

  AIUsageEntitlementModel();

  factory AIUsageEntitlementModel.fromJson(Map<String, dynamic> json) {
    return AIUsageEntitlementModel()
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..uid = json['uid'] as String?
      ..device_id = json['device_id'] as String?
      ..entitlementType = json['entitlementType'] as String?
      ..source = json['source'] as String?
      ..totalQuota = _intOrNull(json['totalQuota'])
      ..usedQuota = _intOrNull(json['usedQuota'])
      ..remainingQuota = _intOrNull(json['remainingQuota'])
      ..defaultGranted = json['defaultGranted'] as bool?
      ..status = _intOrNull(json['status'])
      ..create_time = _intOrNull(json['create_time'])
      ..update_time = _intOrNull(json['update_time'])
      ..lastUsedAt = _intOrNull(json['lastUsedAt'])
      ..expire_time = _intOrNull(json['expire_time']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '_id': objectId,
        'uid': uid,
        'device_id': device_id,
        'entitlementType': entitlementType,
        'source': source,
        'totalQuota': totalQuota,
        'usedQuota': usedQuota,
        'remainingQuota': remainingQuota,
        'defaultGranted': defaultGranted,
        'status': status,
        'create_time': create_time,
        'update_time': update_time,
        'lastUsedAt': lastUsedAt,
        'expire_time': expire_time,
      };

  @override
  Map<String, dynamic> getParams() {
    return toJson();
  }

  static int? _intOrNull(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }
}
