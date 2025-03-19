// import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import 'SharePreferenceUtil.dart';

/// Screen Util.
class AudioPlayUtil {
  static AudioPlayUtil? _instance;

  // FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  AudioPlayer? audioPlayer;
  // AnimationController? animationController;

  // AssetsAudioPlayer assetsAudioPlayer;
  int duration = 10000;
  int volume = 100;
  int durationSecs = 0;
  Function? onStartListener;
  Function? onBufferingListener;
  Function? shuffleListener;
  Function? positionListener;
  // Timer? _timer;
  int recordDuration = 0;
  Function? durationListener;
  Function? onUpdateListener;
  Function? onStateChangeListener;
  String curPath = "";
  static AudioPlayUtil? getInstance([Function? onSelectNotification]) {
    if (_instance == null) {
      _instance = new AudioPlayUtil();
      _instance!.init();
    }
    return _instance;
  }

  void init() async {
    audioPlayer = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      handleInterruptions: false,
      androidApplyAudioAttributes: false,
      handleAudioSessionActivation: false,
    );
    audioPlayer?.setVolume(
        SharePreferenceUtil.getSyncInstance().getAudioVolume() / 100.0);
  }

  setOnUpdateListener(Function onUpdateListener) {
    this.onUpdateListener = onUpdateListener;
  }

  setOnStateChangeListener(onStateChangeListener) {
    this.onStateChangeListener = onStateChangeListener;
  }

  setOnStartListener(Function? onStartListener) {
    this.onStartListener = onStartListener;
  }

  setOnPositionListener(Function? onPositionListener) {
    this.positionListener = onPositionListener;
  }

  setOnBufferingListener(Function? onBufferingListener) {
    this.onBufferingListener = onBufferingListener;
  }

  setOnShuffleListener(Function? shuffleListener) {
    this.shuffleListener = shuffleListener;
  }

  /**
   * volume 0 ~ 100
   */
  setVolume(int volume) {
    SharePreferenceUtil.getSyncInstance().setAudioVolume(volume);
    if (volume == 0) {
      audioPlayer?.setVolume(volume.toDouble() / 100.0);
    } else {
      stop();
    }
  }

  play(String path,
      {int volume = -1,
      int duration = -1,
      bool isLocal = false,
        bool shouldForcePlay = false,
      LoopMode? loopMode}) async {
    if(path != null) {
      path = path.trim();
    }
    this.duration = duration;
    // final LoopMode loopMode = AssetsAudioPlayer.loop;
    // assetsAudioPlayer = AssetsAudioPlayer();
    // assetsAudioPlayer.setLoopMode(LoopMode.single);
    // if (SharePreferenceUtil.getSyncInstance().getAudioVolume() == 0) {
    //   return;
    // }
    // path = Utility.getOSSOriginFromUrl(path);
    curPath = path;
    stop();
    if (volume != -1) {
      audioPlayer?.setVolume(volume / 100);
    } else {
      audioPlayer?.setVolume(
          SharePreferenceUtil.getSyncInstance().getAudioVolume() / 100.0);
    }
    //音量是0没必要播放了
    if(SharePreferenceUtil.getSyncInstance().getAudioVolume() == 0 && shouldForcePlay == false) {
      return;
    }
    AudioSession.instance.then((audioSession) async {
      // This line configures the app's audio session, indicating to the OS the
      // type of audio we intend to play. Using the "speech" recipe rather than
      // "music" since we are playing a podcast.
      await audioSession.configure(AudioSessionConfiguration.speech());
      // Listen to audio interruptions and pause or duck as appropriate.
      _handleInterruptions(audioSession);
      // await audioPlayer.setClip(start: Duration(seconds: 0), end: Duration(seconds: 20));
      // Use another plugin to load audio to play.
      if (path.indexOf("http") != -1) {
        //如果从网络过来
        await audioPlayer!.setUrl(path);
      } else {
        await audioPlayer!.setFilePath(path);
      }
      if (this.duration != -1) {
        // -1表示无限循环播放
        audioPlayer?.setLoopMode(LoopMode.off);
        audioPlayer?.setClip(end: Duration(seconds: this.duration ~/ 1000));
      } else {
        audioPlayer?.setLoopMode(loopMode ?? LoopMode.all);
        // audioPlayer?.setLoopMode(loopMode ?? LoopMode.all);
      }
      await audioPlayer!.play();
    });
  }

  playUrlList(List<String> list, {Function? completeCB}) async {
    stop();
    audioPlayer = AudioPlayer();
    audioPlayer?.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
          print("idle");
          break;
        case ProcessingState.loading:
          print("loading");
          break;
        case ProcessingState.buffering:
          print("buffering");
          break;
        case ProcessingState.ready:
          print("ready");
          break;
        case ProcessingState.completed:
          print("completed");
          stop();
          if (completeCB != null) {
            completeCB();
          }
          break;
      }
    });
    // List<UriAudioSource> listUriAudioSource = [];
    // list.forEach((element) {
    //   listUriAudioSource.add(AudioSource.uri(Uri.parse(element)));
    // });
    List<LockCachingAudioSource> listUriAudioSource = [];
    list.forEach((element) {
      listUriAudioSource.add(LockCachingAudioSource(Uri.parse(element)));
    });

// Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: listUriAudioSource,
    );
    await audioPlayer
        ?.setLoopMode(LoopMode.off); // Set playlist to loop (off|all|one)
    await audioPlayer?.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
    await audioPlayer!.play();
  }

  stop() {
    // _timer?.cancel();
    recordDuration = 0;
    if (audioPlayer != null) {
      audioPlayer?.stop();
      audioPlayer = null;
    }
    audioPlayer = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      handleInterruptions: false,
      androidApplyAudioAttributes: false,
      handleAudioSessionActivation: false,
    );
  }

  pause() async {
    // _timer?.cancel();
    await audioPlayer!.pause();
  }

  continuePlayer() async {
    await audioPlayer!.play();
  }

  void _handleInterruptions(AudioSession audioSession) {
    // just_audio can handle interruptions for us, but we have disabled that in
    // order to demonstrate manual configuration.
    bool playInterrupted = false;
    audioPlayer?.playerStateStream.listen((PlayerState event) {
      switch (event.processingState) {
        case ProcessingState.idle:
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.completed:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.loading:
          break;
      }
      if(this.onStateChangeListener != null) {
        this.onStateChangeListener!(event.processingState);
      }
      // print('STATE:${event.processingState.toString()}');
    });

    audioPlayer?.positionStream.listen((event) {
      durationSecs = event?.inSeconds ?? 0;
      if(positionListener != null) {
        this.positionListener!(audioPlayer?.position.inMilliseconds ?? 0, audioPlayer?.duration?.inMilliseconds ?? 0, audioPlayer?.bufferedPosition?.inMilliseconds ?? 0);
      }
      // print('position');
    });
    audioPlayer?.durationStream.listen((event) {
      durationSecs = event?.inSeconds ?? 0;
      // print('DURATION');
    });
    audioPlayer?.bufferedPositionStream.listen((event) {
      if (this.onBufferingListener != null) {
        this.onBufferingListener!(event.inMilliseconds, duration * 1000);
      }
      // print('BUFFERING');
    });
    audioPlayer?.currentIndexStream.listen((event) {
      // print("currentIndexStream");
    });
    audioPlayer?.playbackEventStream.listen((event) {
      // print("playbackEventStream");
    });

    audioSession.becomingNoisyEventStream.listen((_) {
      print('PAUSE');
      audioPlayer!.pause();
    });
    audioPlayer?.playingStream.listen((bool isPlaying) {
      if (this.onStartListener != null) {
        this.onStartListener!(isPlaying, duration);
      }
      print('PLAYING');
    });
    //只执行了一次
    audioPlayer!.playingStream.listen((playing) {
      print('PLAYING');
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
        // startTimer();
        // if (this.duration != -1) {
          // Future.delayed(Duration(milliseconds: this.duration)).then((e) {
          //   print('STOP');
          //   audioPlayer!.stop();
          // });
        // }
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      print('interruption begin: ${event.begin}');
      print('interruption type: ${event.type}');
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              // audioPlayer!.setVolume(audioPlayer!.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (audioPlayer!.playing) {
              audioPlayer!.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // audioPlayer!.setVolume(1.0);
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) audioPlayer!.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
    // audioSession.devicesChangedEventStream.listen((event) {
    //   print('Devices added: ${event.devicesAdded}');
    //   print('Devices removed: ${event.devicesRemoved}');
    // });
  }

  // void startTimer() {
  //   _timer?.cancel();
  //
  //   _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     recordDuration++;
  //     print("duration$recordDuration");
  //     if (durationListener != null) {
  //       this.durationListener!(recordDuration);
  //     }
  //     // setState(() => _recordDuration++);
  //   });
  // }
  //
  // void dispose() {
  //   _timer?.cancel();
  // }
}
