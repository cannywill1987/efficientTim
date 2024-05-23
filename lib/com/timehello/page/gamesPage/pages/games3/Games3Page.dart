import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/GameComparePictureBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/Observable.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/Loading.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../../../r.dart';
import '../../../../beans/BaseBean.dart';
import '../../../../beans/GameAnswerJsonBean.dart';
import '../../../../beans/GameRankingBean.dart';
import '../../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../../common/httpclient/HttpManager.dart';
import '../../../../common/httpclient/Oberver.dart';
import '../../../../common/provider/Env.dart';
import '../../../../components/GameComparePicture.dart';
import '../../../../components/LivesWidget.dart';
import '../../../../config/ENUMS.dart';
import '../../../../config/Params.dart';
import '../../../../config/Params.dart';
import '../../../../models/EventFn.dart';
import '../../../../util/GameCounterManagement.dart';
import '../../../../util/LoginManager.dart';
import '../../../../util/ScreenUtil.dart';
import '../../../../util/SharePreferenceUtil.dart';
import '../../../../util/WidgetManager.dart';
import '../../components/CircleBackNavigator.dart';
import '../../components/CustomFinishStateTableWidget.dart';
import '../../components/CustomGameItemBackground.dart';
import '../../components/CustomGameText.dart';
import '../../components/GameCounterWidget.dart';
import '../../components/GameRankingDialogUtil.dart';

/**
 * game2 是记各种word
 */
class Games3Page extends BaseWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  bool? canFinishedManually;
  GameComparePictureBean? gameComparePictureBean;

  Games3Page(
      {Key? key,
      this.gameComparePictureBean,
      required this.resourceDeliveryInfoBean,
      this.canFinishedManually: false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _Games3PageWidgetState(bean: this.gameComparePictureBean);
  }
}

class _Games3PageWidgetState<T> extends BaseWidgetState<Games3Page>
    implements Observer {
  int numLives = 3;
  GameComparePictureBean? bean;
  int numCorrect = 0;
  int total = 3;
  bool isEnabled = false;
  BoxConstraints? dimens;
  double windowWidth = 0;
  double windowHeight = 0;
  GlobalKey GameWindowWidgetStateGlobalKey = GlobalKey();
  GlobalKey<GameCounterWidgetState> GameCounterGame3WidgetGlobalKey = GlobalKey();

  _Games3PageWidgetState({this.bean}) {
    curPage = "Game3Page";
  }

  @override
  void didUpdateWidget(Games3Page oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print(tag + "didChangeDependencies\n");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {}

  @override
  void dispose() {
    if (Utility.isMobile()) {
      Utility.setScreenOrientationVertical();
    }
    onClickReset(shouldUpdateUI: false);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = false;
    if (Utility.isMobile()) {
      Utility.setScreenOrientationHorizontal();
    }
    // GameComparePictureBean.parseData(this.bean!);
    if (bean != null) {
      GameComparePictureBean.parseData(bean!,
          screenWidth: windowWidth, screenHeight: windowHeight);
    }
    this.numCorrect = 0;
    this.total = this.bean?.answerJson?.length ?? 1;
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    // eventBus.on<EventFn>().listen((event) {
    //   if (event.type == Params.ACTION_UPDATE_SCREEN_SIZE) {
    //     updateUI();
    //   }
    // });
    //初始化table的数据
  }

  bool isMountedLocal = false;

  componentDidMount() {
    this.isMountedLocal = true;
    initData();
    //添加游戏状态改变的监听
    GameCounterManagement.getInstance().addOnGameModeChangeLister(
        onGameModeChangeLister: (int gameStatusModeEnum) {
      if (gameStatusModeEnum == GameStatusModeEnum.WaitingToStart.index) {
        //等待开始状态
        //设置table input是否可以编辑
        isEnabled = false;
      } else if (gameStatusModeEnum ==
          GameStatusModeEnum.ReadyTimeCounting.index) {
        //准备计时状态
        isEnabled = false;
      } else if (gameStatusModeEnum == GameStatusModeEnum.Starting.index) {
        //开始状态
        isEnabled = true;
      } else if (gameStatusModeEnum == GameStatusModeEnum.Finished.index) {
        //完成状态
        isEnabled = false;
      }
      if (mounted == true) {
        updateUI();
      }
    });
  }

  void didOnSizeChangeWidget(
      ScreenType screenType, BoxConstraints dimensParams) {
    // print("1111111");
    // if(this.isMountedLocal == true) {
    //   this.dimens = dimensParams;
    if (windowWidth !=
            GameWindowWidgetStateGlobalKey.currentContext?.size?.width ||
        windowHeight !=
            GameWindowWidgetStateGlobalKey.currentContext?.size?.height)
      windowWidth =
          GameWindowWidgetStateGlobalKey.currentContext?.size?.width ??
              ScreenUtil.getScreenW(context);
    windowHeight =
        GameWindowWidgetStateGlobalKey.currentContext?.size?.height ??
            ScreenUtil.getScreenH(context);
    GameComparePictureBean.parseData(bean!,
        screenWidth: windowWidth, screenHeight: windowHeight);
    updateUI();
    // print("width: ${Keys.GameWindowWidgetStateGlobalKey.currentContext?.size?.width}, height: ${Keys.GameWindowWidgetStateGlobalKey.currentContext?.size?.height}");
    // Future.delayed(Duration(seconds: 3), () {
    // });
    // }
  }

  void onClick(type, data) async {
    switch (type) {
      case 'reset':
        this.onClickReset();
        break;
      case 'complete':
        GameCounterManagement.getInstance().nextStatus();
        break;
    }
  }

  void onClickReset({bool shouldUpdateUI = true}) {
    //清空bean数据
    for (int i = 0; i < (this.bean?.answerJson?.length ?? 0); i++) {
      GameAnswerJsonBean? bean = this.bean?.answerJson?[i];
      if (bean != null) {
        bean.isChecked = false;
      }
    }
    this.numLives = 3;
    this.numCorrect = 0;
    this.total = this.bean?.answerJson?.length ?? 1;
    GameCounterManagement.getInstance().reset();
    if (mounted && shouldUpdateUI == true) {
      this.updateUI();
    }
  }

  /**
   * val1 -正确的个数
   * val2 - 错误的个数，错误个数可能会多，比如多输入了
   * val3 - 总数
   */
  Future<void> requestUpdateTotalFocusTime() async {
    String gameLevel = this.bean?.id ?? ""; //用gamePictureCompare的库代表gameId
    BaseBean response =
        await HttpManager.getInstance().doPostRequest(Apis.gameRankingAdd,
            params: {
              "gameCode":
                  this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
              "gameLevel": gameLevel,
              "username":
                  LoginManager.getInstance().getUserBean().username,
              "avatar": LoginManager.getInstance().getUserBean().avatar,
              "gameTitle":
                  this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
              "gameTitleEn":
                  this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
              "time": GameCounterManagement.getInstance().timeUsed,
              "val1": this.numLives,
              //生命数量
              // "val2": val2, //错误次数
              // "val3": val3,
              // "score":
              //     (val1 * 0.8 + val2 * 0.2), //统计出分数 正确个数权限最高 0.8 错误个数权限次要 0.2
            },
            shouldShowErrorToast: false);
    if (response.success == true) {
      //请求得到 GameRankingBean
      // GameRankingBean gameRankingBean = GameRankingBean.fromJson(response.data);
      //弹出对话框
      Utility.showRankingDialog(
        context: context,
        scene: "game3",
        gameLevel: gameLevel,
        gameRankingBean: GameRankingBean.fromJson(response.data),
        gameCode: this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
      );
      // GameRankingDialogUtil.show(
      //   Utility.getGlobalContext(),
      //   gameRankingBean: GameRankingBean.fromJson(response.data),
      //   gameCode: this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
      //   gameLevel: gameLevel,
      //   title: getI18NKey().ranking,
      // );

      // Game2RankingDialogUtil.show(
      //     Utility.getGlobalContext(),
      //     gameRankingBean: gameRankingBean,
      //     gameMode: SharePreferenceUtil.getSyncInstance().getGameMode(gameCode: this
      //         .widget
      //         .resourceDeliveryInfoBean
      //         .deliveryName
      //         .toString(), defaultGameMode: 'random_by_number'),
      //     title: getI18NKey().ranking,
      //     gameCode: this.widget.resourceDeliveryInfoBean.deliveryName
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

  initData() {
    requestGetRandomItem();
  }

  void requestGetRandomItem() {
    //从gridview过来的 gameComparePictureBean不为空 不需要请求
    if (this.widget.gameComparePictureBean == null) {
      // Loading.show(context);
      HttpManager.getInstance()
          .doPostRequest(Apis.getRandomItem, observer: this);
    }
  }

  Widget baseBuild(BuildContext context) {
    // double screenWidth = context.watch<Env>().screenWidth != 0
    //     ? context.watch<Env>().screenWidth
    //     : ScreenUtil.getScreenW(context);
    // double screenHeight = context.watch<Env>().screenHeight != 0
    //     ? context.watch<Env>().screenHeight
    //     : ScreenUtil.getScreenH(context);
    // print("screenWidth: ${screenWidth}, screenHeight: ${screenHeight}");
    return Stack(
      key: GameWindowWidgetStateGlobalKey,
      children: [
        WidgetManager.getCachedNetworkImage(
            radius: 0,
            width: double.infinity,
            height: double.infinity,
            url: Utility.getRandomBackgroundUrl(context)),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50,
                ),
                CustomGameItemBackground(children: [
                  CustomGameText(text: getI18NKey().finish_level),
                  CustomTableWidget(datas: [
                    Utility.getTableBoolList(
                        num: this.numCorrect, total: this.total)
                  ], itemWidth: 26),
                ]),
                Spacer(
                  flex: 1,
                ),
                GameCounterWidget(
                    gameRankingModeEnum: GameRankingModeEnum.Customized,
                    gameReadyDuration: 5 * 1000,
                    canFinishedManually: false,
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
                    key: GameCounterGame3WidgetGlobalKey,
                    onClickRetry: () {
                      this.onClick('reset', null);
                    },
                    onClickSubmit: () {
                      this.onClick('submit', null);
                    }),
                Spacer(
                  flex: 1,
                ),
                CustomGameItemBackground(
                    decorationWidget: WidgetManager.getCachedNetworkImage(
                        radius: 0,
                        width: 40,
                        height: 40,
                        isLoading: false,
                        url:
                            "http://fsclould.timerbell.com/20220926-game_avatar.png"),
                    children: [
                      CustomGameText(text: getI18NKey().num_lives),
                      Container(
                          width: 70,
                          child: LivesWidget(
                              number: this.numLives,
                              checkedSvgPath: R.assetsImgIcHeart,
                              uncheckedSvgPath: R.assetsImgIcHeart))
                    ]),
                SizedBox(
                  width: 50,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GameComparePicture(
                  listGameAnswerJsonBean: bean?.answerJson ?? [],
                  picRefUrl: bean?.pic1_ref ?? "",
                  picUrl: bean?.pic2 ?? "",
                  onResultCallback: (int numCorrect, total) {
                    this.total = total;
                    this.numCorrect = numCorrect;
                    updateUI();
                    if (numCorrect == total) {
                      GameCounterManagement.getInstance().nextStatus();
                      requestUpdateTotalFocusTime();
                    }
                  },
                  errorCallback: () {
                    if (numLives > 0) {
                      numLives--;
                      if (numLives == 0) {
                        GameCounterManagement.getInstance().nextStatus();
                      }
                    }
                    this.updateUI();
                  },
                  isEnabled: this.isEnabled,
                )
              ],
            )
          ],
        ),
        Utility.isMobile()
            ? CircleBackNavigator(
                onTapListener: (res) {
                  Utility.popNavigator(context);
                },
              )
            : SizedBox.shrink(),
      ],
    );
  }

  @override
  void update(Observable o, BaseBean response, String scene) {
    // TODO: implement update
    Loading.hide(context);
    if (response.success) {
      if (scene == Apis.getRandomItem) {
        bean = GameComparePictureBean.fromJson(response.data);
        this.total = this.bean?.answerJson?.length ?? 1;
        // GameComparePictureBean.parseData(bean!, screenWidth: windowWidth, screenHeight: windowHeight);
        updateUI();
      }
    } else {
      Utility.showToastMsg(msg: response.message);
    }
  }
}
