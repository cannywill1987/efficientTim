import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/MenuItem2.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';

import '../../../models/CheckButtonStateModel.dart';

/**
 * 设置页面左边的页面
 */
class PCLeftSettingPage extends StatelessWidget {
  List<CheckButtonStateModel> list =
      CONSTANTS.getPCSettingCheckButtonStateModelList();
  Function(String) onTapListener;

  PCLeftSettingPage({required this.onTapListener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: getList(),
        ),
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> listWidgets = [];
    for (int i = 0; i < list.length; i++) {
      listWidgets.add(getItem(list[i]));
    }
    return listWidgets;
  }

  Widget getItem(CheckButtonStateModel data) {
    return MenuItem2(
        title: data.title ?? "",
        // subTitle: "(${getI18NKey().optional})",
        onTapListener: (res) async {
          onTapListener.call(data.code ?? "");
        },
        rightPartContainer: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
        icon: data.checkIcon ?? SizedBox.shrink());
  }
}
