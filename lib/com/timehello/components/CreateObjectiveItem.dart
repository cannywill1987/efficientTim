import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../config/ENUMS.dart';
import '../models/DateTimeModel.dart';
import '../models/MissionModel.dart';
import '../util/Utility.dart';


class ObjectiveListScreen extends StatefulWidget {
  // MissionModel missionModel;
  List<MissionModel> missionModels = [];
  PageModeEnum pageEnum; //用于判断创建 或者 更新

  ObjectiveListScreen({
    List<MissionModel>? missionModels, required this.pageEnum}) {
    if(missionModels == null) {
      this.missionModels = [];
    } else {
      this.missionModels = missionModels;
    }
  } // ObjectiveListScreen({required this.missionModel});
  @override
  _ObjectiveListScreenState createState() => _ObjectiveListScreenState();
}

class _ObjectiveListScreenState extends State<ObjectiveListScreen> {
  // List<String> objectives = [];

  void _addObjective() {
    setState(() {
      MissionModel model = MissionModel();
      model.time_mode = 2; // 0 日期 1 时间段 2 目标
      model.title = "123";
      model.objectiveUnit = "unit";
      model.objectiveTotalValue = 300;
      this.widget.missionModels.add(model);
      // objectives.add("New Objective");
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
      child: SingleChildScrollView(
        child: Column(
          children: [IconButton(
            icon: Icon(Icons.add),
            onPressed: _addObjective,
          ), ...this.widget.missionModels.map((missionModel) {
            int index = this.widget.missionModels.indexOf(missionModel);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  // 删除按钮
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeObjective(index),
                  ),

                  // 圆角白色容器
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
                      child:CreateObjectiveItem(missionModel: missionModel,)
                      // Text(objectives[index]),
                    ),
                  ),
                ],
              ),
            );
          }).toList()],
        ),
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
  bool isFreeCheckIn = true;
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
            title: '标题',
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: '输入这个目标的目标标题',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: itemMargin),
          ItemWithTitle(
            title: '日期',
            child: GestureDetector(
              onTap: () {
                // Handle date selection
              },
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
              ),
            ),
          ),
          SizedBox(height: itemMargin),

          ItemWithTitle(
            title: '量化目标',
            child: Container(
              alignment: Alignment.centerRight,
              child: Switch(
                value: isQuantifyGoalEnabled,
                onChanged: (value) {
                  setState(() {
                    isQuantifyGoalEnabled = value;
                  });
                },
              ),
            ),
          ),
          if (isQuantifyGoalEnabled) ...[
            SizedBox(height: itemMargin),
            ItemWithTitle(
              title: '总量',
              child: TextField(
                controller: objectiveTotalValueController,
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")), //数字包括小数
                ],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,

                decoration: InputDecoration(
                  hintText: '输入这个目标的目标数值(整数)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: itemMargin),
            ItemWithTitle(
              title: '单位',
              child: TextField(
                controller: objectiveUnitController,
                decoration: InputDecoration(
                  hintText: '输入单位：如元、个、次等',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
          SizedBox(height: itemMargin),
          Text(
            '不固定时间，随时打卡更新目标进度',
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
          Spacer(flex: 2),
          Expanded(child: child),
        ],
      ),
    );
  }
}


