//此处与类名一致，由指令自动生成代码
import 'package:json_annotation/json_annotation.dart';

import 'FlomoMissionModel.dart';
import 'MissionModel.dart';
import 'WQBMissionModel.dart';

// part 'CalendarModel.g.dart';
//
// @JsonSerializable()
class CalendarModel {
  List<YearModel>? yearModelList= [];
  List<MonthModel> monthModelList= [];
  List<WeekModel> weekModelList= [];
  List<DayModel> dayModelList= [];
  // int curYear;
  // int curMonth;
  // int curDay;
  DateTime? curDateTime;
  DayModel? curTodayDayModel;
  int? curDaysIndex = -1; //当前天数 从calendar第一天算 第几个Index days,目前没用
  int? indexDaysOfMonth = -1; //当月的天数 用于calendar中间的sliverList
  int indexMonth = -1; //用于calendar底部的month
  CalendarModel({yearModelList, dayModelList, monthModelList}) {
    this.yearModelList = yearModelList ?? [];
    this.dayModelList = dayModelList ?? [];
    this.monthModelList = monthModelList?? [];
  }

  //反序列化
//   factory CalendarModel.fromJson(Map<String, dynamic> json) =>
//       _$CalendarModelFromJson(json);
//
// //序列化
//   Map<String, dynamic> toJson() => _$CalendarModelToJson(this);
}

// @JsonSerializable()
class YearModel {
  List<MonthModel>? monthModelList = [];
  List<DayModel>? dayModelList = [];
  int? year;
  bool? isCurrent = false; //是否是今年
  YearModel({monthModelList, this.isCurrent, this.year, this.dayModelList}) {
    this.monthModelList = monthModelList ?? [];
    this.dayModelList = dayModelList ?? [];
  }

  //反序列化
//   factory YearModel.fromJson(Map<String, dynamic> json) =>
//       _$YearModelFromJson(json);
//
// //序列化
//   Map<String, dynamic> toJson() => _$YearModelToJson(this);
}

// @JsonSerializable()
class MonthModel {
  DateTime? dateTime;
  List<DayModel> dayModelList = [];
  int? month;
  String? monthName; // Jan Oct //属于几月  用于展示
  String yearName; // 属于哪一年 用于展示
  bool? isCurrent = false; //是否是这个月
  MonthModel({dayModelList, this.dateTime, this.isCurrent, this.month, this.monthName, this.yearName = ''}) {
    this.dayModelList = dayModelList ?? [];
  }

//反序列化
//   factory MonthModel.fromJson(Map<String, dynamic> json) =>
//       _$MonthModelFromJson(json);
//
// //序列化
//   Map<String, dynamic> toJson() => _$MonthModelToJson(this);
}

// @JsonSerializable()
class WeekModel {
  List<DayModel> dayModelList = [];
  // int? month;
  // String? monthName; // Jan Oct //属于几月  用于展示
  // String yearName; // 属于哪一年 用于展示
  bool isCurrent = false; //是否是这一周
  MonthModel({dayModelList, required bool isCurrent}) {
    this.dayModelList = dayModelList ?? [];
    this.isCurrent = isCurrent;
  }

// //反序列化
//   factory WeekModel.fromJson(Map<String, dynamic> json) =>
//       _$WeekModelFromJson(json);
//
// //序列化
//   Map<String, dynamic> toJson() => _$MonthModelToJson(this);
}

// @JsonSerializable()
class DayModel {
  DateTime? dateTime;
  String? lunarDay; //农历
  int? year;
  int? weekday; //1 2 3 4 星期几  用于展示
  String? weekdayName; //Thu Mon, 星期几  用于展示
  String? month; // Jan Oct //属于几月
  List<WQBMissionModel> wqbmissionModelList = [];
  List<MissionModel> missionModelList = [];
  List<FlomoMissionModel> flomoMissionModelList = [];
  int? day;
  bool isCurrent = false; //是否是这个天
  bool isCheck = false; //是否被选中
  int? indexMonth;
  bool? hasAlertOfMissionModel; //是否alert_time有预警
  DayModel({this.lunarDay, this.day, this.hasAlertOfMissionModel = false, this.weekdayName, this.year, this.dateTime, this.weekday, missionModelList, this.isCurrent = false, this.month, this.indexMonth}) {
    this.missionModelList = missionModelList ?? [];
  }

  //复写写一个compare 用于indexof 的daymodel数组查找
  bool operator ==(Object other) {
    DayModel otherDayModel = other as DayModel;
    // if (other is DayModel) {
    //   return false;
    // }
    bool res = this.dateTime?.day == otherDayModel.dateTime?.day && this.dateTime?.month == otherDayModel.dateTime?.month &&
        this.dateTime?.year == other.dateTime?.year;
    if(res){
      print('res');
    }
    return res;
  }


   DayModel deepClone(missionModelList) {
    return DayModel(
      lunarDay: this.lunarDay,
      dateTime: this.dateTime,
      year: this.year,
      weekday: this.weekday,
      weekdayName: this.weekdayName,
      month: this.month,
      missionModelList: missionModelList,
      day: this.day,
      isCurrent: this.isCurrent,
      indexMonth: this.indexMonth,
      hasAlertOfMissionModel: this.hasAlertOfMissionModel,
    );
  }

//反序列化
//   factory DayModel.fromJson(Map<String, dynamic> json) =>
//       _$DayModelFromJson(json);
//
// //序列化
//   Map<String, dynamic> toJson() => _$DayModelToJson(this);
}
