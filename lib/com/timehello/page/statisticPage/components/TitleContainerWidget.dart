import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class TitleContainerWidget extends StatefulWidget {
  Icon? icon;
  String title;
  String? subTitle;
  Widget? rightPartContainer;
  OnTapListener? onTapListener;

  TitleContainerWidget(
      {this.icon,
      required this.title,
      this.subTitle,
      this.rightPartContainer,
      this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TitleContainerWidgetState();
  }
}

class TitleContainerWidgetState extends State<TitleContainerWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          this.widget.icon ?? SizedBox.shrink(),
          SizedBox(
            width: 4,
          ),
          Text(
            this.widget.title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff494949)),
                decoration: TextDecoration.none),
          ),
          this.widget.subTitle == null
              ? SizedBox.shrink()
              : Text(
                  this.widget.subTitle ?? "",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffa0a0a0)),
                )
        ],
      )
    ];
    if (this.widget.rightPartContainer != null) {
      items.add(this.widget.rightPartContainer!);
    }
    // TODO: implement build
    //获取星星
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 35,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items,
        ));
  }
}
