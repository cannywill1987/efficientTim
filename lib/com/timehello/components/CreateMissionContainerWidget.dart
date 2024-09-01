import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/AISearchBar.dart';
import 'package:time_hello/com/timehello/components/MissionSearchBar.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/BottomBar.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../common/database/apis/MongoApisManager.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import '../models/FolderModel.dart';
import '../page/missionPage/componnents/HeaderStatsAndInputWidget.dart';
import '../util/SharePreferenceUtil.dart';
import '../util/Utility.dart';
import 'IconButtonListWidget.dart';

class CreateMissionContainerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateMissionContainerWidgetState();
  }
}

class CreateMissionContainerWidgetState extends State<CreateMissionContainerWidget> {
  GlobalKey<HeaderInputState> HeaderInputStateGlobalKey = GlobalKey();
  // int curIndex = 0;
  int? _circleColor = 0; //目标颜色
  String? _circleTitle = ""; //目标标题
  // List<CheckButtonStateModel> list = CONSTANTS.getCmdFButtonList(defaultVal: 0);
  String curScene = "";
  String? _folderModelObjId; //目标objectId 即folderId
  GlobalKey<BottomBarState>? bottomBarStateKey = GlobalKey();
  MissionModel _missionModel = MissionModel();

  int _numberTomatoes = 1; //番茄
  Icon? _circleIcon; //目标Icon

  //用于bottomBar
  int? _tagColor; // SelectTagDialogUtil 过来，选择完标签返回
  int _start_time = 0;
  int _end_time = 0;
  int? _dateStatus; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
  int _priorityStatus = 3; //优先级
  String? _tagName = ''; //创建missionPage tagName
bool isFocusing = false;
  bool isRequesting = false;

  /**
   * 创建mission时选择tag
   */
  Future onClickCreateTag(FolderModel data) async {
    // SelectTagDialogUtil.show(context,
    //     title: getI18NKey().selectTag,
    //     content: '', okCallBack: (FolderModel data) {
    this._tagColor = data.color;
    this._tagName = data.title;
    // this._tagId = data.objectId;
    this._missionModel?.tagNames = [this._tagName].join(',');
    this._missionModel?.tagIds = [data.objectId].join(',');
    setState(() {});
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
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
    setState(() {});
    // updateUI();
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // curScene = list[0].code ?? "";
  }

  void onClick(type, data) async {
    switch (type) {}
  }

  void onClickCreateItem(data) async {
    if (isRequesting == true) {
      return;
    }
    isRequesting = true;
    this._missionModel?.title = data;
    this._missionModel?.folder_id = _folderModelObjId ?? "";
    this._missionModel?.order_index = -1;
    this._missionModel?.tagNames = this._tagName;
    this._missionModel?.tagIds = ""; //2表示在tag里创建的任务 todo, 移动端选择tags时这里要处理下 做个区分
    this._missionModel?.total_tomotoes = this._numberTomatoes;
    this._missionModel?.tomato_duration =
        await SharePreferenceUtil.getSyncInstance().getTomatoTime();
    this._missionModel?.dateStatus = _dateStatus;
    this._missionModel.total_tomotoes = this._numberTomatoes;
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

    MongoApisManager.getInstance().insertMissiontData(
        missionModel: this._missionModel,
        callback: (res) async {
          isRequesting = false;
          if (res != null) {
            Utility.showToastMsg(msg: getI18NKey().addsuccess);
            eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
            eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
            // setState(() {});
            DialogManagement.getInstance().hideDialog(context);
          }
          // this.requestDatas(shouldRefresh: true);
        });
    // HeaderWidgetStateGlobalKey?.currentState?.onClickCreateItem();
  }

  BottomBar getBottomBar(BuildContext context, {bool isVisible: false}) {
    return BottomBar(
      key: bottomBarStateKey,
      start_time: this._start_time,
      end_time: this._end_time,
      //底部bar 用于创建任务用
      iconCircle: this._circleIcon,
      isVisible: isVisible,
      circleTitle: this._circleTitle ?? "",
      dateStatus: this._dateStatus ?? 0,
      //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
      priority: this._priorityStatus ?? 0,
      circleColor: !TextUtil.isEmpty(this._circleColor)
          ? Color(this._circleColor ?? 0xffff8800)
          : ColorsConfig.gray_cc_cancel,
      tagName: this._tagName ?? "",
      tagColor: this._tagColor != null
          ? Color(this._tagColor ?? 0xffff8800)
          : ColorsConfig.gray_cc_cancel,
      onTapFinishListener: ({data}) {
        // this.onClick('onClickSubmit', data);
        // this._missionModel.group_id = this.widget.groupModel.objectId;
        this.onClickCreateItem(this._missionModel.title);
      },
      onTapUpdateDateListener: (
          {dynamic startDate,
          dynamic alertDate,
          dynamic dailyStartDate,
          dynamic dailyEndDate,
          int time_mode = 0}) {
        // 0日期模式
        this._missionModel.time_mode = time_mode;
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
        setState(() {});
        // Navigator.of(context).pop();
        //   },
        // );
      },
      onTapPriorityListener: (data) {
        this._priorityStatus = data;
        this._missionModel?.priorityStatus = _priorityStatus;
        setState(() {});
        // Navigator.of(context).pop();
      },
      onTapCircleListener: (data) {
        this.onTapCircleListener(data);
      },
      onTapTagListener: (data) async {
        // this.onClick('onTapTagListener', data);
        this.onClickCreateTag(data);
      },
      onChangeListener: (data) {
        this._numberTomatoes = data;
      },
      totalTomatoes: this._numberTomatoes ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // height: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderInputWidget(
                shouldShowFolderIcons: false,
                // folderModel: FolderModel(),
                key: HeaderInputStateGlobalKey,
                // onChangeListener!(text, numTomatoes) {
                //                     this._numberTomatoes = numTomatoes;
                //                   },
                onChangeListener: (text, numTomatoes) {
                  this._missionModel.title = text;
                  isFocusing = text.length > 0;
                  this._numberTomatoes = numTomatoes;
                  setState(() {

                  });
                },
                text: "",
                onDesktopSubmitListener: (data, numTomtoes) {
                  this._numberTomatoes = numTomtoes;
                  FolderModel? folderModel = data['folderModel'];
                  if (folderModel != null) {
                    this._circleColor = folderModel.color;
                    this._circleTitle = folderModel.title;
                    this._circleIcon = Icon(
                        IconData(folderModel.icon ?? 0,
                            fontFamily: 'MaterialIcons'),
                        size: 25,
                        color: Color(this._circleColor ?? 0xffff8800));
                    this._folderModelObjId = folderModel.objectId;
                  }
                  this.onClickCreateItem(data['inputContent']);
                },
                onSubmitListener: (data) {
                  this._numberTomatoes = data['numTomatoes'];
                  FolderModel? folderModel = data['folderModel'];
                  if (folderModel != null) {
                    this._circleColor = folderModel.color;
                    this._circleTitle = folderModel.title;
                    this._circleIcon = Icon(
                        IconData(folderModel.icon ?? 0,
                            fontFamily: 'MaterialIcons'),
                        size: 25,
                        color: Color(this._circleColor ?? 0xffff8800));
                    this._folderModelObjId = folderModel.objectId;
                  }
                  this.onClickCreateItem(data['inputContent']);
                  // this.onClick('onClickSubmit', data);
                }),
            getBottomBar(context, isVisible: isFocusing),
          ],
        ));
  }
}
