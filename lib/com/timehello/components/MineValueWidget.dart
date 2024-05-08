import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/UserBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../beans/BaseBean.dart';
import '../common/httpclient/HttpManager.dart';
import '../config/ColorsConfig.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import '../models/MissionModel.dart';
import '../util/LoginManager.dart';
import '../util/OverlayManagement.dart';
import '../util/Utility.dart';

/**
 * 任务价值显示
 */
class MineValueWidget extends StatefulWidget {
  // UserBean? userBean;
  // bool shouldUpdateDatabase;
  // Function onTapMissionValueListener;
  // bool shouldShowTitle;
  Color? color;

  MineValueWidget({
    Color? color,
    // this.shouldShowTitle = true,
    // this.shouldUpdateDatabase = false,
    // this.userBean,
  }) {
    if (color == null) {
      this.color = ColorsConfig.colorGold;
    } else {
      this.color = color;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MineValueWidgetState();
  }
}

class MineValueWidgetState extends State<MineValueWidget> {
  int? mission_value;

  MineValueWidgetState({this.mission_value});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<EventFn>().listen((EventFn event) {
      if (event.type == Params.ACTION_UPDATE_MONEY && mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return getMineValueWidget();
  }

  InkWell getMineValueWidget() {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().my_money_per_hour,
            style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: 12),
          ),
          Text(
            (LoginManager.getInstance().userBean.valuePerHour ?? 0).toString(),
            style: TextStyle(color: this.widget.color, fontSize: 12),
          ),
          Text(
            getI18NKey().dollar,
            style: TextStyle(color: this.widget.color, fontSize: 12),
          ),

          // SizedBox(
          //   width: 5,
          // ),
          // new Text(
          //     this.mission_value == null
          //         ? getI18NKey().none
          //         : (this.mission_value!.toString() + getI18NKey().dollar),
          //     style: TextStyle(color: ColorsConfig.colorGold, fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: Colors.blue,
            size: 18,
          )
        ],
      ),
      onTap: () async {
        // OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
        //     context,
        //     title: getI18NKey().money_per_hour, okCallBack: (data) {
        //   this.setState(() {
        //     this.widget.userBean?.valuePerHour = data;
        //     this.mission_value = data;
        //   });

        OverlayManagement.getInstance().openSelectMoneyPerHourOfMeOverlay(
            context,
            title: getI18NKey().money_per_hour, cancelCallBack: () {
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
        }, okCallBack: (valuePerHour) async {
          OverlayManagement.getInstance().dismissSelectValueMoneyOverlay();
          BaseBean response = await HttpManager.getInstance().doPostRequest(
              Apis.updateValuePerHour,
              params: {"valuePerHour": valuePerHour},
              context: context,
              shouldShowErrorToast: false);
          if (response.success == true) {
            LoginManager.getInstance()
                .setUserBean(UserBean.fromJson(response.data));
            eventBus.fire(EventFn(Params.ACTION_UPDATE_MONEY, {}));
          }
        });

        //   OverlayManagement.getInstance().removeSelectDialogOverlay();
        //   this.widget.onTapMissionValueListener?.call(data: this.mission_value);
        //   if (this.widget.shouldUpdateDatabase == true &&
        //       this.widget.userBean != null) {
        //     MongoApisManager.getInstance()
        //         .update_MissionModel(missionModel: this.widget.userBean!);
        //   }
        // });

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
