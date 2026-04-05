import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/reply_pack.dart';
import 'models/roi.dart';
import 'state/AIReplyAssistState.dart';
import 'services/llm/llm_service.dart';

/// 微信回复助手页面（MVP）。
///
/// 特性：
/// - 窗口内快捷键：F2/F3/F4
/// - Profile 与 ROI 调参
/// - 截图/裁剪预览
/// - OCR 文本、清洗结果、LLM 候选与日志展示
class AIReplyAssistPage extends StatefulWidget {
  const AIReplyAssistPage({Key? key}) : super(key: key);

  @override
  State<AIReplyAssistPage> createState() => _AIReplyAssistPageState();
}

class _AIReplyAssistPageState extends State<AIReplyAssistPage> {
  late final AIReplyAssistState _vm;

  /// 用于接收窗口内键盘事件（F2/F3/F4）。
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _vm = AIReplyAssistState();
    _vm.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _keyboardFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _vm.dispose();
    super.dispose();
  }

  /// Profile 重命名弹窗。
  Future<void> _showRenameDialog(BuildContext context) async {
    final AIReplyAssistState vm = _vm;
    final String initial = vm.activeProfile?.name ?? '';
    final TextEditingController controller =
        TextEditingController(text: initial);
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Profile'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Profile name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      vm.renameCurrentProfile(result.trim());
    }
  }

  /// 页面内快捷键分发。
  ///
  /// - F2: 生成
  /// - F3: 切候选
  /// - F4: 粘贴（不发送）
  KeyEventResult _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.f2) {
      _vm.runGenerate();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f3) {
      _vm.switchCandidate();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f4) {
      _vm.pasteSelectedCandidate();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// 页面主构建。
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AIReplyAssistState>.value(
      value: _vm,
      child: Consumer<AIReplyAssistState>(
        builder: (BuildContext context, AIReplyAssistState vm, Widget? child) {
          final profile = vm.activeProfile;

          return KeyboardListener(
            focusNode: _keyboardFocusNode,
            autofocus: true,
            onKeyEvent: _onKeyEvent,
            child: GestureDetector(
              onTap: () => _keyboardFocusNode.requestFocus(),
              child: Container(
                color: const Color(0xfff6f7f9),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTitle(vm),
                    const SizedBox(height: 8),
                    _buildPermissionBanner(vm),
                    const SizedBox(height: 8),
                    _buildTopControls(context, vm),
                    const SizedBox(height: 8),
                    if ((vm.lastError ?? '').isNotEmpty)
                      _buildErrorBanner(vm.lastError!),
                    if ((vm.lastError ?? '').isNotEmpty)
                      const SizedBox(height: 8),
                    if (profile != null) _buildProfileControls(vm),
                    const SizedBox(height: 8),
                    if (profile != null)
                      _buildRoiControls(vm, profile.chatRoi, profile.inputRoi),
                    const SizedBox(height: 8),
                    _buildLlmConfig(vm),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildPreviewSection(vm),
                            const SizedBox(height: 8),
                            _buildReplySection(vm),
                            const SizedBox(height: 8),
                            _buildTextPanels(vm),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 标题区（含生成状态 loading）。
  Widget _buildTitle(AIReplyAssistState vm) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Text(
            '微信回复助手（MVP）- 仅聚焦+粘贴，不会自动发送',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        if (vm.isGenerating)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  /// 权限未授权提示条（带系统设置跳转）。
  Widget _buildPermissionBanner(AIReplyAssistState vm) {
    final bool screenDenied = vm.permissions['screenRecording'] == 'denied';
    final bool accessDenied = vm.permissions['accessibility'] == 'denied';
    if (!screenDenied && !accessDenied) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xfffff3cd),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffffcc80)),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          Text(
            '权限未开启: screen=${vm.permissions['screenRecording']} accessibility=${vm.permissions['accessibility']}',
            style: const TextStyle(fontSize: 12),
          ),
          if (screenDenied)
            OutlinedButton(
              onPressed: () => vm.openSettings('screenRecording'),
              child: const Text('Open Screen Recording'),
            ),
          if (accessDenied)
            OutlinedButton(
              onPressed: () => vm.openSettings('accessibility'),
              child: const Text('Open Accessibility'),
            ),
          TextButton(
            onPressed: () => vm.checkPermissions(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  /// 业务错误提示条（例如 JSON 不合规）。
  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffffebee),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffffcdd2)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: Color(0xffb71c1c)),
      ),
    );
  }

  /// 顶部工具区：Profile、LLM 模式、主操作按钮。
  Widget _buildTopControls(BuildContext context, AIReplyAssistState vm) {
    final profile = vm.activeProfile;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String>(
            initialValue: profile?.id,
            items: vm.profiles
                .map((p) => DropdownMenuItem<String>(
                      value: p.id,
                      child: Text(p.name),
                    ))
                .toList(),
            onChanged: (String? id) {
              if (id != null) vm.setActiveProfile(id);
            },
            decoration: const InputDecoration(
              labelText: 'Profile',
              isDense: true,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: vm.addProfile,
          child: const Text('Add Profile'),
        ),
        OutlinedButton(
          onPressed: () => _showRenameDialog(context),
          child: const Text('Rename'),
        ),
        OutlinedButton(
          onPressed: vm.removeCurrentProfile,
          child: const Text('Remove'),
        ),
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<LlmMode>(
            initialValue: vm.llmMode,
            items: const <DropdownMenuItem<LlmMode>>[
              DropdownMenuItem<LlmMode>(
                value: LlmMode.backend,
                child: Text('Backend Proxy'),
              ),
              DropdownMenuItem<LlmMode>(
                value: LlmMode.openai,
                child: Text('OpenAI Direct'),
              ),
              DropdownMenuItem<LlmMode>(
                value: LlmMode.claude,
                child: Text('Claude Direct'),
              ),
            ],
            onChanged: (LlmMode? mode) {
              if (mode != null) vm.setLlmMode(mode);
            },
            decoration: const InputDecoration(
              labelText: 'LLM Mode',
              isDense: true,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: vm.isGenerating ? null : vm.runGenerate,
          child: const Text('Generate (F2)'),
        ),
        OutlinedButton(
          onPressed: vm.switchCandidate,
          child: const Text('Next (F3)'),
        ),
        OutlinedButton(
          onPressed: vm.pasteSelectedCandidate,
          child: const Text('Paste (F4)'),
        ),
      ],
    );
  }

  /// 当前 Profile 的参数区（OCR 语言、maxTurns）。
  Widget _buildProfileControls(AIReplyAssistState vm) {
    final profile = vm.activeProfile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<String>(
            initialValue: profile.ocrLang,
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                  value: 'zh-Hans', child: Text('zh-Hans')),
              DropdownMenuItem<String>(
                  value: 'zh-Hant', child: Text('zh-Hant')),
              DropdownMenuItem<String>(value: 'en-US', child: Text('en-US')),
            ],
            onChanged: (String? value) {
              if (value != null) vm.setCurrentOcrLang(value);
            },
            decoration:
                const InputDecoration(labelText: 'OCR Lang', isDense: true),
          ),
        ),
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<int>(
            initialValue: profile.maxTurns,
            items: const <int>[8, 10, 12, 15, 20, 30]
                .map((int e) => DropdownMenuItem<int>(
                      value: e,
                      child: Text('$e turns'),
                    ))
                .toList(),
            onChanged: (int? v) {
              if (v != null) vm.setCurrentMaxTurns(v);
            },
            decoration:
                const InputDecoration(labelText: 'Max Turns', isDense: true),
          ),
        ),
      ],
    );
  }

  /// ROI 编辑区（聊天 ROI + 输入 ROI）。
  Widget _buildRoiControls(AIReplyAssistState vm, Roi chatRoi, Roi inputRoi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _buildRoiEditor(
            title: 'Chat ROI',
            roi: chatRoi,
            onNudge: vm.nudgeCurrentChatRoi,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildRoiEditor(
            title: 'Input ROI',
            roi: inputRoi,
            onNudge: vm.nudgeCurrentInputRoi,
          ),
        ),
      ],
    );
  }

  /// 单个 ROI 编辑卡片。
  Widget _buildRoiEditor({
    required String title,
    required Roi roi,
    required void Function(String field, double delta) onNudge,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffdfe3e8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: <Widget>[
              _buildRoiNudgeItem('x', roi.x, (double d) => onNudge('x', d)),
              _buildRoiNudgeItem('y', roi.y, (double d) => onNudge('y', d)),
              _buildRoiNudgeItem('w', roi.w, (double d) => onNudge('w', d)),
              _buildRoiNudgeItem('h', roi.h, (double d) => onNudge('h', d)),
            ],
          ),
        ],
      ),
    );
  }

  /// ROI 单字段微调控件（±5 logical px）。
  Widget _buildRoiNudgeItem(
      String label, double value, void Function(double delta) onNudge) {
    return Container(
      width: 155,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xfff7f9fc),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xffe3e8ef)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('$label: ${value.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12)),
          ),
          InkWell(
            onTap: () => onNudge(-5),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.remove_circle_outline, size: 18),
            ),
          ),
          InkWell(
            onTap: () => onNudge(5),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.add_circle_outline, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// LLM 直连配置区（仅 openai/claude 模式显示）。
  Widget _buildLlmConfig(AIReplyAssistState vm) {
    if (vm.llmMode == LlmMode.backend) {
      return const SizedBox.shrink();
    }

    final bool isOpenAi = vm.llmMode == LlmMode.openai;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffdfe3e8)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          SizedBox(
            width: 430,
            child: TextFormField(
              initialValue: isOpenAi ? vm.openAiApiKey : vm.claudeApiKey,
              onChanged: (String v) =>
                  isOpenAi ? vm.setOpenAiApiKey(v) : vm.setClaudeApiKey(v),
              obscureText: true,
              decoration: InputDecoration(
                labelText: isOpenAi ? 'OpenAI API Key' : 'Claude API Key',
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            width: 220,
            child: TextFormField(
              initialValue: isOpenAi ? vm.openAiModel : vm.claudeModel,
              onChanged: (String v) =>
                  isOpenAi ? vm.setOpenAiModel(v) : vm.setClaudeModel(v),
              decoration: InputDecoration(
                labelText: isOpenAi ? 'OpenAI Model' : 'Claude Model',
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 预览区：全屏 + ROI 叠层、聊天裁剪图。
  Widget _buildPreviewSection(AIReplyAssistState vm) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _buildPreviewCard(
            title: 'Full Capture + ROI Overlay',
            child: _buildCapturePreview(vm),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPreviewCard(
            title: 'Chat Crop Preview',
            child: _buildImagePreview(vm.chatCropPng),
          ),
        ),
      ],
    );
  }

  /// 通用卡片容器。
  Widget _buildPreviewCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffdfe3e8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  /// 全屏截图预览，并叠加 chat/input 两个 ROI。
  Widget _buildCapturePreview(AIReplyAssistState vm) {
    final capture = vm.lastCapture;
    final profile = vm.activeProfile;
    if (capture == null || profile == null) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No capture yet')),
      );
    }

    final double aspect =
        capture.heightPx == 0 ? 16 / 10 : capture.widthPx / capture.heightPx;

    return AspectRatio(
      aspectRatio: aspect,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double logicalW =
              capture.widthLogical <= 0 ? 1 : capture.widthLogical;
          final double logicalH =
              capture.heightLogical <= 0 ? 1 : capture.heightLogical;
          final double sx = constraints.maxWidth / logicalW;
          final double sy = constraints.maxHeight / logicalH;

          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.memory(
                  capture.png,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                ),
              ),
              _buildOverlay(profile.chatRoi, sx, sy, const Color(0xffff5c5c)),
              _buildOverlay(profile.inputRoi, sx, sy, const Color(0xff4f8cff)),
            ],
          );
        },
      ),
    );
  }

  /// ROI 可视化框。
  Widget _buildOverlay(Roi roi, double sx, double sy, Color color) {
    return Positioned(
      left: roi.x * sx,
      top: roi.y * sy,
      width: roi.w * sx,
      height: roi.h * sy,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            color: color.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }

  /// 二进制图片预览。
  Widget _buildImagePreview(Uint8List? bytes) {
    if (bytes == null) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No crop yet')),
      );
    }
    return Image.memory(bytes, fit: BoxFit.contain, gaplessPlayback: true);
  }

  /// 候选回复区（推荐 + 备选 + 风险 + followups）。
  Widget _buildReplySection(AIReplyAssistState vm) {
    final pack = vm.replyPack;
    if (pack == null) {
      return _buildPreviewCard(
        title: 'Reply Candidates',
        child: const SizedBox(
            height: 100, child: Center(child: Text('No reply yet'))),
      );
    }

    final List<ReplyCandidate> all = <ReplyCandidate>[
      pack.recommended,
      ...pack.alternatives
    ];

    return _buildPreviewCard(
      title: 'Reply Candidates',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...List<Widget>.generate(all.length, (int index) {
            final ReplyCandidate item = all[index];
            final bool selected = vm.selectedCandidateIndex == index;
            return InkWell(
              onTap: () => vm.setSelectedCandidateIndex(index),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xffeaf3ff)
                      : const Color(0xfff8f9fb),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: selected
                        ? const Color(0xff4f8cff)
                        : const Color(0xffe3e8ef),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      index == 0 ? 'Recommended' : 'Alternative $index',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(item.text),
                    if ((item.reason ?? '').trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Reason: ${item.reason}',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xff666666)),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          if (pack.risks.isNotEmpty)
            Text(
              'Risks: ${pack.risks.map((e) => '[${e.level}] ${e.note}').join(' | ')}',
              style: const TextStyle(fontSize: 12, color: Color(0xffa45000)),
            ),
          if (pack.followups.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Followups: ${pack.followups.join(' | ')}',
                style: const TextStyle(fontSize: 12, color: Color(0xff225c99)),
              ),
            ),
        ],
      ),
    );
  }

  /// OCR 原文、清洗结果与日志面板。
  Widget _buildTextPanels(AIReplyAssistState vm) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _buildPreviewCard(
            title: 'OCR / Cleaned Messages',
            child: SizedBox(
              height: 180,
              child: SingleChildScrollView(
                child: SelectableText(
                  'Raw OCR:\n${vm.rawOcrText}\n\nCleaned:\n${vm.cleanedMessages.join('\n')}',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPreviewCard(
            title: 'Logs',
            child: SizedBox(
              height: 180,
              child: SingleChildScrollView(
                reverse: true,
                child: SelectableText(vm.logs.reversed.join('\n')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
