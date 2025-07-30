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
import '../../models/StartTimeMissionModel.dart';
import '../../models/MissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/TextUtil.dart';
import '../../util/Utility.dart';
import '../../util/date_util.dart';

class CreateStartTimePage extends BaseWidget {
  late StartTimeMissionModel missionModel;

  CreateStartTimePage({StartTimeMissionModel? missionModel}) {
    if (missionModel == null) {
      this.missionModel = new StartTimeMissionModel();
    } else {
      this.missionModel = missionModel;
    }
  }

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _CreateStartTimePageState();
  }
}

class _CreateStartTimePageState extends BaseWidgetState<CreateStartTimePage> {
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();

  /**
   * 侧滑点击删除
   */
  Future onClickDeleteItem(StartTimeMissionModel data) async {
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
          .delete_StartTimeMissionModel(currentObjectId: data.objectId);
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
      case 'onTapDeleteListener':
        this.onClickDeleteItem(data);
        break;
      case 'onClickCreate':
        this.onClickCreate(data);
        break;
    }
  }

  @override
  baseBuild(BuildContext context) {
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
            title: Text(getI18NKey().start_time),
            trailing: Text(DateUtil.getTimeString(
                this.widget.missionModel.start_time ?? 0)),
            onTap: () async {
              // 弹出时间选择器
              DateTimeModel? model;
              model = await Utility.showDateTimePickerDialog(context);
              if (model == null) {
                return;
              }
              this.widget.missionModel.start_time = model.timestamp; //设置开始时间
              updateUI();
            },
          ),
        ),
        TextUtil.isEmpty(this.widget.missionModel.background_url)
            ? getBgSettingItem(null)
            : CachedNetworkImage(
                imageUrl: Utility.filterHttpUrl(
                    this.widget.missionModel.background_url ?? '',
                    prefix: "oss"),
                imageBuilder: (context, imageProviderTmp) {
                  return getBgSettingItem(imageProviderTmp);
                }),
        Center(
          child: TextButton(
            onPressed: () {
              // 保存操作
              this.onClick('onClickCreate', null);
            },
            child: Text(this.widget.missionModel.objectId != null
                ? getI18NKey().save
                : getI18NKey().create),
          ),
        ),
      ],
    );
  }

  void onClickCreate(data) async {
    this.requestSaveData();
  }

  Future<void> requestSaveData() async {
    if (TextUtil.isEmpty(this.widget.missionModel.title) == true) {
      Utility.showToastMsg(
          context: context, msg: getI18NKey().please_input_the_mission_title);
      return;
    }
    if (this.widget.missionModel.objectId == null) {
      //创建新的
      this.widget.missionModel.time_format = "dd:HH:mm:ss";
      try {
        EasyLoadingManager.getInstance().showLoading();
        await MongoApisManager.getInstance().insertStartTimeMissionModel(
            missionModel: this.widget.missionModel);
        EasyLoadingManager.getInstance().hideLoading();
        Utility.showToastMsg(context: context, msg: getI18NKey().createSuccess);
        Utility.popupPagePCAndMobile(context);
      } catch (e) {
        Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
      }
    } else {
      //更新
      try {
        await MongoApisManager.getInstance().update_StartTimeMissionModel(
            missionModel: this.widget.missionModel);
        Utility.showToastMsg(
            context: context, msg: getI18NKey().update_success);
        Utility.popupPagePCAndMobile(context);
      } catch (e) {
        Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
      }
    }
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
          color: ThemeManager.getInstance().getCardBackgroundColor(
              defaultColor: Color(0xa0ffffff),
              alpha: TextUtil.isEmpty(this.widget.missionModel.background_url)
                  ? 255
                  : 140),
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
      this.widget.missionModel != null
          ? IconButton(
              icon: Icon(
                Icons.delete,
                color: ThemeManager.getInstance()
                    .getIconColor(defaultColor: Color(0xff909090)),
              ),
              onPressed: () {
                this.onClick("onTapDeleteListener", this.widget.missionModel);
              })
          : SizedBox.shrink(),
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
