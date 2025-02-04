import 'dart:core';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/SearchBarWithIconWidget.dart';
import 'package:time_hello/com/timehello/components/StorageUsageBar.dart';
import 'package:time_hello/com/timehello/components/TimeRatioComponent.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MissionGridView.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MultiSelectHandleWidget.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../r.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CheckButtonListWithIconWidget.dart';
import '../../components/CircleWidget.dart';
import '../../components/CustomBlackButton.dart';
import '../../components/CustomMarquee.dart';
import '../../components/CustomPopupWidget.dart';
import '../../components/CustomTextField.dart';
import '../../components/ExportMissionListDialogUtil.dart';
import '../../components/ListingSecurityWidget.dart';
import '../../components/MissionTableContainerWidget.dart';
import '../../components/SearchBarWidget.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../models/CalendarModel.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../models/SessionMissionModel.dart';
import '../../models/TimelineMissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../RichEditor/RichEditorPage.dart';
import '../SettingItemDetailPage/SettingItemDetailPage.dart';
import '../statisticPage/pages/FolderSummaryPage.dart';
import 'componnents/BottomBar.dart';
import 'componnents/HeaderStatsAndInputWidget.dart';
import 'componnents/HeaderStatsAndInputWidget.dart';
import 'componnents/MissionSilverList.dart';

class MissionPage extends BaseWidget {
  FolderModel folderModel = FolderModel(); //FoldersPage页面传入的数据
  int? folderStatusDate = 1; // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 6 已完成
  Function? onTapNavMenuListener;
  Function? onTapRightNavMenuListener;

  MissionPage(
      {Key? key,
      FolderModel? folderModel,
      this.onTapRightNavMenuListener,
      this.folderStatusDate,
      this.onTapNavMenuListener}) {
    FolderModel folderModelTmp = CONSTANTS.getMenuList([],
        isMobile: screenType == ScreenType.Handset)[0].folderModel;
    this.folderModel = folderModel ?? folderModelTmp;
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _MisssionPageWidgetState(
        folderStatus: this.folderStatusDate, folderModel: this.folderModel);
  }
}

class _MisssionPageWidgetState<T> extends BaseWidgetState<MissionPage> {
  List<MissionModel> _missionModelListUnFinished = []; //未完成任务
  List<MissionModel> _missionModelListFinished = []; //已经完成任务
  FolderTimeModel? _folderTimeModel = new FolderTimeModel(); //头部4个参数时间
  bool _isBottomBarVisible = false; //底部visible
  int _numberTomatoes = 1; //番茄
  int? _dateStatus; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
  int? _missionModelType = 0; //null 或者 0是默认的 1是苹果日历 2是苹果提醒 3.google日历
  int _priorityStatus = 3; //优先级
  String? _tagName = ''; //创建missionPage tagName
  String? _title = ''; //创建missin时
  int numTomatoes = 1;
  String? _tagId = ''; //
  int? _tagColor; // SelectTagDialogUtil 过来，选择完标签返回
  String? _circleTitle = ''; //目标标题 从folderModel过来 或者从SelectCircleDialogUtil
  int? _circleColor = 0; //目标颜色
  String? _folderModelObjId; //目标objectId 即folderId
  Icon? _circleIcon; //目标Icon
  MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByWords;
  MissionModel _missionModel = MissionModel();
  CalendarModel? calendarModel;
  bool isRequesting = false;
  double margin = 5;
  List<MissionModel>? curListMissionModels = [];
  GlobalKey<HeaderStatsAndInputWidgetState>? HeaderWidgetStateGlobalKey =
      GlobalKey();
  GlobalKey<HeaderStatsAndInputWidgetState>?
      HeaderWidgetStateGlobalKeyForTable = GlobalKey();
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
  List<CheckButtonStateModel>? listCheckButtonStateModel;
  int folderStatusIsArchived = -1; // -1 未归档 归档 0 未归档 1 归档
  bool isListAndGridVisible = true;
  double missionPageWidth = 300;


  String objectiveUnit = ""; //目标单位

  double objectiveValue = 0; //目标值

  double objectiveStartValue = 0; //目标值

  double objectiveTotalValue = 0; //目标值完成

  List<TimeSegment> listTimeSegment = [];

  // int
  _MisssionPageWidgetState({folderStatus, folderModel}) {
    this._dateStatus = null;
    initData(folderModel, folderStatus);
  }

  void initData(FolderModel folderModel, folderStatus) {
    if (folderModel.tag == 2) {
      //tag 2 是标签 进来的
      this._missionModel?.tagIds = [folderModel.objectId].join(',');
      this._missionModel?.tagNames = [folderModel.title].join(',');
    } else {
      //1 就是circle 进来的
      if (!TextUtil.isEmpty(folderModel.tag)) {
        //不是今天 明天 即将到来 待定
        this._circleColor = folderModel.color ?? 0;
        this._circleTitle = folderModel.title;
        if (folderModel.icon != null) {
          this._circleIcon = Icon(
              IconData(folderModel.icon!, fontFamily: 'MaterialIcons'),
              size: 20,
              color: Color(this._circleColor ?? 0xffff8800));
        }
      }
      this._folderModelObjId = folderModel.objectId; //用于创建mission时保存id
      print("folderId ${this._folderModelObjId}");
    }
    if (this._dateStatus == null) {
      if (folderStatus != null) {
        //如果来自今天 明天 即将到来等
        this._dateStatus = folderStatus;
      } else {
        //否则来自文件夹等
        this._dateStatus = 0;
      }
    }
  }

  @override
  void onCreate() {
    super.onCreate();
    curPage = "MissionPage";
  }

  @override
  void initState() {
    super.initState();
    listCheckButtonStateModel =
        CONSTANTS.getGridAndListCheckList(defaultCheckedIndex: 0);
    this.isNavBackBtnVisible = false;

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
    this.setKeyboardVisibityListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  componentDidMount() {
    this.requestDatas();
    this.updateRightNavChildren();
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
  void deactivate() {
    super.deactivate();
    unfocus(withUpdateUI: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void unfocus({withUpdateUI: true}) {
    HeaderWidgetStateGlobalKey?.currentState?.unfocus();
    searchBarWidgetKey?.currentState?.unfocus();
    if (withUpdateUI == true) {
      updateUI();
    }
  }

  setKeyboardVisibityListener() {
    this.keyboardSubscription =
        Utility.handleKeyBoardVisibility(onChange: (bool visible) {
      if (visible) {
        _scrollController.animateTo(140,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      }
      _isBottomBarVisible = visible;
      updateUI();
    });
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

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSubtitle':
        await onClickSubtitlePostpone(data);
        break;
      case 'onClickShowFolderChart': //点击添加任务
        onClickShowFolderChart(data);
        break;
      case 'onClickSubmit': //添加Mission
        if (this._numberTomatoes == 0) {
          Utility.showToastMsg(msg: getI18NKey().alertMessage1);
          return;
        }
        if (TextUtil.isEmpty(this._title) == true) {
          Utility.showToastMsg(msg: getI18NKey().alertMessage2);
          return;
        }
        onClickSubmit(this._title);
        break;
      case 'onClickMissionSetting': //跳转到设置叶敏
        onClickMissionSetting(data);
        break;
      case 'onClickMissionDetail': //跳转到任务详情页MissionPage开始任务
        //点击item
        onClickMissionStart(context, data, this.widget.folderModel);
        break;
      case 'onClickDeleteItem': //侧滑点击删除
        //创建任务
        await onClickDeleteItem(data);
        break;
      case 'onClickFinishItem': //点击完成任务
        this.onClickFinishItem(data);
        break;
      case 'onClickCreateItem':
        this.onClickCreateItem(data);
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
      case 'onTapEditTitleListener':
        this.onClickEditTitle(data);
        break;
      // case 'onTapCreateTagListener': //去CreateFolderPage页面创建标签
      //   this.onTapCreateTagListener();
      //   break;
      case 'onTapTagListener': //创建mission时选择tag
        await onClickCreateTag(data);
        break;
      case 'onTapCircleListener': //穿件mission时选择目标文件夹
        this.onTapCircleListener(data);
        break;
    }
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
   * 穿件mission时选择目标文件夹
   */
  Future onTapCircleListener(FolderModel data) async {
    // SelectCircleDialogUtil.show(context,
    //     title: getI18NKey().selectMission,
    //     content: '', okCallBack: (FolderModel data) {
    this._circleColor = data.color;
    this._circleTitle = data.title;
    this._circleIcon = Icon(
        IconData(data.icon ?? 0, fontFamily: 'MaterialIcons'),
        size: 20,
        color: Color(this._circleColor ?? 0xffff8800));
    this._folderModelObjId = data.objectId;
    print("folderId ${this._folderModelObjId}");
    updateUI();
    // updateUI();
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
  }

  /**
   * 创建mission时选择tag
   */
  Future onClickCreateTag(FolderModel data) async {
    // SelectTagDialogUtil.show(context,
    //     title: getI18NKey().selectTag,
    //     content: '', okCallBack: (FolderModel data) {
    this._tagColor = data.color;
    this._tagName = data.title;
    this._tagId = data.objectId;
    this._missionModel?.tagNames = [this._tagName].join(',');
    this._missionModel?.tagIds = [data.objectId].join(',');
    updateUI();
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
  }

  /**
   * 去CreateFolderPage页面创建标签
   */
  // void onTapCreateTagListener() {
  //   FolderModel folderModel = FolderModel();
  //   folderModel.tag = 2; //1-normal 2-tag 3-circle
  //   Utility.pushNavigator(
  //       context,
  //       new CreateFolderPage(
  //         pageEnum: PageEnum.create,
  //         folderModel: folderModel,
  //       ), callback: (res) {
  //     // this.requestDatas();
  //     Keys.SelectCircleDialogUtilStateGlobalKey.currentState.requestData();
  //     // this.onTapTag();
  //   });
  // }

  Future onClickEditTitle(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    DialogManagement.getInstance().showEditTitleDialog(
        Utility.getGlobalContext(),
        title: getI18NKey().edit_title(data.title ?? ""),
        initVal: data.title, okCallBack: (String value) async {
      if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
          false) {
        Utility.showToastMsg(
            context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
        return;
      }
      data.title = value;
      await MongoApisManager.getInstance()
          .update_MissionModel(missionModel: data);
      requestDatas();
      Utility.showToastMsg(context: context, msg: getI18NKey().update_success);
      DialogManagement.getInstance().hideDialog(context);
    }, cancelCallBack: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  Future onClickUnFinishListener(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    // await onClickFinishMission(data);
    data.isFinished = false;
    await MongoApisManager.getInstance()
        .update_MissionModel(missionModel: data);
  }

  Future onClickCreateItem(FolderModel? data) async {
    MissionModel missionModel = MissionModel();
    missionModel.folder_id = data?.objectId;
    missionModel?.end_time =
        CONSTANTS.getDeadLineTme(this.widget.folderStatusDate ?? 0);
    if (Utility.isHandsetBySize() == true) {
      Utility.pushNavigator(
          context, CreateMissionPage(missionModel: missionModel));
    } else {
      DialogManagement.getInstance().showPCCustomDialog(
          context: context,
          widget: CreateMissionPage(missionModel: missionModel));
    }
  }

  Future onTapDoItNow(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    Utility.onClickUpdateTimeDoItNow(Utility.getGlobalContext(), [data]);
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
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
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    await MongoApisManager.getInstance().insertStatsModel(
      title: data.title,
      type: 1,
      icon: this.widget.folderModel?.icon,
      color: this.widget.folderModel?.color,
      tagName: data.tagNames,
      fid: this.widget.folderModel?.objectId,
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

  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
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
   * 添加Mission
   */
  void onClickSubmit(data) async {
    if (isRequesting == true) {
      Utility.showToastMsg(msg: getI18NKey().requesting_please_wait);
      return;
    }
    this._missionModel?.objectiveUnit = this.objectiveUnit;
    this._missionModel?.objectiveValue = this.objectiveValue;
    this._missionModel?.objectiveStartValue = this.objectiveStartValue;
    this._missionModel?.objectiveTotalValue = this.objectiveTotalValue;

    this._missionModel?.title = data.toString();
    this._missionModel?.folder_id = this._folderModelObjId ?? "";
    this._missionModel?.order_index = -1;
    this._missionModel?.tagNames = TextUtil.isEmpty(this._tagName)
        ? this.widget.folderModel?.title
        : this._tagName;
    this._missionModel?.tagIds = this.widget.folderModel?.tag == 2
        ? this.widget.folderModel?.objectId
        : ""; //2表示在tag里创建的任务 todo, 移动端选择tags时这里要处理下 做个区分
    this._missionModel?.total_tomotoes = this._numberTomatoes;
    this._missionModel?.tomato_duration =
        await SharePreferenceUtil.getSyncInstance().getTomatoTime();
    this._missionModel?.dateStatus = _dateStatus;
    this._missionModel.total_tomotoes = this.numTomatoes;
    this._missionModel.time_mode = bottomBarStateKey?.currentState?.time_mode;
    if (this._missionModel.time_mode == 1) {
      this._missionModel.start_time =
          bottomBarStateKey?.currentState?.start_time;
      this._missionModel.end_time = bottomBarStateKey?.currentState?.end_time;
    } else {
      this._missionModel?.end_time =
          CONSTANTS.getDeadLineTme(this._dateStatus ?? 0);
    }
    this._missionModel.daily_start_time =
        bottomBarStateKey?.currentState?.daily_start_time;
    this._missionModel.daily_end_time =
        bottomBarStateKey?.currentState?.daily_end_time;
    this._missionModel.repetiveType =
        bottomBarStateKey?.currentState?.repetiveType;
    this._missionModel.repetiveValue =
        bottomBarStateKey?.currentState?.repetiveValue;
    this._missionModel.alert_time = bottomBarStateKey?.currentState?.alert_time;
    this._missionModel.repetiveWeekDay =
        bottomBarStateKey?.currentState?.repetiveWeekDay;
    this._missionModel.repetiveWeekDay =
        bottomBarStateKey?.currentState?.repetiveWeekDay;
    this._missionModel.uid = LoginManager.getInstance().userBean.uid;
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this._missionModel?.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    if (this._missionModel.time_mode == 1 &&
        (this._missionModel.start_time == 0 ||
            this._missionModel.start_time == null)) {
      Utility.showToastMsg(
          msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().start_time));
      return null;
    }
    if (this._missionModel.time_mode == 1 &&
        (this._missionModel.start_time == 0 ||
            this._missionModel.start_time == null)) {
      Utility.showToastMsg(
          msg: getI18NKey().xxx_cannot_be_empty(getI18NKey().end_time));
      return null;
    }

    if (this._missionModel.missionModelType == 0) {
      isRequesting = true;
    }

    this.isFocusing = false; //隐藏多余的文案
    MongoApisManager.getInstance().insertMissiontData(
        missionModel: this._missionModel ?? MissionModel(),
        callback: (res) async {
          isRequesting = false;
          if (res != null) {
            Utility.showToastMsg(msg: getI18NKey().addsuccess);
          }
          this.requestDatas();
          eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
          eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
        });
    HeaderWidgetStateGlobalKey?.currentState?.resetData();
    HeaderWidgetStateGlobalKeyForTable?.currentState?.resetData();
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
      if (SharePreferenceUtil.getSyncInstance().getSwitchMissionTitle()) {
        Utility.showAlertDialog(
            context: context,
            content: getI18NKey().missionRunningAlert(
                CounterManagement.getInstance().missionModel?.title ?? ""),
            onConfirm: () {
              OverlayManagement.getInstance().openMissionDetailPageOverlay(
                  context: context,
                  missionModel: data,
                  folderModel: folderModel);
            });
      } else {
        OverlayManagement.getInstance().openMissionDetailPageOverlay(
            context: context, missionModel: data, folderModel: folderModel);
      }
    } else {
      OverlayManagement.getInstance().openMissionDetailPageOverlay(
          context: context, missionModel: data, folderModel: folderModel);
      // Utility.pushNavigator(
      //     context,
      //     new MissionDetailPage(
      //       missionModel: data,
      //       folderModel: this.widget.folderModel,
      //     ));
    }
  }

  @override
  void didUpdateWidget(MissionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folderModel?.title != this.widget.folderModel?.title || (!TextUtil.isEmpty(oldWidget.folderModel?.objectId) && !TextUtil.isEmpty(this.widget.folderModel?.objectId) && oldWidget.folderModel?.objectId != this.widget.folderModel?.objectId)) {
      this._dateStatus =
          null; //切换文件夹时重置 这样Initdata会重新拿this.widget.folderStatus数据初始化
      bottomBarStateKey?.currentState
          ?.updateEndTimeByState(this.widget.folderStatusDate ?? 1);
    }
    this.updateRightNavChildren();
    this._folderModelObjId = this.widget.folderModel?.objectId;
    print("folderId ${this._folderModelObjId}");
    //多个folderModel的切换
    Future.delayed(Duration(seconds: 0), () {
      if (mounted == true) {
        bottomBarStateKey?.currentState?.reset();
      }
    });

    //todo 这里可以优化 否则会请求几遍 但是通过 this._folderModelObjId == this.widget.folderModel?.objectId有点问题
    this.requestDatas(shouldUpdate: false);
  }

  void updateRightNavChildren() {
    // && this.rightNavChildren == null
    if (this.widget.folderModel?.tag == 1 || this.widget.folderModel?.tag == 5) {
      // if (ABTestSetting.isOpenAiOn && Utility.isHuaWei() == false)
      this.rightNavChildren = [
        IconButton(
            onPressed: () {
              this
                  .widget
                  .onTapRightNavMenuListener
                  ?.call(this.widget.folderModel, false);
            },
            icon: Utility.getSVGPicture(R.assetsImgIcListingGroup,
                size: StylesConfig.sizeGroup))
      ];
      updateUI();
    }
    // else if(this.rightNavChildren != null && this.widget.folderModel?.tag != 1){
    //   this.rightNavChildren = null;
    //   updateUI();
    // }
    else if (ABTestSetting.isOpenAiOn && Utility.isHuaWei() == false) {
      this.rightNavChildren = [
        IconButton(
            onPressed: () {
              // 第二个参数是不是gpt
              this
                  .widget
                  .onTapRightNavMenuListener
                  ?.call(this.widget.folderModel, true);
            },
            icon: Utility.getSVGPicture(R.assetsImgIcAiVoice, size: 24))
      ];
    }
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        this.missionPageWidth = constraints.maxWidth;
        return WillPopScope(
          key: ValueKey('WillPopScope1'),
          onWillPop: () async {
            if (OverlayManagement.getInstance()
                    .isMissionDetailPageOverlayVisible() ==
                true) {
              OverlayManagement.getInstance().removeMissionDetailPageOverlay();
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Stack(key: ValueKey('Stack2'), children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              key: ValueKey('Container1'),
              color: ThemeManager.getInstance().getBackgroundColor(),
              child: GestureDetector(
                key: ValueKey('TextButton1'),
                onTap: () async {
                  unfocus();
                  await Future.delayed(Duration(milliseconds: 500));
                  Utility.popupDesktopRightNavigator(context);
                },
                child: Stack(key: ValueKey('Stack1'), children: [
                  RefreshIndicator(
                    key: ValueKey('RefreshIndicator1'),
                    onRefresh: () async {
                      Utility.initCalendarModel();
                      // await this.requestDatas();
                      //模拟网络请求
                      //结束刷新
                      return Future.value(true);
                    },
                    child: Container(
                      key: ValueKey('Container2'),
                      color: ThemeManager.getInstance().getBackgroundColor(),
                      child: this.missionDataViewTypeEnum ==
                              MissionDataViewTypeEnum.table
                          ? Column(
                              children: getTableSilverListWidget(),
                            )
                          : CustomScrollView(
                              controller: _scrollController,
                              key: ValueKey('CustomScrollView1'),
                              slivers: getSilverListWidget(),
                            ),
                    ),
                  ),
                ]),
              ),
            ),
            Utility.isHandsetBySize()
                ? Align(
                    key: ValueKey('Align1'),
                    alignment: Alignment.bottomCenter,
                    child: getBottomBar(context,
                        isVisible: this._isBottomBarVisible),
                  )
                : SizedBox.shrink(),
            this._isBottomBarVisible
                ? SizedBox.shrink()
                : Positioned(
                    bottom: 30,
                    right: 20,
                    child: CircleWidget(
                      onTapListener: (obj) {
                        MissionModel missionModel = MissionModel();
                        missionModel.folder_id =
                            this.widget.folderModel?.objectId;
                        if (this.widget.folderModel?.tag == 2) {
                          missionModel.tagNames =
                              this.widget.folderModel?.tag == 2
                                  ? this.widget.folderModel?.title
                                  : "";
                          missionModel.tagIds =
                              this.widget.folderModel?.tag == 2
                                  ? this.widget.folderModel?.objectId
                                  : "";
                          // missionModel.tagIds = this.widget.folderModel?.tag == 2 ? this.widget.folderModel?.objectId : "";
                        }
                        missionModel.folder_id =
                            this.widget.folderModel?.objectId ?? "";
                        // missionModel.end_time = this.widget.folderModel?.objectId ?? "";

                        missionModel.end_time = CONSTANTS
                            .getDeadLineTme((this._dateStatus ?? 0) + 1);

                        // missionModel. = this.widget.folderModel?.tag == 2 ? this.widget.folderModel?.title : "";
                        // missionModel.end_time = dayModel.dateTime?.millisecondsSinceEpoch;
                        if (Utility.isHandsetBySize() == true) {
                          Utility.pushNavigator(context,
                              CreateMissionPage(missionModel: missionModel));
                        } else {
                          DialogManagement.getInstance().showPCCustomDialog(
                              context: context,
                              widget: CreateMissionPage(
                                  missionModel: missionModel));
                        }
                      },
                    )),
            this.multiSelectModeEnum == MultiSelectModeEnum.normal
                ? SizedBox.shrink()
                : Positioned(
                    bottom: 0,
                    child: MultiSelectHandleWidget(
                      missionModelList: this.curListMissionModels ?? [],
                      onClickUpdateTimeDoItNow: (datas) async {
                        Utility.onClickUpdateTimeDoItNow(context, datas);
                      },
                      onClickDelete: (datas) async {
                        await MongoApisManager.getInstance()
                            .batchDelete_MissionModel(listParam: datas);
                      },
                      onClickExport: (datas) {
                        TextEditingController textEditingController =
                            TextEditingController();
                        String s = Utility.getContentFromMissionList(
                            datas: datas ?? [],
                            listCheckButtonModel:
                                CONSTANTS.getExportButtonsList());
                        textEditingController.text = s;
                        ExportMissionListDialogUtil.show(context,
                            textEditingController: textEditingController,
                            onTapListener: (res) {
                          List<CheckButtonStateModel> data = res['data'];
                          MissionOrderEnum missionOrderEnum = res['enum'];
                          String s = Utility.getContentFromMissionList(
                              datas: Utility.getMissionModelListAfterOrder(
                                  missionOrderEnum, datas ?? []),
                              listCheckButtonModel: data);
                          textEditingController.text = s;
                          updateUI();
                        }, export: (data) {
                          Utility.showToastMsg(
                              context: context,
                              msg: getI18NKey().offer_next_version);
                        });
                      },
                      onClickFinish: (datas) async {
                        await MongoApisManager.getInstance()
                            ?.batchUpdate_MissionModelWithParams(
                                listMissionModel: datas);
                      },
                      onClickUnFinish: (datas) async {
                        await MongoApisManager.getInstance()
                            ?.batchUpdate_MissionModelWithParams(
                                listMissionModel: datas);
                      },
                      onClickClose: (datas) async {
                        resetMultiSelectModeEnum();
                      },
                    )),
          ]),
        );
      },
    );
    ;
  }

  BottomBar getBottomBar(BuildContext context, {bool isVisible: false}) {
    return BottomBar(
      key: bottomBarStateKey,
      folderModel: this.widget.folderModel,
      //底部bar 用于创建任务用
      objectiveUnit: this.objectiveUnit,
      objectiveValue: this.objectiveValue,
      objectiveStartValue: this.objectiveStartValue,
      objectiveTotalValue: this.objectiveTotalValue,
      iconCircle: this._circleIcon,
      isVisible: isVisible,
      alert_time: this._missionModel?.alert_time ?? 0,
      circleTitle: this._circleTitle ?? "",
      dateStatus: this._dateStatus ?? 0,
      onTapMissionModelTypeListener: (data) {
        // this._missionModelType = data;
        this._missionModel.missionModelType = data;
        updateUI();
      },
      onTapAlertDateListener: (data) {
        this._missionModel.alert_time = data;
        updateUI();
      },
      onTapUpdateDateListener: (
          {dynamic startDate,
          dynamic alertDate,
          dynamic dailyStartDate,
          dynamic dailyEndDate,
          int time_mode = 0}) {
        // 0日期模式
        if (time_mode == 0) {
          this._missionModel.daily_start_time = dailyStartDate;
          this._missionModel.daily_end_time = dailyEndDate;
          this._missionModel.alert_time = alertDate;
        } else {
          this._missionModel.start_time = dailyStartDate;
          this._missionModel.end_time = dailyEndDate;
          this._missionModel.alert_time = alertDate;
        }
      },
      //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
      priority: this._priorityStatus ?? 0,
        onChangeTotalValAndUnit: (totalval, unit) {
          // this.objectiveValue = val;
          this.objectiveTotalValue = totalval;
          this.objectiveUnit = unit;
        },
      circleColor: !TextUtil.isEmpty(this._circleColor)
          ? Color(this._circleColor ?? 0xffff8800)
          : ColorsConfig.gray_cc_cancel,
      tagName: this._tagName ?? "",
      tagColor: this._tagColor != null
          ? Color(this._tagColor ?? 0xffff8800)
          : ColorsConfig.gray_cc_cancel,
      onTapFinishListener: ({data}) {
        this.onClick('onClickSubmit', data);
      },
      onTapMissionValueListener: ({data}) {
        this._missionModel?.mission_value = data;
      },
      onTapEndTimeListener: ({data}) {
        this._missionModel?.end_time = data;
      },
      //todo 目前用不上 可以考虑删除
      onTapDateListener: (data) {
        // SelectDateDialogUtil.show(
        //   context,
        //   title: getI18NKey().curTimeF,
        //   content: '',
        //   list: CONSTANTS.getDateModels(),
        //   onTapListener: (data) {
        this._dateStatus = data;
        this._missionModel?.dateStatus = _dateStatus;
        updateUI();
        // Navigator.of(context).pop();
        // },
        // );
      },
      onTapPriorityListener: (data) {
        this._priorityStatus = data;
        this._missionModel?.priorityStatus = _priorityStatus;
        updateUI();
        // Navigator.of(context).pop();
      },
      onTapCircleListener: (data) {
        this.onClick('onTapCircleListener', data);
      },
      onTapTagListener: (data) async {
        this.onClick('onTapTagListener', data);
      },
      onChangeListener: (data) => {this._numberTomatoes = data},
      totalTomatoes: this._numberTomatoes ?? 1,
    );
  }

  List<Widget> getTableSilverListWidget() {
    List<Widget> listWidget = [];
    listWidget.add(
      //头部title
      Container(
        constraints: BoxConstraints(
          minHeight: 60,
          maxHeight:
              Utility.isHandsetBySize() && isSearchBarVisible ? 100.0 : 60,
        ),
        child: getHeaderWidget(),
        //是否固定头布局 默认false
      ),
    );

    if (this.widget.folderStatusDate != 6) {
      //已完成不需要加头部
      // if (headerWidget == null) {
      listWidget.add(HeaderStatsAndInputWidget(
          shouldSliver: false,
          key: HeaderWidgetStateGlobalKeyForTable,
          childAfterInputWidget: Utility.isHandsetBySize() &&
                  !DeviceInfoManagement.isMobileWeb() //android ios web需要显示
              ? null
              : getBottomBar(context, isVisible: this.isFocusing),
          //移动端key要唯一 否则每次经过这里都会实例化 造成移动端输入框点击焦点后键盘自动隐藏 pc端要新的globalkey 否则头部headerwidget无法显示
          onTapUpListener: () {},
          onTapDownListener: () {},
          folderTimeModel: _folderTimeModel,
          folderModel: this.widget.folderModel?.tag == 1
              ? this.widget.folderModel
              : null,
          onChangeListener: (data, numTomatoes) {
            this.numTomatoes = numTomatoes;
            this._title = data;
            if ((this._title?.length ?? 0) > 0) {
              this.isFocusing = true;
            } else {
              this.isFocusing = false;
            }
            updateUI();
          },
          //这个好像用不上
          onDesktopSubmitListener: (data, numTomtoes) {
            this._numberTomatoes = numTomtoes;
            this.onClick('onClickSubmit', data);
          },
          onSubmitListener: (data) {
            this._numberTomatoes = data['numTomatoes'];
            FolderModel folderModel = data['folderModel'];
            if (folderModel != null) {
              this._circleColor = folderModel.color;
              this._circleTitle = folderModel.title;
              this._circleIcon = Icon(
                  IconData(folderModel.icon ?? 0, fontFamily: 'MaterialIcons'),
                  size: 25,
                  color: Color(this._circleColor ?? 0xffff8800));
              this._folderModelObjId = folderModel.objectId;
              print("folderId ${this._folderModelObjId}");
            }
            this.onClick('onClickSubmit', data);
          }));
    }
    listWidget.add(SizedBox(
      height: 10,
    ));
    listWidget.add(Expanded(
      child: this.buildMissionTableContainerWidget(
          (SharePreferenceUtil.getSyncInstance().getCompleteMissionVisible() ==
                      false &&
                  this.widget.folderStatusDate != 6)
              ? []
              : (Utility.getListAfterOrder(
                      missionOrderEnum,
                      this.curListMissionModels ?? [],
                      -1,
                      this
                          .widget
                          .folderModel
                          .filterConditionMapBean
                          ?.listingId) ??
                  [])),
    ));

    // if (this.missionDataViewTypeEnum == MissionDataViewTypeEnum.table) {
    //   listWidget.addAll();
    // } else {}

    return [
      ...listWidget,
    ];
  }

  List<Widget> getSilverListWidget() {
    List<Widget> listWidget = [];
    listWidget.add(
      //头部title
      SliverPersistentHeader(
          //是否固定头布局 默认false
          pinned: false,
          //是否浮动 默认false
          floating: false,
          delegate: MySliverDelegate(
            //缩小后的布局高度
            minHeight: 60.0,
            //展开后的高度
            maxHeight:
                Utility.isHandsetBySize() && isSearchBarVisible ? 100.0 : 60,
            child: getHeaderWidget(),
          )),
    );
    if (this.widget.folderStatusDate != 6) {
      //已完成不需要加头部
      // if (headerWidget == null) {
      listWidget.add(HeaderStatsAndInputWidget(
          key: HeaderWidgetStateGlobalKey,
          childAfterInputWidget: Utility.isHandsetBySize() &&
                  !DeviceInfoManagement.isMobileWeb() //android ios web需要显示
              ? null
              : getBottomBar(context, isVisible: this.isFocusing),
          //移动端key要唯一 否则每次经过这里都会实例化 造成移动端输入框点击焦点后键盘自动隐藏 pc端要新的globalkey 否则头部headerwidget无法显示
          onTapUpListener: () {},
          onTapDownListener: () {},
          folderTimeModel: _folderTimeModel,
          folderModel: (this.widget.folderModel?.tag == 1 || this.widget.folderModel?.tag == 4 || this.widget.folderModel?.tag == 5)
              ? this.widget.folderModel
              : null,
          onChangeListener: (data, numTomatoes) {
            this.numTomatoes = numTomatoes;
            this._title = data;
            if ((this._title?.length ?? 0) > 0) {
              this.isFocusing = true;
            } else {
              this.isFocusing = false;
            }
            updateUI();
          },
          //这个好像用不上
          onDesktopSubmitListener: (data, numTomtoes) {
            this._numberTomatoes = numTomtoes;
            this.onClick('onClickSubmit', data);
          },
          onSubmitListener: (data) {
            this._numberTomatoes = data['numTomatoes'];
            FolderModel folderModel = data['folderModel'];
            if (folderModel != null) {
              this._circleColor = folderModel.color;
              this._circleTitle = folderModel.title;
              this._circleIcon = Icon(
                  IconData(folderModel.icon ?? 0, fontFamily: 'MaterialIcons'),
                  size: 25,
                  color: Color(this._circleColor ?? 0xffff8800));
              this._folderModelObjId = folderModel.objectId;
              print("folderId ${this._folderModelObjId}");
            }
            this.onClick('onClickSubmit', data);
          }));
    }
    //CustomScrollView加固定高度 10
    listWidget.add(SliverPadding(padding: EdgeInsets.only(top: 10)));
    listWidget.addAll(this.missionDataViewTypeEnum ==
            MissionDataViewTypeEnum.list
        ? this.buildListWidget(
            Utility.getListAfterOrder(
                    missionOrderEnum,
                    _missionModelListUnFinished,
                    -1,
                    this
                        .widget
                        .folderModel
                        .filterConditionMapBean
                        ?.listingId) ??
                [],
            false)
        : this.buildGridWidget(Utility.getListAfterOrder(
                MissionOrderEnum.orderByWords,
                this.curListMissionModels ?? [],
                folderStatusIsArchived,
                this.widget.folderModel.filterConditionMapBean?.listingId) ??
            []));

    if (this.widget.folderStatusDate != 4 &&
        (this.missionDataViewTypeEnum == MissionDataViewTypeEnum.list)) {
      //待定不需要显示已完成状态
      listWidget.add(initFinishMissionSliverPersistentHeader(
          getI18NKey().missionCompleted, this.widget.folderStatusDate != 6));
    }

    //完成的任务
    if (this.missionDataViewTypeEnum == MissionDataViewTypeEnum.list) {
      listWidget.addAll(this.buildListWidget(
          (SharePreferenceUtil.getSyncInstance().getCompleteMissionVisible() ==
                      false &&
                  this.widget.folderStatusDate != 6)
              ? []
              : (Utility.getListAfterOrder(
                      missionOrderEnum,
                      _missionModelListFinished,
                      -1,
                      this
                          .widget
                          .folderModel
                          .filterConditionMapBean
                          ?.listingId) ??
                  []),
          true));
    } else {}

    // if (this.missionDataViewTypeEnum == MissionDataViewTypeEnum.table) {
    //   listWidget.addAll();
    // } else {}

    return [
      ...listWidget,
    ];
  }

  /**
   * 搜索框 标题等 导出框
   */
  Column getHeaderWidget() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      CustomMarquee(
        bean: MarqueInfo.marqueMissionpage,
      ),
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
                    isEditable: this.widget.folderModel?.tag == 5 || this.widget.folderModel?.tag == 4 || this.widget.folderModel?.tag == 2 ||
                        this.widget.folderModel?.tag == 1,
                    style: TextStyle(
                        fontSize: 20,
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultColor: ColorsConfig.gray_40),
                        fontWeight: FontWeight.bold),
                    text: this.widget.folderModel?.title ?? "",
                    onEnterListener: (v) {
                      this.widget.folderModel?.title = v;
                      if (this.widget.folderModel != null) {
                        MongoApisManager.getInstance().update_FolderModelWithFM(
                            folderModel: this.widget.folderModel!,
                            shouldQueryMissionModel: false);
                      }
                    }),
                // Text(
                //   this.widget.folderModel?.title ?? "",
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: ThemeManager.getInstance()
                //           .getColor(defaultColor: ColorsConfig.gray_40),
                //       fontWeight: FontWeight.bold),
                // ),
                SizedBox(
                  width: 4,
                ),
                ListingSecurityWidget(
                  folder_id: this.widget.folderModel?.objectId ?? "",
                  cryptoVersion: this.widget.folderModel?.cryptoVersion ?? -1,
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
                    AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
                      "sceneType": "missionpage",
                      "eventType": "missionpage_search",
                      "description": "搜索",
                    });
                    updateUI();
                  },
                ),
                (this.widget.folderModel?.tag == 1 ||
                        this.widget.folderModel?.tag == 2 ||
                    this.widget.folderModel?.tag == 4 ||
                    this.widget.folderModel?.tag == 5)
                    ? InkWell(
                        onTap: () async {
                          TimelineMissionModel? timelineMissionModel = null;
                          if (TextUtil.isEmpty(this
                                  .widget
                                  .folderModel
                                  ?.timelineNoteObjectId) ==
                              false) {
                            timelineMissionModel = await MongoApisManager
                                    .getInstance()
                                .queryWhereEqual_TimelineMissionModelByObjectId(
                                    objectId: this
                                            .widget
                                            .folderModel
                                            ?.timelineNoteObjectId ??
                                        "");
                            timelineMissionModel?.sceneType = "note";
                            timelineMissionModel?.eventType = "note";
                          } else {
                            timelineMissionModel = TimelineMissionModel();
                            timelineMissionModel.folder_id =
                                this.widget.folderModel?.objectId ?? null;
                            timelineMissionModel.tagNames =
                                this.widget.folderModel?.tag == 2
                                    ? this.widget.folderModel?.title
                                    : "";
                            timelineMissionModel.color =
                                this.widget.folderModel?.color;
                            timelineMissionModel.icon =
                                this.widget.folderModel?.icon;
                            timelineMissionModel.sceneType = "note";
                            timelineMissionModel.eventType = "note";
                            // timelineMissionModel.
                          }
                          Utility.openPagePCAndMobile(context,
                              child: RichEditorPage(
                                  onOkListener: (url,
                                      timelineMissionModelObjectId,
                                      numberNoteWords) async {
                                    this.widget.folderModel?.noteUrl = url;
                                    this.widget.folderModel?.numberNoteWords =
                                        numberNoteWords;
                                    if (timelineMissionModelObjectId != null) {
                                      this
                                              .widget
                                              .folderModel
                                              ?.timelineNoteObjectId =
                                          timelineMissionModelObjectId;
                                    }
                                    await MongoApisManager.getInstance()
                                        .update_FolderModelWithFM(
                                            folderModel:
                                                this.widget.folderModel ??
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
                // InkWell(
                //   onTap: () {
                //     onClickExport();
                //     // Utility.getContentFromMissionList(datas: this.missionListOriginal, listCheckButtonModel: CONSTANTS.getMi);
                //   },
                //   child: CustomBlackButton(
                //     text: getI18NKey().export,
                //     color: ThemeManager.getInstance()
                //         .getColor(defaultColor: Colors.red),
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                Offstage(
                  offstage: this.isListAndGridVisible == false,
                  child: CheckButtonListWithIconWidget(
                    key: checkButtonListWithIconWidgetKey,
                    list: listCheckButtonStateModel ?? [],
                    onTapListener: (obj) {
                      CheckButtonStateModel item =
                          listCheckButtonStateModel![obj];
                      if (item.code == "list") {
                        AnalyticsEventsManager.getInstance()
                            .sendAnalyticsEventMap({
                          "sceneType": "missionpage",
                          "eventType": "missionpage_list_view",
                          "description": "列表",
                        });
                        missionDataViewTypeEnum = MissionDataViewTypeEnum.list;
                      } else if (item.code == "grid") {
                        AnalyticsEventsManager.getInstance()
                            .sendAnalyticsEventMap({
                          "sceneType": "missionpage",
                          "eventType": "missionpage_classify",
                          "description": "分类",
                        });
                        missionDataViewTypeEnum = MissionDataViewTypeEnum.grid;
                      } else if (item.code == "table") {
                        AnalyticsEventsManager.getInstance()
                            .sendAnalyticsEventMap({
                          "sceneType": "missionpage",
                          "eventType": "missionpage_table",
                          "description": "表格",
                        });
                        missionDataViewTypeEnum = MissionDataViewTypeEnum.table;
                      }
                      SharePreferenceUtil.getSyncInstance().setInt(
                          key: ShareprefrenceKeys.listAndGridView +
                              this.widget.folderStatusDate.toString() +
                              (this.widget.folderModel?.objectId ?? ""),
                          value: missionDataViewTypeEnum.index);
                      updateUI();
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CustomPopupWidget(
                  onSelected: (CheckButtonStateModel model) {
                    if (model.code == 'export') {
                      onClickExport();
                    } else if (model.code == 'sort') {
                      OverlayManagement.getInstance()
                          .openMissionDetailPageSettingOverlay(context,
                              right: 40,
                              top: 80,
                              list: CONSTANTS
                                  .getSortMissionPagePopupMenuButtonList(),
                              onTapListener: (model) {
                        String val = model.code;
                        AnalyticsEventsManager.getInstance()
                            .sendAnalyticsEventMap({
                          "sceneType": "missionpage",
                          "eventType": "missionpage_order",
                          "description": "排序",
                          "message": val
                        });
                        if (val == 'order_by_list') {
                          this.missionOrderEnum = MissionOrderEnum.orderByWords;
                        } else if (val == 'order_by_time') {
                          this.missionOrderEnum = MissionOrderEnum.orderByTime;
                        } else if (val == 'order_by_mission_priority') {
                          this.missionOrderEnum =
                              MissionOrderEnum.orderByPriority;
                        } else if (val == 'order_by_mission_tag') {
                          this.missionOrderEnum = MissionOrderEnum.orderByTag;
                        }
                        SharePreferenceUtil.getSyncInstance()
                            .setMissionOrderEnum(missionOrderEnum);
                        this.updateUI();
                        OverlayManagement.getInstance()
                            .dismissMissionDetailPageSettingEntry();
                        // this.onClick("onClickSettingItem", model.code);
                      });
                    } else if (model.code == 'sync') {
                      CounterMethodChannelManager.getInstance()
                          .storeCustomizeMissionList(
                              Utility.getListAfterOrder(
                                      missionOrderEnum,
                                      _missionModelListUnFinished,
                                      -1,
                                      this
                                          .widget
                                          .folderModel
                                          .filterConditionMapBean
                                          ?.listingId) ??
                                  [],
                              this.widget.folderModel?.title);
                      Utility.showToastMsg(
                          msg: getI18NKey().sync_desktop_widget_success);
                    }
                  },
                  list: CONSTANTS.getMissionButtonList(),
                  child: Icon(
                    Icons.more_horiz,
                    color: Color(0xff999999),
                  ),
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
    ]);
  }

  void onClickExport() {
    AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
      "sceneType": "missionpage",
      "eventType": "missionpage_guide",
      "description": "导出",
    });
    TextEditingController textEditingController = TextEditingController();
    String s = Utility.getContentFromMissionList(
        datas: this.curListMissionModels ?? [],
        listCheckButtonModel: CONSTANTS.getExportButtonsList());
    textEditingController.text = s;
    ExportMissionListDialogUtil.show(context,
        textEditingController: textEditingController, onTapListener: (res) {
      List<CheckButtonStateModel> data = res['data'];
      MissionOrderEnum missionOrderEnum = res['enum'];
      String s = Utility.getContentFromMissionList(
          datas: Utility.getMissionModelListAfterOrder(
              missionOrderEnum, this.curListMissionModels ?? []),
          listCheckButtonModel: data);
      textEditingController.text = s;
      updateUI();
    }, export: (data) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().offer_next_version);
    });
  }

  void onClickSearch(searchWord) {
    this.curSearchWords = searchWord;
    requestDatas();
  }

  // Container getPopupMenu() {
  //   return Container(
  //     key: ValueKey('Container5'),
  //     margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
  //     child: PopupMenuButton<String>(
  //       key: ValueKey('PopupMenuButton5'),
  //       tooltip: '',
  //       padding: EdgeInsets.all(0.0),
  //       child: Container(
  //         key: ValueKey('Container5'),
  //         width: 40,
  //         height: 35,
  //         decoration: BoxDecoration(
  //           color: ThemeManager.getInstance()
  //               .getCardBackgroundColor(defaultColor: Colors.white),
  //           borderRadius: BorderRadius.all(Radius.circular(8)),
  //         ),
  //         child: Icon(Icons.swap_vert,
  //             size: 30,
  //             color: ThemeManager.getInstance().getColor(
  //                 defaultColor: ThemeManager.getInstance()
  //                     .getTextColor(defaultColor: Colors.red))),
  //       ),
  //       onSelected: (String val) {
  //         AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
  //           "sceneType": "missionpage",
  //           "eventType": "missionpage_order",
  //           "description": "排序",
  //           "message": val
  //         });
  //         if (val == 'order_by_list') {
  //           this.missionOrderEnum = MissionOrderEnum.orderByWords;
  //         } else if (val == 'order_by_time') {
  //           this.missionOrderEnum = MissionOrderEnum.orderByTime;
  //         } else if (val == 'order_by_mission_priority') {
  //           this.missionOrderEnum = MissionOrderEnum.orderByPriority;
  //         } else if (val == 'order_by_mission_tag') {
  //           this.missionOrderEnum = MissionOrderEnum.orderByTag;
  //         }
  //         SharePreferenceUtil.getSyncInstance()
  //             .setMissionOrderEnum(missionOrderEnum);
  //         this.updateUI();
  //       },
  //       itemBuilder: (context) {
  //         // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
  //         return <PopupMenuEntry<String>>[
  //           PopupMenuItem<String>(
  //             key: ValueKey('PopupMenuItem5'),
  //             value: 'order_by_list',
  //             child: Text(getI18NKey().order_by_list,
  //                 style: TextStyle(fontSize: 13)),
  //           ),
  //           PopupMenuItem<String>(
  //             key: ValueKey('PopupMenuItem5'),
  //             value: 'order_by_time',
  //             child: Text(
  //               getI18NKey().order_by_time,
  //               style: TextStyle(fontSize: 13),
  //             ),
  //           ),
  //           PopupMenuItem<String>(
  //             key: ValueKey('PopupMenuItem5'),
  //             value: 'order_by_mission_priority',
  //             child: Text(
  //               getI18NKey().order_by_mission_priority,
  //               style: TextStyle(fontSize: 13),
  //             ),
  //           ),
  //           PopupMenuItem<String>(
  //             key: ValueKey('PopupMenuItem6'),
  //             value: 'order_by_mission_tag',
  //             child: Text(
  //               getI18NKey().order_by_mission_tag,
  //               style: TextStyle(fontSize: 13),
  //             ),
  //           ),
  //         ];
  //       },
  //     ),
  //   );
  // }

  Widget buildMissionTableContainerWidget(List<SessionMissionModel> list) {
    List<MissionModel> listMissionModels = [];
    list.forEach((SessionMissionModel sessionMissionModel) {
      listMissionModels.addAll(sessionMissionModel.datas ?? []);
    });
    return MissionTableContainerWidget(
      listMissionModels: listMissionModels,
      onClickMissionSetting: (obj) {
        this.onClick('onClickMissionSetting', obj); //跳转到任务详情页MissionPage开始任务
      },
    );
  }

  List<Widget> buildGridWidget(List<SessionMissionModel> list) {
    List<Widget> listWidget = [];
    // list.forEach((SessionMissionModel model) {
    //   if ((model.datas?.length ?? 0) > 0) {
    listWidget.add(MissionGridView(
      missionOrderEnum: this.missionOrderEnum,
      folderStatus: folderStatusIsArchived,
      multiSelectModeEnum: this.multiSelectModeEnum,
      list: list,
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
      onTapCreateListener: (data) {
        this.onClick('onClickCreateItem', data); //点击完成任务
      },
      onTapShowFolderChartListener: (data) {
        this.onClick('onClickShowFolderChart', data); //点击完成任务
      },
    ));
    if (this.widget.folderStatusDate == 1) {
      CounterMethodChannelManager.getInstance().storeMissionList(list);
    }
    return listWidget;
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
        listWidget.add(
          initSliverPersistentHeader(sessionMissionModel.title ?? "",
              onClickSubtitle: () {
            this.onClick('onClickSubtitle', sessionMissionModel);
          },
              isDelay: isFinish == false && isDelay,
              subtitle: (isFinish == false &&
                      this.missionOrderEnum == MissionOrderEnum.orderByTime &&
                      isDelay)
                  ? getI18NKey().postpone
                  : null),
        );
        listWidget.add(MissionSilverList(
          multiSelectModeEnum: this.multiSelectModeEnum,
          onTapMultiSelectListener: (MissionModel? list) {
            this.onClick('onTapMultiSelectListener', list);
          },
          onTapDoItNow: (data) {
            this.onClick('onTapDoItNow', data);
          },
          //未完成任务列表
          datas: sessionMissionModel.datas ?? [],
          onTapUnFinishListener: (data) {
            this.onClick('onClickUnFinishListener', data); //点击完成任务
          },
          onTapEditTitleListener: (obj) {
            this.onClick(
                'onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
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
    if (this.widget.folderModel?.tag == 4) {
      curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
          .getInt(
              key: ShareprefrenceKeys.listAndGridView +
                  this.widget.folderStatusDate.toString() +
                  (this.widget.folderModel?.objectId ?? ""),
              defaultVal: 1);
      missionDataViewTypeEnum =
          MissionDataViewTypeEnum.values[curIndexListViewAndGridView];
      datas = MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByFilterConditionBean(
              filterConditionBean:
                  this.widget.folderModel?.filterConditionMapBean ??
                      FilterConditionBean());
    } else if (this.widget.folderModel?.tag == 2) {
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
      } else if (this.widget.folderStatusDate == 13) {
        // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
        this.folderStatusIsArchived = 0; // 未归档
        //FoldersPage 今天之前的 23:59:59
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 0)];
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByDateStatus(
                dateStatus: this.widget.folderStatusDate);
      } else if (this.widget.folderStatusDate == 12) {
        // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
        this.folderStatusIsArchived = 0; // 未归档
        //FoldersPage 今天之前的 23:59:59
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 0)];
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByDateStatus(
                dateStatus: this.widget.folderStatusDate);
      } else if (this.widget.folderStatusDate == 14) {
        // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
        // this.folderStatusIsArchived = 0; // 未归档
        //FoldersPage 今天之前的 23:59:59
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
            curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
                .getInt(
                    key: ShareprefrenceKeys.listAndGridView +
                        this.widget.folderStatusDate.toString(),
                    defaultVal: 2)];
        datas = MongoApisManager.getInstance().listCalendarMissionModels;
      } else if (this.widget.folderStatusDate == 15) {
        // 用这个是因为重复的很难计算 但是calendar算好了 所以直接用这个
        // this.folderStatusIsArchived = 0; // 未归档
        //FoldersPage 今天之前的 23:59:59
        missionDataViewTypeEnum = MissionDataViewTypeEnum.values[
        curIndexListViewAndGridView = SharePreferenceUtil.getSyncInstance()
            .getInt(
            key: ShareprefrenceKeys.listAndGridView +
                this.widget.folderStatusDate.toString(),
            defaultVal: 2)];
        datas = MongoApisManager.getInstance().listRemindersMissionModels;
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
      _folderTimeModel = Utility.getFolderTimeModel(datas); //头部4个参数时间
      _missionModelListFinished =
          Utility.getMissionModelFinished(datas); //完成的任务
      _missionModelListUnFinished =
          Utility.getMissionModelUnfinished(datas); //未完成任务
//时间段

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
              color: ThemeManager.getInstance().getBackgroundColor(
                  defaultColor: ColorsConfig.standardPageBackground),
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
                            color: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Color(0xffa3a3a3)),
                            shadows: ThemeManager.getInstance().isDark()
                                ? null
                                : [
                                    Shadow(
                                        color: Colors.white,
                                        offset: Offset(1, 1))
                                  ]),
                      ),
                      if (isDelay == true && title != getI18NKey().others)
                        Text(
                          "(" + getI18NKey().already_delay + ")",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 13,
                              color: ThemeManager.getInstance().getTextColor(
                                  defaultColor: Colors.red,
                                  defaultDarkColor: Colors.red),
                              shadows: ThemeManager.getInstance().isDark()
                                  ? null
                                  : [
                                      Shadow(
                                          color: Colors.white,
                                          offset: Offset(1, 1))
                                    ]),
                        ),
                    ],
                  ),
                  if (subtitle != null && title != getI18NKey().others)
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
                              color: ThemeManager.getInstance().getTextColor(
                                  defaultColor: Colors.blue,
                                  defaultDarkColor: Colors.blue),
                              shadows: ThemeManager.getInstance().isDark()
                                  ? null
                                  : [
                                      Shadow(
                                          color: Colors.white,
                                          offset: Offset(1, 1))
                                    ]),
                        ),
                      ),
                    ),
                ],
              )),
        ));
  }

  //已完成任务
  initFinishMissionSliverPersistentHeader(String title,
      [bool isEnabled = true]) {
    return SliverPersistentHeader(
        //是否固定头布局 默认false
        pinned: false,
        //是否浮动 默认false
        floating: false,
        delegate: MySliverDelegate(
            //缩小后的布局高度
            minHeight: 40.0,
            //展开后的高度
            maxHeight: 40.0,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 20,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      decoration: BoxDecoration(
                          color: ThemeManager.getInstance()
                              .getCardBackgroundColor(
                                  defaultColor: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Wrap(
                        children: [
                          InkWell(
                              onTap: () {
                                if (isEnabled == false) return;
                                SharePreferenceUtil.getSyncInstance()
                                    .setCompleteMissionVisible(
                                        visible: !SharePreferenceUtil
                                                .getSyncInstance()
                                            .getCompleteMissionVisible());
                                this.updateUI();
                              },
                              child: Text(
                                title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                            defaultColor: Color(0xff606060)),
                                    shadows: ThemeManager.getInstance().isDark()
                                        ? null
                                        : [
                                            Shadow(
                                                color: Colors.white,
                                                offset: Offset(1, 1))
                                          ]),
                              )),
                          SizedBox(
                            width: 2,
                          ),
                          SharePreferenceUtil.getSyncInstance()
                                      .getCompleteMissionVisible() ==
                                  false
                              ? Icon(Icons.arrow_drop_down,
                                  color: ThemeManager.getInstance()
                                      .getIconColor(
                                          defaultColor: Color(0xff606060)),
                                  size: 20)
                              : Icon(Icons.arrow_drop_up,
                                  color: ThemeManager.getInstance()
                                      .getIconColor(
                                          defaultColor: Color(0xff606060)),
                                  size: 20)
                        ],
                      )),
                ])));
  }
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局
  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override //是否需要重建
  bool shouldRebuild(MySliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
