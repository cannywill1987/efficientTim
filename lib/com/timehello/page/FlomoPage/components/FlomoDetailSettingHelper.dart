import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';

/**
 * 文件类型：工具函数
 * 文件作用：承接习惯打卡详情页右侧设置弹窗的模型字段更新。
 * 主要职责：把通知时间、重复频率、每日打卡次数的 UI 选择统一写回 FlomoMissionModel，调用方再交给 MongoApisManager 保存。
 */
class FlomoDetailSettingHelper {
  static const int customReminderOptionValue = -1;

  /**
   * 功能：生成通知时间弹窗里的整点选项。
   * 说明：详情页要求覆盖 0 点到 23 点，返回值沿用模型里的毫秒偏移格式，方便直接写入 alert_times。
   */
  static List<int> buildReminderHourOptions() {
    return List<int>.generate(
      24,
      (int hour) => buildReminderMilliseconds(hour: hour, minute: 0),
    );
  }

  /**
   * 功能：把用户在自定义时间弹窗里选择的时分转换成模型存储值。
   * 说明：FlomoMissionModel.alert_times 存的是当天内的毫秒偏移，这里集中转换避免页面散落魔法数字。
   */
  static int buildReminderMilliseconds({
    required int hour,
    required int minute,
  }) {
    return hour * 60 * 60 * 1000 + minute * 60 * 1000;
  }

  /**
   * 功能：把弹窗里选中的通知时间写为唯一提醒时间。
   * 说明：右侧详情页只展示一个通知时间，选择新时间时覆盖旧数组，避免 UI 显示和实际提醒不一致。
   */
  static void applyReminderTime({
    required FlomoMissionModel missionModel,
    required int reminderMilliseconds,
  }) {
    missionModel.alert_times = [reminderMilliseconds];
  }

  /**
   * 功能：更新习惯任务重复频率。
   * 入参：repetiveType 沿用现有 FlomoCreatePage 的 1/2/3 枚举约定。
   */
  static void applyRepeatType({
    required FlomoMissionModel missionModel,
    required int repetiveType,
  }) {
    missionModel.repetiveType = repetiveType;
  }

  /**
   * 功能：更新每日需要打卡的次数。
   * 说明：至少保留 1 次，避免后续完成率计算出现除零或“无需打卡”的异常状态。
   */
  static void applyDailyClockCount({
    required FlomoMissionModel missionModel,
    required int dailyCount,
  }) {
    missionModel.daily_num_times = dailyCount < 1 ? 1 : dailyCount;
  }
}
