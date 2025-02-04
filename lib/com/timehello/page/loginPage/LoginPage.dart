import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/components/BackNavigator.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/TitleDescWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/ForgetPasswordPage/ForgetPasswordPage.dart';
import 'package:time_hello/com/timehello/page/loginPage/components/GuideViewPageWidget.dart';
import 'package:time_hello/com/timehello/page/registerPage/pages/RegisterEmailVerificationPage.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginUtil.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../components/ThirdPartyLoginWidget.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/GoogleMailLoginManager.dart';
import '../../util/ThemeManager.dart';
import '../registerPage/registerPage.dart';
import 'components/Guide1Widget.dart';
import 'components/Guide2Widget.dart';

class LoginPage extends BaseWidget {
  final JumpModeEnum jumpMode;
  final PageFromEnum pageFrom;

  const LoginPage(
      {this.pageFrom: PageFromEnum.Default,
      this.jumpMode = JumpModeEnum.pushMode});

  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return new _LoginPageState();
  }
}

class _LoginPageState extends BaseWidgetState<LoginPage>
    implements LoginResult, Observer {
  final _formKey = new GlobalKey<FormState>();
  GlobalKey<CustomTabBarWidgetState> tabBarGlobalKey =
      GlobalKey<CustomTabBarWidgetState>();
  TextEditingController? textController1Phone;
  TextEditingController? textController1Email;
  TextEditingController? textController2;
  String? mobile;
  String? emailEncrypted;
  String? password;
  bool checked = false;
  bool isMobileVisible = false;
  String? countryIOSCode;
  String? countryPhoneCode;
  String? number;
  String? completeNumber;
  List<CheckButtonStateModel> tabList =
      CONSTANTS.getLoginRegisterTabBarWidget();
  int curTab = 0;
  bool isEmailVerifiedValRequest = false;
  bool hasMobileInput = false;
  bool hasEmailInput = false;
  bool hasInputPwd = false;
  @override
  void initState() {
    super.initState();
    this.curTab = Utility.isChina() ? 0 : 1;
    // this
    //     .tabBarGlobalKey
    //     .currentState
    //     ?.setChecked(this.curTab);
  }

  componentDidMount() {
    AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "view","description": "登录曝光",});
  }

  onClick(type, data) {
    switch (type) {
      case 'onClickBack':
        this.onClickBack();
        break;
      case 'onClickLogin':
        this.onClickLogin();
        break;
    }
  }

  onClickLogin() async {

    if (TextUtil.isEmpty(this.password)) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().please_input_password);
      return;
    }
    if (this.curTab == 0) {
      if (TextUtil.isEmpty(this.mobile)) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().please_input_mobile_no);
        return;
      }
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_button_login_mobile","description": "登录按钮",});
      LoginManager.getInstance()?.requestPasswordLogin(
          countryPhoneCode: this.countryPhoneCode,
          // email: this.email,
          mobile: this.mobile,
          password: this.password!,
          onComplete: this);
    } else {
      if (TextUtil.isEmpty(this.emailEncrypted)) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().please_input_email);
        return;
      }
      //邮箱登录
      String email = await Utility.decryptCTRAES(
          this.emailEncrypted ?? "", Params.AES_PWD);
      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_button_login_mobile","description": "登录按钮",});
      //从重置密码页面过来
      if(SharePreferenceUtil.getSyncInstance()
          .getBool(key: ShareprefrenceKeys.needResetPassword, defaultVal: false) == true) {
        //重置密码后要登录一次验证密码是否正确
        GoogleMailLoginManager.getInstance().login(email: email, password: await Utility.decryptCTRAES(
            this.password ?? "", Params.AES_PWD), callbackSuccess: () async {
          //重置密码 todo 有点风险
          await HttpManager.getInstance().doPostRequest(Apis.resetPwdByEmail, params: {
            "password": this.password,
            "email": this.emailEncrypted
          },
            context: context, );
          //请求邮箱密码登录
          SharePreferenceUtil.getSyncInstance()
              .setBool(key: ShareprefrenceKeys.needResetPassword, val: false);
          requestEmailPasswordLogin(email);
        }, callbackNeedVerified: () {
          Utility.pushReplacement(context ?? Utility.getGlobalContext(), RegisterEmailVerificationPage(pageFromEnum: PageFromEnum.RegisterPage, email: email ?? "", password: password ?? ""));
        }, callbackLoginFaile: (e) {
          Utility.showToastMsg(msg: e.message);
        });
      } else {
        //直接邮箱登录注册
        requestEmailPasswordLogin(email);
      }
    }
  }

  void requestEmailPasswordLogin(String email) {
    LoginManager.getInstance()?.requestPasswordLogin(
        email: email,
        password: this.password!,
        onComplete: this);
  }

  onClickBack() {
    Utility.popNavigator(context, null);
  }

  void resetForm() {
    _formKey.currentState!.reset();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  baseDesktoptBuild(BuildContext context) {
    // TODO: implement baseDesktoptBuild
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: leftGuideCarousel(),
            ),
            Expanded(flex: 1, child: getBody(context))
          ],
        ),
      ),
    );
  }

  Widget leftGuideCarousel() {
    return GuideViewPageWidget();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return getBody(context);
  }

  RawKeyboardListener getBody(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        onKey: (event) {
          // if (event.runtimeType == RawKeyDownEvent) {
          //   if (event.physicalKey == PhysicalKeyboardKey.enter) {
          //     this.onClick('onClickLogin', null);
          //   }
          // }
        },
        focusNode: FocusNode(),
        child: Container(
            color: ThemeManager.getInstance()
                .getBackgroundColor(defaultColor: Colors.white),
            child: Column(
              children: [
                TitleDescWidget(
                  title: getI18NKey().welcome,
                  desc: "",
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Utility.isHandsetBySize() ? 30 : 80),
                  child: ListView(
                    children: <Widget>[
                      CustomTabBarWidget(
                        key: tabBarGlobalKey,
                        list: tabList,
                      checkIndex: this.curTab,
                        onCheckedListener: (int index, CheckButtonStateModel model) {
                          this.curTab = index;
                          if(curTab == 0) {
                            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_switch_phone","description": "手机号切换按钮",});
                          } else {
                            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_switch_email","description": "邮箱切换按钮",});
                          }
                          updateUI();
                        },
                        fontSize: 14,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getInputTextField(),
                      SizedBox(
                        height: 10,
                      ),
                          TextFormField(
                            onChanged: (String text) async {
                              if (TextUtil.isEmpty(text) == true) {
                                this.password = "";
                                return;
                              }

                              if(hasInputPwd == false) {
                                hasInputPwd = true;
                                AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_input_password","description": "密码输入框",});
                              }
                              this.password = await Utility.encryptCTRAES(
                                  text, Params.AES_PWD);
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !this.checked,
                            //密码是否可见
                            textInputAction: TextInputAction.done,
                            controller: textController2,
                            // obscureText: false,
                            decoration: StylesConfig.getInputDecoration(
                                hintText: getI18NKey().password, suffixIcon: CheckImage(
                              //显示隐藏密码的眼睛
                              onTapListener: (isChecked) {
                                checked = !isChecked;
                                updateUI();
                              },
                              checked: checked,
                              autoCheck: true,
                              checkIcon: Utility.getSVGPicture(
                                  R.assetsImgIcEyeSlash,
                                  size: 20),
                              uncheckIcon: Utility.getSVGPicture(
                                  R.assetsImgIcEyeClose,
                                  size: 20),
                            )),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: ThemeManager.getInstance().getTextColor(
                                    defaultColor: Color(0xff8b97a2)),
                                fontWeight: FontWeight.w500),
                            validator: (value) => value!.isEmpty
                                ? getI18NKey().passwordNotEmpty
                                : null,
                            onSaved: (value) {
                              if (TextUtil.isEmpty(value) == true) {
                                password = "";
                                return;
                              }
                              password = value!.trim();
                            },
                          ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                          onTap: () {
                            this.onClick('onClickLogin', null);
                          },
                          child: new Container(
                            height: 45,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            alignment: Alignment.center,
                            // padding: EdgeInsets.fromLTRB(10.0, 45.0, 10.0, 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                  colors: ThemeManager.getInstance()
                                      .getButtonLinearGradientBackgroundColor()),
                            ),
                            child: new Text(this.curTab == 0 ? getI18NKey().login : getI18NKey().login_or_register,
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextButton(
                              //注册按钮
                              onPressed: () {
                                AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_button_register","description": "注册按钮",});
                                Utility.pushNavigator(
                                    context,  RegisterPage(curTab: this.curTab ?? 0, defaultVal: this.curTab == 0 ? (TextUtil.isEmpty(this.mobile) ? "" : ((Utility.decryptCTRAES(this.mobile ?? "" , Params.AES_PWD) ?? "") ?? "")) : (TextUtil.isEmpty(this.mobile) ? "" : (Utility.decryptCTRAES(this.emailEncrypted ?? "" , Params.AES_PWD) ?? "")),),
                                    // 从注册页返回的数据
                                    callback: (data) async {
                                  this.curTab = data['curTab'];
                                  this
                                      .tabBarGlobalKey
                                      .currentState
                                      ?.setChecked(data['curTab']);
                                  if (curTab == 1) {
                                    if (TextUtil.isEmpty(data['email']) ==
                                        true) {
                                      this.emailEncrypted = "";
                                      return;
                                    }
                                    if (data?['email'] != null) {
                                      this.emailEncrypted =
                                          await Utility.encryptCTRAES(
                                              data['email'], Params.AES_PWD);
                                      textController1Email =
                                          TextEditingController(
                                              text: data['email']);
                                    }
                                    updateUI();
                                  } else {
                                    if (TextUtil.isEmpty(data['mobile']) ==
                                        true) {
                                      this.mobile = "";
                                      return;
                                    }
                                    if (data?['mobile'] != null) {
                                      this.mobile = await Utility.encryptCTRAES(
                                          data['mobile'], Params.AES_PWD);
                                      textController1Phone =
                                          TextEditingController(
                                              text: data['mobile']);
                                    }
                                    updateUI();
                                  }
                                });
                              },
                              child: Text(
                                getI18NKey().register,
                                style: TextStyle(
                                    color: ColorsConfig.colorTextField),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          TextButton(
                              //注册按钮
                              onPressed: () {
                                AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_button_reset_password","description": "重置密码按钮",});
                                Utility.pushNavigator(
                                    context, ForgetPasswordPage(),
                                    callback: (data) async {
                                  this.curTab = data['curTab'];
                                  this
                                      .tabBarGlobalKey
                                      .currentState
                                      ?.setChecked(data['curTab']);
                                  if (curTab == 1) {
                                    if (TextUtil.isEmpty(data['email']) ==
                                        true) {
                                      this.emailEncrypted = "";
                                      return;
                                    }
                                    if (data?['email'] != null) {
                                      this.emailEncrypted =
                                          await Utility.encryptCTRAES(
                                              data['email'], Params.AES_PWD);
                                      textController1Email =
                                          TextEditingController(
                                              text: data['email']);
                                    }
                                    updateUI();
                                  } else {
                                    if (TextUtil.isEmpty(data['mobile']) ==
                                        true) {
                                      this.mobile = "";
                                      return;
                                    }
                                    if (data?['mobile'] != null) {
                                      this.mobile = await Utility.encryptCTRAES(
                                          data['mobile'], Params.AES_PWD);
                                      textController1Phone =
                                          TextEditingController(
                                              text: data['mobile']);
                                    }
                                  }
                                  updateUI();
                                });
                              },
                              child: Text(
                                getI18NKey().reset_pwd,
                                style: TextStyle(
                                    color: ColorsConfig.colorTextField),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ThirdPartyLoginWidget(
                        onTapGoogle: () {},
                        onTapFacebook: () {},
                      )
                    ],
                  ),
                )),
                if (Utility.isHandsetBySize() == false)
                  InkWell(
                    onTap: () {
                      AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_button_back","description": "返回按钮",});
                      Navigator.pop(context);
                    },
                    child: Text(
                      getI18NKey().back,
                      style: TextStyle(
                          color: ColorsConfig.colorTextField, fontSize: 14),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
              ],
            )));
  }

  Widget getInputTextField() {
    if (this.curTab == 0) {
      return getMobileInputTextField();
    } else {
      return getEmailInputTextField();
    }
  }

  getEmailInputTextField() {
    return TextFormField(
      onChanged: (String text) async {
        if (TextUtil.isEmpty(text) == true) {
          this.emailEncrypted = "";
          return;
        }
        if(hasEmailInput == false) {
          hasEmailInput = true;
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_input_email","description": "邮箱输入框",});
        }
        this.emailEncrypted = await Utility.encryptCTRAES(text, Params.AES_PWD);
      },
      // inputFormatters: [
      //   // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
      //   FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数
      // ],
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: textController1Email,
      // maxLength: 11,
      obscureText: false,
      onFieldSubmitted: (e) {
        this.onClick('onClickLogin', null);
      },
      //手机号输入
      decoration: StylesConfig.getInputDecoration(hintText: getI18NKey().email),
      style: TextStyle(
          fontFamily: 'Montserrat',
          color: ThemeManager.getInstance()
              .getTextColor(defaultColor: Color(0xff8b97a2)),
          fontWeight: FontWeight.w500),
      validator: (value) =>
          value!.isEmpty ? getI18NKey().emailCannotBeNull : null,
      onSaved: (value) {
        if (TextUtil.isEmpty(value) == true) {
          emailEncrypted = "";
          return;
        }
        emailEncrypted = value!.trim();
      },
    );
  }

  StatefulWidget getMobileInputTextField() {
    if (Utility.isGooglePlay() == true) {
      return IntlPhoneField(
        disableLengthCheck: true,
        searchText: getI18NKey().search_country,
        invalidNumberMessage: getI18NKey().invalid_mobile_number,
        autovalidateMode: AutovalidateMode.disabled,
        controller: textController1Phone,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          //数字包括小数
        ],
        // maxLength: 11,
        obscureText: false,
        textInputAction: TextInputAction.next,
        decoration:
            StylesConfig.getInputDecoration(hintText: getI18NKey().phoneNo),
        initialCountryCode: DeviceInfoManagement.getCountryCode(),
        onChanged: (phone) async {
          if(hasMobileInput == false) {
            hasMobileInput = true;
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_input_phone_number","description": "手机号输入框",});
          }
          this.countryIOSCode = phone.countryISOCode;
          this.countryPhoneCode = phone.countryCode;
          this.number = phone.number;
          this.completeNumber = phone.completeNumber;
          print(phone.completeNumber);
          if (TextUtil.isEmpty(this.number) == true) {
            this.mobile = "";
            return;
          }
          this.mobile =
              await Utility.encryptCTRAES(this.number ?? "", Params.AES_PWD);
          // print("111111");
        },
      );
    } else {
      return TextFormField(
        onChanged: (String text) async {
          if (TextUtil.isEmpty(text) == true) {
            this.mobile = "";
            return;
          }
          if(hasMobileInput == false) {
            hasMobileInput = true;
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({"sceneType": "LoginPage","eventType": "LoginPage_input_phone_number","description": "手机号输入框",});
          }
          this.mobile = await Utility.encryptCTRAES(text, Params.AES_PWD);
        },
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
          FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数
        ],
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        controller: textController1Phone,
        maxLength: 11,
        obscureText: false,
        onFieldSubmitted: (e) {
          this.onClick('onClickLogin', null);
        },
        //手机号输入
        decoration:
            StylesConfig.getInputDecoration(hintText: getI18NKey().phoneNo),
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: ThemeManager.getInstance()
                .getTextColor(defaultColor: Color(0xff8b97a2)),
            fontWeight: FontWeight.w500),
        validator: (value) =>
            value!.isEmpty ? getI18NKey().emailCannotBeNull : null,
        onSaved: (value) {
          if (TextUtil.isEmpty(value) == true) {
            mobile = "";
            return;
          }
          mobile = value!.trim();
        },
      );
    }
  }

  @override
  void loginFail(Map errorMsg, {LoginMode? loginMode}) async {
    // TODO: implement loginFail
    if (this.curTab == 1) {
      if (errorMsg['code'] == CONSTANTS.CODE_USER_NOT_EXIST) {
        String email = await Utility.decryptCTRAES(
            this.emailEncrypted ?? "", Params.AES_PWD);
        if (isEmailVerifiedValRequest == false) {
          LoginManager.getInstance().registerByEmail(
            context: context,
            email: email,
            password: this.password,
          );
          isEmailVerifiedValRequest = true;
          Future.delayed(Duration(seconds: 3), () {
            isEmailVerifiedValRequest = false;
          });
        }
      }
    } else {
      Utility.showToastMsg(msg: errorMsg);
    }
  }

  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    if (this.widget.pageFrom == PageFromEnum.ScreenLockPage) {
      SharePreferenceUtil.getSyncInstance().setString(
          key: ShareprefrenceKeys.default9DigitPasswords, content: "");
      // ScreenLockManager.getInstance().dismiss();
    }
    await LoginManager.getInstance()
        .handleLoginSuccess(context, jumpMode: this.widget.jumpMode);
  }

  @override
  void update(Observable o, BaseBean response, String scene) {
    // TODO: implement update
    if (response.success) {
      if (scene == Apis.login) {}
    } else {
      Utility.showToastMsg(msg: response.message);
    }
  }
}
