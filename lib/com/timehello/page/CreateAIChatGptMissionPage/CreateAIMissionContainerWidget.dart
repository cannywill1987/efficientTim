import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/components/GPTCreateMissionWidget.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import 'CreateAIChatGptMissionWidget.dart';

class CreateAIMissionContainerWidget extends StatelessWidget {
  List<MissionModel>? list;

  CreateAIMissionContainerWidget({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        //宽度300的Container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: 300,
          color: Color(ThemeManager.getInstance().getLightDefaultThemeColorInt()),
          child: GPTCreateMissionWidget(
            list: this.list ?? [],
          ),
        ),
        Expanded(
          child: CreateAIChatGptMissionWidget(
            listMissionModel: this.list ?? [],
          ),
        )
      ],
    );
  }
}


