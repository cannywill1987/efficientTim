import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/EmptyWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/WQBFolderModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';
import 'package:time_hello/com/timehello/page/WrongQuestionBookPage/WrongQuestionBookPage.dart';

import '../../common/provider/Env.dart';
import 'components/WQBNoteWidget.dart';

class WQBMissionDetailpage extends StatefulWidget {
  const WQBMissionDetailpage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBMissionDetailpageState();
  }
}

class WQBMissionDetailpageState extends State<WQBMissionDetailpage> {
  // late WQBMissionModel missionModel;
  @override
  Widget build(BuildContext context) {
    return Selector<Env, Map?>(
        selector: (_, env) => env.wqbRouterMissionDetailData,
        builder: (_, wqbRouterMissionDetailData, __) {
          String? page = wqbRouterMissionDetailData?['page'];
          WQBMissionModel missionData =
              wqbRouterMissionDetailData?['data'] ?? WQBMissionModel();
          WQBFolderModel folderData =
              wqbRouterMissionDetailData?['folderdata'] ?? WQBFolderModel();
          // this.missionModel = wqbRouterMissionDetailData?['data'] ?? WQBMissionModel();
          // 0 错题本 1 便签 2 记忆卡片 3 备忘录
          if (page == 'WrongQuestionBookPage' && missionData.type == 0) {
            return WrongQuestionBookPage(
              key: ValueKey("ejwfi"),
              wqbMissionModel: missionData,
              folderModel: folderData,
              saveModeEnum: SaveModeEnum.normal,
              sceneEnum: WQBSceneEnum.question_wrong_book,
            );
          } else if (page == 'WrongQuestionBookPage' && missionData.type == 2) {
            return WrongQuestionBookPage(
              key: ValueKey("ejwfi"),
              wqbMissionModel: missionData,
              folderModel: folderData,
              saveModeEnum: SaveModeEnum.normal,
              sceneEnum: WQBSceneEnum.card,
            );
          } else if (page == 'WrongQuestionBookPage' && missionData.type == 3) {
            return WrongQuestionBookPage(
              key: ValueKey("ejwfi"),
              wqbMissionModel: missionData,
              folderModel: folderData,
              saveModeEnum: SaveModeEnum.normal,
              sceneEnum: WQBSceneEnum.memorandum,
            );
          } else if (page == 'WrongQuestionBookPage' && missionData.type == 1) {
            return WrongQuestionBookPage(
              key: ValueKey("ejwfi"),
              wqbMissionModel: missionData,
              folderModel: folderData,
              saveModeEnum: SaveModeEnum.normal,
              sceneEnum: WQBSceneEnum.note,
            );

          } else {
            return EmptyWidget();
          }
        });
  }
}
