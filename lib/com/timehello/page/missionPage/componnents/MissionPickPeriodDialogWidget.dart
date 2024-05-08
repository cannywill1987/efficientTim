import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/CONSTANTS.dart';
import '../../../util/Utility.dart';
import 'MissionCheckButtonListWidget.dart';

class MissionPickPeriodDialogWidget extends StatefulWidget {
  Function? onChange;
  int endTime = -1;

  MissionPickPeriodDialogWidget({Key? key, this.onChange}) :super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionPickPeriodDialogWidgetState(endTime: this.endTime);
  }
}


  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return MissionPickPeriodDialogWidgetState(endTime: this.endTime);
  // }}

class MissionPickPeriodDialogWidgetState extends State<MissionPickPeriodDialogWidget> {
  double marginTop = 20;
  int endTime = -1;
  String? code;


  MissionPickPeriodDialogWidgetState({required this.endTime});

  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.code = CONSTANTS.getDoItNowMissionModelsDurationButtonList()[0].code;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //圆角 白色背景 container
    return Container(
      decoration: BoxDecoration(
          color: ThemeManager.getInstance().getBackgroundColor(),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        SizedBox(height: marginTop,),
        MissionCheckButtonListWidget(list: CONSTANTS.getDoItNowMissionModelsDurationButtonList(),
            onTapListener: (e, endTime) async {
              code = e['data'].code;
              bool isCheck = e['data'].isCheck;
              this.endTime = endTime;
              this.widget.onChange?.call(code, isCheck, endTime);
            }),
        SizedBox(height: marginTop,),
        // 时间选择组件 返回hh:mm
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getI18NKey().target_reward,
                style: TextStyle(
                    color: ThemeManager.getInstance().getTextColor(),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                getI18NKey().continue2,
                style: TextStyle(
                    color: Color(0xffFFA500),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],),
    );
  }
  }