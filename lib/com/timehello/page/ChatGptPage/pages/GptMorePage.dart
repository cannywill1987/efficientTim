import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/ChatGptMoreSectionTitleWidget.dart';
import 'package:time_hello/com/timehello/util/CloudSharepreferenceManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../util/ChatGptManager.dart';

class GptMorePage extends BaseWidget {
  final Function(String) onEnterSystemExtraListener;

  GptMorePage({required this.onEnterSystemExtraListener});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return GptMorePageState();
  }
}

class GptMorePageState extends BaseWidgetState<GptMorePage> {
  String systemMessage = "";
  TextEditingController _controller = TextEditingController();
  String initSystemMessage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isAppBarVisible = false;
    this.systemMessage = CloudSharepreferenceManagement.getInstance().getString(ShareprefrenceKeys.gptUserSystemMessage, "");
    this.initSystemMessage = systemMessage;
    _controller.text = this.systemMessage;
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    if(this.initSystemMessage != this.systemMessage){
      this.widget.onEnterSystemExtraListener.call(this.systemMessage);
      CloudSharepreferenceManagement.getInstance().setString(ShareprefrenceKeys.gptUserSystemMessage, this.systemMessage);
      // ChatGptManager.getInstance().init();
    }
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          ChatGptMoreSectionTitleWidget(title: getI18NKey().rules_for_ai),
          SizedBox(
            height: 5,
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 200,
            ),
            child: TextField(
              // focusNode: _contentFocusNode,
              maxLines: 30,
              controller: _controller,
              decoration: InputDecoration(
                hintText: getI18NKey().example_demo_hint,
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(0xff787878)),
                fillColor: ThemeManager.getInstance()
                    .getInputDecorationColor(defaultColor: Color(0xffF4F4F4)),
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                    left: 5, right: 5, top: 5), // Added line spacing of 3
              ),
              style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  //You can set your custom height here
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Color(0xff404040)),
                  letterSpacing: 0,
                  wordSpacing: 0),
              //   // hintText: getI18NKey().please_input_content),
              onChanged: (val) {
                if (val.length > 200 && Utility.isProductEnv() == true) {
                  Utility.showToast(msg: getI18NKey().max_input_num(200));
                  return;
                }
                this.systemMessage = val;
                // this.widget.onEnterSystemExtraListener.call(val);
                // print(func);
                // updateEditMode(EditorEditModeEnum.editing);
                // func(this, this.widget.missionModel, val);
              },
            ),
          )
        ],
      ),
    );
  }
}
