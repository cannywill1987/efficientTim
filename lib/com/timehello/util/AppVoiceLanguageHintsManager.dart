/// 文件类型：工具类
/// 文件作用：根据 App 当前语言生成百炼语音识别 language_hints。
/// 主要职责：统一实时转写和录音文件转写的语种提示顺序，避免两条链路识别倾向不一致。
import 'dart:ui';

import '../config/Params.dart';
import 'SharePreferenceUtil.dart';

class AppVoiceLanguageHintsManager {
  AppVoiceLanguageHintsManager._();

  /// 功能：获取百炼语音识别 language_hints。
  /// 说明：优先使用用户在 App 内保存的语言，其次使用 MaterialApp 解析后的 Params.local，最后才使用系统语言兜底。
  static List<String> getDashScopeLanguageHints() {
    final appLanguageCode = _resolveAppLanguageCode();
    final firstHint = _mapAppLanguageToDashScopeHint(appLanguageCode);
    if (firstHint == 'zh') {
      return const <String>['zh', 'en'];
    }
    if (firstHint == null) {
      return const <String>['en', 'zh'];
    }

    // 非中文语言优先识别当前 App 语言，同时保留英文/中文作为混合输入兜底。
    final hints = <String>[firstHint, 'en', 'zh'];
    return hints.toSet().toList(growable: false);
  }

  /// 功能：解析当前 App 语言代码。
  /// 说明：设置页会把用户选择保存到 SharedPreferences；没有用户选择时再使用主入口写入的 Params.local。
  static String _resolveAppLanguageCode() {
    final savedLanguageCode = SharePreferenceUtil.getSyncInstance()
        .getString(key: ShareprefrenceKeys.curLocaleLanguage, defaultVal: '')
        .trim()
        .toLowerCase();
    if (savedLanguageCode.isNotEmpty) {
      return savedLanguageCode;
    }

    final resolvedLocaleCode = Params.local?.languageCode.trim().toLowerCase();
    if (resolvedLocaleCode != null && resolvedLocaleCode.isNotEmpty) {
      return resolvedLocaleCode;
    }

    return PlatformDispatcher.instance.locale.languageCode.trim().toLowerCase();
  }

  /// 功能：把 App 支持的语言映射成百炼 ASR 支持的语言代码。
  /// 说明：当前 App 支持 en/zh/ja/ko/de/fr，百炼 Paraformer 也支持这些提示；未知语言使用英文兜底。
  static String? _mapAppLanguageToDashScopeHint(String languageCode) {
    if (languageCode.startsWith('zh')) {
      return 'zh';
    }
    const supportedHints = <String>{'en', 'ja', 'ko', 'de', 'fr'};
    if (supportedHints.contains(languageCode)) {
      return languageCode;
    }
    return null;
  }
}
