import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flip_board/flip_clock.dart';
// import 'package:flip_board/flip_widget.dart';

import '../../../components/custom_flip_widget.dart';
import '../../../util/CounterManagement.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/Utility.dart';

class MobileFlipCounterWidget extends StatefulWidget {
  String sec;
  String min;
  // double fontSize = 160.0;
  Widget? headChild;
  Widget? bottomChild;
  // double fontSize
  MobileFlipCounterWidget({Key? key, this.headChild,this.bottomChild, this.sec = "00", this.min = "00"}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CounterState();
  }
}

class CounterState extends State<MobileFlipCounterWidget> {
  final  _flipControllerSec1 = StreamController<int>.broadcast();
  final  _flipControllerSec2 = StreamController<int>.broadcast();
  final  _flipControllerMin1 = StreamController<int>.broadcast();
  final  _flipControllerMin2 = StreamController<int>.broadcast();
  final  _flipControllerHour1 = StreamController<int>.broadcast();
  final  _flipControllerHour2 = StreamController<int>.broadcast();
  int _nextFlipValue = 0;
  int screenH = 0;
  int screenW = 0;
  double itemWidth = 0.0;
  double itemHeight = 0.0;
  double fontSize = 160.0;
  int space = 20; // 分和秒间隔
  int spaceDigital = 5; // 两个数字 sec1和sec2 之间的间隔
  Duration duration = Duration(milliseconds: DeviceInfoManagement.isWEB() == true? 900 : 900);
  Function? onTimerTick;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // screenH = Utili;
    // screenW = MediaQuery.of(context).size.width.toInt();
    onTimerTick = (int time) {
      this.widget.min = Utility.getMins(CounterManagement.getInstance().curTimeF);
      this.widget.sec = Utility.getSeconds(CounterManagement.getInstance().curTimeF);
      setState(() {

      });
    };
    CounterManagement.getInstance().addOnTimerTickListener(onTimerTickListener: onTimerTick!);

  }

  @override
  void dispose() {
    super.dispose();
    CounterManagement.getInstance()
        .removeOnTimerTickListenerList(onTimerTickListenerList: onTimerTick!);
    // CounterManagement.getInstance().dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraints) {
      screenW = constraints.maxWidth.toInt();
      screenH = constraints.maxHeight.toInt();
      setMinValue(int.parse(this.widget.min));
      setSecValue(int.parse(this.widget.sec));
      // screenH = MediaQuery.of(context).size.height.toInt();
      // screenW = MediaQuery.of(context).size.width.toInt();
      itemHeight = this.itemHeight;
      if(screenW > screenH) { // 横屏
        itemWidth = screenW / 4 - 30; //横屏
        itemHeight = screenH - 30; //竖屏
        this.fontSize = (itemWidth > itemHeight ? itemHeight : itemWidth) - 30;
        space = this.fontSize ~/ 8;
        spaceDigital = this.fontSize ~/ 20;
        // if(itemHeight > 160) {
        //   this.itemHeight = 160;
        // }
        return getHorizontalFlipWidget();
      } else {
        itemWidth = screenW / 4 - 30; //横屏
        itemHeight = screenH - 30; //竖屏
        this.fontSize = (itemWidth > itemHeight ? itemHeight : itemWidth) - 30;
        space = this.fontSize ~/ 8;
        spaceDigital = this.fontSize ~/ 20;

        // itemWidth = screenW / 2 - 30; //横屏
        // itemHeight = screenH / 2 - 30; //竖屏
        // this.fontSize = (itemWidth > itemHeight ? itemHeight : itemWidth) - 30;
        space = this.fontSize ~/ 2;
        // return getHorizontalFlipWidget();
        return getVerticalFlipWidget();
      }
    });
  }



  Widget getVerticalFlipWidget() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 10,),
          if(this.widget.headChild != null)
            this.widget.headChild!,
              Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _flipWidget(controller1: _flipControllerMin1, controller2: _flipControllerMin2),
              SizedBox(width: space.toDouble(),),
              _flipWidget(controller1: _flipControllerSec1, controller2: _flipControllerSec2)
            ],),
          Spacer(),
                    if(this.widget.bottomChild != null)
                      this.widget.bottomChild!
        ],
      ),
    );

    // return Container(
    //   color: Colors.black,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           Spacer(),
    //           Expanded(flex: 3, child: _flipWidget(controller1: _flipControllerMin1, controller2: _flipControllerMin2)),
    //           Spacer(),
    //           // Container(width: 100,),
    //           Expanded(flex: 3, child: _flipWidget(controller1: _flipControllerSec1, controller2: _flipControllerSec2)),
    //           if(this.widget.bottomChild != null)
    //             Expanded(flex: 3,child: this.widget.bottomChild!)
    //         ],),
    //     ],
    //   ),
    // );
  }

  Widget getHorizontalFlipWidget() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
            _flipWidget(controller1: _flipControllerMin1, controller2: _flipControllerMin2),
            SizedBox(width: space.toDouble(),),
            _flipWidget(controller1: _flipControllerSec1, controller2: _flipControllerSec2)
          ],),
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

  Widget _flipWidget({controller1, controller2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomFlipWidget(
        flipType: FlipType.middleFlip,
        itemStream: controller1.stream,
        itemBuilder: _numberItemBuilder,
        initialValue: _nextFlipValue,
        flipDirection: AxisDirection.up,
        // flipCurve: direction == AxisDirection.down ? FlipWidget.bounceFastFlip : FlipWidget.defaultFlip,
        flipDuration: duration,
        perspectiveEffect: 0,
        hingeWidth: 0.5,
        hingeLength: 5.0,
        hingeColor: Colors.black,
          ),
        SizedBox(width: this.spaceDigital.toDouble(),),
        CustomFlipWidget(
          flipType: FlipType.middleFlip,
          itemStream: controller2.stream,
          itemBuilder: _numberItemBuilder,
          initialValue: _nextFlipValue,
          flipDirection: AxisDirection.up,
          // flipCurve: direction == AxisDirection.down ? FlipWidget.bounceFastFlip : FlipWidget.defaultFlip,
          flipDuration: duration,
          perspectiveEffect: 0,
          hingeWidth: 0.5,
          hingeLength: 5.0,
          hingeColor: Colors.black,
        ),
      ],
    );
  }


}
