import 'dart:convert';

import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../models/reply_pack.dart';
import 'assist_llm_provider.dart';
import 'reply_json_parser.dart';

/// 后端代理模式 Provider。
///
/// 走现有接口 `Apis.chatGptWithOpenAi`，避免前端直接暴露第三方密钥。
class BackendProxyLlmProvider implements AssistLlmProvider {
  @override
  Future<ReplyPack> generate(AssistLlmInput input) async {
    // 按 OpenAI 风格消息结构透传给后端。
    final List<Map<String, String>> messages = <Map<String, String>>[
      <String, String>{'role': 'system', 'content': input.systemPrompt},
      <String, String>{'role': 'developer', 'content': input.developerPrompt},
      <String, String>{'role': 'user', 'content': input.userPrompt},
    ];

    final String textRes = await HttpManager.getInstance().doStreamRequest(
      Apis.chatGptWithOpenAi,
      CONNECT_TIMEOUT: 180000,
      RECEIVE_TIMEOUT: 180000,
      shouldShowErrorToast: false,
      params: <String, dynamic>{
        'scene': 'ai_reply_assist',
        'messages': messages,
      },
    );

    // 工程内已有“流式文本提取”逻辑，这里复用 Utility.extractContent。
    final dynamic extracted = Utility.extractContent(textRes);
    Map<String, dynamic>? response;
    if (extracted is Map<String, dynamic>) {
      response = extracted;
    } else if (extracted is Map) {
      response = Map<String, dynamic>.from(extracted);
    }
    if (response == null) {
      throw const FormatException('Backend response parse failed');
    }

    // 兼容 choices/message/content 与直接对象两类返回。
    final dynamic choices = response['choices'];
    dynamic rawContent;
    if (choices is List && choices.isNotEmpty) {
      final dynamic first = choices.first;
      if (first is Map) {
        rawContent = first['content'] ??
            (first['message'] is Map
                ? (first['message'] as Map)['content']
                : null);
      }
    }

    if (rawContent == null && response.containsKey('recommended')) {
      return ReplyPack.fromJson(response);
    }

    // 标准路径：把内容标准化后再走统一 JSON 解析器。
    final String normalized = _normalizeContent(rawContent);
    if (normalized.trim().isEmpty) {
      throw const FormatException('Backend content is empty');
    }

    try {
      return ReplyJsonParser.parseFromRaw(normalized);
    } catch (_) {
      try {
        final dynamic decoded = jsonDecode(normalized);
        if (decoded is Map<String, dynamic>) {
          return ReplyPack.fromJson(decoded);
        }
      } catch (_) {}
      rethrow;
    }
  }

  /// 兼容字符串、分段数组、对象三种 content 形态。
  String _normalizeContent(dynamic rawContent) {
    if (rawContent == null) {
      return '';
    }
    if (rawContent is String) {
      return rawContent;
    }
    if (rawContent is List) {
      final StringBuffer buffer = StringBuffer();
      for (final dynamic item in rawContent) {
        if (item is String) {
          buffer.write(item);
        } else if (item is Map) {
          buffer.write(item['text']?.toString() ?? '');
        }
      }
      return buffer.toString();
    }
    return rawContent.toString();
  }
}
