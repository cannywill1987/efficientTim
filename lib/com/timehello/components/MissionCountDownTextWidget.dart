import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/TickTimeManager.dart';

import '../util/Utility.dart';

class MissionCountDownTextWidget extends StatefulWidget {
  final double fontSize;
  final int color;
  final int end_time;
  final int end_buffer_time;
  final bool isFinished;

  MissionCountDownTextWidget(
      {required this.isFinished,
      required this.fontSize,
      required this.color,
      required this.end_time,
      required this.end_buffer_time});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionCountDownTextWidgetState();
  }
}

class MissionCountDownTextWidgetState
    extends State<MissionCountDownTextWidget> {
  Function? cb;
  Duration? _remainingTime;
  int isOverdue = -1; //是否预期 0 未逾期 1 预期
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.isFinished == false) {
      int timestampNow = Utility.getTimeStampToday();
      _remainingTime =
          Utility.getDateTimeFromTimeStamp(this.widget.end_time ?? 0)
              .difference(DateTime.now());
      if (timestampNow < (this.widget.end_buffer_time ?? 0)) {
        TickTimeManager.getInstance().addCallback(
            callback: cb = () {
          int timestampNow = Utility.getTimeStampToday();
          int endtime = this.widget.end_time ?? 0;
          int endBufferTime = this.widget.end_buffer_time ?? 0;

          if (timestampNow < endtime) {
            this.isOverdue = 0; //未逾期
            _remainingTime = Utility.getDateTimeFromTimeStamp(endtime)
                .difference(DateTime.now());
            // if((_remainingTime?.inMilliseconds ?? 0) < 0) {
            //   print(111111111);
            // }
          } else if (timestampNow < endBufferTime) {
            this.isOverdue = 1; //逾期
            _remainingTime = Utility.getDateTimeFromTimeStamp(endBufferTime)
                .difference(DateTime.now());
            // if((_remainingTime?.inMilliseconds ?? 0) < 0) {
            //   print(111111111);
            // }
          } else {
            // if((_remainingTime?.inMilliseconds ?? 0) < 0) {
            //   print(111111111);
            // }
            this.isOverdue = -1;
            _remainingTime = Duration(seconds: 0);
          }
          // print("MissionCountDownTextWidgetState _remainingTime:" +
          //     (_remainingTime?.inMilliseconds ?? 0).toString());
          setState(() {});
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant MissionCountDownTextWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (cb != null) {
      TickTimeManager.getInstance().removeCallback(callback: cb!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String s = (isOverdue == 1 ? getI18NKey().overdue_buffer + " " : "") +
        _formatRemainingTimeDoItNow(_remainingTime!);
    // print("MissionCountDownTextWidgetState _remainingTime:" +
    //     s + "`````````````````````");
    if (this.widget.isFinished == false) {
      return Text(
        s,
        maxLines: 2,
        style: TextStyle(
            fontSize: this.widget.fontSize,
            color: isOverdue == 1 ? Colors.red : Color(this.widget.color)),
      );
    } else {
      return Container();
    }
  }

  String _formatRemainingTimeDoItNow(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitDays = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (int.parse(twoDigitMinutes) < 0) {
      return "";
    }
    if (duration.inDays != 0) {
      // print("111111111" + getI18NKey().count_down(
      //     twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds));
      return getI18NKey().count_down(
          twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds);
    } else if (duration.inHours != 0) {
      // print("2222222" + getI18NKey().count_down(
      //     twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds));
      return getI18NKey()
          .count_down2(twoDigitHours, twoDigitMinutes, twoDigitSeconds);
    } else {
      // print("33333333" + getI18NKey().count_down(
      //     twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds));
      return getI18NKey().count_down3(twoDigitMinutes, twoDigitSeconds);
    }
  }
}
