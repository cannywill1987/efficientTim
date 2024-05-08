import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/CounterManagement.dart';
import '../../../util/Utility.dart';

class CounterWidget extends StatefulWidget {
  String sec;
  String min;
  double fontSize = 60.0;
  int fontMode = 1;
  // double fontSize
  CounterWidget({Key? key, required this.fontMode, this.fontSize = 60, this.sec = "00", this.min = "00"}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CounterState();
  }
}

class CounterState extends State<CounterWidget> {
  Function? onTimerTick;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onTimerTick = (int time) {
      this.widget.min = Utility.getMins(CounterManagement.getInstance().curTimeF);
      this.widget.sec = Utility.getSeconds(CounterManagement.getInstance().curTimeF);
      setState(() {

      });
    };
    CounterManagement.getInstance().addOnTimerTickListener(onTimerTickListener: onTimerTick!);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        // getCounterWidget(min: "00", sec: "00", color: Color(0x26ffffff)),
        getCounterWidget(min: this.widget.min, sec: this.widget.sec,),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CounterManagement.getInstance()
        .removeOnTimerTickListenerList(onTimerTickListenerList: onTimerTick!);
  }

  // 0 Flip 1 oswald 2 kablammo
  String getFontMode() {
    switch (this.widget.fontMode) {
      case 0:
        return 'digital7';
      case 1:
        return 'oswald';
      case 2:
        return 'kablammo';
      default:
        return 'kablammo';
    }
  }

  Wrap getCounterWidget({required String min, required String sec, Color color: Colors.white}) {
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        children: [
          Text(
            min,
            maxLines: 1,
            style: TextStyle(
                // fontFamily: 'digital7',
                // fontFamily: 'oswald',
              fontFamily: getFontMode(),
                fontSize: this.widget.fontSize,

                color: color,
                ),
          ),
          Text(
            ":",
            style: TextStyle(
                // fontFamily: 'oswald',
              fontFamily: getFontMode(),
                fontSize: this.widget.fontSize,
                color: Colors.white,
                ),
          ),
          Text(
            sec,
            style: TextStyle(
                // fontFamily: 'oswald',
              fontFamily: getFontMode(),
                fontSize: this.widget.fontSize,
                color: color,
                ),
          )
        ],
      );
  }
}
