import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/MissionViewModeHelper.dart';

void main() {
  group('MissionViewModeHelper', () {
    test('maps table view type index to the last switcher button', () {
      final List<CheckButtonStateModel> buttons = <CheckButtonStateModel>[
        CheckButtonStateModel(code: 'list', isCheck: true),
        CheckButtonStateModel(code: 'grid', isCheck: false),
        CheckButtonStateModel(code: 'table', isCheck: false),
      ];

      final int switcherIndex =
          MissionViewModeHelper.switcherIndexFromViewTypeIndex(
        MissionDataViewTypeEnum.table.index,
      );
      MissionViewModeHelper.syncSwitcherSelection(buttons, switcherIndex);

      expect(switcherIndex, 2);
      expect(buttons.map((CheckButtonStateModel item) => item.isCheck),
          <bool>[false, false, true]);
    });

    test('maps legacy timeline view type to grid switcher button', () {
      expect(
        MissionViewModeHelper.switcherIndexFromViewTypeIndex(
          MissionDataViewTypeEnum.timeline.index,
        ),
        1,
      );
    });
  });
}
