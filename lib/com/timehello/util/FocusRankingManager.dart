import 'dart:async';

import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/FocusRankingModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

class FocusRankingManager {
  static FocusRankingManager? _instance;
  Timer? _heartbeatTimer;
  MissionModel? _missionModel;
  int Function()? _timeUsedProvider;
  String _focusSessionId = '';

  static FocusRankingManager getInstance() {
    _instance ??= FocusRankingManager();
    return _instance!;
  }

  void start({
    required MissionModel? missionModel,
    required int Function() timeUsedProvider,
  }) {
    if (isShareOpen() != true) {
      stop();
      return;
    }
    if (LoginManager.isLogin() != true || missionModel?.objectId == null) {
      return;
    }
    final bool shouldCreateSession = _focusSessionId.isEmpty ||
        _missionModel?.objectId != missionModel?.objectId;
    _missionModel = missionModel;
    _timeUsedProvider = timeUsedProvider;
    if (shouldCreateSession) {
      _focusSessionId =
          '${LoginManager.getInstance().getUserBean().uid}_${DateTime.now().millisecondsSinceEpoch}';
    }
    heartbeat();
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      heartbeat();
    });
  }

  Future<void> heartbeat() async {
    if (isShareOpen() != true) return;
    if (_missionModel == null || _timeUsedProvider == null) return;
    await _post(Apis.focusRankingHeartbeat);
  }

  bool isShareOpen() {
    return SharePreferenceUtil.getSyncInstance().getBool(
      key: ShareprefrenceKeys.isMissionDetailFocusRankingShareOpen,
      defaultVal: true,
    );
  }

  Future<void> stop() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    if (_missionModel == null || _timeUsedProvider == null) return;
    await _post(Apis.focusRankingStop);
    _missionModel = null;
    _timeUsedProvider = null;
    _focusSessionId = '';
  }

  Future<void> _post(String api) async {
    if (LoginManager.isLogin() != true) return;
    final userBean = LoginManager.getInstance().getUserBean();
    final missionModel = _missionModel;
    if (missionModel == null || TextUtil.isEmpty(userBean.uid)) return;
    await HttpManager.getInstance().doPostRequest(
      api,
      params: {
        'missionId': missionModel.objectId ?? '',
        'missionTitle': missionModel.title ?? '',
        'focusSessionId': _focusSessionId,
        'focusDurationMillis': _timeUsedProvider?.call() ?? 0,
        'username': userBean.username,
        'avatar': userBean.avatar ?? '',
      },
      shouldShowErrorToast: false,
    );
  }

  Future<FocusRankingListModel?> getList({int pageSize = 20}) async {
    BaseBean response = await HttpManager.getInstance().doPostRequest(
      Apis.focusRankingGetList,
      params: {'pageSize': pageSize},
      shouldShowErrorToast: false,
    );
    if (response.success == true && response.data is Map) {
      return FocusRankingListModel.fromJson(
          Map<String, dynamic>.from(response.data));
    }
    return null;
  }
}
