import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../models/DateTimeModel.dart';
import '../../../util/Utility.dart';

class MissionCheckButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  Function onTapListener;
  String unit = getI18NKey().min_en;
  bool isMultiSelected = false;

  MissionCheckButtonListWidget(
      {required this.list,
      required this.onTapListener,
      unit,
      this.isMultiSelected: false}) {
    this.unit = unit ?? "";
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionCheckButtonListWidgetState(list: list);
  }
}

class MissionCheckButtonListWidgetState
    extends State<MissionCheckButtonListWidget> {
  List<CheckButtonStateModel> list = [];
  int endTime = -1;

  MissionCheckButtonListWidgetState({required this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(runSpacing: 10, children: getList(this.list));
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  resetButtonList() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }

  getAlertTime() async {
    DateTimeModel? model = await Utility.showDatePickerDialog(
        context, Utility.getTimeStampToday());
    // this.setState(() {
    //   this.isNeedUpdateBmob = true;
    //   this.widget.missionModel?.end_time =
    //       model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
    // });
    return model?.timestamp ?? 0;
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    if (model.code == 'customize') {
      print('customize');
    }
    if (model.isCheck == true) {
      return TextButton(
          style: StylesConfig.transparentTextButtonStyle,
          onPressed: () async {
            resetButtonList();
            if (model.code == 'customize') {
              endTime = await getAlertTime();
            }
            setState(() {
              model.isCheck = true;
              this.widget.onTapListener({"data": model, "index": index}, endTime);
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  color: ThemeManager.getInstance().getDefautThemeColor(),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Wrap(
                children: [
                  new Text(
                    model.code == 'customize'
                        ? (this.endTime == -1
                            ? getI18NKey().custom
                            : Utility.getDateTimeYMD(Utility.getDateTimeFromTimeStamp(this.endTime)))
                        : (model.title ?? ''),
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  model.title != getI18NKey().no_time_limit
                      ? SizedBox(
                          width: 2,
                        )
                      : SizedBox.shrink(),
                  model.title != getI18NKey().no_time_limit
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            this.widget.unit,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                      : SizedBox.shrink()
                ],
              )));
    } else {
      return TextButton(
          style: StylesConfig.transparentTextButtonStyle,
          onPressed: () async {
            print("自定义");
            if (model.code == 'customize') {
              endTime = await getAlertTime();
            }

            if (this.widget.isMultiSelected == false) {
              this.resetButtonList();
              setState(() {
                model.isCheck = true;
                this.widget.onTapListener({"data": model, "index": index}, endTime);
              });
            } else {
              setState(() {
                model.isCheck = !(model.isCheck ?? false);

                this.widget.onTapListener({"data": getCheckModelList()}, endTime);
              });
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  color: ThemeManager.getInstance().getCardBackgroundColor(),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Wrap(
                children: [
                  new Text(
                    model.code == 'customize'
                        ? (this.endTime == -1
                            ? getI18NKey().customize
                            : Utility.getDateTimeYMD(Utility.getDateTimeFromTimeStamp(this.endTime)))
                        : (model.title ?? ''),
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(color: ThemeManager.getInstance().getTextColor(), fontSize: 15),
                  ),
                  model.title != getI18NKey().no_time_limit
                      ? SizedBox(
                          width: 2,
                        )
                      : SizedBox.shrink(),
                  model.title != getI18NKey().no_time_limit
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            this.widget.unit,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff404040),
                                fontWeight: FontWeight.bold),
                          ))
                      : SizedBox.shrink()
                ],
              )));
    }

  }

  List<CheckButtonStateModel> getCheckModelList() {
    List<CheckButtonStateModel> list = [];
    this.list.forEach((element) {
      if (element.isCheck == true) {
        list.add(element);
      }
    });
    return list;
  }

  void initModelListState() {
    this.widget.list.forEach((element) {
      element.isCheck = false;
    });
  }
}
