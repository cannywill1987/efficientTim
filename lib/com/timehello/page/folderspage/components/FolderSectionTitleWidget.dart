import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../util/ThemeManager.dart';


/**
 * 文件夹标题组件
 */
class FolderSectionTitleWidget extends StatelessWidget {
  final String title;
  Widget? trailingWidget;
  Function? onClick;
  FolderSectionTitleWidget({Key? key, required this.title, this.trailingWidget, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverToBoxAdapter(
      child:    Container(
        padding: EdgeInsets.fromLTRB(15, 4, 12, 4),
        color: ThemeManager.getInstance().getLeftMenuColor(defaultColor: ThemeManager.getInstance().getLightDefaultThemeColor()),
        alignment: Alignment(-1, 1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 13,
                  color: ThemeManager.getInstance().getTextColor(context: context,defaultColor: Color(0xffa3a3a3)),
                  shadows: ThemeManager.getInstance().isDark() ? null : [
                    Shadow(color: Colors.white, offset: Offset(1, 1))
                  ]),
            ),
            if(trailingWidget != null)
              trailingWidget!,
            if(this.onClick != null)
            InkWell(
              onTap: (){
                this.onClick?.call();
              },
              child: Text(
                getI18NKey().create,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 13,
                    color: ThemeManager.getInstance().getTextColor(defaultColor: ThemeManager.getInstance().getDefautThemeColor(), defaultDarkColor: Colors.red),
                    shadows: ThemeManager.getInstance().isDark() ? null : ThemeManager.getInstance().isDark() ? null : [
                      Shadow(color: Colors.white, offset: Offset(1, 1))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

}