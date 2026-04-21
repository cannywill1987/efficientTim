///Dart imports

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

///calendar import
import 'package:time_hello/com/timehello/components/CustomTextField.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
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
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../../../r.dart';
import '../../../common/database/apis/MongoApisManager.dart';
import '../../../common/provider/Env.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/BaseWidget.dart';
import '../../../components/CircleWidget.dart';
import '../../../components/CustomMarquee.dart';
import '../../../components/ListingFilterWidget.dart';
import '../../../components/SearchBarWidget.dart';
import '../../../components/SearchBarWithIconWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../config/Params.dart';
import '../../../models/FolderModel.dart';
import '../../../models/MissionModel.dart';
import '../../../models/TimelineMissionModel.dart';
import '../../../util/DialogManagement.dart';
import '../../../util/TextUtil.dart';
import '../../../util/Utility.dart';
import '../../../util/WidgetManager.dart';
import '../../CreateMissionPage/CreateMissionPage.dart';
import '../../RichEditor/RichEditorPage.dart';
import '../../SettingItemDetailPage/SettingItemDetailPage.dart';

///Local import

/// Widget of getting started calendar
class TimeManagementMissionPage extends BaseWidget {
  /// Creates default getting started calendar
  Function? onRefresh;

  // FolderModel? folderModel;
  PageEnum? pageEnum;
  Function? onTapNavMenuListener;
  Function? onTapCreateMissionListener;
  Function? onTapRightNavMenuListener;

  TimeManagementMissionPage(
      {Key? key,
      this.pageEnum = PageEnum.Normal,
      Function? onRefresh,
      this.onTapRightNavMenuListener,
      this.onTapNavMenuListener,
      this.onTapCreateMissionListener})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return TimeManagementMissionPageState();
  }
}

class TimeManagementMissionPageState
    extends BaseWidgetState<TimeManagementMissionPage> {
  TimeManagementMissionPageState();

  double margin = 5;
  GlobalKey<SearchBarWidgetState>? searchBarWidgetKey = GlobalKey();

  FolderModel? folderModelSearch;
  _DataSource _events = _DataSource(<Appointment>[]);
  late CalendarView _currentView;

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
  String? curSearchWords = null;
  bool isSearchBarVisible = false;

  CalendarView _resolveInitialView(int storedIndex) {
    if (storedIndex < 0 || storedIndex >= CalendarView.values.length) {
      return CalendarView.week;
    }
    final CalendarView view = CalendarView.values[storedIndex];
    if (view == CalendarView.schedule || !_allowedViewsList.contains(view)) {
      return CalendarView.week;
    }
    return view;
  }

  void _normalizeControllerView() {
    final CalendarView? view = _calendarController.view;
    if (view == null ||
        view == CalendarView.schedule ||
        !_allowedViewsList.contains(view)) {
      _calendarController.view = CalendarView.week;
      _currentView = CalendarView.week;
    }
  }

  @override
  void initState() {
    this.isNavBackBtnVisible = false;
    this.forceAppBarVisible = false;
    _currentView = CalendarView.week;
    this.leftNavChildren = [
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          if (this.widget.onTapNavMenuListener != null) {
            this.widget.onTapNavMenuListener!();
          }
        },
      )
    ];
    // if(ABTestSetting.isOpenAiOn)
    // this.rightNavChildren = [
    //   IconButton(
    //       onPressed: () {
    //         this.widget.onTapRightNavMenuListener?.call();
    //       },
    //       icon: Utility.getSVGPicture(R.assetsImgIcAiVoice, size: 24))
    // ];
    int currentView = SharePreferenceUtil.getSyncInstance().getInt(
        key: "timeManagementDefautKey", defaultVal: CalendarView.week.index);
    _currentView = _resolveInitialView(currentView);
    _calendarController.view = _currentView;
    super.initState();
  }

  void onClickSearch(searchWord) {
    this.curSearchWords = searchWord;
    updateUI();
    // requestDatas();
  }

  @override
  void didUpdateWidget(covariant TimeManagementMissionPage oldWidget) {
    // TODO: implement didUpdateWidget
    updateRightNavChildren();
    super.didUpdateWidget(oldWidget);
  }

  void updateRightNavChildren() {
    // && this.rightNavChildren == null
    if (this.folderModelSearch?.tag == 1) {
      // if (ABTestSetting.isOpenAiOn && Utility.isHuaWei() == false)
      this.rightNavChildren = [
        IconButton(
            onPressed: () {
              this.widget.onTapRightNavMenuListener?.call(this.folderModelSearch, false);
            },
            icon: Utility.getSVGPicture(R.assetsImgIcListingGroup,
                size: StylesConfig.sizeGroup))
      ];
      updateUI();
    }
    // else if (this.rightNavChildren != null) {
    //   this.rightNavChildren = null;
    //   updateUI();
    // }
    else if (ABTestSetting.isOpenAiOn && Utility.isHuaWei() == false) {
      this.rightNavChildren = [
        IconButton(
            onPressed: () {
              this
                  .widget
                  .onTapRightNavMenuListener
                  ?.call(this.folderModelSearch, true);
            },
            icon: Utility.getSVGPicture(R.assetsImgIcAiVoice, size: 24))
      ];
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  componentDidMount() {
    // TODO: implement componentDidMount
    updateRightNavChildren();
    return super.componentDidMount();
  }

  @override
  Widget baseBuild(BuildContext context) {
    _normalizeControllerView();
    // CalendarModel calendarModel = context.watch<GlobalStateEnv>().calendarModel;
    return Selector<GlobalStateEnv, CalendarModel>(
        selector: (_, env) => env.calendarModel,
        builder: (_, curCalendarModel, __) {
          CalendarModel calendarModel = curCalendarModel;
          return Selector<Env, FolderModel>(
              selector: (_, env) => env.curFolderSelected,
              builder: (_, curFolderSelected, __) {
                return Selector<Env, int>(
                    selector: (_, env) => env.curFolderStatus,
                    builder: (_, curFolderStatus, __) {
                      this.folderModelSearch = curFolderSelected;
                      List<DayModel> dayModelList = Utility.filterDaysModels(
                          calendarModel?.dayModelList ?? [],
                          folderModelSearch,
                          curSearchWords);
                      _events =
                          _DataSource(getAppointmentDetails(dayModelList));
                      final Widget calendar = _getDragAndDropCalendar(
                          _calendarController,
                          _events,
                          _onViewChanged,
                          WidgetManager.getAppointmentUIWidget(
                              _calendarController));
                      final double screenHeight =
                          MediaQuery.of(context).size.height;
                      return Scaffold(
                          body: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ...getHeaderWidget(),
                          // if(widget.folderModel == null)
                          // CustomMarquee(
                          //   bean: MarqueInfo.marqueTimemanagement,
                          //   paddingTop: 0,
                          // ),
                          // if(widget.folderModel == null)
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
                                    child: _calendarController.view ==
                                                CalendarView.month &&
                                            screenHeight < 800
                                        ? Scrollbar(
                                            thumbVisibility: true,
                                            controller: _controller,
                                            child: ListView(
                                              controller: _controller,
                                              children: <Widget>[
                                                Container(
                                                  color:
                                                      ThemeManager.getInstance()
                                                          .getBackgroundColor(
                                                              defaultColor:
                                                                  Colors.white),
                                                  height: 600,
                                                  child: calendar,
                                                )
                                              ],
                                            ))
                                        : Container(
                                            color: ThemeManager.getInstance()
                                                .getBackgroundColor(
                                                    defaultColor: Colors.white),
                                            child: calendar),
                                  )
                                ]),
                                Positioned(
                                    bottom: 30,
                                    right: 20,
                                    child: CircleWidget(
                                      onTapListener: (obj) {
                                        MissionModel missionModel =
                                            MissionModel();
                                        missionModel.folder_id =
                                            this.folderModelSearch?.objectId;
                                        missionModel.end_time =
                                            CONSTANTS.getDeadLineTme((0) + 1);

                                        if (Utility.isHandsetBySize() == true) {
                                          Utility.pushNavigator(
                                              context,
                                              CreateMissionPage(
                                                  missionModel: missionModel));
                                        } else {
                                          OverlayManagement.getInstance()
                                              .showPCCustomOverlay(
                                                  context: context,
                                                  child: CreateMissionPage(
                                                      missionModel:
                                                          missionModel));
                                          // DialogManagement.getInstance()
                                          //     .showPCCustomDialog(
                                          //         context: context,
                                          //         widget: CreateMissionPage(
                                          //             missionModel:
                                          //                 missionModel));
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
  }

  /**
   * 搜索框 标题等 导出框
   */
  List<Widget> getHeaderWidget() {
    return [
      // CustomMarquee(
      //   bean: MarqueInfo.marqueMissionpage,
      // ),
      SizedBox(
        height: 15,
      ),
      Container(
        padding: EdgeInsets.only(
          left: margin,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CustomTextField(
                    key: UniqueKey(),
                    //每次都会重新创建
                    maxWidth: Utility.isHandsetBySize() == true ? 200 : 400,
                    isEditable: this.folderModelSearch?.tag == 2 ||
                        this.folderModelSearch?.tag == 1,
                    style: TextStyle(
                        fontSize: 20,
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultColor: ColorsConfig.gray_40),
                        fontWeight: FontWeight.bold),
                    text: this.folderModelSearch?.title ?? "",
                    onEnterListener: (v) {
                      this.folderModelSearch?.title = v;
                      if (this.folderModelSearch != null) {
                        MongoApisManager.getInstance().update_FolderModelWithFM(
                            folderModel: this.folderModelSearch!,
                            shouldQueryMissionModel: false);
                      }
                    }),
                SizedBox(
                  width: 4,
                ),
                ListingSecurityWidget(
                  folder_id: this.folderModelSearch?.objectId ?? "",
                  cryptoVersion: this.folderModelSearch?.cryptoVersion ?? -1,
                )
              ],
            ),
            Row(
              children: [
                SearchBarWithIconWidget(
                  key: ValueKey("ejfiejf"),
                  onChange: (searchWord) {
                    onClickSearch(searchWord);
                  },
                  onClickSearchListener: (bool res) {
                    this.isSearchBarVisible = res;
                    updateUI();
                  },
                ),
                (this.folderModelSearch?.tag == 1 ||
                        this.folderModelSearch?.tag == 2)
                    ? InkWell(
                        onTap: () async {
                          TimelineMissionModel? timelineMissionModel = null;
                          if (TextUtil.isEmpty(this
                                  .folderModelSearch
                                  ?.timelineNoteObjectId) ==
                              false) {
                            timelineMissionModel = await MongoApisManager
                                    .getInstance()
                                .queryWhereEqual_TimelineMissionModelByObjectId(
                                    objectId: this
                                            .folderModelSearch
                                            ?.timelineNoteObjectId ??
                                        "");
                            timelineMissionModel?.sceneType = "note";
                            timelineMissionModel?.eventType = "note";
                          } else {
                            timelineMissionModel = TimelineMissionModel();
                            timelineMissionModel.folder_id =
                                this.folderModelSearch?.objectId ?? null;
                            timelineMissionModel.tagNames =
                                this.folderModelSearch?.tag == 2
                                    ? this.folderModelSearch?.title
                                    : "";
                            timelineMissionModel.color =
                                this.folderModelSearch?.color;
                            timelineMissionModel.icon =
                                this.folderModelSearch?.icon;
                            timelineMissionModel.sceneType = "note";
                            timelineMissionModel.eventType = "note";
                            // timelineMissionModel.
                          }
                          Utility.openPagePCAndMobile(context,
                              child: RichEditorPage(
                                  onOkListener: (url,
                                      timelineMissionModelObjectId,
                                      numberNoteWords) async {
                                    this.folderModelSearch?.noteUrl = url;
                                    this.folderModelSearch?.numberNoteWords =
                                        numberNoteWords;
                                    if (timelineMissionModelObjectId != null) {
                                      this
                                              .folderModelSearch
                                              ?.timelineNoteObjectId =
                                          timelineMissionModelObjectId;
                                    }
                                    await MongoApisManager.getInstance()
                                        .update_FolderModelWithFM(
                                            folderModel:
                                                this.folderModelSearch ??
                                                    FolderModel());
                                  },
                                  timelineMissionModel: timelineMissionModel,
                                  richTextModeEnum: RichTextModeEnum.getUrl));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(250)),
                              border: Border.all(
                                  width: 2, color: Colors.lightBlueAccent)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: 15,
                              height: 15,
                              child: Utility.getSVGPicture(
                                R.assetsImgIcWordDocument,
                                size: 15,
                              ),
                            ),
                            Container(
                              child: Text(getI18NKey().add_note),
                            ),
                          ]),
                        ),
                      )
                    : SizedBox.shrink(),
                // SizedBox(
                //   width: 10,
                // ),
                // InkWell(
                //   onTap: () {
                //     TextEditingController textEditingController =
                //     TextEditingController();
                //     String s = Utility.getContentFromMissionList(
                //         datas: this.curListMissionModels ?? [],
                //         listCheckButtonModel:
                //         CONSTANTS.getExportButtonsList());
                //     textEditingController.text = s;
                //     ExportMissionListDialogUtil.show(context,
                //         textEditingController: textEditingController,
                //         onTapListener: (res) {
                //           List<CheckButtonStateModel> data = res['data'];
                //           MissionOrderEnum missionOrderEnum = res['enum'];
                //           String s = Utility.getContentFromMissionList(
                //               datas: Utility.getMissionModelListAfterOrder(
                //                   missionOrderEnum,
                //                   this.curListMissionModels ?? []),
                //               listCheckButtonModel: data);
                //           textEditingController.text = s;
                //           updateUI();
                //         }, export: (data) {
                //           Utility.showToast(
                //               context: context,
                //               msg: getI18NKey().offer_next_version);
                //         });
                //     // Utility.getContentFromMissionList(datas: this.missionListOriginal, listCheckButtonModel: CONSTANTS.getMi);
                //   },
                //   child: CustomBlackButton(
                //     text: getI18NKey().export,
                //     color: Colors.red,
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                // getPopupMenu()
              ],
            )
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      (this.isSearchBarVisible && Utility.isHandsetBySize())
          ? SearchBarWidget(
              key: searchBarWidgetKey,
              defaultValue: this.curSearchWords,
              width: double.infinity,
              onChangeListener: (searchWord) {
                onClickSearch(searchWord);
              },
              onClickResetListener: () {
                isSearchBarVisible = !isSearchBarVisible;
                updateUI();
              })
          : SizedBox.shrink()
    ];
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

    for (int i = 0; i < list.length; i++) {
      DayModel dayModel = list[i];
      dayModel.missionModelList.forEach((MissionModel _missionModel) {
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
        late DateTime dateTimeStart;
        late DateTime? dateTimeEnd;
        if (_missionModel.title == "11111222222") {
          print(1111111);
        }
        if (_missionModel.time_mode == null || _missionModel.time_mode == 0) {
          if (_missionModel?.daily_start_time == null &&
              _missionModel?.daily_end_time == null &&
              _missionModel.repetiveType == 0) {
            if (_missionModel?.end_time != null) {
              //没有重复
              dateTimeStart = Utility.getDateTimeFromTimeStamp(
                  _missionModel?.start_time ?? 0);
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
          dateTimeStart =
              Utility.getDateTimeFromTimeStamp(_missionModel?.start_time ?? 0);
          // }
          // if (_missionModel?.end_time != null) {
          dateTimeEnd =
              Utility.getDateTimeFromTimeStamp(_missionModel?.end_time ?? 0);
          // }
        }
        // final DateTime startDate =
        // DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
        if (listMissionModelsAddedForTimemodeSegment.contains(_missionModel) ==
            false) {
          appointments.add(Appointment(
            id: _missionModel.objectId,
            subject: _missionModel.title ?? "",
            startTime: dateTimeStart,
            endTime: dateTimeEnd,
            color: Color(folderModelWithMission?.color ?? 0xffff8800),
          ));
        }
        //时间段不能重复添加
        if (_missionModel.time_mode == 1) {
          listMissionModelsAddedForTimemodeSegment.add(_missionModel);
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
  SfCalendar _getDragAndDropCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      ViewChangedCallback? viewChangedCallback,
      CalendarAppointmentBuilder? appointmentBuilder]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViewsList,
      showNavigationArrow: false,
      onViewChanged: viewChangedCallback,
      allowDragAndDrop: true,
      showDatePickerButton: true,
      allowAppointmentResize: true,
      appointmentBuilder: appointmentBuilder,
      // blackoutDatesTextStyle: TextStyle(color: Colors.red),
      // cellBorderColor: Colors.red, //边框颜色
      // headerStyle: CalendarHeaderStyle(textStyle: TextStyle(color: Colors.red)), // 选择模式的背景色背景色
      // blackoutDatesTextStyle: TextStyle(color: Colors.green),
      // viewHeaderStyle: ViewHeaderStyle(dateTextStyle: TextStyle(color: Colors.red), dayTextStyle:  TextStyle(color: Colors.red)),
      // weekNumberStyle: WeekNumberStyle(backgroundColor: Colors.red),
      onLongPress: (CalendarLongPressDetails details) {
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
        this.widget.onTapCreateMissionListener?.call(missionModel);
      },
      onSelectionChanged: (CalendarSelectionDetails calendarSelectionDetails) {
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

            this.onClick('onClickSettingItem', {'missionModel': missionModel});
          }
        } else {
          Utility.popupDesktopRightNavigator(context);
        }
      },
      onAppointmentResizeEnd: (AppointmentResizeEndDetails details) async {
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
          missionModel?.end_time = appointment.endTime?.millisecondsSinceEpoch;
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
