import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../util/Utility.dart';

class SectionHeaderForListView extends StatelessWidget {
  String title;
  String? subtitle;
  bool isDelay;

  Function? onClickSubtitle;

  SectionHeaderForListView(
      {Key? key,
      required this.title,
      this.subtitle,
      this.isDelay = false,
      this.onClickSubtitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.fromLTRB(16, 6, 10, 10),
        // color: ColorsConfig.backgroundColor,
        alignment: Alignment(-1, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff8d96a0),
                      shadows: ThemeManager.getInstance().isDark()
                          ? null
                          : [
                              Shadow(color: Colors.white, offset: Offset(1, 1))
                            ]),
                ),
                if (isDelay == true)
                  Text(
                    "(" + getI18NKey().already_delay + ")",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13, color: Colors.red, shadows: [
                      Shadow(color: Colors.white, offset: Offset(1, 1))
                    ]),
                  ),
              ],
            ),
            if (subtitle != null)
              InkWell(
                onTap: () {
                  if (isDelay == true) {
                    onClickSubtitle?.call();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    subtitle ?? "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        shadows: [
                          Shadow(color: Colors.white, offset: Offset(1, 1))
                        ]),
                  ),
                ),
              ),
          ],
        ));
  }
}
