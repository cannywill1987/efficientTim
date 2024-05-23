import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/components/BackNavigator.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/TitleDescWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/page/ForgetPasswordPage/ForgetPasswordPage.dart';
import 'package:time_hello/com/timehello/page/loginPage/components/GuideViewPageWidget.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginUtil.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../components/ThirdPartyLoginWidget.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/ThemeManager.dart';
import '../registerPage/registerPage.dart';
import 'components/Guide1Widget.dart';
import 'components/Guide2Widget.dart';

class LoginPage extends BaseWidget {
  final JumpModeEnum jumpMode;
  final PageFromEnum pageFrom;
  const LoginPage({this.pageFrom: PageFromEnum.Default, this.jumpMode = JumpModeEnum.pushMode});

  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return new _LoginPageState();
  }
}

class _LoginPageState extends BaseWidgetState<LoginPage>
    implements LoginResult, Observer {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController? textController1;
  TextEditingController? textController2;
  String? mobile;
  String? password;
  bool checked = false;
  bool isMobileVisible = false;
  String? countryIOSCode;
  String? countryPhoneCode;
  String? number;
  String? completeNumber;

  @override
  void initState() {
    super.initState();
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

  onClickLogin() {
    if (TextUtil.isEmpty(this.mobile)) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().please_input_mobile_no);
      return;
    }
    if (TextUtil.isEmpty(this.password)) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().please_input_password);
      return;
    }
    LoginManager.getInstance()?.requestPasswordLogin(
        countryPhoneCode: this.countryPhoneCode,
        mobile: this.mobile!,
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
                SizedBox(height: 30,),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Utility.isHandsetBySize() ? 30 : 80),
                  child: ListView(
                    children: <Widget>[
                      getInputTextField(),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          TextFormField(
                            onChanged: (String text) async {
                              if (TextUtil.isEmpty(text) == true) {
                                this.password = "";
                                return;
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
                            decoration:
                            StylesConfig.getInputDecoration(hintText: getI18NKey().password),
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
                          Positioned(
                            right: 10,
                            top: 12,
                            // padding: EdgeInsets.only(top: 15),
                            child: CheckImage(
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
                            ),
                          ),
                        ],
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
                            child: new Text(getI18NKey().login,
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
                                Utility.pushNavigator(
                                    context, const RegisterPage(),
                                    callback: (data) async {
                                  if (TextUtil.isEmpty(data['mobile']) ==
                                      true) {
                                    this.mobile = "";
                                    return;
                                  }
                                  if (data?['mobile'] != null) {
                                    this.mobile = await Utility.encryptCTRAES(
                                        data['mobile'], Params.AES_PWD);
                                    textController1 = TextEditingController(
                                        text: data['mobile']);
                                  }
                                  updateUI();
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
                                Utility.pushNavigator(
                                    context, ForgetPasswordPage(),
                                    callback: (data) async {
                                  if (TextUtil.isEmpty(data['mobile']) ==
                                      true) {
                                    this.mobile = "";
                                    return;
                                  }
                                  if (data?['mobile'] != null) {
                                    this.mobile = await Utility.encryptCTRAES(
                                        data['mobile'], Params.AES_PWD);
                                    textController1 = TextEditingController(
                                        text: data['mobile']);
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
                InkWell(
                  onTap: () {
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
    if (Utility.isGooglePlay() == true) {
      return IntlPhoneField(
        disableLengthCheck: true,
        searchText: getI18NKey().search_country,
        invalidNumberMessage: getI18NKey().invalid_mobile_number,
        autovalidateMode: AutovalidateMode.disabled,
        controller: textController1,
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
          this.mobile = await Utility.encryptCTRAES(text, Params.AES_PWD);
        },
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
          FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数
        ],
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        controller: textController1,
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
  void loginFail(Map errorMsg, {LoginMode? loginMode}) {
    // TODO: implement loginFail
    Utility.showToastMsg(msg: errorMsg);
  }

  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    if(this.widget.pageFrom == PageFromEnum.ScreenLockPage) {
      SharePreferenceUtil.getSyncInstance().setString(key: ShareprefrenceKeys.default9DigitPasswords, content: "");
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
