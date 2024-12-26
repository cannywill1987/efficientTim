class ReminderModel {
  final String? id; // 唯一标识符
  final String? title; // 标题
  final String? notes; // 备注
  final String? calendar; // 所属日历
  final DateTime? startDate; // 开始时间
  final DateTime? dueDate; // 截止时间
  final bool? isCompleted; // 是否完成
  final DateTime? completionDate; // 完成时间
  final int? priority; // 优先级
  final List<String>? tags; // 标签列表
  final List<AlarmModel>? alarms; // 提醒列表
  final RecurrenceModel? recurrence; // 重复规则

  ReminderModel({
    this.id,
    this.title,
    this.notes,
    this.calendar,
    this.startDate,
    this.dueDate,
    this.isCompleted,
    this.completionDate,
    this.priority,
    this.tags,
    this.alarms,
    this.recurrence,
  });

  /// frequency
  /// case daily = 0
  ///case weekly = 1
  ///case monthly = 2
  ///case yearly = 3
  /// 动态计算重复类型
  /// // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复 如果0 关闭 end_time不会作用 重复拥有更高优先级
  int get repetiveType {
    if (recurrence == null || recurrence!.frequency == null) {
      return 0;
    }
    if(recurrence!.daysOfTheWeek != null) {
      return 2;
    }
    if(recurrence!.frequency == 0) {
      return 1;
    }
    if(recurrence!.frequency == 1) {
      return 2;
    }
    if(recurrence!.frequency == 2) {
      return 3;
    }
    if(recurrence!.frequency == 3) {
      return 4;
    }
    return 0;
    // if (alarms == null) return 0; // 无重复
    // // 根据 alarms 的内容判断重复类型
    // for (var alarm in alarms!) {
    //   if (alarm.type == 'relative') {
    //     // 假设存在固定逻辑来判断重复类型
    //     if (alarm.offset != null) return 1; // 按天重复
    //   } else if (alarm.type == 'absolute') {
    //     // 绝对时间提醒可能是按月或按年
    //     return 4; // 按年重复
    //   }
    // }
    // return 0; // 默认无重复
  }

  /// 动态计算重复间隔
  int? get repetiveValue {
    if (recurrence == null || recurrence!.interval == null) {
      return null;
    }
  return recurrence!.interval;
  }

  DateTime? get endDate {
    if (recurrence == null || recurrence!.endDate == null) {
      return null;
    }
    return recurrence!.endDate;
  }


  /// 动态计算重复周信息 (从周日到周六) 根据recurrence.daysOfTheWeek
  List<bool> get repetiveWeekDay {
    // 默认值
    if (recurrence == null || recurrence!.daysOfTheWeek == null) {
      return List.generate(7, (index) => false);
    }
    List<bool> daysOfTheWeek = List.generate(7, (index) => false);
    for (var i = 0; i < recurrence!.daysOfTheWeek!.length; i++) {
      switch (recurrence!.daysOfTheWeek![i]) {
        case 1: // 周日
          daysOfTheWeek[6] = true;
          break;
        case 2: // 周一
          daysOfTheWeek[0] = true;
          break;
        case 3: // 周二
          daysOfTheWeek[1] = true;
          break;
        case 4: // 周三
          daysOfTheWeek[2] = true;
          break;
        case 5: // 周四
          daysOfTheWeek[3] = true;
          break;
        case 6: // 周五
          daysOfTheWeek[4] = true;
          break;
        case 7: // 周六
          daysOfTheWeek[5] = true;
          break;
      }
    }
    // 假设 daysOfTheWeek 为 1-7 表示周日到周六
    return daysOfTheWeek;
  }

  /// 将 JSON 转换为 ReminderModel
  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      title: json['title'],
      notes: json['notes'],
      calendar: json['calendar'],
      startDate: json['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startDate'])
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'])
          : null,
      isCompleted: json['isCompleted'],
      completionDate: json['completionDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completionDate'].toInt())
          : null,
      priority: json['priority'],
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : null,
      alarms: json['alarms'] != null
          ? (json['alarms'] as List).map((e) => AlarmModel.fromJson(e)).toList()
          : null,
      recurrence: json['recurrence'] != null
          ? RecurrenceModel.fromJson(json['recurrence'].length > 0 ? json['recurrence'][0] : {})
          : null,
    );
  }

  /// 将 ReminderModel 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'calendar': calendar,
      'startDate': startDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'completionDate': completionDate?.millisecondsSinceEpoch,
      'priority': priority,
      'tags': tags,
      'alarms': alarms?.map((e) => e.toJson()).toList(),
      'recurrence': recurrence?.toJson(),
    };
  }
}

/// Alarm 模型
class AlarmModel {
  final String? type; // 提醒类型 (absolute/relative/location)
  final DateTime? date; // 绝对时间提醒
  final int? offset; // 相对时间偏移 (毫秒)
  final AlarmLocationModel? location; // 位置信息

  AlarmModel({
    this.type,
    this.date,
    this.offset,
    this.location,
  });

  /// 从 JSON 创建 AlarmModel 实例
  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      type: json['type'],
      date: json['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['date'])
          : null,
      offset: json['offset'],
      location: json['location'] != null
          ? AlarmLocationModel.fromJson(json['location'])
          : null,
    );
  }

  /// 转换 AlarmModel 为 JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date?.millisecondsSinceEpoch,
      'offset': offset,
      'location': location?.toJson(),
    };
  }
}

/// AlarmLocation 模型
class AlarmLocationModel {
  final String? title; // 地点名称
  final double? latitude; // 纬度
  final double? longitude; // 经度
  final double? radius; // 半径

  AlarmLocationModel({this.title, this.latitude, this.longitude, this.radius});

  /// 将 JSON 转换为 AlarmLocationModel
  factory AlarmLocationModel.fromJson(Map<String, dynamic> json) {
    return AlarmLocationModel(
      title: json['title'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
    );
  }

  /// 将 AlarmLocationModel 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }
}

class RecurrenceModel {
  final int? frequency; // 重复频率 (1: daily, 2: weekly, 3: monthly, 4: yearly)
  final int? interval; // 重复间隔
  final List<int>? daysOfTheWeek; // 重复的星期几 (周日: 1, 周一: 2, ...)
  final DateTime? endDate; // 重复结束日期

  RecurrenceModel({
    this.frequency,
    this.interval,
    this.daysOfTheWeek,
    this.endDate,
  });

  /// 从 JSON 创建 RecurrenceModel 实例
  factory RecurrenceModel.fromJson(Map<String, dynamic> json) {
    return RecurrenceModel(
      frequency: json['frequency'],
      interval: json['interval'],
      daysOfTheWeek: json['daysOfTheWeek'] != null
          ? List<int>.from(json['daysOfTheWeek'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
    );
  }

  /// 转换 RecurrenceModel 为 JSON
  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency,
      'interval': interval,
      'daysOfTheWeek': daysOfTheWeek,
      'endDate': endDate?.toIso8601String(),
    };
  }
}