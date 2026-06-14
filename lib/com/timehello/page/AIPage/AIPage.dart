/// 文件类型：页面
/// 文件作用：承载 TimeHello 右侧 AI 面板，并把 AppAIPlugin/Continue GUI 的请求转接到本地工具与百炼模型。
/// 主要职责：构建模型配置、处理聊天流、执行本地任务工具，并提供语音录制转文字等宿主能力。
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:app_ai_plugin/app_ai_plugin.dart';
import 'package:app_ai_plugin/app_ai_plugin_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/AIInterfaceManager.dart';
import 'package:time_hello/com/timehello/util/AppAiVoiceRecordUtils.dart';
import 'package:time_hello/com/timehello/util/AppAiBailianConfigManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/MoneyManager.dart';
import 'package:time_hello/com/timehello/util/SubscriptionAndPriceManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/VoiceTranscriptionManager.dart';

class AIPage extends StatefulWidget {
  final PageGPTFromEnum pageGPTFromEnum;
  final String fid;
  final bool createNewMission;
  final String message;

  const AIPage({
    super.key,
    this.fid = '',
    this.createNewMission = false,
    this.message = '',
    this.pageGPTFromEnum = PageGPTFromEnum.RightBarPage,
  });

  @override
  State<AIPage> createState() => _AIPageState();
}

class _ParsedTimeRange {
  const _ParsedTimeRange(this.start, this.end);

  final DateTime start;
  final DateTime end;
}

class _ParsedObjective {
  const _ParsedObjective(this.total, this.unit);

  final double total;
  final String unit;
}

class _ParsedRenameMission {
  const _ParsedRenameMission(this.oldTitle, this.newTitle);

  final String oldTitle;
  final String newTitle;
}

class _ParsedCompleteMission {
  const _ParsedCompleteMission(this.title);

  final String title;
}

class _ParsedMissionDateUpdate {
  const _ParsedMissionDateUpdate({
    required this.title,
    required this.endTime,
    this.dateStatus,
  });

  final String title;
  final DateTime endTime;
  final int? dateStatus;
}

class _ParsedMissionTimeRangeUpdate {
  const _ParsedMissionTimeRangeUpdate({
    required this.title,
    required this.range,
    this.dateStatus,
  });

  final String title;
  final _ParsedTimeRange range;
  final int? dateStatus;
}

class _ParsedMoveFolder {
  const _ParsedMoveFolder(this.childTitle, this.parentTitle);

  final String childTitle;
  final String parentTitle;
}

class _AppAiVoiceHostAdapter extends HostAdapter {
  const _AppAiVoiceHostAdapter({
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onCancelRecording,
  });

  final Future<Map<String, Object?>> Function() onStartRecording;
  final Future<Map<String, Object?>> Function() onStopRecording;
  final Future<Map<String, Object?>> Function() onCancelRecording;

  @override
  bool canHandle(String messageType) {
    return const <String>{
      'appAi/startVoiceRecording',
      'appAi/stopVoiceRecording',
      'appAi/cancelVoiceRecording',
    }.contains(messageType);
  }

  @override
  Future<Object?> handle(ContinueMessage message) {
    switch (message.messageType) {
      case 'appAi/startVoiceRecording':
        return onStartRecording();
      case 'appAi/stopVoiceRecording':
        return onStopRecording();
      case 'appAi/cancelVoiceRecording':
        return onCancelRecording();
    }
    throw UnsupportedError('Unsupported voice message: ${message.messageType}');
  }
}

class _AIPageState extends State<AIPage> {
  static const String _workspaceDirectory = 'file:///workspace';
  static const String _continueGuiDist =
      String.fromEnvironment('CONTINUE_GUI_DIST');
  static const String _assetGuiDistPath =
      'thirdPartyPackages/AppAIPlugin/libs/gui/dist';
  static const String _projectGuiDistPath =
      '/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficientTime/thirdPartyPackages/AppAIPlugin/libs/gui/dist';
  static const int _freeAiUsageLimit = 3;
  static const int _aiUsageRedeemCost = 100;
  static const int _aiUsageRedeemQuota = 5;

  late final ContinueGuiShellPort _shellPort;
  late final ContinueShellController _controller;
  late final AppAiVoiceRecordUtils _voiceRecordUtils;
  int _aiUsageUsed = 0;
  int _aiUsageTotal = _freeAiUsageLimit;
  int _aiUsageRemaining = _freeAiUsageLimit;
  bool _aiUsageLoaded = false;
  bool _isAiStreaming = false;

  @override
  void initState() {
    super.initState();
    AIInterfaceManager.getInstance().registerContext(context);
    _voiceRecordUtils = AppAiVoiceRecordUtils();
    _shellPort = ContinueGuiShellPort();
    final serializedProfileInfo = _buildSerializedProfileInfo();
    _controller = ContinueShellController(
      coreTransport: MockContinueCoreTransport(
        respondToUnknownMessages: true,
        responses: {
          'history/list': const <Object?>[],
          'history/load': {
            'sessionId': 'ai-page-empty-session',
            'title': 'New Chat',
            'workspaceDirectory': _workspaceDirectory,
            'history': const <Object?>[],
          },
          'history/loadRemote': {
            'sessionId': 'ai-page-empty-session',
            'title': 'New Chat',
            'workspaceDirectory': _workspaceDirectory,
            'history': const <Object?>[],
          },
          'history/save': null,
          'history/share': null,
          'history/delete': null,
          'history/clear': null,
          'chatDescriber/describe': 'New Chat',
          'llm/listModels': Params.appAiBailianModels
              .map((entry) => entry['model'].toString())
              .toList(growable: false),
          'config/getSerializedProfileInfo': serializedProfileInfo,
          'config/refreshProfiles': null,
          'config/updateSelectedModel': null,
          'config/addOpenAiKey': null,
          'config/addModel': null,
          'config/addLocalWorkspaceBlock': null,
          'config/addGlobalRule': null,
          'config/deleteRule': null,
          'config/newPromptFile': null,
          'config/newAssistantFile': null,
          'config/ideSettingsUpdate': null,
          'config/deleteModel': null,
          'config/openProfile': null,
          'config/updateSharedConfig': null,
          'controlPlane/getEnvironment': {
            'DEFAULT_CONTROL_PLANE_PROXY_URL': '',
            'CONTROL_PLANE_URL': '',
            'AUTH_TYPE': 'local',
            'WORKOS_CLIENT_ID': '',
            'APP_URL': '',
          },
          'controlPlane/getCreditStatus': {
            'optedInToFreeTrial': false,
            'creditBalance': 0,
            'hasCredits': true,
            'hasPurchasedCredits': true,
          },
          'docs/initStatuses': null,
          'docs/getIndexedPages': const <String>[],
          'autocomplete/complete': '',
          'autocomplete/cancel': null,
          'autocomplete/accept': null,
          'nextEdit/predict': null,
          'nextEdit/reject': null,
          'nextEdit/accept': null,
          'nextEdit/startChain': null,
          'nextEdit/deleteChain': null,
          'nextEdit/isChainAlive': false,
          'nextEdit/queue/getProcessedCount': 0,
          'nextEdit/queue/dequeueProcessed': const <Object?>[],
          'nextEdit/queue/processOne': null,
          'nextEdit/queue/clear': null,
          'nextEdit/queue/abort': null,
          'streamDiffLines': null,
          'getDiffLines': const <Object?>[],
          'tts/kill': null,
          'index/setPaused': null,
          'index/forceReIndex': null,
          'index/indexingProgressBarInitialized': null,
          'indexing/reindex': null,
          'indexing/abort': null,
          'indexing/setPaused': null,
          'addAutocompleteModel': null,
          'onboarding/complete': null,
          'didChangeSelectedProfile': null,
          'didChangeSelectedOrg': null,
          'isItemTooBig': false,
          'devdata/log': null,
          'cancelApply': null,
        },
        handlers: {
          'llm/compileChat': (message) {
            final rawData = message.data;
            final messages = rawData is Map && rawData['messages'] is List
                ? rawData['messages'] as List
                : const <Object?>[];
            return {
              'compiledChatMessages': messages,
              'didPrune': false,
              'contextPercentage': 0.0,
            };
          },
          'tools/evaluatePolicy': (message) {
            final rawData = message.data;
            final basePolicy =
                rawData is Map<String, Object?> ? rawData['basePolicy'] : null;
            return {'policy': basePolicy, 'displayValue': null};
          },
          'llm/complete': (message) async {
            final rawData = message.data;
            if (rawData is! Map) {
              return '';
            }
            final prompt = (rawData['prompt'] ?? '').toString().trim();
            if (prompt.isEmpty) {
              return '';
            }
            return _requestChat(
              messages: <Map<String, String>>[
                <String, String>{'role': 'user', 'content': prompt},
              ],
              modelEntry: _resolveModelFromStreamData(rawData),
            );
          },
        },
        streamChatHandler: _handleGuiStreamChat,
      ),
      hostAdapter: CompositeHostAdapter(
        delegates: <HostAdapter>[
          _AppAiVoiceHostAdapter(
            onStartRecording: _startVoiceRecordingForGui,
            onStopRecording: _stopVoiceRecordingForGui,
            onCancelRecording: _cancelVoiceRecordingForGui,
          ),
          AIInterfaceManager.getInstance().createHostAdapter(),
          createContinueGuiDemoHostAdapter(),
        ],
      ),
      historyStore: ContinueHistorySqliteManager.getInstance(),
      shellPort: _shellPort,
    );
    _controller.start();
    unawaited(_primeContinueGuiConfiguration(serializedProfileInfo));
    unawaited(_loadAiUsageGate());
  }

  @override
  void didUpdateWidget(covariant AIPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 右侧 AI 面板现在会隐藏保活；重新打开时主动刷新一次配置，
    // 让 rules 里的宿主当前时间戳跟着更新。
    unawaited(_primeContinueGuiConfiguration(_buildSerializedProfileInfo()));
  }

  @override
  void dispose() {
    AIInterfaceManager.getInstance().unregisterContext(context);
    _controller.shutdown();
    _shellPort.dispose();
    unawaited(_voiceRecordUtils.dispose());
    super.dispose();
  }

  String _resolveGuiDistPath() {
    final bundledDistPath = _resolveBundledGuiDistPath();
    if (bundledDistPath != null) {
      return bundledDistPath;
    }
    if (_continueGuiDist.isNotEmpty) {
      return _continueGuiDist;
    }
    // macOS sandbox App 不能直接读取 Desktop 下的源码目录；这里仅在非沙盒开发环境
    // 才允许回退到项目目录，避免 WebView 静态服务因为 Operation not permitted 中断。
    final isMacSandboxed = Platform.isMacOS &&
        (Platform.environment['APP_SANDBOX_CONTAINER_ID'] ?? '').isNotEmpty;
    if (!isMacSandboxed &&
        File('$_projectGuiDistPath/index.html').existsSync()) {
      return _projectGuiDistPath;
    }
    final cwdPath = Directory.current.path;
    return '$cwdPath/thirdPartyPackages/AppAIPlugin/libs/gui/dist';
  }

  String? _resolveBundledGuiDistPath() {
    final candidateRoots = <Directory>[];
    var searchDirectory = File(Platform.resolvedExecutable).parent;
    while (true) {
      candidateRoots.add(searchDirectory);
      final parentDirectory = searchDirectory.parent;
      if (parentDirectory.path == searchDirectory.path) {
        break;
      }
      searchDirectory = parentDirectory;
    }

    for (final root in candidateRoots) {
      final candidates = <String>[
        // macOS Flutter 桌面产物会把 Flutter assets 放在 App.framework 的
        // Versions 目录下；不同构建方式下 symlink 解析不一定稳定，所以同时查
        // Versions/A 与 Versions/Current 的真实路径。
        '${root.path}/Frameworks/App.framework/Versions/A/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/Frameworks/App.framework/Versions/Current/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/Frameworks/App.framework/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/App.framework/Versions/A/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/App.framework/Versions/Current/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/App.framework/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/Resources/flutter_assets/$_assetGuiDistPath',
        '${root.path}/flutter_assets/$_assetGuiDistPath',
      ];
      for (final candidate in candidates) {
        if (File('$candidate/index.html').existsSync()) {
          return candidate;
        }
      }
    }
    return null;
  }

  List<Map<String, Object?>> _modelsForRole(String role) {
    return <Map<String, Object?>>[
      for (final entry in Params.appAiBailianModels)
        if ((entry['roles'] as List<String>).contains(role))
          _modelToContinueModel(entry, role),
    ];
  }

  Map<String, Object?>? _selectedModelForRole(String role) {
    for (final entry in Params.appAiBailianModels) {
      if ((entry['roles'] as List<String>).contains(role)) {
        return _modelToContinueModel(entry, role);
      }
    }
    return null;
  }

  Map<String, Object?> _modelToContinueModel(
      Map<String, Object?> entry, String role) {
    return <String, Object?>{
      'title': entry['name'],
      'model': entry['model'],
      'provider': 'openai',
      'underlyingProviderName': 'openai',
      'apiBase': entry['baseUrl'],
      'apiKey': entry['apiKey'],
      'contextLength': entry['contextLength'],
      'completionOptions': <String, Object?>{
        'model': entry['model'],
        'maxTokens': entry['maxTokens'],
      },
      'roles': <String>[role],
    };
  }

  Map<String, Object?> _buildSerializedProfileInfo() {
    return <String, Object?>{
      'organizations': <Object?>[
        <String, Object?>{
          'id': 'personal',
          'profiles': <Object?>[
            <String, Object?>{
              'title': 'Bailian',
              'id': 'bailian',
              'errors': const <Object?>[],
              'profileType': 'local',
              'uri': '',
              'iconUrl': '',
              'fullSlug': <String, Object?>{
                'ownerSlug': '',
                'packageSlug': '',
                'versionSlug': '',
              },
            },
          ],
          'slug': '',
          'selectedProfileId': 'bailian',
          'name': 'Personal',
          'iconUrl': '',
        },
      ],
      'profileId': 'bailian',
      'result': <String, Object?>{
        'config': <String, Object?>{
          'tools': AIInterfaceManager.getInstance().getToolDefinitions(),
          'slashCommands': const <Object?>[],
          'contextProviders': const <Object?>[],
          'mcpServerStatuses': const <Object?>[],
          'usePlatform': true,
          'modelsByRole': <String, Object?>{
            'chat': _modelsForRole('chat'),
            'apply': _modelsForRole('apply'),
            'edit': _modelsForRole('edit'),
            'summarize': const <Object?>[],
            'autocomplete': _modelsForRole('autocomplete'),
            'rerank': const <Object?>[],
            'embed': const <Object?>[],
            'subagent': const <Object?>[],
          },
          'selectedModelByRole': <String, Object?>{
            'chat': _selectedModelForRole('chat'),
            'apply': _selectedModelForRole('apply'),
            'edit': _selectedModelForRole('edit'),
            'summarize': null,
            'autocomplete': _selectedModelForRole('autocomplete'),
            'rerank': null,
            'embed': null,
            'subagent': null,
          },
          'rules': AIInterfaceManager.getInstance().getRules(),
        },
        'errors': const <Object?>[],
        'configLoadInterrupted': false,
      },
      'selectedOrgId': 'personal',
    };
  }

  Future<void> _primeContinueGuiConfiguration(
      Map<String, Object?> serializedProfileInfo) async {
    for (var index = 0; index < 3; index += 1) {
      await Future<void>.delayed(Duration(milliseconds: 250 * (index + 1)));
      if (!mounted) {
        return;
      }
      await _shellPort.postMessage(
        ContinueMessage(
          messageType: 'configUpdate',
          messageId: 'timehello-ai-configUpdate-$index',
          data: serializedProfileInfo,
        ),
      );
    }
  }

  /// 功能：响应 AppAIPlugin 输入栏的开始录音请求，只启动原生录音，不弹出额外页面。
  Future<Map<String, Object?>> _startVoiceRecordingForGui() async {
    final localPath = await _voiceRecordUtils.start();
    return <String, Object?>{
      'recording': true,
      'localPath': localPath,
    };
  }

  /// 功能：响应输入栏的结束录音请求，停止录音后上传 OSS，并将公网音频 URL 交给百炼转写。
  Future<Map<String, Object?>> _stopVoiceRecordingForGui() async {
    final recordResult = await _voiceRecordUtils.stop();
    final transcriptionResult =
        await VoiceTranscriptionManager.getInstance().transcribeLocalAudioFile(
      localPath: recordResult.path,
      fileNamePrefix: 'app_ai_voice',
    );
    return <String, Object?>{
      'text': transcriptionResult.text,
      'audioUrl': transcriptionResult.audioUrl,
      'localPath': recordResult.path,
      'duration': recordResult.duration,
      'fileSize': recordResult.fileSize,
    };
  }

  /// 功能：响应输入栏取消录音请求，丢弃当前临时音频，不触发上传和转写。
  Future<Map<String, Object?>> _cancelVoiceRecordingForGui() async {
    await _voiceRecordUtils.cancel();
    return const <String, Object?>{'cancelled': true};
  }

  Stream<String> _handleGuiStreamChat(
    ContinueMessage message,
    String? prompt,
  ) async* {
    developer.log(
      'streamChat in: promptLength=${(prompt ?? '').trim().length}',
      name: 'TimeHelloAIPage',
    );
    final rawData = message.data;
    final chatMessages = _extractOpenAiMessages(rawData);
    if (chatMessages.isEmpty && prompt != null && prompt.trim().isNotEmpty) {
      chatMessages.add(<String, String>{
        'role': 'user',
        'content': prompt.trim(),
      });
    }
    if (chatMessages.isEmpty) {
      yield 'No prompt provided.';
      return;
    }

    try {
      if (mounted) {
        setState(() {
          _isAiStreaming = true;
        });
      }
      final usageAllowed = await _consumeAiUsageIfAllowed();
      if (!usageAllowed) {
        yield _aiUsageLimitMessage();
        return;
      }
      final latestUserPrompt = _latestUserPrompt(chatMessages);
      developer.log(
        'routeCheck prompt=$latestUserPrompt '
        'moveFolder=${_shouldAutoMoveFolders(latestUserPrompt)} '
        'updateTimeRange=${_shouldAutoUpdateMissionTimeRange(latestUserPrompt)} '
        'updateDate=${_shouldAutoUpdateMissionDate(latestUserPrompt)} '
        'complete=${_shouldAutoCompleteMissions(latestUserPrompt)} '
        'rename=${_shouldAutoUpdateMissions(latestUserPrompt)}',
        name: 'TimeHelloAIPage',
      );
      if (_shouldAutoDeleteFolders(latestUserPrompt)) {
        yield _aiText(zh: '正在删除清单...', en: 'Deleting lists...');
        final toolArgs = await _buildDeleteFolderToolArgs(
          latestUserPrompt,
          modelEntry: _resolveModelFromStreamData(rawData),
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.batchDeleteFoldersToolName,
          toolArgs,
        );
        final contextItems = result['contextItems'];
        final firstContextItem = contextItems is List && contextItems.isNotEmpty
            ? contextItems.first
            : null;
        final content = firstContextItem is Map
            ? firstContextItem['content']?.toString()
            : null;
        if (result['ok'] == true) {
          yield '\n${content ?? '已删除 ${result['count']} 个清单。'}';
        } else {
          yield '\n${content ?? '删除清单失败：${result['message'] ?? '未找到可删除的清单'}'}';
        }
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoDeleteMissions(latestUserPrompt)) {
        yield _aiText(zh: '正在删除任务...', en: 'Deleting tasks...');
        final toolArgs = await _buildDeleteMissionToolArgs(
          latestUserPrompt,
          modelEntry: _resolveModelFromStreamData(rawData),
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.batchDeleteMissionsToolName,
          toolArgs,
        );
        final contextItems = result['contextItems'];
        final firstContextItem = contextItems is List && contextItems.isNotEmpty
            ? contextItems.first
            : null;
        final content = firstContextItem is Map
            ? firstContextItem['content']?.toString()
            : null;
        if (result['ok'] == true) {
          yield '\n${content ?? '已删除 ${result['count']} 个任务。'}';
        } else {
          yield '\n${content ?? '删除任务失败：${result['message'] ?? '未找到可删除的任务'}'}';
        }
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoListTodayUnfinishedMissions(latestUserPrompt)) {
        yield _aiText(
          zh: '正在查询今天未完成的任务...',
          en: 'Looking up today\'s unfinished tasks...',
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.listMissionsToolName,
          _todayMissionListArgs(isFinished: false),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? '今天没有查询到未完成任务。'}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoListTodayCompletedMissions(latestUserPrompt)) {
        yield _aiText(
          zh: '正在查询今天完成的任务...',
          en: 'Looking up tasks completed today...',
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.listMissionsToolName,
          _todayMissionListArgs(isFinished: true),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? '今天没有查询到已完成任务。'}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoListTodayMissions(latestUserPrompt)) {
        yield _aiText(
          zh: '正在查询今天的任务...',
          en: 'Looking up today\'s tasks...',
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.listMissionsToolName,
          _todayMissionListArgs(),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? '今天没有查询到任务。'}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoListTomorrowMissions(latestUserPrompt)) {
        yield _aiText(
          zh: '正在查询明天的任务...',
          en: 'Looking up tomorrow\'s tasks...',
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.listMissionsToolName,
          _relativeDateMissionListArgs(dateStatus: 2, isFinished: false),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? '明天没有查询到未完成任务。'}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoMoveFolders(latestUserPrompt)) {
        developer.log(
          'localRoute moveFolder prompt=$latestUserPrompt '
          'args=${jsonEncode(_buildLocalMoveFolderArgs(latestUserPrompt))}',
          name: 'TimeHelloAIPage',
        );
        yield _aiText(zh: '正在移动清单...', en: 'Moving the list...');
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.updateFoldersToolName,
          _buildLocalMoveFolderArgs(latestUserPrompt),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? _aiText(zh: '清单移动完成。', en: 'List moved.')}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoUpdateMissionTimeRange(latestUserPrompt)) {
        developer.log(
          'localRoute updateMissionTimeRange prompt=$latestUserPrompt '
          'args=${jsonEncode(_buildLocalMissionTimeRangeUpdateArgs(latestUserPrompt))}',
          name: 'TimeHelloAIPage',
        );
        yield _aiText(
          zh: '正在更新任务时间...',
          en: 'Updating the task time...',
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.updateMissionsToolName,
          _buildLocalMissionTimeRangeUpdateArgs(latestUserPrompt),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? _aiText(zh: '任务时间已更新。', en: 'Task time updated.')}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoUpdateMissionDate(latestUserPrompt)) {
        developer.log(
          'localRoute updateMissionDate prompt=$latestUserPrompt '
          'args=${jsonEncode(_buildLocalMissionDateUpdateArgs(latestUserPrompt))}',
          name: 'TimeHelloAIPage',
        );
        yield _aiText(
          zh: '正在更新任务时间...',
          en: 'Updating the task time...',
        );
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.updateMissionsToolName,
          _buildLocalMissionDateUpdateArgs(latestUserPrompt),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? _aiText(zh: '任务时间已更新。', en: 'Task time updated.')}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoCompleteMissions(latestUserPrompt)) {
        developer.log(
          'localRoute completeMission prompt=$latestUserPrompt '
          'args=${jsonEncode(_buildLocalCompleteMissionArgs(latestUserPrompt))}',
          name: 'TimeHelloAIPage',
        );
        yield _aiText(zh: '正在完成任务...', en: 'Completing the task...');
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.updateMissionsToolName,
          _buildLocalCompleteMissionArgs(latestUserPrompt),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? _aiText(zh: '任务已完成。', en: 'Task completed.')}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoUpdateMissions(latestUserPrompt)) {
        yield _aiText(zh: '正在更新任务...', en: 'Updating the task...');
        final result = await AIInterfaceManager.getInstance().callTool(
          AIInterfaceManager.updateMissionsToolName,
          _buildLocalRenameMissionArgs(latestUserPrompt),
        );
        final content = _firstContextContent(result);
        yield '\n${content ?? _aiText(zh: '任务更新完成。', en: 'Task updated.')}';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      if (_shouldAutoCreateFolders(latestUserPrompt) ||
          _shouldAutoCreateMissions(latestUserPrompt)) {
        yield _shouldAutoCreateFolders(latestUserPrompt) &&
                _shouldAutoCreateMissions(latestUserPrompt)
            ? _aiText(
                zh: '正在创建清单和任务...',
                en: 'Creating lists and tasks...',
              )
            : _shouldAutoCreateFolders(latestUserPrompt)
                ? _aiText(zh: '正在创建清单...', en: 'Creating lists...')
                : _aiText(zh: '正在创建任务...', en: 'Creating tasks...');
        final content = await _handleCreateIntent(
          latestUserPrompt,
          modelEntry: _resolveModelFromStreamData(rawData),
        );
        yield '\n$content';
        AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
        return;
      }

      var streamedLength = 0;
      await for (final chunk in _requestChatStream(
        messages: chatMessages,
        modelEntry: _resolveModelFromStreamData(rawData),
      )) {
        streamedLength += chunk.length;
        yield chunk;
      }
      developer.log(
        'streamChat out: responseLength=$streamedLength',
        name: 'TimeHelloAIPage',
      );
      AIInterfaceManager.getInstance().notifyAiReplyFinishedIfHidden();
    } catch (error, stackTrace) {
      developer.log(
        'streamChat failed',
        name: 'TimeHelloAIPage',
        error: error,
        stackTrace: stackTrace,
      );
      yield 'AI 请求失败：$error';
    } finally {
      if (mounted) {
        setState(() {
          _isAiStreaming = false;
        });
      }
    }
  }

  bool _shouldAutoCreateMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    final createWords = <String>[
      '创建任务',
      '批量创建任务',
      '新建任务',
      '添加任务',
      '新增任务',
      '创建多个任务',
      '添加多个任务',
      '安排任务',
      '帮我记',
      '提醒我',
    ];
    final hasCreateWord = text.contains('创建') ||
        text.contains('新建') ||
        text.contains('添加') ||
        text.contains('新增') ||
        text.contains('安排');
    final hasMissionWord = text.contains('任务');
    return createWords.any(text.contains) || (hasCreateWord && hasMissionWord);
  }

  bool _shouldAutoCreateFolders(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    final createWords = <String>[
      '创建清单',
      '新建清单',
      '添加清单',
      '创建文件夹',
      '新建文件夹',
      '添加文件夹',
      '创建标签',
      '新建标签',
      '添加标签',
    ];
    return createWords.any(text.contains);
  }

  bool _shouldAutoUpdateMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    return _parseLocalRenameMission(text) != null;
  }

  bool _shouldAutoCompleteMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    return _parseLocalCompleteMission(text) != null;
  }

  bool _shouldAutoUpdateMissionDate(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    return _parseLocalMissionDateUpdate(text) != null;
  }

  bool _shouldAutoUpdateMissionTimeRange(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    return _parseLocalMissionTimeRangeUpdate(text) != null;
  }

  Map<String, Object?> _buildLocalMissionTimeRangeUpdateArgs(String prompt) {
    final update = _parseLocalMissionTimeRangeUpdate(prompt);
    if (update == null) {
      return const <String, Object?>{'datas': <Object?>[]};
    }
    return <String, Object?>{
      'datas': <Object?>[
        <String, Object?>{
          'title': update.title,
          'time_mode': 1,
          'start_time': update.range.start.toIso8601String(),
          'end_time': update.range.end.toIso8601String(),
          if (update.dateStatus != null) 'dateStatus': update.dateStatus,
          'isFinished': false,
        },
      ],
    };
  }

  _ParsedMissionTimeRangeUpdate? _parseLocalMissionTimeRangeUpdate(
    String prompt,
  ) {
    final text = prompt.trim();
    final directUpdate = _parseDirectMissionTimeRangeUpdate(text);
    if (directUpdate != null) {
      return directUpdate;
    }

    final patterns = <RegExp>[
      RegExp(
          r'^(?:把|将)?\s*(?:任务|待办|计划)\s*(.+?)\s*(?:改到|改成|改为|修改为|调整到|调整为|设为|设置为|安排到)\s*(.+)$'),
      RegExp(
          r'^(?:把|将)?\s*(.+?)\s*(?:任务|待办|计划)?\s*(?:改到|改成|改为|修改为|调整到|调整为|设为|设置为|安排到)\s*(.+)$'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final title = _cleanMissionActionTitle(match?.group(1));
      final timeText = match?.group(2)?.trim();
      final range =
          timeText == null ? null : _parseLocalMissionTimeRange(timeText);
      if (title != null &&
          title.isNotEmpty &&
          range != null &&
          _looksLikeTimeRangeText(timeText ?? '')) {
        return _ParsedMissionTimeRangeUpdate(
          title: title,
          range: range,
          dateStatus: _dateStatusForDate(range.start),
        );
      }
    }

    final englishPatterns = <RegExp>[
      RegExp(
        r'^(?:change|update|set|move|reschedule)\s+(?:the\s+)?(?:task|todo|mission)\s+(.+?)\s+(?:to|for)\s+(.+)$',
        caseSensitive: false,
      ),
      RegExp(
        r'^(?:change|update|set|move|reschedule)\s+(.+?)\s+(?:task|todo|mission)\s+(?:to|for)\s+(.+)$',
        caseSensitive: false,
      ),
    ];
    for (final pattern in englishPatterns) {
      final match = pattern.firstMatch(text);
      final title = _cleanMissionActionTitle(match?.group(1));
      final timeText = match?.group(2)?.trim();
      final range =
          timeText == null ? null : _parseLocalMissionTimeRange(timeText);
      if (title != null &&
          title.isNotEmpty &&
          range != null &&
          _looksLikeTimeRangeText(timeText ?? '')) {
        return _ParsedMissionTimeRangeUpdate(
          title: title,
          range: range,
          dateStatus: _dateStatusForDate(range.start),
        );
      }
    }
    return null;
  }

  _ParsedMissionTimeRangeUpdate? _parseDirectMissionTimeRangeUpdate(
    String text,
  ) {
    final updateWords = <String>[
      '改到',
      '改成',
      '改为',
      '修改为',
      '调整到',
      '调整为',
      '设为',
      '设置为',
      '安排到',
    ];
    String? updateWord;
    var updateIndex = -1;
    for (final word in updateWords) {
      final index = text.indexOf(word);
      if (index >= 0 && (updateIndex < 0 || index < updateIndex)) {
        updateWord = word;
        updateIndex = index;
      }
    }
    if (updateWord == null || updateIndex <= 0) {
      return null;
    }

    var titlePart = text.substring(0, updateIndex).trim();
    final timePart = text.substring(updateIndex + updateWord.length).trim();
    if (!_looksLikeTimeRangeText(timePart)) {
      return null;
    }
    titlePart = titlePart
        .replaceFirst(RegExp(r'^(?:把|将)\s*'), '')
        .replaceFirst(RegExp(r'^(?:任务|待办|计划)\s*'), '')
        .replaceFirst(RegExp(r'\s*(?:任务|待办|计划)$'), '')
        .trim();
    final title = _cleanMissionActionTitle(titlePart);
    final range = _parseLocalMissionTimeRange(timePart);
    if (title == null || title.isEmpty || range == null) {
      return null;
    }
    return _ParsedMissionTimeRangeUpdate(
      title: title,
      range: range,
      dateStatus: _dateStatusForDate(range.start),
    );
  }

  Map<String, Object?> _buildLocalMissionDateUpdateArgs(String prompt) {
    final update = _parseLocalMissionDateUpdate(prompt);
    if (update == null) {
      return const <String, Object?>{'datas': <Object?>[]};
    }
    return <String, Object?>{
      'datas': <Object?>[
        <String, Object?>{
          'title': update.title,
          'time_mode': 0,
          'end_time': update.endTime.toIso8601String(),
          if (update.dateStatus != null) 'dateStatus': update.dateStatus,
          'isFinished': false,
        },
      ],
    };
  }

  _ParsedMissionDateUpdate? _parseLocalMissionDateUpdate(String prompt) {
    final text = prompt.trim();
    final patterns = <RegExp>[
      RegExp(
          r'^(?:把|将)?\s*(.+?)\s*(?:任务|待办|计划)?\s*(?:改成|改为|修改为|调整为|设为|设置为)\s*(今天|今日|明天|明日|后天)\s*(?:完成|截止|到期)\s*$'),
      RegExp(
          r'^(?:把|将)?\s*(?:任务|待办|计划)\s*(.+?)\s*(?:改成|改为|修改为|调整为|设为|设置为)\s*(今天|今日|明天|明日|后天)\s*(?:完成|截止|到期)\s*$'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final title = _cleanMissionActionTitle(match?.group(1));
      final dateWord = match?.group(2);
      final dateInfo = _relativeEndOfDay(dateWord);
      if (title != null && title.isNotEmpty && dateInfo != null) {
        return _ParsedMissionDateUpdate(
          title: title,
          endTime: dateInfo.endTime,
          dateStatus: dateInfo.dateStatus,
        );
      }
    }
    return null;
  }

  _ParsedMissionDateUpdate? _relativeEndOfDay(String? dateWord) {
    if (dateWord == null) {
      return null;
    }
    final now = DateTime.now();
    var offsetDays = 0;
    int? dateStatus = 1;
    if (dateWord == '明天' || dateWord == '明日') {
      offsetDays = 1;
      dateStatus = 2;
    } else if (dateWord == '后天') {
      offsetDays = 2;
      dateStatus = null;
    }
    final date = DateTime(now.year, now.month, now.day + offsetDays);
    return _ParsedMissionDateUpdate(
      title: '',
      endTime: DateTime(date.year, date.month, date.day, 23, 59, 59),
      dateStatus: dateStatus,
    );
  }

  Map<String, Object?> _buildLocalCompleteMissionArgs(String prompt) {
    final complete = _parseLocalCompleteMission(prompt);
    if (complete == null) {
      return const <String, Object?>{'datas': <Object?>[]};
    }
    return <String, Object?>{
      'datas': <Object?>[
        <String, Object?>{
          'title': complete.title,
          'isFinished': true,
          'finish_time': DateTime.now().millisecondsSinceEpoch,
        },
      ],
    };
  }

  _ParsedCompleteMission? _parseLocalCompleteMission(String prompt) {
    final text = prompt.trim();
    final patterns = <RegExp>[
      RegExp(
          r'^(?:把|将)?\s*(.+?)\s*(?:任务|待办|计划)?\s*(?:改成|改为|修改为|标记为|设为|设置为)\s*(?:今天|今日|现在)?\s*(?:已完成|完成|做完)\s*$'),
      RegExp(r'^(?:完成|做完)\s*(?:任务|待办|计划)?\s*(.+?)\s*$'),
      RegExp(r'^(?:任务|待办|计划)?\s*(.+?)\s*(?:今天|今日|刚刚|已经)?\s*(?:完成了|做完了)\s*$'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final title = _cleanMissionActionTitle(match?.group(1));
      if (title != null && title.isNotEmpty) {
        return _ParsedCompleteMission(title);
      }
    }
    return null;
  }

  String? _cleanMissionActionTitle(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) {
      return null;
    }
    return text
        .replaceAll(RegExp(r'^[“"「『\s]+'), '')
        .replaceAll(RegExp(r'^(?:把|将)\s*'), '')
        .replaceAll(RegExp(r'^(?:任务|待办|计划)\s*'), '')
        .replaceAll(RegExp(r'[”"」』。；;，,]+$'), '')
        .replaceAll(RegExp(r'\s*(?:任务|待办|计划)$'), '')
        .trim();
  }

  bool _shouldAutoMoveFolders(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    return _parseLocalMoveFolder(text) != null;
  }

  Map<String, Object?> _buildLocalMoveFolderArgs(String prompt) {
    final move = _parseLocalMoveFolder(prompt);
    if (move == null) {
      return const <String, Object?>{'datas': <Object?>[]};
    }
    return <String, Object?>{
      'datas': <Object?>[
        <String, Object?>{
          'title': move.childTitle,
          'lookup_tag': 1,
          'parent_folder_title': move.parentTitle,
        },
      ],
    };
  }

  _ParsedMoveFolder? _parseLocalMoveFolder(String prompt) {
    final text = prompt.trim();
    final directMove = _parseDirectMoveFolderText(text);
    if (directMove != null) {
      return directMove;
    }

    final patterns = <RegExp>[
      RegExp(
          r'^(?:把|将)?\s*(?:清单|列表)\s*(.+?)\s*(?:移动到|移到|放到|归到|挪到)\s*(?:文件夹|目录)?\s*(.+?)\s*(?:下面|下|里|中)?$'),
      RegExp(
          r'^(?:把|将)?\s*(.+?)\s*(?:清单|列表)\s*(?:移动到|移到|放到|归到|挪到)\s*(?:文件夹|目录)?\s*(.+?)\s*(?:下面|下|里|中)?$'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final childTitle = _cleanFolderMoveTitle(match?.group(1));
      final parentTitle = _cleanFolderMoveTitle(match?.group(2));
      if (childTitle != null &&
          parentTitle != null &&
          childTitle.isNotEmpty &&
          parentTitle.isNotEmpty &&
          childTitle != parentTitle) {
        return _ParsedMoveFolder(childTitle, parentTitle);
      }
    }
    return null;
  }

  _ParsedMoveFolder? _parseDirectMoveFolderText(String text) {
    final moveWords = <String>['移动到', '移到', '放到', '归到', '挪到'];
    String? moveWord;
    var moveIndex = -1;
    for (final word in moveWords) {
      final index = text.indexOf(word);
      if (index >= 0 && (moveIndex < 0 || index < moveIndex)) {
        moveWord = word;
        moveIndex = index;
      }
    }
    if (moveWord == null || moveIndex <= 0) {
      return null;
    }

    var childPart = text.substring(0, moveIndex).trim();
    var parentPart = text.substring(moveIndex + moveWord.length).trim();
    childPart = childPart
        .replaceFirst(RegExp(r'^(?:把|将)\s*'), '')
        .replaceFirst(RegExp(r'^(?:清单|列表)\s*'), '')
        .replaceFirst(RegExp(r'\s*(?:清单|列表)$'), '')
        .trim();
    parentPart = parentPart
        .replaceFirst(RegExp(r'^(?:文件夹|目录)\s*'), '')
        .replaceFirst(RegExp(r'\s*(?:下面|下|里|中)$'), '')
        .trim();

    final childTitle = _cleanFolderMoveTitle(childPart);
    final parentTitle = _cleanFolderMoveTitle(parentPart);
    if (childTitle == null ||
        parentTitle == null ||
        childTitle.isEmpty ||
        parentTitle.isEmpty ||
        childTitle == parentTitle) {
      return null;
    }
    return _ParsedMoveFolder(childTitle, parentTitle);
  }

  String? _cleanFolderMoveTitle(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) {
      return null;
    }
    return text
        .replaceAll(RegExp(r'^[“"「『\s]+'), '')
        .replaceAll(RegExp(r'[”"」』。；;，,]+$'), '')
        .replaceAll(RegExp(r'^(?:文件夹|目录)\s*'), '')
        .replaceAll(RegExp(r'\s*(?:文件夹|目录)$'), '')
        .replaceAll(RegExp(r'\s*(?:下面|下|里|中)$'), '')
        .trim();
  }

  bool _shouldAutoDeleteMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    // 只要用户明确说的是清单/文件夹/标签，就不能落到任务删除。
    // “批量删除清单：A、B” 里也包含“批量删除”，这里必须先挡住。
    if (_hasFolderModelNoun(text) || _shouldAutoDeleteFolders(text)) {
      return false;
    }
    final deleteWords = <String>[
      '删除任务',
      '删掉任务',
      '移除任务',
      '清除任务',
      '批量删除',
      '批量删掉',
      '取消任务',
    ];
    return deleteWords.any(text.contains);
  }

  bool _shouldAutoDeleteFolders(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    final deleteWords = <String>[
      '删除清单',
      '删掉清单',
      '移除清单',
      '删除文件夹',
      '删掉文件夹',
      '移除文件夹',
      '删除标签',
      '删掉标签',
      '移除标签',
    ];
    final hasDeleteWord = text.contains('删除') ||
        text.contains('删掉') ||
        text.contains('移除') ||
        text.contains('批量删除') ||
        text.contains('批量删掉');
    return deleteWords.any(text.contains) ||
        (hasDeleteWord && _hasFolderModelNoun(text));
  }

  bool _hasFolderModelNoun(String text) {
    return text.contains('清单') ||
        text.contains('文件夹') ||
        text.contains('标签') ||
        text.toLowerCase().contains('folder') ||
        text.toLowerCase().contains('list') ||
        text.toLowerCase().contains('tag');
  }

  bool _shouldAutoListTodayCompletedMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    if (_hasUnfinishedMissionIntent(text)) {
      return false;
    }
    final hasToday = text.contains('今天') || text.contains('今日');
    final hasFinished = text.contains('完成') ||
        text.contains('做完') ||
        text.contains('已做') ||
        text.contains('已完成');
    final hasMission = text.contains('任务') ||
        text.contains('哪几个') ||
        text.contains('哪些') ||
        text.contains('有什么');
    final isQuestion = text.contains('什么') ||
        text.contains('哪些') ||
        text.contains('哪几个') ||
        text.contains('查询') ||
        text.contains('看看') ||
        text.contains('列出') ||
        text.contains('有什么');
    return hasToday && hasFinished && hasMission && isQuestion;
  }

  bool _shouldAutoListTodayUnfinishedMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    final hasToday = text.contains('今天') || text.contains('今日');
    final hasMission = text.contains('任务') ||
        text.contains('待办') ||
        text.contains('计划') ||
        text.contains('哪些') ||
        text.contains('哪几个') ||
        text.contains('有什么');
    final isQuestion = text.contains('什么') ||
        text.contains('哪些') ||
        text.contains('哪几个') ||
        text.contains('查询') ||
        text.contains('看看') ||
        text.contains('列出') ||
        text.contains('有什么');
    return hasToday &&
        hasMission &&
        isQuestion &&
        _hasUnfinishedMissionIntent(text);
  }

  bool _shouldAutoListTodayMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    final hasToday = text.contains('今天') || text.contains('今日');
    final hasMission = text.contains('任务') ||
        text.contains('待办') ||
        text.contains('计划') ||
        text.contains('有什么');
    final hasFinished =
        _hasFinishedMissionIntent(text) || _hasUnfinishedMissionIntent(text);
    final isQuestion = text.contains('什么') ||
        text.contains('哪些') ||
        text.contains('哪几个') ||
        text.contains('查询') ||
        text.contains('看看') ||
        text.contains('列出') ||
        text.contains('有什么');
    return hasToday && hasMission && isQuestion && !hasFinished;
  }

  bool _shouldAutoListTomorrowMissions(String prompt) {
    final text = prompt.trim();
    if (text.isEmpty) {
      return false;
    }
    final hasTomorrow = text.contains('明天') || text.contains('明日');
    final hasMission = text.contains('任务') ||
        text.contains('待办') ||
        text.contains('计划') ||
        text.contains('安排') ||
        text.contains('有什么');
    final isQuestion = text.contains('什么') ||
        text.contains('哪些') ||
        text.contains('哪几个') ||
        text.contains('查询') ||
        text.contains('看看') ||
        text.contains('列出') ||
        text.contains('有什么');
    return hasTomorrow && hasMission && isQuestion;
  }

  bool _hasFinishedMissionIntent(String text) {
    return text.contains('已完成') ||
        text.contains('完成了') ||
        text.contains('做完') ||
        text.contains('已做');
  }

  bool _hasUnfinishedMissionIntent(String text) {
    return text.contains('未完成') ||
        text.contains('没完成') ||
        text.contains('没有完成') ||
        text.contains('待完成') ||
        text.contains('待办');
  }

  Map<String, Object?> _buildLocalRenameMissionArgs(String prompt) {
    final rename = _parseLocalRenameMission(prompt);
    if (rename == null) {
      return const <String, Object?>{'datas': <Object?>[]};
    }
    return <String, Object?>{
      'datas': <Object?>[
        <String, Object?>{
          'title': rename.oldTitle,
          'new_title': rename.newTitle,
        },
      ],
    };
  }

  _ParsedRenameMission? _parseLocalRenameMission(String prompt) {
    final text = prompt.trim();
    final patterns = <RegExp>[
      RegExp(
          r'^(?:把|将)?\s*(?:任务|待办|计划)\s*(.+?)\s*(?:改成|改为|修改为|重命名为|命名为)\s*(.+)$'),
      RegExp(r'^(?:把|将)\s*(.+?)\s*(?:改成|改为|修改为|重命名为|命名为)\s*(.+)$'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final oldTitle = _cleanRenameTitle(match?.group(1));
      final newTitle = _cleanRenameTitle(match?.group(2));
      if (oldTitle != null &&
          newTitle != null &&
          oldTitle.isNotEmpty &&
          newTitle.isNotEmpty &&
          !_looksLikeRelativeCompletionDate(newTitle) &&
          !_looksLikeTimeRangeText(newTitle) &&
          oldTitle != newTitle) {
        return _ParsedRenameMission(oldTitle, newTitle);
      }
    }
    return null;
  }

  bool _looksLikeRelativeCompletionDate(String value) {
    final text = value.trim();
    return RegExp(r'^(?:今天|今日|明天|明日|后天)\s*(?:完成|截止|到期)$').hasMatch(text);
  }

  bool _looksLikeTimeRangeText(String value) {
    final text = value.trim();
    final hasTime = RegExp(r'(?:点|时|:|：)').hasMatch(text) ||
        RegExp(r'\b\d{1,2}\s*(?:am|pm)\b', caseSensitive: false).hasMatch(text);
    final hasRange = RegExp(r'(?:到|至|\-|—|~)').hasMatch(text) ||
        RegExp(r'\b(?:to|until|through)\b', caseSensitive: false)
            .hasMatch(text);
    return hasTime && hasRange;
  }

  int? _dateStatusForDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diffDays = target.difference(today).inDays;
    if (diffDays == 0) {
      return 1;
    }
    if (diffDays == 1) {
      return 2;
    }
    return null;
  }

  String? _cleanRenameTitle(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) {
      return null;
    }
    return text
        .replaceAll(RegExp(r'^[“"「『\s]+'), '')
        .replaceAll(RegExp(r'[”"」』。；;，,]+$'), '')
        .trim();
  }

  String _aiText({
    required String zh,
    required String en,
  }) {
    // AI 面板的流式状态不是普通 Widget 文案，先按当前应用 locale 做轻量映射。
    // 后续如果这些文案沉淀为固定 UI，再迁移到 ARB / S.of(context)。
    final locale = Localizations.maybeLocaleOf(context);
    final languageCode = locale?.languageCode.toLowerCase();
    return languageCode == null || languageCode == 'zh' ? zh : en;
  }

  Map<String, Object?> _todayMissionListArgs({bool? isFinished}) {
    return _relativeDateMissionListArgs(dateStatus: 1, isFinished: isFinished);
  }

  Map<String, Object?> _relativeDateMissionListArgs({
    required int dateStatus,
    bool? isFinished,
  }) {
    final args = <String, Object?>{
      'dateStatus': dateStatus,
      'limit': 100,
    };
    if (isFinished != null) {
      args['isFinished'] = isFinished;
    }
    if (isFinished == true) {
      final currentTime = AIInterfaceManager.getInstance().getCurrentTime(
        const <String, Object?>{},
      );
      final today = currentTime['today'];
      final todayRange = today is Map ? today : const <Object?, Object?>{};
      args
        ..['completed_start_time'] = todayRange['dayStartMillis']
        ..['completed_end_time'] = todayRange['nextDayStartMillis'];
    }
    return args;
  }

  String? _firstContextContent(Map<String, Object?> result) {
    final contextItems = result['contextItems'];
    final firstContextItem = contextItems is List && contextItems.isNotEmpty
        ? contextItems.first
        : null;
    return firstContextItem is Map
        ? firstContextItem['content']?.toString()
        : null;
  }

  String _latestUserPrompt(List<Map<String, String>> messages) {
    for (final message in messages.reversed) {
      if (message['role'] == 'user') {
        return message['content'] ?? '';
      }
    }
    return '';
  }

  Future<String> _handleCreateIntent(
    String prompt, {
    required Map<String, Object?> modelEntry,
  }) async {
    final summaries = <String>[];
    String? latestCreatedFolderTitle;
    if (_shouldAutoCreateFolders(prompt)) {
      final toolArgs = await _buildCreateFolderToolArgs(
        prompt,
        modelEntry: modelEntry,
      );
      final result = await AIInterfaceManager.getInstance().callTool(
        AIInterfaceManager.createFoldersToolName,
        toolArgs,
      );
      latestCreatedFolderTitle =
          _createdFolderTitleFromResult(result) ?? _firstFolderTitle(toolArgs);
      summaries.add(_toolResultContent(
        result,
        successFallback: '已创建 ${result['count']} 个清单。',
        failureFallback: '创建清单失败：${result['message'] ?? '参数不完整'}',
      ));
    }
    if (_shouldAutoCreateMissions(prompt)) {
      final toolArgs = await _buildCreateMissionToolArgs(
        prompt,
        modelEntry: modelEntry,
      );
      _fillMissionFolderTitleIfNeeded(
        toolArgs,
        fallbackFolderTitle: latestCreatedFolderTitle,
      );
      final result = await AIInterfaceManager.getInstance().callTool(
        AIInterfaceManager.createMissionsToolName,
        toolArgs,
      );
      summaries.add(_toolResultContent(
        result,
        successFallback: '已创建 ${result['count']} 个任务。',
        failureFallback: '创建任务失败：${result['message'] ?? '参数不完整'}',
      ));
    }
    return summaries.where((item) => item.trim().isNotEmpty).join('\n');
  }

  String? _createdFolderTitleFromResult(Map<String, Object?> result) {
    final folders = result['folders'];
    if (folders is! List || folders.isEmpty) {
      return null;
    }
    final first = folders.first;
    if (first is Map) {
      final title = first['title']?.toString().trim();
      return title == null || title.isEmpty ? null : title;
    }
    return null;
  }

  String? _firstFolderTitle(Map<String, Object?> args) {
    final datas = args['datas'];
    if (datas is! List || datas.isEmpty) {
      return null;
    }
    final first = datas.first;
    if (first is Map) {
      final title = (first['title'] ?? first['name'])?.toString().trim();
      return title == null || title.isEmpty ? null : title;
    }
    return null;
  }

  void _fillMissionFolderTitleIfNeeded(
    Map<String, Object?> args, {
    required String? fallbackFolderTitle,
  }) {
    if (fallbackFolderTitle == null || fallbackFolderTitle.isEmpty) {
      return;
    }
    final datas = args['datas'];
    if (datas is! List) {
      return;
    }
    for (final item in datas) {
      if (item is Map<String, Object?>) {
        final current = item['folder_title'] ?? item['folderTitle'];
        if (_shouldReplaceRelativeFolderTitle(current)) {
          item['folder_title'] = fallbackFolderTitle;
        }
      } else if (item is Map) {
        final current = item['folder_title'] ?? item['folderTitle'];
        if (_shouldReplaceRelativeFolderTitle(current)) {
          item['folder_title'] = fallbackFolderTitle;
        }
      }
    }
  }

  bool _shouldReplaceRelativeFolderTitle(Object? value) {
    final text = value?.toString().trim();
    return text == null ||
        text.isEmpty ||
        text == '这个清单' ||
        text == '该清单' ||
        text == '刚创建的清单' ||
        text == '上述清单';
  }

  String _toolResultContent(
    Map<String, Object?> result, {
    required String successFallback,
    required String failureFallback,
  }) {
    final contextItems = result['contextItems'];
    final firstContextItem = contextItems is List && contextItems.isNotEmpty
        ? contextItems.first
        : null;
    final content = firstContextItem is Map
        ? firstContextItem['content']?.toString()
        : null;
    if (result['ok'] == true) {
      return content ?? successFallback;
    }
    return content ?? failureFallback;
  }

  Future<Map<String, Object?>> _buildCreateMissionToolArgs(
    String prompt, {
    required Map<String, Object?> modelEntry,
  }) async {
    final now = DateTime.now();
    final rawJson = await _requestChat(
      messages: <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
你是 TimeHello 的任务创建参数解析器。只输出 JSON，不要解释，不要使用 Markdown。
当前本地时间是：${now.toIso8601String()}。
把用户自然语言转换成 timehello.create_missions 的参数：
{
  "datas": [
    {
      "title": "任务标题",
      "time_mode": 1,
      "start_time": "ISO8601，可选",
      "end_time": "ISO8601，可选",
      "priorityStatus": 3,
      "tagNames": ["可选"],
      "subMissions": [{"title": "可选子任务"}],
      "total_tomotoes": 1,
      "objectiveUnit": "目标单位，可选",
      "objectiveValue": 0,
      "objectiveStartValue": 0,
      "objectiveTotalValue": 0
    }
  ]
}
规则：
1. 必须使用 MissionModel / MongoDB 标准字段：title、time_mode、start_time、end_time、dateStatus、priorityStatus、folder_id、folder_title、tagNames、subMissions、total_tomotoes、tomato_duration。
2. 禁止输出 name、taskName、任务名称、due_date、deadline 等非标准字段；要先转换为 title、end_time、time_mode。
3. 只解析“创建任务/添加任务/安排任务/提醒我/帮我记”的内容；遇到“创建清单/新建清单/添加清单/创建文件夹/创建标签”的片段必须忽略，不要把清单名称当成任务。
4. 没有明确时间就不要编造 start_time/end_time，也不要输出 time_mode=1；宿主会默认创建为今天的日期任务。如果有“今天/明天/后天/下周”等相对日期，优先输出 dateStatus；确实需要输出全天 end_time 时，使用当天 23:59:59.000，不要使用 23:59:59.999 或次日 00:00。
5. 如果用户说“在清单 X 下创建任务 Y / 在 X 清单下创建任务 Y”，必须输出 folder_title=X，title=Y；不要把 X 当任务标题。
6. 如果用户说“目标任务/目标 N 个/目标 N 次/目标 N 页/目标 N 分钟”，必须输出 time_mode=2、objectiveTotalValue=N、objectiveStartValue=0、objectiveValue=0、objectiveUnit=对应单位；不要把目标值写进 total_tomotoes。
7. 标题必须简短，不能为空。
8. 只返回一个 JSON object。
''',
        },
        <String, String>{'role': 'user', 'content': prompt},
      ],
      modelEntry: modelEntry,
    );
    final decoded = jsonDecode(_extractJsonObject(rawJson));
    if (decoded is! Map) {
      throw StateError('AI did not return a JSON object.');
    }
    final args = decoded.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
    _applyLocalMissionFolderTitle(prompt, args);
    _applyLocalMissionObjective(prompt, args);
    _applyLocalMissionTimeRange(prompt, args);
    return args;
  }

  void _applyLocalMissionObjective(
    String prompt,
    Map<String, Object?> args,
  ) {
    final objective = _parseMissionObjective(prompt);
    if (objective == null) {
      return;
    }
    final datas = args['datas'];
    if (datas is! List) {
      return;
    }
    for (final item in datas) {
      if (item is Map<String, Object?>) {
        item['time_mode'] = 2;
        item['objectiveValue'] = 0;
        item['objectiveStartValue'] = 0;
        item['objectiveTotalValue'] = objective.total;
        item['objectiveUnit'] = objective.unit;
        item.remove('start_time');
        item.remove('end_time');
      } else if (item is Map) {
        item['time_mode'] = 2;
        item['objectiveValue'] = 0;
        item['objectiveStartValue'] = 0;
        item['objectiveTotalValue'] = objective.total;
        item['objectiveUnit'] = objective.unit;
        item.remove('start_time');
        item.remove('end_time');
      }
    }
  }

  _ParsedObjective? _parseMissionObjective(String prompt) {
    final match = RegExp(
      r'(?:目标任务|目标)\s*(\d+(?:\.\d+)?)\s*([\u4e00-\u9fa5A-Za-z%]+)?',
    ).firstMatch(prompt);
    if (match == null) {
      return null;
    }
    final total = double.tryParse(match.group(1) ?? '');
    if (total == null) {
      return null;
    }
    final unit = (match.group(2) ?? '').trim();
    return _ParsedObjective(total, unit.isEmpty ? '个' : unit);
  }

  void _applyLocalMissionFolderTitle(
    String prompt,
    Map<String, Object?> args,
  ) {
    final folderTitle = _parseMissionFolderTitle(prompt);
    if (folderTitle == null) {
      return;
    }
    final datas = args['datas'];
    if (datas is! List) {
      return;
    }
    for (final item in datas) {
      if (item is Map<String, Object?>) {
        final current = item['folder_title'] ?? item['folderTitle'];
        if (current == null || current.toString().trim().isEmpty) {
          item['folder_title'] = folderTitle;
        }
      } else if (item is Map) {
        final current = item['folder_title'] ?? item['folderTitle'];
        if (current == null || current.toString().trim().isEmpty) {
          item['folder_title'] = folderTitle;
        }
      }
    }
  }

  String? _parseMissionFolderTitle(String prompt) {
    final patterns = <RegExp>[
      RegExp(r'在\s*(?:清单|列表)\s*(.+?)\s*(?:下|里|中)\s*(?:创建|新建|添加|安排)?\s*任务'),
      RegExp(r'在\s*(.+?)\s*(?:清单|列表)\s*(?:下|里|中)\s*(?:创建|新建|添加|安排)?\s*任务'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(prompt);
      final title = match?.group(1)?.trim();
      if (title != null && title.isNotEmpty) {
        return title.replaceAll(RegExp(r'[，,。；;：:]+$'), '').trim();
      }
    }
    return null;
  }

  void _applyLocalMissionTimeRange(
    String prompt,
    Map<String, Object?> args,
  ) {
    final range = _parseLocalMissionTimeRange(prompt);
    if (range == null) {
      return;
    }
    final datas = args['datas'];
    if (datas is! List) {
      return;
    }
    for (final item in datas) {
      if (item is Map<String, Object?>) {
        item['time_mode'] = 1;
        item['start_time'] = range.start.toIso8601String();
        item['end_time'] = range.end.toIso8601String();
      } else if (item is Map) {
        item['time_mode'] = 1;
        item['start_time'] = range.start.toIso8601String();
        item['end_time'] = range.end.toIso8601String();
      }
    }
  }

  _ParsedTimeRange? _parseLocalMissionTimeRange(String prompt) {
    final rangeMatch = RegExp(
      r'(今天|明天|后天)?\s*(上午|下午|晚上|中午|凌晨)?\s*(\d{1,2})\s*(?:点|时|:|：)\s*(?:(\d{1,2})\s*分?)?\s*(?:到|至|\-|—|~)\s*(上午|下午|晚上|中午|凌晨)?\s*(\d{1,2})\s*(?:点|时|:|：)\s*(?:(\d{1,2})\s*分?)?',
    ).firstMatch(prompt);
    if (rangeMatch != null) {
      final day = _parseRelativeDay(rangeMatch.group(1));
      final startPeriod = rangeMatch.group(2);
      final endPeriod = rangeMatch.group(5) ?? startPeriod;
      final startHour = _applyChinesePeriod(
        int.parse(rangeMatch.group(3)!),
        startPeriod,
      );
      final startMinute = int.tryParse(rangeMatch.group(4) ?? '') ?? 0;
      final endHour = _applyChinesePeriod(
        int.parse(rangeMatch.group(6)!),
        endPeriod,
      );
      final endMinute = int.tryParse(rangeMatch.group(7) ?? '') ?? 0;

      final start =
          DateTime(day.year, day.month, day.day, startHour, startMinute);
      var end = DateTime(day.year, day.month, day.day, endHour, endMinute);
      if (!end.isAfter(start)) {
        // 用户写“晚上 11 点到 1 点”时，结束时间应落在次日。
        end = end.add(const Duration(days: 1));
      }
      return _ParsedTimeRange(start, end);
    }

    final englishRangeMatch = RegExp(
      r'\b(today|tomorrow|day\s+after\s+tomorrow)?\s*(?:(?:this|next)\s+)?(morning|afternoon|evening|night|noon)?\s*(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\s*(?:to|until|through|\-|—|~)\s*(?:(?:this|next)\s+)?(morning|afternoon|evening|night|noon)?\s*(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (englishRangeMatch != null) {
      final day = _parseEnglishRelativeDay(englishRangeMatch.group(1));
      final startPeriod = englishRangeMatch.group(2);
      final startMeridiem = englishRangeMatch.group(5);
      final endPeriod = englishRangeMatch.group(6) ?? startPeriod;
      final endMeridiem = englishRangeMatch.group(9) ?? startMeridiem;
      final startHour = _applyEnglishPeriod(
        int.parse(englishRangeMatch.group(3)!),
        startPeriod,
        startMeridiem,
      );
      final startMinute = int.tryParse(englishRangeMatch.group(4) ?? '') ?? 0;
      final endHour = _applyEnglishPeriod(
        int.parse(englishRangeMatch.group(7)!),
        endPeriod,
        endMeridiem,
      );
      final endMinute = int.tryParse(englishRangeMatch.group(8) ?? '') ?? 0;
      final start =
          DateTime(day.year, day.month, day.day, startHour, startMinute);
      var end = DateTime(day.year, day.month, day.day, endHour, endMinute);
      if (!end.isAfter(start)) {
        end = end.add(const Duration(days: 1));
      }
      return _ParsedTimeRange(start, end);
    }

    final pointMatch = RegExp(
      r'(今天|明天|后天)?\s*(上午|下午|晚上|中午|凌晨)?\s*(\d{1,2})\s*(?:点|时|:|：)\s*(?:(\d{1,2})\s*分?)?',
    ).firstMatch(prompt);
    if (pointMatch == null) {
      return null;
    }

    final day = _parseRelativeDay(pointMatch.group(1));
    final startHour = _applyChinesePeriod(
      int.parse(pointMatch.group(3)!),
      pointMatch.group(2),
    );
    final startMinute = int.tryParse(pointMatch.group(4) ?? '') ?? 0;
    final start =
        DateTime(day.year, day.month, day.day, startHour, startMinute);
    return _ParsedTimeRange(start, start.add(const Duration(hours: 1)));
  }

  DateTime _parseRelativeDay(String? dayText) {
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    if (dayText == '明天') {
      day = day.add(const Duration(days: 1));
    } else if (dayText == '后天') {
      day = day.add(const Duration(days: 2));
    }
    return day;
  }

  DateTime _parseEnglishRelativeDay(String? dayText) {
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    final normalized = dayText?.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized == 'tomorrow') {
      day = day.add(const Duration(days: 1));
    } else if (normalized == 'day after tomorrow') {
      day = day.add(const Duration(days: 2));
    }
    return day;
  }

  int _applyChinesePeriod(int hour, String? period) {
    if (period == '下午' || period == '晚上') {
      return hour < 12 ? hour + 12 : hour;
    }
    if (period == '中午') {
      return hour < 11 ? hour + 12 : hour;
    }
    if (period == '凌晨' && hour == 12) {
      return 0;
    }
    return hour;
  }

  int _applyEnglishPeriod(int hour, String? period, String? meridiem) {
    final normalizedMeridiem = meridiem?.toLowerCase();
    if (normalizedMeridiem == 'pm') {
      return hour < 12 ? hour + 12 : hour;
    }
    if (normalizedMeridiem == 'am') {
      return hour == 12 ? 0 : hour;
    }

    final normalizedPeriod = period?.toLowerCase();
    if (normalizedPeriod == 'afternoon' ||
        normalizedPeriod == 'evening' ||
        normalizedPeriod == 'night') {
      return hour < 12 ? hour + 12 : hour;
    }
    if (normalizedPeriod == 'noon') {
      return hour < 11 ? hour + 12 : hour;
    }
    return hour;
  }

  Future<Map<String, Object?>> _buildCreateFolderToolArgs(
    String prompt, {
    required Map<String, Object?> modelEntry,
  }) async {
    final rawJson = await _requestChat(
      messages: <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
你是 TimeHello 的清单/文件夹/标签创建参数解析器。只输出 JSON，不要解释，不要使用 Markdown。
把用户自然语言转换成 timehello.create_folders 的参数：
{
  "datas": [
    {
      "title": "清单标题",
      "tag": 1,
      "parent_folder_title": "父文件夹标题，可选",
      "colorName": "颜色名称，可选",
      "folderStatus": 0
    }
  ]
}
规则：
1. 只解析“创建清单/新建清单/添加清单/创建文件夹/新建文件夹/创建标签”的内容。
2. “创建清单/新建清单/添加清单/列表/list/listing”必须使用 tag=1，这是可承载任务的普通清单。
3. 只有用户明确说“文件夹/目录/容器/分组容器/folder/directory/container”时才使用 tag=3。
4. 标签使用 tag=2；筛选器使用 tag=4；目标使用 tag=5。
5. 用户没说明时默认 tag=1，不要默认 tag=3。
6. 如果用户说“在文件夹 X 下创建清单 Y / 在 X 文件夹下新建清单 Y”，title 必须是 Y，tag=1，并输出 parent_folder_title=X。
7. parent_folder_title 只表示 tag=3 文件夹容器，不要把它当作新清单标题。
8. 如果用户说“红色/橙色/黄色/绿色/蓝色/紫色/粉色/灰色”等颜色，输出 colorName，不要自行编造 color 整数。
9. 遇到“创建任务/添加任务/安排任务/提醒我/帮我记”的片段必须忽略，不要把任务标题当成清单。
10. 标题必须简短，不能为空。
11. 只返回一个 JSON object。
''',
        },
        <String, String>{'role': 'user', 'content': prompt},
      ],
      modelEntry: modelEntry,
    );
    final decoded = jsonDecode(_extractJsonObject(rawJson));
    if (decoded is! Map) {
      throw StateError('AI did not return a JSON object.');
    }
    return decoded.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
  }

  Future<Map<String, Object?>> _buildDeleteMissionToolArgs(
    String prompt, {
    required Map<String, Object?> modelEntry,
  }) async {
    final rawJson = await _requestChat(
      messages: <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
你是 TimeHello 的任务删除参数解析器。只输出 JSON，不要解释，不要使用 Markdown。
把用户自然语言转换成 timehello.batch_delete_missions 的参数：
{
  "objectIds": ["已知任务 ID，可选"],
  "titles": ["精确任务标题，可选"]
}
规则：
1. 如果用户提供任务 ID，放入 objectIds。
2. 如果用户只提供任务名称，放入 titles，必须是精确标题，不要用模糊词扩写。
3. 用户要求删除多个任务时，把每个明确标题放入 titles；不要编造 ID。
4. 不要输出 folder_id、tag、dateStatus 这类宽泛过滤条件，避免误删。
5. 只返回一个 JSON object。
''',
        },
        <String, String>{'role': 'user', 'content': prompt},
      ],
      modelEntry: modelEntry,
    );
    final decoded = jsonDecode(_extractJsonObject(rawJson));
    if (decoded is! Map) {
      throw StateError('AI did not return a JSON object.');
    }
    return decoded.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
  }

  Future<Map<String, Object?>> _buildDeleteFolderToolArgs(
    String prompt, {
    required Map<String, Object?> modelEntry,
  }) async {
    final localTitles = _parseDeleteFolderTitles(prompt);
    if (localTitles.isNotEmpty) {
      return <String, Object?>{'titles': localTitles};
    }

    final rawJson = await _requestChat(
      messages: <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
你是 TimeHello 的清单/文件夹/标签删除参数解析器。只输出 JSON，不要解释，不要使用 Markdown。
把用户自然语言转换成 timehello.batch_delete_folders 的参数：
{
  "titles": ["精确清单/文件夹/标签标题，可选"],
  "objectIds": ["已知 FolderModel ID，可选"]
}
规则：
1. 只解析“删除清单/删掉清单/移除清单/删除文件夹/删除标签”等 FolderModel 删除意图。
2. 如果用户提供 ID，放入 objectIds。
3. 如果用户只提供名称，放入 titles，必须是精确标题，例如“删除清单 阅读计划”输出 {"titles":["阅读计划"]}。
4. 不要输出任务字段，不要调用任务删除语义。
5. 只返回一个 JSON object。
''',
        },
        <String, String>{'role': 'user', 'content': prompt},
      ],
      modelEntry: modelEntry,
    );
    final decoded = jsonDecode(_extractJsonObject(rawJson));
    if (decoded is! Map) {
      throw StateError('AI did not return a JSON object.');
    }
    return decoded.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
  }

  List<String> _parseDeleteFolderTitles(String prompt) {
    var text = prompt.trim();
    if (text.isEmpty) {
      return const <String>[];
    }
    text = text
        .replaceAll(RegExp(r'^(请|帮我|麻烦|帮忙)\s*'), '')
        .replaceAll(RegExp(r'^(批量)?(删除|删掉|移除)\s*(这些|以下)?\s*'), '')
        .replaceAll(RegExp(r'^(清单|文件夹|标签)\s*'), '')
        .replaceAll(RegExp(r'^(：|:|，|,|、)+'), '')
        .trim();
    if (text.isEmpty || text.contains('任务')) {
      return const <String>[];
    }
    final parts = text
        .split(RegExp(r'[、,，;；\n]+'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .where((item) => item != '清单' && item != '文件夹' && item != '标签')
        .toSet()
        .toList(growable: false);
    return parts;
  }

  String _extractJsonObject(String text) {
    final trimmed = text.trim();
    final fenceMatch = RegExp(
      r'```(?:json)?\s*([\s\S]*?)\s*```',
      caseSensitive: false,
    ).firstMatch(trimmed);
    final candidate = fenceMatch?.group(1)?.trim() ?? trimmed;
    final start = candidate.indexOf('{');
    final end = candidate.lastIndexOf('}');
    if (start < 0 || end < start) {
      throw StateError('AI did not return JSON.');
    }
    return candidate.substring(start, end + 1);
  }

  Future<String> _requestChat({
    required List<Map<String, String>> messages,
    required Map<String, Object?> modelEntry,
  }) async {
    final buffer = StringBuffer();
    await for (final chunk in _requestChatStream(
      messages: messages,
      modelEntry: modelEntry,
    )) {
      buffer.write(chunk);
    }
    final text = buffer.toString().trim();
    if (text.isEmpty) {
      throw StateError('AI returned empty content.');
    }
    return text;
  }

  Stream<String> _requestChatStream({
    required List<Map<String, String>> messages,
    required Map<String, Object?> modelEntry,
  }) async* {
    await AppAiBailianConfigManager.getInstance().resolveConfig();
    final resolvedModelEntry = _refreshBailianModelEntry(modelEntry);
    final apiKey = (resolvedModelEntry['apiKey'] ?? '').toString().trim();
    final baseUrl = (resolvedModelEntry['baseUrl'] ?? '').toString().trim();
    final model = (resolvedModelEntry['model'] ?? '').toString().trim();
    if (apiKey.isEmpty) {
      throw StateError('AI API key is empty.');
    }
    if (baseUrl.isEmpty || model.isEmpty) {
      throw StateError('AI model config is incomplete.');
    }

    final runtimeMessages = _withRuntimeSystemPrompt(messages);
    final request = http.Request(
      'POST',
      Uri.parse('$baseUrl/chat/completions'),
    )
      ..headers.addAll(<String, String>{
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
      })
      ..body = jsonEncode(<String, Object?>{
        'model': model,
        'messages': runtimeMessages,
        'temperature': 0.7,
        'stream': true,
      });

    developer.log(
      'request: model=$model messageCount=${runtimeMessages.length}',
      name: 'TimeHelloAIPage',
    );
    final response = await request.send().timeout(const Duration(seconds: 90));
    developer.log(
      'response: status=${response.statusCode}',
      name: 'TimeHelloAIPage',
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.stream.bytesToString();
      throw StateError('AI HTTP ${response.statusCode}: $body');
    }

    final eventDataLines = <String>[];
    var hasText = false;
    await for (final rawLine in response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      final line = rawLine.trimRight();
      if (line.isEmpty) {
        final chunk = _parseOpenAiStreamEvent(eventDataLines);
        if (chunk != null && chunk.isNotEmpty) {
          hasText = true;
          yield chunk;
        }
        continue;
      }
      if (line.startsWith(':')) {
        continue;
      }
      if (line.startsWith('data:')) {
        eventDataLines.add(line.substring(5).trimLeft());
      }
    }

    final tailChunk = _parseOpenAiStreamEvent(eventDataLines);
    if (tailChunk != null && tailChunk.isNotEmpty) {
      hasText = true;
      yield tailChunk;
    }
    if (!hasText) {
      throw StateError('AI returned empty streamed content.');
    }
  }

  List<Map<String, String>> _withRuntimeSystemPrompt(
    List<Map<String, String>> messages,
  ) {
    final runtimePrompt =
        AIInterfaceManager.getInstance().getRuntimeSystemPrompt().trim();
    final guardedMessages = _trimChatHistory(messages);
    return <Map<String, String>>[
      <String, String>{
        'role': 'system',
        'content': '最高优先级运行时规则：\n$runtimePrompt',
      },
      ...guardedMessages,
      <String, String>{
        'role': 'system',
        'content':
            '最后提醒：上面的 TimeHello 宿主当前时间是最高优先级事实。不得使用 2023-10-05 或任何示例日期；回复用户时不要展示内部参数和时间戳。',
      },
    ];
  }

  List<Map<String, String>> _trimChatHistory(
    List<Map<String, String>> messages,
  ) {
    const maxMessages = 16;
    const maxChars = 18000;
    final selected = <Map<String, String>>[];
    var totalChars = 0;
    for (final message in messages.reversed) {
      final content = message['content'] ?? '';
      final nextTotal = totalChars + content.length;
      if (selected.length >= maxMessages || nextTotal > maxChars) {
        break;
      }
      selected.add(message);
      totalChars = nextTotal;
    }
    return selected.reversed.toList(growable: false);
  }

  String? _parseOpenAiStreamEvent(List<String> eventDataLines) {
    if (eventDataLines.isEmpty) {
      return null;
    }
    final payload = eventDataLines.join('\n').trim();
    eventDataLines.clear();
    if (payload.isEmpty || payload == '[DONE]') {
      return null;
    }

    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Invalid AI stream response.');
    }
    if (decoded['error'] != null) {
      throw StateError('AI stream error: ${decoded['error']}');
    }
    final choices = decoded['choices'];
    if (choices is! List || choices.isEmpty) {
      return null;
    }
    final first = choices.first;
    if (first is! Map<String, dynamic>) {
      return null;
    }
    final delta = first['delta'];
    if (delta is Map<String, dynamic>) {
      final text = _extractTextContent(delta['content']);
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    final message = first['message'];
    if (message is Map<String, dynamic>) {
      final text = _extractTextContent(message['content']);
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  Map<String, Object?> _resolveModelFromStreamData(Object? rawData) {
    String? requested;
    if (rawData is Map) {
      final completionOptions = rawData['completionOptions'];
      if (completionOptions is Map) {
        final value = completionOptions['model'];
        if (value is String && value.trim().isNotEmpty) {
          requested = value.trim();
        }
      }
      final value = rawData['model'];
      if (requested == null && value is String && value.trim().isNotEmpty) {
        requested = value.trim();
      }
    }

    if (requested != null) {
      for (final entry in Params.appAiBailianModels) {
        if (entry['model'] == requested) {
          return entry;
        }
      }
    }
    return Params.appAiBailianModels.first;
  }

  /// 功能：资源位解析后按模型 ID 重新获取最新模型配置。
  /// 说明：AppAIPlugin 可能先拿到旧配置再发请求，这里用运行时 Params 兜底刷新 apiKey/baseUrl。
  Map<String, Object?> _refreshBailianModelEntry(Map<String, Object?> entry) {
    final model = entry['model']?.toString().trim();
    if (model != null && model.isNotEmpty) {
      for (final runtimeEntry in Params.appAiBailianModels) {
        if (runtimeEntry['model'] == model) {
          return runtimeEntry;
        }
      }
    }
    return Params.appAiBailianModels.isNotEmpty
        ? Params.appAiBailianModels.first
        : entry;
  }

  List<Map<String, String>> _extractOpenAiMessages(Object? rawData) {
    if (rawData is! Map) {
      return <Map<String, String>>[];
    }
    final rawMessages = rawData['messages'];
    if (rawMessages is! List) {
      return <Map<String, String>>[];
    }

    final messages = <Map<String, String>>[];
    for (final item in rawMessages) {
      if (item is! Map) {
        continue;
      }
      final role = (item['role'] ?? '').toString().trim();
      if (role.isEmpty) {
        continue;
      }
      final text = _extractTextContent(item['content']);
      if (text == null || text.trim().isEmpty) {
        continue;
      }
      messages.add(<String, String>{'role': role, 'content': text.trim()});
    }
    return messages;
  }

  String? _extractTextContent(Object? rawContent) {
    if (rawContent is String) {
      return rawContent;
    }
    if (rawContent is Map && rawContent['text'] is String) {
      return rawContent['text'] as String;
    }
    if (rawContent is List) {
      final buffer = StringBuffer();
      for (final segment in rawContent) {
        if (segment is String) {
          if (buffer.isNotEmpty) {
            buffer.writeln();
          }
          buffer.write(segment);
          continue;
        }
        if (segment is Map && segment['text'] is String) {
          final text = (segment['text'] as String).trim();
          if (text.isEmpty) {
            continue;
          }
          if (buffer.isNotEmpty) {
            buffer.writeln();
          }
          buffer.write(text);
        }
      }
      return buffer.isEmpty ? null : buffer.toString();
    }
    return null;
  }

  bool get _isAiVipUser {
    final vipProducts =
        LoginManager.getInstance().getUserBean().vipProductList ?? [];
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final item in vipProducts) {
      if (item is! Map) {
        continue;
      }
      final serviceName = item['serviceName']?.toString() ?? '';
      final expire = item['expiredTimestamp'];
      final expireMillis = expire is num ? expire.toInt() : 0;
      final isKnownVipProduct = serviceName ==
              SubscriptionAndPriceManager.mangaHelloVip ||
          serviceName == SubscriptionAndPriceManager.mangaHelloVipLifetime ||
          serviceName.contains('subscriptionAnnual') ||
          serviceName.contains('subscriptionhMonthly');
      if (isKnownVipProduct && (expireMillis == 0 || expireMillis > now)) {
        return true;
      }
    }
    return false;
  }

  bool get _shouldShowAiUsageOverlay {
    return _aiUsageLoaded &&
        !_isAiStreaming &&
        !_isAiVipUser &&
        _aiUsageRemaining <= 0;
  }

  Future<void> _loadAiUsageGate() async {
    final model =
        await MongoApisManager.getInstance().queryOrCreateAIUsageEntitlement(
      defaultQuota: _freeAiUsageLimit,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _aiUsageUsed = model?.usedQuota ?? 0;
      _aiUsageTotal = model?.totalQuota ?? _freeAiUsageLimit;
      _aiUsageRemaining = model?.remainingQuota ?? _freeAiUsageLimit;
      _aiUsageLoaded = true;
    });
  }

  Future<bool> _consumeAiUsageIfAllowed() async {
    final result =
        await MongoApisManager.getInstance().consumeAIUsageEntitlement(
      defaultQuota: _freeAiUsageLimit,
      isVip: _isAiVipUser,
    );
    if (mounted) {
      setState(() {
        _aiUsageUsed = result.usedQuota;
        _aiUsageTotal =
            result.totalQuota < 0 ? _aiUsageTotal : result.totalQuota;
        _aiUsageRemaining = result.remainingQuota < 0
            ? _aiUsageRemaining
            : result.remainingQuota;
        _aiUsageLoaded = true;
      });
    }
    return result.allowed;
  }

  void _openInviteFriendsPage() {
    final inviteLang = _getInviteWebLang(context);
    final inviteUrl = Utility.getTokenUrl(
      url: '${Urls.mgmHomeUrl}?qd=timehello_app&cy=mgm&lang=$inviteLang',
    );
    Utility.openDesktopWebviewPanel(
      context,
      url: inviteUrl,
      title: _aiText(zh: '邀请好友', en: 'Invite Friends'),
      width: 438,
    );
  }

  Future<void> _redeemAiUsageByMoney() async {
    final currentMoney = MoneyManager.getInstance().getLocalMoney();
    if (currentMoney < _aiUsageRedeemCost) {
      Utility.showToastMsg(msg: getI18NKey().money_not_enough_toast);
      return;
    }
    await MoneyManager.getInstance().requestUpdateLocalMoney(
      context: context,
      localMoney: -_aiUsageRedeemCost,
    );
    final afterMoney = MoneyManager.getInstance().getLocalMoney();
    if (afterMoney > currentMoney - _aiUsageRedeemCost) {
      return;
    }
    final model = await MongoApisManager.getInstance().grantAIUsageEntitlement(
      quota: _aiUsageRedeemQuota,
      source: 'local_money_redeem',
    );
    if (mounted) {
      setState(() {
        _aiUsageUsed = model?.usedQuota ?? _aiUsageUsed;
        _aiUsageTotal = model?.totalQuota ?? _aiUsageTotal;
        _aiUsageRemaining = model?.remainingQuota ?? _aiUsageRemaining;
        _aiUsageLoaded = true;
      });
    }
  }

  void _openAiSubscriptionPage() {
    LoginManager.getInstance().openSubscriptionDialog(context);
  }

  String _getInviteWebLang(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context);
    final languageCode = locale?.languageCode.toLowerCase();
    if (languageCode == 'zh') {
      final countryCode = locale?.countryCode?.toUpperCase();
      final scriptCode = locale?.scriptCode?.toLowerCase();
      if (countryCode == 'TW' || countryCode == 'HK' || scriptCode == 'hant') {
        return 'zh-Hant';
      }
      return 'zh-Hans';
    }
    return languageCode ?? 'en';
  }

  String _aiUsageLimitMessage() {
    return _aiText(
      zh: 'AI 可用次数已用完。你可以邀请好友获得额外次数，用积分兑换提问次数，或升级为年度会员后继续使用 AI。',
      en: 'Your AI uses have run out. Invite friends, redeem more uses with points, or upgrade to the annual membership to continue using AI.',
    );
  }

  Widget _buildAiUsageGateOverlay(BuildContext context) {
    final isChinese =
        (Localizations.maybeLocaleOf(context)?.languageCode ?? 'zh') == 'zh';
    final usedText = isChinese
        ? '已使用 $_aiUsageUsed / $_aiUsageTotal 次'
        : 'Used $_aiUsageUsed / $_aiUsageTotal';
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.66),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _aiText(zh: 'AI 免费次数已用完', en: 'Free AI uses reached'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  usedText,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _aiUsageLimitMessage(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _openInviteFriendsPage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(
                          _aiText(zh: '邀请好友赚积分', en: 'Invite for points'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _openAiSubscriptionPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(
                          _aiText(zh: '开通年度会员', en: 'Upgrade yearly'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _redeemAiUsageByMoney,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      _aiText(
                        zh: '用 $_aiUsageRedeemCost 积分兑换 +$_aiUsageRedeemQuota 次',
                        en: 'Redeem +$_aiUsageRedeemQuota uses for $_aiUsageRedeemCost points',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 功能：生成传给 AppAIPlugin Web GUI 的语言配置，让内联录音条跟随外层 App 语言。
  /// 说明：文案源头仍然来自 Flutter 的 ARB 资源，Web 侧只接收最终文案，不维护第二套业务翻译。
  Map<String, String> _buildAppAiLocalizedStrings(BuildContext context) {
    final i18n = getI18NKey(context);
    return <String, String>{
      'cancel': i18n.cancel,
      'voiceRecording': i18n.app_ai_voice_recording,
      'voiceTranscribing': i18n.app_ai_voice_transcribing,
      'voiceStopHint': i18n.app_ai_voice_stop_hint,
      'voiceTranscribingHint': i18n.app_ai_voice_transcribing_hint,
      'voiceCancelRecording': i18n.app_ai_voice_cancel_recording,
      'voiceStopRecording': i18n.app_ai_voice_stop_recording,
      'voiceTranscribingAction': i18n.app_ai_voice_transcribing_action,
      'voiceEnd': i18n.finished,
    };
  }

  /// 功能：把 Flutter Locale 转成 Web 组件可理解的 language tag。
  String _buildAppAiLanguageCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final parts = <String>[locale.languageCode];
    if ((locale.scriptCode ?? '').isNotEmpty) {
      parts.add(locale.scriptCode!);
    }
    if ((locale.countryCode ?? '').isNotEmpty) {
      parts.add(locale.countryCode!);
    }
    return parts.join('-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ContinueGuiWebView(
              source: ContinueGuiSource.bundleDirectory(
                directory: _resolveGuiDistPath(),
              ),
              shellPort: _shellPort,
              languageCode: _buildAppAiLanguageCode(context),
              localizedStrings: _buildAppAiLocalizedStrings(context),
            ),
            if (_shouldShowAiUsageOverlay) _buildAiUsageGateOverlay(context),
          ],
        ),
      ),
    );
  }
}
