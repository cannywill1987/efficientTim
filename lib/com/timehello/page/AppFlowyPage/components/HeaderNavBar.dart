import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/CustomTabBarWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/ChatGptPage/components/GPTControlWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/ENUMS.dart';
import 'AppFlowyControlWidget.dart';

class HeaderNavBar extends StatefulWidget {
  final Function onTapListener;

  HeaderNavBar({Key? key, required this.onTapListener}) : super(key: key);

  @override
  HeaderNavBarState createState() => HeaderNavBarState();
}

class HeaderNavBarState extends State<HeaderNavBar> {
  List<CheckButtonStateModel> listTabBars = CONSTANTS.getMissionEditTypeModelList();
  final List<CheckButtonStateModel> listTabBarWideget = CONSTANTS.getGPTHeaderControlCheckButtonStateModelList();
  GlobalKey<CustomTabBarWidgetState> tabBarKey = GlobalKey();
  setCheck(int index) {
    tabBarKey.currentState?.setChecked(index);
  }

  @override
  Widget build(BuildContext context) {
    print("Check0:${listTabBars[0].isCheck} check1:${listTabBars[1].isCheck}");
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: CustomTabBarWidget(
              key: tabBarKey,
              list: listTabBars,
              fontSize: 12,
              onCheckedListener: (int index) {
                setState(() {
                  widget.onTapListener.call(index, listTabBars[index]);
                });
              },
            ),
          ),
          AppFlowyControlWidget(
            list: listTabBarWideget,
            onTapListener: (CheckButtonStateModel model) {
              // setState(() {
                widget.onTapListener.call(listTabBarWideget.indexOf(model), model);
              // });
            },
          )
        ],
      ),
    );
  }
}
