import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/gamesPage/components/RandomContainerWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../../r.dart';
import '../../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../../config/ColorsConfig.dart';
import '../../../../config/ENUMS.dart';
import '../../../../config/Params.dart';
import '../../../../models/SquareModel.dart';
import '../../../../util/GameCounterManagement.dart';
import '../../../../util/SharePreferenceUtil.dart';
import '../../components/GameCounterWidget.dart';

class Games1Page extends BaseWidget {
  ResourceDeliveryInfoBean resourceDeliveryInfoBean;
  bool? canFinishedManually;

  Games1Page(
      {Key? key,
      required this.resourceDeliveryInfoBean,
      this.canFinishedManually: false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _Games1PageWidgetState();
  }
}

class _Games1PageWidgetState<T> extends BaseWidgetState<Games1Page> {
  List<SquareModel> randomArrayData = [];
  GlobalKey<GameCounterWidgetState> GameCounterWidgetGlobalKey = GlobalKey();
  int numPoints = 3;
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
    initGameMode(SharePreferenceUtil.getSyncInstance().getGameMode(
        gameCode: this.widget.resourceDeliveryInfoBean.deliveryName.toString(),
        defaultGameMode: Game1EngLevelModeEnum.level1_num_10.toString()));
    randomArrayData = Utility.generateRandomSquareModelList(
        numberPoint: numPoints, containerHeight: 400, containerWidth: 300);
  }

  void reset() {
    randomArrayData = Utility.generateRandomSquareModelList(
        numberPoint: numPoints, containerHeight: 400, containerWidth: 300);
    updateUI();
  }

  componentDidMount() {
    // GameCounterManagement.getInstance().addOnGameModeChangeLister(
    //     onGameModeChangeLister: (int gameStatusModeEnum) {
    //       if (gameStatusModeEnum ==
    //           GameStatusModeEnum.WaitingToStart.index) {} else
    //       if (gameStatusModeEnum ==
    //           GameStatusModeEnum.ReadyTimeCounting.index) {} else
    //       if (gameStatusModeEnum == GameStatusModeEnum.Starting.index) {} else
    //       if (gameStatusModeEnum == GameStatusModeEnum.Finished.index) {}
    //       if (mounted == true) {
    //         updateUI();
    //       }
    //     });
  }

  /**
   * 点击重新开始
   */
  void onClickReset() {
    randomArrayData = Utility.generateRandomSquareModelList(
        numberPoint: numPoints, containerHeight: 400, containerWidth: 300);
    updateUI();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'reset':
        reset();
        break;
      case '':
        break;
    }
  }

  // Widget baseDesktoptBuild(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: SingleChildScrollView(
  //         child: Column(
  //       children: [],
  //     )),
  //   );
  // }

  void initGameMode(String gameModel) {
    if (gameModel == Game1EngLevelModeEnum.level1_num_10.toString()) {
      numPoints = 10;
    } else if (gameModel == Game1EngLevelModeEnum.level2_num_20.toString()) {
      numPoints = 20;
    } else if (gameModel == Game1EngLevelModeEnum.level3_num_50.toString()) {
      numPoints = 50;
    }
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
                GameCounterWidget(
                  canFinishedManually: this.widget.canFinishedManually!,
                  key: GameCounterWidgetGlobalKey,
                  onClickRetry: () {
                    this.onClick('reset', null);
                  },
                  gameCode: this
                      .widget
                      .resourceDeliveryInfoBean
                      .deliveryName.toString(),
                  gameTitle: this.widget.resourceDeliveryInfoBean.resourceTitle.toString(),
                ),
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
                                    fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)))),
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
                                    fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffc0c0c0)))),
                          ]),
                      textDirection: TextDirection.ltr,
                    ),
                  ]))
            ],
          ),
          RandomContainerWidget(
            width: 300,
            height: 400,
            list: randomArrayData,
            onComplete: () {
              GameCounterWidgetGlobalKey.currentState!.nextStatus();
              randomArrayData = Utility.generateRandomSquareModelList(
                  numberPoint: 15, containerHeight: 400, containerWidth: 300);
            },
          ),
        ],
      )),
    );
  }

  List<PopupMenuEntry<String>> getPopupMenuList() {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: Game1EngLevelModeEnum.level1_num_10.toString(),
        child: Text(getI18NKey().level1_num_10,
            style: TextStyle(fontSize: 13)),
      ),
      PopupMenuItem<String>(
        value: Game1EngLevelModeEnum.level2_num_20.toString(),
        child: Text(
          getI18NKey().level2_num_20,
          style: TextStyle(fontSize: 13),
        ),
      ),
      PopupMenuItem<String>(
        value: Game1EngLevelModeEnum.level3_num_50.toString(),
        child: Text(
          getI18NKey().level3_num_50,
          style: TextStyle(fontSize: 13),
        ),
      ),
    ];
  }
}
