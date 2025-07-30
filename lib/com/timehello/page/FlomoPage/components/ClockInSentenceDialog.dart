import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../beans/ResourceDeliveryInfoBean.dart';
import '../../../beans/ResourceLocationInfoBean.dart';
import '../../../config/Params.dart';
import '../FlomoCreatePage.dart';
import 'ClockInButtonListWidget.dart';
import 'ClockInSentenceGridView.dart';

class ClockInSentenceDialog extends StatefulWidget {
  Function onSubmitted;

  ClockInSentenceDialog({required this.onSubmitted});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClockInSentenceDialogState();
  }
}

class ClockInSentenceDialogState extends State<ClockInSentenceDialog> {
  List<ResourceDeliveryInfoBean>? list;

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(ResourceInfo.clockInSentenceResourceLocationInfoBeanList== null || ResourceInfo.clockInSentenceResourceLocationInfoBeanList?.length == 0) {
        FlomoMissionModel flomoMissionModel = FlomoMissionModel();
        flomoMissionModel.title = "";
        flomoMissionModel.start_time = Utility.getTimeStampToday();
        flomoMissionModel.icon = null;
        flomoMissionModel.color = 0xffff8800;
        // if (data.extendParamsMap?['time'] != null) {
        //   flomoMissionModel.alert_times = [
        //     Utility.getTimeStampFromHHMM(
        //         data.extendParamsMap?['time'])
        //   ];
        // }
        DialogManagement.getInstance().hideDialog(context);
        Utility.openPagePCAndMobile(Utility.getGlobalContext(),
            child: FlomoCreatePage(
              pageModeEnum: 0,
              flomoMissionModel: flomoMissionModel,
            ));
        return;
      }
    });
    ResourceLocationInfoBean? resourceLocationInfoBean =
        ResourceInfo.clockInSentenceResourceLocationInfoBeanList?[0];
    if (resourceLocationInfoBean != null) {
      list = resourceLocationInfoBean.deliveryList ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 45;
    // TODO: implement build
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: Container(
        height: 500,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // constraints: BoxConstraints(maxHeight: 500, maxWidth: 600),
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Container(
              height: 30,
              alignment: Alignment.center,
              child: Text(
                getI18NKey().recommended_Target,
                style: TextStyle(fontSize: 17),
              ),
            ),
            ClockInButtonListWidget(
              list: ResourceInfo.clockInSentenceResourceLocationInfoBeanList ??
                  [],
              onTapListener: (obj) {
                setState(() {
                  list = obj['data'].deliveryList;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 400,
              height: 300,
              child: ClockInSentenceGridView(
                list: list ?? [],
                onSubmit: (ResourceDeliveryInfoBean data) {
                  FlomoMissionModel flomoMissionModel = FlomoMissionModel();
                  flomoMissionModel.title = data.deliveryName;
                  flomoMissionModel.start_time = Utility.getTimeStampToday();
                  flomoMissionModel.icon = data.extendParamsMap?['codePoint'];
                  flomoMissionModel.color = 0xffff8800;
                  if (data.extendParamsMap?['time'] != null) {
                    flomoMissionModel.alert_times = [
                      Utility.getTimeStampFromHHMM(
                          data.extendParamsMap?['time'])
                    ];
                  }
                  DialogManagement.getInstance().hideDialog(context);
                  Utility.openPagePCAndMobile(Utility.getGlobalContext(),
                      child: FlomoCreatePage(
                        pageModeEnum: 0,
                        flomoMissionModel: flomoMissionModel,
                      ));
                },
              ),
            ),
            // 一个紫色按钮
            InkWell(
              onTap: () {
                DialogManagement.getInstance().hideDialog(context);
                Utility.openPagePCAndMobile(context,
                    child: FlomoCreatePage(
                      pageModeEnum: 0,
                      // flomoMissionModel: FlomoMissionModel(),
                    ));
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: ThemeManager.getInstance().getDefautThemeColor(),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 400,
                height: 50,
                child: Text(
                  getI18NKey().custom,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
