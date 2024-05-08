import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/Loading.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/VocabularyManager.dart';

import '../../../../../../r.dart';
import '../../../../beans/BaseBean.dart';
import '../../../../beans/GameRankingBean.dart';
import '../../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../../beans/Word/VocabularyLevelBean.dart';
import '../../../../beans/Word/VocabularyLevelList.dart';
import '../../../../beans/Word/WordBean.dart';
import '../../../../common/httpclient/HttpManager.dart';
import '../../../../components/LoadingDialogUtil.dart';
import '../../../../config/ColorsConfig.dart';
import '../../../../config/Params.dart';
import '../../../../util/AudioPlayUtil.dart';
import '../../../../util/EasyLoadingManager.dart';
import '../../../../util/GameCounterManagement.dart';
import '../../../../util/LoginManager.dart';
import '../../../../util/SharePreferenceUtil.dart';
import '../../components/GameCounterWidget.dart';
import '../../components/CustomTableWidget.dart';
import 'components/WordListView.dart';

/**
 * game2 是记各种word
 */
class Games4Page extends BaseWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  bool? canFinishedManually;
  String? vocabularyLevelUrl;

  Games4Page(
      {Key? key,
      required this.resourceDeliveryInfoBean,
      required this.vocabularyLevelUrl,
      this.canFinishedManually: false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _Games4PageWidgetState(canFinishedManually: canFinishedManually);
  }
}

class _Games4PageWidgetState<T> extends BaseWidgetState<Games4Page> {
  List<List<String>> datasRefList = []; //参考
  List<List<String>> datasList = [];
  // int lenth = 5;
  // int linesNum = 5;

  // double numCharsRef = 0;
  // double numCharsCorrect = 0;
  // double numCharsErrors = 0;
  // double totalChars = 0;
  List<WordBean>? listWordBean;
  bool? canFinishedManually;
  List<VocabularyLevelBean> vocabularyLevelList = [];
  GameStatusModeEnum? gameStatusModeEnum;
  _Games4PageWidgetState({this.canFinishedManually, this.listWordBean});
  Game4EngLevelModeEnum curGameMode = Game4EngLevelModeEnum.level1_show_words;
  GlobalKey<GameCounterWidgetState> GameCounterWidgetGlobalKey = GlobalKey();
  
  void didUpdateWidget(Games4Page oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this.widget.canFinishedManually != oldWidget.canFinishedManually) {
      this.canFinishedManually = oldWidget.canFinishedManually;
    }
  }

  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
    AudioPlayUtil.getInstance()?.stop();
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = true;
    //初始化table的数据
    // curGameMode = ;
    // initData();
    initGameMode(SharePreferenceUtil.getSyncInstance().getGameMode(
        gameCode: this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
        defaultGameMode: Game4EngLevelModeEnum.level1_show_words.toString()));
    // VocabularyManager.getInstance()?.requestGetVocabulariUnitList();
  }

  void initGameMode(String gameModel) {
    if (gameModel == Game4EngLevelModeEnum.level1_show_words.toString()) {
      curGameMode = Game4EngLevelModeEnum.level1_show_words;
    } else if (gameModel == Game4EngLevelModeEnum.level2_hide_leftpart_words.toString()) {
      curGameMode = Game4EngLevelModeEnum.level2_hide_leftpart_words;
    } else if (gameModel == Game4EngLevelModeEnum.level3_hide_rightpart_words.toString()) {
      curGameMode = Game4EngLevelModeEnum.level3_hide_rightpart_words;
    } else if (gameModel == Game4EngLevelModeEnum.level4_hide_all_parts.toString()) {
      curGameMode = Game4EngLevelModeEnum.level4_hide_all_parts;
    } else if (gameModel == Game4EngLevelModeEnum.level5_write_words.toString()) {
      curGameMode = Game4EngLevelModeEnum.level5_write_words;
    }
  }

  void playAudio() {
    List<String> urlList = [];
    this.listWordBean?.forEach((WordBean element) {
      urlList.add(Utility.getUrl(schemaUrl: Params.vocabularyBaseUrl, name: element.am_url!));
      urlList.add(Utility.getUrl(schemaUrl: Params.vocabularyBaseUrl, name: element.zh_url!));
      print("${element.word}, am url:${element.am_url}, zh ur: ${element.zh_url}");
    });
    try {
      AudioPlayUtil.getInstance()?.playUrlList(urlList, completeCB: () {
        this.canFinishedManually = true;
        updateUI();
      });
    } catch(e) {

    }
  }

  void getData() async {
    EasyLoadingManager.getInstance().showLoading();
    listWordBean = await VocabularyManager.getInstance()
        ?.requestGetRandomWordList(this.widget.vocabularyLevelUrl ?? "", 5);
    updateUI();
    GameCounterManagement.getInstance().nextStatus();
    EasyLoadingManager.getInstance().dismiss();
  }

  componentDidMount() {
    //添加游戏状态改变的监听
    GameCounterManagement.getInstance().addOnGameModeChangeLister(
        onGameModeChangeLister: (int gameStatusModeEnum) {
      if (gameStatusModeEnum == GameStatusModeEnum.WaitingToStart.index) {
          this.gameStatusModeEnum = GameStatusModeEnum.WaitingToStart;
        //等待开始状态
        //设置table input是否可以编辑
        setDisable(isDisable: true);
      } else if (gameStatusModeEnum ==
          GameStatusModeEnum.ReadyTimeCounting.index) {
        //准备计时状态
        setDisable(isDisable: true);
        this.gameStatusModeEnum = GameStatusModeEnum.ReadyTimeCounting;
      } else if (gameStatusModeEnum == GameStatusModeEnum.Starting.index) {
        //开始状态
        playAudio();
        setDisable(isDisable: false); //可编辑
        this.gameStatusModeEnum = GameStatusModeEnum.Starting;
      } else if (gameStatusModeEnum == GameStatusModeEnum.Finished.index) {
        //完成状态
        setDisable(isDisable: true);
        this.gameStatusModeEnum = GameStatusModeEnum.Finished;
      }
      if (mounted == true) {
        updateUI();
      }
    });
    getData();
  }

  /**
   * 点击重新开始
   */
  void onClickReset() {
    getData();
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
    // List<List<String>> list = [];
    // String ref = "";
    // for(int i = 0; i < this.datasList.length; i++) {
    //   if (datasList[i][0] == 'EL_INPUT' || datasList[i][0] == 'EL_INPUT_DISABLE') {
    //     list.add([""]);
    //     numCharsErrors += ref.length;
    //     totalChars += ref.length;
    //   } else {
    //     if (i % 2 == 0) {
    //       list.add([getI18NKey().answer + ":" + this.datasRefList[i][0]]);
    //       ref = this.datasRefList[i][0];
    //     } else {
    //       list.add([getI18NKey().my_answer + ":" + this.datasList[i][0]]);
    //       String answer = this.datasList[i][0];
    //       Map s = Utility.getNumChars(ref, answer);
    //       numCharsCorrect += s['numCorrect'].toDouble();
    //       numCharsErrors += s['numError'].toDouble();
    //       totalChars += this.datasList[i][0].length;
    //     }
    //   }
    // }
    // double correctPercent = numCharsCorrect / (numCharsCorrect + numCharsErrors);
    // String correctPercentString = (correctPercent * 100).toStringAsFixed(1) + "%";
    // this.datasList = list;
    // updateUI();
    // this.requestUpdateTotalFocusTime(val1: numCharsCorrect, val2: numCharsErrors, val3: totalChars);
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
  Future<void> requestUpdateTotalFocusTime(
      {required double val1,
      required double val2,
      required double val3}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
        Apis.gameRankingAdd,
        params: {
          "gameCode":
              this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
          "gameLevel": SharePreferenceUtil.getSyncInstance().getGameMode(
              gameCode:
                  this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
              defaultGameMode: 'random_by_number'),
          "username": LoginManager.getInstance().getUserBean().username,
          "avatar": LoginManager.getInstance().getUserBean().avatar,
          "gameTitle":
              this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
          "gameTitleEn":
              this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
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
      String gameCode =
          this.widget.resourceDeliveryInfoBean.deliveryName.toString();
      //弹出对话框
      Utility.showRankingDialog(
        context: context,
        scene: "game4",
        gameMode: SharePreferenceUtil.getSyncInstance().getGameMode(
            gameCode: gameCode, defaultGameMode: 'random_by_number'),
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

  // initData(String val) {
  //   datasList = [];
  //   for (int i = 0; i < this.linesNum; i++) {
  //     datasList
  //         .add([Utility.getRandomStringForGame(mode: val, length: this.lenth)]);
  //     datasList.add(["EL_INPUT_DISABLE"]);
  //   }
  //   datasRefList = Utility.deepCloneList(datasList);
  // }

  Widget baseBuild(BuildContext context) {
    return Container(
      color: Colors.white,
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
                            initGameMode(gameMode);
                            SharePreferenceUtil.getSyncInstance().setGameMode(gameCode: this
                                .widget
                                .resourceDeliveryInfoBean
                                .deliveryName
                                .toString(), gameMode: gameMode);
                            onClickReset();
                            // initData(gameMode);
                            this.updateUI();
                            GameCounterManagement.getInstance().nextStatus();
                          },
                          itemBuilder: (context) {
                            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                            return getPopupMenuList();
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
                            colors: ColorsConfig.listColorsOpacityToWhite),
                      ),
                    )),
                GameCounterWidget(
                    counterStartAuto: false,
                    gameRankingModeEnum: GameRankingModeEnum.Customized,
                    gameReadyDuration: 3 * 1000,
                    canFinishedManually: this.canFinishedManually!,
                    shouldRequestUpdateTimeAuto: false,
                    gameCode: this
                        .widget
                        .resourceDeliveryInfoBean
                        .locationInfoId
                        .toString(),
                    gameTitle: this
                        .widget
                        .resourceDeliveryInfoBean
                        .resourceTitle
                        .toString(),
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
                          //子 TextSpan，可以指定多个
                          children: <TextSpan>[
                            new TextSpan(
                                text: this
                                    .widget
                                    .resourceDeliveryInfoBean
                                    .resourceTitle!,
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xff404040))),
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
                          children: <TextSpan>[
                            new TextSpan(
                                text: this
                                    .widget
                                    .resourceDeliveryInfoBean
                                    .resourceContent!,
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xff404040))),
                          ]),
                      textDirection: TextDirection.ltr,
                    ),
                  ]))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          WordListView(datas: listWordBean, gameStatusModeEnum: this.gameStatusModeEnum ?? GameStatusModeEnum.ReadyTimeCounting, game4EngLevelModeEnum: curGameMode,)
        ],
      )),
    );
  }

  List<PopupMenuEntry<String>> getPopupMenuList() {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: Game4EngLevelModeEnum.level1_show_words.toString(),
        child: Text(getI18NKey().level1_show_words,
            style: TextStyle(fontSize: 13)),
      ),
      PopupMenuItem<String>(
        value: Game4EngLevelModeEnum.level2_hide_leftpart_words.toString(),
        child: Text(
          getI18NKey().level2_hide_leftpart_words,
          style: TextStyle(fontSize: 13),
        ),
      ),
      PopupMenuItem<String>(
        value: Game4EngLevelModeEnum.level3_hide_rightpart_words.toString(),
        child: Text(
          getI18NKey().level3_hide_rightpart_words,
          style: TextStyle(fontSize: 13),
        ),
      ),
      PopupMenuItem<String>(
        value: Game4EngLevelModeEnum.level4_hide_all_parts.toString(),
        child: Text(
          getI18NKey().level4_hide_all_parts,
          style: TextStyle(fontSize: 13),
        ),
      ),
      PopupMenuItem<String>(
        value: Game4EngLevelModeEnum.level5_write_words.toString(),
        child: Text(
          getI18NKey()
              .level5_write_words,
          style: TextStyle(fontSize: 13),
        ),
      ),
    ];
  }
}
