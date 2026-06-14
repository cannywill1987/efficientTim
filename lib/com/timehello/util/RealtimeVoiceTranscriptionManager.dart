/// 文件类型：工具类
/// 文件作用：封装阿里云百炼 Paraformer 实时语音转文字能力。
/// 主要职责：把本机麦克风音频流通过 WebSocket 发送给百炼，并把实时识别文本回调给业务层。
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/Params.dart';
import 'AiVoiceDebugLog.dart';
import 'AppAiBailianConfigManager.dart';
import 'AppVoiceLanguageHintsManager.dart';

typedef RealtimeVoiceTranscriptionListener = void Function(
  RealtimeVoiceTranscriptionUpdate update,
);

class RealtimeVoiceTranscriptionUpdate {
  const RealtimeVoiceTranscriptionUpdate({
    required this.text,
    required this.isFinal,
  });

  final String text;
  final bool isFinal;
}

class RealtimeVoiceTranscriptionManager {
  RealtimeVoiceTranscriptionManager();

  static const String _endpoint =
      'wss://dashscope.aliyuncs.com/api-ws/v1/inference';
  static const String _model = 'paraformer-realtime-v2';
  static const int _sampleRate = 16000;

  final AudioRecorder _recorder = AudioRecorder();
  final Uuid _uuid = Uuid();

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  StreamSubscription<Uint8List>? _audioSubscription;
  Completer<void>? _taskStartedCompleter;
  Completer<void>? _taskFinishedCompleter;
  RealtimeVoiceTranscriptionListener? _onUpdate;
  void Function(Object error)? _onError;
  String? _taskId;
  bool _isRecording = false;
  bool _isStopping = false;

  bool get isRecording => _isRecording;

  /// 功能：启动实时识别会话。
  /// 说明：实时接口要求先建立 WebSocket 并收到 task-started，再发送 PCM 音频二进制。
  Future<void> start({
    required RealtimeVoiceTranscriptionListener onUpdate,
    void Function(Object error)? onError,
  }) async {
    if (_isRecording) {
      return;
    }
    final config =
        await AppAiBailianConfigManager.getInstance().resolveConfig();
    final apiKey = (config?.apiKey ?? Params.appAiBailianRuntimeApiKey).trim();
    AiVoiceDebugLog.log(
      'realtime-start',
      'configSource=${config?.source}, hasKey=${apiKey.isNotEmpty}, keyLength=${apiKey.length}, endpoint=$_endpoint, model=$_model',
    );
    if (apiKey.isEmpty) {
      throw StateError('百炼 API key 为空，无法进行实时语音转文字。');
    }
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw StateError('没有麦克风权限，请先在系统设置中允许访问麦克风。');
    }
    const encoder = AudioEncoder.pcm16bits;
    final isSupported = await _recorder.isEncoderSupported(encoder);
    AiVoiceDebugLog.log(
      'realtime-recorder-check',
      'hasPermission=$hasPermission, encoder=${encoder.name}, isSupported=$isSupported',
    );
    if (!isSupported) {
      throw StateError('当前设备不支持 PCM 流式录音。');
    }

    _onUpdate = onUpdate;
    _onError = onError;
    _taskId = _uuid.v4();
    _taskStartedCompleter = Completer<void>();
    _taskFinishedCompleter = Completer<void>();

    try {
      final channel = IOWebSocketChannel.connect(
        Uri.parse(_endpoint),
        headers: <String, dynamic>{
          'Authorization': 'Bearer $apiKey',
          'user-agent': 'TimeHelloFlutter',
        },
        connectTimeout: const Duration(seconds: 10),
        pingInterval: const Duration(seconds: 20),
      );
      _channel = channel;
      AiVoiceDebugLog.log(
        'realtime-websocket-connect',
        'taskId=$_taskId, endpoint=$_endpoint',
      );
      _socketSubscription = channel.stream.listen(
        _handleSocketMessage,
        onError: _handleSocketError,
        onDone: _handleSocketDone,
        cancelOnError: false,
      );

      await channel.ready.timeout(const Duration(seconds: 10));
      AiVoiceDebugLog.log('realtime-websocket-ready', 'taskId=$_taskId');
      _sendRunTask();
      await _taskStartedCompleter!.future.timeout(const Duration(seconds: 10));
      _isRecording = true;
      _isStopping = false;
      await _startAudioStream();
    } catch (error, stackTrace) {
      AiVoiceDebugLog.log(
        'realtime-start-error',
        'taskId=$_taskId, errorType=${error.runtimeType}',
        error: error,
        stackTrace: stackTrace,
      );
      await cancel();
      rethrow;
    }
  }

  /// 功能：停止实时识别并等待服务端返回 task-finished。
  Future<void> stop() async {
    if (!_isRecording || _isStopping) {
      return;
    }
    _isStopping = true;
    AiVoiceDebugLog.log('realtime-stop-start', 'taskId=$_taskId');
    try {
      await _stopAudioStream();
      _sendFinishTask();
      await _taskFinishedCompleter?.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    } finally {
      await _closeChannel();
      _isRecording = false;
      _isStopping = false;
      AiVoiceDebugLog.log('realtime-stop-done', 'taskId=$_taskId');
    }
  }

  /// 功能：取消实时识别，不再等待服务端最终结果。
  Future<void> cancel() async {
    AiVoiceDebugLog.log('realtime-cancel-start', 'taskId=$_taskId');
    await _stopAudioStream();
    await _closeChannel();
    _isRecording = false;
    _isStopping = false;
    AiVoiceDebugLog.log('realtime-cancel-done', 'taskId=$_taskId');
  }

  Future<void> dispose() async {
    await cancel();
    await _recorder.dispose();
  }

  Future<void> _startAudioStream() async {
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: _sampleRate,
        numChannels: 1,
      ),
    );
    AiVoiceDebugLog.log(
      'realtime-audio-start',
      'taskId=$_taskId, sampleRate=$_sampleRate, channels=1',
    );
    _audioSubscription = stream.listen(
      (chunk) {
        if (chunk.isEmpty) {
          return;
        }
        _channel?.sink.add(chunk);
      },
      onError: _handleSocketError,
      cancelOnError: false,
    );
  }

  Future<void> _stopAudioStream() async {
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    AiVoiceDebugLog.log('realtime-audio-stop', 'taskId=$_taskId');
  }

  void _sendRunTask() {
    final taskId = _taskId;
    if (taskId == null) {
      return;
    }
    final languageHints =
        AppVoiceLanguageHintsManager.getDashScopeLanguageHints();
    _channel?.sink.add(jsonEncode(<String, Object?>{
      'header': <String, Object?>{
        'action': 'run-task',
        'task_id': taskId,
        'streaming': 'duplex',
      },
      'payload': <String, Object?>{
        'task_group': 'audio',
        'task': 'asr',
        'function': 'recognition',
        'model': _model,
        'parameters': <String, Object?>{
          'format': 'pcm',
          'sample_rate': _sampleRate,
          'language_hints': languageHints,
          'disfluency_removal_enabled': false,
          'semantic_punctuation_enabled': true,
        },
        'input': <String, Object?>{},
      },
    }));
    AiVoiceDebugLog.log(
      'realtime-run-task',
      'taskId=$taskId, model=$_model, sampleRate=$_sampleRate, languageHints=${languageHints.join('|')}',
    );
  }

  void _sendFinishTask() {
    final taskId = _taskId;
    if (taskId == null) {
      return;
    }
    _channel?.sink.add(jsonEncode(<String, Object?>{
      'header': <String, Object?>{
        'action': 'finish-task',
        'task_id': taskId,
        'streaming': 'duplex',
      },
      'payload': <String, Object?>{
        'input': <String, Object?>{},
      },
    }));
    AiVoiceDebugLog.log('realtime-finish-task', 'taskId=$taskId');
  }

  void _handleSocketMessage(Object? message) {
    if (message is! String) {
      return;
    }
    final decoded = jsonDecode(message);
    if (decoded is! Map) {
      return;
    }
    final header = (decoded['header'] as Map?)?.cast<String, Object?>();
    final event = header?['event']?.toString();
    AiVoiceDebugLog.log(
      'realtime-socket-event',
      'taskId=$_taskId, event=$event',
    );
    if (event == 'task-started') {
      _completeTaskStarted();
      return;
    }
    if (event == 'task-finished') {
      _completeTaskFinished();
      return;
    }
    if (event == 'task-failed') {
      final messageText =
          header?['error_message'] ?? header?['message'] ?? '实时语音识别任务失败。';
      _handleSocketError(StateError(messageText.toString()));
      return;
    }
    if (event != 'result-generated') {
      return;
    }

    final payload = (decoded['payload'] as Map?)?.cast<String, Object?>();
    final output = (payload?['output'] as Map?)?.cast<String, Object?>();
    final sentence = (output?['sentence'] as Map?)?.cast<String, Object?>();
    if (sentence == null || sentence['heartbeat'] == true) {
      return;
    }
    final text = sentence['text']?.toString().trim() ?? '';
    if (text.isEmpty) {
      return;
    }
    AiVoiceDebugLog.log(
      'realtime-result',
      'taskId=$_taskId, textLength=${text.length}, isFinal=${sentence['sentence_end'] == true}',
    );
    _onUpdate?.call(
      RealtimeVoiceTranscriptionUpdate(
        text: text,
        isFinal: sentence['sentence_end'] == true,
      ),
    );
  }

  void _handleSocketError(Object error) {
    AiVoiceDebugLog.log(
      'realtime-socket-error',
      'taskId=$_taskId, errorType=${error.runtimeType}',
      error: error,
    );
    if (_taskStartedCompleter?.isCompleted == false) {
      _taskStartedCompleter?.completeError(error);
    }
    if (_taskFinishedCompleter?.isCompleted == false) {
      _taskFinishedCompleter?.completeError(error);
    }
    _onError?.call(error);
  }

  void _handleSocketDone() {
    AiVoiceDebugLog.log('realtime-socket-done', 'taskId=$_taskId');
    if (_taskStartedCompleter?.isCompleted == false) {
      _taskStartedCompleter?.completeError(StateError('实时语音识别连接已关闭。'));
    }
    _completeTaskFinished();
  }

  void _completeTaskStarted() {
    if (_taskStartedCompleter?.isCompleted == false) {
      _taskStartedCompleter?.complete();
    }
  }

  void _completeTaskFinished() {
    if (_taskFinishedCompleter?.isCompleted == false) {
      _taskFinishedCompleter?.complete();
    }
  }

  Future<void> _closeChannel() async {
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _channel?.sink.close();
    _channel = null;
    _taskStartedCompleter = null;
    _taskFinishedCompleter = null;
    _taskId = null;
    _onUpdate = null;
    _onError = null;
  }
}
