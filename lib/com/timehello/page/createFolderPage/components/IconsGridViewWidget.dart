import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';

class IconsGridViewWidget extends StatefulWidget {
  OnTapListener? onTapListener;
  Color? color = Color(0xffff8800);
  int defaultIndex = -1;
  double height = 300;
  IconsGridViewWidget({Key? key, this.height = 300, this.onTapListener, this.color, this.defaultIndex = -1})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IconsGridViewWidgetState();
  }
}

class IconsGridViewWidgetState extends State<IconsGridViewWidget> {
  List<SelectObjectTypeModel> _datas = CONSTANTS.getSelectIcons();
  int curSelected = 0;

  @override
  void onCreate() {}

  @override
  void initState() {
    print('initState');
    Future.delayed(Duration(seconds: 0), () {
      setCurIndex(this.widget?.defaultIndex ?? -1);
    });

  }

  void setCurIndex(int icon) {
    int index = -1;
    for (int i = 0; i < _datas.length; i++) {

      SelectObjectTypeModel selectObjectTypeModel = _datas[i];
      if (selectObjectTypeModel.icon!.codePoint == icon) {
        index = i;
      }
    }
    if (index != -1) {
      setState(() {
        this.curSelected = index;
      });
      this.widget.onTapListener!(_datas[index]);
    }
  }

  @override
  void didUpdateWidget(IconsGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    return Container(
      // constraints: BoxConstraints(maxHeight: this.widget.height),
      child: Wrap(
        spacing: 2, //主轴上子控件的间距
        runSpacing: 5, //交叉轴上子控件之间的间距
        children: getItems(),
      ),
    );
  }

  getItems() {
    List<Widget> list = [];
    for (int index = 0; index < _datas.length; index++) {
      list.add(getItem(index));
    }
    return list;
  }

  TextButton getItem(int index) {
    return TextButton(
      style: StylesConfig.transparentTextButtonStyle,
      onPressed: () {
        this.setState(() {
          curSelected = index;
        });
        if (this.widget.onTapListener != null) {
          this.widget.onTapListener!(_datas[index]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: this.curSelected == index
                ? BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8))
                : BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0)),
            color: this.curSelected == index
                ? this.widget.color ?? Color(0xffff8800)
                : Colors.transparent),
        width: 40,
        height: 40,
        child: Icon(
          _datas[index].icon,
          color: this.curSelected == index ? Colors.white : Color(0xffb4b6b9),
        ),
      ),
    );
  }
}
