import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

class LivesWidget extends StatefulWidget {
  int curNumber = 0;
  int number = 3;
  String? checkedSvgPath;
  String? uncheckedSvgPath = "";
  LivesWidget({this.checkedSvgPath, this.uncheckedSvgPath, this.curNumber = 0, this.number = 3}) {
    // if(this.checkedSvgPath?.isEmpty == true) {
    //   this.checkedSvgPath = R.assetsImgIcTomatoChecked;
    // }
    //
    // if(this.uncheckedSvgPath?.isEmpty == true) {
    //   this.uncheckedSvgPath = R.assetsImgIcTomatoChecked;
    // }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LivesWidgetState();
  }
}

class LivesWidgetState extends State<LivesWidget> {
  List<Widget> getCheckImageByNumber() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.number; i++) {
      list.add(SizedBox(width: 3,),);
      list.add(
        CheckImage(
          checkIcon: Utility.getSVGPicture(this.widget.checkedSvgPath ?? "", size: 15),
          uncheckIcon: Utility.getSVGPicture(this.widget.uncheckedSvgPath ?? "", size: 15),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Container(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...getCheckImageByNumber()
          ],
        ),
      );
    // }
  }
}
