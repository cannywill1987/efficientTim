import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/PCButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/PCStatisticRightTopContainer.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/BarModel.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/GetResourceDeliveryManager.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/StatisticUtility.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/BaseBean.dart';
import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../beans/ResourceLocationInfoBean.dart';
import '../../../beans/UserBean.dart';
import '../../../common/httpclient/HttpManager.dart';
import '../../../components/CustomMarquee.dart';
import '../../../components/NineLoterryWidget.dart';
import '../components/RankingListWidget.dart';
import '../../../components/SelectCustomDialogUtil.dart';
import '../../../components/SelectSliderDurationDialogUtil.dart';
import '../../../components/StatisticTopContainer.dart';
import '../../../util/LoginManager.dart';
import '../chartsComponents/BarChartWidget.dart';
import '../components/HeaderStatsWidget.dart';
import '../chartsComponents/LineCharWidget.dart';

import '../components/NumberMissionBarChartWidget.dart';

class SubStatisticPage extends BaseWidget {
  const SubStatisticPage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SubStatisticPageWidgetState();
  }
}

class _SubStatisticPageWidgetState<T> extends BaseWidgetState<SubStatisticPage> {
  List<StatsModel> listStatsModel = [];
  List<StatsModel> listStatsModelFinished = []; //用于StatsPage头部的数据
  List<StatsModel> listStatsModelFinishedPrev = []; //用于StatsPage头部的数据

  List<CheckButtonStateModel> pcDateButtonList =
  CONSTANTS.getPCDateButtonList(); //pc端右上角日历button
  List<ResourceDeliveryInfoBean> pcRightTopResourceDataList =
  CONSTANTS.getPCRightTopDefaultRessourceData();
  int _currentSelection = 0;
  double segmentControlHeight = 18;
  double segmentControlWidth = 70;
  BarModelList data = BarModelList();
  BarModelList dataPrev = BarModelList();

  // NineLoterryController nineLotteryController = NineLoterryController();

  BarModelList dataMissionNumbers = BarModelList(); //用于显示任务数的chart
  String? sceneCode;

  double curSliderVal = 0.1;

  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
    // nineLotteryController = null;
  }

  @override
  void initState() {
    super.initState();
    sceneCode = pcRightTopResourceDataList[0].extendParamsMap?['sceneCode'] ?? "";
    eventBus.on<EventFn>().listen((EventFn event) {
      /**
       * 完成任务更新这里
       */
      if (event.type == Params.ACTION_UPDATE_LISTVIEW) {
        requestDatas(1);
      }
    });

    this.isAppBarVisible = false;
    requestDatas(1);
  }

  Map<int, Widget> getSegmentChildren() {
    return {
      0: Container(
          width: this.segmentControlWidth,
          height: this.segmentControlHeight,
          alignment: Alignment(0, 0),
          child: Text(getI18NKey().byday)),
      1: Container(
          width: this.segmentControlWidth,
          height: this.segmentControlHeight,
          alignment: Alignment(0, 0),
          child: Text(getI18NKey().week)),
      2: Container(
          width: this.segmentControlWidth,
          height: this.segmentControlHeight,
          alignment: Alignment(0, 0),
          child: Text(getI18NKey().month)),
      // 3: Text('Telluraves')
    };
  }

  // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
  void requestDatas(int segmentControl) {
    DateTime dateTime = DateTime.now();
    //这次完成任务总数
    DateTime dateTimeStart = Utility.getDateTimeFromTimeStamp(segmentControl ==
        1
        ? Utility.getFilterDateTimeFromTimeStamp(
        dateTime.millisecondsSinceEpoch)
        .millisecondsSinceEpoch
        : segmentControl == 2
        ? Utility.getFilterDateTimeFromTimeStamp(
        dateTime.millisecondsSinceEpoch - 7 * 24 * 60 * 60 * 1000)
        .millisecondsSinceEpoch
        : Utility.getFilterDateTimeFromTimeStamp(
        dateTime.millisecondsSinceEpoch - 30 * 24 * 60 * 60 * 1000)
        .millisecondsSinceEpoch);
    DateTime dateTimePrev = Utility.getDateTimeFromTimeStamp(segmentControl == 1
        ? (dateTimeStart.millisecondsSinceEpoch - 24 * 60 * 60 * 1000)
        : segmentControl == 2
        ? (dateTimeStart.millisecondsSinceEpoch - 7 * 24 * 60 * 60 * 1000)
        : (dateTimeStart.millisecondsSinceEpoch -
        30 * 24 * 60 * 60 * 1000)); //和上周比
    // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
    listStatsModel = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
        start_endTime: dateTimeStart.millisecondsSinceEpoch,
        end_endTime: dateTime.millisecondsSinceEpoch); //用于charts数据
    listStatsModelFinished = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
        type: 1,
        start_endTime: dateTimeStart.millisecondsSinceEpoch,
        end_endTime: dateTime.millisecondsSinceEpoch); //用于StatsPage头部的数据
    listStatsModelFinishedPrev = MongoApisManager.getInstance()
        .queryWhereEqual_statModelsByTime(
        type: 1,
        start_endTime: dateTimePrev.millisecondsSinceEpoch,
        end_endTime:
        dateTimeStart.millisecondsSinceEpoch); //用于StatsPage头部的数据

    Map<String, BarModelList>? map = StatisticUtility.filterStatsModelToBarModel(
        segmentControl == 1
            ? DateTypeEnum.day //今天数据
            : segmentControl == 2
            ? DateTypeEnum.last7Days //近七天数据
            : DateTypeEnum.lastMonth, //本月数据
        listStatsModel,
        StatisticTypeEnum.time);

    Map<String, BarModelList>? mapDataMissionNumbers =
    StatisticUtility.filterStatsModelToBarModel(
        segmentControl == 1
            ? DateTypeEnum.day //今天数据
            : segmentControl == 2
            ? DateTypeEnum.last7Days //近七天数据
            : DateTypeEnum.lastMonth, //本月数据
        listStatsModelFinished,
        StatisticTypeEnum.number);

    this.data = map?['BarModelList'] ?? BarModelList();
    this.dataPrev = map?['BarModelListPrev'] ?? BarModelList();

    dataMissionNumbers = mapDataMissionNumbers?['BarModelList'] ?? BarModelList();

    int totalTimePrev =
    Utility.getTotalTime(listBarModel: dataPrev.listBarModel ?? {});
    int totalTime = Utility.getTotalTime(listBarModel: data.listBarModel ?? {});

    int numTomatoes = data.listStatsModel?.length ?? 0;
    int numTomatoesPrev = dataPrev.listStatsModel?.length ?? 0;

    int missionCompleted = listStatsModelFinished.length;
    int missionCompletedPrev = listStatsModelFinishedPrev.length;

    pcRightTopResourceDataList = CONSTANTS.getPCRightTopRessourceData(
        sceneCode: sceneCode,
        totalTimePrev: totalTimePrev,
        totalTime: totalTime,
        numTomatoes: numTomatoes,
        numTomatoesPrev: numTomatoesPrev,
        missionCompleted: missionCompleted,
        missionCompletedPrev: missionCompletedPrev,
        dateTypeEnum: segmentControl == 1
            ? DateTypeEnum.day //今天数据
            : segmentControl == 2
            ? DateTypeEnum.last7Days //近七天数据
            : DateTypeEnum.lastMonth); //本月数据
    this.updateUI();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSegmentControl':
        setState(() {
          _currentSelection = data;
          this.requestDatas(_currentSelection + 1);
        });
        break;
      case 'onClickPCValueType':
        setState(() {
          sceneCode = data;
        });
        break;
    }
  }

  Widget baseDesktoptBuild(BuildContext context) {
    return Container(
      color: ThemeManager.getInstance().getBackgroundColor(),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SingleChildScrollView(
          child: Column(
            children: [
              //todo测试用
              Params.env == EnvEnum.prd ? SizedBox.shrink() : TextButton(
                  onPressed: () {
                    NineLoterryController nineLotteryController = NineLoterryController();
                    OverlayManagement.getInstance().openLotteryNineGridViewEntry(context, simpleLotteryController: nineLotteryController);
                    // Utility.openUrl(url: 'https://webcdn.m.qq.com/webapp/homepage/index.html#/appDetail?apkName=com.smile.gifmaker&info=92852E926DAF3C3BA7E9D4089CF5CC40');
                  },
                  child: Text('测试用')),
              SizedBox(
                //头部
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      getI18NKey().projectStatistic,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    // 右上角Pc端按钮列表
                    PCButtonListWidget(
                      list: pcDateButtonList,
                      onTapListener: (data) {
                        int index = data['index'];
                        this.onClick("onClickSegmentControl", index);
                      },
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: AspectRatio(
                          aspectRatio: 1.4, child: getChartContainer())),
                  SizedBox(width: 10),
                  Expanded(
                      child: AspectRatio(
                          aspectRatio: 1.4,
                          child: PCStatisticRightTopContainer(
                            onTapListener: (res) {
                              ResourceDeliveryInfoBean resourceDeliveryInfoModel = res['data'];
                              this.onClick(
                                  "onClickPCValueType",
                                  resourceDeliveryInfoModel
                                      .extendParamsMap?['sceneCode'] ?? "");
                            },
                            list: pcRightTopResourceDataList,
                          )))
                ],
              ),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.all(12), child: Card(
                  margin: EdgeInsets.all(12),
                  elevation: 3,
                  child: RankingListWidget()))

              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Expanded(
              //         child: AspectRatio(
              //             aspectRatio: 1.4, child: gePCLeftTopChartContainer(0))),
              //     SizedBox(width: 10),
              //     Expanded(
              //         child: AspectRatio(
              //             aspectRatio: 1.4, child: getPCRightTopContainer()))
              //   ],
              // ),
            ],
          )),
    );
  }

  Widget getChartContainer() {
    ///帧布局结合透明布局
    return Stack(
      children: <Widget>[
        Visibility(
          visible: (sceneCode == 'tomatoNums') ? true : false,
          child: (sceneCode == 'tomatoNums')
              ? BarChartWidget(
            datas: this.data,
          )
              : SizedBox.shrink(),
        ),
        Visibility(
          visible: sceneCode == 'wholeComepleteTime' ? true : false,
          child: sceneCode == 'wholeComepleteTime'
              ? LineCharWidget(
            datas: this.data,
          )
              : SizedBox.shrink(),
        ),
        Visibility(
          visible: (sceneCode == 'missionNums') ? true : false,
          child: (sceneCode == 'missionNums')
              ? NumberMissionBarChartWidget(
            datas: this.dataMissionNumbers,
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget baseBuild(BuildContext context) {
    return Container(
      color: ThemeManager.getInstance().getBackgroundColor(defaultColor: ColorsConfig.chartBgColor),
      child: SingleChildScrollView(
          child: Column(children: [
            // CustomMarquee(text: 'There once was a boy who told this story about a boy: "',),
            Params.env == EnvEnum.prd ? SizedBox.shrink() : TextButton(
                onPressed: () async {
                  // File file = await Utility.pickImage();
                  // File fileCropped = await Utility.cropImage(file);
                  // Image.file(fileCropped);
                  // String url = await HttpManager.getInstance().uploadImage(key: 'key', file:fileCropped, url: Apis.upload);
                  // String url =
                  //     'http://fsclould.timerbell.com/20220422-image_cropper_065ADC93-B347-4F1F-8257-C0514ED1F4AF-2043-000001C1516A6E53.jpg?imageMogr2/thumbnail/300x300';
                  // HttpManager.getInstance().doPostRequest(Apis.updateAvatar,
                  //     context: context,
                  //     params: {'avatar': url}, callback:
                  //         (BaseBean response, String scene, bool isFromCache) {
                  //       if (response.success == true) {
                  //         eventBus
                  //             .fire(EventFn(Params.ACTION_UPDATE_USERINFO_AVATAR, {}));
                  //         Utility.showToast(msg: getI18NKey().update_success);
                  //         LoginManager.getInstance()
                  //             .setUserBean(UserBean.fromJson(response.data));
                  //         // if (this.onAvatarUpdatedComplete != null) {
                  //         //   this.onAvatarUpdatedComplete();
                  //         // }
                  //       }
                  //     });
                  NineLoterryController nineLotteryController = NineLoterryController();
                  DialogManagement.getInstance().showNineLotteryDialog(context: context,nineLotteryController: nineLotteryController);
                  // OverlayManagement.getInstance().openLotteryNineGridViewEntry(context, simpleLotteryController: nineLotteryController);
                },
                child: Text('测试用')),
            //顶部数据widget
            StatisticTopContainer(
              onTapListener: (res) {
                ResourceDeliveryInfoBean resourceDeliveryInfoModel = res['data'];
                // ResourceDeliveryInfoModel resourceDeliveryInfoModel = res['data'];
                this.onClick("onClickPCValueType",
                    resourceDeliveryInfoModel.extendParamsMap?['sceneCode'] ?? "");
              },
              list: pcRightTopResourceDataList,
            ),

            // HeaderStatsWidget(
            //     datas: this.data,
            //     listStatsModel: this.listStatsModel,
            //     listStatsModelFinished: this.listStatsModelFinished),
            SizedBox(
              height: 15,
            ),
            //排行榜的切换
            MaterialSegmentedControl(
              verticalOffset: 10,
              children: getSegmentChildren(),
              selectionIndex: _currentSelection,
              borderColor: Color(0xffd0d0d0d0),
              selectedColor:
              Color(SharePreferenceUtil.getSyncInstance().getCommonColor()),
              unselectedColor: ThemeManager.getInstance().getColor(defaultColor: Colors.white),
              borderRadius: 32.0,
              onSegmentChosen: (index) {
                this.onClick("onClickSegmentControl", index);
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: getChartContainer(),
              ),
            ),
            SizedBox(height: 10),
            //排行榜
             RankingListWidget()
            // Card(
            //     elevation: 0,
            //     child: Container(
            //         margin: EdgeInsets.all(12), child: RankingListWidget()))
          ])),
    );
  }
}
