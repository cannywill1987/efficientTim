import '../../models/assist_profile.dart';
import '../../models/reply_pack.dart';

/// LLM 输入上下文。
///
/// 将“业务上下文”与“提示词拼装结果”集中为一个对象，
/// 便于不同 provider 统一消费。
class AssistLlmInput {
  /// 清洗后的对话列表（从旧到新）。
  final List<String> messages;

  /// 当前 Profile（语言、maxTurns 等配置）。
  final AssistProfile profile;

  /// system 提示词。
  final String systemPrompt;

  /// developer 提示词。
  final String developerPrompt;

  /// user 提示词（通常包含消息正文和 meta）。
  final String userPrompt;

  const AssistLlmInput({
    required this.messages,
    required this.profile,
    required this.systemPrompt,
    required this.developerPrompt,
    required this.userPrompt,
  });
}

/// LLM Provider 抽象。
///
/// 目标：
/// - 屏蔽后端代理/直连供应商差异
/// - 统一输出为 ReplyPack
abstract class AssistLlmProvider {
  /// 根据输入生成结构化回复包。
  Future<ReplyPack> generate(AssistLlmInput input);
}
