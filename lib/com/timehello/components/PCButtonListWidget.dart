import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../config/CONSTANTS.dart';
import '../util/Utility.dart';

class PCButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex;
  bool shouldShowPopupWhenPC = false;

  PCButtonListWidget(
      {this.initIndex: 0,
        this.shouldShowPopupWhenPC: false,
      required this.list,
      required this.onTapListener,
      this.width: 80}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCButtonListWidgetState();
  }
}

class PCButtonListWidgetState extends State<PCButtonListWidget> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (Utility.isHandsetBySize() == false) {
      if (this.widget.shouldShowPopupWhenPC == true) {
        return getPopupMenu();
      } else {
      return Row(children: getList(this.widget.list));
      }
    } else {
      return getPopupMenu();
    }
  }

  Container getPopupMenu() {
    return Container(
        margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
        child: PopupMenuButton<String>(
          tooltip: '',
          padding: EdgeInsets.all(0.0),
          child: Container(
            height: Utility.isHandsetBySize()? 28 : 35,
            padding: EdgeInsets.symmetric(horizontal: Utility.isHandsetBySize()? 5 : 10),
            decoration: BoxDecoration(
                color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 1,
                ),
                Text(this.getCurModel()?.title ?? '', style: TextStyle(fontSize: Utility.isHandsetBySize()? 12: 16, color: Colors.red),)
              ],
            ),
          ),
          onSelected: (String val) {},
          itemBuilder: (context) {
            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
            return getPopupMenuList();
          },
        ));
  }

  List<PopupMenuEntry<String>> getPopupMenuList() {
    List<PopupMenuEntry<String>> list = [];

    for (int i = 0; i < this.widget.list.length; i++) {
      CheckButtonStateModel model = this.widget.list[i];
      list.add(
        PopupMenuItem<String>(
          value: model.code,
          child: Text(model.title ?? "", style: TextStyle(fontSize: 13)),
          onTap: (){
            this.initModelListState();
              model.isCheck = true;
            this.widget.onTapListener({"data": model, "index": i});
            setState((){});
          },
        ),
      );
    }
    return list;
  }

  @override
  void initState() {
    if (this.widget.initIndex != null) {
      for (int i = 0; i < this.widget.list.length; i++) {
        CheckButtonStateModel model = this.widget.list[i];
        if (this.widget.initIndex == i) {
          model.isCheck = true;
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  CheckButtonStateModel? getCurModel() {
    for (int i = 0; i < this.widget.list.length; i++) {
      CheckButtonStateModel model = this.widget.list[i];
      if (model?.isCheck == true) {
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
    if (model.isCheck == true) {
      return Container(
          width: this.widget.width,
          height: 40,
          decoration: BoxDecoration(
              color: ThemeManager.getInstance().getDefautThemeColor(),
              borderRadius: BorderRadius.all(Radius.circular(20))),
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
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ));
    } else {
      return Container(
          width: this.widget.width,
          height: 40,
          decoration: BoxDecoration(
              color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xfff5f4f9)),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: TextButton(
              style: StylesConfig.transparentTextButtonStyle,
              onPressed: () {
                this.initModelListState();
                setState(() {
                  model.isCheck = true;
                  this.widget.onTapListener({"data": model, "index": index});
                });
              },
              child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    new Text(
                      model.title ?? '',
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040), defaultDarkColor: Color(0xffc0c0c0)), fontSize: 15),
                    )
                  ])));
    }
  }

  void initModelListState() {
    this.widget.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
