import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/TickTimeManager.dart';

import '../../../util/Utility.dart';


class CountUpTextWidget extends StatefulWidget {
  final double fontSize;
  final int color;
  final int start_time;
  final Function onTapFinishListener;

  CountUpTextWidget(
      {required this.onTapFinishListener, required this.fontSize, required this.color, required this.start_time});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CountUpTextWidgetState();
  }
}

class CountUpTextWidgetState extends State<CountUpTextWidget> {
  Function? cb;
  Duration? _elapsedTime;
  int isStarted = -1; //是否已开始 0 未开始 1 已开始
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _elapsedTime = DateTime.now()
        .difference(Utility.getDateTimeFromTimeStamp(this.widget.start_time ?? 0));
    if(cb == null) {
      TickTimeManager.getInstance().addCallback(
          callback: cb = () {
            int timestampNow = Utility.getTimeStampToday();
            int starttime = this.widget.start_time ?? 0;

            if (timestampNow >= starttime) {
              this.isStarted = 1; //已开始
              _elapsedTime = DateTime.now()
                  .difference(Utility.getDateTimeFromTimeStamp(starttime));
            } else {
              stopTimer();
              this.widget.onTapFinishListener();
              this.isStarted = 0;
              _elapsedTime = Duration(seconds: 0);
            }
            setState(() {});
          });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopTimer();
  }

  void stopTimer() {
    if (cb != null) {
      TickTimeManager.getInstance().removeCallback(callback: cb!);
      cb = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if ((_elapsedTime?.inMilliseconds ?? 0) > 0 )
      return Text(_formatElapsedTime(_elapsedTime!));
    else {
      return SizedBox.shrink();
    }
    // return Text((isStarted == 1 ? getI18NKey().counting_buffer + " " : "" )+_formatElapsedTime(_elapsedTime!), style: TextStyle(fontSize: this.widget.fontSize, color: isStarted == 1 ? Colors.green : Color(this.widget.color)),);
  }

  String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitDays = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return getI18NKey().count_up(twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds);
    // return '$twoDigitDays天$twoDigitHours时$twoDigitMinutes分$twoDigitSeconds秒';
  }
} 