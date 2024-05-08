import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import 'WQBComposedRichEditorWidget.dart';

class WQBComposeRichEditorContainerWidget extends StatefulWidget {
  String title;
  Function onTapOk;
  WQBMissionModel wqbMissionModel;
  SaveModeEnum saveModeEnum;
  WQBWrongQuestBookSceneEnum wqbSceneEnum;
  WQBComposeRichEditorContainerWidget({required Key? key, required this.wqbSceneEnum, required this.title, required this.onTapOk, required this.wqbMissionModel, required this.saveModeEnum}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBComposeRichEditorContainerWidgetState();
  }
}

class WQBComposeRichEditorContainerWidgetState extends State<WQBComposeRichEditorContainerWidget> {
  GlobalKey<WQBComposedRichEditorWidgetState> knowledgeRichEditorGlobakKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WQBComposedRichEditorWidget(key: knowledgeRichEditorGlobakKey, title: this.widget.title, saveModeEnum: this.widget.saveModeEnum, onTapOk: this.widget.onTapOk, wqbMissionModel: this.widget.wqbMissionModel, wqbSceneEnum: this.widget.wqbSceneEnum , );
  }

  globalSave() async {
    return await knowledgeRichEditorGlobakKey.currentState!.globalSave();
  }

}
