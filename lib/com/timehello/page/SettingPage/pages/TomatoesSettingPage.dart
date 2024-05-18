import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:time_hello/com/timehello/beans/ResourceLocationInfoBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BlackCheckButtonListWidget.dart';
import 'package:time_hello/com/timehello/components/SectionHeaderWidget.dart';
import 'package:time_hello/com/timehello/components/SelectMinutesDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectMoneySettingDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectMusicDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SelectPresentDialogUtil.dart';
import 'package:time_hello/com/timehello/components/SettingMenuItem.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/util/CounterManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/GetResourceDeliveryManager.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ScreenLockManager.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';

class TomatoesSettingPage extends BaseWidget {
  PageFromEnum pageFrom;

  TomatoesSettingPage({this.pageFrom = PageFromEnum.Normal});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return TomatoesSettingPageState();
  }
}

class TomatoesSettingPageState extends BaseWidgetState<TomatoesSettingPage> {
  MusicModel? musicModelFinishResting; //完成休息中音乐
  MusicModel? musicModelFinishFocusing; //完成专注中音乐
  MusicModel? musicModelFocusing; //专注中音乐
  MusicModel? musicModelResting; //休息中音乐
  List<MusicModel>? listMusicModels; //音乐列表
  List<MusicModel>? listFocusingAndRestingMusicModels; //专注中休息中列表
  bool isNotificationOn = false;

  @override
  void initState() {
    this.isAppBarVisible = false;
    musicModelFinishResting =
        SharePreferenceUtil.getSyncInstance().getFinishRestingMusicModel();
    musicModelFinishFocusing =
        SharePreferenceUtil.getSyncInstance().getFinishFocusingMusicModel();
    musicModelFocusing =
        SharePreferenceUtil.getSyncInstance().getFocusingBGMusicModel();
    musicModelResting =
        SharePreferenceUtil.getSyncInstance().getRestingBGMusicModel();

    GetResourceDeliveryManager.getInstance()
        ?.requestGetResourceDelivery('timehello_music', isCachableOn: true,
            onResourceComplete:
                (List<ResourceLocationInfoBean> response, bool isFromCache) {
      this.listMusicModels = Utility.parseResourceBeansToMusicModels(
          Utility.getResourceDeliveryItemFromList('focusing_bg_music', response)
                  ?.deliveryList ??
              []);
      this.listFocusingAndRestingMusicModels =
          Utility.parseResourceBeansToMusicModels(
              Utility.getResourceDeliveryItemFromList('ringbell', response)
                      ?.deliveryList ??
                  []);
    });
    this.requestNotificationStatus();
  }

  @override
  void didUpdateWidget(TomatoesSettingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    requestNotificationStatus();
  }

  @override
  void dispose() {
    super.dispose();
    //打开页面
    if (this.widget.pageFrom == PageFromEnum.MissionDetailPage) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        OverlayManagement.getInstance().openMissionDetailPageOverlay(
            context: Utility.getGlobalContext(),
            missionModel: CounterManagement.getInstance().missionModel,
            folderModel: CounterManagement.getInstance().folderModel);
      });
    }
  }

  void requestNotificationStatus() async {
    bool isNotificationOn =
        await CounterMethodChannelManager.getInstance().isNotificationOn();
    if (this.isNotificationOn != isNotificationOn) {
      this.isNotificationOn = isNotificationOn;
    }
    updateUI();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(child: getTomatoesSettingWidget(context));
  }

  updateUI() {
    setState(() {});
  }

  void onClick(type, data) async {
    switch (type) {
      case "onClickSelectMusiscFinishResting":
        SelectMusicDialogUtil.getInstance().show(context,
            list: this.listFocusingAndRestingMusicModels ??
                CONSTANTS.getMusicModelList(),
            title: getI18NKey().select_ringtone,
            content: '',
            musicModel: musicModelFinishResting,
            onMusicTapListener: (MusicModel model, String localPath) {
          SharePreferenceUtil.getSyncInstance()
              .setFinishRestingMusicModel(model);
          musicModelFinishResting = SharePreferenceUtil.getSyncInstance()
              .getFinishRestingMusicModel();
          updateUI();
        });
        break;
      case "onClickSelectMusiscFinishingFocusing":
        SelectMusicDialogUtil.getInstance().show(context,
            list: this.listFocusingAndRestingMusicModels ??
                CONSTANTS.getMusicModelList(),
            title: getI18NKey().select_ringtone,
            content: '',
            musicModel: musicModelFinishFocusing,
            onMusicTapListener: (MusicModel model, String localPath) {
          SharePreferenceUtil.getSyncInstance()
              .setFinishFocusingMusicModel(model);
          musicModelFinishFocusing = SharePreferenceUtil.getSyncInstance()
              .getFinishFocusingMusicModel();
          updateUI();
        });
        break;
      case "onClickSelectFocusingMusic":
        SelectMusicDialogUtil.getInstance().show(context,
            list: this.listMusicModels ??
                CONSTANTS.getFocusAndRestingMusicModelList(),
            title: getI18NKey().focusing_music,
            content: '',
            musicModel: musicModelFocusing,
            onMusicTapListener: (MusicModel model, String localPath) {
          SharePreferenceUtil.getSyncInstance().setFocusingBGMusicModel(model);
          musicModelFocusing =
              SharePreferenceUtil.getSyncInstance().getFocusingBGMusicModel();
          updateUI();
        });
        break;
      case "onClickSelectRestingMusic":
        SelectMusicDialogUtil.getInstance().show(context,
            list: this.listMusicModels ??
                CONSTANTS.getFocusAndRestingMusicModelList(),
            title: getI18NKey().resting_music,
            content: '',
            musicModel: musicModelResting,
            onMusicTapListener: (MusicModel model, String localPath) {
          SharePreferenceUtil.getSyncInstance().setRestingBGMusicModel(model);
          musicModelResting =
              SharePreferenceUtil.getSyncInstance().getRestingBGMusicModel();
          updateUI();
        });
        break;
    }
  }

  Column getTomatoesSettingWidget(BuildContext context) {
    int tomatoTime =
        (SharePreferenceUtil.getSyncInstance().getTomatoTime() / 1000 / 60)
            .toInt();

    int tomatoRestTime =
        (SharePreferenceUtil.getSyncInstance().getTomatoRestTime() / 1000 / 60)
            .toInt();
    return Column(children: [
      SectionHeaderWidget(
        title: getI18NKey().tomatoClockSetting,
      ),
      Utility.isProductEnv() == true
          ? SizedBox.shrink()
          : SettingMenuItem(
              title: "测试用",
              description: getI18NKey().localmoney_made_per_minute_description,
              onTapListener: (data) {
                DialogManagement.showRatingDialog(context);
                // Utility.openPagePCAndMobile(context, child:CreateShareFolderPage());
                // SelectMoneySettingDialogUtil.show(context,
                //     title: getI18NKey().localmoney_made_per_minute,
                //     initVal: SharePreferenceUtil.getSyncInstance()
                //         .getLocalMoney(), okCallBack: (val) {
                //   SharePreferenceUtil.getSyncInstance().setLocalMoney(val);
                //   this.updateUI();
                // });
              },
              rightPartContainer: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        SharePreferenceUtil.getSyncInstance()
                                .getLocalMoney()
                                .toString() +
                            getI18NKey().rmb,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.common_color),
                      ),
                    ],
                  )
                ],
              ),
              icon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Utility.getSVGPicture(R.assetsImgIcMoney4, size: 15))),
      this.widget.pageFrom == PageFromEnum.MissionDetailPage
          ? SizedBox.shrink()
          : SettingMenuItem(
              title: getI18NKey().localmoney_made_per_minute,
              description: getI18NKey().localmoney_made_per_minute_description,
              onTapListener: (data) {
                SelectMoneySettingDialogUtil.show(context,
                    title: getI18NKey().localmoney_made_per_minute,
                    initVal: SharePreferenceUtil.getSyncInstance()
                        .getLocalMoney(), okCallBack: (val) {
                  SharePreferenceUtil.getSyncInstance().setLocalMoney(val);
                  setState(() {});
                });
              },
              rightPartContainer: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        SharePreferenceUtil.getSyncInstance()
                                .getLocalMoney()
                                .toString() +
                            getI18NKey().rmb,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.common_color),
                      ),
                    ],
                  )
                ],
              ),
              icon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Utility.getSVGPicture(R.assetsImgIcMoney4, size: 15))),
      this.widget.pageFrom == PageFromEnum.MissionDetailPage
          ? SizedBox.shrink()
          : SettingMenuItem(
              title: getI18NKey().consump_present,
              description: getI18NKey().consump_present_description,
              onTapListener: (data) {
                SelectPresentDialogUtil.show(context,
                    title: "", content: "", isCheckButtonShow: false);
                // SelectMoneySettingDialogUtil.show(context,
                //     title: getI18NKey().localmoney_made_per_minute,
                //     initVal: SharePreferenceUtil.getSyncInstance().getLocalMoney(),
                //     okCallBack: (val) {
                //       SharePreferenceUtil.getSyncInstance().setLocalMoney(val);
                //       this.updateUI();
                //     });
              },
              rightPartContainer: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        getI18NKey().number_present(
                            MongoApisManager.getInstance()
                                    .listPresentModel
                                    .length ??
                                0),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.common_color),
                      ),
                    ],
                  )
                ],
              ),
              icon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child:
                      Utility.getSVGPicture(R.assetsImgIcPresent, size: 15))),
      SettingMenuItem(
          title: getI18NKey().lock_screen_auto_password_setting_for_applock,
          onTapListener: (data) {
            ScreenLockManager.getInstance().resetPassword();
          },
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex: SharePreferenceUtil.getSyncInstance().getDefault9DigitPasswordsNeedShowWhenLoginAppLock()
                ? 1
                : 0,
            list: CONSTANTS.getOnAndOffButtonList(),
            onTapListener: (obj) {
              if(!ScreenLockManager.getInstance().hasPassword() && obj == 1) {
                ScreenLockManager.getInstance().createPassword(shouldShow: true);
              }
              SharePreferenceUtil.getSyncInstance().setDefault9DigitPasswordsNeedShowWhenLoginAppLock(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .getDefault9DigitPasswordsNeedShowWhenLoginAppLock());
              updateUI();
            },
          ),
          icon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Utility.getSVGPicture(R.assetsImgIcLockscreenView, size: 15))),
      SettingMenuItem(
          title: getI18NKey().lock_screen_auto_password_setting,
          onTapListener: (data) {
            ScreenLockManager.getInstance().resetPassword();
          },
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex: SharePreferenceUtil.getSyncInstance().getDefault9DigitPasswordsNeedShowWhenLogin()
                ? 1
                : 0,
            list: CONSTANTS.getOnAndOffButtonList(),
            onTapListener: (obj) {
              if(!ScreenLockManager.getInstance().hasPassword() && obj == 1) {
                ScreenLockManager.getInstance().createPassword(shouldShow: true);
              }
              SharePreferenceUtil.getSyncInstance().setDefault9DigitPasswordsNeedShowWhenLogin(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .getDefault9DigitPasswordsNeedShowWhenLogin());
              updateUI();
            },
          ),
          icon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Utility.getSVGPicture(R.assetsImgIcUnlockscreen, size: 15))),
      SettingMenuItem(
          title: getI18NKey().rest_completed_auto_start_play,
          onTapListener: (data) {},
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex: SharePreferenceUtil.getSyncInstance().getLoopOnRelaxing()
                ? 1
                : 0,
            list: CONSTANTS.getManualOnAndOffButtonList(),
            onTapListener: (obj) {
              SharePreferenceUtil.getSyncInstance().setLoopOnRelaxing(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .getLoopOnRelaxing());
            },
          ),
          icon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Utility.getSVGPicture(R.assetsImgIcAutorenew, size: 15))),
      SettingMenuItem(
          title: getI18NKey().focus_completed_auto_start_rest,
          onTapListener: (data) {},
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex: SharePreferenceUtil.getSyncInstance().getLoopOnFocusing()
                ? 1
                : 0,
            list: CONSTANTS.getManualOnAndOffButtonList(),
            onTapListener: (obj) {
              SharePreferenceUtil.getSyncInstance().setLoopOnFocusing(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .getLoopOnFocusing());
              bool res =
                  SharePreferenceUtil.getSyncInstance().getLoopOnFocusing();
              print(res);
            },
          ),
          icon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Utility.getSVGPicture(R.assetsImgIcAutorenew, size: 15))),
      this.widget.pageFrom == PageFromEnum.MissionDetailPage
          ? SizedBox.shrink()
          : SettingMenuItem(
              title: getI18NKey().defaultFocusDuration,
              description: '',
              onTapListener: (data) {
                SelectMinutesDialogUtil.show(context,
                    duration: tomatoTime,
                    title: getI18NKey().defaultFocusDuration,
                    okCallBack: (duration) {
                  SharePreferenceUtil.getSyncInstance()
                      .setTomatoTime(duration * 60 * 1000);
                  setState(() {});
                });
              },
              rightPartContainer: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        tomatoTime.toString() + getI18NKey().mins2,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.common_color),
                      ),
                    ],
                  )
                ],
              ),
              icon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Utility.getSVGPicture(R.assetsImgIcFocus, size: 15))),
      this.widget.pageFrom == PageFromEnum.MissionDetailPage
          ? SizedBox.shrink()
          : SettingMenuItem(
              title: getI18NKey().confirmRestDuration,
              description: '',
              onTapListener: (data) {
                SelectMinutesDialogUtil.show(context,
                    duration: tomatoRestTime,
                    title: getI18NKey().defaultFocusDuration,
                    okCallBack: (duration) {
                  SharePreferenceUtil.getSyncInstance()
                      .setTomatoRestTime(duration * 60 * 1000);
                  setState(() {});
                });
              },
              rightPartContainer: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        tomatoRestTime.toString() + getI18NKey().minsSpace,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorsConfig.common_color),
                      ),
                    ],
                  )
                ],
              ),
              icon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Utility.getSVGPicture(R.assetsImgIcRest, size: 15))),
      SettingMenuItem(
          title: getI18NKey().focus_finished_ringtone,
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex:
                SharePreferenceUtil.getSyncInstance().isFocusFinishAlertOn()
                    ? 1
                    : 0,
            list: CONSTANTS.getOnOffButtonList(
                defaultVal: SharePreferenceUtil.getSyncInstance()
                    .isFocusFinishAlertOn()),
            onTapListener: (obj) {
              SharePreferenceUtil.getSyncInstance().setFocusFinishAlertOn(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .isFocusFinishAlertOn());
            },
          ),
          description: getI18NKey()
              .currentRingTone(this.musicModelFinishFocusing?.title ?? ''),
          onTapListener: (data) {
            this.onClick('onClickSelectMusiscFinishingFocusing', data);
          },
          icon: Icon(Icons.music_note_outlined,
              color: ColorsConfig.gray_a3_icon)),
      SettingMenuItem(
          title: getI18NKey().resting_stopping_ringtone,
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex:
                SharePreferenceUtil.getSyncInstance().isRestFinishAlertOn()
                    ? 1
                    : 0,
            list: CONSTANTS.getOnOffButtonList(
                defaultVal: SharePreferenceUtil.getSyncInstance()
                    .isRestFinishAlertOn()),
            onTapListener: (obj) {
              SharePreferenceUtil.getSyncInstance().setRestFinishAlertOn(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .isRestFinishAlertOn());
            },
          ),
          description: getI18NKey()
              .currentRingTone(this.musicModelFinishResting?.title ?? ''),
          onTapListener: (data) {
            this.onClick('onClickSelectMusiscFinishResting', data);
          },
          icon: Icon(Icons.music_note_outlined,
              color: ColorsConfig.gray_a3_icon)),
      SettingMenuItem(
          title: getI18NKey().focusing_music,
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex: SharePreferenceUtil.getSyncInstance().isFocusBGMusicOn()
                ? 1
                : 0,
            list: CONSTANTS.getOnOffButtonList(
                defaultVal:
                    SharePreferenceUtil.getSyncInstance().isFocusBGMusicOn()),
            onTapListener: (obj) {
              SharePreferenceUtil.getSyncInstance().setFocusBGMusicOn(
                  isOn: !SharePreferenceUtil.getSyncInstance()
                      .isFocusBGMusicOn());
            },
          ),
          description: getI18NKey()
              .currentRingTone(this.musicModelFocusing?.title ?? ''),
          onTapListener: (data) {
            this.onClick('onClickSelectFocusingMusic', data);
          },
          icon: Icon(Icons.music_note_outlined,
              color: ColorsConfig.gray_a3_icon)),
      SettingMenuItem(
          title: getI18NKey().resting_music,
          rightPartContainer: BlackCheckButtonListWidget(
            initIndex:
                SharePreferenceUtil.getSyncInstance().isRestBGMusicOn() ? 1 : 0,
            list: CONSTANTS.getOnOffButtonList(
                defaultVal:
                    SharePreferenceUtil.getSyncInstance().isRestBGMusicOn()),
            onTapListener: (obj) {
              SharePreferenceUtil.getSyncInstance().setRestBGMusicOn(
                  isOn:
                      !SharePreferenceUtil.getSyncInstance().isRestBGMusicOn());
            },
          ),
          description:
              getI18NKey().currentRingTone(this.musicModelResting?.title ?? ''),
          onTapListener: (data) {
            this.onClick('onClickSelectRestingMusic', data);
          },
          icon: Icon(Icons.music_note_outlined,
              color: ColorsConfig.gray_a3_icon)),
    ]);
  }
}
