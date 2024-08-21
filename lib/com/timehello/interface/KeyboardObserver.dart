import 'package:flutter/cupertino.dart';

abstract class KeyboardObserver {
  void onPressKeyboard(KeyEvent event);
}