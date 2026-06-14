/// 文件类型：页面
/// 文件作用：提供语音录制、试听、确认和上传入口。
/// 主要职责：在笔记、日记、获取 URL 等场景中复用同一套录音 UI 与 OSS 上传链路。
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/util/AliyunStoreManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import 'package:record/record.dart';
import '../../models/EventFn.dart';
import '../../util/DialogManagement.dart';
import '../../util/EasyLoadingManager.dart';
import '../../util/Utility.dart';
import '../../util/VoiceTranscriptionManager.dart';

typedef RecordSubmitWithText = void Function(
  String title,
  String path,
  String localPath,
  int duration,
  int fileSize,
  String recordText,
);

class RecordPage2 extends BaseWidget {
  final RichTextModeEnum richTextModeEnum;
  final bool? shouldShowTitle;
  final void Function(String title, String path, String localPath, int duration,
      int fileSize)? onSubmit;
  final RecordSubmitWithText? onSubmitWithText;
  final VoidCallback? onCancel;
  const RecordPage2({
    required this.shouldShowTitle,
    required this.richTextModeEnum,
    required this.onSubmit,
    this.onSubmitWithText,
    this.onCancel,
  });

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return RecordPage2State();
  }
}

class RecordPage2State extends BaseWidgetState<RecordPage2> {
  String? audioPath;
  String? title;
  String recordText = '';
  int duration = 0;

  componentDidMount() {
    DialogManagement.getInstance()
        .showRequestVoicePermissiondialog(this.context, okCallback: () {});
  }

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    return Center(
      child: _AudioRecorder(
        onConfirm: (path, duration, recordText) {
          // 新版录音弹窗把预览和保存合并到同一流程，只有确认时才触发上传/保存。
          setState(() {
            this.duration = duration;
            audioPath = path;
            this.recordText = recordText;
          });
          requestFinish(duration: duration, path: path);
        },
        richTextModeEnum: this.widget.richTextModeEnum,
        onCancel: () {
          // 外层功能（例如 AI 语音转文字）需要知道用户取消，避免宿主请求一直等待。
          this.widget.onCancel?.call();
          Utility.popupPagePCAndMobile(context);
        },
      ),
    );
  }

  Future requestFinish({required int duration, required String path}) async {
    if (this.widget.richTextModeEnum == RichTextModeEnum.diary) {
      DialogManagement.getInstance().showEditTitleDialog(
          Utility.getGlobalContext(),
          title: getI18NKey().write_a_title,
          initVal: "", okCallBack: (String title) async {
        // String? path = await RecorderManager.getInstance().stop();
        EasyLoadingManager.getInstance().showLoading();
        File file = new File(path);
        // BaseBean res = await HttpManager.getInstance()
        //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);

        String url = await AliyunStoreManager.getInstance()
            .uploadFileByFilePath(
                docType: DocType.audio,
                path: file.path,
                fileExtensionEnum: _audioExtensionFromPath(file.path),
                fileName: Utility.getUUID());

        MongoDbSaved? resMongoDbSave;
        resMongoDbSave = await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
                missionModel: Utility.getTimelineMissionModelFromMissionModel(
                    sceneType: 'diary',
                    eventType: 'diary_voice',
                    icon: Icons.mic.codePoint,
                    color: Colors.teal.toARGB32(),
                    timelineMessage: title.isEmpty
                        ? getI18NKey().complete_voice_diary
                        : getI18NKey().complete_voice_diary_with_title(title),
                    extra: jsonEncode({
                      "file": file.lengthSync(),
                      "duration": duration,
                      "url": url,
                      "localUrl": file.path,
                      "recordText": recordText,
                    })));
        EasyLoadingManager.getInstance().dismiss();
        Navigator.pop(Utility.getGlobalContext());
        handleSuccessResult(resMongoDbSave);
      }, cancelCallBack: () {
        EasyLoadingManager.getInstance().dismiss();
        DialogManagement.getInstance().hideDialog(context);
      });
    } else if (this.widget.richTextModeEnum == RichTextModeEnum.getUrl) {
      EasyLoadingManager.getInstance().showLoading();
      // String? path = await RecorderManager.getInstance().stop();
      File file = new File(path);
      String url = await AliyunStoreManager.getInstance().uploadFileByFilePath(
          docType: DocType.audio,
          path: file.path,
          fileExtensionEnum: _audioExtensionFromPath(file.path),
          fileName: Utility.getUUID());

      // BaseBean res = await HttpManager.getInstance()
      //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
      final String transcript = recordText.trim();
      if (this.widget.onSubmitWithText != null) {
        this.widget.onSubmitWithText?.call(title ?? "", url,
            this.audioPath ?? "", duration, file.lengthSync(), transcript);
      } else {
        this.widget.onSubmit?.call(title ?? "", url, this.audioPath ?? "",
            duration, file.lengthSync());
      }
      EasyLoadingManager.getInstance().dismiss();
      Utility.popupPagePCAndMobile(context);
    } else {
      EasyLoadingManager.getInstance().showLoading();
      // String? path = await RecorderManager.getInstance().stop();
      File file = new File(path);
      String url = await AliyunStoreManager.getInstance().uploadFileByFilePath(
          docType: DocType.audio,
          path: file.path,
          fileExtensionEnum: _audioExtensionFromPath(file.path),
          fileName: Utility.getUUID());

      // BaseBean res = await HttpManager.getInstance()
      //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
      MongoDbSaved? resMongoDbSave =
          await MongoApisManager.getInstance().insertTimelineMissionModel(
              missionModel: Utility.getTimelineMissionModelFromMissionModel(
                  sceneType: 'note',
                  eventType: 'note_voice',
                  icon: Icons.graphic_eq.codePoint,
                  color: Colors.teal.toARGB32(),
                  timelineMessage: getI18NKey().complete_voice_note,
                  extra: jsonEncode({
                    "file": file.lengthSync(),
                    "duration": duration,
                    "url": url,
                    "localUrl": file.path,
                    "recordText": recordText,
                  })));
      final String transcript = recordText.trim();
      if (this.widget.onSubmitWithText != null) {
        this.widget.onSubmitWithText?.call(title ?? "", url,
            this.audioPath ?? "", duration, file.lengthSync(), transcript);
      } else {
        this.widget.onSubmit?.call(title ?? "", url, this.audioPath ?? "",
            duration, file.lengthSync());
      }
      handleSuccessResult(resMongoDbSave);
    }
  }

  void handleSuccessResult(MongoDbSaved? resMongoDbSave) {
    EasyLoadingManager.getInstance().dismiss();
    if (resMongoDbSave != null) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      Utility.showToastMsg(
          context: Utility.getGlobalContext(),
          msg: getI18NKey().add_successfully);
      // this.widget.onSubmit?.call(title ?? "", this.audioPath ?? "", this.duration);
      if (Utility.isHandsetBySize()) {
        Utility.popNavigator(this.context);
        // Navigator.pop(context);
      } else {
        DialogManagement.getInstance().hideDialog(this.context);
      }
      Utility.popupPagePCAndMobile(context);
    } else {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().add_fail);
    }
  }

  /// 功能：根据本地录音文件后缀选择 OSS 文件扩展名，确保后续 ASR 能按真实音频格式读取。
  FileExtension _audioExtensionFromPath(String path) {
    final extension = p.extension(path).replaceFirst('.', '').toLowerCase();
    switch (extension) {
      case 'mp3':
        return FileExtension.mp3;
      case 'wav':
        return FileExtension.wav;
      case 'aac':
        return FileExtension.aac;
      case 'amr':
        return FileExtension.amr;
      case 'm4a':
      default:
        return FileExtension.m4a;
    }
  }
}

class _AudioRecorder extends StatefulWidget {
  final void Function(String path, int duration, String recordText) onConfirm;
  final RichTextModeEnum richTextModeEnum;
  final VoidCallback onCancel;

  const _AudioRecorder({
    Key? key,
    required this.onConfirm,
    required this.richTextModeEnum,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<_AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<_AudioRecorder> {
  static const int _maxRecordSeconds = 10 * 60;
  int _recordDuration = 0;
  int _recordedDuration = 0;
  String? _recordedPath;
  DateTime? _recordedAt;
  Timer? _timer;
  late final AudioRecorder audioRecorder;
  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer()
    ..setReleaseMode(ap.ReleaseMode.stop);
  StreamSubscription<RecordState>? recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  StreamSubscription<void>? _playerCompleteSub;
  StreamSubscription<Duration?>? _playerDurationSub;
  StreamSubscription<Duration>? _playerPositionSub;
  Amplitude? _amplitude;
  Duration? _playbackDuration;
  Duration? _playbackPosition;
  bool _isConfirming = false;
  bool _isTranscribing = false;
  String _transcriptionText = '';
  String _transcriptionError = '';
  int _transcriptionRequestId = 0;

  /// 功能：判断当前录音弹窗是否采用手机视觉模式。
  /// 说明：PC 小窗口调试时也可能进入窄屏布局，所以不能只依赖全局 screenType。
  bool get _isMobileVisualMode {
    final mediaQuery = MediaQuery.maybeOf(context);
    return Utility.isHandsetBySize() || (mediaQuery?.size.width ?? 9999) < 760;
  }

  Color get _recordPrimaryColor =>
      _isMobileVisualMode ? const Color(0xff4f6df5) : const Color(0xfff04438);

  @override
  void initState() {
    audioRecorder = AudioRecorder();

    recordSub = audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    _amplitudeSub = audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

    _playerCompleteSub = _audioPlayer.onPlayerComplete.listen((_) async {
      await _audioPlayer.stop();
      if (mounted) {
        setState(() => _playbackPosition = Duration.zero);
      }
    });
    _playerDurationSub = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _playbackDuration = duration);
    });
    _playerPositionSub = _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _playbackPosition = position);
    });

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.aacLc;

        // We don't do anything with this but printing
        final isSupported = await audioRecorder.isEncoderSupported(
          encoder,
        );

        debugPrint('${encoder.name} supported: $isSupported');

        final devs = await audioRecorder.listInputDevices();
        debugPrint(devs.toString());

        const config = RecordConfig(
          encoder: encoder,
          numChannels: 1,
          bitRate: 128000, // by default
          // sampleRate: 22050, // by default
        );

        // Record to file
        String path;
        // if (kIsWeb) {
        //   path = '';
        // } else {
        final dir = await getTemporaryDirectory();
        path = p.join(
          dir.path,
          'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
        // }
        await audioRecorder.start(config, path: path);

        // Record to stream
        // final file = File(path);
        // final stream = await _audioRecorder.startStream(config);
        // stream.listen(
        //   (data) {
        //     // ignore: avoid_print
        //     print(
        //       _audioRecorder.convertBytesToInt16(Uint8List.fromList(data)),
        //     );
        //     file.writeAsBytesSync(data, mode: FileMode.append);
        //   },
        //   // ignore: avoid_print
        //   onDone: () => print('End of stream'),
        // );

        // Record to stream web
        // var b = <Uint8List>[];
        // final stream = await _audioRecorder.startStream(config);
        // stream.listen(
        //   (data) {
        //     b.add(data);
        //   },
        //   onDone: () {
        //     _downloadWebData(html.Url.createObjectUrl(html.Blob(b)));
        //   },
        // );

        await _audioPlayer.stop();
        setState(() {
          _recordDuration = 0;
          _recordedDuration = 0;
          _recordedPath = null;
          _recordedAt = null;
          _playbackDuration = null;
          _playbackPosition = Duration.zero;
          _transcriptionText = '';
          _transcriptionError = '';
        });

        _startTimer();
      } else {
        EasyLoading.showToast(getI18NKey().no_microphone_permission);
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print(e);
      // }
    }
  }

  Future<void> _stop() async {
    final int duration = _recordDuration;
    final path = await audioRecorder.stop() ?? "";
    if (path.isNotEmpty) {
      setState(() {
        _recordedPath = path;
        _recordedDuration = duration;
        _recordedAt = DateTime.now();
        _recordState = RecordState.stop;
        _recordDuration = duration;
        _playbackPosition = Duration.zero;
        _playbackDuration = Duration(seconds: duration);
      });
    }
  }

  // void _downloadWebData(String path) {
  //   // Simple download code for web testing
  //   final anchor = html.document.createElement('a') as html.AnchorElement
  //     ..href = path
  //     ..style.display = 'none'
  //     ..download = 'audio.wav';
  //   html.document.body!.children.add(anchor);
  //   anchor.click();
  //   html.document.body!.children.remove(anchor);
  //   html.Url.revokeObjectUrl(path);
  // }

  Future<void> _pause() => audioRecorder.pause();

  Future<void> _resume() => audioRecorder.resume();

  void _updateRecordState(RecordState recordState) {
    setState(() => _recordState = recordState);

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        _startTimer();
        break;
      case RecordState.stop:
        _timer?.cancel();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileLayout =
        Utility.isHandsetBySize() || MediaQuery.of(context).size.width < 760;
    if (isMobileLayout) {
      return _buildMobileRecorder(context);
    }

    // 外层弹窗已经负责遮罩和定位，这里只渲染录音卡片，避免出现双层灰色对话框。
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ThemeManager.getInstance()
                    .getCardBackgroundColor(defaultColor: Colors.white),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 32,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildRecordingStepPanel()),
                        const SizedBox(width: 22),
                        Expanded(flex: 5, child: _buildPreviewStepPanel()),
                        const SizedBox(width: 22),
                        Expanded(
                            flex: 4, child: _buildTranscriptionStepPanel()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildFooterActions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 功能：移动端使用单列长页面承载录音、试听和 AI 转写，避免把 PC 三栏弹窗压缩到窄屏。
  /// 说明：这里仍复用同一套录音状态和上传链路，只改变小屏幕的视觉组织方式。
  Widget _buildMobileRecorder(BuildContext context) {
    final Color surfaceColor = ThemeManager.getInstance()
        .getCardBackgroundColor(defaultColor: Colors.white);
    return Material(
      color: surfaceColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
              child: _buildHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                child: Column(
                  children: [
                    _buildRecordingStepPanel(),
                    const SizedBox(height: 14),
                    _buildMobilePreviewStepPanel(),
                    const SizedBox(height: 14),
                    _buildMobileTranscriptionStepPanel(),
                  ],
                ),
              ),
            ),
            _buildMobileFooterActions(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    recordSub?.cancel();
    _amplitudeSub?.cancel();
    _playerCompleteSub?.cancel();
    _playerDurationSub?.cancel();
    _playerPositionSub?.cancel();
    _audioPlayer.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    final Color titleColor = ThemeManager.getInstance().getTextColor();
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xfff04438).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.mic_rounded, color: Color(0xfff04438), size: 30),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getI18NKey().record_voice,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                getI18NKey().record_voice_description,
                style: TextStyle(
                  color: titleColor.withValues(alpha: 0.58),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: getI18NKey().cancel,
          onPressed: _handleCancel,
          icon: Icon(
            Icons.close_rounded,
            color: titleColor.withValues(alpha: 0.64),
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveformPanel() {
    final String timer = _formatDuration(_recordDuration);
    final Color primaryColor = _recordPrimaryColor;
    return Container(
      height: 230,
      padding: const EdgeInsets.fromLTRB(22, 18, 16, 18),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance().isDark()
            ? const Color(0xff1f1f1f)
            : const Color(0xfffffdfb),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeManager.getInstance().isDark()
              ? const Color(0xff343434)
              : const Color(0xffeadfd6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStepTitle(
            getI18NKey().recording_step_title,
            _recordState == RecordState.stop && _recordedPath != null
                ? getI18NKey().record_complete
                : _recordState == RecordState.pause
                    ? getI18NKey().recording_paused
                    : _recordState == RecordState.record
                        ? getI18NKey().recording_now
                        : getI18NKey().tap_to_start_recording,
            _recordState != RecordState.stop,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              painter: _RecordingWaveformPainter(
                amplitude: _normalizedAmplitude,
                progress: (_recordDuration / _maxRecordSeconds).clamp(0, 1),
                isRecording: _recordState == RecordState.record,
                accentColor: primaryColor,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            timer,
            style: TextStyle(
              color: _isMobileVisualMode
                  ? ThemeManager.getInstance().getTextColor()
                  : primaryColor,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${getI18NKey().max_record_duration} ${_formatDuration(_maxRecordSeconds)}',
            style: TextStyle(
              color: ThemeManager.getInstance()
                  .getTextColor()
                  .withValues(alpha: 0.62),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingStepPanel() {
    return _buildStepCard(
      child: Column(
        children: [
          _buildWaveformPanel(),
          const SizedBox(height: 24),
          _buildControls(),
          const SizedBox(height: 24),
          _buildTips(),
        ],
      ),
    );
  }

  Widget _buildPreviewStepPanel() {
    final bool hasRecording = _recordedPath != null;
    return _buildStepCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            getI18NKey().playback_preview,
            hasRecording
                ? getI18NKey().record_complete
                : getI18NKey().no_recording_preview,
            false,
            success: hasRecording,
          ),
          const SizedBox(height: 24),
          _buildPreviewPlayer(hasRecording),
          const SizedBox(height: 18),
          _buildRecordingInfo(hasRecording),
          const SizedBox(height: 18),
          _buildRerecordBlock(hasRecording),
        ],
      ),
    );
  }

  /// 功能：移动端回放区保持轻量，只展示播放波形和速度，减少录音弹窗在手机上的纵向负担。
  Widget _buildMobilePreviewStepPanel() {
    final bool hasRecording = _recordedPath != null;
    return _buildStepCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            getI18NKey().playback_preview,
            hasRecording
                ? getI18NKey().record_complete
                : getI18NKey().no_recording_preview,
            false,
            success: hasRecording,
          ),
          const SizedBox(height: 18),
          _buildPreviewPlayer(hasRecording),
        ],
      ),
    );
  }

  Widget _buildTranscriptionStepPanel() {
    final bool hasRecording = _recordedPath != null;
    final bool hasText = _transcriptionText.trim().isNotEmpty;
    final bool hasError = _transcriptionError.trim().isNotEmpty;
    return _buildStepCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      _recordAiText(
                        zh: '3. AI 转写',
                        en: '3. AI transcription',
                      ),
                      style: TextStyle(
                        color: ThemeManager.getInstance().getTextColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff8b5cf6).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Beta',
                        style: TextStyle(
                          color: Color(0xff8b5cf6),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed:
                    hasRecording && !_isTranscribing ? _handleTranscribe : null,
                icon: _isTranscribing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ThemeManager.getInstance().getTextColor(),
                        ),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 16),
                label: Text(
                  _isTranscribing
                      ? _recordAiText(zh: '转写中', en: 'Transcribing')
                      : _recordAiText(zh: 'AI 转写', en: 'AI Transcribe'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeManager.getInstance().getTextColor(),
                  side: BorderSide(
                    color: ThemeManager.getInstance()
                        .getTextColor()
                        .withValues(alpha: 0.14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ThemeManager.getInstance().isDark()
                  ? const Color(0xff242424)
                  : const Color(0xfffffbf8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeManager.getInstance()
                    .getTextColor()
                    .withValues(alpha: 0.08),
              ),
            ),
            child: _buildTranscriptionBody(
              hasText: hasText,
              hasError: hasError,
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: hasText ? _copyTranscriptionText : null,
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: Text(_recordAiText(zh: '复制文字', en: 'Copy text')),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeManager.getInstance().getTextColor(),
                side: BorderSide(
                  color: ThemeManager.getInstance()
                      .getTextColor()
                      .withValues(alpha: 0.14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能：移动端 AI 转写区采用卡片内按钮和可滚动文本框，贴近手机设计稿的单列阅读方式。
  Widget _buildMobileTranscriptionStepPanel() {
    final bool hasRecording = _recordedPath != null;
    final bool hasText = _transcriptionText.trim().isNotEmpty;
    final bool hasError = _transcriptionError.trim().isNotEmpty;
    return _buildStepCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildTranscriptionTitle()),
              const SizedBox(width: 10),
              _buildTranscribeButton(hasRecording: hasRecording),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            constraints: const BoxConstraints(minHeight: 190),
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ThemeManager.getInstance().isDark()
                  ? const Color(0xff242424)
                  : const Color(0xfffffbf8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeManager.getInstance()
                    .getTextColor()
                    .withValues(alpha: 0.08),
              ),
            ),
            child: _buildTranscriptionBody(
              hasText: hasText,
              hasError: hasError,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: _buildCopyTranscriptionButton(hasText: hasText),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionTitle() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        Text(
          _recordAiText(
            zh: '3. AI 转写',
            en: '3. AI transcription',
          ),
          style: TextStyle(
            color: ThemeManager.getInstance().getTextColor(),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff8b5cf6).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Beta',
            style: TextStyle(
              color: Color(0xff8b5cf6),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTranscribeButton({required bool hasRecording}) {
    return OutlinedButton.icon(
      onPressed: hasRecording && !_isTranscribing ? _handleTranscribe : null,
      icon: _isTranscribing
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ThemeManager.getInstance().getTextColor(),
              ),
            )
          : const Icon(Icons.auto_awesome_rounded, size: 16),
      label: Text(
        _isTranscribing
            ? _recordAiText(zh: '转写中', en: 'Transcribing')
            : _recordAiText(zh: 'AI 转写', en: 'AI Transcribe'),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeManager.getInstance().getTextColor(),
        side: BorderSide(
          color:
              ThemeManager.getInstance().getTextColor().withValues(alpha: 0.14),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
      ),
    );
  }

  Widget _buildCopyTranscriptionButton({required bool hasText}) {
    return OutlinedButton.icon(
      onPressed: hasText ? _copyTranscriptionText : null,
      icon: const Icon(Icons.copy_rounded, size: 16),
      label: Text(_recordAiText(zh: '复制文字', en: 'Copy text')),
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeManager.getInstance().getTextColor(),
        side: BorderSide(
          color:
              ThemeManager.getInstance().getTextColor().withValues(alpha: 0.14),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
      ),
    );
  }

  Widget _buildTranscriptionBody({
    required bool hasText,
    required bool hasError,
  }) {
    final Color textColor = ThemeManager.getInstance().getTextColor();
    if (_isTranscribing) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xfff04438),
            ),
            const SizedBox(height: 14),
            Text(
              _recordAiText(
                zh: '正在识别录音内容...',
                en: 'Transcribing the recording...',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.66),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }
    if (hasText) {
      return Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8),
          child: SelectableText(
            _transcriptionText,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.88),
              fontSize: 14,
              height: 1.58,
            ),
          ),
        ),
      );
    }
    if (hasError) {
      return Center(
        child: Text(
          _transcriptionError,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xfff04438),
            fontSize: 13,
            height: 1.45,
          ),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            color: textColor.withValues(alpha: 0.24),
            size: 42,
          ),
          const SizedBox(height: 14),
          Text(
            _recordAiText(
              zh: '转写文字会显示在这里',
              en: 'Transcribed text will appear here',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.48),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _recordAiText(
              zh: '录音完成后点击上方按钮生成',
              en: 'Click the button above after recording',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.38),
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance().isDark()
            ? const Color(0xff1f1f1f)
            : const Color(0xfffffdfb),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeManager.getInstance().isDark()
              ? const Color(0xff343434)
              : const Color(0xffeadfd6),
        ),
      ),
      child: child,
    );
  }

  Widget _buildStepTitle(
    String title,
    String status,
    bool isActive, {
    bool success = false,
  }) {
    final Color textColor = ThemeManager.getInstance().getTextColor();
    final Color statusColor = success
        ? const Color(0xff37a65a)
        : isActive
            ? const Color(0xfff04438)
            : textColor.withValues(alpha: 0.55);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(
          success ? Icons.check_circle_rounded : Icons.circle,
          color: statusColor,
          size: success ? 16 : 10,
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSideAction(
          icon: Icons.delete_outline_rounded,
          label: getI18NKey().delete,
          onTap: _handleDelete,
        ),
        const SizedBox(width: 48),
        _buildPrimaryRecordAction(),
        const SizedBox(width: 48),
        _buildSideAction(
          icon: _recordState == RecordState.pause
              ? Icons.play_arrow_rounded
              : Icons.pause_rounded,
          label: _recordState == RecordState.pause
              ? getI18NKey().resume
              : getI18NKey().pause,
          onTap: _recordState == RecordState.stop
              ? null
              : () {
                  (_recordState == RecordState.pause) ? _resume() : _pause();
                },
        ),
      ],
    );
  }

  Widget _buildPrimaryRecordAction() {
    final bool isStopped = _recordState == RecordState.stop;
    final bool hasRecording = _recordedPath != null;
    final Color primaryColor = _recordPrimaryColor;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(54),
          onTap:
              isStopped && hasRecording ? null : (isStopped ? _start : _stop),
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isStopped && hasRecording
                    ? Icons.check_rounded
                    : isStopped
                        ? Icons.mic_rounded
                        : Icons.stop_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isStopped
                    ? Colors.grey.withValues(alpha: 0.65)
                    : primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              isStopped
                  ? hasRecording
                      ? getI18NKey().record_complete
                      : getI18NKey().tap_to_start_recording
                  : _recordState == RecordState.pause
                      ? getI18NKey().recording_paused
                      : getI18NKey().recording_now,
              style: TextStyle(
                color: isStopped
                    ? ThemeManager.getInstance()
                        .getTextColor()
                        .withValues(alpha: 0.58)
                    : primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSideAction({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final Color color = ThemeManager.getInstance()
        .getTextColor()
        .withValues(alpha: onTap == null ? 0.28 : 0.70);
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeManager.getInstance()
                    .getTextColor()
                    .withValues(alpha: 0.12),
              ),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance().isDark()
            ? const Color(0xff202020)
            : const Color(0xfffaf7f4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTip(Icons.graphic_eq_rounded, getI18NKey().record_tip_clear),
          _buildTip(Icons.timer_outlined, getI18NKey().record_tip_max),
          _buildTip(
              Icons.lightbulb_outline_rounded, getI18NKey().record_tip_replay),
        ],
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xffc47a32), size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ThemeManager.getInstance()
                    .getTextColor()
                    .withValues(alpha: 0.62),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions() {
    final bool canConfirm = _recordedPath != null && !_isConfirming;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterButton(
          label: getI18NKey().cancel,
          isPrimary: false,
          onTap: _handleCancel,
        ),
        const SizedBox(width: 34),
        _buildFooterButton(
          label: getI18NKey().confirm,
          isPrimary: true,
          onTap: canConfirm ? _handleConfirm : null,
        ),
      ],
    );
  }

  /// 功能：手机底部固定取消和确认按钮，避免用户录完后还要滚到页面底部才能保存。
  Widget _buildMobileFooterActions() {
    final bool canConfirm = _recordedPath != null && !_isConfirming;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance()
            .getCardBackgroundColor(defaultColor: Colors.white),
        border: Border(
          top: BorderSide(
            color: ThemeManager.getInstance()
                .getTextColor()
                .withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMobileFooterButton(
              label: getI18NKey().cancel,
              isPrimary: false,
              onTap: _handleCancel,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: _buildMobileFooterButton(
              label: getI18NKey().confirm,
              isPrimary: true,
              onTap: canConfirm ? _handleConfirm : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooterButton({
    required String label,
    required bool isPrimary,
    required VoidCallback? onTap,
  }) {
    final BorderRadius borderRadius = BorderRadius.circular(14);
    final Color disabledColor = const Color(0xff4f6df5).withValues(alpha: 0.38);
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: isPrimary && onTap != null
              ? const LinearGradient(
                  colors: [Color(0xff5b7cfa), Color(0xff4167f2)],
                )
              : null,
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: isPrimary
                ? (onTap == null ? disabledColor : Colors.transparent)
                : ThemeManager.getInstance()
                    .getCardBackgroundColor(defaultColor: Colors.white),
            disabledBackgroundColor: isPrimary ? disabledColor : null,
            foregroundColor: isPrimary
                ? Colors.white
                : ThemeManager.getInstance().getTextColor(),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: isPrimary
                  ? BorderSide.none
                  : BorderSide(
                      color: ThemeManager.getInstance()
                          .getTextColor()
                          .withValues(alpha: 0.12),
                    ),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterButton({
    required String label,
    required bool isPrimary,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 160,
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isPrimary
              ? const Color(0xfff04438)
              : ThemeManager.getInstance()
                  .getCardBackgroundColor(defaultColor: Colors.white),
          disabledBackgroundColor:
              const Color(0xfff04438).withValues(alpha: 0.38),
          foregroundColor: isPrimary
              ? Colors.white
              : ThemeManager.getInstance().getTextColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: ThemeManager.getInstance()
                        .getTextColor()
                        .withValues(alpha: 0.12),
                  ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _handleDelete() async {
    if (_recordState != RecordState.stop) {
      await audioRecorder.stop();
    }
    await _audioPlayer.stop();
    setState(() {
      _recordDuration = 0;
      _recordedDuration = 0;
      _recordedPath = null;
      _recordedAt = null;
      _recordState = RecordState.stop;
      _amplitude = null;
      _playbackDuration = null;
      _playbackPosition = Duration.zero;
      _isTranscribing = false;
      _transcriptionText = '';
      _transcriptionError = '';
      _transcriptionRequestId++;
    });
  }

  Future<void> _handleCancel() async {
    if (_recordState != RecordState.stop) {
      await audioRecorder.stop();
    }
    await _audioPlayer.stop();
    widget.onCancel();
  }

  Future<void> _handleConfirm() async {
    final String? path = _recordedPath;
    if (path == null || _isConfirming) {
      return;
    }
    await _audioPlayer.stop();
    setState(() => _isConfirming = true);
    // 录音确认时把当前 AI 转写结果一起回传给父级，父级保存 record map 时
    // 可以把 `recordText` 和音频 URL 放在同一条记录里，方便之后反向展示。
    widget.onConfirm(path, _recordedDuration, _transcriptionText.trim());
  }

  Future<void> _handlePreviewToggle() async {
    String? path = _recordedPath;
    if (path == null) {
      if (_recordState != RecordState.stop) {
        // 回放按钮在录音中被点击时，先结束录音再试听，避免用户点了没有任何反馈。
        await _stop();
        path = _recordedPath;
      }
      if (path == null) {
        EasyLoading.showToast(getI18NKey().no_recording_preview);
        return;
      }
    }
    if (_audioPlayer.state == ap.PlayerState.playing) {
      await _audioPlayer.pause();
      setState(() {});
      return;
    }
    if (!await File(path).exists()) {
      EasyLoading.showToast(_recordAiText(
        zh: '录音文件不存在，请重新录制',
        en: 'Recording file not found. Please record again.',
      ));
      return;
    }
    try {
      await _audioPlayer.play(ap.DeviceFileSource(path));
      setState(() {});
    } catch (error) {
      EasyLoading.showToast(_recordAiText(
        zh: '播放失败，请重新录制',
        en: 'Playback failed. Please record again.',
      ));
      debugPrint('[RecordPage2] preview playback failed: $error');
    }
  }

  Future<void> _handleRerecord() async {
    await _handleDelete();
    await _start();
  }

  Future<void> _handleTranscribe() async {
    final String? path = _recordedPath;
    if (path == null || _isTranscribing) {
      return;
    }
    await _audioPlayer.stop();
    final int requestId = ++_transcriptionRequestId;
    setState(() {
      _isTranscribing = true;
      _transcriptionError = '';
    });
    try {
      final result = await VoiceTranscriptionManager.getInstance()
          .transcribeLocalAudioFile(
        localPath: path,
        fileNamePrefix: 'record_page_voice',
      );
      if (!mounted || requestId != _transcriptionRequestId) {
        return;
      }
      setState(() {
        _transcriptionText = result.text;
        _transcriptionError = '';
      });
    } catch (error) {
      if (!mounted || requestId != _transcriptionRequestId) {
        return;
      }
      setState(() {
        _transcriptionError = _recordAiText(
          zh: '转写失败，请稍后重试。\n$error',
          en: 'Transcription failed. Please try again.\n$error',
        );
      });
    } finally {
      if (mounted && requestId == _transcriptionRequestId) {
        setState(() => _isTranscribing = false);
      }
    }
  }

  void _copyTranscriptionText() {
    final text = _transcriptionText.trim();
    if (text.isEmpty) {
      return;
    }
    Utility.copyToClipboard(text);
  }

  Widget _buildPreviewPlayer(bool hasRecording) {
    final bool canPreview =
        hasRecording || _recordState != RecordState.stop;
    final Duration total =
        _playbackDuration ?? Duration(seconds: _recordedDuration);
    final Duration current = _playbackPosition ?? Duration.zero;
    final double progress = total.inMilliseconds <= 0
        ? 0
        : (current.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    final bool isPlaying = _audioPlayer.state == ap.PlayerState.playing;
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(34),
              onTap: _handlePreviewToggle,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: ThemeManager.getInstance().isDark()
                      ? const Color(0xff292929)
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeManager.getInstance()
                        .getTextColor()
                        .withValues(alpha: 0.10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: canPreview
                      ? ThemeManager.getInstance().getTextColor()
                      : ThemeManager.getInstance()
                          .getTextColor()
                          .withValues(alpha: 0.25),
                  size: 34,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 76,
                child: CustomPaint(
                  painter: _PreviewWaveformPainter(
                    progress: progress,
                    enabled: hasRecording,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 76, right: 2, top: 4),
          child: Row(
            children: [
              Text(
                _formatDuration(current.inSeconds),
                style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor()
                      .withValues(alpha: 0.55),
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                _formatDuration(total.inSeconds),
                style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor()
                      .withValues(alpha: 0.55),
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeManager.getInstance().isDark()
                      ? const Color(0xff292929)
                      : const Color(0xfffffbf8),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: ThemeManager.getInstance()
                        .getTextColor()
                        .withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  '1.0x',
                  style: TextStyle(
                    color: ThemeManager.getInstance().getTextColor(),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingInfo(bool hasRecording) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ThemeManager.getInstance().isDark()
            ? const Color(0xff242424)
            : const Color(0xfffffbf8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              ThemeManager.getInstance().getTextColor().withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getI18NKey().recording_info,
            style: TextStyle(
              color: ThemeManager.getInstance().getTextColor(),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.timer_outlined,
            getI18NKey().record_duration,
            hasRecording ? _formatDuration(_recordedDuration) : '--:--',
          ),
          _buildInfoRow(
            Icons.calendar_month_outlined,
            getI18NKey().record_time,
            hasRecording && _recordedAt != null
                ? _formatDateTime(_recordedAt!)
                : '--',
          ),
          _buildInfoRow(
            Icons.mic_none_rounded,
            getI18NKey().record_device,
            hasRecording ? getI18NKey().built_in_microphone : '--',
          ),
          _buildInfoRow(
            Icons.graphic_eq_rounded,
            getI18NKey().audio_quality,
            hasRecording ? getI18NKey().quality_good : '--',
            valueColor: const Color(0xff37a65a),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: ThemeManager.getInstance()
                .getTextColor()
                .withValues(alpha: 0.45),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: ThemeManager.getInstance()
                  .getTextColor()
                  .withValues(alpha: 0.78),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueColor ??
                    ThemeManager.getInstance()
                        .getTextColor()
                        .withValues(alpha: 0.78),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRerecordBlock(bool hasRecording) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xfff04438).withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xfff04438).withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              getI18NKey().record_satisfied_prompt,
              style: TextStyle(
                color: ThemeManager.getInstance().getTextColor(),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: hasRecording ? _handleRerecord : null,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(getI18NKey().rerecord),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xfff04438),
              side: BorderSide(
                color: const Color(0xfff04438).withValues(alpha: 0.35),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _normalizedAmplitude {
    final double current = _amplitude?.current ?? -45;
    final double normalized = ((current + 60) / 60).clamp(0.0, 1.0);
    return normalized;
  }

  String _formatDuration(int totalSeconds) {
    final String minutes = _formatNumber(totalSeconds ~/ 60);
    final String seconds = _formatNumber(totalSeconds % 60);
    return '$minutes:$seconds';
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_formatNumber(dateTime.month)}-${_formatNumber(dateTime.day)} '
        '${_formatNumber(dateTime.hour)}:${_formatNumber(dateTime.minute)}';
  }

  /// 功能：为本次新增的 AI 转写区域提供轻量国际化文案。
  /// 说明：先跟随当前 Locale 输出中文或英文，避免新增视觉能力时出现固定中文。
  String _recordAiText({required String zh, required String en}) {
    final locale = Localizations.maybeLocaleOf(context);
    return locale?.languageCode.toLowerCase() == 'zh' ? zh : en;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_recordDuration >= _maxRecordSeconds) {
        _stop();
        return;
      }
      setState(() => _recordDuration++);
    });
  }
}

class _PreviewWaveformPainter extends CustomPainter {
  final double progress;
  final bool enabled;

  _PreviewWaveformPainter({
    required this.progress,
    required this.enabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    const int barCount = 76;
    final double gap = size.width / barCount;
    final Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = gap.clamp(2.0, 4.0) * 0.42;

    for (int i = 0; i < barCount; i++) {
      final double x = i * gap;
      final double wave = ((i % 14) - 7).abs() / 7;
      final double peak = i % 19 == 0 || i % 23 == 0 ? 1.0 : 0.0;
      final double height =
          (10 + (1 - wave) * 26 + peak * 18).clamp(8.0, size.height * 0.68);
      final bool active = enabled && (x / size.width) <= progress;
      paint.color = active
          ? const Color(0xfff04438)
          : const Color(0xffd8d1ca).withValues(alpha: enabled ? 1 : 0.45);
      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewWaveformPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.enabled != enabled;
}

class _RecordingWaveformPainter extends CustomPainter {
  final double amplitude;
  final double progress;
  final bool isRecording;
  final Color accentColor;

  _RecordingWaveformPainter({
    required this.amplitude,
    required this.progress,
    required this.isRecording,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    const int barCount = 94;
    final double gap = size.width / (barCount * 1.55);
    final double barWidth = gap * 0.56;
    final double progressX = size.width * progress;
    final Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth.clamp(2.0, 5.0);

    for (int i = 0; i < barCount; i++) {
      final double x = i * gap * 1.55;
      final double phase = (i % 12) / 12;
      final double base = 10 + 20 * (0.5 + 0.5 * (phase - 0.5).abs());
      final double liveBoost = isRecording && i > barCount * 0.35
          ? amplitude *
              34 *
              (1 - ((i - barCount * 0.35) / barCount).clamp(0, 1))
          : 0;
      final double height =
          (base + liveBoost + (i % 5) * 3).clamp(8.0, size.height * 0.58);
      paint.color = x <= progressX ? accentColor : const Color(0xffd8d1ca);
      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }

    final Paint cursorPaint = Paint()
      ..color = accentColor
      ..strokeWidth = 1.6;
    canvas.drawLine(
      Offset(progressX, 12),
      Offset(progressX, size.height - 12),
      cursorPaint,
    );
    canvas.drawCircle(Offset(progressX, 10), 5, cursorPaint);
  }

  @override
  bool shouldRepaint(covariant _RecordingWaveformPainter oldDelegate) =>
      oldDelegate.amplitude != amplitude ||
      oldDelegate.progress != progress ||
      oldDelegate.isRecording != isRecording ||
      oldDelegate.accentColor != accentColor;
}
