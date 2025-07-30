import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomMissionSilverWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../models/MissionModel.dart';
import 'PrioriyColorsGridViewWidget.dart';

class PriorityMissionListWidget extends StatefulWidget {
  List<MissionModel> list;
  int priority = -1;
  Function onTapCloseListener;
  PriorityMissionListWidget({required this.onTapCloseListener, required this.priority, Key? key, required this.list}) : super(key: key);
  @override
  _PriorityMissionListWidgetState createState() => _PriorityMissionListWidgetState();
}

class _PriorityMissionListWidgetState extends State<PriorityMissionListWidget> {
  List<CheckButtonStateModel> listCurPercentagePrioriyCheckModel =
  CONSTANTS.getPriorityList();
  int curListCurPrioriyMissionModelsPercentageIndex = 0;
  List<MissionModel> listCurPrioriyMissionModelsPercentage = [];

  initState() {
    super.initState();
    setCurIndexOflistCurPrioriyCheckModelPercentage(this.widget.priority);
    // this.listCurPrioriyMissionModelsPercentage =
    //     this.widget.list;
  }

  setCurIndexOflistCurPrioriyCheckModelPercentage(int index) {
    this.curListCurPrioriyMissionModelsPercentageIndex = index;
    bool isCheck = false;
    for (int i = 0; i < listCurPercentagePrioriyCheckModel.length; i++) {
      CheckButtonStateModel model = listCurPercentagePrioriyCheckModel[i];
      if(i == index && model.isCheck == false) {
        isCheck = true;
        model.isCheck = true;
      } else {
        model.isCheck = false;
      }
      // model.isCheck = ;
    }
    if(isCheck == false) {
      this.listCurPrioriyMissionModelsPercentage = this.widget.list;
      return;
    }
    List<MissionModel> list = [];
      this.widget.list.forEach((element) {
        if(element.priorityStatus == index) {
          list.add(element);
        }
      });
    this.listCurPrioriyMissionModelsPercentage = list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(color: ThemeManager.getInstance().getCardBackgroundColor()),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                  height: 40,
                  child: PrioriyColorsGridViewWidget(
                    onTapListener: (index) {
                      setCurIndexOflistCurPrioriyCheckModelPercentage(index);
                      setState(() {});
                    },
                    datas: listCurPercentagePrioriyCheckModel,
                  )),
              Expanded(
                child: CustomMissionSilverWidget(
                    listMissionModel: listCurPrioriyMissionModelsPercentage),
              ),
            ],
          ),
          Positioned(
              right: 10,
              top: 8,
              child: InkWell(
                onTap: () {
                  this.widget.onTapCloseListener();
                },
                child: Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ))
        ],
      ),
    );
  }
}