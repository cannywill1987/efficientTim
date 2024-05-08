import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import 'CheckContainer.dart';

typedef OnCheckedListener = void Function(int obj);

class CustomTabBar extends StatefulWidget {
  OnCheckedListener onCheckedListener;
  int? checkIndex = 0;

  CustomTabBar({Key? key, required this.onCheckedListener, this.checkIndex = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomTabBarState(
        onCheckedListener: this.onCheckedListener, checkIndex: this.checkIndex);
  }
}

class CustomTabBarState extends State<CustomTabBar> {
  OnCheckedListener onCheckedListener;
  int? checkIndex = 0;
  List<CheckModel> list = CONSTANTS.getTomatoesTabbar();

  CustomTabBarState({required this.onCheckedListener, required this.checkIndex}) {
    setChecked(this.checkIndex ?? 0);
  }

  void setChecked(int index) {
    list.forEach((element) {
      if (element.index == index) {
        element.isChecked = true;
      } else {
        element.isChecked = false;
      }
    });
    print(list);
  }

  void updateUI() {
    setState(() {
      list = list;
    });
  }

  List<Widget> getTabBarWidgets() {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      CheckModel model = list[i];
      listWidget.add(Expanded(
          child: CheckContainer(
        // data: model,
        isNeedUpdateUI: false,
        checked: model.isChecked,
        onCheckedListener: (index, data) async {
          if (this.onCheckedListener != null) {
            this.onCheckedListener(i);
          }
          this.setChecked(i);
          this.updateUI();
        },
        checkWidget: Text(
          model.title ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.tabbarChecked)),
        ),
        uncheckWidget: Text(
          model.title ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.tabbarUnchecked)),
        ),
      )));
    }
    return listWidget;
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 55,
      child: Row(
        children: getTabBarWidgets(),
      ),
    );
    // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }
}
