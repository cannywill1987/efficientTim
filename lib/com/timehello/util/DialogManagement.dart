import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/components/CheckContainer.dart';
import 'package:time_hello/com/timehello/components/CustomCheckBox.dart';
import 'package:time_hello/com/timehello/components/CustomMultiInputWidget.dart';
import 'package:time_hello/com/timehello/components/PasswordWidget.dart';
import 'package:time_hello/com/timehello/components/PriorityMissionListWidget.dart';
import 'package:time_hello/com/timehello/components/SelectBgDialog.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/SearchFriendGroupWidget.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../main.dart';
import '../../../r.dart';
import '../common/database/apis/MongoApisManager.dart';
import '../components/BottomCounterWidget.dart';
import '../components/CloseButton.dart';
import '../components/CmdFContainerWidget.dart';
import '../components/CustomMissionSilverWidget.dart';
import '../components/EditTitleDialogUtil.dart';
import '../components/MSNWidget.dart';
import '../components/NineLoterryWidget.dart';
import '../components/PrioriyColorsGridViewWidget.dart';
import '../components/RatingDialog.dart';
import '../components/SelectSliderDurationDialogUtil.dart';
import '../components/SelectSliderVolumeDialogUtil.dart';
import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../config/ENUMS.dart';
import '../config/EVENTNAME.dart';
import '../config/Params.dart';
import '../interface/OnTapListener.dart';
import '../models/CheckButtonStateModel.dart';
import '../page/FlomoPage/components/FlomoRatingDialog.dart';
import '../page/GroupChatPage/components/GroupChatPermissionSharingWidget.dart';
import '../page/missionDetailPage/MissionDetailPage.dart';
import 'CloudSharepreferenceManagement.dart';
import 'EventCollection.dart';
import 'LoginManager.dart';
import 'SharePreferenceUtil.dart';
import 'TextUtil.dart';
import 'Utility.dart';
import 'WidgetManager.dart';

/**
 * 用于管理overlay
 */
class DialogManagement {
  static DialogManagement? mDialogManagement;
  bool hasRatingBarShow = false;
  AlertDialog? cmdFContainerWidgetDialog = null;
  DialogManagement();

  static DialogManagement getInstance() {
    if (mDialogManagement == null) {
      mDialogManagement = new DialogManagement();
    }
    return mDialogManagement!;
  }

  init() {
    return mDialogManagement;
  }

  Future<bool?> showCustomIconTitleAndDescDialog(BuildContext context,
      {Widget? iconWidget,
      String? title,
      String? desc,
      String? checkBoxDesc,
      bool isChecked = false,
      Function? okCallback}) async {
    bool isCheck = isChecked;
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        okText: getI18NKey().confirm,
        Utility.getGlobalContext(),
        child: Container(
          width: 400,
          child: Column(
            children: [
              if (iconWidget != null) iconWidget,

              SizedBox(
                height: 20,
              ),
              Text(
                title ?? "",
                style: TextStyle(
                    fontSize: 18,
                    color: ThemeManager.getInstance().getTextColor()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getI18NKey().confirm_delete_folder_desc,
                style: TextStyle(fontSize: 14, color: Color(0xff999999)),
              ),
              SizedBox(
                height: 15,
              ),
              //一个checkbox 右边有文案
              if (!TextUtil.isEmpty(checkBoxDesc))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // CheckContainer(
                    //   value: isCheck,
                    //   onChanged: (value) {
                    //     isCheck = value;
                    //   },
                    // ),
                    CustomCheckBox(
                      isChecked: isCheck ?? false,
                      onChanged: (value) {
                        isCheck = value!;
                      },
                    ),
                    Wrap(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          width: 300,
                          child: Text(
                            checkBoxDesc ?? "",
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    ThemeManager.getInstance().getTextColor()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        cancelCallback: () {
          DialogManagement.getInstance().hideDialog(context, false);
        },
        cancelText: getI18NKey().cancel,
        okCallback: () {
          okCallback?.call(isCheck);
          DialogManagement.getInstance().hideDialog(context, true);
        });
    return result;
  }

  Future<bool?> showMissionListDialog(BuildContext context,
      {required List<MissionModel> list, int prioriy = -1}) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: PriorityMissionListWidget(
                  list: list,
                  priority: prioriy,
                  onTapCloseListener: () {
                    DialogManagement.getInstance().hideDialog(context);
                  },
                ),
              ),
              // close circle red btn
            ],
          );
        });
  }

  Future<bool?> showAsyncCustomDialog(BuildContext context,
      {String? title,
      Widget? child,
      barrierDismissible: true,
      shouldShowButtons: true,
      String? okText,
      String? cancelText,
      EdgeInsets? margin,
      EdgeInsets? padding,
      int color: 0xff61c37d,
      Function? okCallback,
      Function? cancelCallback}) async {
    return await showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        traversalEdgeBehavior: TraversalEdgeBehavior.parentScope,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: margin ?? EdgeInsets.all(20),
                    padding: padding ?? EdgeInsets.all(20),
                    constraints: BoxConstraints(
                      maxWidth: 500,
                    ),
                    decoration: StylesConfig.getDecoration(
                      radius: 12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title ?? "",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        child ?? SizedBox.shrink(),
                        if (shouldShowButtons == true)
                          SizedBox(
                            height: 10,
                          ),
                        if (shouldShowButtons == true)
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: ThemeManager.getInstance().getLineColor(),
                          ),
                        if (shouldShowButtons == true)
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        if (cancelCallback != null) {
                                          cancelCallback();
                                        }
                                      },
                                      child: Text(
                                          cancelText ?? getI18NKey().refuse,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Color(0xffbbbbbb),
                                              fontSize: 15)))),
                              Container(
                                width: 1,
                                height: 40,
                                color:
                                    ThemeManager.getInstance().getLineColor(),
                              ),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        if (okCallback != null) {
                                          okCallback();
                                        }
                                      },
                                      child: Text(
                                        okText ?? getI18NKey().agree,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: ThemeManager.getInstance()
                                                .getTextColor(
                                                    defaultColor: ThemeManager
                                                            .getInstance()
                                                        .getDefautThemeColor()),
                                            fontSize: 15),
                                      )))
                            ],
                          )
                      ],
                    ))
              ],
            ),
          );
        });
  }

  void showProtocolDialog(BuildContext context,
      {String? title,
      String? content,
      String? pattern,
      Function? onClickLink,
      Function? okCallback,
      Function? cancelCallback}) async {
    String brand = await CounterMethodChannelManager.getInstance().getBrand();
    showCustomDialog(context,
        title: title,
        color: brand == "HUAWEI" ? 0xffbbbbbb : 0xff61c37d,
        barrierDismissible: false,
        cancelCallback: cancelCallback,
        okCallback: okCallback,
        child: ParsedText(
          text: content ?? "",
          parse: <MatchText>[
            MatchText(
                pattern: pattern, //匹配规则
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
                onTap: (url) {
                  if (onClickLink != null) {
                    onClickLink();
                  }
                }),
          ],
          style: TextStyle(
            color: Color(0xff878787),
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ));
  }

  void showSelectBgDialog(BuildContext context,
      {List? list, required Function onTapListener}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SelectBgDialog(
            list: list ?? [],
            onTapListener: onTapListener,
          );
        });
  }

  void showYearDialog(BuildContext context,
      {required String title,
      Widget? child,
      required Function okCallback,
      required Function cancelCallback}) {
    PickerDateRange? dateTimePickerDateRange;
    DialogManagement.getInstance().showCustomDialog(context,
        title: title,
        okCallback: () {
          okCallback!(dateTimePickerDateRange);
        },
        cancelCallback: cancelCallback,
        child: Utility.getYearDatePicker((datetime) {
          dateTimePickerDateRange = datetime;
        }));
  }

  void showFinishDialog(BuildContext context, {required Function okCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isChecked = false;
        return AlertDialog(
          title: Text(getI18NKey().this_mission_is_cycle_mission),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(getI18NKey().close_all_cycle_mission),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(getI18NKey().cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(getI18NKey().confirm),
              onPressed: () {
                Navigator.of(context).pop();
                // 在这里处理确定按钮的逻辑
                okCallback.call(isChecked);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void showAISearchBarMenuWithoutText({
    required BuildContext context,
    // bool isHighlight,
    Function? onSubmit,
    Function? onContinue,
    Function? onCopy,
  }) {


    // void dismissOverlay() {
    //   // keepEditorFocusNotifier.decrease();
    //   if(cmdFContainerWidgetDialog != null) {
    //     Navigator.of(context).pop();
    //     cmdFContainerWidgetDialog = null;
    //   }
    // }
    // dismissOverlay();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return cmdFContainerWidgetDialog = AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: isHandsetBySize(context: context) ? mobileWidth : tabletWidth,
                      // height: 600,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: CmdFContainerWidget())
                ],
              );
            },
          ),
          actions: <Widget>[

          ],
        );
      },
    );

    // keepEditorFocusNotifier.increase();
    // overlay = FullScreenOverlayWidgetEntry(
    //   top: height / 2 - 200,
    //   // height: 0,
    //   left: width / 2  - (isHandsetBySize(context: context) ? mobileWidth : tabletWidth) / 2,
    //   // width: 0,
    //   dismissCallback: () => keepEditorFocusNotifier.decrease(),
    //   builder: (context) {
    //
    //   },
    // ).build();
    //
    // Overlay.of(context, rootOverlay: true).insert(overlay!);
  }


  void showMonthDialog(BuildContext context,
      {required String title,
      Widget? child,
      required Function okCallback,
      required Function cancelCallback}) {
    PickerDateRange? dateTimePickerDateRange;
    DialogManagement.getInstance().showCustomDialogWithSmallButtons(context,
        // type: 0,
        title: title,
        pcMargin: 10,
        height: 300,
        okCallback: () {
          okCallback!(dateTimePickerDateRange);
        },
        cancelCallback: cancelCallback,
        child: Utility.getMonthDatePicker((datetime) {
          dateTimePickerDateRange = datetime;
        }));
  }

  void showSfHijriDateRangePicker(BuildContext context,
      {required String title,
      Widget? child,
      required Function okCallback,
      required Function cancelCallback}) {
    final HijriDatePickerController _controller = HijriDatePickerController();
    DateRangePickerSelectionMode _selectionMode =
        DateRangePickerSelectionMode.extendableRange;
    ExtendableRangeSelectionDirection _selectionDirection =
        ExtendableRangeSelectionDirection.both;
    bool _enablePastDates = true;
    bool _enableSwipingSelection = true;
    bool _enableViewNavigation = true;
    bool _showActionButtons = true;
    bool _isWeb = false;
    bool _showWeekNumber = false;
    bool _showTodayButton = true;

    DialogManagement.getInstance().showCustomDialogWithSmallButtons(context,
        title: title, okCallback: () {
      if (okCallback != null) {
        okCallback();
      }
    },
        cancelCallback: cancelCallback,
        child: Utility.getSfHijriDateRangePicker(
            _controller,
            _selectionMode,
            _enablePastDates,
            _enableSwipingSelection,
            _enableViewNavigation,
            _showActionButtons,
            HijriDateTime.now().subtract(const Duration(days: 200)),
            HijriDateTime.now().add(const Duration(days: 200)),
            false,
            _showWeekNumber,
            _showTodayButton,
            _selectionDirection,
            context));
  }

  static void showFlomoRatingDialog(BuildContext context,
      {required FlomoMissionModel flomoMissionModel,
      required Function onSubmitted}) async {
    // if(SharePreferenceUtil.getSyncInstance().getBool(key: ShareprefrenceKeys.flomoRatingDialogDontRemindAgain, defaultVal: false) == false) {
    DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(context,
        child: FlomoRatingDialog(
          flomoMissionModel: flomoMissionModel,
          onSubmitted: (val) {
            onSubmitted?.call(val);
          },
        ));
    // }
  }

  static void showRatingDialog(BuildContext context, {scene: ""}) async {
    // if (Utility.isMacOS() == true) {
    //   CounterMethodChannelManager.getInstance().requestReview();
    // } else if (Utility.isIOS() == true) {
    // if (Params.channelEnum != ChannelEnum.vivo) {
      bool hasRating = await CloudSharepreferenceManagement.getInstance()
          .getBool(ShareprefrenceKeys.hasRating + scene, false);
      bool hasRatingGlobal = await CloudSharepreferenceManagement.getInstance()
          .getBool(ShareprefrenceKeys.hasRating, false);

      if (hasRating == false && hasRatingGlobal == false) {
        DialogManagement.getInstance().showRatingDialogWithOnlyChild(context,
            child: RatingDialog(
                force: false,
                starSize: 28,
                submitButtonTextStyle: TextStyle(fontSize: 20),
                image: Container(
                    clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    R.assetsImgBgRatingGuide,
                    width: 100,
                    height: 100,
                  ),
                ),
                title: Text(getI18NKey().rating_guide, style: TextStyle(fontSize: 16),),
                submitButtonText: getI18NKey().submit,
                onDontRemindAgainListener: () {
                  CloudSharepreferenceManagement.getInstance()
                      .setBool(ShareprefrenceKeys.hasRating + scene, true);
                  EventCollection.onCollectionJSON({
                    "sceneType": scene,
                    "eventType": EVENTNAME.rating_refuse,
                    "message": "",
                  });
                },
                onClickCopyQQ: () {
                  Utility.copyToClipboard("563144208", shouldShowToast: false);
                  EventCollection.onCollectionJSON({
                    "sceneType": scene,
                    "eventType": EVENTNAME.rating_add_qq,
                    "message": "",
                  });
                  Utility.showToastMsg(
                      context: context, msg: getI18NKey().copy_qq_success);
                },
                onSubmitted: (d) async {
                  if (!TextUtil.isEmpty(scene)) {
                    EventCollection.onCollectionJSON({
                      "sceneType": scene,
                      "eventType": EVENTNAME.rating,
                      "message": "",
                      "value1": d.rating
                    });
                  }
                  CloudSharepreferenceManagement.getInstance()
                      .setBool(ShareprefrenceKeys.hasRating + scene, true);
                  CloudSharepreferenceManagement.getInstance()
                      .setBool(ShareprefrenceKeys.hasRating, true);
                  // SharePreferenceUtil.getSyncInstance()
                  //     .setBool(key: ShareprefrenceKeys.hasRating, val: true);
                  if (!TextUtil.isEmpty(d.comment)) {
                    MongoApisManager.getInstance().insertCommentModel(
                        title: d.comment,
                        content: d.comment,
                        username:
                            LoginManager.getInstance().getUserBean().username,
                        avatar:
                            LoginManager.getInstance().getUserBean().avatar);
                  }
                  if (d.rating >= 4) {
                    if (Utility.isIOS() == true || Utility.isMacOS() == true) {
                      // String s = "https://itunes.apple.com/app/id${Utility.isMacOS()
                      //     ? '1663772116'
                      //     : '1663610373'}?action=write-review";
                      // Utility.openExternalWebView(url: s);
                      if (Utility.isIOS()) {
                        final InAppReview inAppReview = InAppReview.instance;
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        } else {
                          inAppReview.openStoreListing(
                              appStoreId: Utility.isMacOS()
                                  ? '1663772116'
                                  : '1663610373');
                        }
                      } else {
                        CounterMethodChannelManager.getInstance()
                            .requestReview();
                      }
                    } else {
                      Utility.openExternalWebView(url: Urls.ratingGuide);
                    }
                  }
                }));
      }
    // }
    // }
  }

  void showDateRangePickerDialog(BuildContext context,
      {required String title,
      Widget? child,
      required Function okCallback,
      required Function cancelCallback}) {
    PickerDateRange? dateTimePickerDateRange;
    DialogManagement.getInstance().showCustomDialogWithSmallButtons(context,
        title: title,
        mobileVerticalPadding: 80,
        okCallback: () {
          okCallback(dateTimePickerDateRange);
        },
        cancelCallback: cancelCallback,
        child: Utility.getDateRangePicker2((datetime) {
          dateTimePickerDateRange = datetime.value;
          // okCallback(dateTimePickerDateRange);
        }));
  }

  void showDayDialog(BuildContext context,
      {required String title,
      Widget? child,
      required Function okCallback,
      required Function cancelCallback}) {
    PickerDateRange? dateTimePickerDateRange;
    DialogManagement.getInstance().showCustomDialogWithSmallButtons(context,
        title: title,
        okCallback: () {
          okCallback(dateTimePickerDateRange);
        },
        cancelCallback: cancelCallback,
        child: Utility.getDayDatePicker((datetime) {
          dateTimePickerDateRange = datetime;
        }));
  }

  void showCustomDialogWithSmallButtons(BuildContext context,
      {required String title,
      Widget? child,
      List<Widget>? children,
      double? height: -1,
      String? okTitle,
      double pcMargin = 10,
      minHeight: 200,
      double mobileVerticalPadding = 160,
      String? cancelTitle,
      // int type = 1, // 0 按钮在上面 1 按钮在下面
      required Function okCallback,
      Function? cancelCallback}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          //scaffold里内容居中
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      constraints: BoxConstraints(minHeight: 200, maxWidth: 500),
                      margin: Utility.isHandsetBySize()
                          ? EdgeInsets.symmetric(
                              horizontal: 20, vertical: mobileVerticalPadding)
                          : EdgeInsets.all(pcMargin),
                      padding: Utility.isHandsetBySize()
                          ? EdgeInsets.all(15)
                          : EdgeInsets.all(15),
                      decoration: StylesConfig.getDecoration(
                        color: ThemeManager.getInstance()
                            .getDialogBackgroundColor(
                                defaultColor: Colors.white),
                        radius: 12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          if (Utility.isHandsetBySize())
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (!Utility.isHandsetBySize())
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold),
                                ),
                                getButtonWidget(cancelCallback, cancelTitle,
                                    okTitle, okCallback)
                              ],
                            ),
                          // if(type == 0)
                          //   getButtonWidget(cancelCallback, cancelTitle, okTitle, okCallback)
                          //   ],
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          child ?? SizedBox.shrink(),
                          ...?children ?? [],
                          // heichildght == -1 ? child : Container(height: height, child: ),
                          // Expanded( child: child,),
                          SizedBox(
                            height: 30,
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   height: 1,
                          //   color: ColorsConfig.gray_bg,
                          // ),
                          if (Utility.isHandsetBySize())
                            getButtonWidget(cancelCallback, cancelTitle,
                                okTitle, okCallback)

                          // if(type == 1)
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }

  Future<bool> showGroupChatSharingWidgetDialog(
      {required FolderModel folderModel, Function? okCallback}) async {
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        Utility.getGlobalContext(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        shouldShowButtons: false,
        cancelText: getI18NKey().cancel, okCallback: () {
      //校验密码是否正确
      //密码不正确 应该弹出toast checkPassword 已经弹出了 所以没必要在弹出一遍
      // 得到当前密码
      okCallback?.call();
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), true);
      return;
      // }
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), false);
      return;
    },
        okText: getI18NKey().confirm,
        child: Container(
          width: 400,
          child: Column(
            children: [
              GroupChatPermissionSharingWidget(
                folderModel: folderModel,
              )
            ],
          ),
        ));
    if (result == null) {
      return true;
    } else {
      return result;
    }
  }

  Future<bool> showPasswordDialog({String? title, Function? okCallback}) async {
    GlobalKey<PasswordWidgetState>? passwordWidgetStateGlobalKey = GlobalKey();
    // OverlayManagement.getInstance().show
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        Utility.getGlobalContext(),
        cancelText: getI18NKey().cancel, okCallback: () {
      // if (okCallback != null) {
      //校验密码是否正确
      bool res =
          passwordWidgetStateGlobalKey?.currentState?.checkPassword() ?? false;
      //密码不正确 应该弹出toast checkPassword 已经弹出了 所以没必要在弹出一遍
      if (!res) {
        // DialogManagement.getInstance()
        //     .hideDialog(Utility.getGlobalContext(), false);
        return;
      }
      // 得到当前密码
      String password =
          passwordWidgetStateGlobalKey?.currentState?.getOriginPassword() ?? "";
      // this.setDigitPassword(folderId: folderId, password: password);
      okCallback?.call(password);

      return;
      // }
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), false);
      return;
    },
        okText: getI18NKey().confirm,
        child: Container(
          width: 400,
          child: Column(
            children: [
              // Utility.getSVGPicture(R.assetsImgIcSecure, size: 80),
              SizedBox(
                height: 20,
              ),
              Text(
                getI18NKey().please_input_folder_password(title ?? ""),
                style: TextStyle(
                    fontSize: 18,
                    color: ThemeManager.getInstance().getTextColor()),
              ),
              SizedBox(
                height: 20,
              ),
              PasswordWidget(
                key: passwordWidgetStateGlobalKey,
              ),
            ],
          ),
        ));
    if (result == null) {
      return true;
    } else {
      return result;
    }
  }

  /**
   * true表示可以执行 false表示不可以执行
   */
  Future<bool> showSearchFriendGroupWidget(
      {folderId = "", Function? okCallback}) async {
    GlobalKey<SearchFriendGroupWidgetState>? passwordWidgetStateGlobalKey =
        GlobalKey();
    FolderModel? folderModel =
        MongoApisManager.getInstance().queryfolderModelWithFolderId(folderId);
    Future.delayed(Duration(milliseconds: 500), () {
      if (folderModel == null) {
        return;
      }
    });
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        Utility.getGlobalContext(),
        shouldShowButtons: false,
        margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        padding: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
        cancelText: getI18NKey().cancel, okCallback: () {
      //校验密码是否正确
      //密码不正确 应该弹出toast checkPassword 已经弹出了 所以没必要在弹出一遍
      // 得到当前密码
      String password =
          passwordWidgetStateGlobalKey?.currentState?.getOriginPassword() ?? "";
      okCallback?.call(password);
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), true);
      return;
      // }
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), false);
      return;
    },
        okText: getI18NKey().confirm,
        child: Container(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CloseButton(
                  onPressed: () {
                    Navigator.of(Utility.getGlobalContext()).pop();
                  },
                ),
              ),
              // Utility.getSVGPicture(R.assetsImgIcSecure, size: 80),
              Text(
                getI18NKey().join_group_code,
                style: TextStyle(
                    fontSize: 18,
                    color: ThemeManager.getInstance().getTextColor()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getI18NKey().join_group_code_desc,
                style: TextStyle(fontSize: 14, color: Color(0xff999999)),
              ),
              SizedBox(
                height: 20,
              ),
              SearchFriendGroupWidget(
                key: passwordWidgetStateGlobalKey!,
              ),
            ],
          ),
        ));
    if (result == null) {
      return true;
    } else {
      return result;
    }
  }

  Future<bool> showMultiInputDialog(
      {Function? okCallback,
      String? title,
      String? content,
      String? hint}) async {
    String text = "";
    // GlobalKey<CustomMultiInputWidgetState>
    // customMultiInputWidgetStateGlobalKey = GlobalKey();
    // if (TextUtil.isEmpty(folderId) == true) {
    //   return true;
    // }
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        Utility.getGlobalContext(),
        cancelText: getI18NKey().cancel, okCallback: () {
      //密码不正确 应该弹出toast checkPassword 已经弹出了 所以没必要在弹出一遍
      okCallback?.call(text);
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), true);
      return;
      // }
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), false);
      return;
    },
        okText: getI18NKey().confirm,
        child: Container(
          width: 400,
          child: Column(
            children: [
              // Utility.getSVGPicture(R.assetsImgIcAiHelper, size: 80),
              // SizedBox(
              //   height: 20,
              // ),
              if (!TextUtil.isEmpty(title))
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: 18,
                      color: ThemeManager.getInstance().getTextColor()),
                ),
              SizedBox(
                height: 10,
              ),
              if (!TextUtil.isEmpty(content))
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Text(
                    content ?? "",
                    style: TextStyle(fontSize: 14, color: Color(0xff999999)),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: TextField(
                  onChanged: (val) {
                    text = val;
                  },
                  onSubmitted: (val) {
                    text = val;
                    okCallback?.call(text);
                  },
                  // controller: _originPasswordController,
                  //多行
                  maxLines: 100,
                  //左上角
                  textAlign: TextAlign.start,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    filled: true,
                    suffixIcon: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 1.0,
                    ),
                    fillColor:
                        ThemeManager.getInstance().getInputDecorationColor(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: hint ?? "",
                    hintStyle: TextStyle(
                        color: ThemeManager.getInstance()
                            .getInputPlaceholderColor(),
                        fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ));
    if (result == null) {
      return true;
    } else {
      return result;
    }
  }

  Future<bool> showGPTInputDialog(
      {Function? okCallback, String? title, String? content}) async {
    GlobalKey<CustomMultiInputWidgetState>
        customMultiInputWidgetStateGlobalKey = GlobalKey();
    // if (TextUtil.isEmpty(folderId) == true) {
    //   return true;
    // }
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        Utility.getGlobalContext(),
        cancelText: getI18NKey().cancel, okCallback: () {
      //密码不正确 应该弹出toast checkPassword 已经弹出了 所以没必要在弹出一遍
      okCallback
          ?.call(customMultiInputWidgetStateGlobalKey.currentState?.getText());
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), true);
      return;
      // }
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), false);
      return;
    },
        okText: getI18NKey().confirm,
        child: Container(
          width: 400,
          child: Column(
            children: [
              Utility.getSVGPicture(R.assetsImgIcAiHelper, size: 80),
              SizedBox(
                height: 20,
              ),
              if (!TextUtil.isEmpty(title))
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: 18,
                      color: ThemeManager.getInstance().getTextColor()),
                ),
              SizedBox(
                height: 10,
              ),
              if (!TextUtil.isEmpty(content))
                Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Text(
                    content ?? "",
                    style: TextStyle(fontSize: 14, color: Color(0xff999999)),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              CustomMultiInputWidget(
                key: customMultiInputWidgetStateGlobalKey,
              ),
            ],
          ),
        ));
    if (result == null) {
      return true;
    } else {
      return result;
    }
  }

  ButtonBar getButtonWidget(Function? cancelCallback, String? cancelTitle,
      String? okTitle, Function okCallback) {
    return ButtonBar(
      children: [
        cancelCallback == null
            ? SizedBox.shrink()
            : new ElevatedButton(
                child: new Text(cancelTitle ?? getI18NKey().cancel),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        //默认状态使用灰色
                        return Colors.black;
                      },
                    ),
                    //背景颜色
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      //设置按下时的背景颜色
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.white;
                      }
                      //默认不使用背景颜色
                      return Colors.white;
                    }),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 18, color: Colors.black))),
                onPressed: () {
                  cancelCallback();
                },
              ),
        new ElevatedButton(
          child: new Text(okTitle ?? getI18NKey().confirm),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  //默认状态使用灰色
                  return Colors.white;
                },
              ),
              //背景颜色
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                //设置按下时的背景颜色
                if (states.contains(MaterialState.pressed)) {
                  return Colors.red;
                }
                //默认不使用背景颜色
                return Colors.red;
              }),
              textStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 18, color: Colors.red))),
          onPressed: () {
            // Navigator.of(context).pop();
            okCallback();
          },
        )
      ],
    );
  }

  void showFlomoRatingDialogWithOnlyChild(
    BuildContext context, {
    required Widget child,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return child;
        });
  }

  void showRatingDialogWithOnlyChild(
    BuildContext context, {
    required Widget child,
  }) {
    if (this.hasRatingBarShow == true) {
      return;
    }
    hasRatingBarShow = true;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return child;
        });
  }

  void showCustomDialogWithOnlyChild(
    BuildContext context, {
    required Widget child,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return Scaffold(backgroundColor: Colors.transparent, body: child);
        });
  }

  void showCustomDialog(BuildContext context,
      {String? title,
      Widget? child,
      barrierDismissible: true,
      String? okText,
      String? cancelText,
      int color: 0xff61c37d,
      Function? okCallback,
      Function? cancelCallback}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  decoration: StylesConfig.getDecoration(
                    radius: 12,
                  ),
                  child: Column(
                    children: [
                      Text(
                        title ?? "",
                        style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      child ?? SizedBox.shrink(),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: ThemeManager.getInstance().getLineColor(),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    if (cancelCallback != null) {
                                      cancelCallback();
                                    }
                                  },
                                  child: Text(cancelText ?? getI18NKey().refuse,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color(0xffbbbbbb),
                                          fontSize: 15)))),
                          Container(
                            width: 1,
                            height: 40,
                            color: ThemeManager.getInstance().getLineColor(),
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    if (okCallback != null) {
                                      okCallback();
                                    }
                                  },
                                  child: Text(
                                    okText ?? getI18NKey().agree,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: ThemeManager.getInstance()
                                            .getTextColor(
                                                defaultColor:
                                                    ThemeManager.getInstance()
                                                        .getDefautThemeColor()),
                                        fontSize: 15),
                                  )))
                        ],
                      )
                    ],
                  ))
            ],
          );
        });
  }

  void showCopyTextDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? leftText,
    String? rightText,
    OnTapListener? onTapListener,
    Function? okCallBack,
    Function? cancelCallBack,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          title = title ?? "";
          leftText = leftText ?? getI18NKey().cancel;
          rightText = rightText ?? getI18NKey().copy;
          // if (dialogContent == null) {
          return EditTitleDialog(
            isEditable: false,
            title: title,
            content: content,
            leftText: leftText,
            rightText: rightText,
            okCallBack: okCallBack,
            onTapListener: onTapListener,
            cancelCallBack: cancelCallBack,
          );
        });
  }

  void showEditTitleDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? leftText,
    String? rightText,
    String? initVal = "",
    OnTapListener? onTapListener,
    Function? okCallBack,
    Function? cancelCallBack,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          title = title ?? "";
          leftText = leftText ?? getI18NKey().cancel;
          rightText = rightText ?? getI18NKey().confirm;
          // if (dialogContent == null) {
          return EditTitleDialog(
            title: title,
            content: content,
            leftText: leftText,
            initVal: initVal,
            rightText: rightText,
            okCallBack: okCallBack,
            onTapListener: onTapListener,
            cancelCallBack: cancelCallBack,
          );
        });
  }

  void showNineLotteryDialog(
      {required BuildContext context,
      required NineLoterryController nineLotteryController}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return Container(
            height: 500,
            child: SizedBox(
              child: NineLoterryWidget(
                // commodityList: [{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},],
                onPress: () {
                  nineLotteryController.start(2);
// _simpleLotteryController.start(Random().nextInt(8));
                },
                nineLoterryController: nineLotteryController,
              ),
            ),
          );
          ;
        });
  }

  void pushAndReplaceDialog(
      {required BuildContext context, required Widget widget}) {
    DialogManagement.getInstance().hideDialog(context);
    showPCCustomDialog(context: context, widget: widget);
  }

  void showPCCustomDialog(
      {required BuildContext context,
      required Widget widget,
      double? width,
      double? height}) {
    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return Container(
              clipBehavior: Clip.antiAlias,
              height: height,
              decoration: BoxDecoration(
                color: ThemeManager.getInstance().getNavigationBarColor(
                    defaultColor: ColorsConfig.color_background_menu),
                border: Border.all(
                    color: ThemeManager.getInstance().getLineColor(
                        defaultColor: ColorsConfig.color_background_menu),
                    width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              margin: EdgeInsets.all(60),
              child: Scaffold(
                  body: Column(children: [
                Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: ThemeManager.getInstance().getNavigationBarColor(
                          defaultColor: ColorsConfig.color_background_menu),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClosedButton(
                          onTapListener: (res) {
                            Navigator.of(context).pop();
                            // removeNewPageOverlay();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(child: widget),
                SizedBox(
                  height: 15,
                )
              ])));
        });
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return Container(
              margin: EdgeInsets.all(60),
              child: WidgetManager.getLoadingWidget());
        });
  }

  void showMsnDialog(BuildContext context,
      {String? title, Function? okCallback, Function? cancelCallback}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return Container(
              width: 300,
              height: 300,
              constraints: BoxConstraints(maxHeight: 300),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(15),
                        decoration: StylesConfig.getDecoration(
                          radius: 12,
                        ),
                        child: Column(
                          children: [
                            Text(
                              title ?? "",
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MSNWidget(
                              onTapListener: (data) {
                                if (okCallback != null) {
                                  okCallback(data);
                                }
                              },
                            ),
                          ],
                        ))
                  ],
                ),
              ));
        });
  }

  void showRequestCameraPermissiondialog(BuildContext context,
      {Function? okCallback, Function? cancelCallback}) {
    if (Utility.isHuaWei() == true &&
        SharePreferenceUtil.getSyncInstance().getBool(
                key: ShareprefrenceKeys.hasCameraPermissionRequested +
                    Params.curVersion,
                defaultVal: false) ==
            false) {
      SharePreferenceUtil.getSyncInstance().setBool(
          key: ShareprefrenceKeys.hasCameraPermissionRequested +
              Params.curVersion,
          val: true);
      Utility.showAlertDialog(
          context: context,
          content: getI18NKey().camera_permission_description,
          onConfirm: () {
            if (okCallback != null) {
              okCallback();
            }
          });
    }
  }

  void showRequestVoicePermissiondialog(BuildContext context,
      {Function? okCallback, Function? cancelCallback}) {
    if (Utility.isHuaWei() == true &&
        SharePreferenceUtil.getSyncInstance().getBool(
                key: ShareprefrenceKeys.hasMicrophonePermissionRequested +
                    Params.curVersion,
                defaultVal: false) ==
            false) {
      SharePreferenceUtil.getSyncInstance().setBool(
          key: ShareprefrenceKeys.hasMicrophonePermissionRequested +
              Params.curVersion,
          val: true);
      Utility.showAlertDialog(
          context: context,
          content: getI18NKey().microphone_permission_description,
          onConfirm: () {
            if (okCallback != null) {
              okCallback();
            }
          });
    }
  }

  void hideDialog(BuildContext context, [bool? res]) {
    if (res == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(res);
    }
  }

// void showDialog({BuildContext context, Widget widget}) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(height: 500,  child: SizedBox(child:widget,),);
//       });
// }
}
