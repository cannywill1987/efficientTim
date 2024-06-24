import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import '../common/database/apis/MongoApisManager.dart';
import '../common/provider/CalendarMssionEnv.dart';
import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../libs/SFCalendar/src/calendar/appointment_engine/appointment.dart';
import '../libs/SFCalendar/src/calendar/common/enums.dart';
import '../libs/SFCalendar/src/calendar/common/event_args.dart';
import '../models/FolderModel.dart';
import '../models/MissionModel.dart';
import '../util/DeviceInfoManagement.dart';
import '../util/TextUtil.dart';
import '../util/ThemeManager.dart';
import '../util/Utility.dart';
import 'CheckImage.dart';

class CustomAppointmentWidget extends StatefulWidget {
  final CalendarAppointmentDetails details;
  final CalendarView? calendarView;
  final bool shouldShowCheckBox;

  const CustomAppointmentWidget({
    Key? key,
    required this.details,
    this.calendarView,
    this.shouldShowCheckBox = true,
  }) : super(key: key);

  @override
  _CustomAppointmentWidgetState createState() =>
      _CustomAppointmentWidgetState();
}

class _CustomAppointmentWidgetState extends State<CustomAppointmentWidget> {
  Appointment? appointment;
  MissionModel? missionModel;
  MissionModel? missionModelCurSelected;
  FolderModel? folderModel;
  int priorityColor = 0;
  bool isHover = false;

  @override
  void initState() {
    super.initState();
    updateData();
  }

  void updateData() {
    appointment = widget.details.appointments.first;
    missionModelCurSelected =
        context.read<CalendarMssionEnv>().curSelectedMissionModel;
    missionModel = MongoApisManager.getInstance()
        .queryWhereEqual_missionDataByObjectId(
            objectId: appointment!.id.toString());
    priorityColor =
        CONSTANTS.getPriorityColor(missionModel?.priorityStatus ?? 3);
    if (missionModel?.folder_id != null) {
      folderModel = MongoApisManager.getInstance()
          .queryfolderModelWithFolderId(missionModel?.folder_id ?? "");
    }
  }

  @override
  void didUpdateWidget(covariant CustomAppointmentWidget oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.details != widget.details){
      updateData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if ((DeviceInfoManagement.isMoible() == true ||
        DeviceInfoManagement.isWebMobileBySize())) {
      return getWidget(context);
    } else {
      return MouseRegion(
          onEnter: (_) {
            setState(() {
              this.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              this.isHover = false;
            });
          },
          child: this.isHover == false
              ? getWidget(context)
              : Stack(
                  children: [
                    getWidget(context),
                    Positioned(
                        right: 2,
                        top: 2,
                        child: InkWell(
                          onTap: () {
                            // Utility.copyToClipboard(
                            //     missionModel?.title ?? "",
                            //     context,
                            //     "复制成功");
                            MongoApisManager.getInstance().copy_MissionModel(
                                missionModel: missionModel ?? MissionModel(),
                                );
                          },
                          child: Icon(Icons.copy,
                              size: 10, color: Color(0xff404040)),
                        )),
                  ],
                ));
    }
  }

  Container getWidget(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: folderModel?.color != null
            ? Color(folderModel!.color -
                (ThemeManager.getInstance().isDark() ? 0x10000000 : 0xa0000000))
            : Color(0xffff8800 -
                (ThemeManager.getInstance().isDark()
                    ? 0x10000000
                    : 0xa0000000)),
        borderRadius: BorderRadius.circular(4),
        border: missionModelCurSelected == missionModel
            ? Border.all(
                color: folderModel?.color != null
                    ? Color(priorityColor ?? folderModel!.color)
                    : Color(priorityColor ?? 0xffff8800),
                width: 3,
              )
            : Border(
                left: BorderSide(
                  color: folderModel?.color != null
                      ? Color(priorityColor ?? folderModel!.color)
                      : Color(priorityColor ?? 0xffff8800),
                  width: 3,
                ),
              ),
      ),
      padding: EdgeInsets.only(left: 4),
      alignment: widget.calendarView == CalendarView.month
          ? Alignment.centerLeft
          : Alignment.topLeft,
      child: Text.rich(
        maxLines: widget.calendarView == CalendarView.month ? 1 : null,
        overflow: widget.calendarView == CalendarView.month
            ? TextOverflow.ellipsis
            : null,
        TextSpan(
          children: [
            if (widget.shouldShowCheckBox)
              WidgetSpan(
                child: Container(
                  width: 15,
                  height: 15,
                  padding: widget.calendarView == CalendarView.month
                      ? null
                      : EdgeInsets.only(top: 1),
                  child: CheckImage(
                    width: 15,
                    height: 15,
                    isSizeConfigured: true,
                    onTapListener: (res) {
                      Utility.onClickFinishItem(
                        missionModel: missionModel ?? MissionModel(),
                        folderModel: folderModel ?? FolderModel(),
                        timestampCurrent:
                            widget.details.date.millisecondsSinceEpoch,
                        context: context,
                        finishCallback: () {
                          // requestDatas();
                        },
                      );
                    },
                    checked: Utility.getIsFinishOfMissionModel(
                      missionModel: missionModel ?? MissionModel(),
                      curMonthTimeStamp:
                          widget.details.date.millisecondsSinceEpoch,
                    ),
                    checkIcon: Icon(Icons.check_circle,
                        size: 15, color: ColorsConfig.calendar_green),
                    uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                        color: ColorsConfig.gray_a7, size: 15),
                  ),
                ),
              ),
            TextSpan(
              text: missionModel?.title ?? "",
              style: const TextStyle(
                color: Color(0xff404040),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: !TextUtil.isEmpty(missionModel?.localDurationString)
                  ? "(" + (missionModel?.localDurationString ?? "") + ")"
                  : (((missionModel?.start_time ?? 0) > 0) || (missionModel?.daily_start_time ?? 0) > 0) ?  "(1h 00m)" : "",
              style: TextStyle(
                color: Color(0xff404040),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            ...WidgetManager.getTagsWidgetSpan(missionModel ?? MissionModel()),
          ],
        ),
      ),
    );
  }
}
