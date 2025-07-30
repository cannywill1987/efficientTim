import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../r.dart';
import '../config/CONSTANTS.dart';
import '../models/ColorsModel.dart';
import '../util/Utility.dart';

/**
 * 做笔记时用到的颜色组件
 */
class ColorsWidget extends StatelessWidget {
  Function onColorSelected;
  Widget child;
  ColorsWidget({required this.onColorSelected, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getPopupMenu();
  }

  Container getPopupMenu() {
    return Container(
      key: ValueKey('Container5'),
      margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
      child: PopupMenuButton<String>(
        key: ValueKey('PopupMenuButton5'),
        tooltip: '',
        padding: EdgeInsets.all(0.0),
        child: this.child,
        onSelected: (String val) {
          this.onColorSelected.call(getColorModelByKey(val).color);
        },
        itemBuilder: (context) {
          return getPopupMenuItem();
        },
      ),
    );
  }

  ColorsModel getColorModelByKey(String key) {
    ColorsModel? colorsModel;
    CONSTANTS.getColors().forEach((element) {
      if (element.title == key) {
        colorsModel = element;
      }
    });
    return colorsModel!;
  }

  List<PopupMenuEntry<String>> getPopupMenuItem() {
    List<PopupMenuEntry<String>> list = [];
    CONSTANTS.getColors().forEach((ColorsModel element) {
      list.add(PopupMenuItem<String>(
        onTap: () {
          this.onColorSelected.call(element.color);
        },
        key: ValueKey(element.title),
        value: element.title,
        child: Container(height: 20, color: Color(element.color),),
      ));
    });
    return list;
  }

}