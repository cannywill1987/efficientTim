import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import 'CheckContainer.dart';

typedef OnCheckedListener = void Function(dynamic obj);

class WeekendWidget extends StatefulWidget {
  OnCheckedListener onCheckedListener;
  List<CheckModel> list;
  Color? colorCheck = ColorsConfig.containerChecked;
  Color colorUncheck = ColorsConfig.containerUnchecked;

  WeekendWidget({Key? key,  Color? colorCheck, Color?  colorUncheck, required this.list, required this.onCheckedListener}): super(key: key){
    if(colorCheck == null) {
      this.colorCheck = ColorsConfig.containerChecked;
    } else {
      this.colorCheck = colorCheck;
    }
    if(colorUncheck == null) {
      this.colorUncheck = ColorsConfig.containerUnchecked;
    } else {
      this.colorCheck = colorUncheck;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WeekendWidgetState(list = this.list);
  }
}

class WeekendWidgetState extends State<WeekendWidget> {
  double margin = 3;
  List<CheckModel> list;


  WeekendWidgetState(this.list);

  @override
  void didUpdateWidget(WeekendWidget oldWidget) {
    // this.listCheckModels = oldWidget.dialogContentState.listCheckModels;
    super.didUpdateWidget(oldWidget);
  }

  resetDatas() {
    list.forEach((element) {element.isChecked = false;});
    setState(() {
      this.list = list;
    });
  }


  @override
  void initState() {
    // if (this.widget.onCheckedListener != null) {
    //   this.widget.onCheckedListener(list);
    // }
  }

  List<Widget> getListWidget() {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      CheckModel weekendCheckModel = list[i];
      listWidget.add(
        CheckContainer(
          checked: weekendCheckModel.isChecked,
          onCheckedListener: (bool isChecked, dynamic data) {
            weekendCheckModel.isChecked = isChecked;
            if (this.widget.onCheckedListener != null) {
              this.widget.onCheckedListener(list);
            }
          },
          checkWidget: Container(
              alignment: Alignment.center,
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: this.widget.colorCheck,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(200))),
              child: Text(
                weekendCheckModel.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )),
          uncheckWidget: Container(
              alignment: Alignment.center,
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: ThemeManager.getInstance().getBackgroundColor(defaultColor: this.widget.colorUncheck),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(200))),
              child: Text(
                weekendCheckModel.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: this.widget.colorCheck),
              )),
        ),
      );
      listWidget.add(
        SizedBox(
          width: this.margin,
        ),
      );
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Icon(this.widget.checkIcon, size: this.widget.width,)

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          children: getListWidget(),
        )
      ],
    );
    // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }
}
