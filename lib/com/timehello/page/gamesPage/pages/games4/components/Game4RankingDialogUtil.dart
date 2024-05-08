import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/page/gamesPage/pages/games4/components/Game4RankingListWidget.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../beans/GameRankingBean.dart';
import '../../../../../config/CONSTANTS.dart';
import '../../../../../models/CheckButtonStateModel.dart';
import '../../../../../util/WidgetManager.dart';
import '../../../components/RankingBanner.dart';

/**
 * game 2定制化的排行榜
 */
class Game4RankingDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
      String? content,
      required String? gameCode,
      GameRankingBean? gameRankingBean,
      String? leftText,
      String? rightText,
        String? gameMode,
      int initVal = 10,
      CounterEnum counterEnum = CounterEnum.chronograph,
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
          return GameRanking2Dialog(
            gameRankingBean: gameRankingBean,
            title: title,
            content: content,
            gameCode: gameCode,
            gameMode: gameMode,
            leftText: leftText,
            autoPopupOnClick: true,
            initVal: initVal,
            rightText: rightText,
            okCallBack: okCallBack,
            onTapListener: onTapListener,
            cancelCallBack: cancelCallBack,
          );
          ;
        });
  }
}

class GameRanking2Dialog extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   OnTapListener? onTapListener;
   int initVal = 0;
   String? gameCode;
   GameRankingBean? gameRankingBean;
  String? gameMode;
  bool? autoPopupOnClick;
  GameRanking2Dialog({
    Key? key,
    this.gameRankingBean,
    this.onTapListener,
    this.title,
    this.content,
    this.leftText,
    this.rightText,
    this.gameCode,
    this.autoPopupOnClick,
    this.gameMode,
    this.onlyRight,
    this.okCallBack,
    this.initVal = 0,
    this.cancelCallBack,
  }) : super(key: key);

  @override
  GameRanking2DialogState createState() => GameRanking2DialogState(
        onTapListener: this.onTapListener,
        title: this.title,
        content: this.content,
        leftText: this.leftText,
        rightText: this.rightText,
    autoPopupOnClick: this.autoPopupOnClick,
        onlyRight: this.onlyRight,
        initVal: this.initVal ,
      );
}

class GameRanking2DialogState extends State<GameRanking2Dialog> {
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
  TextEditingController textfieldInputNumberController =
      TextEditingController();
  TextEditingController textfieldInputController = TextEditingController();
  FocusNode _textfieldContentFocusNode = FocusNode();
  List<CheckButtonStateModel> timeLists = CONSTANTS.getSliderDialogList();
  int maxVal = 100;
  String ranking = "";
  bool? autoPopupOnClick;
  GameRanking2DialogState({
    this.onTapListener,
    this.title,
    this.content,
    this.autoPopupOnClick,
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
  void didUpdateWidget(GameRanking2Dialog oldWidget) {}

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
                        this.ranking.isNotEmpty
                            ? RankingBanner(
                                rankingThisTime: this.ranking ?? "",
                                rankingText:
                                    getI18NKey().game2_ranking_text(this.widget.gameRankingBean?.val1?.toInt() ?? 0, this.widget.gameRankingBean?.val2?.toInt() ?? 0, Utility.getFunnel(numCharsCorrect: this.widget.gameRankingBean?.val1 ?? 0, numCharsErrors: this.widget.gameRankingBean?.val2 ?? 0)),
                              )
                            : SizedBox.shrink(),
                        Game4RankingListWidget(
                          gameCode: this.widget.gameCode ?? "",
                          gameMode: this.widget.gameMode,
                          gameRankingBean: this.widget.gameRankingBean,
                          onRequestComplete: (val) => {
                            setState(() {
                              this.ranking = val["myRankingData"]["ranking"].toString();
                            })
                          },
                        ),
                        SizedBox(height: 10),
                        new ButtonBar(
                          children: <Widget>[
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
                                    if (this.widget.autoPopupOnClick == true) {
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
