import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/page/folderspage/components/FoldersMobileDrawerStyleHelper.dart';

void main() {
  test('mobile drawer metrics match modern rounded drawer layout', () {
    final FoldersMobileDrawerStyleMetrics metrics =
        FoldersMobileDrawerStyleHelper.modernMetrics;

    expect(metrics.widthFactor, 0.79);
    expect(metrics.cornerRadius, 28);
    expect(metrics.headerHeight, 118);
    expect(metrics.menuItemMinHeight, 54);
    expect(metrics.upgradeCardHeight, 84);
  });
}
