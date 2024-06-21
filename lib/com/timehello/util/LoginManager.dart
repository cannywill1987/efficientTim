import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/MainContainerWidget.dart';
import 'package:time_hello/com/timehello/page/SettingUserInfoPage/SettingUserInfoPage.dart';
import 'package:time_hello/com/timehello/page/registerPage/pages/RegisterEmailVerificationPage.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/FirebaseManager.dart';
import 'package:time_hello/com/timehello/util/GoogleMailLoginManager.dart';
import 'package:time_hello/com/timehello/util/PermissionManager.dart';
import 'package:time_hello/com/timehello/util/SettingManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import '../beans/BaseBean.dart';
import '../config/Params.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../models/EventFn.dart';
import '../page/loginPage/LoginPage.dart';
import 'EditFormat.dart';
import 'LoginUtil.dart';
import 'SharePreferenceUtil.dart';
import 'UserInfoManager.dart';
import 'Utility.dart';

class LoginManager {
  UserBean userBean = UserBean();
  LoginResult? mOnComplete;
  LoginMode? curLoginMode;
  LoginUtil? loginUtil;
  bool isChangeUser = false;
  static bool hasPrevLogin = false;

  static LoginManager? mLoginManager;

  static LoginManager getInstance() {
    if (mLoginManager == null) {
      mLoginManager = new LoginManager();
    }
    // mLoginManager.init();
    return mLoginManager!;
  }

  init() async {
    userBean = (await SharePreferenceUtil.getAsyncInstance()).getUserBean() ??
        UserBean();
  }

  hasLogin() async {}

  hasUserName(
      {required BuildContext context, required Function callback}) async {
    if (isLogin() == false) {
      LoginManager.getInstance().doAliSdkSecVerifyLogin(context);
      // Utility.pushNavigator(
      //     Utility.getGlobalContext(),
      //     new LoginPage(
      //       jumpMode: JumpModeEnum.backMode,
      //     ), callback: (res) {
      //   // this.requestDatas();
      // });
    } else {
      if (TextUtil.isEmpty(LoginManager.getInstance().getUserBean().username) ==
          true) {
        Utility.showToastMsg(msg: getI18NKey().need_update_username);
        Utility.pushNavigator(
            Utility.getGlobalContext(), new SettingUserInfoPage(),
            callback: (res) {
          if (TextUtil.isEmpty(
                  LoginManager.getInstance().getUserBean().username) ==
              false) {
            Utility.showToastMsg(msg: getI18NKey().setting_success);
            callback();
          } else {
            //用户名未设置成功
            Utility.showToastMsg(msg: getI18NKey().setting_fail);
          }
          // this.requestDatas();
        });
      } else {
        callback();
      }
    }
  }

  /**
   * todo 应该是按照token来区分
   */
  static isLogin() {
    if (!TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)) {
      return true;
    } else {
      return false;
    }
  }

  isLogin2() {
    if (!TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)) {
      return true;
    } else {
      return false;
    }
  }

  logout(context) {
    LoginManager.hasPrevLogin = false;
    MongoApisManager.getInstance().reset(shouldResetAllData: true);
    userBean = UserBean();
    SharePreferenceUtil.getSyncInstance().resetCacheList();
    SharePreferenceUtil.getSyncInstance().setUserBean(userBean: userBean);
    // if(isMobileDevice == true) {
    Utility.pushReplacement(context, MainContainerWidget());
    //重新请求未登录数据
    MongoApisManager.getInstance().init();
    // }
  }

  UserBean getUserBean() {
    if (userBean == null) {
      userBean = new UserBean();
    }
    return userBean;
  }

  LoginManager() {
    loginUtil = new LoginUtil();
  }

  registerByEmail({BuildContext? context, String? email, String? password}) async {
    if (TextUtil.isEmpty(email)) {
      Utility.showToastMsg(msg: getI18NKey().please_input_email);
      return;
    }
    if(!TextUtil.isEmail(email ?? "")) {
      Utility.showToastMsg(msg: getI18NKey().please_input_correct_email);
      return;
    }
    EasyLoadingManager.getInstance().showLoading();
    // EasyLoadingManager.getInstance().showLoading();
    GoogleMailLoginManager.getInstance().signIn(email: email, password: await Utility.decryptCTRAES(
        password ?? "", Params.AES_PWD), callbackSuccess: () {
      //如果注册了那给调用注册
      // register(email: email, password: password, onComplete: new LoginResult);
      Utility.pushReplacement(context ?? Utility.getGlobalContext(), RegisterEmailVerificationPage(pageFromEnum: PageFromEnum.RegisterPage, email: email ?? "", password: password ?? ""));
      // Utility.pushReplacement(context ?? Utility.getGlobalContext(), RegisterEmailVerificationPage(pageFromEnum: PageFromEnum.RegisterPage, email: email ?? "", password: password ?? ""));
      EasyLoadingManager.getInstance().hideLoading();
    }, callbackNeedVerified:() {
      Utility.pushReplacement(context ?? Utility.getGlobalContext(), RegisterEmailVerificationPage(pageFromEnum: PageFromEnum.RegisterPage, email: email ?? "", password: password ?? ""));
    });
  }

  LoginManager register(
      {String? mobile,
      String? password,
      String? dynamicCode,
      String? email,
      String? countryPhoneCode,
      required LoginResult onComplete}) {
    return this.requestPasswordLogin(
        mobile: mobile,
        email: email,
        password: password,
        countryPhoneCode: countryPhoneCode,
        dynamicCode: dynamicCode,
        loginAndRegisterEnum: LoginAndRegisterEnum.register,
        onComplete: onComplete);
  }

  Future<void> handleLoginSuccess(BuildContext context,
      {JumpModeEnum jumpMode: JumpModeEnum.pushMode}) async {
    EasyLoadingManager.getInstance().showLoading();
    try {
      //获取用户信息
      UserInfoManager.getSyncInstance().init();
      await Future.wait([
        MongoApisManager.getInstance()
            .batchUpdate_MissionModel(shouldRefresh: false),
        MongoApisManager.getInstance()
            .batchUpdate_FolderModel(shouldRefresh: false),
        MongoApisManager.getInstance()
            .batchUpdate_StatsModel(shouldRefresh: false),
        MongoApisManager.getInstance()
            .batchUpdate_TimelineMissionModel(shouldRefresh: false),
        MongoApisManager.getInstance()
            .batchUpdate_PresentModel(shouldRefresh: false),
        MongoApisManager.getInstance()
            .batchUpdate_FlomoMissionModel(shouldRefresh: false)
      ]);
      MongoApisManager.getInstance().batchUpdate_folderModelWithGroupId();
      MongoApisManager.getInstance().reset();
      await MongoApisManager.getInstance().init(); //跨手机登录等需要重新同步数据
      Utility.pushDesktopMainContainerNavigator(context, "StatisticPage", {});
      if (jumpMode == JumpModeEnum.pushMode) {
        Utility.pushAndRemoveUntil(
            context, MainContainerWidget(), 'MainContainerWidget');
      } else {
        Utility.popNavigator(context);
      }
    } catch (e) {
      print(e);
    }
    EasyLoadingManager.getInstance().hideLoading();
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  Future<void> requestFromSplashScreen() async {
    loginUtil?.doLoginFromSplashScreen();
  }

  Future<void> doAliSdkSecVerifyLogin(BuildContext context) async {
    loginUtil?.doAliSdkSecVerifyLogin(context);
  }

  /**
   * sharesdk秒验预登陆
   */
  requestPreVerify({Function? result}) async {
    bool hasExecuted = false;
    Future.delayed(Duration(milliseconds: 3000), () {
      if (hasExecuted == false) {
        if (result != null)
          result(BaseBean(message: "", success: false, code: ""));
        hasExecuted = true;
      }
    });
    if (LoginManager.hasPrevLogin == false && LoginManager.isLogin() == false) {
      CounterMethodChannelManager.getInstance().requestPreVerify(
          result: (BaseBean baseBean) {
        hasExecuted = true;
        if (baseBean.success == true) {
          LoginManager.hasPrevLogin = true;
        }
        if (result != null) result(baseBean);
      });
    } else {
      hasExecuted = true;
      if (result != null)
        result(BaseBean(
            message: "",
            success: LoginManager.hasPrevLogin,
            code: "",
            data: ""));
    }
  }

  /**
   * 带上dynamicCode表述注册 或者短信登录
   */
  LoginManager requestPasswordLogin(
      {BuildContext? context,
      String? countryPhoneCode,
      String? mobile,
      String? email,
      String? password,
      String? dynamicCode,
      LoginAndRegisterEnum loginAndRegisterEnum = LoginAndRegisterEnum.login,
      required LoginResult onComplete}) {
    curLoginMode = LoginMode.LoginPassword;
    mOnComplete = onComplete;
    String phoneNum = EditFormat.getNoblanKString(mobile ?? "");
    String psd = password ?? "";
    String emailStr = EditFormat.getNoblanKString(email ?? "");
    // if (TextUtil.isEmpty(mobile.toString())) {
    //   Utility.showToastMsg(msg: getI18NKey().input_mobile);
    //   return mLoginManager!;
    // }
    // if (TextUtil.isEmpty(emailStr)) {
    //   Utility.showToastMsg(msg: getI18NKey().please_input_email);
    //   return mLoginManager!;
    // }
    // if (EditFormat.getNoblanKString(mobile ?? "").length < 11) {
    //   Utility.showToastMsg(msg: getI18NKey().input_correct_mobile);
    //   return mLoginManager!;
    // }
    if (TextUtil.isEmpty(password.toString()) || (password?.length ?? 0) < 6) {
      Utility.showToastMsg(msg: getI18NKey().password_at_least_6);
      return mLoginManager!;
    }

    if (TextUtil.isEmpty(password.toString())) {
      Utility.showToastMsg(msg: getI18NKey().password_not_empty);
      return mLoginManager!;
    }

    try {
      // psd = RSAUtils.encrypt(psd, false, mActivity);
      if (LoginAndRegisterEnum.login == loginAndRegisterEnum) {
        loginUtil?.doLogin(
            countryPhoneCode: countryPhoneCode ?? "",
            email: emailStr,
            shouldShowLoading: true,
            phoneNum: phoneNum,
            password: psd,
            dynamicCode: dynamicCode ?? "");
      } else {
        if (TextUtil.isEmpty(emailStr)) {
          loginUtil?.doRegister(
              // email: emailStr,
              shouldShowLoading: true,
              countryPhoneCode: countryPhoneCode ?? "",
              phoneNum: phoneNum,
              password: psd,
              dynamicCode: dynamicCode ?? "");
        } else {
          loginUtil?.doRegisterWithEmail(
              shouldShowLoading: true,
              context: context ?? Utility.getGlobalContext(),
              email: emailStr,
              password: psd,
              loginTypeEnum: LoginTypeEnum.email);
        }
      }
    } catch (e) {
      print(e);
    }

    loginUtil?.setLoginResult(onComplete);
    return mLoginManager!;
  }

  thirdPartyLoginWithGoogle(BuildContext context) async {
    //不加这个会有plugin找不到的问题
    // EasyLoadingManager.getInstance().showLoading();
    if (Utility.isAndroid() == true) {
      await PermissionManager.getInstance().requestStoragePermission();
    }
    Map map = await FirebaseManager.getInstance().signInWithGoogle();
    // EasyLoadingManager.getInstance().hideLoading();
    loginUtil?.doRegisterWithEmail(
        shouldShowLoading: true,
        context: context,
        email: map['email'],
        avatar: map['avatar'],
        name: map['name'],
        loginTypeEnum: LoginTypeEnum.google);
  }

  thirdPartyLoginWithApple(BuildContext context) async {
    //不加这个会有plugin找不到的问题
    // EasyLoadingManager.getInstance().showLoading();
    // if(Utility.isAndroid() == true) {
    //   await PermissionManager.getInstance().requestStoragePermission();
    // }
    Map map = await FirebaseManager.getInstance().signInWithApple();
    print(map);
    loginUtil?.doRegisterWithEmail(
        shouldShowLoading: true,
        context: context,
        email: map['email'],
        avatar: map['avatar'],
        name: map['name'],
        loginTypeEnum: LoginTypeEnum.google);

    // EasyLoadingManager.getInstance().hideLoading();
    // loginUtil?.doRegisterWithEmail(shouldShowLoading: true, context: context, email: map['email'], avatar: map['avatar'], name: map['name'], loginTypeEnum: LoginTypeEnum.google);
  }

  // thirdPartyLoginWithFacebook(BuildContext context) async {
  //   EasyLoadingManager.getInstance().showLoading();
  //   //不加这个会有plugin找不到的问题
  //   if(Utility.isAndroid() == true) {
  //     await PermissionManager.getInstance().requestStoragePermission();
  //   }
  //   Map map = await FirebaseManager.getInstance().signInWithFacebook();
  //   EasyLoadingManager.getInstance().hideLoading();
  //   loginUtil.doRegisterWithEmail(shouldShowLoading: true, context: context, email: map['email'], avatar: map['avatar'], name: map['name'], loginTypeEnum: LoginTypeEnum.facebook);
  // }

  getUid() {
    return TextUtil.isEmpty(LoginManager.getInstance().getUserBean().uid)
        ? ''
        : LoginManager.getInstance().getUserBean().uid;
  }

  setUserBean(UserBean userBean) {
    userBean.token = userBean.token ?? getUserBean().token; //有些情况后台不会返回token
    SharePreferenceUtil.getSyncInstance().setUserBean(userBean: userBean);
    this.userBean = userBean;
  }

/**
 * 登录成功后的处理
 *
 * @param obj
 */
// void handleLoginSuccess(bool isChangeUser) {
//切换用户
// isChangeUser = obj;
// if (isChangeUser) {
//   ActivityManager activityManager = ActivityManager.getInstance();
//   Activity mainActivity = activityManager.getActivity(activityManager.getMainActivityId());
//   if (mainActivity != null) {
//     mainActivity.finish();  // 切换账号，把首页finish，清除上一个用户的数据
//   }
//
//   toMainFragmentActivity();
//   mActivity.finish();
//   return;
// }
// //告诉首页已经切换用户
// Intent intent = new Intent(Params.BROADCAST_UPDATE_MAINACITIVTY);
// intent.putExtra("action", Params.ACTION_FROM_LOGIN_MAIN_ACTIVITY);
// intent.putExtra("isChangeUser", IsChangeUser);
// mActivity.sendBroadcast(intent);
//
// Bundle b = mActivity.getIntent().getExtras();
// if (b != null) {
//   String fromShare = b.getString(Cons.FROM_SHARE);
//   if (Cons.FROM_SHARE.equals(fromShare)) {
//     EventCollection.onCollection(mActivity, EventName.MGM, EventName.APP_Share_Login_Suc, null, b.getString(Cons.ORIGIN));
//   }
// }
// toActivityAfterLoginSuccess();
// }
}
