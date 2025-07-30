import 'package:flutter/cupertino.dart';

class ViewStubWidget extends StatefulWidget {
  bool isShowed = false;
  Widget child;

  ViewStubWidget({required this.isShowed, required this.child});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewStub(isShowed: isShowed);
  }

}

class ViewStub extends State<ViewStubWidget> {
  Widget? child;
  //变为false就不能再改变回来
  bool hasShowed = false;

  ViewStub({required bool isShowed}) {
    this.hasShowed = isShowed;
  }


  @override
  void didUpdateWidget(ViewStubWidget oldWidget) {
    if(this.hasShowed == false) {
      this.hasShowed = this.widget.isShowed;
    }
  }

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //只有第一次用这个额 其他都显示offstage
    if (this.hasShowed == false) {
      return SizedBox.shrink();
    } else {
      return Offstage(offstage: !this.widget.isShowed, child:this.widget.child);
    }
  }

}