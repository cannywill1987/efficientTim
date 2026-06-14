import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/page/missionPage/componnents/HeaderMobileCounterStatusHelper.dart';
import 'package:time_hello/r.dart';

void main() {
  test('mobile counter status data follows counter management status', () {
    final HeaderMobileCounterStatusData waitingData =
        HeaderMobileCounterStatusHelper.dataForStatus(
      CounterStatus.waitingToFocus,
    );
    final HeaderMobileCounterStatusData focusingData =
        HeaderMobileCounterStatusHelper.dataForStatus(CounterStatus.focusing);
    final HeaderMobileCounterStatusData noneData =
        HeaderMobileCounterStatusHelper.dataForStatus(CounterStatus.none);

    expect(waitingData.isVisible, isTrue);
    expect(waitingData.iconAsset, R.assetsImgIcFocusOrange);
    expect(focusingData.isVisible, isTrue);
    expect(focusingData.iconAsset, R.assetsImgIcFocusOrange);
    expect(noneData.isVisible, isFalse);
  });

  test('mobile folder status icon follows drawer svg assets', () {
    final FolderModel doItNowFolder = FolderModel()..iconType = 9;
    final FolderModel weekFolder = FolderModel()..iconType = 16;

    final HeaderMobileFolderIconData doItNowData =
        HeaderMobileCounterStatusHelper.folderIconDataForFolder(doItNowFolder);
    final HeaderMobileFolderIconData weekData =
        HeaderMobileCounterStatusHelper.folderIconDataForFolder(weekFolder);
    final HeaderMobileFolderIconData defaultData =
        HeaderMobileCounterStatusHelper.folderIconDataForFolder(null);

    expect(doItNowData.iconAsset, R.assetsImgIcInstantly);
    expect(weekData.iconAsset, R.assetsImgIc7Week);
    expect(defaultData.iconAsset, R.assetsImgIcToday);
  });
}
