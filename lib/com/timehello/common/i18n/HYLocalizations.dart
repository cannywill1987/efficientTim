import 'package:flutter/cupertino.dart';

class HYLocalizations {
  final Locale locale;

  HYLocalizations(this.locale);
  static HYLocalizations of(BuildContext context) {
    return Localizations.of(context, HYLocalizations);
  }
}