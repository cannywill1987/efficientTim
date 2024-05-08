import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

class CounterModeButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  int? initIndex;

  CounterModeButtonListWidget(
      {this.initIndex: 0, required this.list, required this.onTapListener}) {
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CounterModeButtonListWidgetState(list: list);
  }
}

class CounterModeButtonListWidgetState
    extends State<CounterModeButtonListWidget> {
  List<CheckButtonStateModel> list;

  CounterModeButtonListWidgetState({required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(1),
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

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    return GestureDetector(
        onTap: () {
          initModelListState();
          model.isCheck = true;
          this.widget.onTapListener(index);
          setState(() {

          });
        },
        child: CounterModeButtonListWidgetItem(
          text: model.title ?? "",
          isChecked: model.isCheck,
        ));
    // if (model.isCheck == true) {
    // } else {
    //   return CounterModeButtonListWidgetItem(text: model.title, isChecked: model.isCheck,);
    // }
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}

class CounterModeButtonListWidgetItem extends StatelessWidget {
  bool isChecked = false;
  String text;
  double paddingHor = 10;
  double paddingVer = 3;

  CounterModeButtonListWidgetItem({required this.isChecked, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.isChecked == true) {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor, vertical: paddingVer),
          decoration: BoxDecoration(
              color: ColorsConfig.chartTextColor,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor, vertical: paddingVer),
          child: Text(
            this.text,
            style: TextStyle(color: Color(0xf0ffffff), fontSize: 12),
          ));
    }
  }
}
