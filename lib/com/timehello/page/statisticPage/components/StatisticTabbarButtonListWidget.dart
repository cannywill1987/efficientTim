import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

import '../../../../../r.dart';
import '../../../util/ThemeManager.dart';
import '../../../util/Utility.dart';

class StatisticTabbarButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener onTapListener;
  double? width;
  int? initIndex; //初始化默认值

  StatisticTabbarButtonListWidget(
      {this.initIndex: 0,
      required this.list,
      required this.onTapListener,
      this.width: 80}) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StatisticTabbarButtonListWidgetState(list: this.list);
  }
}

class StatisticTabbarButtonListWidgetState
    extends State<StatisticTabbarButtonListWidget> {
  String title = "";
  List<CheckButtonStateModel> list;

  StatisticTabbarButtonListWidgetState({required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: getList(list),
    );
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp
          .add(Expanded(child: getCheckButton(element, list.indexOf(element))));
    });
    return listTmp;
  }

  @override
  void initState() {
    if (this.widget.initIndex != null) {
      for (int i = 0; i < this.list.length; i++) {
        CheckButtonStateModel model = this.list[i];
        if (this.widget.initIndex == i) {
          model.isCheck = true;
          this.widget.onTapListener({"data": model, "index": i});
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    double height = 40;
    double fontSize = 15;
    if (model.isCheck == true) {
      return GestureDetector(
        onTap: () {
          // initModelListState();
          // model.isCheck = true;
          // setState(() {});
        },
        child: Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            width: double.infinity,
            height: height,
            child: Column(
              children: [
                new Text(
                  model.title ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.getInstance().getColor(defaultColor: ColorsConfig.chartTextColor)),
                ),
                Container(
                    height: 10,
                    child: Image.asset(
                      R.assetsImgIcTabbarLine,
                      width: 35,
                    ))
              ],
            )),
      );
    } else {
      return GestureDetector(
          onTap: () {
            initModelListState();
            model.isCheck = true;
            this.widget.onTapListener({"data": model, "index": index});
            setState(() {});
          },
          child: Container(
              padding: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              width: double.infinity,
              height: height,
              child: Column(
                children: [
                  new Text(
                    model.title ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff878787)),
                  ),
                  Container(
                    height: 10,
                  )
                ],
              )));
    }
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
