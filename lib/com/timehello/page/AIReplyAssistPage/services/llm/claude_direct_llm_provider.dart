import 'dart:convert';

import 'package:dio/dio.dart';

import '../../models/reply_pack.dart';
import 'assist_llm_provider.dart';
import 'reply_json_parser.dart';

/// Claude 直连 Provider。
///
/// Claude 侧通过提示词强约束 JSON-only，随后统一走解析器兜底。
class ClaudeDirectLlmProvider implements AssistLlmProvider {
  final String apiKey;
  final String model;

  ClaudeDirectLlmProvider({
    required this.apiKey,
    required this.model,
  });

  @override
  Future<ReplyPack> generate(AssistLlmInput input) async {
    // 直连模式必须由用户在设置中提供 key。
    if (apiKey.trim().isEmpty) {
      throw const FormatException('Claude API key is required');
    }

    final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 120),
      headers: <String, String>{
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
    ));

    // 与 OpenAI 保持相同提示词语义，降低双 provider 输出差异。
    final Map<String, dynamic> payload = <String, dynamic>{
      'model': model,
      'temperature': 0.2,
      'max_tokens': 1200,
      'system': '${input.systemPrompt}\n${input.developerPrompt}',
      'messages': <Map<String, String>>[
        <String, String>{
          'role': 'user',
          'content': input.userPrompt,
        }
      ],
    };

    try {
      final Response<dynamic> response = await dio
          .post('https://api.anthropic.com/v1/messages', data: payload);

      final dynamic content = response.data?['content'];
      // content 常见为数组分段，这里做统一拼接。
      final String raw = _normalizeContent(content);
      return ReplyJsonParser.parseFromRaw(raw);
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      throw FormatException(
        'Claude request failed: ${data is Map ? jsonEncode(data) : e.message}',
      );
    }
  }

  /// 兼容文本与数组分段结构。
  String _normalizeContent(dynamic content) {
    if (content == null) {
      return '';
    }
    if (content is String) {
      return content;
    }
    if (content is List) {
      final StringBuffer buffer = StringBuffer();
      for (final dynamic item in content) {
        if (item is String) {
          buffer.write(item);
        } else if (item is Map) {
          buffer.write(item['text']?.toString() ?? '');
        }
      }
      return buffer.toString();
    }
    return content.toString();
  }
}
