import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/CustomMissionSilverWidget.dart';
import 'package:time_hello/com/timehello/components/PrioriyColorsGridViewWidget.dart';
import 'package:time_hello/com/timehello/config/DimensConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/InnerContainerWidget.dart';
import 'package:time_hello/com/timehello/page/statisticPage/components/InnerTitleWidget.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
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
import '../../../util/ThemeManager.dart';
import '../chartsComponents/ColumnGradientWidget.dart';
import '../chartsComponents/CompletePlanClassificationChartWidget.dart';
import '../chartsComponents/CompletionPercentRadialBarWidget.dart';
import '../chartsComponents/DelayUncompletePlanClassificationChartWidget.dart';
import 'FocusDurationDistributionWidget.dart';
import '../chartsComponents/PriorityDistributionOfCompletionPlayCircleChart.dart';
import 'TitleContainerWidget.dart';
import 'TodayMissionCompleteWidget.dart';

class TodayDataWidget extends StatefulWidget {
  double marginTop = 15;
  double margin = 0;
  CalendarTypeEnum calendarTypeEnum;
  CommonCalendarHeaderWidgetController? controller;
  FolderModelWithExtraData? folderModelWithExtraData;
  String? folderId;

  TodayDataWidget(
      {Key? key,
      required this.calendarTypeEnum,
      this.folderId,
      this.folderModelWithExtraData})
      : super(key: key) {
    // startDateTime =
    //     this.startDateTime ?? DateTime.now().subtract(Duration(days: 10 * 365));
    // endDateTime = this.endDateTime ?? DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodayDataWidgetState(calendarTypeEnum: calendarTypeEnum);
  }
}

class TodayDataWidgetState extends State<TodayDataWidget> {
  DateTime? startDateTime;
  DateTime? endDateTime;
  List<MissionModel> listCurPrioriyMissionModels = [];
  List<MissionModel> listCurPrioriyMissionModelsPercentage = [];
  int curListCurPrioriyMissionModelsIndex = 0;
  int curListCurPrioriyMissionModelsPercentageIndex = 0;
  List<MissionModel>? missionListOriginal;
  FolderModel? curSearchingFocusModel; //感觉用不上
  SessionMissionModel? listSessionMissionModelRed1 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelYellow2 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelBlue3 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelGreen4 = SessionMissionModel();

  List<StatsModel> listStatsModel = [];
  List<StatsModel> listStatsModelFinished = []; //用于StatsPage头部的数据
  List<StatsModel> listStatsModelFinishedPrev = []; //用于StatsPage头部的数据
  List<FolderModelWithExtraData> datasFolderModelWithExtraData = [];
  List<FolderModelWithExtraData> datasFolderModelDelayWithExtraData = [];

  List<CheckButtonStateModel> pcDateButtonList =
      CONSTANTS.getPCDateButtonList(); //pc端右上角日历button
  List<ResourceDeliveryInfoBean> pcRightTopResourceDataList =
      CONSTANTS.getPCRightTopDefaultRessourceData();
  BarModelList dataMissionNumbers = BarModelList(); //用于显示任务数的chart
  BarModelList dataBarModelList = BarModelList();
  BarModelList dataBarModelListPrev = BarModelList();
  CalendarModel? calendarModel;
  int totalFocusTimeByFolderModelList = 0;
  int focusTimes = 0;
  int numMissionFinished = 0;
  int numMissionToFinished = 0;
  late Map<String, BarModelList> mapDataMissionNumbersNumbers;
  late Map<String, BarModelList> mapDataMissionNumbersTimes;
  CompleteStatusEnum priorityCompleteStatusEnum = CompleteStatusEnum.unfinished;
  CompleteStatusEnum completePlanStatusEnum = CompleteStatusEnum.unfinished;
  CompleteStatusEnum completionPercentRadialBarEnum =
      CompleteStatusEnum.unfinished;
  List<CheckButtonStateModel> listCurPrioriyCheckModel =
      CONSTANTS.getPriorityList();
  List<CheckButtonStateModel> listCurPercentagePrioriyCheckModel =
      CONSTANTS.getPriorityList();
  CalendarTypeEnum calendarTypeEnum;
  bool isFirstTime = false;

  TodayDataWidgetState(
      {required this.calendarTypeEnum, this.startDateTime, this.endDateTime});

  String getWidgetTitle() {
    switch (this.calendarTypeEnum) {
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
        return getI18NKey().title_data(
            getI18NKey().missionModelDate2(year1, month1, day1) +
                "-" +
                getI18NKey().missionModelDate2(year2, month2, day2));
      case CalendarTypeEnum.day:
        DateTime dateTimeNow = DateTime.now();
        int year1 = this.endDateTime?.year ?? 0;
        int month1 = this.endDateTime?.month ?? 0;
        int day1 = this.endDateTime?.day ?? 0;
        if (dateTimeNow.year == year1 &&
            dateTimeNow.month == month1 &&
            dateTimeNow.day == dateTimeNow.day) {
          return getI18NKey().today;
        } else {
          return getI18NKey()
              .title_data(getI18NKey().missionModelDate2(year1, month1, day1));
        }
      case CalendarTypeEnum.year:
        String year1 = this.startDateTime?.year.toString() ?? "";
        return getI18NKey().title_data(year1);
      case CalendarTypeEnum.month:
        String year1 = this.startDateTime?.year.toString() ?? "";
        // String month1 = this.startDateTime?.month.toString() ?? "";
        return getI18NKey().title_data(getI18NKey().missionModelDate3(
            year1, Utility.getMonthNameFull(this.startDateTime?.month)));
    }
  }

  setCurIndexOflistCurPrioriyCheckModelPercentage(int index) {
    this.curListCurPrioriyMissionModelsPercentageIndex = index;
    for (int i = 0; i < listCurPercentagePrioriyCheckModel.length; i++) {
      CheckButtonStateModel model = listCurPercentagePrioriyCheckModel[i];
      model.isCheck = i == index;
    }
    switch (index) {
      case 3:
        this.listCurPrioriyMissionModelsPercentage =
            this.listSessionMissionModelRed1?.datas ?? [];
        break;
      case 2:
        this.listCurPrioriyMissionModelsPercentage =
            this.listSessionMissionModelYellow2?.datas ?? [];
        break;
      case 1:
        this.listCurPrioriyMissionModelsPercentage =
            this.listSessionMissionModelBlue3?.datas ?? [];
        break;
      default:
        this.listCurPrioriyMissionModelsPercentage =
            this.listSessionMissionModelGreen4?.datas ?? [];
    }
  }

  /**
   * 未完成计划优先级分布
   */
  setCurIndexOflistCurPrioriyCheckModel(int index) {
    this.curListCurPrioriyMissionModelsIndex = index;
    for (int i = 0; i < listCurPrioriyCheckModel.length; i++) {
      CheckButtonStateModel model = listCurPrioriyCheckModel[i];
      model.isCheck = i == index;
    }
    switch (index) {
      case 0:
        this.listCurPrioriyMissionModels = Utility.getFinishListMissionModels(
            this.listSessionMissionModelRed1?.datas ?? [],
            this.priorityCompleteStatusEnum == CompleteStatusEnum.finished);
        break;
      case 1:
        this.listCurPrioriyMissionModels = Utility.getFinishListMissionModels(
            this.listSessionMissionModelYellow2?.datas ?? [],
            this.priorityCompleteStatusEnum == CompleteStatusEnum.finished);
        break;
      case 2:
        this.listCurPrioriyMissionModels = Utility.getFinishListMissionModels(
            this.listSessionMissionModelBlue3?.datas ?? [],
            this.priorityCompleteStatusEnum == CompleteStatusEnum.finished);
        break;
      default:
        this.listCurPrioriyMissionModels = Utility.getFinishListMissionModels(
            this.listSessionMissionModelGreen4?.datas ?? [],
            this.priorityCompleteStatusEnum == CompleteStatusEnum.finished);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // calendarModel = Provider.of<GlobalStateEnv>(context).calendarModel;

    return Selector<GlobalStateEnv, CalendarModel>(
        selector: (_, globalStateEnv) => globalStateEnv.calendarModel,
        builder: (_, listFlomoMissionModel, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleContainerWidget(
                title: getWidgetTitle(),
              ),
              Container(
                  width: double.infinity,
                  height: 2,
                  color: ThemeManager.getInstance().getCardBackgroundColor(
                      defaultColor: ColorsConfig.borderLineColor)),
              SizedBox(
                height: this.widget.marginTop,
              ),
              Row(
                children: [
                  // 头部完成计划书
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () async {
                        List<MissionModel> missionListOriginal =
                            await MongoApisManager.getInstance()
                                .queryWhereEqual_missionDataByEndTime(
                          //todo 这个还没用的上
                          start_endTime: startDateTime?.millisecondsSinceEpoch,
                          end_endTime: endDateTime?.millisecondsSinceEpoch,
                        );
                        DialogManagement.getInstance().showMissionListDialog(
                            context,
                            list: missionListOriginal);
                      },
                      child: InnerContainerWidget(
                        paddingTop: 0,
                        paddingBottom: 0,
                        colorShadowEnum: ColorShadowEnum.orange,
                        title: getI18NKey().num_tasks_finished,
                        child: TodayMissionCompleteWidget(
                          numMissionFinished: numMissionFinished.toString(),
                          percentCompareWithTomorrow: Utility.getPercentByDN(
                              nominator: numMissionFinished.toDouble(),
                              denominator:
                                  (numMissionFinished + numMissionToFinished)
                                      .toDouble()),
                          numMissionToFinished:
                              (numMissionFinished + numMissionToFinished)
                                  .toString(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: this.widget.margin,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        List<MissionModel> missionListOriginal =
                            await MongoApisManager.getInstance()
                                .queryWhereEqual_missionDataByEndTime(
                          //todo 这个还没用的上
                          start_endTime: startDateTime?.millisecondsSinceEpoch,
                          end_endTime: endDateTime?.millisecondsSinceEpoch,
                        );
                        DialogManagement.getInstance().showMissionListDialog(
                            context,
                            list: missionListOriginal);
                      },
                      child: InnerContainerWidget(
                        paddingTop: 0,
                        paddingBottom: 0,
                        colorShadowEnum: ColorShadowEnum.orange,
                        title: getI18NKey().completion_rate,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Utility.getPercentByDN(
                                  nominator: numMissionFinished.toDouble(),
                                  denominator: (numMissionFinished +
                                          numMissionToFinished)
                                      .toDouble()),
                              style: TextStyle(
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor:
                                              ColorsConfig.chartTextColor),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              // 圆形的优先级排列
              InnerTitleWidget(
                title: priorityCompleteStatusEnum == CompleteStatusEnum.finished
                    ? getI18NKey().priority_distribution_of_completion_plan
                    : getI18NKey().priority_distribution_of_uncompletion_plan,
                child: BlackCheckButtonListWidget(
                  initIndex: priorityCompleteStatusEnum.index,
                  list: CONSTANTS.getCompleteButtonList(),
                  onTapListener: (obj) async {
                    priorityCompleteStatusEnum = CompleteStatusEnum.values[obj];
                    setCurIndexOflistCurPrioriyCheckModel(
                        this.curListCurPrioriyMissionModelsIndex);
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              Utility.isHandsetBySize()
                  ? GestureDetector(
                      onTap: () {
                        DialogManagement.getInstance().showMissionListDialog(
                            context,
                            prioriy: this.curListCurPrioriyMissionModelsIndex,
                            list: [
                              ...(this.listSessionMissionModelRed1?.datas ??
                                  []),
                              ...(this.listSessionMissionModelGreen4?.datas ??
                                  []),
                              ...(this.listSessionMissionModelYellow2?.datas ??
                                  []),
                              ...(this.listSessionMissionModelBlue3?.datas ??
                                  [])
                            ]);
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child:
                              buildPriorityDistributionOfCompletionPlayCircleChart()))
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildPriorityDistributionOfCompletionPlayCircleChart(),
                        SizedBox(
                          width: Utility.isHandsetBySize() ? 20 : 50,
                        ),
                        Expanded(
                          child: Container(
                              height: 260,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      child: PrioriyColorsGridViewWidget(
                                        onTapListener: (index) {
                                          setCurIndexOflistCurPrioriyCheckModel(
                                              index);
                                          setState(() {});
                                        },
                                        datas: listCurPrioriyCheckModel,
                                      )),
                                  Expanded(
                                    child: CustomMissionSilverWidget(
                                        listMissionModel:
                                            this.listCurPrioriyMissionModels),
                                  ),
                                ],
                              )),
                        )
                        // Expanded(child: CustomMissionSilverWidget(listMissionModel: [],))
                      ],
                    ),
              InnerTitleWidget(
                title: getI18NKey().completion_rate,
                // child: BlackCheckButtonListWidget(
                //   initIndex: priorityCompleteStatusEnum.index,
                //   list: CONSTANTS.getCompleteButtonList(),
                //   onTapListener: (obj) async {
                //     completionPercentRadialBarEnum = CompleteStatusEnum.values[obj];
                //     setState(() {});
                //   },
                // ),
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              // 四个圈圈圆形的优先级排列
              Utility.isHandsetBySize()
                  ? GestureDetector(
                      onTap: () {
                        DialogManagement.getInstance().showMissionListDialog(
                            context,
                            prioriy: this
                                .curListCurPrioriyMissionModelsPercentageIndex == 3 ? 0 : this.curListCurPrioriyMissionModelsPercentageIndex == 2 ? 1 : this.curListCurPrioriyMissionModelsPercentageIndex == 1 ? 2 : 3,
                            list: [
                              ...(this.listSessionMissionModelRed1?.datas ??
                                  []),
                              ...(this.listSessionMissionModelGreen4?.datas ??
                                  []),
                              ...(this.listSessionMissionModelYellow2?.datas ??
                                  []),
                              ...(this.listSessionMissionModelBlue3?.datas ??
                                  [])
                            ]);
                      },
                      child: buildCompletionPercentRadialBarWidget())
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCompletionPercentRadialBarWidget(),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: Container(
                              height: 260,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      child: PrioriyColorsGridViewWidget(
                                        onTapListener: (index) {
                                          setCurIndexOflistCurPrioriyCheckModelPercentage(
                                              index == 0 ? 3 : index == 1 ? 2 : index == 2 ? 1 : 0);
                                          setState(() {});
                                        },
                                        datas:
                                            listCurPercentagePrioriyCheckModel,
                                      )),
                                  Expanded(
                                    child: CustomMissionSilverWidget(
                                        listMissionModel: this
                                            .listCurPrioriyMissionModelsPercentage),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
              if (shouldShowAllChart())
                SizedBox(
                  height: DimensConfig.innerItemMargin,
                ),
              // PriorityFourDotsWidget(
              //   priorityGreen4: '',
              //   priorityRed1: '',
              //   priorityBlue3: '',
              //   priorityYellow2: '',
              // ),
              if (shouldShowAllChart())
                SizedBox(
                  height: DimensConfig.innerItemMargin,
                ),
              if (shouldShowAllChart())
                InnerTitleWidget(
                  title: getI18NKey().delay_mission,
                  // child: BlackCheckButtonListWidget(
                  //   initIndex: completePlanStatusEnum.index,
                  //   list: CONSTANTS.getCompleteButtonList(),
                  //   onTapListener: (obj) async {
                  //     completePlanStatusEnum = CompleteStatusEnum.values[obj];
                  //     setState(() {});
                  //   },
                  // ),
                ),
              if (shouldShowAllChart())
                SizedBox(
                  height: DimensConfig.innerItemMargin,
                ),
              // 未完成计划分类
              if (shouldShowAllChart())
                DelayUncompletePlanClassificationChartWidget(
                  completePlanStatusEnum: completePlanStatusEnum,
                  datasFolderModelWithExtraData:
                      this.datasFolderModelWithExtraData,
                  startDateTime: this.startDateTime,
                  endDateTime: this.endDateTime,
                ),
              if (shouldShowAllChart())
                InnerTitleWidget(
                  title:
                      this.completePlanStatusEnum == CompleteStatusEnum.finished
                          ? getI18NKey().complete_plan_classification
                          : getI18NKey().uncomplete_plan_classification,
                  child: BlackCheckButtonListWidget(
                    initIndex: completePlanStatusEnum.index,
                    list: CONSTANTS.getCompleteButtonList(),
                    onTapListener: (obj) async {
                      completePlanStatusEnum = CompleteStatusEnum.values[obj];
                      setState(() {});
                    },
                  ),
                ),
              if (shouldShowAllChart())
                SizedBox(
                  height: DimensConfig.innerItemMargin,
                ),
              // 未完成计划分类
              if (shouldShowAllChart())
                CompletePlanClassificationChartWidget(
                  completePlanStatusEnum: completePlanStatusEnum,
                  datasFolderModelWithExtraData:
                      this.datasFolderModelWithExtraData,
                  onTapItem: (v) {},
                  startDateTime: this.startDateTime,
                  endDateTime: this.endDateTime,
                ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DimensConfig.chartItemPadding),
                child: DashLineWidget(
                  gap: 6,
                ),
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              // 专注时长 的 table
              InnerContainerWidget(
                paddingTop: 0,
                paddingBottom: 0,
                colorShadowEnum: ColorShadowEnum.blue,
                child: Row(
                  children: [
                    Expanded(
                        flex: 35,
                        child: InnerContainerTitleSubtitleWidget(
                          title: getI18NKey().focus_duration,
                          value: Utility.formatHourAndMin(
                              totalFocusTimeByFolderModelList),
                        )),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 30,
                      width: 1,
                      color: Color(0xff808185),
                    ),
                    Expanded(
                        flex: 25,
                        child: InnerContainerTitleSubtitleWidget(
                          title: getI18NKey().tomatoNums2,
                          value: getI18NKey().num_times(focusTimes),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              // 专注时长分布
              //folder过来不展示下面数据
              if (shouldShowAllChart())
                InnerTitleWidget(
                    title: getI18NKey().focus_duration_distribution),
              if (shouldShowAllChart())
                SizedBox(
                  height: DimensConfig.innerItemMargin,
                ),
              if (shouldShowAllChart())
                FocusDurationDistributionWidget(
                  datasFolderModelWithExtraData:
                      this.datasFolderModelWithExtraData,
                  totalFocusTimeValue:
                      Utility.formatHourAndMin(totalFocusTimeByFolderModelList),
                ),

              // 专注时间段分布
              InnerTitleWidget(
                  title: getI18NKey().focus_on_time_period_distribution),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              ColumnGradientWidget(
                data: dataBarModelList,
                calendarTypeEnum: this.calendarTypeEnum,
                onTapItem: (v) {},
              ),
              SizedBox(
                height: DimensConfig.innerItemMargin,
              ),
              // StackedColumnChart(datas: dataBarModelList, calendarTypeEnum: this.calendarTypeEnum)
            ],
          );
        });
  }

  PriorityDistributionOfCompletionPlayCircleChart
      buildPriorityDistributionOfCompletionPlayCircleChart() {
    return PriorityDistributionOfCompletionPlayCircleChart(
      listSessionMissionModelRed1:
          this.listSessionMissionModelRed1 ?? SessionMissionModel(),
      listSessionMissionModelGreen4:
          this.listSessionMissionModelGreen4 ?? SessionMissionModel(),
      listSessionMissionModelYellow2:
          this.listSessionMissionModelYellow2 ?? SessionMissionModel(),
      listSessionMissionModelBlue3:
          this.listSessionMissionModelBlue3 ?? SessionMissionModel(),
      completeStatusEnum: this.priorityCompleteStatusEnum,
      onTapPriority: (int index, SessionMissionModel listSessionModel) {
        //     listSessionModel.datas ?? [];
        if (Utility.isHandsetBySize() == true) {
          DialogManagement.getInstance().showMissionListDialog(context,
              prioriy: this.curListCurPrioriyMissionModelsIndex,
              list: [
                ...(this.listSessionMissionModelRed1?.datas ?? []),
                ...(this.listSessionMissionModelGreen4?.datas ?? []),
                ...(this.listSessionMissionModelYellow2?.datas ?? []),
                ...(this.listSessionMissionModelBlue3?.datas ?? [])
              ]);
        } else {
          setCurIndexOflistCurPrioriyCheckModel(index);
          setState(() {});
        }
      },
    );
  }

  CompletionPercentRadialBarWidget buildCompletionPercentRadialBarWidget() {
    return CompletionPercentRadialBarWidget(
      completeStatusEnum: CompleteStatusEnum.finished,
      listSessionMissionModelRed1:
          this.listSessionMissionModelRed1 ?? SessionMissionModel(),
      listSessionMissionModelGreen4:
          this.listSessionMissionModelGreen4 ?? SessionMissionModel(),
      listSessionMissionModelYellow2:
          this.listSessionMissionModelYellow2 ?? SessionMissionModel(),
      listSessionMissionModelBlue3:
          this.listSessionMissionModelBlue3 ?? SessionMissionModel(),
      onTapPriority: (index) {
        if (Utility.isHandsetBySize() == true) {
          DialogManagement.getInstance().showMissionListDialog(context,
              prioriy: this.curListCurPrioriyMissionModelsPercentageIndex,
              list: [
                ...(this.listSessionMissionModelRed1?.datas ?? []),
                ...(this.listSessionMissionModelGreen4?.datas ?? []),
                ...(this.listSessionMissionModelYellow2?.datas ?? []),
                ...(this.listSessionMissionModelBlue3?.datas ?? [])
              ]);
        } else {
          setCurIndexOflistCurPrioriyCheckModelPercentage(index);
          setState(() {});
        }
      },
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
  void didUpdateWidget(TodayDataWidget oldWidget) {
    this.calendarTypeEnum = this.widget.calendarTypeEnum;
    // if(oldWidget.startDateTime != this.startDateTime||oldWidget.endDateTime != this.endDateTime) {
    //   requestDatas();
    // }
  }

  Future<int> requestDatas(
      {required CalendarTypeEnum calendarTypeEnum,
      DateTime? startDateTime,
      DateTime? endDateTime}) async {
    this.calendarTypeEnum = calendarTypeEnum;
    this.startDateTime = startDateTime;
    // if (this.calendarTypeEnum == CalendarTypeEnum.day) {
    //   this.startDateTime = null; //如果是按日搜索就搜索从今天有多少任务没完成
    // }
    this.endDateTime = endDateTime;
    await Future.wait([
      requestFolderModelsDatas(),
      requestPriorityTasksDatas(),
      requestBarModelList()
    ]).then((c) {
      print("1");
    });
    setState(() {});
    return 0;
  }

  //  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  Future<int> requestPriorityTasksDatas() async {
    try {
      missionListOriginal = await MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByEndTime(
        fid: this.widget.folderId ?? this.curSearchingFocusModel?.objectId,
        //todo 这个还没用的上
        start_endTime: startDateTime?.millisecondsSinceEpoch,
        end_endTime: endDateTime?.millisecondsSinceEpoch,
      );
      // missionListForView = Utility.deepClone(missionListOriginal).cast<MissionModel>();

      List<SessionMissionModel> listSessionMissionModel =
          Utility.getListAfterOrder(MissionOrderEnum.orderByPriority,
                  missionListOriginal ?? []) ??
              [];
      filterSessionMissinModelIntoFourParts(listSessionMissionModel);
      if (this.isFirstTime == false) {
        setCurIndexOflistCurPrioriyCheckModel(0);
        setCurIndexOflistCurPrioriyCheckModelPercentage(3);
        this.isFirstTime = true;
      }
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  static bool hasOthersOfFodelModel(List<FolderModel> datas) {
    for (int i = 0; i < datas.length; i++) {
      if (datas[i].iconType == 8) {
        return true;
      }
    }
    return false;
  }

  /**
   * 这个在folderPage过来就应该用不上了 因为那里过来只需要一个文件夹的数据
   */
  Future<int> requestFolderModelsDatas() async {
    try {
      // CalendarModel calendarModel = context
      //     .watch<GlobalStateEnv>()
      //     .calendarModel;
      // 从folderpage过来的
      if (shouldShowAllChart()) {
        List<FolderModel> datas = [];
        List<FolderModel> listWithCircle = MongoApisManager.getInstance()
            .queryWhereEqual_folderModelWithCircle();

        datas.addAll(listWithCircle);
        if (hasOthersOfFodelModel(datas) == false) {
          FolderModel folderModel = FolderModel();
          folderModel.title = getI18NKey().others;
          folderModel.iconType = 8; //其他
          datas.add(folderModel);
          // CONSTANTS.folderModelList = datas;

          datasFolderModelWithExtraData = CONSTANTS.getMenuList(datas,
              startDateTime: this.startDateTime,
              endDateTime: this.endDateTime,
              isMobile: screenType == ScreenType.Handset,
              calendarModel: calendarModel ?? CalendarModel(),
              shouldAddDayType: false);
        }
      } else {
        datasFolderModelWithExtraData = CONSTANTS.getMenuList(
            [this.widget.folderModelWithExtraData!.folderModel],
            startDateTime: this.startDateTime,
            endDateTime: this.endDateTime,
            isMobile: screenType == ScreenType.Handset,
            calendarModel: calendarModel ?? CalendarModel(),
            shouldAddDayType: false);
        // datasFolderModelWithExtraData = [this.widget.folderModelWithExtraData!];
      }
      datasFolderModelDelayWithExtraData =
          Utility.deepClone(datasFolderModelWithExtraData ?? [])
            ..removeWhere((element) => element.folderModel.tag != 2);
      getTotalFocusTimeByFolderModelList(datasFolderModelWithExtraData);
      missionListOriginal?.forEach((element) {});
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  bool shouldShowAllChart() =>
      this.widget.folderModelWithExtraData == null ||
      (this.widget.folderModelWithExtraData?.folderModel?.tag == 2);

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
  //底部专注时长分布
  Future<int> requestBarModelList() async {
    try {
      DateTime dateTime = DateTime.now();
      //这次完成任务总数
      // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
      listStatsModel = MongoApisManager.getInstance()
          .queryWhereEqual_statModelsByTime(
              folder_id:
                  this.widget.folderId ?? this.curSearchingFocusModel?.objectId,
              start_endTime: startDateTime?.millisecondsSinceEpoch,
              end_endTime: dateTime.millisecondsSinceEpoch); //用于charts数据
      listStatsModelFinished = MongoApisManager.getInstance()
          .queryWhereEqual_statModelsByTime(
              type: 1,
              folder_id:
                  this.widget.folderId ?? this.curSearchingFocusModel?.objectId,
              start_endTime: startDateTime?.millisecondsSinceEpoch,
              end_endTime: dateTime.millisecondsSinceEpoch); //用于StatsPage头部的数据
      if (startDateTime != null) {
        listStatsModelFinishedPrev = MongoApisManager.getInstance()
            .queryWhereEqual_statModelsByTime(
                type: 1,
                folder_id: this.widget.folderId ??
                    this.curSearchingFocusModel?.objectId,
                start_endTime: (startDateTime?.millisecondsSinceEpoch ?? 0) -
                    ((endDateTime?.millisecondsSinceEpoch ?? 0) -
                        (startDateTime?.millisecondsSinceEpoch ?? 0)),
                end_endTime:
                    startDateTime?.millisecondsSinceEpoch); //用于StatsPage头部的数据
      }
      mapDataMissionNumbersTimes = StatisticUtility.filterStatsModelToBarModel(
              this.calendarTypeEnum == CalendarTypeEnum.day
                  ? DateTypeEnum.day
                  : DateTypeEnum.custom, //本月数据
              listStatsModel,
              StatisticTypeEnum.time,
              datetimeStart: startDateTime,
              datetimeEnd: endDateTime) ??
          {};

      mapDataMissionNumbersNumbers =
          StatisticUtility.filterStatsModelToBarModel(
                  this.calendarTypeEnum == CalendarTypeEnum.day
                      ? DateTypeEnum.day
                      : DateTypeEnum.custom, //本月数据
                  listStatsModelFinished,
                  StatisticTypeEnum.number,
                  datetimeStart: startDateTime,
                  datetimeEnd: endDateTime) ??
              {};
      //dataBarModelList 用于底部专注时长分布
      this.dataBarModelList =
          mapDataMissionNumbersTimes['BarModelList'] ?? BarModelList();
      this.dataBarModelListPrev =
          mapDataMissionNumbersTimes['BarModelListPrev'] ?? BarModelList();

      dataMissionNumbers =
          mapDataMissionNumbersNumbers['BarModelList'] ?? BarModelList();

      int totalTimePrev = Utility.getTotalTime(
          listBarModel: dataBarModelListPrev.listBarModel ?? {});
      int totalTime = Utility.getTotalTime(
          listBarModel: dataBarModelList.listBarModel ?? {});

      int numTomatoes = dataBarModelList.listStatsModel?.length ?? 0;
      int numTomatoesPrev = dataBarModelListPrev.listStatsModel?.length ?? 0;

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
    } catch (e) {
      print(e.toString());
    }
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
