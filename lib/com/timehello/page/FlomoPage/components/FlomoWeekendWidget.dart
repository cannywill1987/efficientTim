import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../models/CalendarModel.dart';

typedef OnCheckedListener = void Function(dynamic obj);

/**
 * 文件类型：组件
 * 文件作用：展示一周内的日期格子，并承接日期点击回调。
 * 主要职责：根据 DayModel 的选中态、今日状态和任务统计，绘制更清晰的周日期 item。
 */
class FlomoWeekendWidget extends StatelessWidget {
  final Function onCheckedListener;
  final List<DayModel> list;
  final Color colorCheck;
  final Color colorUncheck;
  final double margin;

  FlomoWeekendWidget(
      {Key? key,
      Color? colorCheck,
      Color? colorUncheck,
      required this.list,
      required this.onCheckedListener,
      this.margin = 3})
      : colorCheck = colorCheck ??
            Color(ThemeManager.getInstance().getDefautThemeColorInt()),
        colorUncheck = colorUncheck ??
            Color(ThemeManager.getInstance().getDefautThemeColorInt() -
                0xf0000000),
        super(key: key);

  bool _shouldShowLunar(BuildContext context) {
    final String languageCode =
        Localizations.localeOf(context).languageCode.toLowerCase();
    return languageCode.startsWith('zh');
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return new FlomoWeekendWidgetState(list = this.list);
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...getListWidget(context)],
    );
  }

  /**
   * 功能：把一周的 DayModel 转成可点击日期卡片。
   * 说明：每个 item 固定 Expanded，确保 7 天在不同宽度下仍然等分展示。
   */
  List<Widget> getListWidget(BuildContext context) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      DayModel dayModel = list[i];
      listWidget.add(
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              this.onCheckedListener(dayModel);
            },
            child: getDayWidget(context, dayModel),
          ),
        ),
      );
      if (i != list.length - 1) {
        listWidget.add(SizedBox(width: this.margin));
      }
    }
    return listWidget;
  }

  /**
   * 功能：绘制单个日期 item。
   * 说明：选中态使用主题色填充，今日使用轻边框提示，任务统计以小胶囊展示完成/总数。
   */
  Widget getDayWidget(BuildContext context, DayModel dayModel) {
    final ThemeManager themeManager = ThemeManager.getInstance();
    final bool isDark = themeManager.getThemeMode().isDark;
    final Color accentColor = colorCheck;
    final Color cardColor = dayModel.isCheck
        ? accentColor
        : isDark
            ? const Color(0xff3f3935)
            : const Color(0xfffff6ed);
    final Color borderColor = dayModel.isCheck
        ? accentColor
        : dayModel.isCurrent
            ? accentColor.withValues(alpha: 0.45)
            : isDark
                ? const Color(0xff514a44)
                : const Color(0xffffdfbf);
    final Color primaryTextColor = dayModel.isCheck
        ? Colors.white
        : themeManager.getTextColor(
            defaultColor: const Color(0xff4c382c),
            defaultDarkColor: const Color(0xfff2e7dc),
          );
    final Color secondaryTextColor = dayModel.isCheck
        ? Colors.white.withValues(alpha: 0.76)
        : themeManager.getTextColor(
            defaultColor: const Color(0xff9a806b),
            defaultDarkColor: const Color(0xffcdbfaf),
          );
    final int totalCount = Utility.filterFlomoMissionModelByFinishedState(
      list: dayModel.flomoMissionModelList,
      isFinished: false,
    ).length;
    final int finishedCount = Utility.getNumClocksMissionFinished(dayModel);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      // 这个组件被放在左侧栏固定宽度里，文本开启中文农历和统计胶囊后
      // 72px 会在桌面端产生 Bottom overflow，因此给回接近旧版的日期格高度。
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: dayModel.isCheck
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: isDark ? 0.18 : 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Utility.getWeekendDayStringByWeekend(dayModel.weekday ?? -1),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Center(
              child: Container(
                width: 26,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: dayModel.isCheck
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: isDark ? 0.04 : 0.72),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: dayModel.isCheck
                        ? Colors.white.withValues(alpha: 0.26)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayModel.isCurrent
                          ? getI18NKey().today
                          : Utility.formatDecimal(dayModel.day ?? 1,
                              shouldAddZero: true),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: dayModel.isCurrent ? 8 : 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (_shouldShowLunar(context))
                      Text(
                        dayModel.lunarDay ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 6,
                          height: 1.1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (dayModel.flomoMissionModelList.length > 0)
            Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: dayModel.isCheck
                    ? Colors.white.withValues(alpha: 0.18)
                    : accentColor.withValues(alpha: isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                getI18NKey().num_of_total(finishedCount, totalCount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: dayModel.isCheck ? Colors.white : accentColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }
}
