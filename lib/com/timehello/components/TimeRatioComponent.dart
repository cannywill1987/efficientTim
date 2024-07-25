import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/HorItemScrollViewWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../models/MissionModel.dart';
import '../models/ProgressFocusModel.dart';
import '../util/BeanParser.dart';
import 'CustomPopupWidget.dart';

class TimeRatioComponent extends StatefulWidget {
  final double width;
  final double height;

  // final int totalTime;
  DateTime? startTime;
  DateTime? endTime;
  String scene;
  Widget? lastChild;
  Widget? firstChild;
  // final List<TimeSegment> segments;
  final List<MissionModel> listMissionModels;
  ProgressSortEnum progressSortEnum;

  TimeRatioComponent({
    this.startTime,
    this.endTime,
    this.scene = "default",
    this.progressSortEnum = ProgressSortEnum.priority,
    this.firstChild,
    this.lastChild,
    required this.width,
    required this.height,
    // required this.totalTime,
    required this.listMissionModels,
    // required this.segments,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TimeRatioComponentState();
  }
}

class TimeRatioComponentState extends State<TimeRatioComponent> {
  List<TimeSegment> listTimeSegment = [];
  int totalTime = 1;
  List<CheckButtonStateModel> listRatioPopup = [];
  late ProgressSortEnum progressSortEnum;
  CheckButtonStateModel? checkButtonStateModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int index = SharePreferenceUtil.getSyncInstance().getInt(
        key:
            ShareprefrenceKeys.TimeRatioProgressSortEnumKey + this.widget.scene,
        defaultVal: -1);
    if (index == -1) {
      this.progressSortEnum = this.widget.progressSortEnum;
    } else {
      this.progressSortEnum = ProgressSortEnum.values[index];
    }
    this.listRatioPopup =
        CONSTANTS.getRatioPopup(defaultIndex: this.progressSortEnum);
    checkButtonStateModel = this.getCurRatioCheckButtonStateModel();
    // progressSortEnum = ProgressSortEnum.values[this.widget.progressSortEnum!.index];
  }

  CheckButtonStateModel getCurRatioCheckButtonStateModel() {
    for (int i = 0; i < this.listRatioPopup.length; i++) {
      if (this.listRatioPopup[i].isCheck) {
        return this.listRatioPopup[i];
      }
    }
    return this.listRatioPopup[0];
  }

  String getComleteMission() {
    switch(this.progressSortEnum) {
      case ProgressSortEnum.completeNum:
        return CONSTANTS.getSegmentDateString(dateTime1: this.widget.startTime, dateTime2: this.widget.endTime);
      case ProgressSortEnum.tomato:
        return CONSTANTS.getSegmentDateString(dateTime1: this.widget.startTime, dateTime2: this.widget.endTime);
      case ProgressSortEnum.Lyubichs:
        return CONSTANTS.getSegmentDateString(dateTime1: this.widget.startTime, dateTime2: this.widget.endTime);
      case ProgressSortEnum.priority:
        return CONSTANTS.getSegmentDateString(dateTime1: this.widget.startTime, dateTime2: this.widget.endTime);
    }
    return "";
  }

  String getTotalMission() {
    ProgressFocusModel progressFocusModel = getTotalCompleteMissionStatus();
    switch(this.progressSortEnum) {
      case ProgressSortEnum.completeNum:
        return "${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)}";
      case ProgressSortEnum.tomato:
        return "${getI18NKey().num_tomatoes(progressFocusModel.currentValue)}/${getI18NKey().num_tomatoes(progressFocusModel.totalValue)}";
      case ProgressSortEnum.Lyubichs:
        return "${Utility.formatTimestampWithoutZeroHM(progressFocusModel.currentValue * 1000)} / ${Utility.formatTimestampWithoutZeroHM(progressFocusModel.totalValue == 0 ? 1 : (progressFocusModel.totalValue * 1000))}";
      case ProgressSortEnum.priority:
        return "${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)}";
    }
    return "";
  }

  ProgressFocusModel getTotalCompleteMissionStatus() {
    ProgressFocusModel progressFocusModel= ProgressFocusModel();
    listTimeSegment.forEach((element) {
      progressFocusModel.totalValue += element.totalValue;
      progressFocusModel.currentValue += element.value;
    });
    return progressFocusModel;
  }



  @override
  Widget build(BuildContext context) {
    listTimeSegment = BeanParser.parseMissionModelListToTimeSegment(
        data: this.widget.listMissionModels,
        progressSortEnum: this.progressSortEnum ,startDateTime: this.widget.startTime, endDateTime: this.widget.endTime );
    totalTime = listTimeSegment.fold(
        0, (previousValue, element) => previousValue + element.totalValue);
    if (totalTime == 0) {
      totalTime = 1;
    }
    double fontSize = 12;

    return Container(
      // width: width,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 4),
              if(this.widget.firstChild != null)
                this.widget.firstChild!,
              if(!Utility.isHandsetBySize())
              Text(
                CONSTANTS.getSegmentDateString(
                    dateTime1: this.widget.startTime,
                    dateTime2: this.widget.endTime),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                getI18NKey().total_maju(getTotalMission()),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              if(this.widget.lastChild != null)
                SizedBox(width: 4),
              if(this.widget.lastChild != null)
              this.widget.lastChild!,
              SizedBox(width: 4),

            ],
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            width: widget.width,
            height: widget.height,
            margin: EdgeInsets.only(bottom: 4),
            child: Stack(
              children: _buildSegments(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomPopupWidget(
                onSelected: (model) {
                  this.checkButtonStateModel = model;
                  if (model is CheckButtonStateModel) {
                    switch (model.code) {
                      case 'Lyubichs':
                        this.progressSortEnum = ProgressSortEnum.Lyubichs;
                        break;
                      case 'four_quadrant':
                        this.progressSortEnum = ProgressSortEnum.priority;
                        break;
                      case 'tomato':
                        this.progressSortEnum = ProgressSortEnum.tomato;
                        break;
                      case 'num_mission':
                        this.progressSortEnum = ProgressSortEnum.completeNum;
                        break;
                    }
                    SharePreferenceUtil.getSyncInstance().setInt(
                        key: ShareprefrenceKeys.TimeRatioProgressSortEnumKey +
                            this.widget.scene,
                        value: this.progressSortEnum!.index);
                  }
                  setState(() {});
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    // decoration: BoxDecoration(
                    //     color: ThemeManager.getInstance()
                    //         .getDefautThemeColor(),
                    //     borderRadius:
                    //     BorderRadius.all(Radius.circular(20))),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        checkButtonStateModel!.checkIcon!,
                        SizedBox(
                          width: 4,
                        ),
                        new Text(
                          checkButtonStateModel!.title!,
                          maxLines: 1,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSize),
                        ),
                        //半透明圆形 里面有个inkwell x关闭按钮 点击会清空folderModelForFolder
                        // InkWell(
                        //   onTap: () {
                        //     // folderModelForFolder = null;
                        //     // updateUI();
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.only(left: 5),
                        //     padding: EdgeInsets.all(2),
                        //     decoration: BoxDecoration(
                        //         color: Color(0x33ffffff),
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(20))),
                        //     child: Icon(
                        //       Icons.close,
                        //       size: 12,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        // 向右的白色三角箭头
                        Icon(
                          Icons.arrow_drop_down,
                          color: ThemeManager.getInstance().isDark() ? Colors.white : Color(0xff404040),
                          size: 20,
                        )
                      ],
                    )),
                list: this.listRatioPopup,
              ),
              Expanded(child: HorItemScrollViewWidget(datas: listTimeSegment)),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: listTimeSegment.map((section) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 4.0),
          //       child: Row(
          //         children: [
          //           Container(
          //             width: 10,
          //             height: 10,
          //             color: section.color,
          //           ),
          //           SizedBox(width: 4),
          //           Text(section.label),
          //         ],
          //       ),
          //     );
          //   }).toList(),
          // ),
        ],
      ),
    );
  }

  List<Widget> _buildSegments() {
    double start = 0;
    return listTimeSegment.map((segment) {
      double widthFactor = segment.totalValue / totalTime;
      double widthFocused = segment.value / segment.totalValue > 1
          ? 1
          : segment.value / segment.totalValue;
      double width = widthFocused * widthFactor * widget.width;
      Color color = segment.color;
      print("widthFocused: $widthFocused, label: ${segment.label}");
      if (widthFocused < 1) {
        widthFocused = 0;
      }
      Widget segmentWidget = Positioned(
        left: start,
        width: widthFactor * widget.width,
        child: GestureDetector(
          onTap: segment.onTap,
          child: Stack(
            children: [
              Container(
                width: width,
                height: widget.height,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  color: Color(color.value),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: Color(color.value - 0xa0000000),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      );
      start += widthFactor * widget.width;
      return segmentWidget;
    }).toList();
  }
}

class TimeSegment {
  final String label;
  final Color color;
  final int totalValue;
  final int value;
  final VoidCallback onTap;

  TimeSegment(
      {required this.label,
      required this.value,
      required this.color,
      required this.totalValue,
      required this.onTap});
}
