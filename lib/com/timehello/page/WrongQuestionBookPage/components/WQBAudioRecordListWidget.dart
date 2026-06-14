import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CircleWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../models/MissionModel.dart';
import '../../../models/WQBMissionModel.dart';
import '../../RecorderPage/RecordPage2.dart';
import 'WQBFileMessageWidget.dart';

class WQBAudioRecordListWidget extends StatefulWidget {
  final WQBMissionModel? wqbMissionModel;
  final MissionModel? missionModel;
  final SaveModeEnum saveModeEnum;
  final WQBWrongQuestBookSceneEnum wqbSceneEnum;
  final Function? onChange;
  WQBAudioRecordListWidget(
      {this.wqbMissionModel,
      this.missionModel,
      this.onChange,
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

  List list = [];

  WQBAudioRecordListWidgetState();

  @override
  void initState() {
    super.initState();
    list = getContent();
  }

  @override
  void didUpdateWidget(WQBAudioRecordListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    list = getContent();
  }

  List getContent() {
    if (this.widget.missionModel != null) {
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

  // 单条录音结构：{"url": path, "duration": duration, "recordText": "..."}
  // recordText 与音频放在同一个 map 中，避免另建数组后出现音频和转写文字错位。
  void setContent(Map recordUrl) {
    if (this.widget.missionModel != null) {
      if (this.widget.missionModel?.noteRecordUrls == null) {
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
        this.widget.wqbMissionModel?.wqbKnowledgeRecordUrls.add(recordUrl);
      } else if (this.widget.wqbSceneEnum ==
          WQBWrongQuestBookSceneEnum.question_wrong_question) {
        if (this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls == null) {
          this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls = [];
        }
        this.widget.wqbMissionModel?.wqbWrongQuestionRecordUrls.add(recordUrl);
      } else {
        if (this.widget.wqbMissionModel?.wqbAnswerRecordUrls == null) {
          this.widget.wqbMissionModel?.wqbAnswerRecordUrls = [];
        }
        this.widget.wqbMissionModel?.wqbAnswerRecordUrls.add(recordUrl);
      }
    }
    if (mounted) setState(() {});
    this.widget.onChange?.call();
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
                  return WQBFileMessageWidget(
                      data: list[index],
                      saveModeEnum: this.widget.saveModeEnum,
                      onTapDelete: (data) {
                        // 删除录音后必须继续走外层保存链路，否则只会本地消失，
                        // 刷新页面后 Mongo 中旧的 recordUrls 又会被重新带回来。
                        list.removeAt(index);
                        setState(() {});
                        this.widget.onChange?.call();
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
                        showPCShell: false,
                        child: RecordPage2(
                          richTextModeEnum: RichTextModeEnum.getUrl,
                          shouldShowTitle: null,
                          onSubmit: null,
                          onSubmitWithText: (String title,
                              String path,
                              String localPath,
                              int duration,
                              int fileSize,
                              String recordText) {
                            setContent({
                              "url": path,
                              "duration": duration,
                              "localUrl": localPath,
                              "createdAt":
                                  Utility.getCurrentTimeInSpecifiedFormat(),
                              "fileSize": fileSize,
                              "recordText": recordText,
                            });
                          },
                        ));
                  },
                ))
      ],
    );
  }
}
