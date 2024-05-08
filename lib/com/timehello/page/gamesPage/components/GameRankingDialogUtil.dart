import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/GameRankingBean.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../util/WidgetManager.dart';
import 'GameRankingListWidget.dart';
import 'RankingBanner.dart';


class GameRankingDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
      String? content,
        required String gameCode,
        required String gameLevel,
      String? leftText,
      String? rightText,
        String? gameMode,
        int initVal = 10,
        CounterEnum counterEnum = CounterEnum.chronograph,

        GameRankingBean? gameRankingBean,
      OnTapListener? onTapListener,
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = "",
      bool input = false}) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return GameRankingDialog(
            title: title,
            content: content,
            gameCode: gameCode,
            gameLevel: gameLevel,
            gameMode: gameMode,
            gameRankingBean: gameRankingBean,
            leftText: leftText,
            initVal: initVal,
            rightText: rightText,
            okCallBack: okCallBack,
            autoPopupOnClick: true,
            onTapListener: onTapListener,
            cancelCallBack: cancelCallBack,
          );
        });
  }
}

class GameRankingDialog extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
  String? gameMode;
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   OnTapListener? onTapListener;
   GameRankingBean? gameRankingBean;
   int initVal = 0;
   String? gameCode;
   String? gameLevel;
   bool? autoPopupOnClick;
  GameRankingDialog(
      {Key? key,
        this.autoPopupOnClick,
      this.onTapListener,
        this.gameLevel,
      this.title,
      this.content,
        this.gameMode,
        this.gameRankingBean,
      this.leftText,
      this.rightText,
        this.gameCode,
      this.onlyRight,
      this.okCallBack,
        this.initVal = 0,
      this.cancelCallBack,
      })
      : super(key: key);

  @override
  GameRankingDialogState createState() => GameRankingDialogState(
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      initVal: this.initVal,
      autoPopupOnClick: this.autoPopupOnClick,
      );
}

class GameRankingDialogState extends State<GameRankingDialog> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   String? okRouteUri; //右边按钮跳转路由
   double maxHeight = 500;
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  int curSliderVal = 10;
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  TextEditingController textfieldInputNumberController = TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  List<CheckButtonStateModel> timeLists = CONSTANTS.getSliderDialogList();
  int maxVal = 100;
  String? ranking = "";
bool? autoPopupOnClick;
  GameRankingDialogState(
      {this.onTapListener,
      this.title,
        this.autoPopupOnClick,
      this.content,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.list,
        int initVal = 0,
      this.okRouteUri,
      }) {
      curSliderVal = initVal;
    this.textfieldInputController.text = title ?? "";
  }

  @override
  void didUpdateWidget(GameRankingDialog oldWidget) {}

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
                        maxHeight: this.maxHeight, maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        WidgetManager.getDialogTitleText(title: title ?? ""),
                        SizedBox(height: 10),
                        TextUtil.isEmpty(this.ranking)
                            ? RankingBanner(
                          rankingThisTime: this.ranking ?? "",
                          rankingText: getI18NKey().game1_time_usage(Utility.getTimeStringValue(this.widget.gameRankingBean?.time ?? 0)),
                          // getI18NKey().game2_ranking_text(this.widget.gameRankingBean.val1.toInt(), this.widget.gameRankingBean.val2.toInt(), Utility.getFunnel(numCharsCorrect: this.widget.gameRankingBean.val1, numCharsErrors: this.widget.gameRankingBean.val2)),
                        )
                            : SizedBox.shrink(),
                        GameRankingListWidget(gameLevel: this.widget.gameLevel,gameCode: this.widget?.gameCode ?? "", gameRankingBean: this.widget?.gameRankingBean ?? GameRankingBean(), gameMode: this.widget.gameMode, onRequestComplete: (val) => {
                          setState(() {
                            this.ranking = val["myRankingData"]["ranking"].toString();
                          })
                        }),
                        SizedBox(height: 10),
                        new ButtonBar(
                          children: <Widget>[
                            // new ElevatedButton(
                            //   child: new Text(getI18NKey().cancel),
                            //   style: ButtonStyle(
                            //       foregroundColor:
                            //           MaterialStateProperty.resolveWith(
                            //         (states) {
                            //           //默认状态使用灰色
                            //           return Colors.black;
                            //         },
                            //       ),
                            //       //背景颜色
                            //       backgroundColor:
                            //           MaterialStateProperty.resolveWith(
                            //               (states) {
                            //         //设置按下时的背景颜色
                            //         if (states
                            //             .contains(MaterialState.pressed)) {
                            //           return Colors.white;
                            //         }
                            //         //默认不使用背景颜色
                            //         return Colors.white;
                            //       }),
                            //       textStyle: MaterialStateProperty.all(
                            //           TextStyle(
                            //               fontSize: 18, color: Colors.black))),
                            //   onPressed: () {
                            //     if (this.widget.cancelCallBack != null) {
                            //       this.widget.cancelCallBack();
                            //     }
                            //   },
                            // ),
                            RawKeyboardListener(
                                autofocus: true,
                                onKey: (event) {
                                  if (event.runtimeType == RawKeyDownEvent) {
                                    if (event.physicalKey ==
                                        PhysicalKeyboardKey.enter) {
                                      if(this.widget?.okCallBack != null) {
                                        this.widget?.okCallBack!(curSliderVal);
                                      }
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
                                    if(autoPopupOnClick == true) {
                                      Navigator.of(context).pop();
                                    }
                                    if(this.widget?.okCallBack != null) {
                                      this.widget?.okCallBack!();
                                    }
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
