/*
 * @Descripttion:
 * @version:
 * @Author: lzb
 * @Date: 2020-09-07 15:44:44
 * @LastEditors: lichuang
 * @LastEditTime: 2020-09-08 19:07:18
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:time_hello/com/timehello/util/PermissionManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../r.dart';
import '../../beans/BaseBean.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../config/ColorsConfig.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/EventFn.dart';
import '../../util/DialogManagement.dart';
import '../../util/EasyLoadingManager.dart';
import '../../util/RecorderManager.dart';
import '../../util/ScreenUtil.dart';

enum RecordPlayState {
  record, //准备开始
  recording, //记录中
  pausing, // 暂停中
}

class RecordPage extends StatefulWidget {
  final RichTextModeEnum richTextModeEnum;

  const RecordPage({required this.richTextModeEnum});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with TickerProviderStateMixin {
  RecordPlayState _state = RecordPlayState.record;
  double iconSize = 50;
  String _recorderTxt = '00:00:00';
  String maxRecordTime = "";
  double _dbLevel = 0.0;
  int _maxLength = 10 * 60; //时间改成后台可配置 比如在用户表里支持

  @override
  void initState() {
    super.initState();
    String hour = Utility.formatDecimal(
        Utility.getHourFromTimeStamp(_maxLength * 1000),
        shouldAddZero: true);
    String min = Utility.formatDecimal(
        Utility.getMinsFromTimeStamp(_maxLength * 1000),
        shouldAddZero: true);
    String secs = Utility.formatDecimal(
        Utility.getSecsFromTimeStamp(_maxLength * 1000),
        shouldAddZero: true);
    maxRecordTime =
        getI18NKey().maximum_recording_time('${hour}:${min}:${secs}');
  }

  @override
  void dispose() {
    super.dispose();
    RecorderManager.getInstance().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF0C141F),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          // brightness: Brightness.dark,
          title: Text(
            (this.widget.richTextModeEnum == RichTextModeEnum.note
                ? getI18NKey().note_diary
                : getI18NKey().voice_diary),
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
      backgroundColor: Color(0xFF0C141F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _timeShow(),
          ),
          Positioned(left: 15, right: 15, bottom: 0, child: _actionShow())
        ],
      ),
    );
  }

  Widget _timeShow() {
    return Column(children: [
      SizedBox(
        height: 30,
      ),
      Text(_recorderTxt, style: TextStyle(fontSize: 36, color: Colors.white)),
      SizedBox(
        height: 10,
      ),
      Text(maxRecordTime, style: TextStyle(fontSize: 15, color: Colors.white)),
      SizedBox(height: 150),
      CustomPaint(
          size: Size(double.maxFinite, 100),
          painter:
              LCPainter(amplitude: _dbLevel / 2, number: 30 - _dbLevel ~/ 20)),
    ]);
  }

  //底部按钮
  Widget _actionShow() {
    var _width = 120 - 30;
    var _height = _width * 0.8;

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFF1A283B),
        ),
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...getStateWidget(),
              // Container(
              //   padding: EdgeInsets.all(10),
              //   child: getStateWidget(), //按钮
              // ),
            ]));
  }

  List<Widget> getStateWidget() {
    List<Widget> list = [];
    print("state:$_state");
    if (_state == RecordPlayState.record) {
      list.add(InkWell(
        onTap: () {
          _startRecorder();
        },
        child: Container(
            child: Utility.getSVGPicture(R.assetsImgIcRecordStart,
                size: iconSize //按钮
                )),
      ));
      list.add(
        SizedBox(height: 15),
      );
      list.add(Text(
        _state == RecordPlayState.record
            ? getI18NKey().sound_recording
            : getI18NKey().finish,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ));
    } else if (_state == RecordPlayState.recording) {
      list.add(InkWell(
          onTap: () {
            _pauseRecorder();
          },
          child: Container(
              child: Utility.getSVGPicture(R.assetsImgIcRecordRecording,
                  size: iconSize //按钮
                  ))));
      list.add(
        SizedBox(height: 15),
      );
      list.add(Text(
        getI18NKey().pause,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ));
    } else {
      //pausing 暂停中
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                _resumeRecorder();
              },
              child: Column(
                children: [
                  Container(
                      child: Icon(
                    Icons.play_arrow,
                    size: iconSize,
                    color: ColorsConfig.color_red,
                  )),
                  SizedBox(height: 15),
                  Text(
                    getI18NKey().resume,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )
                ],
              )),
          SizedBox(
            width: 100,
          ),
          InkWell(
              onTap: () {
                _stopRecorder();
              },
              child: Column(
                children: [
                  Container(
                      child: Icon(
                    Icons.stop_circle_outlined,
                    size: iconSize,
                    color: ColorsConfig.color_red,
                  )),
                  SizedBox(height: 15),
                  Text(
                    getI18NKey().stop,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )
                ],
              ))
        ],
      ));
    }
    return list;
  }

  /// 开始录音
  _startRecorder() async {
    try {
      RecorderManager.getInstance().start();
      if (Utility.isMobile() == true &&
          PermissionManager.getInstance().isMicrophoneOn() == false) {
        EasyLoading.showToast(getI18NKey().no_microphone_permission);
        return;
      }
      RecorderManager.getInstance().setDurationListener((duration) {
        if (RecorderManager.getInstance().recordDuration >= _maxLength) {
          _stopRecorder();
        }
        _recorderTxt = RecorderManager.getInstance().buildTimer();
        setState(() {});
      });
      RecorderManager.getInstance().setAmplitudeListener((amplitude) {
        setState(() {
          _dbLevel = amplitude.current + 33;
          double max = amplitude.max;
          // print("当前振幅：$_dbLevel max;$_recorderTxt" );
        });
      });
      this.setState(() {
        _state = RecordPlayState.recording;
      });
    } catch (err) {
      setState(() {
        _stopRecorder();
        _state = RecordPlayState.record;
      });
    }
  }

  /// 暂停录音
  _pauseRecorder() async {
    try {
      RecorderManager.getInstance().pause();
      // String url = res.data;
      // print("path: ${path ?? ""}");
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setState(() {
      _state = RecordPlayState.pausing;
    });
  }

  /// 继续录音
  _resumeRecorder() async {
    try {
      RecorderManager.getInstance().resume();
      setState(() {
        _state = RecordPlayState.recording;
      });
      // String url = res.data;
      // print("path: ${path ?? ""}");
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  /// 结束录音
  _stopRecorder() async {
    try {
      int duration = RecorderManager.getInstance().recordDuration;
      RecorderManager.getInstance().stop();
      // await recorderModule.stopRecorder();
      print('stopRecorder');
      // _cancelRecorderSubscriptions();
      requestFinish(duration);
      // String url = res.data;
      // print("path: ${path ?? ""}");
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setState(() {
      _dbLevel = 0.0;
      _state = RecordPlayState.record;
    });
  }

  Future requestFinish(int duration) async {
    if (this.widget.richTextModeEnum == RichTextModeEnum.diary) {
      DialogManagement.getInstance().showEditTitleDialog(
          Utility.getGlobalContext(),
          title: getI18NKey().write_a_title,
          initVal: "", okCallBack: (String title) async {
        String? path = await RecorderManager.getInstance().stop();
        File file = new File(path ?? "");
        BaseBean res = await HttpManager.getInstance()
            .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
        MongoDbSaved? resMongoDbSave;
        resMongoDbSave = await MongoApisManager.getInstance()
            .insertTimelineMissionModel(
                missionModel: Utility.getTimelineMissionModelFromMissionModel(
                    sceneType: 'diary',
                    eventType: 'diary_voice',
                    icon: Icons.mic.codePoint,
                    color: Colors.teal.value,
                    timelineMessage: title.isEmpty
                        ? getI18NKey().complete_voice_diary
                        : getI18NKey().complete_voice_diary_with_title(title),
                    extra: jsonEncode({
                      "file": file.lengthSync(),
                      "duration": duration,
                      "url": res.data,
                      "localUrl": file.path
                    })));
        Navigator.pop(context);
        handleSuccessResult(resMongoDbSave);
      }, cancelCallBack: () {
        EasyLoadingManager.getInstance().dismiss();
        DialogManagement.getInstance().hideDialog(context);
      });
    } else {
      EasyLoadingManager.getInstance().showLoading();
      String? path = await RecorderManager.getInstance().stop();
      File file = new File(path ?? "");
      BaseBean res = await HttpManager.getInstance()
          .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
      MongoDbSaved? resMongoDbSave =
          await MongoApisManager.getInstance().insertTimelineMissionModel(
              missionModel: Utility.getTimelineMissionModelFromMissionModel(
                  sceneType: 'note',
                  eventType: 'note_voice',
                  icon: Icons.graphic_eq.codePoint,
                  color: Colors.teal.value,
                  timelineMessage: getI18NKey().complete_voice_note,
                  extra: jsonEncode({
                    "file": file.lengthSync(),
                    "duration": duration,
                    "url": res.data,
                    "localUrl": file.path
                  })));
      handleSuccessResult(resMongoDbSave);
    }
  }

  void handleSuccessResult(MongoDbSaved? resMongoDbSave) {
    EasyLoadingManager.getInstance().dismiss();
    if (resMongoDbSave != null) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      Utility.showToast(
          context: Utility.getGlobalContext(),
          msg: getI18NKey().add_successfully);
      if (Utility.isHandsetBySize()) {
        Utility.popNavigator(this.context);
        // Navigator.pop(context);
      } else {
        DialogManagement.getInstance().hideDialog(this.context);
      }
    } else {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().add_fail);
    }
  }

  /// 取消录音监听
  // void _cancelRecorderSubscriptions() {
  //   if (_recorderSubscription != null) {
  //     _recorderSubscription.cancel();
  //     _recorderSubscription = null;
  //   }
  // }

  /// 取消播放监听
  // void _cancelPlayerSubscriptions() {
  //   if (_playerSubscription != null) {
  //     _playerSubscription.cancel();
  //     _playerSubscription = null;
  //   }
  // }

  /// 判断文件是否存在
  Future<bool> _fileExists(String path) async {
    return await File(path).exists();
  }
}

class LCPainter extends CustomPainter {
  final double amplitude;
  final int number;

  LCPainter({this.amplitude = 100.0, this.number = 20});

  @override
  void paint(Canvas canvas, Size size) {
    var centerY = 0.0;
    var width = ScreenUtil.getScreenW(Utility.getGlobalContext()) / number;

    for (var a = 0; a < 4; a++) {
      var path = Path();
      path.moveTo(0.0, centerY);
      var i = 0;
      while (i < number) {
        path.cubicTo(width * i, centerY, width * (i + 1),
            centerY + amplitude - a * (30), width * (i + 2), centerY);
        path.cubicTo(width * (i + 2), centerY, width * (i + 3),
            centerY - amplitude + a * (30), width * (i + 4), centerY);
        i = i + 4;
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = a == 0 ? Colors.blueAccent : Colors.blueGrey.withAlpha(50)
            ..strokeWidth = a == 0 ? 3.0 : 2.0
            ..maskFilter = MaskFilter.blur(
              BlurStyle.solid,
              5,
            )
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
