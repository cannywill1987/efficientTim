import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoDetailClockLogHelper.dart';

void main() {
  group('FlomoDetailClockLogHelper', () {
    test('counts actual clock-in records in the selected month', () {
      final Map clockInMap = {
        '2026-05-10': [
          {'timestamp': 1}
        ],
        '2026-05-12': [
          {'timestamp': 2},
          {'timestamp': 3}
        ],
        '2026-06-01': [
          {'timestamp': 4}
        ],
      };

      expect(
        FlomoDetailClockLogHelper.countMonthClockLogs(
          clockInMap: clockInMap,
          monthDate: DateTime(2026, 5, 1),
        ),
        3,
      );
    });

    test('ignores invalid clock-in values instead of creating placeholder dots',
        () {
      final Map clockInMap = {
        '2026-05-10': null,
        'not-a-date': [
          {'timestamp': 1}
        ],
      };

      expect(
        FlomoDetailClockLogHelper.countMonthClockLogs(
          clockInMap: clockInMap,
          monthDate: DateTime(2026, 5, 1),
        ),
        0,
      );
    });
  });
}
