import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppAiChatComposer extends StatefulWidget {
  const AppAiChatComposer({
    required this.onSubmit,
    this.onStartVoiceRecording,
    this.onStopVoiceRecording,
    this.onCancelVoiceRecording,
    this.liveVoiceTextListenable,
    this.hintText =
        'Ask about the workspace, request an edit, or trigger an agent flow...',
    this.voiceStartTooltip = 'Voice input',
    this.voiceStopTooltip = 'Stop recording',
    this.voiceCancelTooltip = 'Cancel recording',
    this.voiceRecordingLabel = 'Listening...',
    this.voiceTranscribingLabel = 'Transcribing...',
    super.key,
  });

  final ValueChanged<String> onSubmit;
  final Future<Map<String, Object?>> Function()? onStartVoiceRecording;
  final Future<Map<String, Object?>> Function()? onStopVoiceRecording;
  final Future<Map<String, Object?>> Function()? onCancelVoiceRecording;
  final ValueListenable<String>? liveVoiceTextListenable;
  final String hintText;
  final String voiceStartTooltip;
  final String voiceStopTooltip;
  final String voiceCancelTooltip;
  final String voiceRecordingLabel;
  final String voiceTranscribingLabel;

  @override
  State<AppAiChatComposer> createState() => _AppAiChatComposerState();
}

class _AppAiChatComposerState extends State<AppAiChatComposer> {
  late final TextEditingController _controller;
  bool _isVoiceRecording = false;
  bool _isVoiceTranscribing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(content: Text('Please enter a prompt before sending.')),
      );
      return;
    }
    widget.onSubmit(value);
    _controller.clear();
  }

  Future<void> _startVoiceRecording() async {
    final startVoiceRecording = widget.onStartVoiceRecording;
    if (startVoiceRecording == null || _isVoiceRecording) {
      return;
    }
    try {
      await startVoiceRecording();
      if (!mounted) {
        return;
      }
      setState(() {
        _isVoiceRecording = true;
        _isVoiceTranscribing = false;
      });
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _stopVoiceRecording() async {
    final stopVoiceRecording = widget.onStopVoiceRecording;
    if (stopVoiceRecording == null || !_isVoiceRecording) {
      return;
    }
    setState(() {
      _isVoiceTranscribing = true;
    });
    try {
      final result = await stopVoiceRecording();
      if (!mounted) {
        return;
      }
      final text = (result['text'] ?? '').toString().trim();
      if (text.isNotEmpty) {
        _appendVoiceText(text);
      }
      setState(() {
        _isVoiceRecording = false;
        _isVoiceTranscribing = false;
      });
      if (text.isEmpty) {
        _showMessage('No speech was recognized.');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isVoiceRecording = false;
        _isVoiceTranscribing = false;
      });
      _showMessage(error.toString());
    }
  }

  Future<void> _cancelVoiceRecording() async {
    final cancelVoiceRecording = widget.onCancelVoiceRecording;
    if (cancelVoiceRecording == null) {
      return;
    }
    try {
      await cancelVoiceRecording();
    } finally {
      if (mounted) {
        setState(() {
          _isVoiceRecording = false;
          _isVoiceTranscribing = false;
        });
      }
    }
  }

  void _appendVoiceText(String text) {
    final current = _controller.text;
    final separator =
        current.trim().isEmpty || RegExp(r'\s$').hasMatch(current) ? '' : ' ';
    final next = '$current$separator$text';
    _controller
      ..text = next
      ..selection = TextSelection.collapsed(offset: next.length);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(SnackBar(content: Text(message)));
  }

  /// 功能：桌面端按 Enter 直接发送，Shift+Enter 保留多行输入。
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final isEnter = event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter || HardwareKeyboard.instance.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    _submit();
    return KeyEventResult.handled;
  }

  Widget _buildVoiceStatusText() {
    final textListenable = widget.liveVoiceTextListenable;
    if (!_isVoiceRecording && !_isVoiceTranscribing) {
      return const SizedBox.shrink();
    }
    if (textListenable == null) {
      return _VoiceStatusLine(
        text: _isVoiceTranscribing
            ? widget.voiceTranscribingLabel
            : widget.voiceRecordingLabel,
      );
    }
    return ValueListenableBuilder<String>(
      valueListenable: textListenable,
      builder: (context, liveText, child) {
        final trimmedLiveText = liveText.trim();
        return _VoiceStatusLine(
          text: trimmedLiveText.isNotEmpty
              ? trimmedLiveText
              : (_isVoiceTranscribing
                  ? widget.voiceTranscribingLabel
                  : widget.voiceRecordingLabel),
        );
      },
    );
  }

  Widget _buildVoiceControls() {
    if (widget.onStartVoiceRecording == null ||
        widget.onStopVoiceRecording == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isVoiceRecording)
          IconButton(
            tooltip: widget.voiceCancelTooltip,
            onPressed: _isVoiceTranscribing ? null : _cancelVoiceRecording,
            icon: const Icon(Icons.close),
          ),
        IconButton.filledTonal(
          tooltip: _isVoiceRecording
              ? widget.voiceStopTooltip
              : widget.voiceStartTooltip,
          onPressed: _isVoiceTranscribing
              ? null
              : (_isVoiceRecording
                  ? _stopVoiceRecording
                  : _startVoiceRecording),
          style: IconButton.styleFrom(
            backgroundColor: _isVoiceRecording
                ? const Color(0xFFFFE1E1)
                : const Color(0xFFE7F2EE),
            foregroundColor: _isVoiceRecording
                ? const Color(0xFFD04545)
                : const Color(0xFF157E69),
            minimumSize: const Size(48, 48),
          ),
          icon: Icon(_isVoiceRecording ? Icons.stop_rounded : Icons.mic_none),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFD7E4E0))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Focus(
                  onKeyEvent: _handleKeyEvent,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      filled: true,
                      fillColor: const Color(0xFFF4F8F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFCBDDD6)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFCBDDD6)),
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildVoiceControls(),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(100, 52),
                  backgroundColor: const Color(0xFF157E69),
                ),
                child: const Text('Send'),
              ),
            ],
          ),
          _buildVoiceStatusText(),
        ],
      ),
    );
  }
}

class _VoiceStatusLine extends StatelessWidget {
  const _VoiceStatusLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF5F756F),
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
