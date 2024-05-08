import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../util/ThemeManager.dart';

/**
 * 我的菜单栏每个item
 */
class SettingMenuItem extends StatefulWidget {
  Widget? icon; //角标
  String? title; //标题
  String? description; //描述
  Widget? rightPartContainer; //右侧容器
  OnTapListener? onTapListener; //点击回调

  SettingMenuItem(
      {this.icon,
      this.title,
      this.description,
      this.rightPartContainer,
      this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingMenuItemState();
  }
}

class SettingMenuItemState extends State<SettingMenuItem> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      this.widget.icon ?? SizedBox.shrink(),
      SizedBox(
        width: 4,
      ),
      Expanded(
          child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this.widget.title ?? "",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      !TextUtil.isEmpty(this.widget.description)
                          ? Wrap(children: [Text(
                              this.widget.description ?? "",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: ColorsConfig.gray_a7,
                                  fontWeight: FontWeight.w600),
                            )],)
                          : SizedBox.shrink()
                    ],
                  )
                ],
              ))
    ];

    if (this.widget.rightPartContainer != null) {
      items.add(SizedBox(width: 20,));
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
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items,
            )));
  }
}
