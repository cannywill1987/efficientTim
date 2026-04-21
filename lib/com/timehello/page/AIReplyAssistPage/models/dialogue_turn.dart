/// 对话条目（为后续“角色识别”预留的数据结构）。
///
/// 当前 MVP 主要以纯文本 messages 驱动 LLM，
/// `role` 先保留为可扩展字段（customer/agent/unknown）。
class DialogueTurn {
  /// 说话角色。
  final String role;

  /// 文本内容。
  final String text;

  const DialogueTurn({
    required this.role,
    required this.text,
  });

  /// 从 JSON 反序列化。
  factory DialogueTurn.fromJson(Map<String, dynamic> json) {
    return DialogueTurn(
      role: json['role']?.toString() ?? 'unknown',
      text: json['text']?.toString() ?? '',
    );
  }

  /// 序列化。
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
    };
  }
}
