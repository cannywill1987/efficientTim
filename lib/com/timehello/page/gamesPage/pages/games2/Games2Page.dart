import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../../r.dart';
import '../../../../beans/BaseBean.dart';
import '../../../../beans/GameRankingBean.dart';
import '../../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../../common/httpclient/HttpManager.dart';
import '../../../../config/ColorsConfig.dart';
import '../../../../config/Params.dart';
import '../../../../util/GameCounterManagement.dart';
import '../../../../util/LoginManager.dart';
import '../../../../util/SharePreferenceUtil.dart';
import '../../../../util/ThemeManager.dart';
import '../../components/GameCounterWidget.dart';
import '../../components/CustomTableWidget.dart';
import 'components/Game2RankingDialogUtil.dart';

/**
 * game2 是记各种word
 */
class Games2Page extends BaseWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  bool? canFinishedManually;

  Games2Page(
      {Key? key,
      required this.resourceDeliveryInfoBean,
      this.canFinishedManually: false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _Games2PageWidgetState();
  }
}

class _Games2PageWidgetState<T> extends BaseWidgetState<Games2Page> {
  List<List<String>> datasRefList = []; //参考
  List<List<String>> datasList = [];
  int lenth = 5;
  int linesNum = 5;
  // double numCharsRef = 0;
  double numCharsCorrect = 0;
  double numCharsErrors = 0;
  double totalChars = 0;
  GlobalKey<GameCounterWidgetState> GameCounterWidgetGlobalKey = GlobalKey();

  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = true;
    //初始化table的数据
    initData(SharePreferenceUtil.getSyncInstance().getGameMode(
        gameCode: this
            .widget
            .resourceDeliveryInfoBean
            .deliveryName
            .toString(),
        defaultGameMode: 'random_by_number'));
  }

  componentDidMount() {
    //添加游戏状态改变的监听
    GameCounterManagement.getInstance().addOnGameModeChangeLister(
        onGameModeChangeLister: (int gameStatusModeEnum) {
      if (gameStatusModeEnum == GameStatusModeEnum.WaitingToStart.index) { //等待开始状态
        //设置table input是否可以编辑
        setDisable(isDisable: true);
      } else if (gameStatusModeEnum ==
          GameStatusModeEnum.ReadyTimeCounting.index) {  //准备计时状态
        setDisable(isDisable: true);
      } else if (gameStatusModeEnum == GameStatusModeEnum.Starting.index) { //开始状态
        setDisable(isDisable: false); //可编辑
        setCharsInvisible(isInvisible: true);
      } else if (gameStatusModeEnum == GameStatusModeEnum.Finished.index) {  //完成状态
        setDisable(isDisable: true);
      }
      if (mounted == true) {
        updateUI();
      }
    });
  }

  /**
   * 点击重新开始
   */
  void onClickReset() {
    numCharsCorrect = 0;
    numCharsErrors = 0;
    totalChars = 0;
    datasRefList = [];
    datasList = [];
    GameCounterManagement.getInstance().reset();
    initData(SharePreferenceUtil.getSyncInstance().getGameMode(gameCode: this
            .widget
            .resourceDeliveryInfoBean
            .deliveryName
            .toString(), defaultGameMode: 'random_by_number'));
    updateUI();
  }

  /**
   * 点击提交 到Mongodb
   * 得到准确率
   * val1 -正确的个数
   * val2 - 错误的个数，错误个数可能会多，比如多输入了
   * val3 - 总数
   */
  void onClickSubmit() {
    List<List<String>> list = [];
    String ref = "";
    for(int i = 0; i < this.datasList.length; i++) {
      if (datasList[i][0] == 'EL_INPUT' || datasList[i][0] == 'EL_INPUT_DISABLE') {
        list.add([""]);
        numCharsErrors += ref.length;
        totalChars += ref.length;
      } else {
        if (i % 2 == 0) {
          list.add([getI18NKey().answer + ":" + this.datasRefList[i][0]]);
          ref = this.datasRefList[i][0];
        } else {
          list.add([getI18NKey().my_answer + ":" + this.datasList[i][0]]);
          String answer = this.datasList[i][0];
          Map s = Utility.getNumChars(ref, answer);
          numCharsCorrect += s['numCorrect'].toDouble();
          numCharsErrors += s['numError'].toDouble();
          totalChars += this.datasList[i][0].length;
        }
      }
    }
    double correctPercent = numCharsCorrect / (numCharsCorrect + numCharsErrors);
    String correctPercentString = (correctPercent * 100).toStringAsFixed(1) + "%";
    this.datasList = list;
    updateUI();
    this.requestUpdateTotalFocusTime(val1: numCharsCorrect, val2: numCharsErrors, val3: totalChars);
  }

  void onClick(type, data) async {
    switch (type) {
      case 'reset':
        this.onClickReset();
        break;
      case 'submit':
        this.onClickSubmit();
        break;
    }
  }

  /**
   * val1 -正确的个数
   * val2 - 错误的个数，错误个数可能会多，比如多输入了
   * val3 - 总数
   */
  Future<void> requestUpdateTotalFocusTime({required double val1, required double val2, required double val3}) async {
    BaseBean response =
    await HttpManager.getInstance().doPostRequest(Apis.gameRankingAdd,
        params: {
          "gameCode": this
              .widget
              .resourceDeliveryInfoBean
              .deliveryName
              .toString(),
          "gameLevel": SharePreferenceUtil.getSyncInstance().getGameMode(gameCode: this
              .widget
              .resourceDeliveryInfoBean
              .deliveryName
              .toString(), defaultGameMode: 'random_by_number'),
          "username":
          LoginManager.getInstance().getUserBean().username,
          "avatar": LoginManager.getInstance().getUserBean().avatar,
          "gameTitle": this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
          "gameTitleEn": this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
          "time": GameCounterManagement.getInstance().timeUsed,
          "val1": val1,
          "val2": val2,
          "val3": val3,
          "score": (val1 * 0.8 + val2 * 0.2), //统计出分数 正确个数权限最高 0.8 错误个数权限次要 0.2
        },
        shouldShowErrorToast: false);
    if (response.success == true) {
      //请求得到 GameRankingBean
      GameRankingBean gameRankingBean = GameRankingBean.fromJson(response.data);
      String gameCode = this.widget.resourceDeliveryInfoBean.deliveryName.toString();
      //弹出对话框
      Utility.showRankingDialog(
        context: context,
        scene: "game2",
        gameMode: SharePreferenceUtil.getSyncInstance().getGameMode(gameCode: gameCode, defaultGameMode: 'random_by_number'),
        gameRankingBean: GameRankingBean.fromJson(response.data),
        gameCode: gameCode,
      );

      // Game2RankingDialogUtil.show(
      //   Utility.getGlobalContext(),
      //     gameRankingBean: gameRankingBean,
      //     gameMode: SharePreferenceUtil.getSyncInstance().getGameMode(gameCode: this
      //         .widget
      //         .resourceDeliveryInfoBean
      //         .deliveryName
      //         .toString(), defaultGameMode: 'random_by_number'),
      //   title: getI18NKey().ranking,
      //   gameCode: this.widget.resourceDeliveryInfoBean.deliveryName
      // );
    } else {}
  }

  // Widget baseDesktoptBuild(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: SingleChildScrollView(
  //         child: Column(
  //       children: [
  //         // SingleCharTextWidget(
  //         //   text: '1',
  //         //   dotSize: 6,
  //         //   fontSize: 16,
  //         //   gameDotPositionEnum: GameDotPositionEnum.bottomCenter.index,
  //         // )
  //       ],
  //     )),
  //   );
  // }

  /**
   * EL_INPUT_DISABLE 表示输入框不可输入
   * EL_INPUT 表示输入框可输入
   */
  setDisable({bool isDisable = false}) {
    for (int i = 0; i < this.datasList.length; i++) {
      List<String> list = this.datasList[i];
      if (list[0] == "EL_INPUT_DISABLE" || list[0] == "EL_INPUT") {
        list[0] = isDisable == true ? "EL_INPUT_DISABLE" : "EL_INPUT";
      }
    }
  }

  /**
   * 设置table的words是否可输入
   */
  setCharsInvisible({bool isInvisible = false}) {
    for (int i = 0; i < this.datasList.length; i++) {
      List<String> list = this.datasList[i];
      if (Utility.isAllCharAndNum(list[0]) == true && list[0] != "EL_INPUT_DISABLE" && list[0] != "EL_INPUT") {
        list[0] = isInvisible == true
            ? Utility.getCharBylength("*", list[0].length)
            : "EL_INPUT";
      }
    }
  }

  initData(String val) {
    datasList = [];
    for (int i = 0; i < this.linesNum; i++) {
      datasList
          .add([Utility.getRandomStringForGame(mode: val, length: this.lenth)]);
      datasList.add(["EL_INPUT_DISABLE"]);
    }
    datasRefList = Utility.deepCloneList(datasList);
  }

  Widget baseBuild(BuildContext context) {
    return Container(
      color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 200,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                  Utility.filterHttpUrl(this.widget.resourceDeliveryInfoBean.resourceIconUrl ??
                      '', prefix: "oss"),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.red, BlendMode.colorBurn)),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Positioned(
                    right: 5,
                    top: 10,
                    child: Container(
                        margin: EdgeInsets.only(right: 15),
                        child: PopupMenuButton<String>(
                          tooltip: '',
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Icon(
                              Icons.swap_vert,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                          onSelected: (String gameMode) {
                            SharePreferenceUtil.getSyncInstance().setGameMode(gameCode: this
                                .widget
                                .resourceDeliveryInfoBean
                                .deliveryName
                                .toString(), gameMode: gameMode);
                            onClickReset();
                            initData(gameMode);
                            this.updateUI();
                            GameCounterManagement.getInstance().nextStatus();
                          },
                          itemBuilder: (context) {
                            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'random_by_number',
                                child: Text(getI18NKey().random_by_number,
                                    style: TextStyle(fontSize: 13)),
                              ),
                              PopupMenuItem<String>(
                                value: 'random_by_alphabet',
                                child: Text(
                                  getI18NKey().random_by_alphabet,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'random_by_alphabet_lowercase_capital',
                                child: Text(
                                  getI18NKey()
                                      .random_by_alphabet_lowercase_capital,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'random_by_alphabet_lowercase_capital',
                                child: Text(
                                  getI18NKey()
                                      .random_by_alphabet_lowercase_capital,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'random_by_alphabetAndNumber',
                                child: Text(
                                  getI18NKey().random_by_alphabetAndNumber,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value:
                                    'random_by_alphabetAndNumber_lowercase_capital',
                                child: Text(
                                  getI18NKey()
                                      .random_by_alphabetAndNumber_lowercase_capital,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ];
                          },
                        ))),
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: 10000,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: ThemeManager.getInstance().isDark() ? ColorsConfig.listColorsCardBlackToPurple : ColorsConfig.listColorsOpacityToWhite),
                      ),
                    )),
                GameCounterWidget(
                    gameRankingModeEnum: GameRankingModeEnum.Customized,
                    gameReadyDuration: 30 * 1000,
                    canFinishedManually: this.widget.canFinishedManually!,
                    shouldRequestUpdateTimeAuto: false,
                    gameCode: this
                        .widget
                        .resourceDeliveryInfoBean
                        .locationInfoId
                        .toString(),
                    gameTitle: this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
                    key: GameCounterWidgetGlobalKey,
                    onClickRetry: () {
                      this.onClick('reset', null);
                    },
                    onClickSubmit: () {
                      this.onClick('submit', null);
                    }),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Utility.getSVGPicture(
                  R.assetsImgIcObjective,
                  size: 14,
                  // color: Colors.white,
                ),
              ),
              SizedBox(width: 3),
              Expanded(
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                    new Text.rich(
                      //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
                      new TextSpan(
                          text: '${getI18NKey().objective}:',
                          //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                          style: TextStyle(fontSize: 14, color: Colors.orange),
                          //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                          //子 TextSpan，可以指定多个
                          children: <TextSpan>[
                            new TextSpan(
                                text: this
                                    .widget
                                    .resourceDeliveryInfoBean
                                    .resourceTitle!,
                                style: TextStyle(
                                    fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffc0c0c0)))),
                          ]),
                      textDirection: TextDirection.ltr,
                    ),
                  ]))
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utility.getSVGPicture(
                R.assetsImgIcMethod,
                size: 20,
                // color: Colors.white,
              ),
              Expanded(
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                    new Text.rich(
                      //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
                      new TextSpan(
                          text: '${getI18NKey().method}:',
                          //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                          style:
                              TextStyle(fontSize: 14, color: Color(0xfff9d879)),
                          //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                          //子 TextSpan，可以指定多个
                          children: <TextSpan>[
                            new TextSpan(
                                text: this
                                    .widget
                                    .resourceDeliveryInfoBean
                                    .resourceContent!,
                                style: TextStyle(
                                    fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)))),
                          ]),
                      textDirection: TextDirection.ltr,
                    ),
                  ]))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomTableWidget(
              width: ScreenUtil.getScreenW(context) - 10,
              onInputListener: (val) {
                this.datasList = val;
                print(111);
              },
              gameTableMode: GameTableMode.Text,
              height: 200,
              datas: datasList)
        ],
      )),
    );
  }
}
