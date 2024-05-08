import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../common/database/apis/MongoApisManager.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../components/CommonCalendarHeaderWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../models/BarModel.dart';
import '../../../models/CalendarModel.dart';
import '../../../models/FolderModel.dart';
import '../../../models/FolderModelWithExtraData.dart';
import '../../../models/MissionModel.dart';
import '../../../models/SessionMissionModel.dart';
import '../../../util/StatisticUtility.dart';
import '../../../util/ThemeManager.dart';

class SummaryHeaderWidget extends StatefulWidget {

  CalendarTypeEnum calendarTypeEnum;
  // CommonCalendarHeaderWidgetController? controller;

  SummaryHeaderWidget(
      {Key? key, required this.calendarTypeEnum}) : super(key: key) {
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SummaryHeaderWidgetState(calendarTypeEnum: calendarTypeEnum);
  }
}

class SummaryHeaderWidgetState extends State<SummaryHeaderWidget> {
  double marginTop = 5;
  DateTime? startDateTime;
  DateTime? endDateTime;
  List<FolderModelWithExtraData> datasFolderModelWithExtraData = [];
  CalendarModel? calendarModel;
  int totalFocusTimeByFolderModelList = 0;
  int focusTimes = 0;
  int numMissionFinished = 0;
  int numMissionToFinished = 0;
  List<MissionModel>? missionListOriginal;
  FolderModel? curSearchingFocusModel;
  SessionMissionModel? listSessionMissionModelRed1 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelYellow2 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelBlue3 = SessionMissionModel();
  SessionMissionModel? listSessionMissionModelGreen4 = SessionMissionModel();
  CalendarTypeEnum calendarTypeEnum;


  SummaryHeaderWidgetState({required this.calendarTypeEnum});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    calendarModel = Provider.of<GlobalStateEnv>(context).calendarModel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 4,
        ),
        Container(
            width: double.infinity,
            height: 2,
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: ColorsConfig.borderLineColor)),
        SizedBox(
          height: marginTop,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarWidget(
                avatar: LoginManager.getInstance().getUserBean().avatar),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LoginManager.getInstance().getUserBean().username,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: marginTop,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: SummaryHeaderWidgetItem(
                              value: LoginManager.getInstance().getUserBean().totalFocusTimeRanking == -1 ? getI18NKey().no_ranking : LoginManager.getInstance().getUserBean().totalFocusTimeRanking.toString(),
                              marginTop: marginTop,
                              title: getI18NKey().ranking,
                            )),
                        Expanded(
                            child: SummaryHeaderWidgetItem(
                              // value: getI18NKey().num_tasks(this.pcRightTopResourceDataList[2].extendParamsMap?['value']?.toString() ?? 0),
                              value: getI18NKey().num_tasks("${this.numMissionFinished}/${this.numMissionFinished + this.numMissionToFinished}"),
                              marginTop: marginTop,
                              title: getI18NKey().missionNums,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: marginTop,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: SummaryHeaderWidgetItem(
                              value: Utility.formatHourAndMin(LoginManager.getInstance()
                                  .getUserBean()
                                  .totalFocusTime ?? 0),
                              marginTop: marginTop,
                              title: getI18NKey().totalTime,
                            )),
                        Expanded(
                            child: SummaryHeaderWidgetItem(
                              // value: getI18NKey().num_times(this.pcRightTopResourceDataList[1].extendParamsMap?['value']?.toString() ?? 0),
                              value: getI18NKey().num_times(focusTimes),
                              marginTop: marginTop,
                              title: getI18NKey().tomatoNums,
                            ))
                      ],
                    ),

                  ],
                ))
          ],
        )
      ],
    );
  }

  Future<int> requestDatas({DateTime? startDateTime, DateTime? endDateTime}) async {
    this.startDateTime = null;
    this.endDateTime = null;

    // this.startDateTime = startDateTime;
    // this.endDateTime = endDateTime;
    await Future.wait([
      requestFolderModelsDatas(),
      // requestPriorityTasksDatas(),
      // requestBarModelList()
    ]);
    setState(() {});
    return 0;
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

    List<SessionMissionModel> listSessionMissionModel =
    Utility.getListAfterOrder(
        MissionOrderEnum.orderByPriority, missionListOriginal ?? []) ?? [];
    filterSessionMissinModelIntoFourParts(listSessionMissionModel);
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

class SummaryHeaderWidgetItem extends StatelessWidget {
  String title;
  String value;
  double marginTop = 10;

  SummaryHeaderWidgetItem(
      {required this.title, required this.value, required this.marginTop});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Color(0xffb3b3b3),
              fontSize: 10,
              decoration: TextDecoration.none,
              decorationStyle: null),
        ),
        SizedBox(
          height: this.marginTop,
        ),
        Text(
          value,
          style: TextStyle(
              color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
              fontSize: 12,
              decoration: TextDecoration.none,
              decorationStyle: null),
        ),
      ],
    );
  }
}
