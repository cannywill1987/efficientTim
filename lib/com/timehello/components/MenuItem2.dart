import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';

class MenuItem2 extends StatefulWidget {
  Widget icon;
  String title;
  String? subTitle;
  Widget? rightPartContainer;
  OnTapListener? onTapListener;
  MenuItem2({required this.icon, required this.title, this.subTitle, this.rightPartContainer, this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MenuItemState();
  }
}

class MenuItemState extends State<MenuItem2> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          this.widget.icon,
          SizedBox(
            width: 7,
          ),
          Text(
            this.widget.title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 2,
          ),
          this.widget.subTitle == null ? SizedBox.shrink() : Text(
            this.widget.subTitle ?? "",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xffa0a0a0)),
          )

        ],
      )
    ];
    if (this.widget.rightPartContainer != null) {
      items.add(this.widget.rightPartContainer!);

    }
    // TODO: implement build
    //获取星星
    return InkWell(
        onTap: () {
          if(this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
            constraints: BoxConstraints(minHeight: 60),
            // height: 60,
            color: ThemeManager.getInstance().getCardBackgroundColor(context: context, defaultColor: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            )));
  }
}
