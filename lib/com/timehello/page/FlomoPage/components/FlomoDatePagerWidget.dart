import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/BlackCheckButtonListWidget.dart';
import '../../../config/CONSTANTS.dart';
import 'FlomoWeekendWidget.dart';

/**
 * 文件类型：组件
 * 文件作用：Flomo 左侧列表顶部的周日期分页器。
 * 主要职责：管理当前周分页、今日跳转和未完成/已完成筛选，并把日期导航展示成桌面端更清晰的控制区。
 */
class FlomoDatePagerWidget extends StatefulWidget {
  final List<WeekModel> dataWeekModel;
  final List<DayModel> dataModels;
  final Function onTapTodayListener;
  final ValueChanged onTapCheckBoxListener;
  final bool isFinished;
  FlomoDatePagerWidget(
      {Key? key,
      required this.isFinished,
      required this.onTapCheckBoxListener,
      required this.onTapTodayListener,
      required this.dataModels,
      required this.dataWeekModel})
      : super(key: key);

  @override
  FlomoDatePagerWidgetState createState() => FlomoDatePagerWidgetState();
}

class FlomoDatePagerWidgetState extends State<FlomoDatePagerWidget> {
  DayModel? dayModdel;
  int _currentPage = 0;
  PageController pageController = PageController();
  int curWeekIndex = 0;
  DateTime lastDatetimeOfCurrentWeek = DateTime.now();

  /**
   * 功能：清空所有日期选中态。
   * 时机：跳转今日或用户点选某一天前调用，避免一周内出现多个选中日期。
   */
  void resetDayModel() {
    for (var i = 0; i < widget.dataWeekModel.length; i++) {
      WeekModel weekModel = widget.dataWeekModel[i];
      for (int j = 0; j < weekModel.dayModelList.length; j++) {
        weekModel.dayModelList[j].isCheck = false;
      }
    }
  }

  /**
   * 功能：获取当前选中日期在全量日期列表里的位置。
   * 说明：保留给旧逻辑使用，当前 UI 主要依赖周索引翻页。
   */
  int getTodayCurIndex() {
    if (dayModdel != null) {
      return this.widget.dataModels.indexOf(dayModdel!);
    } else {
      int curIndex = 0;
      for (var i = 0; i < widget.dataWeekModel.length; i++) {
        for (int j = 0; j < widget.dataWeekModel[i].dayModelList.length; j++) {
          if (widget.dataWeekModel[i].dayModelList[j].isCurrent) {
            curIndex = j;
            break;
          }
        }
      }
      return curIndex;
    }
  }

  /**
   * 功能：定位今天所在的周。
   * 说明：首次进入页面时顺手把今天设为选中态，保证列表默认展示当天任务。
   */
  int getCurWeek() {
    int curWeek = 0;
    for (var i = 0; i < widget.dataWeekModel.length; i++) {
      for (int j = 0; j < widget.dataWeekModel[i].dayModelList.length; j++) {
        if (widget.dataWeekModel[i].dayModelList[j].isCurrent) {
          curWeek = i;
          dayModdel = widget.dataWeekModel[i].dayModelList[j];
          widget.dataWeekModel[i].dayModelList[j].isCheck = true; //顺便是今天的日子给设置了
          break;
        }
      }
    }
    return curWeekIndex = curWeek;
  }

  /**
   * 功能：从全量日期列表里找到今天对应的 DayModel。
   * 返回：找不到时返回 null，交给上层保留当前筛选。
   */
  DayModel? getTodayDayModel() {
    for (int i = 0; i < this.widget.dataModels.length; i++) {
      DayModel dayModel = this.widget.dataModels[i];
      if (dayModel.isCurrent == true) {
        return dayModel;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      jumpToTodayPage();
      setState(() {});
    });
    // Future.delayed(Duration(milliseconds: 500), () {
    //   pageController.animateToPage(5, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    // });
    // setState(() {
    //   _currentPage = 2;
    // });
  }

  /**
   * 功能：根据日期查找所在周的页码。
   * 说明：优先匹配年月日，避免同月任意日期都落到同一周造成详情联动不准。
   */
  int getWeekIndexFromDateTime(DateTime dateTime) {
    for (var i = 0; i < widget.dataWeekModel.length; i++) {
      for (int j = 0; j < widget.dataWeekModel[i].dayModelList.length; j++) {
        DateTime? dateTimeTmp =
            widget.dataWeekModel[i].dayModelList[j].dateTime;
        if (dateTimeTmp?.year == dateTime.year &&
            dateTimeTmp?.month == dateTime.month &&
            dateTimeTmp?.day == dateTime.day) {
          curWeekIndex = i;
          break;
        }
      }
    }
    return curWeekIndex;
  }

  /**
   * 功能：跳转到指定周页。
   * 说明：外部调用和今日按钮都走这里，统一刷新当前周的结束日期。
   */
  void jumpToPageByIndex(int index) {
    if (widget.dataWeekModel.isEmpty) {
      return;
    }
    final int targetIndex =
        index.clamp(0, widget.dataWeekModel.length - 1).toInt();
    pageController.jumpToPage(_currentPage = targetIndex);
    setUpWeekModelFromIndex(_currentPage);
  }

  /**
   * 功能：跳回今天所在周。
   * 说明：页面首次渲染和用户点击今日按钮时调用，保证日期状态与任务列表同步。
   */
  void jumpToTodayPage() {
    if (widget.dataWeekModel.isEmpty) {
      return;
    }
    resetDayModel();
    _currentPage = getCurWeek();
    setUpWeekModelFromIndex(_currentPage);
    pageController.jumpToPage(_currentPage);
    setState(() {});
  }

  /**
   * 功能：翻到下一周。
   * 说明：到达最后一周时直接忽略，避免 PageController 越界。
   */
  void jumpToNextPage() {
    if (curWeekIndex >= widget.dataWeekModel.length - 1) {
      return;
    }
    pageController.animateToPage(curWeekIndex = curWeekIndex + 1,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  /**
   * 功能：翻到上一周。
   * 说明：到达第一周时直接忽略，避免 PageController 越界。
   */
  void jumpToPrevPage() {
    if (curWeekIndex <= 0) {
      return;
    }
    pageController.animateToPage(curWeekIndex = curWeekIndex - 1,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  /**
   * 功能：根据当前页缓存本周最后一天。
   * 说明：标题展示使用周末日期的年月，和 PageView 当前页保持一致。
   */
  setUpWeekModelFromIndex(int index) {
    if (widget.dataWeekModel.length > 0 &&
        index >= 0 &&
        index < widget.dataWeekModel.length) {
      WeekModel weekModel = widget.dataWeekModel[index];
      if (weekModel.dayModelList.length > 0) {
        lastDatetimeOfCurrentWeek = weekModel
                .dayModelList[weekModel.dayModelList.length - 1].dateTime ??
            DateTime.now();
        return lastDatetimeOfCurrentWeek;
      } else {
        lastDatetimeOfCurrentWeek = DateTime.now();
      }
    }
  }

  /**
   * 功能：构建日期分页器主体。
   * 说明：未完成视图展示周导航；已完成视图只保留筛选胶囊，减少无效占位。
   */
  @override
  Widget build(BuildContext context) {
    final ThemeManager themeManager = ThemeManager.getInstance();
    final bool isDark = themeManager.getThemeMode().isDark;
    final Color accentColor = themeManager.getDefautThemeColor();
    final Color surfaceColor =
        isDark ? const Color(0xff34302d) : const Color(0xfffffbf6);
    final Color borderColor =
        isDark ? const Color(0xff49433e) : const Color(0xffffdfbd);
    final Color mutedTextColor =
        isDark ? const Color(0xffc7bbb0) : const Color(0xff8e735f);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToolbar(
            accentColor: accentColor,
            mutedTextColor: mutedTextColor,
            isDark: isDark,
          ),
          if (this.widget.isFinished == false) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPageButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: jumpToPrevPage,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SizedBox(
                    // 左侧栏宽度较窄时，日期格里同时有星期、日期、农历和完成数。
                    // 高度沿用旧版接近 100 的空间，避免 PC 端被压扁后出现 Bottom overflow。
                    height: 100,
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                          curWeekIndex = page;
                          setUpWeekModelFromIndex(_currentPage);
                        });
                      },
                      itemCount: widget.dataWeekModel.length,
                      itemBuilder: (context, index) {
                        return FlomoWeekendWidget(
                            list: this.widget.dataWeekModel[index].dayModelList,
                            onCheckedListener: (DayModel days) async {
                              resetDayModel();
                              days.isCheck = true;
                              dayModdel = days;
                              this.widget.onTapTodayListener(days);
                              setState(() {});
                            });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _buildPageButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  onTap: jumpToNextPage,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /**
   * 功能：构建顶部工具栏。
   * 说明：把年月、今日按钮和归档切换收在同一行，减少旧版 Stack 居中带来的视觉拥挤。
   */
  Widget _buildToolbar({
    required Color accentColor,
    required Color mutedTextColor,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month_rounded, size: 15, color: accentColor),
              const SizedBox(width: 6),
              Text(
                '${lastDatetimeOfCurrentWeek.year}.${lastDatetimeOfCurrentWeek.month.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Tooltip(
          message: getI18NKey().today,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {
              int curIndex = getCurWeek();
              this.widget.onTapTodayListener.call(getTodayDayModel());
              jumpToPageByIndex(curIndex);
            },
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xff403a35) : const Color(0xfffff1e3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.35 : 0.20),
                ),
              ),
              child: Utility.getSVGPicture(
                R.assetsImgIcCalendarToday,
                size: 16,
                color: accentColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: BlackCheckButtonListWidget(
                key: ValueKey('flomo-date-filter-${widget.isFinished}'),
                initIndex: widget.isFinished ? 1 : 0,
                backgroundColor: accentColor,
                useUnifiedStyle: true,
                list: CONSTANTS.getArchivedButtonList(),
                onTapListener: (index) async {
                  this.widget.onTapCheckBoxListener.call(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /**
   * 功能：构建左右翻页按钮。
   * 说明：固定按钮尺寸，避免 hover 或图标变化导致日期 PageView 抖动。
   */
  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 28,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff403a35) : const Color(0xfffff2e4),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isDark ? const Color(0xff4c4540) : const Color(0xffffdfbd),
          ),
        ),
        child: Icon(
          icon,
          color: ThemeManager.getInstance().getIconColor(
            defaultColor: const Color(0xff9a806b),
          ),
          size: 14,
        ),
      ),
    );
  }
}

class DatePagerWidgetItem extends StatelessWidget {
  final String weekday;
  final String dd;

  DatePagerWidgetItem(this.weekday, this.dd);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          weekday,
          style: const TextStyle(color: Color(0xff404040)),
        ),
        Text(
          dd,
          style: const TextStyle(color: Color(0xff404040)),
        ),
      ],
    );
  }
}
