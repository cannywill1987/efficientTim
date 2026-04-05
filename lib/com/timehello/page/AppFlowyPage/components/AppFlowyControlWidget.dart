
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

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
      children: getButtons(context),
    );
  }

  List<Widget> getButtons(BuildContext context) {
    List<Widget> listWidgets = [];
    bool isExpand = Utility.getGlobalContext().read<Env>().isMiddleMissionPageVisible;
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
    // if(!Utility.isHandsetBySize())
    list.add(CheckButtonStateModel(
        code: 'share',
        checkIcon: Icon(
          // windows 扩大icon
          Icons.share,
          color: ThemeManager.getInstance().getIconColor(
              defaultColor: ColorsConfig.missionEditorIcon,
              defaultDarkColor: Colors.white70),
          size: 16,
        )));

    list.add(CheckButtonStateModel(
        code: 'refresh',
        checkIcon: Icon(
          // windows 扩大icon
          Icons.refresh,
          color: ThemeManager.getInstance().getIconColor(
              defaultColor: ColorsConfig.missionEditorIcon,
              defaultDarkColor: Colors.white70),
          size: 16,
        )));

    list.add(CheckButtonStateModel(
        code: 'expand',
        checkIcon: isExpand ? Icon(
          // windows 扩大icon
          Icons.open_in_full,
          color: ThemeManager.getInstance().getIconColor(
              defaultColor: ColorsConfig.missionEditorIcon,
              defaultDarkColor: Colors.white70),
          size: 16,
        ):Icon(
          // windows 扩大icon
          Icons.close_fullscreen,
          color: ThemeManager.getInstance().getIconColor(
              defaultColor: ColorsConfig.missionEditorIcon,
              defaultDarkColor: Colors.white70),
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
