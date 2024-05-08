import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

GlobalKey<HeaderStatusState> HeaderStatusStateGlobalKey = GlobalKey();

/**
 * MissionDetail怕个 头部的状态
 */
class HeaderStatusMissionDetailWidget extends StatefulWidget {
  MissionModel? missionModel;
  Function? onTapFinishListener;
  Function? onTapCloseListener;
  Widget? rightChild;

  HeaderStatusMissionDetailWidget(
      {Key? key,
        this.rightChild,
      this.onTapFinishListener,
      this.onTapCloseListener,
       this.missionModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HeaderStatusState();
  }
}

class HeaderStatusState extends State<HeaderStatusMissionDetailWidget> {
  @override
  Widget build(BuildContext context) {
    MissionModel? _missionModel = this.widget.missionModel;
    // TODO: implement build
    return Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(
            color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(Colors.white.value)),
            // border: Border.all(color: Color(ColorsConfig.standardColor.value - 0xa0000000)),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        height: 50,
        child: Row(
          children: [
            CheckImage(
              onTapListener: (d) {
                if(this.widget?.onTapFinishListener != null) {
                  this.widget?.onTapFinishListener!();
                }
              },
              checkIcon: Icon(Icons.radio_button_checked_outlined,
                  color: Color(ColorsConfig.gray_a7.value - 0xa0000000)),
              uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                  color: Color(ColorsConfig.gray_a7.value - 0xa0000000)),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Wrap(
                    direction: Axis.vertical,
                    children: [Text(this.widget.missionModel?.title ?? "", style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040))),)],
                  ),
                  Wrap(
                    children: [
                      RatingBar(
                        curNumber: _missionModel?.no_tomotoes_finished ?? 0,
                        number: _missionModel?.total_tomotoes ?? 0,
                      ),
                    ],
                  )
                ])),
            // TextButton(
            //     onPressed: () {
            //       this.widget?.onTapCloseListener();
            //     },
            //     child: Icon(
            //       Icons.close_rounded,
            //       color: ColorsConfig.gray_a7,
            //       size: 18,
            //     ))
            this.widget.rightChild ?? SizedBox.shrink(),
          ],
        ));
  }
}
