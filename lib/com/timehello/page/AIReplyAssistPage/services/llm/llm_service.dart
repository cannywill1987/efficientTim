import '../../models/assist_profile.dart';
import '../../models/reply_pack.dart';
import 'assist_llm_provider.dart';
import 'backend_proxy_llm_provider.dart';
import 'claude_direct_llm_provider.dart';
import 'openai_direct_llm_provider.dart';

/// LLM 模式枚举。
enum LlmMode { backend, openai, claude }

/// LLM 配置（由页面设置和本地存储提供）。
class AssistLlmConfig {
  /// 当前模式：后端代理 / OpenAI 直连 / Claude 直连。
  final LlmMode mode;

  /// OpenAI 直连 key。
  final String openAiApiKey;

  /// Claude 直连 key。
  final String claudeApiKey;

  /// OpenAI 模型名。
  final String openAiModel;

  /// Claude 模型名。
  final String claudeModel;

  const AssistLlmConfig({
    required this.mode,
    required this.openAiApiKey,
    required this.claudeApiKey,
    required this.openAiModel,
    required this.claudeModel,
  });
}

/// LLM 统一调度服务。
///
/// 职责：
/// 1. 构建三段提示词（system/developer/user）
/// 2. 选择 provider
/// 3. 校验 ReplyPack 基础有效性
class LlmService {
  /// 生成结构化回复结果。
  Future<ReplyPack> generate({
    required List<String> messages,
    required AssistProfile profile,
    required AssistLlmConfig config,
  }) async {
    // 提示词分层有助于不同模型保持同样约束。
    final String systemPrompt = _systemPrompt;
    final String developerPrompt = _developerPrompt;
    final String userPrompt = _buildUserPrompt(messages, profile);

    final AssistLlmInput input = AssistLlmInput(
      messages: messages,
      profile: profile,
      systemPrompt: systemPrompt,
      developerPrompt: developerPrompt,
      userPrompt: userPrompt,
    );

    final AssistLlmProvider provider = _createProvider(config);
    final ReplyPack pack = await provider.generate(input);

    // 最低有效性校验，避免 UI 出现空推荐。
    if (pack.recommended.text.trim().isEmpty) {
      throw const FormatException('LLM JSON is valid but recommended is empty');
    }

    return pack;
  }

  /// 按模式选择具体 provider。
  AssistLlmProvider _createProvider(AssistLlmConfig config) {
    switch (config.mode) {
      case LlmMode.openai:
        return OpenAiDirectLlmProvider(
          apiKey: config.openAiApiKey,
          model: config.openAiModel,
        );
      case LlmMode.claude:
        return ClaudeDirectLlmProvider(
          apiKey: config.claudeApiKey,
          model: config.claudeModel,
        );
      case LlmMode.backend:
      default:
        return BackendProxyLlmProvider();
    }
  }

  /// 构建 user 提示词（消息 + profile 元数据）。
  String _buildUserPrompt(List<String> messages, AssistProfile profile) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('messages(from_old_to_new):');
    for (int i = 0; i < messages.length; i++) {
      buffer.writeln('${i + 1}. ${messages[i]}');
    }
    buffer.writeln('meta:');
    buffer.writeln('- profileName: ${profile.name}');
    buffer.writeln('- ocrLang: ${profile.ocrLang}');
    buffer.writeln('- maxTurns: ${profile.maxTurns}');
    return buffer.toString();
  }

  /// system 提示词：安全边界 + JSON-only 硬约束。
  static const String _systemPrompt =
      'You are a cautious assistant for drafting customer-service chat replies. '
      'Never produce illegal, harmful, deceptive, or manipulative instructions. '
      'You must return JSON only.';

  /// developer 提示词：业务目标 + ReplyPack schema。
  static const String _developerPrompt =
      'Task: Based on the chat messages, provide one recommended reply, several alternatives, '
      'risk notes, and follow-up questions. '
      'Output JSON ONLY with this schema: '
      '{"recommended":{"text":"string","reason":"string"},'
      '"alternatives":[{"text":"string","reason":"string"}], '
      '"risks":[{"level":"low|medium|high","note":"string"}], '
      '"followups":["string"]}. '
      'Do not output markdown or code fence. '
      'Keep replies concise and practical for WeChat conversation. '
      'No auto-send language.';
}
