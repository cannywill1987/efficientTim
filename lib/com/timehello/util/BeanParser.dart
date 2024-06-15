import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/TimeRatioComponent.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/EventCollectionModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/ProgressFocusModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../beans/GameRankingBean.dart';
import '../beans/UserBean.dart';
import '../config/ENUMS.dart';
import '../models/CalendarModel.dart';
import '../models/SubmissionModel.dart';

class BeanParser {
  static List<TimeSegment> parseMissionModelListToTimeSegment(
      {required List<MissionModel> data,
      ProgressSortEnum progressSortEnum = ProgressSortEnum.completeNum, DateTime? startDateTime, DateTime? endDateTime}) {
    List<TimeSegment> list = [];
    List<FolderTimeModel> listFolderTimeModel = [];
    List<Map?> listFolderIds = CONSTANTS.sortMissionModelListToFolderIds(data);
    if (ProgressSortEnum.tomato == progressSortEnum) {
      CONSTANTS.sortByFolderTimeForTomatoes(listFolderIds, listFolderTimeModel, list);
      return list;
    } else if (ProgressSortEnum.completeNum == progressSortEnum) {
      CONSTANTS.sortByFolderTimeForCompleteNum(listFolderIds, listFolderTimeModel, list);
    } else if (ProgressSortEnum.focusDuration == progressSortEnum) {
      CONSTANTS.sortByFolderTime(listFolderIds, listFolderTimeModel, list);
    } else if (ProgressSortEnum.Lyubichs == progressSortEnum) {
      // 柳比歇斯
      CONSTANTS.sortByFolderTimeForLyubichs(listFolderIds, listFolderTimeModel, list, startDateTime, endDateTime);
    } else if(ProgressSortEnum.priority == progressSortEnum){
      CONSTANTS.sortByPriorityFolderTimeForCompleteNum(listFolderIds, listFolderTimeModel, list);
    }
    return list;
  }

  static List<MissionModel> parseMissionModelListFromGpt<T>(
      List<Map<String, dynamic>> data) {
    List<Map<String, dynamic>> datas =
        List<Map<String, dynamic>>.from(data?[0]?['datas']) ?? [];
    List<MissionModel> list = datas.map((d) {
      try {
        MissionModel missionModel = MissionModel();
        missionModel.title = d['title'];
        if (d['priorityStatus'] is String) {
          missionModel.priorityStatus = int.parse(d['priorityStatus']);
        } else {
          missionModel.priorityStatus = d['priorityStatus'];
        }
        DateTime dateTimeStart = d['startTime'] == null
            ? DateTime.now()
            : Utility.getUtcDateTimeToLocalFromString(d['startTime']);
        DateTime dateTimeEnd = d['endTime'] == null
            ? dateTimeStart.add(Duration(hours: 1))
            : Utility.getUtcDateTimeToLocalFromString(d['endTime']);
        // timeZoneOffset
        // missionModel.priorityStatus = d['priorityStatus'];
        missionModel.total_tomotoes = d['total_tomotoes'] ?? 1;
        missionModel.start_time = dateTimeStart.millisecondsSinceEpoch;
        missionModel.end_time = dateTimeEnd.millisecondsSinceEpoch;
        if ((missionModel.start_time ?? 0) > 24 * 60 * 60 * 100) {
          missionModel.time_mode = 1;
        }
        missionModel.total_tomotoes = d['total_tomotoes'];
        missionModel.tomato_duration = d['tomato_duration'] ?? 25 * 60 * 1000;

        return missionModel;
      } catch (e) {
        return MissionModel();
      }
    }).toList();
    return list;
  }

  static List<Map> parseSubmissionModelListToJsonMap<T>(
      List<SubmissionModel> data) {
    List<Map> listTmp = [];
    for (int i = 0; i < data.length; i++) {
      SubmissionModel submissionModel = data[i];
      //标题有内容才添加
      if (!TextUtil.isEmpty(submissionModel.title)) {
        listTmp.add(submissionModel.toJson());
      }
    }
    return listTmp;
  }

  static List<SubmissionModel> parseSubmissionModelList<T>(List<dynamic> data) {
    List<SubmissionModel> list = data.map((d) {
      SubmissionModel submissionModel = SubmissionModel.fromJson(d);
      submissionModel.key = ValueKey(
          submissionModel.id ?? Utility.getRandom(from: 0, max: 10000000));
      return submissionModel;
    }).toList();
    return list;
  }

  static List<UserBean> parseUserBeanList<T>(List<dynamic> data) {
    List<UserBean> list = data.map((d) {
      return UserBean.fromJson(d);
    }).toList();
    return list;
  }

  static List<GameRankingBean> parseGameRankingBeanList<T>(List<dynamic> data) {
    List<GameRankingBean> list = data.map((d) {
      return GameRankingBean.fromJson(d);
    }).toList();
    return list;
  }

  static List<EventCollectionModel> parseEventCollectionModel<T>(
      List<dynamic> data) {
    List<EventCollectionModel> list = data.map((d) {
      return EventCollectionModel.fromJson(d);
    }).toList();
    return list;
  }
}
