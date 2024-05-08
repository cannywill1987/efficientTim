import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

import '../../../r.dart';

class CheckImage extends StatefulWidget {
  bool checked = false;
  String checkedImg = R.assetsImgIcArrowDown;
  String unckeckedImg = R.assetsImgIcArrowUp;
  OnTapListener? onTapListener;
  CheckImageState? checkImageState;
  Widget? checkIcon;
  Widget? uncheckIcon;
  bool? autoCheck = false;
  double width;
  double height;
  bool isSizeConfigured = false; //TextButton不设置宽高会有默认边距， isSizeConfigured true 是为了让宽高生效
  // , this.checkedImg, this.unckeckedImg
  CheckImage(
      {Key? key,
        this.width = 30,
        this.height = 30,
        this.isSizeConfigured = false,
      this.checkIcon,
      this.uncheckIcon,
      this.checked = false,
        this.autoCheck = false,
      this.onTapListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return checkImageState = new CheckImageState(checked: this.checked);
  }

  void setChecked(bool checked) {
    if (checkImageState != null) {
      checkImageState!.setChecked(checked);
    }
  }
}

class CheckImageState extends State<CheckImage> {
  bool checked = false;

  CheckImageState({required this.checked});

  void setChecked(bool checked) {
    setState(() {
      this.widget.checked = checked;
    });
  }


  @override
  void didUpdateWidget(CheckImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.checked = this.widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Icon(this.widget.checkIcon, size: this.widget.width,)
    if (this.widget.onTapListener != null) {
      return TextButton(
        style: this.widget.isSizeConfigured == true ? StylesConfig.transparentTextButtonStyleWithSize(Size(this.widget.width, this.widget.height)) : StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(this.checked);
          }
          if (this.widget.autoCheck == true) {
            setState(() {
              this.checked = !this.checked;
            });
          }
        },
        child: this.checked == true
            ? this.widget.checkIcon!
            : this.widget.uncheckIcon!,
      );
    } else {
      return this.widget.checked == true
          ? this.widget.checkIcon!
          : this.widget.uncheckIcon!;
    }
    // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }
}
