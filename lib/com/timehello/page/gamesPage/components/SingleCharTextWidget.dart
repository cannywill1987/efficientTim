import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ENUMS.dart';
import '../../../interface/OnCheckListener.dart';

class SingleCharTextWidget extends StatefulWidget {
  late String text;
  double? fontSize;
  double? dotSize = 3;
  Color? dotColor;

  double? width = 25;
  bool isChecked;
  bool isEnable;
  int? gameDotPositionEnum;
  int? singleCharCheckModeEnum;
  double itemWidth;
  double itemHeight;
  Color? colorUnchecked;
  Color? colorChecked;
  OnCheckListener? onCheckListener;
  SingleCharTextWidget({required this.text,
    this.isEnable = true,
    required this.itemWidth,
    required this.itemHeight,
    width: 25,
     this.isChecked = false,
    this.colorUnchecked,
    this.colorChecked,
    this.onCheckListener,
    this.dotSize = 3,
    this.fontSize = 14,
    this.gameDotPositionEnum,
    dotColor}) {
    // if (dotColor != null) {
    // if (this.gameDotPositionEnum == GameDotPositionEnum.random) {

    //   this.gameDotPositionEnum.index = Utility.getRandom(from: 0, max: 6);
    // }
    this.colorUnchecked = colorUnchecked ?? Color(0xff404040);
    this.colorChecked = colorChecked ?? Colors.red;
    this.dotColor = dotColor ?? Color(0xff404040);
    // }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SingleCharTextWidgetState(isChecked: this.isChecked);
  }
}

class SingleCharTextWidgetState extends State<SingleCharTextWidget> {
  bool isChecked;
  late Alignment dotAlignment;

  SingleCharTextWidgetState({required this.isChecked}) {
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    this.isChecked = this.widget.isChecked;
  }


  @override
  void initState() {
    this.getWidgetAlignment();
  }

  void getWidgetAlignment() {
    int valGameDotPositionEnum = this.widget.gameDotPositionEnum ?? 0;
    if (GameDotPositionEnum.random.index == valGameDotPositionEnum) {
      valGameDotPositionEnum = Utility.getRandom(from: 0, max: 6);
    }
    dotAlignment = valGameDotPositionEnum == GameDotPositionEnum.bottomCenter.index
        ? Alignment.bottomCenter
        : valGameDotPositionEnum == GameDotPositionEnum.bottomLeft.index
        ? Alignment.bottomLeft
        : valGameDotPositionEnum == GameDotPositionEnum.left.index
        ? Alignment.centerLeft
        : valGameDotPositionEnum == GameDotPositionEnum.topLeft.index
        ? Alignment.topLeft
        : valGameDotPositionEnum ==
        GameDotPositionEnum.topCenter.index
        ? Alignment.topCenter
        : valGameDotPositionEnum ==
        GameDotPositionEnum.topRight.index
        ? Alignment.topRight
        : valGameDotPositionEnum ==
        GameDotPositionEnum.right
        ? Alignment.centerRight
        : valGameDotPositionEnum ==
        GameDotPositionEnum.bottomRight.index
        ? Alignment.bottomRight
        : Alignment.bottomCenter;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        if (this.widget.isEnable == true) {
          setState(() {
            this.isChecked = !this.isChecked;
          });
        }
        if (this.widget.onCheckListener != null) {
          this.widget.onCheckListener!(this.isChecked);
        }
      },
      child: Card(
          clipBehavior: Clip.antiAlias,
          shape:RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(25)
                  ),
      color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white), child:Container(
          width: this.widget.itemWidth,
          height: this.widget.itemHeight,
          child: Align(
              child: Container(
                color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
                constraints: BoxConstraints(
                  maxHeight: 30,
                  maxWidth: 30,
                ),
                // width: this.widget.width,
                // height: this.widget.width,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    this.widget.gameDotPositionEnum != GameDotPositionEnum.none
                        ? Align(
                      alignment: dotAlignment,
                      child: Container(
                        width: this.widget.dotSize,
                        height: this.widget.dotSize,
                        decoration: BoxDecoration(
                            color: this.isChecked == true ? this.widget
                                .colorChecked : ThemeManager.getInstance().getTextColor(defaultColor: this.widget.colorUnchecked),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                      ),
                    )
                        : SizedBox.shrink(),
                    Center(
                      child: Container(
                        child: Text(
                          this.widget.text,
                          style: TextStyle(
                              fontSize: this.widget.fontSize,
                              color: this.isChecked == true ? this.widget
                                  .colorChecked : ThemeManager.getInstance().getTextColor(defaultColor: this.widget.colorUnchecked)),
                        ),
                      ),
                    )
                  ],
                ),
              )))),
    );
  }

  getItem() {
    if (this.widget.singleCharCheckModeEnum ==
        SingleCharCheckModeEnum.normal) {}
  }
}
