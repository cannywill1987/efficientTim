import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

/**
 * 底部按钮列表
 */
class IconButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex;
  bool shouldShowPopupWhenPC = false;

  WrapModeEnum wrapMode = WrapModeEnum.scroll;
  IconButtonListWidget(
      {this.initIndex: 0,
      this.wrapMode: WrapModeEnum.scroll,
      this.shouldShowPopupWhenPC: false,
      required this.list,
      required this.onTapListener,
      this.width: 80}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IconButtonListWidgetState(
        list: this.list, curIndex: this.initIndex ?? 0);
  }
}

class IconButtonListWidgetState extends State<IconButtonListWidget> {
  int curIndex = 0;
  List<CheckButtonStateModel> list;
  double fontSize = 13;
  IconButtonListWidgetState({required this.curIndex, required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.widget.wrapMode == WrapModeEnum.scroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: getList(this.list))),
      );
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 10,
              // gap between adjacent chips
              runSpacing: 4.0,
              // gap between lines
              children: getList(this.list)));
    }
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: fontSize + 10,
        decoration: model.isCheck == true
            ? BoxDecoration(
                color: ThemeManager.getInstance().getDefautThemeColor(),
                borderRadius: BorderRadius.all(Radius.circular(20)))
            : BoxDecoration(
                color: ThemeManager.getInstance().getLightDefaultThemeColor(),
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
              if (model.checkIcon != null) model.checkIcon!,
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
                    : TextStyle(
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultDarkColor: Color(0xffa0a0a0)),
                        fontSize: fontSize),
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
