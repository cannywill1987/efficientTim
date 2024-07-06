import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/GPTControlWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/ENUMS.dart';
import 'AppFlowyControlWidget.dart';

class HeaderNavBar extends StatelessWidget {
  List<CheckButtonStateModel> listTabBars = CONSTANTS.getWQBEditTypeModelList();
  final List<CheckButtonStateModel> listTabBarWideget = CONSTANTS.getGPTHeaderControlCheckButtonStateModelList();
  final Function onTapListener;
  // ChatGptPageEnum chatGptPageEnum;

  HeaderNavBar({Key? key, required this.onTapListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Check0:${listTabBars[0].isCheck} check1:${listTabBars[1].isCheck}");
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomTabBarWidget(
            list: listTabBars,
            fontSize: 12,
            onCheckedListener: (int index) {
              this.onTapListener.call(index, listTabBars[index]);
            },
          ),
          AppFlowyControlWidget(list:listTabBarWideget, onTapListener: (CheckButtonStateModel ) {
            this.onTapListener.call(CheckButtonStateModel);
          })
        ],
      ),
    );
  }
}
