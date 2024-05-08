import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../models/CheckButtonStateModel.dart';
import '../util/Utility.dart';
import 'CheckButtonListWidget.dart';

/**
 * 左边icon 右边文案 通过column排列
 */
class SettingListViewWidget extends StatelessWidget {
  List<CheckButtonStateModel> list = [];
  Function onTapListener;
  double right = 40;
  SettingListViewWidget({
    Key? key,
    required this.right ,
    required this.onTapListener,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //用column排列
    return Positioned(
      right: this.right,
      top: 40,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xffffffff)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.map((e) => _buildItem(e)).toList(),
            ),
          ],
        ),
      ),
    );
    //   return Container(
    //     child: ListTile(
    //       leading: Icon(icon),
    //       title: Text(title),
    //       subtitle: Text(subTitle),
    //       trailing: Icon(Icons.keyboard_arrow_right),
    //       onTap: () {
    //         Navigator.pushNamed(context, routeName);
    //       },
    //     ),
    //   );
  }

  Widget _buildItem(CheckButtonStateModel model) {
    return InkWell(
      onTap: () {
        this.onTapListener.call(model);
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (model.checkIconUrl != null)
              Utility.getSVGPicture(
                model.checkIconUrl ?? "",
                size: 16,
                // color: Colors.white,
              ),
            if (model.checkIcon != null) model.checkIcon!,
            SizedBox(width: 5,),
            Text(
              model.title ?? "",
              style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
