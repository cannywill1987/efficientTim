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
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginUtil.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../components/ThirdPartyLoginWidget.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/ThemeManager.dart';
import '../../util/TimerUtil.dart';
import '../registerPage/registerPage.dart';

class ForgetPasswordPage extends BaseWidget {
  ForgetPasswordPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return new _ForgetPasswordPageState();
  }
}

class _ForgetPasswordPageState extends BaseWidgetState<ForgetPasswordPage>
    implements LoginResult, Observer {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController? textController1;
  TextEditingController? textController2;
  String? mobile;
  String? password;
  bool checked = false;

  String? countryIOSCode;
  String? countryPhoneCode;
  String? mobileDecrypted;
  String? completeNumber;
  String? _msn;
  TimerUtil? _timerUtil;
  int msnTotalTime = 60 * 1000;
  int msnCurTime = 0;
  bool isBtnEnable = true;

  @override
  void initState() {
    super.initState();
    _timerUtil = new TimerUtil(mCurTime: msnTotalTime);
    msnCurTime = msnTotalTime;
  }

  onClick(type, data) {
    switch (type) {
      case 'onClickBack':
        this.onClickBack();
        break;
      case 'onClickResetPwd':
        this.onClickResetPassword();
        break;
    }
  }

  onClickResetPassword() {
    if (TextUtil.isEmpty(this.mobile)) {
      Utility.showToast(
          context: context, msg: getI18NKey().please_input_mobile_no);
      return;
    }
    if (TextUtil.isEmpty(this.password)) {
      Utility.showToast(
          context: context, msg: getI18NKey().please_input_password);
      return;
    }
    if (TextUtil.isEmpty(this._msn)) {
      Utility.showToast(
          context: context, msg: getI18NKey().inputSmsVerificationCode);
      return;
    }
    requestResPwd(mobile: mobile, countryPhoneCode: this.countryPhoneCode, password: this.password, dynamicCode: this._msn,);
  }

  onClickBack() {
    Utility.popNavigator(context, null);
  }

  void resetForm() {
    _formKey.currentState!.reset();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent) {
            if (event.physicalKey == PhysicalKeyboardKey.enter) {
              this.onClick('onClickLogin', null);
            }
          }
        },
        focusNode: FocusNode(),
        child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            color: Colors.white,
            child: Column(
              children: [
                Utility.isHandsetBySize()
                    ? SizedBox.shrink()
                    : BackNavigator(
                    title: getI18NKey().reset_pwd,
                    backColor: Colors.black,
                    onTapListener: (data) {
                      this.onClick('onClickBack', null);
                    }),
                Utility.isHandsetBySize()
                    ? SizedBox.shrink()
                    : BackNavigator(
                        backColor: Colors.white,
                        onTapListener: (data) {
                          this.onClick('onClickBack', null);
                        }),
                // TitleDescWidget(
                //   title: getI18NKey().welcome,
                //   desc: "",
                // ),
                Container(margin: EdgeInsets.only(top:30), height: 90, child: getInputTextField()),
                SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                TextFormField(
                  onChanged: (String txt) {
                    this._msn = txt;
                  },
                  controller: textController1,
                  maxLength: 6,
                  obscureText: false,
                  decoration: InputDecoration(
                      labelText: getI18NKey().smsVerificationCode,
                      labelStyle: TextStyle(
                          color: Color(0xff8b97a2),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeManager.getInstance().getInputBorderColor(defaultColor: ColorsConfig.colorTextField),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeManager.getInstance().getInputBorderColor(defaultColor: ColorsConfig.colorTextField),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0)))),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff8b97a2),
                      fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.phone,
                  validator: (value) => TextUtil.isEmpty(value)
                      ? getI18NKey().emailCannotBeNull
                      : null,
                  // onSaved: (value) {
                  //   return _msn = value?.trim() ?? "";
                  // },
                ),
                // Container(color: Colors.white, width: ,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        )),
                    width: 140,
                    child: TextButton(
                        onPressed: () async {
                          requestGetDynamicCode(context);
                        },
                        child: Text(
                          this.isBtnEnable == false
                              ? Utility.parseTimestampToSeconds(
                                      msnCurTime)
                                  .toString()
                              : getI18NKey().getVerificationCode,
                          style: TextStyle(
                              color: ColorsConfig.colorTextField),
                        )),
                  ),
                ),
                  ],
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
                  decoration: InputDecoration(
                      labelText: getI18NKey().password,
                      labelStyle: TextStyle(
                          color: Color(0xff8b97a2),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeManager.getInstance().getInputBorderColor(defaultColor: ColorsConfig.colorTextField),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeManager.getInstance().getInputBorderColor(defaultColor: ColorsConfig.colorTextField),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0)))),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff8b97a2),
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
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Align(
                      alignment: Alignment(1, 1),
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
                            size: 30),
                        uncheckIcon: Utility.getSVGPicture(
                            R.assetsImgIcEyeClose,
                            size: 30),
                      )),
                ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                onTap: () {
                  this.onClick('onClickResetPwd', null);
                },
                child: new Container(
                  height: 45,
                  alignment: Alignment.center,
                  // padding: EdgeInsets.fromLTRB(10.0, 45.0, 10.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                        colors: ColorsConfig
                            .listColorsOrangeLightToHeavyButton),
                  ),
                  child: new Text(getI18NKey().reset_pwd,
                      style: new TextStyle(
                          fontSize: 20.0, color: Colors.white)),
                )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                )],
            )));
  }

  void requestResPwd({
    String? countryPhoneCode,
    String? mobile,
    String? password,
    String? dynamicCode,
  }) {
    HttpManager.getInstance().doPostRequest(Apis.resetPwd,
        params: {
          "countryPhoneCode": countryPhoneCode,
          "mobilePhoneNumber": mobile,
          "password": password,
          "dynamicCode": dynamicCode,
          "scene": Params.MSN_FORGET_PWD
        },
        context: context,
        callback: (BaseBean response, String scene, bool isFromCache) {
      if (response.success == true) {
        Utility.showToast(context: context, msg: getI18NKey().reset_pwd_successful);
        Future.delayed(Duration(seconds: 3), () => {
          Utility.popNavigator(context, {"mobile": this.mobileDecrypted})
        });
      }
    });
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
        decoration: InputDecoration(
            labelText: getI18NKey().phoneNo,
            labelStyle: TextStyle(
                color: Color(0xff8b97a2),
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat'),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ColorsConfig.colorTextField, width: 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ColorsConfig.colorTextField, width: 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)))),
        initialCountryCode: DeviceInfoManagement.getCountryCode(),
        onChanged: (phone) async {
          this.countryIOSCode = phone.countryISOCode;
          this.countryPhoneCode = phone.countryCode;
          this.mobileDecrypted = phone.number;
          this.completeNumber = phone.completeNumber;
          print(phone.completeNumber);
          if (TextUtil.isEmpty(this.mobileDecrypted) == true) {
            this.mobile = "";
            return;
          }
          this.mobile =
              await Utility.encryptCTRAES(this.mobileDecrypted ?? "", Params.AES_PWD);
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
        //手机号输入
        decoration: InputDecoration(
            labelText: getI18NKey().phoneNo,
            labelStyle: TextStyle(
                color: Color(0xff8b97a2),
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat'),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ColorsConfig.colorTextField, width: 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ColorsConfig.colorTextField, width: 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)))),
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xff8b97a2),
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

  Future<BaseBean> requestGetDynamicCode(BuildContext context) async {
    BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
      Apis.getDynamicCode,
      context: context,
      shouldShowErrorToast: true,
      params: {"scene": Params.MSN_FORGET_PWD, "countryPhoneCode":this.countryPhoneCode,
        "mobilePhoneNumber": this.mobile,},
    );
    if (baseBean.success == true) {
      startTimer();
    }
    return baseBean;
  }

  void startTimer() {
    if (!_timerUtil!.isActive()) {
      _timerUtil!.setOnTimerTickCallback(
          (curTime, int totalTime, int timeUsed, bool isFirstTime) {
        if (curTime > 0) {
          this.setState(() {
            msnCurTime = curTime;
            this.isBtnEnable = false;
          });
        } else {
          this.setState(() {
            _timerUtil!
                .updateTotalTimeAndStartCountDown(msnCurTime = msnTotalTime);
            msnCurTime = curTime;
            this.isBtnEnable = true;
          });
        }
      });
      _timerUtil!.startCountDown();
    }
  }

  @override
  void loginFail(Map errorMsg, {LoginMode? loginMode}) {
    // TODO: implement loginFail
    Utility.showToast(msg: errorMsg);
  }

  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    // await LoginManager.getInstance()
    //     .handleLoginSuccess(context, jumpMode: this.widget.jumpMode);
  }

  @override
  void update(Observable o, BaseBean response, String scene) {
    // TODO: implement update
    if (response.success) {
      if (scene == Apis.login) {}
    } else {
      Utility.showToast(msg: response.message);
    }
  }
}
