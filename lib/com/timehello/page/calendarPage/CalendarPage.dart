import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/list_wheel_scroll_view_x.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../components/ListingFilterWidget.dart';
import '../../util/DialogManagement.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../SettingItemDetailPage/SettingItemDetailPage.dart';

/**
 * 文件类型：页面
 * 文件作用：展示日历页的月份区间视图，并承接创建任务、完成任务、任务设置等入口。
 * 主要职责：桌面端和移动端共用纵向日期轴与任务网格，移动端仅做窄屏尺寸适配。
 */
class CalendarPage extends BaseWidget {
  final String? title;
  final Function? onRefresh;

  CalendarPage({Key? key, this.title, this.onRefresh}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() => CalendarPageState();
}

class CalendarPageState extends BaseWidgetState<CalendarPage> {
  Function? debounceFunction;
  int curIndex = 0;
  var timer;
  AutoScrollController? verticalScrollController = AutoScrollController();

  // var isScrollingTimer;
  bool nested = false;
  int currentDateIndex = -1;
  FolderModel? folderModelSearch;

  // bool isScrolling = false;
  // bool enableScrollManually = false;
  FixedExtentScrollController bottomBarScrollController =
      FixedExtentScrollController(
          initialItem: Utility.getGlobalContext()
              .watch<GlobalStateEnv>()
              .calendarModel
              .indexMonth);
  ScrollController _controller = ScrollController();
  int currentBtmIndex = (Utility.getGlobalContext()
          .watch<GlobalStateEnv>()
          .calendarModel
          .indexMonth) +
      1; //MyApp.calendarModel有可能为Null
  int btmIndex = Utility.getGlobalContext()
      .watch<GlobalStateEnv>()
      .calendarModel
      .indexMonth;
  DateTimeModel? currentDateTimeModel;
  CalendarModel? calendarModel;
  double calendarTaskMinWidth = 240; // 桌面端任务条的最小宽度，对应当前月份里耗时最短的任务。
  double calendarTaskMaxWidthMultiple = 3; // 任务条最大宽度为最小宽度的倍数，避免长任务撑破网格。
  static const double _desktopCalendarRowHeight = 62;
  static const double _desktopDateAxisWidth = 112;
  static const double _mobileCalendarRowHeight = 92;
  static const double _mobileDateAxisWidth = 108;

  bool _shouldShowLunar(BuildContext context) {
    final String languageCode =
        Localizations.localeOf(context).languageCode.toLowerCase();
    return languageCode.startsWith('zh');
  }

  @override
  void onCreate() {
    curPage = "CalendarPage";
    bottomBarScrollController =
        FixedExtentScrollController(initialItem: btmIndex);
    currentBtmIndex = btmIndex + 1;
    calendarModel =
        Utility.getGlobalContext().watch<GlobalStateEnv>().calendarModel;
    btmIndex = calendarModel!.indexMonth + 1;
  }

  @override
  void initState() {
    super.initState();
    curPage = "CalendarPage";
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //
    // });
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    // eventBus.on<EventFn>().listen((event) {
    //   if (event.type == Params.ACTION_UPDATE_CALENDARPAGE) {
    //     this.requestDatas();
    //   }
    // });
  }

  @override
  componentDidMount() {
    //延时是为了防止以页面加载出来 却还没有数据
    Future.delayed(Duration(seconds: 2), () {
      horizontalAnimateToItem(this.curIndex = calendarModel!.indexMonth);
      Future.delayed(Duration(seconds: 1), () {
        verticalAnimateToPosition(DateTime.now().day);
      });
    });
  }

  horizontalAnimateToItem(int index) {
    if (calendarModel!.monthModelList.length > 0) {
      this.curIndex = index;
      bottomBarScrollController.animateToItem(index,
          duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
  }

  @override
  void dispose() {
    // 为了避免内存泄漏，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickToMissionDetailPage': //点击跳转专注页
        this.onClickToMissionDetailPage(
            data['missionModel'], data['folderModel']);
        break;
      case 'onClickFinishItem': //点击完成任务
        Utility.onClickFinishItem(
            missionModel: data['missionModel'],
            folderModel: data?['folderModel'] ?? null,
            timestampCurrent: data['timestampCurrent'],
            context: context,
            finishCallback: () {
              requestDatas();
            });
        break;
      case 'onClickPreviousPage':
        horizontalAnimateToItem(--curIndex);
        break;
      case 'onClickNextPage':
        horizontalAnimateToItem(++curIndex);
        break;
      case 'onClickSettingItem':
        this.onClickMissionSetting(data['missionModel']);
        break;
      case 'onClickCreateWithData':
        this.onClickCreateWithData(data['dayModel']);
    }
  }

  void onClickCreateWithData(DayModel dayModel) {
    if (Utility.isHandsetBySize() == true) {
      MissionModel missionModel = MissionModel();
      missionModel.end_time = dayModel.dateTime?.millisecondsSinceEpoch;
      Utility.pushNavigator(
          context,
          CreateMissionPage(
              missionModel: missionModel,
              onRefresh: () {
                requestDatas();
              }));
    } else {
      MissionModel missionModel = MissionModel();
      missionModel.end_time = dayModel.dateTime?.millisecondsSinceEpoch;
      DialogManagement.getInstance().showPCCustomDialog(
          context: context,
          widget: CreateMissionPage(
              missionModel: missionModel,
              onRefresh: () {
                requestDatas();
              }));
    }
  }

  /**
   * 点击跳转专注页
   */
  Future onClickToMissionDetailPage(
      [MissionModel? missionModel, FolderModel? folderModel]) async {
    OverlayManagement.getInstance().openMissionDetailPageOverlay(
        context: context, missionModel: missionModel, folderModel: folderModel);
  }

  Future<void> requestDatas() async {
    if (this.widget.onRefresh != null) {
      this.widget.onRefresh!(this.folderModelSearch);
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
            key: ValueKey("ejzifjf"),
            missionModel: data,
          ), callback: (val) {
        requestDatas();
      });
    } else {
      Utility.openRightSideDesktopNavigator(
          context, 'SettingItemDetailPage', {'missionModel': data});
    }
  }

  /**
   * 获取横坐标Index数
   */
  getHorMonthIndex(DateTimeModel dateTimeModel) {
    for (int index = 0; index < calendarModel!.monthModelList.length; index++) {
      if (dateTimeModel.datetime!.month ==
              calendarModel!.monthModelList[index].month &&
          (dateTimeModel.datetime!.year) ==
              int.parse(calendarModel!.monthModelList[index].yearName)) {
        return index;
      }
    }
    Utility.showToastMsg(msg: getI18NKey().dateOutOfLimit, type: 'error');
    return -1;
  }

  getTotalItems() {
    List<Widget> listWidgets = [];
    for (int index = 1;
        index < (calendarModel?.monthModelList.length ?? 0);
        index++) {
      listWidgets.add(
          getBottomItem(index, false, calendarModel!.monthModelList[index]));
    }
    return listWidgets;
  }

  @override
  Widget build(BuildContext context) {
    calendarModel = context.watch<GlobalStateEnv>().calendarModel;
    List<MonthModel> monthModelList = calendarModel?.monthModelList ?? [];

    return getChild(monthModelList, context);
  }

  ColoredBox getChild(List<MonthModel> monthModelList, BuildContext context) {
    return ColoredBox(
      color: ThemeManager.getInstance()
          .getBackgroundColor(defaultColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: (monthModelList.length > 0 &&
                      ((monthModelList[this.btmIndex].dayModelList.length)) > 0)
                  ? buildCenter()
                  : Container()),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Color(0xfff0f0f0),
          ),
          Container(height: 60, child: buildBottom())
        ],
      ),
    );
  }

  //必须要做这个判断 否则数组为空时会报scrollview异常
  buildCenter() {
    if (!Utility.isHandsetBySize()) {
      return buildDesktopCalendarWorkbench();
    }
    return GestureDetector(
        onTap: () {
          Utility.popupDesktopRightNavigator(context);
        },
        child: buildDesktopCalendarWorkbench());
  }

  /**
   * 功能：构建日历工作台。
   * 说明：PC 端和移动端共用同一套日期轴与任务网格，移动端只缩小行高、日期列和任务卡片宽度。
   */
  Widget buildDesktopCalendarWorkbench() {
    final bool isCompact = Utility.isHandsetBySize();
    final MonthModel monthModel = calendarModel!.monthModelList[btmIndex];
    final List<DayModel> dayModels =
        Utility.filterDaysModels(monthModel.dayModelList, folderModelSearch);

    return Container(
      color: isCompact ? const Color(0xfff7f8f2) : const Color(0xfff4f1ea),
      child: Column(
        children: [
          buildDesktopCalendarToolbar(monthModel),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 10 : 22,
                0,
                isCompact ? 10 : 22,
                0,
              ),
              child: buildDesktopCalendarGrid(dayModels),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建日历顶部工具栏。
   * 说明：移动端使用紧凑月份胶囊和清单筛选，PC 端保留更舒展的月份入口。
   */
  Widget buildDesktopCalendarToolbar(MonthModel monthModel) {
    final bool isCompact = Utility.isHandsetBySize();
    if (isCompact) {
      return Container(
        height: 76,
        padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              icon: const Icon(Icons.chevron_left, color: Color(0xff9b968e)),
              onPressed: () {
                this.onClick('onClickPreviousPage', null);
              },
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  currentDateTimeModel = await Utility.showMonthPickerDialog(
                      context, Utility.getTimeStampToday());
                  if (currentDateTimeModel == null) {
                    return;
                  }
                  final int index = getHorMonthIndex(currentDateTimeModel!);
                  if (index > -1) {
                    horizontalAnimateToItem(index - 1);
                  }
                },
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${monthModel.yearName} ${monthModel.monthName} 1-${monthModel.dayModelList.length}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff222222),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down,
                          color: Color(0xff5d5a54)),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              icon: const Icon(Icons.chevron_right, color: Color(0xffb8b2aa)),
              onPressed: () {
                this.onClick('onClickNextPage', null);
              },
            ),
            ListingFilterWidget(onTapListener: (data) {
              folderModelSearch = data;
              updateUI();
            }),
          ],
        ),
      );
    }

    return Container(
      height: 76,
      padding: const EdgeInsets.fromLTRB(24, 14, 22, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xff9b968e)),
            onPressed: () {
              this.onClick('onClickPreviousPage', null);
            },
          ),
          GestureDetector(
            onTap: () async {
              currentDateTimeModel = await Utility.showMonthPickerDialog(
                  context, Utility.getTimeStampToday());
              if (currentDateTimeModel == null) {
                return;
              }
              final int index = getHorMonthIndex(currentDateTimeModel!);
              if (index > -1) {
                horizontalAnimateToItem(index - 1);
              }
            },
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${monthModel.yearName} ${monthModel.monthName} 1-${monthModel.dayModelList.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff222222),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_drop_down, color: Color(0xff5d5a54)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xffb8b2aa)),
            onPressed: () {
              this.onClick('onClickNextPage', null);
            },
          ),
          const Spacer(),
          ListingFilterWidget(onTapListener: (data) {
            folderModelSearch = data;
            updateUI();
          }),
        ],
      ),
    );
  }

  /**
   * 功能：构建日期轴和任务网格。
   * 说明：网格行对应日期，任务条按当天任务顺序放入横向列。
   * 多任务场景下每个任务只能占据自己的列宽，移动端则允许每一行横向滚动。
   */
  Widget buildDesktopCalendarGrid(List<DayModel> dayModels) {
    if (dayModels.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(builder: (context, constraints) {
      final bool isCompact = Utility.isHandsetBySize();
      final double dateAxisWidth =
          isCompact ? _mobileDateAxisWidth : _desktopDateAxisWidth;
      final double baseRowHeight =
          isCompact ? _mobileCalendarRowHeight : _desktopCalendarRowHeight;
      final double gridWidth = constraints.maxWidth - dateAxisWidth;
      final double gridHeight =
          math.max(constraints.maxHeight - 8, dayModels.length * baseRowHeight);
      final double rowHeight =
          math.max(baseRowHeight, gridHeight / math.max(dayModels.length, 1));
      final int shortestDuration = getShortestMissionDuration(dayModels);

      return SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: dateAxisWidth,
              height: rowHeight * dayModels.length,
              child: Column(
                children: [
                  for (int index = 0; index < dayModels.length; index++)
                    buildDesktopDatePill(dayModels[index], index, rowHeight),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: rowHeight * dayModels.length,
                decoration: BoxDecoration(
                  color: const Color(0xfff7f4ed),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (int dayIndex = 0;
                        dayIndex < dayModels.length;
                        dayIndex++)
                      buildDesktopMissionRow(
                        dayModels[dayIndex],
                        rowHeight,
                        gridWidth,
                        shortestDuration,
                        isLastRow: dayIndex == dayModels.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildDesktopDatePill(DayModel dayModel, int index, double rowHeight) {
    final bool isCompact = Utility.isHandsetBySize();
    final Color accentColor = getDesktopDateAccentColor(index);
    final String week = Utility.getWeekDay(dayModel.weekday);
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          Container(
            width: 3,
            height: rowHeight * 0.78,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              this.onClick('onClickCreateWithData', {'dayModel': dayModel});
            },
            child: Container(
              width: isCompact ? 82 : 88,
              height: isCompact ? 70 : 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCompact ? week : '$week ${dayModel.day ?? ''}',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff25231f),
                    ),
                  ),
                  if (_shouldShowLunar(context)) ...[
                    const SizedBox(height: 3),
                    Text(
                      isCompact
                          ? '${dayModel.day ?? ''}${dayModel.lunarDay ?? ''}'
                          : dayModel.lunarDay ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff25231f),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: isCompact ? 12 : 13,
                        color: ThemeManager.getInstance().getDefautThemeColor(),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        getI18NKey().add_task,
                        style: TextStyle(
                          fontSize: isCompact ? 9 : 10,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          color:
                              ThemeManager.getInstance().getDefautThemeColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDesktopMissionRow(DayModel dayModel, double rowHeight,
      double gridWidth, int shortestDuration,
      {required bool isLastRow}) {
    final bool isCompact = Utility.isHandsetBySize();
    final double horizontalPadding = isCompact ? 6 : 8;
    final double itemSpacing = isCompact ? 8 : 10;
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(color: Color(0xffddd8cf), width: 1),
          bottom: isLastRow
              ? const BorderSide(color: Color(0xffddd8cf), width: 1)
              : BorderSide.none,
        ),
      ),
      child: dayModel.missionModelList.isEmpty
          ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 8),
                child: buildCalendarRowCreateButton(dayModel),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final int missionCount = dayModel.missionModelList.length;
                final double rowUsableWidth =
                    math.max(0, constraints.maxWidth - horizontalPadding * 2);
                final List<double> desiredWidths = dayModel.missionModelList
                    .map((missionModel) => getDesktopMissionWidth(
                          missionModel,
                          shortestDuration,
                          availableWidth: gridWidth - horizontalPadding * 2,
                          missionCountOfDay: missionCount,
                        ))
                    .toList();
                final double createButtonWidth =
                    getCalendarRowCreateButtonWidth();
                final double totalDesiredWidth = desiredWidths.fold<double>(0.0,
                        (previousValue, element) => previousValue + element) +
                    math.max(0, missionCount - 1) * itemSpacing;
                final double minMissionCardWidth = isCompact ? 136 : 160;
                final double minTotalWidthWithCreateButton =
                    minMissionCardWidth * missionCount +
                        math.max(0, missionCount - 1) * itemSpacing +
                        itemSpacing +
                        createButtonWidth;
                final bool shouldScroll =
                    totalDesiredWidth + itemSpacing + createButtonWidth >
                            rowUsableWidth ||
                        minTotalWidthWithCreateButton > rowUsableWidth;
                final double missionCardsWidth = math.max(
                    0, rowUsableWidth - createButtonWidth - itemSpacing);
                final double expandedItemWidth = missionCount > 0
                    ? math.max(
                        isCompact ? 136 : 160,
                        (missionCardsWidth -
                                math.max(0, missionCount - 1) * itemSpacing) /
                            missionCount)
                    : rowUsableWidth;

                Widget buildMissionCard(int missionIndex, double width) {
                  return SizedBox(
                    width: width,
                    height: math.min(46, rowHeight - 12),
                    child: buildDesktopMissionBar(
                      dayModel.missionModelList[missionIndex],
                      dayModel,
                      missionIndex,
                    ),
                  );
                }

                if (!shouldScroll) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: 8),
                    child: Row(
                      children: [
                        for (int missionIndex = 0;
                            missionIndex < missionCount;
                            missionIndex++) ...[
                          buildMissionCard(missionIndex, expandedItemWidth),
                          if (missionIndex != missionCount - 1)
                            SizedBox(width: itemSpacing),
                        ],
                        SizedBox(width: itemSpacing),
                        buildCalendarRowCreateButton(dayModel),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: 8),
                  child: Row(
                    children: [
                      for (int missionIndex = 0;
                          missionIndex < missionCount;
                          missionIndex++) ...[
                        buildMissionCard(
                            missionIndex, desiredWidths[missionIndex]),
                        if (missionIndex != missionCount - 1)
                          SizedBox(width: itemSpacing),
                      ],
                      SizedBox(width: itemSpacing),
                      buildCalendarRowCreateButton(dayModel),
                    ],
                  ),
                );
              },
            ),
    );
  }

  /**
   * 功能：构建每个日期行里的创建入口。
   * 说明：旧版日历依赖左侧日期块承载创建任务入口；新版网格空行如果完全留白，
   * 用户会误以为这一天不能创建任务，所以在任务区域补一个稳定的加号按钮。
   */
  Widget buildCalendarRowCreateButton(DayModel dayModel) {
    final bool isCompact = Utility.isHandsetBySize();
    return GestureDetector(
      onTap: () {
        this.onClick('onClickCreateWithData', {'dayModel': dayModel});
      },
      child: Container(
        width: getCalendarRowCreateButtonWidth(),
        height: math.min(38, isCompact ? 34 : 36),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.84),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: ThemeManager.getInstance()
                .getDefautThemeColor()
                .withValues(alpha: 0.28),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: isCompact ? 15 : 16,
              color: ThemeManager.getInstance().getDefautThemeColor(),
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                getI18NKey().add_task,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isCompact ? 10 : 11,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: ThemeManager.getInstance().getDefautThemeColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getCalendarRowCreateButtonWidth() {
    return Utility.isHandsetBySize() ? 86 : 112;
  }

  /**
   * 功能：构建日历行中的任务卡片。
   * 说明：整张卡片点击仍进入任务设置，右侧播放按钮单独进入任务详情/专注浮层，
   * 避免用户在日历页找不到开始任务的入口。
   */
  Widget buildDesktopMissionBar(
      MissionModel missionModel, DayModel dayModel, int index) {
    final bool isCompact = Utility.isHandsetBySize();
    final Color baseColor = getDesktopMissionColor(missionModel, index);
    final Color lightColor = Color.lerp(baseColor, Colors.white, 0.42)!;
    final FolderModel? folderModel = getFolderModelForMission(missionModel);
    final String subtitle = getMissionSubtitle(missionModel, folderModel);

    return GestureDetector(
      onTap: () {
        this.onClick('onClickSettingItem',
            {'missionModel': missionModel, 'folderModel': folderModel});
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          isCompact ? 9 : 12,
          6,
          isCompact ? 8 : 10,
          6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lightColor.withValues(alpha: 0.94),
              baseColor.withValues(alpha: 0.7)
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: baseColor.withValues(alpha: 0.28),
              blurRadius: 9,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                this.onClick('onClickFinishItem', {
                  'missionModel': missionModel,
                  'folderModel': folderModel,
                  'timestampCurrent': dayModel.dateTime?.millisecondsSinceEpoch
                });
              },
              child: Icon(
                Utility.getIsFinishOfMissionModel(
                        missionModel: missionModel,
                        curMonthTimeStamp:
                            dayModel.dateTime?.millisecondsSinceEpoch ?? 0)
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: 17,
                color: const Color(0xff5d574f).withValues(alpha: 0.62),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    missionModel.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff28251f),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isCompact ? 10 : 11,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff3f3a34),
                    ),
                  ),
                ],
              ),
            ),
            if (!isCompact) ...[
              const SizedBox(width: 6),
              Icon(Icons.schedule,
                  size: 15,
                  color: const Color(0xff5d574f).withValues(alpha: 0.66)),
              const SizedBox(width: 5),
            ],
            buildCalendarMissionDetailButton(missionModel, folderModel),
          ],
        ),
      ),
    );
  }

  /**
   * 功能：构建日历任务卡右侧的播放入口。
   * 入参：missionModel 和 folderModel 用于打开任务详情浮层时保持任务与文件夹上下文一致。
   */
  Widget buildCalendarMissionDetailButton(
      MissionModel missionModel, FolderModel? folderModel) {
    final bool isCompact = Utility.isHandsetBySize();
    final double buttonSize = isCompact ? 24 : 26;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        this.onClick('onClickToMissionDetailPage',
            {'missionModel': missionModel, 'folderModel': folderModel});
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          size: isCompact ? 18 : 20,
          color: const Color(0xffff5a5f),
        ),
      ),
    );
  }

  Color getDesktopDateAccentColor(int index) {
    const List<Color> colors = [
      Color(0xffded9cf),
      Color(0xff9ed8f5),
      Color(0xffc5a7f0),
      Color(0xffded9cf),
      Color(0xffded9cf),
      Color(0xffded9cf),
      Color(0xff87c2f6),
    ];
    return colors[index % colors.length];
  }

  Color getDesktopMissionColor(MissionModel missionModel, int index) {
    final int? folderColor = getFolderModelForMission(missionModel)?.color;
    if (folderColor != null && folderColor != 0) {
      return Color(folderColor);
    }
    const List<Color> colors = [
      Color(0xffffb65f),
      Color(0xff76c5ef),
      Color(0xffa985ee),
    ];
    return colors[index % colors.length];
  }

  FolderModel? getFolderModelForMission(MissionModel missionModel) {
    if ((missionModel.folder_id ?? '').isEmpty) {
      return null;
    }
    final List<FolderModel> folders = MongoApisManager.getInstance()
        .queryWhereEqual_folderModelWithFolderId(missionModel.folder_id);
    if (folders.isEmpty) {
      return null;
    }
    return folders.firstWhere((item) => item.tag == 2,
        orElse: () => folders.first);
  }

  String getMissionSubtitle(
      MissionModel missionModel, FolderModel? folderModel) {
    final List<String> tags = [];
    if ((folderModel?.title ?? '').isNotEmpty) {
      tags.add('#${folderModel!.title}');
    }
    if ((missionModel.tagNames ?? '').isNotEmpty) {
      tags.addAll(missionModel.tagNames!
          .split(',')
          .where((item) => item.trim().isNotEmpty)
          .map((item) => '#${item.trim()}'));
    }
    return tags.isEmpty ? '#未归类' : tags.take(2).join(' ');
  }

  /**
   * 功能：获取当前月份任务里的最短预计时长。
   * 说明：任务条宽度以最短任务为基准，其他任务按照耗时比例放大。
   */
  int getShortestMissionDuration(List<DayModel> dayModels) {
    int? shortest;
    for (final DayModel dayModel in dayModels) {
      for (final MissionModel missionModel in dayModel.missionModelList) {
        final int duration = getMissionDurationForWidth(missionModel);
        if (duration <= 0) {
          continue;
        }
        shortest = shortest == null ? duration : math.min(shortest, duration);
      }
    }
    return shortest ?? 25 * 60 * 1000;
  }

  int getMissionDurationForWidth(MissionModel missionModel) {
    if ((missionModel.daily_start_time ?? 0) > 0 &&
        (missionModel.daily_end_time ?? 0) >
            (missionModel.daily_start_time ?? 0)) {
      return (missionModel.daily_end_time ?? 0) -
          (missionModel.daily_start_time ?? 0);
    }
    final int tomatoDuration = missionModel.tomato_duration != null &&
            (missionModel.tomato_duration ?? 0) > 0
        ? missionModel.tomato_duration!
        : 25 * 60 * 1000;
    return math.max(1, missionModel.total_tomotoes ?? 1) * tomatoDuration;
  }

  double getDesktopMissionWidth(MissionModel missionModel, int shortestDuration,
      {required double availableWidth, required int missionCountOfDay}) {
    final bool isCompact = Utility.isHandsetBySize();
    final double ratio = getMissionDurationForWidth(missionModel) /
        math.max(shortestDuration, 1);
    final double width = (isCompact ? 150 : calendarTaskMinWidth) * ratio;
    // 每一行改成独立横向滚动后，多任务场景可以保留弹性宽度，只需要限制单个卡片不要无限长。
    final double maxWidth = isCompact
        ? math.min(math.max(150, availableWidth * 0.72), 230)
        : missionCountOfDay > 1
            ? math.min(math.max(220, availableWidth * 0.32), 360)
            : math.min(math.max(260, availableWidth * 0.48), 520);
    return width
        .clamp(isCompact ? 132 : 180, maxWidth)
        .clamp(120, maxWidth)
        .toDouble();
  }

  Widget buildBottom() {
    if (!Utility.isHandsetBySize()) {
      return buildDesktopBottomMonthNav();
    }
    return Row(
      children: [
        TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.onClick('onClickPreviousPage', null);
            },
            child: Wrap(
              children: getPreviousPageWidget(),
            )),
        Expanded(
            child: Stack(
          children: [
            //中间的蓝色
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      // child: getBottomItem(
                      //     1, true, MyApp.calendarModel.dayModelList[this.curIndex]),
                      width: 100,
                      height: 40,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color:
                              ThemeManager.getInstance().getDefautThemeColor(),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      alignment: Alignment.center,
                    ))),
            Align(
              alignment: Alignment(0, 0),
              child: ListWheelScrollViewX(
                controller: bottomBarScrollController,
                onSelectedItemChanged: (index) {
                  this.currentBtmIndex = index + 1;
                  updateUI();
                  if (timer != null) {
                    timer?.cancel();
                    timer = null;
                  }
                  timer = Timer(Duration(milliseconds: 300), () {
                    if (verticalScrollController?.hasClients == true) {
                      verticalScrollController?.scrollToIndex(0);
                    }
                    this.btmIndex = index + 1;
                    updateUI();
                    // scrollController.jumpTo(index.toDouble());
                  });
                },
                scrollDirection: Axis.horizontal,
                physics: FixedExtentScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemExtent: 80,
                overAndUnderCenterOpacity: 0.5,
                children: getTotalItems(),
              ),
            ),
          ],
        )),
        TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.onClick('onClickNextPage', null);
            },
            child: Wrap(
              children: getNextPageWidget(),
            )),
      ],
    );
  }

  Widget buildDesktopBottomMonthNav() {
    return Container(
      color: const Color(0xfff4f1ea),
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
      child: Row(
        children: [
          TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.onClick('onClickPreviousPage', null);
            },
            child: Text(
              '${getI18NKey().previous_month} ◀',
              style: TextStyle(
                color: Color(0xff25231f),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index = 1;
                      index < (calendarModel?.monthModelList.length ?? 0);
                      index++)
                    buildDesktopMonthPill(
                        index, calendarModel!.monthModelList[index]),
                ],
              ),
            ),
          ),
          TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.onClick('onClickNextPage', null);
            },
            child: Text(
              '${getI18NKey().next_month} ▶',
              style: TextStyle(
                color: Color(0xff25231f),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesktopMonthPill(int index, MonthModel monthModel) {
    final bool isSelected = index == this.btmIndex;
    return GestureDetector(
      onTap: () {
        this.currentBtmIndex = index;
        this.btmIndex = index;
        this.curIndex = index - 1;
        updateUI();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 76,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff3e8df3) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.15 : 0.11),
              blurRadius: 9,
              offset: const Offset(0, 3),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              monthModel.monthName ?? '',
              style: TextStyle(
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xff25231f),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '1-${monthModel.dayModelList.length}',
              style: TextStyle(
                fontSize: 11,
                height: 1,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xff25231f),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getPreviousPageWidget() {
    if (!Utility.isHandsetBySize()) {
      return [
        Icon(Icons.skip_previous),
        SizedBox(
          width: 3,
        ),
        Text(getI18NKey().previous_page)
      ];
    } else {
      return [Icon(Icons.skip_previous)];
    }
  }

  List<Widget> getNextPageWidget() {
    if (!Utility.isHandsetBySize()) {
      return [
        Text(getI18NKey().next_page),
        SizedBox(
          width: 3,
        ),
        Icon(Icons.skip_next),
      ];
    } else {
      return [
        Icon(Icons.skip_next),
      ];
    }
  }

  verticalAnimateToPosition(int pos) {
    verticalScrollController?.scrollToIndex(pos + 2).then((_) {});
  }

  getCurrentDateIndex() {
    int length = Utility.getGlobalContext()
        .watch<GlobalStateEnv>()
        .calendarModel
        .dayModelList
        .length;
    for (int i = 0; i < length; i++) {
      if (Utility.getGlobalContext()
              .watch<GlobalStateEnv>()
              .calendarModel
              .dayModelList[i]
              .isCurrent ==
          true) {
        return i;
      }
    }
    return 0;
  }

  // getIndexFromMonthModelList(index) {
  //   int jumpTo = 0;
  //   for (int i = 0; i < index; i++) {
  //     jumpTo += MyApp.calendarModel.monthModelList[i].dayModelList.length;
  //   }
  //   // print('123:${jumpTo}');
  //   return jumpTo;
  // }

  getBottomItem(int index, bool isSelected, MonthModel monthModel) {
    isSelected = index == this.currentBtmIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${monthModel.monthName}',
          style: isSelected
              ? TextStyle(color: Colors.white, fontWeight: FontWeight.w600)
              : TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black),
                  fontWeight: FontWeight.w600),
        ),
        Text(
          '${1}-${monthModel.dayModelList.length}',
          style: isSelected
              ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black),
                  fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
