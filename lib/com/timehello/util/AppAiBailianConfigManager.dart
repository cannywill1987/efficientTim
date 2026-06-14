/// 文件类型：工具类
/// 文件作用：从资源位读取 App AI 使用的阿里云百炼配置，并同步到 Params 运行时配置。
/// 主要职责：复用 GetResourceDeliveryManager 的现有资源位请求封装，解析 llm key / 模型配置，避免把 AI 业务逻辑写进通用资源位 manager。
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';

import '../beans/ResourceDeliveryInfoBean.dart';
import '../beans/ResourceLocationInfoBean.dart';
import '../config/Params.dart';
import 'AiVoiceDebugLog.dart';
import 'GetResourceDeliveryManager.dart';

class AppAiBailianResourceConfig {
  const AppAiBailianResourceConfig({
    required this.apiKey,
    required this.baseUrl,
    required this.model,
    required this.modelName,
    required this.source,
  });

  final String apiKey;
  final String baseUrl;
  final String model;
  final String modelName;
  final String source;

  bool get isValid {
    return apiKey.trim().startsWith('sk-') &&
        baseUrl.trim().isNotEmpty &&
        model.trim().isNotEmpty;
  }
}

class AppAiBailianConfigManager {
  AppAiBailianConfigManager._();

  static final AppAiBailianConfigManager _instance =
      AppAiBailianConfigManager._();

  static AppAiBailianConfigManager getInstance() {
    return _instance;
  }

  static const List<String> _candidateScenes = <String>[
    'timehello_init',
    'llm_key_scene',
  ];

  static const Set<String> _candidateLocationCodes = <String>{
    'app_ai_bailian',
    'app_ai',
    'llm_keys',
    'ai_model_config',
    'ab_setting',
  };

  static const Set<String> _candidateDeliveryNames = <String>{
    'qwen_dashscope_cn_api_key',
    'dashscope_api_key',
    'bailian_api_key',
    'app_ai_bailian',
    'app_ai_model_config',
  };

  static const String _primaryAesPassword = String.fromEnvironment(
    'APP_AI_AES_PASSWORD',
    defaultValue: 'linzhibin2003',
  );
  static const String _legacyAesPassword = 'LZB2003';

  AppAiBailianResourceConfig? _cache;

  /// 功能：解析 SplashPage 已经拉到的初始化资源位，并把有效 AI 配置同步到 Params。
  /// 说明：SplashPage 原本就是通过 GetResourceDeliveryManager 取 timehello_init，这里只消费回调结果，不重新请求。
  Future<AppAiBailianResourceConfig?> applyConfigFromResourceLocations(
    List<ResourceLocationInfoBean> locations, {
    String sourceScene = 'timehello_init',
  }) async {
    final config = await _parseConfigFromLocations(locations, sourceScene);
    if (config == null || !config.isValid) {
      AiVoiceDebugLog.log(
        'config-apply-empty',
        'sourceScene=$sourceScene, locationCount=${locations.length}',
      );
      return null;
    }
    _applyConfig(config);
    return config;
  }

  /// 功能：主动解析当前 App AI 配置。
  /// 说明：优先使用缓存；缓存为空时按资源位 scene 拉取，最后才回落到 Params 的编译期/默认配置。
  Future<AppAiBailianResourceConfig?> resolveConfig({
    BuildContext? context,
    bool forceRefresh = false,
  }) async {
    AiVoiceDebugLog.log(
      'config-resolve-start',
      'forceRefresh=$forceRefresh, hasCache=${_cache?.isValid == true}',
    );
    if (!forceRefresh && _cache?.isValid == true) {
      AiVoiceDebugLog.log(
        'config-resolve-cache',
        'source=${_cache?.source}, model=${_cache?.model}, keyLength=${_cache?.apiKey.length}',
      );
      return _cache;
    }

    for (final scene in _candidateScenes) {
      final locations = await _requestLocationsByScene(
        scene,
        context: context,
        forceRefresh: forceRefresh,
      );
      final config = await applyConfigFromResourceLocations(
        locations,
        sourceScene: scene,
      );
      if (config?.isValid == true) {
        return config;
      }
    }

    final fallback = AppAiBailianResourceConfig(
      apiKey: Params.appAiBailianRuntimeApiKey.trim(),
      baseUrl: Params.appAiBailianRuntimeBaseUrl.trim(),
      model: Params.appAiBailianRuntimeModel.trim(),
      modelName: Params.appAiBailianRuntimeModelName.trim(),
      source: 'params-runtime',
    );
    AiVoiceDebugLog.log(
      'config-resolve-fallback',
      'hasKey=${fallback.apiKey.isNotEmpty}, keyLength=${fallback.apiKey.length}, model=${fallback.model}',
    );
    return fallback.isValid ? fallback : null;
  }

  /// 功能：按项目既有方式请求资源位。
  /// 说明：这里只把 callback 封装成 Future，底层请求、缓存、解析仍然交给 GetResourceDeliveryManager。
  Future<List<ResourceLocationInfoBean>> _requestLocationsByScene(
    String scene, {
    BuildContext? context,
    bool forceRefresh = false,
  }) async {
    final completer = Completer<List<ResourceLocationInfoBean>>();
    GetResourceDeliveryManager.getInstance()?.requestGetResourceDelivery(
      scene,
      context: context,
      isCachableOn: !forceRefresh,
      onResourceComplete: (
        List<ResourceLocationInfoBean> response,
        bool isFromCache,
      ) {
        AiVoiceDebugLog.log(
          'config-resource-complete',
          'scene=$scene, isFromCache=$isFromCache, locationCount=${response.length}',
        );
        if (!completer.isCompleted) {
          completer.complete(response);
        }
      },
      onResourceFail: () {
        AiVoiceDebugLog.log('config-resource-fail', 'scene=$scene');
        if (!completer.isCompleted) {
          completer.complete(<ResourceLocationInfoBean>[]);
        }
      },
      onResourceFailNoCache: () {
        AiVoiceDebugLog.log('config-resource-no-cache', 'scene=$scene');
        if (!completer.isCompleted) {
          completer.complete(<ResourceLocationInfoBean>[]);
        }
      },
    );
    return completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        AiVoiceDebugLog.log('config-resource-timeout', 'scene=$scene');
        return <ResourceLocationInfoBean>[];
      },
    );
  }

  Future<AppAiBailianResourceConfig?> _parseConfigFromLocations(
    List<ResourceLocationInfoBean> locations,
    String sourceScene,
  ) async {
    for (final location in locations) {
      final locationCode = (location.locationCode ?? '').trim();
      if (!_candidateLocationCodes.contains(locationCode)) {
        continue;
      }
      final deliveryList =
          location.deliveryList ?? <ResourceDeliveryInfoBean>[];
      for (final delivery in deliveryList) {
        final deliveryName = (delivery.deliveryName ?? '').trim();
        if (!_candidateDeliveryNames.contains(deliveryName)) {
          continue;
        }
        final config = await _parseConfigFromDelivery(
          delivery,
          source: '$sourceScene/$locationCode/$deliveryName',
        );
        if (config?.isValid == true) {
          return config;
        }
      }
    }
    return null;
  }

  Future<AppAiBailianResourceConfig?> _parseConfigFromDelivery(
    ResourceDeliveryInfoBean delivery, {
    required String source,
  }) async {
    final params = delivery.extendParamsMap ?? <dynamic, dynamic>{};
    final rawApiKey = _readFirstString(
      params,
      const <String>[
        'apiKey',
        'api_key',
        'dashscopeApiKey',
        'dashscope_api_key',
        'bailianApiKey',
        'bailian_api_key',
        'key',
        'value',
      ],
    );
    final apiKey = await _normalizeDashScopeApiKey(
      rawApiKey ??
          delivery.resourceContent ??
          delivery.resourceRedirectUrl ??
          '',
    );
    final baseUrl = _readFirstString(
          params,
          const <String>['baseUrl', 'base_url', 'endpoint'],
        ) ??
        Params.appAiBailianBaseUrl;
    final model = _readFirstString(
          params,
          const <String>['model', 'modelId', 'model_id'],
        ) ??
        Params.appAiBailianDefaultModel;
    final modelName = _readFirstString(
          params,
          const <String>['modelName', 'model_name', 'title'],
        ) ??
        delivery.resourceTitle ??
        '通义千问 Plus';
    final config = AppAiBailianResourceConfig(
      apiKey: apiKey,
      baseUrl: baseUrl.trim(),
      model: model.trim(),
      modelName: modelName.trim(),
      source: source,
    );
    AiVoiceDebugLog.log(
      'config-delivery-parse',
      'source=$source, rawKeyLength=${(rawApiKey ?? '').length}, normalizedKeyLength=${apiKey.length}, hasValidPrefix=${apiKey.startsWith('sk-')}, model=${config.model}',
    );
    _verifyFingerprint(
      apiKey,
      _readFirstString(params, const <String>['fingerprint']),
      source,
    );
    return config.isValid ? config : null;
  }

  void _applyConfig(AppAiBailianResourceConfig config) {
    _cache = config;
    Params.updateAppAiBailianConfig(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
      model: config.model,
      modelName: config.modelName,
    );
    AiVoiceDebugLog.log(
      'config-apply-success',
      'source=${config.source}, model=${config.model}, keyLength=${config.apiKey.length}',
    );
  }

  String? _readFirstString(Map<dynamic, dynamic> params, List<String> keys) {
    for (final key in keys) {
      final value = params[key] ?? params[key.toLowerCase()];
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty && text != 'null') {
        return text;
      }
    }
    return null;
  }

  /// 功能：清洗资源位里的 DashScope Key。
  /// 说明：后台可能把 key 放在 JSON 字符串、Bearer 文本或富文本字段里，这里只抽取真正的 sk- 前缀 token。
  /// 新版工作空间 key 形如 sk-ws-...，会包含点号、下划线和连字符，不能再按旧的纯字母数字规则截断。
  Future<String> _normalizeDashScopeApiKey(String rawValue) async {
    var value = rawValue.trim();
    if (value.isEmpty) {
      return '';
    }
    if (value.startsWith('aesgcm:v1:')) {
      value = await _decryptAesGcmEnvelope(value);
    }
    if (value.startsWith('{') && value.endsWith('}')) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) {
          value = _readFirstString(
                decoded,
                const <String>[
                  'apiKey',
                  'api_key',
                  'dashscopeApiKey',
                  'dashscope_api_key',
                  'bailianApiKey',
                  'bailian_api_key',
                  'key',
                  'value',
                ],
              ) ??
              value;
        }
      } catch (_) {}
    }
    value = value.replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '');
    final compact = value.replaceAll(RegExp(r'\s+'), '');
    final match = RegExp(r'sk-[A-Za-z0-9._-]+').firstMatch(compact);
    return match?.group(0) ?? compact;
  }

  /// 功能：解密资源位 AES-GCM 信封。
  /// 说明：格式与 OmniDisk 的资源位 AI Key 方案一致：aesgcm:v1:salt:nonce:ciphertextWithTag。
  Future<String> _decryptAesGcmEnvelope(String envelope) async {
    Object? lastError;
    for (final password in <String>{
      _primaryAesPassword,
      _legacyAesPassword,
    }) {
      if (password.trim().isEmpty) {
        continue;
      }
      try {
        final result = await _decryptAesGcmEnvelopeWithPassword(
          envelope,
          password,
        );
        AiVoiceDebugLog.log(
          'config-aesgcm-decrypt-success',
          'passwordSource=${password == _primaryAesPassword ? 'primary' : 'legacy'}, plaintextLength=${result.length}',
        );
        return result;
      } catch (error) {
        lastError = error;
        AiVoiceDebugLog.log(
          'config-aesgcm-decrypt-fail',
          'passwordSource=${password == _primaryAesPassword ? 'primary' : 'legacy'}, errorType=${error.runtimeType}',
        );
      }
    }
    throw StateError('AI key AES-GCM 解密失败：${lastError ?? 'unknown'}');
  }

  Future<String> _decryptAesGcmEnvelopeWithPassword(
    String envelope,
    String password,
  ) async {
    final parts = envelope.split(':');
    if (parts.length != 5 || '${parts[0]}:${parts[1]}' != 'aesgcm:v1') {
      throw FormatException('Unsupported AI key envelope.');
    }
    final salt = _decodeBase64Url(parts[2]);
    final nonce = _decodeBase64Url(parts[3]);
    final ciphertextWithTag = _decodeBase64Url(parts[4]);
    if (ciphertextWithTag.length <= 16) {
      throw FormatException('AI key envelope is too short.');
    }
    final ciphertext = ciphertextWithTag.sublist(
      0,
      ciphertextWithTag.length - 16,
    );
    final tag = ciphertextWithTag.sublist(ciphertextWithTag.length - 16);
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 200000,
      bits: 256,
    );
    final key = await pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final plaintext = await AesGcm.with256bits().decrypt(
      SecretBox(ciphertext, nonce: nonce, mac: Mac(tag)),
      secretKey: key,
    );
    return utf8.decode(plaintext).trim();
  }

  Uint8List _decodeBase64Url(String value) {
    final remainder = value.length % 4;
    final padded = remainder == 0
        ? value
        : value.padRight(value.length + 4 - remainder, '=');
    return Uint8List.fromList(base64Url.decode(padded));
  }

  void _verifyFingerprint(
    String apiKey,
    String? expectedFingerprint,
    String source,
  ) {
    final expected = (expectedFingerprint ?? '').trim();
    if (expected.isEmpty || apiKey.isEmpty) {
      return;
    }
    final actual =
        crypto.sha256.convert(utf8.encode(apiKey)).toString().substring(0, 12);
    AiVoiceDebugLog.log(
      'config-fingerprint-check',
      'source=$source, expected=$expected, actual=$actual, matched=${actual == expected}',
    );
    if (actual != expected) {
      throw StateError('AI key fingerprint mismatch.');
    }
  }
}
