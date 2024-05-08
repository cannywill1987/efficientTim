import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import '../../../r.dart';


class StateImage extends StatefulWidget {
  int curImgIndex = 0;
  String checkedImg = R.assetsImgIcArrowDown;
  String unckeckedImg = R.assetsImgIcArrowUp;
  List<String> imgList = <String>[];
  double width = 35.0;
  double height = 35.0;
  OnTapListener? onTapListener;
  StateImageState? checkImageState;
  // , this.checkedImg, this.unckeckedImg
  StateImage({Key? key, this.imgList = const [],
    this.width = 35.0,
    this.height = 35.0,
    this.onTapListener}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return checkImageState = new StateImageState();
  }

  void setChecked(int index) {
    if (checkImageState != null) {
      checkImageState?.setCurState(index);
    }
  }
}

class StateImageState extends State<StateImage> {

  void setCurState(int index) {
    setState(() {
      this.widget.curImgIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Image.asset(this.widget.imgList[this.widget.curImgIndex], width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }

}