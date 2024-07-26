import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/AliOneKeyLoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';

import '../components/LoadingDialogUtil.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../page/loginPage/LoginPage.dart';
import 'EasyLoadingManager.dart';
import 'SharePreferenceUtil.dart';
import 'UserInfoManager.dart';
import 'Utility.dart';

abstract class LoginResult {
  void loginSuccess({UserBean loginInfoModel});

  void loginFail(Map errorMsg, {LoginMode loginMode});
}

class LoginUtil implements Observer {
  static LoginUtil? _instance;
  LoginResult? loginResult;

  LoginUtil() {}

  setLoginResult(LoginResult loginResult) {
    this.loginResult = loginResult;
  }

  doAliSdkSecVerifyLogin(BuildContext context) async {
    this.loginResult = loginResult;
    // pc端直接跳转到登录
    // pc端直接跳转到登录 移动端
    if (ChannelEnum.huawei != Params.channelEnum ||
        (ChannelEnum.huawei == Params.channelEnum && true)) {
      if (Utility.isHandsetBySize() == true) {
        //阿里一键登录
        EasyLoadingManager.getInstance().showLoading();
        AliOneKeyLoginManager.getInstance()
            .setResultListener((dynamic event, bool isSuccess) async {
          EasyLoadingManager.getInstance().hideLoading();
          if (event["code"] == "600000") {
            BaseBean baseBean = await HttpManager.getInstance()
                .doPostRequest(Apis.aliSdkSecLogin, params: {
              "token": event["data"] ?? "",
              "deviceId": MongoApisManager.getInstance().device_id,
              "loginType": LoginTypeEnum.secVerify.toString(),
              "channel": Params.channelEnum.toString(),
              "avatar": 'avatar_${Utility.getRandomString(
                from: 1,
                max: 40,
                pureInt: 2,
              )}',
            });
            Params.loginTypeEnum = LoginTypeEnum.secVerify;
            bool res = handleLoginResult(baseBean, true);
            if (res == true) {
              LoginManager.getInstance()
                  .handleLoginSuccess(context, jumpMode: JumpModeEnum.pushMode);
            }
          } else {
            // if (isSuccess == false) {
            //   Future.delayed(Duration(milliseconds: 300), () {
            //     Utility.pushNavigator(context, const LoginPage(jumpMode: JumpModeEnum.pushMode),
            //         callback: (res) {
            //       // this.requestDatas();
            //     });
            //   });
            // }
          }
        });
        AliOneKeyLoginManager.getInstance().login(context);
      } else {
        Utility.pushNavigator(context, new LoginPage(), callback: (res) {
          // this.requestDatas();
        });
        // // pc端直接跳转到登录
        // Utility.pushNavigator(context, new LoginPage(), callback: (res) {
        //   // this.requestDatas();
        // });
      }
    } else {
      Utility.pushNavigator(context, new LoginPage(), callback: (res) {
        // this.requestDatas();
      });
      // Utility.pushNavigator(context, new LoginPage(), callback: (res) {
      //   // this.requestDatas();
      // });
    }
    EasyLoadingManager.getInstance().hideLoading();
    // LoadingDialogUtil.getInstance().hide();
    // }
  }

  doRegister(
      {BuildContext? context,
        String? countryPhoneCode,
        String? phoneNum,
        String? email,
        String? password,
        String? dynamicCode,
        bool shouldShowLoading = false}) {
    loginWithPassword(
        countryPhoneCode: countryPhoneCode,
        mobile: phoneNum,
        shouldShowLoading: shouldShowLoading,
        email: email,
        password: password,
        dynamicCode: dynamicCode,
        loginAndRegisterEnum: LoginAndRegisterEnum.register);
  }

  doRegisterWithEmail(
      {required BuildContext context,
        String? email,
        String? name,
        String? deviceId,
        String? avatar,
        String? password,
        bool? shouldShowLoading = false,
        LoginTypeEnum loginTypeEnum = LoginTypeEnum.email}) async {
    if (shouldShowLoading == true) {
      EasyLoadingManager.getInstance().showLoading();
    }
    BaseBean baseBean =
    await HttpManager.getInstance().doPostRequest(Apis.registerWithEmail,
        params: {
          "name": name,
          "avatar": avatar ??
              'avatar_${Utility.getRandomString(
                from: 1,
                max: 40,
                pureInt: 2,
              )}',
          "email": email,
          "password": password,
          "deviceId": deviceId,
          "loginType": loginTypeEnum.toString(),
          "channel": Params.channelEnum.toString()
          // "uid": uid,
        },
        observer: this,
        shouldShowErrorToast: true);
    if (shouldShowLoading == true) {
      EasyLoadingManager.getInstance().hideLoading();
    }
    Params.loginTypeEnum = loginTypeEnum;
    bool res = handleLoginResult(baseBean, true);
    if (res == true) {
      LoginManager.getInstance()
          .handleLoginSuccess(context, jumpMode: JumpModeEnum.pushMode);
    } else {
      // Utility.showToast(msg: getI18NKey().login)
    }
    // loginWithPassword(
    //     mobile: phoneNum,
    //     password: password,
    //     dynamicCode: dynamicCode,
    //     loginAndRegisterEnum: LoginAndRegisterEnum.register);
  }

  doLogin(
      {String? countryPhoneCode,
        String? email,
        String? phoneNum,
        String? password,
        String? dynamicCode,
        bool shouldShowLoading = false}) {
    loginWithPassword(
        countryPhoneCode: countryPhoneCode,
        email: email,
        mobile: phoneNum,
        password: password,
        dynamicCode: dynamicCode,
        shouldShowLoading: shouldShowLoading,
        loginAndRegisterEnum: LoginAndRegisterEnum.login);
  }

  doLoginFromSplashScreen() {
    loginWithPassword(
        loginAndRegisterEnum: LoginAndRegisterEnum.splashScreen,
        shouldShowToast: false);
  }

  loginWithPassword(
      {String? mobile,
        String? email,
        String? password,
        String? countryPhoneCode,
        String? dynamicCode,
        bool shouldShowToast: true,
        bool shouldShowLoading: false,
        LoginAndRegisterEnum? loginAndRegisterEnum}) async {
    if (shouldShowLoading == true) {
      EasyLoadingManager.getInstance().showLoading();
    }
    BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
        loginAndRegisterEnum == LoginAndRegisterEnum.register
            ? Apis.register
            : loginAndRegisterEnum == LoginAndRegisterEnum.login
            ? Apis.login
            : Apis.loginWithTokenUid,
        params: loginAndRegisterEnum == LoginAndRegisterEnum.register
            ? {
          "avatar": 'avatar_${Utility.getRandomString(
            from: 1,
            max: 40,
            pureInt: 2,
          )}',
          "email": email,
          "mobilePhoneNumber": mobile,
          "password": password,
          "countryPhoneCode": countryPhoneCode,
          "dynamicCode": dynamicCode,
          "scene": Params.MSN_REGISTER_SCENE,
          "loginType": LoginTypeEnum.phone.toString(),
          "channel": Params.channelEnum.toString()
        }
            : loginAndRegisterEnum == LoginAndRegisterEnum.login
            ? {
          "email": email,
          "mobilePhoneNumber": mobile,
          "password": password,
          "countryPhoneCode": countryPhoneCode,
          "dynamicCode": dynamicCode,
          "loginType": LoginTypeEnum.phone.toString(),
          "channel": Params.channelEnum.toString(),
          "scene": Params.MSN_REGISTER_SCENE,
        }
            : {},
        observer: this,
        shouldShowErrorToast: shouldShowToast ||
            loginAndRegisterEnum == LoginAndRegisterEnum.register
            ? true
            : false);
    Params.loginTypeEnum = LoginTypeEnum.normal;
    if (shouldShowLoading == true) {
      EasyLoadingManager.getInstance().hideLoading();
    }
    handleLoginResult(baseBean, shouldShowToast);
  }

  bool handleLoginResult(BaseBean baseBean, bool shouldShowToast) {
    if (baseBean.success == true) {
      UserBean userBean = UserBean.fromJson(baseBean.data);
      SharePreferenceUtil.getSyncInstance().setUserBean(userBean: userBean);
      LoginManager.getInstance().setUserBean(userBean);
      UserInfoManager.getSyncInstance().init();
      if (shouldShowToast == true) {
        Utility.showToastMsg(msg: getI18NKey().login_success);
      }
      if (this.loginResult != null) {
        loginResult?.loginSuccess(
            loginInfoModel: LoginManager.getInstance().getUserBean());
      }

      return true;
    } else {
      loginResult?.loginFail(baseBean.toJson(), loginMode: LoginMode.none);
      return false;
      // if (baseBean.message.isNotEmpty) {
      //   Utility.showToast(msg: baseBean.message);
      // }
    }
  }

  // static isLogin() {
  //   if(!TextUtil.isEmpty(LoginManager.getInstance().getLogininfoModel().uid)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  void update(Observable o, BaseBean response, String scene) {
    // TODO: implement update
  }
}
