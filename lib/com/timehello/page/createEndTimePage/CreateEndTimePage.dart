import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';

import '../../beans/BaseBean.dart';
import '../../beans/ResourceDeliveryInfoBean.dart';
import '../../components/SelectDatePeriodDialogUtil.dart';
import '../../config/CONSTANTS.dart';
import '../../config/Params.dart';
import '../../libs/methodChannel/CounterMethodChannelManager.dart';
import '../../models/DateTimeModel.dart';
import '../../models/EndTimeMissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/TextUtil.dart';
import '../../util/Utility.dart';
import '../../util/date_util.dart';

/**
 * 文件类型：页面
 * 文件作用：创建或编辑倒计时任务，提供目标时间、提醒、重复和壁纸等配置入口。
 * 主要职责：维护 EndTimeMissionModel 的表单状态，并复用原有 Mongo 接口完成新增/更新。
 */
class CreateEndTimePage extends BaseWidget {
  final EndTimeMissionModel missionModel;

  CreateEndTimePage({EndTimeMissionModel? missionModel})
      : missionModel = missionModel ?? EndTimeMissionModel();

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

  @override
  void dispose() {
    controllerDesc.dispose();
    controllerTitle.dispose();
    super.dispose();
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

  /**
   * 功能：保存当前倒计时表单。
   * 说明：新建时补齐默认倒计时格式，编辑时只更新当前模型，成功后沿用原有桌面/移动端返回逻辑。
   */
  Future<void> requestSaveData() async {
    if (TextUtil.isEmpty(this.widget.missionModel.title) == true) {
      Utility.showToastMsg(
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
        Utility.showToastMsg(context: context, msg: getI18NKey().createSuccess);
        //todo 敢做这个没用了 因为用env了
        //mobile端返回上一页
        Utility.popupPagePCAndMobile(context);
      } catch (e) {
        Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
      }
    } else {
      // 更新已有倒计时，只提交 EndTimeMissionModel 的当前表单状态。
      try {
        await MongoApisManager.getInstance()
            .update_EndTimeMissionModel(missionModel: this.widget.missionModel);
        Utility.showToastMsg(
            context: context, msg: getI18NKey().update_success);
        //todo 敢做这个没用了 因为用env了
        //mobile端返回上一页
        Utility.popupPagePCAndMobile(context);
      } catch (e) {
        Utility.showToastMsg(context: context, msg: getI18NKey().network_error);
      }
    }
  }

  @override
  baseBuild(BuildContext context) {
    // 参考新设计稿：桌面端创建页收敛成居中的白色表单卡片，弱化原始列表表单的工具感。
    return Container(
      color: const Color(0xfff3efe7),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Container(
            padding: const EdgeInsets.fromLTRB(32, 30, 32, 34),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleEditor(),
                const SizedBox(height: 28),
                buildSettingRows(),
                const SizedBox(height: 28),
                buildWallpaperSection(),
                const SizedBox(height: 34),
                Center(child: buildSaveButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /**
   * 功能：构建倒计时标题和描述输入区。
   * 说明：输入时直接同步到模型，保存时复用原有 Mongo 写入逻辑。
   */
  Widget buildTitleEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controllerTitle,
          onChanged: (val) {
            this.widget.missionModel.title = val;
          },
          style: const TextStyle(
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Color(0xff171a21),
          ),
          decoration: InputDecoration(
            hintText: getI18NKey().title,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllerDesc,
          onChanged: (val) {
            this.widget.missionModel.message = val;
          },
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff667085),
          ),
          decoration: InputDecoration(
            hintText: getI18NKey().remarks_optional,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  /**
   * 功能：构建倒计时创建页的核心设置项。
   * 说明：每一行只负责展示当前值和触发对应选择弹窗，真实数据仍写回 EndTimeMissionModel。
   */
  Widget buildSettingRows() {
    String repetiveString =
        CONSTANTS.getRepetiveDateString1E(this.widget.missionModel);
    return Column(
      children: [
        buildSettingRow(
          icon: Icons.calendar_today_outlined,
          title: getI18NKey().time,
          value: DateUtil.getTimeString(this.widget.missionModel.end_time ?? 0),
          onTap: selectEndTime,
        ),
        buildSettingRow(
          icon: Icons.timer_outlined,
          title: getI18NKey().unit,
          value: getI18NKey().day_hour_minute_second,
        ),
        buildSettingRow(
          icon: Icons.notifications_active_outlined,
          title: getI18NKey().reminder,
          value: getAlertText(),
          onTap: selectAlertTime,
        ),
        buildSettingRow(
          icon: Icons.repeat,
          title: getI18NKey().whether_to_repeat,
          value: repetiveString,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                repetiveString,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff6b7280),
                ),
              ),
              const SizedBox(width: 12),
              IgnorePointer(
                child: Switch(
                  value: (this.widget.missionModel.repetiveType ?? 0) != 0,
                  onChanged: (_) {},
                  activeThumbColor: const Color(0xff0a68d1),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xffd7dce2),
                ),
              ),
            ],
          ),
          onTap: selectRepeat,
        ),
      ],
    );
  }

  Widget buildSettingRow({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffedf0f3), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xff4f8fd8)),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xff333844),
              ),
            ),
            const Spacer(),
            trailing ??
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff6b7280),
                    ),
                  ),
                ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right,
                  size: 18, color: Color(0xff8a93a3)),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildWallpaperSection() {
    final List<ResourceDeliveryInfoBean> wallpapers = ResourceInfo
            .missionItemBackgroundLocationInfoBean?.deliveryList
            ?.take(5)
            .toList() ??
        [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '选择壁纸',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xff48505d),
              ),
            ),
            const Spacer(),
            IconButton(
              icon:
                  const Icon(Icons.delete, size: 18, color: Color(0xff1f2933)),
              onPressed: () {
                this.widget.missionModel.background_url = null;
                updateUI();
              },
            )
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: wallpapers.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index >= wallpapers.length) {
                return buildWallpaperMoreButton();
              }
              final ResourceDeliveryInfoBean wallpaper = wallpapers[index];
              final String imageUrl = wallpaper.resourcePictureUrl ??
                  wallpaper.resourceIconUrl ??
                  '';
              return buildWallpaperThumb(imageUrl);
            },
          ),
        ),
      ],
    );
  }

  /**
   * 功能：构建单张壁纸缩略图。
   * 说明：点击后只更新模型里的 background_url，真正保存仍由底部保存按钮统一提交。
   */
  Widget buildWallpaperThumb(String imageUrl) {
    final bool selected = this.widget.missionModel.background_url == imageUrl;
    return GestureDetector(
      onTap: () {
        this.widget.missionModel.background_url = imageUrl;
        updateUI();
      },
      child: Container(
        width: 116,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? const Color(0xff0a68d1) : Colors.transparent,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: Utility.filterHttpUrl(imageUrl, prefix: "oss"),
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              Container(color: const Color(0xffeef2f6)),
        ),
      ),
    );
  }

  /**
   * 功能：构建更多壁纸入口。
   * 说明：保留项目已有全量背景选择弹窗，避免新版页面只显示前几张缩略图时丢失选择能力。
   */
  Widget buildWallpaperMoreButton() {
    return GestureDetector(
      onTap: () {
        DialogManagement.getInstance().showSelectBgDialog(context,
            list: ResourceInfo
                    .missionItemBackgroundLocationInfoBean?.deliveryList ??
                [], onTapListener: (String imgUrl) {
          this.widget.missionModel.background_url = imgUrl;
          updateUI();
          DialogManagement.getInstance().hideDialog(context);
        });
      },
      child: Container(
        width: 34,
        decoration: BoxDecoration(
          color: const Color(0xffeef2f6),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: const Color(0xffcdd6e0),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: const Icon(Icons.more_horiz, color: Color(0xff8a93a3)),
      ),
    );
  }

  /**
   * 功能：构建保存按钮。
   * 说明：按钮视觉按设计稿强化为蓝色主按钮，点击仍走 onClickCreate 以复用原事件分发。
   */
  Widget buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: () {
        this.onClick('onClickCreate', null);
      },
      icon: const Icon(Icons.check_circle, size: 16),
      label: Text(getI18NKey().save),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff096bd8),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: const Color(0xff096bd8).withValues(alpha: 0.28),
        minimumSize: const Size(132, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    );
  }

  Future<void> selectEndTime() async {
    DateTimeModel? model = await Utility.showDateTimePickerDialog(context);
    if (model == null) {
      return;
    }
    this.widget.missionModel.end_time = model.timestamp;
    updateUI();
  }

  Future<void> selectAlertTime() async {
    DateTimeModel? model;
    TimeOfDay? timeOfDay;
    if (this.widget.missionModel.repetiveType == 0) {
      model = await Utility.showDateTimePickerDialog(context);
      if (model == null) {
        return;
      }
      this.widget.missionModel.alert_time = model.timestamp;
    } else {
      timeOfDay = await Utility.showTimePickerDialog(context);
      if (timeOfDay == null) {
        return;
      }
      this.widget.missionModel.alert_time =
          timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
    }
    updateUI();
    this.requestNotification();
  }

  void selectRepeat() {
    SelectDatePeriodDialogUtil.show(context,
        okCallBack: (valueMiddleSelected, valueRightSelected, listCheckModels) {
      this.widget.missionModel.repetiveValue = valueMiddleSelected;
      if (this.widget.missionModel.repetiveType != valueRightSelected) {
        this.widget.missionModel.alert_time = 0;
      }
      this.widget.missionModel.repetiveType = valueRightSelected;
      if (this.widget.missionModel.repetiveWeekDay == null ||
          (this.widget.missionModel.repetiveWeekDay?.length ?? 0) == 0) {
        this.widget.missionModel.repetiveWeekDay = [
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ];
      }
      if (listCheckModels.length > 6) {
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
      }
      updateUI();
    });
  }

  String getAlertText() {
    return TextUtil.isEmpty(this.widget.missionModel.alert_time) == false
        ? (this.widget.missionModel.repetiveType == 0
            ? CONSTANTS.getAlertDateString(
                Utility.getDateTimeModelFromTimeStamp(
                    this.widget.missionModel.alert_time ?? 0))
            : Utility.formatHourAndMin2(
                this.widget.missionModel.alert_time ?? 0))
        : getI18NKey().none;
  }
}
