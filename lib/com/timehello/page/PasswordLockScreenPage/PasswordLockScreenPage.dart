import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';

class PasswordLockScreenPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return PasswordLockScreenPageState();
  }
}

class PasswordLockScreenPageState extends BaseWidgetState<PasswordLockScreenPage> {
  @override
  baseBuild(BuildContext context) {
    return Container();
  }
}

