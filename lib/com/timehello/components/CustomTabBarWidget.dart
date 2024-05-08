import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../models/CheckButtonStateModel.dart';
import 'CheckContainer.dart';

typedef OnCheckedListener = void Function(int obj);

class CustomTabBarWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnCheckedListener onCheckedListener;
  int? checkIndex = 0;
  double fontSize = 18;

  CustomTabBarWidget(
      {Key? key,
        required this.fontSize,
      required this.list,
      required this.onCheckedListener,
      this.checkIndex = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomTabBarWidgetState(
        list: this.list,
        onCheckedListener: this.onCheckedListener, checkIndex: this.checkIndex);
  }
}

class CustomTabBarWidgetState extends State<CustomTabBarWidget> {
  OnCheckedListener onCheckedListener;
  int? checkIndex = 0;
  List<CheckButtonStateModel> list;
  // List<CheckModel> list = CONSTANTS.getTomatoesTabbar();

  CustomTabBarWidgetState(
      {required this.list, required this.onCheckedListener, required this.checkIndex}) {
    // setChecked(this.checkIndex ?? 0);
  }

  resetList() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }

  void setChecked(int index) {
    this.resetList();
    this.list[index].isCheck = true;
    setState(() {

    });
    // this.widget.list.forEach((element) {
    //   if (element.index == index) {
    //     element.isChecked = true;
    //   } else {
    //     element.isChecked = false;
    //   }
    // });
    // print(list);
  }

  void updateUI() {
    setState(() {
      // list = list;
    });
  }

  List<Widget> getTabBarWidgets() {
    List<Widget> listWidget = [];
    for (int i = 0; i < this.list.length; i++) {
      CheckButtonStateModel model = this.list[i];
      listWidget.add(Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: CheckContainer(
          // data: model,
          isNeedUpdateUI: false,
          checked: model.isCheck,
          onCheckedListener: (index, data) async {
            if (this.onCheckedListener != null) {
              this.onCheckedListener(i);
            }
            this.setChecked(i);
            this.updateUI();
          },
          checkWidget: Column(
            children: [
              Text(
                model.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize:this.widget.fontSize, color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.tabbarChecked)),
              ),
              Container(width: 20, height: 2, margin: EdgeInsets.only(top: 4),decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: ThemeManager.getInstance().getColor(defaultColor: Color(0xffff8800))),)
            ],
          ),
          uncheckWidget: Column(
            children: [
              Text(
                model.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: this.widget.fontSize - 2, color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.tabbarUnchecked, defaultDarkColor: Color(0xff999999))),
              ),
              Container(width: 20, height: 4, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: ThemeManager.getInstance().isDark() ? null: Colors.white),)
            ],
          ),
        ),
      ));
    }
    return listWidget;
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
      child: Row(
        children: getTabBarWidgets(),
      ),
    );
    // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,);
  }
}
