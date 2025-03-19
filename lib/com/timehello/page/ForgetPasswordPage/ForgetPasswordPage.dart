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
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/TitleDescWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/registerPage/pages/RegisterEmailVerificationPage.dart';
import 'package:time_hello/com/timehello/util/GoogleMailLoginManager.dart';
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

/**
 * 忘记密码页面
 */
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
  final _formKey = new GlobalKey<FormState>(); // 表单key
  TextEditingController? textController1; // 文本编辑器1
  TextEditingController? textController2; // 文本编辑器2
  String? mobile; // 手机号
  String? password; // 密码
  bool checked = false; // 是否选中

  String? countryIOSCode; // 国家IOS代码
  String? countryPhoneCode; // 国家电话代码
  String? mobileDecrypted; // 手机号解密
  String? completeNumber; // 完整号码
  String? _msn; // 短信验证码
  TimerUtil? _timerUtil; // 计时器
  int msnTotalTime = 60 * 1000; // 短信验证码总时间
  int msnCurTime = 0; // 短信验证码当前时间
  bool isBtnEnable = true; // 按钮是否启用
  int curTab = 0; // 当前tab
  List<CheckButtonStateModel> tabList =
      CONSTANTS.getLoginRegisterTabBarWidget(); // 标签列表
  String? email = ""; // 邮箱 

  @override
  void initState() {
    super.initState();
    if (Utility.isHandsetBySize()) {}
    _timerUtil = new TimerUtil(mCurTime: msnTotalTime);
    if(Utility.isChina()) {
      curTab = 0;
    } else {
      curTab = 1;
    }
    msnCurTime = msnTotalTime;
  }

  /**
   * 点击事件
   * type: 类型
   * data: 数据
   */
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

  /**
   * 点击重置密码
   */
  onClickResetPassword() async {
    if (this.curTab == 0) {
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
      if (TextUtil.isEmpty(this._msn)) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().inputSmsVerificationCode);
        return;
      }
      requestResPwd(
        mobile: mobile,
        countryPhoneCode: this.countryPhoneCode,
        password: this.password,
        dynamicCode: this._msn,
      );
    } else {
      if (Params.useGmail == false) {
        if (TextUtil.isEmpty(this.email)) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().please_input_mobile_no);
          return;
        }
        if (TextUtil.isEmpty(this.password)) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().please_input_password);
          return;
        }
        if (TextUtil.isEmpty(this._msn)) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().inputSmsVerificationCode);
          return;
        }
        requestResPwd(
          email: email,
          countryPhoneCode: this.countryPhoneCode,
          password: this.password,
          dynamicCode: this._msn,
        );
      } else {
        String email =
            await Utility.decryptCTRAES(this.email ?? "", Params.AES_PWD);
        GoogleMailLoginManager.getInstance().resetPassword(
            email: email,
            // password: await Utility.decryptCTRAES(
            //     this.password ?? "", Params.AES_PWD),
            callbackSuccess: () async {
              Utility.pushReplacement(
                  context ?? Utility.getGlobalContext(),
                  RegisterEmailVerificationPage(
                      pageFromEnum: PageFromEnum.ForgetPassword,
                      email: email ?? "",
                      password: password ?? ""));

              // Utility.popNavigator(context, {"curTab": 1, "email": email});
              //用于调用重启密码接口
              SharePreferenceUtil.getSyncInstance().setBool(
                  key: ShareprefrenceKeys.needResetPassword, val: true);
            },
            callbackFail: (e) {
              Utility.showToastMsg(context: context, msg: e.message);
            });
      }
    }
  }

  /**
   * 点击返回
   */
  onClickBack() {
    Utility.popNavigator(context, null);
  }

  /**
   * 重置表单
   */
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
            color: ThemeManager.getInstance()
                .getBackgroundColor(defaultColor: Colors.white),
            child: Column(
              children: [
                Utility.isHandsetBySize()
                    ? SizedBox.shrink()
                    : BackNavigator(
                        backColor: ThemeManager.getInstance().isDark()
                            ? Colors.white
                            : Colors.black,
                        onTapListener: (data) {
                          this.onClick('onClickBack', null);
                        }),
                // TitleDescWidget(
                //   title: getI18NKey().welcome,
                //   desc: "",
                // ),
                SizedBox(
                  height: 10,
                ),
                CustomTabBarWidget(
                  checkIndex: curTab,
                  list: tabList,
                  onCheckedListener: (int index, CheckButtonStateModel model) {
                    this.curTab = index;
                    updateUI();
                  },
                  fontSize: 14,
                ),

                Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 90,
                    child: getInputTextField()),
                if (this.curTab == 0 ||
                    (this.curTab == 1 && Params.useGmail == false))
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
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () async {
                                      requestGetDynamicCode(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        this.isBtnEnable == false
                                            ? Utility.parseTimestampToSeconds(
                                                    msnCurTime)
                                                .toString()
                                            : getI18NKey().getVerificationCode,
                                        style: TextStyle(
                                            color: ColorsConfig.colorTextField),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          labelText: getI18NKey().smsVerificationCode,
                          labelStyle: TextStyle(
                              color: Color(0xff8b97a2),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat'),
                          focusedBorder: StylesConfig.buildOutlineInputBorder(),
                          enabledBorder: StylesConfig.buildOutlineInputBorder(),
                          border: StylesConfig.buildOutlineInputBorder(),
                        ),
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
                    ],
                  ),
                if (this.curTab == 0 ||
                    (this.curTab == 1 && Params.useGmail == false))
                  TextFormField(
                    onChanged: (String text) async {
                      if (TextUtil.isEmpty(text) == true) {
                        this.password = "";
                        return;
                      }
                      this.password =
                          await Utility.encryptCTRAES(text, Params.AES_PWD);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !this.checked,
                    //密码是否可见
                    textInputAction: TextInputAction.done,
                    controller: textController2,
                    // obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
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
                              )),
                        ],
                      ),
                      labelText: getI18NKey().password,
                      labelStyle: TextStyle(
                          color: Color(0xff8b97a2),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat'),
                      focusedBorder: StylesConfig.buildOutlineInputBorder(),
                      enabledBorder: StylesConfig.buildOutlineInputBorder(),
                      border: StylesConfig.buildOutlineInputBorder(),
                    ),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff8b97a2),
                        fontWeight: FontWeight.w500),
                    validator: (value) =>
                        value!.isEmpty ? getI18NKey().passwordNotEmpty : null,
                    onSaved: (value) {
                      if (TextUtil.isEmpty(value) == true) {
                        password = "";
                        return;
                      }
                      password = value!.trim();
                    },
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
                )
              ],
            )));
  }

  /**
   * 请求重置密码
   * countryPhoneCode: 国家电话代码
   * mobile: 手机号
   * email: 邮箱
   * password: 密码
   * dynamicCode: 动态码
   */
  void requestResPwd({
    String? countryPhoneCode,
    String? mobile,
    String? email,
    String? password,
    String? dynamicCode,
  }) {
    HttpManager.getInstance().doPostRequest(Apis.resetPwd,
        params: {
          "countryPhoneCode": countryPhoneCode,
          "mobilePhoneNumber": mobile,
          "email": email,
          "password": password,
          "dynamicCode": dynamicCode,
          "scene": Params.MSN_FORGET_PWD
        },
        context: context,
        callback: (BaseBean response, String scene, bool isFromCache) {
      if (response.success == true) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().reset_pwd_successful);
        Future.delayed(
            Duration(seconds: 3),
            () => {
                  Utility.popNavigator(
                      context, {"curTab": 0, "mobile": this.mobileDecrypted})
                });
      }
    });
  }

  /**
   * 获取输入文本框
   */
  Widget getInputTextField() {
    if (this.curTab == 0) {
      return getMobileInputTextField();
    } else {
      return getEmailInputTextField();
    }
  }

  /**
   * 获取邮箱输入文本框
   */
  Widget getEmailInputTextField() {
    return TextFormField(
      onChanged: (String text) async {
        if (TextUtil.isEmpty(text) == true) {
          this.email = "";
          return;
        }
        this.email = await Utility.encryptCTRAES(text, Params.AES_PWD);
      },
      // inputFormatters: [
      //   // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
      //   FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数
      // ],
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: textController2,
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
          email = "";
          return;
        }
        email = value!.trim();
      },
    );
  }

  /**
   * 获取手机输入文本框
   */
  StatefulWidget getMobileInputTextField() {
    if (Utility.isGooglePlay() == true) {
      return IntlPhoneField(
          initialCountryCode: DeviceInfoManagement.getCountryCode(),
        languageCode: DeviceInfoManagement.getLanguage(),
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
          focusedBorder: StylesConfig.buildOutlineInputBorder(),
          enabledBorder: StylesConfig.buildOutlineInputBorder(),
          border: StylesConfig.buildOutlineInputBorder(),
        ),
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
          this.mobile = await Utility.encryptCTRAES(
              this.mobileDecrypted ?? "", Params.AES_PWD);
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
          focusedBorder: StylesConfig.buildOutlineInputBorder(),
          enabledBorder: StylesConfig.buildOutlineInputBorder(),
          border: StylesConfig.buildOutlineInputBorder(),
        ),
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

  /**
   * 请求获取动态码
   * context: 上下文
   */
  Future<BaseBean> requestGetDynamicCode(BuildContext context) async {
    if (this.curTab == 0) {
      BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
        Apis.getDynamicCode,
        context: context,
        shouldShowErrorToast: true,
        params: {
          "scene": Params.MSN_FORGET_PWD,
          "countryPhoneCode": this.countryPhoneCode,
          "mobilePhoneNumber": this.mobile,
        },
      );
      if (baseBean.success == true) {
        startTimer();
      }
      return baseBean;
    } else {
      BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
        Apis.getEmailDynamicCode,
        context: context,
        shouldShowErrorToast: true,
        params: {
          "scene": Params.MSN_FORGET_PWD,
          "countryPhoneCode": this.countryPhoneCode,
          "email":
              await Utility.decryptCTRAES(this.email ?? "", Params.AES_PWD),
        },
      );
      if (baseBean.success == true) {
        startTimer();
      }
      return baseBean;
    }
  }

  /**
   * 开始计时
   */
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

  /**
   * 登录失败
   * errorMsg: 错误信息
   * loginMode: 登录模式
   */
  @override
  void loginFail(Map errorMsg, {LoginMode? loginMode}) {
    // TODO: implement loginFail
    Utility.showToastMsg(msg: errorMsg);
  }

  /**
   * 登录成功
   * loginInfoModel: 登录信息模型
   */
  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    // await LoginManager.getInstance()
    //     .handleLoginSuccess(context, jumpMode: this.widget.jumpMode);
  }

  /**
   * 更新
   * o: 观察者
   * response: 响应
   * scene: 场景
   */
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
