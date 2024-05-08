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
import '../models/CheckButtonStateModel.dart';
import '../util/LoginManager.dart';
import '../util/WidgetManager.dart';
import 'CheckButtonListWidget.dart';

/**
 * 创建分享课程现金选择方式
 */
class SelectCashSettingDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
        String? content,
        String? leftText,
        String? rightText,
        int initVal = 10,
        OnTapListener? onTapListener,
        Function? okCallBack,
        Function? cancelCallBack,
        bool input = false}) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    // OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
    //   return SelectMoneySettingDialog(
    //       title: title,
    //       content: content,
    //       leftText: leftText,
    //       initVal: initVal,
    //       rightText: rightText,
    //       okCallBack: okCallBack,
    //       onTapListener: onTapListener,
    //       cancelCallBack: cancelCallBack,
    //       input: input);
    // });
    // navigatorKey.currentState.overlay.insert(overlayEntry);
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          return SelectMoneySettingDialog(
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
  }
}

class SelectMoneySettingDialog extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   bool? input; //是否展示输入框
   OnTapListener? onTapListener;
   int? initVal = 0;

  SelectMoneySettingDialog({Key? key,
    this.onTapListener,
    this.title,
    this.content,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.okCallBack,
    this.initVal,
    this.cancelCallBack,
    this.input})
      : super(key: key);

  @override
  SelectMoneySettingDialogState createState() =>
      SelectMoneySettingDialogState(
          onTapListener: this.onTapListener,
          title: this.title,
          content: this.content,
          leftText: this.leftText,
          rightText: this.rightText,
          onlyRight: this.onlyRight,
          initVal: this.initVal ?? 0,
          input: this.input);
}

class SelectMoneySettingDialogState extends State<SelectMoneySettingDialog> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight = false; //右边按钮文字
   bool? input = false; //是否展示输入框
   double maxHeight = 300;
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  int curSliderVal = 10;
  FixedExtentScrollController durationScrollController =
  FixedExtentScrollController(initialItem: 0);
  TextEditingController textfieldInputNumberController =
  TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  List<CheckButtonStateModel> timeLists = CONSTANTS.getSelectMoneyDialogList();
  int? maxVal = (LoginManager
      .getInstance()
      .userBean
      .localMoney ?? 0) < 100
      ? 100
      : LoginManager
      .getInstance()
      .userBean
      .localMoney;
  bool isInputHandling = false;
  // FocusNode _textfieldFocusNode = FocusNode();

  SelectMoneySettingDialogState({this.onTapListener,
    this.title,
    this.content,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.list,
    int initVal = 0,
    this.input}) {
    curSliderVal = initVal;
    this.textfieldInputController.text = title ?? "";
  }

  @override
  void didUpdateWidget(SelectMoneySettingDialog oldWidget) {}

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
                        maxHeight: this.maxHeight, maxWidth: 500),
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
                            //标题 消费金额
                            child: WidgetManager.getSliderDialogTitleWidget(
                                textEditingController: textfieldInputController,
                                onChange: (val) =>
                                {
                                  if (Utility.isNumeric(val) == true)
                                    {
                                      setState(() {
                                        this.curSliderVal = int.parse(val);
                                        isInputHandling = true;
                                        Future.delayed(Duration.zero, () => {
                                          isInputHandling = false
                                        });
                                      })
                                    }
                                })),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              //输入框
                              child: WidgetManager
                                  .getSliderDialogInputNumberWidget(
                                  focusNode: _textfieldContentFocusNode,
                                  textEditingController:
                                  textfieldInputNumberController,
                                  onChange: (String val) {
                                    // textfieldInputController.text = "";
                                    setState(() {
                                      this.curSliderVal = int.parse(val);
                                      // if (int.parse(val) > maxVal) {
                                      //   //输入框输入值会经过这里 这里不能改变
                                      //   if (isInputHandling == false) {
                                      //     curSliderVal = maxVal;
                                      //   }
                                      // } else if (int.parse(val) > 0) {
                                      //   if (isInputHandling == false) {
                                      //     curSliderVal = int.parse(val);
                                      //   }
                                      // }
                                    });
                                  }),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  curSliderVal.toInt().toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getI18NKey().yuan,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            )
                          ],
                        ),
                        Slider(
                          min: 1,
                          max: maxVal?.toDouble() ?? 1,
                          activeColor: ColorsConfig.red,
                          inactiveColor: Color(0xfffdfdfd),
                          value: curSliderVal > (maxVal?? 0)
                              ? (maxVal?.toDouble() ?? 1)
                              : curSliderVal.toDouble(),
                          onChanged: (value) {
                            textfieldInputNumberController.text = "";
                            setState(() {
                              curSliderVal = value.toInt();
                            });
                          },
                          onChangeStart: (value) {
                            print("onChangeStart : $value");
                            Utility.unfocus(focusNode: _textfieldContentFocusNode);
                            // updateSlider(value, "onChangeStart : $value");
                          },
                          onChangeEnd: (value) {
                            print("onChangeEnd : $value");
                            // updateSlider(value, "onChangeEnd : $value");
                          },
                        ),
                        CheckButtonListWidget(
                          unit: getI18NKey().yuan,
                          onTapListener: (res) {
                            Utility.unfocus(focusNode: _textfieldContentFocusNode);
                            CheckButtonStateModel resourceDeliveryInfoModel =
                            res['data'];
                            String val = resourceDeliveryInfoModel.title ?? "";
                            textfieldInputNumberController.text = "";
                            if (Utility.isNumeric(
                                resourceDeliveryInfoModel?.title ?? '') ==
                                true) {
                              setState(() {
                                if (int.parse(val) > (maxVal ?? 1)) {
                                  curSliderVal = (maxVal ?? 1);
                                } else {
                                  curSliderVal = int.parse(val);
                                }
                              });
                            } else {
                              //自定义
                              setState(() {
                                curSliderVal = 100; //这个表示正数
                              });
                            }
                            // ResourceDeliveryInfoModel resourceDeliveryInfoModel = res['data'];
                            // this.onClick(
                            //     "onClickPCValueType",
                            //     resourceDeliveryInfoModel
                            //         .extendParamsMap['sceneCode']);
                          },
                          list: timeLists,
                        ),


                        SizedBox(height: 20),
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
                                Navigator.of(context).pop();
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
                                      Navigator.of(context).pop();
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
                                                .contains(
                                                MaterialState.pressed)) {
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
                                    Navigator.of(context).pop();
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
