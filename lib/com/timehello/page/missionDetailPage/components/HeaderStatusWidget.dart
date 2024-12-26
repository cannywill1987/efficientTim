import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';

import '../../../util/Utility.dart';

GlobalKey<HeaderStatusState> HeaderStatusStateGlobalKey = GlobalKey();

/**
 * MissionDetail怕个 头部的状态
 */
class HeaderStatusWidget extends StatefulWidget {
  MissionModel? missionModel;
  Function? onTapFinishListener;
  Function? onTapCloseListener;

  HeaderStatusWidget(
      {Key? key,
      this.onTapFinishListener,
      this.onTapCloseListener,
      @required this.missionModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HeaderStatusState();
  }
}

class HeaderStatusState extends State<HeaderStatusWidget> {
  @override
  Widget build(BuildContext context) {
    MissionModel? _missionModel = this.widget.missionModel;
    // TODO: implement build
    return Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        height: 50,
        child: Row(
          children: [
            CheckImage(
              onTapListener: (d) {
                if(this.widget?.onTapFinishListener != null)
                this.widget?.onTapFinishListener!();
              },
              checkIcon: Icon(Icons.radio_button_checked_outlined,
                  color: ColorsConfig.gray_a7),
              uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                  color: ColorsConfig.gray_a7),
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
                    children: [Text(this.widget.missionModel?.title ?? "")],
                  ),
                  Wrap(
                    children: [
                      if(Utility.shouldShowTomatoes(missionModelType: _missionModel?.missionModelType))
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
          ],
        ));
  }
}
