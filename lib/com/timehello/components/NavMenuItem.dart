import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../config/ColorsConfig.dart';

class NavMenuItem extends StatelessWidget {
  Function onTapListener;
  Widget? icon;
  String title;
  String? subtitle;
  NavMenuItem({required this.onTapListener,  this.icon, required this.title,  this.subtitle});

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
          height: 60,
          color: ThemeManager.getInstance().getNavigationBarColor(defaultColor: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              icon ?? SizedBox.shrink(),
              SizedBox(
                width: 7,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  TextUtil.isEmpty(this.subtitle) ? SizedBox.shrink() : Text(
                    this.subtitle ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                ],
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: ColorsConfig.gray_cc_cancel,
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )),
    );
  }

}