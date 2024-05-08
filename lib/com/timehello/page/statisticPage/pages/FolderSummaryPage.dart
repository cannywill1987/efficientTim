import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/DimensConfig.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/page/TimeLinePage/TimeLinePage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CommonCalendarHeaderWidget.dart';
import '../../../components/PCButtonListWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ENUMS.dart';
import '../../../config/Params.dart';
import '../../../models/CalendarModel.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../models/EventFn.dart';
import '../../../models/FolderModel.dart';
import '../../../models/FolderModelWithExtraData.dart';
import '../../../models/MissionModel.dart';
import '../../../models/StatsModel.dart';
import '../../../util/Utility.dart';
import '../components/AllDataWidget.dart';
import '../components/ContainerWidget.dart';
import '../components/FolderSummaryHeaderWidget.dart';
import '../components/SummaryHeaderWidget.dart';
import '../components/TitleContainerWidget.dart';
import '../components/TodayDataWidget.dart';

class FolderSummaryPage extends BaseWidget {
  final FolderModelWithExtraData folderModelWithExtraData;
  final bool shouldShowNav;
  PickerDateRange? dateTimePickerDateRange;

  CalendarTypeEnum calendarTypeEnum = CalendarTypeEnum.last7Days;
   FolderSummaryPage({Key? key, this.calendarTypeEnum = CalendarTypeEnum.last7Days, this.dateTimePickerDateRange, this.shouldShowNav = false, required this.folderModelWithExtraData}): super(key: key);
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return FolderSummaryPageState(calendarTypeEnum: calendarTypeEnum, dateTimePickerDateRange: dateTimePickerDateRange);
  }
}

class FolderSummaryPageState extends BaseWidgetState<FolderSummaryPage> {
  double marginWidget = 5;
  double marginTopWidget = 10;

  // List<MissionModel> listMissionModel;
  List<StatsModel>? listStatsModel;
  List<StatsModel>? listStatsModelPrev;

  List<MissionModel> missionListOriginal = []; //原始数据
  List<MissionModel> missionListForView = []; //用于搜索 和 展示
  CommonCalendarHeaderWidgetController? controller;
  CalendarTypeEnum calendarTypeEnum = CalendarTypeEnum.last7Days;
  PickerDateRange? dateTimePickerDateRange;
  List<CheckButtonStateModel> pcDateButtonList = CONSTANTS
      .getCommonCalendarPCDateButtonList(hasAll: true); //pc端右上角日历button
  FolderModel? curSearchingFocusModel;
  GlobalKey<TodayDataWidgetState>? TodayDataWidgetGlobalKey = GlobalKey();
  GlobalKey<AllDataWidgetState> AllDataWidgetGlobalKey = GlobalKey();
  GlobalKey<FolderSummaryHeaderWidgetState>? SummaryHeaderWidgetGlobalKey = GlobalKey();
  GlobalKey<TimeLinePageState> TimeLinePageStateGlobalKey = GlobalKey();


  FolderSummaryPageState({required this.calendarTypeEnum, this.dateTimePickerDateRange});

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build

    return ColoredBox(
      color: ThemeManager.getInstance().getBackgroundColor(defaultColor: ColorsConfig.chartBgColor),
      child: ListView(
        cacheExtent: 10000,
        children: [
          SizedBox(
            height: marginWidget,
          ),
          // 头部
          ContainerWidget(
            child: FolderSummaryHeaderWidget(
              key: SummaryHeaderWidgetGlobalKey,
              calendarTypeEnum: this.calendarTypeEnum, folderModelWithExtraData: this.widget.folderModelWithExtraData,
              // listMissionModel: missionListOriginal,
              // listStatsModel: listStatsModel ?? [],
              // listStatsModelPrev: listStatsModelPrev ?? [],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: DimensConfig.chartItemPadding),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CommonCalendarHeaderWidget(
                    controller: controller,
                    dateTimePickerDateRangeCustom: dateTimePickerDateRange,
                    calendarTypeEnum: calendarTypeEnum,
                    onChange: (data) {
                      dateTimePickerDateRange = data;
                      requestDatas();
                    }),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    // ListingFilterWidget(onTapListener: (data) {
                    //   this.curSearchingFocusModel = data;
                    //   this.requestDatas();
                    // }),
                    SizedBox(
                      width: 4,
                    ),
                    // 右上角Pc端按钮列表
                    PCButtonListWidget(
                      shouldShowPopupWhenPC: true,
                      initIndex: calendarTypeEnum.index,
                      list: pcDateButtonList,
                      onTapListener: (data) {
                        int index = data['index'];
                        if (CalendarTypeEnum.all.index == index) {
                          controller?.dateTimePicker = null;
                        }
                        calendarTypeEnum = CalendarTypeEnum.values[index];
                        // setState(() {});
                        this.onClick("onClickSegmentControl", index);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          if(this.widget.folderModelWithExtraData.folderModel.tag != 2)
          SizedBox(
            height: marginWidget,
          ),
          if(this.widget.folderModelWithExtraData.folderModel.tag != 2)
          Container(
            height: 200,
            child: ContainerWidget(
              paddingTop: 0,
              paddingBottom: 0,
              child: Column(children: [
                TitleContainerWidget(
                  title: Utility.isHuaWei() ? getI18NKey().tasks_list: getI18NKey().timeline,
                ),
                Container(
                    width: double.infinity,
                    height: 2,
                    color: ColorsConfig.borderLineColor),
                //时间轴
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child:TimeLinePage(
                        key: TimeLinePageStateGlobalKey,
                        folderObjectId: this.widget.folderModelWithExtraData.folderModel.objectId ?? "",
                        timelinePageFromEnum:
                            TimelinePageFromEnum.FolderStatisticPage.index)))
              ]),
            ),
          ),
          SizedBox(
            height: marginWidget,
          ),
          ContainerWidget(
            paddingTop: 0,
            child: TodayDataWidget(
              key: TodayDataWidgetGlobalKey,
              folderModelWithExtraData: this.widget.folderModelWithExtraData,
              folderId: this.widget.folderModelWithExtraData.folderModel.objectId,
              calendarTypeEnum: this.calendarTypeEnum,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isAppBarVisible = this.widget.shouldShowNav;
    controller = CommonCalendarHeaderWidgetController();
    controller?.dateTimePicker = dateTimePickerDateRange;
  }

  componentDidMount() {
    eventBus.on<EventFn>().listen((EventFn event) {
      if (event.type == Params.ACTION_UPDATE_LISTVIEW ) {
        this.requestDatas();
      }
    });
    this.requestDatas();
  }

  @override
  void dispose() {
    // Keys.TodayDataWidgetGlobalKey = null;
    // Keys.SummaryHeaderWidgetGlobalKey = null;
    // Keys.TimeLinePageStateGlobalKey = null;
    super.dispose();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSegmentControl':
        this.onClickSegmentControl(data);
        break;
    }
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
  }

//  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  requestDatas() async {
    // updateUI();
    // Future.delayed(Duration(milliseconds: 500), () {
    //底部今日数据请求
    await TodayDataWidgetGlobalKey!.currentState?.requestDatas(
        calendarTypeEnum: this.calendarTypeEnum,
        startDateTime: controller?.dateTimePicker?.startDate,
        endDateTime: controller?.dateTimePicker?.endDate);
    //头部请求
    await SummaryHeaderWidgetGlobalKey!.currentState?.requestDatas(
        startDateTime: controller?.dateTimePicker?.startDate,
        endDateTime: controller?.dateTimePicker?.endDate);
    //时间轴请求
    await TimeLinePageStateGlobalKey!.currentState?.requestDatas(
        startDateTime: controller?.dateTimePicker?.startDate,
        endDateTime: controller?.dateTimePicker?.endDate);
    if(mounted == true) {
      setState(() {});
    }
    // Keys.AllDataWidgetGlobalKey.currentState?.requestDatas(
    //     startDateTime: controller?.dateTimePicker?.startDate,
    //     endDateTime: controller?.dateTimePicker?.endDate);
    // if (mounted) {
    //   updateUI();
    // }
    // });
  }
}
