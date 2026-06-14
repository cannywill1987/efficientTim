import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoDetailSettingHelper.dart';

void main() {
  group('FlomoDetailSettingHelper', () {
    test('applies a selected reminder time as the only active alert time', () {
      final FlomoMissionModel model = FlomoMissionModel()
        ..alert_times = [8 * 60 * 60 * 1000];

      FlomoDetailSettingHelper.applyReminderTime(
        missionModel: model,
        reminderMilliseconds: 7 * 60 * 60 * 1000,
      );

      expect(model.alert_times, [7 * 60 * 60 * 1000]);
    });

    test('applies repeat mode and daily clock count to the mission model', () {
      final FlomoMissionModel model = FlomoMissionModel()
        ..repetiveType = 1
        ..daily_num_times = 1;

      FlomoDetailSettingHelper.applyRepeatType(
        missionModel: model,
        repetiveType: 2,
      );
      FlomoDetailSettingHelper.applyDailyClockCount(
        missionModel: model,
        dailyCount: 3,
      );

      expect(model.repetiveType, 2);
      expect(model.daily_num_times, 3);
    });

    test('builds every whole-hour reminder option from midnight to 23:00', () {
      final List<int> options =
          FlomoDetailSettingHelper.buildReminderHourOptions();

      expect(options.length, 24);
      expect(options.first, 0);
      expect(options.last, 23 * 60 * 60 * 1000);
      expect(options[7], 7 * 60 * 60 * 1000);
    });

    test('converts custom hour and minute to reminder milliseconds', () {
      final int reminderMilliseconds =
          FlomoDetailSettingHelper.buildReminderMilliseconds(
        hour: 23,
        minute: 45,
      );

      expect(
        reminderMilliseconds,
        23 * 60 * 60 * 1000 + 45 * 60 * 1000,
      );
    });
  });
}
