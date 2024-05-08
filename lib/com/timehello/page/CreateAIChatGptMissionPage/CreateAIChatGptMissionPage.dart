///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

///calendar import
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/beans/ResourceDeliveryInfoBean.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/EVENTNAME.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/SharePreferenceModel.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/NavigatorManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';

import '../../common/database/apis/MongoApisManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/ChatInputWidget.dart';
import '../../components/CircleWidget.dart';
import '../../components/CommonCalendarHeaderWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../components/GPTCreateMissionWidget.dart';
import '../../components/ListingFilterWidget.dart';
import '../../components/SelectCircleDialogUtil.dart';
import '../../components/SelectTagDialogUtil.dart';
import '../../config/ColorsConfig.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../config/StylesConfig.dart';
import '../../models/ChatGptMessageModel.dart';
import '../../models/FolderModel.dart';
import '../../models/MissionModel.dart';
import '../../util/ChatGptManager.dart';
import '../../util/DialogManagement.dart';
import '../../util/TextUtil.dart';
import '../../util/Utility.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../SettingItemDetailPage/SettingItemDetailPage.dart';
import 'components/ButtonListWidget.dart';

///Local import

/// Widget of getting started calendar
class CreateAIChatGptMissionPage extends BaseWidget {
  /// Creates default getting started calendar
  Function? onRefresh;

  CreateAIChatGptMissionPage({Key? key, Function? onRefresh}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return CreateAIChatGptMissionPageState();
  }
}

class CreateAIChatGptMissionPageState
    extends BaseWidgetState<CreateAIChatGptMissionPage> {
  CreateAIChatGptMissionPageState();

  GlobalKey<ChatInputWidgetState> ChatInputWidgetStateGlobalKey = GlobalKey();

  // FolderModel? folderModelSearch;
  _DataSource _events = _DataSource(<Appointment>[]);

  // CommonCalendarHeaderWidgetController? controller;
  Icon? iconCircle;
  Color circleColor = ColorsConfig.gray_cc_cancel;
  String circleTitle = "";
  String? curFolderModelObjectId = null;

  String? tagName = "";
  Color? tagColor = ColorsConfig.gray_cc_cancel;
  String tagId = "";
  String tagNames = "";
  String tagIds = "";
  bool isLoading = false;

  String role = getI18NKey().role_time_manager;

  late CalendarView _currentView;
  List<MissionModel> listMissionModel = [];
  List<MissionModel> curListMissionModel = [];
  final List<CalendarView> _allowedViewsList = <CalendarView>[
    // CalendarView.day,
    CalendarView.week,
    // CalendarView.workWeek,
    CalendarView.schedule,
    // CalendarView.month,
    // // CalendarView.timelineDay,
    // CalendarView.timelineWeek,
    // // CalendarView.timelineWorkWeek,
    // CalendarView.timelineMonth,
  ];

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  final CalendarController _calendarController = CalendarController();
  DateTime curDateTime = DateTime.now();

  @override
  void initState() {
    _currentView = CalendarView.week;
    _currentView = CalendarView.values[1];
    _calendarController.view = _currentView;
    isAppBarVisible = true;
    forceAppBarVisible = true;
    super.initState();
  }

  void unfocus() {
    ChatInputWidgetStateGlobalKey.currentState?.unfocus();
  }

  @override
  Widget baseBuild(BuildContext context) {
    _events = _DataSource(getAppointmentDetails(listMissionModel ?? []));
    final Widget calendar =
        _getDragAndDropCalendar(_calendarController, _events, _onViewChanged);
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomMarquee(
          bean: MarqueInfo.marqueCreateAIChatGptMissionPage,
          paddingTop: 0,
        ),
        // ListingFilterWidget(onTapListener: (data) {
        //   this.folderModelSearch = data;
        //   setState(() {});
        //   // this.curSearchingFocusModel = data;
        //   // this.requestDatas();
        // }),
        Expanded(
          child: Stack(
            children: [
              Row(children: <Widget>[
                Expanded(
                  child: _calendarController.view == CalendarView.month &&
                          screenHeight < 800
                      ? Scrollbar(
                          thumbVisibility: true,
                          controller: _controller,
                          child: ListView(
                            controller: _controller,
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(bottom: 140),
                                height: 600,
                                child: calendar,
                              )
                            ],
                          ))
                      : Container(
                          padding: EdgeInsets.only(bottom: 140),
                          color: Colors.white,
                          child: calendar),
                ),
              ]),
              ChatInputWidget(
                  key: ChatInputWidgetStateGlobalKey,
                  placeholder: getI18NKey().role_message_placehodler,
                  isLoading: isLoading,
                  headerWidget: Container(
                    padding: EdgeInsets.only(right: 15),
                    height: 40,
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CommonCalendarHeaderWidget(
                                // controller: controller,
                                calendarTypeEnum: CalendarTypeEnum.day,
                                onChange: (data) {
                                  if (data != null) {
                                    PickerDateRange? dateTimePickerDateRange =
                                        data;
                                    this.curDateTime =
                                        dateTimePickerDateRange?.startDate ??
                                            DateTime.now();
                                  }
                                  print("");
                                  //  = data;
                                  // dateTimePickerDateRange = data;
                                  // requestDatas();
                                }),
                            TextButton(
                                style: StylesConfig.transparentTextButtonStyle,
                                onPressed: () {
                                  // if (this.widget.onTapCircleListener !=
                                  //     null) {
                                  //   this.widget.onTapCircleListener!();
                                  // }
                                  this.onTapCircleListener();
                                },
                                child: Wrap(
                                  children: [
                                    this.iconCircle ??
                                        Icon(Icons.fiber_manual_record,
                                            size: 25, color: this.circleColor),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 100),
                                        child: Text(
                                          this.circleTitle ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                  ],
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                )),
                            TextButton(
                              style: StylesConfig.transparentTextButtonStyle,
                              onPressed: () {
                                this.onClickCreateTag();
                                // if (this.widget.onTapTagListener != null) {
                                //   this.widget.onTapTagListener!();
                                // }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    size: 25,
                                    color: this.tagColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 65),
                                      child: Text(
                                        this.tagNames ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ))
                                ],
                              ),
                            ),
                            ButtonListWidget(
                              list: CONSTANTS
                                  .getGptRoleResourceDeliveryInfoBeanList(),
                              onTapListener: (obj) {
                                ResourceDeliveryInfoBean data = obj['data'];
                                role = data.resourceTitle ?? "";
                                ChatInputWidgetStateGlobalKey.currentState
                                    ?.setText(data.resourceContent ?? "");
                              },
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            EasyLoadingManager.getInstance().showLoading();
                            if (this.listMissionModel.length > 0) {
                              await MongoApisManager.getInstance()
                                  .batchInsert_MissionModels(
                                      listParam: this.listMissionModel);
                              Utility.popNavigator(context);
                            }
                            EasyLoadingManager.getInstance().dismiss();
                          },
                          child: Text(
                            getI18NKey().create,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  onClickSendMsg: (val) async {
                    await onClickSendGptMsg(val);
                  })
            ],
          ),
        )
      ],
    );
  }

  /**
   * 创建mission时选择tag
   */
  Future onClickCreateTag() async {
    unfocus();
    SelectTagDialogUtil.show(context,
        title: getI18NKey().selectTag,
        content: '', okCallBack: (FolderModel data) {
      setState(() {
        this.tagColor = Color(data.color);
        this.tagName = data.title;
        this.tagId = data?.objectId ?? "";
        this.tagNames = [this.tagName].join(',');
        this.tagIds = [data.objectId].join(',');
        updateMissionModelListWithTagNames();
      });
    }, onTapCreateTagListener: (data) {
      // this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  Future<void> onClickSendGptMsg(val) async {
    unfocus();
    curListMissionModel = [];
    ChatGptMessageModel? chatGptMessageModelGpt;
    if (!TextUtil.isEmpty(val)) {
      this.isLoading = true;
      updateUI();
      try {
        chatGptMessageModelGpt = await ChatGptManager.getInstance().sendMessage(
            showForbiddenMsg: false,
            // conversationIdParams: getLastParentMessageId()['conversationId'],
            newChatGptObject: true,
            textParam:
                CONSTANTS.getChatGptMessagge(this.role, this.curDateTime, val),
            parentMessageIdParam: null);
        String s = chatGptMessageModelGpt?.text ?? "";
        print("result:${s}");
        List<Map<String, dynamic>> list = Utility.getJsonFromGpt(s);
        list.map((i) {
          DateTime daily_start_time =
              Utility.getDateTimeFromYMDHMSF(i["daily_start_time"]);
          DateTime daily_end_time =
              Utility.getDateTimeFromYMDHMSF(i["daily_end_time"]);
          MissionModel missionModel = MissionModel();
          missionModel.title = i["title"];
          missionModel.total_tomotoes = i["total_tomotoes"];
          missionModel.priorityStatus = i["priorityStatus"];
          missionModel.message = i["message"];
          // missionModel.daily_start_time = i["daily_start_time"];

          missionModel.daily_start_time =
              daily_start_time.hour * 60 * 60 * 1000 +
                  daily_start_time.minute * 60 * 1000;
          missionModel.daily_end_time = daily_end_time.hour * 60 * 60 * 1000 +
              daily_end_time.minute * 60 * 1000;
          missionModel.end_time = Utility.getDateTimeFromYMDHMSF(i["end_time"])
              .millisecondsSinceEpoch;

          // MissionModel missionModel = MissionModel.fromJson(i);
          //   DateTime dateTime1 = Utility.getLocalDateTimeFromUTCTimestamp(missionModel.daily_start_time ?? 0);
          //   DateTime dateTime2 = Utility.getLocalDateTimeFromUTCTimestamp(missionModel.daily_end_time ?? 0);
          curListMissionModel.add(missionModel);
          listMissionModel.add(missionModel);
        }).toList();
        updateMissionModelList();
        // listMissionModel.forEach((element) {
        //   DateTime dateTimeStart = Utility.getDateTimeFromTimeStamp(element?.daily_start_time ?? 0);
        //   DateTime dateTimeEnd = Utility.getDateTimeFromTimeStamp(element?.daily_end_time ?? 0);
        //   element.daily_start_time = dateTimeStart.hour * 60 * 60 * 1000 + dateTimeStart.minute * 60 * 1000+ dateTimeStart.second * 1000;
        //   element.daily_end_time = dateTimeEnd.hour * 60 * 60 * 1000 + dateTimeEnd.minute * 60 * 1000+ dateTimeEnd.second * 1000;
        // });

        DialogManagement.getInstance().showCustomDialogWithSmallButtons(
          context,
          okTitle: getI18NKey().i_know,
          children: [
            Text(
              getI18NKey().trainee_advice_notice(this.role),
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      GPTCreateMissionWidget(list: this.curListMissionModel)),
            )
          ],
          title: getI18NKey().trainee_give_your_advice(this.role),
          okCallback: () {
            DialogManagement.getInstance().hideDialog(context);
            DialogManagement.showRatingDialog(context,
                scene: EVENTNAME.CreateAIChatGptMissionPage);
          },
          // cancelCallback: () {
          //   DialogManagement.getInstance().hideDialog(context);
          // }
        );

        print("list");
        updateUI();
        // getAppointmentDetails(listMissionModel);
      } catch (e) {
        Utility.showToast(msg: getI18NKey().request_error_try_again);
        print(e);
      } finally {
        this.isLoading = false;
        updateUI();
      }
    }
  }

  /// Creates the required appointment details as a list.
  List<Appointment> getAppointmentDetails(List<MissionModel> list) {
    final List<Appointment> appointments = <Appointment>[];
    List<MissionModel> listMissionModelsAddedForTimemodeSegment = [];

    for (int i = 0; i < list.length; i++) {
      MissionModel missionModel = list[i];
      DateTime dateTimeEnd;
      DateTime dateTimeStart;
      // DateTime dateTime = Utility.getDateTimeFromTimeStamp(missionModel.end_time ?? 0);
      DateTime dateTime = this.curDateTime;
      if (missionModel?.daily_start_time == null &&
          missionModel?.daily_end_time == null &&
          missionModel.repetiveType == 0) {
        dateTimeStart =
            Utility.getDateTimeFromTimeStamp(missionModel.end_time ?? 0);
      } else {
        dateTimeStart = Utility.getDateTimeFromTimeStamp(DateTime(
                    dateTime?.year ?? 0,
                    dateTime?.month ?? 0,
                    dateTime?.day ?? 0,
                    dateTime?.hour ?? 0)
                .millisecondsSinceEpoch +
            (missionModel?.daily_start_time ?? 0));
      }

      if (missionModel?.daily_end_time != null) {
        dateTimeEnd = Utility.getDateTimeFromTimeStamp(DateTime(
                    dateTime.year ?? 0,
                    dateTime.month ?? 0,
                    dateTime.day ?? 0,
                    dateTime.hour ?? 0)
                .millisecondsSinceEpoch +
            (missionModel?.daily_end_time ?? 0));
      } else {
        dateTimeEnd = dateTimeStart.add(Duration(hours: 1));
      }
      if (listMissionModelsAddedForTimemodeSegment.contains(missionModel) ==
          false) {
        appointments.add(Appointment(
          id: i,
          subject: missionModel.title ?? "",
          startTime: dateTimeStart,
          endTime: dateTimeEnd,
          color: Color(0xffff8800),
        ));
      }
      //时间段不能重复添加
      if (missionModel.time_mode == 1) {
        listMissionModelsAddedForTimemodeSegment.add(missionModel);
      }
    }
    return appointments;
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

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSettingItem':
        this.onClickMissionSetting(data['missionModel']);
        break;
    }
  }

  void updateMissionModelListWithTagNames() {
    this.listMissionModel.forEach((element) {
      if (TextUtil.isEmpty(element.tagNames)) {
        element.tagNames = this.tagNames;
      }
      if (TextUtil.isEmpty(element.tagIds)) {
        element.tagIds = this.tagIds;
      }
      // if (TextUtil.isEmpty(element.folder_id)) {
      //   element.folder_id = this.curFolderModelObjectId;
      // }
      //
      // if (TextUtil.isEmpty(element.alert_time)) {
      //   element.alert_time = (element?.daily_start_time ?? 0) +
      //       (element?.end_time ?? 0);
      // }
    });
  }

  void updateMissionModelListWithFolderId() {
    this.listMissionModel.forEach((element) {
      if (TextUtil.isEmpty(element.folder_id)) {
        element.folder_id = this.curFolderModelObjectId;
      }
    });
  }

  void updateMissionModelListWithAlertTime(MissionModel missionModel) {
    // this.listMissionModel.forEach((element) {
    missionModel.alert_time =
        (missionModel?.daily_start_time ?? 0) + (missionModel?.end_time ?? 0);
    // });
  }

  void updateMissionModelList() {
    this.listMissionModel.forEach((element) {
      if (TextUtil.isEmpty(element.tagNames)) {
        element.tagNames = this.tagNames;
      }
      if (TextUtil.isEmpty(element.tagIds)) {
        element.tagNames = this.tagIds;
      }
      if (TextUtil.isEmpty(element.folder_id)) {
        element.folder_id = this.curFolderModelObjectId;
      }

      if (TextUtil.isEmpty(element.alert_time)) {
        element.alert_time = (element?.daily_start_time ?? 0) +
            (Utility.getYearMonthAndDayDateTimeByTimestamp(
                    element?.end_time ?? 0)
                .millisecondsSinceEpoch);
      }
    });
  }

  /**
   * 跳转到设置叶敏
   */
  void onClickMissionSetting(data) {
    unfocus();
    Utility.popupDesktopRightNavigator(context);
    // if (Utility.isHandsetBySize()) {
    NavigatorManager.getInstance().pushToSettingItemDetailPage(context,
        missionModel: data,
        fromNormal: 1, onClickDeleteCallback: (MissionModel missionModel) {
      if (missionModel != null) {
        this.listMissionModel.remove(missionModel);
        updateUI();
      }
    }, popOkCallback: (data) {
      Future.delayed(Duration(seconds: 1), () {
        // updateMissionModelList();
        updateUI();
      });
    });
    // Utility.pushNavigator(
    //     context,
    //     new SettingItemDetailPage(
    //       missionModel: data,
    //     ), callback: (val) {
    //   // requestDatas();
    // });
    // } else {
    //   Utility.openRightSideDesktopNavigator(
    //       context, 'SettingItemDetailPage', {'missionModel': data});
    // }
  }

  /**
   * 穿件mission时选择目标文件夹
   */
  Future onTapCircleListener() async {
    unfocus();
    SelectCircleDialogUtil.show(context,
        title: getI18NKey().selectMission,
        content: '', okCallBack: (FolderModel data) {
      setState(() {
        this.circleColor = Color(data.color);
        this.circleTitle = data?.title ?? "";
        this.iconCircle = Icon(
            IconData(data.icon ?? 0, fontFamily: 'MaterialIcons'),
            size: 25,
            color: this.circleColor);
        this.curFolderModelObjectId = data.objectId;
        updateMissionModelListWithFolderId();
      });
      // updateUI();
    }, onTapCreateTagListener: (data) {
      // this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getDragAndDropCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      ViewChangedCallback? viewChangedCallback]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViewsList,
      showNavigationArrow: false,
      onViewChanged: viewChangedCallback,
      allowDragAndDrop: true,
      showDatePickerButton: true,
      allowAppointmentResize: true,

      // blackoutDatesTextStyle: TextStyle(color: Colors.red),
      // cellBorderColor: Colors.red, //边框颜色
      // headerStyle: CalendarHeaderStyle(textStyle: TextStyle(color: Colors.red)), // 选择模式的背景色背景色
      // blackoutDatesTextStyle: TextStyle(color: Colors.green),
      // viewHeaderStyle: ViewHeaderStyle(dateTextStyle: TextStyle(color: Colors.red), dayTextStyle:  TextStyle(color: Colors.red)),
      // weekNumberStyle: WeekNumberStyle(backgroundColor: Colors.red),
      onLongPress: (CalendarLongPressDetails details) {
        unfocus();
        if ((details.appointments?.length ?? 0) > 0) {
          return;
        }
        DateTime date = details.date!;
        dynamic appointments = details.appointments;
        CalendarElement view = details.targetElement;
        MissionModel missionModel = MissionModel();
        missionModel.end_time = date.millisecondsSinceEpoch;
        missionModel.daily_start_time = date.hour * 60 * 60 * 1000 +
            date.minute * 60 * 1000 +
            date.second * 1000;
        Utility.openPagePCAndMobile(context,
            child: CreateMissionPage(
                missionModel: missionModel,
                fromNormal: 1,
                popOkCallback: (res) {
                  if (res != null) {
                    listMissionModel.add(res);
                    updateUI();
                  }
                },
                onRefresh: () {}));
        // if (Utility.isHandsetBySize() == true) {
        //   // Utility.pushNavigator(context,
        //   //     );
        // } else {
        //   DialogManagement.getInstance().showPCCustomDialog(
        //       context: context,
        //       widget: CreateMissionPage(
        //           missionModel: missionModel, fromNormal: 1, onRefresh: () {}));
        // }
      },
      onSelectionChanged: (CalendarSelectionDetails calendarSelectionDetails) {
        // print(11111111);
      },
      onTap: (CalendarTapDetails details) async {
        // calendarTapDetails.appointments
        unfocus();
        List<dynamic>? appointments = details.appointments;
        dynamic appointmentDynamic = appointments?[0];
        //
        if (appointmentDynamic != null) {
          Appointment appointment = appointmentDynamic as Appointment;
          // if (appointment != null) {
          //   ;
          //   // MissionModel? missionModel = await MongoApisManager.getInstance()
          //   //     .queryWhereEqual_missionDataByObjectId(
          //   //         objectId: appointment.id.toString());
          //
          this.onClick('onClickSettingItem',
              {'missionModel': listMissionModel[appointment.id as int]});
        }
        // }
      },
      onAppointmentResizeEnd: (AppointmentResizeEndDetails details) async {
        Appointment appointment = details.appointment as Appointment;
        // MissionModel? missionModel = await MongoApisManager.getInstance()
        //     .queryWhereEqual_missionDataByObjectId(
        //         objectId: appointment.id.toString());
        MissionModel? missionModel =
            this.listMissionModel[appointment.id as int];
        CalendarResource? resource = details.resource;
        DateTime startDateTime = details.startTime!;
        DateTime endDateTime = details.endTime!;

        int startTime = (startDateTime?.hour ?? 0) * 60 * 60 * 1000 +
            (startDateTime?.minute ?? 0) * 60 * 1000 +
            (startDateTime?.second ?? 0) * 1000;

        int endTime = (endDateTime?.hour ?? 0) * 60 * 60 * 1000 +
            (endDateTime?.minute ?? 0) * 60 * 1000 +
            (endDateTime?.second ?? 0) * 1000;

        missionModel?.daily_end_time = endTime;
        missionModel?.daily_start_time = startTime;

        // if (Utility.isFolderModelEnabled(folderId: missionModel?.folder_id) ==
        //     false) {
        //   Utility.showToast(
        //       context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
        //   return;
        // }

        // await MongoApisManager.getInstance()
        //     .update_MissionModel(missionModel: missionModel ?? MissionModel());
        if (this.widget.onRefresh != null) {
          this.widget.onRefresh!();
        }
      },
      onDragEnd: (AppointmentDragEndDetails details) async {
        unfocus();
        Appointment appointment = details.appointment as Appointment;
        MissionModel? missionModel = await MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByObjectId(
                objectId: appointment?.id?.toString() ?? "");
        CalendarResource? sourceResource = details.sourceResource;
        CalendarResource? targetResource = details.targetResource;
        DateTime? draggingTime = details.droppingTime;

        int time = (draggingTime?.hour ?? 0) * 60 * 60 * 1000 +
            (draggingTime?.minute ?? 0) * 60 * 1000 +
            (draggingTime?.second ?? 0) * 1000;

        missionModel?.daily_end_time = ((missionModel.daily_end_time ?? 0) -
                (missionModel.daily_start_time ?? 0)) +
            time;
        missionModel?.daily_start_time = time;

        if (missionModel?.repetiveType == 0) {
          missionModel?.end_time = (draggingTime?.millisecondsSinceEpoch ?? 0);
        }

        if (Utility.isFolderModelEnabled(
                folderId: missionModel?.folder_id ?? "") ==
            false) {
          Utility.showToast(
              context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
          return;
        }
        // await MongoApisManager.getInstance()
        //     .update_MissionModel(missionModel: missionModel ?? MissionModel());
        if (this.widget.onRefresh != null) {
          this.widget.onRefresh!();
        }
        if (missionModel != null)
          updateMissionModelListWithAlertTime(missionModel);
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
      scheduleViewSettings: ScheduleViewSettings(appointmentItemHeight: 50),
      // weekNumberStyle: WeekNumberStyle(backgroundColor: Colors.red),

      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      timeSlotViewSettings: const TimeSlotViewSettings(
          minimumAppointmentDuration: Duration(minutes: 60)),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
