import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/config/DimensConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/InnerContainerWidget.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/InnerTitleWidget.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../common/database/apis/MongoApisManager.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CommonCalendarHeaderWidget.dart';
import '../../../components/DashWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/BarModel.dart';
import '../../../models/CalendarModel.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../models/FolderModel.dart';
import '../../../models/FolderModelWithExtraData.dart';
import '../../../models/SessionMissionModel.dart';
import '../../../models/StatsModel.dart';
import '../../../util/StatisticUtility.dart';
import '../chartsComponents/ColumnGradientWidget.dart';
import '../chartsComponents/CompletePlanClassificationChartWidget.dart';
import 'FocusDurationDistributionWidget.dart';
import '../chartsComponents/PriorityDistributionOfCompletionPlayCircleChart.dart';
import 'TitleContainerWidget.dart';
import 'TodayMissionCompleteWidget.dart';

class AllDataWidget extends StatefulWidget {
  double marginTop = 15;
  double margin = 0;
  CalendarTypeEnum calendarTypeEnum;
  CommonCalendarHeaderWidgetController? controller;

  AllDataWidget({Key? key, required this.calendarTypeEnum}) : super(key: key) {
    // startDateTime =
    //     this.startDateTime ?? DateTime.now().subtract(Duration(days: 10 * 365));
    // endDateTime = this.endDateTime ?? DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllDataWidgetState();
  }
}

class AllDataWidgetState extends State<AllDataWidget> {
  DateTime? startDateTime;
  DateTime? endDateTime;

  List<MissionModel>? missionListOriginal;
  FolderModel? curSearchingFocusModel;
  SessionMissionModel? listSessionMissionModelRed1 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelYellow2 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelBlue3 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelGreen4 = SessionMissionModel();

  List<StatsModel> listStatsModel = [];
  List<StatsModel> listStatsModelFinished = []; //用于StatsPage头部的数据
  List<StatsModel> listStatsModelFinishedPrev = []; //用于StatsPage头部的数据
  List<FolderModelWithExtraData> datasFolderModelWithExtraData = [];

  List<CheckButtonStateModel> pcDateButtonList =
      CONSTANTS.getPCDateButtonList(); //pc端右上角日历button
  List<ResourceDeliveryInfoBean> pcRightTopResourceDataList =
      CONSTANTS.getPCRightTopDefaultRessourceData();
  BarModelList dataMissionNumbers = BarModelList(); //用于显示任务数的chart
  BarModelList data = BarModelList();
  BarModelList dataPrev = BarModelList();
  CalendarModel? calendarModel;
  int totalFocusTimeByFolderModelList = 0;
  int focusTimes = 0;
  int numMissionFinished = 0;
  int numMissionToFinished = 0;

  AllDataWidgetState({this.startDateTime, this.endDateTime});

  String getWidgetTitle() {
    switch(this.widget.calendarTypeEnum) {
      case CalendarTypeEnum.all:
        return getI18NKey().title_data(getI18NKey().all);
      case CalendarTypeEnum.last7Days:
        // String year1 = this.startDateTime?.year.toString() ?? "";
        // String month1 = this.startDateTime?.month.toString() ?? "";
        // String day1 = this.startDateTime?.day.toString() ?? "";
        // String year2 = this.endDateTime?.year.toString() ?? "";
        // String month2 = this.endDateTime?.month.toString() ?? "";
        // String day2 = this.endDateTime?.day.toString() ?? "";
        return getI18NKey().title_data(getI18NKey().last_7_days);
      case CalendarTypeEnum.custom:
        String year1 = this.startDateTime?.year.toString() ?? "";
        String month1 = this.startDateTime?.month.toString() ?? "";
        String day1 = this.startDateTime?.day.toString() ?? "";
        String year2 = this.endDateTime?.year.toString() ?? "";
        String month2 = this.endDateTime?.month.toString() ?? "";
        String day2 = this.endDateTime?.day.toString() ?? "";
        return getI18NKey().title_data(getI18NKey().missionModelDate2(year1, month1, day1) + "-" + getI18NKey().missionModelDate2(year2, month2, day2));
      case CalendarTypeEnum.day:
        DateTime dateTimeNow = DateTime.now();
        int year1 = this.endDateTime?.year ?? 0;
        int month1 = this.endDateTime?.month??0;
        int day1 = this.endDateTime?.day??0;
        if (dateTimeNow.year == year1 && dateTimeNow.month == month1 && dateTimeNow.day == dateTimeNow.day) {
          return getI18NKey().today;
        } else {
          return getI18NKey().title_data(
              getI18NKey().missionModelDate2(year1, month1, day1));
        }
      case CalendarTypeEnum.year:
        String year1 = this.startDateTime?.year.toString() ?? "";
        return getI18NKey().title_data(year1);
      case CalendarTypeEnum.month:
        String year1 = this.startDateTime?.year.toString() ?? "";
        // String month1 = this.startDateTime?.month.toString() ?? "";
        return getI18NKey().title_data(getI18NKey().missionModelDate3(year1, Utility.getMonthNameFull(this.startDateTime?.month)));

    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    calendarModel = Provider.of<GlobalStateEnv>(context).calendarModel;

    return Column(
      key: ValueKey('Column_121'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          key: ValueKey('SizedBox_f12'),
          height: DimensConfig.innerItemMargin,
        ),
        InnerTitleWidget(key: ValueKey('SizedBox_f12a'), title: getI18NKey().focus_on_time_period_distribution),
        SizedBox(
          key: ValueKey('12131'),
          height: DimensConfig.innerItemMargin,
        ),
        // ColumnGradientWidget()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   requestDatas();
    // });
  }

  @override
  void didUpdateWidget(AllDataWidget oldWidget) {
    // if(oldWidget.startDateTime != this.startDateTime||oldWidget.endDateTime != this.endDateTime) {
    //   requestDatas();
    // }
  }

  void requestDatas({DateTime? startDateTime, DateTime? endDateTime}) async {
    this.startDateTime = startDateTime;
    // if (this.widget.calendarTypeEnum == CalendarTypeEnum.day) {
    //   this.startDateTime = null; //如果是按日搜索就搜索从今天有多少任务没完成
    // }
    this.endDateTime = endDateTime;
    await Future.wait([
      requestFolderModelsDatas(),
      requestPriorityTasksDatas(),
      // requestBarModelList()
    ]).then((value) {
      setState(() {});
    });
  }

  //  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  Future<int> requestPriorityTasksDatas() async {
    missionListOriginal = await MongoApisManager.getInstance()
        .queryWhereEqual_missionDataByEndTime(
      fid: this.curSearchingFocusModel?.objectId, //todo 这个还没用的上
      start_endTime: startDateTime?.millisecondsSinceEpoch,
      end_endTime: endDateTime?.millisecondsSinceEpoch,
    );
    // missionListForView = Utility.deepClone(missionListOriginal).cast<MissionModel>();

    List<SessionMissionModel>? listSessionMissionModel =
        Utility.getListAfterOrder(
            MissionOrderEnum.orderByPriority, missionListOriginal ?? []);
    filterSessionMissinModelIntoFourParts(listSessionMissionModel ?? []);
    return 0;
  }

  Future<int> requestFolderModelsDatas({bool shouldRefresh = false}) async {
    try {
      // CalendarModel calendarModel = context
      //     .watch<GlobalStateEnv>()
      //     .calendarModel;
      List<FolderModel> datas = await MongoApisManager.getInstance()
          .queryWhereEqual_folderModel(shouldRefresh: shouldRefresh);
      setState(() {
        // List<FolderModel> folderModelList = datas;
        CONSTANTS.folderModelList = datas;

        datasFolderModelWithExtraData = CONSTANTS.getMenuList(datas,
            startDateTime: this.startDateTime,
            endDateTime: this.endDateTime,
            isMobile: screenType == ScreenType.Handset,
            calendarModel: calendarModel ?? CalendarModel(),
            shouldAddDayType: false);
      });
      getTotalFocusTimeByFolderModelList(datasFolderModelWithExtraData);
    } catch (e) {}
    return 0;
  }

  getTotalFocusTimeByFolderModelList(List<FolderModelWithExtraData> datas) {
    totalFocusTimeByFolderModelList = 0;
    focusTimes = 0;
    numMissionFinished = 0;
    numMissionToFinished = 0;
    datas.forEach((FolderModelWithExtraData item) {
      totalFocusTimeByFolderModelList =
          (item.folderTimeModel.finishedTime ?? 0) +
              totalFocusTimeByFolderModelList;
      focusTimes = (item.folderTimeModel.numMissionFinished ?? 0) + focusTimes;
      numMissionFinished =
          (item.folderTimeModel.numMissionFinished ?? 0) + focusTimes;
      numMissionToFinished = (item.folderTimeModel.numMissionToFinished ?? 0) +
          numMissionToFinished;
    });
  }

  // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
  Future<int> requestBarModelList() async {
    DateTime dateTime = DateTime.now();
    //这次完成任务总数
    // DateTime dateTimeStart = Utility.getDateTimeFromTimeStamp(segmentControl ==
    //     1
    //     ? Utility.getFilterDateTimeFromTimeStamp(
    //     dateTime.millisecondsSinceEpoch)
    //     .millisecondsSinceEpoch
    //     : segmentControl == 2
    //     ? Utility.getFilterDateTimeFromTimeStamp(
    //     dateTime.millisecondsSinceEpoch - 7 * 24 * 60 * 60 * 1000)
    //     .millisecondsSinceEpoch
    //     : Utility.getFilterDateTimeFromTimeStamp(
    //     dateTime.millisecondsSinceEpoch - 30 * 24 * 60 * 60 * 1000)
    //     .millisecondsSinceEpoch);
    // DateTime dateTimePrev = Utility.getDateTimeFromTimeStamp(segmentControl == 1
    //     ? (dateTimeStart.millisecondsSinceEpoch - 24 * 60 * 60 * 1000)
    //     : segmentControl == 2
    //     ? (dateTimeStart.millisecondsSinceEpoch - 7 * 24 * 60 * 60 * 1000)
    //     : (dateTimeStart.millisecondsSinceEpoch -
    //     30 * 24 * 60 * 60 * 1000)); //和上周比
    // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
    listStatsModel = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
            start_endTime: startDateTime?.millisecondsSinceEpoch,
            end_endTime: dateTime.millisecondsSinceEpoch); //用于charts数据
    listStatsModelFinished = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
            type: 1,
            start_endTime: startDateTime?.millisecondsSinceEpoch,
            end_endTime: dateTime.millisecondsSinceEpoch); //用于StatsPage头部的数据
    listStatsModelFinishedPrev = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
            type: 1,
            start_endTime: (startDateTime?.millisecondsSinceEpoch ?? 0) -
                ((endDateTime?.millisecondsSinceEpoch ?? 0) -
                    (startDateTime?.millisecondsSinceEpoch ?? 0)),
            end_endTime:
                startDateTime?.millisecondsSinceEpoch); //用于StatsPage头部的数据

    Map<String, BarModelList>? map =
        StatisticUtility.filterStatsModelToBarModel(
            DateTypeEnum.custom, //本月数据
            listStatsModel,
            StatisticTypeEnum.time,
            datetimeStart: startDateTime,
            datetimeEnd: endDateTime);

    Map<String, BarModelList> mapDataMissionNumbers =
        StatisticUtility.filterStatsModelToBarModel(
            DateTypeEnum.custom, //本月数据
            listStatsModelFinished,
            StatisticTypeEnum.number,
            datetimeStart: startDateTime,
            datetimeEnd: endDateTime) ?? {};

    this.data = map?['BarModelList'] ?? BarModelList();
    this.dataPrev = map?['BarModelListPrev'] ?? BarModelList();

    dataMissionNumbers =
        mapDataMissionNumbers['BarModelList'] ?? BarModelList();

    int totalTimePrev =
        Utility.getTotalTime(listBarModel: dataPrev.listBarModel ?? {});
    int totalTime = Utility.getTotalTime(listBarModel: data.listBarModel ?? {});

    int numTomatoes = data.listStatsModel?.length ?? 0;
    int numTomatoesPrev = dataPrev.listStatsModel?.length ?? 0;

    int missionCompleted = listStatsModelFinished.length;
    int missionCompletedPrev = listStatsModelFinishedPrev.length;

    pcRightTopResourceDataList = CONSTANTS.getPCRightTopRessourceData(
        sceneCode: 'wholeComepleteTime',
        totalTimePrev: totalTimePrev,
        totalTime: totalTime,
        numTomatoes: numTomatoes,
        numTomatoesPrev: numTomatoesPrev,
        missionCompleted: missionCompleted,
        missionCompletedPrev: missionCompletedPrev,
        dateTypeEnum: DateTypeEnum.custom); //本月数据
    // setState(() {});
    return 0;
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
}
