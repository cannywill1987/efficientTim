import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CheckButtonListWithIconWidget.dart';
import 'package:time_hello/com/timehello/components/CustomMarquee.dart';
import 'package:time_hello/com/timehello/components/SearchBarWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/SessionMissionModel.dart';
import 'package:time_hello/com/timehello/page/missionDetailPage/components/MissionDetailMissionSilverList.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/BottomBar.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/HeaderStatsAndInputWidget.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../common/provider/GlobalStateEnv.dart';
import '../../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../../models/CalendarModel.dart';
import '../../../models/TimelineMissionModel.dart';
import '../../../util/CounterManagement.dart';
import '../../missionPage/MissionPage.dart';

class MissionDetailMissionPageWidget extends BaseWidget {
  FolderModel? folderModel; //FoldersPage页面传入的数据
  int? folderStatusDate = 1; // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 6 已完成
  Function? onTapNavMenuListener;

  MissionDetailMissionPageWidget(
      {Key? key,
      folderModel,
      this.folderStatusDate,
      this.onTapNavMenuListener}) {
    this.folderModel = folderModel ??
        CONSTANTS.getMenuList([],
            isMobile: screenType == ScreenType.Handset)[0].folderModel;
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _MisssionPageWidgetState(
        folderStatus: this.folderStatusDate, folderModel: this.folderModel);
  }
}

class _MisssionPageWidgetState<T> extends BaseWidgetState<MissionDetailMissionPageWidget> {
  List<MissionModel> _missionModelListUnFinished = []; //未完成任务
  List<MissionModel> _missionModelListFinished = []; //已经完成任务
  int? _dateStatus; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
  int numTomatoes = 1;
  MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByWords;
  MissionModel _missionModel = MissionModel();
  CalendarModel? calendarModel;
  bool isRequesting = false;
  double margin = 5;
  List<MissionModel>? curListMissionModels = [];
  GlobalKey<HeaderStatsAndInputWidgetState>? HeaderWidgetStateGlobalKey =
      GlobalKey();
  GlobalKey<CheckButtonListWithIconWidgetState>?
      checkButtonListWithIconWidgetKey = GlobalKey();
  int timestampCur = 0;
  GlobalKey<SearchBarWidgetState>? searchBarWidgetKey = GlobalKey();
  GlobalKey<BottomBarState>? bottomBarStateKey = GlobalKey();
  bool isFocusing = false;
  bool isSearchBarVisible = false;
  String? curSearchWords = null;
  ScrollController _scrollController = ScrollController();
  double padding = 5;
  MultiSelectModeEnum multiSelectModeEnum = MultiSelectModeEnum.normal;
  MissionDataViewTypeEnum missionDataViewTypeEnum =
      MissionDataViewTypeEnum.list;
  int folderStatusIsArchived = -1; // -1 未归档 归档 0 未归档 1 归档
  bool isListAndGridVisible = true;

  // int
  _MisssionPageWidgetState({folderStatus, folderModel}) {
    this._dateStatus = null;
    initData(folderModel, folderStatus);
  }

  void initData(folderModel, folderStatus) {
    // if (folderModel.tag == 2) {
    //   //tag 2 是标签 进来的
    //   this._missionModel?.tagIds = [folderModel.objectId].join(',');
    //   this._missionModel?.tagNames = [folderModel.title].join(',');
    // } else {
    //   //1 就是circle 进来的
    //   if (!TextUtil.isEmpty(folderModel.tag)) {
    //     //不是今天 明天 即将到来 待定
    //     this._circleColor = folderModel.color ?? 0;
    // }
    // if (this._dateStatus == null) {
    //   if (folderStatus != null) {
    //     //如果来自今天 明天 即将到来等
    //     this._dateStatus = folderStatus;
    //   } else {
    //     //否则来自文件夹等
    //     this._dateStatus = 0;
    //   }
    // }
  }

  @override
  void onCreate() {
    super.onCreate();
    curPage = "MissionDetailMissionPageWidget";
  }

  @override
  void initState() {
    super.initState();
    this.shouldShowSafeArea = false;
    this.isAppBarVisible = false;
    this.forceAppBarVisible = false;
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickFinishItem': //点击完成任务
        this.onClickFinishMission(data);
        break;
      case 'onClickMissionDetail': //跳转到任务详情页MissionPage开始任务
      //点击item
        onClickMissionStart(context, data, this.widget.folderModel);
        break;
    }
  }

  /**
   * 跳转到任务详情页MissionPage开始任务
   */
  static void onClickMissionStart(
      BuildContext context, MissionModel data, FolderModel? folderModel) async {
      OverlayManagement.getInstance().openMissionDetailPageOverlay(
          context: context, missionModel: data, folderModel: folderModel);
  }

  Future<void> onClickFinishMission(MissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    FolderModel? folderModel = MongoApisManager.getInstance().queryWhereEqualFolderModelByObjectId(objectId: data.folder_id ?? "");
    if (folderModel != null) {
      await MongoApisManager.getInstance().insertStatsModel(
        title: data.title,
        type: 1,
        icon: folderModel?.icon,
        color: folderModel?.color,
        tagName: data.tagNames,
        fid: folderModel?.objectId,
        begin_time: Utility.getTimestampFromDateTime(data.createdAt ?? ""),
        finish_time: Utility.getTimeStampToday(),
        value: data.tomato_duration?.toDouble() ?? 0,
        category: data.title,
      );
    }
    await MongoApisManager.getInstance()
        .finishMissionModel(missionModel: data, context: context);
    this.requestDatas();
    CounterManagement counterManagement = CounterManagement.getInstance();
    //不是同一个就重置重新开始计数
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    //关闭的是同一个任务那就停止计时器
    if (counterManagement?.missionModel?.objectId == data.objectId) {
      // counterManagement.reset();
      CounterManagement.getInstance().reset();
    }
  }

  componentDidMount() {
    this.requestDatas();
    missionOrderEnum =
        SharePreferenceUtil.getSyncInstance().getMissionOrderEnum();
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_LISTVIEW) {
        Future.delayed(Duration(seconds: 1), () {
          this.requestDatas();
        });
      }
    });
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // calendarModel = context.read<GlobalStateEnv>().calendarModel;
    Env env = context.watch<Env>();
    if (env.jumpFromFolderPageToMissionPage != null) {
      initData(env.jumpFromFolderPageToMissionPage?['folderModel'],
          env.jumpFromFolderPageToMissionPage?['folderStatus']);
    } else {
      initData(this.widget.folderModel, this.widget.folderStatusDate);
    }

    return CustomScrollView(
      controller: _scrollController,
      key: ValueKey('CustomScrollView1'),
      slivers: getSilverListWidget(),
    );
  }


  List<Widget> getSilverListWidget() {
    List<Widget> listWidget = [];
    // listWidget.add(
      //头部title
      // SliverPersistentHeader(
      //     //是否固定头布局 默认false
      //     pinned: false,
      //     //是否浮动 默认false
      //     floating: false,
      //     delegate: MySliverDelegate(
      //       //缩小后的布局高度
      //       minHeight: 60.0,
      //       //展开后的高度
      //       maxHeight:
      //           Utility.isHandsetBySize() && isSearchBarVisible ? 100.0 : 60,
      //       child: getHeaderWidget(),
      //     )),
    // );
    //CustomScrollView加固定高度 10
    // listWidget.add(SliverPadding(padding: EdgeInsets.only(top: 10)));
    // listWidget.add(SliverPadding(padding: EdgeInsets.only(top: 10),));
    listWidget.addAll(
        this.buildListWidget(
            Utility.getListAfterOrder(
                missionOrderEnum, _missionModelListUnFinished) ??
                [],
            false));


    //完成的任务
    if (this.missionDataViewTypeEnum == MissionDataViewTypeEnum.list) {
      listWidget.addAll(this.buildListWidget(
          (SharePreferenceUtil.getSyncInstance().getCompleteMissionVisible() ==
                      false &&
                  this.widget.folderStatusDate != 6)
              ? []
              : (Utility.getListAfterOrder(
                      missionOrderEnum, _missionModelListFinished) ??
                  []),
          true));
    } else {}

    return [
      ...listWidget,
    ];
  }




  List<Widget> buildListWidget(List<SessionMissionModel> list, bool isFinish) {
    List<Widget> listWidget = [];
    list.forEach((SessionMissionModel sessionMissionModel) {
      bool isDelay = false;
      if (sessionMissionModel.title?.indexOf("2023年12月31日") != -1) {
        print("");
      }
      if (sessionMissionModel.date != null) {
        if (sessionMissionModel.date?.year == 2023 &&
            sessionMissionModel.date?.month == 12 &&
            sessionMissionModel.date?.day == 30) {
          print("");
        }
        isDelay = Utility.isDelayed(sessionMissionModel.date ?? DateTime.now());
      }
      if ((sessionMissionModel.datas?.length ?? 0) > 0) {
        listWidget.add(MissionDetailMissionSilverList(
          multiSelectModeEnum: this.multiSelectModeEnum,
          //未完成任务列表
          datas: sessionMissionModel.datas ?? [],
          onTapUnFinishListener: (data) {
            this.onClick('onClickUnFinishListener', data); //点击完成任务
          },
          onTapPlayListener: (obj) {
            this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapListener: (obj) {
          },
          onTapFinishListener: (data) {
            this.onClick('onClickFinishItem', data); //点击完成任务
          },
        ));
      }
    });
    if (this.widget.folderStatusDate == 1) {
      CounterMethodChannelManager.getInstance().storeMissionList(list);
    }
    return listWidget;
  }



//  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  requestDatas({bool shouldUpdate = true}) {
    int curIndexListViewAndGridView = 0;
    //不能去掉 否则重新安装重新登录讲没有最新数据
    this.isListAndGridVisible = true;
    resetMultiSelectModeEnum();
    try {
      calendarModel =
          Provider.of<GlobalStateEnv>(context, listen: false).calendarModel;
    } catch (e) {}
    List<MissionModel> datas = [];
    curListMissionModels = [];
    if (this.widget.folderModel?.tag == 2) {
      curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
          .getInt(
              key: ShareprefrenceKeys.listAndGridView +
                  this.widget.folderStatusDate.toString() +
                  (this.widget.folderModel?.objectId ?? ""),
              defaultVal: 1);
      missionDataViewTypeEnum =
          MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
      datas = MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByTagName(
              tagName: this.widget.folderModel?.title ?? "");
    } else {
      if (this.widget.folderStatusDate == 0 ||
          this.widget.folderStatusDate == null) {
        //从正常FoldersPage跳转过来的 只展示List

        //从正常文件过来
        this.isListAndGridVisible = false;
        this.missionDataViewTypeEnum = MissionDataViewTypeEnum.list;
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByFolderModelObjectId(
                objectId: this.widget.folderModel?.objectId);
      } else if (this.widget.folderStatusDate == 1) {
        // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
        this.folderStatusIsArchived = 0; // 未归档
        //FoldersPage 今天之前的 23:59:59
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 0)];
        datas = CONSTANTS.getMissionModelFromDayModel(
            CONSTANTS.getDayModelList(calendarModel,
                endDateTime: Utility.getFilterDateTimeFromTimeStamp(
                    DateTime.now().millisecondsSinceEpoch, true)),
            shouldRequireIsNotFinished: true);
      } else if (this.widget.folderStatusDate == 2) {
        //FoldersPage 明天之前的 23:59:59 今天之后 的
        this.folderStatusIsArchived = 0; // 未归档
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 1)];
        datas = CONSTANTS.getMissionModelFromDayModel(CONSTANTS.getDayModelList(
            calendarModel,
            startDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 1000),
            endDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 1000,
                true)));
      } else if (this.widget.folderStatusDate == 3) {
        //FoldersPage 明天之前的 23:59:59 7天之前的的
        this.folderStatusIsArchived = 0; // 未归档
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 1)];
        datas = CONSTANTS.getMissionModelFromDayModel(CONSTANTS.getDayModelList(
            calendarModel,
            endDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch + 6 * 24 * 60 * 60 * 1000,
                true)));
      } else if (this.widget.folderStatusDate == 4) {
        //待定 还没设定时间的
        this.folderStatusIsArchived = 0; // 未归档
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 1)];
        datas = MongoApisManager.getFinishedMissionModelsFromList(
            MongoApisManager.getInstance()
                .queryWhereEqual_missionDataByEndTime());
      } else if (this.widget.folderStatusDate == 6) {
        //完成列表查询
        this.folderStatusIsArchived = 0; // 未归档
        curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
            .getInt(
                key: ShareprefrenceKeys.listAndGridView +
                    this.widget.folderStatusDate.toString() +
                    (this.widget.folderModel?.objectId ?? ""),
                defaultVal: 1);
        missionDataViewTypeEnum =
            MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByFinished();
      } else if (this.widget.folderStatusDate == 9) {
        //do it now 现在做
        curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
            .getInt(
                key: ShareprefrenceKeys.listAndGridView +
                    this.widget.folderStatusDate.toString() +
                    (this.widget.folderModel?.objectId ?? ""),
                defaultVal: 1);
        missionDataViewTypeEnum =
            MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByDoItNowMissionWithoutFinish();
      } else if (this.widget.folderStatusDate == 10) {
        //所有任务
        curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
            .getInt(
                key: ShareprefrenceKeys.listAndGridView +
                    this.widget.folderStatusDate.toString() +
                    (this.widget.folderModel?.objectId ?? ""),
                defaultVal: 1);
        missionDataViewTypeEnum =
            MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
        datas = MongoApisManager.getInstance().listMissionModels;
      }
    }
    checkButtonListWithIconWidgetKey?.currentState
        ?.setCurIndex(curIndexListViewAndGridView);
    //如果curSearchWords有值 就支持搜索功能
    if (!TextUtil.isEmpty(curSearchWords)) {
      datas = Utility.filterMissionModel(curSearchWords ?? "", datas);
    }

    Utility.parseMissionModelsToSessionMissionMidelListByFolderName(
        datas, CONSTANTS.folderModelList);
    if (mounted) {
      _missionModelListFinished =
          Utility.getMissionModelFinished(datas); //完成的任务
      _missionModelListUnFinished =
          Utility.getMissionModelUnfinished(datas); //未完成任务
      if (shouldUpdate == true) {
        if (mounted == true) {
          setState(() {});
        }
      }
    }
    this.curListMissionModels = datas;
  }

  void resetMultiSelectModeEnum() {
    this.curListMissionModels?.forEach((element) {
      element.isSelected = false;
    });
    this.multiSelectModeEnum = MultiSelectModeEnum.normal;
    updateUI();
  }

  /**
   * 完成任务的SectionHeader
   */
  initSliverPersistentHeader(String title,
      {bool isDelay = false, String? subtitle, Function? onClickSubtitle}) {
    return SliverPersistentHeader(
        //是否固定头布局 默认false
        pinned: false,
        //是否浮动 默认false
        floating: false,
        delegate: MySliverDelegate(
          //缩小后的布局高度
          minHeight: 30.0,
          //展开后的高度
          maxHeight: 30.0,
          child: Container(
              padding: EdgeInsets.fromLTRB(25, 0, 0, 7),
              // color: ColorsConfig.backgroundColor,
              alignment: Alignment(-1, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xffa3a3a3),
                            shadows: [
                              Shadow(color: Colors.white, offset: Offset(1, 1))
                            ]),
                      ),
                      if (isDelay == true)
                        Text(
                          "(" + getI18NKey().already_delay + ")",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              shadows: [
                                Shadow(
                                    color: Colors.white, offset: Offset(1, 1))
                              ]),
                        ),
                    ],
                  ),
                  if (subtitle != null)
                    InkWell(
                      onTap: () {
                        if (isDelay == true) {
                          onClickSubtitle?.call();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                              shadows: [
                                Shadow(
                                    color: Colors.white, offset: Offset(1, 1))
                              ]),
                        ),
                      ),
                    ),
                ],
              )),
        ));
  }

  //已完成任务
}

