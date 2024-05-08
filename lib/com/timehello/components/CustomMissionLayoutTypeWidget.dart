import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class CustomMissionLayoutTypeWidget extends StatelessWidget {
  double size = 20;
  FolderModel folderModel;

  CustomMissionLayoutTypeWidget({required this.folderModel, this.size = 20});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPopupWidget(
        onSelected: (res) {
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
          MongoApisManager.getInstance()?.update_FolderModelWithFM(folderModel: folderModel);
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
