import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/TitleDescWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/TimerUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../util/ThemeManager.dart';

class RegisterStep2 extends StatefulWidget {
  Function? onTapListener;
  int curTab = 0; // 0 手机号注册 1 邮箱
  RegisterStep2({
    Key? key,
    this.curTab = 0,
    Function? onTapListener,
  }) : super(key: key) {
    this.onTapListener = onTapListener;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterStep2State();
  }
}

class RegisterStep2State extends State<RegisterStep2> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  String? _msn;
  String? _password;
  final _formKey = new GlobalKey<FormState>();
  TimerUtil? _timerUtil;
  bool? isBtnEnable = false;
  int msnTotalTime = 60 * 1000;
  int msnCurTime = 0;
  bool checked = true;

  RegisterStep2State() {
    _timerUtil = new TimerUtil(mCurTime: msnTotalTime);
    msnCurTime = msnTotalTime;
  }

  @override
  void initState() {
    // this.startTimer();
  } // Check if form is valid before perform login or signup

  void startTimer() {
    if (_timerUtil?.isActive() == false) {
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
                ?.updateTotalTimeAndStartCountDown(msnCurTime = msnTotalTime);
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
          return KeyEventResult.ignored;
        },
        child: Container(
            padding: EdgeInsets.only(left: 60, right: 60),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                // TextButton(onPressed: () {}, child: Text('f', style: TextStyle(color:Colors.white),))
                SizedBox(
                  height: 40,
                ),
                TitleDescWidget(
                  title: getI18NKey().welcome,
                  desc: getI18NKey().registerStep2,
                ),
                SizedBox(
                  height: 40,
                ),
                if(this.widget.curTab == 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onChanged: (String txt) {
                                this._msn = txt;
                              },
                              controller: textController1,
                              maxLength: 6,
                              obscureText: false,
                              decoration:
                              StylesConfig.getInputDecoration(hintText: getI18NKey().smsVerificationCode),
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor: Color(0xff8b97a2)),
                                  fontWeight: FontWeight.w500),
                              keyboardType: TextInputType.phone,
                              validator: (value) => TextUtil.isEmpty(value)
                                  ? getI18NKey().emailCannotBeNull
                                  : null,
                              onSaved: (value) {
                                _msn = value?.trim();
                              },
                            ),
                            ABTestSetting.isRegisterDynamicCode == true
                                ? Text(
                                    '请先输入短信验证码验证:12345',
                                    style: TextStyle(fontSize: 12),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                      // Container(color: Colors.white, width: ,),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.transparent, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        // width: 140,
                        child: TextButton(
                            onPressed: () {
                              startTimer();
                            },
                            child: Text(
                              this.isBtnEnable == false
                                  ? Utility.parseTimestampToSeconds(msnCurTime)
                                      .toString()
                                  : getI18NKey().getVerificationCode,
                              style: TextStyle(
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor:
                                              ColorsConfig.colorTextField)),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Stack(children: [
                      TextFormField(
                        onChanged: (String txt) async {
                          this._password =
                              await Utility.encryptCTRAES(txt, Params.AES_PWD);
                        },
                        controller: textController2,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: this.checked,
                        //密码是否可见
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (v) {
                          if (this.widget.onTapListener != null) {
                            this.widget.onTapListener!(
                                {"msn": this._msn, "password": this._password});
                          }
                        },
                        decoration:

                        InputDecoration(
                            labelText: getI18NKey().password,
                            labelStyle: TextStyle(
                                color: Color(0xff8b97a2),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat'),
                          border: StylesConfig.borderSide,
                          enabledBorder:StylesConfig.enableBorderSide,
                          focusedBorder:StylesConfig.focusBorderSide,
                          filled: true,
                          fillColor: StylesConfig.filledInputColor,),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Color(0xff8b97a2)),
                            fontWeight: FontWeight.w500),
                        validator: (value) => TextUtil.isEmpty(value)
                            ? getI18NKey().passwordNotEmpty
                            : null,
                        onSaved: (value) => _password = value?.trim(),
                      ),
                      Positioned(
                        right: 10,
                        top: 12,
                        child: CheckImage(
                          onTapListener: (isChecked) {
                            checked = isChecked;
                            setState(() {});
                          },
                          checked: !checked,
                          autoCheck: true,
                          checkIcon: Utility.getSVGPicture(
                              R.assetsImgIcEyeSlash,
                              size: 20),
                          uncheckIcon: Utility.getSVGPicture(
                              R.assetsImgIcEyeClose,
                              size: 20),
                        ),
                      ),
                    ])),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                    onTap: () {
                      if (this.widget.onTapListener != null) {
                        this.widget.onTapListener!(
                            {"msn": this._msn, "password": this._password});
                      }
                    },
                    child: new Container(
                      height: 45,
                      alignment: Alignment.center,
                      // padding: EdgeInsets.fromLTRB(10.0, 45.0, 10.0, 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                            colors: ThemeManager.getInstance()
                                .getButtonLinearGradientBackgroundColor()),
                      ),
                      child: new Text(getI18NKey().register,
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    )),
              ],
            )));
  }
}
