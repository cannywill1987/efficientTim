import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';

import '../../../../../r.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/StylesConfig.dart';
import '../../../util/TextUtil.dart';
import '../../../util/ThemeManager.dart';
import '../../../util/Utility.dart';
import 'FlomoMenuItem.dart';

/**
 * FlomoDetalPage的下面的目标详情页面
 */
class FlomoDetailObjectiveInfo extends StatelessWidget {
  FlomoMissionModel missionModel;
  FlomoDetailObjectiveInfo({Key? key, required this.missionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        FlomoMenuItem(
            title: getI18NKey().start_date,
            subTitle: "",
            onTapListener: (data) {
              // this.onClick('onClickSelectTomatoes', null);
            },
            rightPartContainer: Text(Utility.getDateTimeYMD(
                Utility.getDateTimeFromTimeStamp(missionModel
                    ?.start_time ??
                    0)), style: StylesConfig.textStyleMenuItemTextStyle,),
            icon: Utility.getSVGPicture(R.assetsImgIcStarttimeOrange,
                size: StylesConfig.iconSize, color: ThemeManager.getInstance().getDefautThemeColor())),
        FlomoMenuItem(
            title: getI18NKey().end_time,
            subTitle: "",
            onTapListener: (data) {
              // this.onClick('onClickSelectTomatoes', null);
            },
            rightPartContainer: Text(Utility.getDateTimeYMD(
                Utility.getDateTimeFromTimeStamp(missionModel
                    ?.end_time ??
                    0)), style: StylesConfig.textStyleMenuItemTextStyle,),
            icon: Utility.getSVGPicture(R.assetsImgIcEndtimeOrange,
                size: StylesConfig.iconSize, color: ThemeManager.getInstance().getDefautThemeColor())),
        FlomoMenuItem(
            title: getI18NKey().alert_time,
            subTitle: "",
            onTapListener: (data) {
              // this.onClick('onClickSelectTomatoes', null);
            },
            rightPartContainer: Wrap(children: [Text(Utility.getResultStringFromTimes(missionModel.alert_times), textAlign: TextAlign.right,style: StylesConfig.textStyleMenuItemTextStyle)]),
            icon: Utility.getSVGPicture(R.assetsImgIcAlarmOrange,
                size: StylesConfig.iconSize, color: ThemeManager.getInstance().getDefautThemeColor())),
        FlomoMenuItem(
            title: getI18NKey().frequency,
            subTitle: "",
            onTapListener: (data) {
              // this.onClick('onClickSelectTomatoes', null);
            },
            rightPartContainer: Text(CONSTANTS.getFlomoRepeativeString(missionModel?.repetiveType ?? 0)),
            icon: Utility.getSVGPicture(R.assetsImgIcRepeativeOrange,
                size: StylesConfig.iconSize, color: ThemeManager.getInstance().getDefautThemeColor())),
      ],)
    );
  }
}
