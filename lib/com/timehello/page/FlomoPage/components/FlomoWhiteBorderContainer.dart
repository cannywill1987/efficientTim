import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class FlomoWhiteBorderContainer extends StatelessWidget {
  Widget child;
  double paddingTopBtm = 10;
  FlomoWhiteBorderContainer({required this.child, this.paddingTopBtm: 14});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingTopBtm),
        // constraints: BoxConstraints(
        //   // maxHeight: 80,
        // ),
        // height: 80,
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }
}
