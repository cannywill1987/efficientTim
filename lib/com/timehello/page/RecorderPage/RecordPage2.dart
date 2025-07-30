import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/util/AliyunStoreManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

// import 'package:record/record.dart';
import '../../models/EventFn.dart';
import '../../util/DialogManagement.dart';
import '../../util/EasyLoadingManager.dart';
import '../../util/ScreenUtil.dart';
import '../../util/Utility.dart';
import 'components/AudioPlayerWidget.dart';

// import 'components/record.dart';
import 'package:record_platform_interface/record_platform_interface.dart';

import 'components/record.dart';

class RecordPage2 extends BaseWidget {
  final RichTextModeEnum richTextModeEnum;
  final bool? shouldShowTitle;
   final void Function(String title, String path, String localPath,int duration, int fileSize)? onSubmit;
  const RecordPage2({required this.shouldShowTitle, required this.richTextModeEnum, required this.onSubmit,});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return RecordPage2State();
  }
}

class RecordPage2State extends BaseWidgetState<RecordPage2> {
  bool showPlayer = false;
  String? audioPath;
  String? title;
  int duration = 0;

  componentDidMount() {
    DialogManagement.getInstance().showRequestVoicePermissiondialog(this.context, okCallback: () {
    });
  }

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    return Center(
      child: showPlayer
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AudioPlayerWidget(
                source: audioPath!,
                onDelete: () {

                  setState(() => showPlayer = false);
                }, hintText: null, onSubmit: (String title) {
                  this.title = title;
                  // if(this.widget.richTextModeEnum == RichTextModeEnum.getUrl) {
                  //   this.widget.onSubmit?.call(title, this.audioPath ?? "", this.duration);
                  // } else {
                    requestFinish(
                        duration: this.duration, path: this.audioPath ?? "");
                  // }
              }, shouldShowTitle: this.widget.shouldShowTitle == true || this.widget.richTextModeEnum == RichTextModeEnum.diary, onCancel: () { Utility.popupPagePCAndMobile(context); },
              ),
            )
          : _AudioRecorder(
              onStop: (path, duration) {
                // if (kDebugMode) print('Recorded file path: $path');
                setState(() {
                  this.duration = duration;
                  audioPath = path;
                  showPlayer = true;
                });
              },
              richTextModeEnum: this.widget.richTextModeEnum,
            ),
    );

    //   _AudioRecorder(onStop: (String path) {
    //   setState(() {
    //     showPlayer = true;
    //   });
    // },);
  }

  Future requestFinish({required int duration, required String path}) async {
    if (this.widget.richTextModeEnum == RichTextModeEnum.diary) {
      DialogManagement.getInstance().showEditTitleDialog(
          Utility.getGlobalContext(),
          title: getI18NKey().write_a_title,
          initVal: "", okCallBack: (String title) async {
        // String? path = await RecorderManager.getInstance().stop();
        EasyLoadingManager.getInstance().showLoading();
        File file = new File(path ?? "");
        // BaseBean res = await HttpManager.getInstance()
        //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);

        String url = await AliyunStoreManager.getInstance()
            .uploadFileByFilePath(docType: DocType.audio, path: file.path, fileName: Utility.getUUID());

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
                  "url": url,
                  "localUrl": file.path
                })));
        EasyLoadingManager.getInstance().dismiss();
        Navigator.pop(Utility.getGlobalContext());
        handleSuccessResult(resMongoDbSave);
      }, cancelCallBack: () {
        EasyLoadingManager.getInstance().dismiss();
        DialogManagement.getInstance().hideDialog(context);
      });
    } else if(this.widget.richTextModeEnum == RichTextModeEnum.getUrl) {
      EasyLoadingManager.getInstance().showLoading();
      // String? path = await RecorderManager.getInstance().stop();
      File file = new File(path ?? "");
      String url = await AliyunStoreManager.getInstance()
          .uploadFileByFilePath(docType: DocType.audio, path: file.path, fileName: Utility.getUUID());

      // BaseBean res = await HttpManager.getInstance()
      //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
      this.widget.onSubmit?.call(title ?? "", url, this.audioPath ?? "", duration, file.lengthSync());
      EasyLoadingManager.getInstance().dismiss();
      Utility.popupPagePCAndMobile(context);
    } else {
      EasyLoadingManager.getInstance().showLoading();
      // String? path = await RecorderManager.getInstance().stop();
      File file = new File(path ?? "");
      String url = await AliyunStoreManager.getInstance()
          .uploadFileByFilePath(docType: DocType.audio, path: file.path, fileName: Utility.getUUID());

      // BaseBean res = await HttpManager.getInstance()
      //     .uploadFile(key: "record", file: file, url: Apis.uploadOSSFile);
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
                "url": url,
                "localUrl": file.path
              })));
      this.widget.onSubmit?.call(title ?? "", url, this.audioPath ?? "", duration, file.lengthSync());
      handleSuccessResult(resMongoDbSave);
    }
  }

  void handleSuccessResult(MongoDbSaved? resMongoDbSave) {
    EasyLoadingManager.getInstance().dismiss();
    if (resMongoDbSave != null) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      Utility.showToastMsg(
          context: Utility.getGlobalContext(),
          msg: getI18NKey().add_successfully);
      // this.widget.onSubmit?.call(title ?? "", this.audioPath ?? "", this.duration);
      if (Utility.isHandsetBySize()) {
        Utility.popNavigator(this.context);
        // Navigator.pop(context);
      } else {
        DialogManagement.getInstance().hideDialog(this.context);
      }
      Utility.popupPagePCAndMobile(context);
    } else {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().add_fail);
    }
  }
}

class _AudioRecorder extends StatefulWidget {
  final void Function(String path, int duration) onStop;
  final RichTextModeEnum richTextModeEnum;

  const _AudioRecorder(
      {Key? key, required this.onStop, required this.richTextModeEnum})
      : super(key: key);

  @override
  State<_AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<_AudioRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  late final AudioRecorder audioRecorder;
  StreamSubscription<RecordState>? recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    audioRecorder = AudioRecorder();

    recordSub = audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    _amplitudeSub = audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.aacLc;

        // We don't do anything with this but printing
        final isSupported = await audioRecorder.isEncoderSupported(
          encoder,
        );

        debugPrint('${encoder.name} supported: $isSupported');

        final devs = await audioRecorder.listInputDevices();
        debugPrint(devs.toString());

        const config = RecordConfig(
          encoder: encoder, numChannels: 1,
          bitRate: 128000, // by default
          // sampleRate: 22050, // by default
        );

        // Record to file
        String path;
        // if (kIsWeb) {
        //   path = '';
        // } else {
        final dir = await getTemporaryDirectory();
        path = p.join(
          dir.path,
          'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
        // }
        await audioRecorder.start(config, path: path);

        // Record to stream
        // final file = File(path);
        // final stream = await _audioRecorder.startStream(config);
        // stream.listen(
        //   (data) {
        //     // ignore: avoid_print
        //     print(
        //       _audioRecorder.convertBytesToInt16(Uint8List.fromList(data)),
        //     );
        //     file.writeAsBytesSync(data, mode: FileMode.append);
        //   },
        //   // ignore: avoid_print
        //   onDone: () => print('End of stream'),
        // );

        // Record to stream web
        // var b = <Uint8List>[];
        // final stream = await _audioRecorder.startStream(config);
        // stream.listen(
        //   (data) {
        //     b.add(data);
        //   },
        //   onDone: () {
        //     _downloadWebData(html.Url.createObjectUrl(html.Blob(b)));
        //   },
        // );

        _recordDuration = 0;

        _startTimer();
      } else {
        EasyLoading.showToast(getI18NKey().no_microphone_permission);
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print(e);
      // }
    }
  }

  Future<void> _stop() async {
    final path = await audioRecorder.stop() ?? "";
    if (path != null) {
      widget.onStop(path, _recordDuration);
      // _downloadWebData(path);
    }
    // this.requestFinish(duration: _recordDuration, path: path);
  }



  // void _downloadWebData(String path) {
  //   // Simple download code for web testing
  //   final anchor = html.document.createElement('a') as html.AnchorElement
  //     ..href = path
  //     ..style.display = 'none'
  //     ..download = 'audio.wav';
  //   html.document.body!.children.add(anchor);
  //   anchor.click();
  //   html.document.body!.children.remove(anchor);
  //   html.Url.revokeObjectUrl(path);
  // }

  Future<void> _pause() => audioRecorder.pause();

  Future<void> _resume() => audioRecorder.resume();

  void _updateRecordState(RecordState recordState) {
    setState(() => _recordState = recordState);

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        _startTimer();
        break;
      case RecordState.stop:
        _timer?.cancel();
        _recordDuration = 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRecordStopControl(),
              const SizedBox(width: 20),
              _buildPauseResumeControl(),
              const SizedBox(width: 20),
              _buildText(),
            ],
          ),
          if (_amplitude != null) ...[
            const SizedBox(height: 40),
            Text('Current: ${_amplitude?.current ?? 0.0}'),
            Text('Max: ${_amplitude?.max ?? 0.0}'),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    recordSub?.cancel();
    _amplitudeSub?.cancel();
    audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: ThemeManager.getInstance().getIconColor(defaultColor: theme.primaryColor), size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: color),
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }
    late Icon icon;
    late Color color;
    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
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
