import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../r.dart';
import '../config/CONSTANTS.dart';
import '../models/CheckButtonStateModel.dart';
import '../models/ColorsModel.dart';
import '../util/Utility.dart';

class CustomPopupWidget extends StatelessWidget {
  Function onSelected;
  List<CheckButtonStateModel> list;
  Widget child;

  CustomPopupWidget(
      {required this.onSelected, required this.list, required this.child});

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
        // onSelected: (String val) {
        //   this.onSelected.call(getModelByKey(val).color);
        // },
        itemBuilder: (context) {
          return getPopupMenuItem();
        },
      ),
    );
  }

  CheckButtonStateModel getModelByKey(String key) {
    CheckButtonStateModel? model;
    this.list.forEach((element) {
      if (element.code == key) {
        model = element;
      }
    });
    return model!;
  }

  List<PopupMenuEntry<String>> getPopupMenuItem() {
    List<PopupMenuEntry<String>> list = [];
    this.list.forEach((CheckButtonStateModel element) {
      list.add(PopupMenuItem<String>(
        onTap: () {
          Future.delayed(Duration(milliseconds: 200), () {
            this.onSelected.call(element);
          });
        },
        key: ValueKey(element.title),
        value: element.code,
        child: Container(
          child: element.checkIcon == null
              ? getTitleText(element)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    element.checkIcon!,
                    SizedBox(
                      width: 6,
                    ),
                    if (element.content != null && element.content!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          getTitleText(element),
                          Text(
                            element.content ?? "",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xffc0c0c0)),
                          ),
                        ],
                      ),
                    if (!(element.content != null &&
                        element.content!.isNotEmpty))
                      getTitleText(element),
                    Spacer()
                  ],
                ),
        ),
      ));
    });
    return list;
  }

  Text getTitleText(CheckButtonStateModel element) {
    return Text(
      element.title ?? "",
      style: TextStyle(fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: Color(element.color ?? 0xff404040))),
    );
  }
}
