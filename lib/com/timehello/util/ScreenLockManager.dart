import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/flutter_screen_lock/src/functions.dart';
import 'package:time_hello/com/timehello/page/loginPage/LoginPage.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class ScreenLockManager {
  static ScreenLockManager? instance;

  static ScreenLockManager getInstance() {
    if (instance == null) {
      instance = new ScreenLockManager();
      instance?.init();
    }
    return instance!;
  }

  init() {
    // SharePreferenceUtil.getSyncInstance().setString(key: ShareprefrenceKeys.default9DigitPasswords, content: "");
  }

  dismiss() {
    Navigator.pop(Utility.getGlobalContext());
  }

  hasPassword() {
    String pwd = SharePreferenceUtil.getSyncInstance().getString(key: ShareprefrenceKeys.default9DigitPasswords);
    if(TextUtil.isEmpty(pwd)) {
      return false;
    } else {
      return true;
    }
  }

  resetPassword() async {
    if(hasPassword() == true) {
      await showPasword(canCancel: true, onUnlocked: () {
        createPassword(shouldShow: false);
      });
    } else {
      createPassword(shouldShow: false);
    }
  }

   showPasword({canCancel: false,  Function? onUnlocked,  Function? onCancelled}) async {
    String pwd = SharePreferenceUtil.getSyncInstance().getString(key: ShareprefrenceKeys.default9DigitPasswords);
    if(hasPassword() == true) {
      try {
        await screenLock(
          // correctString: "111111111",
          title: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(getI18NKey().please_enter_ur_password,
                style: TextStyle(color: Colors.white, fontSize: 20),),
              InkWell(
                onTap: () {
                  Utility.pushNavigator(Utility.getGlobalContext(), LoginPage(pageFrom: PageFromEnum.ScreenLockPage));
                  // Navigator.pop(Utility.getGlobalContext());
                  // createPassword(shouldShow: true);
                },
                child: Text(getI18NKey().reset_pwd,
                  style: TextStyle(color: Colors.blue, fontSize: 16),),
              ),
            ],
          ),
          // title: "111111111",
            onUnlocked: () {
              Navigator.pop(Utility.getGlobalContext());
              onUnlocked?.call();
              print("unlocked");
            },
            onCancelled: () {
              onCancelled?.call();
              Navigator.pop(Utility.getGlobalContext());
              print("cancelled");
            },
          context: Utility.getGlobalContext(),
          correctString: pwd,

          canCancel: canCancel,
        );
      } catch(e) {
        print(e);
      }
    } else {
      createPassword();
    }
  }

  createPassword({shouldShow: false}) {
    screenLockCreate(
      context: Utility.getGlobalContext(),
      title: Text(getI18NKey().please_create_ur_password, style: TextStyle(color: Colors.white, fontSize: 20),),
        confirmTitle: Text(getI18NKey().please_confirm_your_password, style: TextStyle(color: Colors.white, fontSize: 20),),
        onCancelled: () {
          // onCancelled?.call();
          Navigator.pop(Utility.getGlobalContext());
          print("cancelled");
        },
      onConfirmed: (value) {
        SharePreferenceUtil.getSyncInstance().setString(key: ShareprefrenceKeys.default9DigitPasswords, content: value);
        if(shouldShow) {
          Navigator.pop(Utility.getGlobalContext());
          screenLock(
            context: Utility.getGlobalContext(),
            title: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(getI18NKey().please_enter_ur_password,
                  style: TextStyle(color: Colors.white, fontSize: 20),),
                InkWell(
                  onTap: () {
                    Utility.pushNavigator(Utility.getGlobalContext(), LoginPage(pageFrom: PageFromEnum.ScreenLockPage));
                    // Navigator.pop(Utility.getGlobalContext());
                    // createPassword(shouldShow: true);
                  },
                  child: Text(getI18NKey().reset_pwd,
                    style: TextStyle(color: Colors.blue, fontSize: 16),),
                ),
              ],
            ),
            onUnlocked: () {
              Navigator.pop(Utility.getGlobalContext());
              print("unlocked");
            },
            correctString: value,
            canCancel: true,
          );
        }else {
          Navigator.pop(Utility.getGlobalContext());
        }
        // CloudSharepreferenceManagement.getInstance().setString(ShareprefrenceKeys.default9DigitPasswords, value);
        // print(value)
      }, // store new passcode somewhere here
    );
  }
}