import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';

import '../beans/BaseBean.dart';
import '../beans/UserBean.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/ColorsConfig.dart';
import '../config/Params.dart';
import '../models/MissionModel.dart';
import '../util/LoginManager.dart';
import '../util/OverlayManagement.dart';
import '../util/Utility.dart';

/**
 * 任务价值显示
 */
class MissionValueWidget extends StatefulWidget {
  MissionModel? missionModel;
  bool shouldUpdateDatabase;
  Function onTapMissionValueListener;
  bool shouldShowTitle;

  MissionValueWidget(
      {Key? key,
      this.shouldShowTitle = true,
      this.shouldUpdateDatabase = false,
      this.missionModel,
      required this.onTapMissionValueListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionValueWidgetState(
        mission_value: this.missionModel?.mission_value);
  }
}

class MissionValueWidgetState extends State<MissionValueWidget> {
  int? mission_value;

  MissionValueWidgetState({this.mission_value});

  @override
  Widget build(BuildContext context) {
    return getMissionValueWidget();
  }


  @override
  void didUpdateWidget(MissionValueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // this.setState(() {
      this.mission_value = this.widget.missionModel?.mission_value;
    // });
  }

  InkWell getMissionValueWidget() {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (this.widget.shouldShowTitle == true)
            Text(
              getI18NKey().mission_value,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          SizedBox(
            width: 5,
          ),
          new Text(
              this.mission_value == null
                  ? getI18NKey().none
                  : (this.mission_value!.toString() + getI18NKey().dollar + "(" + getI18NKey().value_per_hour(Utility.getMissionValuePerHourByMissionModel(missionModel: this.widget.missionModel!)) +")" + getI18NKey().dollar),
              style: TextStyle(color: ColorsConfig.colorGold, fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: ColorsConfig.colorGold,
          )
        ],
      ),
      onTap: () async {
        if(LoginManager.getInstance().userBean.valuePerHour == null || LoginManager.getInstance().userBean.valuePerHour == 0){
          OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
              context,
              title: getI18NKey().mission_value,
              okCallBack: (valuePerHour) async {
                OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
                BaseBean response = await HttpManager.getInstance().doPostRequest(
                    Apis.updateValuePerHour,
                    params: {"valuePerHour": valuePerHour},
                    context: context,
                    shouldShowErrorToast: false);
                if (response.success == true) {
                  LoginManager.getInstance()
                      .setUserBean(UserBean.fromJson(response.data));
                }
              });
          return;
        }

        OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
            context,
            title: getI18NKey().mission_value, cancelCallBack:() {
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
        },okCallBack: (data) {
          this.setState(() {
            this.widget.missionModel?.mission_value = data;
            this.mission_value = data;
          });
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
          this.widget.onTapMissionValueListener?.call(data: this.mission_value);
          if (this.widget.shouldUpdateDatabase == true &&
              this.widget.missionModel != null) {
            MongoApisManager.getInstance()
                .update_MissionModel(missionModel: this.widget.missionModel!);
          }
        });

        // DateTimeModel? model = await Utility.showDatePickerDialog(
        //     context, CONSTANTS.getDeadLineTme(this.widget.dateStatus) ?? 0);
        // this.setState(() {
        //   this.end_time = model?.datetime?.millisecondsSinceEpoch; //计划到期日
        // });
        // if (this.widget.onTapFinishListener != null) {
        //   this.widget.onTapEndTimeListener!(data: this.end_time);
        // }
      },
    );
  }
}
