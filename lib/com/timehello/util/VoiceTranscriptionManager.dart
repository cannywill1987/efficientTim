/// 文件类型：工具类
/// 文件作用：统一封装录音文件转文字链路，供录音弹窗和 AppAIPlugin 语音输入复用。
/// 主要职责：把本地录音上传到 OSS，再调用百炼 Paraformer 异步转写，并提取干净的整句文本。
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../config/ENUMS.dart';
import '../config/Params.dart';
import 'AiVoiceDebugLog.dart';
import 'AliyunStoreManager.dart';
import 'AppAiBailianConfigManager.dart';
import 'AppVoiceLanguageHintsManager.dart';

class VoiceTranscriptionManager {
  VoiceTranscriptionManager._();

  static final VoiceTranscriptionManager _instance =
      VoiceTranscriptionManager._();

  static VoiceTranscriptionManager getInstance() {
    return _instance;
  }

  /// 功能：把本地录音文件上传到 OSS 后提交给百炼转写。
  /// 说明：百炼录音识别必须使用公网可访问 URL，不能直接传本地 sandbox 路径。
  Future<VoiceTranscriptionResult> transcribeLocalAudioFile({
    required String localPath,
    String fileNamePrefix = 'voice_transcription',
  }) async {
    if (localPath.trim().isEmpty) {
      throw StateError('录音文件路径为空，无法进行语音转文字。');
    }
    AiVoiceDebugLog.log(
      'file-transcribe-start',
      'localPathLength=${localPath.length}, fileNamePrefix=$fileNamePrefix',
    );
    final audioUrl =
        await AliyunStoreManager.getInstance().uploadFileByFilePath(
      docType: DocType.audio,
      path: localPath,
      fileExtensionEnum: audioExtensionFromPath(localPath),
      fileName: '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}',
    );
    AiVoiceDebugLog.log(
      'file-upload-success',
      'audioUrlLength=${audioUrl.toString().length}',
    );
    final text = await transcribeBailianAudioUrl(audioUrl.toString());
    AiVoiceDebugLog.log(
      'file-transcribe-done',
      'textLength=${text.length}, audioUrlLength=${audioUrl.toString().length}',
    );
    return VoiceTranscriptionResult(
      text: text,
      audioUrl: audioUrl.toString(),
    );
  }

  /// 功能：根据音频文件后缀选择 OSS 上传扩展名，确保 ASR 服务按真实音频格式读取。
  FileExtension audioExtensionFromPath(String path) {
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

  /// 功能：调用阿里云百炼 Paraformer 录音文件识别，把 OSS 音频 URL 转成文本。
  /// 说明：接口是异步任务，先提交任务，再轮询 task_id，最后读取 transcription_url 中的转写结果。
  Future<String> transcribeBailianAudioUrl(String audioUrl) async {
    final config =
        await AppAiBailianConfigManager.getInstance().resolveConfig();
    final apiKey = (config?.apiKey ?? Params.appAiBailianRuntimeApiKey).trim();
    AiVoiceDebugLog.log(
      'file-bailian-config',
      'configSource=${config?.source}, hasKey=${apiKey.isNotEmpty}, keyLength=${apiKey.length}',
    );
    if (apiKey.isEmpty) {
      throw StateError('百炼 API key 为空，无法进行语音转文字。');
    }
    if (audioUrl.trim().isEmpty) {
      throw StateError('录音上传后没有拿到可访问的音频 URL。');
    }

    final languageHints =
        AppVoiceLanguageHintsManager.getDashScopeLanguageHints();
    final endpoint = Uri.parse(
      'https://dashscope.aliyuncs.com/api/v1/services/audio/asr/transcription',
    );
    AiVoiceDebugLog.log(
      'file-submit-start',
      'audioUrlLength=${audioUrl.length}, model=paraformer-v2, languageHints=${languageHints.join('|')}',
    );
    final submitResponse = await http
        .post(
          endpoint,
          headers: <String, String>{
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
            'X-DashScope-Async': 'enable',
          },
          body: jsonEncode(<String, Object?>{
            'model': 'paraformer-v2',
            'input': <String, Object?>{
              'file_urls': <String>[audioUrl],
            },
            'parameters': <String, Object?>{
              'language_hints': languageHints,
            },
          }),
        )
        .timeout(const Duration(seconds: 30));
    AiVoiceDebugLog.log(
      'file-submit-result',
      'statusCode=${submitResponse.statusCode}, bodyLength=${submitResponse.bodyBytes.length}',
    );
    if (submitResponse.statusCode < 200 || submitResponse.statusCode >= 300) {
      throw StateError(
        '百炼转写任务提交失败 HTTP ${submitResponse.statusCode}: ${submitResponse.body}',
      );
    }

    final submitJson = jsonDecode(utf8.decode(submitResponse.bodyBytes))
        as Map<String, Object?>;
    final taskId =
        ((submitJson['output'] as Map?)?['task_id'] ?? submitJson['task_id'])
            ?.toString()
            .trim();
    if (taskId == null || taskId.isEmpty) {
      throw StateError('百炼转写任务提交成功，但响应里没有 task_id。');
    }
    AiVoiceDebugLog.log(
      'file-task-created',
      'taskId=$taskId',
    );

    for (var index = 0; index < 90; index += 1) {
      await Future<void>.delayed(const Duration(seconds: 2));
      final taskResponse = await http.post(
        Uri.parse('https://dashscope.aliyuncs.com/api/v1/tasks/$taskId'),
        headers: <String, String>{'Authorization': 'Bearer $apiKey'},
      ).timeout(const Duration(seconds: 30));
      if (taskResponse.statusCode < 200 || taskResponse.statusCode >= 300) {
        AiVoiceDebugLog.log(
          'file-task-query-http-error',
          'taskId=$taskId, pollIndex=$index, statusCode=${taskResponse.statusCode}, bodyLength=${taskResponse.bodyBytes.length}',
        );
        throw StateError(
          '百炼转写任务查询失败 HTTP ${taskResponse.statusCode}: ${taskResponse.body}',
        );
      }

      final taskJson = jsonDecode(utf8.decode(taskResponse.bodyBytes))
          as Map<String, Object?>;
      final output = (taskJson['output'] as Map?)?.cast<String, Object?>();
      final status = output?['task_status']?.toString() ??
          taskJson['task_status']?.toString() ??
          '';
      AiVoiceDebugLog.log(
        'file-task-status',
        'taskId=$taskId, pollIndex=$index, status=$status',
      );
      if (status == 'SUCCEEDED') {
        final text = await _loadBailianTranscriptionText(output);
        AiVoiceDebugLog.log(
          'file-task-success',
          'taskId=$taskId, textLength=${text.length}',
        );
        if (text.trim().isEmpty) {
          throw StateError('百炼转写完成，但没有识别到可用文字。');
        }
        return text.trim();
      }
      if (status == 'FAILED' || status == 'CANCELED') {
        AiVoiceDebugLog.log(
          'file-task-failed',
          'taskId=$taskId, status=$status, message=${output?['message'] ?? output?['code'] ?? ''}',
        );
        throw StateError(
          '百炼转写任务失败：${output?['message'] ?? output?['code'] ?? status}',
        );
      }
    }

    throw TimeoutException('百炼转写任务查询超时，请稍后重试。');
  }

  /// 功能：读取百炼任务结果里的 transcription_url，并兼容不同返回层级提取最终文本。
  Future<String> _loadBailianTranscriptionText(
    Map<String, Object?>? output,
  ) async {
    final results = output?['results'];
    final resultItems =
        results is List ? results.cast<Object?>() : const <Object?>[];
    final buffer = StringBuffer();

    for (final item in resultItems) {
      if (item is! Map) {
        continue;
      }
      final transcriptionUrl = item['transcription_url']?.toString().trim();
      if (transcriptionUrl == null || transcriptionUrl.isEmpty) {
        final inlineText = _extractBailianText(item);
        if (inlineText.isNotEmpty) {
          buffer.writeln(inlineText);
        }
        continue;
      }

      final response = await http
          .get(Uri.parse(transcriptionUrl))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError(
          '百炼转写结果下载失败 HTTP ${response.statusCode}: ${response.body}',
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final text = _extractBailianText(decoded);
      if (text.isNotEmpty) {
        buffer.writeln(text);
      }
    }

    return buffer.toString().trim();
  }

  /// 功能：从百炼转写 JSON 中提取最终文本，优先使用整段/整句结果，避免把字级 words 重复拼进去。
  String _extractBailianText(Object? value) {
    final transcriptTexts = _collectBailianTextsFromListContainers(
      value,
      containerKeys: const <String>{'transcripts', 'results'},
      textKeys: const <String>{'text', 'transcript'},
    );
    if (transcriptTexts.isNotEmpty) {
      return _joinBailianTextLines(transcriptTexts);
    }

    final sentenceTexts = _collectBailianTextsFromListContainers(
      value,
      containerKeys: const <String>{'sentences', 'sentence_list'},
      textKeys: const <String>{'text', 'sentence'},
    );
    if (sentenceTexts.isNotEmpty) {
      return _joinBailianTextLines(sentenceTexts);
    }

    final fallbackTexts = _collectBailianFallbackTexts(value);
    return _joinBailianTextLines(fallbackTexts);
  }

  /// 功能：按指定数组容器收集文本，例如 transcripts[].text 或 sentences[].text。
  /// 说明：百炼结果常同时包含整句和 words 字级明细，按容器优先级读取可避免重复。
  List<String> _collectBailianTextsFromListContainers(
    Object? value, {
    required Set<String> containerKeys,
    required Set<String> textKeys,
  }) {
    final lines = <String>[];

    void visit(Object? node) {
      if (node is Map) {
        for (final entry in node.entries) {
          final key = entry.key.toString();
          final child = entry.value;
          if (containerKeys.contains(key) && child is List) {
            for (final item in child) {
              if (item is Map) {
                var hasDirectText = false;
                for (final textKey in textKeys) {
                  final candidate = item[textKey];
                  if (candidate is String && candidate.trim().isNotEmpty) {
                    lines.add(candidate.trim());
                    hasDirectText = true;
                    break;
                  }
                }
                if (!hasDirectText) {
                  visit(item);
                }
              } else if (item is String && item.trim().isNotEmpty) {
                lines.add(item.trim());
              }
            }
            continue;
          }
          if (!_isBailianWordDetailKey(key)) {
            visit(child);
          }
        }
      } else if (node is List) {
        for (final child in node) {
          visit(child);
        }
      }
    }

    visit(value);
    return lines;
  }

  /// 功能：兜底读取零散文本字段，同时跳过 words/tokens 这类字级时间戳明细。
  List<String> _collectBailianFallbackTexts(Object? value) {
    final lines = <String>[];

    void visit(Object? node, {String? parentKey}) {
      if (parentKey != null && _isBailianWordDetailKey(parentKey)) {
        return;
      }
      if (node is Map) {
        for (final key in const <String>['text', 'transcript', 'sentence']) {
          final candidate = node[key];
          if (candidate is String && candidate.trim().isNotEmpty) {
            lines.add(candidate.trim());
            break;
          }
        }
        for (final entry in node.entries) {
          visit(entry.value, parentKey: entry.key.toString());
        }
      } else if (node is List) {
        for (final child in node) {
          visit(child, parentKey: parentKey);
        }
      }
    }

    visit(value);
    return lines;
  }

  /// 功能：判断当前字段是否属于字词级明细，避免把“你/好/首/先”逐字追加到转写结果。
  bool _isBailianWordDetailKey(String key) {
    return const <String>{
      'words',
      'word',
      'tokens',
      'token',
      'timestamps',
      'timestamp',
      'phonemes',
      'characters',
      'char',
    }.contains(key);
  }

  /// 功能：合并百炼文本并保持顺序去重，避免同一整句在多个层级重复出现。
  String _joinBailianTextLines(List<String> lines) {
    final orderedUniqueLines = <String>[];
    final seen = <String>{};
    for (final line in lines) {
      final normalized = line.trim();
      if (normalized.isEmpty || seen.contains(normalized)) {
        continue;
      }
      seen.add(normalized);
      orderedUniqueLines.add(normalized);
    }
    return orderedUniqueLines.join('\n').trim();
  }
}

class VoiceTranscriptionResult {
  const VoiceTranscriptionResult({
    required this.text,
    required this.audioUrl,
  });

  final String text;
  final String audioUrl;
}
