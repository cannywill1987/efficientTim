import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/BaseBean.dart';
import '../../../beans/GameRankingBean.dart';
import '../../../common/httpclient/HttpManager.dart';
import '../../../components/CustomTextButton.dart';
import '../../../components/GameBagdgeWIdget.dart';
import '../../../config/Params.dart';
import '../../../util/GameCounterManagement.dart';
import '../../../util/SharePreferenceUtil.dart';
import 'GameRankingDialogUtil.dart';

class GameCounterWidget extends StatefulWidget {
  String gameCode = "gameCode";
  String gameTitle = "gameTitle";
  String gameTitleEn = "gameTitleEn";
  bool canFinishedManually = false;
  bool counterStartAuto = true; // 计数器是否自动执行
  int gameStartingDuration = 30 * 60 * 1000 * 1000;
  int gameReadyDuration = 3 * 1000;
  bool shouldRequestUpdateTimeAuto = true;
  Function onClickRetry;
  Function? onClickSubmit;
  Function? onComplete;
  GameRankingModeEnum? gameRankingModeEnum;

  GameCounterWidget(
      {required Key key,
      this.gameReadyDuration = 3 * 1000,
      this.gameStartingDuration = 30 * 60 * 1000 * 1000,
      this.counterStartAuto = true,
      required this.gameCode,
      required this.gameTitle,
      this.gameRankingModeEnum = GameRankingModeEnum.TimeCounting,
      this.gameTitleEn = "gameTitleEn",
      this.canFinishedManually = false,
      this.shouldRequestUpdateTimeAuto: true,
      this.onComplete,
      required this.onClickRetry,
      this.onClickSubmit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GameCounterWidgetState();
  }
}

class GameCounterWidgetState extends State<GameCounterWidget> {
  Function? onRequestFinish;
  Function? onTimerTick;
  Function? onUpdateUI;
  bool isDisposed = false;
  bool isHover = false;

  @override
  void initState() {
    GameCounterManagement.getInstance().init(
        readyTime: this.widget.gameReadyDuration,
        duration: this.widget.gameStartingDuration);
    if (this.widget.counterStartAuto == true) {
      GameCounterManagement.getInstance().nextStatus();
    }

    GameCounterManagement.getInstance().addOnTimerTickListener(
        onTimerTickListener: onTimerTick = (timer) {
      if (mounted == true) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    if (onTimerTick != null) {
      GameCounterManagement.getInstance()
          .removeRequestFinishListener(onRequestFinishListener: onTimerTick!);
    }
    GameCounterManagement.getInstance().pauseTimer();
    GameCounterManagement.getInstance().reset();
    this.isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RawKeyboardListener(
        autofocus: true,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent) {
            if (event.physicalKey == PhysicalKeyboardKey.enter ||
                event.isAltPressed == PhysicalKeyboardKey.space) {
              if (this.widget.canFinishedManually == true ||
                  GameCounterManagement.getInstance().gameStatusModeEnum !=
                      GameStatusModeEnum.Starting) {
                nextStatus();
              }
            }
          }
        },
        focusNode: FocusNode(),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: Utility.isHandsetBySize() ? 0 : 0),
                child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        this.isHover = true;
                      });
                    },
                    onHover: (_) {},
                    onExit: (_) {
                      setState(() {
                        this.isHover = false;
                      });
                    },
                    child: GestureDetector(
                        onDoubleTap: () {
                          if (!Utility.isHandsetBySize()) {
                            // onClickPushMissionDetailPage(context);
                          }
                        },
                        onTap: () {
                          if (Utility.isHandsetBySize()) {
                            // onClickPushMissionDetailPage(context);
                          }
                        },
                        child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: Utility.isHandsetBySize()
                                    ? BorderRadius.circular(25)
                                    : BorderRadius.circular(8)),
                            child: getPCGameCounterWidget(context)))))));
  }

  SizedBox getPCGameCounterWidget(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 55,
        child: Stack(
          children: [
            Container(
                height: 55,
                width: 250,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: ColorsConfig.listColorsLightBlueToBlue),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        Utility.getTimeStringValue(
                            GameCounterManagement.getInstance().timeUsed),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Spacer(),
                      this.widget.canFinishedManually == true ||
                              GameCounterManagement.getInstance()
                                      .gameStatusModeEnum !=
                                  GameStatusModeEnum.Starting
                          ? Card(
                              color: Colors.blue,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(23))),
                              child: Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.blue),
                                  child: getTextButton()))
                          : getTextButton(),
                      //暂停
                      SizedBox(
                        width: 10,
                      ),
                    ])),
            //扩大
            Positioned(
                left: 3,
                top: 3,
                child: CustomTextButton(
                  width: 10,
                  height: 10,
                  onPressed: () {},
                  child: SizedBox.shrink(),
                )),
            (GameCounterManagement.getInstance().gameStatusModeEnum ==
                        GameStatusModeEnum.ReadyTimeCounting &&
                    GameCounterManagement.getInstance().timeUsed > 0)
                ? Align(
                    alignment: Alignment.topLeft,
                    child: GameBadgetWidget(
                        title: GameCounterManagement.getInstance()
                                        .gameStatusModeEnum ==
                                    GameStatusModeEnum.ReadyTimeCounting &&
                                GameCounterManagement.getInstance().timeUsed > 2
                            ? "Ready"
                            : GameCounterManagement.getInstance()
                                            .gameStatusModeEnum ==
                                        GameStatusModeEnum.ReadyTimeCounting &&
                                    Utility.getSeconds(
                                            GameCounterManagement.getInstance()
                                                .timeUsed) ==
                                        "01"
                                ? "Go"
                                : "",
                        color: Color(0xffffffff)))
                : SizedBox.shrink()
          ],
        ));
  }

  TextButton getTextButton() {
    return TextButton(
      onPressed: () {
        if (this.widget.canFinishedManually == true ||
            GameCounterManagement.getInstance().gameStatusModeEnum !=
                GameStatusModeEnum.Starting) {
          nextStatus();
        }
      },
      child: Text(
        GameCounterManagement.getInstance().gameStatusModeEnum ==
                GameStatusModeEnum.ReadyTimeCounting
            ? getI18NKey().readying
            : GameCounterManagement.getInstance().gameStatusModeEnum ==
                    GameStatusModeEnum.Starting
                ? (this.widget.canFinishedManually == true
                    ? getI18NKey().finish
                    : getI18NKey().ongoing)
                : GameCounterManagement.getInstance().gameStatusModeEnum ==
                        GameStatusModeEnum.Finished
                    ? getI18NKey().retry
                    : "",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  void nextStatus() {
    if (GameCounterManagement.getInstance().gameStatusModeEnum ==
        GameStatusModeEnum.Starting) {
      GameCounterManagement.getInstance().nextStatus();
      if (this.widget.gameRankingModeEnum == GameRankingModeEnum.TimeCounting) {
        this.requestGameRankingAdd(
            value: GameCounterManagement.getInstance().timeUsed);
      }
      if (this.widget.onClickSubmit != null) {
        this.widget.onClickSubmit!();
      }
    } else if (GameCounterManagement.getInstance().gameStatusModeEnum ==
        GameStatusModeEnum.ReadyTimeCounting) {
      GameCounterManagement.getInstance().nextStatus();
    } else if (GameCounterManagement.getInstance().gameStatusModeEnum ==
        GameStatusModeEnum.Finished) {
      this.widget.onClickRetry();
      GameCounterManagement.getInstance().nextStatus();
    }
    setState(() {});
  }

  Future<void> requestGameRankingAdd({required int value}) async {
    if (this.widget.shouldRequestUpdateTimeAuto == false) return;
    BaseBean response =
        await HttpManager.getInstance().doPostRequest(Apis.gameRankingAdd,
            params: {
              "gameCode": this.widget.gameCode,
              "gameLevel": SharePreferenceUtil.getSyncInstance().getGameMode(
                  gameCode: this.widget.gameCode,
                  defaultGameMode: 'random_by_number'),
              "username":
                  LoginManager.getInstance().getUserBean().username,
              "avatar": LoginManager.getInstance().getUserBean().avatar,
              "gameTitle": this.widget.gameTitle,
              "gameTitleEn": this.widget.gameTitleEn,
              "time": GameCounterManagement.getInstance().timeUsed
            },
            shouldShowErrorToast: false);
    if (response.success == true) {
      GameRankingDialogUtil.show(
        Utility.getGlobalContext(),
        gameRankingBean: GameRankingBean.fromJson(response.data),
        gameLevel: SharePreferenceUtil.getSyncInstance().getGameMode(
            gameCode: this.widget.gameCode,
            defaultGameMode: 'random_by_number'),
        gameCode: this.widget.gameCode,
        title: getI18NKey().ranking,
      );
    } else {}
  }

// static String getTimeStringValue() {
// return Utility.getMins(GameCounterManagement.getInstance().curTimeF) != '00'
//     ? Utility.getMins(GameCounterManagement.getInstance().curTimeF)
//     : Utility.getSeconds(GameCounterManagement.getInstance().curTimeF) != '00'
//         ? Utility.getSeconds(GameCounterManagement.getInstance().curTimeF)
//         : '00';
// }

}
