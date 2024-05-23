import 'dart:core';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/WrongQuestionBookPage.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../beans/ResourceDeliveryInfoBean.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomCircleWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../components/SearchBarWidget.dart';
import '../../models/WQBFolderModel.dart';
import '../../models/WQBMissionModel.dart';
import '../../models/WQBSessionMissionModel.dart';
import '../../util/DialogManagement.dart';
import 'components/WQBFourDateWidget.dart';
import 'components/WQBMissionSilverList.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';


class WQBMissionPage extends BaseWidget {
  // WQBFolderModel? folderModel; //FoldersPage页面传入的数据
  int? folderStatus = 1; // 根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 6 已完成
  Function? onTapNavMenuListener;

  WQBMissionPage({Key? key, this.folderStatus, this.onTapNavMenuListener}) {
    // this.folderModel = folderModel ?? WQBFolderModel();
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _MisssionPageWidgetState(folderStatus: this.folderStatus);
  }
}

class _MisssionPageWidgetState<T> extends BaseWidgetState<WQBMissionPage> {
  WQBFolderModel? folderModel;
  List<WQBMissionModel> _missionModelListUnFinished = []; //未完成任务
  List<WQBMissionModel> _missionModelListFinished = []; //已经完成任务
  // FolderTimeModel? _folderTimeModel = new FolderTimeModel(); //头部4个参数时间
  bool _isBottomBarVisible = false; //底部visible
  int _numberTomatoes = 1; //番茄
  int _dateStatus = 3; //dateStatus 0-今天 1 明天 2 即将到来 3 待定 4 日程 5 已完成
  int state = -1;
  int _priorityStatus = 3; //优先级
  String? _tagName = ''; //创建WQBMissionPage tagName
  String? _title = ''; //创建missin时
  int numTomatoes = 1;
  String? _tagId = ''; //
  int? _tagColor; // SelectTagDialogUtil 过来，选择完标签返回
  String? _circleTitle = ''; //目标标题 从folderModel过来 或者从SelectCircleDialogUtil
  int? _circleColor = 0; //目标颜色
  String? _folderModelObjId; //目标objectId 即folderId
  Icon? _circleIcon; //目标Icon
  MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByWords;
  WQBMissionModel _missionModel = WQBMissionModel();
  // CalendarModel? calendarModel;
  bool isRequesting = false;
  double margin = 5;
  List<WQBMissionModel>? curListMissionModels = [];
  List<WQBMissionModel>? curAllListMissionModels = [];

  // GlobalKey<HeaderWidgetState>? HeaderWidgetStateGlobalKey = GlobalKey();
  GlobalKey<SearchBarWidgetState>? searchBarWidgetKey = GlobalKey();

  // GlobalKey<BottomBarState>? bottomBarStateKey = GlobalKey();
  bool isFocusing = false;
  bool isSearchBarVisible = false;
  String? curSearchWords = null;
  ScrollController _scrollController = ScrollController();
  WQBModeEnum wqbModeEnum  = WQBModeEnum.all;
  GlobalKey<WrongQuestionBookPageState> WrongQuestionBookPageStateGlobalKey =
      GlobalKey();
  List<ResourceDeliveryInfoBean> listTopResourceData = CONSTANTS.getWQBMENUSilverListRessourceData();
  double padding = 5;

  _MisssionPageWidgetState({folderStatus}) {
    initData(folderStatus);
  }

  getTopList() {
    listTopResourceData.forEach((element) {
      if(element.extendParamsMap?['code'] == 'all') {
        element.extendParamsMap?['value'] = Utility.getAllWQBSizeByState(curAllListMissionModels ?? []);
        // element.isSelected = true;
      } else if(element.extendParamsMap?['code'] == 'new') {
        element.extendParamsMap?['value'] = Utility.getAllWQBSizeByState(curAllListMissionModels ?? [], state: 0);
      } else if(element.extendParamsMap?['code'] == 'memorizing') {
        element.extendParamsMap?['value'] = Utility.getAllWQBSizeByState(curAllListMissionModels ?? [], state: 1);
      } else if(element.extendParamsMap?['code'] == 'memorized') {
        element.extendParamsMap?['value'] = Utility.getAllWQBSizeByState(curAllListMissionModels ?? [], state: 2);
      }
    });
  }

  void initData(folderStatus) {
    if (this.folderModel?.tag == 2) {
      //tag 2 是标签 进来的
      this._missionModel?.tagIds = [this.folderModel?.objectId].join(',');
      // todo 这里要判断下
      // this._missionModel?.tagNames = [folderModel.title].join(',');
    } else {
      //1 就是circle 进来的
      if (!TextUtil.isEmpty(this.folderModel?.tag)) {
        //不是今天 明天 即将到来 待定
        this._circleColor = this.folderModel?.color ?? 0;
        this._circleTitle = this.folderModel?.title;
        this._circleIcon = Icon(
            IconData(this.folderModel?.icon ?? Icons.circle.codePoint,
                fontFamily: 'MaterialIcons'),
            size: 20,
            color: Color(this._circleColor ?? 0xffff8800));
      }
      this._folderModelObjId = this.folderModel?.objectId; //用于创建mission时保存id
    }
    if (folderStatus != null) {
      //如果来自今天 明天 即将到来等
      this._dateStatus = folderStatus - 1;
    } else {
      //否则来自文件夹等
      this._dateStatus = 0;
    }
  }

  @override
  void onCreate() {
    super.onCreate();
    curPage = "WQBMissionPage";
  }

  @override
  void initState() {
    super.initState();
    // this.isNavBackBtnVisible = false;
    this.isAppBarVisible = false;
    this.setKeyboardVisibityListener();
  }

  componentDidMount() {
    this.requestDatas();
    missionOrderEnum =
        SharePreferenceUtil.getSyncInstance().getMissionOrderEnum();
  }

  //写这里和写initState()里面都差不多，只要在build(BuildContext context)里面的组件使用前赋值就行
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    unfocus();
  }

  void unfocus() {
    // HeaderWidgetStateGlobalKey?.currentState?.unfocus();
    searchBarWidgetKey?.currentState?.unfocus();
    updateUI();
  }

  setKeyboardVisibityListener() {
    this.keyboardSubscription =
        Utility.handleKeyBoardVisibility(onChange: (bool visible) {
      if (visible) {
        _scrollController.animateTo(140,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      }
      setState(() {
        _isBottomBarVisible = visible;
      });
    });
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickMissionToMissionDetail': //跳转到设置叶敏
        onClickMissionToMissionDetail(data);
        break;
      case 'onClickMissionDetail': //跳转到任务详情页WQBMissionPage开始任务
        //点击item
        // onClickMissionStart(context, data, this.widget.folderModel);
        break;
      case 'onClickDeleteItem': //侧滑点击删除
        //创建任务
        await onClickDeleteItem(data);
        break;
      case 'onClickFinishItem': //点击完成任务
        this.onClickFinishItem(data);
        break;
      case 'onTapEditTitleListener':
        this.onClickEditTitle(data);
        break;
    }
  }


  Future onClickEditTitle(WQBMissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    DialogManagement.getInstance().showEditTitleDialog(
        Utility.getGlobalContext(),
        title: getI18NKey().edit_title(data.title ?? ""),
        initVal: data.title, okCallBack: (String value) async {
      if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
        Utility.showToastMsg(
            context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
        return;
      }
      data.title = value;
      await MongoApisManager.getInstance()
          .update_WQBMissionModel(missionModel: data);
      requestDatas();
      Utility.showToastMsg(context: context, msg: getI18NKey().update_success);
      DialogManagement.getInstance().hideDialog(context);
    }, cancelCallBack: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(WQBMissionModel data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
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

  Future<void> onClickFinishMission(WQBMissionModel data) async {
    await MongoApisManager.getInstance()
        .finishWQBMissionModel(missionModel: data);
    this.requestDatas();
  }

  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(data) async {
    if (Utility.isFolderModelEnabled(folderId: data.folder_id) == false) {
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
          .delete_WQBMissionModel(currentObjectId: data.objectId);
      this.requestDatas();
      WQBMissionModel missionModel = WQBMissionModel();
      missionModel.type = -1;
      this.onClickMissionToMissionDetail(missionModel);
      // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    }
  }

  /**
   * 跳转到设置叶敏
   */
  void onClickMissionToMissionDetail(data) {
    Utility.pushWQBDesktopMissionDetailNavigator(
        context,
        'WrongQuestionBookPage',
        {'data': data, 'folderdata': this.folderModel});
  }


  @override
  void didUpdateWidget(WQBMissionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    this._folderModelObjId = this.folderModel?.objectId;
    //todo 这里可以优化 否则会请求几遍 但是通过 this._folderModelObjId == this.widget.folderModel?.objectId有点问题
    this.requestDatas(shouldUpdate: false);
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return Selector<GlobalStateEnv, WQBModeEnum>(
        selector: (_, env) => env.wqbModeEnum,
        builder: (_, wqbModeEnum, __) {
          //当前显示的模式 主要移动端用来做入口判断
          this.wqbModeEnum = wqbModeEnum;
          return Selector<Env, Map?>(
            selector: (_, env) => env.wqbRouterMainContainerData,
            builder: (_, wqbRouterMainContainerData, __) {
              return Selector<GlobalStateEnv, List<WQBMissionModel>?>(
                selector: (_, env) => env.listWQBMissionModel,
                builder: (_, listWQBMissionModel, __) {
                  // 当前 是哪个文件夹下
                  this.folderModel =
                      wqbRouterMainContainerData?['data'] ?? WQBFolderModel();
                  requestDatas(shouldUpdate: false);
                  // wqbRouterMainContainerData['data']
                  return Stack(key: ValueKey('Stack2'), children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: this.padding, vertical: 0),
                      key: ValueKey('Container1'),
                      color: ThemeManager.getInstance().getBackgroundColor(context: context),
                      child: Stack(key: ValueKey('Stack1'), children: [
                        Container(
                          key: ValueKey('Container2'),
                          color: ThemeManager.getInstance().getBackgroundColor(context: context, defaultColor: ColorsConfig.standardPageBackground),
                          child: CustomScrollView(
                            controller: _scrollController,
                            key: ValueKey('CustomScrollView1'),
                            slivers: getSilverListWidget(),
                          ),
                        ),
                      ]),
                    ),
                    this._isBottomBarVisible
                        ? SizedBox.shrink()
                        : Positioned(
                            bottom: 30,
                            right: 20,
                            child: CustomCircleWidget(
                              onTapListener: (obj) async {
                                await onTapCreate(obj, context);
                              }, list: CONSTANTS.getWQBCreateMissionButtonList(),
                            )),
                  ]);
                },
              );
            },
          );
        });
  }

  Future<void> onTapCreate(obj, BuildContext context) async {
      WQBMissionModel missionModel = WQBMissionModel();
    missionModel.folder_id = this.folderModel?.objectId;
    // missionModel.type = 1;
    // 创建错题本
    if(obj.code == "wrong_question_book") {
      missionModel.type = 0;
      missionModel.folder_id = this.folderModel?.objectId;
      Utility.openPagePCAndMobile(context,
          child: WrongQuestionBookPage(
            key:
            WrongQuestionBookPageStateGlobalKey,
            folderModel: this.folderModel,
            wqbMissionModel: missionModel,
            saveModeEnum: SaveModeEnum.save, sceneEnum: WQBSceneEnum.question_wrong_book,
          ));
    } else if(obj.code == "memorandum") { //创建备忘录
      missionModel.type = 3;
      Utility.openPagePCAndMobile(context,
          child: WrongQuestionBookPage(
            key:
            WrongQuestionBookPageStateGlobalKey,
            folderModel: this.folderModel,
            wqbMissionModel: missionModel,
            saveModeEnum: SaveModeEnum.save, sceneEnum: WQBSceneEnum.memorandum,
          ));
    } else if(obj.code == "note2") { //创建笔记
      missionModel.type = 1;
      missionModel.color = CONSTANTS.getColors()[0].color;
      MongoDbSaved? mongoDbSaved = await MongoApisManager.getInstance().insertWQBMissiontData(missionModel: missionModel);
      if(mongoDbSaved != null) {
        missionModel.objectId = mongoDbSaved.objectId;
      }
      onClickMissionToMissionDetail(missionModel);
    } else if(obj.code == "card") { //创建卡片
      missionModel.type = 2;
      Utility.openPagePCAndMobile(context,
          child: WrongQuestionBookPage(
            key:
            WrongQuestionBookPageStateGlobalKey,
            folderModel: this.folderModel,
            wqbMissionModel: missionModel,
            saveModeEnum: SaveModeEnum.save, sceneEnum: WQBSceneEnum.card,
          ));
    }
  }

  List<Widget> getSilverListWidget() {
    List<Widget> listWidget = [];
    listWidget.addAll(this.buildListWidget(Utility.getWQBListAfterOrder(
            missionOrderEnum, _missionModelListUnFinished) ??
        []));

    return [
      WQBFourDateWidget(
          onTapListener: (state) {
            this.state = state['index'] - 1;
            this.requestDatas();
          },
        list: listTopResourceData,
      ),
      SliverToBoxAdapter(
        child: CustomMarquee(
          bean: MarqueInfo.marqueMissionpage,
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                this.folderModel?.title ?? "",
                style: TextStyle(
                    fontSize: 20,
                    color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.gray_40),
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
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
      ),
      ...listWidget,
      //已完成任务列表
      ...this.buildListWidget((SharePreferenceUtil.getSyncInstance()
                      .getWQBCompleteMissionVisible() ==
                  false &&
              this.widget.folderStatus != 6)
          ? []
          : (Utility.getWQBListAfterOrder(
                  missionOrderEnum, _missionModelListFinished) ??
              [])),
    ];
  }

  void onClickSearch(searchWord) {
    this.curSearchWords = searchWord;
    requestDatas();
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
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Icon(
            Icons.swap_vert,
            size: 30,
            color: ThemeManager.getInstance().getIconColor(defaultColor: Colors.red),
          ),
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

  List<Widget> buildListWidget(List<WQBSessionMissionModel> list) {
    List<Widget> listWidget = [];
    list.forEach((WQBSessionMissionModel model) {
      if ((model.datas?.length ?? 0) > 0) {
        listWidget.add(initSliverPersistentHeader(model.title ?? ""));
        listWidget.add(WQBMissionSilverList(
          //未完成任务列表
          datas: model.datas ?? [],
          // onTapUnFinishListener: (data) {
          //   this.onClick('onClickUnFinishListener', data); //点击完成任务
          // },
          onTapEditTitleListener: (obj) {
            this.onClick(
                'onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapPlayListener: (obj) {
            this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
          },
          onTapListener: (obj) {
            this.onClick('onClickMissionToMissionDetail', obj); //跳转到设置叶敏
          },
          onTapDeleteListener: (data) async {
            this.onClick('onClickDeleteItem', data); //侧滑点击删除
          },
          onTapEditListener: (data) {
            this.onClick('onClickMissionToMissionDetail', data);
          },
          onTapFinishListener: (data) {
            this.onClick('onClickFinishItem', data); //点击完成任务
          }, wqbMissionModel: this._missionModel,
        ));
      }
    });
    // if(this.widget.folderStatus == 1) {
    //   CounterMethodChannelManager.getInstance().storeMissionList(list);
    // }
    return listWidget;
  }

//  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  requestDatas({bool shouldUpdate = true}) {
    //不能去掉 否则重新安装重新登录讲没有最新数据
        int type = -1;
        // 0 错题本 1 便签 2 记忆卡片 3
        if (this.wqbModeEnum == WQBModeEnum.note) {
          type = 1;
        } else if (this.wqbModeEnum == WQBModeEnum.wrong_question_book) {
          type = 0;
        } else if (this.wqbModeEnum == WQBModeEnum.card) {
          type = 2;
        } else if (this.wqbModeEnum == WQBModeEnum.memorandum) { //备忘录
          type = 3;
        }
    List<WQBMissionModel>? datas = [];
    curAllListMissionModels = [];
        this.curAllListMissionModels = MongoApisManager.getInstance()
        .queryWhereEqual_wqbmissionDataByFolderModelObjectId(folder_objectId: this.folderModel?.objectId, type: type);
    getTopList();
    if(this.folderModel?.tag == 1) { // circle过来的
      // if (this.folderModel?.iconType == 9) {
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_wqbmissionDataByFolderModelObjectId(folder_objectId: this.folderModel?.objectId,
            type: type, state: this.state);
      // }
    } else if(this.folderModel?.tag == 2) { //tag
      datas = MongoApisManager.getInstance()?.queryWhereEqual_wqbmissionDataByFolderModelTag(tag:  this.folderModel?.title ?? "") ?? [];
    } else { //查看全部
      datas = MongoApisManager.getInstance()
          .queryWhereEqual_wqbmissionDataByFolderModelObjectId(
          type: type, state: this.state);
      // datas = curAllListMissionModels ?? [];
    }
      // }
    //如果curSearchWords有值 就支持搜索功能
    if (!TextUtil.isEmpty(curSearchWords)) {
      datas = Utility.filterWQBMissionModel(curSearchWords ?? "", datas);
    }

    Utility.parseWQBMissionModelsToSessionMissionMidelListByFolderName(
        datas, CONSTANTS.wqbFolderModelList);
    if (mounted) {
      // _folderTimeModel = Utility.getFolderTimeModel(datas); //头部4个参数时间
      _missionModelListFinished =
          Utility.getWQBMissionModelFinished(datas); //完成的任务
      _missionModelListUnFinished =
          Utility.getWQBMissionModelUnfinishedDelay(datas); //未完成任务
      if (shouldUpdate == true) {
        if (mounted == true) {
          setState(() {});
        }
      }
    }
    this.curListMissionModels = datas;
  }

  /**
   * 完成任务的SectionHeader
   */
  initSliverPersistentHeader(String title) {
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
              color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Color(0xffe5e5e5)),
              alignment: Alignment(-1, 1),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 13,
                    color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffa3a3a3)),
                    shadows: ThemeManager.getInstance().isDark() ? null : [
                      Shadow(color: Colors.white, offset: Offset(1, 1))
                    ]),
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
                          color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
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
                                    color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff606060)),
                                    shadows: ThemeManager.getInstance().isDark() ? null : [
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
                                  color: Color(0xff606060), size: 20)
                              : Icon(Icons.arrow_drop_up,
                                  color: Color(0xff606060), size: 20)
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
