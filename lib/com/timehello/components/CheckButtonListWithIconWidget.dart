import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../util/Utility.dart';

class CheckButtonListWithIconWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  String unit = getI18NKey().min_en;
  int? initIndex;
  Color backgroundColor = ColorsConfig.chartTextColor;

  CheckButtonListWithIconWidget(
      {Key? key, Color? backgroundColor , this.initIndex: 0, required this.list, required this.onTapListener, unit}): super(key: key) {
    if(backgroundColor == null) {
      this.backgroundColor = ThemeManager.getInstance().getCardBackgroundColor(defaultColor: ThemeManager.getInstance().getDefautThemeColor());
    } else {
      this.backgroundColor = backgroundColor;
    }
    this.unit = unit ?? getI18NKey().min_en;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CheckButtonListWithIconWidgetState(list: list);
  }
}

class CheckButtonListWithIconWidgetState
    extends State<CheckButtonListWithIconWidget> {
  List<CheckButtonStateModel> list;


  CheckButtonListWithIconWidgetState({required this.list});


  @override
  void didUpdateWidget(CheckButtonListWithIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if(oldWidget.list != this.widget.list) {
    //   this.list = this.widget.list;
    // }
  }

  updateList(List<CheckButtonStateModel> list) {
    this.list = list;
    setState(){};
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
            border: Border.all(color: this.widget.backgroundColor, width: 1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: getList(this.list)));
  }

  @override
  void initState() {
    if (this.widget.initIndex != null) {
      for (int i = 0; i < this.list.length; i++) {
        CheckButtonStateModel model = this.list[i];
        if (this.widget.initIndex == i) {
          model.isCheck = true;
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  void setCurIndex(int index) {
    initModelListState();
    try {
      list[index].isCheck = true;
    } catch (e) {
      list[list.length - 1].isCheck = true;
      print(e);
    }
    if(mounted)
    setState(() {

    });
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    return GestureDetector(
        onTap: () {
          initModelListState();
          model.isCheck = true;
          this.widget.onTapListener(index);
          if(mounted)
          setState(() {

          });
        },
        child: CheckButtonListWithIconWidgetItem(
          backgroundColor: this.widget.backgroundColor,
          icon: model.isCheck ? model.checkIcon : model.uncheckIcon,
          text: model.title ?? "",
          isChecked: model.isCheck ?? false,
        ));
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}

class CheckButtonListWithIconWidgetItem extends StatelessWidget {
  bool isChecked = false;
  String text;
  Widget? icon;
  double paddingHor = 10;
  double paddingVer = 3;
  Color backgroundColor;
  CheckButtonListWithIconWidgetItem({ this.icon, required this.backgroundColor, required this.isChecked, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.isChecked == true) {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor, vertical: paddingVer),
          decoration: BoxDecoration(
              color: this.backgroundColor,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              this.icon ?? SizedBox.shrink(),
              SizedBox(width: 4,),
              Text(
                this.text,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor, vertical: paddingVer),
          child: Row(
            children: [
              this.icon ?? SizedBox.shrink(),
              SizedBox(width: 4,),
              Text(
                this.text,
                style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: this.backgroundColor), fontSize: 12),
              ),
            ],
          ));
    }
  }
}
