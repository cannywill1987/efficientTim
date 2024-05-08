import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class RecorderManager {
  static RecorderManager? _instance;
  final audioRecorder = AudioRecorder();
  int recordDuration = 0;
  Timer? _timer;
  RecordState recordState = RecordState.stop;
  StreamSubscription<RecordState>? recordSub;
  Function? stateListener;
  Function? amplitudeListener;
  Function? durationListener;

  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  static RecorderManager getInstance() {
    if (_instance == null) {
      _instance = new RecorderManager();
      _instance!.init();
    }
    return _instance!;
  }

  init() {
    recordSub = audioRecorder.onStateChanged().listen((recordState) {
      this.recordState = recordState;
      if (stateListener != null) {
        stateListener!(recordState);
      }
      // setState(() => recordState = recordState);
    });

    _amplitudeSub = audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      _amplitude = amp;
      if (this.amplitudeListener != null) {
        this.amplitudeListener!(amp);
      }
    });
  }

  set timer(Timer value) {
    _timer = value;
  }

  setAmplitudeListener(Function amplitudeListener) {
    this.amplitudeListener = amplitudeListener;
  }

  setDurationListener(Function durationListener) {
    this.durationListener = durationListener;
  }



  bool isPlaying() {
    return this.recordState == RecordState.record;
  }

  start() async {
    if (await audioRecorder.hasPermission()) {
      // Start recording
      // await audioRecorder.start(
      //   path: 'aFullPath/myFile.m4a',
      //   encoder: AudioEncoder.aacLc, // by default
      //   bitRate: 128000, // by default
      //   samplingRate: 44100, // by default
      // );
      // We don't do anything with this but printing
      final isSupported = await audioRecorder.isEncoderSupported(
        AudioEncoder.aacLc,
      );

      // final devs = await _audioRecorder.listInputDevices();
      // final isRecording = await _audioRecorder.isRecording();

      Directory tempDir = await getTemporaryDirectory();
      var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String path =
          '${tempDir.path}/$time.m4a';

      // await audioRecorder.start(
      //   // path: path,
      //   // encoder: AudioEncoder.aacLc, // by default
      //   // bitRate: 128000, // by default
      //   // samplingRate: 22050, // by default
      // );
      recordDuration = 0;

      startTimer();
    }
  }

  Future<String?> stop() async {
    _timer?.cancel();
    recordDuration = 0;

    final path = await audioRecorder.stop();

    if (path != null) {
      return path;
      // widget.onStop(path);
    }
    return null;
  }

  Future<void> pause() async {
    _timer?.cancel();
    await audioRecorder.pause();
  }

  Future<void> resume() async {
    startTimer();
    await audioRecorder.resume();
  }

  String buildTimer() {
    final String hour = _formatNumber(Utility.getHourFromTimeStamp(recordDuration));
    final String minutes = _formatNumber(recordDuration ~/ 60);
    final String seconds = _formatNumber(recordDuration % 60);
    return '$hour:$minutes:$seconds';
    // return Text(
    //   '$minutes : $seconds',
    //   style: const TextStyle(color: Colors.red),
    // );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      print("duration$recordDuration");
      if(durationListener != null) {
        this.durationListener!(recordDuration);
      }
      // setState(() => _recordDuration++);
    });
  }

  void dispose() {
    _timer?.cancel();
    recordSub?.cancel();
    _amplitudeSub?.cancel();
    audioRecorder.dispose();
  }
}
