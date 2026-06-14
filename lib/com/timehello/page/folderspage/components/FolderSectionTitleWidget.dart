import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../util/ThemeManager.dart';

/**
 * 文件夹标题组件
 */
class FolderSectionTitleWidget extends StatelessWidget {
  final String title;
  final bool useUnifiedStyle;
  final bool useMobileModernStyle;
  Widget? trailingWidget;
  Function? onClick;
  FolderSectionTitleWidget(
      {Key? key,
      required this.title,
      this.trailingWidget,
      this.onClick,
      this.useUnifiedStyle = false,
      this.useMobileModernStyle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color titleColor = useMobileModernStyle
        ? const Color(0xFF73B825)
        : useUnifiedStyle
            ? ThemeManager.getInstance().getTextColor(
                context: context,
                defaultColor: ColorsConfig.missionSidebarSectionTitle,
                defaultDarkColor: Colors.white70)
            : ThemeManager.getInstance().getTextColor(
                context: context, defaultColor: Color(0xffa3a3a3));
    return SliverToBoxAdapter(
      child: Container(
        padding: useMobileModernStyle
            ? const EdgeInsets.fromLTRB(18, 8, 18, 8)
            : useUnifiedStyle
                ? const EdgeInsets.fromLTRB(20, 16, 18, 6)
                : const EdgeInsets.fromLTRB(15, 4, 12, 4),
        color: useMobileModernStyle
            ? const Color(0xFFF8FBEF)
            : useUnifiedStyle
                ? Colors.transparent
                : ThemeManager.getInstance().getLeftMenuColor(
                    defaultColor:
                        ThemeManager.getInstance().getLightDefaultThemeColor()),
        alignment: Alignment(-1, 1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: useUnifiedStyle ? 11 : 13,
                  fontWeight:
                      useUnifiedStyle ? FontWeight.w700 : FontWeight.normal,
                  letterSpacing: useUnifiedStyle ? 0.3 : 0,
                  color: titleColor,
                  shadows: useUnifiedStyle ||
                          useMobileModernStyle ||
                          ThemeManager.getInstance().isDark()
                      ? null
                      : [Shadow(color: Colors.white, offset: Offset(1, 1))]),
            ),
            if (trailingWidget != null) trailingWidget!,
            if (this.onClick != null)
              InkWell(
                onTap: () {
                  this.onClick?.call();
                },
                child: useUnifiedStyle || useMobileModernStyle
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: useMobileModernStyle
                              ? const Color(0xFFFFFFFF)
                              : isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : ColorsConfig
                                      .missionSidebarHeaderChipBackground,
                          borderRadius: BorderRadius.circular(
                              useMobileModernStyle ? 18 : 12),
                          boxShadow: useMobileModernStyle
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getI18NKey().create,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: ThemeManager.getInstance()
                                      .getTextColor(
                                          defaultColor: useMobileModernStyle
                                              ? const Color(0xFF73B825)
                                              : ColorsConfig
                                                  .missionSidebarTextPrimary,
                                          defaultDarkColor: Colors.white)),
                            ),
                            if (useMobileModernStyle) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: Color(0xFF73B825),
                              ),
                            ],
                          ],
                        ),
                      )
                    : Text(
                        getI18NKey().create,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            color: ThemeManager.getInstance().getTextColor(
                                defaultColor: ThemeManager.getInstance()
                                    .getDefautThemeColor(),
                                defaultDarkColor: Colors.red),
                            shadows: ThemeManager.getInstance().isDark()
                                ? null
                                : [
                                    Shadow(
                                        color: Colors.white,
                                        offset: Offset(1, 1))
                                  ]),
                      ),
              )
          ],
        ),
      ),
    );
  }
}
