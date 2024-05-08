import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../util/ScreenUtil.dart';
import '../util/TextUtil.dart';


/**
 * mission设置页面的tag
 */
class PrompsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapItemListener;
  List<String> datas = [];

  PrompsGridViewWidget(
      {this.onTapItemListener,
      required this.datas});

  @override
  State<StatefulWidget> createState() {
    return _PrompsGridViewWidgetState();
  }
}

class _PrompsGridViewWidgetState extends State<PrompsGridViewWidget> {
  @override
  void onCreate() {}

  @override
  void initState() {
  }

  @override
  void didUpdateWidget(PrompsGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: ScreenUtil.getScreenW(context) - 100,
          child: Wrap(
            spacing: 2, //主轴上子控件的间距
            runSpacing: 5, //交叉轴上子控件之间的间距
            children: getItems(),
          ),
        )
      ],
    );
  }

  /**
   * 每个tag items
   */
  getItems() {
    List<Widget> list = [];
    for (int index = 0; index < this.widget.datas.length; index++) {
      String prompt = this.widget.datas[index];
      list.add(GestureDetector(
        onTap: () {
          if (this.widget.onTapItemListener != null) {
            this.widget.onTapItemListener!(this.widget.datas[index]);
          }
        },
        child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Color(0xff909090)),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  prompt,
                  style: TextStyle(
                      color: Color(
                        0xff909090,
                      ),
                      fontSize: 13),
                ),
              ],
            )),
      ));
    }
    list.add(getButton());
    return list;
  }

  Widget getButton() {
    Color color = Color(0xff909090);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: color),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: GestureDetector(
            onTap: () async {
              if (this.widget.onTapItemListener != null) {
                this.widget.onTapItemListener!(this.widget.datas);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: color),
                SizedBox(
                  width: 3,
                ),
                Text(
                  "添加提醒",
                  style: TextStyle(color: color, fontSize: 11),
                ),
              ],
            )));
  }
}
