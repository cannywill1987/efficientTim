import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

import '../../../r.dart';

typedef OnCheckedListener = void Function(bool isChecked, dynamic data);

class CheckContainer extends StatefulWidget {
  bool checked = false;
  String checkedImg = R.assetsImgIcArrowDown;
  String unckeckedImg = R.assetsImgIcArrowUp;
  double width = 35.0;
  double height = 35.0;
  Widget? checkWidget;
  Widget? uncheckWidget;
  CheckContainerState? checkContainerState;
  OnCheckedListener? onCheckedListener;
  bool isNeedUpdateUI = true; //更新UI是否启动
  dynamic data;
  // , this.checkedImg, this.unckeckedImg
  CheckContainer(
      {Key? key,
      this.checkWidget,
      this.uncheckWidget,
      checked ,
      this.isNeedUpdateUI = true,
      this.width = 35.0,
      this.height = 35.0,
        this.data,
      this.onCheckedListener})
      : super(key: key) {
    this.checked = checked ?? false;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return checkContainerState =
        new CheckContainerState(checked: this.checked, isNeedUpdateUI: this.isNeedUpdateUI);
  }

  void setChecked(bool checked) {
    if (checkContainerState != null) {
      checkContainerState?.setChecked(checked);
    }
  }
}

class CheckContainerState extends State<CheckContainer> {
  bool checked = false;
  bool isNeedUpdateUI = true;

  CheckContainerState({required this.checked, required this.isNeedUpdateUI});

  void setChecked(bool checked) {
    setState(() {
      this.checked = checked;
    });
  }

  @override
  didUpdateWidget(CheckContainer oldWidget) {
    this.checked = this.widget.checked;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Icon(this.widget.checkIcon, size: this.widget.width,)
    // print("aaaaaaaaaaaaaaaaa:" + this.checked.toString());
    if (this.widget.width != null && this.widget.onCheckedListener != null) {
      return InkWell(
          onTap: () {
            if (this.isNeedUpdateUI == true) {
              setState(() {
                this.checked = !this.checked;
              });
            }
            if (this.widget.onCheckedListener != null) {
              this.widget.onCheckedListener!(this.checked, this.widget.data);
            }
          },
          child: Container(constraints: BoxConstraints(minWidth: this.widget.width), height: this.widget.height,child:this.checked == true
              ? this.widget.checkWidget
              : this.widget.uncheckWidget));
      // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
    } else if(this.widget.onCheckedListener != null){
      return InkWell(
          onTap: () {
            if (this.isNeedUpdateUI == true) {
              setState(() {
                this.checked = !this.checked;
              });
            }
            if (this.widget.onCheckedListener != null) {
              this.widget?.onCheckedListener!(this.checked, this.widget.data);
            }
          },
          child: this.checked == true
              ? this.widget.checkWidget
              : this.widget.uncheckWidget);
      // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
    } else {
      return this.checked == true
          ? this.widget.checkWidget!
          : this.widget.uncheckWidget!;
    }
  }
}
