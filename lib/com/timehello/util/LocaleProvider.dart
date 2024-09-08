import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  Locale get locale {
    return _locale ?? const Locale('en');
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('zh', 'CN'),
    const Locale('zh', 'HK'),
    const Locale('zh', 'TW'),
    const Locale('fr'),
    const Locale('de'),
    const Locale('ko'),
    const Locale('ja'),
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return '🇺🇸';
      case 'zh':
        return '🇨🇳';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'ko':
        return '🇰🇷';
      case 'ja':
        return '🇯🇵';
      default:
        return '🏳️';
    }
  }
}