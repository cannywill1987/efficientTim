/// 单条候选回复。
class ReplyCandidate {
  /// 推荐回复正文。
  final String text;

  /// 生成原因（可选）。
  final String? reason;

  const ReplyCandidate({
    required this.text,
    this.reason,
  });

  /// 兼容字符串和对象两种输入结构。
  factory ReplyCandidate.fromJson(dynamic json) {
    if (json is String) {
      return ReplyCandidate(text: json);
    }
    final map = Map<String, dynamic>.from(json as Map<dynamic, dynamic>);
    return ReplyCandidate(
      text: map['text']?.toString() ?? '',
      reason: map['reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'reason': reason,
    };
  }
}

/// 风险提示条目。
class RiskNote {
  /// 风险等级（low/medium/high 等）。
  final String level;

  /// 风险说明文本。
  final String note;

  const RiskNote({
    required this.level,
    required this.note,
  });

  /// 兼容字符串和对象两种输入结构。
  factory RiskNote.fromJson(dynamic json) {
    if (json is String) {
      return RiskNote(level: 'unknown', note: json);
    }
    final map = Map<String, dynamic>.from(json as Map<dynamic, dynamic>);
    return RiskNote(
      level: map['level']?.toString() ?? 'unknown',
      note: map['note']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'note': note,
    };
  }
}

/// LLM 强制结构化输出载体。
///
/// 约定：
/// 1. `recommended` 必有。
/// 2. `alternatives/risks/followups` 可以为空数组。
/// 3. 解析时会做基础空文本过滤，降低脏数据对 UI 的影响。
class ReplyPack {
  /// 首选回复。
  final ReplyCandidate recommended;

  /// 备选回复列表。
  final List<ReplyCandidate> alternatives;

  /// 风险提示列表。
  final List<RiskNote> risks;

  /// 可继续追问的问题建议。
  final List<String> followups;

  const ReplyPack({
    required this.recommended,
    required this.alternatives,
    required this.risks,
    required this.followups,
  });

  /// 兜底空对象（避免 UI 空指针）。
  factory ReplyPack.empty() {
    return const ReplyPack(
      recommended: ReplyCandidate(text: ''),
      alternatives: <ReplyCandidate>[],
      risks: <RiskNote>[],
      followups: <String>[],
    );
  }

  /// 从 LLM JSON 反序列化，并做轻量清洗。
  factory ReplyPack.fromJson(Map<String, dynamic> json) {
    final alternativesRaw =
        json['alternatives'] as List<dynamic>? ?? <dynamic>[];
    final risksRaw = json['risks'] as List<dynamic>? ?? <dynamic>[];
    final followupsRaw = json['followups'] as List<dynamic>? ?? <dynamic>[];

    return ReplyPack(
      recommended: ReplyCandidate.fromJson(
          json['recommended'] ?? <String, dynamic>{'text': ''}),
      alternatives: alternativesRaw
          .map((dynamic e) => ReplyCandidate.fromJson(e))
          .where((ReplyCandidate e) => e.text.trim().isNotEmpty)
          .toList(),
      risks: risksRaw
          .map((dynamic e) => RiskNote.fromJson(e))
          .where((RiskNote e) => e.note.trim().isNotEmpty)
          .toList(),
      followups: followupsRaw
          .map((dynamic e) => e.toString())
          .where((String e) => e.trim().isNotEmpty)
          .toList(),
    );
  }

  /// 序列化。
  Map<String, dynamic> toJson() {
    return {
      'recommended': recommended.toJson(),
      'alternatives':
          alternatives.map((ReplyCandidate e) => e.toJson()).toList(),
      'risks': risks.map((RiskNote e) => e.toJson()).toList(),
      'followups': followups,
    };
  }
}
