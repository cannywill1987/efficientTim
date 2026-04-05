import 'dart:convert';

import '../../models/reply_pack.dart';

/// ReplyPack JSON 解析器。
///
/// 兼容常见脏输出：
/// - markdown code fence 包裹
/// - JSON 前后混入解释文本
class ReplyJsonParser {
  /// 从原始文本中提取 JSON 并解析成 ReplyPack。
  static ReplyPack parseFromRaw(String raw) {
    final String jsonText = _extractJsonObject(raw);
    final dynamic decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('LLM output is not a JSON object');
    }
    return ReplyPack.fromJson(decoded);
  }

  /// 提取第一个完整 JSON 对象文本。
  ///
  /// 策略：
  /// 1. 先去掉 markdown fence
  /// 2. 再按首尾 `{}` 截取
  static String _extractJsonObject(String raw) {
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('LLM output is empty');
    }

    String candidate = trimmed;
    if (candidate.startsWith('```')) {
      candidate = candidate
          .replaceFirst(RegExp(r'^```[a-zA-Z0-9_-]*\n?'), '')
          .replaceFirst(RegExp(r'```\s*$'), '')
          .trim();
    }

    final int start = candidate.indexOf('{');
    final int end = candidate.lastIndexOf('}');
    if (start == -1 || end == -1 || end <= start) {
      throw const FormatException('No JSON object found in LLM output');
    }
    return candidate.substring(start, end + 1);
  }
}
