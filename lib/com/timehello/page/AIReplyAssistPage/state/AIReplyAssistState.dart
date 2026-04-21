import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';

import '../models/assist_profile.dart';
import '../models/capture_result.dart';
import '../models/reply_pack.dart';
import '../models/roi.dart';
import '../services/capture_service.dart';
import '../services/ocr_service.dart';
import '../services/parse_service.dart';
import '../services/paste_service.dart';
import '../services/permission_service.dart';
import '../services/llm/llm_service.dart';

/// AI 回复助手页面状态容器。
///
/// 负责：
/// 1. Profile/LLM 配置的本地读写
/// 2. F2 主流程编排（截图->裁剪->OCR->清洗->LLM）
/// 3. 候选回复切换与 F4 粘贴
/// 4. 日志与错误状态维护
class AIReplyAssistState extends ChangeNotifier {
  AIReplyAssistState();

  /// 本地持久化（SharePreference）。
  final SharePreferenceUtil _prefs = SharePreferenceUtil.getSyncInstance();

  /// 业务服务层。
  final CaptureService _captureService = CaptureService();
  final OcrService _ocrService = OcrService();
  final ParseService _parseService = ParseService();
  final PasteService _pasteService = PasteService();
  final PermissionService _permissionService = PermissionService();
  final LlmService _llmService = LlmService();

  /// 全部 Profile 与当前激活 Profile id。
  List<AssistProfile> profiles = <AssistProfile>[];
  String? activeProfileId;

  /// LLM 配置（支持后端代理与双直连）。
  LlmMode llmMode = LlmMode.backend;
  String openAiApiKey = '';
  String claudeApiKey = '';
  String openAiModel = 'gpt-4.1-mini';
  String claudeModel = 'claude-3-5-sonnet-latest';

  /// 运行态状态。
  bool isGenerating = false;
  String? lastError;

  CaptureResult? lastCapture;
  Uint8List? chatCropPng;
  String rawOcrText = '';
  List<String> cleanedMessages = <String>[];

  ReplyPack? replyPack;
  int selectedCandidateIndex = 0;

  final List<String> logs = <String>[];

  Map<String, String> permissions = <String, String>{
    'screenRecording': 'unknown',
    'accessibility': 'unknown',
  };

  /// 当前生效 Profile。
  AssistProfile? get activeProfile {
    if (profiles.isEmpty) {
      return null;
    }
    final String? id = activeProfileId;
    if (id == null) {
      return profiles.first;
    }
    for (final AssistProfile p in profiles) {
      if (p.id == id) {
        return p;
      }
    }
    return profiles.first;
  }

  /// 当前选中的候选（推荐 or 备选）。
  ReplyCandidate? get selectedCandidate {
    final ReplyPack? pack = replyPack;
    if (pack == null) {
      return null;
    }
    if (selectedCandidateIndex <= 0) {
      return pack.recommended;
    }
    final int altIndex = selectedCandidateIndex - 1;
    if (altIndex >= 0 && altIndex < pack.alternatives.length) {
      return pack.alternatives[altIndex];
    }
    return pack.recommended;
  }

  /// 候选总数（推荐 1 条 + 备选 N 条）。
  int get candidateCount {
    final ReplyPack? pack = replyPack;
    if (pack == null) {
      return 0;
    }
    return 1 + pack.alternatives.length;
  }

  /// 页面初始化入口：加载本地配置并刷新权限状态。
  Future<void> initialize() async {
    _loadFromLocal();
    await checkPermissions(silent: true);
    notifyListeners();
  }

  /// 从本地存储恢复状态。
  void _loadFromLocal() {
    try {
      final String profilesRaw = _prefs.getString(
        key: ShareprefrenceKeys.aiReplyProfiles,
        defaultVal: '',
      );
      if (profilesRaw.trim().isNotEmpty) {
        final dynamic parsed = jsonDecode(profilesRaw);
        // 历史 JSON 可能是 dynamic Map，这里统一转成强类型。
        if (parsed is List) {
          profiles = parsed
              .map((dynamic e) {
                if (e is Map<String, dynamic>) {
                  return AssistProfile.fromJson(e);
                }
                if (e is Map) {
                  return AssistProfile.fromJson(Map<String, dynamic>.from(e));
                }
                return null;
              })
              .whereType<AssistProfile>()
              .toList();
        }
      }
    } catch (_) {}

    // 首次使用兜底默认 Profile。
    if (profiles.isEmpty) {
      profiles = <AssistProfile>[AssistProfile.defaultProfile()];
    }

    activeProfileId = _prefs.getString(
      key: ShareprefrenceKeys.aiReplyActiveProfileId,
      defaultVal: profiles.first.id,
    );

    // 读取 LLM 模式与 key/model 参数。
    llmMode = _parseLlmMode(_prefs.getString(
      key: ShareprefrenceKeys.aiReplyLlmMode,
      defaultVal: 'backend',
    ));

    openAiApiKey = _prefs.getString(
      key: ShareprefrenceKeys.aiReplyOpenAiKey,
      defaultVal: '',
    );
    claudeApiKey = _prefs.getString(
      key: ShareprefrenceKeys.aiReplyClaudeKey,
      defaultVal: '',
    );
    openAiModel = _prefs.getString(
      key: ShareprefrenceKeys.aiReplyOpenAiModel,
      defaultVal: 'gpt-4.1-mini',
    );
    claudeModel = _prefs.getString(
      key: ShareprefrenceKeys.aiReplyClaudeModel,
      defaultVal: 'claude-3-5-sonnet-latest',
    );

    // 统一修正并回写，确保状态最小一致性。
    _normalizeStateAndPersist();
  }

  /// 修正关键状态并持久化。
  void _normalizeStateAndPersist() {
    if (profiles.isEmpty) {
      profiles = <AssistProfile>[AssistProfile.defaultProfile()];
    }
    if (activeProfile == null) {
      activeProfileId = profiles.first.id;
    }
    _saveProfiles();
    _saveLlmSettings();
  }

  /// 持久化 Profile 列表与 activeProfileId。
  void _saveProfiles() {
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyProfiles,
      content: jsonEncode(
        profiles.map((AssistProfile p) => p.toJson()).toList(),
      ),
    );
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyActiveProfileId,
      content: activeProfileId ?? '',
    );
  }

  /// 持久化 LLM 设置。
  void _saveLlmSettings() {
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyLlmMode,
      content: llmMode.name,
    );
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyOpenAiKey,
      content: openAiApiKey,
    );
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyClaudeKey,
      content: claudeApiKey,
    );
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyOpenAiModel,
      content: openAiModel,
    );
    _prefs.setString(
      key: ShareprefrenceKeys.aiReplyClaudeModel,
      content: claudeModel,
    );
  }

  /// 将字符串解析为枚举模式。
  LlmMode _parseLlmMode(String raw) {
    switch (raw) {
      case 'openai':
        return LlmMode.openai;
      case 'claude':
        return LlmMode.claude;
      case 'backend':
      default:
        return LlmMode.backend;
    }
  }

  /// 追加日志（最新在前，最多保留 200 行）。
  void appendLog(String msg) {
    final String line = '[${DateTime.now().toIso8601String()}] $msg';
    logs.insert(0, line);
    if (logs.length > 200) {
      logs.removeRange(200, logs.length);
    }
    notifyListeners();
  }

  /// 主动刷新权限状态。
  Future<void> checkPermissions({bool silent = false}) async {
    try {
      permissions = await _permissionService.checkPermissions();
      if (!silent) {
        appendLog(
          'Permissions: screen=${permissions['screenRecording']} accessibility=${permissions['accessibility']}',
        );
      }
    } catch (e) {
      if (!silent) {
        appendLog('Permission check failed: $e');
      }
    }
    notifyListeners();
  }

  /// 打开系统设置权限页。
  Future<void> openSettings(String page) async {
    await _permissionService.openSystemSettings(page);
    appendLog('Requested open system settings: $page');
  }

  /// 切换 LLM 模式并落库。
  void setLlmMode(LlmMode mode) {
    llmMode = mode;
    _saveLlmSettings();
    notifyListeners();
  }

  /// 设置 OpenAI key。
  void setOpenAiApiKey(String value) {
    openAiApiKey = value;
    _saveLlmSettings();
    notifyListeners();
  }

  /// 设置 Claude key。
  void setClaudeApiKey(String value) {
    claudeApiKey = value;
    _saveLlmSettings();
    notifyListeners();
  }

  /// 设置 OpenAI 模型名（空值回退默认）。
  void setOpenAiModel(String value) {
    openAiModel = value.trim().isEmpty ? 'gpt-4.1-mini' : value.trim();
    _saveLlmSettings();
    notifyListeners();
  }

  /// 设置 Claude 模型名（空值回退默认）。
  void setClaudeModel(String value) {
    claudeModel =
        value.trim().isEmpty ? 'claude-3-5-sonnet-latest' : value.trim();
    _saveLlmSettings();
    notifyListeners();
  }

  /// 切换当前激活 Profile。
  void setActiveProfile(String profileId) {
    activeProfileId = profileId;
    _saveProfiles();
    notifyListeners();
  }

  /// 基于当前配置新增一个 Profile。
  void addProfile() {
    final AssistProfile base = activeProfile ?? AssistProfile.defaultProfile();
    final String id =
        'profile-${DateTime.now().millisecondsSinceEpoch.toString()}';
    final AssistProfile profile = base.copyWith(
      id: id,
      name: 'Profile ${profiles.length + 1}',
    );
    profiles = <AssistProfile>[...profiles, profile];
    activeProfileId = profile.id;
    _saveProfiles();
    appendLog('Added profile: ${profile.name}');
  }

  /// 删除当前 Profile（至少保留一个）。
  void removeCurrentProfile() {
    if (profiles.length <= 1) {
      appendLog('Cannot remove the last profile');
      return;
    }
    final AssistProfile? current = activeProfile;
    if (current == null) {
      return;
    }
    profiles = profiles.where((AssistProfile p) => p.id != current.id).toList();
    activeProfileId = profiles.first.id;
    _saveProfiles();
    appendLog('Removed profile: ${current.name}');
  }

  /// 重命名当前 Profile。
  void renameCurrentProfile(String name) {
    if (name.trim().isEmpty) {
      return;
    }
    _mutateCurrentProfile((AssistProfile p) => p.copyWith(name: name.trim()));
    appendLog('Renamed profile to: ${name.trim()}');
  }

  /// 设置 OCR 语言。
  void setCurrentOcrLang(String lang) {
    _mutateCurrentProfile((AssistProfile p) => p.copyWith(ocrLang: lang));
  }

  /// 设置最大上下文条数（带范围保护）。
  void setCurrentMaxTurns(int maxTurns) {
    final int fixed = maxTurns < 1 ? 1 : (maxTurns > 50 ? 50 : maxTurns);
    _mutateCurrentProfile((AssistProfile p) => p.copyWith(maxTurns: fixed));
  }

  /// 微调 chat ROI（像素步进）。
  void nudgeCurrentChatRoi(String field, double delta) {
    final AssistProfile? current = activeProfile;
    if (current == null) {
      return;
    }
    _mutateCurrentProfile(
      (AssistProfile p) =>
          p.copyWith(chatRoi: _nudgeRoi(p.chatRoi, field, delta)),
    );
  }

  /// 微调 input ROI（像素步进）。
  void nudgeCurrentInputRoi(String field, double delta) {
    final AssistProfile? current = activeProfile;
    if (current == null) {
      return;
    }
    _mutateCurrentProfile(
      (AssistProfile p) =>
          p.copyWith(inputRoi: _nudgeRoi(p.inputRoi, field, delta)),
    );
  }

  /// ROI 单字段增量变换（带边界保护）。
  Roi _nudgeRoi(Roi roi, String field, double delta) {
    switch (field) {
      case 'x':
        return roi.copyWith(x: (roi.x + delta).clamp(0, 10000).toDouble());
      case 'y':
        return roi.copyWith(y: (roi.y + delta).clamp(0, 10000).toDouble());
      case 'w':
        return roi.copyWith(w: (roi.w + delta).clamp(1, 10000).toDouble());
      case 'h':
        return roi.copyWith(h: (roi.h + delta).clamp(1, 10000).toDouble());
      default:
        return roi;
    }
  }

  /// 更新当前 Profile 的通用内部方法。
  void _mutateCurrentProfile(AssistProfile Function(AssistProfile profile) fn) {
    final AssistProfile? current = activeProfile;
    if (current == null) {
      return;
    }
    profiles = profiles
        .map((AssistProfile p) => p.id == current.id ? fn(p) : p)
        .toList();
    _saveProfiles();
    notifyListeners();
  }

  /// F2 主流程：
  /// capture -> crop(chatRoi) -> ocr -> clean -> llm.generate。
  Future<void> runGenerate() async {
    // 防重入：执行中再次按 F2 直接忽略。
    if (isGenerating) {
      appendLog('Generation is already running. Ignored duplicate F2.');
      return;
    }

    final AssistProfile? profile = activeProfile;
    if (profile == null) {
      appendLog('No active profile selected');
      return;
    }

    isGenerating = true;
    lastError = null;
    notifyListeners();

    try {
      await checkPermissions(silent: true);

      // 1) 全屏截图
      final CaptureResult capture = await _captureService.captureScreenPng();
      lastCapture = capture;
      appendLog(
          'Capture done: ${capture.widthPx}x${capture.heightPx} scale=${capture.scale.toStringAsFixed(2)}');

      // 2) 按聊天 ROI 裁剪
      chatCropPng = await _captureService.cropPng(
        png: capture.png,
        roi: profile.chatRoi,
        scale: capture.scale,
      );
      appendLog('Crop done: chat ROI');

      // 3) OCR
      rawOcrText = await _ocrService.recognizeText(
        chatCropPng!,
        lang: profile.ocrLang,
      );
      appendLog('OCR done: ${rawOcrText.length} chars');

      // 4) 清洗
      cleanedMessages =
          _parseService.clean(rawOcrText, maxTurns: profile.maxTurns);
      appendLog('Parse done: ${cleanedMessages.length} cleaned messages');

      if (cleanedMessages.isEmpty) {
        throw Exception('No usable messages after cleaning');
      }

      // 5) 调用 LLM 生成结构化结果
      replyPack = await _llmService.generate(
        messages: cleanedMessages,
        profile: profile,
        config: AssistLlmConfig(
          mode: llmMode,
          openAiApiKey: openAiApiKey,
          claudeApiKey: claudeApiKey,
          openAiModel: openAiModel,
          claudeModel: claudeModel,
        ),
      );
      selectedCandidateIndex = 0;
      appendLog('LLM done: ${candidateCount} candidates prepared');
    } catch (e) {
      // 区分 JSON 结构失败与其他异常，给出更可操作提示。
      final String err = e.toString();
      if (err.contains('FormatException') ||
          err.contains('No JSON object found') ||
          err.contains('JSON')) {
        lastError = '输出不合规，请缩短上下文后重试';
      } else {
        lastError = '$e';
      }
      appendLog('Generate failed: $lastError');
    } finally {
      // 结束态统一收口。
      isGenerating = false;
      notifyListeners();
    }
  }

  /// F3：轮转候选。
  void switchCandidate() {
    if (candidateCount <= 1) {
      return;
    }
    selectedCandidateIndex = (selectedCandidateIndex + 1) % candidateCount;
    appendLog('Candidate switched to #${selectedCandidateIndex + 1}');
    notifyListeners();
  }

  /// 点击候选时指定索引。
  void setSelectedCandidateIndex(int index) {
    if (index < 0 || index >= candidateCount) {
      return;
    }
    selectedCandidateIndex = index;
    notifyListeners();
  }

  /// F4：将当前候选粘贴到输入框（不发送）。
  Future<void> pasteSelectedCandidate() async {
    final ReplyCandidate? candidate = selectedCandidate;
    final AssistProfile? profile = activeProfile;
    if (candidate == null || profile == null || candidate.text.trim().isEmpty) {
      appendLog('No candidate available to paste');
      return;
    }

    try {
      await _pasteService.focusAndPaste(
        inputRoi: profile.inputRoi,
        text: candidate.text,
      );
      appendLog('Text pasted to input box (not sent)');
    } catch (e) {
      appendLog('Paste failed: $e');
    }
  }
}
