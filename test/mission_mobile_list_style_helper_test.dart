import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MissionMobileListStyleHelper.dart';

void main() {
  test('mobile modern list metrics match rounded card layout', () {
    final MissionMobileListStyleMetrics metrics =
        MissionMobileListStyleHelper.mobileModernMetrics;

    expect(metrics.cardMinHeight, 96);
    expect(metrics.cardRadius, 14);
    expect(metrics.horizontalMargin, 26);
    expect(metrics.bottomSpacing, 12);
    expect(metrics.sectionHeaderHeight, 44);
  });

  test('objective progress data follows desktop objective card values', () {
    final MissionModel missionModel = MissionModel()
      ..objectiveTotalValue = 100
      ..objectiveValue = 76.9
      ..objectiveUnit = '个';

    final MissionMobileObjectiveProgressData progressData =
        MissionMobileListStyleHelper.buildObjectiveProgressData(missionModel);

    expect(progressData.percentText, '76.9%');
    expect(progressData.progress, closeTo(0.769, 0.001));
    expect(progressData.sliderMin, 0);
    expect(progressData.sliderMax, 100);
    expect(progressData.sliderValue, 76.9);
    expect(progressData.countText, '76 / 100 个');
  });
}
