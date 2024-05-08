import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/CreditCardModel.dart';
import 'package:time_hello/com/timehello/models/EndTimeMissionModel.dart';

import '../../beans/BillModel.dart';
import '../../beans/ResourceDeliveryInfoBean.dart';
import '../../beans/ResourceLocationInfoBean.dart';
import '../../config/ENUMS.dart';
import '../../models/CalendarModel.dart';
import '../../models/ChatGptMessageModel.dart';
import '../../models/CourseModel.dart';
import '../../models/EventCollectionModel.dart';
import '../../models/FlomoMissionModel.dart';
import '../../models/FolderModel.dart';
import '../../models/GroupModel.dart';
import '../../models/MissionModel.dart';
import '../../models/PresentModel.dart';
import '../../models/StatsModel.dart';
import '../../models/TimelineMissionModel.dart';
import '../../models/WQBFolderModel.dart';
import '../../models/WQBMissionModel.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class MissionDetailEnv with ChangeNotifier, DiagnosticableTreeMixin {

  MissionModel? _missionModel; //任务
  FolderModel? _folderModel; //folderModel
  CounterEnum _counterEnum = CounterEnum.chronograph;
  PageEnum? _pageEnum = PageEnum.Normal;
  int _timeHasUsed = 0; //从live activity过来需要计算
  static int isFromPushTimes = 0; // 用来比较次数 否则MIssionDetailEnv会被多次创建无法计时

  CounterStatus? _counterStatusFromLiveActivity =
      CounterStatus.none; //用于继续某个时间段的计时

  MissionModel? get missionModel => _missionModel;

  set missionModel(MissionModel? value) {
    _missionModel = value;
    notifyListeners();
  }

  FolderModel? get folderModel => _folderModel;

  set folderModel(FolderModel? value) {
    _folderModel = value;
    notifyListeners();
  }

  CounterEnum get counterEnum => _counterEnum;

  set counterEnum(CounterEnum value) {
    _counterEnum = value;
    notifyListeners();
  }

  PageEnum? get pageEnum => _pageEnum;

  set pageEnum(PageEnum? value) {
    _pageEnum = value;
    notifyListeners();
  }

  int get timeHasUsed => _timeHasUsed;

  set timeHasUsed(int value) {
    _timeHasUsed = value;
    notifyListeners();
  }

  CounterStatus? get counterStatusFromLiveActivity => _counterStatusFromLiveActivity;

  set counterStatusFromLiveActivity(CounterStatus? value) {
    _counterStatusFromLiveActivity = value;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IntProperty('curFolderSelected', curFolderSelected));
  }
}