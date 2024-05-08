import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoWhiteBorderContainer.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/CustomPainterCircleProgressWidget.dart';

class FlomoDetailStatsWidget extends StatelessWidget {
  FlomoMissionModel flomoMissionModel;
  CalendarModel calendarModel;
  DateTime curDateTime;
  FlomoDetailStatsWidget({required this.calendarModel, required this.flomoMissionModel,required this.curDateTime});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Map map = Utility.getFlomoMissionModelAtMonth(dateTime: this.curDateTime, flomoMissionModel: this.flomoMissionModel);
    // String s= Utility.totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStampAndMap(curTimeStamp:curDateTime.millisecondsSinceEpoch ,clockInMap:map,daily_num_times:this.flomoMissionModel?.daily_num_times ?? 0).toString();
    int totalOfMonth = Utility.getTotalClockInFlomoMissionModel(flomoMissionModel: flomoMissionModel, calendarModel: calendarModel,startDateTime: Utility.getFilterDateTimeOfMonth(this.curDateTime), endDateTime: Utility.getFilterDateTimeOfMonth(this.curDateTime, true));
    int alreadyOfMonth = Utility.totalFlomoMissionClockInFinishedByTime(clockInMap: flomoMissionModel?.clockIn ?? {}, daily_num_times: flomoMissionModel.daily_num_times, dateTimeStart: Utility.getFilterMonthDateTimeFromTimeStamp(this.curDateTime.millisecondsSinceEpoch), dateTimeEnd: Utility.getFilterMonthDateTimeFromTimeStamp(this.curDateTime.millisecondsSinceEpoch, true));
    double percent = totalOfMonth == 0 ? 0 : alreadyOfMonth / totalOfMonth;
    return FlomoWhiteBorderContainer(child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CustomPaint(
            size: Size(60, 60),
            painter: CustomPainterCircleProgressWidget(
              progressColor: ThemeManager.getInstance().getDefautThemeColor(),
              thickness: 6,
              progress: percent,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Utility.getPercent(percent), style: TextStyle(fontSize: 16,color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040))),),
                    Text(getI18NKey().completion_rate, style: TextStyle(fontSize: 12,color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff9a9a9a))),),
                  ],
                ),
              ),)
        ],
      ),
      _buildItem(totalOfMonth.toString(), getI18NKey().this_month_plan),
      _buildItem(alreadyOfMonth.toString(), getI18NKey().already_persisted),
      _buildItem(Utility
          .totalMaxFlomoMissionClockInFinishedContinuouslyAtYmdTimeStampAndMap(
      dateTimeStart: Utility.getFilterDateTimeOfMonth(this.curDateTime), dateTimeEnd: Utility.getFilterDateTimeOfMonth(this.curDateTime, true), clockInMap: this.flomoMissionModel?.clockIn ?? {}, daily_num_times: this.flomoMissionModel.daily_num_times,
      ).toString(), getI18NKey().continously_clockin),
    ],));
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
            color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xFF989898)),
          ),
        ),
      ],
    );
  }

}