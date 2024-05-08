import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';

import '../../../util/Utility.dart';

class CircleBackNavigator extends StatelessWidget {
  OnTapListener onTapListener;
  Color? backColor;

  CircleBackNavigator({ this.backColor, required this.onTapListener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          this.onTapListener(null);
        },
        child: Card(
            margin: EdgeInsets.only(top: 25, left: 25),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(80))),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child: BackButton(
                  color: this.backColor ?? Color(0xff404040),
                  onPressed: () {
                    this.onTapListener(null);
                  },
                ))));
  }
}
