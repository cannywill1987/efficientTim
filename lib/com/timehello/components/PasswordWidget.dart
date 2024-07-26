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
  final TextEditingController _originPasswordController =
      TextEditingController();
  bool _isPasswordMatch = true;
  double height = 50;
  bool checkedPasswordOrigin = false;
  bool checkedPassword1 = false;
  bool checkedPassword2 = false;
  String getOriginPassword() {
    return _originPasswordController.text;
  }


  setOriginPassword(String password) {
    _originPasswordController.text = password;
  }


  bool checkPassword() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              // onChanged: (value) => _checkPasswordMatch(),
            ),
          ),
        SizedBox(height: 2),
        if (!_isPasswordMatch)
          Text(
            getI18NKey().encrypt_password_not_match,
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
