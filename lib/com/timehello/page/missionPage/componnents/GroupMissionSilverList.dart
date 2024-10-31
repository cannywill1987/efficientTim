import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MissionSilverList.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../components/CustomTextField.dart';
import '../../../components/ExportMissionListDialogUtil.dart';
import '../../../components/ListingSecurityWidget.dart';
import '../../../components/MissionCountDownTextWidget.dart';
import '../../../components/SelectCircleDialogUtil.dart';
import '../../../components/SelectDateDialog.dart';
import '../../../components/SelectTagDialogUtil.dart';
import '../../../components/SubmissionColumnList.dart';
import '../../../config/ENUMS.dart';
import '../../../interface/OnSubmitListener.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../models/GroupModel.dart';
import '../../../models/SessionMissionModel.dart';
import '../../../util/DeviceInfoManagement.dart';

// import 'BottomBar.dart';
import '../../../util/SharePreferenceUtil.dart';
import '../../../util/WidgetManager.dart';
import 'BottomBar.dart';
import 'GroupAddWidget.dart';
import 'HeaderStatsAndInputWidget.dart';
import 'MultiSelectHandleWidget.dart';
import 'SectionHeaderForListView.dart';

class GroupMissionSilverList extends StatefulWidget {
  FolderModel folderModel;
  List<MissionModel>? _datas = [];
  List<MissionModel>? _datasMissionModelUnfinished = [];
  List<MissionModel>? _datasMissionModelFinished = [];
  OnTapListener? onTapListener;
  Function? onEnterListener;
  Function onClickCreateMission;
  Function onReorderMissionModelListListener;
  Function onUpdateGroupModelListener;
  Function onTapMoveLeftGroupListener;
  Function onTapMoveRightGroupListener;
  Function onUpdateUIListener;
  MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function onMoveNextGroupListener;
  Function onMovePreviousGroupListener;
  OnSubmitListener? onSubmitListener;
  OnDesktopSubmitListener? onDesktopSubmitListener;
  Function? onTapDoItNow;
  bool? isSlideEnable;
  bool isFirstGroup;
  bool isFirstGroupWithoutOrder;
  bool isLastGroup;
  GroupModel groupModel;
  Function? onChangeListener;

  // MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByWords;
  final Function onTapAddColumLeftGroupListener;
  final Function onTapAddColumRightGroupListener;
  final Function onTapDeleteGroupListener;
  final Function onTapSelectBgColorGroupListener;

  GroupMissionSilverList(
      {Key? key,
      List<MissionModel>? datas,
      OnTapListener? onTapListener,
      required this.onMoveNextGroupListener,
      required this.onMovePreviousGroupListener,
      required this.isFirstGroup,
      required this.isFirstGroupWithoutOrder,
      required this.isLastGroup,
      required this.onTapMoveLeftGroupListener,
      required this.onTapMoveRightGroupListener,
      required this.onUpdateUIListener,
      required this.onUpdateGroupModelListener,
      required this.onTapAddColumLeftGroupListener,
      required this.onTapAddColumRightGroupListener,
      required this.onTapDeleteGroupListener,
      required this.onTapSelectBgColorGroupListener,
      required this.onReorderMissionModelListListener,
      required this.onClickCreateMission,
      required this.folderModel,
      required this.groupModel,
      this.onEnterListener,
      this.onTapMultiSelectListener,
      this.onSubmitListener,
      this.onDesktopSubmitListener,
      this.onTapFinishListener,
      this.onTapDoItNow,
      this.onTapUnFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.isSlideEnable = true})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this._datas = datas;
    this._datasMissionModelUnfinished =
        Utility.filterMissionModelByFinishedState(
            list: _datas ?? [], isFinished: false);
    this._datasMissionModelFinished = Utility.filterMissionModelByFinishedState(
        list: _datas ?? [], isFinished: true);
  }

  set datas(List<MissionModel> datas) {
    _datas = datas;
    _datasMissionModelUnfinished = Utility.filterMissionModelByFinishedState(
        list: _datas ?? [], isFinished: false);
    _datasMissionModelFinished = Utility.filterMissionModelByFinishedState(
        list: _datas ?? [], isFinished: true);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new MissionSilverState();
  }
}

class MissionSilverState extends State<GroupMissionSilverList> {
  // Map<int, bool> isReoderingMapping = {};
  bool isReodering = false;
  bool isAddingMission = false;
  GlobalKey<BottomBarState>? bottomBarStateKey = GlobalKey();
  MissionModel _missionModel = MissionModel();
  MultiSelectModeEnum multiSelectModeEnum = MultiSelectModeEnum.normal;

  //用于bottomBar
  int? _tagColor; // SelectTagDialogUtil 过来，选择完标签返回
  String? _circleTitle = ''; //目标标题 从folderModel过来 或者从SelectCircleDialogUtil
  int? _circleColor = 0; //目标颜色
  String? _folderModelObjId; //目标objectId 即folderId
  Icon? _circleIcon; //目标Icon
  int _start_time = 0;
  int _end_time = 0;
  int? _dateStatus; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
  int _priorityStatus = 3; //优先级
  String? _tagName = ''; //创建missionPage tagName
  int _numberTomatoes = 1; //番茄
  String? _tagId = ''; //
  GlobalKey<HeaderInputState> customTextFieldGlobalKey = GlobalKey();
  GlobalKey<CustomTextFieldState> customTextFieldStateGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // void resetIsReoderingMapping() {
  //   isReoderingMapping.updateAll((key, value) => false);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GroupMissionSilverList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // if(this.widget.groupModel.isAdd == true) {
    //   customTextFieldStateGlobalKey.currentState?.setEditing(isEditting: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    initData(this.widget.folderModel);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          child: GroupAddWidget(
            customTextFieldKey: customTextFieldStateGlobalKey,
            title: this.widget.groupModel.title ?? "",
            onEnterListener: (title) {
              this.widget.onEnterListener?.call(title);
            },
            onMoreListener: () {},
            onAddMissionListener: () {
              this.isAddingMission = this.isAddingMission ? false : true;
              print("res:${this.isAddingMission}");
              setState(() {});
            },
            totalMission: this.widget.groupModel.missionModelList?.length ?? 0,
            groupModel: this.widget.groupModel,
            onTapAddColumLeftGroupListener:
                this.widget.onTapAddColumLeftGroupListener,
            onTapAddColumRightGroupListener:
                this.widget.onTapAddColumRightGroupListener,
            onTapDeleteGroupListener: this.widget.onTapDeleteGroupListener,
            onTapSelectBgColorGroupListener:
                this.widget.onTapSelectBgColorGroupListener,
            onUpdateGroupModelListener: (groupModel) {
              this.widget.onUpdateGroupModelListener?.call(groupModel);
            },
            isFirst: this.widget.isFirstGroupWithoutOrder,
            isLast: this.widget.isLastGroup,
            onMoveNextGroupListener: this.widget.onMoveNextGroupListener,
            onMovePreviousGroupListener:
                this.widget.onMovePreviousGroupListener,
          ),
        ),
        if (isAddingMission == true) getHeaderInputWidget(),
        getBottomBar(context, isVisible: isAddingMission),
        if (isAddingMission == true)
          SizedBox(
            height: 10,
          ),
        // if(isAddingMission)
        //   BottomBar(totalTomatoes: 10, tagColor: Colors.red, circleColor: Colors.yellow,),
        Expanded(
          child: Scrollbar(
            trackVisibility: true,
            child: ReorderableListView(
              primary: true,
              padding: EdgeInsets.symmetric(horizontal: 5),
              buildDefaultDragHandles:
                  !TextUtil.isEmpty(this.widget.groupModel.objectId),
              onReorderStart: (index) {
                // this.isReodering = true;
                // this.resetIsReoderingMapping();
                if (TextUtil.isEmpty(this.widget.groupModel.objectId)) {
                  Utility.showToastMsg(
                      msg: getI18NKey().cannot_reorder_for_group);
                  return;
                }
                if (this.widget._datasMissionModelUnfinished?.length == index) {
                  Utility.showToastMsg(
                      msg: getI18NKey().cannot_reorder_for_group);
                  return;
                }
                isReodering = true;
                setState(() {});
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                print("start:${isReodering}");
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
              },
              onReorderEnd: (index) {
                // this.isReodering = false;

                isReodering = false;
                setState(() {});
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                print("start:${isReodering}");
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
              },
              onReorder: (oldIndex, newIndex) {
                if (((this.widget._datasMissionModelUnfinished?.length ?? 0) ==
                    oldIndex)) {
                  Utility.showToastMsg(
                      msg: getI18NKey().cannot_reorder_for_group);
                  return;
                }

                // if (((this.widget._datasMissionModelUnfinished?.length ?? 0) == 0) && newIndex == 0) {
                //   Utility.showToast(msg: getI18NKey().cannot_reorder_for_group);
                //   return;
                // }
                if (this.widget._datasMissionModelUnfinished?.length ==
                    oldIndex) {
                  Utility.showToastMsg(
                      msg: getI18NKey().cannot_reorder_for_group);
                  return;
                }
                if (TextUtil.isEmpty(this.widget.groupModel.objectId)) {
                  Utility.showToastMsg(
                      msg: getI18NKey().cannot_reorder_for_group);
                  return;
                }
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  MissionModel? item = this.widget._datas?.removeAt(
                      (this.widget._datasMissionModelUnfinished?.length ?? 0) <
                              oldIndex
                          ? oldIndex - 1
                          : oldIndex);
                  // int length = this.widget._datas.length ?? 0;
                  int length = Utility.filterMissionModelByFinishedState(
                          list: this.widget._datas ?? [], isFinished: false)
                      .length;
                  if (item != null &&
                      ((this.widget._datas?.length ?? 0) + 1) >= newIndex) {
                    if (((this.widget._datas?.length ?? 0) + 1) == newIndex) {
                      this.widget._datas?.add(item);
                    } else {
                      this.widget._datas?.insert(newIndex, item);
                    }
                    // this.widget._datas?.insert(newIndex, item!);
                    //如果不在 this.widget._datasMissionModelUnfinished 把missionModel的isFinished设置为true
                    // this.widget._datasMissionModelUnfinished = Utility.filterMissionModelByFinishedState(list: this.widget._datas ?? [], isFinished: false);
                    // this.widget._datasMissionModelFinished = Utility.filterMissionModelByFinishedState(list: this.widget._datas ?? [], isFinished: true);
                    if (newIndex < (length) + 1) {
                      item.isFinished = false;
                    } else {
                      item.isFinished = true;
                    }

                    this.widget.onReorderMissionModelListListener?.call(
                        this.widget._datas!, this.widget.groupModel, item);
                  }
                });
              },
              children: getListView(),
            ),
          ),
        ),
        if (this.multiSelectModeEnum == MultiSelectModeEnum.multiSelect)
          getMultiSelectHandleWidget(context)
      ],
    );
  }

  MultiSelectHandleWidget getMultiSelectHandleWidget(BuildContext context) {
    return MultiSelectHandleWidget(
      missionModelList: this.widget.groupModel.missionModelList ?? [],
      onClickUpdateTimeDoItNow: (datas) async {
        Utility.onClickUpdateTimeDoItNow(context, datas);
      },
      onClickDelete: (datas) async {
        await MongoApisManager.getInstance()
            .batchDelete_MissionModel(listParam: datas);
        this.widget.onUpdateUIListener.call();
      },
      onClickExport: (datas) {
        TextEditingController textEditingController = TextEditingController();
        String s = Utility.getContentFromMissionList(
            datas: datas ?? [],
            listCheckButtonModel: CONSTANTS.getExportButtonsList());
        textEditingController.text = s;
        ExportMissionListDialogUtil.show(context,
            textEditingController: textEditingController, onTapListener: (res) {
          List<CheckButtonStateModel> data = res['data'];
          MissionOrderEnum missionOrderEnum = res['enum'];
          String s = Utility.getContentFromMissionList(
              datas: Utility.getMissionModelListAfterOrder(
                  missionOrderEnum, datas ?? []),
              listCheckButtonModel: data);
          textEditingController.text = s;
          setState(() {});
          ;
        }, export: (data) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().offer_next_version);
        });
      },
      onClickFinish: (datas) async {
        await MongoApisManager.getInstance()
            ?.batchUpdate_MissionModelWithParams(listMissionModel: datas);
        this.widget.onUpdateUIListener.call();
      },
      onClickUnFinish: (datas) async {
        await MongoApisManager.getInstance()
            ?.batchUpdate_MissionModelWithParams(listMissionModel: datas);
        this.widget.onUpdateUIListener.call();
      },
      onClickClose: (datas) async {
        resetMultiSelectModeEnum();
      },
    );
  }

  void resetMultiSelectModeEnum() {
    this.widget.groupModel.missionModelList?.forEach((element) {
      element.isSelected = false;
    });
    this.multiSelectModeEnum = MultiSelectModeEnum.normal;
    setState(() {});
  }

  void initData(FolderModel folderModel) {
    this._missionModel?.total_tomotoes = this._numberTomatoes;
    this._missionModel?.tomato_duration =
        SharePreferenceUtil.getSyncInstance().getTomatoTime();
    int folderStatus = 1; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
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
        if (folderModel.icon != null)
          this._circleIcon = Icon(
              IconData(folderModel.icon!, fontFamily: 'MaterialIcons'),
              size: 20,
              color: Color(this._circleColor ?? 0xffff8800));
      }
      this._folderModelObjId = folderModel.objectId; //用于创建mission时保存id
    }
    if (this._dateStatus == null) {
      if (folderStatus != null) {
        //如果来自今天 明天 即将到来等
        this._dateStatus = folderStatus - 1;
      } else {
        //否则来自文件夹等
        this._dateStatus = 0;
      }
    }
  }

  resetData() {
    customTextFieldGlobalKey.currentState?.resetData();
  }

  unfocus() {
    customTextFieldGlobalKey.currentState?.unfocus();
  }

  getHeaderInputWidget() {
    return Container(
        key: ValueKey('Container1322'),
        margin: EdgeInsets.fromLTRB(
            CONSTANTS.missionPageMargin, 10, CONSTANTS.missionPageMargin, 0),
        child: HeaderInputWidget(
            folderModel: this.widget.folderModel ?? FolderModel(),
            key: customTextFieldGlobalKey,
            onChangeListener: (val, numTomatoes) {
              this._missionModel.title = val;
              this._numberTomatoes = numTomatoes;
              this._missionModel.total_tomotoes = numTomatoes;
            },
            text: "",
            onDesktopSubmitListener: (dynamic obj, int numTomatoes) {
              // this._missionModel.title = obj;
              // this.widget.onSubmitListener?.call(this._missionModel);
              // this.isAddingMission = false;
              this._missionModel.total_tomotoes = numTomatoes;
              this._missionModel.title = obj;
              this._missionModel.group_id = this.widget.groupModel.objectId;
              this._missionModel.folder_id = this.widget.folderModel.objectId;
              this.widget.onClickCreateMission(this._missionModel);
              this.isAddingMission = false;
              setState(() {});
            },
            onSubmitListener: (val) {
              String title = val['inputContent'];
              int numTomatoes = val['numTomatoes'];
              this._missionModel.total_tomotoes = numTomatoes;
              this._missionModel.title = title;
              this._missionModel.group_id = this.widget.groupModel.objectId;
              this._missionModel.folder_id = this.widget.folderModel.objectId;
              // this.widget.onSubmitListener?.call(this._missionModel);
              this.widget.onClickCreateMission(this._missionModel);
              this.isAddingMission = false;
              setState(() {});
            }));
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
        this._missionModel.group_id = this.widget.groupModel.objectId;
        this._missionModel.folder_id = this._folderModelObjId;
        this.widget.onClickCreateMission(this._missionModel);
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
      onChangeListener: (data) => {this._numberTomatoes = data},
      totalTomatoes: this._numberTomatoes ?? 1,
    );
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
    setState(() {});
    // }, onTapCreateTagListener: (data) {
    //   // this.onClick("onTapCreateTagListener", data);
    // }, onTapListener: (data) {});
  }

  onTapMultiSelectListener(data) async {
    if (data == null) {
      if (this.multiSelectModeEnum == MultiSelectModeEnum.normal) {
        this.multiSelectModeEnum = MultiSelectModeEnum.multiSelect;
      } else {
        this.multiSelectModeEnum = MultiSelectModeEnum.normal;
      }
    }
    setState(() {});
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

  List<Widget> getListView() {
    List<Widget> listViewItems = [];
    if (this.widget._datasMissionModelUnfinished != null) {
      for (int index = 0;
          index < this.widget._datasMissionModelUnfinished!.length;
          index++) {
        MissionModel item = this.widget._datasMissionModelUnfinished![index];
        // bool isReordering = isReodering ?? false;
        listViewItems.add(getItem(item));
      }
    }
    if ((this.widget._datasMissionModelUnfinished?.length ?? 0) > 0 ||
        ((this.widget._datasMissionModelFinished?.length ?? 0) > 0)) {
      listViewItems.add(SectionHeaderForListView(
        key: ValueKey(Utility.getRandom(from: 0, max: 100000).toString()),
        title: getI18NKey().finished,
      ));
    }
    if (this.widget._datasMissionModelFinished != null) {
      for (int index = 0;
          index < this.widget._datasMissionModelFinished!.length;
          index++) {
        MissionModel item = this.widget._datasMissionModelFinished![index];
        // bool isReordering = isReodering ?? false;
        listViewItems.add(getItem(item));
      }
    }

    // listViewItems.add(Container(key: ValueKey(Utility.getRandom(from: 0, max: 100000).toString()),height: 200, color:Colors.red));
    return listViewItems;
  }

  GroupMissionSilverListItem getItem(MissionModel item) {
    return GroupMissionSilverListItem(
      key: ValueKey(item.objectId.toString() +
          Utility.getRandom(from: 0, max: 100000).toString()),
      multiSelectModeEnum: this.multiSelectModeEnum,
      isSlideEnable: this.widget.isSlideEnable ?? false,
      onTapListener: this.widget.onTapListener,
      isReorderable: TextUtil.isEmpty(this.widget.groupModel.objectId),
      missionModel: item,
      onTapDoItNow: this.widget.onTapDoItNow,
      onTapUnFinishListener: this.widget.onTapUnFinishListener,
      onTapEditTitleListener: this.widget.onTapEditTitleListener,
      onTapEditListener: this.widget.onTapEditListener,
      onTapDeleteListener: this.widget.onTapDeleteListener,
      onTapFinishListener: this.widget.onTapFinishListener,
      onTapMultiSelectListener: (MissionModel? obj) {
        this.onTapMultiSelectListener(obj);
      },
      onTapPlayListener: this.widget.onTapPlayListener,
      isReodering: this.isReodering,
      groupModel: this.widget.groupModel,
      onTapMoveLeftGroupListener: this.widget.onTapMoveLeftGroupListener,
      onTapMoveRightGroupListener: this.widget.onTapMoveRightGroupListener,
      isFirstGroup: this.widget.isFirstGroup,
      isLastGroup: this.widget.isLastGroup,
    );
  }
}

class GroupMissionSilverListItem extends StatefulWidget {
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  Function onTapMoveLeftGroupListener;
  Function onTapMoveRightGroupListener;
  bool isFirstGroup;
  bool isLastGroup;

  // int index = 0;
  GroupModel groupModel;
  bool isVisible = false;
  bool isSlideEnable = true;
  MissionModel? _missionModel;
  OnTapFinishListener? onTapFinishListener;
  Function? onTapDoItNow;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapEditTitleListener? onTapEditTitleListener;
  MultiSelectModeEnum multiSelectModeEnum;
  bool isReodering = false;
  bool isReorderable = true; // 未分组不用拖动
  // Map<int, Image> map = {};
  GroupMissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      OnTapListener? onTapListener,
      MissionModel? missionModel,
      required this.isFirstGroup,
      required this.isLastGroup,
      // int index = 0,
      required this.groupModel,
      required this.onTapMoveLeftGroupListener,
      required this.onTapMoveRightGroupListener,
      this.isReorderable = true,
      required this.isReodering,
      required this.multiSelectModeEnum,
      this.onTapMultiSelectListener,
      this.onTapEditTitleListener,
      this.onTapDoItNow,
      this.onTapPlayListener,
      this.onTapUnFinishListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.isSlideEnable = false})
      : super(key: key) {
    this.onTapListener = onTapListener;
    // this.index = index;
    this.isVisible = isVisible;
    this._missionModel = missionModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw MenuSilverListItem(onTapListener);
    return GroupMissionSilverListItemState();
  }
}

class GroupMissionSilverListItemState
    extends State<GroupMissionSilverListItem> {
  bool isHover = Utility.isHandsetBySize() ? true : false;

  double height = 125;
  ImageProvider? imageProvider;

  FolderModel? getFolderModel(MissionModel? missionModel) {
    if (!TextUtil.isEmpty(this.widget._missionModel?.folder_id)) {
      List<FolderModel> wqbFolderModelList = MongoApisManager.getInstance()
          .queryWhereEqual_folderModelWithFolderId(
              this.widget._missionModel?.folder_id);
      if (wqbFolderModelList.length > 0) {
        return wqbFolderModelList[0];
      }
    }
    return null;
  }

  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );

  @override
  Widget build(BuildContext context) {
    // print("grid mission silver list");
    MissionModel? _missionModel = this.widget._missionModel;
    // FolderModel? folderModel = getFolderModel(_missionModel);
    bool isDoItNow = this.isDoItNow(_missionModel);
    // TODO: implement build
    //左边文案和角标
    List<Widget> childrenRow = <Widget>[
      Container(
          height: 30,
          width: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(
                CONSTANTS.getPriorityColor(_missionModel?.priorityStatus ?? 3)),
          )),
      SizedBox(
        width: 5,
      ),
      CheckImage(
        width: 25,
        height: 25,
        isSizeConfigured: true,
        onTapListener: (res) {
          if (_missionModel?.isFinished == true) {
            if (this.widget.onTapUnFinishListener != null)
              this.widget.onTapUnFinishListener?.call(_missionModel);
          } else {
            if (this.widget.onTapFinishListener != null)
              this.widget.onTapFinishListener!(_missionModel);
          }
        },
        checked: _missionModel?.isFinished ?? false,
        checkIcon: Icon(Icons.check_circle,
            size: 20, color: ColorsConfig.calendar_green),
        uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
            color: ColorsConfig.gray_a7, size: 20),
      ),
      SizedBox(
        width: 2,
      ),
      InkWell(
          onTap: () {
            if (this.widget.onTapPlayListener != null)
              this.widget.onTapPlayListener!(_missionModel);
          },
          child: Icon(
            Icons.play_circle_outline,
            color: Color(0xfffd5553),
            size: 20,
          )),
      ListingSecurityWidget(
        missionModdel_id: _missionModel?.objectId,
        folder_id: _missionModel?.folder_id ?? "",
        cryptoVersion: _missionModel?.cryptoVersion ?? -1,
        marginLeft: 5,
        size: 15,
      ),
      SizedBox(
        width: 5,
      ),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: _missionModel?.title ?? "",
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  decoration: _missionModel?.isFinished == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor: Color(0xffa0a0a0)),
                                  decorationThickness: 2,
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor: Color(0xff404040)))),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  if ((_missionModel?.subMissions?.length ??
                                          0) >
                                      0) ...[
                                    Utility.getSVGPicture(
                                        R.assetsImgIcSubmission,
                                        size: 14),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _missionModel?.subMissions?.length
                                              .toString() ??
                                          "0",
                                      textAlign: TextAlign.left,
                                      style: ThemeManager.getInstance()
                                          .getTextStyle(
                                              defaultTextStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xff9DA7B2))),
                                    ),
                                  ],
                                ],
                              )),
                          ...WidgetManager.getTagsWidgetSpan(
                              _missionModel ?? MissionModel(),
                              fontSize: 14),
                          ...WidgetManager.getIsNoteWidget(
                            _missionModel ?? MissionModel(),
                          )
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SubmissionColumnList(
                    missionModel: _missionModel ?? MissionModel(),
                  ),
              ]),
          flex: 3),
      // Spacer(),
      Container(
          margin: EdgeInsets.fromLTRB(
              0, 0, (this.isHover == false && isDoItNow) ? 3 : 4, 0),
          alignment: Alignment.centerRight,
          width: (this.isHover == false && isDoItNow) ? 110 : 25,
          height: 25,
          child: (this.isHover == true)
              ? PopupMenuButton<String>(
                  tooltip: '',
                  iconSize: 14,
                  icon: Icon(
                    Icons.more_vert,
                    color: ThemeManager.getInstance()
                        .getIconColor(defaultColor: Colors.black87),
                  ),
                  onCanceled: () {},
                  itemBuilder: (context) {
                    // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                    if (_missionModel?.isFinished == false) {
                      return getUnfinishedPopupList(
                          _missionModel ?? MissionModel());
                    } else {
                      return getFinishedPopupList(
                          _missionModel ?? MissionModel());
                    }
                  },
                )
              : isDoItNow
                  ? MissionCountDownTextWidget(
                      fontSize: 12,
                      color: 0xff909090,
                      end_time: _missionModel?.do_it_now?[0]['end_time'] as int,
                      end_buffer_time: _missionModel?.do_it_now?[0]
                          ['buffer_end_time'],
                      isFinished: _missionModel?.isFinished ?? false,
                    )
                  : SizedBox.shrink()),
    ];
    // print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
    // print("moving:" + this.widget.isReodering.toString());
    // print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
    if (DeviceInfoManagement.isMoible() == true ||
        DeviceInfoManagement.isWebMobileBySize()) {
      return Slidable(
        key: ValueKey(_missionModel),
        enabled: DeviceInfoManagement.isMoible() == true ||
            DeviceInfoManagement.isWebMobileBySize(),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: ratio,
          children: _missionModel?.isFinished == false
              ? getUnfinishIconSlideActions(_missionModel ?? MissionModel())
              : getFinishIconSlideActions(_missionModel ?? MissionModel()),
        ),
        child: getItem(_missionModel, childrenRow),
      );
    } else {
      return getItem(_missionModel, childrenRow);
    }
  }

  Widget getItem(MissionModel? _missionModel, List<Widget> childrenRow) {
    return InkWell(
        onTap: () {
          if (this.widget.multiSelectModeEnum ==
              MultiSelectModeEnum.multiSelect) {
            if (this.widget.onTapMultiSelectListener != null) {
              _missionModel?.isSelected =
                  _missionModel.isSelected ? false : true;
              this.widget.onTapMultiSelectListener?.call(_missionModel);
              setState(() {});
            }
          } else {
            if (this.widget.onTapEditListener != null) {
              this.widget.onTapEditListener!(_missionModel);
            }
          }
        },
        child: MouseRegion(
            onEnter: (_) {
              setState(() {
                this.isHover = true;
              });
            },
            onHover: (_) {},
            onExit: (_) {
              setState(() {
                this.isHover = Utility.isHandsetBySize() ? true : false;
              });
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  bottom: 4,
                  left: CONSTANTS.missionPageMargin,
                  right: (CONSTANTS.missionPageMargin)),
              decoration: new BoxDecoration(
                border: this.widget.multiSelectModeEnum ==
                        MultiSelectModeEnum.normal
                    ? new Border.all(
                        width: 1.0,
                        color: ThemeManager.getInstance().isDark()
                            ? Color(CONSTANTS.getPriorityColor(
                                _missionModel?.priorityStatus ?? 3))
                            : new Color(0xfff0f0f0))
                    : Border.all(
                        width: 2.0,
                        color: new Color((CONSTANTS.getPriorityColor(
                                _missionModel?.priorityStatus ?? 3) -
                            (this.widget._missionModel?.isSelected == true
                                ? 0x00000000
                                : 0xe0000000)))),
                image: imageProvider == null
                    ? null
                    : DecorationImage(
                        image: imageProvider!,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            ThemeManager.getInstance().getCardBackgroundColor(
                                defaultColor: Colors.white),
                            BlendMode.colorBurn)),
                color: ThemeManager.getInstance()
                    .getCardBackgroundColor(defaultColor: Colors.white),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0)),
              ),
              child: Stack(
                children: [
                  TextUtil.isEmpty(_missionModel?.background_url ?? "")
                      ? SizedBox.shrink()
                      : CachedNetworkImage(
                          imageUrl: Utility.filterHttpUrl(
                              _missionModel?.background_url ?? '',
                              prefix: "oss"),
                          imageBuilder: (context, imageProviderTmp) {
                            Future.delayed(Duration(seconds: 0), () {
                              imageProvider = imageProviderTmp;
                              if (mounted == true) {
                                // setState(() {});
                              }
                            });
                            return Container();
                          }),
                  Container(
                    color: ThemeManager.getInstance().getCardBackgroundColor(
                        defaultColor: Colors.white, alpha: 150),
                    // color: Colors.yellow,
                    constraints: BoxConstraints(minHeight: 30),
                    padding: EdgeInsets.only(
                        right: this.widget.isReorderable == true ? 5 : 28,
                        top: 0,
                        bottom: 0),
                    alignment: Alignment.centerLeft,
                    child: Stack(children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: childrenRow,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            )));
  }

  bool isDoItNow(MissionModel? _missionModel) =>
      (_missionModel != null && Utility.isDoingItNow(_missionModel));
  double fontSize = Utility.isHandsetBySize() ? 11 : 15;

  List<Widget> getFinishIconSlideActions(MissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapUnFinishListener != null)
            this.widget.onTapUnFinishListener!(_missionModel);
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().unfinished,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapMultiSelectListener != null)
            this.widget.onTapMultiSelectListener!(null);
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.select_all,
        label: getI18NKey().multi_select,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<Widget> getUnfinishIconSlideActions(MissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          this.widget.onTapPlayListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.play_arrow,
        label: getI18NKey().play,
      ),
      SlidableAction(
        onPressed: (context) {
          if (_missionModel.isFinished == false) {
            if (this.widget.onTapFinishListener != null)
              this.widget.onTapFinishListener!(_missionModel);
          } else {
            if (this.widget.onTapUnFinishListener != null)
              this.widget.onTapUnFinishListener!(_missionModel);
          }
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().finish,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapEditListener != null)
            this.widget.onTapEditListener!(_missionModel);
        },
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        label: getI18NKey().edit,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapMultiSelectListener != null)
            this.widget.onTapMultiSelectListener!(null);
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.select_all,
        label: getI18NKey().multi_select,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<PopupMenuEntry<String>> getUnfinishedPopupList(
      MissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      if (!this.widget.isFirstGroup)
        PopupMenuItem<String>(
          value: 'move_previous',
          onTap: () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapMoveLeftGroupListener(
                  _missionModel, this.widget.groupModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(R.assetsImgIcPrevious, width: 16, height: 16),
              SizedBox(width: 5),
              Text(getI18NKey().jump_previous_group,
                  style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      if (!this.widget.isLastGroup)
        PopupMenuItem<String>(
          value: 'move_next',
          onTap: () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapMoveRightGroupListener(
                  _missionModel, this.widget.groupModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(R.assetsImgIcNext, width: 16, height: 16),
              SizedBox(width: 5),
              Text(getI18NKey().jump_next_group,
                  style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      PopupMenuItem<String>(
        value: 'start_focus',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapPlayListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Utility.getSVGPicture(R.assetsImgIcFocusTarget, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().start_focus,
                style: TextStyle(fontSize: 15, color: Colors.red)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'complete',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapFinishListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.check, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().finish, style: TextStyle(fontSize: 15))
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'doItNow',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            this.widget.onTapDoItNow!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Utility.getSVGPicture(R.assetsImgIcInstantly, size: fontSize),
            // Icon(Icons.check, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().do_it_now,
                style: TextStyle(fontSize: 15, color: Color(0xffff8800)))
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'edit',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapEditListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.green, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().edit,
                style: TextStyle(color: Colors.green, fontSize: 15))
          ],
        ),
      ),
      PopupMenuItem<String>(
          value: 'multi_select',
          onTap: () {
            this.widget.onTapMultiSelectListener?.call(null);
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.select_all, color: Colors.blue, size: fontSize),
              SizedBox(width: 5),
              Text(getI18NKey().multi_select,
                  style: TextStyle(color: Colors.blue, fontSize: 15)),
            ],
          )),
      PopupMenuItem<String>(
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          value: 'delete',
          onTap: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapDeleteListener!(_missionModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.grey, size: fontSize),
              SizedBox(width: 5),
              Text(
                getI18NKey().delete,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          )),
    ];
  }

  List<PopupMenuEntry<String>> getFinishedPopupList(
      MissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      if (!this.widget.isFirstGroup)
        PopupMenuItem<String>(
          value: 'move_previous',
          onTap: () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapMoveLeftGroupListener(
                  _missionModel, this.widget.groupModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(R.assetsImgIcPrevious, width: 16, height: 16),
              SizedBox(width: 5),
              Text(getI18NKey().jump_previous_group,
                  style: TextStyle(fontSize: 15, color: Color(0xff404040))),
            ],
          ),
        ),
      if (!this.widget.isLastGroup)
        PopupMenuItem<String>(
          value: 'move_next',
          onTap: () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapMoveRightGroupListener(
                  _missionModel, this.widget.groupModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(R.assetsImgIcNext, width: 16, height: 16),
              SizedBox(width: 5),
              Text(getI18NKey().jump_next_group,
                  style: TextStyle(fontSize: 15, color: Color(0xff404040))),
            ],
          ),
        ),
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'unfinished',
        onTap: () {
          if (this.widget.onTapUnFinishListener != null)
            this.widget.onTapUnFinishListener?.call(_missionModel);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.green, size: fontSize),
            Text(
              getI18NKey().unfinished,
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'multi_select',
        onTap: () {
          this.widget.onTapMultiSelectListener?.call(null);
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          // Future.delayed(Duration(milliseconds: 100), () {
          //   this.widget.onTapEditListener!(_missionModel);
          // });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.select_all, color: Colors.blue, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().multi_select,
                style: TextStyle(color: Colors.blue, fontSize: 15)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.grey, size: fontSize),
            SizedBox(width: 5),
            Text(
              getI18NKey().delete,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    ];
  }
}
