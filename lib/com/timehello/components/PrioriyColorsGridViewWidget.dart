import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class PrioriyColorsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  int defaultIndexColor = -1;
  List<CheckButtonStateModel> datas = [];
  bool hasTitle;

  PrioriyColorsGridViewWidget(
      {required this.datas,
      this.hasTitle = false,
      this.onTapListener,
      this.defaultIndexColor = -1}) {
    // if (datas != null) {
    //   this.datas = datas;
    // } else {
    //   this.datas = CONSTANTS.getColors();
    // }
  }

  @override
  State<StatefulWidget> createState() {
    return _PrioriyColorsGridViewWidgetState();
  }
}

class _PrioriyColorsGridViewWidgetState extends State<PrioriyColorsGridViewWidget> {
  // int curIndex;

  _PrioriyColorsGridViewWidgetState();

  @override
  void onCreate() {}

  // @override
  // bool get mounted {
  // }

  @override
  void initState() {
    // for (int i = 0; i < this.widget.datas.length; i++) {
    //   if (this.widget.datas[i].color == this.widget.defaultIndexColor) {
    //     this.curIndex = i;
    //   }
    // }

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
                if (this.widget.onTapListener != null) {
                  this.widget.onTapListener!(index);
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
                      ],
                    ),
            );
          }),
    );
  }

  Container getBody(int index) {
    CheckButtonStateModel model = this.widget.datas[index];
    const double height = 15;
    return model.isCheck == true
        ? Container(
            alignment: Alignment.center,
            child: Container(
              height: height,
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
            height: height,
            decoration: BoxDecoration(
              //背景color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              color: Color(this.widget.datas[index].color ?? 0xffff8800),
              //设置四周边框
              border: new Border.all(
                  width: 1, color: Color(this.widget.datas[index].color ?? 0xffff8800)),
            ),
          )
        : Container(
      height: height,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10, right: 10),
            width: 40,
            decoration: BoxDecoration(
              //背景color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              color: Color(this.widget.datas[index].color ?? 0xffff8800),
              //设置四周边框
              border: new Border.all(
                  width: 2, color: Color(this.widget.datas[index].color ?? 0xffff8800)),
            ),
          );
  }
}
