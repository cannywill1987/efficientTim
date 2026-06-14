/// 文件类型：组件
/// 文件作用：提供聊天/AI 创建任务页面底部输入栏，支持文字输入、快捷建议、发送和移动端语音转文字输入。
/// 主要职责：维护输入框状态，处理发送事件，并把录音、OSS 上传、ASR 转写后的文本回填给上层 AI 创建任务流程。
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:time_hello/com/timehello/beans/SuggestionBean.dart';
import 'package:time_hello/com/timehello/page/FeedbackPage/FeedbackPage.dart';
import 'package:time_hello/com/timehello/util/AppAiVoiceRecordUtils.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/VoiceTranscriptionManager.dart';

import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';

class ChatInputWidget extends StatefulWidget {
  final Function onClickSendMsg;
  final Widget? headerWidget;
  final List<SuggestionBean>? listSuggest;
  final bool isLoading;
  final String? placeholder;

  ChatInputWidget(
      {Key? key,
      this.listSuggest,
      this.placeholder,
      this.isLoading = false,
      this.headerWidget,
      required this.onClickSendMsg})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatInputWidgetState();
  }
}

class ChatInputWidgetState extends State<ChatInputWidget> {
  static const int _voiceMaxSeconds = 30;

  TextEditingController inputController = TextEditingController();
  String value = "";
  FocusNode? _contentFocusNode = FocusNode();
  final AppAiVoiceRecordUtils _voiceRecordUtils = AppAiVoiceRecordUtils();
  Timer? _voiceTimer;
  bool _isVoiceRecording = false;
  bool _isVoiceTranscribing = false;
  int _voiceRecordingSeconds = 0;

  // SuggestionsController controller;
  late SuggestionsController<SuggestionBean> suggestionsController;

  unfocus() {
    _contentFocusNode?.unfocus();
  }

  setText(String txt) {
    inputController.text = txt;
  }

  refresh() {
    suggestionsController.refresh();
    // controller.refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    suggestionsController = SuggestionsController();

    // controller = SuggestionsController();
  }

  @override
  void dispose() {
    _voiceTimer?.cancel();
    // 页面退出时异步释放录音器，避免麦克风句柄残留影响下一次录音。
    unawaited(_voiceRecordUtils.dispose());
    super.dispose();
  }

  bool get _isVoiceBusy => _isVoiceRecording || _isVoiceTranscribing;

  /**
   * 功能：启动移动端 AI 语音输入录音。
   * 说明：Web 端继续保留旧提示；移动端和桌面端原生环境复用 AppAIPlugin 的录音工具，避免重复实现录音链路。
   */
  Future<void> _startVoiceInput() async {
    if (_isVoiceBusy) {
      return;
    }
    if (widget.isLoading == true) {
      Utility.showToastMsg(msg: getI18NKey().requesting_please_wait);
      return;
    }
    if (DeviceInfoManagement.isWEB()) {
      Utility.showToastMsg(context: context, msg: getI18NKey().voice_guide);
      return;
    }
    try {
      await _voiceRecordUtils.start();
      if (!mounted) {
        return;
      }
      setState(() {
        _isVoiceRecording = true;
        _isVoiceTranscribing = false;
        _voiceRecordingSeconds = 0;
      });
      _startVoiceTimer();
    } catch (error) {
      Utility.showToastMsg(context: context, msg: error.toString());
    }
  }

  /**
   * 功能：停止录音、上传音频并转写为文本，成功后把文本追加到 AI 创建任务输入框。
   * 说明：这里只负责语音转文本，不直接发送消息，保留用户检查和继续编辑的空间。
   */
  Future<void> _stopVoiceInput() async {
    if (_isVoiceRecording == false || _isVoiceTranscribing == true) {
      return;
    }
    _voiceTimer?.cancel();
    setState(() {
      _isVoiceRecording = false;
      _isVoiceTranscribing = true;
    });
    try {
      final recordResult = await _voiceRecordUtils.stop();
      final transcriptionResult = await VoiceTranscriptionManager.getInstance()
          .transcribeLocalAudioFile(
        localPath: recordResult.path,
        fileNamePrefix: 'mission_ai_voice',
      );
      final String text = transcriptionResult.text.trim();
      if (text.isEmpty) {
        Utility.showToastMsg(context: context, msg: getI18NKey().voice_guide);
        return;
      }
      _appendVoiceTextToInput(text);
    } catch (error) {
      Utility.showToastMsg(context: context, msg: error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isVoiceRecording = false;
          _isVoiceTranscribing = false;
          _voiceRecordingSeconds = 0;
        });
      }
    }
  }

  /**
   * 功能：取消当前语音输入，丢弃本地临时录音文件，不触发 OSS 上传和 ASR 转写。
   */
  Future<void> _cancelVoiceInput() async {
    if (_isVoiceBusy == false) {
      return;
    }
    _voiceTimer?.cancel();
    try {
      await _voiceRecordUtils.cancel();
    } catch (error) {
      Utility.showToastMsg(context: context, msg: error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isVoiceRecording = false;
          _isVoiceTranscribing = false;
          _voiceRecordingSeconds = 0;
        });
      }
    }
  }

  /**
   * 功能：维护录音时长，并在达到最大时长后自动结束录音。
   */
  void _startVoiceTimer() {
    _voiceTimer?.cancel();
    _voiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isVoiceRecording == false) {
        timer.cancel();
        return;
      }
      final int nextSeconds = _voiceRecordingSeconds + 1;
      setState(() {
        _voiceRecordingSeconds = nextSeconds;
      });
      if (nextSeconds >= _voiceMaxSeconds) {
        timer.cancel();
        unawaited(_stopVoiceInput());
      }
    });
  }

  /**
   * 功能：把识别文本追加到输入框末尾，并把光标移动到文本末尾。
   */
  void _appendVoiceTextToInput(String text) {
    final String current = inputController.text.trim();
    final String nextText = current.isEmpty ? text : "$current\n$text";
    inputController.text = nextText;
    inputController.selection =
        TextSelection.collapsed(offset: nextText.length);
    value = nextText;
    _contentFocusNode?.requestFocus();
  }

  String _formatVoiceDuration(int seconds) {
    final String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final String restSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$restSeconds";
  }

  /**
   * 功能：构建移动端语音录制控制条，参考 AppAIPlugin 的内联录音交互。
   */
  Widget _buildVoiceRecorderPanel() {
    final bool isDark = ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
    final Color panelColor =
        isDark ? const Color(0xFF1F1D22) : const Color(0xFFFFF5F7);
    final Color borderColor =
        isDark ? const Color(0xFF36303A) : const Color(0xFFFFDEE8);
    final Color primaryTextColor =
        isDark ? const Color(0xFFF5F2F4) : const Color(0xFF53474D);
    final Color secondaryTextColor =
        isDark ? const Color(0xFFB9ADB5) : const Color(0xFF9B838C);
    final bool isTranscribing = _isVoiceTranscribing;

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildVoiceCircleButton(
            icon: Icons.close_rounded,
            label: getI18NKey().cancel,
            backgroundColor:
                isDark ? const Color(0xFF343039) : const Color(0xFFFFFFFF),
            foregroundColor: secondaryTextColor,
            enabled: isTranscribing == false,
            onTap: _cancelVoiceInput,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic_rounded,
                        size: 18,
                        color: isTranscribing
                            ? ThemeManager.getInstance().getDefautThemeColor()
                            : ColorsConfig.darkRed),
                    const SizedBox(width: 6),
                    Text(
                      isTranscribing
                          ? getI18NKey().app_ai_voice_transcribing
                          : getI18NKey().app_ai_voice_recording,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatVoiceDuration(_voiceRecordingSeconds),
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 13,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildVoiceWaveform(isDark: isDark),
                const SizedBox(height: 6),
                Text(
                  isTranscribing
                      ? getI18NKey().app_ai_voice_transcribing_hint
                      : getI18NKey().app_ai_voice_stop_hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: secondaryTextColor, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildVoiceCircleButton(
            icon: isTranscribing ? Icons.hourglass_top_rounded : Icons.stop,
            label: isTranscribing
                ? getI18NKey().app_ai_voice_transcribing_action
                : getI18NKey().finished,
            backgroundColor: ColorsConfig.darkRed,
            foregroundColor: Colors.white,
            enabled: isTranscribing == false,
            onTap: _stopVoiceInput,
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceCircleButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: enabled ? onTap : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: foregroundColor, size: 23),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 54,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: foregroundColor == Colors.white
                      ? ColorsConfig.darkRed
                      : foregroundColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceWaveform({required bool isDark}) {
    final List<int> heights = <int>[
      4,
      7,
      5,
      10,
      13,
      8,
      16,
      9,
      18,
      7,
      14,
      17,
      9,
      22,
      11,
      16,
      24,
      10,
      19,
      14,
      25,
      13,
      20,
      11,
      16,
      23,
      12,
      18,
      8,
      14,
    ];
    final Color activeColor = _isVoiceTranscribing
        ? ThemeManager.getInstance().getDefautThemeColor()
        : ColorsConfig.darkRed;
    final Color inactiveColor =
        isDark ? const Color(0xFF5F5662) : const Color(0xFFE5CCD3);
    final int activeCount =
        ((_voiceRecordingSeconds / _voiceMaxSeconds) * heights.length)
            .ceil()
            .clamp(1, heights.length);

    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(heights.length, (index) {
          final bool isActive = index < activeCount;
          return Container(
            width: 3,
            height: heights[index].toDouble(),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(
          maxHeight: this.widget.headerWidget != null ? 380 : 140,
          minHeight: 60),
      color: ThemeManager.getInstance().getBackgroundColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (this.widget.headerWidget != null)
            SizedBox(
              height: 10,
            ),
          this.widget.headerWidget ??
              SizedBox(
                height: 0,
              ),
          Container(
            margin: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
                top: this.widget.headerWidget != null ? 5 : 10),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                          color: ThemeManager.getInstance()
                              .getInputDecorationColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                unawaited(_startVoiceInput());
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.mic,
                                  color: _isVoiceBusy
                                      ? ThemeManager.getInstance()
                                          .getDefautThemeColor()
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TypeAheadField<SuggestionBean>(
                                // controller: controller,
                                suggestionsController: suggestionsController,
                                hideOnEmpty: true,
                                autoFlipDirection: true,
                                onSelected: (value) {
                                  inputController.text =
                                      value.suggestionContent ?? '';
                                  // this.widget.onClickSendMsg(inputController.text);
                                  // inputController.text = '';
                                },
                                itemBuilder: (BuildContext context,
                                    SuggestionBean? value) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    color: ThemeManager.getInstance()
                                        .getCardBackgroundColor(),
                                    alignment: Alignment.centerLeft,
                                    constraints: BoxConstraints(minHeight: 40),
                                    child: Text(value?.suggestion ?? ""),
                                  );
                                },
                                suggestionsCallback: (search) {
                                  if (TextUtil.isEmpty(search)) {
                                    return this.widget.listSuggest;
                                  }
                                  List<SuggestionBean> listReturns = [];
                                  for (var item
                                      in this.widget.listSuggest ?? []) {
                                    if (item.suggestion
                                            ?.toLowerCase()
                                            .contains(search.toLowerCase()) ==
                                        true) {
                                      listReturns.add(item);
                                    }
                                  }
                                  return listReturns;
                                },

                                // ...
                                // controller: myTextEditingController, // your custom controller, or null
                                builder: (context, controller, focusNode) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 200.0, // 设置TextField的最大高度
                                    ),
                                    child: TextField(
                                      // expands: true,
                                      keyboardType: TextInputType.multiline,
                                      minLines: DeviceInfoManagement.isWEB()
                                          ? 1
                                          : null,

                                      maxLines: DeviceInfoManagement.isWEB()
                                          ? 1
                                          : null,
                                      // 允许TextField高度自适应内容，直到达到最大高度限制
                                      // decoration: InputDecoration(
                                      //   hintText: 'Enter multiple lines here',
                                      //   border: OutlineInputBorder(),
                                      // ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(
                                            500), // 限制最大输入长度为500字符
                                      ],
                                      // enabled: this.isLoading2 == 0,
                                      focusNode: _contentFocusNode = focusNode,
                                      controller: inputController = controller,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (val) {
                                        // callback for regular enter key press
                                        this.widget.onClickSendMsg(
                                            inputController.text);
                                        inputController.text = '';
                                      },
                                      onEditingComplete: () {
                                        final isCtrlPressed = HardwareKeyboard
                                            .instance.logicalKeysPressed
                                            .contains(
                                                LogicalKeyboardKey.controlLeft);
                                        if (isCtrlPressed) {
                                          // insert a new line character
                                          inputController.value =
                                              TextEditingValue(
                                            text: inputController.text + '\n',
                                            selection: TextSelection.collapsed(
                                                offset: inputController
                                                        .text.length +
                                                    1),
                                          );
                                        } else {
                                          // trigger the callback for regular enter key press
                                          // this.onClickSendMsg(inputController.text);
                                        }
                                      },
                                      scrollController: ScrollController(),
                                      onChanged: (val) {
                                        this.value = val;
                                      },
                                      decoration: InputDecoration(
                                        hintText: this.widget.placeholder ??
                                            getI18NKey()
                                                .please_enter_your_question,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (this.widget.isLoading == true) {
                      Utility.showToastMsg(
                          msg: getI18NKey().requesting_please_wait);
                      return;
                    }
                    this.widget.onClickSendMsg(inputController.text);
                    inputController.text = '';
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeManager.getInstance().getCardBackgroundColor(
                          defaultColor: Color(0xff9ea2f9)),
                      shape: BoxShape.circle,
                    ),
                    child: this.widget.isLoading
                        ? CupertinoActivityIndicator()
                        : Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (_isVoiceBusy) _buildVoiceRecorderPanel(),
          SizedBox(
            height: 3,
          ),
          Utility.isHandsetBySize()
              ? SizedBox.shrink()
              : Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          getI18NKey().newline(CONSTANTS.getNewLineText()),
                          style:
                              TextStyle(color: Color(0xffa0a0a0), fontSize: 12),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Utility.pushNavigator(context, FeedbackPage());
                        },
                        child: Text(
                          getI18NKey().report2,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ))
                  ],
                )
        ],
      ),
    );
  }
}
