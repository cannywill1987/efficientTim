import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../common/provider/GlobalStateEnv.dart';
import 'components/GameListViewWidget.dart';

/**
 * 游戏列表首页
 */
class GamesPage extends BaseWidget {
  const GamesPage();

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _GamesPageWidgetState();
  }
}

class _GamesPageWidgetState<T> extends BaseWidgetState<GamesPage> {
  @override
  void deactivate() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.isAppBarVisible = Utility.isHandsetBySize() ? true : false;
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSegmentControl':
        break;
      case 'onClickPCValueType':
        break;
    }
  }

  Widget baseDesktoptBuild(BuildContext context) {
    return GameListViewWidget(
        onTapListener: (res) {
          LoginManager.getInstance().hasUserName(context: context, callback: () {
            Utility.pushToGame(context: context, bean: res, isPC: true);
            // Utility.pushToGame(context: context, bean: res);
          });
        },
        datas: context.read<GlobalStateEnv>().gamePagesResourceDeliveryInfoBeanList ?? []);
  }

  Widget baseBuild(BuildContext context) {
    return GameListViewWidget(
        onTapListener: (res) {
          LoginManager.getInstance().hasUserName(context: context, callback: () {
            Utility.pushToGame(context: context, bean: res, isPC: false);
          });
        },
        datas: context.read<GlobalStateEnv>().gamePagesResourceDeliveryInfoBeanList ?? []);
  }
}
