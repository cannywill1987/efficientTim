import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/ColorsModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class ColorsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  int? curIndex = 0;
  int defaultIndexColor = -1;
  List<ColorsModel> datas = [];
  bool hasTitle;

  ColorsGridViewWidget(
      {List<ColorsModel>? datas,
      this.hasTitle = false,
      this.onTapListener,
      this.curIndex,
      this.defaultIndexColor = -1}) {
    if (datas != null) {
      this.datas = datas;
    } else {
      this.datas = CONSTANTS.getColors();
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _ColorsGridViewWidgetState(curIndex: this.curIndex ?? 0);
  }
}

class _ColorsGridViewWidgetState extends State<ColorsGridViewWidget> {
  int curIndex;

  _ColorsGridViewWidgetState({required this.curIndex});

  @override
  void onCreate() {}

  // @override
  // bool get mounted {
  // }

  @override
  void initState() {
    for (int i = 0; i < this.widget.datas.length; i++) {
      if (this.widget.datas[i].color == this.widget.defaultIndexColor) {
        this.curIndex = i;
      }
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (this.widget.onTapListener != null) {
    //     this.widget.onTapListener!(this.widget.datas[this.widget.curIndex ?? 0]);
    //   }
    // });
  }

  double size = 40;

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Container(
      height: this.widget.hasTitle ? size + 25 : size,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // padding: EdgeInsets.only(left: 10, right: 10),
          itemCount: this.widget.datas.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                this.curIndex = index;
                if (this.widget.onTapListener != null) {
                  this.widget.onTapListener!(this.widget.datas[index]);
                }
                setState(() {});
              },
              child: TextUtil.isEmpty(this.widget.datas[index].title ?? "")
                  ? getBody(index)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getBody(index),
                        SizedBox(height: 5,),
                        Text(this.widget.datas[index].title ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color:
                                    ThemeManager.getInstance().getTextColor())),
                      ],
                    ),
            );
          }),
    );
  }

  Container getBody(int index) {
    return index == this.curIndex
        ? Container(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                //背景color: Colors.white,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(60.0)),
                // color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 2, color: Color(0xFFEF9A9A)),
              ),
            ),
            margin: EdgeInsets.only(left: 10, right: 10),
            width: size,
            height: size,
            decoration: BoxDecoration(
              //背景color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              color: Color(this.widget.datas[index].color),
              //设置四周边框
              border: new Border.all(
                  width: 1, color: Color(this.widget.datas[index].color)),
            ),
          )
        : Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10, right: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              //背景color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              color: Color(this.widget.datas[index].color),
              //设置四周边框
              border: new Border.all(
                  width: 2, color: Color(this.widget.datas[index].color)),
            ),
          );
  }
}
