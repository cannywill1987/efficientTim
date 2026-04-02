import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../util/ThemeManager.dart';


/**
 * 文件夹标题组件
 */
class FolderSectionTitleWidget extends StatelessWidget {
  final String title;
  final bool useUnifiedStyle;
  Widget? trailingWidget;
  Function? onClick;
  FolderSectionTitleWidget(
      {Key? key,
      required this.title,
      this.trailingWidget,
      this.onClick,
      this.useUnifiedStyle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color titleColor = useUnifiedStyle
        ? ThemeManager.getInstance().getTextColor(
            context: context,
            defaultColor: const Color(0xFF8C6753),
            defaultDarkColor: Colors.white70)
        : ThemeManager.getInstance()
            .getTextColor(context: context, defaultColor: Color(0xffa3a3a3));
    return SliverToBoxAdapter(
      child: Container(
        padding: useUnifiedStyle
            ? const EdgeInsets.fromLTRB(18, 16, 18, 8)
            : const EdgeInsets.fromLTRB(15, 4, 12, 4),
        color: useUnifiedStyle
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
                  fontSize: useUnifiedStyle ? 12 : 13,
                  fontWeight:
                      useUnifiedStyle ? FontWeight.w700 : FontWeight.normal,
                  letterSpacing: useUnifiedStyle ? 0.4 : 0,
                  color: titleColor,
                  shadows: useUnifiedStyle || ThemeManager.getInstance().isDark()
                      ? null
                      : [
                          Shadow(color: Colors.white, offset: Offset(1, 1))
                        ]),
            ),
            if (trailingWidget != null) trailingWidget!,
            if (this.onClick != null)
              InkWell(
                onTap: () {
                  this.onClick?.call();
                },
                child: useUnifiedStyle
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFFFEAD8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          getI18NKey().create,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ThemeManager.getInstance().getTextColor(
                                  defaultColor: const Color(0xFF8C5831),
                                  defaultDarkColor: Colors.white)),
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
