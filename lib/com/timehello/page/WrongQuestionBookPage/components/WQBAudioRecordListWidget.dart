import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/CircleWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/CONSTANTS.dart';
import '../../../config/ColorsConfig.dart';
import '../../../models/MissionModel.dart';
import '../../../models/WQBMissionModel.dart';
import '../../RecorderPage/RecordPage2.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';
import '../WQBReadOnlyPage.dart';
import 'WQBFileMessageWidget.dart';
import 'WQBRichEditorPage.dart';

class WQBAudioRecordListWidget extends StatefulWidget {
  WQBMissionModel? wqbMissionModel;
  MissionModel? missionModel;
  SaveModeEnum saveModeEnum;
  WQBWrongQuestBookSceneEnum wqbSceneEnum = WQBWrongQuestBookSceneEnum.knowledge_point;

  WQBAudioRecordListWidget(
      {this.wqbMissionModel,
        this.missionModel,
      required this.saveModeEnum,
      required this.wqbSceneEnum});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBAudioRecordListWidgetState();
  }
}

class WQBAudioRecordListWidgetState extends State<WQBAudioRecordListWidget> {
  // EditTypeEnum editTypeEnum;

  late TextEditingController _controller;

  List list = [];

  WQBAudioRecordListWidgetState();

  @override
  void initState() {
    list = getContent();
  }

  @override
  void didUpdateWidget(WQBAudioRecordListWidget oldWidget) {
    list = getContent();
  }

  List getContent() {
    if(this.widget.missionModel != null) {
      return this.widget.missionModel?.noteRecordUrls ?? [];
    } else {
      if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.knowledge_point) {
        return this.widget.wqbMissionModel?.wqbKnowledgeRecordUrls ?? [];
      } else if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.question_wrong_question) {
        return this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls ?? [];
      } else {
        return this.widget.wqbMissionModel?.wqbAnswerRecordUrls ?? [];
      }
    }
  }

  // {"path": path, "duration": duration}
  void setContent(Map recordUrl) {
    if(this.widget.missionModel != null) {
      if(this.widget.missionModel?.noteRecordUrls == null) {
        this.widget.missionModel?.noteRecordUrls = [];
      }
      this.widget.missionModel?.noteRecordUrls?.add(recordUrl);
      // return this.widget.missionModel?.noteRecordUrls ?? [];
    } else {
      if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.knowledge_point) {
        if (this.widget.wqbMissionModel?.wqbKnowledgeRecordUrls == null) {
          this.widget.wqbMissionModel?.wqbKnowledgeRecordUrls = [];
        }
        this.widget.wqbMissionModel?.wqbKnowledgeRecordUrls?.add(recordUrl);
      } else if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.question_wrong_question) {
        if (this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls == null) {
          this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls = [];
        }
        this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls?.add(recordUrl);
      } else {
        if (this.widget.wqbMissionModel?.wqbAnswerRecordUrls == null) {
          this.widget.wqbMissionModel?.wqbAnswerRecordUrls = [];
        }
        this.widget.wqbMissionModel?.wqbAnswerRecordUrls?.add(recordUrl);
      }
    }
    if(mounted)
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List list = getContent();
    //正常展示模式
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10, bottom: 100),
                //整个listview的top bottom margin
                itemBuilder: (context, int index) {
                  return WQBFileMessageWidget(data: list[index], saveModeEnum: this.widget.saveModeEnum,onTapDelete: (data) {
                    list.remove(data);
                    setState(() {});
                  });
                },
              ),
            ),
          ],
        ),
        this.widget.saveModeEnum == SaveModeEnum.normal
            ? SizedBox.shrink()
            : Positioned(
                right: 10,
                bottom: 10,
                child: CircleWidget(
                  onTapListener: (data) {
                    Utility.openPagePCAndMobile(context,
                        child: RecordPage2(
                          richTextModeEnum: RichTextModeEnum.getUrl,
                          shouldShowTitle: null,
                          onSubmit: (String title, String path, String localPath, int duration, int fileSize) {
                            setContent({"url": path, "duration": duration, "localUrl": localPath, "createdAt": Utility.getCurrentTimeInSpecifiedFormat(), "fileSize": fileSize});
                          },
                        ));
                  },
                ))
      ],
    );
  }
}
