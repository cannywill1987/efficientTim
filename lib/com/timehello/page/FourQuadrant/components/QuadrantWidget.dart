import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';
import '../../../config/ENUMS.dart';
import '../../../config/Params.dart';
import '../../../models/EventFn.dart';
import '../../../models/MissionModel.dart';
import '../../../util/CounterManagement.dart';
import '../../../util/DialogManagement.dart';
import '../../../util/MobileVoiceTaskManager.dart';
import '../../../util/LoginManager.dart';
import '../../../util/OverlayManagement.dart';
import '../../../util/TextUtil.dart';
import '../../CreateMissionPage/CreateMissionPage.dart';
import '../../missionPage/componnents/MobileVoiceTaskSheet.dart';
import '../../SettingItemDetailPage/SettingItemDetailPage.dart';
import '../../missionPage/MissionPage.dart';
import 'QuadrantMissionSilverList.dart';

typedef OnRefreshListener = void Function(dynamic obj);

/**
 * 四象限组件
 */
class QuadrantWidget extends StatefulWidget {
  String title; // 标题
  String desc; // 描述
  List<MissionModel> listMissionModelsUnfinished; // 未完成任务列表
  List<MissionModel> listMissionModelsFinished; // 已完成任务列表
  PriorityEnum priorityEnum; // 优先级
  Function onRefresh; // 刷新
  OnRefreshListener? onRefreshListener; // 刷新监听
  GlobalKey quadrantWidgetGlobalKey; // 四象限组件全局key
  bool isHeaderVisible; // 是否显示头部
  Function onDragingListener; // 拖拽监听
  Function onDragEndListener; // 拖拽结束监听

  QuadrantWidget(
      {Key? key,
      required this.priorityEnum,
      required this.onDragingListener,
      required this.title,
      required this.quadrantWidgetGlobalKey,
      required this.onDragEndListener,
      required this.desc,
      this.isHeaderVisible: true,
      this.onRefreshListener,
      required this.onRefresh,
      required this.listMissionModelsUnfinished,
      required this.listMissionModelsFinished})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QuadrantWidgetState();
  }
}

class QuadrantWidgetState extends State<QuadrantWidget> {
  bool isShowed = false; //当前滑动到那个容器

  /// 功能：获取当前象限的主色。
  /// 说明：四象限页面只用主色做信息提示，不再大面积铺满高饱和背景，避免任务列表阅读负担过重。
  Color get _priorityAccentColor =>
      Utility.getTextColorByPriority(this.widget.priorityEnum);

  /// 功能：获取象限卡片的浅背景色。
  /// 说明：亮色模式下把四色降低到极轻的底色，暗色模式继续沿用全局卡片背景，避免破坏暗黑模式。
  Color _getQuadrantSurfaceColor() {
    if (ThemeManager.getInstance().isDark()) {
      return ThemeManager.getInstance().getCardBackgroundColor();
    }
    return Color.lerp(Colors.white, _priorityAccentColor, 0.045) ??
        Colors.white;
  }

  /// 功能：获取象限顶部标题区域背景色。
  /// 说明：标题区域保留轻微色彩识别，但比旧版渐变更克制，接近参考图里的白底卡片风格。
  Color _getQuadrantTitleBackgroundColor() {
    if (ThemeManager.getInstance().isDark()) {
      return ThemeManager.getInstance().getCardBackgroundColor();
    }
    return Color.lerp(Colors.white, _priorityAccentColor, 0.08) ?? Colors.white;
  }

  /// 功能：获取“待完成/已完成”分组条背景色。
  /// 说明：分组条只做轻色块提示，避免旧版红黄绿蓝横条过重。
  Color _getSectionHeaderBackgroundColor() {
    if (ThemeManager.getInstance().isDark()) {
      return ThemeManager.getInstance().getCardBackgroundColor();
    }
    return Color.lerp(Colors.white, _priorityAccentColor, 0.12) ?? Colors.white;
  }

  /// 功能：获取象限边框颜色。
  /// 说明：拖拽悬停时稍微加深，普通状态保持轻描边。
  Color _getQuadrantBorderColor() {
    return _priorityAccentColor.withAlpha(isShowed ? 120 : 54);
  }

  /// 功能：象限内部加号长按时打开语音创建任务面板。
  /// 说明：与页面浮动加号不同，象限内部入口会把当前象限优先级作为默认参数传给普通创建和 AI 创建。
  Future<void> _showMobileVoiceTaskSheet() async {
    if (!Utility.isHandsetBySize()) {
      return;
    }
    await MobileVoiceTaskSheet.show(
      context: context,
      onSubmit: _handleMobileVoiceTaskPayload,
    );
  }

  /// 功能：按普通/AI 模式创建当前象限任务。
  Future<String?> _handleMobileVoiceTaskPayload(
    MobileVoiceTaskPayload payload,
  ) async {
    final text = payload.text.trim();
    if (TextUtil.isEmpty(text)) {
      throw StateError(getI18NKey().mobile_voice_task_empty);
    }
    final priorityStatus =
        CONSTANTS.getPriorityByPriorityEnum(this.widget.priorityEnum);
    if (payload.mode == MobileVoiceTaskMode.ai) {
      final result = await MobileVoiceTaskManager.createAiMissionsFromPrompt(
        prompt: text,
        defaultPriorityStatus: priorityStatus,
        defaultDateStatus: 1,
      );
      if (result['ok'] != true) {
        throw StateError(result['message']?.toString() ?? '');
      }
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      this.widget.onRefresh();
      return _toolResultMessage(result, fallback: getI18NKey().addsuccess);
    }

    await _createPlainVoiceMission(
      title: text,
      priorityStatus: priorityStatus,
    );
    return getI18NKey().addsuccess;
  }

  /// 功能：普通语音直接创建当前象限任务。
  Future<void> _createPlainVoiceMission({
    required String title,
    required int priorityStatus,
  }) async {
    final missionModel = MissionModel();
    missionModel.title = title;
    missionModel.end_time = CONSTANTS.getDeadLineTme(1);
    missionModel.dateStatus = 1;
    missionModel.priorityStatus = priorityStatus;
    missionModel.total_tomotoes = 1;
    missionModel.tomato_duration =
        await SharePreferenceUtil.getSyncInstance().getTomatoTime();
    final saved = await MongoApisManager.getInstance().insertMissiontData(
      missionModel: missionModel,
    );
    if (saved == null) {
      throw StateError(getI18NKey().alertMessage2);
    }
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    this.widget.onRefresh();
  }

  /// 功能：从 AI 工具结果中取创建成功文案。
  String _toolResultMessage(
    Map<String, Object?> result, {
    required String fallback,
  }) {
    final contextItems = result['contextItems'];
    if (contextItems is List && contextItems.isNotEmpty) {
      final first = contextItems.first;
      if (first is Map && !TextUtil.isEmpty(first['content'])) {
        return first['content'].toString();
      }
    }
    return result['message']?.toString() ?? fallback;
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickMissionSetting': //跳转到设置叶敏
        onClickMissionSetting(data);
        break;
      case 'onClickMissionDetail': //跳转到任务详情页MissionPage开始任务
        //点击item
        onClickMissionStart(data);
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
      case 'onDragEndListener':
        this.onDragEndListener(data);

        break;
    }
  }

  void showBorder() {
    this.isShowed = true;
    setState(() {});
  }

  hideBorder() {
    this.isShowed = false;
    setState(() {});
  }

  void onDragEndListener(MissionModel? missionMdeo) {
    this.widget.onDragEndListener.call();
    if (missionMdeo != null) {
      requestMongoDbUpdateData(missionModel: missionMdeo);
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
    );
    if (!didFinish) {
      return;
    }
    this.widget.onRefresh();
    CounterManagement counterManagement = CounterManagement.getInstance();
    //不是同一个就重置重新开始计数
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    //关闭的是同一个任务那就停止计时器
    if (counterManagement.missionModel?.objectId == data.objectId) {
      // counterManagement.reset();
      CounterManagement.getInstance().reset();
    }
  }

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
      data.title = value;
      if (ChatGroupManager.isFolderModelEnabled(
              folderId: data.folder_id,
              uid: LoginManager.getInstance().userBean.uid ?? "") ==
          false) {
        Utility.showToastMsg(
            context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
        return;
      }
      await MongoApisManager.getInstance()
          .update_MissionModel(missionModel: data);
      data.title = value;
      await MongoApisManager.getInstance()
          .update_MissionModel(missionModel: data);
      this.widget.onRefresh();
      Utility.showToastMsg(context: context, msg: getI18NKey().update_success);
      DialogManagement.getInstance().hideDialog(context);
    }, cancelCallBack: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  void requestMongoDbUpdateData({MissionModel? missionModel}) async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: missionModel?.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    await MongoApisManager.getInstance()
        .update_MissionModel(missionModel: missionModel ?? MissionModel());
    //todo 敢做这个没用了 因为用env了
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    // if(this.widget.onRefresh != null) {
    //   this.widget.onRefresh();
    // }
  }

  /**
   * 跳转到任务详情页MissionPage开始任务
   */
  void onClickMissionStart(MissionModel data) async {
    if (ChatGroupManager.isFolderModelEnabled(folderId: data.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    FolderModel? folderModel = await MongoApisManager.getInstance()
        .queryfolderModelWithFolderId(data.folder_id);
    // 有任务进行中给出提示
    if (CounterManagement.getInstance().counterStatus ==
            CounterStatus.focusing &&
        !TextUtil.isEmpty(
            CounterManagement.getInstance().missionModel?.title) &&
        data.title != CounterManagement.getInstance().missionModel?.title) {
      if (SharePreferenceUtil.getSyncInstance().getSwitchMissionTitle()) {
        Utility.showAlertDialog(
            context: context,
            content: getI18NKey().missionRunningAlert(data.title ?? ""),
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
      this.widget.onRefresh();
      // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    }
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
            key: ValueKey("ejzifjfze"),
            missionModel: data,
          ));
    } else {
      Utility.openRightSideDesktopNavigator(
          context, 'SettingItemDetailPage', {'missionModel': data});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          !this.widget.isHeaderVisible
              ? SizedBox.shrink()
              : Container(
                  height: Utility.isHandsetBySize() ? 45 : 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _getQuadrantTitleBackgroundColor(),
                    border: Border.all(
                      color: _getQuadrantBorderColor(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            this.widget.title,
                            style: TextStyle(
                                color: Utility.getTextColorByPriority(
                                    this.widget.priorityEnum),
                                fontSize: Utility.isHandsetBySize() ? 14 : 18),
                          ),
                          Text(
                            this.widget.desc,
                            style: TextStyle(
                                color: ThemeManager.getInstance().isDark()
                                    ? Color(0xffa0a0a0)
                                    : Utility.getSubTextColorByPriority(
                                        this.widget.priorityEnum),
                                fontSize: Utility.isHandsetBySize() ? 12 : 14),
                          )
                        ]),
                  ),
                ),
          !this.widget.isHeaderVisible
              ? SizedBox.shrink()
              : SizedBox(
                  height: Utility.isHandsetBySize() ? 5 : 8.0,
                ),
          Expanded(
              child: Container(
                  clipBehavior: Clip.antiAlias,
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _getQuadrantBorderColor(),
                      width: isShowed ? 1.2 : 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: _getQuadrantSurfaceColor(),
                  ),
                  child: CustomScrollView(
                    slivers: buildList(
                        containerWidth: constraints.maxWidth,
                        containerHeight: constraints.maxHeight,
                        onCreateListener: () {
                          // PriorityEnum priorityEnum = this.widget.priorityEnum;
                          MissionModel missionModel = MissionModel();
                          missionModel.end_time =
                              CONSTANTS.getDeadLineTme((0) + 1);
                          missionModel.priorityStatus =
                              CONSTANTS.getPriorityByPriorityEnum(
                                  this.widget.priorityEnum);
                          if (Utility.isHandsetBySize() == true) {
                            Utility.pushNavigator(context,
                                CreateMissionPage(missionModel: missionModel));
                          } else {
                            DialogManagement.getInstance().showPCCustomDialog(
                                context: context,
                                widget: CreateMissionPage(
                                    missionModel: missionModel));
                          }
                        }),
                  )))
        ],
      );
    });
  }

  /**
   * 完成任务的SectionHeader
   *
   */
  initSliverPersistentHeader(String title,
      {String? subtitle, Function? onTapCreateListener}) {
    return SliverPersistentHeader(
        //是否固定头布局 默认false
        pinned: false,
        //是否浮动 默认false
        floating: false,
        delegate: MySliverDelegate(
          //缩小后的布局高度
          minHeight: Utility.isHandsetBySize() ? 25 : 35.0,
          //展开后的高度
          maxHeight: Utility.isHandsetBySize() ? 25 : 35.0,
          child: Container(
              decoration: BoxDecoration(
                color: _getSectionHeaderBackgroundColor(),
              ),
              padding: EdgeInsets.fromLTRB(
                  Utility.isHandsetBySize() ? 10 : 25.0,
                  0,
                  0,
                  Utility.isHandsetBySize() ? 0 : 0),
              // color: ColorsConfig.backgroundColor,
              alignment: Alignment(0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 13,
                        color: ThemeManager.getInstance().getTextColor(
                            defaultColor: Utility.getTextColorByPriority(
                                this.widget.priorityEnum),
                            defaultDarkColor: Color(0xffcccccc)),
                        shadows: ThemeManager.getInstance().isDark()
                            ? null
                            : [
                                Shadow(
                                    color: Colors.white, offset: Offset(1, 1))
                              ]),
                  ),
                  Spacer(),
                  if (subtitle != null)
                    GestureDetector(
                      onTap: () {
                        onTapCreateListener?.call();
                      },
                      onLongPress: () {
                        unawaited(_showMobileVoiceTaskSheet());
                      },
                      child: Text(
                        subtitle ?? "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            color: ThemeManager.getInstance().getTextColor(
                                defaultColor: Utility.getTextColorByPriority(
                                    this.widget.priorityEnum),
                                defaultDarkColor: Color(0xffcccccc)),
                            shadows: ThemeManager.getInstance().isDark()
                                ? null
                                : [
                                    Shadow(
                                        color: Colors.white,
                                        offset: Offset(1, 1))
                                  ]),
                      ),
                    ),
                  if (subtitle != null) SizedBox(width: 15),
                ],
              )),
        ));
  }

  /**
   * 构建列表
   * containerWidth: 容器宽度
   * containerHeight: 容器高度
   * onCreateListener: 创建监听
   */
  List<Widget> buildList(
      {required double containerWidth,
      required double containerHeight,
      required Function onCreateListener}) {
    List<Widget> listWidget = [];
    listWidget.add(initSliverPersistentHeader(getI18NKey().missionToBeComplete,
        subtitle: getI18NKey().create, onTapCreateListener: onCreateListener));
    listWidget.add(QuadrantMissionSilverList(
      quadrantWidgetGlobalKey: this.widget.quadrantWidgetGlobalKey,
      onDragEndListener: (data) {
        this.onClick("onDragEndListener", data);
      },
      priorityEnum: this.widget.priorityEnum,
      //未完成任务列表
      datas: this.widget.listMissionModelsUnfinished,
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
      onDragingListener: (index) {
        this.widget.onDragingListener(index);
      },
      containerHeight: containerHeight,
      containerWidth: containerWidth,
    ));
    listWidget.add(initSliverPersistentHeader(getI18NKey().missioncompleted));
    listWidget.add(QuadrantMissionSilverList(
      containerHeight: containerHeight,
      containerWidth: containerWidth,
      quadrantWidgetGlobalKey: this.widget.quadrantWidgetGlobalKey,
      priorityEnum: this.widget.priorityEnum,
      //未完成任务列表
      datas: this.widget.listMissionModelsFinished,
      onDragEndListener: (data) {
        this.onClick("onDragEndListener", data);
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
      onDragingListener: (index) {
        this.widget.onDragingListener(index);
        // showBorder(priorityIndex: index);
      },
    ));
    return listWidget;
  }
}
