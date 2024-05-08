import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/SearchBarWidget.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/CalendarMssionEnv.dart';
import 'package:time_hello/com/timehello/common/provider/GlobalStateEnv.dart';
import 'package:time_hello/com/timehello/components/CustomBlackButton.dart';
import 'package:time_hello/com/timehello/components/ExportMissionListDialogUtil.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/components/SearchBarWithIconWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/page/CreateMissionPage/CreateMissionPage.dart';
import 'package:time_hello/com/timehello/page/RichEditor/RichEditorPage.dart';
import 'package:time_hello/com/timehello/page/SettingItemDetailPage/SettingItemDetailPage.dart';
import 'package:time_hello/com/timehello/page/calendarPage/TimeManagementPage.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/GridMissionSilverList.dart';
import 'package:time_hello/com/timehello/page/statisticPage/pages/FolderSummaryPage.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/GridSectionTitleWidget.dart';
import '../../../components/MoreWidget.dart';
import '../../../components/SectionTitleWidget.dart';
import '../../../config/ENUMS.dart';
import '../../../interface/OnCallbackListener.dart';
import '../../../models/MissionModel.dart';
import '../../../models/SessionMissionModel.dart';
import '../../missionPage/componnents/MissionSilverList.dart';

class CalendarMissionListWidget extends StatefulWidget {
  Function(DateTime?, DateTime?)? onDateRangeSelected;
  CalendarMissionListWidget({Key? key, this.onDateRangeSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CalendarMissionListWidgetState();
  }

}

class CalendarMissionListWidgetState extends State<CalendarMissionListWidget> {
  FolderModel folderModel = FolderModel(); //FoldersPage页面传入的数据

  MultiSelectModeEnum multiSelectModeEnum = MultiSelectModeEnum.normal;
  List<MissionModel>? curListMissionModels = [];
  CalendarModel? calendarModel;
  int folderStatusIsArchived = -1; // -1 未归档 归档 0 未归档 1 归档
  String? curSearchWords = null;
  FolderTimeModel? _folderTimeModel = new FolderTimeModel(); //头部4个参数时间
  List<MissionModel> _missionModelListUnFinished = []; //未完成任务
  List<MissionModel> _missionModelListFinished = []; //已经完成任务
  bool isSearchBarVisible = false;
  MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByTime;

  DateTime? startDateTime;
  DateTime? endDateTime;

  int folderStatus = -1;
  // MultiSelectModeEnum multiSelectModeEnum = MultiSelectModeEnum.normal;
  List<MissionModel> list = [];
  // Color color = Colors.red;
  double subFontSize = 12;
  Color subColor = Color(0xff666666);
  double headerHeight = 80;
  GlobalKey<SearchBarWidgetState>? searchBarWidgetKey = GlobalKey();
  // FolderModel folderModel = FolderModel();
  // OnTapListener onTapListener;
  // MissionOrderEnum missionOrderEnum;
  //
  // OnTapEditTitleListener? onTapEditTitleListener;
  // OnTapEditListener? onTapEditListener;
  // OnTapDeleteListener? onTapDeleteListener;
  // OnTapFinishListener? onTapFinishListener;
  // OnTapPlayListener? onTapPlayListener;
  // OnTapMultiSelectListener? onTapMultiSelectListener;
  // Function? onTapDoItNow;
  // OnTapUnFinishListener? onTapUnFinishListener;
  // Function onTapCreateListener;
  // Function onTapShowFolderChartListener;

  // CalendarMissionListWidget(
  // // {
  //   // required this.multiSelectModeEnum,
  //   // required this.list,
  //   // required this.onTapListener,
  //   // required this.onTapCreateListener,
  //   // // required this.onTapShowFolderChartListener,
  //   // required this.missionOrderEnum,
  //   // required this.folderStatus,
  //   // this.onTapEditTitleListener,
  //   // this.onTapEditListener,
  //   // this.onTapDoItNow,
  //   // this.onTapDeleteListener,
  //   // this.onTapFinishListener,
  //   // this.onTapPlayListener,
  //   // this.onTapMultiSelectListener,
  //   // this.onTapUnFinishListener,
  // // }
  // )

  @override
  void initState() {
    super.initState();
    this.requestDatas();
    // missionOrderEnum =
    //     SharePreferenceUtil.getSyncInstance().getMissionOrderEnum();
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
  void deactivate() {
    super.deactivate();
    unfocus(withUpdateUI: false);
  }

  void unfocus({withUpdateUI: true}) {
    // HeaderWidgetStateGlobalKey?.currentState?.unfocus();
    searchBarWidgetKey?.currentState?.unfocus();
    if (withUpdateUI == true) {
      updateUI();
    }
  }

  void resetMultiSelectModeEnum(bool shouldUpdate) {
    this.curListMissionModels?.forEach((element) {
      element.isSelected = false;
    });
    this.multiSelectModeEnum = MultiSelectModeEnum.normal;
    if(shouldUpdate) {
      updateUI();
    }
  }

  updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void onClickSearch(searchWord) {
    this.curSearchWords = searchWord;
    requestDatas();
  }

  //  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  requestDatas({bool shouldUpdate = true}) {
    int curIndexListViewAndGridView = 0;
    //不能去掉 否则重新安装重新登录讲没有最新数据
    // this.isListAndGridVisible = true;
    resetMultiSelectModeEnum(shouldUpdate);
    try {
      calendarModel =
          Provider.of<GlobalStateEnv>(context, listen: false).calendarModel;
    } catch (e) {}
    // List<MissionModel> datas = [];
    curListMissionModels = [];
    // if (this.folderModel?.tag == 2) {
    //   curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
    //       .getInt(
    //       key: ShareprefrenceKeys.listAndGridView +
    //           this.widget.folderStatusDate.toString() +
    //           (this.folderModel?.objectId ?? ""),
    //       defaultVal: 1);
    //   // missionDataViewTypeEnum =
    //   // MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
    //   datas = MongoApisManager.getInstance()
    //       .queryWhereEqual_missionDataByTagName(
    //       tagName: this.folderModel?.title ?? "");
    // } else {
    //   if (this.widget.folderStatusDate == 0 ||
    //       this.widget.folderStatusDate == null) {
    //     //从正常FoldersPage跳转过来的 只展示List

        //从正常文件过来
        // this.isListAndGridVisible = false;
        // this.missionDataViewTypeEnum = MissionDataViewTypeEnum.list;
    List<MissionModel> listMissionModels = [];
    if(this.startDateTime != null && this.endDateTime != null) {
      List<DayModel> dayModelList = Utility.filterDaysModelsByDateTimeRange(
          calendarModel?.dayModelList ?? [], folderModel, this.startDateTime,
          this.endDateTime);
      listMissionModels = Utility.getMissionModelListFromList(dayModelList);
    } else {
      listMissionModels = MongoApisManager.getInstance().listMissionModels;
    }
        list = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByFolderModelObjectId(
            objectId: this.folderModel?.objectId, listMissionModels: listMissionModels);
      // } else if (this.widget.folderStatusDate == 13) {
      //   // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
      //   this.folderStatusIsArchived = 0; // 未归档
      //   //FoldersPage 今天之前的 23:59:59
      //   // missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
      //   // curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //   //     .getInt(
      //   //     key: ShareprefrenceKeys.listAndGridView +
      //   //         this.widget.folderStatusDate.toString(),
      //   //     defaultVal: 0)];
      //   datas = MongoApisManager.getInstance()
      //       .queryWhereEqual_missionDataByDateStatus(
      //       dateStatus: this.widget.folderStatusDate);
      // } else if (this.widget.folderStatusDate == 12) {
      //   // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
      //   this.folderStatusIsArchived = 0; // 未归档
      //   //FoldersPage 今天之前的 23:59:59
      //   // missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
      //   // curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //   //     .getInt(
      //   //     key: ShareprefrenceKeys.listAndGridView +
      //   //         this.widget.folderStatusDate.toString(),
      //   //     defaultVal: 0)];
      //   datas = MongoApisManager.getInstance()
      //       .queryWhereEqual_missionDataByDateStatus(
      //       dateStatus: this.widget.folderStatusDate);
      // } else if (this.widget.folderStatusDate == 1) {
      //   // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
      //   this.folderStatusIsArchived = 0; // 未归档
      //   //FoldersPage 今天之前的 23:59:59
      //   // missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
      //   // curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //   //     .getInt(
      //   //     key: ShareprefrenceKeys.listAndGridView +
      //   //         this.widget.folderStatusDate.toString(),
      //   //     defaultVal: 0)];
      //   datas = CONSTANTS.getMissionModelFromDayModel(
      //       CONSTANTS.getDayModelList(calendarModel,
      //           endDateTime: Utility.getFilterDateTimeFromTimeStamp(
      //               DateTime.now().millisecondsSinceEpoch, true)),
      //       shouldRequireIsNotFinished: true);
      // } else if (this.widget.folderStatusDate == 2) {
      //   //FoldersPage 明天之前的 23:59:59 今天之后 的
      //   this.folderStatusIsArchived = 0; // 未归档
      //   // missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
      //   // curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //   //     .getInt(
      //   //     key: ShareprefrenceKeys.listAndGridView +
      //   //         this.widget.folderStatusDate.toString(),
      //   //     defaultVal: 1)];
      //   datas = CONSTANTS.getMissionModelFromDayModel(CONSTANTS.getDayModelList(
      //       calendarModel,
      //       startDateTime: Utility.getFilterDateTimeFromTimeStamp(
      //           DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 1000),
      //       endDateTime: Utility.getFilterDateTimeFromTimeStamp(
      //           DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 1000,
      //           true)));
      // } else if (this.widget.folderStatusDate == 3) {
      //   //FoldersPage 明天之前的 23:59:59 7天之前的的
      //   this.folderStatusIsArchived = 0; // 未归档
      //   // missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
      //   // curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //   //     .getInt(
      //   //     key: ShareprefrenceKeys.listAndGridView +
      //   //         this.widget.folderStatusDate.toString(),
      //   //     defaultVal: 1)];
      //   datas = CONSTANTS.getMissionModelFromDayModel(CONSTANTS.getDayModelList(
      //       calendarModel,
      //       endDateTime: Utility.getFilterDateTimeFromTimeStamp(
      //           DateTime.now().millisecondsSinceEpoch + 6 * 24 * 60 * 60 * 1000,
      //           true)));
      // } else if (this.widget.folderStatusDate == 4) {
      //   //待定 还没设定时间的
      //   this.folderStatusIsArchived = 0; // 未归档
      //   // missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
      //   // curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //   //     .getInt(
      //   //     key: ShareprefrenceKeys.listAndGridView +
      //   //         this.widget.folderStatusDate.toString(),
      //   //     defaultVal: 1)];
      //   datas = MongoApisManager.getFinishedMissionModelsFromList(
      //       MongoApisManager.getInstance()
      //           .queryWhereEqual_missionDataByEndTime());
      // } else if (this.widget.folderStatusDate == 6) {
      //   //完成列表查询
      //   this.folderStatusIsArchived = 0; // 未归档
      //   curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //       .getInt(
      //       key: ShareprefrenceKeys.listAndGridView +
      //           this.widget.folderStatusDate.toString() +
      //           (this.folderModel?.objectId ?? ""),
      //       defaultVal: 1);
      //   // missionDataViewTypeEnum =
      //   // MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
      //   datas = MongoApisManager.getInstance()
      //       .queryWhereEqual_missionDataByFinished();
      // } else if (this.widget.folderStatusDate == 9) {
      //   //do it now 现在做
      //   curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //       .getInt(
      //       key: ShareprefrenceKeys.listAndGridView +
      //           this.widget.folderStatusDate.toString() +
      //           (this.folderModel?.objectId ?? ""),
      //       defaultVal: 1);
      //   // missionDataViewTypeEnum =
      //   // MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
      //   datas = MongoApisManager.getInstance()
      //       .queryWhereEqual_missionDataByDoItNowMissionWithoutFinish();
      // } else if (this.widget.folderStatusDate == 10) {
      //   //所有任务
      //   curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
      //       .getInt(
      //       key: ShareprefrenceKeys.listAndGridView +
      //           this.widget.folderStatusDate.toString() +
      //           (this.folderModel?.objectId ?? ""),
      //       defaultVal: 1);
      //   // missionDataViewTypeEnum =
      //   // MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
      //   datas = MongoApisManager.getInstance().listMissionModels;
      // }
    // }
    // checkButtonListWithIconWidgetKey?.currentState
    //     ?.setCurIndex(curIndexListViewAndGridView);
    //如果curSearchWords有值 就支持搜索功能
    if (!TextUtil.isEmpty(curSearchWords)) {
      list = Utility.filterMissionModel(curSearchWords ?? "", list);
    }

    Utility.parseMissionModelsToSessionMissionMidelListByFolderName(
        list, CONSTANTS.folderModelList);
    if (mounted) {
      _folderTimeModel = Utility.getFolderTimeModel(list); //头部4个参数时间
      _missionModelListFinished =
          Utility.getMissionModelFinished(list); //完成的任务
      _missionModelListUnFinished =
          Utility.getMissionModelUnfinished(list); //未完成任务
      if (shouldUpdate == true) {
        if (mounted == true) {
          setState(() {});
        }
      }
    }
    this.curListMissionModels = list;
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSubtitle':
        await onClickSubtitlePostpone(data);
        break;
      case 'onClickShowFolderChart': //点击添加任务
        onClickShowFolderChart(data);
        break;
    // case 'onClickSubmit': //添加Mission
    //   if (this._numberTomatoes == 0) {
    //     Utility.showToast(msg: getI18NKey().alertMessage1);
    //     return;
    //   }
    //   if (TextUtil.isEmpty(this._title) == true) {
    //     Utility.showToast(msg: getI18NKey().alertMessage2);
    //     return;
    //   }
    //   onClickSubmit(this._title);
    //   break;
      case 'onClickMissionSetting': //跳转到设置叶敏
        onClickMissionSetting(data);
        break;
      case 'onClickMissionDetail': //跳转到任务详情页MissionPage开始任务
      //点击item
        onClickMissionStart(context, data, this.folderModel);
        break;
      case 'onClickDeleteItem': //侧滑点击删除
      //创建任务
        await onClickDeleteItem(data);
        break;
      case 'onClickFinishItem': //点击完成任务
        this.onClickFinishItem(data);
        break;
      case 'onClickCreate':
        onClickCreate();
        break;
      case 'onTapDoItNow':
        this.onTapDoItNow(data);
        break;
      case 'onClickUnFinishListener':
        this.onClickUnFinishListener(data);
        break;
      case 'onTapMultiSelectListener':
        this.onTapMultiSelectListener(data);
        break;
    // case 'onTapEditTitleListener':
    //   this.onClickEditTitle(data);
    //   break;
    // // case 'onTapCreateTagListener': //去CreateFolderPage页面创建标签
    // //   this.onTapCreateTagListener();
    // //   break;
    //   case 'onTapTagListener': //创建mission时选择tag
    //     await onClickCreateTag(data);
    //     break;
    //   case 'onTapCircleListener': //穿件mission时选择目标文件夹
    //     this.onTapCircleListener(data);
    //     break;
    }
  }

  void onClickCreate() {
    MissionModel missionModel = MissionModel();
    missionModel.end_time = CONSTANTS.getDeadLineTme((0) + 1);
    missionModel.folder_id = this.folderModel.objectId;
    if (Utility.isHandsetBySize() == true) {
      Utility.pushNavigator(context,
          CreateMissionPage(missionModel: missionModel));
    } else {
      DialogManagement.getInstance().showPCCustomDialog(
          context: context,
          widget:
          CreateMissionPage(missionModel: missionModel));
    }
  }

  /**
   * 跳转到任务详情页MissionPage开始任务
   */
  static void onClickMissionStart(
      BuildContext context, MissionModel data, FolderModel? folderModel) async {
    // 有任务进行中给出提示
    if (CounterManagement.getInstance().counterStatus ==
        CounterStatus.focusing &&
        !TextUtil.isEmpty(
            CounterManagement.getInstance().missionModel?.title) &&
        data?.title != CounterManagement.getInstance().missionModel?.title) {
      Utility.showAlertDialog(
          context: context,
          content: getI18NKey().missionRunningAlert(
              CounterManagement.getInstance().missionModel?.title ?? ""),
          onConfirm: () {
            OverlayManagement.getInstance().openMissionDetailPageOverlay(
                context: context, missionModel: data, folderModel: folderModel);
            // Utility.pushNavigator(
            //     context,
            //     new MissionDetailPage(
            //       missionModel: data,
            //       folderModel: this.folderModel,
            //     ));
          });
    } else {
      OverlayManagement.getInstance().openMissionDetailPageOverlay(
          context: context, missionModel: data, folderModel: folderModel);
      // Utility.pushNavigator(
      //     context,
      //     new MissionDetailPage(
      //       missionModel: data,
      //       folderModel: this.folderModel,
      //     ));
    }
  }

  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().delete,
        message: getI18NKey().confirmToDelete,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      await MongoApisManager.getInstance()
          .delete_MissionModel(currentObjectId: data.objectId);
      this.requestDatas();
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    }
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(MissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().confirmToFinished,
        message: getI18NKey().confirmToFinishedContent,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      await onClickFinishMission(data);
    }
  }

  Future<void> onClickFinishMission(MissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    await MongoApisManager.getInstance().insertStatsModel(
      title: data.title,
      type: 1,
      icon: this.folderModel?.icon,
      color: this.folderModel?.color,
      tagName: data.tagNames,
      fid: this.folderModel?.objectId,
      begin_time: Utility.getTimestampFromDateTime(data.createdAt ?? ""),
      finish_time: Utility.getTimeStampToday(),
      value: data.tomato_duration?.toDouble() ?? 0,
      category: data.title,
    );
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

  Future onTapDoItNow(MissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    Utility.onClickUpdateTimeDoItNow(Utility.getGlobalContext(), [data]);
  }

  Future onClickUnFinishListener(MissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToast(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    // await onClickFinishMission(data);
    data.isFinished = false;
    await MongoApisManager.getInstance()
        .update_MissionModel(missionModel: data);
  }

  onTapMultiSelectListener(data) async {
    if (data == null) {
      if (this.multiSelectModeEnum == MultiSelectModeEnum.normal) {
        this.multiSelectModeEnum = MultiSelectModeEnum.multiSelect;
      } else {
        this.multiSelectModeEnum = MultiSelectModeEnum.normal;
      }
    }
    updateUI();
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
            key: ValueKey("ejzifjfze43"),
            missionModel: data,
          ));
    } else {
      Utility.openRightSideDesktopNavigator(
          context, 'SettingItemDetailPage', {'missionModel': data});
    }
    context.read<CalendarMssionEnv>().curSelectedMissionModel = data;
  }

  onClickShowFolderChart(data) async {
    FolderModelWithExtraData res;
    if (data != null) {
      calendarModel = context.read<GlobalStateEnv>().calendarModel;
      res = CONSTANTS.getFolderModelWithExtraDataByFolderModel(
          folderModel: data, calendarModel: calendarModel!);
      Utility.openPagePCAndMobile(context,
          child: FolderSummaryPage(
            folderModelWithExtraData: res,
            shouldShowNav: Utility.isHandsetBySize(),
          ));
    }
  }

  Container getPopupMenu() {
    return Container(
      key: ValueKey('Container5'),
      margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
      child: PopupMenuButton<String>(
        key: ValueKey('PopupMenuButton5'),
        tooltip: '',
        padding: EdgeInsets.all(0.0),
        child: Container(
          key: ValueKey('Container5'),
          width: 40,
          height: 35,
          decoration: BoxDecoration(
            color: ThemeManager.getInstance()
                .getCardBackgroundColor(defaultColor: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Icon(Icons.swap_vert,
              size: 30,
              color: ThemeManager.getInstance().getColor(
                  defaultColor: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.red))),
        ),
        onSelected: (String val) {
          if (val == 'order_by_list') {
            this.missionOrderEnum = MissionOrderEnum.orderByWords;
          } else if (val == 'order_by_time') {
            this.missionOrderEnum = MissionOrderEnum.orderByTime;
          } else if (val == 'order_by_mission_priority') {
            this.missionOrderEnum = MissionOrderEnum.orderByPriority;
          } else if (val == 'order_by_mission_tag') {
            this.missionOrderEnum = MissionOrderEnum.orderByTag;
          }
          SharePreferenceUtil.getSyncInstance()
              .setMissionOrderEnum(missionOrderEnum);
          this.updateUI();
        },
        itemBuilder: (context) {
          // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              key: ValueKey('PopupMenuItem5'),
              value: 'order_by_list',
              child: Text(getI18NKey().order_by_list,
                  style: TextStyle(fontSize: 13)),
            ),
            PopupMenuItem<String>(
              key: ValueKey('PopupMenuItem5'),
              value: 'order_by_time',
              child: Text(
                getI18NKey().order_by_time,
                style: TextStyle(fontSize: 13),
              ),
            ),
            PopupMenuItem<String>(
              key: ValueKey('PopupMenuItem5'),
              value: 'order_by_mission_priority',
              child: Text(
                getI18NKey().order_by_mission_priority,
                style: TextStyle(fontSize: 13),
              ),
            ),
            PopupMenuItem<String>(
              key: ValueKey('PopupMenuItem6'),
              value: 'order_by_mission_tag',
              child: Text(
                getI18NKey().order_by_mission_tag,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ];
        },
      ),
    );
  }

  Future<void> onClickSubtitlePostpone(data) async {
    SessionMissionModel sessionMissionModel = data;
    int endTimeToday = Utility.getFilterDateTimeFromTimeStamp(
        DateTime.now().millisecondsSinceEpoch, true)
        .millisecondsSinceEpoch;
    sessionMissionModel.datas?.forEach((element) {
      element.end_time = endTimeToday;
    });
    if (sessionMissionModel.datas != null) {
      await MongoApisManager.getInstance()?.batchUpdate_MissionModelWithParams(
          listMissionModel: sessionMissionModel.datas ?? []);
    }
  }

  // double getFinishedPercent() {
  //   return Utility.getMissionModelFinished(list ?? []).length.toDouble() /
  //       ((list?.length ?? 0) > 0 ? (list?.length ?? 1) : 1);
  // }

  @override
  Widget build(BuildContext context) {
    return Selector<CalendarMssionEnv, MissionModel?>(
        selector: (_, env) => env.curSelectedMissionModel,
        builder: (_, curSelectedMissionModel, __) {
          return  Selector<CalendarMssionEnv, FolderModel?>(
              selector: (_, env) => env.curSelectedFolderModel,
              builder: (_, curSelectedFolderModel, __) {
                return  Selector<CalendarMssionEnv, DateTime?>(
                    selector: (_, env) => env.startDateTime,
                    builder: (_, startDateTime, __) {
                      return  Selector<CalendarMssionEnv, DateTime?>(
                          selector: (_, env) => env.endDateTime,
                          builder: (_, endDateTime, __) {
                            this.folderModel = curSelectedFolderModel ?? FolderModel();
                            requestDatas(shouldUpdate: false);
                            return
                                GestureDetector(
                                  onTap: () {
                                    unfocus();
                                  },
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverToBoxAdapter(
                                        child: Column(
                                          children: [
                                            Container(
                                              // padding: EdgeInsets.only(
                                              //   left: margin,
                                              // ),
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  //银色 reset_alt 的icon可点击
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: () {
                                                      this.startDateTime = null;
                                                      this.endDateTime = null;
                                                      context.read<CalendarMssionEnv>().startDateTime = null;
                                                      context.read<CalendarMssionEnv>().endDateTime = null;
                                                      this.widget.onDateRangeSelected?.call(this.startDateTime, this.endDateTime);
                                                    },
                                                    child: Icon(Icons.restart_alt,
                                                        size: 20,
                                                        color: ThemeManager.getInstance()
                                                            .getIconColor()),
                                                  ),


                                                  Spacer(),
                                                  // Wrap(
                                                  //   crossAxisAlignment: WrapCrossAlignment.center,
                                                  //   children: [
                                                  //     // CustomTextField(
                                                  //     //     key: UniqueKey(),
                                                  //     //     //每次都会重新创建
                                                  //     //     maxWidth: Utility.isHandsetBySize() == true ? 200 : 400,
                                                  //     //     isEditable: this.folderModel?.tag == 2 ||
                                                  //     //         this.folderModel?.tag == 1,
                                                  //     //     style: TextStyle(
                                                  //     //         fontSize: 20,
                                                  //     //         color: ThemeManager.getInstance()
                                                  //     //             .getTextColor(defaultColor: ColorsConfig.gray_40),
                                                  //     //         fontWeight: FontWeight.bold),
                                                  //     //     text: this.folderModel?.title ?? "",
                                                  //     //     onEnterListener: (v) {
                                                  //     //       this.folderModel?.title = v;
                                                  //     //       if (this.folderModel != null) {
                                                  //     //         MongoApisManager.getInstance().update_FolderModelWithFM(
                                                  //     //             folderModel: this.folderModel!,
                                                  //     //             shouldQueryMissionModel: false);
                                                  //     //       }
                                                  //     //     }),
                                                  //     // Text(
                                                  //     //   this.folderModel?.title ?? "",
                                                  //     //   style: TextStyle(
                                                  //     //       fontSize: 20,
                                                  //     //       color: ThemeManager.getInstance()
                                                  //     //           .getColor(defaultColor: ColorsConfig.gray_40),
                                                  //     //       fontWeight: FontWeight.bold),
                                                  //     // ),
                                                  //     SizedBox(
                                                  //       width: 4,
                                                  //     ),
                                                  //     ListingSecurityWidget(
                                                  //       folder_id: this.folderModel?.objectId ?? "",
                                                  //       cryptoVersion: this.folderModel?.cryptoVersion ?? -1,
                                                  //     )
                                                  //   ],
                                                  // ),
                                                  Row(
                                                    children: [
                                                      SearchBarWithIconWidget(
                                                  shouldShowSearchBar: false,
                                                        key: ValueKey("ejfiejf"),
                                                        onChange: (searchWord) {
                                                          onClickSearch(searchWord);
                                                        },
                                                        onClickSearchListener: (bool res) {
                                                          this.isSearchBarVisible = res;
                                                          updateUI();
                                                        },
                                                      ),
                                                      (this.folderModel?.tag == 1 ||
                                                          this.folderModel?.tag == 2)
                                                          ? InkWell(
                                                        onTap: () async {
                                                          TimelineMissionModel? timelineMissionModel = null;
                                                          if (TextUtil.isEmpty(this
                                                              .folderModel
                                                              ?.timelineNoteObjectId) ==
                                                              false) {
                                                            timelineMissionModel = await MongoApisManager
                                                                .getInstance()
                                                                .queryWhereEqual_TimelineMissionModelByObjectId(
                                                                objectId: this
                                                                    .folderModel
                                                                    ?.timelineNoteObjectId ??
                                                                    "");
                                                            timelineMissionModel?.sceneType = "note";
                                                            timelineMissionModel?.eventType = "note";
                                                          } else {
                                                            timelineMissionModel = TimelineMissionModel();
                                                            timelineMissionModel.folder_id =
                                                                this.folderModel?.objectId ?? null;
                                                            timelineMissionModel.tagNames =
                                                            this.folderModel?.tag == 2
                                                                ? this.folderModel?.title
                                                                : "";
                                                            timelineMissionModel.color =
                                                                this.folderModel?.color;
                                                            timelineMissionModel.icon =
                                                                this.folderModel?.icon;
                                                            timelineMissionModel.sceneType = "note";
                                                            timelineMissionModel.eventType = "note";
                                                            // timelineMissionModel.
                                                          }
                                                          Utility.openPagePCAndMobile(context,
                                                              child: RichEditorPage(
                                                                  onOkListener: (url,
                                                                      timelineMissionModelObjectId,
                                                                      numberNoteWords) async {
                                                                    this.folderModel?.noteUrl = url;
                                                                    this.folderModel?.numberNoteWords =
                                                                        numberNoteWords;
                                                                    if (timelineMissionModelObjectId != null) {
                                                                      this
                                                                          .folderModel
                                                                          ?.timelineNoteObjectId =
                                                                          timelineMissionModelObjectId;
                                                                    }
                                                                    await MongoApisManager.getInstance()
                                                                        .update_FolderModelWithFM(
                                                                        folderModel:
                                                                        this.folderModel ??
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

                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          TextEditingController textEditingController =
                                                          TextEditingController();
                                                          String s = Utility.getContentFromMissionList(
                                                              datas: this.curListMissionModels ?? [],
                                                              listCheckButtonModel: CONSTANTS.getExportButtonsList());
                                                          textEditingController.text = s;
                                                          ExportMissionListDialogUtil.show(context,
                                                              textEditingController: textEditingController,
                                                              onTapListener: (res) {
                                                                List<CheckButtonStateModel> data = res['data'];
                                                                MissionOrderEnum missionOrderEnum = res['enum'];
                                                                String s = Utility.getContentFromMissionList(
                                                                    datas: Utility.getMissionModelListAfterOrder(
                                                                        missionOrderEnum,
                                                                        this.curListMissionModels ?? []),
                                                                    listCheckButtonModel: data);
                                                                textEditingController.text = s;
                                                                updateUI();
                                                              }, export: (data) {
                                                                Utility.showToast(
                                                                    context: context,
                                                                    msg: getI18NKey().offer_next_version);
                                                              });
                                                          // Utility.getContentFromMissionList(datas: this.missionListOriginal, listCheckButtonModel: CONSTANTS.getMi);
                                                        },
                                                        child: CustomBlackButton(
                                                          text: getI18NKey().export,
                                                          color: ThemeManager.getInstance()
                                                              .getColor(defaultColor: Colors.red),
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      getPopupMenu()
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            (this.isSearchBarVisible)
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
                                                : SizedBox.shrink(),
                                            CalendarDatePicker2(
                                              config: CalendarDatePicker2Config(
                                                selectedDayHighlightColor:
                                                ThemeManager.getInstance()
                                                    .getDefautThemeColor(),
                                                todayTextStyle: TextStyle(
                                                    color: ThemeManager.getInstance()
                                                        .getDefautThemeColor()),
                                                calendarType: CalendarDatePicker2Type.range,
                                              ), value: this.startDateTime == null ? [] : (this.startDateTime != null && this.endDateTime != null && this.startDateTime?.year == this.endDateTime?.year && this.startDateTime?.month == endDateTime?.month && this.startDateTime?.day == this.endDateTime?.day) ? [this.startDateTime] : [this.startDateTime, this.endDateTime],
                                              // value: _dates,
                                              onValueChanged: (dates) {
                                                if(dates.length == 1) {
                                                  DateTime dateTime = dates[0] ?? DateTime.now();
                                                  this.startDateTime = dateTime;
                                                  this.endDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
                                                  context.read<CalendarMssionEnv>().startDateTime = startDateTime;
                                                  context.read<CalendarMssionEnv>().endDateTime = this.endDateTime;
                                                } else if(dates.length == 2) {
                                                  this.startDateTime = dates[0];
                                                  DateTime endDateTime = dates[1] ?? DateTime.now();
                                                  this.endDateTime = DateTime(endDateTime!.year, endDateTime!.month, endDateTime!.day, 23, 59, 59);
                                                  context.read<CalendarMssionEnv>().startDateTime = dates[0];
                                                  context.read<CalendarMssionEnv>().endDateTime = this.endDateTime;
                                                  print(dates);
                                                } else {
                                                  context.read<CalendarMssionEnv>().startDateTime = null;
                                                  context.read<CalendarMssionEnv>().endDateTime = null;
                                                }
                                                this.widget.onDateRangeSelected?.call(this.startDateTime, this.endDateTime);
                                              },
                                            ),

                                            Align(
                                                child: InkWell(
                                                  onTap: () {
                                                    this.onClick("onClickCreate", null);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                          color: ThemeManager.getInstance().getButtonBorderColor(
                                                              defaultDarkColor: Colors.white),
                                                          width: 1,
                                                        ),
                                                        color: ThemeManager.getInstance().getButtonBackgroundColor(
                                                            defaultDarkColor: Colors.white)
                                                      // gradient: LinearGradient(
                                                      //     colors:
                                                      //     ColorsConfig.listColorsOrangeLightToHeavyButton),
                                                    ),
                                                    width: 260,
                                                    height: 35,
                                                    child: Text(
                                                      getI18NKey().create,
                                                      style: TextStyle(
                                                          color: ThemeManager.getInstance()
                                                              .getTextColor(defaultColor: Colors.white),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      ...getList()
                                      // SliverToBoxAdapter(
                                      //   child: CalendarMissionListWidget(
                                      //     list: this.curListMissionModels ?? [],
                                      //     onTapMultiSelectListener: (MissionModel? list) {
                                      //       this.onClick('onTapMultiSelectListener', list);
                                      //     },
                                      //     onTapDoItNow: (data) {
                                      //       this.onClick('onTapDoItNow', data);
                                      //     },
                                      //     //未完成任务列表
                                      //     onTapUnFinishListener: (data) {
                                      //       this.onClick('onClickUnFinishListener', data); //点击完成任务
                                      //     },
                                      //     onTapEditTitleListener: (obj) {
                                      //       this.onClick('onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
                                      //     },
                                      //     onTapPlayListener: (obj) {
                                      //       this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
                                      //     },
                                      //     onTapListener: (obj) {
                                      //       this.onClick('onClickMissionSetting', obj); //跳转到设置叶敏
                                      //     },
                                      //     onTapDeleteListener: (data) async {
                                      //       this.onClick('onClickDeleteItem', data); //侧滑点击删除
                                      //     },
                                      //     onTapEditListener: (data) {
                                      //       this.onClick('onClickMissionSetting', data);
                                      //     },
                                      //     onTapFinishListener: (data) {
                                      //       this.onClick('onClickFinishItem', data); //点击完成任务
                                      //     },
                                      //     onTapCreateListener: (data) {
                                      //       this.onClick('onClickCreateItem', data); //点击完成任务
                                      //     },
                                      //     // onTapShowFolderChartListener: (data) {
                                      //     //   this.onClick('onClickShowFolderChart', data); //点击完成任务
                                      //     // },
                                      //     missionOrderEnum: missionOrderEnum,
                                      //     folderStatus: 1,
                                      //     multiSelectModeEnum: multiSelectModeEnum,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                );
                          });
                    });
              });
        });
  }

  List<Widget> getList() {
    List<Widget> listWidget = [];
    listWidget.addAll(buildListWidget(Utility.getListAfterOrder(
        this.missionOrderEnum, Utility.filterMissionModelByFinishedState(list: this.list ?? [], isFinished: false), this.folderStatus) ?? [], false));
    listWidget.add(MoreWidget(
      text: getI18NKey().missionCompleted,
      // onTapListener: () {
      //   this.onTapMoreListener.call();
      // },
    ));
    listWidget.addAll(buildListWidget(Utility.getListAfterOrder(
        this.missionOrderEnum, Utility.filterMissionModelByFinishedState(list: this.list ?? [], isFinished: true), this.folderStatus) ?? [], true));
    return listWidget;
  }

  List<Widget> buildListWidget(List<SessionMissionModel> list, bool isFinish) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      SessionMissionModel model = list[i];
      if((model.datas?.length ?? 0) > 0) {
        listWidget.add(SliverToBoxAdapter(
          child: GridSectionTitleWidget(
            title: model.title ?? "",
          ),
        ));
        listWidget.add(GridMissionSilverList(
          datas: Utility.parseMissionModelsByIsFinishedAndPriority(
              model.datas ?? []),
          onTapMultiSelectListener: (MissionModel? list) {
            this.onClick('onTapMultiSelectListener', list);
          },
          onTapDoItNow: (data) {
            this.onClick('onTapDoItNow', data);
          },
          //未完成任务列表
          onTapUnFinishListener: (data) {
            this.onClick('onClickUnFinishListener', data); //点击完成任务
          },
          onTapEditTitleListener: (obj) {
            this.onClick('onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapPlayListener: (obj) {
            this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapListener: (obj) {
            this.onClick('onClickMissionSetting', obj); //跳转到设置叶敏
          },
          onTapDeleteListener: (data) async {
            this.onClick('onClickDeleteItem', data); //侧滑点击删除
          },
          onTapEditListener: (data) {
            this.onClick('onClickMissionSetting', data);
          },
          onTapFinishListener: (data) {
            this.onClick('onClickFinishItem', data); //点击完成任务
          },
          multiSelectModeEnum: this.multiSelectModeEnum,
        ));
      }
    }
    return listWidget;
    // return [
    //   SliverPadding(padding: EdgeInsets.only(top: 3)),
    //   SliverToBoxAdapter(
    //     child: SectionTitleWidget(
    //       title: '优先级',
    //     ),
    //   ),
    //
    // ];
  }
}
