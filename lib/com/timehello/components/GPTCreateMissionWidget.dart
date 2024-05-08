import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../models/MissionModel.dart';

class GPTCreateMissionWidget extends StatelessWidget {
  final List<MissionModel> list;
  final ScrollController _scrollController = ScrollController();

  GPTCreateMissionWidget({required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scrollbar(
      controller: _scrollController,
      trackVisibility: true,
      child: ListView.builder(
        itemCount: this.list.length,
        cacheExtent: 30,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return GPTCreateMissionWidgetListViewItem(
              missionModel: this.list[index]);
        },
      ),
    );
  }
}

class GPTCreateMissionWidgetListViewItem extends StatelessWidget {
  MissionModel missionModel;

  GPTCreateMissionWidgetListViewItem({required this.missionModel});

  double marginTop = 10;
  double marginRight = 4;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          children: [
            Text(
              this.missionModel.title ?? "",
              textAlign: TextAlign.left,
              style: TextStyle(
                  // color: Color(0xff404040),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          height: marginTop,
        ),
        Row(children: [
          Text(
            this.missionModel.time_mode == 1 ? getI18NKey().time_segment : getI18NKey().date,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(
            width: marginRight,
          ),
          Text(
            this.missionModel.time_mode == 1 ? CONSTANTS.getSegmentDateStringSubtitle(this.missionModel ?? MissionModel()) : Utility.getDateTimeYMD(Utility.getDateTimeFromTimeStamp(
                this.missionModel.end_time ?? 0)),
            style: TextStyle( fontSize: 12),
          ),
          SizedBox(
            width: 10,
          ),
        ]),
        SizedBox(
          height: marginTop,
        ),
        Row(
          children: [
            TextUtil.isEmpty(this.missionModel.daily_start_time) ? SizedBox.shrink() : Text(
              getI18NKey().start_time,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            TextUtil.isEmpty(this.missionModel.daily_start_time) ? SizedBox.shrink() : SizedBox(
              width: marginRight,
            ),
            TextUtil.isEmpty(this.missionModel.daily_start_time) ? SizedBox.shrink() : Text(
              Utility.formatHourAndMin2(
                      this.missionModel.daily_start_time ?? 0) ??
                  "",
              style: TextStyle(color: Color(0xff404040), fontSize: 12),
            ),
            SizedBox(
              width: 10,
            ),
            TextUtil.isEmpty(this.missionModel.daily_end_time) ? SizedBox.shrink() : Text(
              getI18NKey().end_time,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            TextUtil.isEmpty(this.missionModel.daily_end_time) ? SizedBox.shrink() : SizedBox(
              width: marginRight,
            ),
            TextUtil.isEmpty(this.missionModel.daily_end_time) ? SizedBox.shrink() : Text(
              Utility.formatHourAndMin2(
                      this.missionModel.daily_end_time ?? 0) ??
                  "",
              style: TextStyle(color: Color(0xff404040), fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: marginTop,
        ),
        TextUtil.isEmpty(this.missionModel.message)
            ? SizedBox.shrink()
            : Row(
                children: [
                  Text(
                    getI18NKey().content,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(
                    width: marginRight,
                  ),
                  Text(
                    this.missionModel.message ?? "",
                    style: TextStyle(color: Color(0xff404040), fontSize: 12),
                  )
                ],
              ),
        SizedBox(
          height: 2 * marginTop,
        ),
      ],
    );
  }
}
