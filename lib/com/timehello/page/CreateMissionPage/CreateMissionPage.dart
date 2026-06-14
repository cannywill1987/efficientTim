// ignore_for_file: must_be_immutable, must_call_super, invalid_null_aware_operator, deprecated_member_use, unused_local_variable, unused_field, unnecessary_non_null_assertion, dead_null_aware_expression

/**
 * 文件类型：页面
 * 文件作用：创建或编辑任务时承载标题、标签、优先级、时间、清单、番茄数等配置项。
 * 主要职责：维护任务编辑状态，串联选择弹窗、保存接口与桌面端创建任务页面的视觉呈现。
 */
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/PriorityButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/SectionTitleWidget.dart';
import 'package:time_hello/com/timehello/components/SelectDatePeriodDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectTagDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectTomatoesDialogUtil.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbUpdated.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import '../../../../r.dart';
import '../../beans/BaseBean.dart';
import '../../beans/SuggestionBean.dart';
import '../../beans/UserBean.dart';
import '../../common/httpclient/HttpManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/IconButtonListWidget.dart';
import '../../components/MenuItem2.dart';
import '../../components/SelectCircleDialogUtil.dart';
import '../../components/SliderWithCanvasWidget.dart';
import '../../components/TomatoInputNumber.dart';
import '../../config/ENUMS.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../util/DialogManagement.dart';
import '../../util/EasyLoadingManager.dart';
import '../../util/LoginManager.dart';
import '../../util/OverlayManagement.dart';
import '../RecorderPage/RecordPage2.dart';

/**
 * 从任务列表或 AI 创建入口进入的任务创建/编辑页面。
 * fromNormal 为 1 时只回传本地 MissionModel，不立即落库刷新列表。
 */
class CreateMissionPage extends BaseWidget {
  int fromNormal = 0; //0是正常创建更新 1表示CreateAIChatGptMissionPage不需要刷新数据，直接更新即可
  MissionModel missionModel = MissionModel();
  Function? onRefresh;
  Function? popOkCallback;

  CreateMissionPage(
      {this.fromNormal = 0,
      MissionModel? missionModel,
      Function? onRefresh,
      this.popOkCallback}) {
    this.onRefresh = onRefresh;
    if (missionModel == null) {
      this.missionModel = MissionModel();
    } else {
      this.missionModel = missionModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _CreateMissionPageWidgetState();
  }
}

class _CreateMissionPageWidgetState<T>
    extends BaseWidgetState<CreateMissionPage> {
  // 录音创建入口当前在创建任务页暂不展示，保留完整方法链路便于后续恢复。
  static const bool _showMobileVoiceCreateEntry = false;
  static const int _objectiveUnitHistoryLimit = 12;

  TextEditingController? inputNodeConroller;
  List<FolderModel> folderModelTags = [];
  FolderModel? folderModel;
  TextEditingController inputTitleController = TextEditingController();
  final TextEditingController _objectiveUnitController =
      TextEditingController();
  final TextEditingController _objectiveTotalController =
      TextEditingController();
  final FocusNode _objectiveUnitFocusNode = FocusNode();
  final FocusNode _objectiveTotalFocusNode = FocusNode();

// GlobalKey<BlackCheckButtonListWidgetS>
  GlobalKey<BlackCheckButtonListWidgetState> blackCheckButtonListWidgetState =
      GlobalKey<BlackCheckButtonListWidgetState>();

  // MissionModel missionModel;
  bool isNeedUpdateBmob =
      false; //是否需要更新BMOB 需要更新就EventBus发送广播让MssionPage重新发起requestData请求
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _noteFocusNode = FocusNode();

  bool get _isDark => ThemeManager.getInstance().getThemeMode().isDark;

  Color get _pageCanvasColor {
    if (Utility.isHandsetBySize() && !_isDark) {
      return const Color(0xFFFFFCFA);
    }
    if (_isDark) {
      return ThemeManager.getInstance().getBackgroundColor();
    }
    return ColorsConfig.missionDesktopEditorCanvas;
  }

  Color get _surfaceColor => ThemeManager.getInstance().getCardBackgroundColor(
        defaultColor:
            _isDark ? const Color(0xFF26231F) : const Color(0xFFFFFCF8),
      );

  Color get _panelBorderColor =>
      _isDark ? const Color(0xFF4C4037) : const Color(0xFFF0D9C4);

  Color get _primaryTextColor => ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF3E2A1E),
        defaultDarkColor: Colors.white,
      );

  Color get _secondaryTextColor => ThemeManager.getInstance().getTextColor(
        defaultColor: const Color(0xFF9C806C),
        defaultDarkColor: const Color(0xFFCAC1B8),
      );

  @override
  void onCreate() {
    super.onCreate();
    curPage = "CreateMissionPage";
  }

  @override
  void initState() {
    super.initState();
    //查找当前mission所属的FolderModel
    forceAppBarVisible = true;
    isAppBarVisible = true;

    inputNodeConroller =
        TextEditingController(text: this.widget.missionModel?.message ?? '');
    inputTitleController.text = this.widget.missionModel.title ?? '';
    _syncObjectiveEditorsFromMission(force: true);
    _objectiveUnitFocusNode.addListener(_handleObjectiveUnitFocusChange);
    // await requestGetTags(this.widget.missionModel?.tagNames.split(',') ?? ['ejizfjize']);
    if (this.widget.missionModel.tagNames == null)
      this.widget.missionModel.tagNames = '';
    if (this.widget.missionModel.tagNames != null) {
      requestGetTags(this.widget.missionModel.tagNames?.split(',') ?? []);
    }
  }

  /**
   * 功能：统一分发页面内的点击事件，避免各个 UI 区块直接散落保存、标签、优先级等业务入口。
   */
  void onClick(type, data) async {
    switch (type) {
      case 'onTapTagListener': //创建mission时选择tag
        await onClickCreateTag();
        break;
      case "onClickPriority": //点击选择优先级
        await onTapPriority(data);
        break;
      case "onClickUpdate": //点击更新按钮
        await onClickUpdate();
        break;
      case 'onTapCircleListener': //穿件mission时选择目标文件夹
        this.onTapCircleListener();
        break;
      case 'onClickSelectTomatoes':
        this.onClickSelectTomatoes(context);
        break;
      case 'onClickChangeTomatoesNum': //修改番茄数
        this.onClickChangeTomatoesNum(data);
        break;
    }
  }

  onClickChangeTomatoesNum(data) {
    this.widget.missionModel.total_tomotoes = data['count'];
    this.widget.missionModel.tomato_duration = data['duration'];
    // TomatoInputNumber 在 initState 会立即回调一次；如果此时同步 setState，
    // 创建页还在构建 TextField / 设置列表，会触发 setState during build。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) updateUI();
    });
  }

  void unfocus() {
    _titleFocusNode.unfocus();
    _noteFocusNode.unfocus();
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
      if (this.widget.missionModel.tagNames == null)
        this.widget.missionModel.tagNames = '';
      List<String> titleList =
          this.widget.missionModel.tagNames?.split(',') ?? [];
      if (titleList.indexOf(title) == -1 && title.isEmpty == false) {
        titleList.add(title);
        this.widget.missionModel.tagNames = titleList.join(',');
        this.updateUI();
        this.isNeedUpdateBmob = true;
        requestGetTags(this.widget.missionModel.tagNames?.split(',') ?? []);
        Navigator.of(context).pop();
      } else {}
      unfocus();
    });
  }

  requestGetTags(List<String> list) async {
    this.folderModelTags =
        await CONSTANTS.getFolderModelListFromStringList(list);
    this.updateUI();
  }

  @override
  void didUpdateWidget(CreateMissionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    inputNodeConroller =
        TextEditingController(text: this.widget.missionModel?.message ?? '');
    if (oldWidget.missionModel.objectiveUnit !=
            widget.missionModel.objectiveUnit ||
        oldWidget.missionModel.objectiveTotalValue !=
            widget.missionModel.objectiveTotalValue) {
      _syncObjectiveEditorsFromMission(force: true);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _objectiveUnitFocusNode.removeListener(_handleObjectiveUnitFocusChange);
    _objectiveUnitController.dispose();
    _objectiveTotalController.dispose();
    _objectiveUnitFocusNode.dispose();
    _objectiveTotalFocusNode.dispose();
    super.dispose();
  }

  /**
   * 功能：把 MissionModel 里的目标单位和总量同步到输入框，避免 build 时反复重建 controller。
   * 说明：旧实现每次 build 都 new controller，导致 suggestion 选中值和输入态经常被重置。
   */
  void _syncObjectiveEditorsFromMission({bool force = false}) {
    final String unitText = (widget.missionModel.objectiveUnit ?? '').trim();
    final String totalText =
        _formatObjectiveNumber(widget.missionModel.objectiveTotalValue);
    if (force || _objectiveUnitController.text != unitText) {
      _objectiveUnitController.text = unitText;
    }
    if (force || _objectiveTotalController.text != totalText) {
      _objectiveTotalController.text = totalText;
    }
  }

  /**
   * 功能：把 double 数值格式化成目标输入框展示文案。
   * 说明：目标总量当前交互只允许整数，因此展示时直接用整数文案即可。
   */
  String _formatObjectiveNumber(double? value) {
    if (value == null || value <= 0) {
      return '';
    }
    return value.toInt().toString();
  }

  /**
   * 功能：合并本地缓存单位和历史任务单位，生成目标单位输入框的 suggestion 列表。
   * 说明：本地缓存保证“刚编辑过但还没落库”的单位也能立即复用。
   */
  List<SuggestionBean> _getObjectiveUnitSuggestions() {
    final List<SuggestionBean> results = [];
    final Set<String> seen = {};

    void appendUnit(String? rawUnit) {
      final String unit = (rawUnit ?? '').trim();
      final String key = unit.toLowerCase();
      if (unit.isEmpty || seen.contains(key)) {
        return;
      }
      seen.add(key);
      results.add(
        SuggestionBean(
          suggestion: unit,
          suggestionContent: unit,
        ),
      );
    }

    for (final String unit
        in SharePreferenceUtil.getSyncInstance().getObjectiveUnitHistory()) {
      appendUnit(unit);
    }
    for (final SuggestionBean bean
        in MongoApisManager.getInstance().getSuggestionBeans()) {
      appendUnit(bean.suggestionContent ?? bean.suggestion);
    }
    return results;
  }

  /**
   * 功能：把当前目标单位写入前端缓存，供下次在下拉 suggestion 中直接复用。
   */
  bool _cacheObjectiveUnit(String rawUnit) {
    final String unit = rawUnit.trim();
    if (unit.isEmpty) {
      return false;
    }
    final List<String> current =
        SharePreferenceUtil.getSyncInstance().getObjectiveUnitHistory();
    if (current.isNotEmpty &&
        current.first.trim().toLowerCase() == unit.toLowerCase()) {
      return false;
    }
    final List<String> next = [unit];
    for (final String item in current) {
      final String trimmed = item.trim();
      if (trimmed.isEmpty || trimmed.toLowerCase() == unit.toLowerCase()) {
        continue;
      }
      next.add(trimmed);
      if (next.length >= _objectiveUnitHistoryLimit) {
        break;
      }
    }
    SharePreferenceUtil.getSyncInstance().setObjectiveUnitHistory(next);
    return true;
  }

  /**
   * 功能：在目标单位输入框失焦时补写缓存，保证用户手动输入的新单位也能进入历史列表。
   */
  void _handleObjectiveUnitFocusChange() {
    if (!_objectiveUnitFocusNode.hasFocus) {
      if (_cacheObjectiveUnit(_objectiveUnitController.text) && mounted) {
        setState(() {});
      }
    }
  }

  /**
   * 功能：统一处理目标单位输入或 suggestion 选中后的状态同步。
   */
  void _applyObjectiveUnit(String value, {bool persist = false}) {
    final String unit = value.trim();
    widget.missionModel.objectiveUnit = unit;
    if (_objectiveUnitController.text != unit) {
      _objectiveUnitController.text = unit;
      _objectiveUnitController.selection = TextSelection.collapsed(
        offset: _objectiveUnitController.text.length,
      );
    }
    if (persist) {
      _cacheObjectiveUnit(unit);
    }
  }

  /**
   * 功能：统一处理目标总量输入，并同步修正当前进度、百分比和完成态。
   * 说明：旧实现虽然改了 model，但没有 setState，导致滑杆 max 不刷新，看起来像“拖不动”。
   */
  void _applyObjectiveTotal(String rawValue) {
    final String normalized = rawValue.trim();
    final double? total = normalized.isEmpty ? 0 : double.tryParse(normalized);
    if (total == null) {
      return;
    }
    setState(() {
      final double safeTotal = total <= 0 ? 0 : total;
      widget.missionModel.objectiveTotalValue = safeTotal;
      final double safeCurrent =
          (widget.missionModel.objectiveValue ?? 0).clamp(0, safeTotal);
      widget.missionModel.objectiveValue = safeCurrent;
      widget.missionModel.isFinished =
          safeTotal > 0 && safeCurrent >= safeTotal;
    });
  }

  /**
   * 功能：统一处理目标滑杆拖拽，确保 current / total / 完成态同时保持一致。
   */
  void _handleObjectiveSliderChanged(double value) {
    setState(() {
      widget.missionModel.objectiveValue = value;
      final double total = widget.missionModel.objectiveTotalValue ?? 0;
      widget.missionModel.isFinished = total > 0 && value >= total;
    });
  }

  /**
   * 功能：校验任务标题与清单权限，并根据当前任务是否已有 objectId 选择创建或更新接口。
   * 副作用：成功后会关闭 loading、返回页面，并触发外部刷新回调。
   */
  Future<void> requestSaveData() async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this?.widget?.missionModel?.folder_id) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }

    this.widget.missionModel.message = inputNodeConroller?.text;
    this.widget.missionModel.title = inputTitleController.text;
    _cacheObjectiveUnit(_objectiveUnitController.text);
    if (TextUtil.isEmpty(this.widget.missionModel.title) == true) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().please_input_the_mission_title);
      return;
    }
    if ((this.widget.missionModel.alert_time ?? 0) > 0) {
      //加了这个 才会刷新提醒时间
      Params.shouldRefreshPushModelList = true;
    }
    //如果是从ai过来的那就不用更新
    if (this.widget.fromNormal == 1 && this.widget.popOkCallback != null) {
      this.widget.popOkCallback!(this?.widget?.missionModel);
      Utility.popNavigator(context, null);
      return;
    }
    try {
      EasyLoadingManager.getInstance().showLoading();
      if (TextUtil.isEmpty(this.widget.missionModel.objectId)) {
        MongoDbSaved? mongoDbSaved = await MongoApisManager.getInstance()
            .insertMissiontData(missionModel: this.widget.missionModel);
        if (mongoDbSaved != null) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().createSuccess);
          //todo 敢做这个没用了 因为用env了
          //mobile端返回上一页
          EasyLoadingManager.getInstance().hideLoading();
          Utility.popNavigator(context, null);
          if (this.widget.onRefresh != null) {
            this.widget.onRefresh!();
          }
        } else {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().network_error);
        }
      } else {
        MongoDbUpdated? mongoDbSaved = await MongoApisManager.getInstance()
            .update_MissionModel(missionModel: this.widget.missionModel);
        if (mongoDbSaved != null) {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().createSuccess);
          //todo 敢做这个没用了 因为用env了
          //mobile端返回上一页
          Utility.popNavigator(context, null);
          if (this.widget.onRefresh != null) {
            this.widget.onRefresh!();
          }
          EasyLoadingManager.getInstance().hideLoading();
        } else {
          Utility.showToastMsg(
              context: context, msg: getI18NKey().network_error);
        }
      }
    } catch (e) {
      EasyLoadingManager.getInstance().hideLoading();
      Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
    }
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

  @override
  baseAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: Utility.isHandsetBySize() ? 74 : 58,
      leadingWidth: Utility.isHandsetBySize() ? 74 : 70,
      iconTheme: IconThemeData(color: _primaryTextColor),
      backgroundColor: _pageCanvasColor,
      leading: Center(
        child: _buildHeaderIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () {
            Utility.popNavigator(context);
          },
        ),
      ),
      actions: [
        _buildHeaderIconButton(
          icon: Icons.close_rounded,
          onTap: () {
            Utility.popNavigator(context);
          },
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor:
                  _isDark ? const Color(0xFF3A3028) : const Color(0xFFFFEEE3),
              foregroundColor: const Color(0xFFFF5B2E),
              padding: EdgeInsets.symmetric(
                horizontal: Utility.isHandsetBySize() ? 18 : 14,
                vertical: Utility.isHandsetBySize() ? 13 : 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              onClickUpdate();
            },
            child: Text(
              TextUtil.isEmpty(this.widget.missionModel.objectId)
                  ? getI18NKey().create
                  : getI18NKey().update,
              style: TextStyle(
                fontSize: Utility.isHandsetBySize() ? 16 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
      centerTitle: true,
      title: Text(
        TextUtil.isEmpty(this.widget.missionModel.objectId)
            ? getI18NKey().create_mission
            : getI18NKey().update,
        style: TextStyle(
          color: _primaryTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /**
   * 功能：构建桌面端顶部返回/关闭小按钮，保持创建页和清单页相近的轻量工具栏质感。
   */
  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: Utility.isHandsetBySize() ? 46 : 34,
        height: Utility.isHandsetBySize() ? 46 : 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isDark ? const Color(0xFF332D28) : const Color(0xFFFFF4EA),
          borderRadius:
              BorderRadius.circular(Utility.isHandsetBySize() ? 16 : 12),
          border: Border.all(color: _panelBorderColor),
        ),
        child: Icon(
          icon,
          size: Utility.isHandsetBySize() ? 24 : 18,
          color: _secondaryTextColor,
        ),
      ),
    );
  }

  /**
   * 功能：统一任务标题输入框边框，避免桌面端输入框和页面面板割裂。
   */
  OutlineInputBorder _buildTitleInputBorder({Color? color}) {
    return OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color ?? _panelBorderColor),
    );
  }

  /**
   * 功能：渲染标签选择区域。已有标签用可删除胶囊展示，没有标签时保留“添加标签”入口。
   */
  Widget _buildTagsArea() {
    final List<Widget> chips = [];
    for (final FolderModel tag in folderModelTags) {
      chips.add(_buildTagChip(tag));
    }
    chips.add(_buildAddTagChip());
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: chips,
      ),
    );
  }

  Widget _buildTagChip(FolderModel tag) {
    final Color tagColor = Color(tag.color);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        _deleteTag(tag);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: tagColor.withValues(alpha: _isDark ? 0.18 : 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tagColor.withValues(alpha: 0.34)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag.title ?? "",
              style: TextStyle(
                color: tagColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                _deleteTag(tag);
              },
              child: Icon(Icons.close_rounded, size: 14, color: tagColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddTagChip() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        this.onClick('onTapTagListener', null);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: _isDark ? const Color(0xFF2E2925) : const Color(0xFFFFF5EC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _panelBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16, color: _secondaryTextColor),
            const SizedBox(width: 5),
            Text(
              getI18NKey().add_tag,
              style: TextStyle(
                color: _secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 功能：移动端语音创建入口，复用 RecordPage2 的录音、预览、上传和转写链路。
   */
  Widget _buildVoiceCreateCard() {
    if (!_showMobileVoiceCreateEntry || !Utility.isHandsetBySize()) {
      return const SizedBox.shrink();
    }
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _openVoiceCreateMission,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: _isDark ? const Color(0xFF2E2925) : const Color(0xFFFFF7F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _panelBorderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5B2E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.mic_none_rounded,
                size: 22,
                color: Color(0xFFFF5B2E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getI18NKey().record_voice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getI18NKey().record_voice_description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 12,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: _secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 功能：移动端四象限优先级选择，按设计图补充图标与行动提示，降低纯按钮感。
   */
  Widget _buildMobilePriorityGrid() {
    if (!Utility.isHandsetBySize()) {
      return PriorityButtonListWidget(
        list: CONSTANTS.getPriorityButtonList(),
        initIndex: this.widget.missionModel.priorityStatus ?? 3,
        useUnifiedStyle: true,
        onTapListener: (data) {
          int index = data['index'];
          this.onClick("onClickPriority", index);
        },
      );
    }
    final list = CONSTANTS.getPriorityButtonList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.35,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final model = list[index];
        final priority = PriorityEnum.values[int.parse(model.code ?? "0")];
        final bool isChecked =
            (this.widget.missionModel.priorityStatus ?? 3) == index;
        final Color priorityColor = Utility.getTextColorByPriority(priority);
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            this.onClick("onClickPriority", index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(
              color: isChecked
                  ? priorityColor.withValues(alpha: 0.13)
                  : Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isChecked ? priorityColor : const Color(0xFFEEDCCD),
                width: isChecked ? 1.4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    _getMobilePriorityIcon(index),
                    size: 22,
                    color: priorityColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            model.title ?? "",
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: isChecked
                                  ? priorityColor
                                  : const Color(0xFF33251E),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getMobilePrioritySubtitle(index),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF8D817A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getMobilePriorityIcon(int index) {
    switch (index) {
      case 0:
        return Icons.emergency_share_rounded;
      case 1:
        return Icons.error_outline_rounded;
      case 2:
        return Icons.schedule_rounded;
      case 3:
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  String _getMobilePrioritySubtitle(int index) {
    switch (index) {
      case 0:
        return "立即处理";
      case 1:
        return "计划去做";
      case 2:
        return "授权他人";
      case 3:
      default:
        return "有空再做";
    }
  }

  /**
   * 功能：打开录音页，确认后把转写内容回填到任务标题和备注。
   */
  void _openVoiceCreateMission() {
    Utility.openPagePCAndMobile(
      context,
      showPCShell: false,
      child: RecordPage2(
        richTextModeEnum: RichTextModeEnum.getUrl,
        shouldShowTitle: null,
        onSubmit: null,
        onSubmitWithText: (
          String title,
          String path,
          String localPath,
          int duration,
          int fileSize,
          String recordText,
        ) {
          _applyVoiceMissionText(recordText);
        },
      ),
    );
  }

  /**
   * 功能：语音转写结果优先生成标题，完整文本保留到备注，避免用户录长句时标题过长。
   */
  void _applyVoiceMissionText(String recordText) {
    final String text = recordText.trim();
    if (text.isEmpty) {
      return;
    }
    final String firstLine = text
        .split(RegExp(r'[\n。！？!?]'))
        .map((item) => item.trim())
        .firstWhere((item) => item.isNotEmpty, orElse: () => text);
    final String title =
        firstLine.length > 60 ? firstLine.substring(0, 60) : firstLine;
    if (inputTitleController.text.trim().isEmpty) {
      inputTitleController.text = title;
    }
    if ((inputNodeConroller?.text.trim().isEmpty ?? true)) {
      inputNodeConroller?.text = text;
    } else {
      inputNodeConroller?.text = '${inputNodeConroller?.text.trim()}\n$text';
    }
    this.widget.missionModel.message = inputNodeConroller?.text;
    this.widget.missionModel.title = inputTitleController.text;
    this.isNeedUpdateBmob = true;
    updateUI();
  }

  /**
   * 功能：删除标签并同步刷新标签模型列表。这里保持旧逻辑的逗号分隔字段，避免影响存量数据格式。
   */
  void _deleteTag(FolderModel tag) {
    List<String> tagNamesList =
        this.widget.missionModel?.tagNames?.split(',') ?? [];
    tagNamesList.remove(tag.title);
    this.widget.missionModel.tagNames = tagNamesList.join(',');
    requestGetTags(this.widget.missionModel?.tagNames?.split(',') ?? []);
    this.isNeedUpdateBmob = true;
  }

  /**
   * 穿件mission时选择目标文件夹
   */
  Future onTapCircleListener() async {
    SelectCircleDialogUtil.show(context,
        title: getI18NKey().selectMission,
        content: '', okCallBack: (FolderModel data) {
      this.widget.missionModel.folder_id = data.objectId;
      updateUI();
      unfocus();
    }, onTapCreateTagListener: (data) {
      // this.onClick("onTapCreateTagListener", data);
    }, onTapListener: (data) {});
  }

  Future requestNotification() async {
    BaseBean res =
        await CounterMethodChannelManager.getInstance().isNotificationEnabled();
    if (res.data == false) {
      OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: getI18NKey().no_notification_permission_title,
          message: getI18NKey().need_notification_permission_content,
          okLabel: getI18NKey().go_to_setting,
          cancelLabel: getI18NKey().cancel,
          onWillPop: () async {
            //点击对话框外围黑色区域才会走这里
            return true;
          });
      if (result == OkCancelResult.ok) {
        await CounterMethodChannelManager.getInstance().openSetting();
      }
    }
  }

  /**
   * 更新alert_time
   * 如果是重复 直接用重复的开始时间
   * 如果是不重复 用开始时间+结束时间 因为结束时间 是 年月日到日
   */
  void updateAlertTime() {
    if (this.widget.missionModel.time_mode == 1 ||
        this.widget.missionModel.time_mode == 2) {
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

  Container getBgSettingItem(ImageProvider<Object>? imageProviderTmp) {
    if (Utility.isHandsetBySize()) {
      return Container(
        height: 58,
        margin: const EdgeInsets.fromLTRB(18, 16, 18, 12),
        decoration: BoxDecoration(
          color: ThemeManager.getInstance()
              .getCardBackgroundColor(defaultColor: Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9DED6)),
          image: imageProviderTmp == null
              ? null
              : DecorationImage(
                  image: imageProviderTmp,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.78),
                    BlendMode.srcATop,
                  ),
                ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            DialogManagement.getInstance().showSelectBgDialog(context,
                list: ResourceInfo
                        .missionItemBackgroundLocationInfoBean?.deliveryList ??
                    [], onTapListener: (String imgUrl) {
              this.widget.missionModel.background_url = imgUrl;
              updateUI();
              DialogManagement.getInstance().hideDialog(context);
            });
          },
          child: Row(
            children: [
              const SizedBox(width: 20),
              const Icon(
                Icons.image_outlined,
                size: 24,
                color: Color(0xFF67615C),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  getI18NKey().change_bg,
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: _secondaryTextColor,
              ),
              const SizedBox(width: 18),
            ],
          ),
        ),
      );
    }
    return Container(
        height: 50,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          image: imageProviderTmp == null
              ? null
              : DecorationImage(
                  image: imageProviderTmp,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      ThemeManager.getInstance().getCardBackgroundColor(
                          defaultColor: Colors.white, alpha: 150),
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

  List<Widget> getBarWidget() {
    return [
      InkWell(
        onTap: () {
          DialogManagement.getInstance().showSelectBgDialog(context,
              list: ResourceInfo
                      .missionItemBackgroundLocationInfoBean?.deliveryList ??
                  [], onTapListener: (String imgUrl) {
            this.widget.missionModel.background_url = imgUrl;
            updateUI();
            DialogManagement.getInstance().hideDialog(context);
          });
        },
        child: Text(getI18NKey().change_bg),
      ),
    ];
  }

  @override
  baseBuild(BuildContext context) {
    // 先同步当前任务所属清单和重复信息，后续设置行会直接读取这些派生展示值。
    this.folderModel = MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithFolderIdOfMission(
            this.widget.missionModel.folder_id, 1);
    DateTime? dateTimeNextTime = Utility.getNextDateTime(
        missionModelParam: this.widget.missionModel,
        calendarModel: context.watch<GlobalStateEnv>().calendarModel);
    String repetiveString =
        CONSTANTS.getRepetiveDateString1(this.widget.missionModel);
    return RawKeyboardListener(
      autofocus: true,
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent) {
          if (event.physicalKey == PhysicalKeyboardKey.enter) {
            this.onClick("onClickUpdate", null);
          }
        }
      },
      focusNode: FocusNode(),
      child: Container(
          color: _pageCanvasColor,
          child: Stack(children: [
            SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  0,
                  Utility.isHandsetBySize() ? 10 : 18,
                  0,
                  Utility.isHandsetBySize()
                      ? MediaQuery.of(context).padding.bottom + 24
                      : 0,
                ),
                child: Column(children: [
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: double.infinity, minHeight: 100),
                      padding: EdgeInsets.fromLTRB(
                        Utility.isHandsetBySize() ? 18 : 24,
                        0,
                        Utility.isHandsetBySize() ? 18 : 24,
                        18,
                      ),
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        border: Border(
                          top: BorderSide(color: _panelBorderColor),
                          bottom: BorderSide(color: _panelBorderColor),
                        ),
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 54,
                              child: Focus(
                                  onKey: (FocusNode node, RawKeyEvent event) {
                                    return KeyEventResult.ignored;
                                  },
                                  child: TextField(
                                    maxLength: 255,
                                    textAlign: TextAlign.left,
                                    focusNode: _titleFocusNode,
                                    controller: inputTitleController,
                                    onChanged: (text) {
                                      // _value = text;
                                      // this.widget.onChangeListener(text);
                                    },
                                    // onSubmitted: (String value) {
                                    //   if (this.widget.onSubmitListener != null) {
                                    //     this.widget.onSubmitListener(
                                    //         {"inputContent": value, "folderModel": curFolderModel});
                                    //   }
                                    //
                                    //   print(value);
                                    // },
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        decorationColor: Color(0xffd5d5d5),
                                        color: _primaryTextColor,
                                        fontWeight: FontWeight.w500),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 0, bottom: 0),
                                        counterStyle: TextStyle(
                                            color: Colors.transparent,
                                            fontSize: 0),
                                        //右边距是为了放置番茄计数器
                                        fillColor: ThemeManager.getInstance()
                                            .getInputThemeColor(
                                                defaultColor:
                                                    const Color(0xFFFFFBF6),
                                                defaultDarkColor:
                                                    const Color(0xFF2E2925)),
                                        //背景颜色，必须结合filled: true,才有效
                                        // hoverColor: Colors.white,
                                        // focusColor: Colors.white,
                                        filled: true,
                                        //重点，必须设置为true，fillColor才有效
                                        // border: OutlineInputBorder(),
                                        prefixIcon: Container(
                                          width: 34,
                                          height: 34,
                                          margin: const EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            color: _isDark
                                                ? const Color(0xFF3A3028)
                                                : const Color(0xFFFFE9D6),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.assignment_outlined,
                                            size: 18,
                                            color: _secondaryTextColor,
                                          ),
                                        ),
                                        prefixIconColor: Color(0xffd5d5d5),
                                        floatingLabelStyle: TextStyle(
                                            color: Color(0xffff0000),
                                            fontSize: 14),
                                        border: _buildTitleInputBorder(),
                                        //边框，一般下面的几个边框一起设置
                                        //keyboardType: TextInputType.number, //键盘类型
                                        //obscureText: true,//密码模式
                                        focusedBorder: _buildTitleInputBorder(
                                            color: ThemeManager.getInstance()
                                                .getDefautThemeColor()),
                                        enabledBorder: _buildTitleInputBorder(),
                                        disabledBorder:
                                            _buildTitleInputBorder(),
                                        focusedErrorBorder:
                                            _buildTitleInputBorder(
                                                color: ColorsConfig.darkRed),
                                        errorBorder: _buildTitleInputBorder(
                                            color: ColorsConfig.darkRed),
                                        // labelStyle:
                                        //     TextStyle(color: Color(0x00000000), fontSize: 14),
                                        // labelText: getI18NKey().search,
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: _secondaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        hintText: getI18NKey()
                                            .please_input_the_mission_title),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildTagsArea(),
                            SizedBox(
                              height: Utility.isHandsetBySize() ? 12 : 18,
                            ),
                            if (_showMobileVoiceCreateEntry) ...[
                              _buildVoiceCreateCard(),
                              if (Utility.isHandsetBySize())
                                const SizedBox(height: 14),
                            ],
                            _buildMobilePriorityGrid(),
                            if (this.widget.missionModel.time_mode == 2)
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: SliderWithCanvasWidget(
                                      shouldOnlyShowSlider: true,
                                      onChange: _handleObjectiveSliderChanged,
                                      min: this
                                              .widget
                                              .missionModel
                                              ?.objectiveStartValue ??
                                          0,
                                      max: this
                                              .widget
                                              .missionModel
                                              ?.objectiveTotalValue ??
                                          0,
                                      curVal: this
                                          .widget
                                          .missionModel
                                          ?.objectiveValue,
                                      enable: (this
                                                  .widget
                                                  .missionModel
                                                  ?.objectiveTotalValue ??
                                              0) >
                                          (this
                                                  .widget
                                                  .missionModel
                                                  ?.objectiveStartValue ??
                                              0),
                                    ),
                                  ),
                                  Text(
                                    this
                                            .widget
                                            .missionModel
                                            .objectivePercentString ??
                                        "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ThemeManager.getInstance().isDark()
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${this.widget.missionModel?.objectiveValue?.toInt() ?? 0}/",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ThemeManager.getInstance().isDark()
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                  getTotalInputWidgetForObjective(),
                                  getUnitInputWidgetForObjective(),
                                ],
                              ),
                          ])),
                  if (Utility.shouldShowWallpaper(
                      missionModelType:
                          this.widget.missionModel.missionModelType))
                    SizedBox(height: 5),
                  if (Utility.shouldShowWallpaper(
                      missionModelType:
                          this.widget.missionModel.missionModelType))
                    TextUtil.isEmpty(this.widget.missionModel.background_url)
                        ? getBgSettingItem(null)
                        : CachedNetworkImage(
                            imageUrl: Utility.filterHttpUrl(
                                this.widget.missionModel.background_url ?? '',
                                prefix: "oss"),
                            imageBuilder: (context, imageProviderTmp) {
                              return getBgSettingItem(imageProviderTmp);
                            }),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      Utility.isHandsetBySize() ? 18 : 0,
                      Utility.isHandsetBySize() ? 12 : 0,
                      Utility.isHandsetBySize() ? 18 : 0,
                      0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: Utility.isHandsetBySize()
                        ? BoxDecoration(
                            color: ThemeManager.getInstance()
                                .getCardBackgroundColor(
                                    defaultColor: Colors.white),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE9DED6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.025),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          )
                        : null,
                    child: Column(children: [
                      SectionTitleWidget(
                        title: getI18NKey().setting,
                        useUnifiedStyle: true,
                        child: BlackCheckButtonListWidget(
                          key: blackCheckButtonListWidgetState,
                          // initIndex: 1,
                          initIndex: this.widget.missionModel.time_mode,
                          backgroundColor:
                              ThemeManager.getInstance().getDefautThemeColor(),
                          useThemeColorForUnifiedStyle: true,
                          list: CONSTANTS.getSettingItemDetailCheckButtonList(
                              defaultVal:
                                  this.widget.missionModel.time_mode ?? 0),
                          onTapListener: (index) async {
                            if (index == 1) {
                              if (LoginManager.getInstance()
                                      .isVIP(shouldShowDialog: true) ==
                                  false) {
                                return;
                              }
                            }
                            this.widget.missionModel.time_mode = index;
                            this.widget.missionModel?.end_time = 0;
                            this.widget.missionModel?.start_time = 0;
                            setState(() {});
                          },
                        ),
                      ),
                      if (this.widget.missionModel.time_mode != 2)
                        if (DeviceInfoManagement.isMacOs() ||
                            DeviceInfoManagement.isIOS())
                          MenuItem2(
                              useCreateMissionMobileStyle:
                                  Utility.isHandsetBySize(),
                              title: getI18NKey().save_mode,
                              subTitle: "",
                              onTapListener: (data) async {},
                              rightPartContainer: IconButtonListWidget(
                                popupModeEnum: PopupModeEnum.popup,
                                initIndex:
                                    this.widget.missionModel.missionModelType ??
                                        0,
                                list: CONSTANTS.getMissionTypeButtonList(
                                    defaultVal: 0),
                                onTapListener: (obj) {
                                  switch (obj['data'].code) {
                                    case 'normal':
                                      blackCheckButtonListWidgetState
                                          .currentState
                                          ?.setCurIndex(0);
                                      this
                                          .widget
                                          .missionModel
                                          .missionModelType = 0;
                                      this.widget.missionModel.time_mode = 0;
                                      // this.time_mode = 0;
                                      break;
                                    case 'calendar':
                                      if (LoginManager.getInstance()
                                              .isVIP(shouldShowDialog: true) ==
                                          false) {
                                        return;
                                      }
                                      blackCheckButtonListWidgetState
                                          .currentState
                                          ?.setCurIndex(1);
                                      this.widget.missionModel.time_mode = 1;
                                      // _tabBarKey.currentState?.setChecked(0);
                                      this
                                          .widget
                                          .missionModel
                                          .missionModelType = 1;
                                      // this.time_mode = 1;
                                      break;
                                    case 'alarm':
                                      if (LoginManager.getInstance()
                                              .isVIP(shouldShowDialog: true) ==
                                          false) {
                                        return;
                                      }
                                      blackCheckButtonListWidgetState
                                          .currentState
                                          ?.setCurIndex(0);
                                      this.widget.missionModel.time_mode = 0;
                                      // _tabBarKey.currentState?.setChecked(0);
                                      this
                                          .widget
                                          .missionModel
                                          .missionModelType = 2;
                                      // this.time_mode = 0;
                                      break;
                                  }
                                  setState(() {});
                                },
                              ),
                              icon: Utility.getSVGPicture(
                                  R.assetsImgIcCalendarMode,
                                  size: StylesConfig.iconSize,
                                  color: ThemeManager.getInstance()
                                      .getDefautThemeColor())),
                      if (Utility.shouldShowBeginTime(
                          missionModelType:
                              this.widget.missionModel.missionModelType))
                        MenuItem2(
                            useCreateMissionMobileStyle:
                                Utility.isHandsetBySize(),
                            title: (this.widget.missionModel.repetiveType ==
                                        0 ||
                                    this.widget.missionModel.time_mode == 1 ||
                                    this.widget.missionModel.time_mode == 2)
                                ? getI18NKey().start_time
                                : getI18NKey().daily_start_time,
                            subTitle: this.widget.missionModel.repetiveType == 1
                                ? ""
                                : "(${getI18NKey().optional})",
                            onTapListener: (data) async {
                              if (this.widget.missionModel.time_mode == 1 ||
                                  this.widget.missionModel.time_mode == 2) {
                                DateTimeModel? model =
                                    await Utility.showDateTimePickerDialog(
                                        context);
                                updateAlertTime();
                                this.setState(() {
                                  this.isNeedUpdateBmob = true;
                                  this.widget.missionModel?.start_time =
                                      model?.datetime?.millisecondsSinceEpoch ??
                                          0; //计划到期日
                                });
                              } else {
                                DateTimeModel model;
                                TimeOfDay? timeOfDay;
                                timeOfDay =
                                    await Utility.showTimePickerDialog(context);
                                if (timeOfDay == null) {
                                  return;
                                }
                                this.widget.missionModel.daily_start_time =
                                    timeOfDay.hour * 60 * 60 * 1000 +
                                        timeOfDay.minute * 60 * 1000;
                                // if((this.widget.missionModel.alert_time??0) > 0) {
                                //   Params.shouldRefreshPushModelList = true;
                                // }
                                updateAlertTime();
                                this.setState(() {
                                  this.isNeedUpdateBmob = true;
                                });
                              }
                              // this.requestNotification();
                              // NotificationManager.getInstance()
                            },
                            rightPartContainer: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  (this.widget.missionModel.time_mode == 1 ||
                                          this.widget.missionModel.time_mode ==
                                              2)
                                      ? CONSTANTS.getAlertDateString(
                                          Utility.getDateTimeModelFromTimeStamp(
                                              this
                                                      .widget
                                                      .missionModel
                                                      ?.start_time ??
                                                  0))
                                      : TextUtil.isEmpty(
                                                  this
                                                      .widget
                                                      .missionModel
                                                      .daily_start_time) ==
                                              false
                                          ? Utility.formatHourAndMin2(this
                                                  .widget
                                                  ?.missionModel
                                                  ?.daily_start_time ??
                                              0)
                                          : getI18NKey().none,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ColorsConfig.gray_a3_icon),
                                ),
                                IconButton(
                                  icon: Icon(Icons.cancel,
                                      size: 20,
                                      color: ColorsConfig.gray_cc_cancel),
                                  onPressed: () {
                                    this.isNeedUpdateBmob = true;
                                    // this.widget.missionModel.daily_start_time = 0;
                                    this.widget.missionModel?.daily_start_time =
                                        0;
                                    this.widget.missionModel?.start_time = null;
                                    this.updateUI();
                                  },
                                )
                              ],
                            ),
                            icon: Utility.getSVGPicture(
                                R.assetsImgIcStarttimeOrange,
                                size: StylesConfig.iconSize,
                                color: ThemeManager.getInstance()
                                    .getDefautThemeColor())),
                      if (Utility.shouldShowEndTime(
                          missionModelType:
                              this.widget.missionModel.missionModelType))
                        MenuItem2(
                            useCreateMissionMobileStyle:
                                Utility.isHandsetBySize(),
                            title: (this.widget.missionModel.repetiveType ==
                                        0 ||
                                    this.widget.missionModel.time_mode == 1 ||
                                    this.widget.missionModel.time_mode == 2)
                                ? getI18NKey().end_time
                                : getI18NKey().daily_end_time,
                            subTitle: this.widget.missionModel.repetiveType == 1
                                ? ""
                                : "(${getI18NKey().optional})",
                            onTapListener: (data) async {
                              if (this.widget.missionModel.time_mode == 1 ||
                                  this.widget.missionModel.time_mode == 2) {
                                if (this.widget.missionModel?.start_time ==
                                    null) {
                                  Utility.showToastMsg(
                                      context: context,
                                      msg: getI18NKey()
                                          .please_select_daily_start_time);
                                  return;
                                }
                                DateTimeModel? model =
                                    await Utility.showDateTimePickerDialog(
                                        context);
                                if ((model?.datetime?.millisecondsSinceEpoch ??
                                        0) <
                                    (this.widget.missionModel?.start_time ??
                                        0)) {
                                  Utility.showToastMsg(
                                      context: context,
                                      msg: getI18NKey()
                                          .end_time_cannot_before_start_time);
                                  this.widget.missionModel?.end_time = null;
                                  return;
                                }
                                this.setState(() {
                                  this.isNeedUpdateBmob = true;
                                  this.widget.missionModel?.end_time =
                                      model?.datetime?.millisecondsSinceEpoch ??
                                          0; //计划到期日
                                });
                              } else {
                                if (this.widget.missionModel.daily_start_time ==
                                    null) {
                                  Utility.showToastMsg(
                                      context: context,
                                      msg: getI18NKey()
                                          .please_select_daily_start_time);
                                  return;
                                }
                                TimeOfDay? timeOfDay;
                                timeOfDay =
                                    await Utility.showTimePickerDialog(context);
                                if (timeOfDay == null) {
                                  return;
                                }
                                int endTime = timeOfDay.hour * 60 * 60 * 1000 +
                                    timeOfDay.minute * 60 * 1000;
                                if (endTime <
                                    (this
                                            .widget
                                            .missionModel
                                            .daily_start_time ??
                                        0)) {
                                  Utility.showToastMsg(
                                      context: context,
                                      msg: getI18NKey()
                                          .end_time_cannot_before_start_time);
                                  this.widget.missionModel.daily_end_time =
                                      null;
                                  return;
                                }
                                this.widget.missionModel.daily_end_time =
                                    endTime;

                                this.setState(() {
                                  this.isNeedUpdateBmob = true;
                                });
                              }
                              // this.requestNotification();
                              // NotificationManager.getInstance()
                            },
                            rightPartContainer: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  (this.widget.missionModel.time_mode == 1 ||
                                          this.widget.missionModel.time_mode ==
                                              2)
                                      ? CONSTANTS.getAlertDateString(
                                          Utility.getDateTimeModelFromTimeStamp(
                                              this
                                                      .widget
                                                      .missionModel
                                                      ?.end_time ??
                                                  0))
                                      : TextUtil.isEmpty(this
                                                  .widget
                                                  .missionModel
                                                  .daily_end_time) ==
                                              false
                                          ? Utility.formatHourAndMin2(this
                                                  .widget
                                                  .missionModel
                                                  .daily_end_time ??
                                              0)
                                          : getI18NKey().none,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: ColorsConfig.gray_a3_icon),
                                ),
                                IconButton(
                                  icon: Icon(Icons.cancel,
                                      size: 20,
                                      color: ColorsConfig.gray_cc_cancel),
                                  onPressed: () {
                                    this.isNeedUpdateBmob = true;
                                    this.widget.missionModel?.end_time = 0;
                                    this.widget.missionModel?.daily_end_time =
                                        0;
                                    this.updateUI();
                                  },
                                )
                              ],
                            ),
                            icon: Utility.getSVGPicture(
                                R.assetsImgIcEndtimeOrange,
                                size: StylesConfig.iconSize,
                                color: ThemeManager.getInstance()
                                    .getDefautThemeColor())),
                      // SizedBox(height: 20,),
                      if (Utility.shouldShowCircleFolderId(
                          missionModelType:
                              this.widget.missionModel.missionModelType))
                        MenuItem2(
                            useCreateMissionMobileStyle:
                                Utility.isHandsetBySize(),
                            title: getI18NKey().mission,
                            subTitle: "(${getI18NKey().optional})",
                            onTapListener: (data) async {
                              this.onClick('onTapCircleListener', data);
                            },
                            rightPartContainer: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  this.folderModel != null &&
                                          this.folderModel?.title != null
                                      ? (this.folderModel?.title ?? "")
                                      : getI18NKey().none,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: this.folderModel != null &&
                                              this.folderModel?.color != null
                                          ? Color(this.folderModel?.color ?? 0)
                                          : ColorsConfig.gray_a3_icon),
                                ),
                                IconButton(
                                  icon: Icon(Icons.cancel,
                                      size: 20,
                                      color: ColorsConfig.gray_cc_cancel),
                                  onPressed: () {
                                    this.isNeedUpdateBmob = true;
                                    this.widget.missionModel.alert_time = 0;
                                    this.updateUI();
                                  },
                                )
                              ],
                            ),
                            icon: folderModel?.icon != null
                                ? Icon(
                                    IconData(folderModel?.icon ?? 0,
                                        fontFamily: 'MaterialIcons'),
                                    size: 25,
                                    color: folderModel?.icon != null
                                        ? Color(folderModel?.color ?? 0)
                                        : ColorsConfig.gray_a3_icon)
                                : Utility.getSVGPicture(
                                    R.assetsImgIcFolderOrange,
                                    size: StylesConfig.iconSize,
                                    color: ThemeManager.getInstance()
                                        .getDefautThemeColor())),
                      if (this.widget.missionModel.time_mode != 2)
                        this.widget.missionModel.isFinished == true
                            ? SizedBox.shrink()
                            : Utility.shouldShowTomatoes(
                                        missionModelType: this
                                            .widget
                                            .missionModel
                                            .missionModelType) ==
                                    false
                                ? SizedBox.shrink()
                                : MenuItem2(
                                    useCreateMissionMobileStyle:
                                        Utility.isHandsetBySize(),
                                    title: getI18NKey().tomatoNums,
                                    subTitle: getI18NKey().tomatoNums3,
                                    onTapListener: (data) {
                                      this.onClick(
                                          'onClickSelectTomatoes', null);
                                    },
                                    rightPartContainer: TomatoInputNumber(
                                        onValueChangeListener: (v, duration) {
                                      this.onClick('onClickChangeTomatoesNum',
                                          {"count": v, "duration": duration});
                                    }),
                                    icon: Utility.getSVGPicture(
                                        R.assetsImgIcFocusOrange,
                                        size: StylesConfig.iconSize,
                                        color: ThemeManager.getInstance()
                                            .getDefautThemeColor())),
                      if (Utility.shouldShowMissionValue(
                              missionModelType:
                                  this.widget.missionModel.missionModelType) ==
                          true)
                        MenuItem2(
                            useCreateMissionMobileStyle:
                                Utility.isHandsetBySize(),
                            title: getI18NKey().mission_value,
                            // subTitle: getI18NKey().tomatoNums3,
                            onTapListener: (data) {
                              if (LoginManager.getInstance()
                                          .userBean
                                          .valuePerHour ==
                                      null ||
                                  LoginManager.getInstance()
                                          .userBean
                                          .valuePerHour ==
                                      0) {
                                OverlayManagement.getInstance()
                                    .openSelectMoneyPerHourOfMeOverlay(context,
                                        title: getI18NKey().mission_value,
                                        okCallBack: (valuePerHour) async {
                                  OverlayManagement.getInstance()
                                      .removeSelectDialogOverlay();
                                  BaseBean response =
                                      await HttpManager.getInstance()
                                          .doPostRequest(
                                              Apis.updateValuePerHour,
                                              params: {
                                                "valuePerHour": valuePerHour
                                              },
                                              context: context,
                                              shouldShowErrorToast: false);
                                  if (response.success == true) {
                                    LoginManager.getInstance().setUserBean(
                                        UserBean.fromJson(response.data));
                                  }
                                });
                                return;
                              }
                              OverlayManagement.getInstance()
                                  .openSelectMoneyPerHourOfMeOverlay(context,
                                      title: getI18NKey().mission_value,
                                      cancelCallBack: () {
                                OverlayManagement.getInstance()
                                    .dismissSelectValueMoneyOverlay();
                              }, okCallBack: (data) {
                                this.setState(() {
                                  this.widget.missionModel?.mission_value =
                                      data;
                                  // this.mission_value = data;
                                });
                                OverlayManagement.getInstance()
                                    .dismissSelectValueMoneyOverlay();
                              });
                            },
                            rightPartContainer: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        // Text(
                                        //   this.widget.missionModel.mission_value == null ? getI18NKey().none : (this.widget.missionModel.mission_value.toString() + getI18NKey().dollar),
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       color: this.widget.missionModel.mission_value == null ? ColorsConfig.gray_a3_icon : ColorsConfig.colorGold),
                                        // ),
                                        Text(
                                          this
                                                      .widget
                                                      .missionModel
                                                      .mission_value ==
                                                  null
                                              ? getI18NKey().none
                                              : (this
                                                      .widget
                                                      .missionModel
                                                      .mission_value
                                                      .toString() +
                                                  getI18NKey().dollar +
                                                  "(" +
                                                  getI18NKey().value_per_hour(Utility
                                                      .getMissionValuePerHourByMissionModel(
                                                          missionModel: this
                                                              .widget
                                                              .missionModel!)) +
                                                  ")"),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: this
                                                          .widget
                                                          .missionModel
                                                          .mission_value ==
                                                      null
                                                  ? ColorsConfig.gray_a3_icon
                                                  : ColorsConfig.colorGold),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.cancel,
                                          size: 20,
                                          color: ColorsConfig.gray_cc_cancel),
                                      onPressed: () {
                                        this.widget.missionModel.mission_value =
                                            0;
                                        updateUI();
                                        // this.isNeedUpdateBmob = true;
                                        // this.widget.missionModel.mission_value = 0;
                                        // this.updateUI();
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            icon: Utility.getSVGPicture(R.assetsImgIcMoney2,
                                size: StylesConfig.iconSize,
                                color: ThemeManager.getInstance()
                                    .getDefautThemeColor())),
                      if (this.widget.missionModel.time_mode != 2)
                        (this.widget.missionModel.isFinished == true ||
                                this.widget.missionModel?.time_mode == 1)
                            ? SizedBox.shrink()
                            : MenuItem2(
                                useCreateMissionMobileStyle:
                                    Utility.isHandsetBySize(),
                                title: getI18NKey().deadLine,
                                subTitle: "(${getI18NKey().optional})",
                                onTapListener: (data) async {
                                  DateTimeModel? model =
                                      await Utility.showDatePickerDialog(
                                          context,
                                          this.widget.missionModel.end_time ??
                                              0);
                                  this.setState(() {
                                    this.isNeedUpdateBmob = true;
                                    this.widget.missionModel.end_time = model
                                            ?.datetime
                                            ?.millisecondsSinceEpoch ??
                                        0; //计划到期日
                                  });
                                },
                                rightPartContainer: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      TextUtil.isEmpty(this
                                                  .widget
                                                  .missionModel
                                                  .end_time) ==
                                              false
                                          ? CONSTANTS.getWeekDayString(Utility
                                              .getDateTimeModelFromTimeStamp(
                                                  this
                                                          .widget
                                                          .missionModel
                                                          .end_time ??
                                                      0))
                                          : getI18NKey().none,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: ColorsConfig.darkRed),
                                    ),
                                    IconButton(
                                      //点击x按钮清空数据
                                      icon: Icon(Icons.cancel,
                                          size: 20,
                                          color: ColorsConfig.gray_cc_cancel),
                                      onPressed: () {
                                        this.isNeedUpdateBmob = true;
                                        this.widget.missionModel.end_time =
                                            null;
                                        // this.widget.missionModel.end_time =
                                        //     Utility.getTimeStampToday();
                                        // this.widget.missionModel.end_time = 0;
                                        this.updateUI();
                                      },
                                    )
                                  ],
                                ),
                                icon: Utility.getSVGPicture(
                                    R.assetsImgIcEndtime2Orange,
                                    size: StylesConfig.iconSize,
                                    color: ThemeManager.getInstance()
                                        .getDefautThemeColor())),
                      this.widget.missionModel.isFinished == true
                          ? SizedBox.shrink()
                          : Utility.shouldShowAlert(
                                      missionModelType: this
                                          .widget
                                          .missionModel
                                          .missionModelType) ==
                                  false
                              ? SizedBox.shrink()
                              : MenuItem2(
                                  useCreateMissionMobileStyle:
                                      Utility.isHandsetBySize(),
                                  title: getI18NKey().alert,
                                  subTitle: "(${getI18NKey().optional})",
                                  onTapListener: (data) async {
                                    DateTimeModel? model;
                                    TimeOfDay? timeOfDay;
                                    if (this.widget.missionModel.repetiveType ==
                                        0) {
                                      model = await Utility
                                          .showDateTimePickerDialog(context);
                                      if (model == null) {
                                        return;
                                      }
                                      // this.alertTimeModel = model;
                                      this.widget.missionModel.alert_time =
                                          model.timestamp; //设置提醒时间
                                      // if (model.timestamp > 0) {
                                      //   Params.shouldRefreshPushModelList = true;
                                      // }
                                    } else {
                                      timeOfDay =
                                          await Utility.showTimePickerDialog(
                                              context);
                                      if (timeOfDay == null) {
                                        return;
                                      }
                                      this.widget.missionModel.alert_time =
                                          timeOfDay.hour * 60 * 60 * 1000 +
                                              timeOfDay.minute * 60 * 1000;
                                      // if((this.widget.missionModel.alert_time??0) > 0) {
                                      //   Params.shouldRefreshPushModelList = true;
                                      // }
                                    }
                                    this.setState(() {
                                      this.isNeedUpdateBmob = true;
                                    });
                                    this.requestNotification();
                                    // NotificationManager.getInstance()
                                  },
                                  rightPartContainer: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        TextUtil.isEmpty(this
                                                    .widget
                                                    .missionModel
                                                    .alert_time) ==
                                                false
                                            ? (this
                                                        .widget
                                                        .missionModel
                                                        .repetiveType ==
                                                    0
                                                ? CONSTANTS.getAlertDateString(Utility
                                                    .getDateTimeModelFromTimeStamp(
                                                        this
                                                                .widget
                                                                .missionModel
                                                                .alert_time ??
                                                            0))
                                                : Utility.formatHourAndMin2(this
                                                        .widget
                                                        .missionModel
                                                        .alert_time ??
                                                    0))
                                            : getI18NKey().none,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: ColorsConfig.gray_a3_icon),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel,
                                            size: 20,
                                            color: ColorsConfig.gray_cc_cancel),
                                        onPressed: () {
                                          this.isNeedUpdateBmob = true;
                                          this.widget.missionModel.alert_time =
                                              0;
                                          this.updateUI();
                                        },
                                      )
                                    ],
                                  ),
                                  icon: Utility.getSVGPicture(
                                      R.assetsImgIcAlarmOrange,
                                      size: StylesConfig.iconSize,
                                      color: ThemeManager.getInstance()
                                          .getDefautThemeColor())),
                      if (this.widget.missionModel?.time_mode == 0)
                        (this.widget.missionModel.isFinished == true)
                            ? SizedBox.shrink()
                            : Utility.shouldShowAlert(
                                        missionModelType: this
                                            .widget
                                            .missionModel
                                            .missionModelType) ==
                                    false
                                ? SizedBox.shrink()
                                : MenuItem2(
                                    useCreateMissionMobileStyle:
                                        Utility.isHandsetBySize(),
                                    title: getI18NKey().repetive,
                                    subTitle: "(${getI18NKey().optional})",
                                    onTapListener: (data) {
                                      SelectDatePeriodDialogUtil.show(context,
                                          okCallBack: (valueMiddleSelected,
                                              valueRightSelected,
                                              listCheckModels) {
                                        this.isNeedUpdateBmob = true;
                                        this.widget.missionModel.repetiveValue =
                                            valueMiddleSelected; //更新值
                                        if (this
                                                .widget
                                                .missionModel
                                                .repetiveType !=
                                            valueRightSelected) {
                                          this.widget.missionModel.alert_time =
                                              0;
                                        }
                                        this.widget.missionModel.repetiveType =
                                            valueRightSelected; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复
                                        if (this
                                                    .widget
                                                    .missionModel
                                                    .repetiveWeekDay ==
                                                null ||
                                            (this
                                                        .widget
                                                        .missionModel
                                                        .repetiveWeekDay
                                                        ?.length ??
                                                    0) ==
                                                0)
                                          this
                                              .widget
                                              .missionModel
                                              .repetiveWeekDay = [
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                          ];
                                        if (listCheckModels.length > 5) {
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[0] =
                                              listCheckModels[0].isChecked;
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[1] =
                                              listCheckModels[1].isChecked;
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[2] =
                                              listCheckModels[2].isChecked;
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[3] =
                                              listCheckModels[3].isChecked;
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[4] =
                                              listCheckModels[4].isChecked;
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[5] =
                                              listCheckModels[5].isChecked;
                                          this
                                                  .widget
                                                  .missionModel
                                                  .repetiveWeekDay?[6] =
                                              listCheckModels[6].isChecked;
                                        }
                                        updateAlertTime();
                                        updateUI();
                                        // this.isNeedUpdateBmob = true;
                                      });
                                    },
                                    rightPartContainer: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: Utility.isHandsetBySize()
                                                    ? 160
                                                    : 160,
                                                child: new Text.rich(
                                                  //富文本文本框构造方法，可以显示多种样式的text，第一个参数为 TextSpan
                                                  new TextSpan(
                                                    text: repetiveString,
                                                    //文字样式，如果后面的子 TextSpan 没有覆盖该 TextStyle 中的属性，则使用该 TextStyle 指定的样式
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: ColorsConfig
                                                            .darkRed),
                                                    //应该是手势识别监听器，后面用到手势监听再详细学习该类用法
//          recognizer: ,
                                                    //子 TextSpan，可以指定多个
                                                  ),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                              ),
                                              dateTimeNextTime == null
                                                  ? SizedBox.shrink()
                                                  : Text(
                                                      CONSTANTS
                                                          .getRepetiveDateString2(
                                                              dateTimeNextTime),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorsConfig
                                                              .gray_a3_icon),
                                                    ),
                                            ]),
                                        IconButton(
                                          icon: Icon(Icons.cancel,
                                              size: 20,
                                              color:
                                                  ColorsConfig.gray_cc_cancel),
                                          onPressed: () {
                                            resetRepeativeValue();
                                          },
                                        )
                                      ],
                                    ),
                                    icon: Utility.getSVGPicture(
                                        R.assetsImgIcAlarmOrange,
                                        size: StylesConfig.iconSize,
                                        color: ThemeManager.getInstance()
                                            .getDefautThemeColor())),
                    ]),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: Utility.isHandsetBySize() == true ? 110 : 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ThemeManager.getInstance().getInputThemeColor(
                        defaultColor: const Color(0xFFFFFBF6),
                        defaultDarkColor: const Color(0xFF2E2925),
                      ),
                      border: Border.all(color: _panelBorderColor),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      focusNode: _noteFocusNode,
                      controller: inputNodeConroller,
                      onChanged: (data) {
                        this.isNeedUpdateBmob = true;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 40,
                      //不限制行数
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: getI18NKey().note,
                          hintStyle: new TextStyle(
                              fontSize: 14, color: _secondaryTextColor)),
                      style: TextStyle(color: _primaryTextColor, fontSize: 14),
                      maxLength: 1000,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!Utility.isHandsetBySize())
                    InkWell(
                        onTap: () {
                          this.onClick("onClickUpdate", null);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            width: 260,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  colors: ThemeManager.getInstance()
                                      .getButtonLinearGradientBackgroundColor()),
                            ),
                            child: Text(
                              getI18NKey().create,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ))),
                  SizedBox(
                    height: 20,
                  ),
                ])),
          ])),
    );
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

  void onClickSelectTomatoes(BuildContext context) {
    SelectTomatoesDialogUtil.show(context,
        numTomatoes: (this.widget.missionModel.total_tomotoes ?? 1) - 1,
        duration: this.widget.missionModel.tomato_duration != null
            ? ((this.widget.missionModel.tomato_duration ?? 0) / (60 * 1000) -
                    1)
                .toInt()
            : 25, okCallBack: (numTomatoes, duration) {
      this.widget.missionModel.tomato_duration = (duration + 1) * 60 * 1000;
      this.widget.missionModel.total_tomotoes = numTomatoes + 1;
      this.isNeedUpdateBmob = true;
      updateUI();
      unfocus();
    });
  }

  Future onClickUpdate() async {
    await requestSaveData();
    unfocus();
    // if (Utility.isHandsetBySize()) {
    //   //mobile端返回上一页
    //   Utility.popNavigator(context, null);
    // } else {
    //   //pc端把右端设置隐藏
    //   Utility.popupDesktopRightNavigator(context);
    // }
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    // eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
  }

  SuggestionsController<SuggestionBean> suggestionsUnitController =
      SuggestionsController();
  /**
   * 功能：统一渲染目标模式里的总量/单位输入框装饰，让输入区和暖色卡片风格保持一致。
   */
  InputDecoration _buildObjectiveInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: ThemeManager.getInstance().getInputThemeColor(
        defaultColor: const Color(0xFFF5F0EA),
        defaultDarkColor: const Color(0xFF312A25),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: ThemeManager.getInstance().getDefautThemeColor(),
        ),
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(
        color: ThemeManager.getInstance().getInputPlaceholderColor(),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /**
   * 功能：构建目标单位输入框，支持自定义输入和历史单位 suggestion 选择。
   */
  Widget getUnitInputWidgetForObjective({String placeholder = ""}) {
    return SizedBox(
      width: 86,
      child: TypeAheadField<SuggestionBean>(
        controller: _objectiveUnitController,
        focusNode: _objectiveUnitFocusNode,
        suggestionsController: suggestionsUnitController,
        hideOnEmpty: true,
        showOnFocus: true,
        autoFlipDirection: true,
        debounceDuration: const Duration(milliseconds: 120),
        constraints: const BoxConstraints(
          maxWidth: 180,
          maxHeight: 240,
        ),
        offset: const Offset(0, 8),
        onSelected: (value) {
          _applyObjectiveUnit(value.suggestionContent ?? '', persist: true);
          setState(() {});
        },
        decorationBuilder: (context, child) {
          return Material(
            color: _surfaceColor,
            elevation: 10,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: child,
            ),
          );
        },
        itemBuilder: (BuildContext context, SuggestionBean? value) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            alignment: Alignment.centerLeft,
            constraints: const BoxConstraints(minHeight: 44),
            child: Text(
              value?.suggestion ?? "",
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
        emptyBuilder: (context) => const SizedBox.shrink(),
        suggestionsCallback: (search) {
          final List<SuggestionBean> listSuggestionBean =
              _getObjectiveUnitSuggestions();
          if (TextUtil.isEmpty(search)) {
            return listSuggestionBean;
          }
          return listSuggestionBean.where((item) {
            return (item.suggestion ?? '')
                .toLowerCase()
                .contains(search.toLowerCase());
          }).toList();
        },
        builder: (context, controller, focusNode) {
          return TextField(
            focusNode: focusNode,
            controller: controller,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              LengthLimitingTextInputFormatter(12),
            ],
            onTap: () {
              suggestionsUnitController.open(gainFocus: false);
            },
            onSubmitted: (val) {
              _applyObjectiveUnit(val, persist: true);
              setState(() {});
              focusNode.unfocus();
            },
            onChanged: (val) {
              _applyObjectiveUnit(val);
              suggestionsUnitController.refresh();
            },
            decoration: _buildObjectiveInputDecoration(
              hintText: getI18NKey().unit,
              suffixIcon: Icon(
                Icons.expand_more_rounded,
                size: 16,
                color: _secondaryTextColor,
              ),
            ),
          );
        },
      ),
    );
  }

  /**
   * 功能：构建目标总量输入框，并在输入时实时刷新滑杆最大值。
   */
  Widget getTotalInputWidgetForObjective() {
    return SizedBox(
      width: 86,
      child: TextField(
        focusNode: _objectiveTotalFocusNode,
        controller: _objectiveTotalController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        onChanged: _applyObjectiveTotal,
        onSubmitted: (val) {
          _applyObjectiveTotal(val);
          _objectiveTotalFocusNode.unfocus();
        },
        decoration: _buildObjectiveInputDecoration(
          hintText: getI18NKey().total_value,
        ),
      ),
    );
  }

  /**
   * 点击选择优先级
   */
  Future onTapPriority(int priority) async {
    this.widget.missionModel.priorityStatus = priority;
  }

  /**
   * 获取优先级Icon
   */
  Widget getPriorityIcon(missionModel, {double iconSize = 30}) {
    int priorityStatus = missionModel?.priorityStatus ?? 3;
    return CONSTANTS
            .getPriorityModels(iconSize: iconSize)[priorityStatus]
            .icon ??
        SizedBox.shrink();
  }
}
