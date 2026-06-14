class FocusRankingModel {
  String? id;
  String? uid;
  String? username;
  String? avatar;
  String? missionId;
  String? missionTitle;
  String? dayKey;
  bool active = false;
  int focusStartedAt = 0;
  int lastHeartbeatAt = 0;
  int currentSessionFocusMillis = 0;
  int completedFocusMillis = 0;
  int todayFocusMillis = 0;
  int focusCount = 0;

  FocusRankingModel();

  factory FocusRankingModel.fromJson(Map<String, dynamic> json) {
    return FocusRankingModel()
      ..id = json['_id']?.toString()
      ..uid = json['uid']?.toString()
      ..username = json['username']?.toString()
      ..avatar = json['avatar']?.toString()
      ..missionId = json['missionId']?.toString()
      ..missionTitle = json['missionTitle']?.toString()
      ..dayKey = json['dayKey']?.toString()
      ..active = json['active'] == true
      ..focusStartedAt = _toInt(json['focusStartedAt'])
      ..lastHeartbeatAt = _toInt(json['lastHeartbeatAt'])
      ..currentSessionFocusMillis = _toInt(json['currentSessionFocusMillis'])
      ..completedFocusMillis = _toInt(json['completedFocusMillis'])
      ..todayFocusMillis = _toInt(json['todayFocusMillis'])
      ..focusCount = _toInt(json['focusCount']);
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class FocusRankingListModel {
  String dayKey = '';
  List<FocusRankingModel> activeRanking = [];
  List<FocusRankingModel> todayRanking = [];
  List<FocusRankingModel> todayLessRanking = [];

  FocusRankingListModel();

  factory FocusRankingListModel.fromJson(Map<String, dynamic> json) {
    return FocusRankingListModel()
      ..dayKey = json['dayKey']?.toString() ?? ''
      ..activeRanking = _parseList(json['activeRanking'])
      ..todayRanking = _parseList(json['todayRanking'])
      ..todayLessRanking = _parseList(json['todayLessRanking']);
  }

  static List<FocusRankingModel> _parseList(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map((item) =>
            FocusRankingModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
