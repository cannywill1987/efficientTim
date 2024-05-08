import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/MoneyHandlerWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SettingModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../common/provider/Env.dart';
import 'LoginAvatarWidget.dart';

class PCLeftMenuBarWidget extends StatefulWidget {
  OnTapListener onTapListener;
  OnTapListener onTapAvatarWidgetListener;

  PCLeftMenuBarWidget(
      {required this.onTapListener, required this.onTapAvatarWidgetListener});

  @override
  State<StatefulWidget> createState() {
      return PCLeftMenuBarWidgetState();
  }


}


class PCLeftMenuBarWidgetState extends State<PCLeftMenuBarWidget> {
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return Selector<Env, SettingModel>(
        selector: (_, env) => env.settingModel ?? SettingModel(),
        builder: (_, settingModel, __) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              color: ThemeManager.getInstance().getNavigationBarColor(
                  defaultColor:
                  ThemeManager.getInstance().getDefautThemeColor()),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 120),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: getItemsList(settingModel),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoginAvatarWidget(
                            onTapListener: (data) {
                              this.widget.onTapAvatarWidgetListener(data);
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          LoginManager.getInstance().userBean?.username != null
                              ? Text(
                            LoginManager.getInstance().userBean.username,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white, fontSize: 12),
                          )
                              : SizedBox.shrink(),
                        ]),
                  )
                ],
              ));
        });
  }

  List<Widget> getItemsList(SettingModel settingModel) {
    List<Widget> list = [];
    list.add(SizedBox(height: 10));
    List listTmp = CONSTANTS.getLeftDesktopMenubar(settingModel: settingModel);
    listTmp.forEach((e) {
      list.add(
          getItem(e['icon'], e['iconChecked'], e['title'], e['sceneCode'], settingModel));
      list.add(SizedBox(height: 5));
      list.add(getDivider());
      list.add(SizedBox(height: 15));
    });
    return list;
  }

  Widget getItem(Widget icon, Widget iconChecked, String text, String scene, SettingModel settingModel) {
    Env? env = context?.watch<Env>();
    String scenePage = env?.routerMainContainerData != null
        ? (env?.routerMainContainerData?['page'] ?? null)
        : CONSTANTS.getLeftDesktopMenubar(settingModel: settingModel)[0]["sceneCode"];

    return InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener(scene);
          }
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            scenePage == scene ? iconChecked : icon, //不同长江展示不同icon
            SizedBox(height: 3),
            Text(
              text,
              maxLines: 1, // 限制行数，例如限制为1行。
              overflow: TextOverflow.ellipsis, // 当文本超出限定长度时，显示省略号。
              style: TextStyle(color: Colors.white, fontSize: 14),
            )
          ],
        ));
  }

  Widget getDivider() {
    return Container(
        width: 20,
        height: 2,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: ColorsConfig.listColorsDivider)));
  }
}