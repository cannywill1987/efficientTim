import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../models/DateTimeModel.dart';
import '../models/MissionModel.dart';
import '../util/Utility.dart';


class ObjectiveListScreen extends StatefulWidget {
  // MissionModel missionModel;
  // ObjectiveListScreen({required this.missionModel});
  @override
  _ObjectiveListScreenState createState() => _ObjectiveListScreenState();
}

class _ObjectiveListScreenState extends State<ObjectiveListScreen> {
  List<String> objectives = [];

  void _addObjective() {
    setState(() {
      objectives.add("New Objective");
    });
  }

  void _removeObjective(int index) {
    setState(() {
      objectives.removeAt(index);
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
          ), ...objectives.map((objective) {
            int index = objectives.indexOf(objective);
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
                      child:CreateObjectiveItem()
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
  bool isQuantifyGoalEnabled = false;
  bool isFreeCheckIn = true;

  Row getDailyEndTimeWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        if (startTime != null && endTime != null) {
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


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemWithTitle(
              title: '开始日期',
              child: GestureDetector(
                onTap: () {
                  // Handle date selection
                },
                child: Container(
                  padding: EdgeInsets.only(left: 8, bottom: 15),
                  child: Row(
                    children: [
                      getDailyStartTimeWidget(context),
                      SizedBox(
                        width: 0,
                      ),
                      getDailyEndTimeWidget(context),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '量化目标',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: isQuantifyGoalEnabled,
                  onChanged: (value) {
                    setState(() {
                      isQuantifyGoalEnabled = value;
                    });
                  },
                ),
              ],
            ),
            if (isQuantifyGoalEnabled) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFreeCheckIn = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isFreeCheckIn ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '自由打卡',
                          style: TextStyle(
                            color: isFreeCheckIn ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFreeCheckIn = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isFreeCheckIn ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '规律打卡',
                          style: TextStyle(
                            color: !isFreeCheckIn ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ItemWithTitle(
                title: '总量',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '输入这个目标的目标数值',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ItemWithTitle(
                title: '单位',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '输入单位：如元、个、次等',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
            SizedBox(height: 16),
            PunchCardPage(),
            Text(
              '不固定时间，随时打卡更新目标进度',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Spacer(),
        Flexible(flex: 2,child: child),
      ],
    );
  }
}


class PunchCardPage extends StatefulWidget {
  @override
  _PunchCardPageState createState() => _PunchCardPageState();
}

class _PunchCardPageState extends State<PunchCardPage> {
  bool isFreeCard = true;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemWithTitle(
          title: '总量',
          child: TextField(
            decoration: InputDecoration(
              hintText: '输入这个目标的目标数值',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ItemWithTitle(
          title: '单位',
          child: TextField(
            decoration: InputDecoration(
              hintText: '输入单位：如元、个、次等等',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
