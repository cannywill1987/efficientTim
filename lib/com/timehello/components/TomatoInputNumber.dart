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

typedef OnValueChangeListener = void Function(dynamic obj, int? durationEachTomato);

/**
 * PC端用于计数用
 */
class TomatoInputNumber extends StatefulWidget {
  OnValueChangeListener onValueChangeListener;

  TomatoInputNumber({Key? key, required this.onValueChangeListener}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TomatoInputNumberState();
  }
}

class TomatoInputNumberState extends State<TomatoInputNumber> {
  int _counter = 1;
   int duration = SharePreferenceUtil.getSyncInstance().getTomatoTime();


  TomatoInputNumberState() {

  }

  @override
  void didUpdateWidget(TomatoInputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    duration = SharePreferenceUtil.getSyncInstance().getTomatoTime();
  }

  @override
  void initState() {
    super.initState();
    this.widget.onValueChangeListener(_counter, duration);
    duration = SharePreferenceUtil.getSyncInstance().getTomatoTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String hour =
        Utility.getHourFromTimeStamp(this._counter * this.duration).toString();
    String mins =
        Utility.getMinsFromTimeStamp(this._counter * this.duration).toString();
    List<Widget> listWidget = [];
    double redFontSize = Utility.isHandsetBySize() ? 8 : 10;
    double extensionFontSize = Utility.isHandsetBySize() ? 7 : 8;
    listWidget.addAll([
      Text(
        hour,
        style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.red), fontSize: redFontSize),
      ),
      SizedBox(
        width: 1,
      ),
      Text(
        getI18NKey().hour,
        style:
            TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.gray_a7), fontSize: extensionFontSize),
      ),
      SizedBox(
        width: 1,
      ),
      Text(
        mins,
        style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.red), fontSize: redFontSize),
      ),
      SizedBox(
        width: 1,
      ),
      Text(
        getI18NKey().mins2,
        style:
            TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.gray_a7), fontSize: extensionFontSize),
      )
    ]);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeManager.getInstance().getColor(defaultColor: ThemeManager.getInstance().getTextColor(defaultColor: const Color(0xffa0a0a0)))),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      constraints: BoxConstraints(minWidth: 116),
      height: 25,
      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Container(
            width: 22,
            child: TextButton(
              style:
                  StylesConfig.transparentTextButtonStyleWithSize(Size(20, 20)),
              onPressed: () {
                decrement();
              },
              child: Icon(
                Icons.remove,
                color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xffa0a0a0)),
                size: 20,
              ),
            )),
         Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                _counter.toString(),
                style: TextStyle(fontSize: 14, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffa0a0a0))),
              ),
              SizedBox(
                width: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child:
                    Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: 12),
              ),
              SizedBox(
                width: 2,
              ),
              Container(
                width: 1,
                height: 10,
                color: ThemeManager.getInstance().getColor(defaultColor: Color(0xffa0a0a0)),
              ),
              SizedBox(
                width: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                children: [...listWidget],
              ),
            ],
        ),
        // Container(height: 20, color: Color(0xffa0a0a0),),
        Container(
          width: 22,
          child: TextButton(
            style:
                StylesConfig.transparentTextButtonStyleWithSize(Size(20, 20)),
            onPressed: () {
              increment();
            },
            child: Icon(
              Icons.add,
              color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xffa0a0a0)),
              size: 20,
            ),
          ),
        ),
      ]),
    );
  }

  void increment() {
    setState(() {
      _counter++;
    });
    this.widget.onValueChangeListener(_counter, duration);
  }

  void decrement() {
    setState(() {
      if (_counter > 1) _counter--;
      this.widget.onValueChangeListener(_counter, duration);
    });
  }
}
