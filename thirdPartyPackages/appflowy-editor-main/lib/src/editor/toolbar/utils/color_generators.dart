import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

/// Default text color options when no option is provided
/// - support
///   - desktop
///   - web
///   - mobile
///
List<ColorOption> generateTextColorOptions() {
  return [
    ColorOption(
      colorHex: Colors.grey.toHex(),
      name: i18nInstanceLocal.fontColorGray,
    ),
    ColorOption(
      colorHex: Colors.brown.toHex(),
      name: i18nInstanceLocal.fontColorBrown,
    ),
    ColorOption(
      colorHex: Colors.yellow.toHex(),
      name: i18nInstanceLocal.fontColorYellow,
    ),
    ColorOption(
      colorHex: Colors.green.toHex(),
      name: i18nInstanceLocal.fontColorGreen,
    ),
    ColorOption(
      colorHex: Colors.blue.toHex(),
      name: i18nInstanceLocal.fontColorBlue,
    ),
    ColorOption(
      colorHex: Colors.purple.toHex(),
      name: i18nInstanceLocal.fontColorPurple,
    ),
    ColorOption(
      colorHex: Colors.pink.toHex(),
      name: i18nInstanceLocal.fontColorPink,
    ),
    ColorOption(
      colorHex: Colors.red.toHex(),
      name: i18nInstanceLocal.fontColorRed,
    ),
  ];
}

/// Default background color options when no option is provided
/// - support
///   - desktop
///   - web
///   - mobile
///
List<ColorOption> generateHighlightColorOptions() {
  return [
    ColorOption(
      colorHex: Colors.grey.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorGray,
    ),
    ColorOption(
      colorHex: Colors.brown.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorBrown,
    ),
    ColorOption(
      colorHex: Colors.yellow.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorYellow,
    ),
    ColorOption(
      colorHex: Colors.green.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorGreen,
    ),
    ColorOption(
      colorHex: Colors.blue.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorBlue,
    ),
    ColorOption(
      colorHex: Colors.purple.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorPurple,
    ),
    ColorOption(
      colorHex: Colors.pink.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorPink,
    ),
    ColorOption(
      colorHex: Colors.red.withOpacity(0.3).toHex(),
      name: i18nInstanceLocal.backgroundColorRed,
    ),
  ];
}
