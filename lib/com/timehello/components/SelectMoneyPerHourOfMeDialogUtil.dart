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

class SelectMoneyPerHourOfMeDialogUtil {

  static show(BuildContext mContext,
      {String? title,
      String? content,
      String? leftText,
      String? rightText,
        int initVal = 50,
        CounterEnum counterEnum = CounterEnum.chronograph,
      OnTapListener? onTapListener,
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = "",
      bool input = false}) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return SelectMoneyPerHourOfMeDialog(
          title: title,
          content: content,
          leftText: leftText,
          initVal: initVal,
          rightText: rightText,
          counterEnum: counterEnum,
          okCallBack: okCallBack,
          onTapListener: onTapListener,
          cancelCallBack: cancelCallBack,
          okRouteUri: okRouteUri,
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

class SelectMoneyPerHourOfMeDialog extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
   OnTapListener? onTapListener;
   CounterEnum? counterEnum;
   int? initVal;
  SelectMoneyPerHourOfMeDialog(
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
        this.counterEnum,
      this.okRouteUri,
      this.input})
      : super(key: key);

  @override
  SelectMoneyPerHourOfMeDialogState createState() => SelectMoneyPerHourOfMeDialogState(
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      initVal: this.initVal,
      okRouteUri: this.okRouteUri,
      input: this.input);
}

class SelectMoneyPerHourOfMeDialogState extends State<SelectMoneyPerHourOfMeDialog> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
   double? maxHeight = 350;
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  int? curSliderVal = 50;
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  TextEditingController textfieldInputNumberController = TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode? _textfieldContentFocusNode = FocusNode();
  List<CheckButtonStateModel>? timeLists = CONSTANTS.getSliderDialogList();
  int? maxVal = 1000;
  // CounterEnum? counterEnum = CounterEnum.chronograph;

  SelectMoneyPerHourOfMeDialogState(
      {this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.list,
        int? initVal,
      this.okRouteUri,
        // this.counterEnum,
      this.input}) {
      curSliderVal = initVal;
    if ((initVal ?? 0) > 1000) {
      this.maxVal = initVal;
    } else {
      this.maxVal = 1000;
    }
    this.textfieldInputController.text = title ?? "";
  }

  @override
  void didUpdateWidget(SelectMoneyPerHourOfMeDialog oldWidget) {}

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
                    color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: WidgetManager
                                  .getSliderDialogInputNumberWidget(
                                      focusNode: _textfieldContentFocusNode,
                                      textEditingController:
                                          textfieldInputNumberController,
                                      onChange: (String val) {
                                        // textfieldInputController.text = "";
                                        setState(() {
                                          if (int.parse(val) > 1000) {
                                            maxVal = int.parse(val) + 1;
                                          } else {
                                            maxVal = 1000;
                                          }
                                          if(int.parse(val) > 0) {
                                            curSliderVal = int.parse(val);
                                          }
                                        });
                                      }),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  curSliderVal?.toInt().toString() ?? "",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: ColorsConfig.colorGold,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      getI18NKey().dollar,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorsConfig.colorGold,
                                          fontWeight: FontWeight.bold),
                                    )),
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
                          activeColor: ThemeManager.getInstance().getSliderColor(defaultColor: ColorsConfig.red),
                          inactiveColor: ThemeManager.getInstance().getSliderInactiveColor(),
                          value: curSliderVal?.toDouble() ?? 0,
                          onChanged: (value) {
                            textfieldInputNumberController.text = "";
                            if (value > 120) {
                              maxVal = (value + 1).toInt();
                            } else {
                              maxVal = 120;
                            }
                            setState(() {
                              curSliderVal = value.toInt();
                            });
                          },
                          onChangeStart: (value) {
                            print("onChangeStart : $value");
                            // updateSlider(value, "onChangeStart : $value");
                          },
                          onChangeEnd: (value) {
                            print("onChangeEnd : $value");
                            // updateSlider(value, "onChangeEnd : $value");
                          },
                        ),
                        CheckButtonListWidget(
                          unit: getI18NKey().dollar,
                          onTapListener: (res) {
                            CheckButtonStateModel resourceDeliveryInfoModel =
                                res['data'];
                            String val = resourceDeliveryInfoModel.title ?? "";
                            textfieldInputNumberController.text = "";
                            if (Utility.isNumeric(
                                    resourceDeliveryInfoModel.title ?? "0") ==
                                true) {
                              if (int.parse(val) > 120) {
                                maxVal = (int.parse(val) + 1).toInt();
                              } else {
                                maxVal = 120;
                              }
                              setState(() {
                                // counterEnum = CounterEnum.chronograph;
                                curSliderVal = int.parse(val);
                              });
                            } else {
                              //自定义
                              setState(() {
                                // counterEnum = CounterEnum.timer;
                                curSliderVal = 120; //这个表示正数
                              });
                            }
                            // ResourceDeliveryInfoModel resourceDeliveryInfoModel = res['data'];
                            // this.onClick(
                            //     "onClickPCValueType",
                            //     resourceDeliveryInfoModel
                            //         .extendParamsMap['sceneCode']);
                          },
                          list: timeLists ?? [],
                        ),
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
