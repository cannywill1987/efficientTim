import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/FlomoPage.dart';

import '../../components/EmptyWidget.dart';
import 'FlomoDetailPage.dart';

class FlomoPCContainerPage extends BaseWidget {
  const FlomoPCContainerPage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return FlomoPCContainerPageState();
  }
}

class FlomoPCContainerPageState extends BaseWidgetState<FlomoPCContainerPage> {
  FlomoMissionModel? flomoMissionModel;
  DateTime? curDateTime = DateTime.now();
   GlobalKey<FlomoDetailPageState> flomoPageSateGlobalKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 400,
          child: FlomoPage(onTapListener: (data) {
            flomoMissionModel = data['data'];
            curDateTime = data['curDateTime'];
            flomoPageSateGlobalKey.currentState?.jumpToDateTime(curDateTime ?? DateTime.now());
            updateUI();
          }),
        ),
        this.flomoMissionModel == null? Expanded(child: EmptyWidget(text: "",)):Expanded(
            child: FlomoDetailPage(
              key: flomoPageSateGlobalKey,
                flomoMissionModel: this.flomoMissionModel ?? FlomoMissionModel(),
                curDateTime: this.curDateTime))
      ],
    );
  }
}
