
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/MissionDetailEnv.dart';
import 'package:time_hello/com/timehello/components/BackNavigator.dart';
import 'package:time_hello/com/timehello/components/EditTitleDialogUtil.dart';
import 'package:time_hello/com/timehello/components/ai/ai_content_confirm.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/SettingItemDetailPage/SettingItemDetailPage.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../main.dart';
import '../components/AISearchBar.dart';
import '../components/BottomCounterWidget.dart';
import '../components/CloseButton.dart';
import '../components/CmdFContainerWidget.dart';
import '../components/ConfirmDialogWidget.dart';
import '../components/FullScreenOverlayWidgetEntry.dart';
import '../components/NineLoterryWidget.dart';
import '../components/SelectBgDialog.dart';
import '../components/SelectMoneyPerHourOfMeDialogUtil.dart';
import '../components/SelectSliderDurationDialogUtil.dart';
import '../components/SelectSliderVolumeDialogUtil.dart';
import '../components/SettingListViewWidget.dart';
import '../config/ENUMS.dart';
import '../config/Params.dart';
import '../config/Params.dart';
import '../interface/OnTapListener.dart';
import '../models/CheckButtonStateModel.dart';
import '../page/missionDetailPage/MissionDetailPage.dart';
import 'Utility.dart';

/**
 * 用于管理overlay
 */
class OverlayManagement {
  static OverlayManagement? mOverlayManagement;
  OverlayEntry? missionDetailPageOverlayEntry; //倒计时页面用overlay平铺
  OverlayEntry? sliderSelectSliderDurationOverlayEntry; //用于missionDetail页控制时长
  OverlayEntry? selectValueMoneyOverlayEntry; //任务价值控制
  OverlayEntry? editTitleOverlayEntry; //标题对话框编辑
  OverlayEntry? selectSliderVolumeDialogOverlayEntry; //选择声音
  OverlayEntry? missionDetailBottomCounterEntry; //底部计数widget
  OverlayEntry? missionDetailPageSettingEntry; //MissionDetailPage右上角列表
  OverlayEntry? mPCCustomOverlayEntry; //pc端自定义overlay
  OverlayEntry? desktopRightFloatingOverlayEntry; // pc端右侧真正悬浮层


  OverlayEntry? customDialogEntry; //自定义对话框
  OverlayEntry? newPagePCEntry; //针对pc端新页面 普通页面用push
  OverlayEntry? selectBgDialogOverlayEntry;
  OverlayEntry? loadingEntry; //针对pc端新页面 普通页面用push
  List<OverlayEntry>? newPagePCEntryHistoryList = []; //针对pc端新页面 普通页面用push
  OverlayEntry? lotteryNineGridViewEntry; //九宫格抽奖
  OverlayState? overlayState;



  BottomCounterWidget? bottomCounterWidget;

  static OverlayManagement getInstance() {
    if (mOverlayManagement == null) {
      mOverlayManagement = new OverlayManagement();
    }
    return mOverlayManagement!;
  }

  init(
      {required MissionModel missionModel,
      required FolderModel folderModel,
      required MissionDetailPageState missionDetailPageState}) {
    return mOverlayManagement;
  }

  Widget buildDesktopRightFloatingPanel(
      {required BuildContext context,
      required Widget child,
      double width = 430,
      VoidCallback? onClose,
      EdgeInsetsGeometry margin =
          const EdgeInsets.fromLTRB(18, 18, 18, 28)}) {
    final bool isDark = ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
    final BorderRadius panelRadius = BorderRadius.circular(32);
    final BorderRadius innerRadius = BorderRadius.circular(24);
    return Container(
      width: width,
      margin: margin,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1D1713).withValues(alpha: 0.96)
              : const Color(0xFFFDF7EE).withValues(alpha: 0.98),
          borderRadius: panelRadius,
          border: Border.all(
            color: isDark ? const Color(0xFF43372F) : const Color(0xFFEADBCB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 34,
              offset: const Offset(0, 18),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: panelRadius,
          child: Column(
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.fromLTRB(18, 10, 12, 8),
                child: Row(
                  children: [
                    Text(
                      "Task Details",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ThemeManager.getInstance().getTextColor(
                            defaultColor: const Color(0xFF8B6A55),
                            defaultDarkColor: Colors.white70),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: onClose ??
                          () {
                            Utility.popupDesktopRightNavigator(context);
                          },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A231E)
                              : const Color(0xFFFFF5EC),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF43372F)
                                : const Color(0xFFF1E2D5),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: ThemeManager.getInstance().getIconColor(
                              defaultColor: const Color(0xFF7A6657),
                              defaultDarkColor: Colors.white70),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                  child: ClipRRect(
                    borderRadius: innerRadius,
                    child: Container(
                      color: isDark
                          ? const Color(0xFF241D18)
                          : const Color(0xFFFFFCF8),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openDesktopRightFloatingPage(BuildContext context,
      {required String page, required Map data, double width = 438}) {
    Widget? child;
    switch (page) {
      case 'SettingItemDetailPage':
        child = SettingItemDetailPage(
          key: ValueKey("setting_item_detail_overlay"),
          missionModel: data['missionModel'],
        );
        break;
    }
    if (child == null) {
      return;
    }
    final Widget panelChild = child;
    removeDesktopRightFloatingOverlay();
    final OverlayState overlayState = Overlay.of(context);
    desktopRightFloatingOverlayEntry = OverlayEntry(builder: (overlayContext) {
      return Positioned(
        top: 72,
        right: 14,
        bottom: 28,
        width: width,
        child: Material(
          color: Colors.transparent,
          child: buildDesktopRightFloatingPanel(
            context: overlayContext,
            width: width,
            margin: EdgeInsets.zero,
            onClose: removeDesktopRightFloatingOverlay,
            child: panelChild,
          ),
        ),
      );
    });
    overlayState.insert(desktopRightFloatingOverlayEntry!);
  }

  void removeDesktopRightFloatingOverlay() {
    desktopRightFloatingOverlayEntry?.remove();
    desktopRightFloatingOverlayEntry = null;
  }

  showPCCustomOverlay({required BuildContext context, required Widget child}) {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ColorsConfig.color_background_menu,
            border: Border.all(color: ColorsConfig.color_background_menu, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.all(60),
          child: Scaffold(
              body: Column(children: [
                Container(
                    height: 30,
                    decoration: BoxDecoration(color: ColorsConfig.color_background_menu,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClosedButton(
                          onTapListener: (res) {
                            this.hidePCCustomOverlay();
                            // removeNewPageOverlay();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(child: child)
              ])));
    });
    navigatorKey.currentState?.overlay
        ?.insert(mPCCustomOverlayEntry = overlayEntry);
  }

  hidePCCustomOverlay() {
    if (this?.mPCCustomOverlayEntry != null) {
      this?.mPCCustomOverlayEntry?.remove();
      this?.mPCCustomOverlayEntry = null;
    }
  }

  /**
   * 打开倒计时页面
   */
  openMissionDetailPageOverlay(
      {required BuildContext context,
      MissionModel? missionModel,
      CounterStatus? counterStatusFromLiveActivity, //选填
      int timeHasUsed = 0,
      PageEnum? pageEnum,
      FolderModel? folderModel}) {
    if (this?.missionDetailPageOverlayEntry != null) {
      removeMissionDetailPageOverlay();
    }
    context.read<MissionDetailEnv>().timeHasUsed = timeHasUsed;
    context.read<MissionDetailEnv>().counterStatusFromLiveActivity = counterStatusFromLiveActivity ?? CounterStatus.none;
    context.read<MissionDetailEnv>().missionModel = missionModel;
    context.read<MissionDetailEnv>().folderModel = folderModel;
    context.read<MissionDetailEnv>().pageEnum = pageEnum ?? PageEnum.Normal;
    MissionDetailEnv.isFromPushTimes++; // 用来比较次数
    overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = new OverlayEntry(
        maintainState: true,
        opaque: true,
        builder: (context) {
          return MissionDetailPage(
              // timeHasUsed: timeHasUsed,
              // counterStatusFromLiveActivity:
              //     counterStatusFromLiveActivity ?? CounterStatus.none,
              // missionModel: missionModel ?? MissionModel(),
              // folderModel: folderModel ?? FolderModel(),
              // pageEnum: pageEnum
          );
        });
    navigatorKey.currentState?.overlay?.insert(overlayEntry);
    missionDetailPageOverlayEntry = overlayEntry;
  }

  /**
   * 关闭倒计时页面
   */
  removeMissionDetailPageOverlay() {
    this?.missionDetailPageOverlayEntry?.remove();
    this?.missionDetailPageOverlayEntry = null;
  }

  isMissionDetailPageOverlayVisible() {
    return this?.missionDetailPageOverlayEntry != null;
  }

  showSelectBgDialog(BuildContext context,
      {List? list, required Function onTapListener}) {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return SelectBgDialog(
        list: list ?? [],
        onTapListener: onTapListener,
      );
    });
    navigatorKey.currentState?.overlay
        ?.insert(selectBgDialogOverlayEntry = overlayEntry);
  }

  hideSelectBgDialog() {
    if (this?.selectBgDialogOverlayEntry != null) {
      this?.selectBgDialogOverlayEntry?.remove();
      this?.selectBgDialogOverlayEntry = null;
    }
  }

  openSelectMoneyPerHourOfMeOverlay(BuildContext context,
      {String? title,
        String? content,
        String? leftText,
        String? rightText,
        int initVal = 50,
        CounterEnum counterEnum = CounterEnum.chronograph,
        OnTapListener? onTapListener,
        Function? okCallBack,
        Function? cancelCallBack,
        String okRouteUri = ""}) {
    dismissSelectValueMoneyOverlay();
    // if(selectValueMoneyOverlayEntry != null){
    //   return;
    // }
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return SelectMoneyPerHourOfMeDialog(
          title: title,
          content: content,
          leftText: leftText,
          initVal: initVal,
          rightText: rightText,
          counterEnum: counterEnum,
          okCallBack: okCallBack,
          onTapListener: onTapListener,
          cancelCallBack: cancelCallBack,
          okRouteUri: okRouteUri);
    });
    navigatorKey.currentState?.overlay
        ?.insert(selectValueMoneyOverlayEntry = overlayEntry);
  }


  openMissionDetailPageSettingOverlay(BuildContext context,
      {required double right, double? top, required List<CheckButtonStateModel> list, required Function onTapListener}) async {
    var overlayState = Overlay.of(context, rootOverlay: true);
    dismissMissionDetailPageSettingEntry();
    // if(selectValueMoneyOverlayEntry != null){
    //   return;
    // }
    OverlayEntry overlayEntry =  FullScreenOverlayEntry(builder: (context) {
      return Stack(
        children: [
          SettingListViewWidget(list: list, onTapListener: onTapListener, right: right, top: top ?? 40,),
        ],
      );
    },    dismissCallback: () => dismissMissionDetailPageSettingEntry(),
    ).build();;
    // navigatorKey.currentState?.overlay
    //     ?.insert(missionDetailPageSettingEntry = overlayEntry);
    overlayState?.insert(this.missionDetailPageSettingEntry = overlayEntry);
  }


  dismissMissionDetailPageSettingEntry() {
    if (this?.missionDetailPageSettingEntry != null) {
      this?.missionDetailPageSettingEntry?.remove();
      this?.missionDetailPageSettingEntry = null;
    }
  }

  openSelectTimeDialogOverlay(BuildContext context,
      {String? title,
      String? content,
      String? leftText,
      String? rightText,
      int initVal = 10,
      CounterEnum counterEnum = CounterEnum.chronograph,
      OnTapListener? onTapListener,
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = ""}) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return SelectSliderDurationDialog(
          title: title,
          content: content,
          leftText: leftText,
          initVal: initVal,
          rightText: rightText,
          counterEnum: counterEnum,
          okCallBack: okCallBack,
          onTapListener: onTapListener,
          cancelCallBack: cancelCallBack,
          okRouteUri: okRouteUri);
    });
    navigatorKey.currentState?.overlay
        ?.insert(sliderSelectSliderDurationOverlayEntry = overlayEntry);
  }

  openEditTitleDialogOverlay(
    BuildContext context, {
    String? title,
    String? content,
    String? leftText,
    String? rightText,
    String? initVal = "",
    OnTapListener? onTapListener,
    Function? okCallBack,
    Function? cancelCallBack,
  }) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return EditTitleDialog(
        title: title,
        content: content,
        leftText: leftText,
        initVal: initVal,
        rightText: rightText,
        okCallBack: okCallBack,
        onTapListener: onTapListener,
        cancelCallBack: cancelCallBack,
      );
    });
    navigatorKey.currentState?.overlay
        ?.insert(editTitleOverlayEntry = overlayEntry);
  }

  removeEditDialogOverlay() {
    if (this?.editTitleOverlayEntry != null) {
      this?.editTitleOverlayEntry?.remove();
      this?.editTitleOverlayEntry = null;
    }
  }

  removeSelectDialogOverlay() {
    if (this?.sliderSelectSliderDurationOverlayEntry != null) {
      this?.sliderSelectSliderDurationOverlayEntry?.remove();
      this?.sliderSelectSliderDurationOverlayEntry = null;
    }
  }

  openSelectSliderVolumeDialogOverlay(
    BuildContext context, {
    required String title,
    String? content,
    String? leftText,
    String? rightText,
    int initVal = 10,
    OnTapListener? onTapListener,
    required Function okCallBack,
    required Function cancelCallBack,
  }) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return SelectSliderVolumeDialog(
        title: title,
        content: content,
        leftText: leftText,
        initVal: initVal,
        rightText: rightText,
        okCallBack: okCallBack,
        onTapListener: onTapListener,
        cancelCallBack: cancelCallBack,
      );
    });
    navigatorKey.currentState?.overlay
        ?.insert(selectSliderVolumeDialogOverlayEntry = overlayEntry);
  }

  openCustomConfirmDialog(
      BuildContext context, {
        required String title,
        String? content,
        String? leftText,
        String? rightText,
        int initVal = 10,
        OnTapListener? onTapListener,
        required Function okCallBack,
        required Function cancelCallBack,
      }) {
    title = title ?? "";
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return ConfirmDialogWidget(
        title: title,
        content: content,
        leftText: leftText,
        initVal: initVal,
        rightText: rightText,
        okCallBack: okCallBack,
        onTapListener: (v) {
          onTapListener?.call(v);
        },
        cancelCallBack: () {
          dismissCustomConfirmDialog();
          cancelCallBack.call();
        },
      );
    });
    navigatorKey.currentState?.overlay
        ?.insert(customDialogEntry = overlayEntry);
  }


  dismissCustomConfirmDialog() {
    if (this?.customDialogEntry != null) {
      this?.customDialogEntry?.remove();
      this?.customDialogEntry = null;
    }
  }
  dismissSelectValueMoneyOverlay() {
    if (this?.selectValueMoneyOverlayEntry != null) {
      this?.selectValueMoneyOverlayEntry?.remove();
      this?.selectValueMoneyOverlayEntry = null;
    }
  }



  removeSelectSliderVolumeDialogOverlay() {
    if (this?.selectSliderVolumeDialogOverlayEntry != null) {
      this?.selectSliderVolumeDialogOverlayEntry?.remove();
      this?.selectSliderVolumeDialogOverlayEntry = null;
    }
  }

  void showAutoLoopDialog(BuildContext context,
      {required String title,
      Widget? child,
      required Function okCallback,
      required Function cancelCallback}) {
    openDialogOverlay(context, Container());
  }

  void openDialogOverlay(BuildContext context, Widget widget) {
    var overlayState = Overlay.of(context);
    OverlayEntry newPagePCEntry = new OverlayEntry(builder: (context) {
      return Container(
          clipBehavior: Clip.antiAlias,
          decoration: StylesConfig.getDecoration(),
          margin: EdgeInsets.all(60),
          child: Scaffold(
            body: Column(
              children: [
                Container(
                    height: 30,
                    color: ColorsConfig.color_background_menu,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClosedButton(
                          onTapListener: (res) {
                            removeNewPageOverlay();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(child: widget)
              ],
            ),
          ));
    });
    newPagePCEntryHistoryList?.add(newPagePCEntry);
    overlayState.insert(newPagePCEntry);
  }

  /**
   * 只能用在mount
   * 而不是InitState
   */
  void showLoadingDialog(BuildContext context) {
    var overlayState = Overlay.of(context);
    OverlayEntry newPagePCEntry = new OverlayEntry(builder: (context) {
      return Container(
          margin: EdgeInsets.all(60), child: WidgetManager.getLoadingWidget());
    });
    newPagePCEntryHistoryList?.add(newPagePCEntry);
    overlayState.insert(newPagePCEntry);
  }

  hideLoadingDialog() {
    this.newPagePCEntryHistoryList?.last.remove();
    this.newPagePCEntryHistoryList?.removeLast();
  }

  void openDialog(BuildContext context, Widget pageWidget) {
    var overlayState = Overlay.of(context);
    OverlayEntry newPagePCEntry = new OverlayEntry(builder: (context) {
      return Container(margin: EdgeInsets.all(60), child: pageWidget);
    });
    newPagePCEntryHistoryList?.add(newPagePCEntry);
    overlayState.insert(newPagePCEntry);
  }

  void openNewPageOverlay(BuildContext context, Widget pageWidget) {
    var overlayState = Overlay.of(context);
    OverlayEntry newPagePCEntry = new OverlayEntry(builder: (context) {
      return Container(
          clipBehavior: Clip.antiAlias,
          decoration: StylesConfig.getDecoration(),
          margin: EdgeInsets.all(60),
          child: Scaffold(
            body: Column(
              children: [
                Container(
                    height: 30,
                    color: ColorsConfig.color_background_menu,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClosedButton(
                          onTapListener: (res) {
                            removeNewPageOverlay();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(child: pageWidget)
              ],
            ),
          ));
    });
    newPagePCEntryHistoryList?.add(newPagePCEntry);
    overlayState.insert(newPagePCEntry);
  }

  removeDialogOverlay() {
    this.newPagePCEntryHistoryList?.last.remove();
    // if (this?.newPagePCEntry != null) {
    //   this?.newPagePCEntry?.remove();
    //   this?.newPagePCEntry = null;
    // }
    this.newPagePCEntryHistoryList?.removeLast();
    print("");
  }

  removeNewPageOverlay() {
    this.newPagePCEntryHistoryList?.last.remove();
    // if (this?.newPagePCEntry != null) {
    //   this?.newPagePCEntry?.remove();
    //   this?.newPagePCEntry = null;
    // }
    this.newPagePCEntryHistoryList?.removeLast();
    print("");
  }

  void openMissionDetailBottomCounterOverlay(BuildContext context) {
    if (bottomCounterWidget == null) {
      var overlayState = Overlay.of(context);
      missionDetailBottomCounterEntry = new OverlayEntry(builder: (context) {
        return bottomCounterWidget = BottomCounterWidget();
      });
      overlayState.insert(missionDetailBottomCounterEntry!);
    }
  }

  void openLotteryNineGridViewEntry(BuildContext context,
      {required NineLoterryController simpleLotteryController}) {
    var overlayState = Overlay.of(context);
    lotteryNineGridViewEntry = new OverlayEntry(builder: (context) {
      return Center(
        child: NineLoterryWidget(
          // commodityList: [{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},],
          onPress: () {
            simpleLotteryController?.start(5);
// _simpleLotteryController.start(Random().nextInt(8));
          },
          nineLoterryController: simpleLotteryController,
        ),
      );
    });
    overlayState.insert(lotteryNineGridViewEntry!);
  }

  removeLotteryNineGridViewEntry() {
    if (this?.lotteryNineGridViewEntry != null) {
      this?.lotteryNineGridViewEntry?.remove();
      this?.lotteryNineGridViewEntry = null;
    }
  }

  void showAIConfirmMenu({
    required BuildContext context,
    // Function callback,
    // required EditorState editorState,
    // Selection? selection,
    bool isHighlight = false,
    String? text,
    String? prompt,
    Function? onSubmit,
    Function? onContinue,
    Function? onCopy,
  }) {
    // Since link format is only available for single line selection,
    // the first rect(also the only rect) is used as the starting reference point for the [overlay] position
    // final texts = editorState.getTextInSelection(selection);
    // String text = texts.join('\n');
    // get link address if the selection is already a link
    String? linkText;
    OverlayEntry? overlay;
    // final (left, top, right, bottom) = _getPosition(editorState, linkText);
    // if (selection != null) {
    //   // if (isHighlight) {
    //   //   linkText = editorState.getDeltaAttributeValueInSelection(
    //   //     BuiltInAttributeKey.href,
    //   //     selection,
    //   //   );
    //   // }
    //
    //   // get node, index and length for formatting text when the link is removed
    //   final node = editorState.getNodeAtPath(selection!.end.path);
    //   if (node == null) {
    //     return;
    //   }
    //   // final index = selection.normalized.startIndex;
    //   // final length = selection.length;
    // }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void dismissOverlay() {
      keepEditorFocusNotifier.decrease();
      overlay?.remove();
      overlay = null;
    }

    keepEditorFocusNotifier.increase();
    overlay = FullScreenOverlayWidgetEntry(
      top: height / 2 - 200,
      // height: 0,
      left: width / 2 - (isHandsetBySize(context: context) ? mobileWidth : tabletWidth) / 2,
      // width: 0,
      dismissCallback: () => keepEditorFocusNotifier.decrease(),
      builder: (context) {
        return Container(
            width: isHandsetBySize(context: context) ? mobileWidth : tabletWidth,
            height: isHandsetBySize(context: context) ? 400 : 600,
            child: AiContentConfirmWidget(
              // shouldShowReplace: selection != null,
              text: text ?? "",
              onCopy: (text) {
                print('复制');
                onCopy?.call(text);
                dismissOverlay();
                // _controller.text = this.widget.text;
              },
              onReplace: (text) {
                print('替换');
                // editorState.replaceTextAtPosition(text, selection: selection!);
              },
              onInsert: (text) {
                print('插入');
                // editorState.insertTextAtLastCurrentSelection(
                //   text,
                //   // position: selection.end,
                //   // forceInsert: true
                // );
                // setState({});
              },
              onContinue: (text) async {
                print('继续写作');
                String res = await onContinue?.call(
                    i18nInstanceLocal.continue_writing_prompt +
                        "-" +
                        (prompt ?? ""),
                    text);
                text = res;
                showAIConfirmMenu(
                    context: context,
                    // editorState: editorState,
                    // selection: selection,
                    isHighlight: isHighlight,
                    text: res,
                    prompt: null,
                    onSubmit: onSubmit,
                    onContinue: onContinue,
                    onCopy: onCopy);
                // showAIConfirmMenu(context, editorState, selection, isHighlight,
                //     res, null, onSubmit, onContinue,onCopy);
              },
              onGiveUp: (text) {
                print('放弃');
                dismissOverlay();
              },
              onSubmit: (aiText) async {
                String res = await onSubmit?.call(aiText, text);
                dismissOverlay();
                showAIConfirmMenu(
                    context: context,
                    // editorState: editorState,
                    // selection: selection,
                    isHighlight: isHighlight,
                    text: res,
                    prompt: null,
                    onSubmit: onSubmit,
                    onContinue: onContinue,
                    onCopy: onCopy);
                // showAIConfirmMenu(context, editorState, selection, isHighlight,
                //     res, null, onSubmit, onContinue,onCopy);
              },
            ));
      },
    ).build();

    Overlay.of(context, rootOverlay: true).insert(overlay!);
  }

}
