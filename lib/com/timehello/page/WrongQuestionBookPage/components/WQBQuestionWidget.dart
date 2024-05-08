import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import '../../../config/ENUMS.dart';
import 'WQBComposedRichEditorWidget.dart';

/**
 * 问题组件
 */
class WQBQuestionWidget extends StatelessWidget {
  Function onTapOk;
  WQBMissionModel wqbMissionModel;
  SaveModeEnum saveModeEnum;
  Key key;
  WQBQuestionWidget({required this.key, required this.onTapOk, required this.wqbMissionModel, required this.saveModeEnum}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WQBComposedRichEditorWidget(title: getI18NKey().question_mistake, saveModeEnum: saveModeEnum, onTapOk: onTapOk, wqbMissionModel: this.wqbMissionModel, wqbSceneEnum: WQBWrongQuestBookSceneEnum.question_wrong_question, key: this.key,);
  }
}

