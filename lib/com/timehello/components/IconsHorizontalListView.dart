import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';

class IconsHorizontalListView extends StatefulWidget {
  OnTapListener? onTapListener;
  Color? color = Color(0xffff8800);
  int defaultIndex = -1;

  IconsHorizontalListView(
      {Key? key, this.onTapListener, this.color, this.defaultIndex = -1})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IconsHorizontalListViewState();
  }
}

class IconsHorizontalListViewState extends State<IconsHorizontalListView> {
  List<SelectObjectTypeModel> _datas = CONSTANTS.getSelectIcons();
  int curSelected = 0;
  final ScrollController _scrollController = ScrollController();

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
  void didUpdateWidget(IconsHorizontalListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    //listview添加scrollbar
    // return Scrollbar(
    //   //滚动方向，默认为垂直方向
    //   child: ListView(
    //     //设置水平方向排列
    //     scrollDirection: Axis.horizontal,
    //     children: getItems(),
    //   ),
    // );
    //return getItems();
  //   return Container(
  //     width: 300,
  //     height: 40,
  //     child: getItems2(),
  //   );
  // }
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _datas.length,
          itemBuilder: (context, index) {
            // return Container(width: 30, height: 30,);
            return TextButton(
                style: StylesConfig.transparentTextButtonStyle,
                onPressed: () {
                  setState(() {
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
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10))
                            : BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                        color: this.curSelected == index
                            ? this.widget.color ?? Color(0xffff8800)
                            : Colors.transparent),
                    width: 40,
                    height: 40,
                    child: Icon(
                      _datas[index].icon,
                      color: this.curSelected == index
                          ? Colors.white
                          : Color(0xffb4b6b9),
                    )));
          }),
    );
  }

  getItems() {
    List<Widget> list = [];
    for (int index = 0; index < _datas.length; index++) {
      list.add(TextButton(
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
      ));
    }
    return list;
  }
}
