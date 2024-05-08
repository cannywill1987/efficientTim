import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/TickTimeManager.dart';

import '../../../util/Utility.dart';


class CountDownTextWidget extends StatefulWidget {
  final double fontSize;
  final int color;
  final int end_time;
  final Function onTapFinishListener;

  CountDownTextWidget(
      {required this.onTapFinishListener, required this.fontSize, required this.color, required this.end_time});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CountDownTextWidgetState();
  }
}

class CountDownTextWidgetState extends State<CountDownTextWidget> {
  Function? cb;
  Duration? _remainingTime;
  int isOverdue = -1; //是否预期 0 未逾期 1 预期
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _remainingTime = Utility.getDateTimeFromTimeStamp(this.widget.end_time ?? 0)
        .difference(DateTime.now());
    if(cb == null) {
      TickTimeManager.getInstance().addCallback(
          callback: cb = () {
            int timestampNow = Utility.getTimeStampToday();
            int endtime = this.widget.end_time ?? 0;

            if (timestampNow < endtime) {
              this.isOverdue = 0; //未逾期
              _remainingTime = Utility.getDateTimeFromTimeStamp(endtime)
                  .difference(DateTime.now());
            } else {
              stopTimer();
              this.widget.onTapFinishListener();
              this.isOverdue = -1;
              _remainingTime = Duration(seconds: 0);
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
    if ((_remainingTime?.inMilliseconds ?? 0) > 0 )
      return Text(_formatRemainingTime(_remainingTime!));
    else {
      return SizedBox.shrink();
    }
    // return Text((isOverdue == 1 ? getI18NKey().overdue_buffer + " " : "" )+_formatRemainingTime(_remainingTime!), style: TextStyle(fontSize: this.widget.fontSize, color: isOverdue == 1 ? Colors.red : Color(this.widget.color)),);
  }

  String _formatRemainingTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitDays = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return getI18NKey().count_down(twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds);
    // return '$twoDigitDays天$twoDigitHours时$twoDigitMinutes分$twoDigitSeconds秒';
  }
}
