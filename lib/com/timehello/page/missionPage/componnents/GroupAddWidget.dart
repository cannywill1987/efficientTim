import 'package:flutter/cupertino.dart';
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
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        CustomTextField(
            key: customTextFieldKey,
            style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: fontSize),
            text: this.title,
            onEnterListener: this.onEnterListener),
        SizedBox(
          width: 5,
        ),
        Text(
          this.totalMission.toString(),
          style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xffaeb0b4)), fontSize: fontSize),
        ),
        Spacer(),
        if (!(TextUtil.isEmpty(groupModel.objectId) == true &&
            groupModel.title == getI18NKey().unorder_group))
          ColorsWidget(
            onColorSelected: (int color) async {
              this.groupModel.color = color;
              this.onUpdateGroupModelListener.call(groupModel);
            },
            child: Utility.getSVGPicture(R.assetsImgIcPaintPaint, size: 16),
          ),
        SizedBox(
          width: 5,
        ),
        InkWell(
            onTap: () {
              this.onAddMissionListener.call();
            },
            child: Icon(
              Icons.add,
              color: Color(0xffaeb0b4),
              size: size,
            )),
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
          child: Icon(
            Icons.more_horiz,
            color: Color(0xffaeb0b4),
            size: size,
          ),
        )
      ],
    );
  }
}
