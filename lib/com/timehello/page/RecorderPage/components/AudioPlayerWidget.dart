import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/ColorsConfig.dart';
import '../../../util/ThemeManager.dart';
import '../../../util/Utility.dart';

class AudioPlayerWidget extends StatefulWidget {
  /// Path from where to play recorded audio
  final String source;
  final String? hintText;
  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final void Function(String title) onSubmit;
  final bool shouldShowTitle;
  const AudioPlayerWidget({
    Key? key,
    required this.shouldShowTitle,
    required this.onCancel,
    required this.onSubmit,
    required this.hintText,
    required this.source,
    required this.onDelete,
  }) : super(key: key);

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  TextEditingController textfieldInputNumberController = TextEditingController();
  String title = "";
  Duration? _position;
  Duration? _duration;
  FocusNode _textfieldContentFocusNode = FocusNode();

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
      setState(() {});
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            this.widget.shouldShowTitle == false ? SizedBox.shrink() : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  style: TextStyle(fontSize: 12, color: Color(0xff404040)),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  // keyboardType: TextInputType.numberWithOptions(signed: false),
                  focusNode: _textfieldContentFocusNode,
                  controller: textfieldInputNumberController,
                  cursorColor: ColorsConfig.gray_40,
                  onChanged: (String text) {
                    this.title = text;
                    // if (onChange != null) {
                    //   onChange(text);
                    // }
                  },
                  onSubmitted: (value) {
                    print(value);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: this.widget.hintText ?? getI18NKey().please_input_title,
                    // fillColor: Colors.red,//背景颜色，必须结合filled: true,才有效
                    // focusColor: Colors.red,
                    // hoverColor: Colors.red,
                    contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    filled: true,
                    //重点，必须设置为true，fillColor才有效
                    isCollapsed: true,
                    //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                    enabledBorder: OutlineInputBorder(
                      //未选中时候的颜色
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xffffffff)),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //选中时外边框颜色
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Color(0xffffffff)),
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  ),
                )),
            SizedBox(height: 20,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildControl(),
                _buildSlider(constraints.maxWidth),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Color(0xFF73748D), size: _deleteBtnSize),
                  onPressed: () {
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                      stop().then((value) => widget.onDelete());
                    } else {
                      widget.onDelete();
                    }
                  },
                ),
              ],
            ),
            Text('${_duration ?? 0.0}'),
            new ButtonBar(
              children: <Widget>[
                new ElevatedButton(
                  child: new Text(getI18NKey().cancel),
                  style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.resolveWith(
                            (states) {
                          //默认状态使用灰色
                          return Colors.black;
                        },
                      ),
                      //背景颜色
                      backgroundColor:
                      MaterialStateProperty.resolveWith(
                              (states) {
                            //设置按下时的背景颜色
                            if (states
                                .contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            //默认不使用背景颜色
                            return Colors.white;
                          }),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(
                              fontSize: 18, color: Colors.black))),
                  onPressed: () {
                    this.widget.onCancel.call();
                    // if (this.widget.cancelCallBack != null) {
                    //   this.widget.cancelCallBack!();
                    // }
                  },
                ),
                RawKeyboardListener(
                    autofocus: true,
                    onKey: (event) {
                      if (event.runtimeType == RawKeyDownEvent) {
                        if (event.physicalKey ==
                            PhysicalKeyboardKey.enter) {
                          this.widget?.onSubmit.call(textfieldInputNumberController.text);
                        }
                      }
                    },
                    focusNode: FocusNode(),
                    child: new ElevatedButton(
                      child: new Text(getI18NKey().confirm),
                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.resolveWith(
                                (states) {
                              //默认状态使用灰色
                              return Colors.white;
                            },
                          ),
                          //背景颜色
                          backgroundColor:
                          MaterialStateProperty.resolveWith(
                                  (states) {
                                //设置按下时的背景颜色
                                if (states
                                    .contains(MaterialState.pressed)) {
                                  return Colors.red;
                                }
                                //默认不使用背景颜色
                                return Colors.red;
                              }),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(
                                  fontSize: 18,
                                  color: Colors.red))),
                      onPressed: () {
                        this.widget?.onSubmit.call(textfieldInputNumberController.text);
                      },
                    )),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() {
    return _audioPlayer.play(
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source),
    );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}
