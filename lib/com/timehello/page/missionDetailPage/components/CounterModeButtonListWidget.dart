import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class CounterModeButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  int? initIndex;

  CounterModeButtonListWidget(
      {this.initIndex: 0, required this.list, required this.onTapListener}) {}

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
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xff121820).withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
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
          setState(() {});
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

  CounterModeButtonListWidgetItem(
      {required this.isChecked, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Color themeColor = ThemeManager.getInstance().getDefautThemeColor();
    if (this.isChecked == true) {
      return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minWidth: 112),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor + 8, vertical: paddingVer + 5),
          decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.15),
              border: Border.all(color: themeColor, width: 1),
              borderRadius: BorderRadius.circular(999)),
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ));
    } else {
      return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minWidth: 112),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor + 8, vertical: paddingVer + 5),
          child: Text(
            this.text,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ));
    }
  }
}
