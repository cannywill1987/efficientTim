import 'dart:convert';

import 'package:dio/dio.dart';

import '../../models/reply_pack.dart';
import 'assist_llm_provider.dart';
import 'reply_json_parser.dart';

/// OpenAI 直连 Provider。
///
/// 使用 `response_format=json_schema` 强制结构化输出。
class OpenAiDirectLlmProvider implements AssistLlmProvider {
  final String apiKey;
  final String model;

  OpenAiDirectLlmProvider({
    required this.apiKey,
    required this.model,
  });

  @override
  Future<ReplyPack> generate(AssistLlmInput input) async {
    // 直连模式必须由用户在设置中提供 key。
    if (apiKey.trim().isEmpty) {
      throw const FormatException('OpenAI API key is required');
    }

    final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 120),
      headers: <String, String>{
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    ));

    // 将 system/developer 合并到 system，减少模型角色差异带来的不稳定。
    final Map<String, dynamic> payload = <String, dynamic>{
      'model': model,
      'temperature': 0.2,
      'messages': <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '${input.systemPrompt}\n${input.developerPrompt}',
        },
        <String, String>{
          'role': 'user',
          'content': input.userPrompt,
        },
      ],
      // 严格 JSON schema，降低代码侧解析失败概率。
      'response_format': <String, dynamic>{
        'type': 'json_schema',
        'json_schema': <String, dynamic>{
          'name': 'reply_pack',
          'strict': true,
          'schema': _jsonSchema,
        },
      },
    };

    try {
      final Response<dynamic> response = await dio.post(
        'https://api.openai.com/v1/chat/completions',
        data: payload,
      );

      final dynamic choices = response.data?['choices'];
      if (choices is! List || choices.isEmpty) {
        throw const FormatException('OpenAI response missing choices');
      }

      final dynamic message = (choices.first as Map)['message'];
      final dynamic content = (message is Map) ? message['content'] : null;
      // content 可能是字符串，也可能是数组分段，统一标准化。
      final String raw = _normalizeContent(content);
      return ReplyJsonParser.parseFromRaw(raw);
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      throw FormatException(
        'OpenAI request failed: ${data is Map ? jsonEncode(data) : e.message}',
      );
    }
  }

  /// 兼容文本与分段结构。
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

  /// ReplyPack 对应 JSON Schema。
  static const Map<String, dynamic> _jsonSchema = <String, dynamic>{
    'type': 'object',
    'additionalProperties': false,
    'properties': <String, dynamic>{
      'recommended': <String, dynamic>{
        'type': 'object',
        'additionalProperties': false,
        'properties': <String, dynamic>{
          'text': <String, dynamic>{'type': 'string'},
          'reason': <String, dynamic>{'type': 'string'},
        },
        'required': <String>['text'],
      },
      'alternatives': <String, dynamic>{
        'type': 'array',
        'items': <String, dynamic>{
          'type': 'object',
          'additionalProperties': false,
          'properties': <String, dynamic>{
            'text': <String, dynamic>{'type': 'string'},
            'reason': <String, dynamic>{'type': 'string'},
          },
          'required': <String>['text'],
        },
      },
      'risks': <String, dynamic>{
        'type': 'array',
        'items': <String, dynamic>{
          'type': 'object',
          'additionalProperties': false,
          'properties': <String, dynamic>{
            'level': <String, dynamic>{'type': 'string'},
            'note': <String, dynamic>{'type': 'string'},
          },
          'required': <String>['level', 'note'],
        },
      },
      'followups': <String, dynamic>{
        'type': 'array',
        'items': <String, dynamic>{'type': 'string'},
      },
    },
    'required': <String>['recommended', 'alternatives', 'risks', 'followups'],
  };
}
