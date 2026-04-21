import 'roi.dart';

/// 单个助手配置档（Profile）。
///
/// 一个 Profile 对应一套微信窗口布局参数：
/// - 聊天区域 ROI
/// - 输入框 ROI
/// - OCR 语言
/// - 清洗后的最大上下文条数
class AssistProfile {
  /// Profile 唯一标识（本地持久化用）。
  final String id;

  /// Profile 显示名称。
  final String name;

  /// 聊天截图裁剪区域。
  final Roi chatRoi;

  /// 输入框定位区域（F4 粘贴用其中心点）。
  final Roi inputRoi;

  /// OCR 语言（Vision 识别语言代码）。
  final String ocrLang;

  /// 保留的最近对话条数上限。
  final int maxTurns;

  const AssistProfile({
    required this.id,
    required this.name,
    required this.chatRoi,
    required this.inputRoi,
    required this.ocrLang,
    required this.maxTurns,
  });

  /// 创建默认 Profile（MVP 首次启动使用）。
  factory AssistProfile.defaultProfile() {
    return const AssistProfile(
      id: 'default-profile',
      name: 'Default',
      chatRoi: Roi(x: 180, y: 130, w: 840, h: 960),
      inputRoi: Roi(x: 300, y: 1120, w: 700, h: 90),
      ocrLang: 'zh-Hans',
      maxTurns: 12,
    );
  }

  /// 从本地 JSON 反序列化。
  factory AssistProfile.fromJson(Map<String, dynamic> json) {
    return AssistProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Profile',
      chatRoi: Roi.fromJson(Map<String, dynamic>.from(json['chatRoi'] ?? {})),
      inputRoi: Roi.fromJson(Map<String, dynamic>.from(json['inputRoi'] ?? {})),
      ocrLang: json['ocrLang']?.toString() ?? 'zh-Hans',
      maxTurns: (json['maxTurns'] as num?)?.toInt() ?? 12,
    );
  }

  /// 序列化到本地 JSON。
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chatRoi': chatRoi.toJson(),
      'inputRoi': inputRoi.toJson(),
      'ocrLang': ocrLang,
      'maxTurns': maxTurns,
    };
  }

  /// 不可变对象常用 copyWith。
  AssistProfile copyWith({
    String? id,
    String? name,
    Roi? chatRoi,
    Roi? inputRoi,
    String? ocrLang,
    int? maxTurns,
  }) {
    return AssistProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      chatRoi: chatRoi ?? this.chatRoi,
      inputRoi: inputRoi ?? this.inputRoi,
      ocrLang: ocrLang ?? this.ocrLang,
      maxTurns: maxTurns ?? this.maxTurns,
    );
  }
}
