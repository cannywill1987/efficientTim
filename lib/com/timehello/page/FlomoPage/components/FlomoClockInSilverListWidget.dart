import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/CheckImage.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';

class FlomoClockInSilverListWidget extends StatelessWidget {
  List list;

  FlomoClockInSilverListWidget(this.list) {
    this.list.sort((a, b) {
      if(a['ymd'] == null || b['ymd'] == null) {
        return 0;
      }
      DateTime dateTimeA = DateTime.parse(a['ymd']);
      DateTime dateTimeB = DateTime.parse(b['ymd']);
      return dateTimeA.isAfter(dateTimeB) ? 1 : dateTimeA.isAtSameMomentAs(dateTimeB) ? 0 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // 使用listview
    // Wrap(children: [
    //   for
    // ],);
    return Wrap(
      children: List.generate(this.list.length,
          (index) => FlomoClockInSilverListWidgetItem(list[index])),
    );
    // return ListView.builder(itemCount: this.list.length, itemBuilder: (context, index) {
    //   return FlomoClockInSilverListWidgetItem(list[index]);
    // });
  }
}

class FlomoClockInSilverListWidgetItem extends StatelessWidget {
  Map data;

  FlomoClockInSilverListWidgetItem(this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: CheckImage(
                width: 20,
                height: 20,
                isSizeConfigured: true,
                onTapListener: (res) {
                  // if (this.widget.onTapFinishListener != null)
                  //   this.widget.onTapFinishListener(_missionModel);
                },
                checked: true,
                checkIcon: Icon(Icons.check_circle,
                    size: 20, color: ColorsConfig.calendar_green),
                uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                    color: ColorsConfig.gray_a7, size: 20),
              ),
            ),
            Text(
              data['ymd'] != null
                  ? Utility.parseYMDToYMDWeekend(data['ymd'])
                  : "",
              style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040), defaultDarkColor: Color(0xffa0a0a0)), fontSize: 12),
            ),
            CONSTANTS.getFlomoEmoji(sceneCode: data['sceneCode'])
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 7, top: 3, bottom: 3),
              width: 7,
              constraints: BoxConstraints(minHeight: 30),
              decoration: BoxDecoration(
                  color: Color(ThemeManager.getInstance().getDefautThemeColorInt() - 0xc0000000),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              width: 10,
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    data['message'],
                    style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
