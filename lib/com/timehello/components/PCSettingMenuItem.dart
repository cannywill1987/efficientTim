import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class PCSettingMenuItem extends StatefulWidget {
  Icon? icon;
  String? title;
  String? description;
  Widget? rightPartContainer;
  OnTapListener? onTapListener;

  PCSettingMenuItem(
      {this.icon,
      this.title,
      this.description,
      this.rightPartContainer,
      this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCSettingMenuItemState();
  }
}

class PCSettingMenuItemState extends State<PCSettingMenuItem> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          this.widget.icon ?? SizedBox.shrink(),
          Container(
              padding: EdgeInsets.only(left: 25),
              width: 24,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    this.widget.title ?? "",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  !TextUtil.isEmpty(this.widget.description)
                      ? Text(
                          this.widget.description ?? "",
                          style: TextStyle(
                              fontSize: 11,
                              color: ColorsConfig.gray_a7,
                              fontWeight: FontWeight.w600),
                        )
                      : SizedBox.shrink()
                ],
              )),
        ],
      )
    ];
    if (this.widget.rightPartContainer != null) {
      items.add(SizedBox(
        width: 150,
      ));
      items.add(this.widget.rightPartContainer ?? SizedBox.shrink());
    }
    // TODO: implement build
    //获取星星
    return InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(null);
          }
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 60,
            color: ThemeManager.getInstance().getNavigationBarColor(defaultColor: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            )));
  }
}
