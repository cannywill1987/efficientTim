import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';

class AppflowyPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return AppflowyPageState();
  }

}

class AppflowyPageState extends BaseWidgetState<AppflowyPage> {
  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    return AppflowyPage();
  }
}