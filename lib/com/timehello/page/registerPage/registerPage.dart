import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/Oberver.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/components/BackNavigator.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/LoadingDialogUtil.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/loginPage/components/GuideViewPageWidget.dart';
import 'package:time_hello/com/timehello/page/registerPage/pages/RegisterEmailVerificationPage.dart';
import 'package:time_hello/com/timehello/util/EditFormat.dart';
import 'package:time_hello/com/timehello/util/GoogleMailLoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../util/EasyLoadingManager.dart';
import 'components/registerStep1.dart';
import 'components/registerStep2.dart';

GlobalKey<RegisterStep2State> mRegisterStep2GK = GlobalKey();
GlobalKey<RegisterStep1State> mRegisterStep1GK = GlobalKey();

class RegisterPage extends BaseWidget {
  const RegisterPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends BaseWidgetState<RegisterPage>
    implements LoginResult, Observer {
  TextEditingController? textController1;
  TextEditingController? textController2;
  String? countryPhoneCode;
  String? _mobile;
  String? _email;
  String? _mobileDecrypted;
  String? _dynamicCode;
  String? _password;
  CrossFadeState curRegisterPage = CrossFadeState.showFirst;
  int curTab = 0;
  bool isEmailVerifiedValRequest=false;
  // bool isLoading = false;
  @override
  void initState() {
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    super.initState();
  }

  dispose() {
    try {
      textController1?.dispose();
      textController2?.dispose();
    } catch(e) {

    }
    // GoogleMailLoginManager.getInstance().cancelTimer();
    super.dispose();
  }

  onClick(type, data) {
    switch (type) {
      case 'onClickBack':
        this.onClickBack();
        break;
      case 'onClickRegister':
        this.onClickRegister();
        break;
    }
  }

  onClickRegister() async {
    // Map res;
    // res = await MongoApisManager.getInstance()
    //     .register(this._mobile, this._password);
    // if (res['success'] == true) {
    if(curTab == 0) {
      if (TextUtil.isEmpty(this._mobile.toString())) {
        Utility.showToastMsg(msg: getI18NKey().input_mobile);
        return;
      }
      // if (TextUtil.isEmpty(emailStr)) {
      //   Utility.showToastMsg(msg: getI18NKey().please_input_email);
      //   return mLoginManager!;
      // }
      if (EditFormat.getNoblanKString(this._mobile ?? "").length < 11) {
        Utility.showToastMsg(msg: getI18NKey().input_correct_mobile);
        return;
      }
    LoginManager.getInstance().register(
        mobile: this._mobile,
        password: this._password,
        dynamicCode: this._dynamicCode,
        countryPhoneCode: this.countryPhoneCode,
        onComplete: this);
    } else {
      String email = await Utility.decryptCTRAES(this._email ?? "", Params.AES_PWD);
      if(isEmailVerifiedValRequest == false) {
        LoginManager.getInstance().registerByEmail(
          context: context,
          email: email,
          password: this._password,
        );
        isEmailVerifiedValRequest = true;
        Future.delayed(Duration(seconds: 3), () {
          isEmailVerifiedValRequest = false;
        });
      }
      // GoogleMailLoginManager.getInstance().signIn(email: email, password: this._password, callbackSuccess: () {
      //   Utility.pushReplacement(context, RegisterEmailVerificationPage(pageFromEnum: PageFromEnum.RegisterPage, email: email, password: this._password ?? ""));
      // });

    }
  }

  onClickBack() {
    if (curRegisterPage == CrossFadeState.showSecond) {
      showRegisterStep1();
    } else {
      Utility.popNavigator(context, null);
    }
  }

  void resetForm() {}

  void showRegisterStep1() {
    setState(() {
      curRegisterPage = CrossFadeState.showFirst;
    });
  }

  void showRegisterStep2() {
    setState(() {
      curRegisterPage = CrossFadeState.showSecond;
    });
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

  Column getBody(BuildContext context) {
    return Column(
      children: [
        // Utility.isHandsetBySize()
        //     ? SizedBox.shrink()
        //     : BackNavigator(onTapListener: (data) {
        //         this.onClick('onClickBack', null);
        //       }),
        Expanded(
            child: Container(
                constraints: BoxConstraints.expand(height: double.infinity),
                color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
                child: AnimatedCrossFade(
                    firstChild: RegisterStep1(
                        key: mRegisterStep1GK,
                        onTapListener: (String? countryPhoneCode, String? mobile, String? email, int curTab) async {
                          this.curTab = curTab;
                          if(curTab == 0) {
                            EasyLoadingManager.getInstance().showLoading();
                            HttpManager.getInstance().doPostRequest(
                                Apis.getDynamicCode,
                                context: context,
                                params: {
                                  "countryPhoneCode":this.countryPhoneCode,
                                  "mobilePhoneNumber": this._mobile,
                                  "scene": Params.MSN_REGISTER_SCENE
                                },
                                observer: this);
                          } else {
                            this._email = email;
                            String emailP = await Utility.decryptCTRAES(this._email ?? "", Params.AES_PWD);
                            bool isEmailExist = await GoogleMailLoginManager.getInstance().isEmailExistFromServer(email: emailP);
                            if(isEmailExist == true) {
                              // Utility.showToastMsg(msg: getI18NKey().email_exist);
                              Utility.popNavigator(context, {"curTab":1,"email": emailP});
                              return;
                            }
                            this.showRegisterStep2();
                          }
                          // if(TextUtil.isEmpty(email))

                          // MongoApisManager.getInstance().sendSms(_mobile);
                        },
                        onChanged: (countryPhoneCode, mobile) async {
                          this.countryPhoneCode = countryPhoneCode;
                          this._mobileDecrypted = mobile;
                          this._mobile =
                              await Utility.encryptCTRAES(mobile, Params.AES_PWD);
                        }),
                    secondChild: RegisterStep2(
                        key: mRegisterStep2GK,
                        curTab: this.curTab,
                        onTapListener: (data) async {
                          this._dynamicCode = data['msn'];
                          this._password = data['password']; //已经加密
                          this.onClick('onClickRegister', null);
                        }),
                    crossFadeState: curRegisterPage,
                    duration: Duration(microseconds: 1000)))),
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
    );
  }

  @override
  void loginFail(Map errorMsg, {LoginMode? loginMode}) {
    // TODO: implement loginFail
    // if(isLoading == true) {
    //   isLoading = false;
    //   LoadingDialogUtil.getInstance().hide();
    // }    Utility.showToastMsg(msg: errorMsg);
  }

  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    // if(isLoading == true) {
    //   isLoading = false;
    // LoadingDialogUtil.getInstance().hide();
    // }
    await LoginManager.getInstance().handleLoginSuccess(context);

    // Utility.pushAndRemoveUntil(context, MainContainerWidget(), 'MainContainerWidget');
    // Utility.pushAndRemoveUntil(context, MainContainerWidget2(), 'BottomTabBarHome');
  }



  @override
  void update(Observable o, BaseBean response, String scene) async {
    // TODO: implement update
    // if(isLoading == true) {
    //   isLoading = false;
    //   LoadingDialogUtil.getInstance().hide();
    // }
     await EasyLoadingManager.getInstance().hideLoading();
    if (response.success) {
      if (scene == Apis.getDynamicCode) {
        this.showRegisterStep2();
        mRegisterStep2GK.currentState?.startTimer();
      }
    } else {
      //用户已经存在 返回上一页 注入手机号
      Utility.showToastMsg(msg: response.message);
      if (response.code == '0000D2DE') {
        Utility.popNavigator(context, {"curTab":0,"mobile": _mobileDecrypted});
      }
    }
  }
}
