import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/common/provider/CalendarMssionEnv.dart';
import 'package:time_hello/com/timehello/components/CustomBlackButton.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/ListingFilterWidget.dart';
import 'package:time_hello/com/timehello/components/TimeRatioComponent.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../../common/database/apis/MongoApisManager.dart';
import '../../components/BaseWidget.dart';
import '../../components/BlackCheckButtonListWidget.dart';
import '../../components/CircleWidget.dart';
import '../../components/CommonCalendarHeaderWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../components/ExportMissionListDialogUtil.dart';
import '../../components/PCButtonListWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/Params.dart';
import '../../models/CalendarModel.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../models/EventFn.dart';
import '../../models/FolderModel.dart';
import '../../models/MissionModel.dart';
import '../../models/SessionMissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/SharePreferenceUtil.dart';
import '../../util/ThemeManager.dart';
import '../../util/Utility.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import 'components/QuadrantWidget.dart';
import '../../components/SearchBarWidget.dart';

class FourQuadrantPage extends BaseWidget {
  const FourQuadrantPage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return FourQuadrantPageState();
  }
}

class FourQuadrantPageState extends BaseWidgetState<FourQuadrantPage> {
  SessionMissionModel? listSessionMissionModelRed1;
  SessionMissionModel? listSessionMissionModelYellow2;
  SessionMissionModel? listSessionMissionModelBlue3;
  SessionMissionModel? listSessionMissionModelGreen4;
  List<MissionModel> missionListOriginal = []; //原始数据
  List<MissionModel> missionListForView = []; //用于搜索 和 展示
  List<CheckButtonStateModel> pcDateButtonList = CONSTANTS
      .getCommonCalendarPCDateButtonList(hasAll: true); //pc端右上角日历button
  CalendarModel? calendarModel;
  CalendarTypeEnum calendarTypeEnum = CalendarTypeEnum.all;
  PickerDateRange? dateTimePickerDateRange;
  CommonCalendarHeaderWidgetController? controller;

  FolderModel? curSearchingFocusModel;
  GlobalKey quadrantWidgetGlobalKey = GlobalKey();
  GlobalKey<QuadrantWidgetState> quadrantWidgetGlobalKey1 = GlobalKey();
  GlobalKey<QuadrantWidgetState> quadrantWidgetGlobalKey2 = GlobalKey();
  GlobalKey<QuadrantWidgetState> quadrantWidgetGlobalKey3 = GlobalKey();
  GlobalKey<QuadrantWidgetState> quadrantWidgetGlobalKey4 = GlobalKey();
  int curIndex = 1;

  DateTime? startDateTime;
  DateTime? endDateTime;
  double missionPageWidth = 300;

  selectDate(DateTime? startDateTime, DateTime? endDateTime) {
    this.startDateTime = startDateTime;
    this.endDateTime = endDateTime;
    if (this.startDateTime == null && this.endDateTime == null) {
      controller?.dateTimePicker = null;
    } else {
      controller?.dateTimePicker =
          PickerDateRange(this.startDateTime, this.endDateTime);
    }
    this.requestDatas();
  }

  @override
  void initState() {
    super.initState();
    isAppBarVisible = false;
    controller = CommonCalendarHeaderWidgetController();
    // SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.fourquadrantVisible, value: this.curIndex);
    this.curIndex = SharePreferenceUtil.getSyncInstance()
        .getInt(key: ShareprefrenceKeys.fourquadrantVisible, defaultVal: 1);
    this.requestDatas();
  }

  componentDidMount() {
    eventBus.on<EventFn>().listen((EventFn event) {
      if (event.type == Params.ACTION_UPDATE_LISTVIEW) {
        this.requestDatas();
      }
    });
  }

  //  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  requestDatas() async {
    Future<void> _request() async {
      missionListOriginal = await MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByEndTime(
        fid: this.curSearchingFocusModel?.objectId,
        start_endTime:
            controller?.dateTimePicker?.startDate?.millisecondsSinceEpoch,
        end_endTime:
            controller?.dateTimePicker?.endDate?.millisecondsSinceEpoch,
      );
      missionListForView = missionListOriginal;
      // missionListForView = Utility.deepClone(missionListOriginal).cast<MissionModel>();

      List<SessionMissionModel>? listSessionMissionModel =
          Utility.getListAfterOrder(
              MissionOrderEnum.orderByPriority, missionListOriginal);
      filterSessionMissinModelIntoFourParts(listSessionMissionModel ?? []);
      if (mounted) {
        updateUI();
      }
    }

    _request();
    // //待定 还没设定时间的
    // Utility.throttle(() async {
    // })();
  }

  filterSessionMissinModelIntoFourParts(
      List<SessionMissionModel> listSessionMissionModel) {
    listSessionMissionModelRed1 = getListSessionMissionModel(
        getI18NKey().priority1, listSessionMissionModel);
    listSessionMissionModelYellow2 = getListSessionMissionModel(
        getI18NKey().priority2, listSessionMissionModel);
    listSessionMissionModelBlue3 = getListSessionMissionModel(
        getI18NKey().priority3, listSessionMissionModel);
    listSessionMissionModelGreen4 = getListSessionMissionModel(
        getI18NKey().priority4, listSessionMissionModel);
    //同步四象限桌面widget
    CounterMethodChannelManager.getInstance().storeMissionDataList([
      listSessionMissionModelRed1 ??
          SessionMissionModel(
              title: getI18NKey().four_quadrant_priority1_abbr, datas: []),
      listSessionMissionModelYellow2 ??
          SessionMissionModel(
              title: getI18NKey().four_quadrant_priority2_abbr, datas: []),
      listSessionMissionModelBlue3 ??
          SessionMissionModel(
              title: getI18NKey().four_quadrant_priority3_abbr, datas: []),
      listSessionMissionModelGreen4 ??
          SessionMissionModel(
              title: getI18NKey().four_quadrant_priority4_abbr, datas: [])
    ]);
  }

  SessionMissionModel? getListSessionMissionModel(
      String key, List<SessionMissionModel> listSessionMissionModel) {
    for (int i = 0; i < listSessionMissionModel.length; i++) {
      SessionMissionModel sessionMissionModel = listSessionMissionModel[i];
      if (sessionMissionModel.title == key) {
        return sessionMissionModel;
      }
    }
    return null;
  }

  @override
  void didUpdateWidget(FourQuadrantPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    //todo 这里可以优化 否则会请求几遍 但是通过 this._folderModelObjId == this.widget.folderModel?.objectId有点问题
    // this.requestDatas();
    // context.watch();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSearch':
        this.onClickSearch(data);
        break;
      case 'onClickSegmentControl':
        this.onClickSegmentControl(data);
        break;
      case 'onRefreshListener':
        this.onRefreshListener(data);
        break;
    }
  }

  void onRefreshListener(MissionModel missionMdeo) {
    requestDatas();
  }

  void onClickSegmentControl(index) {
    // switch (index) {
    //   case 0:
    //     this.calendarTypeEnum = CalendarTypeEnum.day;
    //     break;
    //   case 1:
    //     this.calendarTypeEnum = CalendarTypeEnum.month;
    //     break;
    //   case 2:
    //     this.calendarTypeEnum = CalendarTypeEnum.year;
    //     break;
    //   case 3:
    //     this.calendarTypeEnum = CalendarTypeEnum.all;
    //     break;
    //   case 4:
    //     this.calendarTypeEnum = CalendarTypeEnum.custom;
    //     break;
    // }
    requestDatas();
    // updateUI();
  }

  void onClickSearch(wordSearch) {
    if (TextUtil.isEmpty(wordSearch) != true) {
      missionListForView =
          Utility.filterMissionModel(wordSearch, missionListOriginal);
      List<SessionMissionModel>? listSessionMissionModel =
          Utility.getListAfterOrder(
              MissionOrderEnum.orderByPriority, missionListForView);
      filterSessionMissinModelIntoFourParts(listSessionMissionModel ?? []);
      updateUI();
    } else {
      this.requestDatas();
    }
  }

  @override
  void dispose() {
    // Keys.QuadrantWidgetGlobalKey = GlobalKey();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    double innerMargin = Utility.isHandsetBySize() ? 10 : 20.0;
    // TODO: implement build
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      this.missionPageWidth = constraints.maxWidth;
      return Stack(
        children: [
          Container(
              key: quadrantWidgetGlobalKey,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomMarquee(
                    paddingHor: 0,
                    paddingTop: 0,
                    bean: MarqueInfo.marqueFourQuadrantPage,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // 搜索框
                  SearchBarWidget(
                      lastWidget: CustomPopupWidget(
                        onSelected: (CheckButtonStateModel model) {
                          if(model.code == 'export') {
                            onClickExport(context);
                          } else if (model.code == 'visibility') {
                            onClickChangeVisibility(curIndex == 1 ? 0 :1);

                          }
                        },
                        list: CONSTANTS.getFourQuadrantButtonList(),
                        child: Icon(
                          Icons.more_horiz,
                          color: Color(0xff999999),
                        ),
                      ),
                      onChangeListener: (val) {
                        this.onClick('onClickSearch', val);
                      }),
                  SizedBox(
                    //头部
                    height: 5,
                  ),
                  TimeRatioComponent(
                      scene: "FourQuadrantPage",
                      firstChild:         this.calendarTypeEnum == CalendarTypeEnum.custom ?
          CommonCalendarHeaderWidget(
          controller: controller,
          calendarTypeEnum: calendarTypeEnum,
          onChange: (data) {
            dateTimePickerDateRange = data;
            requestDatas();
          }):null,
                      progressSortEnum: ProgressSortEnum.priority,
                      lastChild: getListingWidget(context),
                      width: this.missionPageWidth,
                      startTime: this.startDateTime,
                      endTime: this.endDateTime,
                      height: 5,
                      // totalTime: 24 * 60 * 60, // 一天的总秒数
                      listMissionModels: this.missionListForView
                      // [
                      //   TimeSegment(label: 'Segment 1', value: 1* 60 * 60, color: Colors.red, totalValue: 2 * 60 * 60, onTap: () => print("Segment 1 clicked")),
                      //   TimeSegment(label: 'Segment 2', value: 1* 60 * 60, color: Colors.orange, totalValue: 3 * 60 * 60, onTap: () => print("Segment 2 clicked")),
                      //   TimeSegment(label: 'Segment 3', value: 1* 60 * 60, color: Colors.yellow, totalValue: 5 * 60 * 60, onTap: () => print("Segment 3 clicked")),
                      //   TimeSegment(label: 'Segment 4', value: 1* 60 * 60, color: Colors.green, totalValue: 4 * 60 * 60, onTap: () => print("Segment 4 clicked")),
                      //   TimeSegment(label: 'Segment 5', value: 1* 60 * 60, color: Colors.blue, totalValue: 10 * 60 * 60, onTap: () => print("Segment 5 clicked")),
                      // ],
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: QuadrantWidget(
                          key: quadrantWidgetGlobalKey1,
                          isHeaderVisible: this.curIndex == 1,
                          quadrantWidgetGlobalKey: this.quadrantWidgetGlobalKey,
                          onRefresh: () {
                            this.requestDatas();
                          },
                          onRefreshListener: (missionModel) {
                            this.onClick("onRefreshListener", missionModel);
                          },
                          listMissionModelsFinished:
                              Utility.getMissionModelFinished(
                                  listSessionMissionModelRed1?.datas ?? []),
                          listMissionModelsUnfinished:
                              Utility.getMissionModelUnfinished(
                                  listSessionMissionModelRed1?.datas ?? []),
                          priorityEnum: PriorityEnum.red1,
                          title: getI18NKey().four_quadrant_priority1,
                          desc: getI18NKey().four_quadrant_priority1_desc,
                          onDragingListener: onDragingListener,
                          onDragEndListener: resetBorder,
                        ),
                      )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: QuadrantWidget(
                          key: quadrantWidgetGlobalKey2,
                          isHeaderVisible: this.curIndex == 1,
                          quadrantWidgetGlobalKey: this.quadrantWidgetGlobalKey,
                          onRefreshListener: (missionModel) {
                            this.onClick("onRefreshListener", missionModel);
                          },
                          onRefresh: () {
                            this.requestDatas();
                          },
                          listMissionModelsFinished:
                              Utility.getMissionModelFinished(
                                  listSessionMissionModelYellow2?.datas ?? []),
                          listMissionModelsUnfinished:
                              Utility.getMissionModelUnfinished(
                                  listSessionMissionModelYellow2?.datas ?? []),
                          priorityEnum: PriorityEnum.yellow2,
                          title: getI18NKey().four_quadrant_priority2,
                          desc: getI18NKey().four_quadrant_priority2_desc,
                          onDragingListener: onDragingListener,
                          onDragEndListener: resetBorder,
                        ),
                      )),
                    ],
                  )),
                  SizedBox(
                    height: innerMargin,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 5),
                          child: QuadrantWidget(
                            key: quadrantWidgetGlobalKey3,
                            isHeaderVisible: this.curIndex == 1,
                            quadrantWidgetGlobalKey:
                                this.quadrantWidgetGlobalKey,
                            onRefreshListener: (missionModel) {
                              this.onClick("onRefreshListener", missionModel);
                            },
                            onRefresh: () {
                              this.requestDatas();
                            },
                            listMissionModelsFinished:
                                Utility.getMissionModelFinished(
                                    listSessionMissionModelBlue3?.datas ?? []),
                            listMissionModelsUnfinished:
                                Utility.getMissionModelUnfinished(
                                    listSessionMissionModelBlue3?.datas ?? []),
                            priorityEnum: PriorityEnum.blue3,
                            title: getI18NKey().four_quadrant_priority3,
                            desc: getI18NKey().four_quadrant_priority3_desc,
                            onDragingListener: onDragingListener,
                            onDragEndListener: resetBorder,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          child: QuadrantWidget(
                            key: quadrantWidgetGlobalKey4,
                            isHeaderVisible: this.curIndex == 1,
                            quadrantWidgetGlobalKey:
                                this.quadrantWidgetGlobalKey,
                            onRefreshListener: (missionModel) {
                              this.onClick("onRefreshListener", missionModel);
                            },
                            onRefresh: () {
                              this.requestDatas();
                            },
                            listMissionModelsFinished:
                                Utility.getMissionModelFinished(
                                    listSessionMissionModelGreen4?.datas ?? []),
                            listMissionModelsUnfinished:
                                Utility.getMissionModelUnfinished(
                                    listSessionMissionModelGreen4?.datas ?? []),
                            priorityEnum: PriorityEnum.green4,
                            title: getI18NKey().four_quadrant_priority4,
                            desc: getI18NKey().four_quadrant_priority4_desc,
                            onDragingListener: onDragingListener,
                            onDragEndListener: resetBorder,
                          ),
                        ),
                      )
                    ],
                  )),
                  SizedBox(
                    height: innerMargin,
                  ),
                ],
              )),
          Positioned(
              bottom: 30,
              right: 20,
              child: CircleWidget(
                onTapListener: (obj) {
                  MissionModel missionModel = MissionModel();
                  missionModel.end_time = CONSTANTS.getDeadLineTme((0) + 1);

                  if (Utility.isHandsetBySize() == true) {
                    Utility.pushNavigator(
                        context, CreateMissionPage(missionModel: missionModel));
                  } else {
                    DialogManagement.getInstance().showPCCustomDialog(
                        context: context,
                        widget: CreateMissionPage(missionModel: missionModel));
                  }
                },
              ))
        ],
      );
    });
  }

  Widget getListingWidget(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        // BlackCheckButtonListWidget(
        //   // backgroundColor: ThemeManager.getInstance().getCardBackgroundColor(),
        //   // key: blackCheckButtonListWidgetGlobalKey,
        //   initIndex: curIndex,
        //   list: CONSTANTS.getVisibleButtonList(),
        //   onTapListener: (index) async {
        //     onClickChangeVisibility(index);
        //   },
        // ),
        SizedBox(
          width: 10,
        ),
        // 导出
        // GestureDetector(
        //   onTap: () {
        //     onClickExport(context);
        //     // Utility.getContentFromMissionList(datas: this.missionListOriginal, listCheckButtonModel: CONSTANTS.getMi);
        //   },
        //   child: CustomBlackButton(
        //     text: getI18NKey().export,
        //     color: ThemeManager.getInstance()
        //         .getTextColor(defaultColor: Colors.red),
        //   ),
        // ),

        SizedBox(
          width: 4,
        ),

        // 右上角Pc端按钮列表
        if (Utility.isHandsetBySize())
          PCButtonListWidget(
            initIndex: calendarTypeEnum.index,
            list: pcDateButtonList,
            onTapListener: (data) {
              int index = data['index'];
              if (CalendarTypeEnum.all.index == index) {
                controller?.dateTimePicker = null;
                // dateTimePickerDateRange = null;
              }
              this.calendarTypeEnum = CalendarTypeEnum.values[index];
              this.onClick("onClickSegmentControl", index);
            },
          ),
        ListingFilterWidget(onTapListener: (data) {
          this.curSearchingFocusModel = data;
          context.read<CalendarMssionEnv>().curSelectedFolderModel = data;
          this.requestDatas();
        }),
      ],
    );
  }

  void onClickChangeVisibility(index) {
                  this.curIndex = index;
    SharePreferenceUtil.getSyncInstance().setInt(
        key: ShareprefrenceKeys.fourquadrantVisible,
        value: this.curIndex);
    setState(() {});
  }

  void onClickExport(BuildContext context) {
            TextEditingController textEditingController =
        TextEditingController();
    String s = Utility.getContentFromMissionList(
        datas: this.missionListForView,
        listCheckButtonModel: CONSTANTS.getExportButtonsList());
    textEditingController.text = s;
    ExportMissionListDialogUtil.show(context,
        textEditingController: textEditingController,
        onTapListener: (res) {
      List<CheckButtonStateModel> data = res['data'];
      MissionOrderEnum missionOrderEnum = res['enum'];
      String s = Utility.getContentFromMissionList(
          datas: Utility.getMissionModelListAfterOrder(
              missionOrderEnum, this.missionListForView),
          listCheckButtonModel: data);
      textEditingController.text = s;
      updateUI();
    }, export: (data) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().offer_next_version);
    });
  }

  resetBorder() {
    quadrantWidgetGlobalKey1.currentState?.hideBorder();
    quadrantWidgetGlobalKey2.currentState?.hideBorder();
    quadrantWidgetGlobalKey3.currentState?.hideBorder();
    quadrantWidgetGlobalKey4.currentState?.hideBorder();
  }

  onDragingListener(index) {
    print(index);
    if (index == 1) {
      quadrantWidgetGlobalKey1.currentState?.showBorder();
      quadrantWidgetGlobalKey2.currentState?.hideBorder();
      quadrantWidgetGlobalKey3.currentState?.hideBorder();
      quadrantWidgetGlobalKey4.currentState?.hideBorder();
    } else if (index == 2) {
      quadrantWidgetGlobalKey1.currentState?.hideBorder();
      quadrantWidgetGlobalKey2.currentState?.showBorder();
      quadrantWidgetGlobalKey3.currentState?.hideBorder();
      quadrantWidgetGlobalKey4.currentState?.hideBorder();
    } else if (index == 3) {
      quadrantWidgetGlobalKey1.currentState?.hideBorder();
      quadrantWidgetGlobalKey2.currentState?.hideBorder();
      quadrantWidgetGlobalKey3.currentState?.showBorder();
      quadrantWidgetGlobalKey4.currentState?.hideBorder();
    } else if (index == 4) {
      quadrantWidgetGlobalKey1.currentState?.hideBorder();
      quadrantWidgetGlobalKey2.currentState?.hideBorder();
      quadrantWidgetGlobalKey3.currentState?.hideBorder();
      quadrantWidgetGlobalKey4.currentState?.showBorder();
    }
  }
}
