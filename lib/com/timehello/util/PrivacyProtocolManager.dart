import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../beans/BaseBean.dart';
import '../beans/ResourceLocationInfoBean.dart';
import '../config/Params.dart';
import 'DeviceInfoManagement.dart';
import 'LoginUtil.dart';
import 'SharePreferenceUtil.dart';

class PrivacyProtocolManager {
  static PrivacyProtocolManager? mPrivacyProtocolManager;

  static PrivacyProtocolManager getInstance() {
    if (mPrivacyProtocolManager == null) {
      mPrivacyProtocolManager = new PrivacyProtocolManager();
    }
    mPrivacyProtocolManager!.init();
    return mPrivacyProtocolManager!;
  }

  init() {}

  bool isProtocolAgreed(BuildContext? context) {
    String lang = DeviceInfoManagement.getLanguage();
    bool isProtocolShowed = SharePreferenceUtil.getSyncInstance()
        .getBool(key: 'isProtocolShowed');
    if (lang == "zh" && (Utility.isAndroid() == true || Utility.isIOS() == true)) {
      return isProtocolShowed;
    } else {
      return true;
    }
  }

  showDialog(BuildContext context, {required Function onClickLink, required Function okCallback, required Function cancelCallback, required Function jumpCallback}) {
    String lang = Localizations.localeOf(Utility.getGlobalContext()).languageCode;
    bool isProtocolShowed = SharePreferenceUtil.getSyncInstance()
        .getBool(key: ShareprefrenceKeys.isProtocolShowed);
    // && lang == "zh"
    if (isProtocolShowed ==
        false  && (Utility.isAndroid() == true || Utility.isIOS() == true)) {
      DialogManagement.getInstance().showProtocolDialog(context,
          pattern: getI18NKey().privacy_pattern,
          title: getI18NKey().gently_remind,
          content: getI18NKey().privacy_protocol_content,
          onClickLink: () {
            onClickLink();
          },
          okCallback: () {
            SharePreferenceUtil.getSyncInstance()
                .setBool(key: ShareprefrenceKeys.isProtocolShowed, val: true);
            bool isProtocolShowed = SharePreferenceUtil.getSyncInstance()
                .getBool(key: ShareprefrenceKeys.isProtocolShowed);
            okCallback();
          },
          cancelCallback: () {
            hideDialog(context);
            DialogManagement.getInstance().showProtocolDialog(context,
                pattern: getI18NKey().privacy_pattern,
                title: getI18NKey().gently_remind,
                content: getI18NKey().privacy_protocol_content2,
                onClickLink: () {
                  onClickLink();
                },
                okCallback: () {
                  okCallback();
                  SharePreferenceUtil.getSyncInstance()
                      .setBool(key: 'isProtocolShowed', val: true);
                },
                cancelCallback: () {
                  cancelCallback();
                });

          });
    } else {
      jumpCallback();
    }
  }

  hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
