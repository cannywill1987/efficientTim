//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/page/loginPage/LoginPage.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../r.dart';
import '../../components/BaseWidget.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';

class LockScreenPage extends BaseWidget {

  const LockScreenPage();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return LockScreenPageState();
  }
}

class LockScreenPageState extends BaseWidgetState<LockScreenPage> {
  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Utility.getSVGPicture(R.assetsImgIcLockscreenSelected,
                  color: Color(0xff999999), size: 100),
              SizedBox(height: 20,),
              Text(
                getI18NKey().lock_app_setting,
                style: TextStyle(fontSize: 15, color: Color(0xff666666)),
              ),
              SizedBox(height: 20,),
              Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: Wrap(
                  children: [
                    Text(
                      getI18NKey().lock_app_setting_description,
                      style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  if(!LoginManager.getInstance().isLogin2()) {
                    Utility.pushNavigator(context, LoginPage());
                    return;
                  }
                  if(LoginManager.getInstance().isLogin2() && SharePreferenceUtil.getSyncInstance().getDefault9DigitPasswordsNeedShowWhenLoginAppLock() == true && ScreenLockManager.getInstance().hasPassword()) {
                    ScreenLockManager.getInstance().showPasword(onUnlocked: () {
                      CounterMethodChannelManager.getInstance().requestPushToTimeline();
                    });
                  } else {
                    CounterMethodChannelManager.getInstance().requestPushToTimeline();
                  }
                },
                child: Container(
                  width: 200,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color(0xff999999),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      getI18NKey().lock_app_setting,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}
