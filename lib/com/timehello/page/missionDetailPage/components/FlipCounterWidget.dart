import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flip_board/flip_clock.dart';
// import 'package:flip_board/flip_widget.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/custom_flip_widget.dart';
import '../../../util/CounterManagement.dart';

class FlipCounterWidget extends StatefulWidget {
  String sec;
  String min;
  double widgetWidth = 0.0;
  // double fontSize = 160.0;

  // double fontSize
  FlipCounterWidget({Key? key, required this.widgetWidth,this.sec = "00", this.min = "00"})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CounterState();
  }
}

class CounterState extends State<FlipCounterWidget> {
  final _flipControllerSec1 = StreamController<int>.broadcast();
  final _flipControllerSec2 = StreamController<int>.broadcast();
  final _flipControllerMin1 = StreamController<int>.broadcast();
  final _flipControllerMin2 = StreamController<int>.broadcast();
  final _flipControllerHour1 = StreamController<int>.broadcast();
  final _flipControllerHour2 = StreamController<int>.broadcast();
  int _nextFlipValue = 0;
  double itemWidth = 0.0;
  double itemHeight = 0.0;
  double fontSize = 160.0;
  int screenH = 0;
  int screenW = 0;
  int space = 20; // 分和秒间隔
  int spaceDigital = 5; // 两个数字 sec1和sec2 之间的间隔
  Function? onTimerTick;

  Duration duration =
      Duration(milliseconds: DeviceInfoManagement.isWEB() == true ? 900 : 900);

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
    setMinValue(int.parse(this.widget.min));
    setSecValue(int.parse(this.widget.sec));

    return LayoutBuilder(builder: (context, constraints) {
      // screenW = constraints.maxWidth.toInt();
      // screenH = Utility.getSc;
      setMinValue(int.parse(this.widget.min));
      setSecValue(int.parse(this.widget.sec));
      screenH = MediaQuery.of(context).size.height.toInt();
      // screenW = MediaQuery.of(context).size.width.toInt();
      screenW = this.widget.widgetWidth.toInt();
      itemHeight = this.itemHeight;
      // if(screenW > screenH) { // 横屏
      itemWidth = screenW / 5 - 30; //横屏
      itemHeight = screenH - 30; //竖屏
      this.fontSize = ((itemWidth > itemHeight ? itemHeight : itemWidth) - 30);
      space = this.fontSize ~/ 6;
      spaceDigital = this.fontSize ~/ 40;
      // if(itemHeight > 160) {
      //   this.itemHeight = 160;
      // }
      return getHorizontalFlipWidget();
      // } else {
      //   itemWidth = screenW / 4 - 30; //横屏
      //   itemHeight = screenH - 30; //竖屏
      //   this.fontSize = (itemWidth > itemHeight ? itemHeight : itemWidth) - 30;
      //   space = this.fontSize ~/ 8;
      //   spaceDigital = this.fontSize ~/ 20;
      //
      //   // itemWidth = screenW / 2 - 30; //横屏
      //   // itemHeight = screenH / 2 - 30; //竖屏
      //   // this.fontSize = (itemWidth > itemHeight ? itemHeight : itemWidth) - 30;
      //   space = this.fontSize ~/ 2;
      //   // return getHorizontalFlipWidget();
      //   return getHorizontalFlipWidget();
      // }
    });

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //   _flipWidget(controller1: _flipControllerMin1, controller2: _flipControllerMin2),
    //   SizedBox(width: 12,),
    //   _flipWidget(controller1: _flipControllerSec1, controller2: _flipControllerSec2)
    // ],);
    // // return Stack(
    // //   children: [
    // //     // getFlipCounterWidget(min: this.widget.min, sec: this.widget.sec,),
    // //   ],
    // // );
  }

  @override
  void dispose() {
    super.dispose();
    if (DeviceInfoManagement.isMoible()) {
      DeviceInfoManagement.getInstance()?.setLandScape(false);
    }
    CounterManagement.getInstance()
        .removeOnTimerTickListenerList(onTimerTickListenerList: onTimerTick!);
    // CounterManagement.getInstance().dispose();
  }

  Widget getHorizontalFlipWidget() {
    return Container(
      key: ValueKey("flip_counter_widget"),
      child: Column(
        key: ValueKey("flip_counter_widget_column"),
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            key: ValueKey("flip_counter_widget_row"),
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _flipWidget(
                key: "flip_counter_widget_flip_widget_min1",
                  controller1: _flipControllerMin1,
                  controller2: _flipControllerMin2),
              SizedBox(
                width: space.toDouble(),
              ),
              _flipWidget(
                key: "flip_counter_widget_flip_widget_sec1",
                  controller1: _flipControllerSec1,
                  controller2: _flipControllerSec2)
            ],
          ),
        ],
      ),
    );
  }

  /**
   * val 0 ~ 59
   * 十位数分配给 _flipControllerSec1
   * 个位数分配至 _flipControllerSec2
   */
  setSecValue(int val) {
    _flipControllerSec1.add(val ~/ 10);
    _flipControllerSec2.add(val % 10);
  }

  setMinValue(int val) {
    _flipControllerMin1.add(val ~/ 10);
    _flipControllerMin2.add(val % 10);
  }

  void _flip() => _flipControllerSec1.add(++_nextFlipValue % 10);

  Widget _numberItemBuilder(BuildContext context, int? value) {
    double height = this.fontSize * 150 / 100;
    return Container(
      width: this.fontSize + 40.0,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xff292929),
        // color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(color: Color(0xff292929)),
      ),
      child: Text(
        (value ?? 0).toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: this.fontSize,
        ),
      ),
    );
  }

  Widget _flipWidget({controller1, controller2, key}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFlipWidget(
          key: ValueKey("flip_widget" + key.toString() + "1"),
          flipType: FlipType.middleFlip,
          itemStream: controller1.stream,
          itemBuilder: _numberItemBuilder,
          initialValue: _nextFlipValue,
          flipDirection: AxisDirection.up,
          // flipCurve: direction == AxisDirection.down ? FlipWidget.bounceFastFlip : FlipWidget.defaultFlip,
          flipDuration: duration,
          perspectiveEffect: 0.008,
          hingeWidth: 2.0,
          //上下是数字的缝隙
          hingeLength: 56.0,
          //
          hingeColor: Colors.black,
        ),
        SizedBox(
          width: this.spaceDigital.toDouble(),
        ),
        CustomFlipWidget(
          key: ValueKey("flip_widget" + key.toString() + "2"),
          flipType: FlipType.middleFlip,
          itemStream: controller2.stream,
          itemBuilder: _numberItemBuilder,
          initialValue: _nextFlipValue,
          flipDirection: AxisDirection.up,
          // flipCurve: direction == AxisDirection.down ? FlipWidget.bounceFastFlip : FlipWidget.defaultFlip,
          flipDuration: duration,
          perspectiveEffect: 0.008,
          hingeWidth: 2.0,
          hingeLength: 56.0,
          hingeColor: Colors.black,
        ),
      ],
    );
  }

  Wrap getFlipFlipCounterWidget(
      {required String min, required String sec, Color color: Colors.white}) {
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
            fontFamily: 'oswald',
            fontSize: this.fontSize,

            color: color,
          ),
        ),
        Text(
          ":",
          style: TextStyle(
            fontFamily: 'oswald',
            fontSize: this.fontSize,
            color: Colors.white,
          ),
        ),
        Text(
          sec,
          style: TextStyle(
            fontFamily: 'oswald',
            fontSize: this.fontSize,
            color: color,
          ),
        )
      ],
    );
  }

  Wrap getFlipCounterWidget(
      {required String min, required String sec, Color color: Colors.white}) {
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
            fontFamily: 'oswald',
            fontSize: this.fontSize,

            color: color,
          ),
        ),
        Text(
          ":",
          style: TextStyle(
            fontFamily: 'oswald',
            fontSize: this.fontSize,
            color: Colors.white,
          ),
        ),
        Text(
          sec,
          style: TextStyle(
            fontFamily: 'oswald',
            fontSize: this.fontSize,
            color: color,
          ),
        )
      ],
    );
  }
}
