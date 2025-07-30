import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import '../../../config/ENUMS.dart';
import 'WQBComposedRichEditorWidget.dart';

class WQBAnswerWidget extends StatelessWidget {
  Function onTapOk;
  WQBMissionModel wqbMissionModel;
  SaveModeEnum saveModeEnum;
  Key key;
  WQBAnswerWidget({required this.key, required this.onTapOk, required this.wqbMissionModel, required this.saveModeEnum});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WQBComposedRichEditorWidget(title: getI18NKey().normal_solution, saveModeEnum: saveModeEnum, onTapOk: onTapOk, wqbMissionModel: this.wqbMissionModel, wqbSceneEnum: WQBWrongQuestBookSceneEnum.correct_answer, key: this.key,);
  }
}
