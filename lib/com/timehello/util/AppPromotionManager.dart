import 'dart:convert';
import 'dart:io';

import 'package:time_hello/com/timehello/beans/ResourceDeliveryInfoBean.dart';
import 'package:time_hello/com/timehello/config/Params.dart';

class AppPromotionManager {
  static AppPromotionManager? _instance;

  static AppPromotionManager getInstance() {
    _instance ??= AppPromotionManager();
    return _instance!;
  }

  List<AppPromotionModel> getApps() {
    final deliveryList =
        ResourceInfo.appPromotionListResourceLocationInfoBean?.deliveryList ??
            <ResourceDeliveryInfoBean>[];
    final apps = deliveryList
        .map(AppPromotionModel.fromDelivery)
        .where((item) =>
            item.enabled && item.isVisibleForAppScene(Params.appScene))
        .toList()
      ..sort((a, b) => a.sort.compareTo(b.sort));
    return apps.isNotEmpty ? apps : [_fallbackEfficientTimeApp()];
  }

  AppPromotionModel _fallbackEfficientTimeApp() {
    return AppPromotionModel(
      appCode: 'efficientTime',
      appScene: 'efficientTime',
      title: '日常计划',
      subtitle: '高效管理你的任务与时间',
      category: '效率',
      description:
          '日常计划是一款帮助你提高效率的任务管理应用。通过清晰的计划和智能提醒，让你轻松管理工作、学习和生活中的各项任务，养成良好的习惯，达成目标。',
      iconUrl: '',
      localIconAsset: 'assets/img/ic_launcher.png',
      bannerUrl: '',
      rating: '4.8',
      fileSize: '28.6 MB',
      sort: 0,
      enabled: true,
      visibleAppScenes: const [],
      excludeAppScenes: const [],
      features: const ['任务清单', '日程管理', '习惯追踪', '数据统计'],
      platforms: const [
        AppPromotionPlatform(
          code: 'android',
          title: 'Android',
          subtitle: '下载 APK',
          url: 'https://www.timerbell.com',
        ),
        AppPromotionPlatform(
          code: 'ios',
          title: 'iOS',
          subtitle: '在 App Store 获取',
          url: 'https://apps.apple.com/app/id1663610373',
        ),
        AppPromotionPlatform(
          code: 'macos',
          title: 'macOS',
          subtitle: '下载 DMG',
          url: 'https://apps.apple.com/app/id1663772116',
        ),
        AppPromotionPlatform(
          code: 'windows',
          title: 'Windows',
          subtitle: '下载 EXE',
          url: 'https://www.timerbell.com',
        ),
      ],
    );
  }
}

class AppPromotionModel {
  final String appCode;
  final String appScene;
  final String title;
  final String subtitle;
  final String category;
  final String description;
  final String iconUrl;
  final String localIconAsset;
  final String bannerUrl;
  final String rating;
  final String fileSize;
  final int sort;
  final bool enabled;
  final List<String> visibleAppScenes;
  final List<String> excludeAppScenes;
  final List<String> features;
  final List<AppPromotionPlatform> platforms;

  const AppPromotionModel({
    required this.appCode,
    required this.appScene,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.iconUrl,
    required this.localIconAsset,
    required this.bannerUrl,
    required this.rating,
    required this.fileSize,
    required this.sort,
    required this.enabled,
    required this.visibleAppScenes,
    required this.excludeAppScenes,
    required this.features,
    required this.platforms,
  });

  factory AppPromotionModel.fromDelivery(ResourceDeliveryInfoBean bean) {
    final params = bean.extendParamsMap ?? <dynamic, dynamic>{};
    final platforms = _parsePlatforms(params['platforms']);
    final defaultUrl = _string(bean.resourceRedirectUrl);
    return AppPromotionModel(
      appCode: _firstNotEmpty(
          [_string(params['appCode']), _string(bean.deliveryName)]),
      appScene: _firstNotEmpty(
          [_string(params['appScene']), _string(bean.deliveryName)]),
      title: _firstNotEmpty(
          [_string(params['title']), _string(bean.resourceTitle)]),
      subtitle: _firstNotEmpty(
          [_string(params['subtitle']), _string(bean.resourceContent)]),
      category:
          _firstNotEmpty([_string(params['category']), _string(params['tag'])]),
      description: _firstNotEmpty(
          [_string(params['description']), _string(bean.resourceContent)]),
      iconUrl: _string(bean.resourceIconUrl),
      localIconAsset: _firstNotEmpty(
          [_string(params['localIconAsset']), 'assets/img/ic_launcher.png']),
      bannerUrl: _firstNotEmpty(
          [_string(params['bannerUrl']), _string(bean.resourcePictureUrl)]),
      rating: _string(params['rating']),
      fileSize: _string(params['fileSize']),
      sort: int.tryParse(_string(params['sort'])) ?? 999,
      enabled: _bool(params['enabled'], defaultValue: true),
      visibleAppScenes: _stringList(params['visibleAppScenes']),
      excludeAppScenes: _stringList(params['excludeAppScenes']),
      features: _stringList(params['features']),
      platforms:
          platforms.isNotEmpty ? platforms : _defaultPlatforms(defaultUrl),
    );
  }

  bool isVisibleForAppScene(String currentAppScene) {
    if (excludeAppScenes.contains(currentAppScene)) return false;
    if (visibleAppScenes.isEmpty) return true;
    return visibleAppScenes.contains(currentAppScene);
  }

  AppPromotionPlatform? getPreferredPlatform() {
    final code = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
            ? 'ios'
            : Platform.isMacOS
                ? 'macos'
                : Platform.isWindows
                    ? 'windows'
                    : '';
    for (final item in platforms) {
      if (item.code == code && item.url.isNotEmpty) return item;
    }
    for (final item in platforms) {
      if (item.url.isNotEmpty) return item;
    }
    return null;
  }
}

class AppPromotionPlatform {
  final String code;
  final String title;
  final String subtitle;
  final String url;
  final bool enabled;

  const AppPromotionPlatform({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.url,
    this.enabled = true,
  });
}

String _string(dynamic value) => value == null ? '' : value.toString().trim();

String _firstNotEmpty(List<String> values) {
  for (final value in values) {
    if (value.trim().isNotEmpty) return value.trim();
  }
  return '';
}

bool _bool(dynamic value, {required bool defaultValue}) {
  if (value is bool) return value;
  final text = _string(value).toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return defaultValue;
}

List<String> _stringList(dynamic value) {
  if (value is List) {
    return value.map(_string).where((item) => item.isNotEmpty).toList();
  }
  final text = _string(value);
  if (text.isEmpty) return <String>[];
  final decoded = _tryDecode(text);
  if (decoded is List) return _stringList(decoded);
  return text
      .split(RegExp(r'[,，|]'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

dynamic _tryDecode(String value) {
  try {
    return jsonDecode(value);
  } catch (_) {
    return null;
  }
}

List<AppPromotionPlatform> _parsePlatforms(dynamic value) {
  if (value is Map) {
    return value.entries
        .map((entry) {
          final code = _string(entry.key);
          final config =
              entry.value is Map ? entry.value as Map : <dynamic, dynamic>{};
          return AppPromotionPlatform(
            code: code,
            title: _firstNotEmpty(
                [_string(config['title']), _platformTitle(code)]),
            subtitle: _firstNotEmpty(
                [_string(config['subtitle']), _platformSubtitle(code)]),
            url: _string(config['url']),
            enabled: _bool(config['enabled'], defaultValue: true),
          );
        })
        .where((item) => item.enabled)
        .toList();
  }
  if (value is List) {
    return value
        .map((item) {
          final config = item is Map ? item : <dynamic, dynamic>{};
          final code = _string(config['code']);
          return AppPromotionPlatform(
            code: code,
            title: _firstNotEmpty(
                [_string(config['title']), _platformTitle(code)]),
            subtitle: _firstNotEmpty(
                [_string(config['subtitle']), _platformSubtitle(code)]),
            url: _string(config['url']),
            enabled: _bool(config['enabled'], defaultValue: true),
          );
        })
        .where((item) => item.enabled)
        .toList();
  }
  return <AppPromotionPlatform>[];
}

List<AppPromotionPlatform> _defaultPlatforms(String url) {
  if (url.isEmpty) return <AppPromotionPlatform>[];
  return <AppPromotionPlatform>[
    AppPromotionPlatform(
      code: 'default',
      title: 'Download',
      subtitle: '',
      url: url,
    ),
  ];
}

String _platformTitle(String code) {
  switch (code) {
    case 'android':
      return 'Android';
    case 'ios':
      return 'iOS';
    case 'macos':
      return 'macOS';
    case 'windows':
      return 'Windows';
    default:
      return code;
  }
}

String _platformSubtitle(String code) {
  switch (code) {
    case 'android':
      return '下载 APK';
    case 'ios':
      return '在 App Store 获取';
    case 'macos':
      return '下载 DMG';
    case 'windows':
      return '下载 EXE';
    default:
      return '';
  }
}
