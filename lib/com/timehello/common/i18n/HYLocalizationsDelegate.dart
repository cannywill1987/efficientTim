import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'HYLocalizations.dart';

class HYLocalizationsDelegate extends LocalizationsDelegate<HYLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ["en", "zh"].contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<HYLocalizations> old) {
    return false;
  }

  @override
  Future<HYLocalizations> load(Locale locale) {
    return SynchronousFuture(HYLocalizations(locale));
  }

  static HYLocalizationsDelegate delegate = HYLocalizationsDelegate();
}
