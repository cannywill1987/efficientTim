import "dart:math";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomPainterCircleProgressWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import 'CustomTextButton.dart';
import 'dart:math';

class BottomCounterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BottomCounterWidgetState();
  }
}

class BottomCounterWidgetState extends State<BottomCounterWidget> {
  Function? onRequestFinish;
  Function? onTimerTick;
  Function? onUpdateUI;
  bool isDisposed = false;
  bool isHover = false;

  // bool draggable = true;

  Offset prevOffset = Offset(0, 0);
  Offset curOffset = Offset(SharePreferenceUtil.getSyncInstance().getMobileCounterPosX(), SharePreferenceUtil.getSyncInstance().getMobileCounterPosY());
  Offset curLocalOffset = Offset(SharePreferenceUtil.getSyncInstance().getLocalMobileCounterPosX(),SharePreferenceUtil.getSyncInstance().getLocalMobileCounterPosY());
  // //静止状态下的offset
  // Offset idleOffset = Offset(0, 0);
  // //本次移动的offset
  // Offset moveOffset = Offset(-1, -1);
  // //最后一次down事件的offset
  // Offset lastStartOffset = Offset(0, 0);


  @override
  void initState() {
    curOffset = Offset(SharePreferenceUtil.getSyncInstance().getMobileCounterPosX(), SharePreferenceUtil.getSyncInstance().getMobileCounterPosY());
    curLocalOffset = Offset(SharePreferenceUtil.getSyncInstance().getLocalMobileCounterPosX(),SharePreferenceUtil.getSyncInstance().getLocalMobileCounterPosY());
    // idleOffset = moveOffset * 1;
    CounterManagement counterManagement = CounterManagement.getInstance();
    counterManagement.addOnRequestFinishListener(
        onRequestFinishListener: onRequestFinish = (MissionModel missionModel) {
      if (isDisposed == false) {
        Future.delayed(Duration(milliseconds: 200)).then((e) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
    counterManagement.addOnTimerTickListener(
        onTimerTickListener: onTimerTick = (int time) {
      if (isDisposed == false) {
        Future.delayed(Duration(milliseconds: 200)).then((e) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
    counterManagement.addOnUpdateUIListener(
        onUpdateUIListener: onUpdateUI = () {
      if (isDisposed == false) {
        Future.delayed(Duration(milliseconds: 200)).then((e) {
          if(mounted == true) {
            setState(() {});
          }
        });
      }
    });
  }


  @override
  void didUpdateWidget(BottomCounterWidget oldWidget) {
    curOffset = Offset(SharePreferenceUtil.getSyncInstance().getMobileCounterPosX(), SharePreferenceUtil.getSyncInstance().getMobileCounterPosY());
    // idleOffset = moveOffset * 1;
  }

  @override
  void dispose() {
    super.dispose();
    this.isDisposed = true;
    // NotificationUtil.getInstance().hideAllNotification();
    CounterManagement.getInstance().removeOnRequestFinishListener(
        onRequestFinishListener: onRequestFinish!);
    CounterManagement.getInstance()
        .removeOnTimerTickListenerList(onTimerTickListenerList: onTimerTick!);
    CounterManagement.getInstance()
        .removeOnUpdateUIListener(onUpdateUIListener: onUpdateUI!);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size = MediaQuery.of(context).size;
    // print("1111111" + draggable.toString());
    return
      Utility.isHandsetBySize() == true ? Positioned(
        top: curOffset.dy - curLocalOffset.dy,
        left:  curOffset.dx - curLocalOffset.dx,
        child: GestureDetector(
          // 移动开始
          onPanStart: (DragStartDetails details) {
            print("start, ${curLocalOffset.dx}, ${curLocalOffset.dy}, ${curOffset.dx}, ${curOffset.dy}");
            // print("global dx:${details.globalPosition.dx},global dy:${details.globalPosition.dy}, local dx:${details.localPosition.dx},local dy:${details.localPosition.dy},");
              curLocalOffset = details.localPosition;
            setState(() {
              curOffset = Offset(details.globalPosition.dx , details.globalPosition.dy);
              // moveOffset = lastStartOffset;
              // draggable = true;
            });
          },
          // 移动中
          onPanUpdate: (DragUpdateDetails details) {
            print("update, ${curLocalOffset.dx}, ${curLocalOffset.dy}, ${curOffset.dx}, ${curOffset.dy}, ${details.delta.dx}, ${details.delta.dy}");
             // prevOffset = Offset(curOffset.dx, curOffset.dy);
             // curOffset = Offset(curOffset.dx - (prevOffset.dx - details.globalPosition.dx - details.localPosition.dx), curOffset.dy - (prevOffset.dy - details.globalPosition.dy - details.localPosition.dy));
            // if((curOffset.dx - details.globalPosition.dx).abs() <10 && (curOffset.dy - details.globalPosition.dy).abs() <10) {
            if((details.globalPosition.dx + curLocalOffset.dx + 40) < size.width && (details.globalPosition.dy + curLocalOffset.dy + 40) < size.height) {
              curOffset =
                  Offset(details.globalPosition.dx, details.globalPosition.dy);
              setState(() {});
            }
            // }
          },
          // 移动结束
          onPanEnd: (DragEndDetails detail) {
            print("end");
            // setState(() {
            //   idleOffset = moveOffset * 1;
            // });
            // prevOffset = Offset(curOffset.dx, curOffset.dy);
            // curOffset = detail.globalPosition;
            if(curOffset.dx > 0) SharePreferenceUtil.getSyncInstance().setMobileCounterPosX(curOffset.dx);
            if(curOffset.dy > 0) SharePreferenceUtil.getSyncInstance().setMobileCounterPosY(curOffset.dy);
            if(curLocalOffset.dx > 0) SharePreferenceUtil.getSyncInstance().setLocalMobileCounterPosX(curLocalOffset.dx);
            if(curLocalOffset.dy > 0) SharePreferenceUtil.getSyncInstance().setLocalMobileCounterPosY(curLocalOffset.dy);
          },
          child: getCounterWidget(context)
        ),
      ) : Positioned(
        top: curOffset.dy - curLocalOffset.dy,
        left:  size.width / 2 - 35,
        child: GestureDetector(
          // 移动开始
            onPanStart: (DragStartDetails details) {
              print("start, ${curLocalOffset.dx}, ${curLocalOffset.dy}, ${curOffset.dx}, ${curOffset.dy}");
              // print("global dx:${details.globalPosition.dx},global dy:${details.globalPosition.dy}, local dx:${details.localPosition.dx},local dy:${details.localPosition.dy},");
              curLocalOffset = details.localPosition;
              setState(() {
                curOffset = Offset(details.globalPosition.dx , details.globalPosition.dy);
                // moveOffset = lastStartOffset;
                // draggable = true;
              });
            },
            // 移动中
            onPanUpdate: (DragUpdateDetails details) {
              print("update, ${curLocalOffset.dx}, ${curLocalOffset.dy}, ${curOffset.dx}, ${curOffset.dy}, ${details.delta.dx}, ${details.delta.dy}");
              // prevOffset = Offset(curOffset.dx, curOffset.dy);
              // curOffset = Offset(curOffset.dx - (prevOffset.dx - details.globalPosition.dx - details.localPosition.dx), curOffset.dy - (prevOffset.dy - details.globalPosition.dy - details.localPosition.dy));
              // if((curOffset.dx - details.globalPosition.dx).abs() <10 && (curOffset.dy - details.globalPosition.dy).abs() <10) {
              if((details.globalPosition.dx + curLocalOffset.dx + 40) < size.width && (details.globalPosition.dy + curLocalOffset.dy + 40) < size.height) {
                // if(details.globalPosition.dy < 40) {
                //   details.globalPosition.dy = 40;
                // }
                curOffset =
                    Offset(details.globalPosition.dx, details.globalPosition.dy < 40 ? 40 : details.globalPosition.dy);
                setState(() {});
              }
              // }
            },
            // 移动结束
            onPanEnd: (DragEndDetails detail) {
              print("end");
              // setState(() {
              //   idleOffset = moveOffset * 1;
              // });
              // prevOffset = Offset(curOffset.dx, curOffset.dy);
              // curOffset = detail.globalPosition;
              // if(curOffset.dx > 0) SharePreferenceUtil.getSyncInstance().setMobileCounterPosX(curOffset.dx);
              if(curOffset.dy > 0) SharePreferenceUtil.getSyncInstance().setMobileCounterPosY(curOffset.dy);
              // if(curLocalOffset.dx > 0) SharePreferenceUtil.getSyncInstance().setLocalMobileCounterPosX(curLocalOffset.dx);
              if(curLocalOffset.dy > 0) SharePreferenceUtil.getSyncInstance().setLocalMobileCounterPosY(curLocalOffset.dy);
            },
            child: getCounterWidget(context)
        ),
      );
  }

  SingleChildRenderObjectWidget getCounterWidget(BuildContext context) {
    //通过这里判断底部的计数器是否应该显示
    return CounterManagement.getInstance().missionModel != null
            ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: Utility.isHandsetBySize() ? 20 : 70),
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
                            onClickPushMissionDetailPage(context);
                          }
                        },
                        onTap: () {
                          if (Utility.isHandsetBySize()) {
                            onClickPushMissionDetailPage(context);
                          }
                        },
                        child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: Utility.isHandsetBySize()
                                    ? BorderRadius.circular(25)
                                    : BorderRadius.circular(8)),
                            child: Utility.isHandsetBySize()
                                ? getMobileBottomCounterWidget(context)
                                : getPCBottomCounterWidget(context))))))
            : SizedBox.shrink();
  }

  getMobileBottomCounterWidget(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:
                  CounterManagement.getInstance().shouldShowRedFocusStatus()
                      ? ColorsConfig.listColorsLightRedToRed
                      : ColorsConfig.listColorsLightBlueToBlue),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomPaint(
              size: Size(40, 40),
              painter: CustomPainterCircleProgressWidget(
                  progress: CounterManagement.getInstance()
                          .shouldShowRedFocusStatus()
                      ? 1 -
                          (CounterManagement.getInstance().curTimeF) /
                              SharePreferenceUtil.getSyncInstance()!.getTomatoTime()
                      : 1 -
                          (CounterManagement.getInstance().curTimeF) /
                              SharePreferenceUtil.getSyncInstance()!
                                  .getTomatoRestTime(),
                  ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  getTimeStringValue(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))
          ],
        ));
  }

  Stack getPCBottomCounterWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 55,
            width: 250,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: CounterManagement.getInstance()
                          .shouldShowRedFocusStatus()
                      ? ColorsConfig.listColorsLightRedToRed
                      : ColorsConfig.listColorsLightBlueToBlue),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              CustomPaint(
                                size: Size(40, 40),
                                painter: CustomPainterCircleProgressWidget(
                                    progress: CounterManagement.getInstance()
                                            .shouldShowRedFocusStatus()
                                        ? 1 -
                                            (CounterManagement.getInstance()
                                                        .curTimeF) /
                                                SharePreferenceUtil
                                                        .getSyncInstance()!
                                                    .getTomatoTime()
                                        : 1 -
                                            (CounterManagement.getInstance()
                                                        .curTimeF) /
                                                SharePreferenceUtil
                                                        .getSyncInstance()!
                                                    .getTomatoRestTime(),
                                    ),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    getTimeStringValue(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ))
                            ],
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    CounterManagement.getInstance().missionModel?.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  //暂停
                  CounterManagement.getInstance().counterStatus ==
                          CounterStatus.focusing
                      ? CustomTextButton(
                            width: 25,
                            height: 25,
                            onPressed: () {
                              CounterManagement.getInstance().nextStatus(true);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(Icons.pause,
                                color: Colors.white, size: 20),
                          ),
                        )
                      : SizedBox.shrink(),
                  //完成
                  CounterManagement.getInstance().counterStatus ==
                          CounterStatus.relaxing
                      ?  CustomTextButton(
                    width: 25,
                    height: 25,
                    onPressed: () {
                            CounterManagement.getInstance().nextStatus(true);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child:
                                Icon(Icons.done, color: Colors.white, size: 20),
                          ),
                        )
                      : SizedBox.shrink(),
                  //启动
                  (CounterManagement.getInstance().counterStatus ==
                              CounterStatus.waitingToStartRelaxing ||
                          CounterManagement.getInstance().counterStatus ==
                              CounterStatus.pausingFocusing ||
                          CounterManagement.getInstance().counterStatus ==
                              CounterStatus.waitingToFocus)
                      ?  CustomTextButton(
                      width: 25,
                      height: 25,
                      onPressed: () {
                            CounterManagement.getInstance().nextStatus(true);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 20),
                          ))
                      : SizedBox.shrink(),
                  SizedBox(
                    width: 5,
                  ),
                  //停止
                  CounterManagement.getInstance().counterStatus ==
                          CounterStatus.pausingFocusing
                      ?  CustomTextButton(
                      width: 25,
                      height: 25,
                      onPressed: () {
                            CounterManagement.getInstance()
                                .stopFromFocusingStatus();
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child:
                                Icon(Icons.stop, color: Colors.white, size: 15),
                          ))
                      : SizedBox.shrink(),
                  SizedBox(
                    width: 10,
                  ),
                ])),
        //扩大
        Positioned(
            left: 3,
            top: 3,
            child:  CustomTextButton(
              width: 10,
              height: 10,
              onPressed: () {
                if (CounterManagement.getInstance().missionModel?.objectId !=
                    null) {
                  onClickPushMissionDetailPage(context);
                }
              },
              child: this.isHover
                  ? Icon(Icons.open_in_full, color: Colors.white, size: 10)
                  : SizedBox.shrink(),
            ))
      ],
    );
  }

  static String getTimeStringValue() {
    return Utility.getMins(CounterManagement.getInstance().curTimeF) != '00'
        ? Utility.getMins(CounterManagement.getInstance().curTimeF)
        : Utility.getSeconds(CounterManagement.getInstance().curTimeF) != '00'
            ? Utility.getSeconds(CounterManagement.getInstance().curTimeF)
            : '00';
  }

  void onClickPushMissionDetailPage(BuildContext context) {
    OverlayManagement.getInstance().openMissionDetailPageOverlay(
        context: context,
        missionModel: CounterManagement.getInstance().missionModel ?? MissionModel(),
        folderModel: CounterManagement.getInstance().folderModel ?? FolderModel());
    // Utility.pushNavigator(
    //     context,
    //     new MissionDetailPage(
    //       missionModel: CounterManagement.getInstance()?.missionModel,
    //       folderModel: CounterManagement.getInstance()?.folderModel,
    //     ));
  }
}
