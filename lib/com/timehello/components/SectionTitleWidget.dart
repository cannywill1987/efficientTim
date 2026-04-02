import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/ColorsConfig.dart';
import '../util/ThemeManager.dart';

/**
 * settingitemdetail用得上
 */
class SectionTitleWidget extends StatelessWidget {
  final String title;
  final Widget? child;
  final bool useUnifiedStyle;

  const SectionTitleWidget(
      {Key? key, required this.title, this.child, this.useUnifiedStyle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useUnifiedStyle) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 10, 6, 12),
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ThemeManager.getInstance().getTextColor(
                    defaultColor: const Color(0xFF3F2A1E),
                    defaultDarkColor: Colors.white),
              ),
            ),
            if (child != null) Spacer(),
            if (child != null) child!,
          ],
        ),
      );
    }
    return Container(
        padding: EdgeInsets.fromLTRB(5, 4, 5, 7),
        color: ThemeManager.getInstance().getCardBackgroundColor(),
        alignment: Alignment(-1, 1),
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 13,
                  color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffa3a3a3)),
                  shadows: ThemeManager.getInstance().isDark() ? null : [Shadow(color: Colors.white, offset: Offset(1, 1))]
              ),
            ),
            if (child != null) Spacer(),
            if (child != null) child!,
          ],
        ));
  }
}
