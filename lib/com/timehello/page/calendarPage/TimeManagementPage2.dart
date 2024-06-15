///Dart imports

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'package:provider/provider.dart';

///calendar import
import 'package:time_hello/com/timehello/common/provider/CalendarMssionEnv.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/TimeRatioComponent.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/appointment_engine/appointment.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/appointment_engine/calendar_datasource.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/common/calendar_controller.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/common/enums.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/common/event_args.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/resource_view/calendar_resource.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/settings/month_view_settings.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/settings/schedule_view_settings.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/settings/time_slot_view_settings.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/settings/view_header_style.dart';
import 'package:time_hello/com/timehello/libs/SFCalendar/src/calendar/sfcalendar.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/SharePreferenceModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';
import 'package:time_hello/com/timehello/util/WidgetManager2.dart';

import '../../../../r.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CircleWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../components/ListingFilterWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../models/FolderModel.dart';
import '../../models/MissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/TextUtil.dart';
import '../../util/Utility.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../SettingItemDetailPage/SettingItemDetailPage.dart';

///Local import

/// Widget of getting started calendar
class TimeManagementPage extends StatefulWidget {
  /// Creates default getting started calendar
  Function? onRefresh;
  FolderModel? folderModel;
  PageEnum? pageEnum;

  TimeManagementPage(
      {Key? key,
      this.pageEnum = PageEnum.Normal,
      this.folderModel,
      Function? onRefresh})
      : super(key: key);

  @override
  TimeManagementPageState createState() => TimeManagementPageState();
}

class TimeManagementPageState extends State<TimeManagementPage> {
  TimeManagementPageState();

  double missionPageWidth = 300;
  FolderModel? folderModelSearch;
  List<MissionModel> listMissionModels = [];
  _DataSource _events = _DataSource(<Appointment>[]);
  late CalendarView _currentView;
  DateTime? startDateTime;
  DateTime? endDateTime;

  //时间轴展示的
  final List<CalendarView> _allowedViewsList = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    // CalendarView.workWeek,
    CalendarView.schedule,
    CalendarView.month,
    // CalendarView.timelineDay,
    CalendarView.timelineWeek,
    // CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth,
  ];

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _currentView = CalendarView.week;
    if (widget.folderModel != null) {
      folderModelSearch = widget.folderModel;
    }
    int currentView = SharePreferenceUtil.getSyncInstance().getInt(
        key: "timeManagementDefautKey", defaultVal: CalendarView.week.index);
    if (currentView != null) {
      _currentView = CalendarView.values[currentView];
    }
    _calendarController.view = _currentView;

    super.initState();
  }

  selectDate(DateTime dateTime) {
    _calendarController.displayDate = dateTime;
    _calendarController.selectedDate = dateTime;
    CalendarModel calendarModel = context.read<GlobalStateEnv>().calendarModel;
    List<DayModel> dayModelList = Utility.filterDaysModels(
        calendarModel?.dayModelList ?? [], folderModelSearch);
  }

  @override
  Widget build(BuildContext context) {
    // CalendarModel calendarModel = context.watch<GlobalStateEnv>().calendarModel;
    // List<DayModel> dayModelList = Utility.filterDaysModels(
    //     calendarModel?.dayModelList ?? [], folderModelSearch);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      this.missionPageWidth = constraints.maxWidth;
      return Selector<CalendarMssionEnv, MissionModel?>(
          selector: (_, env) => env.curSelectedMissionModel,
          builder: (_, curSelectedMissionModel, __) {
            return Selector<CalendarMssionEnv, FolderModel?>(
                selector: (_, env) => env.curSelectedFolderModel,
                builder: (_, curSelectedFolderModel, __) {
                  return Selector<CalendarMssionEnv, DateTime?>(
                      selector: (_, env) => env.startDateTime,
                      builder: (_, startDateTime, __) {
                        return Selector<CalendarMssionEnv, DateTime?>(
                            selector: (_, env) => env.endDateTime,
                            builder: (_, endDateTime, __) {
                              this.startDateTime = startDateTime;
                              this.endDateTime = endDateTime;
                              return Selector<GlobalStateEnv, CalendarModel?>(
                                  selector: (_, env) => env.calendarModel,
                                  builder: (_, calendarModel, __) {
                                    List<DayModel> dayModelList =
                                        Utility.filterDaysModels(
                                            calendarModel?.dayModelList ?? [],
                                            folderModelSearch);
                                    _events = _DataSource(
                                        getAppointmentDetails(dayModelList));
                                    final Widget calendar =
                                        _getDragAndDropCalendar(
                                            _calendarController,
                                            _events,
                                            _onViewChanged,
                                            WidgetManager2
                                                .getAppointmentUIWidget(
                                                    _calendarController));
                                    final double screenHeight =
                                        MediaQuery.of(context).size.height;

                                    return Scaffold(
                                        body: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        if (widget.folderModel == null)
                                          CustomMarquee(
                                            bean:
                                                MarqueInfo.marqueTimemanagement,
                                            paddingTop: 0,
                                          ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TimeRatioComponent(
                                          width: this.missionPageWidth,
                                          startTime: startDateTime,
                                          endTime: endDateTime,
                                          height: 5,
                                          // totalTime: 24 * 60 * 60, // 一天的总秒数
                                          listMissionModels:
                                              listMissionModels ?? [],
                                          // [
                                          //   TimeSegment(label: 'Segment 1', value: 1* 60 * 60, color: Colors.red, totalValue: 2 * 60 * 60, onTap: () => print("Segment 1 clicked")),
                                          //   TimeSegment(label: 'Segment 2', value: 1* 60 * 60, color: Colors.orange, totalValue: 3 * 60 * 60, onTap: () => print("Segment 2 clicked")),
                                          //   TimeSegment(label: 'Segment 3', value: 1* 60 * 60, color: Colors.yellow, totalValue: 5 * 60 * 60, onTap: () => print("Segment 3 clicked")),
                                          //   TimeSegment(label: 'Segment 4', value: 1* 60 * 60, color: Colors.green, totalValue: 4 * 60 * 60, onTap: () => print("Segment 4 clicked")),
                                          //   TimeSegment(label: 'Segment 5', value: 1* 60 * 60, color: Colors.blue, totalValue: 10 * 60 * 60, onTap: () => print("Segment 5 clicked")),
                                          // ],
                                        ),
                                        if (widget.folderModel == null)
                                          ListingFilterWidget(
                                              onTapListener: (data) {
                                            this.folderModelSearch = data;
                                            context
                                                .read<CalendarMssionEnv>()
                                                .curSelectedFolderModel = data;
                                            // context.read<CalendarMssionEnv().curSelectedFolderModel = data;
                                            setState(() {});
                                            // this.curSearchingFocusModel = data;
                                            // this.requestDatas();
                                          }),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Row(children: <Widget>[
                                                Expanded(
                                                  child: _calendarController
                                                                  .view ==
                                                              CalendarView
                                                                  .month &&
                                                          screenHeight < 800
                                                      ? Scrollbar(
                                                          thumbVisibility: true,
                                                          controller:
                                                              _controller,
                                                          child: ListView(
                                                            controller:
                                                                _controller,
                                                            children: <Widget>[
                                                              Container(
                                                                color: ThemeManager
                                                                        .getInstance()
                                                                    .getBackgroundColor(
                                                                        defaultColor:
                                                                            Colors.white),
                                                                height: 600,
                                                                child: calendar,
                                                              )
                                                            ],
                                                          ))
                                                      : Container(
                                                          color: ThemeManager
                                                                  .getInstance()
                                                              .getBackgroundColor(
                                                                  defaultColor:
                                                                      Colors
                                                                          .white),
                                                          child: calendar),
                                                )
                                              ]),
                                              Positioned(
                                                  bottom: 30,
                                                  right: 20,
                                                  child: CircleWidget(
                                                    onTapListener: (obj) {
                                                      MissionModel
                                                          missionModel =
                                                          MissionModel();
                                                      missionModel.end_time =
                                                          CONSTANTS
                                                              .getDeadLineTme(
                                                                  (0) + 1);
                                                      missionModel.folder_id =
                                                          this
                                                              .folderModelSearch
                                                              ?.objectId;
                                                      if (Utility
                                                              .isHandsetBySize() ==
                                                          true) {
                                                        Utility.pushNavigator(
                                                            context,
                                                            CreateMissionPage(
                                                                missionModel:
                                                                    missionModel));
                                                      } else {
                                                        DialogManagement
                                                                .getInstance()
                                                            .showPCCustomDialog(
                                                                context:
                                                                    context,
                                                                widget: CreateMissionPage(
                                                                    missionModel:
                                                                        missionModel));
                                                      }
                                                    },
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ));
                                  });
                            });
                      });
                });
          });
    });
  }

  /// Update the current view when the view changed and update the scroll view
  /// when the view changes from or to month view because month view placed
  /// on scroll view.
  void _onViewChanged(ViewChangedDetails viewChangedDetails) {
    if (_currentView != CalendarView.month &&
        _calendarController.view != CalendarView.month) {
      _currentView = _calendarController.view!;
      SharePreferenceUtil.getSyncInstance()
          .setInt(key: "timeManagementDefautKey", value: _currentView.index);
      return;
    }

    _currentView = _calendarController.view!;
    SharePreferenceUtil.getSyncInstance()
        .setInt(key: "timeManagementDefautKey", value: _currentView.index);
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        // Update the scroll view when view changes.
      });
    });
  }

  /// Creates the required appointment details as a list.
  /// Creates the required appointment details as a list.
  List<Appointment> getAppointmentDetails(List<DayModel> list) {
    final List<Appointment> appointments = <Appointment>[];
    List<MissionModel> listMissionModelsAddedForTimemodeSegment = [];
    listMissionModels = [];
    for (int i = 0; i < list.length; i++) {
      DayModel dayModel = list[i];
      dayModel.missionModelList.forEach((MissionModel _missionModel) {
        if (endDateTime == null && startDateTime != null) {
          endDateTime =
              Utility.getFilterDateTimeFromDateTime(startDateTime!, true);
        }
        if (startDateTime != null && endDateTime != null) {
          DateTime? curDateTime = dayModel.dateTime;
          if (curDateTime != null) {
            if ((curDateTime.isAfter(startDateTime!) ||
                    curDateTime.isAtSameMomentAs(startDateTime!)) &&
                (curDateTime.isBefore(endDateTime!) ||
                    curDateTime.isAtSameMomentAs(endDateTime!))) {
              listMissionModels.add(_missionModel);
            }
          }
        }
        if (startDateTime == null && endDateTime == null) {
          listMissionModels.add(_missionModel);
        }
        FolderModel? folderModelWithMission;
        if (!TextUtil.isEmpty(_missionModel.folder_id)) {
          List<FolderModel> folderModelList = MongoApisManager.getInstance()!
              .queryWhereEqual_folderModelWithFolderId(_missionModel.folder_id);
          for (int i = 0; i < folderModelList.length; i++) {
            FolderModel item = folderModelList[i];
            if (item.tag == 2) {
              //
              folderModelWithMission = item;
            }
            if (item.tag == 1) {
              folderModelWithMission = item;
            }
            if (item.tag == 0) {
              folderModelWithMission = item;
            }
          }
        }
        if(_missionModel.title == "支持排序") {
          print("支持排序");
        }
        late DateTime dateTimeStart;
        late DateTime? dateTimeEnd;
        if (_missionModel.time_mode == null || _missionModel.time_mode == 0) {
          if (_missionModel?.daily_start_time == null &&
              _missionModel?.daily_end_time == null &&
              _missionModel.repetiveType == 0) {
            if (_missionModel?.end_time != null) {
              //没有重复
              dateTimeStart = Utility.getDateTimeFromTimeStamp(
                  (_missionModel?.start_time == null &&
                          _missionModel?.end_time != null)
                      ? (_missionModel!.end_time! - 60 * 60 * 1000)
                      : _missionModel.start_time ?? 0);
            }
          } else {
            //有重复
            dateTimeStart = Utility.getDateTimeFromTimeStamp(DateTime(
                        dayModel.dateTime?.year ?? 0,
                        dayModel.dateTime?.month ?? 0,
                        dayModel?.day ?? 0,
                        dayModel.dateTime?.hour ?? 0)
                    .millisecondsSinceEpoch +
                (_missionModel?.daily_start_time ?? 0));
          }

          if (_missionModel?.daily_end_time != null) {
            dateTimeEnd = Utility.getDateTimeFromTimeStamp(DateTime(
                        dayModel.dateTime?.year ?? 0,
                        dayModel.dateTime?.month ?? 0,
                        dayModel?.day ?? 0,
                        dayModel.dateTime?.hour ?? 0)
                    .millisecondsSinceEpoch +
                (_missionModel?.daily_end_time ?? 0));
          } else {
            dateTimeEnd = dateTimeStart.add(Duration(hours: 1));
          }
        } else {
          //时间段模式
          // if (_missionModel?.start_time != null) {
          dateTimeStart = Utility.getDateTimeFromTimeStamp(
              (_missionModel?.start_time == null &&
                      _missionModel?.end_time != null)
                  ? (_missionModel!.end_time! - 60 * 60 * 1000)
                  : _missionModel.start_time ?? 0);
          // }
          // if (_missionModel?.end_time != null) {
          dateTimeEnd =
              Utility.getDateTimeFromTimeStamp(_missionModel?.end_time ?? 0);
          // }
        }

        if (listMissionModelsAddedForTimemodeSegment.contains(_missionModel) ==
            false) {
          // final DateTime startDate =
          // DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
          appointments.add(Appointment(
            id: _missionModel.objectId,
            subject: _missionModel.title ?? "",
            startTime: dateTimeStart,
            endTime: dateTimeEnd,
            color: Color(folderModelWithMission?.color ?? 0xffff8800),
          ));
          //时间段不能重复添加
          if (_missionModel.time_mode == 1) {
            listMissionModelsAddedForTimemodeSegment.add(_missionModel);
          }
        }
      });
    }
    return appointments;
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSettingItem':
        this.onClickMissionSetting(data['missionModel']);
        break;
    }
  }

  /**
   * 跳转到设置叶敏
   */
  void onClickMissionSetting(data) {
    Utility.popupDesktopRightNavigator(context);
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new SettingItemDetailPage(
            key: ValueKey("ejzifjfzezef"),
            missionModel: data,
          ), callback: (val) {
        // requestDatas();
      });
    } else {
      Utility.openRightSideDesktopNavigator(
          context, 'SettingItemDetailPage', {'missionModel': data});
    }
  }

  /// Returns the calendar widget based on the properties passed.
  Widget _getDragAndDropCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      ViewChangedCallback? viewChangedCallback,
      CalendarAppointmentBuilder? appointmentBuilder]) {
    return Localizations(
      locale: const Locale('zh', 'CN'),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // SfGlobalLocalizations.delegate

        // SfGlobalLocalizations.delegate
      ],
      child: SfCalendar(
        controller: calendarController,
        dataSource: calendarDataSource,
        allowedViews: _allowedViewsList,
        showNavigationArrow: false,
        onViewChanged: viewChangedCallback,
        allowDragAndDrop: true,
        showDatePickerButton: true,
        allowAppointmentResize: true,
        appointmentBuilder: appointmentBuilder,
          // monthCellBuilder: (BuildContext context, MonthCellDetails details) {
          //   return Container(
          //     color: ThemeManager.getInstance()
          //         .getBackgroundColor(defaultColor: Colors.white),
          //     child: Column(
          //       children: [
          //         Container(
          //           height: 10,
          //           color: Colors.red,
          //         ),
          //         Text(details.date.day.toString()),
          //       ],
          //     ),
          //   );
          // },
        // resourceViewHeaderBuilder:
        //     (BuildContext context, ResourceViewHeaderDetails details) {
        //   return Container(
        //     color: ThemeManager.getInstance()
        //         .getBackgroundColor(defaultColor: Colors.white),
        //     child: Row(
        //       children: [
        //         Container(
        //           width: 10,
        //           height: 10,
        //           color: details.resource.color,
        //         ),
        //         SizedBox(width: 4),
        //         Text(
        //           details.resource.displayName ?? "",
        //           style: TextStyle(color: details.resource.color),
        //         ),
        //       ],
        //     ),
        //   );
        // },
        // blackoutDatesTextStyle: TextStyle(color: Colors.red),
        // cellBorderColor: Colors.red, //边框颜色
        // headerStyle: CalendarHeaderStyle(textStyle: TextStyle(color: Colors.red)), // 选择模式的背景色背景色
        // blackoutDatesTextStyle: TextStyle(color: Colors.green),
        // viewHeaderStyle: ViewHeaderStyle(dateTextStyle: TextStyle(color: Colors.red), dayTextStyle:  TextStyle(color: Colors.red)),
        // weekNumberStyle: WeekNumberStyle(backgroundColor: Colors.red),
        onLongPress: (CalendarLongPressDetails details) {
          // 长按创建任务
          if ((details.appointments?.length ?? 0) > 0) {
            return;
          }
          DateTime date = details.date!;
          dynamic appointments = details.appointments;
          CalendarElement view = details.targetElement;
          MissionModel missionModel = MissionModel();
          missionModel.folder_id = this.folderModelSearch?.objectId;
          missionModel.time_mode = 1;
          missionModel.end_time = date.millisecondsSinceEpoch;
          missionModel.start_time = date.millisecondsSinceEpoch;
          missionModel.end_time =
              date.add(Duration(hours: 1)).millisecondsSinceEpoch;
          if (Utility.isHandsetBySize() == true) {
            Utility.pushNavigator(
                context,
                CreateMissionPage(
                    missionModel: missionModel, onRefresh: () {}));
          } else {
            DialogManagement.getInstance().showPCCustomDialog(
                context: context,
                widget: CreateMissionPage(
                    missionModel: missionModel, onRefresh: () {}));
          }
        },
        onSelectionChanged:
            (CalendarSelectionDetails calendarSelectionDetails) {
          // print(11111111);
        },
        onTap: (CalendarTapDetails details) async {
          // calendarTapDetails.appointments
          List<dynamic>? appointments = details.appointments;
          dynamic appointmentDynamic = appointments?[0];
          if (appointmentDynamic != null) {
            Appointment appointment = appointmentDynamic as Appointment;
            if (appointment != null) {
              MissionModel? missionModel = await MongoApisManager.getInstance()
                  .queryWhereEqual_missionDataByObjectId(
                      objectId: appointment.id.toString());

              this.onClick(
                  'onClickSettingItem', {'missionModel': missionModel});
            }
          } else {
            Utility.popupDesktopRightNavigator(context);
          }
        },
        onAppointmentResizeEnd: (AppointmentResizeEndDetails details) async {
          // 改变尺寸
          Appointment appointment = details.appointment as Appointment;
          MissionModel? missionModel = await MongoApisManager.getInstance()
              .queryWhereEqual_missionDataByObjectId(
                  objectId: appointment.id.toString());
          CalendarResource? resource = details.resource;
          DateTime startDateTime = details.startTime!;
          DateTime endDateTime = details.endTime!;
          //日期
          if (missionModel?.time_mode == 0 || missionModel?.time_mode == null) {
            missionModel?.daily_end_time =
                (endDateTime?.hour ?? 0) * 60 * 60 * 1000 +
                    (endDateTime?.minute ?? 0) * 60 * 1000 +
                    (endDateTime?.second ?? 0) * 1000;
            missionModel?.daily_start_time =
                (startDateTime?.hour ?? 0) * 60 * 60 * 1000 +
                    (startDateTime?.minute ?? 0) * 60 * 1000 +
                    (startDateTime?.second ?? 0) * 1000;
          } else {
            //时间段
            missionModel?.start_time = startDateTime.millisecondsSinceEpoch;
            missionModel?.end_time = endDateTime.millisecondsSinceEpoch;
          }
          if (ChatGroupManager.isFolderModelEnabled(
                  folderId: missionModel?.folder_id) ==
              false) {
            Utility.showToastMsg(
                context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
            return;
          }
          if (missionModel != null) {
            await MongoApisManager.getInstance().update_MissionModel(
                missionModel: missionModel, shouldQueryMissionModel: false);
          }
          if (this.widget.onRefresh != null) {
            this.widget.onRefresh!();
          }
        },
        onDragEnd: (AppointmentDragEndDetails details) async {
          Appointment appointment = details.appointment as Appointment;
          MissionModel? missionModel = await MongoApisManager.getInstance()
              .queryWhereEqual_missionDataByObjectId(
                  objectId: appointment.id.toString());
          CalendarResource? sourceResource = details.sourceResource;
          CalendarResource? targetResource = details.targetResource;
          DateTime? draggingTime = details.droppingTime;
          if (missionModel?.time_mode == 0 || missionModel?.time_mode == null) {
            missionModel?.daily_end_time =
                (appointment.endTime?.hour ?? 0) * 60 * 60 * 1000 +
                    (appointment.endTime?.minute ?? 0) * 60 * 1000 +
                    (appointment.endTime?.second ?? 0) * 1000;
            missionModel?.daily_start_time =
                (appointment.startTime?.hour ?? 0) * 60 * 60 * 1000 +
                    (appointment.startTime?.minute ?? 0) * 60 * 1000 +
                    (appointment.startTime?.second ?? 0) * 1000;
            missionModel?.folder_id = this.folderModelSearch?.objectId;
            if (missionModel?.repetiveType == 0) {
              missionModel?.end_time =
                  (draggingTime?.millisecondsSinceEpoch ?? 0);
            }
          } else {
            //时间段
            missionModel?.start_time =
                appointment.startTime?.millisecondsSinceEpoch;
            missionModel?.end_time =
                appointment.endTime?.millisecondsSinceEpoch;
          }
          if (ChatGroupManager.isFolderModelEnabled(
                  folderId: missionModel?.folder_id) ==
              false) {
            Utility.showToastMsg(
                context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
            return;
          }
          if (missionModel != null) {
            await MongoApisManager.getInstance().update_MissionModel(
                missionModel: missionModel, shouldQueryMissionModel: false);
          }
          if (this.widget.onRefresh != null) {
            this.widget.onRefresh!();
          }
        },

        viewHeaderStyle: ViewHeaderStyle(
            // backgroundColor: Colors.blue,
            dayTextStyle: TextStyle(color: Colors.grey, fontSize: 12),
            dateTextStyle: TextStyle(color: Colors.grey, fontSize: 14)),
        // scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        //   appointmentTextStyle: TextStyle( //任务的文字的样式
        //       color: Colors.yellow,
        //       fontSize: -1,
        //       fontWeight: FontWeight.w500,
        //       fontFamily: 'Roboto'),
        // weekNumberStyle: WeekNumberStyle(backgroundColor: Colors.yellow, textStyle: TextStyle(fontSize: 8)),
        scheduleViewSettings: ScheduleViewSettings(
            monthHeaderSettings: MonthHeaderSettings(
                height: 50, monthTextStyle: TextStyle(fontSize: 50))),
        // weekNumberStyle: WeekNumberStyle(backgroundColor: Colors.red),
        monthViewSettings: const MonthViewSettings(
            navigationDirection: MonthNavigationDirection.vertical,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)),
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
