
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

/**
 * 右上角的控制按钮
 */
class GPTControlWidget extends StatelessWidget {
  List<CheckButtonStateModel> list = [];
  Function(CheckButtonStateModel) onTapListener;
  ChatGptPageEnum chatGptPageEnum;

  GPTControlWidget(
      {required this.chatGptPageEnum,
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
    if (this.chatGptPageEnum == ChatGptPageEnum.chatGptPage || this.chatGptPageEnum == ChatGptPageEnum.morePage) {
      list.addAll(this.list);
    }
    list.add(CheckButtonStateModel(
        code: 'close',
        checkIcon: Icon(
          this.chatGptPageEnum == ChatGptPageEnum.chatGptPage ? Icons.cancel : Icons.close,
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
