import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoDetailResponsiveLayout.dart';

void main() {
  group('FlomoDetailResponsiveLayout', () {
    test('uses dashboard layout only when the detail area is wide enough', () {
      expect(
          FlomoDetailResponsiveLayout.shouldUseDashboardLayout(1100), isTrue);
      expect(
          FlomoDetailResponsiveLayout.shouldUseDashboardLayout(899), isFalse);
    });

    test('keeps the right panel readable without taking over the calendar area',
        () {
      expect(FlomoDetailResponsiveLayout.sidePanelWidth(1400), 340);
      expect(FlomoDetailResponsiveLayout.sidePanelWidth(980), 300);
      expect(FlomoDetailResponsiveLayout.sidePanelWidth(760), 0);
    });

    test('keeps calendar day cells compact on wide screens', () {
      expect(
        FlomoDetailResponsiveLayout.calendarDayChildAspectRatio(1300),
        closeTo(1300 / 7 / 58, 0.001),
      );
      expect(
        FlomoDetailResponsiveLayout.calendarDayChildAspectRatio(350),
        closeTo(350 / 7 / 58, 0.001),
      );
    });
  });
}
