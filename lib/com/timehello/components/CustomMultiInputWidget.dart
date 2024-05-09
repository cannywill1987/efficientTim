import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class CustomMultiInputWidget extends StatefulWidget {
  double width;

  CustomMultiInputWidget({Key? key, this.width = 300}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomMultiInputWidgetState();
  }
}

class CustomMultiInputWidgetState extends State<CustomMultiInputWidget> {
  bool isVisibleForOriginPassword = false;
  final TextEditingController _originPasswordController =
      TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();
  bool _isPasswordMatch = true;
  double height = 50;
  String getText() {
    return _originPasswordController.text;
  }

  // String getPassword1() {
  //   return _passwordController.text;
  // }
  //
  // String getPassword2() {
  //   return _confirmPasswordController.text;
  // }

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
              maxLength: 1000,
              decoration: InputDecoration(
                filled: true,
                suffixIcon: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1.0,
                ),
                fillColor: ThemeManager.getInstance().getInputDecorationColor(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                hintText: getI18NKey().please_input_first_gpt_sentence,
                hintStyle: TextStyle(
                    color:
                        ThemeManager.getInstance().getInputPlaceholderColor(),
                    fontSize: 12),
              ),
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

}
