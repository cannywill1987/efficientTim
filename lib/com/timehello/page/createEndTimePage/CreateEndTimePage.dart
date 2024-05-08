import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../beans/BaseBean.dart';
import '../../components/SelectDatePeriodDialogUtil.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ColorsConfig.dart';
import '../../config/Params.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../models/DateTimeModel.dart';
import '../../models/EndTimeMissionModel.dart';
import '../../models/MissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/TextUtil.dart';
import '../../util/Utility.dart';
import '../../util/date_util.dart';

class CreateEndTimePage extends BaseWidget {
  late EndTimeMissionModel missionModel;

  CreateEndTimePage({EndTimeMissionModel? missionModel}) {
    if (missionModel == null) {
      this.missionModel = new EndTimeMissionModel();
    } else {
      this.missionModel = missionModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _CreateEndTimePageState();
  }
}

class _CreateEndTimePageState extends BaseWidgetState<CreateEndTimePage> {
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();


  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(EndTimeMissionModel data) async {
    OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: getI18NKey().delete,
        message: getI18NKey().confirmToDelete,
        okLabel: getI18NKey().confirm,
        cancelLabel: getI18NKey().cancel,
        onWillPop: () async {
          //点击对话框外围黑色区域才会走这里
          return true;
        });
    if (result == OkCancelResult.ok) {
      EasyLoadingManager.getInstance().showLoading();
      await MongoApisManager.getInstance()
          .delete_EndTimeMissionModel(currentObjectId: data.objectId);
      EasyLoadingManager.getInstance().hideLoading();
      Utility.popupPagePCAndMobile(context);
    }
  }


  @override
  void initState() {
    super.initState();
    if (this.widget.missionModel.objectId != null) {
      controllerTitle.text = this.widget.missionModel.title ?? "";
      controllerDesc.text = this.widget.missionModel.message ?? "";
    }
  }

  Future requestNotification() async {
    BaseBean res =
        await CounterMethodChannelManager.getInstance().isNotificationEnabled();
    if (res.data == false) {
      OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: getI18NKey().no_notification_permission_title,
          message: getI18NKey().need_notification_permission_content,
          okLabel: getI18NKey().go_to_setting,
          cancelLabel: getI18NKey().cancel,
          onWillPop: () async {
            //点击对话框外围黑色区域才会走这里
            return true;
          });
      if (result == OkCancelResult.ok) {
        await CounterMethodChannelManager.getInstance().openSetting();
      }
    }
  }

  void onClick(type, data) async {
    switch (type) {
      //创建文件夹
      case 'onClickCreate':
        this.onClickCreate(data);
        break;
      case 'onTapDeleteListener':
        this.onClickDeleteItem(data);
        break;
    }
  }


  void onClickCreate(data) async {
    this.requestSaveData();
  }

  Future<void> requestSaveData() async {
    if (TextUtil.isEmpty(this.widget.missionModel.title) == true) {
      Utility.showToast(
          context: context, msg: getI18NKey().please_input_the_mission_title);
      return;
    }
    if (this.widget.missionModel.objectId == null) {
      //穿管新的
      this.widget.missionModel.time_format = "dd:HH:mm:ss";
      try {
        EasyLoadingManager.getInstance().showLoading();
        await MongoApisManager.getInstance()
            .insertEndTimeMissionModel(missionModel: this.widget.missionModel);
        EasyLoadingManager.getInstance().hideLoading();
        Utility.showToast(context: context, msg: getI18NKey().createSuccess);
        //todo 敢做这个没用了 因为用env了
        //mobile端返回上一页
        Utility.popupPagePCAndMobile(context);
      } catch (e) {
        Utility.showToast(context: context, msg: getI18NKey().network_error);
      }
    } else { //更新
      try {
        await MongoApisManager.getInstance()
            .update_EndTimeMissionModel(missionModel: this.widget.missionModel);
        Utility.showToast(context: context, msg: getI18NKey().update_success);
        //todo 敢做这个没用了 因为用env了
        //mobile端返回上一页
        Utility.popupPagePCAndMobile(context);
      } catch (e) {
        Utility.showToast(context: context, msg: getI18NKey().network_error);
      }
    }
  }

  @override
  baseBuild(BuildContext context) {
    String repetiveString =
        CONSTANTS.getRepetiveDateString1E(this.widget.missionModel);

    return ListView(
        children: [
          ListTile(
            title: TextField(
              controller: controllerTitle,
              onChanged: (val) {
                this.widget.missionModel?.title = val;
              },
              decoration: InputDecoration(
                hintText: getI18NKey().title,
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: controllerDesc,
              onChanged: (val) {
                this.widget.missionModel?.message = val;
              },
              decoration: InputDecoration(
                hintText: getI18NKey().remarks_optional,
              ),
            ),
          ),
          InkWell(
            child: ListTile(
              title: Text(getI18NKey().time),
              trailing: Text(
                  DateUtil.getTimeString(this.widget.missionModel.end_time ?? 0)),
              // trailing: Text(""),
              onTap: () async {
                // 弹出时间选择器
                DateTimeModel? model;
                TimeOfDay? timeOfDay;
                model = await Utility.showDateTimePickerDialog(context);
                if (model == null) {
                  return;
                }
                this.widget.missionModel.end_time = model.timestamp; //设置提醒时间
                updateUI();
              },
            ),
          ),
          ListTile(
            title: Text(getI18NKey().unit),
            trailing: Text(getI18NKey().day_hour_minute_second),
          ),
          InkWell(
            onTap: () async {
              DateTimeModel? model;
              TimeOfDay? timeOfDay;
              if (this.widget.missionModel.repetiveType == 0) {
                model = await Utility.showDateTimePickerDialog(context);
                if (model == null) {
                  return;
                }
                // this.alertTimeModel = model;
                this.widget.missionModel.alert_time = model.timestamp; //设置提醒时间
                // if (model.timestamp > 0) {
                //   Params.shouldRefreshPushModelList = true;
                // }
              } else {
                timeOfDay = await Utility.showTimePickerDialog(context);
                if (timeOfDay == null) {
                  return;
                }
                this.widget.missionModel.alert_time =
                    timeOfDay.hour * 60 * 60 * 1000 +
                        timeOfDay.minute * 60 * 1000;
                // if((this.widget.missionModel.alert_time??0) > 0) {
                //   Params.shouldRefreshPushModelList = true;
                // }
              }
              updateUI();
              this.requestNotification();
            },
            child: ListTile(
              title: Text(getI18NKey().reminder),
              trailing: Text(
                TextUtil.isEmpty(this.widget.missionModel.alert_time) == false
                    ? (this.widget.missionModel.repetiveType == 0
                        ? CONSTANTS.getAlertDateString(
                            Utility.getDateTimeModelFromTimeStamp(
                                this.widget.missionModel.alert_time ?? 0))
                        : Utility.formatHourAndMin2(
                            this.widget.missionModel.alert_time ?? 0))
                    : getI18NKey().none,
                style:
                    TextStyle(fontSize: 15, color: ColorsConfig.gray_a3_icon),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              SelectDatePeriodDialogUtil.show(context, okCallBack:
                  (valueMiddleSelected, valueRightSelected, listCheckModels) {
                this.widget.missionModel.repetiveValue =
                    valueMiddleSelected; //更新值
                if (this.widget.missionModel.repetiveType !=
                    valueRightSelected) {
                  this.widget.missionModel.alert_time = 0;
                }
                this.widget.missionModel.repetiveType =
                    valueRightSelected; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复
                if (this.widget.missionModel.repetiveWeekDay == null ||
                    (this.widget.missionModel.repetiveWeekDay?.length ?? 0) ==
                        0)
                  this.widget.missionModel.repetiveWeekDay = [
                    false,
                    false,
                    false,
                    false,
                    false,
                    false,
                    false,
                  ];
                this.widget.missionModel.repetiveWeekDay?[0] =
                    listCheckModels[0].isChecked;
                this.widget.missionModel.repetiveWeekDay?[1] =
                    listCheckModels[1].isChecked;
                this.widget.missionModel.repetiveWeekDay?[2] =
                    listCheckModels[2].isChecked;
                this.widget.missionModel.repetiveWeekDay?[3] =
                    listCheckModels[3].isChecked;
                this.widget.missionModel.repetiveWeekDay?[4] =
                    listCheckModels[4].isChecked;
                this.widget.missionModel.repetiveWeekDay?[5] =
                    listCheckModels[5].isChecked;
                this.widget.missionModel.repetiveWeekDay?[6] =
                    listCheckModels[6].isChecked;
                updateUI();
                // this.isNeedUpdateBmob = true;
              });
            },
            child: ListTile(
              title: Text(getI18NKey().whether_to_repeat),
              trailing: Text(repetiveString),
            ),
          ),
          TextUtil.isEmpty(this.widget.missionModel.background_url)
              ? getBgSettingItem(null)
              : CachedNetworkImage(
                  imageUrl: Utility.filterHttpUrl(this.widget.missionModel.background_url ?? '', prefix: "oss"),
                  imageBuilder: (context, imageProviderTmp) {
                    return getBgSettingItem(imageProviderTmp);
                  }),
          Center(
            child: TextButton(
              onPressed: () {
                // 保存操作
                this.onClick('onClickCreate', null);
              },
              child: Text(getI18NKey().save),
            ),
          ),
        ],
      );
  }

  Container getBgSettingItem(ImageProvider<Object>? imageProviderTmp) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          image: imageProviderTmp == null
              ? null
              : DecorationImage(
                  image: imageProviderTmp,
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
        ),
        // color: Colors.white,
        child: Container(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Color(0xa0ffffff), alpha: TextUtil.isEmpty(this.widget.missionModel.background_url) ? 255 : 140),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...getBarWidget(),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ));
  }

  List<Widget> getBarWidget() {
    return [
      InkWell(
        onTap: () {
          DialogManagement.getInstance().showSelectBgDialog(context,
              list: ResourceInfo
                      .missionItemBackgroundLocationInfoBean?.deliveryList ??
                  [], onTapListener: (String imgUrl) {
            // SharePreferenceUtil.getSyncInstance().setString(
            //     key: ShareprefrenceKeys.pcBackground,
            //     content: imgUrl);

            this.widget.missionModel.background_url = imgUrl;
            // requestMongoDbUpdateData();
            updateUI();
            DialogManagement.getInstance().hideDialog(context);
          });
        },
        child: Text(getI18NKey().change_bg),
      ),
      this.widget.missionModel != null ? IconButton(
          icon: Icon(
            Icons.delete,
            color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff909090)),
          ),
          onPressed: () {
            this.onClick("onTapDeleteListener", this.widget.missionModel);
          }) : SizedBox.shrink(),
      // SizedBox(
      //   width: 0,
      // ),
      // IconButton(
      //     icon: Icon(
      //       Icons.play_circle_outline,
      //       color: Color(0xfffd5553),
      //     ),
      //     onPressed: () {
      //       this.onClick("onClickMissionDetail", this.widget.missionModel);
      //     }),
    ];
  }
}
