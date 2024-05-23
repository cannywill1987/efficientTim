import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class PasswordWidget extends StatefulWidget {
  double width;

  PasswordWidget({Key? key, this.width = 200}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PasswordWidgetState();
  }
}

class PasswordWidgetState extends State<PasswordWidget> {
  bool isVisibleForOriginPassword = false;
  final TextEditingController _originPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordMatch = true;
  double height = 50;
  bool checkedPasswordOrigin = false;
  bool checkedPassword1 = false;
  bool checkedPassword2 = false;
  String getOriginPassword() {
    return _originPasswordController.text;
  }

  String getPassword1() {
    return _passwordController.text;
  }

  String getPassword2() {
    return _confirmPasswordController.text;
  }

  bool isOriginPasswordVisible() {
    return isVisibleForOriginPassword;
  }

  setIsVisibleForOriginPassword(bool isVisible) {
    isVisibleForOriginPassword = isVisible;
    setState(() {});
  }

  setOriginPassword(String password) {
    _originPasswordController.text = password;
  }

  setPassword1(String password) {
    _passwordController.text = password;
  }

  setPassword2(String password) {
    _confirmPasswordController.text = password;
  }

  bool checkPassword() {
    String password = this.getPassword1() ?? "";
    String passwordConfirm = this.getPassword2() ?? "";
    if (password.length < 6) {
      Utility.showToastMsg(msg: getI18NKey().input_6_digit_password);
      return false;
    }
    if (passwordConfirm.length < 6) {
      Utility.showToastMsg(msg: getI18NKey().input_6_digit_password);
      return false;
    }

    if (password != passwordConfirm) {
      Utility.showToastMsg(msg: getI18NKey().encrypt_password_not_match);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isVisibleForOriginPassword == true)
          Container(
            height: height,
            width: this.widget.width,
            child: TextField(
              controller: _originPasswordController,
              obscureText: !this.checkedPasswordOrigin,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                filled: true,
                suffixIcon: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1.0,
                  child: CheckImage(
                    //显示隐藏密码的眼睛
                    onTapListener: (isChecked) {
                      checkedPasswordOrigin = !isChecked;
                      setState(() {});
                    },
                    checked: checkedPasswordOrigin,
                    autoCheck: true,
                    checkIcon:
                    Utility.getSVGPicture(R.assetsImgIcEyeSlash, size: 20),
                    uncheckIcon:
                    Utility.getSVGPicture(R.assetsImgIcEyeClose, size: 20),
                  ),
                ),
                fillColor: ThemeManager.getInstance().getInputDecorationColor(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                hintText: getI18NKey().please_origin_password,
                hintStyle: TextStyle(
                    color:
                        ThemeManager.getInstance().getInputPlaceholderColor(),
                    fontSize: 12),
              ),
              onChanged: (value) => _checkPasswordMatch(),
            ),
          ),
        SizedBox(height: 2),
        Container(
          height: height,
          width: this.widget.width,
          child: TextField(
            controller: _passwordController,
            obscureText: !this.checkedPassword1,
            maxLength: 6,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              suffixIcon: Align(
                alignment: Alignment.centerRight,
                widthFactor: 1.0,
                child: CheckImage(
                  //显示隐藏密码的眼睛
                  onTapListener: (isChecked) {
                    checkedPassword1 = !isChecked;
                    setState(() {});
                    ;
                  },
                  checked: checkedPassword1,
                  autoCheck: true,
                  checkIcon:
                      Utility.getSVGPicture(R.assetsImgIcEyeSlash, size: 20),
                  uncheckIcon:
                      Utility.getSVGPicture(R.assetsImgIcEyeClose, size: 20),
                ),
              ),
              filled: true,
              fillColor: ThemeManager.getInstance().getInputDecorationColor(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              hintText: getI18NKey().encrypt_password,
              hintStyle: TextStyle(
                  color: ThemeManager.getInstance().getInputPlaceholderColor(),
                  fontSize: 12),
            ),
            onChanged: (value) => _checkPasswordMatch(),
          ),
        ),
        Container(
          height: height,
          width: this.widget.width,
          margin: EdgeInsets.only(top: 10),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: !this.checkedPassword2,
            maxLength: 6,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              filled: true,
              fillColor: ThemeManager.getInstance().getInputDecorationColor(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Align(
                alignment: Alignment.centerRight,
                widthFactor: 1.0,
                child: CheckImage(
                  //显示隐藏密码的眼睛
                  onTapListener: (isChecked) {
                    checkedPassword2 = !isChecked;
                    setState(() {});
                  },
                  checked: checkedPassword2,
                  autoCheck: true,
                  checkIcon:
                  Utility.getSVGPicture(R.assetsImgIcEyeSlash, size: 20),
                  uncheckIcon:
                  Utility.getSVGPicture(R.assetsImgIcEyeClose, size: 20),
                ),
              ),
              hintText: getI18NKey().encrypt_password_confirm,
              hintStyle: TextStyle(
                  color: ThemeManager.getInstance().getInputPlaceholderColor(),
                  fontSize: 12),
            ),
            onChanged: (value) => _checkPasswordMatch(),
          ),
        ),
        SizedBox(height: 10),
        if (!_isPasswordMatch)
          Text(
            getI18NKey().encrypt_password_not_match,
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }
}
