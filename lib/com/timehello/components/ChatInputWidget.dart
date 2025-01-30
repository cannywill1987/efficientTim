import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:time_hello/com/timehello/beans/SuggestionBean.dart';
import 'package:time_hello/com/timehello/page/FeedbackPage/FeedbackPage.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../config/CONSTANTS.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';

class ChatInputWidget extends StatefulWidget {
  Function onClickSendMsg;
  Widget? headerWidget;
  List<SuggestionBean>? listSuggest;
  bool isLoading;
  String? placeholder;

  ChatInputWidget(
      {Key? key,
      this.listSuggest,
      this.placeholder,
      this.isLoading = false,
      this.headerWidget,
      required this.onClickSendMsg})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatInputWidgetState();
  }
}

class ChatInputWidgetState extends State<ChatInputWidget> {
  TextEditingController inputController = TextEditingController();
  String value = "";
  FocusNode? _contentFocusNode = FocusNode();

  // SuggestionsController controller;
  late SuggestionsController<SuggestionBean> suggestionsController;

  unfocus() {
    _contentFocusNode?.unfocus();
  }

  setText(String txt) {
    inputController.text = txt;
  }

  refresh() {
    suggestionsController.refresh();
    // controller.refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    suggestionsController = SuggestionsController();

    // controller = SuggestionsController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(
          maxHeight: this.widget.headerWidget != null ? 380 : 140,
          minHeight: 60),
      color: ThemeManager.getInstance().getBackgroundColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (this.widget.headerWidget != null)
            SizedBox(
              height: 10,
            ),
          this.widget.headerWidget ??
              SizedBox(
                height: 0,
              ),
          Container(
            margin: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
                top: this.widget.headerWidget != null ? 5 : 10),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                          color: ThemeManager.getInstance()
                              .getInputDecorationColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Utility.showToastMsg(
                                    context: context,
                                    msg: getI18NKey().voice_guide);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TypeAheadField<SuggestionBean>(
                                // controller: controller,
                                suggestionsController: suggestionsController,
                                hideOnEmpty: true,
                                autoFlipDirection: true,
                                onSelected: (value) {
                                  inputController.text =
                                      value.suggestionContent ?? '';
                                  // this.widget.onClickSendMsg(inputController.text);
                                  // inputController.text = '';
                                },
                                itemBuilder: (BuildContext context,
                                    SuggestionBean? value) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    color: ThemeManager.getInstance()
                                        .getCardBackgroundColor(),
                                    alignment: Alignment.centerLeft,
                                    constraints: BoxConstraints(minHeight: 40),
                                    child: Text(value?.suggestion ?? ""),
                                  );
                                },
                                suggestionsCallback: (search) {
                                  if (TextUtil.isEmpty(search)) {
                                    return this.widget.listSuggest;
                                  }
                                  List<SuggestionBean> listReturns = [];
                                  for (var item
                                      in this.widget.listSuggest ?? []) {
                                    if (item.suggestion
                                            ?.toLowerCase()
                                            .contains(search.toLowerCase()) ==
                                        true) {
                                      listReturns.add(item);
                                    }
                                  }
                                  return listReturns;
                                },

                                // ...
                                // controller: myTextEditingController, // your custom controller, or null
                                builder: (context, controller, focusNode) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 200.0, // 设置TextField的最大高度
                                    ),
                                    child: TextField(
                                      // expands: true,
                                      keyboardType: TextInputType.multiline,
                                      minLines: DeviceInfoManagement.isWEB()
                                          ? 1
                                          : null,

                                      maxLines: DeviceInfoManagement.isWEB()
                                          ? 1
                                          : null,
                                      // 允许TextField高度自适应内容，直到达到最大高度限制
                                      // decoration: InputDecoration(
                                      //   hintText: 'Enter multiple lines here',
                                      //   border: OutlineInputBorder(),
                                      // ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(
                                            500), // 限制最大输入长度为500字符
                                      ],
                                      // enabled: this.isLoading2 == 0,
                                      focusNode: _contentFocusNode = focusNode,
                                      controller: inputController = controller,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (val) {
                                        // callback for regular enter key press
                                        this.widget.onClickSendMsg(
                                            inputController.text);
                                        inputController.text = '';
                                      },
                                      onEditingComplete: () {
                                        final isCtrlPressed = RawKeyboard
                                            .instance.keysPressed
                                            .contains(
                                                LogicalKeyboardKey.controlLeft);
                                        if (isCtrlPressed) {
                                          // insert a new line character
                                          inputController.value =
                                              TextEditingValue(
                                            text: inputController.text + '\n',
                                            selection: TextSelection.collapsed(
                                                offset: inputController
                                                        .text.length +
                                                    1),
                                          );
                                        } else {
                                          // trigger the callback for regular enter key press
                                          // this.onClickSendMsg(inputController.text);
                                        }
                                      },
                                      scrollController: ScrollController(),
                                      onChanged: (val) {
                                        this.value = val;
                                      },
                                      decoration: InputDecoration(
                                        hintText: this.widget.placeholder ??
                                            getI18NKey()
                                                .please_enter_your_question,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (this.widget.isLoading == true) {
                      Utility.showToastMsg(
                          msg: getI18NKey().requesting_please_wait);
                      return;
                    }
                    this.widget.onClickSendMsg(inputController.text);
                    inputController.text = '';
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeManager.getInstance().getCardBackgroundColor(
                          defaultColor: Color(0xff9ea2f9)),
                      shape: BoxShape.circle,
                    ),
                    child: this.widget.isLoading
                        ? CupertinoActivityIndicator()
                        : Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Utility.isHandsetBySize()
              ? SizedBox.shrink()
              : Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          getI18NKey().newline(CONSTANTS.getNewLineText()),
                          style:
                              TextStyle(color: Color(0xffa0a0a0), fontSize: 12),
                        )),
                    SizedBox(width: 10,),
                    InkWell(
                        onTap: () {
                          Utility.pushNavigator(context, FeedbackPage());
                        },
                        child: Text(
                          getI18NKey().report2,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ))
                  ],
                )
        ],
      ),
    );
  }
}
