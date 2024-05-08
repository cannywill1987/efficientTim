import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/BarModel.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';

import 'TextUtil.dart';
import 'Utility.dart';

class StatisticUtility {
  //key-title value-值
  static Map<String, BarModelList>? filterStatsModelToBarModel(
      DateTypeEnum dateTypeEnum, List<StatsModel> listParam, StatisticTypeEnum statisticTypeEnum, {DateTime? datetimeStart, DateTime? datetimeEnd}) {
    // double maxValue = getMaxVal(listParam);

    switch (dateTypeEnum) {
      case DateTypeEnum.day:
        Map res = getDayValue(listParam, statisticTypeEnum: statisticTypeEnum, nowDateTime: datetimeStart, );
        Map resPrev = getDayValue(listParam, statisticTypeEnum: statisticTypeEnum,
            nowDateTime: Utility.getDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch -
                    24 * 60 * 60 * 1000)); //用于和昨天比较得到百分比
        return {
          "BarModelListPrev": BarModelList(
              listBarModel: resPrev["mapListBarModel"],
              maxValue: resPrev["maxYValue"],
              listStatsModel: resPrev["listAllStatsModel"]),
          "BarModelList": BarModelList(
              listBarModel: res["mapListBarModel"],
              maxValue: res["maxYValue"],
              listStatsModel: res["listAllStatsModel"])
        };
        // return ;
        break;
      case DateTypeEnum.last7Days:
        Map res = getLast7DayValue(listParam, statisticTypeEnum: statisticTypeEnum);
        Map resPrev = getLast7DayValue(listParam, statisticTypeEnum: statisticTypeEnum,
            nowDateTime: Utility.getDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch -
                   7 * 24 * 60 * 60 * 1000)); //用于和昨天比较得到百分比
        return {
          "BarModelListPrev": BarModelList(
              listBarModel: resPrev["mapListBarModel"],
              maxValue: resPrev["maxYValue"],
              listStatsModel: resPrev["listAllStatsModel"]),
          "BarModelList": BarModelList(
              listBarModel: res["mapListBarModel"],
              maxValue: res["maxYValue"],
              listStatsModel: res["listAllStatsModel"])
        };
        break;
      case DateTypeEnum.lastMonth:
        Map res = getLastLatestMonthValue(listParam, statisticTypeEnum: statisticTypeEnum);
        Map resPrev = getLastLatestMonthValue(listParam, statisticTypeEnum: statisticTypeEnum,
            nowDateTime: Utility.getDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch -
                    30 * 24 * 60 * 60 * 1000)); //用于和昨天比较得到百分比
        return {
          "BarModelListPrev": BarModelList(
              listBarModel: resPrev["mapListBarModel"],
              maxValue: resPrev["maxYValue"],
              listStatsModel: resPrev["listAllStatsModel"]),
          "BarModelList": BarModelList(
              listBarModel: res["mapListBarModel"],
              maxValue: res["maxYValue"],
              listStatsModel: res["listAllStatsModel"])
        };
        break;
      case DateTypeEnum.custom:
        // datetimeEnd = datetimeEnd ?? DateTime.now().add(Duration(days: 30));
        // if(listParam.length > 0) {
        //   print("");
        // }
        Map res = getCustomizedValue(listParam, statisticTypeEnum: statisticTypeEnum, dateTime1: datetimeStart, dateTime2: datetimeEnd);
        // Map resPrev = getCustomizedValue(listParam, statisticTypeEnum: statisticTypeEnum,
        //     nowDateTime: Utility.getDateTimeFromTimeStamp(datetimeStart.millisecondsSinceEpoch)); //用于和昨天比较得到百分比
        return {
          // "BarModelListPrev": BarModelList(
          //     listBarModel: resPrev["mapListBarModel"],
          //     maxValue: resPrev["maxYValue"],
          //     listStatsModel: resPrev["listAllStatsModel"]),
          "BarModelList": BarModelList(
              listBarModel: res["mapListBarModel"],
              maxValue: res["maxYValue"],
              listStatsModel: res["listAllStatsModel"])
        };
        break;
      default:
    }
  }

  /**
   * 从listParam中获取最早时间
   */
  static DateTime getEarliestDateTime(List<StatsModel> listParam) {
    DateTime dateTime = DateTime.now().subtract(Duration(days: 7));
    for (StatsModel statsModel in listParam) {
      DateTime createTime = Utility.getUtcDateTimeFromString(statsModel.createdAt!);
      if (createTime.millisecondsSinceEpoch < dateTime.millisecondsSinceEpoch) {
        dateTime = createTime;
      }
    }
    return dateTime;
  }

  static Map getCustomizedValue(List<StatsModel> listParam, {DateTime? dateTime1, DateTime? dateTime2, StatisticTypeEnum statisticTypeEnum = StatisticTypeEnum.time}) {
    //todo 按理说应该是从 listParam 拿出最早的时间和最晚的时间
    if (dateTime1 == null) {
      dateTime1 = getEarliestDateTime(listParam).subtract(Duration(days: 3));
      // dateTime1 = DateTime.now().subtract(
      //     Duration(days: 365)); //null是点击搜索全部数据时 选近两年 10年SummaryPage更改年份时回卡
    }
    if (dateTime2 == null) dateTime2 = DateTime.now().add(Duration(days: 1));
    dateTime1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    // dateTime2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
    Map<String, List<BarModel>> res = Map<String, List<BarModel>>();
    double maxYValue = 0;
    List<StatsModel> barModelList;
    Map resTmp;
    List<StatsModel> listAllStatsModel = [];
    Function getListsModelByType = StatisticTypeEnum.number == statisticTypeEnum ? getListBarModel: getTimeListBarModel;
    int days = ((dateTime2.millisecondsSinceEpoch - dateTime1.millisecondsSinceEpoch) ~/ (1000 * 24 * 60 * 60)).ceil() + 1;
    DateTime dateTime2Tmp = DateTime(dateTime1.year, dateTime1.month, dateTime1.day, 23, 59, 59);
    for (int i = 0; i < days; i++) {
      barModelList = getListsModel(listParam,
          dateTime1?.millisecondsSinceEpoch ?? 0, dateTime2Tmp.millisecondsSinceEpoch);
      resTmp = getListsModelByType(barModelList); //计算每个bar的最大值和bar
      res[dateTime1?.millisecondsSinceEpoch.toString() ?? ""] = resTmp["listBarModel"];
      maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
      listAllStatsModel.addAll(barModelList);
      dateTime1 = dateTime1?.add(Duration(days: 1));
      dateTime2Tmp = dateTime2Tmp.add(Duration(days: 1));
    }
    return {
      "mapListBarModel": res,
      "maxYValue": maxYValue,
      "listAllStatsModel": listAllStatsModel
    };
  }

  static Map getLastLatestMonthValue(List<StatsModel> listParam, {DateTime? nowDateTime, StatisticTypeEnum statisticTypeEnum = StatisticTypeEnum.time}) {
    Map<String, List<BarModel>> res = Map<String, List<BarModel>>();
    if (nowDateTime == null) {
      nowDateTime = DateTime.now();
    }
    double maxYValue = 0;
    DateTime dateTime1, dateTime2;
    List<StatsModel> barModelList = [];
    Map resTmp;
    List<StatsModel> listAllStatsModel = [];
    Function getListsModelByType = StatisticTypeEnum.number == statisticTypeEnum ? getListBarModel: getTimeListBarModel;
    for (int i = 0; i < 29; i++) {
      if (i == 0) {
        dateTime1 = nowDateTime.subtract(Duration(
            days: 30 - i - 2,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));
        dateTime2 = nowDateTime.subtract(Duration(
            days: 30 - i - 3,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));
        barModelList = getListsModel(listParam,
            dateTime1.millisecondsSinceEpoch, dateTime2.millisecondsSinceEpoch);
        resTmp = getListsModelByType(barModelList); //计算每个bar的最大值和bar
        res[Utility.toFixed(dateTime1.month) +
            '/' +
            Utility.toFixed(dateTime1.day)] = resTmp["listBarModel"];
        maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
      } else if (i < 27) {
        dateTime1 = nowDateTime.subtract(Duration(
            days: 30 - i - 2,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));
        dateTime2 = nowDateTime.subtract(Duration(
            days: 30 - i - 3,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));
        barModelList = getListsModel(listParam,
            dateTime1.millisecondsSinceEpoch, dateTime2.millisecondsSinceEpoch);
        resTmp = getListsModelByType(barModelList);
        res["{" + i.toString() + "}"] = resTmp["listBarModel"];
        maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
      } else if (i == 27) {
        dateTime1 = nowDateTime.subtract(Duration(
            days: 1,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));
        dateTime2 = nowDateTime.subtract(Duration(
            days: 0,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));

        barModelList = getListsModel(listParam,
            dateTime1.millisecondsSinceEpoch, dateTime2.millisecondsSinceEpoch);

        resTmp = getListsModelByType(barModelList);
        res["{" + i.toString() + "}"] = resTmp["listBarModel"];
        maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
      } else if (i == 28) {
        //今天的数据
        dateTime1 = nowDateTime.subtract(Duration(
            days: 0,
            hours: nowDateTime.hour,
            minutes: nowDateTime.minute,
            seconds: nowDateTime.second,
            microseconds: nowDateTime.microsecond));
        dateTime2 = nowDateTime.subtract(Duration(days: 0));
        barModelList = getListsModel(listParam,
            dateTime1.millisecondsSinceEpoch, dateTime2.millisecondsSinceEpoch);

        resTmp = getListsModelByType(barModelList);
        res["今天"] = resTmp["listBarModel"];
        maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
      }
      listAllStatsModel.addAll(barModelList);
    }
    return {
      "mapListBarModel": res,
      "maxYValue": maxYValue,
      "listAllStatsModel": listAllStatsModel
    };
  }

  static Map getLast7DayValue(List<StatsModel> listParam,
      {DateTime? nowDateTime, StatisticTypeEnum statisticTypeEnum = StatisticTypeEnum.time}) {
    Map<String, List<BarModel>> res = Map<String, List<BarModel>>(); //存储数据
    if (nowDateTime == null) {
      nowDateTime = DateTime.now();
    }
    Function getListsModelByType = StatisticTypeEnum.number == statisticTypeEnum ? getListBarModel: getTimeListBarModel;
    double maxYValue = 0; //最大值
    DateTime dateTime1, dateTime2; //每个时间段时间差
    List<StatsModel> barModelList;
    List<StatsModel> listAllStatsModel = [];
    Map resTmp;

    dateTime1 = nowDateTime.subtract(Duration(
        days: 6,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(
        days: 5,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch); //获取时间短的 StatsModel
    resTmp = getListsModelByType(barModelList);
    res[Utility.toFixed(dateTime1.month) +
        '/' +
        Utility.toFixed(dateTime1.day)] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    dateTime1 = nowDateTime.subtract(Duration(
        days: 5,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(
        days: 4,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res[Utility.toFixed(dateTime1.month) +
        '/' +
        Utility.toFixed(dateTime1.day)] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    dateTime1 = nowDateTime.subtract(Duration(
        days: 4,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(
        days: 3,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res[Utility.toFixed(dateTime1.month) +
        '/' +
        Utility.toFixed(dateTime1.day)] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    //
    dateTime1 = nowDateTime.subtract(Duration(
        days: 3,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(
        days: 2,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res[Utility.toFixed(dateTime1.month) +
        '/' +
        Utility.toFixed(dateTime1.day)] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);
    //前天的数据
    dateTime1 = nowDateTime.subtract(Duration(
        days: 2,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(
        days: 1,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));

    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["前天"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);
    //昨天的数据
    dateTime1 = nowDateTime.subtract(Duration(
        days: 1,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(
        days: 0,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));

    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch);

    resTmp = getListsModelByType(barModelList);
    res["昨天"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    dateTime1 = nowDateTime.subtract(Duration(
        days: 0,
        hours: nowDateTime.hour,
        minutes: nowDateTime.minute,
        seconds: nowDateTime.second,
        microseconds: nowDateTime.microsecond));
    dateTime2 = nowDateTime.subtract(Duration(days: 0));
    barModelList = getListsModel(listParam, dateTime1.millisecondsSinceEpoch,
        dateTime2.millisecondsSinceEpoch);

    resTmp = getListsModelByType(barModelList);
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    res["今天"] = resTmp["listBarModel"];
    listAllStatsModel.addAll(barModelList);

    return {
      "mapListBarModel": res,
      "maxYValue": maxYValue,
      "listAllStatsModel": listAllStatsModel
    };
  }

  static Map getDayValue(List<StatsModel> listParam, {DateTime? nowDateTime, StatisticTypeEnum? statisticTypeEnum}) {
    Map<String, List<BarModel>> res = Map<String, List<BarModel>>();
    List<StatsModel> listAllStatsModel = [];
    if (nowDateTime == null) {
      nowDateTime = DateTime.now();
    }
    Function getListsModelByType = StatisticTypeEnum.number == statisticTypeEnum ? getListBarModel: getTimeListBarModel;

    // DateTime nowDateTime = DateTime.now();
    double maxYValue = 0;
    List<StatsModel> barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 0, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 0, 59, 59)
            .millisecondsSinceEpoch);
    Map resTmp = getListsModelByType(barModelList);
    res["00:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 1, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 1, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["01:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 2, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 2, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["02:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 3, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 3, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["03:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 4, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 4, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["04:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 5, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 5, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["05:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 6, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 6, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["06:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 7, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 7, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["07:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 8, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 8, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["08:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 9, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 9, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["09:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 10, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 10, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["10:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 11, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 11, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["11:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 12, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 12, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["12:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 13, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 13, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["13:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 14, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 14, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["14:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 15, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 15, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["15:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 16, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 16, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["16:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 17, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 17, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["17:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 18, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 18, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["18:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 19, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 19, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["19:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 20, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 20, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["20:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 21, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 21, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["21:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 22, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 22, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["22:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    barModelList = getListsModel(
        listParam,
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 23, 0, 0)
            .millisecondsSinceEpoch,
        DateTime(
                nowDateTime.year, nowDateTime.month, nowDateTime.day, 23, 59, 59)
            .millisecondsSinceEpoch);
    resTmp = getListsModelByType(barModelList);
    res["23:00"] = resTmp["listBarModel"];
    maxYValue = maxYValue > resTmp["yValue"] ? maxYValue : resTmp["yValue"];
    listAllStatsModel.addAll(barModelList);

    return {
      "mapListBarModel": res,
      "maxYValue": maxYValue,
      "listAllStatsModel": listAllStatsModel
    }; //Map<String, List<BarModel>>

    //     listParam.forEach((element) {
    //   res["00:00"] =
    // });
  }

  static List<StatsModel> getListsModel(
      List<StatsModel> listParam, int startTimestamp, int endTimestamp) {
    List<StatsModel> list = [];
    listParam.forEach((element) {
        // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        // print("startTimestamp:${Utility.getDateTimeFromTimeStamp(startTimestamp)}");
        // print("endTimestamp:${Utility.getDateTimeFromTimeStamp(endTimestamp)}");
        // print("currentTime:${element.updatedAt}");
        // print("result is:${Utility.getTimestampFromDateTime(element.updatedAt ?? "") >= startTimestamp &&
        //     Utility.getTimestampFromDateTime(element.updatedAt ?? "") < endTimestamp}");
        // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      if(element.title == "1111111111111111111111111111111111111111") {
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      }
      if (Utility.getTimestampFromDateTime(element.updatedAt ?? "") >= startTimestamp &&
          Utility.getTimestampFromDateTime(element.updatedAt ?? "") < endTimestamp) {
        list.add(element);
      }
    });
    return list;
  }

  //key-title value-值
  static Map getTimeListBarModel(List<StatsModel> listParam) {
    List<BarModel> listRes = [];
    int maxValBarModelList = getTimeMaxVal(listParam).toInt(); //每一列的最大值 用于算比例
    List<String> listKeys = filterGetKeys(listParam);
    listKeys.sort((a, b) => a.compareTo(b)); //排序

    Map<String, double> mapValue = Map(); //key-title value-值
    Map<String, int> mapColor = Map(); //key-title value-值
    listParam.forEach((element) {
      //算出每个key的时间
      if (mapValue.containsKey(element.title) != false) {
        //如果已经有了
        mapValue[element.title ?? ""] = (mapValue[element.title ?? ""] ?? 0)+ (element.value ?? 0);
      } else {
        mapValue[element.title ?? ""] = element.value ?? 0;
      }
      if (!TextUtil.isEmpty(element.color)) {
        mapColor[element.title ?? ""] = element.color ?? 0xffff8800;
      }
    });
    double curY = 0;
    for (String key in listKeys) {
      listRes.add(BarModel(
          title: key,
          color: mapColor[key],
          fromYValue: (curY).toDouble(),
          fromToYValue: (curY + (mapValue[key])! ~/ (1000 * 60)).toDouble()));
      curY = curY + (mapValue[key])! / (1000 * 60);
    }

    return {
      "listBarModel": listRes,
      "yValue": curY
    }; //yValue用于计算最大值 listBarModel每个bar的范围值
  }

  static double getTimeMaxVal(List<StatsModel> list) {
    double maxVal = 0;
    list.forEach((StatsModel element) {
      if (element.value! > maxVal) {
        maxVal = element.value?.toDouble()??0;
      }
    });
    return (maxVal ~/ (1000 * 60)).toDouble();
  }

  static filterGetKeys(List<StatsModel> list) {
    List<String> listTmp = [];
    list.forEach((StatsModel element) {
      if(element.title != null) {
        if (listTmp.indexOf(element.title!) == -1) {
          listTmp.add(element.title!);
        }
      }
    });
    return listTmp;
  }

  static getKeys(List<StatsModel> list) {
    List<String> listTmp = [];
    list.forEach((StatsModel element) {
      if(element.title != null) {
        listTmp.add(element.title!);
      }
    });
    return listTmp;
  }

  //key-title value-值
  static Map getListBarModel(List<StatsModel> listParam) {

    List<BarModel> listRes = [];
    if(listParam.length == 0) {
      return {
        "listBarModel": listRes,
        "yValue": 0.0
      };
    }
    int maxValBarModelList = getMaxVal(listParam).toInt(); //每一列的最大值 用于算比例
    List<String> listKeys = getKeys(listParam);
    listKeys.sort((a, b) => a.compareTo(b)); //排序

    Map<String, double> mapValue = Map(); //key-title value-值
    Map<String, int> mapColor = Map(); //key-title value-值
    listParam.forEach((element) {
      //算出每个key的时间
      mapValue[element?.title ?? ""] = 1;
      // if (mapValue.containsKey(element.title) != false) {
      //   //如果已经有了
      //   mapValue[element.title] += 1;
      // } else {
      //   mapValue[element.title] = 0;
      // }
      // if (!TextUtil.isEmpty(element.color)) {
      //   mapColor[element.title] = element.color ?? ColorsConfig.statisticColor;
      // }
    });
    double curY = 0;
    for (String key in listKeys) {
      listRes.add(BarModel(
          title: key,
          color: mapColor[key],
          fromYValue: (curY).toDouble(),
          fromToYValue: (curY + mapValue[key]!).toDouble()));
      curY = curY + (mapValue?[key] ?? 0);
    }

    return {
      "listBarModel": listRes,
      "yValue": curY
    }; //yValue用于计算最大值 listBarModel每个bar的范围值
  }

  static double getMaxVal(List<StatsModel> list) {
    double maxVal = 0;
    list.forEach((StatsModel element) {
      if (element.value! > maxVal) {
        maxVal = element.value?.toDouble() ?? 0;
      }
    });
    return (maxVal).toDouble();
  }
}
