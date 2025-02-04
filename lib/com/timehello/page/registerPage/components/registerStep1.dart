import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/TitleDescWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../config/Params.dart';
import '../../../config/StylesConfig.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/TextUtil.dart';
import '../../../util/ThemeManager.dart';

class RegisterStep1 extends StatefulWidget {
  Function? onTapListener;
  Function? onChanged;
  int curTab;
  RegisterStep1({
    Key? key,
    this.curTab = 0,
    Function? onChanged,
    Function? onTapListener,
  }) : super(key: key) {
    this.onTapListener = onTapListener;
    this.onChanged = onChanged;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterStep1State(curTab:this.curTab);
  }
}

class RegisterStep1State extends State<RegisterStep1> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  String? mobile;
  String? email;
  String? countryPhoneCode;
  int curTab = 0;

  // this.countryPhoneCode = phone.countryCode;
  // this.number = phone.number;
  // this.completeNumber = phone.completeNumber;
  String? _password;
  final _formKey = new GlobalKey<FormState>();

  List<CheckButtonStateModel> tabList =
      CONSTANTS.getLoginRegisterTabBarWidget();

  RegisterStep1State({required int curTab}) {
    this.curTab = curTab;
    textController1 = TextEditingController();
    textController2 = TextEditingController();
  }

  // setCurTab(int curTab) {
  //   this.curTab = curTab;
  //   setState(() {});
  // }

  setPhone(String phone) {
    this.mobile = phone;
    if (this.widget.onChanged != null) {
      this.widget.onChanged!(this.countryPhoneCode, this.mobile);
    }
    textController1?.text = phone;
    setState(() {

    });
  }

  setEmail(String email) {
    this.email = email;
    textController2?.text = email;
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (textController1 != null) textController1?.dispose();
    if (textController2 != null) textController2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        onKey: (event) {
          // if (event.runtimeType == RawKeyDownEvent) {
          //   if (event.physicalKey == PhysicalKeyboardKey.enter) {
          //
          //   }
          // }
        },
        focusNode: FocusNode(),
        child: Container(
            padding: EdgeInsets.only(left: 60, right: 60),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),

                TitleDescWidget(
                  title: getI18NKey().welcome,
                  desc: getI18NKey().registerStep1,
                ),
                SizedBox(
                  height: 40,
                ),
                CustomTabBarWidget(
                  checkIndex: this.curTab,
                  list: tabList,
                  onCheckedListener: (int index, CheckButtonStateModel model) {
                    this.curTab = index;
                    setState(() {});
                  },
                  fontSize: 14,
                ),
                SizedBox(
                  height: 20,
                ),

                getTextField(),
                // TextFormField(
                //     onChanged: (String data) {
                //       this._mobile = data;
                //       if (this.widget.onChanged != null) {
                //         this.widget.onChanged(data);
                //       }
                //     },
                //     inputFormatters: [
                //       // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
                //       FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                //       //数字包括小数
                //     ],
                //     keyboardType: TextInputType.phone,
                //     maxLength: 11,
                //     controller: textController1,
                //     obscureText: false,
                //     decoration: InputDecoration(
                //         labelText: getI18NKey().phoneNo,
                //         labelStyle: TextStyle(
                //             color: Color(0xff8b97a2),
                //             fontWeight: FontWeight.w500,
                //             fontFamily: 'Montserrat'),
                //         enabledBorder: UnderlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: ColorsConfig.colorTextField, width: 1),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(4.0),
                //                 topRight: Radius.circular(4.0))),
                //         focusedBorder: UnderlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: ColorsConfig.colorTextField, width: 1),
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(4.0),
                //                 topRight: Radius.circular(4.0)))),
                //     style: TextStyle(
                //         fontFamily: 'Montserrat',
                //         color: Color(0xff8b97a2),
                //         fontWeight: FontWeight.w500),
                //     validator: (value) =>
                //         value.isEmpty ? getI18NKey().emailCannotBeNull : null,
                //     onSaved: (value) {
                //       return _mobile = value.trim();
                //     },
                //   ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      if (this.widget.onTapListener != null) {
                        this.widget.onTapListener!(this.countryPhoneCode,
                            this.mobile, this.email, this.curTab);
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
                      child: new Text(getI18NKey().nextStep,
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    )),
              ],
            )));
  }

  Widget getTextField() {
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
      // onFieldSubmitted: (e) {
      //   this.onClick('onClickLogin', null);
      // },
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

  StatefulWidget getMobileInputTextField() {
    if (Utility.isGooglePlay() == true) {
      return IntlPhoneField(
          disableLengthCheck: true,
          searchText: getI18NKey().search_country,
          invalidNumberMessage: getI18NKey().invalid_mobile_number,
          autovalidateMode: AutovalidateMode.disabled,
          controller: textController1,
          onSubmitted: (v) {
            if (TextUtil.isEmpty(this.mobile)) {
              Utility.showToastMsg(msg: getI18NKey().input_mobile);
              return;
            }
            if (this.widget.onTapListener != null) {
              this.widget.onTapListener!(
                  this.countryPhoneCode ?? "", this.mobile);
            }
          },
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
            enabledBorder: StylesConfig.enableBorderSide,
            focusedBorder: StylesConfig.focusBorderSide,
            filled: true,
            fillColor: StylesConfig.filledInputColor,
            labelStyle: TextStyle(
                color: ThemeManager.getInstance()
                    .getInputPlaceholderColor(defaultColor: Color(0xff8b97a2)),
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat'),
            border: OutlineInputBorder(),
          ),
          initialCountryCode: DeviceInfoManagement.getCountryCode(),
          onChanged: (phone) async {
            // this.countryIOSCode = phone.countryISOCode;
            this.countryPhoneCode = phone.countryCode;
            this.mobile = phone.number;
            if (this.widget.onChanged != null) {
              this.widget.onChanged!(this.countryPhoneCode, this.mobile);
            }
          });
    } else {
      return TextFormField(
        onChanged: (String data) {
          this.mobile = data;
          if (this.widget.onChanged != null) {
            this.widget.onChanged!("+86", data);
          }
        },
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          //数字包括小数
        ],
        keyboardType: TextInputType.phone,
        maxLength: 11,
        controller: textController1,
        obscureText: false,
        decoration: InputDecoration(
          enabledBorder: StylesConfig.enableBorderSide,
          focusedBorder: StylesConfig.focusBorderSide,
          filled: true,
          fillColor: StylesConfig.filledInputColor,
          labelText: getI18NKey().phoneNo,
          labelStyle: TextStyle(
              color: ThemeManager.getInstance()
                  .getInputPlaceholderColor(defaultColor: Color(0xff8b97a2)),
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat'),
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: ThemeManager.getInstance()
                .getTextColor(defaultColor: Color(0xff8b97a2)),
            fontWeight: FontWeight.w500),
        validator: (value) =>
            TextUtil.isEmpty(value) ? getI18NKey().emailCannotBeNull : null,
        onSaved: (value) {
          this.mobile = value?.trim();
          // return this.mobile ?? "";
        },
      );
    }
  }
}
