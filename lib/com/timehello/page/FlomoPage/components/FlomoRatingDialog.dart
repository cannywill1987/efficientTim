import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckContainer.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../config/ColorsConfig.dart';
import 'FlomoDetailHeaderWidget.dart';

class FlomoRatingDialog extends StatefulWidget {
  Function onSubmitted;
  FlomoMissionModel flomoMissionModel;

  FlomoRatingDialog(
      {required this.flomoMissionModel, required this.onSubmitted});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FlomoRatingDialogState();
  }
}

class FlomoRatingDialogState extends State<FlomoRatingDialog> {
  List emojiList = CONSTANTS.getEmojiList();
  final _commentController = TextEditingController();
  Map curEmoji = {};

  void checkEmojiIndex(index) {
    for (int i = 0; i < emojiList.length; i++) {
      emojiList[i]['isChecked'] = false;
      if (i == index) {
        emojiList[index]['isChecked'] = true;
        curEmoji = emojiList[i];
      }
    }
    setState(() {});
  }

  initState() {
    super.initState();
    checkEmojiIndex(this.emojiList.length - 1);
  }

  List<Widget> getEmojiListWidget() {
    List<Widget> list = [];
    for (int i = 0; i < emojiList.length; i++) {
      list.add(InkWell(
        onTap: () {
          checkEmojiIndex(i);
        },
        child: CheckContainer(
          checked: emojiList[i]['isChecked'],
          checkWidget: emojiList[i]['iconChecked'],
          uncheckWidget: emojiList[i]['icon'],
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    double size = 45;
    // TODO: implement build
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // constraints: BoxConstraints(maxHeight: 500, maxWidth: 600),
        decoration: BoxDecoration(
          color: ThemeManager.getInstance()
              .getBackgroundColor(defaultColor: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            FlomoDetailHeaderWidget(
                isDialog: true,
                flomoMissionModel: this.widget.flomoMissionModel),
            Text(
              Utility.getDateTimeYMD(Utility.getDateTimeFromTimeStamp(
                  DateTime.now().millisecondsSinceEpoch)),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Color(0xff7e7e7e)),
                  fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: getEmojiListWidget(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorsConfig.standardBorderLineColor, width: 1),
                  color: ThemeManager.getInstance()
                      .getInputDecorationColor(defaultColor: Color(0xfff0f0f0)),
                  borderRadius: BorderRadius.circular(4)),
              child: TextField(
                controller: _commentController,
                textAlign: TextAlign.left,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 40,
                //不限制行数
                decoration: InputDecoration(
                    hintText: getI18NKey().write_your_clockin_feedback,
                    border: InputBorder.none,
                    hintStyle: new TextStyle(
                        fontSize: 14,
                        color: ThemeManager.getInstance().getInputThemeColor(
                            defaultColor: Color.fromRGBO(187, 187, 187, 1)))),
                maxLength: 150,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    getI18NKey().dont_remind_again,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    // widget.onClickCopyQQ?.call();
                    SharePreferenceUtil.getSyncInstance().setBool(
                        key:
                            ShareprefrenceKeys.flomoRatingDialogDontRemindAgain,
                        val: true);
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                TextButton(
                  child: Text(
                    getI18NKey().cancel,
                    style: TextStyle(color: Color(0xff999999)),
                  ),
                  onPressed: () {
                    // widget.onDontRemindAgainListener?.call();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    getI18NKey().confirm,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    String comment = _commentController.text;
                    widget.onSubmitted.call(
                        {"content": comment, "code": curEmoji['sceneCode']});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
