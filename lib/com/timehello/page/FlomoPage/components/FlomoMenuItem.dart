import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';


class FlomoMenuItem extends StatefulWidget {
  Widget icon;
  String title;
  String? subTitle;
  Widget? rightPartContainer;
  List<Widget>? rightPartContainers;
  OnTapListener? onTapListener;
  FlomoMenuItem({required this.icon, required this.title, this.subTitle, this.rightPartContainer, this.onTapListener, this.rightPartContainers});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MenuItemState();
  }
}

class MenuItemState extends State<FlomoMenuItem> {
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
      items.add(SizedBox(
        width: 10,
      ));
      items.add(Flexible(child: this.widget.rightPartContainer!));
    }
    if (this.widget.rightPartContainers != null) {
      items.addAll(this.widget.rightPartContainers as Iterable<Widget>);
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
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            )));
  }
}
