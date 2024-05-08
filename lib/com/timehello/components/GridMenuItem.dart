import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../config/ColorsConfig.dart';

class GridMenuItem extends StatelessWidget {
  Function onTapListener;
  Widget? icon;
  String title;
  String? subtitle;

  GridMenuItem(
      {required this.onTapListener,
      this.icon,
      required this.title,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        if (onTapListener != null) {
          onTapListener();
        }
      },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white)),
          padding: EdgeInsets.symmetric(vertical: 5),
          width: 60,
          height: 90,
          // color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 25, child: icon ?? SizedBox.shrink()),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 5,
              ),
              //只一行text
              Text(
                this.subtitle ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )),
    );
  }
}
