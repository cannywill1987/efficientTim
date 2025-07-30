import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import 'WQBTitle.dart';

enum Severity { light, heavy }

class WQBResultListView extends StatefulWidget {
  WQBMissionModel wqbMissionModel;
  SaveModeEnum saveModeEnum;
  WQBResultListView({required this.saveModeEnum, required this.wqbMissionModel});

  @override
  _WQBResultListViewState createState() => _WQBResultListViewState();
}

class _WQBResultListViewState extends State<WQBResultListView> {
  List<Severity> _severityList = List<Severity>.filled(5, Severity.light);

  @override
  Widget build(BuildContext context) {
    // WQBTitle(title: "复习周期"),
    return Column(
      children: [
        TitleContainerWidget(
          title: getI18NKey().cause_analysis,
        ),
        Container(
            width: double.infinity,
            height: 2,
            color: ColorsConfig.borderLineColor),
        ...List.generate(this.widget.wqbMissionModel.causeAnalysis?.length ?? 0,
            (index) {
          return getWidget(index);
        }),
      ],
    );
  }

  String getS(String code) {
    switch (code) {
      case 'confused':
        return getI18NKey().confused;
      case 'examination':
        return getI18NKey().examination;
      case 'wrong_thinking':
        return getI18NKey().wrong_thinking;
      default:
        return getI18NKey().arithmetic_error;
    }
  }

  Padding getWidget(int index) {
    Map map = this.widget.wqbMissionModel.causeAnalysis?[index];
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(getS(map['code'])
              // ['概念模糊', '审题错误', '思路错误', '运算错误', '粗心大意'][index],
              ),
          Row(
            children: [
              Text(getI18NKey().light),
              Radio<int>(
                value: map['weight'],
                groupValue: 0,
                onChanged: (int? value) {
                  map['weight'] = 0;
                  if(this.widget.saveModeEnum == SaveModeEnum.normal) {
                    MongoApisManager.getInstance().update_WQBMissionModel(
                        missionModel: this.widget.wqbMissionModel);
                  }
                  setState(() {
                  });
                },
              ),
              Text(getI18NKey().heavy),
              Radio<int>(
                value: map['weight'],
                groupValue: 1,
                onChanged: (int? value) {
                  map['weight'] = 1;
                  if(this.widget.saveModeEnum == SaveModeEnum.normal) {
                    MongoApisManager.getInstance().update_WQBMissionModel(
                        missionModel: this.widget.wqbMissionModel);
                  }
                  setState(() {
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
