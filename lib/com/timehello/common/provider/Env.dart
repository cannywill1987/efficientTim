import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/SettingModel.dart';
import 'package:time_hello/com/timehello/models/UserInfoModel.dart';

import '../../beans/CreditCardModel.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class Env with ChangeNotifier, DiagnosticableTreeMixin {
  Map? _routerMainContainerData; //右边主内容 包含菜单栏
  Map? _wqbRouterMainContainerData; //右边主内容 包含菜单栏
  Map? _creditCardDetailData; //账单详情当前CreditCardModel
  Map? _wqbRouterMissionDetailData; //答题卡等内容 包含错题本等

  SettingModel? _settingModel; //设置model
  UserInfoModel? _userInfoModel;

  // FolderModel? _curFolderModelSelected; //当前选中的文件夹

  int _curMobileTab = 0; //当前移动端在哪个tab
  Map? _routerData; //右边那部分
  Map? _jumpFromFolderPageToMissionPage;
  Map? _routerRightSideData;
  bool _isMiddleMissionPageVisible = true; //中间的任务页面是否可见 点击ComposedRichEditorWidget扩大时用得上 需要设置成false

  FolderModel? _curFolderSelected;

  ChatGptFolderModel? _curChatGptFolderModel;

  int _curFolderStatus = 0; //0:正常 1:编辑 2:移动

  bool _isFolderPageVisible = true; //文件夹页面是否可见

  UserInfoModel? get userInfoModel => _userInfoModel ?? null;

  bool get isFolderPageVisible => _isFolderPageVisible;

  set isFolderPageVisible(bool value) {
    _isFolderPageVisible = value;
    notifyListeners();
  }

  set userInfoModel(UserInfoModel? value) {
    _userInfoModel = value;
    notifyListeners();
  }

  int get curFolderStatus => _curFolderStatus;

  set curFolderStatus(int value) {
    _curFolderStatus = value;
    notifyListeners();
  }

  SettingModel? get settingModel => _settingModel ?? null;

  set settingModel(SettingModel? value) {
    _settingModel = value;
    notifyListeners();
  }

  int get curMobileTab => _curMobileTab;

  set curMobileTab(int value) {
    _curMobileTab = value;
    notifyListeners();
  }

  Map? get jumpFromFolderPageToMissionPage => _jumpFromFolderPageToMissionPage ?? null;

  set jumpFromFolderPageToMissionPage(Map? value) {
    _jumpFromFolderPageToMissionPage = value;
    notifyListeners();
  }


  Map? get wqbRouterMissionDetailData => _wqbRouterMissionDetailData ?? null;

  set wqbRouterMissionDetailData(Map? value) {
    _wqbRouterMissionDetailData = value;
    notifyListeners();
  }

  Map? get creditCardDetailData => _creditCardDetailData ?? null;

  set creditCardDetailData(Map? value) {
    _creditCardDetailData = value;
    notifyListeners();
  }

  Map? get wqbRouterMainContainerData => _wqbRouterMainContainerData ?? null;

  set wqbRouterMainContainerData(Map? value) {
    _wqbRouterMainContainerData = value;
    notifyListeners();
  }


  Map? get routerMainContainerData => _routerMainContainerData ?? null;

  set routerMainContainerData(Map? value) {
    _routerMainContainerData = value;
    notifyListeners();
  }

  bool get isMiddleMissionPageVisible => _isMiddleMissionPageVisible;

  set isMiddleMissionPageVisible(bool value) {
    if(_isMiddleMissionPageVisible != value) {
      _isMiddleMissionPageVisible = value;
      notifyListeners();
    }
  }

  Map? get routerRightSideData => _routerRightSideData ?? null;

  set routerRightSideData(Map? value) {
    _routerRightSideData = value;
    notifyListeners();
  }

  //用于跳转的当前页面的数据
  Map get routerData => _routerData ?? {};

  // {'PageEnum': PageEnum.create, 'folderModel': folderModel}
  set routerData(Map value) {
    _routerData = value;
    notifyListeners();
  }

  FolderModel get curFolderSelected => _curFolderSelected ?? FolderModel();

  set curFolderSelected(FolderModel value) {
    _curFolderSelected = value;
    notifyListeners();
  }

  ChatGptFolderModel get curChatGptFolderModel => _curChatGptFolderModel ?? ChatGptFolderModel();

  set curChatGptFolderModel(ChatGptFolderModel? value) {
    _curChatGptFolderModel = value;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IntProperty('curFolderSelected', curFolderSelected));
  }
}