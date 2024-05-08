import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/CONSTANTS.dart';
import '../../../util/Utility.dart';

/**
 * 底部按钮列表
 */
class WQBButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex;
  bool shouldShowPopupWhenPC = false;

  WQBButtonListWidget(
      {this.initIndex: 0,
      this.shouldShowPopupWhenPC: false,
      required this.list,
      required this.onTapListener,
      this.width: 80}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBButtonListWidgetState(
        list: this.list, curIndex: this.initIndex ?? 0);
  }
}

class WQBButtonListWidgetState extends State<WQBButtonListWidget> {
  int curIndex = 0;
  List<CheckButtonStateModel> list;

  WQBButtonListWidgetState({required this.curIndex, required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff7171ed), width: 1),
                  color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getList(this.list)))
        ]);
  }

  @override
  void initState() {
    if (this.curIndex != null) {
      for (int i = 0; i < this.list.length; i++) {
        CheckButtonStateModel model = this.list[i];
        if (this.curIndex == i) {
          model.isCheck = true;
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  CheckButtonStateModel? getCurModel() {
    for (int i = 0; i < this.list.length; i++) {
      CheckButtonStateModel model = this.list[i];
      if (model.isCheck) {
        return model;
      }
    }
    return null;
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(SizedBox(width: 10));
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        height: 40,
        decoration: model.isCheck == true
            ? BoxDecoration(
                color: Color(0xff7171ed),
                borderRadius: BorderRadius.all(Radius.circular(20)))
            : BoxDecoration(
                color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xfff5f4f9)),
                borderRadius: BorderRadius.all(Radius.circular(20))),
        child: GestureDetector(
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
              new Text(
                model.title ?? '',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: model.isCheck == true
                    ? TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.white), fontSize: 15)
                    : TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: 15),
              )
            ],
          ),
        ));
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
