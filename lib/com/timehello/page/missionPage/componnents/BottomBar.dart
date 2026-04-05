import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:string_validator/string_validator.dart';
import 'package:time_hello/com/timehello/components/CustomCloseButton.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/components/HorizontalNumberPickerWrapper.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnChangeListener.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/KeyboardListenerManager.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../beans/BaseBean.dart';
import '../../../beans/SuggestionBean.dart';
import '../../../beans/UserBean.dart';
import '../../../common/database/apis/MongoApisManager.dart';
import '../../../common/httpclient/HttpManager.dart';
import '../../../components/CustomFolderModelSelectPopupWidget.dart';
import '../../../components/CustomTagFolderModelSelectPopupWidget.dart';
import '../../../components/IconButtonListWidget.dart';
import '../../../components/SelectDatePeriodDialogUtil.dart';
import '../../../config/Params.dart';
import '../../../models/CheckButtonStateModel.dart';
import '../../../models/DateTimeModel.dart';
import '../../../models/EventFn.dart';
import '../../../models/FolderModel.dart';
import '../../../util/ChatGroupManager.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/OverlayManagement.dart';
import '../../../util/TextUtil.dart';
import '../../CreateAIChatGptMissionPage/CreateAIChatGptMissionPage.dart';

typedef OnTapDateListener = void Function(dynamic data);
typedef OnTapAlertDateListener = void Function(dynamic data);
typedef OnTapMissionTypeListener = void Function(dynamic data);
typedef OnTapUpdateDateListener = void Function(
    {dynamic startDate,
    dynamic alertDate,
    dynamic dailyStartDate,
    dynamic dailyEndDate,
    int time_mode});
// typedef OnTapDailyEndDateListener = void Function({dynamic endDate});
typedef OnTapBottomBarPriorityListener = void Function(dynamic data);
typedef OnTapBottomBarTagListener = void Function(dynamic data);
typedef OnTapBottomBarCircleListener = void Function(dynamic data);
typedef OnTapBottomBarFinishListener = void Function({dynamic data});
typedef OnTapBottomBarEndTimeListener = void Function({dynamic data});
typedef OnTapBottomBarMissionValueListener = void Function({dynamic data});

class BottomBar extends StatefulWidget {
  bool isVisible = false;
  bool useUnifiedStyle = false;

  FolderModel? folderModel;
  OnTapUpdateDateListener? onTapUpdateDateListener;

  OnTapMissionTypeListener? onTapMissionModelTypeListener;

  // OnTapDailyEndDateListener? onTapDailyEndDateListener;
  OnChangeListener? onChangeListener;
  OnTapDateListener? onTapDateListener;
  OnTapBottomBarEndTimeListener? onTapEndTimeListener;
  OnTapBottomBarPriorityListener? onTapPriorityListener;
  OnTapBottomBarTagListener? onTapTagListener;
  OnTapBottomBarCircleListener? onTapCircleListener;
  OnTapBottomBarFinishListener? onTapFinishListener;
  OnTapBottomBarMissionValueListener? onTapMissionValueListener;
  OnTapAlertDateListener? onTapAlertDateListener;
  Function? onChangeTotalValAndUnit;
  int iconType = 0; // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
  int priority = 0;
  String? tagName = "";
  int dateStatus = 0;
  int time_mode = 0;
  int? mission_value;
  int totalTomatoes;
  int end_time = 0;
  int alert_time = 0;
  int start_time = 0;
  int missionModelType = 0;

  String objectiveUnit = ""; //目标单位

  double objectiveValue = 0; //目标值

  double objectiveStartValue = 0; //目标值

  double objectiveTotalValue = 0; //目标值完成

  Color tagColor = ColorsConfig.gray_cc_cancel;
  String circleTitle = "";
  Color circleColor = ColorsConfig.gray_cc_cancel;
  Icon? iconCircle;
  List? repetiveWeekDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  BottomBar(
      {Key? key,
      this.isVisible = false,
      this.useUnifiedStyle = false,
      this.start_time = 0,
      this.missionModelType = 0,
        this.folderModel,
      this.alert_time = 0,
        this.objectiveUnit = "",
        this.objectiveValue = 0,
        this.objectiveStartValue = 0,
        this.objectiveTotalValue = 0,

      this.end_time = 0,
      this.mission_value,
      this.onChangeListener,
      this.onTapAlertDateListener,
      this.onTapMissionModelTypeListener,
        this.onChangeTotalValAndUnit,
      this.onTapFinishListener,
      this.onTapDateListener,
      this.onTapUpdateDateListener,
      this.time_mode = 0,
      this.tagName,
      this.onTapPriorityListener,
      required this.totalTomatoes,
      this.dateStatus = 0,
      this.onTapEndTimeListener,
      required this.tagColor,
      this.iconCircle,
      this.onTapTagListener,
      this.circleTitle = "",
      required this.circleColor,
      this.iconType = 0,
      this.priority = 0,
      this.onTapMissionValueListener,
      this.onTapCircleListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BottomBarState(
        iconCircle: this.iconCircle,
        dateStatus: this.dateStatus,
        iconType: this.iconType,
        totalTomatoes: this.totalTomatoes,
        missionModelType: this.missionModelType,
        tagName: this.tagName,
        mission_value: this.mission_value,
        priority: this.priority,
        tagColor: this.tagColor,
        folderModel: this.folderModel,
        time_mode: this.time_mode,
        circleTitle: this.circleTitle,
        circleColor: this.circleColor);
  }
}

class BottomBarState extends State<BottomBar> {
  // NumberFormat _numberFormat = NumberFormat(',0');
  int? mCurPage;
  PageController? _pageController = PageController();
  int time_mode = 0;
  int? iconType = 0;
  int? priority = 0;
  String? tagName = "";
  Color? tagColor = ColorsConfig.gray_cc_cancel;
  String? circleTitle = "";
  Color? circleColor = ColorsConfig.gray_cc_cancel;
  int? dateStatus = 0;
  Icon? iconCircle;
  int? end_time;
  int? mission_value;
  int? daily_start_time;
  int totalTomatoes;
  int missionModelType = 0;
  int? daily_end_time;
  int start_time = 0;
  String objectiveUnit = ""; //目标单位

  double objectiveValue = 0; //目标值

  double objectiveStartValue = 0; //目标值

  double objectiveTotalValue = 0; //目标值完成
  List<CheckButtonStateModel> listCheckButtonStateModelTabBar = [];
  GlobalKey<CustomTabBarWidgetState> _tabBarKey = GlobalKey();

  // int totalTomatoes = 1;
  int? alert_time;
  double paddingTop = 3;
  double marginRight = 10;
  double iconSize = 20;
  int repetiveType = 0;
  int repetiveValue = 0;
  List repetiveWeekDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  FolderModel? folderModel;

  BottomBarState(
      {this.iconCircle,
        this.folderModel,
      this.dateStatus,
      this.time_mode = 0,
        this.objectiveUnit = "",
        this.objectiveValue = 0,
        this.objectiveStartValue = 0,
        this.objectiveTotalValue = 0,
      required this.totalTomatoes,
      this.missionModelType = 0,
      this.tagColor,
      this.tagName,
      this.mission_value,
      // this.totalTomatoes = 1,
      this.iconType,
      this.priority,
      this.circleTitle,
      this.circleColor});

  @override
  void didUpdateWidget(BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.folderModel = this.widget.folderModel;
    this.iconCircle = this.widget.iconCircle;
    this.dateStatus = this.widget.dateStatus;
    this.mission_value = this.widget.mission_value;
    this.iconType = this.widget.iconType;
    this.tagColor = this.widget.tagColor;
    this.tagName = this.widget.tagName;
    this.priority = this.widget.priority;
    this.circleColor = this.widget.circleColor;
    this.circleTitle = this.widget.circleTitle;
    this.objectiveUnit = this.widget.objectiveUnit;
    this.objectiveValue = this.widget.objectiveValue;
    this.objectiveStartValue = this.widget.objectiveStartValue;
    this.objectiveTotalValue = this.widget.objectiveTotalValue;

    // this.missionModelType = this.widget.missionModelType;
  }

  updateEndTimeByState(int dateStatus) {
    this.end_time = CONSTANTS.getDeadLineTme(dateStatus);
    setState(() {});
  }

  @override
  void initState() {
    Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
    // 1 今天 2 明天 3 7天后 4 所有为完成任务 12 待定任务 13 碎片清单
    this.end_time = CONSTANTS.getDeadLineTme(this.widget.dateStatus);
    eventBus.on<EventFn>().listen((EventFn event) {
      //这个不需要也行 但是有一个用户反馈创建用户没刷新这里
      if (event.type == Params.ACTION_UPDATE_VALUE_PER_DAY && mounted) {
        setState(() {
          this.totalTomatoes = event.obj['numTomatoes'];
        });
      }
    });
  } // 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单

  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyB)) {
        // ctrl+b&cmd+b begin, 开始专注 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().startFocusing();
      } else if ((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyS) {
        // ctrl+s&cmd+s stop,停止拴住 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().stopFromFocusingStatus();
      } else if ((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyP) {
        // ctrl+p&cmd+p pause,暂停专属拴住 ok
        // CounterManagement.getInstance().pauseTimer();
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().nextStatus(true);
      } else if ((HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.controlLeft)) &&
          key == LogicalKeyboardKey.keyR) {
        // ctrl+r&cmd+r resume,继续专注 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().nextStatus(false);
      } else if (key == LogicalKeyboardKey.space) {
        // 空格 下一个状态 ok
        if (CounterManagement.getInstance().missionModel != null)
          CounterManagement.getInstance().nextStatus(true);
      }
      // else if (
      // (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.metaLeft) || HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) && key == LogicalKeyboardKey.keyF) { // ctrl+f&cmd+f finish,完成专注
      //   this.onClickFinishItem(this.missionModel);
      // }
    }
    return false;
  }

  @override
  void dispose() {
    Keyboardlistenermanager.getInstance()?.addListener(handleKeyEvent);
    _pageController?.dispose();
    super.dispose();
  }

  void updateAlertTime() {
    if (this.time_mode == 1 || this.time_mode == 2) {
      this.alert_time = (this.start_time ?? 0);
    } else {
      if (this.repetiveType == 0 && this.end_time != null) {
        this.alert_time = (this.daily_start_time ?? 0) + (this.end_time ?? 0);
      } else {
        this.alert_time = (this.daily_start_time ?? 0);
      }
      if ((this.alert_time ?? 0) > 0) {
        //加了这个 才会刷新提醒时间
        Params.shouldRefreshPushModelList = true;
      }
    }
  }

  Color get _desktopTextColor => ThemeManager.getInstance()
      .getTextColor(defaultColor: const Color(0xFF463125));

  Color get _desktopSubTextColor => ThemeManager.getInstance()
      .getTextColor(defaultColor: const Color(0xFF9A7A64));

  String _getDateStatusTitle() {
    final List<CheckButtonStateModel> list =
        CONSTANTS.getCheckButtonStateModelList();
    final CheckButtonStateModel? model = list.cast<CheckButtonStateModel?>().firstWhere(
          (element) => element?.value == (this.dateStatus ?? 0),
          orElse: () => null,
        );
    return model?.title ?? getI18NKey().today;
  }

  Widget _buildDesktopChipShell({
    required Widget child,
    VoidCallback? onTap,
    Color backgroundColor = const Color(0xFFFFFBF6),
    Color borderColor = const Color(0xFFE7D8C8),
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
  }) {
    final Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
    if (onTap == null) {
      return content;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: content,
    );
  }

  Widget _buildDesktopValueChip({
    required String label,
    required String value,
    required IconData icon,
    Color? accentColor,
    VoidCallback? onTap,
    VoidCallback? onClear,
  }) {
    final Color color = accentColor ?? const Color(0xFFC78B62);
    final bool hasValue = TextUtil.isEmpty(value) == false &&
        value != getI18NKey().none &&
        value != "";
    return _buildDesktopChipShell(
      onTap: onTap,
      backgroundColor:
          hasValue ? const Color(0xFFFFF5EA) : const Color(0xFFFFFBF6),
      borderColor: hasValue ? const Color(0xFFE7C8AA) : const Color(0xFFE7D8C8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _desktopSubTextColor,
            ),
          ),
          const SizedBox(width: 7),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 165),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: hasValue ? _desktopTextColor : _desktopSubTextColor,
              ),
            ),
          ),
          if (onClear != null && hasValue) ...[
            const SizedBox(width: 7),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onClear,
              child: Icon(Icons.close,
                  size: 14, color: _desktopSubTextColor.withValues(alpha: 0.9)),
            ),
          ] else ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                size: 16, color: _desktopSubTextColor),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopQuickDateChip(CheckButtonStateModel model) {
    final bool isSelected = (this.dateStatus ?? 0) == (model.value ?? 0);
    return _buildDesktopChipShell(
      onTap: () {
        if (this.widget.onTapDateListener != null) {
          this.widget.onTapDateListener?.call(model.value);
          updateEndTimeByState(model.value);
        }
      },
      backgroundColor:
          isSelected ? const Color(0xFFFFE8C6) : const Color(0xFFFFFBF6),
      borderColor:
          isSelected ? const Color(0xFFE1B882) : const Color(0xFFE7D8C8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: Text(
        model.title ?? "",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isSelected ? const Color(0xFF8A5A34) : _desktopTextColor,
        ),
      ),
    );
  }

  Widget _buildDesktopCreateButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_create_button",
          "description": "创建",
        });
        if (this.widget.onTapFinishListener != null) {
          this.widget.onTapFinishListener!();
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFD09063),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD09063).withValues(alpha: 0.22),
              blurRadius: 12,
              offset: const Offset(0, 8),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getI18NKey().create,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopQuickActionRow(BuildContext context) {
    final List<CheckButtonStateModel> quickDateModels =
        CONSTANTS.getCheckButtonStateModelList().where((model) {
      return model.code == "today" ||
          model.code == "tomorrow" ||
          model.code == "this_week" ||
          model.code == "do_it_now";
    }).toList();

    return LayoutBuilder(builder: (context, constraints) {
      final bool compact = constraints.maxWidth < 820;
      final Widget chips = Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            quickDateModels.map((model) => _buildDesktopQuickDateChip(model)).toList(),
      );
      if (compact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chips,
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: _buildDesktopCreateButton()),
          ],
        );
      }
      return Row(
        children: [
          Expanded(child: chips),
          const SizedBox(width: 14),
          SizedBox(width: 138, child: _buildDesktopCreateButton()),
        ],
      );
    });
  }

  Widget getDesktopWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (Utility.shouldShowDailyIcon(
                        missionModelType: this.missionModelType))
                      getDailyWidget(),
                    if (Utility.shouldShowPriority(
                        missionModelType: this.missionModelType))
                      getPriorityWidget(),
                    if (Utility.shouldShowTag(
                        missionModelType: this.missionModelType))
                      getTagNameWidget(),
                    if (Utility.shouldShowCircleFolderId(
                        missionModelType: this.missionModelType))
                      getCircleFolderModelWidget(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Center(
                  child: IconButtonListWidget(
                    popupModeEnum: PopupModeEnum.popup,
                    initIndex: this.missionModelType,
                    list: CONSTANTS.getMissionTypeButtonList(defaultVal: 0),
                    onTapListener: (obj) {
                      switch (obj['data'].code) {
                        case 'normal':
                          this.widget.onTapMissionModelTypeListener?.call(0);
                          _tabBarKey.currentState?.setChecked(0);
                          this.missionModelType = 0;
                          this.time_mode = 0;
                          break;
                        case 'calendar':
                          this.widget.onTapMissionModelTypeListener?.call(1);
                          _tabBarKey.currentState?.setChecked(0);
                          this.missionModelType = 1;
                          this.time_mode = 1;
                          break;
                        case 'alarm':
                          this.widget.onTapMissionModelTypeListener?.call(2);
                          _tabBarKey.currentState?.setChecked(0);
                          this.missionModelType = 2;
                          this.time_mode = 0;
                          break;
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTabBarWidget(
            key: _tabBarKey,
            isAutoTrigger: true,
            list: getDataList(),
            onCheckedListener: (int index, CheckButtonStateModel model) {
              if (model.code == 'time' || model.code == 'objective') {
                if (LoginManager.getInstance().isVIP(shouldShowDialog: true) ==
                    false) {
                  return;
                }
              }
              reset(model: model);
            },
            fontSize: 13,
            useUnifiedStyle: true,
          ),
          if (this.time_mode == 2) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (Utility.shouldUnit(missionModelType: this.missionModelType))
                  getTotalValInputWidgetForObjective(),
                if (Utility.shouldTotalVal(
                    missionModelType: this.missionModelType))
                  getUnitInputWidgetForObjective(),
              ],
            ),
          ],
          if (this.time_mode == 0 || this.time_mode == 1 || this.time_mode == 2)
            ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (Utility.shouldShowBeginTime(
                      missionModelType: this.missionModelType))
                    getDailyStartTimeWidget(context),
                  if (Utility.shouldShowEndTime(
                      missionModelType: this.missionModelType))
                    getDailyEndTimeWidget(context),
                  if (!(this.time_mode == 1 || this.time_mode == 2) &&
                      Utility.shouldShowEndTime(
                          missionModelType: this.missionModelType))
                    getEndTimeWidget(context),
                ],
              ),
              if (!(this.time_mode == 1 || this.time_mode == 2)) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (Utility.shouldShowAlert(
                        missionModelType: this.missionModelType))
                      getAlertTimeWidget(context),
                    getRepeativeWidget(context),
                    if (Utility.shouldShowValue(
                        missionModelType: this.missionModelType))
                      getMissionValueWidget(context),
                  ],
                ),
              ],
            ],
          const SizedBox(height: 12),
          _buildDesktopQuickActionRow(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Offstage(
        offstage: !this.widget.isVisible,
        child: this.widget.useUnifiedStyle
            ? getDesktopWidget(context)
            : getMobileWidget(context));
  }

  Container getMobileWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        color: ThemeManager.getInstance()
            .getBackgroundColor(defaultColor: ColorsConfig.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: paddingTop),
                    height: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            if (Utility.shouldShowDailyIcon(
                                missionModelType: this.missionModelType))
                              getDailyWidget(),
                            if (Utility.shouldShowDailyIcon(
                                missionModelType: this.missionModelType))
                              SizedBox(
                                width: marginRight,
                              ),
                            if (Utility.shouldShowPriority(
                                missionModelType: this.missionModelType))
                              getPriorityWidget(),
                            if (Utility.shouldShowPriority(
                                missionModelType: this.missionModelType))
                              SizedBox(
                                width: marginRight,
                              ),
                            if (Utility.shouldShowTag(
                                missionModelType: this.missionModelType))
                              getTagNameWidget(),
                            if (Utility.shouldShowTag(
                                missionModelType: this.missionModelType))
                              SizedBox(
                                width: marginRight,
                              ),
                            if (Utility.shouldShowCircleFolderId(
                                missionModelType: this.missionModelType))
                              getCircleFolderModelWidget(),
                          ],
                        ),
                        Spacer(),
                        IconButtonListWidget(
                          popupModeEnum: PopupModeEnum.popup,
                          initIndex: this.missionModelType,
                          list:
                              CONSTANTS.getMissionTypeButtonList(defaultVal: 0),
                          onTapListener: (obj) {
                            switch (obj['data'].code) {
                              case 'normal':
                                this
                                    .widget
                                    .onTapMissionModelTypeListener
                                    ?.call(0);
                                _tabBarKey.currentState?.setChecked(0);
                                this.missionModelType = 0;
                                this.time_mode = 0;
                                break;
                              case 'calendar':
                                this
                                    .widget
                                    .onTapMissionModelTypeListener
                                    ?.call(1);
                                _tabBarKey.currentState?.setChecked(0);
                                this.missionModelType = 1;
                                this.time_mode = 1;
                                break;
                              case 'alarm':
                                this
                                    .widget
                                    .onTapMissionModelTypeListener
                                    ?.call(2);
                                _tabBarKey.currentState?.setChecked(0);
                                this.missionModelType = 2;
                                this.time_mode = 0;
                                break;
                            }
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  // if (this.widget.missionModelType == 0) //
                  CustomTabBarWidget(
                    key: _tabBarKey,
                  isAutoTrigger: true,
                    list: getDataList(),
                    // 0 任务 1 日程 2 闹钟提醒
                    onCheckedListener: (int index, CheckButtonStateModel model) {
                      if(model.code == 'time' || model.code == 'objective') {
                      // if (index == 1 || index == 2) {
                        if (LoginManager.getInstance()
                                .isVIP(shouldShowDialog: true) ==
                            false) {
                          return;
                        }
                      }
                      // CheckButtonStateModel checkButtonStateModel = model;
                      reset(model: model);
                    },
                    fontSize: 14,
                  ),
                  if (this.time_mode == 2)
                    Container(
                    padding: EdgeInsets.symmetric(vertical: paddingTop),
                    child: Row(
                      children: [
                        if (Utility.shouldUnit(
                            missionModelType: this.missionModelType))
                          getTotalValInputWidgetForObjective(),
                        SizedBox(
                          width: 10,
                        ),
                        if (Utility.shouldTotalVal(
                            missionModelType: this.missionModelType))
                          getUnitInputWidgetForObjective(),
                      ],
                    ),
                  ),

                  if (this.time_mode == 0 || this.time_mode == 1 || this.time_mode == 2)
                    ...getListWidgetForTimeModeDateAndTimeSegment(context),
                  // if (this.time_mode == 2)
                  //   ...getListWidgetForObjective(context),
                ],
              ),
            )
          ],
        ));
  }

  List<CheckButtonStateModel> getDataList() {
    return listCheckButtonStateModelTabBar = (this.folderModel?.tag == 5 ? CONSTANTS.getSettingItemDetailCheckButtonListForOnlyObjective(
                      defaultVal: 0): this.missionModelType == 0
                      ? CONSTANTS.getSettingItemDetailCheckButtonList(
                          defaultVal: 0)
                      : this.missionModelType == 1 // 1 需要
                          ? CONSTANTS
                              .getOnlySettingItemDetailCheckButtonListForCalendar()
                          : CONSTANTS
                              .getOnlySettingItemDetailCheckButtonListForAlarm());
  }

  void reset({CheckButtonStateModel? model}) {
    if(model == null) {
      model = getDataList()[0];
      _tabBarKey.currentState?.setChecked(0);
    }
       String code = model?.code ?? "";
    this.daily_start_time = null;
    this.daily_end_time = null;
    switch(code) {
      case 'date':
        this.time_mode = 0;
    
        break;
      case 'time':
        this.time_mode = 1;
        break;
      case 'objective':
        this.time_mode = 2;
        break;
    }
    // this.time_mode = index; // 0 日期 1 时间段 2 目标
    this.end_time = 0;
    this.alert_time = 0;
    this.start_time = 0;
    
    setState(() {});
  }

  // List<Widget> getListWidgetForTimeModeObjective(BuildContext context) {
  //   return [
  //     Container(
  //       padding: EdgeInsets.symmetric(vertical: paddingTop),
  //       child: Row(
  //         children: [
  //           if (Utility.shouldShowBeginTime(
  //               missionModelType: this.missionModelType))
  //             getDailyStartTimeWidget(context),
  //           SizedBox(
  //             width: 0,
  //           ),
  //           if (Utility.shouldShowEndTime(
  //               missionModelType: this.missionModelType))
  //             getDailyEndTimeWidget(context),
  //           (this.time_mode == 1 || this.time_mode == 2)
  //               ? SizedBox.shrink()
  //               : Utility.shouldShowEndTime(
  //                       missionModelType: this.missionModelType)
  //                   ? getEndTimeWidget(context)
  //                   : SizedBox.shrink(),
  //         ],
  //       ),
  //     ),
  //     (this.time_mode == 1||this.time_mode == 2)
  //         ? SizedBox.shrink()
  //         : Container(
  //             padding: EdgeInsets.symmetric(vertical: paddingTop),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.max,
  //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 if (Utility.shouldShowAlert(
  //                     missionModelType: this.missionModelType))
  //                   getAlertTimeWidget(context),
  //                 getRepeativeWidget(context),
  //                 SizedBox(
  //                   width: 0,
  //                 ),
  //                 // getEndTimeWidget(context),
  //               ],
  //             ),
  //           ),
  //     Container(
  //       padding: EdgeInsets.symmetric(vertical: paddingTop),
  //       child: getBottomWidget(context),
  //     )
  //   ];
  // }
  SuggestionsController<SuggestionBean> suggestionsController = SuggestionsController();
  TextEditingController inputController = TextEditingController();
  FocusNode? _contentFocusNode = FocusNode();
  String? value = "";

  getTotalValInputWidgetForObjective({String placeholder = ""}) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          getI18NKey().total_value,
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 25,
          width: 120,
          child: TextField(

            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数

              LengthLimitingTextInputFormatter(
                  10), // 限制最大输入长度为500字符
            ],
            // enabled: this.isLoading2 == 0,
            // focusNode: _contentFocusNode = focusNode,
            // controller: inputController = controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (val) {
              // callback for regular enter key press
              // this.widget.onClickSendMsg(
              //     inputController.text);
              // inputController.text = '';
            },
            onEditingComplete: () {
              final isCtrlPressed = RawKeyboard
                  .instance.keysPressed
                  .contains(
                  LogicalKeyboardKey.controlLeft);
              if (isCtrlPressed) {
                // insert a new line character
                // inputController.value =
                //     TextEditingValue(
                //       text: inputController.text + '\n',
                //       selection: TextSelection.collapsed(
                //           offset: inputController
                //               .text.length +
                //               1),
                //     );
              } else {
                // trigger the callback for regular enter key press
                // this.onClickSendMsg(inputController.text);
              }
            },
            scrollController: ScrollController(),
            onChanged: (val) {
              // this.value = val;
              this.objectiveTotalValue = val.toDouble();
              this.widget.onChangeTotalValAndUnit?.call(this.objectiveTotalValue, this.objectiveUnit);
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
              fillColor: ThemeManager.getInstance().getInputDecorationColor(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              hintText: getI18NKey().total_value,
              hintStyle: TextStyle(
                  color: ThemeManager.getInstance().getInputPlaceholderColor(),
                  fontSize: 11),
            ),
            // onChanged: (value) => _checkPasswordMatch(),
          ),
        ),
      ],
    );
  }

  getUnitInputWidgetForObjective({String placeholder = "123"}) {
    List<SuggestionBean> listSuggestionBean = MongoApisManager.getInstance().getSuggestionBeans();
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          getI18NKey().unit,
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
        SizedBox(
          width: 5,
        ),
        TypeAheadField<SuggestionBean>(
          // controller: controller,
          suggestionsController: suggestionsController,
          hideOnEmpty: true,
          autoFlipDirection: true,
          onSelected: (value) {
            inputController.text =
                value.suggestionContent ?? '';
            this.objectiveUnit = value.suggestionContent ?? '';
            this.widget.onChangeTotalValAndUnit?.call(this.objectiveTotalValue, this.objectiveUnit);

            // this.widget.onClickSendMsg(inputController.text);
            // inputController.text = '';
          },
          itemBuilder: (BuildContext context,
              SuggestionBean? value) {
            return Container(
              padding:
              EdgeInsets.symmetric(horizontal: 5),
              color: ThemeManager.getInstance()
                  .getCardBackgroundColor(),
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
            for (var item
            in listSuggestionBean ?? []) {
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
              width: 120,
              child: TextField(
                    focusNode: _contentFocusNode = focusNode,
                    controller: inputController = controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (val) {
                      // callback for regular enter key press
                      // this.widget.onClickSendMsg(
                      //     inputController.text);
                      inputController.text = '';
                    },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      10), // 限制最大输入长度为500字符
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
                  final isCtrlPressed = RawKeyboard
                      .instance.keysPressed
                      .contains(
                      LogicalKeyboardKey.controlLeft);
                  if (isCtrlPressed) {
                    // insert a new line character
                    inputController.value =
                        TextEditingValue(
                          text: inputController.text + '\n',
                          selection: TextSelection.collapsed(
                              offset: inputController
                                  .text.length +
                                  1),
                        );
                  } else {
                    // trigger the callback for regular enter key press
                    // this.onClickSendMsg(inputController.text);
                  }
                },
                scrollController: ScrollController(),
                onChanged: (val) {
                  this.value = val;
                  this.objectiveUnit = val;
                  this.widget.onChangeTotalValAndUnit?.call(this.objectiveTotalValue, this.objectiveUnit);
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
                  fillColor: ThemeManager.getInstance().getInputDecorationColor(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: getI18NKey().unit,
                  hintStyle: TextStyle(
                      color: ThemeManager.getInstance().getInputPlaceholderColor(),
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

  List<Widget> getListWidgetForObjective(BuildContext context) {
    return [
      Container(
        padding: EdgeInsets.symmetric(vertical: paddingTop),
        child: Row(
          children: [
            if (Utility.shouldUnit(
                missionModelType: this.missionModelType))
            getTotalValInputWidgetForObjective(),
            SizedBox(
              width: 10,
            ),
            if (Utility.shouldTotalVal(
                missionModelType: this.missionModelType))
              getUnitInputWidgetForObjective(),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: paddingTop),
        child: Row(
          children: [
            if (Utility.shouldShowBeginTime(
                missionModelType: this.missionModelType))
              getDailyStartTimeWidget(context),
            SizedBox(
              width: 0,
            ),
            if (Utility.shouldShowEndTime(
                missionModelType: this.missionModelType))
              getDailyEndTimeWidget(context),
            // this.time_mode == 1
            //     ? SizedBox.shrink()
            //     : Utility.shouldShowEndTime(
            //             missionModelType: this.missionModelType)
            //         ? getEndTimeWidget(context)
            //         : SizedBox.shrink(),
          ],
        ),
      ),
      (this.time_mode == 1 || this.time_mode == 2)
          ? SizedBox.shrink()
          : Container(
              padding: EdgeInsets.symmetric(vertical: paddingTop),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Utility.shouldShowAlert(
                      missionModelType: this.missionModelType))
                    getAlertTimeWidget(context),
                  getRepeativeWidget(context),
                  SizedBox(
                    width: 0,
                  ),
                  // getEndTimeWidget(context),
                ],
              ),
            ),
      Container(
        padding: EdgeInsets.symmetric(vertical: paddingTop),
        child: getBottomWidget(context),
      )
    ];
  }

  //日期和时间段用这个
  List<Widget> getListWidgetForTimeModeDateAndTimeSegment(
      BuildContext context) {
    return [
      Container(
        padding: EdgeInsets.symmetric(vertical: paddingTop),
        child: Row(
          children: [
            if (Utility.shouldShowBeginTime(
                missionModelType: this.missionModelType))
              getDailyStartTimeWidget(context),
            SizedBox(
              width: 0,
            ),
            if (Utility.shouldShowEndTime(
                missionModelType: this.missionModelType))
              getDailyEndTimeWidget(context),
            (this.time_mode == 1 || this.time_mode == 2)
                ? SizedBox.shrink()
                : Utility.shouldShowEndTime(
                        missionModelType: this.missionModelType)
                    ? getEndTimeWidget(context)
                    : SizedBox.shrink(),
          ],
        ),
      ),
      (this.time_mode == 1 || this.time_mode == 2)
          ? SizedBox.shrink()
          : Container(
              padding: EdgeInsets.symmetric(vertical: paddingTop),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Utility.shouldShowAlert(
                      missionModelType: this.missionModelType))
                    getAlertTimeWidget(context),
                  getRepeativeWidget(context),
                  SizedBox(
                    width: 0,
                  ),
                  // getEndTimeWidget(context),
                ],
              ),
            ),
      Container(
        padding: EdgeInsets.symmetric(vertical: paddingTop),
        child: getBottomWidget(context),
      )
    ];
  }

  CustomPopupWidget getDailyWidget() {
    if (widget.useUnifiedStyle) {
      return CustomPopupWidget(
        onSelected: (v) {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_date_type",
            "description": "任务时间类型",
          });
          if (this.widget.onTapDateListener != null) {
            this.widget.onTapDateListener?.call(v.value);
            updateEndTimeByState(v.value);
          }
        },
        list: CONSTANTS.getCheckButtonStateModelList(),
        child: _buildDesktopValueChip(
          label: getI18NKey().today,
          value: _getDateStatusTitle(),
          icon: Icons.calendar_today_outlined,
          onTap: null,
        ),
      );
    }
    return CustomPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_date_type",
          "description": "任务时间类型",
        });
        if (this.widget.onTapDateListener != null) {
          this.widget.onTapDateListener?.call(v.value);
          updateEndTimeByState(v.value);
        }
      },
      list: CONSTANTS.getCheckButtonStateModelList(),
      child: CONSTANTS.getDateIcon(this.dateStatus ?? 0, iconSize - 2),
    );
  }

  Row getBottomWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (Utility.shouldShowValue(missionModelType: this.missionModelType))
          getMissionValueWidget(context),
        Spacer(),
        InkWell(
          child: new Text(
            getI18NKey().create,
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
              "sceneType": "missionpage",
              "eventType": "missionpage_create_button",
              "description": "创建",
            });
            if (this.widget.onTapFinishListener != null) {
              this.widget.onTapFinishListener!();
            }
          },
        ),
      ],
    );
  }

  Widget getEndTimeWidget(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return _buildDesktopValueChip(
        label: getI18NKey().deadLine,
        value: end_time == null
            ? getI18NKey().none
            : CONSTANTS.getWeekDayString(
                Utility.getDateTimeModelFromTimeStamp(end_time ?? 0)),
        icon: Icons.event_outlined,
        onTap: () async {
          DateTimeModel? model = await Utility.showDatePickerDialog(
              context, CONSTANTS.getDeadLineTme(this.widget.dateStatus) ?? 0);
          this.setState(() {
            this.end_time = model?.datetime?.millisecondsSinceEpoch;
          });
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_end_time",
            "description": "完成时间",
          });
          if (this.widget.onTapEndTimeListener != null) {
            this.widget.onTapEndTimeListener!(data: this.end_time);
          }
        },
        onClear: () {
          setState(() {
            this.end_time = null;
          });
        },
      );
    }
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().deadLine,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              end_time == null
                  ? getI18NKey().none
                  : CONSTANTS.getWeekDayString(
                      Utility.getDateTimeModelFromTimeStamp(end_time ?? 0)),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.end_time = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        DateTimeModel? model = await Utility.showDatePickerDialog(
            context, CONSTANTS.getDeadLineTme(this.widget.dateStatus) ?? 0);
        this.setState(() {
          this.end_time = model?.datetime?.millisecondsSinceEpoch; //计划到期日
        });
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_end_time",
          "description": "完成时间",
        });
        if (this.widget.onTapEndTimeListener != null) {
          this.widget.onTapEndTimeListener!(data: this.end_time);
        }
      },
    );
  }

  Widget getAlertTimeWidget(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return _buildDesktopValueChip(
        label: getI18NKey().alert,
        value: TextUtil.isEmpty(this.alert_time) == false
            ? (this.repetiveType == 0
                ? CONSTANTS.getAlertDateString(
                    Utility.getDateTimeModelFromTimeStamp(
                        this.alert_time ?? 0))
                : Utility.getHourAndMinsFromDateTimeFromTimeStamp(
                    this.alert_time ?? 0))
            : getI18NKey().none,
        icon: Icons.notifications_none_rounded,
        accentColor: ColorsConfig.colorGold,
        onTap: () async {
          DateTimeModel? model;
          TimeOfDay? timeOfDay;
          if (this.repetiveType == 0) {
            model = await Utility.showDateTimePickerDialog(context);
            if (model == null) {
              return;
            }
            this.alert_time = model.timestamp ?? 0;
          } else {
            timeOfDay = await Utility.showTimePickerDialog(context);
            if (timeOfDay == null) {
              return;
            }
            this.alert_time =
                timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
          }
          this.widget.onTapAlertDateListener?.call(this.alert_time);
          this.setState(() {});
          Utility.requestNotification(context);
        },
        onClear: () {
          this.alert_time = 0;
          this.widget.onTapAlertDateListener?.call(this.alert_time);
          setState(() {});
        },
      );
    }
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().alert,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              TextUtil.isEmpty(this.alert_time) == false
                  ? (this.repetiveType == 0
                      ? CONSTANTS.getAlertDateString(
                          Utility.getDateTimeModelFromTimeStamp(
                              this.alert_time ?? 0))
                      : Utility.getHourAndMinsFromDateTimeFromTimeStamp(
                          this.alert_time ?? 0))
                  : getI18NKey().none,
              style: TextStyle(color: ColorsConfig.colorGold, fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.alert_time = 0;
              this.widget.onTapAlertDateListener?.call(this.alert_time);
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        // if (
        // ChatGroupManager.isFolderModelEnabled(
        //     folderId: this.widget.missionModel.folder_id ?? "",
        //     uid: LoginManager.getInstance().userBean.uid ?? "") ==
        //     false) {
        //   Utility.showToastMsg(
        //       context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
        //   return null;
        // }
        //没有权限提醒设置权限
        DateTimeModel? model;
        TimeOfDay? timeOfDay;
        if (this.repetiveType == 0) {
          model = await Utility.showDateTimePickerDialog(context);
          if (model == null) {
            return;
          }
          // this.alertTimeModel = model;
          this.alert_time = model.timestamp ?? 0; //设置提醒时间
        } else {
          //每日提醒四件
          timeOfDay = await Utility.showTimePickerDialog(context);
          if (timeOfDay == null) {
            return;
          }
          this.alert_time =
              timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
          // if(this.widget.missionModel.alert_time > 0) {
          //   Params.shouldRefreshPushModelList = true;
          // }
        }
        this.widget.onTapAlertDateListener?.call(this.alert_time);
        this.setState(() {
          // this.isNeedUpdateBmob = true;
        });
        Utility.requestNotification(context);
      },
    );
  }

  Widget getMissionValueWidget(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return _buildDesktopValueChip(
        label: getI18NKey().mission_value,
        value: this.widget.mission_value == null
            ? getI18NKey().none
            : (this.widget.mission_value!.toString() + getI18NKey().dollar),
        icon: Icons.paid_outlined,
        accentColor: ColorsConfig.colorGold,
        onTap: () async {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_task_duration",
            "description": "任务价值",
          });
          if (LoginManager.getInstance().userBean.valuePerHour == null ||
              LoginManager.getInstance().userBean.valuePerHour == 0) {
            OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
                context,
                title: getI18NKey().mission_value, okCallBack: (valuePerHour) async {
              OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
              BaseBean response = await HttpManager.getInstance().doPostRequest(
                  Apis.updateValuePerHour,
                  params: {"valuePerHour": valuePerHour},
                  context: context,
                  shouldShowErrorToast: false);
              if (response.success == true) {
                LoginManager.getInstance()
                    .setUserBean(UserBean.fromJson(response.data));
              }
            });
            return;
          }

          OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
              context,
              title: getI18NKey().mission_value, cancelCallBack: () {
            OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
          }, okCallBack: (data) {
            this.setState(() {
              this.widget.mission_value = data;
            });
            OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
            this.widget.onTapMissionValueListener
                ?.call(data: this.widget.mission_value);
          });
        },
        onClear: () {
          setState(() {
            this.widget.mission_value = null;
          });
        },
      );
    }
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().mission_value,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.widget.mission_value == null
                  ? getI18NKey().none
                  : (this.widget.mission_value!.toString() +
                          getI18NKey().dollar) +
                      " (" +
                      getI18NKey()
                          .value_per_hour(Utility.getMissionValuePerHour(
                        totalTomatoes: this.totalTomatoes,
                        missionValue: this.widget.mission_value ?? 0,
                      )) +
                      ")",
              style: TextStyle(color: ColorsConfig.colorGold, fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.widget.mission_value = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_task_duration",
          "description": "任务价值",
        });
        if (LoginManager.getInstance().userBean.valuePerHour == null ||
            LoginManager.getInstance().userBean.valuePerHour == 0) {
          OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
              context,
              title: getI18NKey().mission_value,
              okCallBack: (valuePerHour) async {
            OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
            BaseBean response = await HttpManager.getInstance().doPostRequest(
                Apis.updateValuePerHour,
                params: {"valuePerHour": valuePerHour},
                context: context,
                shouldShowErrorToast: false);
            if (response.success == true) {
              LoginManager.getInstance()
                  .setUserBean(UserBean.fromJson(response.data));
            }
          });
          return;
        }

        OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
            context,
            title: getI18NKey().mission_value, cancelCallBack: () {
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
        }, okCallBack: (data) {
          this.setState(() {
            this.widget.mission_value = data;
          });
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
          this
              .widget
              .onTapMissionValueListener
              ?.call(data: this.widget.mission_value);
        });

        // DateTimeModel? model = await Utility.showDatePickerDialog(
        //     context, CONSTANTS.getDeadLineTme(this.widget.dateStatus) ?? 0);
        // this.setState(() {
        //   this.end_time = model?.datetime?.millisecondsSinceEpoch; //计划到期日
        // });
        // if (this.widget.onTapFinishListener != null) {
        //   this.widget.onTapEndTimeListener!(data: this.end_time);
        // }
      },
    );
  }

  Widget getRepeativeWidget(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return _buildDesktopValueChip(
        label: getI18NKey().repetive,
        value: CONSTANTS.getRepetiveDateString3(
            repetiveType: this.repetiveType,
            repetiveValue: this.repetiveValue,
            repetiveWeekDay: this.repetiveWeekDay),
        icon: Icons.repeat_rounded,
        onTap: () async {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_repeative",
            "description": "重复",
          });

          SelectDatePeriodDialogUtil.show(context, okCallBack:
              (valueMiddleSelected, valueRightSelected, listCheckModels) {
            this.repetiveValue = valueMiddleSelected;
            if (this.repetiveType != valueRightSelected) {
              this.alert_time = 0;
            }
            this.repetiveType = valueRightSelected;
            if (this.repetiveWeekDay == null ||
                this.repetiveWeekDay?.length == 0) {
              this.repetiveWeekDay = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
              ];
            }
            this.repetiveWeekDay?[0] = listCheckModels[0].isChecked;
            this.repetiveWeekDay?[1] = listCheckModels[1].isChecked;
            this.repetiveWeekDay?[2] = listCheckModels[2].isChecked;
            this.repetiveWeekDay?[3] = listCheckModels[3].isChecked;
            this.repetiveWeekDay?[4] = listCheckModels[4].isChecked;
            this.repetiveWeekDay?[5] = listCheckModels[5].isChecked;
            this.repetiveWeekDay?[6] = listCheckModels[6].isChecked;
            updateAlertTime();
            setState(() {});
          });
        },
        onClear: () {
          this.repetiveType = 0;
          this.repetiveValue = 0;
          this.repetiveWeekDay = [
            false,
            false,
            false,
            false,
            false,
            false,
            false,
          ];
          setState(() {});
        },
      );
    }
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().repetive,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              CONSTANTS.getRepetiveDateString3(
                  repetiveType: this.repetiveType,
                  repetiveValue: this.repetiveValue,
                  repetiveWeekDay: this.repetiveWeekDay),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.repetiveType = 0;
              this.repetiveValue = 0;
              this.repetiveWeekDay = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
              ];

              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_repeative",
          "description": "重复",
        });

        SelectDatePeriodDialogUtil.show(context, okCallBack:
            (valueMiddleSelected, valueRightSelected, listCheckModels) {
          this.repetiveValue = valueMiddleSelected; //更新值
          if (this.repetiveType != valueRightSelected) {
            this.alert_time = 0;
          }
          this.repetiveType =
              valueRightSelected; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复
          if (this.repetiveWeekDay == null || this.repetiveWeekDay?.length == 0)
            this
              ..repetiveWeekDay = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
              ];
          this.repetiveWeekDay?[0] = listCheckModels[0].isChecked;
          this.repetiveWeekDay?[1] = listCheckModels[1].isChecked;
          this.repetiveWeekDay?[2] = listCheckModels[2].isChecked;
          this.repetiveWeekDay?[3] = listCheckModels[3].isChecked;
          this.repetiveWeekDay?[4] = listCheckModels[4].isChecked;
          this.repetiveWeekDay?[5] = listCheckModels[5].isChecked;
          this.repetiveWeekDay?[6] = listCheckModels[6].isChecked;
          // requestMongoDbUpdateData();
          updateAlertTime();
          setState(() {});
          // this.isNeedUpdateBmob = true;
        });
      },
    );
  }

  Widget getDailyEndTimeWidget(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return _buildDesktopValueChip(
        label: getI18NKey().end_time,
        value: (this.time_mode == 1 || this.time_mode == 2)
            ? CONSTANTS.getAlertDateString(
                Utility.getDateTimeModelFromTimeStamp(this.end_time ?? 0))
            : this.daily_end_time != null
                ? Utility.formatHourAndMin2(this.daily_end_time ?? 0)
                : getI18NKey().none,
        icon: Icons.hourglass_bottom_rounded,
        onTap: () async {
          if (this.time_mode == 1 || this.time_mode == 2) {
            DateTimeModel? model =
                await Utility.showDateTimePickerDialog(context);
            if ((model?.datetime?.millisecondsSinceEpoch ?? 0) <
                (this.start_time ?? 0)) {
              Utility.showToastMsg(
                  context: context,
                  msg: getI18NKey().end_time_cannot_before_start_time);
              this.end_time = null;
              return;
            }
            this.setState(() {
              this.end_time = model?.datetime?.millisecondsSinceEpoch ?? 0;
            });
          } else {
            TimeOfDay? timeOfDay = await Utility.showTimePickerDialog(context);
            if (timeOfDay == null) {
              return;
            }
            int? startTime = this.daily_start_time;
            int? endTime =
                timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
            if (startTime != null && endTime != null && (startTime > endTime)) {
              Utility.showToastMsg(
                  msg: getI18NKey().end_time_cannot_before_start_time);
              return;
            }
            this.daily_end_time = endTime;
          }
          if (this.widget.onTapUpdateDateListener != null) {
            this.widget.onTapUpdateDateListener!(
                startDate: this.time_mode == 0
                    ? this.daily_start_time
                    : this.start_time,
                alertDate: this.alert_time,
                dailyStartDate: this.time_mode == 0
                    ? this.daily_start_time
                    : this.start_time,
                dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
                time_mode: this.time_mode);
          }
          setState(() {});
        },
        onClear: () {
          this.daily_end_time = null;
          setState(() {});
        },
      );
    }
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().end_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
    (this.time_mode == 1 || this.time_mode == 2)
                  ? CONSTANTS.getAlertDateString(
                      Utility.getDateTimeModelFromTimeStamp(this.end_time ?? 0))
                  : this.daily_end_time != null
                      ? Utility.formatHourAndMin2(this.daily_end_time ?? 0)
                      : getI18NKey().none,
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.daily_end_time = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        if (this.time_mode == 1 || this.time_mode == 2) {
          // DateTimeModel? model =
          //     await Utility.showDateTimePickerDialog(context);
          // updateAlertTime();
          DateTimeModel? model =
              await Utility.showDateTimePickerDialog(context);
          if ((model?.datetime?.millisecondsSinceEpoch ?? 0) <
              (this.start_time ?? 0)) {
            Utility.showToastMsg(
                context: context,
                msg: getI18NKey().end_time_cannot_before_start_time);
            this.end_time = null;
            return;
          }
          this.setState(() {
            this.end_time =
                model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          });
        } else {
          TimeOfDay? timeOfDay;
          timeOfDay = await Utility.showTimePickerDialog(context);
          if (timeOfDay == null) {
            return;
          }

          int? startTime = this.daily_start_time;
          int? endTime =
              timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
          if (startTime != null && endTime != null) {
            bool isBefore = (startTime > endTime);
            if (isBefore) {
              Utility.showToastMsg(
                  msg: getI18NKey().end_time_cannot_before_start_time);
              return;
            }
          }
          this.daily_end_time = endTime;
        }
        if (this.widget.onTapUpdateDateListener != null) {
          this.widget.onTapUpdateDateListener!(
              startDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              alertDate: this.alert_time,
              dailyStartDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
              time_mode: this.time_mode);
        }
        setState(() {});
      },
    );
  }

  Widget getDailyStartTimeWidget(BuildContext context) {
    if (widget.useUnifiedStyle) {
      return _buildDesktopValueChip(
        label: getI18NKey().start_time,
        value: (this.time_mode == 1 || this.time_mode == 2)
            ? CONSTANTS.getAlertDateString(
                Utility.getDateTimeModelFromTimeStamp(this.start_time ?? 0))
            : this.daily_start_time != null
                ? Utility.formatHourAndMin2(this.daily_start_time ?? 0)
                : getI18NKey().none,
        icon: Icons.schedule_rounded,
        onTap: () async {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_start_time",
            "description": "开始时间",
          });
          if (this.time_mode == 1 || this.time_mode == 2) {
            DateTimeModel? model =
                await Utility.showDateTimePickerDialog(context);
            this.setState(() {
              this.start_time = model?.datetime?.millisecondsSinceEpoch ?? 0;
            });
          } else {
            TimeOfDay? timeOfDay = await Utility.showTimePickerDialog(context);
            if (timeOfDay == null) {
              return;
            }
            int? startTime =
                timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
            int? endTime = this.daily_end_time;
            if (startTime != null && endTime != null && (startTime > endTime)) {
              Utility.showToastMsg(
                  msg: getI18NKey().end_time_cannot_before_start_time);
              return;
            }
            this.daily_start_time = startTime;
          }
          updateAlertTime();
          if (this.widget.onTapUpdateDateListener != null) {
            this.widget.onTapUpdateDateListener!(
                startDate: this.time_mode == 0
                    ? this.daily_start_time
                    : this.start_time,
                alertDate: this.alert_time,
                dailyStartDate: this.time_mode == 0
                    ? this.daily_start_time
                    : this.start_time,
                dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
                time_mode: this.time_mode);
          }
          setState(() {});
        },
        onClear: () {
          this.daily_start_time = null;
          this.daily_end_time = null;
          this.start_time = 0;
          this.end_time = 0;
          if (this.widget.onTapUpdateDateListener != null) {
            this.widget.onTapUpdateDateListener!(
                startDate: this.time_mode == 0
                    ? this.daily_start_time
                    : this.start_time,
                alertDate: this.alert_time,
                dailyStartDate: this.time_mode == 0
                    ? this.daily_start_time
                    : this.start_time,
                dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
                time_mode: this.time_mode);
          }
          setState(() {});
        },
      );
    }
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().start_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
    (this.time_mode == 1 || this.time_mode == 2)
                  ? CONSTANTS.getAlertDateString(
                      Utility.getDateTimeModelFromTimeStamp(
                          this.start_time ?? 0))
                  : this.daily_start_time != null
                      ? Utility.formatHourAndMin2(this.daily_start_time ?? 0)
                      : getI18NKey().none,
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.daily_start_time = null;
              this.daily_end_time = null;
              this.start_time = 0;
              this.end_time = 0;
              if (this.widget.onTapUpdateDateListener != null) {
                this.widget.onTapUpdateDateListener!(
                    startDate: this.time_mode == 0
                        ? this.daily_start_time
                        : this.start_time,
                    alertDate: this.alert_time,
                    dailyStartDate: this.time_mode == 0
                        ? this.daily_start_time
                        : this.start_time,
                    dailyEndDate:
                        this.time_mode == 0 ? this.end_time : this.end_time,
                    time_mode: this.time_mode);
              }
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_start_time",
          "description": "开始时间",
        });
        if (this.time_mode == 1 || this.time_mode == 2) {
          DateTimeModel? model =
              await Utility.showDateTimePickerDialog(context);
          // updateAlertTime();
          this.setState(() {
            this.start_time =
                model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          });
        } else {
          TimeOfDay? timeOfDay;
          timeOfDay = await Utility.showTimePickerDialog(context);
          if (timeOfDay == null) {
            return;
          }
          int? startTime =
              timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
          int? endTime = this.daily_end_time;
          if (startTime != null && endTime != null) {
            bool isBefore = (startTime > endTime);
            if (isBefore) {
              Utility.showToastMsg(
                  msg: getI18NKey().end_time_cannot_before_start_time);
              return;
            }
          }

          this.daily_start_time = startTime;
        }
        updateAlertTime();
        if (this.widget.onTapUpdateDateListener != null) {
          this.widget.onTapUpdateDateListener!(
              startDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              alertDate: this.alert_time,
              dailyStartDate:
                  this.time_mode == 0 ? this.daily_start_time : this.start_time,
              dailyEndDate: this.time_mode == 0 ? this.end_time : this.end_time,
              time_mode: this.time_mode);
        }
        setState(() {});
      },
    );
  }

  Widget getPriorityWidget() {
    if (widget.useUnifiedStyle) {
      return CustomPopupWidget(
        onSelected: (v) {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_priority",
            "description": "优先级",
          });
          if (this.widget.onTapPriorityListener != null) {
            this.widget.onTapPriorityListener?.call(v.value);
          }
        },
        list: CONSTANTS.getPriorityList(),
        child: _buildDesktopValueChip(
          label: getI18NKey().priorityStatus,
          value: CONSTANTS.getPriorityDescByIndex(this.priority ?? 3),
          icon: Icons.flag_outlined,
          accentColor: Color(CONSTANTS.getPriorityColor(this.priority ?? 3)),
          onTap: null,
        ),
      );
    }
    return CustomPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_priority",
          "description": "优先级",
        });
        if (this.widget.onTapPriorityListener != null) {
          this.widget.onTapPriorityListener?.call(v.value);
        }
      },
      list: CONSTANTS.getPriorityList(),
      child: CONSTANTS.getPriorityIcon(this.priority ?? 0, size: iconSize + 2),
    );
  }

  CustomTagFolderModelSelectPopupWidget getTagNameWidget() {
    if (widget.useUnifiedStyle) {
      return CustomTagFolderModelSelectPopupWidget(
        onSelected: (v) {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_tags",
            "description": "标签",
          });
          if (this.widget.onTapTagListener != null) {
            this.widget.onTapTagListener!(v);
          }
        },
        child: _buildDesktopValueChip(
          label: getI18NKey().tagNames,
          value: TextUtil.isEmpty(this.tagName) ? getI18NKey().none : (this.tagName ?? ""),
          icon: Icons.local_offer_outlined,
          accentColor: this.tagColor,
          onTap: null,
        ),
      );
    }
    return CustomTagFolderModelSelectPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_tags",
          "description": "标签",
        });
        if (this.widget.onTapTagListener != null) {
          this.widget.onTapTagListener!(v);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer,
            size: iconSize,
            color: this.tagColor,
          ),
          SizedBox(
            width: 5,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 65),
              child: Text(
                this.tagName ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ))
        ],
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     if (this.widget.onTapTagListener != null) {
    //       this.widget.onTapTagListener!();
    //     }
    //   },
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Icon(
    //         Icons.local_offer,
    //         size: iconSize,
    //         color: this.tagColor,
    //       ),
    //       SizedBox(
    //         width: 5,
    //       ),
    //       ConstrainedBox(
    //           constraints: BoxConstraints(maxWidth: 65),
    //           child: Text(
    //             this.tagName ?? "",
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(fontSize: 12),
    //           ))
    //     ],
    //   ),
    // );
  }

  Widget getCircleFolderModelWidget() {
    if (widget.useUnifiedStyle) {
      return CustomFolderModelSelectPopupWidget(
        onSelected: (v) {
          AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
            "sceneType": "missionpage",
            "eventType": "missionpage_select_list",
            "description": "选择清单",
          });
          if (this.widget.onTapCircleListener != null) {
            this.widget.onTapCircleListener?.call(v);
          }
        },
        child: _buildDesktopValueChip(
          label: getI18NKey().task,
          value: TextUtil.isEmpty(this.circleTitle)
              ? getI18NKey().none
              : (this.circleTitle ?? ""),
          icon: Icons.folder_open_outlined,
          accentColor: this.circleColor,
          onTap: null,
        ),
      );
    }
    return CustomFolderModelSelectPopupWidget(
      onSelected: (v) {
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "missionpage",
          "eventType": "missionpage_select_list",
          "description": "选择清单",
        });
        if (this.widget.onTapCircleListener != null) {
          this.widget.onTapCircleListener?.call(v);
        }
      },
      child: Wrap(
        children: [
          this.iconCircle ??
              Icon(Icons.fiber_manual_record,
                  size: iconSize, color: this.circleColor),
          SizedBox(
            width: 5,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text(
                this.circleTitle ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ))
        ],
        crossAxisAlignment: WrapCrossAlignment.center,
      ),
    );
  }

  getWidgetOfHorizontalNumberPickerWrapper() {
    return HorizontalNumberPickerWrapper(
      initialValue: 0,
      minValue: 0,
      maxValue: 1000,
      step: 1,
      unit: getI18NKey().tomato,
      widgetWidth: MediaQuery.of(context).size.width.round() - 68,
      subGridCountPerGrid: 2,
      subGridWidth: 50,
      scaleTextColor: ColorsConfig.red,
      //刻度下的文字颜色
      titleTextColor: ColorsConfig.red,
      indicatorColor: ColorsConfig.red,
      //指示器颜色
      //   scaleColor:ColorsConfig.red,
      onSelectedChanged: (value) {
        if (this.widget.onChangeListener != null) {
          this.widget.onChangeListener!(value);
        }
        print(value);
      },
      titleTransformer: (value) {
        return value.toString();
      },
      scaleTransformer: (value) {
        return value.toString();
        // return '${value ~/ 1000}k';
      },
    );
  }
}

class MissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionWidgetState();
  }
}

class MissionWidgetState extends State<MissionWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw Container();
  }
}
