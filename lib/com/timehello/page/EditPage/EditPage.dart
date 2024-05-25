import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../util/ThemeManager.dart';

/**
 * 一个输入框的编辑页面
 */
class EditPage extends BaseWidget {
  int? maxLengh = 30;
  String? title = '';
  String? textHolder = '';
  String? initialText;
  EditPage({this.initialText, this.title, this.maxLengh, this.textHolder});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _EditPageWidgetState();
  }
}

class _EditPageWidgetState<T> extends BaseWidgetState<EditPage> {
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  String text = '';
  @override
  void onCreate() {
    super.onCreate();
    curPage = "EditPage";
  }

  @override
  void initState() {
    textfieldInputController.text = this.widget.initialText ?? "";

  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Container(
      height: double.infinity,
      color: ColorsConfig.backgroundColor,
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                child: TextField(
                  focusNode: _textfieldContentFocusNode,
                  controller: textfieldInputController,
                  cursorColor: ColorsConfig.gray_40,
                  onChanged: (text) {
                    // inputController.clear();
                    // this.username = text;
                    this.text = text;
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
                      hintText: this.widget.textHolder ?? '',
                      hintStyle: new TextStyle(
                          fontSize: 14, color: Color.fromRGBO(187, 187, 187, 1)),
                      enabledBorder: OutlineInputBorder(
                        //未选中时候的颜色
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xffe0e0e0)),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //选中时外边框颜色
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xffe0e0e0)),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      contentPadding: EdgeInsets.only(left: 10)),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 260,
                  height: 45,
                  child: ElevatedButton(
                      child: Text(
                        getI18NKey().update,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onPressed: () {
                        if (TextUtil.isEmpty(this.text)) {
                          Utility.showToastMsg(msg: getI18NKey().can_not_be_empty);
                          return;
                        }
                        Utility.popNavigator(context, this.text);
                        this.onClick("onClickUpdate", null);
                      })),
            ],
          )),
    );
  }
}
