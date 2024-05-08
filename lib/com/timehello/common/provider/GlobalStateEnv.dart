import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/CreditCardModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/EndTimeMissionModel.dart';
import 'package:time_hello/com/timehello/models/SharePreferenceModel.dart';

import '../../beans/BillModel.dart';
import '../../beans/ResourceDeliveryInfoBean.dart';
import '../../beans/ResourceLocationInfoBean.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../models/CalendarModel.dart';
import '../../models/ChatGptMessageModel.dart';
import '../../models/CourseModel.dart';
import '../../models/EventCollectionModel.dart';
import '../../models/EventFn.dart';
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
class GlobalStateEnv with ChangeNotifier, DiagnosticableTreeMixin {

  List<ResourceDeliveryInfoBean>? _gamePagesResourceDeliveryInfoBeanList; //游戏列表
  List<ResourceDeliveryInfoBean>? _gameBackgroundDeliveryInfoBeanList; //游戏列表
  List<FolderModel> _listFolderModels = [];
  List<WQBFolderModel> _listWQBFolderModel = [];
  List<WQBMissionModel> _listWQBMissionModel = [];
  List<TimelineMissionModel> _listTimelineMissionModel = [];
  List<FlomoMissionModel> _listFlomoMissionModel = [];
  List<CreditCardModel> _listCreditCardModel = [];
  List<BillModel> _listBillModel = [];
  List<GroupModel> _listGroupModel = [];
  List<SharePreferenceModel> _listSharePreferenceModel = [];
  List<ChatGptFolderModel> _listChatGptFolderModel = [];

  List<EndTimeMissionModel> _listEndTimeMissionModel = [];
  List<MissionModel> _listMissionModels = [];
  List<StatsModel> _listStatsModels = [];
  List<PresentModel> _listPresentModel = [];
  List<CourseModel> _listCourseModel = [];
  List<ChatGptMessageModel> _listChatGptMessageModel = [];
  List<EventCollectionModel> _listEventCollectionModel = [];
  CalendarModel? _calendarModel; //日历model
  WQBModeEnum _wqbModeEnum = WQBModeEnum.all;

  List<EventCollectionModel> get listEventCollectionModel => _listEventCollectionModel;

  set listEventCollectionModel(List<EventCollectionModel> value) {
    _listEventCollectionModel = value;
    notifyListeners();
  }

  List<ChatGptFolderModel> get listChatGptFolderModel => _listChatGptFolderModel;

  set listChatGptFolderModel(List<ChatGptFolderModel> value) {
    _listChatGptFolderModel = value;
    notifyListeners();
  }

  WQBModeEnum get wqbModeEnum => _wqbModeEnum;

  set wqbModeEnum(WQBModeEnum value) {
    _wqbModeEnum = value;
    notifyListeners();
  }

  List<ChatGptMessageModel> get listChatGptMessageModel => _listChatGptMessageModel;

  set listChatGptMessageModel(List<ChatGptMessageModel> value) {
    _listChatGptMessageModel = value;
    notifyListeners();
  }

  List<CourseModel> get listCourseModel => _listCourseModel;

  set listCourseModel(List<CourseModel> value) {
    _listCourseModel = value;
    notifyListeners();
  }

  List<StatsModel> get listStatsModels => _listStatsModels;

  set listPresentModel(List<PresentModel> value) {
    _listPresentModel = value;
    notifyListeners();
  }

  List<PresentModel> get listPresentModel => _listPresentModel;

  set listStatsModels(List<StatsModel> value) {
    _listStatsModels = value;
    notifyListeners();
  }

  List<WQBMissionModel> get listWQBMissionModel => _listWQBMissionModel;

  set listWQBMissionModel(List<WQBMissionModel> value) {
    _listWQBMissionModel = value;
    notifyListeners();
  }


  List<EndTimeMissionModel> get listEndTimeMissionModel => _listEndTimeMissionModel;

  set listEndTimeMissionModel(List<EndTimeMissionModel> value) {
    _listEndTimeMissionModel = value;
    notifyListeners();
  }


  List<TimelineMissionModel> get listTimelineMissionModel => _listTimelineMissionModel;

  set listTimelineMissionModel(List<TimelineMissionModel> value) {
    _listTimelineMissionModel = value;
    eventBus.fire(EventFn(Params.ACTION_UPDATE_STATISTIC, {}));
    notifyListeners();
  }


  List<SharePreferenceModel> get listSharePreferenceModel => _listSharePreferenceModel;

  set listSharePreferenceModel(List<SharePreferenceModel> value) {
    _listSharePreferenceModel = value;
    notifyListeners();
  }

  // List<SharePreferenceModel> get listSharePreferenceModel => _listSharePreferenceModel;

  set listGroupModel(List<GroupModel> value) {
    _listGroupModel = value;
    notifyListeners();
  }

  List<BillModel> get listBillModel => _listBillModel;

  set listBillModel(List<BillModel> value) {
    _listBillModel = value;
    notifyListeners();
  }


  List<CreditCardModel> get listCreditCardModel => _listCreditCardModel;

  set listCreditCardModel(List<CreditCardModel> value) {
    _listCreditCardModel = value;
    notifyListeners();
  }

  List<FlomoMissionModel> get listFlomoMissionModel => _listFlomoMissionModel;

  set listFlomoMissionModel(List<FlomoMissionModel> value) {
    _listFlomoMissionModel = value;
    notifyListeners();
  }

  List<MissionModel> get listMissionModels => _listMissionModels;

  set listMissionModels(List<MissionModel> value) {
    _listMissionModels = value;
    notifyListeners();
  }


  List<WQBFolderModel> get listWQBFolderModel => _listWQBFolderModel;

  set listWQBFolderModel(List<WQBFolderModel> value) {
    _listWQBFolderModel = value;
    notifyListeners();
  }

  List<FolderModel> get listFolderModels => _listFolderModels;

  set listFolderModels(List<FolderModel> value) {
    _listFolderModels = value;
    notifyListeners();
  }

  CalendarModel get calendarModel => _calendarModel ?? CalendarModel();

  set calendarModel(CalendarModel value) {
    _calendarModel = value;
    notifyListeners();
  }

  setCalendarModel(CalendarModel value) {
    _calendarModel = value;
    notifyListeners();
  }

  List<ResourceDeliveryInfoBean> get gamePagesResourceDeliveryInfoBeanList => _gamePagesResourceDeliveryInfoBeanList ?? [];
  set gamePagesResourceDeliveryInfoBeanList(List<ResourceDeliveryInfoBean> value) {
    _gamePagesResourceDeliveryInfoBeanList = value;
    notifyListeners();
  }

  List<ResourceDeliveryInfoBean> get gameBackgroundDeliveryInfoBeanList => _gameBackgroundDeliveryInfoBeanList ?? [];

  set gameBackgroundDeliveryInfoBeanList(List<ResourceDeliveryInfoBean> value) {
    _gameBackgroundDeliveryInfoBeanList = value;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IntProperty('curFolderSelected', curFolderSelected));
  }
}