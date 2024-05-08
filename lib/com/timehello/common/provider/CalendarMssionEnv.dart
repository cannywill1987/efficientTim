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
class CalendarMssionEnv with ChangeNotifier, DiagnosticableTreeMixin {
  MissionModel? _curSelectedMissionModel; //任务
  FolderModel? _curSelectedFolderModel; //任务
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  DateTime? get startDateTime => _startDateTime;

  set startDateTime(DateTime? value) {
    _startDateTime = value;
    notifyListeners();
  }

  DateTime? get endDateTime => _endDateTime;

  set endDateTime(DateTime? value) {
    _endDateTime = value;
    notifyListeners();
  }

  FolderModel? get curSelectedFolderModel => _curSelectedFolderModel;

  set curSelectedFolderModel(FolderModel? value) {
    _curSelectedFolderModel = value;
    notifyListeners();
  }

  MissionModel? get curSelectedMissionModel => _curSelectedMissionModel;

  set curSelectedMissionModel(MissionModel? value) {
    _curSelectedMissionModel = value;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IntProperty('curFolderSelected', curFolderSelected));
  }
}
