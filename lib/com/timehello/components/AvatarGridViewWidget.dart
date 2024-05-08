import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

import 'LoginAvatarWidget.dart';

class AvatarGridViewWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  Color? color = Color(0xffff8800);

  AvatarGridViewWidget({this.onTapListener, this.color}) {
    if (this.color == null) {
      color = Color(0xffff8800);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _AvatarGridViewWidgetState();
  }
}

class _AvatarGridViewWidgetState extends State<AvatarGridViewWidget> {
  List<String> _datas = CONSTANTS.getAvatarListWidget();
  int curSelected = 0;

  @override
  void onCreate() {}

  // @override
  // bool get mounted {
  //   print('mounted');
  // }

  @override
  void initState() {
    print('initState');
  }

  @override
  void didUpdateWidget(AvatarGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Container(
      height: 300,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 6, //主轴上子控件的间距
          runSpacing: 6, //交叉轴上子控件之间的间距
          children: getItems(),
        ),
      ),
    );
  }

  getItems() {
    List<Widget> list = [];
    list.add(LoginAvatarWidget(
      avatarEnum: AvatarEnum.edit,
    ));
    for (int index = 0; index < _datas.length; index++) {
      list.add(InkWell(
        onTap: () {
          this.setState(() {
            curSelected = index;
          });
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(_datas[index]);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: this.curSelected == index
                  ? BorderRadius.all(Radius.circular(20))
                  : BorderRadius.all(Radius.circular(20)),
              color: this.curSelected == index
                  ? this.widget.color ?? Color(0xffff8800)
                  : Colors.transparent),
          width: 40,
          height: 40,
          child: CONSTANTS.getAvatarFromAvatarList(_datas[index], 20),
        ),
      ));
    }
    return list;
  }
}
