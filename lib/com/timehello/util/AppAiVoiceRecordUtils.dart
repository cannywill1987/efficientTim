/// 文件类型：工具类
/// 文件作用：为 AppAIPlugin 的内联语音输入提供原生录音能力。
/// 主要职责：封装开始、停止、取消录音流程，并返回可上传的本地音频文件信息。
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AppAiVoiceRecordResult {
  const AppAiVoiceRecordResult({
    required this.path,
    required this.duration,
    required this.fileSize,
  });

  final String path;
  final int duration;
  final int fileSize;
}

class AppAiVoiceRecordUtils {
  AppAiVoiceRecordUtils();

  final AudioRecorder _recorder = AudioRecorder();
  final Stopwatch _stopwatch = Stopwatch();
  String? _currentPath;
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  /// 功能：请求麦克风权限并开始录音，录音文件落在临时目录中。
  /// 返回：本次录音的本地目标路径，后续停止时会使用同一路径上传。
  Future<String> start() async {
    if (_isRecording) {
      return _currentPath ?? '';
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw StateError('没有麦克风权限，请先在系统设置中允许访问麦克风。');
    }

    const encoder = AudioEncoder.aacLc;
    final isSupported = await _recorder.isEncoderSupported(encoder);
    if (!isSupported) {
      throw StateError('当前设备不支持 AAC 录音编码。');
    }

    final dir = await getTemporaryDirectory();
    final path = p.join(
      dir.path,
      'app_ai_voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    const config = RecordConfig(
      encoder: encoder,
      numChannels: 1,
      bitRate: 128000,
    );
    await _recorder.start(config, path: path);
    _currentPath = path;
    _isRecording = true;
    _stopwatch
      ..reset()
      ..start();
    return path;
  }

  /// 功能：停止当前录音并返回文件信息，供外层上传 OSS 与语音转文字。
  Future<AppAiVoiceRecordResult> stop() async {
    if (!_isRecording) {
      throw StateError('当前没有正在进行的录音。');
    }

    _stopwatch.stop();
    final stoppedPath = await _recorder.stop();
    _isRecording = false;
    final path = stoppedPath?.isNotEmpty == true ? stoppedPath! : _currentPath;
    _currentPath = null;

    if (path == null || path.isEmpty) {
      throw StateError('录音结束后没有生成音频文件。');
    }

    final file = File(path);
    if (!await file.exists()) {
      throw StateError('录音文件不存在：$path');
    }

    return AppAiVoiceRecordResult(
      path: path,
      duration: _stopwatch.elapsed.inSeconds,
      fileSize: await file.length(),
    );
  }

  /// 功能：取消录音并清理当前未确认的临时文件。
  Future<void> cancel() async {
    final path = _currentPath;
    if (_isRecording) {
      await _recorder.stop();
    }
    _stopwatch
      ..stop()
      ..reset();
    _isRecording = false;
    _currentPath = null;

    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// 功能：页面销毁时释放录音器资源，避免麦克风句柄残留。
  Future<void> dispose() async {
    if (_isRecording) {
      await cancel();
    }
    await _recorder.dispose();
  }
}
