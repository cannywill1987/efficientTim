/// 文件类型：工具类
/// 文件作用：为移动端长按加号的语音创建任务入口提供 AI 判定、千问参数解析和创建任务工具调用。
/// 主要职责：根据转写文本判断是否进入 AI 模式，把自然语言解析成 TimeHello 创建任务参数，并复用 AIInterfaceManager 写入任务。
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/AIInterfaceManager.dart';
import 'package:time_hello/com/timehello/util/AppAiBailianConfigManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

enum MobileVoiceTaskMode {
  normal,
  ai,
}

class MobileVoiceTaskManager {
  MobileVoiceTaskManager._();

  static const List<String> _aiTriggerKeywords = <String>[
    '帮我创建',
    '帮我新建',
    '帮我添加',
    '帮我安排',
    '帮我生成',
    '帮我记',
    '创建任务',
    '新建任务',
    '添加任务',
    '安排任务',
    '生成任务',
    '提醒我',
    '帮我提醒',
    '日程',
    '截止',
    '到期',
    '今天',
    '明天',
    '后天',
    '下周',
    '下个月',
    '上午',
    '下午',
    '晚上',
    '清单',
    '列表',
    '标签',
    '优先级',
    '重要',
    '紧急',
    '番茄',
    '专注',
    '多个任务',
    '几件事',
    '第一',
    '第二',
    '第三',
    'create task',
    'add task',
    'remind me',
    'schedule',
  ];

  /// 功能：判断转写文本是否需要走 AI 参数解析。
  /// 说明：简单一句话直接创建任务，涉及日期、清单、优先级或多任务时交给 AI 生成标准 MissionModel 参数。
  static bool shouldUseAiMode(String text) {
    final normalized = text.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    if (_aiTriggerKeywords.any((keyword) {
      return normalized.contains(keyword.toLowerCase());
    })) {
      return true;
    }
    return RegExp(r'\d+\s*(点|:|：|分钟|小时|个|次|页|天)').hasMatch(text) ||
        RegExp(r'(周一|周二|周三|周四|周五|周六|周日|星期[一二三四五六日天])').hasMatch(text);
  }

  /// 功能：调用千问把自然语言转换为创建任务参数，并通过 AIInterfaceManager 创建任务。
  /// 入参：defaultFolderTitle、defaultPriorityStatus、defaultDateStatus 来自当前页面上下文，用于补齐语音里没说出的默认值。
  static Future<Map<String, Object?>> createAiMissionsFromPrompt({
    required String prompt,
    String? defaultFolderTitle,
    int? defaultPriorityStatus,
    int? defaultDateStatus,
  }) async {
    final toolArgs = await _buildCreateMissionToolArgs(prompt);
    _applyContextDefaults(
      toolArgs,
      defaultFolderTitle: defaultFolderTitle,
      defaultPriorityStatus: defaultPriorityStatus,
      defaultDateStatus: defaultDateStatus,
    );
    return AIInterfaceManager.getInstance().callTool(
      AIInterfaceManager.createMissionsToolName,
      toolArgs,
    );
  }

  static const String _createMissionsFunctionName = 'timehello_create_missions';

  /// 功能：向百炼兼容 OpenAI 的 chat/completions 接口请求创建任务参数。
  /// 说明：优先使用 Function Calling 的 arguments，避免只靠 prompt 约束 JSON；模型或接口不支持时再降级读取 content JSON。
  static Future<Map<String, Object?>> _buildCreateMissionToolArgs(
    String prompt,
  ) async {
    await AppAiBailianConfigManager.getInstance().resolveConfig();
    final modelEntry = Params.appAiBailianModels.first;
    final apiKey = (modelEntry['apiKey'] ?? '').toString().trim();
    final baseUrl = (modelEntry['baseUrl'] ?? '').toString().trim();
    final model = (modelEntry['model'] ?? '').toString().trim();
    if (apiKey.isEmpty || baseUrl.isEmpty || model.isEmpty) {
      throw StateError('AI 模型配置不完整，无法生成任务参数。');
    }

    final now = DateTime.now();
    var response = await _postChatCompletions(
      apiKey: apiKey,
      baseUrl: baseUrl,
      body: _buildFunctionCallingBody(
        model: model,
        prompt: prompt,
        now: now,
        forceToolChoice: true,
      ),
    );
    if (_shouldRetryWithAutoToolChoice(response)) {
      response = await _postChatCompletions(
        apiKey: apiKey,
        baseUrl: baseUrl,
        body: _buildFunctionCallingBody(
          model: model,
          prompt: prompt,
          now: now,
          forceToolChoice: false,
        ),
      );
    }
    if (_shouldRetryWithPromptJson(response)) {
      response = await _postChatCompletions(
        apiKey: apiKey,
        baseUrl: baseUrl,
        body: _buildPromptJsonBody(
          model: model,
          prompt: prompt,
          now: now,
        ),
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('AI HTTP ${response.statusCode}: ${response.body}');
    }

    final decoded =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, Object?>;
    final choices = decoded['choices'];
    if (choices is! List || choices.isEmpty) {
      throw StateError('AI 没有返回可用的任务参数。');
    }
    final first = choices.first;
    final message = first is Map ? first['message'] : null;
    final toolArgs = _extractFunctionToolArgs(message);
    if (toolArgs != null) {
      return _normalizeToolArgs(toolArgs);
    }

    final content = first is Map
        ? (message is Map
            ? message['content']?.toString()
            : first['text']?.toString())
        : null;
    if (TextUtil.isEmpty(content)) {
      throw StateError('AI 返回内容为空，无法创建任务。');
    }

    final args = jsonDecode(_extractJsonObject(content ?? ''));
    return _normalizeToolArgs(args);
  }

  /// 功能：按百炼 OpenAI 兼容协议发起模型请求。
  /// 说明：这里保留直接 http 调用，因为该请求访问外部模型网关并使用独立 Bearer API Key，不走业务接口统一 USER-TOKEN。
  static Future<http.Response> _postChatCompletions({
    required String apiKey,
    required String baseUrl,
    required Map<String, Object?> body,
  }) {
    return http
        .post(
          Uri.parse('$baseUrl/chat/completions'),
          headers: <String, String>{
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 90));
  }

  /// 功能：构建 Function Calling 请求体，让模型返回创建任务工具的 arguments。
  /// 说明：forceToolChoice 为 true 时强制指定工具；若网关或模型不支持，会自动降级为 auto 重试。
  static Map<String, Object?> _buildFunctionCallingBody({
    required String model,
    required String prompt,
    required DateTime now,
    required bool forceToolChoice,
  }) {
    return <String, Object?>{
      'model': model,
      'temperature': 0.1,
      'stream': false,
      'enable_thinking': false,
      'messages': _buildCreateMissionMessages(prompt: prompt, now: now),
      'tools': _buildCreateMissionTools(),
      'tool_choice': forceToolChoice
          ? <String, Object?>{
              'type': 'function',
              'function': <String, Object?>{
                'name': _createMissionsFunctionName,
              },
            }
          : 'auto',
    };
  }

  /// 功能：构建旧版 JSON 输出请求体，作为工具调用不可用时的兜底方案。
  /// 说明：保留该路径可以兼容暂不支持 tools 的模型，避免移动端创建任务入口直接失效。
  static Map<String, Object?> _buildPromptJsonBody({
    required String model,
    required String prompt,
    required DateTime now,
  }) {
    return <String, Object?>{
      'model': model,
      'temperature': 0.2,
      'stream': false,
      'enable_thinking': false,
      'messages': _buildCreateMissionMessages(
        prompt: prompt,
        now: now,
        forceJsonContent: true,
      ),
    };
  }

  /// 功能：组装任务参数解析的对话上下文。
  /// 说明：系统提示只描述业务规则，具体结构约束优先交给 tools schema 承担。
  static List<Map<String, String>> _buildCreateMissionMessages({
    required String prompt,
    required DateTime now,
    bool forceJsonContent = false,
  }) {
    return <Map<String, String>>[
      <String, String>{
        'role': 'system',
        'content':
            '最高优先级运行时规则：\n${AIInterfaceManager.getInstance().getRuntimeSystemPrompt()}',
      },
      <String, String>{
        'role': 'system',
        'content': '''
你是 TimeHello 移动端语音创建任务参数解析器。
当前本地时间是：${now.toIso8601String()}。
${forceJsonContent ? '请只输出 JSON object，不要解释，不要使用 Markdown。' : '如果工具可用，必须调用 $_createMissionsFunctionName，不要输出自然语言。'}

字段与业务规则：
1. 必须使用 MissionModel 标准字段：title、time_mode、start_time、end_time、dateStatus、priorityStatus、folder_id、folder_title、tagNames、subMissions、total_tomotoes、tomato_duration。
2. 禁止输出 name、taskName、due_date、deadline 等别名字段。
3. 没有明确时间就不要编造 start_time/end_time；有“今天/明天/后天/下周”等相对日期时优先输出 dateStatus。
4. “明天”输出 dateStatus=2，“今天”输出 dateStatus=1，“最近7天/本周”输出 dateStatus=3，“待定/碎片”按语义输出 12 或 13。
5. “重要紧急/紧急重要”输出 priorityStatus=0；“重要不紧急”输出 1；“紧急不重要”输出 2；“不重要不紧急”输出 3。
6. 如果用户说“在清单 X 下创建任务 Y”，输出 folder_title=X，title=Y。
7. 多个任务必须拆成 datas 多条；标题必须简短不能为空。
''',
      },
      <String, String>{'role': 'user', 'content': prompt},
    ];
  }

  /// 功能：定义创建任务工具的 JSON Schema。
  /// 说明：模型只负责生成参数，真正落库仍交给 AIInterfaceManager，避免两套任务字段规则分叉。
  static List<Map<String, Object?>> _buildCreateMissionTools() {
    return <Map<String, Object?>>[
      <String, Object?>{
        'type': 'function',
        'function': <String, Object?>{
          'name': _createMissionsFunctionName,
          'description': '把用户自然语言转换为 TimeHello 创建任务参数。',
          'parameters': <String, Object?>{
            'type': 'object',
            'properties': <String, Object?>{
              'datas': <String, Object?>{
                'type': 'array',
                'description': '需要创建的任务列表，多个任务必须拆成多条。',
                'items': <String, Object?>{
                  'type': 'object',
                  'properties': <String, Object?>{
                    'title': <String, Object?>{
                      'type': 'string',
                      'description': '任务标题，必须简短不能为空。',
                    },
                    'time_mode': <String, Object?>{'type': 'integer'},
                    'start_time': <String, Object?>{
                      'type': 'string',
                      'description': 'ISO8601 开始时间，用户没有明确时间时不要输出。',
                    },
                    'end_time': <String, Object?>{
                      'type': 'string',
                      'description': 'ISO8601 结束时间，用户没有明确时间时不要输出。',
                    },
                    'dateStatus': <String, Object?>{'type': 'integer'},
                    'priorityStatus': <String, Object?>{'type': 'integer'},
                    'folder_id': <String, Object?>{'type': 'string'},
                    'folder_title': <String, Object?>{'type': 'string'},
                    'tagNames': <String, Object?>{
                      'type': 'array',
                      'items': <String, Object?>{'type': 'string'},
                    },
                    'subMissions': <String, Object?>{
                      'type': 'array',
                      'items': <String, Object?>{
                        'type': 'object',
                        'properties': <String, Object?>{
                          'title': <String, Object?>{'type': 'string'},
                        },
                        'required': <String>['title'],
                        'additionalProperties': false,
                      },
                    },
                    'total_tomotoes': <String, Object?>{'type': 'integer'},
                    'tomato_duration': <String, Object?>{'type': 'integer'},
                  },
                  'required': <String>['title'],
                  'additionalProperties': false,
                },
              },
            },
            'required': <String>['datas'],
            'additionalProperties': false,
          },
        },
      },
    ];
  }

  /// 功能：判断是否因为强制 tool_choice 兼容性问题需要改用 auto 重试。
  static bool _shouldRetryWithAutoToolChoice(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = response.body.toLowerCase();
      return body.contains('tool_choice') ||
          body.contains('function_call') ||
          body.contains('tools');
    }
    return false;
  }

  /// 功能：判断 tools 完全不可用时是否需要降级为旧版 JSON 内容解析。
  static bool _shouldRetryWithPromptJson(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = response.body.toLowerCase();
      return body.contains('tools') ||
          body.contains('function') ||
          body.contains('tool_choice');
    }
    return false;
  }

  /// 功能：从 OpenAI 兼容返回里提取 function arguments。
  /// 说明：兼容新版 tool_calls 和旧版 function_call 两种结构。
  static Map<String, Object?>? _extractFunctionToolArgs(Object? message) {
    if (message is! Map) {
      return null;
    }
    final toolCalls = message['tool_calls'];
    if (toolCalls is List) {
      for (final call in toolCalls) {
        if (call is! Map) {
          continue;
        }
        final function = call['function'];
        if (function is! Map) {
          continue;
        }
        final name = function['name']?.toString();
        if (name != _createMissionsFunctionName) {
          continue;
        }
        return _decodeArgsMap(function['arguments']);
      }
    }

    final functionCall = message['function_call'];
    if (functionCall is Map) {
      final name = functionCall['name']?.toString();
      if (name == null || name == _createMissionsFunctionName) {
        return _decodeArgsMap(functionCall['arguments']);
      }
    }
    return null;
  }

  /// 功能：把模型返回的 arguments 统一解码成 Map。
  static Map<String, Object?> _decodeArgsMap(Object? value) {
    final decoded = value is String ? jsonDecode(value) : value;
    if (decoded is! Map) {
      throw StateError('AI 返回的工具参数不是 JSON object。');
    }
    return decoded.map<String, Object?>(
      (key, item) => MapEntry<String, Object?>(key.toString(), item),
    );
  }

  /// 功能：归一化并校验创建任务参数，防止模型返回空 datas 或空标题。
  static Map<String, Object?> _normalizeToolArgs(Object? value) {
    if (value is! Map) {
      throw StateError('AI 返回的任务参数不是 JSON object。');
    }
    final normalized = value.map<String, Object?>(
      (key, item) => MapEntry<String, Object?>(key.toString(), item),
    );
    final datas = normalized['datas'];
    if (datas is! List || datas.isEmpty) {
      throw StateError('AI 返回的任务列表为空。');
    }
    for (final item in datas) {
      if (item is! Map || TextUtil.isEmpty(item['title'])) {
        throw StateError('AI 返回的任务标题为空，无法创建任务。');
      }
    }
    return normalized;
  }

  /// 功能：把当前页面上下文补到 AI 参数中，避免用户只说标题时丢失当前清单、四象限或日期默认值。
  static void _applyContextDefaults(
    Map<String, Object?> args, {
    String? defaultFolderTitle,
    int? defaultPriorityStatus,
    int? defaultDateStatus,
  }) {
    final datas = args['datas'];
    if (datas is! List) {
      return;
    }
    for (final item in datas) {
      if (item is! Map) {
        continue;
      }
      final hasFolder = !TextUtil.isEmpty(item['folder_id']) ||
          !TextUtil.isEmpty(item['folder_title']);
      if (!hasFolder && !TextUtil.isEmpty(defaultFolderTitle)) {
        item['folder_title'] = defaultFolderTitle;
      }
      if (item['priorityStatus'] == null && defaultPriorityStatus != null) {
        item['priorityStatus'] = defaultPriorityStatus;
      }
      final hasAnyTime = item['dateStatus'] != null ||
          item['start_time'] != null ||
          item['end_time'] != null;
      if (!hasAnyTime && defaultDateStatus != null) {
        item['dateStatus'] = defaultDateStatus;
      }
    }
  }

  /// 功能：从模型返回中提取第一个 JSON object，兼容 ```json 代码块和多余自然语言。
  static String _extractJsonObject(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text
          .replaceFirst(RegExp(r'^```(?:json)?\s*', caseSensitive: false), '')
          .replaceFirst(RegExp(r'\s*```$'), '')
          .trim();
    }
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw StateError('AI 返回中没有找到 JSON object：$raw');
    }
    return text.substring(start, end + 1);
  }
}
