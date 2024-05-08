import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

import '../../../../../r.dart';

typedef OnCheckedListener = void Function(bool isChecked, dynamic data);

class FlomoCheckContainer extends StatelessWidget {
  bool checked = false;
  String checkedImg = R.assetsImgIcArrowDown;
  String unckeckedImg = R.assetsImgIcArrowUp;
  double width = 35.0;
  double height = 35.0;
  Widget? checkWidget;
  Widget? uncheckWidget;
  // FlomoCheckContainerState? checkContainerState;
  OnCheckedListener? onCheckedListener;
  bool isNeedUpdateUI = true; //更新UI是否启动
  dynamic data;
  // , this.checkedImg, this.unckeckedImg
  FlomoCheckContainer(
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

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return checkContainerState =
  //       new FlomoCheckContainerState(checked: this.checked, isNeedUpdateUI: this.isNeedUpdateUI);
  // }
  //
  // void setChecked(bool checked) {
  //   if (checkContainerState != null) {
  //     checkContainerState?.setChecked(checked);
  //   }
  // }

  @override
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Icon(this.widget.checkIcon, size: this.widget.width,)
    // print("aaaaaaaaaaaaaaaaa:" + this.checked.toString());
    if (this.width != null && this.onCheckedListener != null) {
      return InkWell(
          onTap: () {
            // if (this.isNeedUpdateUI == true) {
            //   setState(() {
            //     this.checked = !this.checked;
            //   });
            // }
            if (this.onCheckedListener != null) {
              this.onCheckedListener!(this.checked, this.data);
            }
          },
          child: Container(width:this.width, height: this.height,child:this.checked == true
              ? this.checkWidget
              : this.uncheckWidget));
      // return new Image.asset(this.checked?this.checkedImg:this.unckeckedImg, width: this.width, height: this.height,fit: BoxFit.cover,);
    } else if(this.onCheckedListener != null){
      return InkWell(
          onTap: () {
            // if (this.isNeedUpdateUI == true) {
            //   setState(() {
            //     this.checked = !this.checked;
            //   });
            // }
            if (this.onCheckedListener != null) {
              this.onCheckedListener!(this.checked, this.data);
            }
          },
          child: this.checked == true
              ? this.checkWidget
              : this.uncheckWidget);
      // return new Image.asset(this.checked?this.checkedImg:this.unckeckedImg, width: this.width, height: this.height,fit: BoxFit.cover,);
    } else {
      return this.checked == true
          ? this.checkWidget!
          : this.uncheckWidget!;
    }
  }
}

// class FlomoCheckContainerState extends State<FlomoCheckContainer> {
//   bool checked = false;
//   bool isNeedUpdateUI = true;
//
//   FlomoCheckContainerState({required this.checked, required this.isNeedUpdateUI});
//
//   void setChecked(bool checked) {
//     setState(() {
//       this.checked = checked;
//     });
//   }
//
//   @override
//   didUpdateWidget(FlomoCheckContainer oldWidget) {
//     this.checked = this.checked;
//     super.didUpdateWidget(oldWidget);
//   }
//
//
// }
