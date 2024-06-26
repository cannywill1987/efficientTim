import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/ColorsConfig.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';

/**
 * 用于设计样式管理
 */
class ThemeManager {
  static ThemeManager? mThemeManager;
  int cpt = 0;
  Timer? _timer;
  List<Function> onCallbackList = [];
  late AdaptiveThemeMode themeMode;

  // late ThemeData curThemeData;
  ThemeData curThemeDataDark = ThemeData.dark();
  ThemeData curThemeDataLight = ThemeData.dark();
  int selectedIconColor = 0xff6083f6;
  int defaultThemeColor = 0xff6083f6;
  int lightDefaultThemeColor = 0xff6083f6;
  // late ThemeData curThemeDataLight;
  static ThemeManager getInstance({AdaptiveThemeMode? themeMode}) {
    if (mThemeManager == null) {
      mThemeManager = new ThemeManager();
      mThemeManager?.init(themeMode);
    }
    return mThemeManager!;
  }

  init([AdaptiveThemeMode? adaptiveTheme]) {
    try {
      int initIndex = SharePreferenceUtil.getSyncInstance()
          .getInt(key: ShareprefrenceKeys.themeMode, defaultVal: 0);
      AdaptiveThemeMode themeModeParam = AdaptiveThemeMode.values[initIndex];
      themeMode = themeModeParam;
      defaultThemeColor = SharePreferenceUtil.getSyncInstance()
          .getInt(
          key: ShareprefrenceKeys.defaultThemeColor, defaultVal: defaultThemeColor);
      lightDefaultThemeColor = defaultThemeColor - 0xe0000000;
      // themeMode = adaptiveTheme ?? AdaptiveTheme
      //     .of(Utility.getGlobalContext())
      //     .mode;
    } catch (e) {
      themeMode = AdaptiveThemeMode.light;
    }
  }

  AdaptiveThemeMode getThemeMode() {
    return themeMode;
  }

  void setThemeMode(AdaptiveThemeMode themeMode) {
    this.themeMode = themeMode;

    if (this.themeMode == AdaptiveThemeMode.dark) {
      AdaptiveTheme.of(Utility.getGlobalContext()).setDark();
    } else {
      AdaptiveTheme.of(Utility.getGlobalContext()).setLight();
    }
    SharePreferenceUtil.getSyncInstance()
        .setInt(key: ShareprefrenceKeys.themeMode, value: themeMode.index);
    eventBus.fire(EventFn(Params.ACTION_UPDATE_GLOBAL_THEME, {}));
  }

  // void setLightDefautThemeColor(int color) {
  //   selectedIconColor = color;
  //   defaultThmeColor = color;
  //   lightDefaultThmeColor = defaultThmeColor - 0xc0000000;
  //   SharePreferenceUtil.getSyncInstance()
  //       .setInt(key: ShareprefrenceKeys.defaultThemeColor, value: color);
  //   eventBus.fire(EventFn(Params.ACTION_UPDATE_GLOBAL_THEME, {}));
  // }

  void setDefautThemeColor(int color) {
    selectedIconColor = color;
    defaultThemeColor = color;
    lightDefaultThemeColor = defaultThemeColor - 0xe0000000;
    SharePreferenceUtil.getSyncInstance()
        .setInt(key: ShareprefrenceKeys.defaultThemeColor, value: color);
    eventBus.fire(EventFn(Params.ACTION_UPDATE_GLOBAL_THEME, {}));
  }

  // Color getThemeColor() {
  //   return Color();
  // }

  TextStyle? getTextStyle(
      {BuildContext? context, String? scene, TextStyle? defaultTextStyle}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultTextStyle?.copyWith(color: Colors.white) ?? null;
        }
        return defaultTextStyle ?? null;
    }
  }

  Color getSliderColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? ColorsConfig.red;
        }
        return defaultColor ?? ColorsConfig.red;
    }
  }

  Color getSliderInactiveColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Color(0xff575757);
        }
        return defaultColor ?? Color(0xfffdfdfd);
    }
  }

  Color getInputBorderColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Colors.blue;
        }
        return defaultColor ?? ThemeManager.getInstance().getDefautThemeColor();
    }
  }

  Color getInputPlaceholderColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Color(0xff575757);
        }
        return defaultColor ?? Color(0xff999999);
    }
  }

  Color? getInputThemeColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Color(0xff3b3a37);
        }
        return defaultColor;
    }
  }

  // inputDecorationTheme
  InputDecorationTheme? getInputDecorationTheme(
      {BuildContext? context,
      String? scene,
      InputDecorationTheme? defaultInputDecorationTheme}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultInputDecorationTheme?.copyWith(
                fillColor: this.curThemeDataDark.colorScheme.surface,
                filled: true,
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                errorStyle: TextStyle(color: Colors.red),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeManager.getInstance()
                          .getInputBorderColor(defaultColor: Colors.white)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeManager.getInstance()
                          .getInputBorderColor(defaultColor: Colors.white)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeManager.getInstance()
                          .getInputBorderColor(defaultColor: Colors.red)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeManager.getInstance()
                          .getInputBorderColor(defaultColor: Colors.red)),
                ),
              ) ??
              null;
        }
        return defaultInputDecorationTheme ?? null;
    }
  }

  getSelectedIconColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Color(selectedIconColor);
        }
        return defaultColor;
    }
  }

  Color getIconColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Colors.white;
        }
        return defaultColor ?? ThemeManager.getInstance().getDefautThemeColor();
    }
  }

  Color getUncheckIconColor(
      {BuildContext? context,
        String? scene,
        Color? defaultColor,
        Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Colors.white;
        }
        return defaultColor ?? Color(defaultThemeColor);
    }
  }

  Color getTextColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Colors.white;
        }
        return defaultColor ?? Colors.black;
    }
  }

  // The background color for widgets like [Card].
  Color getCardBackgroundColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      int alpha = 255}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          if (alpha == 255)
            return Color(0xff424242);
          else {
            return Color.fromARGB(alpha, 66, 66, 66);
          }
        }
        return defaultColor ?? Colors.white;
    }
  }

  getInputDecorationColor(
      {BuildContext? context, String? scene, Color? defaultColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return Color(0xff212121);
        }
        return defaultColor ?? Color(0xffe0e0e0);
    }
  }

  int getLightDefaultThemeColorInt() {
    return this.lightDefaultThemeColor;
  }

  int getDefautThemeColorInt() {
    return this.defaultThemeColor;
  }

  Color getDefautThemeColor() {
    return Color(this.defaultThemeColor);
  }

  Color getLightDefaultThemeColor() {
    return Color(this.lightDefaultThemeColor);
  }

  getColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? Colors.white;
        }
        return defaultColor;
    }
  }

  //阴影颜色
  getShadowColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return defaultDarkColor ?? this.curThemeDataDark.shadowColor;
        }
        return defaultColor;
    }
  }

  isDark() {
    return themeMode.isDark;
  }

  getButtonTextColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return Colors.white;
        }
        return defaultColor;
    }
  }

  getButtonLinearGradientBackgroundColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return [Color(0xff424242), Color(0xff424242 - 0x20000000)];
        }
        return [Color(selectedIconColor), Color(selectedIconColor - 0x20000000)];
    }
  }

  getButtonBackgroundColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return Color(0xff424242);
        }
        return defaultColor ??  ThemeManager.getInstance().getDefautThemeColor();
    }
  }

  getButtonBorderColor(
      {BuildContext? context,
      String? scene,
      Color? defaultColor,
      Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    switch (scene) {
      default:
        if (themeMode.isDark) {
          return this.curThemeDataDark.buttonTheme.colorScheme?.background ??
              Colors.white;
        }
        return defaultColor ?? Colors.white;
    }
  }

  Color getDialogBackgroundColor({BuildContext? context, Color? defaultColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    if (themeMode.isDark) {
      return this.curThemeDataDark.dialogBackgroundColor;
    } else {
      return defaultColor ?? ColorsConfig.standardPageBackground;
    }
    // return Theme.of(context).colorScheme.background;
  }

  Color getBackgroundColor({BuildContext? context, Color? defaultColor, Color? defaultDarkColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    if (themeMode.isDark) {
      return defaultDarkColor?? this.curThemeDataDark.colorScheme.background;
    } else {
      return defaultColor ?? ColorsConfig.standardPageBackground;
    }
    // return Theme.of(context).colorScheme.background;
  }

  Color getNavigationBarColor({BuildContext? context, Color? defaultColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    if (themeMode.isDark) {
      return this.curThemeDataDark.navigationBarTheme.backgroundColor ??
          Colors.white;
    } else {
      return defaultColor ?? Colors.white;
    }
    // return Theme.of(context).colorScheme.background;
  }

  Color getLeftMenuColor({BuildContext? context, Color? defaultColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    if (themeMode.isDark) {
      return Color(0xff4b4b4b) ?? Colors.white;
    } else {
      return defaultColor ?? Colors.white;
    }
    // return Theme.of(context).colorScheme.background;
  }

  Color getCardLineColor({BuildContext? context, Color? defaultColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    if (themeMode.isDark) {
      return Colors.black ?? Colors.white;
    } else {
      return defaultColor ?? Colors.white;
    }
    // return Theme.of(context).colorScheme.background;
  }

  Color getLineColor({BuildContext? context, Color? defaultColor}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    if (themeMode.isDark) {
      return Colors.black ?? Colors.white;
    } else {
      return defaultColor ?? Colors.white;
    }
    // return Theme.of(context).colorScheme.background;
  }

  getTextTheme({BuildContext? context}) {
    if (context == null) {
      context = Utility.getGlobalContext();
    }
    return Theme.of(context).textTheme;
  }

  getDarkThemeData() {
    ThemeData themeDataDark = ThemeData.dark()
        .copyWith(
            colorScheme: this.curThemeDataDark.colorScheme.copyWith(
                  background: Color(0xff20201e), //背景色
                ))
        .copyWith(
            navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Color(0xff363535), //导航栏颜色
        ));
    this.curThemeDataDark = themeDataDark;
    return themeDataDark;
  }

  getLightThemeData() {
    ThemeData themeData = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: ColorsConfig.standardPageBackground,
        brightness: Brightness.light,
      ),
      // 主色调
      primarySwatch: Colors.blue,
      // 按钮主题
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      // 文本主题
      textTheme: TextTheme(
        // 你可以根据需要设置其他文本样式

        // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
    this.curThemeDataLight = themeData;
    return themeData;
  }

  // getThemeData() {
  //     // this.curThemeDataDark = this.curThemeDataDark;
  //     //背景色淡灰
  //     // ThemeData themeDataDark = ThemeData.dark().copyWith(
  //     //     colorScheme: this.curThemeDataDark.colorScheme.copyWith(
  //     //   background: Color(0xff20201e), //背景色
  //     // )).copyWith(navigationBarTheme: NavigationBarThemeData(
  //     //     backgroundColor: Color(0xff363535), //导航栏颜色
  //     //     ));
  //     this.curThemeDataDark = this.getDarkThemeData();
  //
  //   // if (themeMode.isDark) {
  //   //   this.curThemeData = this.curThemeDataDark;
  //   //   return this.curThemeData;
  //   // } else {
  //   //   // return this.curThemeDataDark;
  //   //   ThemeData themeData = this.getLightThemeData();
  //   //   this.curThemeData = themeData;
  //   //   return this.curThemeData;
  //   // }
  // }

  // setThemeMode({required AdaptiveThemeMode mode}) {
  //   AdaptiveTheme.of(Utility.getGlobalContext()).setThemeMode(mode);
  // }

  setTheme(BuildContext context, ThemeData light, ThemeData dark) {
    AdaptiveTheme.of(context).setTheme(
      light: light,
      dark: dark,
      // system: AdaptiveThemeMode.system,
    );
  }

  addChangeListener(BuildContext context) {
    AdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
      // do your thing.
    });
  }

  setDefaultTheme(BuildContext context) {
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      // isDefault: true,
    );
  }

// saveThemeMode(BuildContext context) async {
//   final prefs = await SharedPreferences.getInstance();
//   await pref.clear();
//   AdaptiveTheme.persist();
// }
}
