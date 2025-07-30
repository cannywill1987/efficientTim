import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../config/ENUMS.dart';
import '../models/DateTimeModel.dart';
import '../models/MissionModel.dart';
import '../util/Utility.dart';


class ObjectiveListScreen extends StatefulWidget {
  List<MissionModel> missionModels = [];
  PageModeEnum pageEnum;

  ObjectiveListScreen({List<MissionModel>? missionModels, required this.pageEnum}) {
    if (missionModels == null) {
      this.missionModels = [];
    } else {
      this.missionModels = missionModels;
    }
  }

  @override
  _ObjectiveListScreenState createState() => _ObjectiveListScreenState();
}

class _ObjectiveListScreenState extends State<ObjectiveListScreen> {
  void _addObjective() {
    setState(() {
      MissionModel model = MissionModel();
      model.time_mode = 2;
      model.title = "";
      model.objectiveUnit = "";
      model.objectiveTotalValue = 0;
      this.widget.missionModels.add(model);
    });
  }

  void _removeObjective(int index) {
    setState(() {
      this.widget.missionModels.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [

          ...this.widget.missionModels.map((missionModel) {
            int index = this.widget.missionModels.indexOf(missionModel);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeObjective(index),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeManager.getInstance().getCardBackgroundColor(),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CreateObjectiveItem(missionModel: missionModel,)
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addObjective,
          ),

        ],
      ),
    );
  }
}

class CreateObjectiveItem extends StatefulWidget {
  MissionModel? missionModel;

  CreateObjectiveItem({this.missionModel});

  @override
  _CreateObjectiveItemState createState() => _CreateObjectiveItemState();
}

class _CreateObjectiveItemState extends State<CreateObjectiveItem> {
  bool isQuantifyGoalEnabled = true;
  double itemMargin = 8;

  late TextEditingController titleController;
  late TextEditingController objectiveUnitController;
  late TextEditingController objectiveTotalValueController;

  @override
  void initState() {
    super.initState();

    widget.missionModel ??= MissionModel();

    titleController = TextEditingController(text: widget.missionModel?.title ?? '');
    objectiveUnitController = TextEditingController(text: widget.missionModel?.objectiveUnit ?? '');
    objectiveTotalValueController = TextEditingController(text: widget.missionModel?.objectiveTotalValue?.toString() ?? '');

    titleController.addListener(() {
      widget.missionModel?.title = titleController.text;
    });
    objectiveUnitController.addListener(() {
      widget.missionModel?.objectiveUnit = objectiveUnitController.text;
    });
    objectiveTotalValueController.addListener(() {
      widget.missionModel?.objectiveTotalValue = double.tryParse(objectiveTotalValueController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    objectiveUnitController.dispose();
    objectiveTotalValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemWithTitle(
            title: getI18NKey().title,
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: getI18NKey().enter_objective_title,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: itemMargin),
          ItemWithTitle(
            title: getI18NKey().date,
              child: Container(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    getDailyStartTimeWidget(context),
                    getDailyEndTimeWidget(context),
                  ],
                ),
              )
          ),
          SizedBox(height: itemMargin),
          ItemWithTitle(
            title: getI18NKey().quantified_goal,
            child: Switch(
              value: isQuantifyGoalEnabled,
              onChanged: (value) {
                setState(() {
                  isQuantifyGoalEnabled = value;
                });
              },
            ),
          ),
          if (isQuantifyGoalEnabled) ...[
            SizedBox(height: itemMargin),
            ItemWithTitle(
              title: getI18NKey().total_value,
              child: TextField(
                controller: objectiveTotalValueController,
                decoration: InputDecoration(
                  hintText: getI18NKey().enter_total_value,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: itemMargin),
            ItemWithTitle(
              title: getI18NKey().unit,
              child: TextField(
                controller: objectiveUnitController,
                decoration: InputDecoration(
                  hintText: getI18NKey().enter_unit,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
          SizedBox(height: itemMargin),
          Text(
            getI18NKey().free_check_in,
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Row getDailyEndTimeWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                getI18NKey().deadLine,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(
                width: 5,
              ),
              new Text(
                  this.widget.missionModel?.end_time != null
                      ? Utility.formatHourAndMin2(
                      this.widget.missionModel?.end_time ?? 0)
                      : getI18NKey().none,
                  style: TextStyle(
                      color: ThemeManager.getInstance()
                          .getTextColor(defaultColor: Colors.black87),
                      fontSize: 12)),
              Icon(
                Icons.arrow_right_sharp,
                color: ThemeManager.getInstance()
                    .getIconColor(defaultColor: Colors.black87),
              )
            ],
          ),
          onTap: () async {
            if (this.widget.missionModel?.start_time == null) {
              Utility.showToastMsg(
                  msg: getI18NKey().please_select_daily_start_time);
              return;
            }
            DateTimeModel? model =
            await Utility.showDateTimePickerDialog(context);

            int? startTime = this.widget.missionModel?.end_time;
            int? endTime = model?.timestamp;
            if (startTime != null && endTime != null) {
              bool isBefore = (startTime > endTime);
              if (isBefore) {
                Utility.showToastMsg(
                    msg: getI18NKey().end_time_cannot_before_start_time);
                return;
              }
            }

            // if((model?.timestamp ?? 0) < (this.widget.folderModel?.start_time ?? 100000000)) {
            //   Utility.showToast(msg: getI18NKey().end_time_cannot_before_start_time);
            //   return;
            // }
            // if(this.widget.folderModel.start_time != null && this.widget.folderModel.end_time != null) {
            // bool isBefore = (this.widget.folderModel.start_time! > model!.timestamp!);
            //   if(isBefore) {
            //     Utility.showToast(msg: getI18NKey().end_time_cannot_before_start_time);
            //     return;
            // }
            // }

            this.widget.missionModel?.end_time = model?.timestamp;
            // this.widget.folderModel?.end_time =;
            int daysDifferent = Utility.getDayDiffByDayFromTimeStamp(
                this.widget.missionModel?.end_time ?? 0,
                this.widget.missionModel?.start_time ?? 0);
            setState(() {});
          },
        ),
        this.widget.missionModel?.start_time != null &&
            this.widget.missionModel?.end_time != null
            ? Text(
          getI18NKey().num_days(Utility.getDayDiffByDayFromTimeStamp(
              this.widget.missionModel?.end_time ?? 0,
              this.widget.missionModel?.start_time ?? 0)),
          style: TextStyle(fontSize: 13, color: Color(0xff999999)),
        )
            : SizedBox.shrink()
      ],
    );
  }

  InkWell getDailyStartTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().start_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.widget.missionModel?.start_time != null
                  ? Utility.formatHourAndMin2(
                  this.widget.missionModel?.start_time ?? 0)
                  : getI18NKey().none,
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        DateTimeModel? model = await Utility.showDateTimePickerDialog(context);
        int? startTime = model?.timestamp;
        int? endTime = this.widget.missionModel?.end_time;
        if (startTime != null && (endTime != null  && endTime != 0)) {
          bool isBefore = (startTime > endTime);
          if (isBefore) {
            Utility.showToastMsg(
                msg: getI18NKey().end_time_cannot_before_start_time);
            return;
          }
        }

        this.widget.missionModel?.start_time = model?.timestamp;
        // this.widget.folderModel?.end_time =;
        int daysDifferent = Utility.getDayDiffByDayFromTimeStamp(
            this.widget.missionModel?.end_time ?? 0,
            this.widget.missionModel?.start_time ?? 0);
        setState(() {});
      },
    );
  }
}
class ItemWithTitle extends StatelessWidget {
  final String title;
  final Widget child;

  const ItemWithTitle({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Spacer(flex: 1),
          Expanded(flex:2, child: child),
        ],
      ),
    );
  }
}
