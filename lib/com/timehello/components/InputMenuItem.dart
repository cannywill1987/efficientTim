import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';

class InputMenuItem extends StatefulWidget {
  Widget? icon;
  String title;
  String? subTitle;
  double? maxWidth;
  Widget? rightPartContainer;
  OnTapListener? onTapListener;
  InputMenuItem({this.maxWidth, this.icon, required this.title, this.subTitle, this.rightPartContainer, this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InputMenuItemState();
  }
}

class InputMenuItemState extends State<InputMenuItem> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if(this.widget.icon != null)
          this.widget.icon!,
          SizedBox(
            width: 7,
          ),
          Container(
            constraints: this.widget.maxWidth == null ? null : BoxConstraints(minWidth: this.widget.maxWidth!),
            child: Text(
              this.widget.title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
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
            constraints: BoxConstraints(minHeight: 60),
            // height: 60,
            color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            )));
  }
}
