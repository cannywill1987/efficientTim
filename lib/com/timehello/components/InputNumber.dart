import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../util/TextUtil.dart';
import 'CheckContainer.dart';

typedef OnValueChangeListener = void Function(
    dynamic obj, int? durationEachTomato);

/**
 * PC端用于计数用
 */
class InputNumber extends StatefulWidget {
  OnValueChangeListener onValueChangeListener;
  String unit;
  int defaultVal;
  InputNumber({Key? key, this.defaultVal: 1, required this.onValueChangeListener, required this.unit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InputNumberState(counter: this.defaultVal);
  }
}

class InputNumberState extends State<InputNumber> {
  int counter = 1;
  int duration = SharePreferenceUtil.getSyncInstance().getTomatoTime();
  double margin = 30;
  double sizeBtn = 30;
  InputNumberState({required this.counter}) {}

  @override
  void didUpdateWidget(InputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    duration = SharePreferenceUtil.getSyncInstance().getTomatoTime();
  }

  @override
  void initState() {
    super.initState();
    this.widget.onValueChangeListener(counter, duration);
    duration = SharePreferenceUtil.getSyncInstance().getTomatoTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String hour =
        Utility.getHourFromTimeStamp(this.counter * this.duration).toString();
    String mins =
        Utility.getMinsFromTimeStamp(this.counter * this.duration).toString();

    return Container(
      constraints: BoxConstraints(minWidth: 116),
      height: 25,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // 色值ff8800的圆角矩形
                width: sizeBtn,
                height: sizeBtn,
                decoration: BoxDecoration(
                  color: counter == 1 ? Color(ThemeManager.getInstance().getDefautThemeColorInt() - 0x50000000) : ThemeManager.getInstance().getDefautThemeColor(),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: InkWell(
                  onTap: () {
                    decrement();
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 20,
                  ),
                )),
            SizedBox(width: margin,),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(counter.toString(),
                    style: TextStyle(
                        fontSize: 26,
                        color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)),
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(this.widget.unit,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffa0a0a0)))),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
            // Container(height: 20, color: Color(0xffa0a0a0),),
            SizedBox(width: margin,),
            Container(
              // 色值ff8800的圆角矩形
              width: sizeBtn,
              height: sizeBtn,
              decoration: BoxDecoration(
                color: ThemeManager.getInstance().getDefautThemeColor(),
                borderRadius: BorderRadius.circular(6),
              ),

              child: InkWell(
                onTap: () {
                  increment();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ]),
    );
  }

  void increment() {
    setState(() {
      counter++;
    });
    this.widget.onValueChangeListener(counter, duration);
  }

  void decrement() {
    setState(() {
      if (counter > 1) counter--;
      this.widget.onValueChangeListener(counter, duration);
    });
  }
}
