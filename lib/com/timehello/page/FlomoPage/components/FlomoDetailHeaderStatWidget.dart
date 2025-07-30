// 一个组件 一个白色圆角8的container容器 里面有4个item横向排列
// 每个item 有个色值404040 的text 加粗展示数字
// 下方是色值989898的子标题 纵向居中排列

import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../util/Utility.dart';
import 'FlomoWhiteBorderContainer.dart';

class FlomoDetailHeaderStatWidget extends StatelessWidget {
  FlomoMissionModel missionModel;
  DateTime curDateTime;

  FlomoDetailHeaderStatWidget({required this.missionModel, required this.curDateTime});

  @override
  Widget build(BuildContext context) {
    return FlomoWhiteBorderContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildItem(Utility.totalFlomoMissionClockDaysAlready(flomoMissionModel: missionModel, curTimeStamp: DateTime.now().millisecondsSinceEpoch).toString(), getI18NKey().join_days),
          _buildItem(Utility.totalFlomoMissionClockInFinished(clockInMap: missionModel?.clockIn ?? {}, daily_num_times: missionModel.daily_num_times).toString(), getI18NKey().completed_days),
          _buildItem(Utility
              .totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStamp(
            flomoMissionModel: missionModel,
            curTimeStamp: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch).millisecondsSinceEpoch,
          ).toString(), getI18NKey().continuous_days),
          // _buildItem('2', getI18NKey().highest_days),
        ],
      ),
    );
  }

  Widget _buildItem(String number, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number,
          style: TextStyle(
            color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF404040)),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5,),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF989898), defaultDarkColor: Color(0xFFc0c0c0)),
          ),
        ),
      ],
    );
  }

}
