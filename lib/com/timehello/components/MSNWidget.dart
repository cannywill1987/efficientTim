import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/TitleDescWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/TimerUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../common/httpclient/HttpManager.dart';
import '../util/LoginManager.dart';
import '../util/ThemeManager.dart';

class MSNWidget extends StatefulWidget {
  Function? onTapListener;

  MSNWidget({
    Key? key,
     Function? onTapListener,
  }) : super(key: key) {
    this.onTapListener = onTapListener;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MSNWidgetState();
  }
}

class MSNWidgetState extends State<MSNWidget> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  String _msn = "";
  String _password = "";
  final _formKey = new GlobalKey<FormState>();
  TimerUtil? _timerUtil;
  bool? isBtnEnable = false;
  int? msnTotalTime = 60 * 1000;
  int? msnCurTime;
  bool checked = true;

  MSNWidgetState() {
    _timerUtil = new TimerUtil(mCurTime: msnTotalTime);
    msnCurTime = msnTotalTime;
  }

  @override
  void initState() {
    this.requestGetDynamicCode(context);

    // this.startTimer();
  } // Check if form is valid before perform login or signup

  void startTimer() {
    if (!(_timerUtil?.isActive() ?? true)) {
      _timerUtil?.setOnTimerTickCallback(
          (curTime, int totalTime, int timeUsed, bool isFirstTime) {
        if (curTime > 0) {
          this.setState(() {
            msnCurTime = curTime;
            this.isBtnEnable = false;
          });
        } else {
          this.setState(() {
            _timerUtil
                ?.updateTotalTimeAndStartCountDown(msnCurTime = (msnTotalTime ?? 0));
            msnCurTime = curTime;
            this.isBtnEnable = true;
          });
        }
      });
      _timerUtil?.startCountDown();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (this._timerUtil != null) {
      this._timerUtil?.cancel();
      this._timerUtil = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event.data.physicalKey == PhysicalKeyboardKey.enter) {
            if (this.widget.onTapListener != null) {
              this.widget.onTapListener!(
                  {"msn": this._msn, "password": this._password});
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column( children: <Widget>[
              // TextButton(onPressed: () {}, child: Text('f', style: TextStyle(color:Colors.white),))
              // Text(getI18NKey().please_finish_msn,
              //     style: TextStyle(color: Color(0xff404040)),
              //     textAlign: TextAlign.center),
              if(!LoginManager.getInstance().isEmailAccount())
              Container(
                // decoration: BoxDecoration(
                //     border: Border.all(
                //         color: ColorsConfig.colorTextField, width: 1),
                //     borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4),)),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
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
                        validator: (value) => value?.isEmpty == true
                            ? getI18NKey().emailCannotBeNull
                            : null,
                        onSaved: (value) {
                           _msn = value?.trim() ?? "";
                        },
                      ),
                    ),
                    // Container(color: Colors.white, width: ,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.transparent, width: 1),
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
                                  ? Utility.parseTimestampToSeconds(msnCurTime ?? 0)
                                      .toString()
                                  : getI18NKey().getVerificationCode,
                              style:
                                  TextStyle(color: ColorsConfig.colorTextField),
                            )),
                      ),
                    ),
                  ],
                ),
              ),

              //输入 密码
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Stack(children: [
                    TextFormField(
                      onChanged: (String txt) async {
                        this._password =
                            await Utility.encryptCTRAES(txt, Params.AES_PWD);
                      },
                      controller: textController2,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: this.checked ?? false,
                      //密码是否可见
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          labelText: getI18NKey().password,
                          labelStyle: TextStyle(
                              color: Color(0xff8b97a2),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat'),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeManager.getInstance().getInputBorderColor(defaultColor: ColorsConfig.colorTextField), width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeManager.getInstance().getInputBorderColor(defaultColor: ColorsConfig.colorTextField), width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0)))),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xff8b97a2),
                          fontWeight: FontWeight.w500),
                      validator: (value) =>
                          value?.isEmpty == true ? getI18NKey().passwordNotEmpty : null,
                      onSaved: (value) => _password = value?.trim() ?? "" ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Align(
                          alignment: Alignment(1, 1),
                          child: CheckImage(
                            onTapListener: (isChecked) {
                              checked = isChecked;
                              setState(() {});
                            },
                            checked: !checked,
                            autoCheck: true,
                            checkIcon: Utility.getSVGPicture(
                                R.assetsImgIcEyeSlash,
                                size: 30),
                            uncheckIcon: Utility.getSVGPicture(
                                R.assetsImgIcEyeClose,
                                size: 30),
                          )),
                    ),
                  ])),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: ColorsConfig.gray_bg,
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            if (this.widget.onTapListener != null) {
                              this.widget.onTapListener!({
                                "msn": this._msn,
                                "password": this._password
                              });
                            }
                          },
                          child: Text(getI18NKey().unregister,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Color(0xff61c37d),
                                  fontSize: 15)))),
                  Container(
                    width: 1,
                    height: 40,
                    color: ColorsConfig.gray_bg,
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            getI18NKey().unregister_temp,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Color(0xff61c37d),
                                fontSize: 15),
                          )))
                ],
              )
            ])));
  }


  requestGetDynamicCode(BuildContext context) async {
    if(LoginManager.getInstance().isEmailAccount()){
      return;
    }
    BaseBean baseBean = await HttpManager.getInstance().doPostRequest(
      Apis.getDynamicCode,
      context: context,
      shouldShowErrorToast: true,
      params: {"scene": Params.MSN_UNREGISTER_SCENE},
    );
    if (baseBean.success == true) {
      startTimer();
    }
  }

  // bool isEmailAccount() => LoginManager.getInstance().userBean.email == null || LoginManager.getInstance().userBean.email!.isEmpty;
}
