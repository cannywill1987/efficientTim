import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/MissionModel.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import '../WQBReadOnlyPage.dart';
import 'WQBRichEditorPage.dart';

/**
 * 纯文本组件
 */
class WQPlainTextWidget extends StatefulWidget {
  WQBMissionModel? wqbMissionModel;
  MissionModel? missionModel;
  SaveModeEnum editTypeEnum;
  WQBWrongQuestBookSceneEnum wqbSceneEnum =
      WQBWrongQuestBookSceneEnum.knowledge_point;

  WQPlainTextWidget(
      {this.wqbMissionModel,
      this.missionModel,
      required this.editTypeEnum,
      required this.wqbSceneEnum});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQPlainTextWidgetState();
  }
}

class WQPlainTextWidgetState extends State<WQPlainTextWidget> {
  // EditTypeEnum editTypeEnum;

  late TextEditingController _controller;

  WQPlainTextWidgetState();

  @override
  void initState() {
    _controller = TextEditingController(text: getContent());
  }

  @override
  void didUpdateWidget(WQPlainTextWidget oldWidget) {
    if (_controller != null) {
      _controller.text = getContent();
    }
  }

  String getContent() {
    if(this.widget.missionModel != null) {
      return this.widget.missionModel?.message ?? "";
    } else {
      if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.knowledge_point) {
        return this.widget.wqbMissionModel?.wqbKnowledgeContent ?? "";
      } else if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.question_wrong_question) {
        return this.widget.wqbMissionModel?.wqbWrongQuestionContent ?? "";
      } else {
        return this.widget.wqbMissionModel?.wqbAnswerContent ?? "";
      }
    }
  }

  void setContent(String content) {
    if(this.widget.missionModel != null) {
      this.widget.missionModel?.message = content;
    } else {
      if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.knowledge_point) {
        this.widget.wqbMissionModel?.wqbKnowledgeContent = content;
      } else if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.question_wrong_question) {
        this.widget.wqbMissionModel?.wqbWrongQuestionContent = content;
      } else {
        this.widget.wqbMissionModel?.wqbAnswerContent = content;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return this.widget.editTypeEnum == SaveModeEnum.normal
        ? Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: SingleChildScrollView(
        child: Text(getContent() ?? "", textAlign: TextAlign.left),
      ),
        )
        : TextField(
            maxLines: 3000,
            // maxLines: 400,
            controller: _controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: getI18NKey().please_input_content),
            onChanged: (val) {
              setContent(val);
              // this.widget.wqbMissionModel?.content = val;
            },
          );
  }
}
