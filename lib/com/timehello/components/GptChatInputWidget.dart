import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../config/CONSTANTS.dart';
import '../util/Utility.dart';

class GptChatInputWidget extends StatefulWidget {
  Function onClickSendMsg;
  Widget? headerWidget;
  bool isLoading;
  String? placeholder;

  GptChatInputWidget(
      {Key? key,
      this.placeholder,
      this.isLoading = false,
      this.headerWidget,
      required this.onClickSendMsg})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GptChatInputWidgetState();
  }
}

class GptChatInputWidgetState extends State<GptChatInputWidget> {
  TextEditingController inputController = TextEditingController();
  String value = "";
  FocusNode? _contentFocusNode = FocusNode();

  unfocus() {
    _contentFocusNode?.unfocus();
  }

  setText(String txt) {
    inputController.text = txt;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              this.widget.headerWidget ??
                  SizedBox(
                    height: 0,
                  ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xffefefef),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Utility.showToast(
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
                                  child: TypeAheadField<String>(
                                    onSelected: (value) {},
                                    itemBuilder: (BuildContext context,
                                        String? value) {
                                      return Container(child: Text(value ?? ""),);
                                    },
                                    suggestionsCallback: (search) {
                                      return ["1", "2"];
                                      },

                                    // ...
                                    // controller: myTextEditingController, // your custom controller, or null
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                        controller: inputController =
                                            controller,
                                        // enabled: this.isLoading2 == 0,
                                        focusNode: _contentFocusNode,
                                        maxLines: 3000,
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
                                              .contains(LogicalKeyboardKey
                                                  .controlLeft);
                                          if (isCtrlPressed) {
                                            // insert a new line character
                                            inputController.value =
                                                TextEditingValue(
                                              text: inputController.text + '\n',
                                              selection:
                                                  TextSelection.collapsed(
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
                                        decoration: InputDecoration.collapsed(
                                          hintText: this.widget.placeholder ??
                                              getI18NKey()
                                                  .please_enter_your_question,
                                          border: InputBorder.none,
                                          // contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                          Utility.showToast(
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
                          color: Color(0xff9ea2f9),
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
                  : Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        getI18NKey().newline(CONSTANTS.getNewLineText()),
                        style:
                            TextStyle(color: Color(0xffa0a0a0), fontSize: 12),
                      ))
            ],
          ),
        ));
  }
}
