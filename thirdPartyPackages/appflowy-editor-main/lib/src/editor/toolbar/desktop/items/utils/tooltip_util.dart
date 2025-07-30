import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';

String shortcutTooltips(
  String? macOSString,
  String? windowsString,
  String? linuxString,
) {
  if (kIsWeb) return '';
  if (Platform.isMacOS && macOSString != null) {
    return '\n$macOSString';
  } else if (Platform.isWindows && windowsString != null) {
    return '\n$windowsString';
  } else if (Platform.isLinux && linuxString != null) {
    return '\n$linuxString';
  }
  return '';
}

String getTooltipText(String id) {
  switch (id) {
    case 'underline':
      return '${i18nInstanceLocal.underline}${shortcutTooltips('⌘ + U', 'CTRL + U', 'CTRL + U')}';
    case 'bold':
      return '${i18nInstanceLocal.bold}${shortcutTooltips('⌘ + B', 'CTRL + B', 'CTRL + B')}';
    case 'italic':
      return '${i18nInstanceLocal.italic}${shortcutTooltips('⌘ + I', 'CTRL + I', 'CTRL + I')}';
    case 'strikethrough':
      return '${i18nInstanceLocal.strikethrough}${shortcutTooltips('⌘ + SHIFT + S', 'CTRL + SHIFT + S', 'CTRL + SHIFT + S')}';
    case 'code':
      return '${i18nInstanceLocal.embedCode}${shortcutTooltips('⌘ + E', 'CTRL + E', 'CTRL + E')}';
    case 'align_left':
      return i18nInstanceLocal.textAlignLeft;
    case 'align_center':
      return i18nInstanceLocal.textAlignCenter;
    case 'align_right':
      return i18nInstanceLocal.textAlignRight;
    case 'text_direction_auto':
      return i18nInstanceLocal.auto;
    case 'text_direction_ltr':
      return i18nInstanceLocal.ltr;
    case 'text_direction_rtl':
      return i18nInstanceLocal.rtl;
    case 'text_direction_rtl':
      return i18nInstanceLocal.rtl;
    case 'ai':
      return i18nInstanceLocal.ai;
    default:
      return '';
  }
}
