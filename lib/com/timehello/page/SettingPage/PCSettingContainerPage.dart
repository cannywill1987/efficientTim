import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/SettingPage/SettingPage.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import 'pages/FilterMenuSettingPage.dart';
import 'pages/ModuleFilterMenuSettingPage.dart';
import 'pages/PCLeftSettingPage.dart';
import 'pages/TomatoesSettingPage.dart';

class PCSettingContainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PCSettingContainerPageState();
  }
}

class PCSettingContainerPageState extends State<PCSettingContainerPage> {
  String theme = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 300,
            child: PCLeftSettingPage(
              onTapListener: (String theme) {
                this.theme = theme;
                setState(() {});
              },
            )),
        SizedBox(
          width: 1,
        ),
        Expanded(
            child: TextUtil.isEmpty(this.theme) || this.theme == 'focus_setting'
                ? TomatoesSettingPage(
                    pageFrom: PageFromEnum.Normal,
                  )
                : this.theme == "filtering_setting" ? FilterMenuSettingPage() :ModuleFilterMenuSettingPage() )
      ],
    );
  }
}
