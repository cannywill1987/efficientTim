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
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/loginPage/components/GuideViewPageWidget.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/LoginUtil.dart';
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
  String? _mobileDecrypted;
  String? _dynamicCode;
  String? _password;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    super.initState();
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
    LoginManager.getInstance().register(
        mobile: this._mobile,
        password: this._password,
        dynamicCode: this._dynamicCode,
        countryPhoneCode: this.countryPhoneCode,
        onComplete: this);
    // }
  }

  onClickBack() {
    if (_crossFadeState == CrossFadeState.showSecond) {
      showRegisterStep1();
    } else {
      Utility.popNavigator(context, null);
    }
  }

  void resetForm() {}

  void showRegisterStep1() {
    setState(() {
      _crossFadeState = CrossFadeState.showFirst;
    });
  }

  void showRegisterStep2() {
    setState(() {
      _crossFadeState = CrossFadeState.showSecond;
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
                        onTapListener: (String? countryPhoneCode, String? mobile) {
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
                        onTapListener: (data) async {
                          this._dynamicCode = data['msn'];
                          this._password = data['password']; //已经加密
                          this.onClick('onClickRegister', null);
                        }),
                    crossFadeState: _crossFadeState,
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
    Utility.showToastMsg(msg: errorMsg);
  }

  @override
  void loginSuccess({UserBean? loginInfoModel}) async {
    // TODO: implement loginSuccess
    await LoginManager.getInstance().handleLoginSuccess(context);

    // Utility.pushAndRemoveUntil(context, MainContainerWidget(), 'MainContainerWidget');
    // Utility.pushAndRemoveUntil(context, MainContainerWidget2(), 'BottomTabBarHome');
  }



  @override
  void update(Observable o, BaseBean response, String scene) async {
    // TODO: implement update
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
        Utility.popNavigator(context, {"mobile": _mobileDecrypted});
      }
    }
  }
}
