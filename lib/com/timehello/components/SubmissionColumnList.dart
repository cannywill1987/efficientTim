import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';

import '../config/ColorsConfig.dart';
import '../models/MissionModel.dart';
import '../models/SubmissionModel.dart';

enum DraggingMode {
  iOS,
  android,
}

class SubmissionColumnList extends StatefulWidget {
  MissionModel missionModel;
  // Function onChange;
  int maxLines = 3;
  SubmissionColumnList(
      {Key? key, required this.missionModel, this.maxLines = 2})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SubmissionColumnListState();
  }
}

class SubmissionColumnListState extends State<SubmissionColumnList> {
  late List<SubmissionModel> _items;
  DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // cacheExtent: 3000,
      children: <Widget>[
        for (int index = 0;
            index < this.widget.missionModel.subMissionModels.length;
            index++)
          if(index < this.widget.maxLines)
          SumissionColumnListItem(
            submissionModel: this.widget.missionModel.subMissionModels[index],
          ),
        if(this.widget.missionModel.subMissionModels.length > this.widget.maxLines)
          SumissionColumnListItem(
            submissionModel: SubmissionModel(title: "......", isFinished: false, id: -1, shouldFocus: false, notificationTime: 0, numToamatoesFocused: 0, numToamatoTotal: 0, create_time: 0, update_time: 0,),
          ),

      ],
    );
  }
}

class SumissionColumnListItem extends StatefulWidget {
  final SubmissionModel submissionModel;

  const SumissionColumnListItem({
    Key? key,
    required this.submissionModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SumissionSliverListItemState();
  }
}

class SumissionSliverListItemState extends State<SumissionColumnListItem> {


  initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(width: 10,),
        Opacity(
          opacity: this.widget.submissionModel.id != -1 ? 1: 0,
          child: Container(
            width: 15,
            height: 15,
            child: CheckImage(
              width: 15,
              height: 15,
              isSizeConfigured: true,
              onTapListener: (res) {
              },
              checked: this.widget.submissionModel.isFinished ?? false,
              checkIcon: Icon(Icons.check_circle,
                  size: 10, color: ColorsConfig.calendar_green),
              uncheckIcon: Icon(Icons.check_circle,
                  color: ColorsConfig.gray_a7, size: 10),
            ),
          ),
        ),
        Text(
          " - ${this.widget.submissionModel.title}",
          style: TextStyle(fontSize: 12, color:  this.widget.submissionModel.isFinished ? ColorsConfig.calendar_green : Color(0xff999999)),
        ),
        if(this.widget.submissionModel.notificationTime > 0)
        SizedBox(width: 5,),
        if(this.widget.submissionModel.notificationTime > 0)
        Padding(
          padding: const EdgeInsets.only(top:2),
          child: Icon(
            Icons.alarm_on,
            color: Color(0xff999999),
            size: 12,
          ),
        )
      ],
    );
  }
}
