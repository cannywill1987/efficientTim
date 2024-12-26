import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../models/EventFn.dart';

class CustomMissionLayoutTypeWidget extends StatelessWidget {
  double size = 20;
  FolderModel folderModel;

  CustomMissionLayoutTypeWidget({required this.folderModel, this.size = 20});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPopupWidget(
        onSelected: (res) async {
          switch(res.code){
            case 'listview':
              folderModel.layoutType = 0;
              break;
            case 'group':
              folderModel.layoutType = 1;
              break;
            case 'timeline':
              folderModel.layoutType = 2;
              break;
          }
          if(this.folderModel.iconType == 14) { //苹果安卓日历
            SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.layoutIconType14, value: folderModel.layoutType ?? 0);
          } else if (this.folderModel.iconType == 15) { //苹果提醒
            SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.layoutIconType15, value: folderModel.layoutType ?? 0);
          }else {
            await MongoApisManager.getInstance()?.update_FolderModelWithFM(
                folderModel: folderModel);
          }
          eventBus.fire(EventFn(Params.ACTION_UPDATE_MISSION_CONTAINER, {"data":this.folderModel, "layoutType": this.folderModel.iconType}));
          // eventBus.fire(Params.ACTION_UPDATE_MISSION_CONTAINER);
          print("");
        },
        list: CONSTANTS.getViewsButtonList(),
        child: getLayoutTypeWidget());
  }

  ////布局类型 0 列表 1 group分组 2 时间线
  Widget getLayoutTypeWidget() {
    switch (this.folderModel.layoutType) {
      case 1:
        return Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size);
      case 2:
        return Utility.getSVGPicture(R.assetsImgIcViewTimeline, size: size);
      default:
        return Utility.getSVGPicture(R.assetsImgIcViewListview, size: size);
    }
  }
}
