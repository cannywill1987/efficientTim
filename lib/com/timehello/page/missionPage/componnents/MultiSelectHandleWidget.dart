import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/CustomBlackButton.dart';
import '../../../models/MissionModel.dart';

class MultiSelectHandleWidget extends StatefulWidget {
  Function? onClickDelete;
  Function? onClickUpdateTimeDoItNow;
  Function? onClickExport;
  Function? onClickFinish;
  Function? onClickUnFinish;
  Function? onClickClose;
  List<MissionModel> missionModelList = [];

  MultiSelectHandleWidget({this.onClickUpdateTimeDoItNow, this.onClickClose, required this.missionModelList, this.onClickDelete, this.onClickExport,
      this.onClickFinish, this.onClickUnFinish});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MultiSelectHandleWidgetState();
  }
}

class MultiSelectHandleWidgetState extends State<MultiSelectHandleWidget> {
  List<MissionModel> getSelectedMissionModels() {
    List<MissionModel> selectedMissionModels = [];
    for (MissionModel missionModel in this.widget.missionModelList) {
      if (missionModel.isSelected) {
        selectedMissionModels.add(missionModel);
      }
    }
    return selectedMissionModels;
  }

  List<MissionModel> filterSelectedWithMissionModelFinished(List<MissionModel> missionModels) {
    for (MissionModel missionModel in missionModels) {
      missionModel.isFinished = true;
    }
    return missionModels;
  }

  List<MissionModel> filterSelectedWithMissionModelUnfinished(List<MissionModel> missionModels) {
    for (MissionModel missionModel in missionModels) {
      missionModel.isFinished = false;
    }
    return missionModels;
  }

  List<MissionModel> filterSelectedWithMissionModelSeleted(List<MissionModel> missionModels) {
    for (MissionModel missionModel in missionModels) {
      missionModel.isSelected = false;
    }
    return missionModels;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50,
      width: 8000,
      color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              this.widget.onClickExport?.call(getSelectedMissionModels());
            },
            child: CustomBlackButton(
              text: getI18NKey().export,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              this.widget.onClickUpdateTimeDoItNow?.call(getSelectedMissionModels());
            },
            child: CustomBlackButton(
              text: getI18NKey().do_it_now,
              color: Colors.teal,
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              this.widget.onClickDelete?.call(getSelectedMissionModels());
            },
            child: CustomBlackButton(
              text: getI18NKey().delete,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              this.widget.onClickFinish?.call(filterSelectedWithMissionModelFinished(getSelectedMissionModels()));
            },
            child: CustomBlackButton(
              text: getI18NKey().complete,
              color: Colors.green,
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              this.widget.onClickUnFinish?.call(filterSelectedWithMissionModelUnfinished(getSelectedMissionModels()));
            },
            child: CustomBlackButton(
              text: getI18NKey().unfinished,
              color: Colors.green,
            ),
          ),
          SizedBox(width: 40,),
          InkWell(
            onTap: () {
              this.widget.onClickClose?.call(filterSelectedWithMissionModelSeleted(getSelectedMissionModels()));
            },
            child: CustomBlackButton(
              text: getI18NKey().close_multi,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }


}
