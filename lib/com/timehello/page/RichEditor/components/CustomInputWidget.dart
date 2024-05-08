import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/ThemeManager.dart';
import '../../../util/Utility.dart';

class CustomDiaryInputWidget extends StatelessWidget {
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide: BorderSide(
      color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Colors.white),
    ),
  );
  Function? onChangeListener;
  Function onSubmitListener;
  FocusNode _contentFocusNode = FocusNode();
  TextEditingController inputController = TextEditingController();

  CustomDiaryInputWidget(
      {this.onChangeListener, required this.onSubmitListener, required TextEditingController inputController}) {
    if (inputController != null) {
      this.inputController = inputController;
    }
    // inputController.text = title ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      maxLength: 255,
      focusNode: _contentFocusNode,
      controller: inputController,
      onChanged: (text) {
        // inputController.clear();
        if (this.onChangeListener != null) {
          this.onChangeListener!(text);
        }
        print(text);
      },
      onSubmitted: (String value) {
        if (this.onSubmitListener != null) {
          this.onSubmitListener(value);
        }

        print(value);
      },
      style: TextStyle(
          fontFamily: 'Montserrat',
          decorationColor: Color(0xffd5d5d5),
          color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
          fontWeight: FontWeight.w500),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          // counterStyle: TextStyle(color: Colors.transparent, fontSize: 0),
          counterStyle: TextStyle(height: double.minPositive, fontSize: 0),
          counterText: "",
          contentPadding: EdgeInsets.only(left: 60, right: 75),
          //右边距是为了放置番茄计数器
          fillColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
          //背景颜色，必须结合filled: true,才有效
          hoverColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
          focusColor: ThemeManager.getInstance().getInputThemeColor(defaultColor: Colors.white),
          filled: true,
          //重点，必须设置为true，fillColor才有效
          // border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.title, color: Color(0xffd5d5d5),),
          prefixIconColor: Color(0xffd5d5d5),
          floatingLabelStyle: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffff0000)), fontSize: 14),
          labelStyle: TextStyle(color: Color(0xffd5d5d5), fontSize: 14),
          border: _outlineInputBorder,
          //边框，一般下面的几个边框一起设置
          //keyboardType: TextInputType.number, //键盘类型
          //obscureText: true,//密码模式
          focusedBorder: _outlineInputBorder,
          enabledBorder: _outlineInputBorder,
          disabledBorder: _outlineInputBorder,
          focusedErrorBorder: _outlineInputBorder,
          errorBorder: _outlineInputBorder,
          labelText: getI18NKey().write_a_title,
          helperText: ''),
    );
  }
}
