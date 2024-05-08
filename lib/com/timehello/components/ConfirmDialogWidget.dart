import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../main.dart';
import '../beans/ResourceDeliveryInfoBean.dart';
import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../config/Params.dart';
import '../models/CheckButtonStateModel.dart';
import '../util/WidgetManager.dart';
import 'BlackCheckButtonListWidget.dart';
import 'CheckButtonListWidget.dart';


class ConfirmDialogWidget extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   OnTapListener? onTapListener;
   int? initVal;
  ConfirmDialogWidget(
      {Key? key,
      this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
        this.initVal,
      this.cancelCallBack,
      })
      : super(key: key);

  @override
  ConfirmDialogWidgetState createState() => ConfirmDialogWidgetState(
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      initVal: this.initVal,
      );
}

class ConfirmDialogWidgetState extends State<ConfirmDialogWidget> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   String? okRouteUri; //右边按钮跳转路由
   double? maxHeight = 300;
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  int? curSliderVal = 10;
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  TextEditingController textfieldInputNumberController = TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  List<CheckButtonStateModel> timeLists = CONSTANTS.getSliderDialogList();
  int? maxVal = 100;

  ConfirmDialogWidgetState(
      {this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.list,
        int? initVal,
      this.okRouteUri,
      }) {
      curSliderVal = initVal;
    // if (initVal > 120) {
    //   this.maxVal = initVal;
    // } else {
    //   this.maxVal = 120;
    // }
    this.textfieldInputController.text = title ?? "";
  }

  @override
  void didUpdateWidget(ConfirmDialogWidget oldWidget) {}

  @override
  void initState() {
    super.initState();
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
                    color: Colors.white,
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
                        Text(this.widget.content ?? "",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
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
                                      this.widget?.okCallBack!(curSliderVal);
                                    }
                                  }
                                },
                                focusNode: FocusNode(),
                                child: new ElevatedButton(
                                  child: new Text(getI18NKey().confirm),
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
                                    this.widget?.okCallBack!(curSliderVal);
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
