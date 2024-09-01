import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/components/PCSettingMenuItem.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/StylesConfig.dart';
import '../../../util/ThemeManager.dart';

class PCAccountWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCAccountWidgetState();
  }
}

class PCAccountWidgetState<T> extends State<PCAccountWidget> {
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  String? username = LoginManager.getInstance().userBean.username;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RawKeyboardListener(
        autofocus: true,
        onKey: (event) {
      if (event.runtimeType == RawKeyDownEvent) {
        if (event.physicalKey == PhysicalKeyboardKey.enter) {
          this.requestUpdateUsername();
        }
      }
    },
    focusNode: FocusNode(),
    child: getAccountWidget(context));
  }


  @override
  void initState() {
    textfieldInputController.text = username ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    //如果文案发生改变则请求 todo 其实做成失去焦点请求比较好
    this.requestUpdateUsername();
  }

  void requestUpdateUsername() {
    if (this.username != (LoginManager.getInstance().userBean?.username ?? '')) {
      HttpManager.getInstance().doPostRequest(Apis.updateUser, context: context, params: {"username": this.username}, callback: (BaseBean response, String scene, bool isFromCache) {
        if (response.success == true) {
            LoginManager.getInstance().setUserBean(UserBean.fromJson(response.data));
            eventBus.fire(EventFn(Params.ACTION_UPDATE_USERINFO_AVATAR, {}));
        }
      });
    }
  }

  Column getAccountWidget(BuildContext context) {
    return Column(children: [
      PCSettingMenuItem(
          title: getI18NKey().username,
          description: '',
          icon: null,
          onTapListener: (data) {},
          rightPartContainer: Container(
              width: 180,
              height: 55,
              alignment: Alignment.center,
              child: Container(
                  height: 32,
                  child: TextField(
                    focusNode: _textfieldContentFocusNode,
                    controller: textfieldInputController,
                    cursorColor: ColorsConfig.gray_40,
                    onChanged: (text) {
                      // inputController.clear();
                      this.username = text;
                      print(text);
                    },
                    onSubmitted: (value) {
                      // if (this.widget.onSubmitListener != null) {
                      //   this.widget.onSubmitListener(value);
                      // }
                      print(value);
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        focusedBorder: StylesConfig.buildOutlineInputBorder(),
                        enabledBorder: StylesConfig.buildOutlineInputBorder(),
                        border: StylesConfig.buildOutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 10)
                    ),
                  )))
      ),
    ]);
  }

}