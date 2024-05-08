import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/AvatarWidget.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

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

class FolderSummaryHeaderWidget extends StatefulWidget {
  FolderModelWithExtraData folderModelWithExtraData;
  CalendarTypeEnum calendarTypeEnum;
  // CommonCalendarHeaderWidgetController? controller;

  FolderSummaryHeaderWidget(
      {Key? key, required this.calendarTypeEnum, required this.folderModelWithExtraData}) : super(key: key) {
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FolderSummaryHeaderWidgetState(calendarTypeEnum: calendarTypeEnum);
  }
}

class FolderSummaryHeaderWidgetState extends State<FolderSummaryHeaderWidget> {
  double marginTop = 5;
  DateTime? startDateTime;
  DateTime? endDateTime;
  // List<FolderModelWithExtraData> datasFolderModelWithExtraData = [];
  CalendarModel? calendarModel;
  int totalFocusTimeByFolderModelList = 0;
  int focusTimes = 0;
  int numMissionFinished = 0;
  int numMissionToFinished = 0;
  List<MissionModel>? missionListOriginal;
  FolderModel? curSearchingFocusModel;
  //感觉没用
  // SessionMissionModel? listSessionMissionModelRed1 = SessionMissionModel();
  // SessionMissionModel? listSessionMissionModelYellow2 = SessionMissionModel();
  // SessionMissionModel? listSessionMissionModelBlue3 = SessionMissionModel();
  // SessionMissionModel? listSessionMissionModelGreen4 = SessionMissionModel();
  CalendarTypeEnum calendarTypeEnum;


  FolderSummaryHeaderWidgetState({required this.calendarTypeEnum});

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
            color: ColorsConfig.borderLineColor),
        SizedBox(
          height: marginTop,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 4,),
            WidgetManager.getFolderModelIcon(this.widget.folderModelWithExtraData.folderModel, 40) ?? SizedBox.shrink(),
            SizedBox(width: 4,),
            // AvatarWidget(
            //     avatar: LoginManager.getInstance().getUserBean().avatar),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.folderModelWithExtraData.folderModel?.title ?? "" ,
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
                            child: FolderSummaryHeaderWidgetItem(
                              value: this
                                  .widget
                                  .folderModelWithExtraData
                                  .folderTimeModel
                                  ?.previewTimeString
                                  .toString() ?? "",
                              marginTop: marginTop,
                              title: getI18NKey().previewTime,
                            )),
                        Expanded(
                            child: FolderSummaryHeaderWidgetItem(
                              // value: getI18NKey().num_tasks(this.pcRightTopResourceDataList[2].extendParamsMap?['value']?.toString() ?? 0),
                              value: "${this
                                  .widget
                                  .folderModelWithExtraData
                                  .folderTimeModel
                                  ?.numMissionToFinished
                                  .toString()} / ${(this
                                  .widget
                                  .folderModelWithExtraData
                                  .folderTimeModel
                                  ?.numMissionToFinished ?? 0) + (this
                                  .widget
                                  .folderModelWithExtraData
                                  .folderTimeModel
                                  ?.numMissionFinished ?? 0)}",
                              marginTop: marginTop,
                              title: getI18NKey().missionToBeComplete,
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
                            child: FolderSummaryHeaderWidgetItem(
                              value: this
                                  .widget
                                  .folderModelWithExtraData.folderTimeModel.numMissionFinished
                                  .toString() ?? "",
                              marginTop: marginTop,
                              title: getI18NKey().missioncompleted,
                            )),
                        Expanded(
                            child: FolderSummaryHeaderWidgetItem(
                              // value: getI18NKey().num_times(this.pcRightTopResourceDataList[1].extendParamsMap?['value']?.toString() ?? 0),
                              value: this
                                  .widget
                                  .folderModelWithExtraData.folderTimeModel.finishedTimeString
                                  .toString() ?? "",
                              marginTop: marginTop,
                              title: getI18NKey().timefocused,
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
    // filterSessionMissinModelIntoFourParts(listSessionMissionModel);
    return 0;
  }

  Future<int> requestFolderModelsDatas({bool shouldRefresh = false}) async {
    try {
      // CalendarModel calendarModel = context
      //     .watch<GlobalStateEnv>()
      //     .calendarModel;
      // List<FolderModel> datas = await MongoApisManager.getInstance()
      //     .queryWhereEqual_folderModel(shouldRefresh: shouldRefresh);
      // setState(() {
        // List<FolderModel> folderModelList = datas;
        // CONSTANTS.folderModelList = datas;

      //   datasFolderModelWithExtraData = CONSTANTS.getMenuList(datas,
      //       startDateTime: this.startDateTime,
      //       endDateTime: this.endDateTime,
      //       isMobile: screenType == ScreenType.Handset,
      //       calendarModel: calendarModel ?? CalendarModel(),
      //       shouldAddDayType: false);
      // });
      // getTotalFocusTimeByFolderModelList(datasFolderModelWithExtraData);
    } catch (e) {}
    return 0;
  }

  getTotalFocusTimeByFolderModelList() {
    totalFocusTimeByFolderModelList = 0;
    focusTimes = 0;
    numMissionFinished = 0;
    numMissionToFinished = 0;
      totalFocusTimeByFolderModelList =
          (this.widget.folderModelWithExtraData.folderTimeModel.finishedTime ?? 0) +
              totalFocusTimeByFolderModelList;
      focusTimes = (this.widget.folderModelWithExtraData.folderTimeModel.numMissionFinished ?? 0) + focusTimes;
      numMissionFinished =
          (this.widget.folderModelWithExtraData.folderTimeModel.numMissionFinished ?? 0) + focusTimes;
      numMissionToFinished = (this.widget.folderModelWithExtraData.folderTimeModel.numMissionToFinished ?? 0) +
          numMissionToFinished;
  }

  // filterSessionMissinModelIntoFourParts(
  //     List<SessionMissionModel> listSessionMissionModel) {
  //   listSessionMissionModelRed1 = getListSessionMissionModel(
  //       getI18NKey().priority1, listSessionMissionModel);
  //   listSessionMissionModelYellow2 = getListSessionMissionModel(
  //       getI18NKey().priority2, listSessionMissionModel);
  //   listSessionMissionModelBlue3 = getListSessionMissionModel(
  //       getI18NKey().priority3, listSessionMissionModel);
  //   listSessionMissionModelGreen4 = getListSessionMissionModel(
  //       getI18NKey().priority4, listSessionMissionModel);
  // }

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

class FolderSummaryHeaderWidgetItem extends StatelessWidget {
  String title;
  String value;
  double marginTop = 10;

  FolderSummaryHeaderWidgetItem(
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
