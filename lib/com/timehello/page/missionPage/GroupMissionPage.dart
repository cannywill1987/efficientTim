// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/components/unified/UnifiedDesktopShell.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/GroupModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../r.dart';
import '../../common/provider/Env.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CheckButtonListWithIconWidget.dart';
import '../../components/CustomBlackButton.dart';
import '../../components/CustomLgLeftChatWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../components/CustomTextField.dart';
import '../../components/ExportMissionListDialogUtil.dart';
import '../../components/GroupIconButtonListWidget.dart';
import '../../components/SearchBarWidget.dart';
import '../../components/SearchBarWithIconWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ColorsConfig.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../models/EventFn.dart';
import '../../models/FolderModel.dart';
import '../../util/CounterManagement.dart';
import '../../util/DialogManagement.dart';
import '../../util/OverlayManagement.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../RichEditor/RichEditorPage.dart';
import '../SettingItemDetailPage/SettingItemDetailPage.dart';
import '../TimeLinePage/components/FileMessageWidget.dart';
import '../WrongQuestionBookPage/components/WQBNoteWidget.dart';
import '../missionPage/componnents/MissionGridView.dart';
import 'componnents/GroupMissionSilverList.dart';
import 'componnents/MissionSilverList.dart';
import '../../libs/DragAndDropLists/lib/drag_and_drop_item.dart';
import '../../libs/DragAndDropLists/lib/drag_and_drop_list.dart';
import '../../libs/DragAndDropLists/lib/drag_and_drop_lists.dart';

class GroupMissionPage extends BaseWidget {
  // FolderModel? folderModel; //FoldersPage页面传入的数据
  Function? onTapNavMenuListener;
  Key? key;
  Function? onTapRightNavMenuListener;
  final bool useUnifiedStyle;

  GroupMissionPage(
      {this.key,
      this.onTapRightNavMenuListener,
      this.onTapNavMenuListener,
      this.useUnifiedStyle = false})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return GroupMissionPageState();
  }
}

class GroupMissionPageState extends BaseWidgetState<GroupMissionPage> {
  FolderModel? folderModel;
  bool isModifying = false;
  bool isRequesting = false;
  bool isAddingGroup = false; // 是否添加group中
  // AppFlowyEditor? editor;
  List<GroupModel> listGroupModels = [];
  List<GroupModel> listGroupModelsAddingGroup = [];
  int curMobileIndex = 0;
  double margin = 5;
  bool isSearchBarVisible = false;
  List<MissionModel>? curListMissionModels = [];
  GlobalKey<DraggableHorizontalListState> draggableHorizontalListKey =
      GlobalKey();
  GlobalKey<SearchBarWidgetState>? searchBarWidgetKey = GlobalKey();
  String? curSearchWords = null;
  bool get isUnifiedDesktop =>
      widget.useUnifiedStyle && !Utility.isHandsetBySize();

  Widget _buildUnifiedDesktopCanvas({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8DAC4),
            Color(0xFFF7ECDD),
            Color(0xFFDDEDE0),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -72,
            left: -54,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD7B8).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(95),
              ),
            ),
          ),
          Positioned(
            top: 178,
            left: -62,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFFCFE6D7).withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(85),
              ),
            ),
          ),
          Positioned(
            top: 64,
            right: -48,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF7E2D0).withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(75),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    // this.setKeyboardVisibityListener();
  }

  didupdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.updateRightNavChildren();
  }

  void updateRightNavChildren() {
    // && this.rightNavChildren == null
    if (this.folderModel?.tag == 1) {
      // if (ABTestSetting.isOpenAiOn && Utility.isHuaWei() == false)
      this.rightNavChildren = [
        IconButton(
            onPressed: () {
              this
                  .widget
                  .onTapRightNavMenuListener
                  ?.call(this.folderModel, false);
            },
            icon: Utility.getSVGPicture(R.assetsImgIcListingGroup,
                size: StylesConfig.sizeGroup))
      ];
      updateUI();
    }
    // else if(this.rightNavChildren != null){
    //   this.rightNavChildren = null;
    //   updateUI();
    // }
    else if (ABTestSetting.isOpenAiOn && Utility.isHuaWei() == false) {
      this.rightNavChildren = [
        IconButton(
            onPressed: () {
              this
                  .widget
                  .onTapRightNavMenuListener
                  ?.call(this.folderModel, true);
            },
            icon: Utility.getSVGPicture(R.assetsImgIcAiVoice, size: 24))
      ];
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  componentDidMount() {
    // TODO: implement componentDidMount
    updateRightNavChildren();
    return super.componentDidMount();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onMoveNextGroupListener':
        this.onMoveNextGroupListener(data);
        break;
      case 'onMovePreviousGroupListener':
        this.onMovePreviousGroupListener(data);
        break;
      case "onTapMoveLeftGroupListener":
        this.onTapMoveLeftGroupListener(
            data['missionModel'], data['groupModel']);
        break;
      case "onTapMoveRightGroupListener":
        this.onTapMoveRightGroupListener(
            data['missionModel'], data['groupModel']);
        break;
      case "onDragMissionBetweenGroupsListener":
        this.onDragMissionBetweenGroupsListener(
          movedMission: data['missionModel'],
          sourceGroupModel: data['sourceGroupModel'],
          targetGroupModel: data['targetGroupModel'],
          orderedSourceMissionModels:
              List<MissionModel>.from(data['orderedSourceMissionModels'] ?? []),
          orderedTargetMissionModels:
              List<MissionModel>.from(data['orderedTargetMissionModels'] ?? []),
        );
        break;
      case 'onClickDoItNow':
        Utility.onClickUpdateTimeDoItNow(context, [data]);
        break;
      case 'onTapMultiSelectListener':
        // this.onTapMultiSelectListener(data);
        break;
      case 'onClickUnFinishListener':
        this.onClickUnFinishListener(data);
        break;
      case 'onClickMissionDetail': //跳转到任务详情页MissionPage开始任务
        //点击item
        onClickMissionStart(context, data, this.folderModel);
        break;
      case 'onClickMissionSetting': //跳转到设置叶敏
        onClickMissionSetting(data);
        break;
      case 'onClickFinishItem': //点击完成任务
        this.onClickFinishItem(data);
        break;
      case 'onClickDeleteItem': //侧滑点击删除
        //创建任务
        await onClickDeleteItem(data);
        break;
      case 'onClickDeleteItem': //侧滑点击删除
        //创建任务
        await onClickDeleteItem(data);
        break;
      case 'onClickUpdateGroupModel':
        this.onClickUpdateGroupModel(data);
        break;
      case 'onTapAddColumLeftGroupListener':
        this.onTapAddColumLeftGroup(data);
        break;
      case 'onTapAddColumRightGroupListener':
        this.onTapAddColumRightGroup(data);
        break;
      case 'onTapDeleteGroupListener':
        this.onClickDeleteGroupModel(data);
        break;
      case 'onTapSelectBgColorGroupListener':
        this.onClickUpdateGroupModel(data);
        break;
      case 'onClickUpdateTitle':
        this.onClickUpdateTitle(data);
        break;
      case 'onClickCreateItem':
        onClickCreateItem(data);
        break;
      case 'onClickAddGroup':
        this.onClickAddGroup(data['title'], index: data['index']);
        break;
      case 'onClickUpdateOrderGroupModel':
        this.onClickUpdateOrderGroupModel(listGroupModels);
        break;
      case 'onReorderMissionModelList':
        this.onReorderMissionModelList(
            data['missionModelList'], data['groupModel'], data['missionModel']);
        break;
    }
  }

  setMobileGroupIndex(int index, {bool shouldUpdateUI = true}) {
    this.curMobileIndex = index;
    for (int i = 0; i < this.listGroupModels.length; i++) {
      GroupModel groupModel = this.listGroupModels[i];
      groupModel.isCheck = false;
      if (i == index) {
        groupModel.isCheck = true;
        this.curMobileIndex = index;
      }
    }
    if (shouldUpdateUI) {
      updateUI();
    }
  }

  /**
   * 分组卡片移动到右边
   */
  onMoveNextGroupListener(GroupModel groupModel) {
    List<String> groupModelObjectIdOrderList =
        this.folderModel?.groupModelObjectIdOrderList ?? [];
    int currentIndex =
        groupModelObjectIdOrderList.indexOf(groupModel.objectId ?? "");
    if (currentIndex < groupModelObjectIdOrderList.length - 1) {
      String tmp = groupModelObjectIdOrderList[currentIndex];
      groupModelObjectIdOrderList[currentIndex] =
          groupModelObjectIdOrderList[currentIndex + 1];
      groupModelObjectIdOrderList[currentIndex + 1] = tmp;
      this.folderModel?.groupModelObjectIdOrderList =
          groupModelObjectIdOrderList ?? [];
      MongoApisManager.getInstance()
          .update_FolderModelWithFM(
              folderModel: this.folderModel!, shouldQueryMissionModel: false)
          .then((value) {
        updateUI();
      });
    }
  }

  /**
   * 分组卡片移动到左边
   */
  onMovePreviousGroupListener(GroupModel groupModel) {
    List<String> groupModelObjectIdOrderList =
        this.folderModel?.groupModelObjectIdOrderList ?? [];
    int currentIndex =
        groupModelObjectIdOrderList.indexOf(groupModel.objectId ?? "");
    if (currentIndex > 0) {
      String tmp = groupModelObjectIdOrderList[currentIndex];
      groupModelObjectIdOrderList[currentIndex] =
          groupModelObjectIdOrderList[currentIndex - 1];
      groupModelObjectIdOrderList[currentIndex - 1] = tmp;
      this.folderModel?.groupModelObjectIdOrderList =
          groupModelObjectIdOrderList ?? [];
      MongoApisManager.getInstance()
          .update_FolderModelWithFM(
              folderModel: this.folderModel!, shouldQueryMissionModel: false)
          .then((value) {
        updateUI();
      });
    }
  }

  onTapMoveLeftGroupListener(
      MissionModel missionModel, GroupModel groupModel) async {
    groupModel.missionModelObjectIdOrderList?.remove(missionModel.objectId);
    groupModel.missionModelList?.remove(missionModel);
    int currentIndex = listGroupModels.indexOf(groupModel);
    // int currentIndex = groupModel.missionModelObjectIdOrderList?.indexOf(missionModel?.objectId ?? "") ?? 0;
    if (currentIndex > 0 && missionModel.objectId != null) {
      GroupModel prevGroupModel = listGroupModels[currentIndex - 1];
      prevGroupModel.missionModelObjectIdOrderList?.add(missionModel.objectId!);
      prevGroupModel.missionModelList?.add(missionModel);
      missionModel.group_id = prevGroupModel.objectId;
      await Future.wait([
        MongoApisManager.getInstance().update_MissionModel(
            missionModel: missionModel, shouldQueryMissionModel: false),
        MongoApisManager.getInstance()
            .batchUpdate_GroupModel(listParam: [prevGroupModel, groupModel])
      ]).then((value) {
        updateUI();
      });
    }
  }

  onTapMoveRightGroupListener(
      MissionModel missionModel, GroupModel groupModel) async {
    groupModel.missionModelObjectIdOrderList?.remove(missionModel.objectId);
    groupModel.missionModelList?.remove(missionModel);
    int currentIndex = listGroupModels.indexOf(groupModel);
    // int currentIndex = groupModel.missionModelObjectIdOrderList?.indexOf(missionModel?.objectId ?? "") ?? 0;
    if (currentIndex < listGroupModels.length - 1 &&
        missionModel.objectId != null) {
      GroupModel nextGroupModel = listGroupModels[currentIndex + 1];
      // nextGroupModel.missionModelObjectIdOrderList?.removeWhere((element) => element == missionModel.objectId!);
      nextGroupModel.missionModelObjectIdOrderList?.add(missionModel.objectId!);
      nextGroupModel.missionModelObjectIdOrderList = Utility.removeDuplicates(
          nextGroupModel.missionModelObjectIdOrderList ?? []);
      // nextGroupModel.missionModelList?.removeWhere((element) => element == missionModel!);
      nextGroupModel.missionModelList?.add(missionModel);
      nextGroupModel.missionModelList =
          Utility.removeDuplicates(nextGroupModel.missionModelList ?? []);
      missionModel.group_id = nextGroupModel.objectId;
      await Future.wait([
        MongoApisManager.getInstance().update_MissionModel(
            missionModel: missionModel, shouldQueryMissionModel: false),
        MongoApisManager.getInstance()
            .batchUpdate_GroupModel(listParam: [nextGroupModel, groupModel])
      ]).then((value) {
        updateUI();
      });
    }
  }

  Future<void> onDragMissionBetweenGroupsListener(
      {required MissionModel movedMission,
      required GroupModel sourceGroupModel,
      required GroupModel targetGroupModel,
      required List<MissionModel> orderedSourceMissionModels,
      required List<MissionModel> orderedTargetMissionModels}) async {
    final bool isSameGroup =
        sourceGroupModel.objectId == targetGroupModel.objectId;
    final List<MissionModel> missionsToPersist = [];
    final List<GroupModel> groupsToPersist = [];

    void syncMissionOrder(List<MissionModel> missionModels) {
      for (int i = 0; i < missionModels.length; i++) {
        missionModels[i].order_index = i;
      }
    }

    syncMissionOrder(orderedSourceMissionModels);
    if (isSameGroup) {
      targetGroupModel.missionModelList = orderedTargetMissionModels;
      targetGroupModel.missionModelObjectIdOrderList =
          orderedTargetMissionModels
              .map((element) => element.objectId ?? '')
              .where((element) => element.isNotEmpty)
              .toList();
      missionsToPersist.addAll(orderedTargetMissionModels);
      if (TextUtil.isEmpty(targetGroupModel.objectId) == false) {
        groupsToPersist.add(targetGroupModel);
      }
    } else {
      syncMissionOrder(orderedTargetMissionModels);
      movedMission.group_id = targetGroupModel.objectId;

      sourceGroupModel.missionModelList = orderedSourceMissionModels;
      targetGroupModel.missionModelList = orderedTargetMissionModels;

      if (TextUtil.isEmpty(sourceGroupModel.objectId) == false) {
        sourceGroupModel.missionModelObjectIdOrderList =
            orderedSourceMissionModels
                .map((element) => element.objectId ?? '')
                .where((element) => element.isNotEmpty)
                .toList();
        groupsToPersist.add(sourceGroupModel);
      }
      if (TextUtil.isEmpty(targetGroupModel.objectId) == false) {
        targetGroupModel.missionModelObjectIdOrderList =
            orderedTargetMissionModels
                .map((element) => element.objectId ?? '')
                .where((element) => element.isNotEmpty)
                .toList();
        groupsToPersist.add(targetGroupModel);
      }
      missionsToPersist.addAll(orderedSourceMissionModels);
      missionsToPersist.addAll(orderedTargetMissionModels);
    }

    final List<MissionModel> uniqueMissionModels = [];
    final Set<String> missionIds = {};
    for (final MissionModel missionModel in missionsToPersist) {
      final String missionId =
          missionModel.objectId ?? missionModel.title ?? "";
      if (missionIds.add(missionId)) {
        uniqueMissionModels.add(missionModel);
      }
    }

    if (groupsToPersist.isEmpty) {
      await MongoApisManager.getInstance().batchUpdate_MissionModel2(
          listParam: uniqueMissionModels, shouldRefresh: true);
    } else {
      await Future.wait([
        MongoApisManager.getInstance().batchUpdate_MissionModel2(
            listParam: uniqueMissionModels, shouldRefresh: false),
        MongoApisManager.getInstance().batchUpdate_GroupModel(
            listParam: groupsToPersist, shouldRefresh: true),
      ]);
    }
    updateUI();
  }

  // onTapMultiSelectListener(data) async {
  //   if (data == null) {
  //     if (this.multiSelectModeEnum == MultiSelectModeEnum.normal) {
  //       this.multiSelectModeEnum = MultiSelectModeEnum.multiSelect;
  //     } else {
  //       this.multiSelectModeEnum = MultiSelectModeEnum.normal;
  //     }
  //   }
  //   updateUI();
  // }

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

  // Future onClickCreateItem(FolderModel? data) async {
  //   // MissionModel missionModel = MissionModel();
  //   // missionModel.folder_id = data?.objectId;
  //   // missionModel?.end_time =
  //   //     CONSTANTS.getDeadLineTme(this.widget.folderStatusDate ?? 0);
  //   // if (Utility.isHandsetBySize() == true) {
  //   //   Utility.pushNavigator(
  //   //       context, CreateMissionPage(missionModel: missionModel));
  //   // } else {
  //   //   DialogManagement.getInstance().showPCCustomDialog(
  //   //       context: context,
  //   //       widget: CreateMissionPage(missionModel: missionModel));
  //   // }
  // }

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
              // Utility.pushNavigator(
              //     context,
              //     new MissionDetailPage(
              //       missionModel: data,
              //       folderModel: this.widget.folderModel,
              //     ));
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

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(MissionModel data) async {
    await onClickFinishMission(data);
  }

  Future<void> onClickFinishMission(MissionModel data) async {
    bool didFinish =
        await MongoApisManager.getInstance().handleFinishMissionModel(
      missionModel: data,
      context: context,
      folderModel: this.folderModel,
    );
    if (!didFinish) {
      return;
    }
    // this.requestDatas();
    updateUI();
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
  Future onClickDeleteItem(MissionModel data) async {
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
      updateUI();
      // this.requestDatas();
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    }
  }

  void onTapAddColumRightGroup(GroupModel data) {
    this.isAddingGroup = true;
    this.listGroupModelsAddingGroup.clear();
    int index =
        this.listGroupModels?.indexWhere((element) => element == data) ?? -1;
    if (index == -1) {
      return;
    }
    this.listGroupModelsAddingGroup.addAll(this.listGroupModels);
    GroupModel groupModel = GroupModel();
    groupModel?.isAdd = true;
    this.listGroupModelsAddingGroup?.insert(index + 1, groupModel);
    updateUI();
  }

  void onTapAddColumLeftGroup(GroupModel data) {
    this.isAddingGroup = true;
    this.listGroupModelsAddingGroup.clear();
    int index =
        this.listGroupModels?.indexWhere((element) => element == data) ?? -1;
    if (index == -1) {
      return;
    }
    this.listGroupModelsAddingGroup.addAll(this.listGroupModels);
    GroupModel groupModel = GroupModel();
    groupModel?.isAdd = true;
    this.listGroupModelsAddingGroup?.insert(index, groupModel);
    updateUI();
  }

  void onClickCreateItem(data) {
    if (isRequesting == true) {
      return;
    }
    MongoApisManager.getInstance().insertMissiontData(
        missionModel: data ?? MissionModel(),
        callback: (res) async {
          isRequesting = false;
          if (res != null) {
            Utility.showToastMsg(msg: getI18NKey().addsuccess);
            eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
            eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
            updateUI();
          }
          // this.requestDatas(shouldRefresh: true);
        });
    // HeaderWidgetStateGlobalKey?.currentState?.onClickCreateItem();
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

  requestDatas({bool shouldRefresh = false}) {
    //需要加上这个 否则会有冲突
    if (isModifying == true) {
      return;
    }
    isModifying = true;
    List<String> listOrderId =
        this.folderModel?.groupModelObjectIdOrderList ?? [];
    List<MissionModel> listMissionModel = MongoApisManager.getInstance()
        .queryMissioinModelsByFolderId(
            folderId: this.folderModel?.objectId ?? ''); //查询所有的mission
    if (!TextUtil.isEmpty(curSearchWords)) {
      listMissionModel =
          Utility.filterMissionModel(curSearchWords ?? "", listMissionModel);
    }
    List<GroupModel> listGroupModelsTmp = MongoApisManager.getInstance()
        .queryGroupModelsByFolderId(
            folderId: this.folderModel?.objectId ?? ''); //查询所有的group
    listGroupModels = Utility.orderGroupModel(
        listOrderId: listOrderId ?? [],
        listGroupModel: listGroupModelsTmp,
        listMissionModel: listMissionModel); //排序
    setMobileGroupIndex(this.curMobileIndex, shouldUpdateUI: false);
    isModifying = false;
    if (shouldRefresh == true) {
      updateUI();
    }
    print("");
  }

  onClickDeleteGroupModel(GroupModel groupModel) async {
    //有分组
    if (!TextUtil.isEmpty(groupModel.objectId)) {
      await MongoApisManager.getInstance()
          .delete_GroupModel(currentObjectId: groupModel.objectId);
      List<MissionModel> listMissionModels = MongoApisManager.getInstance()
          .queryMissioinModelsByGroupId(groupId: groupModel.objectId!);
      if (listMissionModels.length > 0) {
        await MongoApisManager.getInstance()
            .batchDelete_MissionModel(listParam: listMissionModels);
      }
      // await MongoApisManager.getInstance()
      //     .batchDelete_MissionModel(listParam: listMissionModels);
      updateUI();
    }
  }

  onClickUpdateGroupModel(GroupModel groupModel) async {
    //有分组
    if (!TextUtil.isEmpty(groupModel.objectId)) {
      await MongoApisManager.getInstance()
          .update_GroupModel(groupModel: groupModel);
      updateUI();
    }
  }

  onClickUpdateTitle(GroupModel groupModel) async {
    //更新title 未分组
    if (groupModel.objectId == null) {
      List<MissionModel> listMissionModels = MongoApisManager.getInstance()
          .queryMissioinModelsByWithoutGroupId(
              folderId: this.folderModel?.objectId ?? '');
      onClickAddGroup(groupModel.title,
          listMissionModels: listMissionModels, index: listGroupModels.length);
      return;
    }
    //有分组
    if (!TextUtil.isEmpty(this.folderModel?.objectId)) {
      await MongoApisManager.getInstance()
          .update_GroupModel(groupModel: groupModel);
    }
    updateUI();
  }

  onReorderMissionModelList(List<MissionModel> listMissionModels,
      GroupModel groupModel, MissionModel missionModel) async {
    //更新mission的order
    if (listMissionModels != null) {
      List<String> missionModelObjectIdOrderList = [];
      for (MissionModel missionModel in listMissionModels) {
        missionModelObjectIdOrderList.add(missionModel.objectId ?? '');
      }
      groupModel.missionModelObjectIdOrderList = missionModelObjectIdOrderList;
    }
    Future.wait([
      MongoApisManager.getInstance().update_MissionModel(
          missionModel: missionModel, shouldQueryMissionModel: false),
      MongoApisManager.getInstance().update_GroupModel(
          groupModel: groupModel, shouldQueryMissionModel: false)
    ]).then((value) {
      updateUI();
    });
  }

  onClickAddGroup(val,
      {List<MissionModel>? listMissionModels, required int index}) async {
    this.isAddingGroup = false;
    GroupModel groupModel = GroupModel();
    groupModel.title = val;
    groupModel.folder_id = this.folderModel?.objectId ?? '';
    MongoDbSaved? res = await MongoApisManager.getInstance()
        .insertGroupModelModel(groupModel: groupModel);
    if (res?.objectId != null) {
      List<String> listGroupModelObjectIdOrderList =
          this.folderModel?.groupModelObjectIdOrderList ?? [];
      if (index != -1) {
        listGroupModelObjectIdOrderList.insert(index - 1, res?.objectId ?? '');
        this.folderModel?.groupModelObjectIdOrderList =
            listGroupModelObjectIdOrderList;
      } else {
        this.folderModel?.groupModelObjectIdOrderList = res?.objectId != null
            ? [...listGroupModelObjectIdOrderList, res?.objectId ?? '']
            : [...listGroupModelObjectIdOrderList];
      }
      // listGroupModelObjectIdOrderList + [res?.objectId ?? ''];
      MongoApisManager.getInstance().update_FolderModelWithFM(
          folderModel: this.folderModel!, shouldQueryMissionModel: false);
      //针对未分组更新mission的group_id
      if (listMissionModels != null) {
        listMissionModels.forEach((element) {
          element.group_id = res?.objectId ?? '';
        });
        MongoApisManager.getInstance()
            .batchUpdate_MissionModel2(listParam: listMissionModels);
      }
    }
    updateUI();
  }

  void onClickSearch(searchWord) {
    this.curSearchWords = searchWord;
    updateUI();
    // requestDatas();
  }

  /**
   * 搜索框 标题等 导出框
   */
  List<Widget> getHeaderWidget() {
    if (isUnifiedDesktop) {
      return [_buildUnifiedHeaderWidget()];
    }
    return [
      // CustomMarquee(
      //   bean: MarqueInfo.marqueMissionpage,
      // ),
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
                    key: UniqueKey(), //每次都会重新创建
                    maxWidth: Utility.isHandsetBySize() == true ? 200 : 400,
                    isEditable: this.folderModel?.tag == 2 ||
                        this.folderModel?.tag == 1,
                    style: TextStyle(
                        fontSize: 20,
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultColor: ColorsConfig.gray_40),
                        fontWeight: FontWeight.bold),
                    text: this.folderModel?.title ?? "",
                    onEnterListener: (v) {
                      this.folderModel?.title = v;
                      if (this.folderModel != null) {
                        MongoApisManager.getInstance().update_FolderModelWithFM(
                            folderModel: this.folderModel!,
                            shouldQueryMissionModel: false);
                      }
                    }),
                SizedBox(
                  width: 4,
                ),
                ListingSecurityWidget(
                  folder_id: this.folderModel?.objectId ?? "",
                  cryptoVersion: this.folderModel?.cryptoVersion ?? -1,
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
                    updateUI();
                  },
                ),
                _canShowFolderNoteAction()
                    ? InkWell(
                        onTap: _openFolderNoteEditor,
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
                // SizedBox(
                //   width: 10,
                // ),
                // InkWell(
                //   onTap: () {
                //     TextEditingController textEditingController =
                //     TextEditingController();
                //     String s = Utility.getContentFromMissionList(
                //         datas: this.curListMissionModels ?? [],
                //         listCheckButtonModel:
                //         CONSTANTS.getExportButtonsList());
                //     textEditingController.text = s;
                //     ExportMissionListDialogUtil.show(context,
                //         textEditingController: textEditingController,
                //         onTapListener: (res) {
                //           List<CheckButtonStateModel> data = res['data'];
                //           MissionOrderEnum missionOrderEnum = res['enum'];
                //           String s = Utility.getContentFromMissionList(
                //               datas: Utility.getMissionModelListAfterOrder(
                //                   missionOrderEnum,
                //                   this.curListMissionModels ?? []),
                //               listCheckButtonModel: data);
                //           textEditingController.text = s;
                //           updateUI();
                //         }, export: (data) {
                //           Utility.showToast(
                //               context: context,
                //               msg: getI18NKey().offer_next_version);
                //         });
                //     // Utility.getContentFromMissionList(datas: this.missionListOriginal, listCheckButtonModel: CONSTANTS.getMi);
                //   },
                //   child: CustomBlackButton(
                //     text: getI18NKey().export,
                //     color: Colors.red,
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
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
    ];
  }

  bool _canShowFolderNoteAction() {
    return this.folderModel?.tag == 1 || this.folderModel?.tag == 2;
  }

  Future<void> _openFolderNoteEditor() async {
    TimelineMissionModel? timelineMissionModel;
    if (TextUtil.isEmpty(this.folderModel?.timelineNoteObjectId) == false) {
      timelineMissionModel = await MongoApisManager.getInstance()
          .queryWhereEqual_TimelineMissionModelByObjectId(
              objectId: this.folderModel?.timelineNoteObjectId ?? "");
      timelineMissionModel?.sceneType = "note";
      timelineMissionModel?.eventType = "note";
    } else {
      timelineMissionModel = TimelineMissionModel();
      timelineMissionModel.folder_id = this.folderModel?.objectId ?? null;
      timelineMissionModel.tagNames =
          this.folderModel?.tag == 2 ? this.folderModel?.title : "";
      timelineMissionModel.color = this.folderModel?.color;
      timelineMissionModel.icon = this.folderModel?.icon;
      timelineMissionModel.sceneType = "note";
      timelineMissionModel.eventType = "note";
    }
    Utility.openPagePCAndMobile(context,
        child: RichEditorPage(
            onOkListener:
                (url, timelineMissionModelObjectId, numberNoteWords) async {
              this.folderModel?.noteUrl = url;
              this.folderModel?.numberNoteWords = numberNoteWords;
              if (timelineMissionModelObjectId != null) {
                this.folderModel?.timelineNoteObjectId =
                    timelineMissionModelObjectId;
              }
              await MongoApisManager.getInstance().update_FolderModelWithFM(
                  folderModel: this.folderModel ?? FolderModel());
            },
            timelineMissionModel: timelineMissionModel,
            richTextModeEnum: RichTextModeEnum.getUrl));
  }

  Widget _buildUnifiedHeaderWidget() {
    final Color titleColor = ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF3D2A20), defaultDarkColor: Colors.white);
    final Color subtitleColor = ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF9A7763),
        defaultDarkColor: Colors.white70);
    return UnifiedDesktopCard(
      margin: EdgeInsets.fromLTRB(
          CONSTANTS.missionPageMargin, 10, CONSTANTS.missionPageMargin, 0),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomMarquee(
              bean: MarqueInfo.marqueMissionpage,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9D7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getI18NKey().mission_workspace,
                      style: TextStyle(
                        fontSize: 11,
                        color: subtitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CustomTextField(
                            key: UniqueKey(),
                            maxWidth: 360,
                            isEditable: this.folderModel?.tag == 2 ||
                                this.folderModel?.tag == 1,
                            style: TextStyle(
                                fontSize: 24,
                                color: titleColor,
                                fontWeight: FontWeight.bold),
                            text: this.folderModel?.title ?? "",
                            onEnterListener: (v) {
                              this.folderModel?.title = v;
                              if (this.folderModel != null) {
                                MongoApisManager.getInstance()
                                    .update_FolderModelWithFM(
                                        folderModel: this.folderModel!,
                                        shouldQueryMissionModel: false);
                              }
                            }),
                        const SizedBox(width: 4),
                        ListingSecurityWidget(
                          folder_id: this.folderModel?.objectId ?? "",
                          cryptoVersion: this.folderModel?.cryptoVersion ?? -1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SizedBox(
                  height: 42,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SearchBarWithIconWidget(
                            key: ValueKey("ejfiejf_unified_group"),
                            onChange: (searchWord) {
                              onClickSearch(searchWord);
                            },
                            onClickSearchListener: (bool res) {
                              this.isSearchBarVisible = res;
                              updateUI();
                            },
                          ),
                          if (_canShowFolderNoteAction())
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: UnifiedActionChip(
                                onTap: _openFolderNoteEditor,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: Utility.getSVGPicture(
                                        R.assetsImgIcWordDocument,
                                        size: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      getI18NKey().add_note,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF8C5831),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget baseBuild(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Utility.popupDesktopRightNavigator(context);
      },
      child: Selector<Env, FolderModel>(
          selector: (_, env) => env.curFolderSelected,
          builder: (_, curFolderSelected, __) {
            return Selector<Env, int>(
                selector: (_, env) => env.curFolderStatus,
                builder: (_, curFolderStatus, __) {
                  this.folderModel = curFolderSelected;
                  this.requestDatas();
                  final Widget content = Column(
                    children: [
                      ...getHeaderWidget(),
                      if (Utility.isHandsetBySize() == true)
                        Container(
                            height: 40,
                            child: GroupIconButtonListWidget(
                              list: this.listGroupModels,
                              onTapListener: (obj) {
                                draggableHorizontalListKey.currentState
                                    ?.jumpToPage(obj['index']);
                              },
                            )),
                      Expanded(
                        child: DraggableHorizontalList(
                          key: draggableHorizontalListKey,
                          onTapDoItNow: (MissionModel missionModel) {
                            this.onClick("onClickDoItNow", missionModel);
                          },
                          onTapAddGroupListener: (v, index) {
                            this.onClick('onClickAddGroup',
                                {"title": v, "index": index});
                          },
                          listGroupModels: this.isAddingGroup == true
                              ? this.listGroupModelsAddingGroup
                              : this.listGroupModels,
                          onReorderFinishListener: (listGroupModels) {
                            this.onClick('onClickUpdateOrderGroupModel',
                                listGroupModels);
                          },
                          onClickUpdateTitle: (title) {
                            this.onClick("onClickUpdateTitle", title);
                          },
                          folderModel: this.folderModel ?? FolderModel(),
                          onCreateMissionListener: (MissionModel missionModel) {
                            this.onClick("onClickCreateItem", missionModel);
                          },
                          onReorderMissionModelListListener:
                              (datas, groupModel, MissionModel missionModel) {
                            this.onClick("onReorderMissionModelList", {
                              "missionModelList": datas,
                              'groupModel': groupModel,
                              'missionModel': missionModel
                            });
                          },
                          onTapAddColumLeftGroupListener:
                              (GroupModel groupModel) {
                            this.onClick(
                                "onTapAddColumLeftGroupListener", groupModel);
                          },
                          onTapAddColumRightGroupListener:
                              (GroupModel groupModel) {
                            this.onClick(
                                "onTapAddColumRightGroupListener", groupModel);
                          },
                          onTapDeleteGroupListener: (GroupModel groupModel) {
                            this.onClick(
                                "onTapDeleteGroupListener", groupModel);
                          },
                          onTapSelectBgColorGroupListener:
                              (GroupModel groupModel) {
                            this.onClick(
                                "onTapSelectBgColorGroupListener", groupModel);
                          },
                          onUpdateGroupModelListener: (groupModel) {
                            this.onClick("onClickUpdateGroupModel", groupModel);
                          },
                          onTapEditListener: (data) {
                            this.onClick(
                                'onClickMissionSetting', data); //侧滑点击删除
                          },
                          onTapDeleteListener: (obj) {
                            this.onClick('onClickDeleteItem', obj); //侧滑点击删除
                          },
                          onTapFinishListener: (obj) {
                            this.onClick('onClickFinishItem', obj); //点击完成任务
                          },
                          onTapPlayListener: (obj) {
                            this.onClick('onClickMissionDetail',
                                obj); //跳转到任务详情页MissionPage开始任务
                          },
                          onTapMultiSelectListener: (MissionModel? list) {
                            this.onClick('onTapMultiSelectListener', list);
                          },
                          onTapUnFinishListener: (data) {
                            this.onClick(
                                'onClickUnFinishListener', data); //点击完成任务
                          },
                          onUpdateUIListener: () {
                            this.updateUI();
                          },
                          onTapMoveLeftGroupListener: (MissionModel missionMode,
                              GroupModel groupModel) {
                            this.onClick("onTapMoveLeftGroupListener", {
                              "missionModel": missionMode,
                              "groupModel": groupModel
                            });
                          },
                          onTapMoveRightGroupListener:
                              (MissionModel missionMode,
                                  GroupModel groupModel) {
                            this.onClick("onTapMoveRightGroupListener", {
                              "missionModel": missionMode,
                              "groupModel": groupModel
                            });
                          },
                          onDragMissionBetweenGroupsListener: (
                            MissionModel missionMode,
                            GroupModel sourceGroupModel,
                            GroupModel targetGroupModel,
                            List<MissionModel> orderedSourceMissionModels,
                            List<MissionModel> orderedTargetMissionModels,
                          ) {
                            this.onClick(
                              "onDragMissionBetweenGroupsListener",
                              {
                                "missionModel": missionMode,
                                "sourceGroupModel": sourceGroupModel,
                                "targetGroupModel": targetGroupModel,
                                "orderedSourceMissionModels":
                                    orderedSourceMissionModels,
                                "orderedTargetMissionModels":
                                    orderedTargetMissionModels,
                              },
                            );
                          },
                          onMoveNextGroupListener: (GroupModel groupModel) {
                            this.onClick("onMoveNextGroupListener", groupModel);
                          },
                          onMovePreviousGroupListener: (GroupModel groupModel) {
                            this.onClick(
                                "onMovePreviousGroupListener", groupModel);
                          },
                          onMobilePageChangeLinstener: (page) {
                            this.setMobileGroupIndex(page);
                          },
                        ),
                      ),
                    ],
                  );
                  if (isUnifiedDesktop) {
                    return _buildUnifiedDesktopCanvas(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                        child: content,
                      ),
                    );
                  }
                  return content;
                });
          }),
    );
  }

  // void onClickSetIndex(int index) {
  //
  // }

  void onClickUpdateOrderGroupModel(listGroupModels) async {
    List<GroupModel> listGroupModelsTmp = listGroupModels;
    List<String> listReorderObjectId = [];
    for (int i = 0; i < listGroupModels.length; i++) {
      GroupModel groupModel = listGroupModels[i];
      if (TextUtil.isEmpty(groupModel.objectId) ||
          (groupModel.objectId?.length ?? 0) < 10) {
        continue;
      }
      listReorderObjectId.add(groupModel.objectId ?? '');
      // groupModel.order = i;
    }
    // await MongoApisManager.getInstance()
    //     .updateGroupModelWithGM(groupModel: groupModel);
    // listGroupModelsTmp.removeAt(0);
    this.folderModel?.groupModelObjectIdOrderList = listReorderObjectId;
    await MongoApisManager.getInstance().update_FolderModelWithFM(
        folderModel: this.folderModel!, shouldQueryMissionModel: false);
    // updateUI();
  }
}

class DraggableHorizontalList extends StatefulWidget {
  Function onTapAddGroupListener;
  Function onReorderFinishListener;
  Function onCreateMissionListener;
  Function onReorderMissionModelListListener;
  Function onClickUpdateTitle;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  Function? onTapDoItNow;
  OnTapUnFinishListener? onTapUnFinishListener;

  final Function onTapAddColumLeftGroupListener;
  final Function onTapAddColumRightGroupListener;
  final Function onTapDeleteGroupListener;
  final Function onTapSelectBgColorGroupListener;
  final Function onUpdateGroupModelListener;
  final Function onUpdateUIListener;
  final Function onTapMoveLeftGroupListener;
  final Function onTapMoveRightGroupListener;
  final Function onDragMissionBetweenGroupsListener;
  final Function onMoveNextGroupListener;
  final Function onMovePreviousGroupListener;
  final Function onMobilePageChangeLinstener;

  List<GroupModel> listGroupModels = [];
  FolderModel folderModel;

  // final ScrollController _scrollController = ScrollController();

  DraggableHorizontalList(
      {Key? key,
      this.onTapDoItNow,
      required this.onMobilePageChangeLinstener,
      required this.onTapMoveLeftGroupListener,
      required this.onMoveNextGroupListener,
      required this.onMovePreviousGroupListener,
      required this.onTapMoveRightGroupListener,
      required this.onDragMissionBetweenGroupsListener,
      required this.onUpdateUIListener,
      required this.onTapEditListener,
      required this.onTapDeleteListener,
      required this.onTapFinishListener,
      required this.onTapPlayListener,
      required this.onTapMultiSelectListener,
      required this.onTapUnFinishListener,
      required this.onUpdateGroupModelListener,
      required this.onReorderMissionModelListListener,
      required this.folderModel,
      required this.onTapAddColumLeftGroupListener,
      required this.onTapAddColumRightGroupListener,
      required this.onTapDeleteGroupListener,
      required this.onTapSelectBgColorGroupListener,
      required this.onCreateMissionListener,
      required this.onReorderFinishListener,
      required this.onClickUpdateTitle,
      required this.listGroupModels,
      required this.onTapAddGroupListener})
      : super(key: key);

  @override
  DraggableHorizontalListState createState() => DraggableHorizontalListState();
}

class DraggableHorizontalListState extends State<DraggableHorizontalList> {
  // final List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  // GlobalKey<CustomTextFieldState> customTextFieldStateGlobalKey = GlobalKey();
  // final ScrollController _scrollController = ScrollController();
  static const double _desktopColumnWidth = 360;
  static const double _desktopColumnGap = 18;
  PageController controller = PageController(viewportFraction: 0.8);
  final ScrollController _desktopBoardScrollController = ScrollController();

  Color _resolveColumnBaseColor(GroupModel? groupModel, int index) {
    final String title = (groupModel?.title ?? "").toLowerCase();
    const List<int> fallbackPalette = [
      0xfff3c978,
      0xff9cc9f3,
      0xffb6e6bb,
      0xffd4b4f2,
      0xfff0c7d6,
    ];
    if (title.contains("未分") || title.contains("uncategor")) {
      return const Color(0xfff3c978);
    }
    if (title.contains("检") || title.contains("check")) {
      return const Color(0xff9cc9f3);
    }
    if (title.contains("计") || title.contains("plan")) {
      return const Color(0xffb6e6bb);
    }
    if (title.contains("执") || title.contains("do")) {
      return const Color(0xffd4b4f2);
    }
    if (groupModel?.color != null && groupModel!.color != 0xfff7f2f9) {
      return Color(groupModel.color!);
    }
    return Color(fallbackPalette[index % fallbackPalette.length]);
  }

  /// 这里把列背景拆成“整列浅底 + 头部更深一层”，是为了更接近参考图的层次感，
  /// 同时继续兼容分组原本允许自定义颜色的能力。
  Map<String, Color> _resolveColumnPalette({
    required int index,
    GroupModel? groupModel,
    bool isAdd = false,
  }) {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color baseColor = isAdd
        ? const Color(0xffd7e3fb)
        : _resolveColumnBaseColor(groupModel, index);
    if (isDark) {
      final Color surfaceColor = ThemeManager.getInstance()
          .getCardBackgroundColor(defaultColor: const Color(0xff2f2f2f));
      return {
        "background": Color.lerp(surfaceColor, baseColor, 0.14) ?? surfaceColor,
        "header": Color.lerp(surfaceColor, baseColor, 0.26) ?? surfaceColor,
        "surface": Color.lerp(surfaceColor, Colors.black, 0.08) ?? surfaceColor,
        "border": (Color.lerp(baseColor, Colors.white, 0.2) ?? baseColor)
            .withAlpha(66),
        "accent": Color.lerp(baseColor, Colors.white, 0.08) ?? baseColor,
      };
    }
    return {
      "background": Color.lerp(baseColor, Colors.white, 0.74) ?? baseColor,
      "header": Color.lerp(baseColor, Colors.white, 0.42) ?? baseColor,
      "surface": Colors.white.withAlpha(240),
      "border": (Color.lerp(baseColor, Colors.white, 0.18) ?? baseColor)
          .withAlpha(230),
      "accent": Color.lerp(baseColor, Colors.black, 0.06) ?? baseColor,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  jumpToPage(int index) {
    controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    if (Utility.isHandsetBySize()) {
      return PageView.builder(
          itemCount: this.widget.listGroupModels.length + 1,
          onPageChanged: (index) {
            print("onPageChanged index:$index");
            this.widget.onMobilePageChangeLinstener.call(index);
          },
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            if (index < this.widget.listGroupModels.length) {
              GroupModel item = this.widget.listGroupModels[index];
              return _buildListItem(context,
                  key: item.objectId ??
                      Utility.getRandom(from: 1000, max: 1000000).toString(),
                  index: index,
                  groupModel: item,
                  isAdd: item.isAdd ?? false, onTapAddGroupListener: (v) {
                this
                    .widget
                    .onTapAddGroupListener
                    .call(v, this.widget.listGroupModels.indexOf(item));
                print("添加分组");
              });
            } else {
              return _buildListItem(context,
                  key: "add",
                  index: index,
                  isAdd: true, onTapAddGroupListener: (v) {
                this.widget.onTapAddGroupListener.call(v, -1);
                print("添加分组");
              });
            }
          });
    } else {
      return _buildDesktopDragBoard(context);
    }
  }

  Widget _buildDesktopDragBoard(BuildContext context) {
    final List<DragAndDropList> dragLists = _buildDesktopDragLists();
    return Scrollbar(
      controller: _desktopBoardScrollController,
      thumbVisibility: true,
      trackVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: DragAndDropLists(
        children: dragLists,
        axis: Axis.horizontal,
        // listPadding 会从列表可见宽度里扣除；这里把列宽和间距分开算，
        // 保持每个看板列仍是 360，同时让列与列之间有稳定呼吸感。
        listWidth: _desktopColumnWidth + _desktopColumnGap,
        sliverList: false,
        scrollController: _desktopBoardScrollController,
        listDragOnLongPress: true,
        itemDragOnLongPress: true,
        lastItemTargetHeight: 24,
        listPadding: const EdgeInsets.only(right: _desktopColumnGap),
        listGhost: const SizedBox(
          width: _desktopColumnWidth,
          child: Card(
            elevation: 0,
            color: Colors.transparent,
          ),
        ),
        itemGhost: Container(
          constraints: const BoxConstraints(minHeight: 78),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(150),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withAlpha(120)),
          ),
        ),
        itemTargetOnWillAccept: (incoming, target) {
          final dynamic data = (target.parent is DragAndDropList)
              ? (target.parent as DragAndDropList).data
              : null;
          return !(data is Map && data['isAdd'] == true);
        },
        onListReorder: _onDesktopListReorder,
        onItemReorder: _onDesktopItemReorder,
      ),
    );
  }

  List<DragAndDropList> _buildDesktopDragLists() {
    final List<DragAndDropList> dragLists = [];
    for (int index = 0; index < widget.listGroupModels.length; index++) {
      final GroupModel groupModel = widget.listGroupModels[index];
      final bool isFirstGroup =
          (TextUtil.isEmpty(groupModel.objectId) == true &&
              groupModel.title == getI18NKey().unorder_group);
      final bool isFirstGroupWithoutOrder = widget.listGroupModels.length > 1
          ? widget.listGroupModels[1].objectId == groupModel.objectId
          : false;
      final bool isLastGroup =
          widget.listGroupModels.last.objectId == groupModel.objectId;
      final Map<String, Color> palette = _resolveColumnPalette(
          index: index, groupModel: groupModel, isAdd: false);
      dragLists.add(
        DragAndDropList(
          data: {
            'groupModel': groupModel,
            'isAdd': false,
          },
          canDrag: !isFirstGroup,
          decoration: BoxDecoration(
            color: palette["background"],
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: palette["border"]!, width: 1),
            boxShadow: ThemeManager.getInstance().isDark()
                ? []
                : [
                    BoxShadow(
                      color: palette["accent"]!.withAlpha(20),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
          ),
          header: DesktopGroupMissionColumn(
            key: ValueKey(groupModel.objectId ?? groupModel.title),
            folderModel: widget.folderModel,
            groupModel: groupModel,
            columnHeaderColor: palette["header"],
            columnSurfaceColor: palette["surface"],
            columnAccentColor: palette["accent"],
            columnBorderColor: palette["border"],
            onTapEditTitleListener: widget.onTapEditListener,
            onTapEditListener: widget.onTapEditListener,
            onTapDeleteListener: widget.onTapDeleteListener,
            onTapFinishListener: widget.onTapFinishListener,
            onTapPlayListener: widget.onTapPlayListener,
            onTapMultiSelectListener: widget.onTapMultiSelectListener,
            onTapUnFinishListener: widget.onTapUnFinishListener,
            onTapDoItNow: widget.onTapDoItNow,
            onClickCreateMission: widget.onCreateMissionListener,
            onUpdateGroupModelListener: widget.onUpdateGroupModelListener,
            onTapAddColumLeftGroupListener:
                widget.onTapAddColumLeftGroupListener,
            onTapAddColumRightGroupListener:
                widget.onTapAddColumRightGroupListener,
            onTapDeleteGroupListener: widget.onTapDeleteGroupListener,
            onTapSelectBgColorGroupListener:
                widget.onTapSelectBgColorGroupListener,
            onMoveNextGroupListener: widget.onMoveNextGroupListener,
            onMovePreviousGroupListener: widget.onMovePreviousGroupListener,
            isFirstGroupWithoutOrder: isFirstGroupWithoutOrder,
            isLastGroup: isLastGroup,
          ),
          children: _buildDesktopMissionItems(
            groupModel: groupModel,
            isFirstGroup: isFirstGroup,
            isLastGroup: isLastGroup,
            palette: palette,
          ),
          contentsWhenEmpty: Container(
            constraints: const BoxConstraints(minHeight: 96),
            alignment: Alignment.center,
            child: Text(
              getI18NKey().add_group,
              style: TextStyle(
                color: palette["accent"],
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }
    dragLists.add(
      DragAndDropList(
        data: {'isAdd': true},
        canDrag: false,
        decoration: BoxDecoration(
          color: _resolveColumnPalette(
              index: widget.listGroupModels.length,
              groupModel: null,
              isAdd: true)["background"],
          borderRadius: BorderRadius.circular(26),
        ),
        header: _buildDesktopAddGroupHeader(
          index: widget.listGroupModels.length,
          onTapAddGroupListener: (v) {
            widget.onTapAddGroupListener.call(v, -1);
          },
        ),
        children: const [],
        contentsWhenEmpty: const SizedBox.shrink(),
        lastTarget: const SizedBox.shrink(),
      ),
    );
    return dragLists;
  }

  /// 功能：构建桌面横向看板末尾的“新增分组”列头。
  /// 说明：这里不能复用 `_buildListItem(isAdd: true)`，因为那个组件是整列布局，
  /// 内部带 Spacer，需要父级提供有限高度；而 DragAndDropList 的 header 会以非 flex 子节点方式测量，
  /// 复用整列组件会触发 unbounded height 断言，导致整个横向看板空白。
  Widget _buildDesktopAddGroupHeader({
    required int index,
    Function? onTapAddGroupListener,
  }) {
    final Map<String, Color> palette = _resolveColumnPalette(
      index: index,
      groupModel: null,
      isAdd: true,
    );
    return Container(
      key: const Key("desktop_add_group_header"),
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: palette["header"],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Row(
        children: [
          CustomTextField(
            isEditing: false,
            shouldUpdateText: true,
            onEnterListener: (String text) {
              onTapAddGroupListener?.call(text);
            },
            icon: Icon(
              Icons.add,
              color: palette["accent"],
              size: 14,
            ),
            style: TextStyle(
              color: palette["accent"],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            text: getI18NKey().add_group,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  List<DragAndDropItem> _buildDesktopMissionItems(
      {required GroupModel groupModel,
      required bool isFirstGroup,
      required bool isLastGroup,
      required Map<String, Color> palette}) {
    final List<MissionModel> missions = groupModel.missionModelList ?? [];
    return missions.map((MissionModel missionModel) {
      return DragAndDropItem(
        data: missionModel,
        child: GroupMissionSilverListItem(
          key: ValueKey(missionModel.objectId ?? missionModel.title),
          multiSelectModeEnum: MultiSelectModeEnum.normal,
          isSlideEnable: false,
          onTapListener: widget.onTapPlayListener,
          isReorderable: TextUtil.isEmpty(groupModel.objectId),
          missionModel: missionModel,
          onTapDoItNow: widget.onTapDoItNow,
          onTapUnFinishListener: widget.onTapUnFinishListener,
          onTapEditTitleListener: null,
          onTapEditListener: widget.onTapEditListener,
          onTapDeleteListener: widget.onTapDeleteListener,
          onTapFinishListener: widget.onTapFinishListener,
          onTapMultiSelectListener: widget.onTapMultiSelectListener,
          onTapPlayListener: widget.onTapPlayListener,
          isReodering: false,
          columnAccentColor: palette["accent"],
          cardBorderColor: palette["border"],
          cardSurfaceColor: palette["surface"],
          groupModel: groupModel,
          onTapMoveLeftGroupListener: widget.onTapMoveLeftGroupListener,
          onTapMoveRightGroupListener: widget.onTapMoveRightGroupListener,
          isFirstGroup: isFirstGroup,
          isLastGroup: isLastGroup,
        ),
      );
    }).toList();
  }

  void _onDesktopListReorder(int oldListIndex, int newListIndex) {
    if (oldListIndex >= widget.listGroupModels.length ||
        newListIndex >= widget.listGroupModels.length) {
      return;
    }
    setState(() {
      final GroupModel movedGroup =
          widget.listGroupModels.removeAt(oldListIndex);
      widget.listGroupModels.insert(newListIndex, movedGroup);
      widget.onReorderFinishListener.call(widget.listGroupModels);
    });
  }

  void _onDesktopItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    if (oldListIndex >= widget.listGroupModels.length ||
        newListIndex >= widget.listGroupModels.length) {
      return;
    }
    setState(() {
      final GroupModel sourceGroupModel = widget.listGroupModels[oldListIndex];
      final GroupModel targetGroupModel = widget.listGroupModels[newListIndex];
      final List<MissionModel> sourceMissionModels =
          List<MissionModel>.from(sourceGroupModel.missionModelList ?? []);
      final List<MissionModel> targetMissionModels = oldListIndex ==
              newListIndex
          ? sourceMissionModels
          : List<MissionModel>.from(targetGroupModel.missionModelList ?? []);

      final MissionModel movedMission =
          sourceMissionModels.removeAt(oldItemIndex);
      final List<MissionModel> receiverMissionModels =
          oldListIndex == newListIndex
              ? sourceMissionModels
              : targetMissionModels;
      if (newItemIndex > receiverMissionModels.length) {
        newItemIndex = receiverMissionModels.length;
      }
      receiverMissionModels.insert(newItemIndex, movedMission);

      if (oldListIndex == newListIndex) {
        sourceGroupModel.missionModelList = receiverMissionModels;
      } else {
        sourceGroupModel.missionModelList = sourceMissionModels;
        targetGroupModel.missionModelList = receiverMissionModels;
      }

      widget.onDragMissionBetweenGroupsListener.call(
        movedMission,
        sourceGroupModel,
        targetGroupModel,
        List<MissionModel>.from(sourceGroupModel.missionModelList ?? []),
        List<MissionModel>.from(targetGroupModel.missionModelList ?? []),
      );
    });
  }

  List<Widget> buildList(BuildContext context) {
    List<Widget> list = [];
    list = this
        .widget
        .listGroupModels
        .asMap()
        .entries
        .map((entry) => _buildListItem(context,
                key: entry.value.objectId ??
                    Utility.getRandom(from: 1000, max: 1000000).toString(),
                index: entry.key,
                groupModel: entry.value,
                isAdd: entry.value.isAdd ?? false, onTapAddGroupListener: (v) {
              this
                  .widget
                  .onTapAddGroupListener
                  .call(v, this.widget.listGroupModels.indexOf(entry.value));
              print("添加分组");
            }))
        .toList();
    //最后个添加分组
    list.add(_buildListItem(context,
        key: "add",
        index: this.widget.listGroupModels.length,
        isAdd: true, onTapAddGroupListener: (v) {
      this.widget.onTapAddGroupListener.call(v, -1);
      print("添加分组");
    }));
    return list;
  }

  Widget _buildListItem(BuildContext context,
      {required String key,
      required int index,
      GroupModel? groupModel,
      bool isAdd = false,
      Function? onTapAddGroupListener}) {
    bool isFirstGroup = (TextUtil.isEmpty(groupModel?.objectId) == true &&
        groupModel?.title == getI18NKey().unorder_group);
    bool isFirstGroupWithoutOrder = this.widget.listGroupModels.length > 1
        ? this.widget.listGroupModels[1].objectId == groupModel?.objectId
        : false;
    bool isLastGroup =
        this.widget.listGroupModels.last.objectId == groupModel?.objectId;
    final Map<String, Color> palette = _resolveColumnPalette(
        index: index, groupModel: groupModel, isAdd: isAdd);
    final BorderRadius borderRadius = BorderRadius.circular(26);
    return Container(
      key: Key(key),
      width: Utility.isHandsetBySize() ? double.infinity : 360,
      margin: EdgeInsets.fromLTRB(index == 0 ? 8 : 0, 10, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: palette["background"],
          borderRadius: borderRadius,
          border: Border.all(color: palette["border"]!, width: 1),
          boxShadow: ThemeManager.getInstance().isDark()
              ? []
              : [
                  BoxShadow(
                    color: palette["accent"]!.withAlpha(20),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  )
                ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Center(
              child: isAdd == false
                  ? GroupMissionSilverList(
                      columnBackgroundColor: palette["background"],
                      columnHeaderColor: palette["header"],
                      columnSurfaceColor: palette["surface"],
                      columnAccentColor: palette["accent"],
                      columnBorderColor: palette["border"],
                      onTapMultiSelectListener: (MissionModel? list) {
                        this.widget.onTapMultiSelectListener?.call(list);
                      },
                      onTapDoItNow: (data) {
                        this.widget.onTapDoItNow?.call(data);
                      },
                      //未完成任务列表
                      onTapUnFinishListener: (data) {
                        this.widget.onTapUnFinishListener?.call(data);
                        // this.onClick('onClickUnFinishListener', data); //点击完成任务
                      },
                      onTapEditTitleListener: (obj) {
                        // this.widget.onTapEditTitleListener?.call(data);
                        // this.onClick('onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
                      },
                      onTapPlayListener: (obj) {
                        this.widget.onTapPlayListener?.call(obj);
                        // this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
                      },
                      onTapListener: (obj) {
                        this.widget.onTapPlayListener?.call(obj);
                        // this.onClick('onClickMissionSetting', obj); //跳转到设置叶敏
                      },
                      onTapDeleteListener: (data) async {
                        this.widget.onTapDeleteListener?.call(data);
                        // this.onClick('onClickDeleteItem', data); //侧滑点击删除
                      },
                      onTapEditListener: (data) {
                        this.widget.onTapEditListener?.call(data);
                        // this.onClick('onClickMissionSetting', data);
                      },
                      onTapFinishListener: (data) {
                        this.widget.onTapFinishListener?.call(data);
                        // this.onClick('onClickFinishItem', data); //点击完成任务
                      },
                      // onTapCreateListener: (data) {
                      //   this.onClick('onClickCreateItem', data); //点击完成任务
                      // },
                      // onTapShowFolderChartListener: (data) {
                      //   this.onClick('onClickShowFolderChart', data); //点击完成任务
                      // },

                      onSubmitListener: (missionModel) {},
                      onDesktopSubmitListener:
                          (missionModel, int numTomatoes) {},
                      onEnterListener: (String text) {
                        // onTapAddGroupListener?.call(text);
                        groupModel?.title = text;
                        this.widget.onClickUpdateTitle.call(groupModel);
                      },
                      datas: groupModel?.missionModelList ?? [],
                      groupModel: groupModel ?? GroupModel(),
                      folderModel: this.widget.folderModel,
                      onClickCreateMission: (missionModel) {
                        this.widget.onCreateMissionListener.call(missionModel);
                      },
                      onReorderMissionModelListListener:
                          (datas, groupModel, missionModel) {
                        this
                            .widget
                            .onReorderMissionModelListListener
                            ?.call(datas, groupModel, missionModel);
                      },
                      onDragMissionBetweenGroupsListener: (
                        MissionModel missionModel,
                        GroupModel sourceGroupModel,
                        GroupModel targetGroupModel,
                        List<MissionModel> orderedSourceMissionModels,
                        List<MissionModel> orderedTargetMissionModels,
                      ) {},
                      onTapAddColumLeftGroupListener:
                          this.widget.onTapAddColumLeftGroupListener,
                      onTapAddColumRightGroupListener:
                          this.widget.onTapAddColumRightGroupListener,
                      onTapSelectBgColorGroupListener:
                          this.widget.onTapSelectBgColorGroupListener,
                      onTapDeleteGroupListener:
                          this.widget.onTapDeleteGroupListener,
                      onUpdateGroupModelListener: (groupModel) {
                        this.widget.onUpdateGroupModelListener.call(groupModel);
                      },
                      onUpdateUIListener: () {
                        this.widget.onUpdateUIListener.call();
                      },
                      onTapMoveLeftGroupListener:
                          (MissionModel missionModel, GroupModel groupModel) {
                        this
                            .widget
                            .onTapMoveLeftGroupListener
                            ?.call(missionModel, groupModel);
                      },
                      onTapMoveRightGroupListener:
                          (MissionModel missionModel, GroupModel groupModel) {
                        this
                            .widget
                            .onTapMoveRightGroupListener
                            ?.call(missionModel, groupModel);
                      },
                      isFirstGroup: isFirstGroup,
                      isLastGroup: isLastGroup,
                      isFirstGroupWithoutOrder: isFirstGroupWithoutOrder,
                      onMoveNextGroupListener: (GroupModel groupModel) {
                        this.widget.onMoveNextGroupListener.call(groupModel);
                      },
                      onMovePreviousGroupListener: (groupModel) {
                        this
                            .widget
                            .onMovePreviousGroupListener
                            .call(groupModel);
                      },
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      key: Key("add12312" +
                          Utility.getRandom(from: 0, max: 10000).toString()),
                      children: [
                        Container(
                          height: 58,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: palette["header"],
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(26),
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomTextField(
                                // key: customTextFieldStateGlobalKey,
                                isEditing: groupModel?.isAdd ?? false,
                                shouldUpdateText: true,
                                onEnterListener: (String text) {
                                  onTapAddGroupListener?.call(text);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: palette["accent"],
                                  size: 14,
                                ),
                                style: TextStyle(
                                    color: palette["accent"],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                text: getI18NKey().add_group,
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Spacer()
                      ],
                    )),
        ),
      ),
    );
  }
}
