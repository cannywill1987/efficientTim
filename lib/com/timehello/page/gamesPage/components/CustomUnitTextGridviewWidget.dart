import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/Word/VocabularyUnitBean.dart';

import '../../../../../r.dart';
import '../../../beans/GameAnswerJsonBean.dart';
import '../../../beans/GameComparePictureBean.dart';
import '../../../beans/Word/VocabularyLevelBean.dart';
import '../../../config/ENUMS.dart';
import '../../../interface/OnTapListener.dart';
import '../../../util/Utility.dart';
import '../../../util/WidgetManager.dart';
import 'SingleCharTextWidget.dart';

class CustomUnitTextGridviewWidget extends StatefulWidget {
  List<VocabularyUnitBean> datas = [];
  OnTapListener? onTapListener;
  double? itemWidth;

  CustomUnitTextGridviewWidget(
      {this.itemWidth = 50,
      required OnTapListener onTapListener,
      required List<VocabularyUnitBean> datas}) {
    this.onTapListener = onTapListener;
    this.datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomUnitTextGridviewWidgetState();
  }
}

class CustomUnitTextGridviewWidgetState extends State<CustomUnitTextGridviewWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
        spacing: 10,
      children: [...getList()],
    );
  }

  List<Widget> getList() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.datas.length; i++) {
      list.add(getItem(i));
    }
    return list;
}
  Widget getItem(int index) {
    Color color = Utility.getRandomColor();
    VocabularyUnitBean item = this.widget.datas[index];
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: GestureDetector(
            onTap: () {
              if (this.widget.onTapListener != null) {
                this.widget.onTapListener!(item);
              }
            },
            child: Container(
              height: this.widget.itemWidth ?? 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(this.widget.itemWidth ?? 100)),
                border: Border.all(width: 2, color: color),
              ),
              alignment: Alignment.center,
              // width: this.widget.itemWidth,
              // height: this.widget.itemWidth,
              child: Row(mainAxisSize: MainAxisSize.min, children: [Text(
                item.unitName.toString(),
                style: TextStyle(color: color),
              )]),
            )));
  }
}
