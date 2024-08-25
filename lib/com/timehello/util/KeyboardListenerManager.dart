import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * 全局监听键盘事件
 */
class Keyboardlistenermanager {
  static Keyboardlistenermanager? _instance;
  List<KeyEventCallback> listenerList = [];

  static Keyboardlistenermanager? getInstance() {
    if (_instance == null) {
      _instance = Keyboardlistenermanager();
    }
    return _instance;
  }

  addListener(KeyEventCallback listener) {
    try {
      if(!Utility.isHandsetBySize()) {
        removeAllListener();
        listenerList.add(listener);
        HardwareKeyboard.instance.addHandler(listener);
      }
    } catch (e) {
      print(e);
    }
  }

  removeListener(KeyEventCallback listener) {
    try {
      if(!Utility.isHandsetBySize()) {
        if (listenerList.contains(listener)) {
          listenerList.remove(listener);
          HardwareKeyboard.instance.removeHandler(listener);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  removeAllListener() {
    try {
      // listenerList.forEach((element) {
      //   HardwareKeyboard.instance.removeHandler(element);
      // });
      // listenerList.clear();
    } catch (e) {
      print(e);
    }
  }
}
