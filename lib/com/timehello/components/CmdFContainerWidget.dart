import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/AISearchBar.dart';
import 'package:time_hello/com/timehello/components/MissionSearchBar.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/BottomBar.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../common/database/apis/MongoApisManager.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import '../models/FolderModel.dart';
import '../page/missionPage/componnents/HeaderStatsAndInputWidget.dart';
import '../util/SharePreferenceUtil.dart';
import '../util/Utility.dart';
import 'CreateMissionContainerWidget.dart';
import 'IconButtonListWidget.dart';

class CmdFContainerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CmdFContainerWidgetState();
  }
}

class CmdFContainerWidgetState extends State<CmdFContainerWidget> {
  GlobalKey<HeaderInputState> HeaderInputStateGlobalKey = GlobalKey();
  int curIndex = 0;
  List<CheckButtonStateModel> list = CONSTANTS.getCmdFButtonList(defaultVal: 0);
  String curScene = "";
  GlobalKey<BottomBarState>? bottomBarStateKey = GlobalKey();
bool isFocusing = false;
  bool isRequesting = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curScene = list[0].code ?? "";
  }

  void onClick(type, data) async {
    switch (type) {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        IconButtonListWidget(
          initIndex: curIndex,
          list: list,
          onTapListener: (obj) {
            CheckButtonStateModel model = obj['data'];
            this.curScene = model?.code ?? "";
            this.curIndex = obj['index'];

            setState(() {});
          },
        ),
        SizedBox(height: 10,),
        if (this.curScene == 'search') MissionSearchBar(),
        if (this.curScene == 'create')
          CreateMissionContainerWidget(),
        if (this.curScene == 'AI')
          AISearchBar(
            title: "搜索title",
            prompt: "搜索prompt",
            placeholder: "搜索placeholder",
            onSubmit: (prompt, aiText) async {
            },
          ),
      ],
    );
  }
}
