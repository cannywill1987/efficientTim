import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/components/SelectDatePeriodDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectTagDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectTomatoesDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SliderWithCanvasWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/page/TimeLinePage/TimeLinePage.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/NavigatorManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../beans/SuggestionBean.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomMarquee.dart';
import '../../components/CustomTabBarWidget.dart';
import '../../components/ListingSecurityWidget.dart';
import '../../components/MenuItem2.dart';
import '../../components/MissionCountDownTextWidget.dart';
import '../../components/MissionValueWidget.dart';
import '../../components/PriorityButtonListWidget.dart';
import '../../components/SectionTitleWidget.dart';
import '../../components/SelectCircleDialogUtil.dart';
import '../../components/SubmissionSliverList.dart';
import '../../components/unified/UnifiedDesktopShell.dart';
import '../../config/ENUMS.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../libs/mongodb/response/MongoDbUpdated.dart';
import '../../models/CheckButtonStateModel.dart';
import '../../util/CounterManagement.dart';
import '../../util/DeviceInfoManagement.dart';
import '../../util/OverlayManagement.dart';
import '../../util/ScreenUtil.dart';
import '../missionPage/componnents/ComposedRichEditorWidget.dart';
import 'components/TagsGridViewWidget.dart';

/**
 * 文件类型：页面
 * 文件作用：用于编辑任务详情里的笔记、子任务、任务设置和时间轴。
 * 主要职责：承接 MissionPage 进入的设置编辑流程，并在移动端和 PC 端复用同一套任务设置数据更新逻辑。
 */
class SettingItemDetailPage extends BaseWidget {
  int fromNormal = 0; //0是正常创建更新 1表示CreateAIChatGptMissionPage不需要刷新数据，直接更新即可
  int defaultTab = 0;
  MissionModel missionModel;
  Function? popOkCallback;
  Function? onClickDeleteCallback;

  SettingItemDetailPage(
      {Key? key,
      this.fromNormal = 0,
      this.defaultTab = 0,
      this.onClickDeleteCallback,
      required this.missionModel,
      this.popOkCallback})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SettingItemDetailPageWidgetState(
        curTab: fromNormal == 1 ? 2 : defaultTab);
  }
}

class _SettingItemDetailPageWidgetState<T>
    extends BaseWidgetState<SettingItemDetailPage> {
  // DateTimeModel alertTimeModel = null;
  TextEditingController? controller;
  List<FolderModel> folderModelTags = [];
  List<CheckButtonStateModel> tabList = CONSTANTS.getMissionDetailSetting();
  int curTab = 0;
  FolderModel? folderModel;
  GlobalKey<ComposedRichEditorWidgetState>? composedRichEditorWidgetGlobalKey =
      GlobalKey<ComposedRichEditorWidgetState>();
  GlobalKey<SubmissionSliverListState>? submissionSliverListStateGlobalKey =
      GlobalKey();

  // MissionModel missionModel;
  bool isNeedUpdateBmob =
      false; //是否需要更新BMOB 需要更新就EventBus发送广播让MssionPage重新发起requestData请求
  bool isSaving = false;
  bool isDeletingMission = false;
  bool isInlineEditingTitle = false;
  TextEditingController? titleEditingController;
  FocusNode titleEditingFocusNode = FocusNode();

  bool get isUnifiedDesktop => !Utility.isHandsetBySize();

  bool get isUnifiedMobile => Utility.isHandsetBySize();

  bool get useUnifiedSettingStyle => isUnifiedDesktop || isUnifiedMobile;

  bool get isDarkTheme =>
      ThemeManager.getInstance().getThemeMode().isDark ||
      Theme.of(context).brightness == Brightness.dark;

  Color get detailPanelBackground => isDarkTheme
      ? const Color(0xFF1F1915)
      : const Color(0xFFFDF7EE).withValues(alpha: 0.96);

  Color get detailSectionBackground =>
      isDarkTheme ? const Color(0xFF2A231E) : const Color(0xFFFFFCF7);

  Color get detailBorderColor =>
      isDarkTheme ? const Color(0xFF443931) : const Color(0xFFEBDCCB);

  Color get detailTitleColor => ThemeManager.getInstance().getTextColor(
      defaultColor: const Color(0xFF352216), defaultDarkColor: Colors.white);

  Color get detailSubColor => ThemeManager.getInstance().getTextColor(
      defaultColor: const Color(0xFF8D7768), defaultDarkColor: Colors.white70);

  Color get detailMobileBackground =>
      isDarkTheme ? const Color(0xFF17130F) : const Color(0xFFF8EEE1);

  /**
   * 功能：构建移动端设置页统一卡片装饰。
   * 说明：移动端复用 PC 端的暖色卡片语言，但降低阴影和圆角尺寸，避免在小屏上显得过重。
   */
  BoxDecoration buildMobileSettingCardDecoration() {
    return BoxDecoration(
      color: detailSectionBackground,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: detailBorderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDarkTheme ? 0.12 : 0.035),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  /**
   * 功能：构建设置页最外层响应式背景。
   * 说明：PC 端仍交给右侧面板承载，移动端补齐暖色渐变背景，让任务设置页和 PC 新设计保持一致。
   */
  Widget wrapUnifiedPageShell({required Widget child}) {
    if (isUnifiedDesktop) {
      return Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: child,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: detailMobileBackground,
        gradient: isDarkTheme
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF7EE),
                  Color(0xFFF8EEE1),
                  Color(0xFFF1E6D9),
                ],
              ),
      ),
      child: child,
    );
  }

  /**
   * 功能：统一包装设置页内的分组卡片。
   * 说明：移动端使用更紧凑的外边距和圆角，PC 端继续使用 UnifiedDesktopCard，保证两端视觉语言一致但密度不同。
   */
  Widget wrapUnifiedSection(
      {required Widget child, EdgeInsetsGeometry? padding}) {
    if (isUnifiedMobile) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: padding ?? const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: buildMobileSettingCardDecoration(),
        child: child,
      );
    }
    if (!isUnifiedDesktop) {
      return child;
    }
    return UnifiedDesktopCard(
      margin: const EdgeInsets.only(top: 12),
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 16),
      backgroundColor: detailSectionBackground,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      border: Border.all(color: detailBorderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
      child: child,
    );
  }

  Widget buildHeaderActionChip(
      {required Widget child, required VoidCallback onTap}) {
    return UnifiedActionChip(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }

  /**
   * 功能：构建任务设置项容器。
   * 说明：历史函数名保留 Desktop，但现在移动端也复用它来把设置项转成单列卡片，避免手机上继续使用旧列表样式。
   */
  Widget buildDesktopSettingsGrid(List<Widget> children) {
    if (isUnifiedMobile) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1) const SizedBox(height: 10),
            ],
          ],
        ),
      );
    }
    if (!isUnifiedDesktop) {
      return Column(children: children);
    }
    return wrapUnifiedSection(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: children,
        ),
      ),
    );
  }

  Widget buildDesktopControlSection(Widget child) {
    if (!isUnifiedDesktop) {
      return child;
    }
    return wrapUnifiedSection(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: child,
    );
  }

  Widget buildBackgroundPreviewWidget() {
    final String backgroundUrl = this.widget.missionModel.background_url ?? '';
    if (TextUtil.isEmpty(backgroundUrl)) {
      return getBgSettingItem();
    }
    return CachedNetworkImage(
      imageUrl: Utility.filterHttpUrl(backgroundUrl, prefix: "oss"),
      placeholder: (_, __) => getBgSettingItem(),
      errorWidget: (_, __, ___) => getBgSettingItem(),
      imageBuilder: (context, imageProviderTmp) {
        return getBgSettingItem(imageProviderTmp: imageProviderTmp);
      },
    );
  }

  Widget buildDesktopTaskSettingsHeader() {
    return wrapUnifiedSection(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: buildEditableMissionTitle(fontSize: 22)),
              const SizedBox(width: 12),
              buildDeleteMissionButton(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            getI18NKey().mission_setting,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: detailSubColor,
            ),
          ),
          const SizedBox(height: 12),
          if (!(this.widget.missionModel.missionModelType == 1 ||
              this.widget.missionModel.missionModelType == 2))
            BlackCheckButtonListWidget(
              initIndex: this.widget.missionModel.time_mode,
              backgroundColor: ColorsConfig.gray_40,
              useUnifiedStyle: true,
              list: CONSTANTS.getSettingItemDetailCheckButtonList(
                  defaultVal: this.widget.missionModel.time_mode ?? 0),
              onTapListener: (index) async {
                this.widget.missionModel.time_mode = index;
                this.widget.missionModel.end_time = 0;
                this.widget.missionModel.start_time = 0;
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  Widget buildDeleteMissionButton() {
    return Tooltip(
      message: getI18NKey().delete,
      child: InkWell(
        onTap: isDeletingMission
            ? null
            : () async {
                await onClickDeleteItem(this.widget.missionModel);
              },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 44,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isDarkTheme ? const Color(0xFF3A2020) : const Color(0xFFFFF7F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFF4D4F),
              width: 1.4,
            ),
          ),
          child: isDeletingMission
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF4D4F),
                    ),
                  ),
                )
              : const Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFFFF4D4F),
                ),
        ),
      ),
    );
  }

  double get unifiedTileWidth => 156;

  /**
   * 功能：判断当前任务设置是否按完整日期时间编辑。
   * 说明：日期模式和目标模式都需要保留年月日时分；只有时间段模式使用每日开始/完成时间。
   */
  bool get shouldUseDateTimeSetting =>
      this.widget.missionModel.time_mode == 1 ||
      this.widget.missionModel.time_mode == 2;

  _SettingItemDetailPageWidgetState({this.curTab = 0}) {}

  @override
  void onCreate() {
    super.onCreate();
    curPage = "SettingItemDetailPage";
  }

  @override
  void initState() {
    //查找当前mission所属的FolderModel
    // AppFlowyEditorLocalizations.delegate.load(const Locale('zh', 'CN'));
    if (Utility.shouldShowAllMissionDetailTab(
            missionModelType: this.widget.missionModel.missionModelType) ==
        true) {
      tabList = CONSTANTS.getMissionDetailSetting();
    } else {
      tabList = CONSTANTS.getMissionDetailSetting2();
    }

    controller =
        TextEditingController(text: this.widget.missionModel?.message ?? '');
    titleEditingController =
        TextEditingController(text: this.widget.missionModel.title ?? '');
    // await requestGetTags(this.widget.missionModel?.tagNames.split(',') ?? ['ejizfjize']);
    if (this.widget.missionModel?.tagNames == null)
      this.widget.missionModel?.tagNames = '';
    if (this.widget.missionModel?.tagNames != null) {
      requestGetTags(this.widget.missionModel?.tagNames?.split(',') ?? []);
    }

    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      MissionModel? missionModel = event?.obj?['data'];
      if (missionModel != null) {
        if (event.type == Params.ACTION_UPDATE_SETTING_ITEM_DETAIL) {
          if (this.widget.missionModel.objectId == missionModel?.objectId) {
            this.widget.missionModel = missionModel!;
            updateUI();
          }
          // Future.delayed(Duration(seconds: 1), () {
          // });
        }
      }
    });
  }

  // componentDidMount() {
  //   //监听广播 设置页面过来后用得上 todo 应该加一个action
  //
  // }

  void onClick(type, data) async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.missionModel.folder_id ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
    switch (type) {
      case 'onClickMissionDetail': //跳转到任务详情页MissionPage开始任务
        onClickMissionStart(data);
        break;
      // case 'onClickUpdateBgUrl':
      //   this.onClickUpdateBgUrl(this.widget.missionModel);
      //   break;
      case 'onClickDeleteItem':
        this.onClickDeleteItem(this.widget.missionModel);
        break;
      case 'onTapTagListener': //创建mission时选择tag
        await onClickCreateTag();
        break;
      case "onClickPriority": //点击选择优先级
        await onTapPriority(data);
        break;
      case "onClickDoItNow":
        Utility.onClickUpdateTimeDoItNow(context, [this.widget.missionModel],
            onTapFinish: () {
          updateUI();
        });
        break;
      case "onClickFinishItem": //点击完成任务
        if (this.widget.missionModel.isFinished == false) {
          await onClickFinishItem(this.widget.missionModel);
        } else {
          await onClickUnfinishItem(this.widget.missionModel);
        }
        break;
      case "onClickUpdate": //点击更新按钮
        await onClickUpdate();
        break;
      case "onTapCreateTagListener":
        break;
      case 'onTapCircleListener': //穿件mission时选择目标文件夹
        this.onTapCircleListener();
        break;
      case 'onClickSelectTomatoes':
        this.onClickSelectTomatoes(context);
        break;
      case 'onClickEditTitle': //编辑标题
        this.onClickEditTitle(this.widget.missionModel ?? MissionModel());
        break;
    }
  }

  /**
   * 功能：删除当前任务。
   * 说明：删除期间锁定按钮状态，避免重复提交；删除成功后通知列表和日历刷新。
   */
  Future onClickDeleteItem(data) async {
    if (isDeletingMission) {
      return;
    }
    if (this.widget.fromNormal != 0 &&
        this.widget.onClickDeleteCallback != null) {
      this.widget.onClickDeleteCallback!(data);
      // if (Utility.isHandsetBySize() == true) {
      Navigator.of(context).pop();
      // } else {
      //   Utility.popupDesktopRightNavigator(context);
      // }
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
      try {
        setState(() {
          isDeletingMission = true;
        });
        // 删除任务必须走 MongoApisManager，确保 MongoDB、内存缓存和后续列表刷新链路保持一致。
        await MongoApisManager.getInstance()
            .delete_MissionModel(currentObjectId: data.objectId);
        eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
        eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
        Utility.showToastMsg(
            context: context, msg: getI18NKey().delete_success);
        if (Utility.isHandsetBySize() == true) {
          Navigator.of(context).pop();
        } else {
          Utility.popupDesktopRightNavigator(context);
        }
      } finally {
        if (mounted) {
          setState(() {
            isDeletingMission = false;
          });
        }
      }
    }
  }

  Future onClickEditTitle(MissionModel data) async {
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
      if (this.widget.fromNormal == 0) {
        await MongoApisManager.getInstance()
            .update_MissionModel(missionModel: data);
      }
      isNeedUpdateBmob = true;
      updateUI();
      DialogManagement.getInstance().hideDialog(context);
    }, cancelCallBack: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  /**
   * 创建mission时选择tag
   */
  Future onClickCreateTag() async {
    SelectTagDialogUtil.show(context,
        title: getI18NKey().selectTag,
        content: '',
        okCallBack: (FolderModel data) {}, onTapCreateTagListener: (data) {
      this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {
      String title = data.title;
      if (this.widget.missionModel?.tagNames == null)
        this.widget.missionModel?.tagNames = '';
      List<String> titleList =
          this.widget.missionModel?.tagNames?.split(',') ?? [];
      if (titleList.indexOf(title) == -1 && title.isEmpty == false) {
        titleList.add(title);
        this.widget.missionModel?.tagNames = titleList.join(',');
        this.updateUI();
        this.isNeedUpdateBmob = true;
        requestGetTags(this.widget.missionModel?.tagNames?.split(',') ?? []);
        Navigator.of(context).pop();
      } else {}
    });
  }

  requestGetTags(List<String> list) async {
    this.folderModelTags =
        await CONSTANTS.getFolderModelListFromStringList(list);
    this.updateUI();
  }

  @override
  void didUpdateWidget(SettingItemDetailPage oldWidget) {
    controller =
        TextEditingController(text: this.widget.missionModel?.message ?? '');
    if (!isInlineEditingTitle &&
        oldWidget.missionModel.title != this.widget.missionModel.title) {
      titleEditingController?.text = this.widget.missionModel.title ?? '';
    }
  }

  @override
  void deactivate() {}

  @override
  void dispose() {
    titleEditingController?.dispose();
    titleEditingFocusNode.dispose();
    super.dispose();
  }

  void startInlineTitleEdit() {
    titleEditingController?.text = this.widget.missionModel.title ?? '';
    isInlineEditingTitle = true;
    updateUI();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      titleEditingFocusNode.requestFocus();
      titleEditingController?.selection = TextSelection(
        baseOffset: 0,
        extentOffset: titleEditingController?.text.length ?? 0,
      );
    });
  }

  void cancelInlineTitleEdit() {
    titleEditingController?.text = this.widget.missionModel.title ?? '';
    isInlineEditingTitle = false;
    titleEditingFocusNode.unfocus();
    updateUI();
  }

  /**
   * 功能：把标题输入框里的临时文本同步回当前任务模型。
   * 说明：移动端点击底部“保存”会先触发输入框失焦，如果这里仍然走取消逻辑，
   * 会把 controller 重置成旧标题，导致保存时标题被还原。
   */
  bool syncInlineTitleTextToMission({bool shouldExitEditMode = true}) {
    final String nextTitle = titleEditingController?.text.trim() ?? '';
    if (TextUtil.isEmpty(nextTitle)) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(),
          msg: getI18NKey().title_cannot_be_empty);
      titleEditingFocusNode.requestFocus();
      return false;
    }

    // 先写回本地 MissionModel，后续保存按钮会统一走 requestMongoDbUpdateData 持久化。
    this.widget.missionModel.title = nextTitle;
    if (shouldExitEditMode) {
      isInlineEditingTitle = false;
      titleEditingFocusNode.unfocus();
    }
    return true;
  }

  Future<void> submitInlineTitleEdit() async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.missionModel.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      cancelInlineTitleEdit();
      return;
    }
    if (!syncInlineTitleTextToMission()) {
      return;
    }

    if (this.widget.fromNormal == 0) {
      await MongoApisManager.getInstance()
          .update_MissionModel(missionModel: this.widget.missionModel);
    }
    isNeedUpdateBmob = true;
    updateUI();
  }

  Widget buildEditableMissionTitle({double fontSize = 22}) {
    final TextStyle titleStyle = TextStyle(
      fontSize: fontSize,
      height: 1.12,
      fontWeight: FontWeight.w800,
      color: detailTitleColor,
    );

    if (isInlineEditingTitle) {
      return TextField(
        controller: titleEditingController,
        focusNode: titleEditingFocusNode,
        autofocus: true,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        style: titleStyle,
        cursorColor: detailTitleColor,
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          filled: false,
        ),
        onSubmitted: (_) async {
          await submitInlineTitleEdit();
        },
        onTapOutside: (_) {
          if (syncInlineTitleTextToMission()) {
            updateUI();
          }
        },
      );
    }

    return InkWell(
      onTap: startInlineTitleEdit,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          this.widget.missionModel.title ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
      ),
    );
  }

  Future<MongoDbUpdated?> requestMongoDbUpdateData() async {
    if ((this.widget.missionModel?.alert_time ?? 0) > 0) {
      Params.shouldRefreshPushModelList = true;
    }
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.missionModel?.folder_id ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
    MongoDbUpdated? mongoDbUpdated = await MongoApisManager.getInstance()
        .update_MissionModel(
            missionModel: this.widget.missionModel ?? MissionModel());
    if (mongoDbUpdated != null) {
      //todo 敢做这个没用了 因为用env了
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    } else {
      Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
    }
    return mongoDbUpdated;
  }

  /**
   * 选择标签
   */
  Future onTapTag() async {
    SelectTagDialogUtil.show(context,
        title: getI18NKey().selectTag,
        content: '',
        okCallBack: (FolderModel data) {}, onTapCreateTagListener: (data) {
      this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  /**
   * 功能：构建移动端设置页顶部栏。
   * 说明：移动端参考 PC 端暖色面板设计，把选择壁纸、删除和开始任务收进圆形图标按钮，减少顶部文字拥挤。
   */
  @override
  baseAppBar(BuildContext context) {
    if (isUnifiedMobile) {
      return AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
        backgroundColor: detailPanelBackground,
        leadingWidth: 58,
        iconTheme: IconThemeData(color: detailTitleColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: detailTitleColor, size: 21),
          onPressed: () {
            Utility.popNavigator(context);
          },
        ),
        title: Text(
          getI18NKey().setting,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: detailTitleColor,
          ),
        ),
        centerTitle: true,
        actions: getBarWidget(),
      );
    }
    return AppBar(
      iconTheme: IconThemeData(
        color: ThemeManager.getInstance()
            .getIconColor(defaultColor: Colors.black), //修改颜色
      ),
      backgroundColor: ThemeManager.getInstance()
          .getNavigationBarColor(defaultColor: Colors.white),
      actions: getBarWidget(),
      title: Text(getI18NKey().setting, style: TextStyle(fontSize: 16)),
      //标题居中显示
      centerTitle: true,
    );
  }

  /**
   * 功能：构建移动端设置页顶部圆形操作按钮。
   * 说明：移动端顶部操作参考 PC 端胶囊按钮的暖色边框，但保留 AppBar 的紧凑点击区。
   */
  Widget buildMobileAppBarAction({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: detailSectionBackground,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: detailBorderColor),
          ),
          child: Icon(icon, size: 19, color: iconColor ?? detailSubColor),
        ),
      ),
    );
  }

  /**
   * 功能：根据当前端形态生成顶部操作区。
   * 说明：移动端使用图标按钮，PC 端保留原有文字/图标操作，避免影响桌面端既有交互习惯。
   */
  List<Widget> getBarWidget() {
    if (isUnifiedMobile) {
      return [
        buildMobileAppBarAction(
          icon: Icons.image_outlined,
          onTap: () {
            DialogManagement.getInstance().showSelectBgDialog(context,
                list: ResourceInfo
                        .missionItemBackgroundLocationInfoBean?.deliveryList ??
                    [], onTapListener: (String imgUrl) {
              this.widget.missionModel.background_url = imgUrl;
              this.isNeedUpdateBmob = true;
              updateUI();
              DialogManagement.getInstance().hideDialog(context);
            });
          },
        ),
        buildMobileAppBarAction(
          icon: Icons.delete_outline_rounded,
          iconColor: const Color(0xFFFF4D4F),
          onTap: () {
            this.onClick("onClickDeleteItem", this.widget.missionModel);
          },
        ),
        if (this.widget.fromNormal == 0)
          buildMobileAppBarAction(
            icon: Icons.play_circle_outline_rounded,
            iconColor: const Color(0xFFFF5A5F),
            onTap: () {
              this.onClick("onClickMissionDetail", this.widget.missionModel);
            },
          ),
      ];
    }
    return [
      InkWell(
        onTap: () {
          DialogManagement.getInstance().showSelectBgDialog(context,
              list: ResourceInfo
                      .missionItemBackgroundLocationInfoBean?.deliveryList ??
                  [], onTapListener: (String imgUrl) {
            // SharePreferenceUtil.getSyncInstance().setString(
            //     key: ShareprefrenceKeys.pcBackground,
            //     content: imgUrl);

            this.widget.missionModel.background_url = imgUrl;
            this.isNeedUpdateBmob = true;
            // requestMongoDbUpdateData();
            updateUI();
            DialogManagement.getInstance().hideDialog(context);
          });
        },
        child: Text(getI18NKey().change_bg),
      ),
      IconButton(
          icon: Icon(
            Icons.delete,
            color: Color(0xff909090),
          ),
          onPressed: () {
            this.onClick("onClickDeleteItem", this.widget.missionModel);
          }),
      SizedBox(
        width: 0,
      ),
      this.widget.fromNormal != 0
          ? SizedBox.shrink()
          : IconButton(
              icon: Icon(
                Icons.play_circle_outline,
                color: Color(0xfffd5553),
              ),
              onPressed: () {
                this.onClick("onClickMissionDetail", this.widget.missionModel);
              }),
    ];
  }

  /**
   * 跳转到任务详情页MissionPage开始任务
   */
  void onClickMissionStart(MissionModel data) async {
    FolderModel folderModel = MongoApisManager.getInstance()
            .getFolderModelByFolderId(data?.folder_id ?? "") ??
        FolderModel();
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
    }
  }

  /**
   * 穿件mission时选择目标文件夹
   */
  Future onTapCircleListener() async {
    SelectCircleDialogUtil.show(context,
        title: getI18NKey().selectMission,
        content: '', okCallBack: (FolderModel data) {
      this.widget.missionModel?.folder_id = data.objectId;
      this.isNeedUpdateBmob = true;
      // requestMongoDbUpdateData();
      updateUI();
    }, onTapCreateTagListener: (data) {
      // this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    //return super.baseBuild(context);
    bool isDoingItNow = Utility.isDoingItNow(this.widget.missionModel!);
    this.folderModel = MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithFolderIdOfMission(
            this.widget.missionModel?.folder_id, 1);
    // DateTime? dateTimeNextTime = Utility.getNextDateTime(
    //     missionModelParam: this.widget.missionModel ?? MissionModel(),
    //     calendarModel: context.watch<GlobalStateEnv>().calendarModel);
    return wrapUnifiedPageShell(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            isUnifiedMobile ? 14 : 0,
            isUnifiedMobile ? 10 : 0,
            isUnifiedMobile ? 14 : 0,
            isUnifiedMobile ? 4 : 0,
          ),
          child: CustomTabBarWidget(
            checkIndex: curTab,
            list: tabList,
            onCheckedListener: (int index, CheckButtonStateModel model) {
              Utility.setDesktopMiddileMissionPage(context, isVisible: true);
              composedRichEditorWidgetGlobalKey?.currentState?.unfocus();
              if (Utility.shouldShowAllMissionDetailTab(
                      missionModelType:
                          this.widget.missionModel.missionModelType) ==
                  true) {
                this.curTab = index;
              } else {
                this.curTab = (index == 0) ? 0 : 2;
              }
              updateUI();
            },
            fontSize: isUnifiedDesktop ? 13 : 14,
            useUnifiedStyle: useUnifiedSettingStyle,
          ),
        ),
        useUnifiedSettingStyle
            ? const SizedBox(height: 8)
            : Container(
                height: 1,
                color: Color(0xffe0e0e0),
              ),
        if (this.curTab == 0) ...getTabBar0WidgetList(),
        if (this.curTab == 3) ...getTabBar3WidgetList(),
        if (this.curTab != 0 && this.curTab != 3)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!useUnifiedSettingStyle)
                      CustomMarquee(
                        bean: MarqueInfo.marqueSettingItemDetail,
                      ),
                    if (this.curTab == 1 ||
                        (!isUnifiedDesktop && this.curTab == 2))
                      _buildMissionHeroBlock(isDoingItNow),
                    // Container(height: 20, color: ColorsConfig.backgroundColor,),

                    if (this.curTab == 1) ...getTabBar1WidgetList(),
                    if (this.curTab == 2) ...getTabBar2WidgetList(),
                  ]),
            ),
          ),
        if (this.curTab != 0 && this.curTab != 3)
          SizedBox(
            height: 20,
          ),
        if (this.curTab != 0 && this.curTab != 3)
          Align(child: buildSaveButton())
      ],
    ));
  }

  Widget buildSaveButton() {
    if (isUnifiedDesktop) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 30),
        child: InkWell(
          onTap: isSaving
              ? null
              : () {
                  this.onClick("onClickUpdate", null);
                },
          borderRadius: BorderRadius.circular(999),
          child: Container(
            alignment: Alignment.center,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFDCC6AB), width: 1.2),
              color: const Color(0xFFFFEFD9),
            ),
            child: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF5B4332)),
                    ),
                  )
                : Text(
                    getI18NKey().save,
                    style: TextStyle(
                      color: Color(0xFF5B4332),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 24),
      child: InkWell(
        onTap: isSaving
            ? null
            : () {
                this.onClick("onClickUpdate", null);
              },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFDCC6AB), width: 1.2),
            color:
                isDarkTheme ? const Color(0xFF3A2D23) : const Color(0xFFFFEFD9),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(alpha: isDarkTheme ? 0.12 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF5B4332)),
                  ),
                )
              : Text(
                  getI18NKey().save,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : const Color(0xFF5B4332),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildMissionHeroBlock(bool isDoingItNow) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isUnifiedDesktop)
          Row(
            children: [
              Expanded(
                child: buildEditableMissionTitle(fontSize: 22),
              ),
              const SizedBox(width: 12),
              buildHeaderActionChip(
                onTap: () {
                  DialogManagement.getInstance().showSelectBgDialog(context,
                      list: ResourceInfo.missionItemBackgroundLocationInfoBean
                              ?.deliveryList ??
                          [], onTapListener: (String imgUrl) {
                    this.widget.missionModel.background_url = imgUrl;
                    this.isNeedUpdateBmob = true;
                    updateUI();
                    DialogManagement.getInstance().hideDialog(context);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined, size: 16, color: detailSubColor),
                    const SizedBox(width: 6),
                    Text(
                      getI18NKey().change_bg,
                      style: TextStyle(
                        color: detailSubColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (isUnifiedDesktop) const SizedBox(height: 18),
        if (isUnifiedMobile)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: buildEditableMissionTitle(fontSize: 20)),
            ],
          ),
        if (isUnifiedMobile) const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (this.widget.fromNormal != 0)
                ? SizedBox.shrink()
                : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          this.onClick("onClickFinishItem", null);
                        },
                        child: this.widget.missionModel?.isFinished == true
                            ? Icon(
                                Icons.check_circle,
                                color: ColorsConfig.calendar_green,
                                size: isUnifiedDesktop ? 28 : 25,
                              )
                            : Icon(
                                Icons.radio_button_unchecked_outlined,
                                color: ColorsConfig.calendar_green,
                                size: isUnifiedDesktop ? 28 : 25,
                              ),
                      ),
                      ListingSecurityWidget(
                        missionModdel_id: this.widget.missionModel?.objectId,
                        folder_id: this.widget.missionModel?.folder_id ?? "",
                        cryptoVersion:
                            this.widget.missionModel?.cryptoVersion ?? -1,
                        marginLeft: 5,
                        size: isUnifiedDesktop ? 22 : 20,
                      )
                    ],
                  ),
            SizedBox(width: isUnifiedDesktop ? 12 : 5),
            if (!useUnifiedSettingStyle)
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: this.widget.missionModel?.title ?? '',
                    children: [
                      TextSpan(
                          text: "【" + getI18NKey().edit + "】",
                          style: TextStyle(
                            color: ThemeManager.getInstance().getColor(
                                defaultColor: ColorsConfig.standardColor,
                                defaultDarkColor: Colors.blue),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              this.onClick("onClickEditTitle", null);
                            }),
                    ],
                    style: TextStyle(
                        fontSize: 14,
                        color: ThemeManager.getInstance()
                            .getTextColor(defaultColor: ColorsConfig.gray_40)),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
          ],
        ),
        if (Utility.shouldShowValue(
                missionModelType: this.widget.missionModel.missionModelType) ==
            true)
          Row(
            children: [
              Spacer(),
              MissionValueWidget(
                missionModel: this.widget.missionModel,
                onTapMissionValueListener: (val) {},
              ),
            ],
          ),
        if (Utility.shouldUnit(
                    missionModelType:
                        this.widget.missionModel.missionModelType) ==
                true &&
            this.widget.missionModel.time_mode == 2)
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SliderWithCanvasWidget(
                  shouldOnlyShowSlider: true,
                  onChange: (double value) {
                    this.widget.missionModel?.objectiveValue = value;
                    if ((this.widget.missionModel?.objectiveTotalValue ?? 0) >
                        0) {
                      if ((this.widget.missionModel?.objectiveTotalValue ??
                              0) <=
                          value) {
                        this.widget.missionModel?.isFinished = true;
                      } else {
                        this.widget.missionModel?.isFinished = false;
                      }
                    }
                    funcDebounceWithUpdateSliderVal(this);
                    setState(() {});
                  },
                  min: this.widget.missionModel?.objectiveStartValue ?? 0,
                  max: this.widget.missionModel?.objectiveTotalValue ?? 0,
                  curVal: this.widget.missionModel?.objectiveValue,
                ),
              ),
              Text(
                this.widget.missionModel.objectivePercentString ?? "",
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeManager.getInstance().isDark()
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(width: 5),
              Text(
                "${this.widget.missionModel?.objectiveValue?.toInt() ?? 0}/${this.widget.missionModel?.objectiveTotalValue?.toInt()}",
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeManager.getInstance().isDark()
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              getUnitInputWidgetForObjective(),
            ],
          ),
        if (this.widget.missionModel?.isFinished == false &&
            Utility.shouldShowDoItNow(
                    missionModelType:
                        this.widget.missionModel.missionModelType) ==
                true)
          Row(
            children: [
              Spacer(),
              isDoingItNow
                  ? MissionCountDownTextWidget(
                      fontSize: 12,
                      color: 0xff909090,
                      end_time: this.widget.missionModel?.do_it_now?[0]
                          ['end_time'] as int,
                      end_buffer_time: this.widget.missionModel?.do_it_now?[0]
                          ['buffer_end_time'],
                      isFinished: this.widget.missionModel?.isFinished ?? false,
                    )
                  : InkWell(
                      onTap: () {
                        this.onClick("onClickDoItNow", null);
                      },
                      child: Text(
                        getI18NKey().do_it_now,
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      )),
              SizedBox(width: 8),
            ],
          ),
        if (TextUtil.isEmpty(Utility.getJumpTxt(
                missionModelType: this.widget.missionModel.missionModelType)) ==
            false)
          Row(
            children: [
              Spacer(),
              InkWell(
                  onTap: () {
                    if (this.widget.missionModel.missionModelType == 2) {
                      CounterMethodChannelManager.getInstance().openReminderApp(
                          id: this.widget.missionModel.objectId ?? "");
                    } else if (this.widget.missionModel.missionModelType == 1) {
                      CounterMethodChannelManager.getInstance().openCalendarApp(
                          timestamp: Utility.getTimeStampToday());
                    }
                  },
                  child: Text(
                    getI18NKey().jump_to_xxx(Utility.getJumpTxt(
                        missionModelType:
                            this.widget.missionModel.missionModelType)),
                    style: TextStyle(
                        color: ThemeManager.getInstance().getTextColor(
                            defaultColor: ThemeManager.getInstance()
                                .getTextColor(defaultColor: Colors.blue)),
                        fontSize: 12),
                  )),
            ],
          ),
        SizedBox(height: 10),
        TagsGridViewWidget(
          datas: this.folderModelTags,
          useUnifiedStyle: useUnifiedSettingStyle,
          onTapAddTagListener: (data) {
            if (ChatGroupManager.isFolderModelEnabled(
                    folderId: this.widget.missionModel.folder_id ?? "",
                    uid: LoginManager.getInstance().userBean.uid ?? "") ==
                false) {
              Utility.showToastMsg(
                  context: Utility.getGlobalContext(),
                  msg: getI18NKey().no_auth);
              return null;
            }
            this.onClick('onTapTagListener', data);
          },
          onTapDeleteTagListener: (data) {
            if (ChatGroupManager.isFolderModelEnabled(
                    folderId: this.widget.missionModel.folder_id ?? "",
                    uid: LoginManager.getInstance().userBean.uid ?? "") ==
                false) {
              Utility.showToastMsg(
                  context: Utility.getGlobalContext(),
                  msg: getI18NKey().no_auth);
              return null;
            }
            List<String> tagNamesList =
                this.widget.missionModel?.tagNames?.split(',') ?? [];
            tagNamesList.remove(data.title);
            this.widget.missionModel?.tagNames = tagNamesList.join(',');
            requestGetTags(
                this.widget.missionModel?.tagNames?.split(',') ?? []);
            this.isNeedUpdateBmob = true;
          },
        ),
        if (Utility.shouldShowPriority(
                missionModelType: this.widget.missionModel.missionModelType) ==
            true)
          SizedBox(height: 10),
        if (Utility.shouldShowPriority(
                missionModelType: this.widget.missionModel.missionModelType) ==
            true)
          PriorityButtonListWidget(
            useUnifiedStyle: useUnifiedSettingStyle,
            list: CONSTANTS.getPriorityButtonList(),
            initIndex: this.widget.missionModel.priorityStatus ?? 3,
            onTapListener: (data) {
              int index = data['index'];
              this.onClick("onClickPriority", index);
            },
          ),
      ],
    );
    if (isUnifiedDesktop) {
      return wrapUnifiedSection(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: content,
      );
    }
    return wrapUnifiedSection(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: content,
    );
  }

  List<Widget> getTabBar3WidgetList() {
    // DateTime? dateTimeNextTime = Utility.getNextDateTime(
    //     missionModelParam: this.widget.missionModel ?? MissionModel(),
    //     calendarModel: context.read<GlobalStateEnv>().calendarModel);
    //
    // String repetiveString = CONSTANTS
    //     .getRepetiveDateString1(this.widget.missionModel ?? MissionModel());
    return [
      Expanded(
          child: isUnifiedDesktop
              ? Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TimeLinePage(
                    missionObjectId: this.widget.missionModel.objectId ?? "",
                    folderObjectId: this.folderModel?.objectId ?? "",
                    timelinePageFromEnum:
                        TimelinePageFromEnum.ObjectivePage.index,
                    key: Key("fjijfixz"),
                  ),
                )
              : TimeLinePage(
                  missionObjectId: this.widget.missionModel.objectId ?? "",
                  folderObjectId: this.folderModel?.objectId ?? "",
                  timelinePageFromEnum:
                      TimelinePageFromEnum.ObjectivePage.index,
                  key: Key("fjijfixz"),
                )),
    ];
  }

  List<Widget> getTabBar2WidgetList() {
    DateTime? dateTimeNextTime = Utility.getNextDateTime(
        missionModelParam: this.widget.missionModel ?? MissionModel(),
        calendarModel: context.read<GlobalStateEnv>().calendarModel);

    String repetiveString = CONSTANTS
        .getRepetiveDateString1(this.widget.missionModel ?? MissionModel());
    final List<Widget> settingTiles = [
      if (Utility.shouldShowStartTime(
              missionModelType: this.widget.missionModel.missionModelType) ==
          true)
        MenuItem2(
            useUnifiedStyle: useUnifiedSettingStyle,
            compactUnifiedStyle: useUnifiedSettingStyle,
            width: isUnifiedDesktop ? unifiedTileWidth : null,
            title: (this.widget.missionModel?.repetiveType == 0 ||
                    shouldUseDateTimeSetting)
                ? getI18NKey().start_time
                : getI18NKey().daily_start_time,
            subTitle: "(${getI18NKey().optional})",
            onTapListener: (data) async {
              if (ChatGroupManager.isFolderModelEnabled(
                      folderId: this.widget.missionModel.folder_id ?? "",
                      uid: LoginManager.getInstance().userBean.uid ?? "") ==
                  false) {
                Utility.showToastMsg(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().no_auth);
                return null;
              }
              if (shouldUseDateTimeSetting) {
                DateTimeModel? model =
                    await Utility.showDateTimePickerDialog(context);
                updateAlertTime();
                this.setState(() {
                  this.isNeedUpdateBmob = true;
                  this.widget.missionModel?.start_time =
                      model?.datetime?.millisecondsSinceEpoch ?? 0;
                });
              } else {
                TimeOfDay? timeOfDay =
                    await Utility.showTimePickerDialog(context);
                if (timeOfDay == null) {
                  return;
                }
                int startTime = timeOfDay.hour * 60 * 60 * 1000 +
                    timeOfDay.minute * 60 * 1000;
                if (this.widget.missionModel?.daily_end_time != null &&
                    (this.widget.missionModel?.daily_end_time ?? 0) <
                        startTime) {
                  Utility.showToastMsg(
                      context: context,
                      msg: getI18NKey().end_time_cannot_before_start_time);
                  this.widget.missionModel?.daily_end_time = null;
                  return;
                }
                this.widget.missionModel?.daily_start_time = startTime;
                updateAlertTime();
              }
              this.setState(() {
                this.isNeedUpdateBmob = true;
              });
            },
            rightPartContainer: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    shouldUseDateTimeSetting
                        ? CONSTANTS.getAlertDateString(
                            Utility.getDateTimeModelFromTimeStamp(
                                this.widget.missionModel?.start_time ?? 0))
                        : TextUtil.isEmpty(this
                                    .widget
                                    .missionModel
                                    ?.daily_start_time) ==
                                false
                            ? Utility.formatHourAndMin2(
                                this.widget.missionModel?.daily_start_time ?? 0)
                            : getI18NKey().none,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: isUnifiedDesktop ? 13 : 15,
                        color: ColorsConfig.gray_a3_icon),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                  icon: Icon(Icons.cancel,
                      size: 18, color: ColorsConfig.gray_cc_cancel),
                  onPressed: () {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel?.daily_start_time = 0;
                    this.widget.missionModel?.start_time = null;
                    this.updateUI();
                  },
                )
              ],
            ),
            icon: Utility.getSVGPicture(R.assetsImgIcStarttimeOrange,
                size: StylesConfig.iconSize)),
      if (Utility.shouldShowEndTime(
              missionModelType: this.widget.missionModel.missionModelType) ==
          true)
        MenuItem2(
            useUnifiedStyle: useUnifiedSettingStyle,
            compactUnifiedStyle: useUnifiedSettingStyle,
            width: isUnifiedDesktop ? unifiedTileWidth : null,
            title: (this.widget.missionModel?.repetiveType == 0 ||
                    shouldUseDateTimeSetting)
                ? getI18NKey().end_time
                : getI18NKey().daily_end_time,
            subTitle: this.widget.missionModel.repetiveType == 1
                ? ""
                : "(${getI18NKey().optional})",
            onTapListener: (data) async {
              if (ChatGroupManager.isFolderModelEnabled(
                      folderId: this.widget.missionModel.folder_id ?? "",
                      uid: LoginManager.getInstance().userBean.uid ?? "") ==
                  false) {
                Utility.showToastMsg(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().no_auth);
                return null;
              }
              if (shouldUseDateTimeSetting) {
                if (this.widget.missionModel?.start_time == null) {
                  Utility.showToastMsg(
                      context: context,
                      msg: getI18NKey().please_select_daily_start_time);
                  return;
                }
                DateTimeModel? model =
                    await Utility.showDateTimePickerDialog(context);
                if ((model?.datetime?.millisecondsSinceEpoch ?? 0) <
                    (this.widget.missionModel?.start_time ?? 0)) {
                  Utility.showToastMsg(
                      context: context,
                      msg: getI18NKey().end_time_cannot_before_start_time);
                  this.widget.missionModel?.end_time = null;
                  return;
                }
                this.setState(() {
                  this.isNeedUpdateBmob = true;
                  this.widget.missionModel?.end_time =
                      model?.datetime?.millisecondsSinceEpoch ?? 0;
                });
              } else {
                if (this.widget.missionModel?.daily_start_time == null) {
                  Utility.showToastMsg(
                      context: context,
                      msg: getI18NKey().please_select_daily_start_time);
                  return;
                }
                TimeOfDay? timeOfDay =
                    await Utility.showTimePickerDialog(context);
                if (timeOfDay == null) {
                  return;
                }
                int endTime = timeOfDay.hour * 60 * 60 * 1000 +
                    timeOfDay.minute * 60 * 1000;
                if (endTime <
                    (this.widget.missionModel?.daily_start_time ?? 0)) {
                  Utility.showToastMsg(
                      context: context,
                      msg: getI18NKey().end_time_cannot_before_start_time);
                  this.widget.missionModel?.daily_end_time = null;
                  return;
                }
                this.widget.missionModel?.daily_end_time = endTime;
              }
              this.setState(() {
                this.isNeedUpdateBmob = true;
              });
            },
            rightPartContainer: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    shouldUseDateTimeSetting
                        ? CONSTANTS.getAlertDateString(
                            Utility.getDateTimeModelFromTimeStamp(
                                this.widget.missionModel?.end_time ?? 0))
                        : TextUtil.isEmpty(
                                    this.widget.missionModel?.daily_end_time) ==
                                false
                            ? Utility.formatHourAndMin2(
                                this.widget.missionModel?.daily_end_time ?? 0)
                            : getI18NKey().none,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: isUnifiedDesktop ? 13 : 15,
                        color: ColorsConfig.gray_a3_icon),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                  icon: Icon(Icons.cancel,
                      size: 18, color: ColorsConfig.gray_cc_cancel),
                  onPressed: () {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel?.end_time = 0;
                    this.widget.missionModel?.daily_end_time = 0;
                    this.updateUI();
                  },
                )
              ],
            ),
            icon: Utility.getSVGPicture(R.assetsImgIcEndtimeOrange,
                size: StylesConfig.iconSize)),
      if (Utility.shouldShowCircleFolderId(
              missionModelType: this.widget.missionModel.missionModelType) ==
          true)
        MenuItem2(
            useUnifiedStyle: useUnifiedSettingStyle,
            compactUnifiedStyle: useUnifiedSettingStyle,
            width: isUnifiedDesktop ? unifiedTileWidth : null,
            title: getI18NKey().mission,
            subTitle: this.widget.missionModel.repetiveType == 1
                ? ""
                : getI18NKey().optional_with_parenthese,
            onTapListener: (data) async {
              this.onClick('onTapCircleListener', data);
            },
            rightPartContainer: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    this.folderModel != null && this.folderModel?.title != null
                        ? (this.folderModel?.title ?? "")
                        : getI18NKey().none,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: isUnifiedDesktop ? 13 : 15,
                        color: this.folderModel != null &&
                                this.folderModel?.color != null
                            ? Color(this.folderModel?.color ?? 0xffff8800)
                            : ColorsConfig.gray_a3_icon),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                  icon: Icon(Icons.cancel,
                      size: 18, color: ColorsConfig.gray_cc_cancel),
                  onPressed: () {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel?.alert_time = 0;
                    this.updateUI();
                  },
                )
              ],
            ),
            icon: folderModel?.icon != null
                ? Icon(
                    IconData(folderModel?.icon ?? 0,
                        fontFamily: 'MaterialIcons'),
                    size: 16,
                    color: folderModel?.icon != null
                        ? Color(folderModel?.color ?? 0)
                        : ColorsConfig.gray_a3_icon)
                : Utility.getSVGPicture(R.assetsImgIcFolderOrange,
                    size: StylesConfig.iconSize)),
      if (Utility.shouldShowTomatoes(
              missionModelType: this.widget.missionModel.missionModelType) ==
          true)
        this.widget.missionModel?.isFinished == true
            ? const SizedBox.shrink()
            : MenuItem2(
                useUnifiedStyle: useUnifiedSettingStyle,
                compactUnifiedStyle: useUnifiedSettingStyle,
                width: isUnifiedDesktop ? unifiedTileWidth : null,
                title: getI18NKey().tomatoNums,
                subTitle: getI18NKey().tomatoNums3,
                onTapListener: (data) {
                  this.onClick('onClickSelectTomatoes', null);
                },
                rightPartContainer: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingBar(
                      curNumber:
                          this.widget.missionModel?.no_tomotoes_finished ?? 0,
                      number: this.widget.missionModel?.total_tomotoes ?? 0,
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Utility.getSVGPicture(R.assetsImgIcTomatoChecked,
                            size: 15),
                        Text(
                          "=" +
                              CONSTANTS.getDurationString(
                                  this.widget.missionModel ?? MissionModel()),
                          style: TextStyle(
                              fontSize: 12, color: ColorsConfig.gray_a3_icon),
                        ),
                      ],
                    )
                  ],
                ),
                icon: Utility.getSVGPicture(R.assetsImgIcFocusOrange,
                    size: StylesConfig.iconSize)),
      (this.widget.missionModel?.isFinished == true ||
              this.widget.missionModel?.time_mode == 1)
          ? const SizedBox.shrink()
          : MenuItem2(
              useUnifiedStyle: useUnifiedSettingStyle,
              compactUnifiedStyle: useUnifiedSettingStyle,
              width: isUnifiedDesktop ? unifiedTileWidth : null,
              title: getI18NKey().deadLine,
              onTapListener: (data) async {
                if (ChatGroupManager.isFolderModelEnabled(
                        folderId: this.widget.missionModel.folder_id ?? "",
                        uid: LoginManager.getInstance().userBean.uid ?? "") ==
                    false) {
                  Utility.showToastMsg(
                      context: Utility.getGlobalContext(),
                      msg: getI18NKey().no_auth);
                  return null;
                }
                DateTimeModel? model = await Utility.showDatePickerDialog(
                    context, this.widget.missionModel?.end_time ?? 0);
                this.setState(() {
                  this.isNeedUpdateBmob = true;
                  this.widget.missionModel?.end_time =
                      model?.datetime?.millisecondsSinceEpoch ?? 0;
                });
              },
              rightPartContainer: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      TextUtil.isEmpty(this.widget.missionModel?.end_time) ==
                              false
                          ? CONSTANTS.getWeekDayString(
                              Utility.getDateTimeModelFromTimeStamp(
                                  this.widget.missionModel?.end_time ?? 0))
                          : getI18NKey().none,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: isUnifiedDesktop ? 13 : 15,
                          color: ColorsConfig.gray_cc_cancel),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 28, minHeight: 28),
                    icon: Icon(Icons.cancel,
                        size: 18, color: ColorsConfig.gray_cc_cancel),
                    onPressed: () {
                      this.isNeedUpdateBmob = true;
                      this.widget.missionModel?.end_time = null;
                      this.updateUI();
                    },
                  )
                ],
              ),
              icon: Utility.getSVGPicture(R.assetsImgIcEndtime2Orange,
                  size: StylesConfig.iconSize)),
      (this.widget.missionModel?.isFinished == true)
          ? const SizedBox.shrink()
          : (!Utility.shouldShowAlert(
                  missionModelType: this.widget.missionModel?.missionModelType))
              ? const SizedBox.shrink()
              : MenuItem2(
                  useUnifiedStyle: useUnifiedSettingStyle,
                  compactUnifiedStyle: useUnifiedSettingStyle,
                  width: isUnifiedDesktop ? unifiedTileWidth : null,
                  title: getI18NKey().alert,
                  subTitle: "(${getI18NKey().optional})",
                  onTapListener: (data) async {
                    if (ChatGroupManager.isFolderModelEnabled(
                            folderId: this.widget.missionModel.folder_id ?? "",
                            uid: LoginManager.getInstance().userBean.uid ??
                                "") ==
                        false) {
                      Utility.showToastMsg(
                          context: Utility.getGlobalContext(),
                          msg: getI18NKey().no_auth);
                      return null;
                    }
                    DateTimeModel? model;
                    if (this.widget.missionModel?.repetiveType == 0) {
                      model = await Utility.showDateTimePickerDialog(context);
                      if (model == null) {
                        return;
                      }
                      this.widget.missionModel?.alert_time = model.timestamp;
                    } else {
                      TimeOfDay? timeOfDay =
                          await Utility.showTimePickerDialog(context);
                      if (timeOfDay == null) {
                        return;
                      }
                      this.widget.missionModel?.alert_time =
                          timeOfDay.hour * 60 * 60 * 1000 +
                              timeOfDay.minute * 60 * 1000;
                    }
                    this.setState(() {
                      this.isNeedUpdateBmob = true;
                    });
                    Utility.requestNotification(context);
                  },
                  rightPartContainer: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          TextUtil.isEmpty(this
                                      .widget
                                      .missionModel
                                      ?.alert_time) ==
                                  false
                              ? (this.widget.missionModel?.repetiveType == 0
                                  ? CONSTANTS.getAlertDateString(
                                      Utility.getDateTimeModelFromTimeStamp(
                                          this
                                                  .widget
                                                  .missionModel
                                                  ?.alert_time ??
                                              0))
                                  : Utility
                                      .getHourAndMinsFromDateTimeFromTimeStamp(
                                          this
                                                  .widget
                                                  .missionModel
                                                  ?.alert_time ??
                                              0))
                              : getI18NKey().none,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: isUnifiedDesktop ? 13 : 15,
                              color: ColorsConfig.gray_a3_icon),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 28, minHeight: 28),
                        icon: Icon(Icons.cancel,
                            size: 18, color: ColorsConfig.gray_cc_cancel),
                        onPressed: () {
                          this.isNeedUpdateBmob = true;
                          this.widget.missionModel?.alert_time = 0;
                          this.updateUI();
                        },
                      )
                    ],
                  ),
                  icon: Utility.getSVGPicture(R.assetsImgIcAlarmOrange,
                      size: StylesConfig.iconSize)),
      if (this.widget.missionModel?.time_mode == 0)
        this.widget.missionModel?.isFinished == true
            ? const SizedBox.shrink()
            : MenuItem2(
                useUnifiedStyle: useUnifiedSettingStyle,
                compactUnifiedStyle: useUnifiedSettingStyle,
                width: isUnifiedDesktop ? unifiedTileWidth : null,
                title: getI18NKey().repetive,
                subTitle: "(${getI18NKey().optional})",
                onTapListener: (data) {
                  if (ChatGroupManager.isFolderModelEnabled(
                          folderId: this.widget.missionModel.folder_id ?? "",
                          uid: LoginManager.getInstance().userBean.uid ?? "") ==
                      false) {
                    Utility.showToastMsg(
                        context: Utility.getGlobalContext(),
                        msg: getI18NKey().no_auth);
                    return null;
                  }
                  SelectDatePeriodDialogUtil.show(context, okCallBack:
                      (valueMiddleSelected, valueRightSelected,
                          listCheckModels) {
                    this.isNeedUpdateBmob = true;
                    this.widget.missionModel?.repetiveValue =
                        valueMiddleSelected;
                    if (this.widget.missionModel?.repetiveType !=
                        valueRightSelected) {
                      this.widget.missionModel?.alert_time = 0;
                    }
                    this.widget.missionModel?.repetiveType = valueRightSelected;
                    if (this.widget.missionModel?.repetiveWeekDay == null ||
                        this.widget.missionModel?.repetiveWeekDay?.length ==
                            0) {
                      this.widget.missionModel?.repetiveWeekDay = [
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                        false,
                      ];
                    }
                    if (listCheckModels.length > 5) {
                      this.widget.missionModel?.repetiveWeekDay?[0] =
                          listCheckModels[0].isChecked;
                      this.widget.missionModel?.repetiveWeekDay?[1] =
                          listCheckModels[1].isChecked;
                      this.widget.missionModel?.repetiveWeekDay?[2] =
                          listCheckModels[2].isChecked;
                      this.widget.missionModel?.repetiveWeekDay?[3] =
                          listCheckModels[3].isChecked;
                      this.widget.missionModel?.repetiveWeekDay?[4] =
                          listCheckModels[4].isChecked;
                      this.widget.missionModel?.repetiveWeekDay?[5] =
                          listCheckModels[5].isChecked;
                      this.widget.missionModel?.repetiveWeekDay?[6] =
                          listCheckModels[6].isChecked;
                      this.isNeedUpdateBmob = true;
                    }
                    updateAlertTime();
                    updateUI();
                  });
                },
                rightPartContainer: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: isUnifiedDesktop ? 118 : 160,
                              child: Text.rich(
                                TextSpan(
                                  text: repetiveString,
                                  style: TextStyle(
                                      fontSize: isUnifiedDesktop ? 13 : 14,
                                      color: ColorsConfig.gray_cc_cancel),
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            dateTimeNextTime == null
                                ? const SizedBox.shrink()
                                : Text(
                                    CONSTANTS.getRepetiveDateString2(
                                        dateTimeNextTime),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorsConfig.gray_a3_icon),
                                  ),
                          ]),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 28, minHeight: 28),
                      icon: Icon(Icons.cancel,
                          size: 18, color: ColorsConfig.gray_cc_cancel),
                      onPressed: () {
                        resetRepeativeValue();
                      },
                    )
                  ],
                ),
                icon: Utility.getSVGPicture(R.assetsImgIcRepeativeOrange,
                    size: StylesConfig.iconSize)),
    ];

    final bool shouldShowWallpaper = Utility.shouldShowWallpaper(
        missionModelType: this.widget.missionModel.missionModelType);

    if (isUnifiedDesktop) {
      return [
        buildDesktopTaskSettingsHeader(),
        if (shouldShowWallpaper) ...[
          SectionTitleWidget(
            title: getI18NKey().background_setting,
            useUnifiedStyle: true,
          ),
          buildBackgroundPreviewWidget(),
        ],
        SectionTitleWidget(
          title: getI18NKey().tag,
          useUnifiedStyle: true,
        ),
        wrapUnifiedSection(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: TagsGridViewWidget(
            datas: this.folderModelTags,
            useUnifiedStyle: true,
            onTapAddTagListener: (data) {
              if (ChatGroupManager.isFolderModelEnabled(
                      folderId: this.widget.missionModel.folder_id ?? "",
                      uid: LoginManager.getInstance().userBean.uid ?? "") ==
                  false) {
                Utility.showToastMsg(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().no_auth);
                return null;
              }
              this.onClick('onTapTagListener', data);
            },
            onTapDeleteTagListener: (data) {
              if (ChatGroupManager.isFolderModelEnabled(
                      folderId: this.widget.missionModel.folder_id ?? "",
                      uid: LoginManager.getInstance().userBean.uid ?? "") ==
                  false) {
                Utility.showToastMsg(
                    context: Utility.getGlobalContext(),
                    msg: getI18NKey().no_auth);
                return null;
              }
              List<String> tagNamesList =
                  this.widget.missionModel?.tagNames?.split(',') ?? [];
              tagNamesList.remove(data.title);
              this.widget.missionModel?.tagNames = tagNamesList.join(',');
              requestGetTags(
                  this.widget.missionModel?.tagNames?.split(',') ?? []);
              this.isNeedUpdateBmob = true;
            },
          ),
        ),
        if (Utility.shouldShowPriority(
                missionModelType: this.widget.missionModel.missionModelType) ==
            true) ...[
          SectionTitleWidget(
            title: getI18NKey().priority,
            useUnifiedStyle: true,
          ),
          wrapUnifiedSection(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: PriorityButtonListWidget(
              useUnifiedStyle: true,
              list: CONSTANTS.getPriorityButtonList(),
              initIndex: this.widget.missionModel.priorityStatus ?? 3,
              onTapListener: (data) {
                int index = data['index'];
                this.onClick("onClickPriority", index);
              },
            ),
          ),
        ],
        SectionTitleWidget(
          title: getI18NKey().setting,
          useUnifiedStyle: true,
        ),
        buildDesktopSettingsGrid(settingTiles),
        const SizedBox(height: 20),
      ];
    }

    final List<Widget> widgets = [];

    if (shouldShowWallpaper) {
      widgets.add(SectionTitleWidget(
        title: getI18NKey().background_setting,
        useUnifiedStyle: useUnifiedSettingStyle,
      ));
      widgets.add(buildBackgroundPreviewWidget());
    }

    if (!isUnifiedDesktop) {
      widgets.add(SectionTitleWidget(
        title: getI18NKey().setting,
        useUnifiedStyle: useUnifiedSettingStyle,
        child: (this.widget.missionModel.missionModelType == 1 ||
                this.widget.missionModel.missionModelType == 2)
            ? null
            : BlackCheckButtonListWidget(
                initIndex: this.widget.missionModel.time_mode,
                backgroundColor: ColorsConfig.gray_40,
                useUnifiedStyle: useUnifiedSettingStyle,
                list: CONSTANTS.getSettingItemDetailCheckButtonList(
                    defaultVal: this.widget.missionModel.time_mode ?? 0),
                onTapListener: (index) async {
                  this.widget.missionModel.time_mode = index;
                  this.widget.missionModel?.end_time = 0;
                  this.widget.missionModel?.start_time = 0;
                  setState(() {});
                },
              ),
      ));
    }

    widgets.add(buildDesktopSettingsGrid(settingTiles));
    widgets.add(const SizedBox(height: 20));
    return widgets;
  }

  void resetRepeativeValue() {
    this.isNeedUpdateBmob = true;
    if (this.widget.missionModel?.repetiveValue != null) {
      this.widget.missionModel?.alert_time = 0;
    }
    this.widget.missionModel?.repetiveValue = null;
    this.widget.missionModel?.repetiveType = 0;
    this.widget.missionModel?.repetiveWeekDay = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    this.isNeedUpdateBmob = true;
    // requestMongoDbUpdateData();
    this.updateUI();
  }

  // List<Widget> getTabBarRichWWidgetList() {
  //   return [
  //   ];
  // }

  List<Widget> getTabBar0WidgetList() {
    return [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: isUnifiedDesktop ? 12 : 0),
          child: ComposedRichEditorWidget(
            key: composedRichEditorWidgetGlobalKey,
            title: getI18NKey().note_plain,
            onTapOk: () {},
            // 移动端设置页已经有暖色外壳，编辑器主体透出外层背景，避免出现一整块突兀白底。
            editorBackgroundColor: isUnifiedMobile ? Colors.transparent : null,
            missionModel: this.widget.missionModel,
            saveModeEnum: SaveModeEnum.normal,
          ),
        ),
      ),
      // getSubmissionListWidget(),
    ];
  }

  List<Widget> getTabBar1WidgetList() {
    return [
      SectionTitleWidget(
          title: getI18NKey().sub_task_add_newline,
          useUnifiedStyle: useUnifiedSettingStyle,
          child: InkWell(
              onTap: () {
                submissionSliverListStateGlobalKey?.currentState?.addItem();
              },
              child: Icon(
                Icons.add,
                color: ColorsConfig.addBlueColor,
              ))),
      getSubmissionListWidget(),
    ];
  }

  /**
   * 更新alert_time
   * 日期和目标模式直接使用完整开始时间作为提醒基准。
   * 时间段模式如果不重复，则用日期到期日叠加每日开始时间；重复任务只保留每日开始时间。
   */
  void updateAlertTime() {
    if (shouldUseDateTimeSetting) {
      this.widget.missionModel?.alert_time =
          (this.widget.missionModel?.start_time ?? 0);
    } else {
      if (this.widget.missionModel?.repetiveType == 0 &&
          this.widget.missionModel?.end_time != null) {
        this.widget.missionModel?.alert_time =
            (this.widget.missionModel?.daily_start_time ?? 0) +
                (this.widget.missionModel?.end_time ?? 0);
      } else {
        this.widget.missionModel?.alert_time =
            (this.widget.missionModel?.daily_start_time ?? 0);
      }
    }
  }

  /**
   * 功能：构建子任务列表区域。
   * 说明：统一样式下把子任务列表放进卡片，避免移动端子任务页和任务设置页视觉断层。
   */
  Container getSubmissionListWidget() {
    return Container(
      decoration: BoxDecoration(
          color: useUnifiedSettingStyle
              ? Colors.transparent
              : ThemeManager.getInstance()
                  .getBackgroundColor(defaultColor: Colors.white)),
      constraints: BoxConstraints(maxHeight: 320),
      child: useUnifiedSettingStyle
          ? wrapUnifiedSection(
              padding: EdgeInsets.zero,
              child: SubmissionSliverList(
                key: submissionSliverListStateGlobalKey,
                missionModel: this.widget.missionModel,
                onChange: (MissionModel val) {
                  this.widget.missionModel.subMissionModels =
                      val.subMissionModels;
                },
              ),
            )
          : SubmissionSliverList(
              key: submissionSliverListStateGlobalKey,
              missionModel: this.widget.missionModel,
              onChange: (MissionModel val) {
                this.widget.missionModel.subMissionModels =
                    val.subMissionModels;
              },
            ),
    );
  }

  /**
   * 功能：构建任务背景图设置项。
   * 说明：移动端复用 PC 的预览卡片，但压缩图片预览尺寸，保证单手滚动时仍能快速识别当前壁纸。
   */
  Container getBgSettingItem({ImageProvider<Object>? imageProviderTmp}) {
    if (useUnifiedSettingStyle) {
      return Container(
        margin: EdgeInsets.fromLTRB(
          isUnifiedMobile ? 14 : 0,
          isUnifiedMobile ? 8 : 0,
          isUnifiedMobile ? 14 : 0,
          8,
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: buildUnifiedDesktopCardDecoration(
          backgroundColor: detailSectionBackground,
          borderRadius: BorderRadius.circular(isUnifiedMobile ? 20 : 22),
          border: Border.all(color: detailBorderColor),
          boxShadow: const [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: isUnifiedMobile ? 118 : 164,
              height: isUnifiedMobile ? 78 : 94,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: imageProviderTmp == null
                    ? null
                    : DecorationImage(
                        image: imageProviderTmp,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            ThemeManager.getInstance()
                                .getBackgroundColor(defaultColor: Colors.white),
                            BlendMode.colorBurn),
                      ),
                color: const Color(0xFFF5E9DB),
              ),
              alignment: Alignment.center,
              child: imageProviderTmp == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 18,
                          color: detailSubColor,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          getI18NKey().none,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: detailSubColor,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getI18NKey().background_setting,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: detailTitleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    imageProviderTmp == null
                        ? getI18NKey().change_background
                        : getI18NKey().background,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: detailSubColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildHeaderActionChip(
                    onTap: () {
                      DialogManagement.getInstance().showSelectBgDialog(context,
                          list: ResourceInfo
                                  .missionItemBackgroundLocationInfoBean
                                  ?.deliveryList ??
                              [], onTapListener: (String imgUrl) {
                        this.widget.missionModel?.background_url = imgUrl;
                        this.isNeedUpdateBmob = true;
                        updateUI();
                        DialogManagement.getInstance().hideDialog(context);
                      });
                    },
                    child: Text(
                      getI18NKey().change_bg,
                      style: TextStyle(
                        color: detailSubColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
    return Container(
        height: 40,
        decoration: BoxDecoration(
          image: imageProviderTmp == null
              ? null
              : DecorationImage(
                  image: imageProviderTmp,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      ThemeManager.getInstance()
                          .getBackgroundColor(defaultColor: Colors.white),
                      BlendMode.colorBurn)),
        ),
        // color: Colors.white,
        child: Container(
          color: ThemeManager.getInstance().getCardBackgroundColor(
              defaultColor: Color(0xa0ffffff), alpha: 150),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...getBarWidget(),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ));
  }

  void onClickSelectTomatoes(BuildContext context) {
    SelectTomatoesDialogUtil.show(context,
        numTomatoes: (this.widget.missionModel?.total_tomotoes ?? 0) - 1,
        duration: this.widget.missionModel?.tomato_duration != null
            ? ((this.widget.missionModel?.tomato_duration ?? 0) / (60 * 1000) -
                    1)
                .toInt()
            : 25, okCallBack: (numTomatoes, duration) {
      this.widget.missionModel?.tomato_duration = (duration + 1) * 60 * 1000;
      this.widget.missionModel?.total_tomotoes = numTomatoes + 1;
      this.isNeedUpdateBmob = true;
      updateUI();
    });
  }

  Future onClickUpdate() async {
    MongoDbUpdated? mongoDbUpdated;
    if (isInlineEditingTitle && !syncInlineTitleTextToMission()) {
      return;
    }
    if (mounted) {
      setState(() {
        isSaving = true;
      });
    }
    try {
      if (this.widget.popOkCallback == null) {
        this.widget.missionModel?.message = controller?.text;
        mongoDbUpdated = await requestMongoDbUpdateData();
      } else {
        this.widget.popOkCallback!(this.widget.missionModel);
      }
      if (mongoDbUpdated != null) {
        if (Utility.isHandsetBySize()) {
          Utility.popNavigator(context, null);
        } else {
          Utility.popupDesktopRightNavigator(context);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  onClickUnfinishItem(data) async {
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
    updateUI();
  }

  /**
   * 点击完成任务
   */
  Future onClickFinishItem(data) async {
    bool didFinish =
        await MongoApisManager.getInstance().handleFinishMissionModel(
      missionModel: data,
      context: context,
    );
    if (!didFinish) {
      return;
    }
    if (!TextUtil.isEmpty(this.widget.missionModel.objectId)) {
      if (Utility.isHandsetBySize()) {
        Utility.popNavigator(context, this.widget.missionModel);
      } else {
        Utility.popupDesktopRightNavigator(context);
      }
    } else {
      NavigatorManager.getInstance().popupSettingItemDetailPage(context,
          missionModel: this.widget.missionModel);
    }
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  SuggestionsController<SuggestionBean> suggestionsController =
      SuggestionsController();
  TextEditingController? inputController;
  FocusNode? _contentFocusNode = FocusNode();
  String? value = "";

  getUnitInputWidgetForObjective({String placeholder = ""}) {
    List<SuggestionBean> listSuggestionBean =
        MongoApisManager.getInstance().getSuggestionBeans();
    inputController = TextEditingController();
    inputController!.text = this.widget.missionModel.objectiveUnit ?? '';
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TypeAheadField<SuggestionBean>(
          // controller: controller,
          suggestionsController: suggestionsController,
          hideOnEmpty: true,
          autoFlipDirection: true,
          onSelected: (value) {
            inputController!.text = value.suggestionContent ?? '';
            this.widget.missionModel.objectiveUnit =
                value.suggestionContent ?? '';
            // this.widget.onChangeTotalValAndUnit?.call(this.objectiveTotalValue, this.objectiveUnit);

            // this.widget.onClickSendMsg(inputController.text);
            // inputController.text = '';
          },
          itemBuilder: (BuildContext context, SuggestionBean? value) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              color: ThemeManager.getInstance().getCardBackgroundColor(),
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(minHeight: 40),
              child: Text(value?.suggestion ?? ""),
            );
          },
          suggestionsCallback: (search) {
            if (TextUtil.isEmpty(search)) {
              return listSuggestionBean;
            }
            List<SuggestionBean> listReturns = [];
            for (var item in listSuggestionBean ?? []) {
              if (item.suggestion
                      ?.toLowerCase()
                      .contains(search.toLowerCase()) ==
                  true) {
                listReturns.add(item);
              }
            }
            return listReturns;
          },
          builder: (context, controller, focusNode) {
            return Container(
              height: 25,
              width: 60,
              child: TextField(
                focusNode: _contentFocusNode = focusNode,
                controller: inputController = controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (val) {
                  // callback for regular enter key press
                  // this.widget.onClickSendMsg(
                  //     inputController.text);
                  inputController!.text = '';
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), // 限制最大输入长度为500字符
                ],
                // enabled: this.isLoading2 == 0,
                // focusNode: _contentFocusNode = focusNode,
                // controller: inputController = controller,
                // textInputAction: TextInputAction.done,
                // onSubmitted: (val) {
                //   // callback for regular enter key press
                //   // this.widget.onClickSendMsg(
                //   //     inputController.text);
                //   inputController.text = '';
                // },
                onEditingComplete: () {
                  final isCtrlPressed = RawKeyboard.instance.keysPressed
                      .contains(LogicalKeyboardKey.controlLeft);
                  if (isCtrlPressed) {
                    // insert a new line character
                    inputController!.value = TextEditingValue(
                      text: inputController!.text + '\n',
                      selection: TextSelection.collapsed(
                          offset: inputController!.text.length + 1),
                    );
                  } else {
                    // trigger the callback for regular enter key press
                    // this.onClickSendMsg(inputController.text);
                  }
                },
                scrollController: ScrollController(),
                onChanged: (val) {
                  this.value = val;
                  this.widget.missionModel.objectiveUnit = val;
                  // this.objectiveUnit = val;
                  // this.widget.onChangeTotalValAndUnit?.call(this.objectiveTotalValue, this.objectiveUnit);
                },
                // keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // suffixIcon: Align(
                  //   alignment: Alignment.centerRight,
                  //   widthFactor: 1.0,
                  //   child: CheckImage(
                  //     //显示隐藏密码的眼睛
                  //     onTapListener: (isChecked) {
                  //       checkedPassword1 = !isChecked;
                  //       setState(() {});
                  //       ;
                  //     },
                  //     checked: checkedPassword1,
                  //     autoCheck: true,
                  //     checkIcon:
                  //     Utility.getSVGPicture(R.assetsImgIcEyeSlash, size: 20),
                  //     uncheckIcon:
                  //     Utility.getSVGPicture(R.assetsImgIcEyeClose, size: 20),
                  //   ),
                  // ),
                  filled: true,
                  fillColor:
                      ThemeManager.getInstance().getInputDecorationColor(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: getI18NKey().unit,
                  hintStyle: TextStyle(
                      color:
                          ThemeManager.getInstance().getInputPlaceholderColor(),
                      fontSize: 11),
                ),
                // onChanged: (value) => _checkPasswordMatch(),
              ),
            );
            // return Container(
            //   height: 25,
            //   width: 80,
            //   child: TextField(
            //     inputFormatters: [
            //       LengthLimitingTextInputFormatter(
            //           10), // 限制最大输入长度为500字符
            //     ],
            //     // enabled: this.isLoading2 == 0,
            //     focusNode: _contentFocusNode = focusNode,
            //     controller: inputController = controller,
            //     textInputAction: TextInputAction.done,
            //     onSubmitted: (val) {
            //       // callback for regular enter key press
            //       // this.widget.onClickSendMsg(
            //       //     inputController.text);
            //       inputController.text = '';
            //     },
            //     onEditingComplete: () {
            //       final isCtrlPressed = RawKeyboard
            //           .instance.keysPressed
            //           .contains(
            //           LogicalKeyboardKey.controlLeft);
            //       if (isCtrlPressed) {
            //         // insert a new line character
            //         inputController.value =
            //             TextEditingValue(
            //               text: inputController.text + '\n',
            //               selection: TextSelection.collapsed(
            //                   offset: inputController
            //                       .text.length +
            //                       1),
            //             );
            //       } else {
            //         // trigger the callback for regular enter key press
            //         // this.onClickSendMsg(inputController.text);
            //       }
            //     },
            //     scrollController: ScrollController(),
            //     onChanged: (val) {
            //       this.value = val;
            //     },
            //     // keyboardType: TextInputType.number,
            //     // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //     decoration: InputDecoration(
            //       // suffixIcon: Align(
            //       //   alignment: Alignment.centerRight,
            //       //   widthFactor: 1.0,
            //       //   child: CheckImage(
            //       //     //显示隐藏密码的眼睛
            //       //     onTapListener: (isChecked) {
            //       //       checkedPassword1 = !isChecked;
            //       //       setState(() {});
            //       //       ;
            //       //     },
            //       //     checked: checkedPassword1,
            //       //     autoCheck: true,
            //       //     checkIcon:
            //       //     Utility.getSVGPicture(R.assetsImgIcEyeSlash, size: 20),
            //       //     uncheckIcon:
            //       //     Utility.getSVGPicture(R.assetsImgIcEyeClose, size: 20),
            //       //   ),
            //       // ),
            //       filled: true,
            //       fillColor: ThemeManager.getInstance().getInputDecorationColor(),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30.0),
            //         borderSide: BorderSide.none,
            //       ),
            //       // hintText: getI18NKey().unit,
            //       hintStyle: TextStyle(
            //           color: ThemeManager.getInstance().getInputPlaceholderColor(),
            //           fontSize: 10),
            //     ),
            //     // onChanged: (value) => _checkPasswordMatch(),
            //   ),
            // );
          },
        ),
      ],
    );
  }

  Function funcDebounceWithUpdateSliderVal =
      Utility.debounceWith((_SettingItemDetailPageWidgetState state) async {
    // state.isLoading = true;
    // state.tmpMissionModel?.objectiveValue = value;
    // print("value:$value");
    MongoApisManager.getInstance().update_MissionModel(
        shouldUpdateLog: false,
        missionModel: state.widget.missionModel ?? MissionModel());

    MongoApisManager.getInstance().insertTimelineMissionModel(
        shouldQueryMissionModel: false,
        missionModel: Utility.getTimelineMissionModelFromMissionModel(
            icon: Icons.check_circle.codePoint,
            color: Colors.greenAccent.value,
            sceneType: "mission",
            eventType: "realize_mission",
            mission_id: state.widget.missionModel?.objectId,
            folder_id: state.widget.missionModel?.folder_id,
            timelineMessage: getI18NKey().realize_percent(
                state.widget.missionModel?.title ?? "?",
                state.widget.missionModel?.objectivePercentString ?? "")));
  }, Duration(milliseconds: 3000));

  /**
   * 点击选择优先级
   */
  Future onTapPriority(int priority) async {
    this.widget.missionModel.priorityStatus = priority;
  }

  /**
   * 获取优先级Icon
   */
  Widget? getPriorityIcon(missionModel, {double iconSize = 30}) {
    int priorityStatus = missionModel?.priorityStatus ?? 3;
    return CONSTANTS.getPriorityModels(iconSize: iconSize)[priorityStatus].icon;
  }
}
