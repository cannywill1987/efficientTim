参考如下创建页面代码

XXXPage

```
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';

class XXXPage extends BaseWidget {
 
  XXXPage(
      {Key? key}) : super(key: key) {
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _MisssionPageWidgetState();
  }
}

class _MisssionPageWidgetState<T> extends BaseWidgetState<XXXPage> {

  // int
  _MisssionPageWidgetState({folderStatus, folderModel}) {
  }

  @override
  baseBuild(BuildContext context) {
    // TODO: implement baseBuild
    // calendarModel = context.read<GlobalStateEnv>().calendarModel;
    return Container();
  }
}

```

