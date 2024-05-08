import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

import '../models/GroupModel.dart';

/**
 * 底部按钮列表
 */
class GroupIconButtonListWidget extends StatefulWidget {
  List<GroupModel> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex;
  bool shouldShowPopupWhenPC = false;

  GroupIconButtonListWidget(
      {this.initIndex: 0,
      this.shouldShowPopupWhenPC: false,
      required this.list,
      required this.onTapListener,
      this.width: 80}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GroupIconButtonListWidgetState(curIndex: this.initIndex ?? 0);
  }
}

class GroupIconButtonListWidgetState extends State<GroupIconButtonListWidget> {
  int curIndex = 0;
  // List<GroupModel> list;
  double fontSize = 13;
  GroupIconButtonListWidgetState({required this.curIndex});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: getList(this.widget.list)),
    );
  }

  @override
  void initState() {
    if (this.curIndex != null) {
      for (int i = 0; i < this.widget.list.length; i++) {
        GroupModel model = this.widget.list[i];
        if (this.curIndex == i) {
          model.isCheck = true;
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  GroupModel? getCurModel() {
    for (int i = 0; i < this.widget.list.length; i++) {
      GroupModel model = this.widget.list[i];
      if (model?.isCheck ?? false) {
        return model;
      }
    }
    return null;
  }

  List<Widget> getList(List<GroupModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(SizedBox(width: 10));
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  Widget getCheckButton(GroupModel model, int index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: fontSize + 10,
        decoration: model.isCheck == true
            ? BoxDecoration(
                color: Color(0xff7171ed),
                borderRadius: BorderRadius.all(Radius.circular(20)))
            : BoxDecoration(
                color: Color(0xfff5f4f9),
                borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          radius: 10,
          onTap: () {
            this.initModelListState();
            setState(() {
              if (model.isCheck == false) {
                this.widget.onTapListener({"data": model, "index": index});
              }
              model.isCheck = true;
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              // if(model.icon != null)
              // model.icon!,
              SizedBox(
                width: 4,
              ),
              new Text(
                model.title ?? '',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: model.isCheck == true
                    ? TextStyle(color: Colors.white, fontSize: fontSize)
                    : TextStyle(color: Color(0xff404040), fontSize: fontSize),
              )
            ],
          ),
        ));
  }

  void initModelListState() {
    this.widget.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
