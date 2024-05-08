import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../main.dart';
import '../beans/ResourceDeliveryInfoBean.dart';
import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../models/CheckButtonStateModel.dart';
import '../util/WidgetManager.dart';
import 'CheckButtonListWidget.dart';

class EditTitleDialogUtil {

  static show(BuildContext mContext,
      {String? title,
      String? content,
      String? leftText,
      String? rightText,
        String initVal = "",
      OnTapListener? onTapListener,
      Function? okCallBack,
      Function? cancelCallBack,
      bool input = false}) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return EditTitleDialog(
          title: title,
          content: content,
          leftText: leftText,
          initVal: initVal,
          rightText: rightText,
          okCallBack: okCallBack,
          onTapListener: onTapListener,
          cancelCallBack: cancelCallBack,
          input: input);
    });
    navigatorKey.currentState?.overlay?.insert(overlayEntry);
    // showDialog(
    //     context: mContext,
    //     builder: (BuildContext context) {
    //       return DialogContent(
    //           title: title,
    //           content: content,
    //           leftText: leftText,
    //           initVal: initVal,
    //           rightText: rightText,
    //           counterEnum: counterEnum,
    //           okCallBack: okCallBack,
    //           onTapListener: onTapListener,
    //           cancelCallBack: cancelCallBack,
    //           okRouteUri: okRouteUri,
    //           input: input);
    //     });
  }
}

class EditTitleDialog extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool isEditable;
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   bool? input; //是否展示输入框
   OnTapListener? onTapListener;
   String? initVal;
  EditTitleDialog(
      {Key? key,
       this.onTapListener,
       this.title,
       this.content,
       this.leftText,
        this.isEditable = true,
       this.rightText,
       this.onlyRight,
       this.okCallBack,
         this.initVal,
       this.cancelCallBack,
      this.input})
      : super(key: key);

  @override
  EditTitleDialogState createState() => EditTitleDialogState(
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      initVal: this.initVal,
      input: this.input);
}

class EditTitleDialogState extends State<EditTitleDialog> {
  String label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   bool? input; //是否展示输入框
   double? maxHeight = 300;
  String? initVal;
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  String? curVal = "";
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  TextEditingController textfieldInputNumberController = TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  List<CheckButtonStateModel> timeLists = CONSTANTS.getSliderDialogList();
  int maxVal = 120;

  EditTitleDialogState(
      {this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.list,
        this.initVal,
      this.input}) {
    this.textfieldInputController.text = title ?? "";
  }

  @override
  void didUpdateWidget(EditTitleDialog oldWidget) {}

  @override
  void initState() {
    super.initState();
    textfieldInputNumberController.text= this.widget.initVal ?? this.content ?? "";
  }

  @override
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    // textfieldInputController.text = this.title;
    return new Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        //自定义dialog布局
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    color: ThemeManager.getInstance().getDialogBackgroundColor(defaultColor: Colors.white),
                    constraints: BoxConstraints(
                        maxHeight: this.maxHeight ?? 0, maxWidth: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        // Text(this.widget.title,
                        //     style: TextStyle(
                        //         fontSize: 17, fontWeight: FontWeight.w400)),
                        Container(
                            height: 62,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: WidgetManager.getSliderDialogTitleWidget(textEditingController: textfieldInputController)),
                        SizedBox(height: 10),
                        WidgetManager
                            .getDialogInputWidget(
                          enabled: this.widget.isEditable,
                            focusNode: _textfieldContentFocusNode,
                            textEditingController:
                            textfieldInputNumberController,
                            onChange: (String val) {
                              curVal = val;
                            }),
                        SizedBox(height: 10),
                        new ButtonBar(
                          children: <Widget>[
                            new ElevatedButton(
                              child: new Text(getI18NKey().cancel),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) {
                                      //默认状态使用灰色
                                      return Colors.black;
                                    },
                                  ),
                                  //背景颜色
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    //设置按下时的背景颜色
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.white;
                                    }
                                    //默认不使用背景颜色
                                    return Colors.white;
                                  }),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          fontSize: 18, color: Colors.black))),
                              onPressed: () {
                                if (this.widget.cancelCallBack != null) {
                                  this.widget.cancelCallBack!();
                                }
                              },
                            ),
                            RawKeyboardListener(
                                autofocus: true,
                                onKey: (event) {
                                  if (event.runtimeType == RawKeyDownEvent) {
                                    if (event.physicalKey ==
                                        PhysicalKeyboardKey.enter) {
                                      this.widget?.okCallBack!(textfieldInputNumberController.text);
                                    }
                                  }
                                },
                                focusNode: FocusNode(),
                                child: new ElevatedButton(
                                  child: new Text(this.widget.rightText ?? getI18NKey().confirm),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) {
                                          //默认状态使用灰色
                                          return Colors.white;
                                        },
                                      ),
                                      //背景颜色
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        //设置按下时的背景颜色
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.red;
                                        }
                                        //默认不使用背景颜色
                                        return Colors.red;
                                      }),
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(
                                              fontSize: 18,
                                              color: Colors.red))),
                                  onPressed: () {
                                    this.widget?.okCallBack!(textfieldInputNumberController.text);
                                  },
                                )),
                          ],
                        )
                      ],
                    ))),
          )
        ]));
  }
}
