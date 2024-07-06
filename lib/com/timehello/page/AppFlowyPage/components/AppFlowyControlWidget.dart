
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/FeedbackPage/FeedbackPage.dart';

import '../../../util/Utility.dart';

/**
 * 右上角的控制按钮
 */
class AppFlowyControlWidget extends StatelessWidget {
  List<CheckButtonStateModel> list = [];
  Function(CheckButtonStateModel) onTapListener;
  // ChatGptPageEnum chatGptPageEnum;

  AppFlowyControlWidget(
      {
        // required this.chatGptPageEnum,
      required this.list,
      required this.onTapListener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // 横着排列4个inkwell封装的icon按钮
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: getButtons(),
    );
  }

  List<Widget> getButtons() {
    List<Widget> listWidgets = [];
    List list = [];
    // list.add(CheckButtonStateModel(
    //     code: 'report',
    //     checkIcon: InkWell(
    //         onTap: () {
    //           Utility.pushNavigator(Utility.getGlobalContext(), FeedbackPage());
    //         },
    //         child: Text(
    //           getI18NKey().report2,
    //           style: TextStyle(color: Colors.red, fontSize: 12),
    //         ))));
    // if (this.chatGptPageEnum == ChatGptPageEnum.chatGptPage || this.chatGptPageEnum == ChatGptPageEnum.morePage) {
    //   list.addAll(this.list);
    // }

    list.add(CheckButtonStateModel(
        code: 'close',
        checkIcon: Icon(
          // windows 扩大icon
          Icons.expand,
          size: 16,
        )));
    list.forEach((element) {
        if (element.checkIcon != null) {
          listWidgets.add(InkWell(
              onTap: () {
                this.onTapListener.call(element);
              },
              child: element.checkIcon!));
          listWidgets.add(SizedBox(
            width: 8,
          ));
        }
      });
    return listWidgets;
  }
}
