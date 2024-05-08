import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class WrongWidget extends StatefulWidget {
  double left;
  double top;
  double sizeIcon;
  bool isWrongWidgetVisible;
  Function callbackStateChange;

  WrongWidget(
      {Key? key,
      required this.left,
      required this.top,
      required this.sizeIcon,
      required this.isWrongWidgetVisible,
      required this.callbackStateChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WrongWidgetState(isCorrect: this.isWrongWidgetVisible);
  }
}

class WrongWidgetState extends State<WrongWidget> {
  bool isCorrect;

  WrongWidgetState({required this.isCorrect});

  @override
  void didUpdateWidget(WrongWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this.widget.isWrongWidgetVisible == true) {
      this.isCorrect = this.widget.isWrongWidgetVisible;
      Future.delayed(Duration(seconds: 3), () {
        if(mounted == true) {
          setState(() {
            this.isCorrect = false;
            this.widget.callbackStateChange(this.isCorrect);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
            left: this.widget.left - this.widget.sizeIcon / 2,
            top: this.widget.top - this.widget.sizeIcon / 2,
            child: Offstage(
                offstage: !this.isCorrect,
                child: Utility.getSVGPicture(R.assetsImgIcError,
                size: this.widget.sizeIcon)));
  }
}
