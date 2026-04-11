import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomTextField.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/ColorsWidget.dart';
import '../../../components/CustomPopupWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../models/GroupModel.dart';

/**
 * 添加组件
 */
class GroupAddWidget extends StatelessWidget {
  final String title;
  final Color? accentColor;
  final Color? surfaceColor;

  // Function onEnterListener;
  final Function(String) onEnterListener;
  final Function onMoreListener;
  final Function onAddMissionListener;
  final Function onUpdateGroupModelListener;
  final Function onMoveNextGroupListener;
  final Function onMovePreviousGroupListener;
  final int totalMission;
  final Function onTapAddColumLeftGroupListener;
  final Function onTapAddColumRightGroupListener;
  final Function onTapDeleteGroupListener;
  final Function onTapSelectBgColorGroupListener;
  GroupModel groupModel;
  double fontSize = 13;
  double size = 20;
  Key? customTextFieldKey;
  bool isFirst;
  bool isLast;
  GroupAddWidget(
      {required this.title,
      required this.onMoveNextGroupListener,
      required this.onMovePreviousGroupListener,
      required this.isFirst,
      required this.isLast,
      this.accentColor,
      this.surfaceColor,
      this.customTextFieldKey,
      required this.totalMission,
      required this.groupModel,
      required this.onUpdateGroupModelListener,
      required this.onTapAddColumLeftGroupListener,
      required this.onTapAddColumRightGroupListener,
      required this.onTapDeleteGroupListener,
      required this.onTapSelectBgColorGroupListener,
      required this.onEnterListener,
      required this.onMoreListener,
      required this.onAddMissionListener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Color iconColor = accentColor ??
        ThemeManager.getInstance()
            .getIconColor(defaultColor: Color(0xff6b7280));
    final Color chipColor = surfaceColor?.withAlpha(230) ??
        (ThemeManager.getInstance().isDark()
            ? ThemeManager.getInstance()
                .getCardBackgroundColor(defaultColor: Color(0xff3a3a3a))
            : Colors.white.withAlpha(224));
    return Row(
      children: [
        SizedBox(
          width: 14,
        ),
        CustomTextField(
            key: customTextFieldKey,
            style: TextStyle(
                color: ThemeManager.getInstance()
                    .getTextColor(defaultColor: Color(0xff404040)),
                fontSize: 15,
                fontWeight: FontWeight.w700),
            text: this.title,
            onEnterListener: this.onEnterListener),
        SizedBox(
          width: 8,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            this.totalMission.toString(),
            style: TextStyle(
                color: ThemeManager.getInstance()
                    .getTextColor(defaultColor: Color(0xff7d8590)),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ),
        Spacer(),
        if (!(TextUtil.isEmpty(groupModel.objectId) == true &&
            groupModel.title == getI18NKey().unorder_group))
          ColorsWidget(
            onColorSelected: (int color) async {
              this.groupModel.color = color;
              this.onUpdateGroupModelListener.call(groupModel);
            },
            child: _buildActionShell(
              child: Utility.getSVGPicture(R.assetsImgIcPaintPaint, size: 15),
              iconColor: iconColor,
              chipColor: chipColor,
            ),
          ),
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {
              this.onAddMissionListener.call();
            },
            child: _buildActionShell(
              chipColor: chipColor,
              iconColor: iconColor,
              child: Icon(
                Icons.add,
                color: iconColor,
                size: 18,
              ),
            )),
        SizedBox(
          width: 10,
        ),
        CustomPopupWidget(
          onSelected: (val) async {
            switch (val.code) {
              case 'bg_color':
                this.onTapSelectBgColorGroupListener.call(groupModel);
                break;
              case 'add_left_column':
                this.onTapAddColumLeftGroupListener.call(groupModel);
                break;
              case 'add_right_column':
                this.onTapAddColumRightGroupListener.call(groupModel);
                break;
              case 'delete':
                this.onTapDeleteGroupListener.call(groupModel);
                break;
              case 'go_to_left':
                this.onMovePreviousGroupListener.call(groupModel);
                break;
              case 'go_to_right':
                this.onMoveNextGroupListener.call(groupModel);
                break;
            }
            // updateUI();
          },
          list: (TextUtil.isEmpty(groupModel.objectId) == true &&
                  groupModel.title == getI18NKey().unorder_group)
              ? CONSTANTS.getUnorderGroupHeaderPopup()
              : CONSTANTS.getGroupHeaderPopup(isFirst: isFirst, isLast: isLast),
          child: _buildActionShell(
            chipColor: chipColor,
            iconColor: iconColor,
            child: Icon(
              Icons.more_horiz,
              color: iconColor,
              size: 18,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildActionShell(
      {required Widget child,
      required Color chipColor,
      required Color iconColor}) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconTheme(
        data: IconThemeData(color: iconColor),
        child: child,
      ),
    );
  }
}
