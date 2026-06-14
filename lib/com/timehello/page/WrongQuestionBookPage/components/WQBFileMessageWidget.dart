import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_hello/com/timehello/util/AudioPlayUtil.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import '../../../config/ENUMS.dart';
import '../../../util/Utility.dart';

/// A class that represents file message widget.
/// 播放audio的文件
class WQBFileMessageWidget extends StatefulWidget {
  // bool isLoading = true;
  final Map data;
  final SaveModeEnum saveModeEnum;
  final Function onTapDelete;

  WQBFileMessageWidget(
      {required this.data,
      required this.saveModeEnum,
      required this.onTapDelete}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBFileMessageWidgetState();
  }
}

class WQBFileMessageWidgetState extends State<WQBFileMessageWidget>
    with SingleTickerProviderStateMixin {
  double width = 300;
  double height = 45;
  String timeLabel = "";
  String hour = "";
  String min = "";
  String secs = "";
  int duration = 0;
  String localUrl = "";
  String url = "";
  String recordText = "";
  int fileSize = 0;
  double progress = 0;
  double bufferProgress = 0;
  Ticker? _ticker;
  AnimationController? animationController;
  int position = 0;

  @override
  void initState() {
    super.initState();
    try {
      Map map = this.widget.data;
      duration = map['duration'];
      localUrl = map['localUrl'];
      url = map['url'];
      fileSize = map['file'] ?? map['fileSize'] ?? 0;
      // recordText 是 AI 转写后的文本，和当前音频记录放在同一个 map 里。
      recordText = (map['recordText'] ??
              map['record_text'] ??
              map['transcription'] ??
              '')
          .toString()
          .trim();
      // timeLabel = Utility.getTime(duration * 1000);
    } catch (e) {}
  }

  void startAnim() {
    if (animationController == null) {
      animationController = new AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
        vsync: this,
      )..repeat();
      _ticker = this.createTicker((elapsed) {
        // 这里是动画循环的回调
        setState(() {
          progress = (AudioPlayUtil.getInstance()
                      ?.audioPlayer
                      ?.position
                      .inMilliseconds ??
                  0) /
              (AudioPlayUtil.getInstance()
                      ?.audioPlayer
                      ?.duration
                      ?.inMilliseconds ??
                  1);
          // 更新 UI
        });
      })
        ..start();
      animationController?.addListener(() {});
      animationController!.forward();
    }
  }

  void stopAnim() {
    animationController?.stop();
    animationController?.dispose();
    _ticker?.dispose();
    _ticker = null;
    animationController = null;
    // if (animationController == null) {
    //   animationController = new AnimationController(
    //     animationBehavior: AnimationBehavior.preserve,
    //     duration: const Duration(milliseconds: 400),
    //     reverseDuration: const Duration(milliseconds: 400), vsync: null,
    //   )
    //     ..repeat();
    //   _ticker = this.createTicker((elapsed) {
    //     // 这里是动画循环的回调
    //     setState(() {
    //       // 更新 UI
    //     });
    //   })
    //     ..start();
    //   animationController?.addListener(() {
    //
    //   });
    //   animationController!.forward();
    // }
  }

  @override
  void dispose() {
    animationController?.dispose();
    _ticker?.dispose();
    AudioPlayUtil.getInstance()?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = 5;
    width = ScreenUtil.getInstance().screenWidth - 200;
    if (width > 260) {
      width = 260;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
                onTap: () {
                  if (this.localUrl.isEmpty == true &&
                      this.url.isEmpty == true) {
                    return;
                  }
                  if (File(this.localUrl).existsSync() == true) {
                    if (AudioPlayUtil.getInstance()?.audioPlayer?.playing ==
                            false ||
                        AudioPlayUtil.getInstance()?.curPath != this.localUrl) {
                      //没有播放中
                      playUrl(this.localUrl);
                    } else {
                      if (AudioPlayUtil.getInstance()?.audioPlayer?.playing ==
                          true) {
                        AudioPlayUtil.getInstance()?.audioPlayer?.pause();
                      }
                    }
                  } else {
                    // if(AudioPlayUtil.getInstance()?.audioPlayer?.playerState.processingState != ProcessingState.loading) {
                    if (AudioPlayUtil.getInstance()?.audioPlayer?.playing ==
                            false ||
                        AudioPlayUtil.getInstance()?.curPath != this.url) {
                      //没有播放中
                      playUrl(this.url);
                    } else {
                      if (AudioPlayUtil.getInstance()?.audioPlayer?.playing ==
                          true) {
                        AudioPlayUtil.getInstance()?.audioPlayer?.pause();
                      }
                    }
                    // } else {
                    //   AudioPlayUtil.getInstance()?.stop();
                    // }
                  }
                },
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Container(
                    width: width - 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                this.widget.data[''] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 11),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              timeLabel,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 10),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        LineProgressBarWidget(
                            width: width - 30,
                            progress: progress,
                            bufferProgress: bufferProgress),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // this.widget.data.eventType ==
                                //         "note_voice"
                                //     ? getI18NKey().note_diary
                                Utility.getDifTime(
                                    Utility.getDateTimeFromString(
                                        this.widget.data['createdAt'] ?? "")),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 10),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  Utility.getDateTimeYMDHM(
                                          Utility.getDateTimeFromString(
                                              this.widget.data['createdAt'] ??
                                                  "")) ??
                                      "",
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 11),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff3499DD),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(radius),
                          topLeft: Radius.circular(radius),
                          topRight: Radius.circular(radius),
                          bottomRight: Radius.circular(radius))),
                )),
            this.widget.saveModeEnum == SaveModeEnum.normal
                ? SizedBox.shrink()
                : InkWell(
                    onTap: () {
                      this.widget.onTapDelete.call(this.widget.data);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.circular(40)),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  )
          ],
        ),
        if (recordText.isNotEmpty) _buildRecordTextBubble(),
      ],
    );
  }

  /// 功能：展示录音对应的 AI 转写文字，保证从数据库反查出来时能看到音频文本。
  Widget _buildRecordTextBubble() {
    return Container(
      width: width,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Color(0xff3499DD).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xff3499DD).withValues(alpha: 0.18),
        ),
      ),
      child: SelectableText(
        recordText,
        style: TextStyle(
          color: Color(0xff255f86),
          fontSize: 12,
          height: 1.45,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  void playUrl(String path) {
    if (AudioPlayUtil.getInstance()?.audioPlayer?.playerState.processingState !=
        ProcessingState.loading) {
      AudioPlayUtil.getInstance()?.play(path,
          loopMode: LoopMode.off, volume: 100, shouldForcePlay: true);
      AudioPlayUtil.getInstance()
          ?.setOnPositionListener((position, duration, buffferPos) {
        this.position = position;
        this.duration = duration;
        progress = position.toDouble() / duration.toDouble();
        bufferProgress = buffferPos.toDouble() / duration.toDouble();
        timeLabel = Utility.getTime(position);
        if (mounted == true) {
          setState(() {});
        }
      });
      AudioPlayUtil.getInstance()
          ?.setOnStateChangeListener((ProcessingState val) {
        if (val == ProcessingState.loading) {
          timeLabel = getI18NKey().loading;
        } else if (val == ProcessingState.idle) {
          timeLabel = Utility.getTime(this.duration);
        } else {
          timeLabel = Utility.getTime(position);
        }
        if (mounted == true) {
          setState(() {});
        }
      });
    } else {
      AudioPlayUtil.getInstance()?.stop();
    }
  }
}

class LineProgressBarWidget extends StatelessWidget {
  final double width;
  final double progress;
  final double bufferProgress;

  LineProgressBarWidget(
      {required this.width,
      required this.progress,
      required this.bufferProgress});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double progressWidth = width * progress;
    double bufferedProgressWidth = width * bufferProgress;
    return Stack(
      children: [
        Container(
          width: width,
          height: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xff2fe2c2))),
        ),
        Container(
          width: progressWidth >= 0 ? progressWidth : 0,
          height: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff2fe2c2)),
        ),
        Container(
          width: bufferedProgressWidth >= 0 ? bufferedProgressWidth : 0,
          height: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xa02fe2c2)),
        ),
      ],
    );
  }
}
