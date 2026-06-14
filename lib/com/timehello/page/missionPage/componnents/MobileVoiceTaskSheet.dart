/// 文件类型：组件
/// 文件作用：移动端长按加号后弹出的语音创建任务底部面板。
/// 主要职责：启动录音、展示语音波形、完成转写，并把普通/AI 创建模式交给外层页面执行。
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/AppAiVoiceRecordUtils.dart';
import 'package:time_hello/com/timehello/util/AiVoiceDebugLog.dart';
import 'package:time_hello/com/timehello/util/MobileVoiceTaskManager.dart';
import 'package:time_hello/com/timehello/util/RealtimeVoiceTranscriptionManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/VoiceTranscriptionManager.dart';

class MobileVoiceTaskPayload {
  const MobileVoiceTaskPayload({
    required this.text,
    required this.mode,
  });

  final String text;
  final MobileVoiceTaskMode mode;
}

typedef MobileVoiceTaskSubmitCallback = Future<String?> Function(
  MobileVoiceTaskPayload payload,
);

class MobileVoiceTaskSheet extends StatefulWidget {
  const MobileVoiceTaskSheet({
    super.key,
    required this.onSubmit,
  });

  final MobileVoiceTaskSubmitCallback onSubmit;

  /// 功能：以底部弹窗形式打开语音创建任务面板。
  /// 说明：使用 showModalBottomSheet 保留原页面上下文，方便创建成功后刷新当前任务列表。
  static Future<void> show({
    required BuildContext context,
    required MobileVoiceTaskSubmitCallback onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (sheetContext) {
        return MobileVoiceTaskSheet(onSubmit: onSubmit);
      },
    );
  }

  @override
  State<MobileVoiceTaskSheet> createState() => _MobileVoiceTaskSheetState();
}

class _MobileVoiceTaskSheetState extends State<MobileVoiceTaskSheet> {
  static const int _maxRecordSeconds = 30;

  final AppAiVoiceRecordUtils _recordUtils = AppAiVoiceRecordUtils();
  final RealtimeVoiceTranscriptionManager _realtimeTranscriptionManager =
      RealtimeVoiceTranscriptionManager();
  final List<String> _realtimeFinalTexts = <String>[];
  final TextEditingController _recognizedTextController =
      TextEditingController();
  final FocusNode _recognizedTextFocusNode = FocusNode();
  Timer? _timer;
  String _realtimePartialText = '';
  bool _isRecording = false;
  bool _isTranscribing = false;
  bool _isSubmitting = false;
  bool _useRealtimeTranscription = true;
  bool _showRecognizedEditor = false;
  bool _isRealtimeFallbackRunning = false;
  bool _isFileFallbackRecording = false;
  int _recordSeconds = 0;
  String _recognizedText = '';
  MobileVoiceTaskMode _mode = MobileVoiceTaskMode.normal;

  bool get _hasRecognizedText => !TextUtil.isEmpty(_recognizedText);

  @override
  void initState() {
    super.initState();
    _recognizedTextFocusNode.addListener(_handleRecognizedFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_startRecording());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recognizedTextFocusNode.removeListener(_handleRecognizedFocusChanged);
    _recognizedTextController.dispose();
    _recognizedTextFocusNode.dispose();
    unawaited(_recordUtils.dispose());
    unawaited(_realtimeTranscriptionManager.dispose());
    super.dispose();
  }

  /// 功能：开始录音并重置识别状态。
  /// 说明：长按加号打开面板后立即录音，减少“先打开再点一次”的移动端操作成本。
  Future<void> _startRecording() async {
    if (_isRecording || _isTranscribing || _isSubmitting) {
      AiVoiceDebugLog.log(
        'sheet-start-skip',
        'isRecording=$_isRecording, isTranscribing=$_isTranscribing, isSubmitting=$_isSubmitting',
      );
      return;
    }
    try {
      _resetRecognitionState();
      AiVoiceDebugLog.log(
        'sheet-start',
        'useRealtime=$_useRealtimeTranscription',
      );
      if (_useRealtimeTranscription) {
        try {
          _isFileFallbackRecording = false;
          await _realtimeTranscriptionManager.start(
            onUpdate: _handleRealtimeUpdate,
            onError: _handleRealtimeError,
          );
        } catch (_) {
          // 实时 ASR 对 key 权限要求更严格，失败时自动回退到录完识别，避免用户入口直接不可用。
          await _realtimeTranscriptionManager.cancel();
          if (!mounted) {
            return;
          }
          await _switchToFileRecordingAfterRealtimeFailure(
            shouldStartTimer: false,
          );
        }
      } else {
        await _recordUtils.start();
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _isRecording = true;
        _isTranscribing = false;
        _recordSeconds = 0;
      });
      AiVoiceDebugLog.log(
        'sheet-start-done',
        'useRealtime=$_useRealtimeTranscription, recordSeconds=$_recordSeconds',
      );
      _startTimer();
    } catch (error, stackTrace) {
      AiVoiceDebugLog.log(
        'sheet-start-error',
        'useRealtime=$_useRealtimeTranscription, errorType=${error.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
      Utility.showToastMsg(context: context, msg: error.toString());
    }
  }

  /// 功能：停止录音并走 OSS + 百炼转写，成功后根据关键词标记普通模式或 AI 模式。
  Future<void> _stopAndTranscribe() async {
    if (!_isRecording || _isTranscribing || _isSubmitting) {
      return;
    }
    _timer?.cancel();
    AiVoiceDebugLog.log(
      'sheet-stop-start',
      'useRealtime=$_useRealtimeTranscription, recordSeconds=$_recordSeconds, hasText=$_hasRecognizedText',
    );
    setState(() {
      _isRecording = false;
      _isTranscribing = _isFileFallbackRecording || !_useRealtimeTranscription;
    });

    try {
      if (_useRealtimeTranscription && !_isFileFallbackRecording) {
        await _realtimeTranscriptionManager.stop();
        AiVoiceDebugLog.log(
          'sheet-realtime-stop-result',
          'textLength=${_recognizedText.trim().length}',
        );
        if (TextUtil.isEmpty(_recognizedText.trim())) {
          Utility.showToastMsg(
            context: context,
            msg: getI18NKey().mobile_voice_task_empty,
          );
        } else {
          _focusRecognizedEditorAfterFrame();
        }
        return;
      }
      final recordResult = await _recordUtils.stop();
      AiVoiceDebugLog.log(
        'sheet-file-record-stop',
        'duration=${recordResult.duration}, fileSize=${recordResult.fileSize}, pathLength=${recordResult.path.length}',
      );
      final transcriptionResult = await VoiceTranscriptionManager.getInstance()
          .transcribeLocalAudioFile(
        localPath: recordResult.path,
        fileNamePrefix: 'mobile_voice_task',
      );
      final text = transcriptionResult.text.trim();
      AiVoiceDebugLog.log(
        'sheet-file-transcribe-result',
        'textLength=${text.length}, audioUrlLength=${transcriptionResult.audioUrl.length}',
      );
      if (TextUtil.isEmpty(text)) {
        Utility.showToastMsg(
          context: context,
          msg: getI18NKey().mobile_voice_task_empty,
        );
        return;
      }
      _applyRecognizedText(text, shouldFocusEditor: true);
    } catch (error, stackTrace) {
      AiVoiceDebugLog.log(
        'sheet-stop-error',
        'useRealtime=$_useRealtimeTranscription, errorType=${error.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
      Utility.showToastMsg(context: context, msg: error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _isTranscribing = false;
        });
      }
    }
  }

  /// 功能：取消录音并关闭面板，确保未确认的本地临时录音会被清理。
  Future<void> _closeSheet() async {
    _timer?.cancel();
    AiVoiceDebugLog.log(
      'sheet-close',
      'useRealtime=$_useRealtimeTranscription, isRecording=$_isRecording, hasText=$_hasRecognizedText',
    );
    try {
      await _realtimeTranscriptionManager.cancel();
      await _recordUtils.cancel();
    } catch (_) {}
    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  /// 功能：确认当前识别文本并交给外层创建任务。
  /// 说明：外层页面拥有当前清单、四象限和日期上下文，因此真正写库放在外层处理。
  Future<void> _submitRecognizedText() async {
    if (_isSubmitting || !_hasRecognizedText) {
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    AiVoiceDebugLog.log(
      'sheet-submit-start',
      'mode=${_mode.name}, textLength=${_recognizedText.length}',
    );
    try {
      final message = await widget.onSubmit(
        MobileVoiceTaskPayload(text: _recognizedText, mode: _mode),
      );
      if (!TextUtil.isEmpty(message)) {
        Utility.showToastMsg(context: context, msg: message ?? '');
      }
      if (mounted) {
        Navigator.of(context).maybePop();
      }
      AiVoiceDebugLog.log('sheet-submit-success', 'mode=${_mode.name}');
    } catch (error, stackTrace) {
      AiVoiceDebugLog.log(
        'sheet-submit-error',
        'mode=${_mode.name}, errorType=${error.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
      Utility.showToastMsg(context: context, msg: error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// 功能：维护录音时长，并在达到上限后自动停止转写。
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isRecording) {
        timer.cancel();
        return;
      }
      final nextSeconds = _recordSeconds + 1;
      setState(() {
        _recordSeconds = nextSeconds;
      });
      if (nextSeconds >= _maxRecordSeconds) {
        timer.cancel();
        unawaited(_stopAndTranscribe());
      }
    });
  }

  /// 功能：重置两套转写方案共用的识别状态，避免上一轮残留文本影响当前模式判断。
  void _resetRecognitionState() {
    _realtimeFinalTexts.clear();
    _realtimePartialText = '';
    _recognizedText = '';
    _recognizedTextController.clear();
    _recognizedTextFocusNode.unfocus();
    _showRecognizedEditor = false;
    _isFileFallbackRecording = false;
    _mode = MobileVoiceTaskMode.normal;
    AiVoiceDebugLog.log(
        'sheet-reset', 'useRealtime=$_useRealtimeTranscription');
  }

  /// 功能：接收百炼实时识别片段，并合并成面板中持续刷新的完整文本。
  void _handleRealtimeUpdate(RealtimeVoiceTranscriptionUpdate update) {
    if (!mounted) {
      return;
    }
    if (update.isFinal) {
      if (!TextUtil.isEmpty(update.text) &&
          (_realtimeFinalTexts.isEmpty ||
              _realtimeFinalTexts.last != update.text)) {
        _realtimeFinalTexts.add(update.text);
      }
      _realtimePartialText = '';
    } else {
      _realtimePartialText = update.text;
    }
    final text = <String>[
      ..._realtimeFinalTexts,
      if (!TextUtil.isEmpty(_realtimePartialText)) _realtimePartialText,
    ].join('');
    AiVoiceDebugLog.log(
      'sheet-realtime-update',
      'textLength=${text.length}, isFinal=${update.isFinal}',
    );
    _applyRecognizedText(text);
  }

  /// 功能：把实时识别异常回显给用户，避免 WebSocket 失败时静默卡住录音面板。
  void _handleRealtimeError(Object error) {
    unawaited(_switchToFileRecordingAfterRealtimeFailure());
  }

  /// 功能：实时识别运行中失败时，真实切换到录完识别方案继续录音。
  /// 说明：WebSocket 的 401/断开可能在 start 成功后异步返回，不能只提示文案而保留实时模式勾选状态。
  Future<void> _switchToFileRecordingAfterRealtimeFailure({
    bool shouldStartTimer = true,
  }) async {
    if (_isRealtimeFallbackRunning || !mounted) {
      AiVoiceDebugLog.log(
        'sheet-realtime-fallback-skip',
        'isRunning=$_isRealtimeFallbackRunning, mounted=$mounted',
      );
      return;
    }
    _isRealtimeFallbackRunning = true;
    try {
      AiVoiceDebugLog.log(
        'sheet-realtime-fallback-start',
        'shouldStartTimer=$shouldStartTimer, wasRecording=$_isRecording',
      );
      _timer?.cancel();
      await _realtimeTranscriptionManager.cancel();
      if (!mounted) {
        return;
      }
      if (!_recordUtils.isRecording) {
        await _recordUtils.start();
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _isFileFallbackRecording = true;
        _isRecording = true;
        _isTranscribing = false;
        _recordSeconds = 0;
      });
      Utility.showToastMsg(
        context: context,
        msg: getI18NKey().mobile_voice_task_realtime_fallback,
      );
      if (shouldStartTimer) {
        _startTimer();
      }
      AiVoiceDebugLog.log(
        'sheet-realtime-fallback-done',
        'useRealtime=$_useRealtimeTranscription, isRecording=$_isRecording',
      );
    } catch (error, stackTrace) {
      AiVoiceDebugLog.log(
        'sheet-realtime-fallback-error',
        'errorType=${error.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        Utility.showToastMsg(context: context, msg: error.toString());
      }
    } finally {
      _isRealtimeFallbackRunning = false;
    }
  }

  /// 功能：统一更新识别结果、编辑框内容和普通/AI 模式。
  /// 说明：实时识别会频繁刷新文本，录完识别只刷新一次，所以这里集中处理光标和模式状态。
  void _applyRecognizedText(String text, {bool shouldFocusEditor = false}) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognizedText = text;
      if (!TextUtil.isEmpty(text)) {
        _showRecognizedEditor = true;
      }
      _mode = MobileVoiceTaskManager.shouldUseAiMode(text)
          ? MobileVoiceTaskMode.ai
          : MobileVoiceTaskMode.normal;
    });
    if (_recognizedTextController.text != text) {
      _recognizedTextController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    if (shouldFocusEditor) {
      _focusRecognizedEditorAfterFrame();
    }
  }

  /// 功能：监听编辑框焦点变化，键盘弹起/收起时刷新底部面板布局。
  void _handleRecognizedFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// 功能：识别完成后把焦点切到编辑框，方便用户立即修改识别文字。
  void _focusRecognizedEditorAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isRecording && _hasRecognizedText) {
        _recognizedTextFocusNode.requestFocus();
      }
    });
  }

  /// 功能：用户手动编辑识别文本时，同步更新最终提交文本和任务创建模式。
  void _handleRecognizedTextChanged(String text) {
    setState(() {
      _recognizedText = text;
      _mode = MobileVoiceTaskManager.shouldUseAiMode(text)
          ? MobileVoiceTaskMode.ai
          : MobileVoiceTaskMode.normal;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final restSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$restSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark ||
        ThemeManager.getInstance().getThemeMode().isDark;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final panelColor = isDark ? const Color(0xFF1F1D22) : Colors.white;
    final primaryText = isDark ? Colors.white : const Color(0xFF211A17);
    final secondaryText =
        isDark ? const Color(0xFFBDB2B8) : const Color(0xFF9A8B86);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        constraints: BoxConstraints(
          minHeight: keyboardInset > 0 ? 300 : 360,
          maxHeight: keyboardInset > 0 ? 390 : 470,
        ),
        padding: EdgeInsets.fromLTRB(
            22, 20, 22, keyboardInset > 0 ? 18 : 24 + bottomInset),
        decoration: BoxDecoration(
          color: panelColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
              blurRadius: 30,
              offset: const Offset(0, -12),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _buildModePill(isDark: isDark),
                const Spacer(),
                IconButton(
                  onPressed: _closeSheet,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildMainContent(
                isDark: isDark,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
            ),
            if (!_recognizedTextFocusNode.hasFocus) ...<Widget>[
              const SizedBox(height: 10),
              _buildWaveControl(isDark: isDark),
              const SizedBox(height: 14),
              Text(
                _footerHint(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModePill({required bool isDark}) {
    final isAiMode = _mode == MobileVoiceTaskMode.ai;
    final color = isAiMode ? const Color(0xFFE86B96) : const Color(0xFF9B8A84);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isAiMode ? Icons.auto_awesome_rounded : Icons.graphic_eq_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            isAiMode
                ? getI18NKey().mobile_voice_task_ai_mode
                : getI18NKey().mobile_voice_task_record_mode,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent({
    required bool isDark,
    required Color primaryText,
    required Color secondaryText,
  }) {
    if (_showRecognizedEditor && !_isRecording && !_isTranscribing) {
      return _buildRecognizedTextEditor(
        isDark: isDark,
        primaryText: primaryText,
        secondaryText: secondaryText,
      );
    }
    return Center(
      child: Text(
        _displayText(),
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: primaryText,
          fontSize: _hasRecognizedText ? 22 : 24,
          height: 1.35,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /// 功能：展示可编辑的识别结果输入框。
  /// 说明：用户停止录音后先确认/修正 ASR 文本，再点击底部确认按钮创建任务。
  Widget _buildRecognizedTextEditor({
    required bool isDark,
    required Color primaryText,
    required Color secondaryText,
  }) {
    final borderColors = _mode == MobileVoiceTaskMode.ai
        ? const <Color>[Color(0xFFFF9AC4), Color(0xFF98B8FF)]
        : const <Color>[Color(0xFF9EEBD8), Color(0xFFB6C9FF)];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: borderColors),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.4),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF28232B) : const Color(0xFFFFFCFE),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Stack(
          children: <Widget>[
            TextField(
              controller: _recognizedTextController,
              focusNode: _recognizedTextFocusNode,
              onChanged: _handleRecognizedTextChanged,
              maxLength: 100,
              maxLines: null,
              minLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              cursorColor: const Color(0xFF438CFF),
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterStyle: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: const EdgeInsets.only(right: 54, bottom: 8),
                isCollapsed: true,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: _isSubmitting
                    ? null
                    : () => unawaited(_submitRecognizedText()),
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF15C8A3)
                        .withValues(alpha: isDark ? 0.22 : 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: _isSubmitting
                      ? const CupertinoActivityIndicator()
                      : const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF15C8A3),
                          size: 26,
                        ),
                ),
              ),
            ),
            Positioned(
              right: 2,
              bottom: 22,
              child: IgnorePointer(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 36,
                  color:
                      borderColors.last.withValues(alpha: isDark ? 0.28 : 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _displayText() {
    if (_hasRecognizedText) {
      return _recognizedText;
    }
    if (_isTranscribing) {
      return getI18NKey().app_ai_voice_transcribing;
    }
    if (_isRecording) {
      if (_useRealtimeTranscription) {
        return getI18NKey().mobile_voice_task_realtime_listening_text;
      }
      return getI18NKey().mobile_voice_task_listening_text;
    }
    return getI18NKey().mobile_voice_task_speak_title;
  }

  String _footerHint() {
    if (_isSubmitting) {
      return _mode == MobileVoiceTaskMode.ai
          ? getI18NKey().mobile_voice_task_ai_creating
          : getI18NKey().mobile_voice_task_direct_creating;
    }
    if (_isTranscribing) {
      return getI18NKey().app_ai_voice_transcribing_hint;
    }
    if (_isRecording && _useRealtimeTranscription) {
      return '${getI18NKey().mobile_voice_task_realtime_hint} ${_formatDuration(_recordSeconds)}';
    }
    if (_hasRecognizedText) {
      return getI18NKey().confirm;
    }
    return '${getI18NKey().app_ai_voice_stop_hint} ${_formatDuration(_recordSeconds)}';
  }

  Widget _buildWaveControl({required bool isDark}) {
    final activeColor = _mode == MobileVoiceTaskMode.ai
        ? const Color(0xFFE86B96)
        : const Color(0xFF15C8A3);
    final inactiveColor =
        isDark ? const Color(0xFF5B535A) : const Color(0xFFEADFE2);

    return Row(
      children: <Widget>[
        _roundButton(
          icon: Icons.mic_none_rounded,
          backgroundColor:
              isDark ? const Color(0xFF2A252C) : const Color(0xFFF8F1F3),
          iconColor: _isRecording ? activeColor : const Color(0xFF9A8B86),
          onTap: _isRecording || _isTranscribing || _isSubmitting
              ? null
              : _startRecording,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF29252B) : const Color(0xFFFFF7F9),
              borderRadius: BorderRadius.circular(27),
            ),
            child: _buildWaveform(
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _roundButton(
          icon: _trailingIcon(),
          backgroundColor: _hasRecognizedText
              ? const Color(0xFF15C8A3)
              : const Color(0xFFE86B96),
          iconColor: Colors.white,
          isLoading: _isTranscribing || _isSubmitting,
          onTap: _trailingTap,
        ),
      ],
    );
  }

  IconData _trailingIcon() {
    if (_hasRecognizedText) {
      return Icons.check_rounded;
    }
    return _isRecording ? Icons.graphic_eq_rounded : Icons.mic_rounded;
  }

  VoidCallback? get _trailingTap {
    if (_isTranscribing || _isSubmitting) {
      return null;
    }
    if (_isRecording) {
      return () => unawaited(_stopAndTranscribe());
    }
    if (_hasRecognizedText) {
      return () => unawaited(_submitRecognizedText());
    }
    return () => unawaited(_startRecording());
  }

  Widget _roundButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? CupertinoActivityIndicator(color: iconColor)
            : Icon(icon, color: iconColor, size: 30),
      ),
    );
  }

  Widget _buildWaveform({
    required Color activeColor,
    required Color inactiveColor,
  }) {
    const heights = <double>[
      4,
      5,
      7,
      10,
      14,
      22,
      19,
      13,
      9,
      8,
      12,
      18,
      25,
      32,
      28,
      20,
      12,
      8,
      7,
      10,
      14,
      19,
      25,
      31,
      22,
      15,
      10,
      7,
      5,
      4,
    ];
    final activeCount = _hasRecognizedText
        ? heights.length
        : ((_recordSeconds / _maxRecordSeconds) * heights.length)
            .ceil()
            .clamp(1, heights.length);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(heights.length, (index) {
        final isActive =
            index < activeCount && (_isRecording || _hasRecognizedText);
        return Container(
          width: 2.5,
          height: heights[index],
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
