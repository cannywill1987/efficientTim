import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';

void main() {
  group('StatsModel.fromJson', () {
    test('兼容 value 为 double 时的 duration 计算', () {
      final StatsModel model = StatsModel.fromJson({
        'title': 'focus',
        'type': 0,
        'value': 500.5,
        'begin_time': 1000,
        'finish_time': 2000,
      });

      expect(model.value, 500.5);
      expect(model.duration, 500);
    });

    test('兼容数字字符串和空时间字段', () {
      final StatsModel model = StatsModel.fromJson({
        'type': '1',
        'focus_duration': '1200.8',
        'value': '1500.6',
        'begin_time': null,
        'finish_time': null,
      });

      expect(model.type, 1);
      expect(model.focus_duration, 1200);
      expect(model.value, 1500.6);
      expect(model.duration, 1500);
    });
  });
}
