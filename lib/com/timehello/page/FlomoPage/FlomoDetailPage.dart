import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/IconWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../common/database/apis/MongoApisManager.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../util/DialogManagement.dart';
import '../../util/Utility.dart';
import 'FlomoCreatePage.dart';
import 'components/FlomoDetailCalendarWidget.dart';
import 'components/FlomoDetailClockLogHelper.dart';
import 'components/FlomoDetailObjectiveInfo.dart';
import 'components/FlomoDetailResponsiveLayout.dart';
import 'components/FlomoDetailSettingHelper.dart';
import 'components/FlomoSelectDateWidget.dart';

/**
 * 文件类型：页面
 * 文件作用：展示单个 Flomo 任务的打卡详情、月度统计、打卡记录和目标配置。
 * 主要职责：维护详情页当前日期、同步日历分页，并在桌面端把 item 详情组织成更清晰的分区卡片。
 */
class FlomoDetailPage extends BaseWidget {
  final FlomoMissionModel flomoMissionModel;
  final DateTime curDateTime;

  FlomoDetailPage(
      {Key? key, required this.flomoMissionModel, DateTime? curDateTime})
      : curDateTime = Utility.getFilterDateTimeFromTimeStamp(
            (curDateTime ?? DateTime.now()).millisecondsSinceEpoch),
        super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    return FlomoDetailPageState(curDateTime: this.curDateTime);
  }
}

class FlomoDetailPageState extends BaseWidgetState<FlomoDetailPage> {
  PageController pageController = PageController();
  late CalendarModel calendarModel;
  DateTime curDateTime;
  bool shouldTriggerOnPageChanged = true;
  bool isRequesting = false;

  FlomoDetailPageState({required this.curDateTime});

  /**
   * 功能：响应左侧列表切换任务后的详情页数据刷新。
   * 说明：当 item 变更时同步外部传入日期，避免右侧详情仍停留在上一个任务的月份。
   */
  @override
  void didUpdateWidget(covariant FlomoDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool missionChanged = oldWidget.flomoMissionModel.objectId !=
        widget.flomoMissionModel.objectId;
    final bool monthChanged =
        oldWidget.curDateTime.month != widget.curDateTime.month ||
            oldWidget.curDateTime.year != widget.curDateTime.year;
    if (missionChanged || monthChanged) {
      curDateTime = widget.curDateTime;
      if (pageController.hasClients) {
        jumpToDateTime(curDateTime);
      }
    }
  }

  /**
   * 功能：初始化详情页右上角编辑入口。
   * 说明：保留原有编辑逻辑，只把按钮样式调整为更贴近桌面详情页的胶囊按钮。
   */
  @override
  void initState() {
    super.initState();
    this.rightNavChildren = [
      TextButton(
        onPressed: () async {
          Utility.openPagePCAndMobile(context,
              child: FlomoCreatePage(
                pageModeEnum: 1,
                flomoMissionModel: this.widget.flomoMissionModel,
              ));
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.pencil, size: 14),
            const SizedBox(width: 5),
            Text(getI18NKey().edit),
          ],
        ),
      ),
      PopupMenuButton<String>(
        tooltip: '',
        icon: const Icon(CupertinoIcons.ellipsis_circle, size: 18),
        onSelected: (value) async {
          if (value != 'delete') {
            return;
          }
          // 详情页补一个明确删除入口，避免用户只能回左侧列表里找 hover 菜单。
          await MongoApisManager.getInstance().insertTimelineMissionModel(
              missionModel: Utility.getTimelineMissionModelFromMissionModel(
                  icon: Icons.check_circle.codePoint,
                  color: Colors.greenAccent.toARGB32(),
                  object_id: this.widget.flomoMissionModel.objectId,
                  sceneType: "mission",
                  eventType: "clockin_time",
                  timelineMessage: getI18NKey().delete_flomo_mission(
                      this.widget.flomoMissionModel.title ?? "?")));
          await MongoApisManager.getInstance().delete_FlomoMissionModel(
              currentObjectId: this.widget.flomoMissionModel.objectId);
          if (mounted) {
            Navigator.of(context).maybePop();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'delete',
            child: Text(
              getI18NKey().delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ];
  }

  /**
   * 功能：组件挂载后跳到当前月份。
   * 说明：Calendar 数据在首次 build 后可用，保持原详情页默认定位到今天的行为。
   */
  @override
  componentDidMount() {
    super.componentDidMount();
    jumpToToday();
  }

  /**
   * 功能：让月历 PageView 跳到指定日期所在月份。
   * 入参：dateTime 为左侧日期条或详情页日期选择器传入的目标日期。
   */
  jumpToDateTime(DateTime dateTime) {
    this.curDateTime = dateTime;
    List<MonthModel> listMonthModel = calendarModel.monthModelList;
    int curMonthIndex = 0;
    for (int i = 0; i < listMonthModel.length; i++) {
      MonthModel monthModel = calendarModel.monthModelList[i];
      if (monthModel.dateTime?.year == dateTime.year &&
          monthModel.dateTime?.month == dateTime.month) {
        curMonthIndex = i;
        break;
      }
    }
    shouldTriggerOnPageChanged = false;
    pageController.jumpToPage(curMonthIndex);
    shouldTriggerOnPageChanged = true;
  }

  /**
   * 功能：跳转到当前月份。
   * 说明：用于首次进入详情页，让用户先看到当前月打卡状态。
   */
  jumpToToday() {
    List<MonthModel> listMonthModel = calendarModel.monthModelList;
    int curMonthIndex = 0;
    for (int i = 0; i < listMonthModel.length; i++) {
      MonthModel monthModel = calendarModel.monthModelList[i];
      if (monthModel.isCurrent == true) {
        curMonthIndex = i;
        break;
      }
    }
    pageController.jumpToPage(curMonthIndex);
  }

  /**
   * 功能：构建任务详情页。
   * 说明：参考新图右侧区域，桌面端使用顶部数据卡、中央日历和右侧习惯详情栏；窄屏保留纵向滚动。
   */
  @override
  Widget baseBuild(BuildContext context) {
    return Selector<GlobalStateEnv, List<FlomoMissionModel>>(
        selector: (_, globalStateEnv) => globalStateEnv.listFlomoMissionModel,
        builder: (_, listFlomoMissionModel, __) {
          calendarModel = context.read<GlobalStateEnv>().calendarModel;
          final _FlomoDetailPalette palette =
              _FlomoDetailPalette.fromContext(context);

          return Container(
            decoration: BoxDecoration(
              color: palette.pageBackground,
              gradient: palette.isDark
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xfffffbf5),
                        Color(0xfffff6eb),
                        Color(0xffeef6e9),
                      ],
                    ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool useDashboard =
                    FlomoDetailResponsiveLayout.shouldUseDashboardLayout(
                        constraints.maxWidth);
                final double sidePanelWidth =
                    FlomoDetailResponsiveLayout.sidePanelWidth(
                        constraints.maxWidth);
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    useDashboard ? 18 : 14,
                    useDashboard ? 18 : 14,
                    useDashboard ? 18 : 14,
                    22,
                  ),
                  child: useDashboard
                      ? _buildDashboardLayout(
                          palette: palette,
                          sidePanelWidth: sidePanelWidth,
                        )
                      : _buildStackedLayout(palette: palette),
                );
              },
            ),
          );
        });
  }

  /**
   * 功能：构建桌面端参考图布局。
   * 说明：顶部指标横排，中间左侧承载大日历和补充卡片，右侧固定宽度展示当前习惯详情。
   */
  Widget _buildDashboardLayout({
    required _FlomoDetailPalette palette,
    required double sidePanelWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopStatsGrid(palette: palette),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildCalendarSection(palette: palette),
                  const SizedBox(height: 14),
                  _buildMonthStatsSection(palette: palette),
                  const SizedBox(height: 14),
                  _buildTargetInfoSection(palette: palette),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: sidePanelWidth,
              child: _buildHabitSidePanel(palette: palette),
            ),
          ],
        ),
      ],
    );
  }

  /**
   * 功能：构建窄屏纵向布局。
   * 说明：窄屏没有空间放右侧栏，保留参考图的信息层级但改为上下排列。
   */
  Widget _buildStackedLayout({required _FlomoDetailPalette palette}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHabitSidePanel(palette: palette),
        const SizedBox(height: 14),
        _buildTopStatsGrid(palette: palette),
        const SizedBox(height: 14),
        _buildCalendarSection(palette: palette),
        const SizedBox(height: 14),
        _buildMonthStatsSection(palette: palette),
        const SizedBox(height: 14),
        _buildTargetInfoSection(palette: palette),
      ],
    );
  }

  /**
   * 功能：构建顶部关键数据卡片。
   * 说明：对应参考图顶部“加入天数、连续打卡、本月完成率、本月计划、最长连续”一排指标。
   */
  Widget _buildTopStatsGrid({required _FlomoDetailPalette palette}) {
    final _FlomoMissionStats stats = _buildMissionStats();
    return LayoutBuilder(builder: (context, constraints) {
      final bool compact = constraints.maxWidth < 760;
      return GridView.count(
        crossAxisCount: compact ? 2 : 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: compact ? 2.6 : 1.55,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMetricCard(
            palette: palette,
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xff73b84a),
            title: getI18NKey().join_days,
            value: stats.joinDays.toString(),
            unit: getI18NKey().day,
            subtitle: Utility.getDateTimeYMD(Utility.getDateTimeFromTimeStamp(
                widget.flomoMissionModel.start_time ?? 0)),
          ),
          _buildMetricCard(
            palette: palette,
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xffff8a2a),
            title: getI18NKey().continously_clockin,
            value: stats.continuousDays.toString(),
            unit: getI18NKey().day,
            subtitle: getI18NKey().continuous_days,
          ),
          _buildMetricCard(
            palette: palette,
            icon: Icons.donut_large_rounded,
            iconColor: const Color(0xff3d8cff),
            title:
                getI18NKey().month_clockin_rate(curDateTime.month.toString()),
            value: Utility.getPercent(stats.monthPercent),
            subtitle:
                '${stats.monthCompletedCount} / ${stats.monthPlanCount} ${getI18NKey().day}',
          ),
          _buildMetricCard(
            palette: palette,
            icon: Icons.star_rounded,
            iconColor: const Color(0xffffc53d),
            title: getI18NKey().this_month_plan,
            value: stats.monthPlanCount.toString(),
            unit: getI18NKey().day,
            subtitle: getI18NKey().already_persisted,
          ),
          _buildMetricCard(
            palette: palette,
            icon: Icons.emoji_events_rounded,
            iconColor: const Color(0xff8d5cf6),
            title: getI18NKey().continuous_days,
            value: stats.longestContinuousDays.toString(),
            unit: getI18NKey().day,
            subtitle: getI18NKey().completed_days,
          ),
        ],
      );
    });
  }

  /**
   * 功能：构建单个顶部数据卡。
   * 说明：固定图标区、主数值和副标题层级，保证宽屏横排时可快速扫读。
   */
  Widget _buildMetricCard({
    required _FlomoDetailPalette palette,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    String unit = '',
    String subtitle = '',
  }) {
    return _buildSurface(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      iconColor.withValues(alpha: palette.isDark ? 0.18 : 0.13),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.titleText,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: palette.mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.subtleText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建右侧主体里的大日历卡片。
   * 说明：日历是参考图右侧的视觉中心，保留原有点击日期打卡链路，只调整容器层级和宽屏展示。
   */
  Widget _buildCalendarSection({required _FlomoDetailPalette palette}) {
    return _buildSectionSurface(
      palette: palette,
      title: getI18NKey().clock_in_calendar,
      icon: Icons.calendar_month_rounded,
      trailing: _buildCalendarLegend(palette: palette),
      child: Column(
        children: [
          FlomoSelectDateWidget(
            minDatetime: this.calendarModel.dayModelList.first.dateTime,
            maxDatetime: this.calendarModel.dayModelList.last.dateTime,
            onChange: (DateTime value) {
              // 日期选择器变更后先更新本地日期，再驱动月历切页和页面刷新。
              this.curDateTime = value;
              jumpToDateTime(value);
              updateUI();
            },
            currentDateTime: this.curDateTime,
          ),
          FlomoDetailCalendarWidget(
            flomoMissionModel: this.widget.flomoMissionModel,
            maxWidth: double.infinity,
            onTapListener: (dayModel) async {
              await _handleCalendarDayTapped(dayModel);
            },
            calendarModel: calendarModel,
            onMonthChanged: (DateTime value) {
              if (shouldTriggerOnPageChanged) {
                curDateTime = value;
              }
            },
            pageController: pageController,
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建日历状态图例。
   * 说明：用轻量圆点解释完成状态，和参考图右上角图例保持一致。
   */
  Widget _buildCalendarLegend({required _FlomoDetailPalette palette}) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        _buildLegendItem(
          palette: palette,
          color: const Color(0xff73b84a),
          label: getI18NKey().completed,
        ),
        _buildLegendItem(
          palette: palette,
          color: const Color(0xffffbd45),
          label: getI18NKey().already_persisted,
        ),
        _buildLegendItem(
          palette: palette,
          color: palette.border,
          label: getI18NKey().status_waiting,
        ),
      ],
    );
  }

  /**
   * 功能：构建单个日历图例项。
   */
  Widget _buildLegendItem({
    required _FlomoDetailPalette palette,
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: palette.subtleText, fontSize: 11)),
      ],
    );
  }

  /**
   * 功能：构建本月打卡率卡片。
   * 说明：把原来的 FlomoDetailStatsWidget 信息改成参考图底部横条，更适合宽屏扫读。
   */
  Widget _buildMonthStatsSection({required _FlomoDetailPalette palette}) {
    final _FlomoMissionStats stats = _buildMissionStats();
    return _buildSectionSurface(
      palette: palette,
      title: getI18NKey().month_clockin_rate(curDateTime.month.toString()),
      icon: Icons.bar_chart_rounded,
      child: Row(
        children: [
          SizedBox(
            width: 78,
            height: 78,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 66,
                  height: 66,
                  child: CircularProgressIndicator(
                    value: stats.monthPercent.clamp(0, 1),
                    strokeWidth: 7,
                    backgroundColor: palette.progressTrack,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(palette.accentColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Utility.getPercent(stats.monthPercent),
                      style: TextStyle(
                        color: palette.titleText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      getI18NKey().completion_rate,
                      style: TextStyle(color: palette.subtleText, fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final bool compact = constraints.maxWidth < 520;
              return GridView.count(
                crossAxisCount: compact ? 2 : 4,
                childAspectRatio: compact ? 2.2 : 2.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildCompactStatTile(
                    palette: palette,
                    value: stats.monthPlanCount.toString(),
                    label: getI18NKey().this_month_plan,
                  ),
                  _buildCompactStatTile(
                    palette: palette,
                    value: stats.monthCompletedCount.toString(),
                    label: getI18NKey().already_persisted,
                  ),
                  _buildCompactStatTile(
                    palette: palette,
                    value: stats.continuousDays.toString(),
                    label: getI18NKey().continously_clockin,
                  ),
                  _buildCompactStatTile(
                    palette: palette,
                    value: stats.longestContinuousDays.toString(),
                    label: getI18NKey().continuous_days,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建本月统计里的小数据块。
   */
  Widget _buildCompactStatTile({
    required _FlomoDetailPalette palette,
    required String value,
    required String label,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: palette.softSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.titleText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.subtleText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建目标详情卡片。
   * 说明：复用现有目标配置组件，避免 UI 改版影响设置数据来源。
   */
  Widget _buildTargetInfoSection({required _FlomoDetailPalette palette}) {
    return _buildSectionSurface(
      palette: palette,
      title: getI18NKey().target_details,
      icon: Icons.fact_check_rounded,
      child: FlomoDetailObjectiveInfo(
        missionModel: this.widget.flomoMissionModel,
      ),
    );
  }

  /**
   * 功能：构建右侧习惯详情栏。
   * 说明：参考图右栏把习惯身份、进度、统计、记录和设置聚合在一张卡里。
   */
  Widget _buildHabitSidePanel({required _FlomoDetailPalette palette}) {
    final _FlomoMissionStats stats = _buildMissionStats();
    final Color missionColor =
        Color(widget.flomoMissionModel.color ?? 0xffff8800);
    return _buildSurface(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHabitHeader(palette: palette, missionColor: missionColor),
          const SizedBox(height: 18),
          _buildHabitProgress(
            palette: palette,
            stats: stats,
            missionColor: missionColor,
          ),
          const SizedBox(height: 18),
          _buildSideStatGrid(palette: palette, stats: stats),
          const SizedBox(height: 18),
          _buildClockRecordPreview(
              palette: palette, missionColor: missionColor),
          const SizedBox(height: 18),
          _buildSideSettings(palette: palette, missionColor: missionColor),
        ],
      ),
    );
  }

  /**
   * 功能：构建右栏顶部习惯身份区域。
   */
  Widget _buildHabitHeader({
    required _FlomoDetailPalette palette,
    required Color missionColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: missionColor.withValues(alpha: palette.isDark ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: IconWidget(
            icon: widget.flomoMissionModel.icon ?? 0,
            iconSize: 34,
            color: widget.flomoMissionModel.color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.flomoMissionModel.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: palette.titleText,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                Utility.getResultStringFromTimes(
                    widget.flomoMissionModel.alert_times),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: palette.mutedText, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildStatusChip(palette: palette),
      ],
    );
  }

  /**
   * 功能：构建进行中/已完成状态胶囊。
   */
  Widget _buildStatusChip({required _FlomoDetailPalette palette}) {
    final bool isFinished = widget.flomoMissionModel.isFinished == true;
    final Color color =
        isFinished ? palette.subtleText : const Color(0xff73b84a);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: palette.isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isFinished ? getI18NKey().completed : getI18NKey().status_handling,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /**
   * 功能：构建右栏本月进度条。
   * 说明：用线性进度承接参考图里的“本月进度 16 / 26 天”表达。
   */
  Widget _buildHabitProgress({
    required _FlomoDetailPalette palette,
    required _FlomoMissionStats stats,
    required Color missionColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                getI18NKey().this_month_plan,
                style: TextStyle(
                  color: palette.titleText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${stats.monthCompletedCount} / ${stats.monthPlanCount} ${getI18NKey().day}',
              style: TextStyle(color: palette.mutedText, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: stats.monthPercent.clamp(0, 1),
            minHeight: 8,
            backgroundColor: palette.progressTrack,
            valueColor: AlwaysStoppedAnimation<Color>(missionColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${Utility.getPercent(stats.monthPercent)} ${getI18NKey().completion_rate}',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: palette.mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /**
   * 功能：构建右栏四宫格统计。
   */
  Widget _buildSideStatGrid({
    required _FlomoDetailPalette palette,
    required _FlomoMissionStats stats,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCompactStatTile(
          palette: palette,
          value: stats.continuousDays.toString(),
          label: getI18NKey().continously_clockin,
        ),
        _buildCompactStatTile(
          palette: palette,
          value: stats.completedDays.toString(),
          label: getI18NKey().completed_days,
        ),
        _buildCompactStatTile(
          palette: palette,
          value: Utility.getPercent(stats.monthPercent),
          label: getI18NKey().completion_rate,
        ),
        _buildCompactStatTile(
          palette: palette,
          value: _buildReminderText(),
          label: getI18NKey().alert_time,
        ),
      ],
    );
  }

  /**
   * 功能：构建本月打卡日志点预览。
   * 说明：日志点按 clockIn 里当前月份的真实打卡次数生成，用户点击几次就展示几个点。
   */
  Widget _buildClockRecordPreview({
    required _FlomoDetailPalette palette,
    required Color missionColor,
  }) {
    final List recentMessages =
        (widget.flomoMissionModel.messages ?? []).take(3).toList();
    final int monthClockLogCount =
        FlomoDetailClockLogHelper.countMonthClockLogs(
      clockInMap: widget.flomoMissionModel.clockIn,
      monthDate: curDateTime,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                getI18NKey().month_clockin_record(curDateTime.month.toString()),
                style: TextStyle(
                  color: palette.titleText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(monthClockLogCount, (index) {
            return Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: missionColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  size: 12, color: Colors.white),
            );
          }),
        ),
        if (recentMessages.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...recentMessages.map((item) {
            return _buildRecentMessagePreviewItem(
              palette: palette,
              data: item is Map ? item : {},
            );
          }),
        ],
      ],
    );
  }

  /**
   * 功能：构建右栏里的简版打卡记录。
   * 说明：右栏空间较窄，只展示日期和一行记录内容，完整记录仍保留在任务数据里。
   */
  Widget _buildRecentMessagePreviewItem({
    required _FlomoDetailPalette palette,
    required Map data,
  }) {
    final String ymd =
        data['ymd'] != null ? Utility.parseYMDToYMDWeekend(data['ymd']) : '';
    final String message = (data['message'] ?? '').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.softSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ymd,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: palette.titleText, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  /**
   * 功能：构建右栏设置摘要。
   */
  Widget _buildSideSettings({
    required _FlomoDetailPalette palette,
    required Color missionColor,
  }) {
    final List<int> reminderOptions = <int>[
      ..._buildReminderOptions(),
      FlomoDetailSettingHelper.customReminderOptionValue,
    ];
    final List<int> dailyClockOptions = _buildDailyClockOptions();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          getI18NKey().setting,
          style: TextStyle(
            color: palette.titleText,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        _buildPopupInfoRow<int>(
          palette: palette,
          icon: Icons.notifications_none_rounded,
          iconColor: missionColor,
          label: getI18NKey().alert_time,
          value: _buildReminderText(),
          values: reminderOptions,
          itemLabelBuilder: _buildReminderOptionText,
          onSelected: _handleReminderMenuSelected,
        ),
        _buildPopupInfoRow<int>(
          palette: palette,
          icon: Icons.event_repeat_rounded,
          iconColor: missionColor,
          label: getI18NKey().frequency,
          value: CONSTANTS.getFlomoRepeativeString(
              widget.flomoMissionModel.repetiveType ?? 0),
          values: _buildRepeatOptions(),
          itemLabelBuilder: CONSTANTS.getFlomoRepeativeString,
          onSelected: _handleRepeatSelected,
        ),
        _buildPopupInfoRow<int>(
          palette: palette,
          icon: Icons.palette_outlined,
          iconColor: missionColor,
          label: getI18NKey().habit_clockin,
          value: getI18NKey()
              .everyDayOnce(widget.flomoMissionModel.daily_num_times),
          values: dailyClockOptions,
          itemLabelBuilder: getI18NKey().everyDayOnce,
          onSelected: _handleDailyClockSelected,
          showDivider: false,
        ),
      ],
    );
  }

  /**
   * 功能：构建右栏可点击设置行，并通过 popup 完成选择。
   * 说明：设置项仍复用统一的信息行样式，避免弹窗选择和详情展示出现两套视觉。
   */
  Widget _buildPopupInfoRow<T>({
    required _FlomoDetailPalette palette,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required List<T> values,
    required String Function(T value) itemLabelBuilder,
    required ValueChanged<T> onSelected,
    bool showDivider = true,
  }) {
    return PopupMenuButton<T>(
      tooltip: '',
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return values
            .map(
              (T item) => PopupMenuItem<T>(
                value: item,
                child: Text(
                  itemLabelBuilder(item),
                  style: TextStyle(
                    color: palette.titleText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList();
      },
      child: _buildInfoRow(
        palette: palette,
        icon: icon,
        iconColor: iconColor,
        label: label,
        value: value,
        showArrow: true,
        showDivider: showDivider,
      ),
    );
  }

  /**
   * 功能：构建右栏设置单行。
   */
  Widget _buildInfoRow({
    required _FlomoDetailPalette palette,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool showDivider = true,
    bool showArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: palette.border))
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: palette.mutedText, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: palette.titleText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showArrow) ...[
            const SizedBox(width: 5),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: palette.subtleText,
            ),
          ],
        ],
      ),
    );
  }

  /**
   * 功能：构建通用分区卡片。
   * 说明：右侧详情页所有内容卡片共用这套标题、边框和阴影，保证视觉统一。
   */
  Widget _buildSectionSurface({
    required _FlomoDetailPalette palette,
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return _buildSurface(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: palette.accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.titleText,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  /**
   * 功能：构建通用表面容器。
   */
  Widget _buildSurface({
    required _FlomoDetailPalette palette,
    required EdgeInsetsGeometry padding,
    required Widget child,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: palette.isDark ? 0.14 : 0.045),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  /**
   * 功能：从任务数据和当前月份计算详情页所需统计。
   * 说明：所有统计集中在这里，避免顶部卡片、右栏和月统计条各算一遍后口径不一致。
   */
  _FlomoMissionStats _buildMissionStats() {
    final int monthPlanCount = Utility.getTotalClockInFlomoMissionModel(
      flomoMissionModel: widget.flomoMissionModel,
      calendarModel: calendarModel,
      startDateTime: Utility.getFilterDateTimeOfMonth(this.curDateTime),
      endDateTime: Utility.getFilterDateTimeOfMonth(this.curDateTime, true),
    );
    final int monthCompletedCount =
        Utility.totalFlomoMissionClockInFinishedByTime(
      clockInMap: widget.flomoMissionModel.clockIn ?? {},
      daily_num_times: widget.flomoMissionModel.daily_num_times,
      dateTimeStart: Utility.getFilterMonthDateTimeFromTimeStamp(
          this.curDateTime.millisecondsSinceEpoch),
      dateTimeEnd: Utility.getFilterMonthDateTimeFromTimeStamp(
          this.curDateTime.millisecondsSinceEpoch, true),
    );
    final int continuousDays =
        Utility.totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStamp(
      flomoMissionModel: widget.flomoMissionModel,
      curTimeStamp: Utility.getFilterDateTimeFromTimeStamp(
              DateTime.now().millisecondsSinceEpoch)
          .millisecondsSinceEpoch,
    );
    final int longestContinuousDays = Utility
        .totalMaxFlomoMissionClockInFinishedContinuouslyAtYmdTimeStampAndMap(
      dateTimeStart: Utility.getFilterDateTimeOfMonth(this.curDateTime),
      dateTimeEnd: Utility.getFilterDateTimeOfMonth(this.curDateTime, true),
      clockInMap: widget.flomoMissionModel.clockIn ?? {},
      daily_num_times: widget.flomoMissionModel.daily_num_times,
    );
    final int completedDays = Utility.totalFlomoMissionClockInFinished(
      clockInMap: widget.flomoMissionModel.clockIn ?? {},
      daily_num_times: widget.flomoMissionModel.daily_num_times,
    );
    final int joinDays = Utility.totalFlomoMissionClockDaysAlready(
      flomoMissionModel: widget.flomoMissionModel,
      curTimeStamp: DateTime.now().millisecondsSinceEpoch,
    );
    return _FlomoMissionStats(
      joinDays: joinDays,
      completedDays: completedDays,
      continuousDays: continuousDays,
      longestContinuousDays: longestContinuousDays,
      monthPlanCount: monthPlanCount,
      monthCompletedCount: monthCompletedCount,
      monthPercent:
          monthPlanCount == 0 ? 0 : monthCompletedCount / monthPlanCount,
    );
  }

  /**
   * 功能：格式化右栏提醒时间。
   */
  String _buildReminderText() {
    final String reminder =
        Utility.getResultStringFromTimes(widget.flomoMissionModel.alert_times);
    return reminder.isEmpty ? '-' : reminder;
  }

  /**
   * 功能：提供右栏通知时间弹窗的常用时间。
   * 说明：这里按产品要求提供 0 点到 23 点的整点选择，自定义分钟数走独立时间弹窗。
   */
  List<int> _buildReminderOptions() {
    return FlomoDetailSettingHelper.buildReminderHourOptions();
  }

  /**
   * 功能：格式化通知时间弹窗里的选项文案。
   */
  String _buildReminderOptionText(int reminderMilliseconds) {
    if (reminderMilliseconds ==
        FlomoDetailSettingHelper.customReminderOptionValue) {
      return getI18NKey().custom;
    }
    return Utility.formatHourAndMin2(reminderMilliseconds);
  }

  /**
   * 功能：提供重复频率弹窗选项。
   */
  List<int> _buildRepeatOptions() {
    return <int>[1, 2, 3];
  }

  /**
   * 功能：提供每日打卡次数弹窗选项。
   * 说明：详情页以快速微调为主，覆盖常见的一到五次目标；更多复杂配置仍可进入编辑页。
   */
  List<int> _buildDailyClockOptions() {
    final int currentDailyCount = widget.flomoMissionModel.daily_num_times;
    final List<int> options = <int>[1, 2, 3, 4, 5];
    if (currentDailyCount > 0 && !options.contains(currentDailyCount)) {
      options.insert(0, currentDailyCount);
    }
    return options;
  }

  /**
   * 功能：处理通知时间菜单选择。
   * 说明：整点选项直接保存，自定义选项再打开系统时间选择弹窗。
   */
  Future<void> _handleReminderMenuSelected(int reminderMilliseconds) async {
    if (reminderMilliseconds ==
        FlomoDetailSettingHelper.customReminderOptionValue) {
      await _handleCustomReminderSelected();
      return;
    }
    await _handleReminderSelected(reminderMilliseconds);
  }

  /**
   * 功能：处理自定义通知时间选择。
   * 说明：用户取消弹窗时不改模型；确认后把时分转换成当天毫秒偏移并写回 Mongo。
   */
  Future<void> _handleCustomReminderSelected() async {
    final TimeOfDay? timeOfDay = await Utility.showTimePickerDialog(context);
    if (timeOfDay == null) {
      return;
    }
    final int reminderMilliseconds =
        FlomoDetailSettingHelper.buildReminderMilliseconds(
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
    );
    await _handleReminderSelected(reminderMilliseconds);
  }

  /**
   * 功能：处理通知时间选择并写回 Mongo。
   */
  Future<void> _handleReminderSelected(int reminderMilliseconds) async {
    FlomoDetailSettingHelper.applyReminderTime(
      missionModel: widget.flomoMissionModel,
      reminderMilliseconds: reminderMilliseconds,
    );
    await _persistFlomoDetailSetting();
  }

  /**
   * 功能：处理重复频率选择并写回 Mongo。
   */
  Future<void> _handleRepeatSelected(int repetiveType) async {
    FlomoDetailSettingHelper.applyRepeatType(
      missionModel: widget.flomoMissionModel,
      repetiveType: repetiveType,
    );
    await _persistFlomoDetailSetting();
  }

  /**
   * 功能：处理每日打卡次数选择并写回 Mongo。
   */
  Future<void> _handleDailyClockSelected(int dailyCount) async {
    FlomoDetailSettingHelper.applyDailyClockCount(
      missionModel: widget.flomoMissionModel,
      dailyCount: dailyCount,
    );
    await _persistFlomoDetailSetting();
  }

  /**
   * 功能：统一保存右栏设置改动。
   * 说明：先刷新当前页面给用户即时反馈，再调用 MongoApisManager 更新远端和全局任务缓存。
   */
  Future<void> _persistFlomoDetailSetting() async {
    updateUI();
    await MongoApisManager.getInstance().update_FlomoMissionModel(
      missionModel: widget.flomoMissionModel,
    );
    if (mounted) {
      updateUI();
    }
  }

  /**
   * 功能：处理月历单日点击打卡。
   * 说明：沿用原数据更新链路，只把并发锁、刷新和评分弹窗集中到一个函数里，便于后续维护。
   */
  Future<void> _handleCalendarDayTapped(dynamic dayModel) async {
    if (isRequesting == true) {
      return;
    }
    isRequesting = true;
    await MongoApisManager.getInstance().update_FlomoMissionModelClocksIn(
        flomoMissionModel: this.widget.flomoMissionModel,
        ymd: Utility.getYMD(dayModel.dateTime ?? DateTime.now()),
        callback: () {
          updateUI();
        });
    isRequesting = false;
    if (Utility.isFlomoMissionClockInFinishedAtYMD(
            flomoMissionModel: this.widget.flomoMissionModel,
            ymd: Utility.getYMD(curDateTime)) ==
        true) {
      DialogManagement.showFlomoRatingDialog(
        context,
        flomoMissionModel: this.widget.flomoMissionModel,
        onSubmitted: (val) async {
          await MongoApisManager.getInstance().update_FlomoMissionModelMessage(
              flomoMissionModel: this.widget.flomoMissionModel,
              ymd: Utility.getYMD(curDateTime),
              satisfaction: val['code'],
              message: val['content']);
          DialogManagement.getInstance().hideDialog(context);
        },
      );
    }
  }
}

/**
 * 文件内类型：详情页调色板
 * 作用：集中管理习惯打卡详情页亮色/暗色模式下的表面色、文字色和边框色。
 */
class _FlomoDetailPalette {
  final bool isDark;
  final Color pageBackground;
  final Color cardBackground;
  final Color softSurface;
  final Color border;
  final Color titleText;
  final Color mutedText;
  final Color subtleText;
  final Color progressTrack;
  final Color accentColor;

  _FlomoDetailPalette({
    required this.isDark,
    required this.pageBackground,
    required this.cardBackground,
    required this.softSurface,
    required this.border,
    required this.titleText,
    required this.mutedText,
    required this.subtleText,
    required this.progressTrack,
    required this.accentColor,
  });

  /**
   * 功能：从 ThemeManager 和 Flutter 主题上下文生成当前页面调色板。
   * 说明：这里同时看 ThemeManager 与 Theme.of(context)，避免桌面端局部主题状态不同步时文字不可读。
   */
  factory _FlomoDetailPalette.fromContext(BuildContext context) {
    final ThemeManager themeManager = ThemeManager.getInstance();
    final bool isDark = themeManager.getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
    return _FlomoDetailPalette(
      isDark: isDark,
      pageBackground:
          isDark ? const Color(0xff282522) : const Color(0xfffff8f0),
      cardBackground:
          isDark ? const Color(0xff34302d) : const Color(0xfffffbf6),
      softSurface: isDark ? const Color(0xff403a35) : const Color(0xfffff2e4),
      border: isDark ? const Color(0xff4a433e) : const Color(0xffffdfbf),
      titleText: isDark ? const Color(0xfff3e8dd) : const Color(0xff3b2a20),
      mutedText: isDark ? const Color(0xffc7bbb0) : const Color(0xff7c6250),
      subtleText: isDark ? const Color(0xff9d9188) : const Color(0xffa48b78),
      progressTrack: isDark ? const Color(0xff4a433e) : const Color(0xffefe6dc),
      accentColor: themeManager.getDefautThemeColor(),
    );
  }
}

/**
 * 文件内类型：习惯打卡详情统计
 * 作用：承载顶部数据卡、月统计和右侧详情栏共用的统计结果，保证不同区域展示口径一致。
 */
class _FlomoMissionStats {
  final int joinDays;
  final int completedDays;
  final int continuousDays;
  final int longestContinuousDays;
  final int monthPlanCount;
  final int monthCompletedCount;
  final double monthPercent;

  _FlomoMissionStats({
    required this.joinDays,
    required this.completedDays,
    required this.continuousDays,
    required this.longestContinuousDays,
    required this.monthPlanCount,
    required this.monthCompletedCount,
    required this.monthPercent,
  });
}
