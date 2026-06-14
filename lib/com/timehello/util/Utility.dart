import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:lunar_calendar_converter_new/lunar_solar_converter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file/open_file.dart';
// import 'package:platform_device_id/platform_device_id.dart';

// import 'package:secverify_plugin/secverify_UIConfig.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/beans/GameRankingBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/BottomCounterWidget.dart';
import 'package:time_hello/com/timehello/components/EventModel.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/BarModel.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/models/ChatGptMessageModelWithExtraData.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/EventCollectionModel.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/models/PresentModel.dart';
import 'package:time_hello/com/timehello/models/ProgressFocusModel.dart';
import 'package:time_hello/com/timehello/models/PushDataModel.dart';
import 'package:time_hello/com/timehello/models/PushDataModelList.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/models/SquareModel.dart';
import 'package:time_hello/com/timehello/models/StartTimeMissionModel.dart';
import 'package:time_hello/com/timehello/models/SubmissionModel.dart';
import 'package:time_hello/com/timehello/page/MobileTabBarHome.dart';
import 'package:time_hello/com/timehello/page/gamesPage/pages/games1/Games1Page.dart';
import 'package:time_hello/com/timehello/page/gamesPage/pages/games4/Games4GridViewPage.dart';
import 'package:time_hello/com/timehello/util/AutoUpdateManager.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/NotificationManager.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';

import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/generated/l10n.dart';
import 'package:time_hello/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import '../../../r.dart';
import '../beans/BaseBean.dart';
import '../beans/CreditCardModel.dart';
import '../beans/GameComparePictureBean.dart';
import '../beans/ReminderModel.dart';
import '../beans/ResourceDeliveryInfoBean.dart';
import '../beans/ResourceLocationInfoBean.dart';
import '../common/provider/GlobalStateEnv.dart';
import '../components/CropImageRoute.dart';
import '../components/NineLoterryWidget.dart';
import '../components/RatingDialog.dart';
import '../config/ColorsConfig.dart';
import '../libs/SFCalendar/src/calendar/common/enums.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';
import '../models/ChatGptMessageModel.dart';
import '../models/CheckButtonStateModel.dart';
import '../models/EndTimeMissionModel.dart';
import '../models/EventFn.dart';
import '../models/GroupModel.dart';
import '../models/SessionMissionModel.dart';
import '../models/TimelineMissionModel.dart';
import '../models/WQBFolderModel.dart';
import '../models/WQBMissionModel.dart';
import '../models/WQBSessionMissionModel.dart';
import '../page/WebviewPage/WebviewPage.dart';
import '../page/WrongQuestionBookPage/WQBMissionDetailpage.dart';
import '../page/gamesPage/components/GameRankingDialogUtil.dart';
import '../page/gamesPage/pages/games2/Games2Page.dart';
import '../page/gamesPage/pages/games2/components/Game2RankingDialogUtil.dart';
import '../page/gamesPage/pages/games3/Games3GridViewPage.dart';
import '../page/gamesPage/pages/games3/Games3Page.dart';
import '../page/gamesPage/pages/games4/Games4Page.dart';
import '../page/missionPage/componnents/MissionPickPeriodDialogWidget.dart';
import 'AudioPlayUtil.dart';
import 'CloudSharepreferenceManagement.dart';
import 'CounterManagement.dart';
import 'EventCollection.dart';
import 'LoginManager.dart';
import 'OverlayManagement.dart';
import 'PermissionManager.dart';
import 'TextUtil.dart';
import 'package:file_selector/file_selector.dart';

// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression/image_compression.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

typedef void OnError(Exception exception);

S getI18NKey([BuildContext? context]) {
  return S.of(context ?? Utility.getGlobalContext());
}

class Utility {
  static setScreenOrientationVertical() {
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  /**
   * 把https换成http
   */
  static filterHttpUrl(String url, {String? prefix}) {
    if (url.startsWith("https")) {
      if (prefix != null && prefix.isNotEmpty)
        url = url.replaceFirst(
            "https://" + (prefix ?? ""), "http://" + (prefix ?? ""));
    }
    return url;
  }

  /**
   * 删除foldermodel的关联uid
   */
  static deleteUserInfoMapByUid(List? uidInfoList, String? uid) {
    for (int i = 0; i < (uidInfoList?.length ?? 0); i++) {
      Map map = uidInfoList?[i] ?? {};
      if (map['uid'] == uid) {
        uidInfoList?.remove(map);
      }
    }
  }

//0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
  /**
   * 获取folderModel的分享状态 1 2 3
   * 别的用户的uid
   */
  static List<FolderModel> getFolderIdsForSharing123OtherUser(
      List<FolderModel> list) {
    List<FolderModel> listTmp = [];
    list.forEach((element) {
      if ((element.isSharing == 3 ||
              element.isSharing == 2 ||
              element.isSharing == 1) &&
          (element.uid != LoginManager.getInstance().userBean.uid)) {
        listTmp.add(element);
      }
    });
    return listTmp;
  }

  //帮我实现一个数组顺序不变 数组去重
  static List<T> removeDuplicates<T>(List<T> list) {
    List<T> uniqueList = [];
    Set<T> seen = {};

    for (T element in list) {
      if (!seen.contains(element)) {
        seen.add(element);
        uniqueList.add(element);
      }
    }

    return uniqueList;
  }

  /**
   * 是否是我的folderModel 用于判断是否删除本身folder或者说是删除FolderModel的otherUids
   */
  static isMyFolderModel({FolderModel? folderModel, String uid = ""}) {
    if (TextUtil.isEmpty(uid)) {
      uid = LoginManager.getInstance().userBean.uid ?? "";
    }
    //如果otherUid有那就是加入的
    if (folderModel?.uid != uid) {
      return false;
    } else {
      return true;
    }
  }

  static Map getLatestExpireDateOfReceipt(List list, List<String> productIds) {
    int latestExpireDate = 0;
    String productId = "";
    String originalTransactionId = "";
    list.forEach((element) {
      // if (element['expires_date_ms']) {
      if (element['expires_date_ms'] != null &&
          productIds.contains(element['product_id']) == true) {
        latestExpireDate =
            max(latestExpireDate, int.parse(element['expires_date_ms']));
        productId = element['product_id'];
        originalTransactionId = element['original_transaction_id'];
      }
      // }
    });
    return {
      "latestExpireDate": latestExpireDate,
      "productId": productId,
      "originalTransactionId": originalTransactionId
    };
  }
  //
  // /**
  //  * folderModel是否可编辑
  //  */
  // static isFolderModelEnabled({String? folderId, String uid = ""}) {
  //   if (TextUtil.isEmpty(uid)) {
  //     uid = LoginManager.getInstance().userBean.uid ?? "";
  //   }
  //   FolderModel? folderModel =
  //       MongoApisManager.getInstance().getFolderModelByFolderId(folderId ?? "");
  //   print(
  //       "folderId:${folderId} ${folderModel?.isSharing} isOtherUserEditable:${folderModel?.isOtherUserEditable} uid:${folderModel?.otherUids?.contains(uid)}");
  //   if (folderModel?.isSharing == 2 &&
  //       folderModel?.isOtherUserEditable == false) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  static setScreenOrientationHorizontal() {
    SystemChrome.setPreferredOrientations([
      // 强制横屏
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  /**
   * 分享课程code时用得上 方便对方输入
   * 随机生成n位整数字符串
   */
  static String generateRandomNDigitString(int n) {
    Random random = new Random();
    int min = pow(10, n - 1).toInt();
    int max = pow(10, n).toInt() - 1;
    int randomNumber = min + random.nextInt(max - min);
    return randomNumber.toString();
  }

  /**
   * CTR可以解密
   */
  // static decryptCTRAES(encryptedText, String keyTmp) {
  //   final key = encrypt.Key.fromUtf8(keyTmp);
  //   final iv = encrypt.IV.fromLength(16);
  //   final encrypter = encrypt.Encrypter(encrypt.AES(key));
  //   encrypt.Encrypted encrypted = encrypter.encrypt(encryptedText, iv: iv);
  //   return encrypter.decrypt(encrypted, iv: iv);
  // }

  static String decryptCTRAES(String encryptedText, String keyTmp) {
    final key = encrypt.Key.fromUtf8(keyTmp);
    final iv = encrypt.IV.fromUtf8(Params.AES_IV);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

  /**
   * CTR可以加密
   */
  static String encryptCTRAES(String plainText, String keyTmp) {
    final key = encrypt.Key.fromUtf8(keyTmp);
    final iv = encrypt.IV.fromUtf8(Params.AES_IV);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    encrypt.Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static ResourceLocationInfoBean? getResourceDeliveryItemFromList(
      String key, List<ResourceLocationInfoBean> list) {
    for (int i = 0; i < list.length; i++) {
      ResourceLocationInfoBean bean = list[i];
      if ((bean.locationCode?.trim() ?? "") == key) {
        return bean;
      }
    }
    return null;
  }

  static int getHexStringToDec(String hex) {
    return int.parse(hex, radix: 16);
  }

  static ResourceDeliveryInfoBean? getDeliveryInfoBean(
      {required List<ResourceLocationInfoBean> response,
      required String key,
      required String code}) {
    List<ResourceDeliveryInfoBean>? deliveryList =
        Utility.getResourceDeliveryItemFromList(key, response)?.deliveryList ??
            [];
    if (deliveryList != null) {
      ResourceDeliveryInfoBean? deliveryInfoBean =
          Utility.getResourceDeliveryInfoBeanByKey(deliveryList, code);
      if (deliveryInfoBean != null) {
        return deliveryInfoBean;
      }
    }
    return null;
  }

  static List<MusicModel> parseResourceBeansToMusicModels(
      List<ResourceDeliveryInfoBean> list) {
    if (list == null) return [];
    List<MusicModel> listTmp = [];
    for (int i = 0; i < list.length; i++) {
      ResourceDeliveryInfoBean bean = list[i];
      listTmp.add(new MusicModel(
          title: TextUtil.isEmpty(bean?.resourceTitle ?? '')
              ? (bean?.deliveryName ?? "")
              : (bean?.resourceTitle ?? ""),
          url: bean.resourcePictureUrl ?? ""));
    }
    return listTmp;
  }

  static ResourceDeliveryInfoBean? getResourceDeliveryInfoBeanByKey(
      List<ResourceDeliveryInfoBean> list, String key) {
    for (int i = 0; i < list.length; i++) {
      ResourceDeliveryInfoBean item = list[i];
      if (item.deliveryName == key) {
        return item;
      }
    }
    return null;
  }

  /**
   * 解析资源位数据
   */
  static List<GameComparePictureBean> parseGameComparePictureBean(
      List<dynamic> list,
      {double? screenWidth,
      double? screenHeight}) {
    List<GameComparePictureBean> listGameComparePictureBean = [];
    list.forEach((i) {
      GameComparePictureBean bean = GameComparePictureBean.fromJson(i);
      GameComparePictureBean.parseData(bean,
          screenWidth: screenWidth, screenHeight: screenHeight);
      listGameComparePictureBean.add(bean);
    });
    return listGameComparePictureBean;
  }

  static void startLottery() {
    final NineLoterryController _simpleLotteryController =
        NineLoterryController();
    _simpleLotteryController.start(5); //开启
    Center(
      child: NineLoterryWidget(
        // commodityList: [{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"},{"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}, {"prize_img": "http://fsclould.timerbell.com/20220926-game_avatar.png"}],
        onPress: () {
          _simpleLotteryController.start(5);
// _simpleLotteryController.start(Random().nextInt(8));
        },
        nineLoterryController: _simpleLotteryController,
      ),
    );
  }

  /**
   * 解析资源位数据
   */
  static List<ResourceLocationInfoBean> parseResourceBean(List<dynamic> list) {
    List<ResourceLocationInfoBean> listResourceLocationInfoBean = [];
    try {
      list.forEach((i) {
        i['isCheck'] = false;
        ResourceLocationInfoBean bean = ResourceLocationInfoBean.fromJson(i);
        List<ResourceDeliveryInfoBean> list = [];
        bean.deliveryList = list;
        // bean.deliveryList = map.toList();;
        ResourceLocationInfoBean resourceLocationInfoBean =
            ResourceLocationInfoBean.fromJson(i);

        resourceLocationInfoBean.deliveryList
            ?.forEach((resourceDeliveryInfoBean) {
          // ResourceDeliveryInfoBean resourceDeliveryInfoBean = ResourceDeliveryInfoBean.fromJson(t);
          if (resourceDeliveryInfoBean.extendParamsString != null) {
            resourceDeliveryInfoBean.extendParamsMap = TextUtil.isEmpty(
                    resourceDeliveryInfoBean.extendParamsString)
                ? null
                : jsonDecode(resourceDeliveryInfoBean.extendParamsString ?? "");
          }
          list.add(resourceDeliveryInfoBean);
        });

        listResourceLocationInfoBean.add(resourceLocationInfoBean);
      });
    } catch (e) {
      print(e);
    }
    return listResourceLocationInfoBean;
  }

  /**
   * 按时间排序
   */
  // static List<SessionMissionModel>
  // parseMissionModelsToSessionMissionMidelListByDateTime(
  //     List<MissionModel> list) {
  //   List<SessionMissionModel> listTmp = [];
  //   List<String> listKeys = [];
  //
  //   list.sort((MissionModel a, MissionModel b) {
  //     return (a.end_time ?? 0) > (b.end_time ?? 0)
  //         ? -1
  //         : (a.end_time ?? 0) < (b.end_time ?? 0)
  //         ? 1
  //         : 0;
  //   });
  //
  //   list.forEach((MissionModel element) {
  //     DateTime dateTime =
  //     Utility.getDateTimeFromTimeStamp(element.end_time ?? 0); //有可能空的情况
  //     if (listKeys.indexOf(getI18NKey().missionModelDate(
  //         dateTime.year,
  //         dateTime.month,
  //         dateTime.day,
  //         CONSTANTS.getTextFromDayOfWeek(dateTime.weekday))) ==
  //         -1) {
  //       listKeys.add(getI18NKey().missionModelDate(
  //           dateTime.year,
  //           dateTime.month,
  //           dateTime.day,
  //           CONSTANTS.getTextFromDayOfWeek(dateTime.weekday)));
  //     }
  //   });
  //
  //   listKeys.forEach((elementKey) {
  //     SessionMissionModel sessionMissionModel = SessionMissionModel();
  //     List<MissionModel> listMissionModel = [];
  //     sessionMissionModel.title = elementKey;
  //     list.forEach((MissionModel elementMissionModel) {
  //       DateTime dateTime =
  //       Utility.getDateTimeFromTimeStamp(elementMissionModel.end_time ?? 0);
  //       if (elementKey ==
  //           getI18NKey().missionModelDate(
  //               dateTime.year,
  //               dateTime.month,
  //               dateTime.day,
  //               CONSTANTS.getTextFromDayOfWeek(dateTime.weekday))) {
  //         listMissionModel.add(elementMissionModel);
  //       }
  //     });
  //     listMissionModel.sort((MissionModel a, MissionModel b) {
  //       return a.title?.compareTo(b.title ?? "") ?? 0;
  //     });
  //     sessionMissionModel.datas = listMissionModel;
  //     listTmp.add(sessionMissionModel);
  //   });
  //   return listTmp;
  // }
  /**
   * 按时间排序
   */
  static List<WQBSessionMissionModel>
      parseWQBMissionModelsToSessionMissionMidelListByDateTime(
          List<WQBMissionModel> list) {
    List<WQBSessionMissionModel> listTmp = [];
    List<String> listKeys = [];

    list.sort((WQBMissionModel a, WQBMissionModel b) {
      return (a.update_time ?? 0) > (b.update_time ?? 0)
          ? -1
          : (a.update_time ?? 0) < (b.update_time ?? 0)
              ? 1
              : 0;
    });

    list.forEach((WQBMissionModel element) {
      DateTime dateTime =
          Utility.getDateTimeFromTimeStamp(element.update_time ?? 0); //有可能空的情况
      if (listKeys.indexOf(getI18NKey().missionModelDate(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              CONSTANTS.getTextFromDayOfWeek(dateTime.weekday))) ==
          -1) {
        listKeys.add(getI18NKey().missionModelDate(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            CONSTANTS.getTextFromDayOfWeek(dateTime.weekday)));
      }
    });

    listKeys.forEach((elementKey) {
      WQBSessionMissionModel sessionMissionModel = WQBSessionMissionModel();
      List<WQBMissionModel> listMissionModel = [];
      sessionMissionModel.title = elementKey;
      list.forEach((WQBMissionModel elementMissionModel) {
        DateTime dateTime = Utility.getDateTimeFromTimeStamp(
            elementMissionModel.update_time ?? 0);
        if (elementKey ==
            getI18NKey().missionModelDate(
                dateTime.year,
                dateTime.month,
                dateTime.day,
                CONSTANTS.getTextFromDayOfWeek(dateTime.weekday))) {
          listMissionModel.add(elementMissionModel);
        }
      });
      listMissionModel.sort((WQBMissionModel a, WQBMissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  /**
   * 按时间排序
   */
  static List<SessionMissionModel>
      parseMissionModelsToSessionMissionMidelListByDateTime(
          List<MissionModel> list) {
    List<SessionMissionModel> listTmp = [];
    List<String> listKeys = [];
    // 时间从早到晚
    list.sort((MissionModel a, MissionModel b) {
      return (a.end_time ?? 0) < (b.end_time ?? 0)
          ? -1
          : (a.end_time ?? 0) > (b.end_time ?? 0)
              ? 1
              : 0;
    });

    list.forEach((MissionModel element) {
      DateTime dateTime =
          Utility.getDateTimeFromTimeStamp(element.end_time ?? 0); //有可能空的情况
      if (listKeys.indexOf(getI18NKey().missionModelDate(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              CONSTANTS.getTextFromDayOfWeek(dateTime.weekday))) ==
          -1) {
        listKeys.add(getI18NKey().missionModelDate(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            CONSTANTS.getTextFromDayOfWeek(dateTime.weekday)));
      }
    });
    DateTime dateTime1970 = Utility.getDateTimeFromTimeStamp(0);
    String date1970 = getI18NKey().missionModelDate(
        dateTime1970.year,
        dateTime1970.month,
        dateTime1970.day,
        CONSTANTS.getTextFromDayOfWeek(dateTime1970.weekday));
    listKeys.forEach((elementKey) {
      // DateTime? dateTimeFirstMission = null;
      SessionMissionModel sessionMissionModel = SessionMissionModel();
      List<MissionModel> listMissionModel = [];
      sessionMissionModel.title =
          elementKey == date1970 ? getI18NKey().others : elementKey;
      list.forEach((MissionModel elementMissionModel) {
        DateTime dateTime =
            Utility.getDateTimeFromTimeStamp(elementMissionModel.end_time ?? 0);
        // if(dateTimeFirstMission == null) {
        //   dateTimeFirstMission = dateTime;
        // }
        if (elementKey ==
            getI18NKey().missionModelDate(
                dateTime.year,
                dateTime.month,
                dateTime.day,
                CONSTANTS.getTextFromDayOfWeek(dateTime.weekday))) {
          listMissionModel.add(elementMissionModel);
        }
      });
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      // if(dateTimeFirstMission != null) {
      //   //用于判断认为是否延期 需要递延
      //   sessionMissionModel.date =
      //       getFilterDateTimeFromDateTime(dateTimeFirstMission!);
      // }

      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    listTmp.forEach((element) {
      int? end_time = element.datas?[0].end_time;
      if (end_time != null) {
        element.date = getFilterDateTimeFromTimeStamp(end_time!);
      }
    });
    return listTmp;
  }

  static isDelayed(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year < now.year) {
      return true;
    } else if (dateTime.year == now.year) {
      if (dateTime.month < now.month) {
        return true;
      } else if (dateTime.month == now.month) {
        if (dateTime.day < now.day) {
          return true;
        }
      }
    }
    return false;
  }

  static print(obj) {
    // if (isProductEnv() == false) {
    //   if (obj != null) {
    //     print(obj.toString());
    //   }
    // }
  }

  static List<WQBSessionMissionModel>
      parseWQBMissionModelsToSessionMissionMidelListByTag(
          List<WQBMissionModel> listModels,
          List<WQBFolderModel> listTagsFolderModels) {
    List<WQBSessionMissionModel> listTmp = [];
    List<String> listKeys = [];

    listTagsFolderModels.forEach((WQBFolderModel folderModel) {
      if (folderModel.tag == 2) {
        listKeys.add(folderModel?.title ?? "");
      }
    });

    // listModels.forEach((MissionModel element) {
    //   if (listKeys.indexOf(element.priorityStatus ?? 3) == -1) {
    //     listKeys.add(element.priorityStatus ?? 3);
    //   }
    // });
    listKeys.sort((String a, String b) {
      return a?.compareTo(b ?? "") ?? 0;
    });
    listKeys.add(getI18NKey().others);
    listKeys.forEach((elementKey) {
      WQBSessionMissionModel sessionMissionModel = WQBSessionMissionModel();
      List<WQBMissionModel> listMissionModel = [];
      sessionMissionModel.title = elementKey;
      listModels.forEach((WQBMissionModel elementMissionModel) {
        List tags = elementMissionModel?.tagNames ?? [];
        if (tags?.contains(elementKey) == true) {
          listMissionModel.add(elementMissionModel);
        } else if (elementKey == getI18NKey().others &&
            TextUtil.isEmpty(elementMissionModel?.tagNames) == true) {
          listMissionModel.add(elementMissionModel);
        } else {
          if (listKeys.indexOf(
                      elementMissionModel?.tagNames?.join(',') ?? "") ==
                  -1 &&
              elementKey == getI18NKey().others) {
            listMissionModel.add(elementMissionModel);
            print(111111);
          }
        }
      });
      listMissionModel.sort((WQBMissionModel a, WQBMissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  static List<GroupModel> orderGroupModel(
      {required List<String> listOrderId,
      required List<GroupModel> listGroupModel,
      required List<MissionModel> listMissionModel}) {
    List<GroupModel> listGroupModelTmp = [];
    GroupModel groupModelOthers = GroupModel();
    groupModelOthers.title = getI18NKey().unorder_group;
    // groupModel?.id = "";
    //   groupModel?.datas = [];
    // 重置groupModel的missionModelList
    listGroupModel.forEach((element) {
      element?.missionModelList = [];
    });

    listMissionModel.forEach((MissionModel element) {
      GroupModel? groupModelTmp =
          getGroupModelByOrderId(element?.group_id ?? "", listGroupModel);
      if (groupModelTmp?.missionModelList == null) {
        groupModelTmp?.missionModelList = [];
      }
      if (groupModelTmp == null) {
        groupModelOthers?.missionModelList?.add(element);
      } else {
        groupModelTmp?.missionModelList?.add(element);
      }
    });

    listGroupModelTmp.add(groupModelOthers);
    // List<GroupModel> listGroupModelTmpToRemove = [];
    listOrderId.forEach((element) {
      GroupModel? groupModelTmp =
          getGroupModelByOrderId(element, listGroupModel);
      if (groupModelTmp != null) {
        listGroupModelTmp.add(groupModelTmp);
        listGroupModel.remove(groupModelTmp);
      }
    });
    listGroupModelTmp.addAll(listGroupModel);

    listGroupModelTmp.forEach((GroupModel groupModel) {
      groupModel.missionModelList = orderMissionModel(
          listOrderId: groupModel?.missionModelObjectIdOrderList ?? [],
          listMissionModel: groupModel.missionModelList ?? []);
    });
    return listGroupModelTmp;
  }

  //两个groupmodel list title一样的情况下把后面groupmodel的objectId给前面的
  static List<GroupModel> orderGroupModelByTitle(
      {required List<GroupModel> listGroupModel1,
      required List<GroupModel> listGroupModel2}) {
    List<GroupModel> listGroupModelTmp = [];
    listGroupModel1.forEach((element1) {
      listGroupModel2.forEach((element2) {
        if (element1.title == element2.title) {
          element1.objectId = element2.objectId;
        }
      });
    });
    return listGroupModelTmp;
  }

  static List<MissionModel> orderMissionModel(
      {required List<String> listOrderId,
      required List<MissionModel> listMissionModel}) {
    List<MissionModel> listMissionModelTmp = [];
    List<MissionModel> listMissionModelTmpToRemove = [];
    listOrderId.forEach((element) {
      MissionModel? missionModelTmp =
          getMissionModelByOrderId(element, listMissionModel);
      if (missionModelTmp != null) {
        listMissionModelTmp.add(missionModelTmp);
        listMissionModelTmpToRemove.add(missionModelTmp);
      }
    });
    listMissionModelTmpToRemove.forEach((element) {
      listMissionModel.remove(element);
    });
    // 当分组没有持久化顺序列表时，退回到 order_index，
    // 这样未分组任务在拖拽后刷新仍能保持相对顺序。
    listMissionModel.sort((MissionModel a, MissionModel b) {
      final int orderA = a.order_index ?? 0;
      final int orderB = b.order_index ?? 0;
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      }
      return (a.createdAt ?? "")
          .toString()
          .compareTo((b.createdAt ?? "").toString());
    });
    listMissionModelTmp.addAll(listMissionModel);
    return listMissionModelTmp;
  }

  static MissionModel? getMissionModelByOrderId(
      String orderId, List<MissionModel> listMissionModel) {
    // MissionModel? missionModel = MissionModel();
    for (int i = 0; i < listMissionModel.length; i++) {
      if (listMissionModel[i]?.objectId == orderId) {
        return listMissionModel[i];
      }
    }
    return null;
  }

  static GroupModel? getGroupModelByOrderId(
      String orderId, List<GroupModel> listGroupModel) {
    // GroupModel? groupModel = GroupModel();
    for (int i = 0; i < listGroupModel.length; i++) {
      if (listGroupModel[i]?.objectId == orderId) {
        return listGroupModel[i];
      }
    }
    return null;
  }

  static List<SessionMissionModel>
      parseMissionModelsToSessionMissionMidelListByTag(
          List<MissionModel> listModels,
          List<FolderModel> listTagsFolderModels) {
    List<SessionMissionModel> listTmp = [];
    List<String> listKeys = [];

    listTagsFolderModels.forEach((FolderModel folderModel) {
      if (folderModel.tag == 2) {
        listKeys.add(folderModel?.title ?? "");
      }
    });

    // listModels.forEach((MissionModel element) {
    //   if (listKeys.indexOf(element.priorityStatus ?? 3) == -1) {
    //     listKeys.add(element.priorityStatus ?? 3);
    //   }
    // });
    listKeys.sort((String a, String b) {
      return a?.compareTo(b ?? "") ?? 0;
    });
    listKeys.add(getI18NKey().others);
    listKeys.forEach((elementKey) {
      SessionMissionModel sessionMissionModel = SessionMissionModel();
      List<MissionModel> listMissionModel = [];
      sessionMissionModel.title = elementKey;
      listModels.forEach((MissionModel elementMissionModel) {
        List<String> tags = elementMissionModel?.tagNames?.split(",") ?? [];
        if (tags?.contains(elementKey) == true) {
          listMissionModel.add(elementMissionModel);
        } else if (elementKey == getI18NKey().others &&
            TextUtil.isEmpty(elementMissionModel?.tagNames) == true) {
          listMissionModel.add(elementMissionModel);
        } else {
          if (listKeys.indexOf(elementMissionModel?.tagNames ?? "") == -1 &&
              elementKey == getI18NKey().others) {
            listMissionModel.add(elementMissionModel);
            print(111111);
          }
        }
      });
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  /**
   * 根据优先级排序
   */
  static List<WQBSessionMissionModel>
      parseWQBMissionModelsToSessionMissionMidelListByPriority(
          List<WQBMissionModel> listModels) {
    List<WQBSessionMissionModel> listTmp = [];
    List<int> listKeys = [];
    listModels.forEach((WQBMissionModel element) {
      if (listKeys.indexOf(element.priorityStatus ?? 3) == -1) {
        listKeys.add(element.priorityStatus ?? 3);
      }
    });
    listKeys.sort((int a, int b) {
      return a < b
          ? -1
          : a > b
              ? 1
              : 0;
    });
    listKeys.forEach((elementKey) {
      WQBSessionMissionModel sessionMissionModel = WQBSessionMissionModel();
      List<WQBMissionModel> listMissionModel = [];
      sessionMissionModel.title = CONSTANTS.getPriorityByIndex(elementKey);
      listModels.forEach((WQBMissionModel elementMissionModel) {
        if (elementKey == (elementMissionModel.priorityStatus ?? 3)) {
          listMissionModel.add(elementMissionModel);
        }
      });
      listMissionModel.sort((WQBMissionModel a, WQBMissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  /**
   * 根据isFinished 优先级priorityStatus排序 然后根据title排序
   */
  static List<MissionModel> parseMissionModelsByIsFinishedAndPriority(
      List<MissionModel> listModels) {
    listModels.sort((a, b) {
      int compare = ((a.priorityStatus ?? 3) > (b.priorityStatus ?? 3))
          ? 1
          : (a?.priorityStatus ?? 3) == (b?.priorityStatus ?? 3)
              ? 0
              : -1;
      return compare;
    });
    listModels.sort((a, b) {
      int compare = a?.isFinished == true ? 1 : -1;
      return compare;
      // compare = ((a.priorityStatus ?? 0) > (b.priorityStatus ?? 0)) ? 1 : (a?.priorityStatus ?? 0) == (b?.priorityStatus  ?? 0) ? 0 : -1;
      // if (compare != 0) return compare;
      // return a.title?.compareTo(b.title ?? "") ?? 0;
    });
    return listModels;
  }

  // static List<MissionModel> parseMissionModelsByPriority(
  //     List<MissionModel> listModels) {
  //   List<int> listKeys = [];
  //   listModels.forEach((MissionModel element) {
  //     if (listKeys.indexOf(element.priorityStatus ?? 3) == -1) {
  //       listKeys.add(element.priorityStatus ?? 3);
  //     }
  //   });
  //   listKeys.sort((int a, int b) {
  //     return a < b
  //         ? -1
  //         : a > b
  //         ? 1
  //         : 0;
  //   });
  //   return listModels;
  // }

  static bool isObjectiveForMissionModel({required MissionModel missionModel}) {
    if (missionModel.time_mode == 2) {
      return true;
    }
    return false;
  }

  /**
   * 根据优先级排序
   */
  static List<SessionMissionModel>
      parseMissionModelsToSessionMissionMidelListByPriority(
          List<MissionModel> listModels) {
    List<SessionMissionModel> listTmp = [];
    List<int> listKeys = [];
    listModels.forEach((MissionModel element) {
      if (listKeys.indexOf(element.priorityStatus ?? 3) == -1) {
        listKeys.add(element.priorityStatus ?? 3);
      }
    });
    listKeys.sort((int a, int b) {
      return a < b
          ? -1
          : a > b
              ? 1
              : 0;
    });
    listKeys.forEach((elementKey) {
      SessionMissionModel sessionMissionModel = SessionMissionModel();
      List<MissionModel> listMissionModel = [];
      sessionMissionModel.title = CONSTANTS.getPriorityByIndex(elementKey);
      listModels.forEach((MissionModel elementMissionModel) {
        if (elementKey == (elementMissionModel.priorityStatus ?? 3)) {
          listMissionModel.add(elementMissionModel);
        }
      });
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  // int? tag; //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来 -1  未归类 -2 苹果日历 -3 苹果提醒
  static String getFolderTitleByFid(
      String fid, List<FolderModel> listFolderModel, List<int> tag) {
    for (int i = 0; i < listFolderModel.length; i++) {
      FolderModel model = listFolderModel[i];
      if (model.objectId == fid &&
          (tag == null || tag.indexOf(model.tag ?? 0) != -1)) {
        return model.title ?? "";
      }
    }
    if (fid == "-2") {
      return getI18NKey().apple_calendar;
    } else if (fid == "-3") {
      return getI18NKey().apple_alarm;
    }
    return getI18NKey().unorder_folderlist;
  }

  static bool isContainOtherFolder(List<String> listTitles) {
    for (int i = 0; i < listTitles.length; i++) {
      if (listTitles[i] == getI18NKey().unorder_folderlist) {
        return true;
      }
    }
    return false;
  }

  static String getWQBFolderTitleByFid(
      String fid, List<WQBFolderModel> listFolderModel) {
    for (int i = 0; i < listFolderModel.length; i++) {
      WQBFolderModel model = listFolderModel[i];
      if (model.objectId == fid) {
        return model.title ?? "";
      }
    }
    return getI18NKey().unorder_folderlist;
  }

  // static String getFolderIdByTitle(String title, List<FolderModel> listFolderModel) {
  //   for (int i = 0; i< listFolderModel.length; i++) {
  //     FolderModel model = listFolderModel[i];
  //     if (model.title == title) {
  //       return model.id;
  //     }
  //   }
  //   return "";
  // }

  static FolderModel? getFolderModelByTitle(
      {required List<FolderModel> listFolderModel, required String title}) {
    for (int i = 0; i < listFolderModel.length; i++) {
      FolderModel folderModel = listFolderModel[i];
      if (folderModel.title == title) {
        return folderModel;
      }
    }
    return null;
  }

  /**
   * folderStatus -1 表示所有的folder 0-表示未完成的folder 1-表示已完成的folder
   */
  static List<SessionMissionModel>
      parseMissionModelsToSessionMissionMidelListByFolderName(
          List<MissionModel> list, List<FolderModel> listFolderModel,
          [int folderStatus = -1]) {
    List<SessionMissionModel> listTmp = [];
    List<String> listKeysTitle = [];
    List<FolderModel> listFolderModelTmp = [];

    if (folderStatus == -1) {
      listFolderModelTmp = listFolderModel;
    } else {
      listFolderModel.forEach((element) {
        if (element.folderStatus == null) {
          // 0-归档 1-未归档
          element.folderStatus = 0;
        }
        if (element.folderStatus == folderStatus) {
          listFolderModelTmp.add(element);
        }
      });
    }
    listFolderModel = listFolderModelTmp;

    listFolderModel.forEach((FolderModel element) {
      if (listKeysTitle.indexOf(getFolderTitleByFid(
              element.objectId ?? '', listFolderModel, [1])) ==
          -1) {
        listKeysTitle.add(
            getFolderTitleByFid(element.objectId ?? '', listFolderModel, [1]));
      } else if (listKeysTitle.indexOf(getFolderTitleByFid(
              element.objectId ?? '', listFolderModel, [5])) ==
          -1) {
        listKeysTitle.add(
            getFolderTitleByFid(element.objectId ?? '', listFolderModel, [5]));
      }
    });
    listKeysTitle.sort();
    listKeysTitle
        .removeWhere((element) => element == getI18NKey().apple_calendar);
    listKeysTitle.removeWhere((element) => element == getI18NKey().apple_alarm);
    // listKeysTitle.add(getFolderTitleByFid("-2", listFolderModel, 1));
    // listKeysTitle.add(getFolderTitleByFid("-3", listFolderModel, 1));
    // 苹果日历
    if (DeviceInfoManagement.isIOS() == true ||
        DeviceInfoManagement.isMacOs() == true)
      listKeysTitle.add(getFolderTitleByFid("-2", listFolderModel, [1]));
    // 苹果提醒
    if (DeviceInfoManagement.isIOS() == true ||
        DeviceInfoManagement.isMacOs() == true)
      listKeysTitle.add(getFolderTitleByFid("-3", listFolderModel, [1]));

    listKeysTitle
        .removeWhere((element) => element == getI18NKey().unorder_folderlist);

    // if(isContainOtherFolder(listKeysTitle) == false) {
    listKeysTitle.add(getFolderTitleByFid("-1", listFolderModel, [1]));
    // listKeysTitle.add(getFolderTitleByFid("-1", listFolderModel, 5));
    // }

    listKeysTitle.forEach((elementTitle) {
      // if(elementTitle == getI18NKey().apple_calendar || elementTitle == getI18NKey().apple_alarm) {
      //   print("1");
      // }
      SessionMissionModel sessionMissionModel = SessionMissionModel();
      List<MissionModel> listMissionModel = [];
      sessionMissionModel.title = elementTitle;
      FolderModel? folderModel = getFolderModelByTitle(
              listFolderModel: listFolderModel, title: elementTitle) ??
          null;
      sessionMissionModel.folder_id = folderModel?.objectId ?? '';
      sessionMissionModel.color = folderModel?.color ?? 0xffff8800;
      list.forEach((MissionModel element) {
        if (elementTitle?.indexOf("测试") != -1) {
          print("1");
        }
        if (element.title?.indexOf("123") != -1) {
          print("1");
        }
        if (elementTitle?.indexOf("测试") != -1 &&
            element.title?.indexOf("123") != -1) {
          print("1");
        }
        if (elementTitle?.indexOf("测试") != -1 &&
            element.title?.indexOf("q") != -1) {
          print("1");
        }
        if (elementTitle?.indexOf("未归类清单") != -1 &&
            element.title?.indexOf("q") != -1) {
          print("1");
        }
        if (element.missionModelType == 1 &&
            elementTitle == getI18NKey().apple_calendar &&
            (DeviceInfoManagement.isIOS() || DeviceInfoManagement.isMacOs())) {
          listMissionModel.add(element);
        } else if (element.missionModelType == 2 &&
            elementTitle == getI18NKey().apple_alarm &&
            (DeviceInfoManagement.isIOS() || DeviceInfoManagement.isMacOs())) {
          listMissionModel.add(element);
        } else if (elementTitle ==
                getFolderTitleByFid(
                    element.folder_id ?? '', listFolderModel, [1, 5]) &&
            element.missionModelType != 1 &&
            element.missionModelType != 2) {
          listMissionModel.add(element);
        }
        // else if (elementTitle ==
        //     getFolderTitleByFid(element.folder_id ?? '', listFolderModel, [5]) && element.missionModelType != 1 && element.missionModelType != 2) {
        //   listMissionModel.add(element);
        // }
      });
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  /// 根据不同日期返回不同格式的字符串
  /// 今天返回"今天"，昨天返回"昨天"，明天返回"明天"
  /// 如果是今年(但不是今/昨/明)返回"月/日"
  /// 如果不是今年返回"年/月/日"
  static String getFormattedDate(DateTime dateTime) {
    // 获取当前日期用于比较
    DateTime now = DateTime.now();

    // 创建今天、昨天和明天的日期对象(不含时分秒)
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime tomorrow = today.add(Duration(days: 1));

    // 获取不含时分秒的输入日期
    DateTime dateWithoutTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    // 检查是否为今天、昨天或明天
    if (dateWithoutTime.isAtSameMomentAs(today)) {
      return getI18NKey().today;
    } else if (dateWithoutTime.isAtSameMomentAs(yesterday)) {
      return getI18NKey().yesterday;
    } else if (dateWithoutTime.isAtSameMomentAs(tomorrow)) {
      return getI18NKey().tomorrow;
    }

    // 检查是否是今年的日期
    if (dateTime.year == now.year) {
      return "${dateTime.month}/${dateTime.day}";
    }

    // 不是今年的日期，返回完整年月日
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }

  /**
   *
   */
  static String formatToTwoDecimalPlaces(double value) {
    return value.toStringAsFixed(2);
  }

  /**
   * 判断任务是否归档
   */
  static bool isMissionModelArchive(MissionModel missionModel) {
    List<FolderModel> list = MongoApisManager.getInstance().listFolderModels;
    for (int i = 0; i < list.length; i++) {
      FolderModel folderModel = list[i];
      if (folderModel.objectId == missionModel.folder_id &&
          folderModel.folderStatus == 1) {
        return true;
      }
    }
    return false;
  }

  static List<WQBSessionMissionModel>
      parseWQBMissionModelsToSessionMissionMidelListByFolderName(
          List<WQBMissionModel> list, List<WQBFolderModel> listFolderModel) {
    List<WQBSessionMissionModel> listTmp = [];
    List<String> listKeysTitle = [];
    listFolderModel.forEach((WQBFolderModel element) {
      if (listKeysTitle.indexOf(getWQBFolderTitleByFid(
              element.objectId ?? '', listFolderModel)) ==
          -1) {
        listKeysTitle.add(
            getWQBFolderTitleByFid(element.objectId ?? '', listFolderModel));
      }
    });
    listKeysTitle.add(getWQBFolderTitleByFid("-1", listFolderModel));

    listKeysTitle.sort();
    listKeysTitle.forEach((elementTitle) {
      WQBSessionMissionModel sessionMissionModel = WQBSessionMissionModel();
      List<WQBMissionModel> listMissionModel = [];
      sessionMissionModel.title = elementTitle;
      list.forEach((WQBMissionModel element) {
        if (elementTitle ==
            getWQBFolderTitleByFid(element.folder_id ?? '', listFolderModel)) {
          listMissionModel.add(element);
        }
      });
      listMissionModel.sort((WQBMissionModel a, WQBMissionModel b) {
        return a.title?.compareTo(b.title ?? "") ?? 0;
      });
      sessionMissionModel.datas = listMissionModel;
      listTmp.add(sessionMissionModel);
    });
    return listTmp;
  }

  static Color darken(
    Color color, [
    int percent = 40,
  ]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(color.alpha, (color.red * value).round(),
        (color.green * value).round(), (color.blue * value).round());
  }

  static Path drawPathArc(
    Path path, {
    required double centerX,
    required double centerY,
    required double radius,
    required double startAngle,
    required double sweepAngle,
  }) {
    path.arcTo(
        Rect.fromLTRB(centerX - radius, centerY - radius, centerX + radius,
            centerY + radius),
        startAngle * math.pi * 2 / 360,
        sweepAngle * math.pi * 2 / 360,
        true);
    return path;
  }

  /**
   * 把文件尺寸换成byte
   */
  static String formatBytes(int size, [int fractionDigits = 2]) {
    if (size <= 0) return '0 B';
    final multiple = (log(size) / log(1024)).floor();
    return '${(size / pow(1024, multiple)).toStringAsFixed(fractionDigits)} ${[
      'B',
      'kB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB',
    ][multiple]}';
  }

  static double getRatioForSlider(
      {BuildContext? context,
      int numItem = 3,
      double itemWidth = 100,
      double height = 100}) {
    double screenWidth = MediaQuery.of(Utility.getGlobalContext()).size.width;
    double width = (screenWidth > (numItem * itemWidth))
        ? (numItem * itemWidth)
        : screenWidth;
    double ratio = width / screenWidth;
    // return ratio > 0.85 ? 0.85 : ratio;
    return 1;
    // double screenWidth = MediaQuery.of(context).size.width;
    // double height = 80;
    // double ratio = screenWidth / (numItem * itemWidth);
  }

  static void drawArc(Canvas canvas,
      {required double centerX,
      required double centerY,
      required double radius,
      required double startAngle,
      required double sweepAngle,
      required Paint paint}) {
    canvas.drawArc(
        Rect.fromLTRB(centerX - radius, centerY - radius, centerX + radius,
            centerY + radius),
        startAngle * math.pi * 2 / 360,
        sweepAngle * math.pi * 2 / 360,
        false,
        paint);
  }

  static showToastMsg(
      {msg: '',
      BuildContext? context,
      // toastLength: Toast.LENGTH_SHORT,
      // gravity: ToastGravity.BOTTOM,
      backgroudColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      type: '', // info error 默认Info
      icon}) {
    if (msg == null || msg.isEmpty) {
      return;
    }
    if (TextUtil.isEmpty(type) || type == 'info') {
      if (icon == null) {
        icon = Icon(
          Icons.check_circle,
          color: Colors.green[400],
          size: 35,
        );
      }
    } else {
      if (type == 'error') {
        icon = Icon(
          Icons.report_problem,
          color: Colors.red[400],
          size: 35,
        );
      }
    }
    if (Utility.isHandsetBySize() && DeviceInfoManagement.isMoible()) {
      try {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {}
    } else {
      try {
        // showToast(msg,
        //     context: context,
        //     axis: Axis.horizontal,
        //     alignment: Alignment.center,
        //     position: StyledToastPosition.bottom);
        ScaffoldMessenger.of(
                Params.curContext ?? context ?? Utility.getGlobalContext())
            .showSnackBar(
          SnackBar(
            backgroundColor:
                ThemeManager.getInstance().getCardBackgroundColor(),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                icon,
                const SizedBox(width: 15),
                Flexible(
                    child: Text(msg,
                        style: TextStyle(
                            color: type == 'error'
                                ? Colors.red[400]
                                : ThemeManager.getInstance().getTextColor(
                                    defaultColor: Colors.green[400]),
                            fontSize: 14.5))),
              ],
            ),
            // action: SnackBarAction(
            //   label: '',
            //   onPressed: () {
            //     ScaffoldMessenger.of(Params.curContext ??
            //             context ??
            //             Utility.getGlobalContext())
            //         .hideCurrentSnackBar();
            //   },
            // ),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {}
      // Scaffold.of(Utility.getGlobalContext()).showSnackBar(new SnackBar(content:Text(msg)));
    }
  }

  // "2023-01-01"的时间戳
  static int getMonthFirstFromTimestamp(int timestamp) {
    DateTime dateTimeTmp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime dateTime = DateTime(dateTimeTmp.year, dateTimeTmp.month, 1);
    return dateTime.millisecondsSinceEpoch;
  }

  //从时间戳得到
  static int getMonthFromTimestamp(int timestamp) {
    DateTime dateTimeTmp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime dateTime =
        DateTime(dateTimeTmp.year, dateTimeTmp.month, dateTimeTmp.day);
    return dateTime.millisecondsSinceEpoch;
  }

  /**
   * 获取账单金额 -1表示没有添加数据 对于设置了重复的任务不想全部结束时对的处理方式
   */
  static addAndUpdateMissionModelRepeativeDate(
      {required MissionModel missionModel,
      required int curMonthTimeStamp,
      required bool isFinished}) {
    // 0表示不重复 1表示每天 2表示每周 3表示每月 4表示每年
    if (missionModel.repetiveType == 0 || curMonthTimeStamp < 1) {
      missionModel.isFinished = isFinished;
      return;
    }
    if (missionModel.repeativeDate == null) {
      missionModel.repeativeDate = [];
    }
    Map<String, dynamic> map = {};
    if (curMonthTimeStamp == null) {
      DateTime dateTimeTmp = getDateTimeFromTimeStamp(getTimeStampToday());
      DateTime dateTime =
          DateTime(dateTimeTmp.year, dateTimeTmp.month, dateTimeTmp.day);
      curMonthTimeStamp = dateTime.millisecondsSinceEpoch;
    }
    bool hasData = false;
    for (int i = 0; i < (missionModel.repeativeDate?.length ?? 0); i++) {
      Map map = missionModel.repeativeDate?[i] ?? {};
      if (map['month'] == curMonthTimeStamp) {
        hasData = true;
        map['isFinished'] = isFinished;
        break;
      }
    }
    //添加到数组 判断哪天是否完成了任务
    if (hasData == false) {
      DateTime dateTimeTmp = getDateTimeFromTimeStamp(curMonthTimeStamp);
      DateTime dateTime =
          DateTime(dateTimeTmp.year, dateTimeTmp.month, dateTimeTmp.day);
      map['isFinished'] = isFinished;
      map['month'] = dateTime.millisecondsSinceEpoch;
      missionModel.repeativeDate?.add(map);
    }
    return missionModel;
  }

  /**
   * 点击完成任务
   */
  static Future onClickFinishItem(
      {required BuildContext context,
      required MissionModel missionModel,
      FolderModel? folderModel,
      int? timestampCurrent,
      required Function finishCallback}) async {
    await Utility.requestMissionModelFinish(
        context, missionModel, timestampCurrent, folderModel, () {
      finishCallback();
      // this.requestDatas();
    });
  }

  static Future<void> requestMissionModelFinish(
      BuildContext context,
      MissionModel missionModel,
      int? timestampCurrent,
      FolderModel? folderModel,
      Function finishCallback) async {
    bool didHandle =
        await MongoApisManager.getInstance()!.handleFinishMissionModel(
      missionModel: missionModel,
      context: context,
      folderModel: folderModel,
      curMonthTimeStamp: timestampCurrent,
    );
    if (didHandle) {
      finishCallback.call();
    }
  }

  /**
   * 判断MissionModel在curMontTimeStamp是否完成了任务 重复任务的处理方式
   */
  static bool getIsFinishOfMissionModel(
      {required MissionModel missionModel, required int curMonthTimeStamp}) {
    if (missionModel.isFinished == true) {
      return true;
    }
    int curMonth = getMonthFromTimestamp(curMonthTimeStamp);
    if (missionModel.repetiveType == 0) {
      return missionModel.isFinished ?? false;
    }
    for (int i = 0; i < (missionModel.repeativeDate?.length ?? 0); i++) {
      Map? map = missionModel.repeativeDate?[i];
      if (map == null) {
        return false;
      }
      if (map['month'] == curMonth && map['isFinished'] != null) {
        bool val = map['isFinished'];
        return val;
      }
    }
    return false;
  }

  /**
   * 获取账单金额 -1表示没有添加数据 信用卡用得上
   */
  static getBillAmountFromRepaymentDatas(
      {required List repaymentData, required int curMonthTimeStamp}) {
    double amount = -1;
    int curMonth = getMonthFirstFromTimestamp(curMonthTimeStamp);
    for (int i = 0; i < repaymentData.length; i++) {
      Map map = repaymentData[i];
      if (map['month'] == curMonth && map['billAmount'] != null) {
        int val = map['billAmount'];
        amount = val.toDouble();
        break;
      }
    }
    return amount;
  }

  static double getBillAmount({required CreditCardModel creditModel}) {
    double billAmount = Utility.getBillAmountFromRepaymentDatas(
      repaymentData: creditModel.repaymentData ?? [],
      curMonthTimeStamp: Utility.getTimeStampToday(),
    );
    if (billAmount == -1) {
      return 0;
    } else {
      return billAmount;
    }
  }

  //还款数据 [{curMonthTimeStamp:"2023-01-01", amount: 12, repaymentStatus: 0}] 还款状态 repaymentStatus 0 未还款 1 逾期 2 已还款 这个应该没有用
  //有curMonthTimeStamp 就是更新数据，没有就是新增数据
  static void addAndUpdateRepaymentDay(List repaymentData,
      {int? curMonthTimeStamp, double amount = 0, int repaymentStatus = 0}) {
    Map map = {};
    if (curMonthTimeStamp == null) {
      DateTime dateTimeTmp = getDateTimeFromTimeStamp(getTimeStampToday());
      DateTime dateTime = DateTime(dateTimeTmp.year, dateTimeTmp.month, 1);
      curMonthTimeStamp = dateTime.millisecondsSinceEpoch;
    }
    bool hasData = false;
    for (int i = 0; i < repaymentData.length; i++) {
      Map map = repaymentData[i];
      if (map['month'] == curMonthTimeStamp) {
        hasData = true;
        map['repaymentStatus'] = repaymentStatus;
        map['billAmount'] = amount;
        break;
      }
    }
    if (hasData == false) {
      DateTime dateTimeTmp = getDateTimeFromTimeStamp(curMonthTimeStamp);
      DateTime dateTime = DateTime(dateTimeTmp.year, dateTimeTmp.month, 1);
      map['repaymentStatus'] = repaymentStatus;
      map['billAmount'] = amount;
      map['month'] = dateTime.millisecondsSinceEpoch;
      repaymentData.add(map);
    }
    // }
  }

  static showAlertDialog({context, content, Function? onConfirm}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(getI18NKey().remind),
            content: Text(content),
            backgroundColor: ThemeManager.getInstance()
                .getDialogBackgroundColor(defaultColor: Colors.white),
            elevation: 24,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
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
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
              ),
            ],
          );
        });
  }

  static pushNavigator(BuildContext context, Widget page,
      {Function? callback}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return page;
    })).then((value) {
      if (callback != null) {
        //callback声明时  callback: (val)
        callback(value ?? null);
      }
    });
  }

  static bool isLatestVersion(String version, {bool defaultval = false}) {
    if (Utility.compareVersion(Params.curVersion, version) == 0) {
      return defaultval;
    }
    if (Utility.compareVersion(Params.curVersion, version) == -1) {
      //
      return true;
    }
    return defaultval;
  }

  /**
   * 打开对应的页面 移动端直接Push
   * pc打开对话框
   */
  static openPagePCAndMobile(
    BuildContext context, {
    required Widget child,
    bool showPCShell = true,
  }) {
    if (Utility.isHandsetBySize() == true) {
      Utility.pushNavigator(context, child);
    } else {
      DialogManagement.getInstance().showPCCustomDialog(
        context: context,
        widget: child,
        showShell: showPCShell,
      );
    }
  }

  static popupPagePCAndMobile(BuildContext context, {Widget? child}) {
    if (Utility.isHandsetBySize() == true) {
      Utility.popNavigator(context);
    } else {
      DialogManagement.getInstance().hideDialog(context);
    }
  }

  static toggleCurDesktopFolderPageVisibility(BuildContext context) {
    // bool isVisible = !context.read<Env>().isFolderPageVisible;
    context.read<Env>().isFolderPageVisible =
        !context.read<Env>().isFolderPageVisible;
    // context.read<Env>().routerMainContainerData = {isFolderPageVisible: };
  }

  static pushCurFolderModel(BuildContext context,
      {required FolderModel folderModel, required int folderStatus}) {
    context.read<Env>().curFolderSelected = folderModel;
    context.read<Env>().curFolderStatus = folderStatus;
  }

  static setDesktopMiddileMissionPage(BuildContext context,
      {isVisible = true}) {
    if (Utility.isHandsetBySize() == false) {
      context.read<Env>().isMiddleMissionPageVisible = isVisible;
    }
  }

  static popupDesktopRightNavigator(BuildContext context) {
    setDesktopMiddileMissionPage(context, isVisible: true);
    final rightSideData = context.read<Env>().routerRightSideData;
    // AI 面板关闭时只隐藏，不销毁内部 Continue GUI / stream controller，
    // 否则用户边等回复边收起面板会导致本轮对话被中断。
    if (rightSideData is Map && rightSideData['page'] == 'ChatGptPage') {
      OverlayManagement.getInstance().hideDesktopAiFloatingOverlay();
    } else {
      OverlayManagement.getInstance().removeDesktopRightFloatingOverlay();
    }
    if (context.read<Env>().routerRightSideData != null) {
      context.read<Env>().routerRightSideData = null;
    }
  }

  /**
   * https://www.jianshu.com/p/cc3e6f78c85d
   * 计算文字宽度
   */
  static Size getTextSize(String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    try {
      if (text == null || text.isEmpty) {
        return Size.zero;
      }
      final TextPainter textPainter = TextPainter(
          // textDirection: TextDirection.LTR,
          text: TextSpan(text: text, style: style),
          maxLines: maxLines);
      textPainter.layout(maxWidth: maxWidth);
      // ..layout(maxWidth: maxWidth);
      return textPainter.size;
    } catch (e) {
      ScreenUtil.getInstance().screenWidth;
    }
    return Size.zero;
  }

  /**
   * 显示月份选择器
   */
  static Future<DateTimeModel?> showMonthPickerDialog(BuildContext context,
      [int timestamp = 0]) async {
    String datetime = '';
    Locale myLocale = Localizations.localeOf(context);
    DateTime? picker = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: (timestamp != null && timestamp != 0)
            ? getDateTimeFromTimeStamp(timestamp)
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 3),
        locale: myLocale);
    if (picker == null) {
      return null;
    }
    datetime = toFixed(picker.year) +
        "-" +
        toFixed(picker.month + 1) +
        "-" +
        toFixed(picker.day);
    // String dateTimeToShow = datetime + " " + toFixed(res.hour) + ":" + toFixed(res.minute);
    String dateTimeToShow = "";
    datetime += " " + "00:00.000";
    DateTimeModel model = DateTimeModel(
        isThisWeek: Utility.isThisWeek(picker),
        isNextWeek: Utility.isNextWeek(picker),
        isLastWeek: Utility.isLastWeek(picker),
        dayOfWeek: picker.weekday,
        timestamp: picker.millisecondsSinceEpoch,
        datetimeToShow: dateTimeToShow,
        datetime: picker,
        datetimeString: datetime);
    return model;
  }

  /**
   * 通过尺寸判断是不是手机
   */
  static bool isHandsetBySize() {
    if (screenType == ScreenType.Handset) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * desktop通过PC端打开页面 右边主内容 包含菜单栏
   */
  static pushDesktopMainContainerNavigator(
      BuildContext context, String page, Map data) {
    if (data == null) {
      data = {};
    }
    data['page'] = page;
    context.read<Env>().routerMainContainerData = data;
  }

  /**
   * desktop通过PC端打开页面 右边主内容 包含菜单栏
   */
  static pushWQBDesktopMainContainerNavigator(
      BuildContext context, String page, Map data) {
    if (data == null) {
      data = {};
    }
    data['page'] = page;
    context.read<Env>().wqbRouterMainContainerData = data;
  }

  static pushGPTDesktopMainContainerNavigator(
      BuildContext context, ChatGptFolderModel data) {
    // if (data == null) {
    //   data = {};
    // }
    // data['page'] = page;
    context.read<Env>().curChatGptFolderModel = data;
  }

  static pushCreditDetailDesktopMainContainerNavigator(
      BuildContext context, String page, Map data) {
    if (data == null) {
      data = {};
    }
    data['page'] = page;
    context.read<Env>().creditCardDetailData = data;
  }

  /**
   * 判断错题本的tags是否存在
   */
  static isTagExist({required String tag, required List tags}) {
    if (tags == null || tags.length == 0) {
      return false;
    }
    for (int i = 0; i < tags.length; i++) {
      if (tags[i]['title'] == tag) {
        return true;
      }
    }
    return false;
  }

  //打开最右侧展示栏
  static pushWQBDesktopMissionDetailNavigator(
      BuildContext context, String page, Map data) {
    if (data == null) {
      data = {};
    }
    data['page'] = page;
    context.read<Env>().wqbRouterMissionDetailData = data;
    if (Utility.isHandsetBySize() == true) {
      Utility.pushNavigator(context, WQBMissionDetailpage());
    }
  }

  static String getTagsFromWQBMissionModel(WQBMissionModel missionModel) {
    List list = [];
    missionModel.tagNames?.forEach((element) {
      list.add(element['title']);
    });
    return list.join(',');
  }

  static int getFirstTagColorFromWQBMissionModel(WQBMissionModel missionModel) {
    List list = [];
    for (int i = 0; i < (missionModel.tagNames?.length ?? 0); i++) {
      Map map = missionModel?.tagNames?[i] ?? {};
      return map['color'];
    }

    return 0xffc0c0c0;
  }

  static popupWQBDesktopMainContainerNavigator(BuildContext context) {
    if (context.read<Env>().wqbRouterMainContainerData != null) {
      context.read<Env>().wqbRouterMainContainerData = null;
    }
  }

  static popupDesktopMainContainerNavigator(BuildContext context) {
    if (context.read<Env>().routerMainContainerData != null) {
      context.read<Env>().routerMainContainerData = null;
    }
  }

  /**
   * desktop返回PC中间内容区默认页
   *
   * pushDesktopNavigator 打开的页面不是 Navigator 栈页面，而是写入 Env.routerData
   * 后由 DesktopRouter 切换出来的内容区；因此关闭这类页面时需要清空 routerData。
   */
  static popupDesktopNavigator(BuildContext context) {
    context.read<Env>().routerData = {};
  }

  /**
   * 显示当前tab
   */
  static void showCurTab(BuildContext context, int val, Map data) {
    context.read<Env>().curMobileTab = val;
    context.read<Env>().routerData = data;
  }

  /**
   * desktop通过PC端打开页面 不包含左侧菜单栏
   */
  static pushDesktopNavigator(BuildContext context, String page, Map data,
      {bool forceUpdate = false}) {
    data['page'] = page;
    if (forceUpdate == true) {
      // 随机数
      data['forceUpdate'] = Random().nextInt(100000);
    }
    context.read<Env>().routerData = data;
  }

  /**
   * 数据统计PC端右上角的卡片数据
   */
  static getPCStatisticPageRightTopData(
      {required BarModelList prevbarModelList,
      required BarModelList barModelList}) {
    int preTotalTime =
        getTotalTime(listBarModel: prevbarModelList?.listBarModel ?? {});
    int totalTime =
        getTotalTime(listBarModel: barModelList?.listBarModel ?? {});
    return {
      'preTotalTime': preTotalTime,
      'totalTime': totalTime,
      "percentChange": (preTotalTime - totalTime) / preTotalTime
    };
  }

  /**
   * StatisticPage获取总时长
   * type = 1状态是用于展示折线图，这时base才用上
   */
  static getTotalTime(
      {int type = 0,
      int base = 0,
      required Map<String, List<BarModel>> listBarModel}) {
    List<FlSpot> listFlSpot = [];
    List xList = listBarModel?.keys?.toList(growable: true) ?? [];
    double totalY = 0;

    for (int i = 0; i < xList.length; i++) {
      String key = xList[i];
      double y = 0;
      double yWithBase = 0;
      for (int j = 0; j < (listBarModel[key]?.length ?? 0); j++) {
        BarModel barModel = listBarModel[key]![j];
        y += (barModel.fromToYValue ?? 0) - (barModel?.fromYValue ?? 0);
        if (base != null) {
          yWithBase =
              (barModel.fromToYValue ?? 0) - (barModel?.fromYValue ?? 0) / base;
        }
      }
      totalY += y.toInt();
      if (base != null) {
        // totalYWithBase += yWithBase.toInt();
        listFlSpot.add(FlSpot(i.toDouble(), totalY.toDouble() / base));
      }
    }
    if (type == 0) {
      return totalY.toInt();
    } else {
      return {
        "totalYWithBase": totalY / base,
        "xList": xList,
        "listFlSpot": listFlSpot
      };
    }
  }

  /**
   * desktop通过PC端打开页面
   * 点击菜单栏让路由打开页面
   */
  static openDesktopNavigator(BuildContext context, String page, Map data) {
    data['page'] = page;
    context.read<Env>().routerData = data;
  }

  static openRightSideDesktopNavigator(
      BuildContext context, String page, Map data) {
    if (Utility.isHandsetBySize() == false &&
        (page == 'SettingItemDetailPage' ||
            page == 'GroupChatPage' ||
            page == 'ChatGptPage' ||
            page == 'WebviewPage')) {
      data['page'] = page;
      data['__overlay_ts'] = DateTime.now().millisecondsSinceEpoch;
      context.read<Env>().routerRightSideData = data;
      OverlayManagement.getInstance()
          .openDesktopRightFloatingPage(context, page: page, data: data);
      return;
    }
    data['page'] = page;
    context.read<Env>().routerRightSideData = data;
  }

  /// 桌面端右侧浮层打开 WebView。
  ///
  /// 这里统一走右侧浮层路由，WebView 页面本身只负责承载网页和 JS bridge；
  /// 以后邀请页、活动页或内部运营页都可以复用这个入口。
  static openDesktopWebviewPanel(
    BuildContext context, {
    required String url,
    String title = 'WebView',
    double width = 438,
  }) {
    openRightSideDesktopNavigator(context, 'WebviewPage', {
      'url': url,
      'title': title,
      'width': width,
    });
  }

  /**
   * 消除页面直到Pagename
   */
  static pushAndRemoveUntil(
      BuildContext context, BaseWidget page, String untilPageName) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        ModalRoute.withName(untilPageName));

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => page),
    //         (route) =>  false); //true保留跳转的当前栈   false 不保留
  }

  static pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  static pushNavigatorName(BuildContext context, String pageName,
      {Function? callback}) {
    Navigator.pushNamed(context, pageName);
  }

  static popNavigator([BuildContext? context, dynamic obj = null]) {
    if (obj != null) {
      Navigator.of(context!).pop(obj);
    } else {
      Navigator.of(context!).pop();
    }
  }

  static parseTimestampToSeconds(int timestamp) {
    return (timestamp / 1000).toInt();
  }

  static String filterXAxis(x) {
    if (x == '01:00' ||
        x == '02:00' ||
        x == '04:00' ||
        x == '05:00' ||
        x == '07:00' ||
        x == '08:00' ||
        x == '10:00' ||
        x == '11:00' ||
        x == '13:00' ||
        x == '14:00' ||
        x == '16:00' ||
        x == '17:00' ||
        x == '19:00' ||
        x == '20:00' ||
        x == '22:00' ||
        x == '23:00') {
      return '';
    } else if (new RegExp("\{.*?\}").hasMatch(x) == true) {
      return '';
    }
    return x;
  }

  /**
   * 判断是否是数字
   */
  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  /**
   * 白天 晚上判断
   */
  static bool isDay() {
    int hour = new DateTime.now().hour;
    return hour >= 8 && hour <= 18;
  }

  static int getTimeStampToday() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  /**
   * 预计时间
   */
  static int getPreviewTimeFromFolderModel(List<MissionModel> list) {
    int previewTime = 0;
    list.forEach((data) {
      if (data.isFinished == false) {
        previewTime +=
            ((data.total_tomotoes ?? 0) - (data.no_tomotoes_finished ?? 0)) *
                (data.tomato_duration ??
                    SharePreferenceUtil.getSyncInstance().getTomatoTime());
      }
    });
    return previewTime;
  }

  static int getPreviewTimeFromFolderModelWithoutRepeative(
      List<MissionModel> list) {
    int previewTime = 0;
    list.forEach((data) {
      if (data.isFinished == false) {
        if (data.repetiveType == 0) {
          previewTime +=
              ((data.total_tomotoes ?? 0) - (data.no_tomotoes_finished ?? 0)) *
                  (data.tomato_duration ??
                      SharePreferenceUtil.getSyncInstance().getTomatoTime());
        }
      }
    });
    return previewTime;
  }

  /**
   * 计算待完成任务数量
   */
  // static int getNumMissionToFinish(List<MissionModel> list) {
  //   int numMissionToFinished = 0;
  //   list.forEach((data) {
  //     numMissionToFinished += data.total_tomotoes - data.no_tomotoes_finished;
  //   });
  //   return numMissionToFinished;
  // }

  /**
   * 计算总的完成的任务时间
   * todo 这个已经完成时间不应该用tomatoTime来计算
   */
  static int getFinishedTimeFromFolderModel(List<MissionModel> list) {
    int finishedTime = 0;
    list.forEach((data) {
      finishedTime += (data?.no_tomotoes_finished ?? 0) *
          (data.tomato_duration ??
              SharePreferenceUtil.getSyncInstance().getTomatoTime());
    });
    return finishedTime;
  }

  static List<MissionModel> getFinishListMissionModels(
      List<MissionModel> list, bool isFinished) {
    List<MissionModel> listMissionModels = [];
    list.forEach((data) {
      if (data.isFinished == isFinished) {
        listMissionModels.add(data);
      }
    });
    return listMissionModels;
  }

  /**
   * 完成任务
   */
  static List<MissionModel> getMissionModelFinished(List<MissionModel> list) {
    List<MissionModel> listTmp = [];
    list.forEach((data) {
      if (data.isFinished == true) {
        listTmp.add(data);
      }
    });
    return listTmp;
  }

  /**
   * 完成任务
   */
  static List<WQBMissionModel> getWQBMissionModelFinished(
      List<WQBMissionModel> list) {
    List<WQBMissionModel> listTmp = [];
    list.forEach((data) {
      if (data.isFinished == true) {
        listTmp.add(data);
      }
    });
    return listTmp;
  }

  /**
   * Generate current time in 2023-09-10T04:47:49.532Z format
   */
  static String getCurrentTimeInSpecifiedFormat() {
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();
    return formattedDate;
  }

  /**
   * 未完成任务
   */
  static List<MissionModel> getMissionModelUnfinished(List<MissionModel> list) {
    List<MissionModel> listTmp = [];
    list.forEach((data) {
      if (data.isFinished != true) {
        listTmp.add(data);
      }
    });
    return listTmp;
  }

  /**
   * 重复未完成任务
   */
  static List<MissionModel> getMissionModelRepeativeUnfinished(
      List<MissionModel> list) {
    List<MissionModel> listTmp = [];
    list.forEach((data) {
      if (data.isFinished != true && data.repetiveType != 0) {
        listTmp.add(data);
      }
    });
    return listTmp;
  }

  static List<MissionModel> getMissionModelUnfinishedDelay(
      List<MissionModel> list) {
    List<MissionModel> listTmp = [];
    list.forEach((data) {
      if (data.isFinished != true && data.repetiveType == 0) {
        listTmp.add(data);
      }
    });
    return listTmp;
  }

  static List<WQBMissionModel> getWQBMissionModelUnfinishedDelay(
      List<WQBMissionModel> list) {
    List<WQBMissionModel> listTmp = [];
    list.forEach((data) {
      if (data.isFinished != true) {
        listTmp.add(data);
      }
    });
    return listTmp;
  }

  /**
   * 计算待完成任务数量
   */
  static int getNumMissionFinished(List<MissionModel> list) {
    int numMissionFinished = 0;
    list.forEach((data) {
      numMissionFinished += (data.no_tomotoes_finished ?? 0);
    });
    return numMissionFinished;
  }

  /**
   *打卡完成率 用于进度条
   * 0.0 - 1.0
   *
   */
  static double getPercentOfNumClocksIn(
      {required FlomoMissionModel missionModel, required String ymd}) {
    List list = missionModel.clockIn?[ymd] ?? []; //完成的打卡
    return list.length / missionModel.daily_num_times; //今天完成打卡的数量/每日打卡数
  }

  /**
   * 根据排序规则从list过滤得到SessionMissionModel
   */
  static List<WQBSessionMissionModel>? getWQBListAfterOrder(
      MissionOrderEnum missionOrderEnum, List<WQBMissionModel> list) {
    if (missionOrderEnum == MissionOrderEnum.orderByWords) {
      return Utility.parseWQBMissionModelsToSessionMissionMidelListByFolderName(
          list, CONSTANTS.wqbFolderModelList);
    } else if (missionOrderEnum == MissionOrderEnum.orderByPriority) {
      return Utility.parseWQBMissionModelsToSessionMissionMidelListByPriority(
          list);
    } else if (missionOrderEnum == MissionOrderEnum.orderByTime) {
      return Utility.parseWQBMissionModelsToSessionMissionMidelListByDateTime(
          list);
    } else if (missionOrderEnum == MissionOrderEnum.orderByTag) {
      return Utility.parseWQBMissionModelsToSessionMissionMidelListByTag(
          list, MongoApisManager.getInstance().listWQBFolderModel);
    }
    return null;
  }

  /**
   * 根据排序规则从list过滤得到SessionMissionModel
   */
  static List<SessionMissionModel>? getListAfterOrder(
      MissionOrderEnum missionOrderEnum, List<MissionModel> list,
      [int folderStatus = -1, List<String>? listFolderIds]) {
    if (missionOrderEnum == MissionOrderEnum.orderByWords) {
      List<FolderModel> listFolderModels = CONSTANTS.folderModelList;
      if (listFolderIds != null) {
        listFolderModels = listFolderModels
            .where((element) => listFolderIds.contains(element.objectId))
            .toList();
      }
      return Utility.parseMissionModelsToSessionMissionMidelListByFolderName(
          list, listFolderModels, folderStatus);
    } else if (missionOrderEnum == MissionOrderEnum.orderByPriority) {
      return Utility.parseMissionModelsToSessionMissionMidelListByPriority(
          list);
    } else if (missionOrderEnum == MissionOrderEnum.orderByTime) {
      return Utility.parseMissionModelsToSessionMissionMidelListByDateTime(
          list);
    } else if (missionOrderEnum == MissionOrderEnum.orderByTag) {
      List<FolderModel> listFolderModels =
          MongoApisManager.getInstance().listFolderModels;
      if (listFolderIds != null) {
        listFolderModels = listFolderModels
            .where((element) => listFolderIds.contains(element.objectId))
            .toList();
      }
      return Utility.parseMissionModelsToSessionMissionMidelListByTag(
          list, listFolderModels);
    }
    return null;
  }

  // static List<SessionMissionModel>? getListAfterOrderForGrid(
  //     MissionOrderEnum missionOrderEnum, List<MissionModel> list) {
  //   if (missionOrderEnum == MissionOrderEnum.orderByWords) {
  //     return Utility.parseMissionModelsToSessionMissionMidelListByFolderName(
  //         list, CONSTANTS.folderModelList);
  //   } else if (missionOrderEnum == MissionOrderEnum.orderByPriority) {
  //     return Utility.parseMissionModelsToSessionMissionMidelListByPriority(
  //         list);
  //   } else if (missionOrderEnum == MissionOrderEnum.orderByTime) {
  //     return Utility.parseMissionModelsToSessionMissionMidelListByDateTime(
  //         list);
  //   } else if (missionOrderEnum == MissionOrderEnum.orderByTag) {
  //     return Utility.parseMissionModelsToSessionMissionMidelListByTag(
  //         list, MongoApisManager.getInstance().listFolderModels);
  //   }
  //   return null;
  // }

  static List<MissionModel> getMissionModelListAfterOrder(
      MissionOrderEnum missionOrderEnum, List<MissionModel> listMissionModel) {
    if (missionOrderEnum == MissionOrderEnum.orderByWords) {
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.title?.compareTo(b?.title ?? "") ?? 0;
      });
    } else if (missionOrderEnum == MissionOrderEnum.orderByPriority) {
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.priorityStatus?.compareTo(b.priorityStatus ?? 0) ?? 0;
      });
    } else if (missionOrderEnum == MissionOrderEnum.orderByTime) {
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.end_time! > (b.end_time ?? 0)
            ? -1
            : a.end_time! < (b.end_time ?? 0)
                ? 1
                : 0;
      });
    } else if (missionOrderEnum == MissionOrderEnum.orderByCreatedTime) {
      listMissionModel.sort((MissionModel a, MissionModel b) {
        DateTime dateTimeA = getDateTimeFromUTCString(a.createdAt ?? "");
        DateTime dateTimeB = getDateTimeFromUTCString(b.createdAt ?? "");
        return dateTimeA.isAfter(dateTimeB)
            ? -1
            : dateTimeA.isBefore(dateTimeB)
                ? 1
                : 0;
      });
    } else if (missionOrderEnum == MissionOrderEnum.orderByUpdateTime) {
      listMissionModel.sort((MissionModel a, MissionModel b) {
        DateTime dateTimeA = getDateTimeFromUTCString(a.updatedAt ?? "");
        DateTime dateTimeB = getDateTimeFromUTCString(b.updatedAt ?? "");
        return dateTimeA.isAfter(dateTimeB)
            ? -1
            : dateTimeA.isBefore(dateTimeB)
                ? 1
                : 0;
      });
    } else if (missionOrderEnum == MissionOrderEnum.orderByTag) {
      listMissionModel.sort((MissionModel a, MissionModel b) {
        return a.title?.compareTo(b?.title ?? "") ?? 0;
      });
    }
    return listMissionModel;
  }

  static sortByCreatedTime(List list,
      {SortEnum sortEnum = SortEnum.ascendant}) {
    list.sort((dynamic a, dynamic b) {
      try {
        DateTime dateTimeA = getDateTimeFromUTCString(a.createdAt);
        DateTime dateTimeB = getDateTimeFromUTCString(b.updatedAt);
        int res = dateTimeA.isAfter(dateTimeB)
            ? sortEnum == SortEnum.ascendant
                ? -1
                : 1
            : dateTimeA.isBefore(dateTimeB)
                ? sortEnum == SortEnum.ascendant
                    ? 1
                    : -1
                : 0;
        return res;
      } catch (e) {
        return -1;
      }
    });
    return list;
  }

  static FolderTimeModel getWQBFolderTimeModel(List<WQBMissionModel> list) {
    FolderTimeModel folderTimeModel = new FolderTimeModel();
    int numMissionToFinished = 0; //待完成任务数量
    int finishedTime = 0; //完成总数量
    int numMissionFinished = 0; //待完成任务数量
    int previewTime = 0; //预计剩下完成时间
    int numTomatoesUnfinished = 0; //未完成番茄数量
    int numTomatoesFinished = 0; //完成番茄数量
    int numTomatoesPlanned = 0; //计划番茄数量

    list.forEach((data) {
      // totalTime += (data.total_tomotoes - data.no_tomotoes_finished) * getTomatoTime();
      try {
        numMissionFinished += data.isFinished == true ? 1 : 0;
        numMissionToFinished += data.isFinished == true ? 0 : 1;
        // numTomatoesFinished += (data.no_tomotoes_finished ?? 0);
        // numTomatoesUnfinished = numTomatoesUnfinished +
        //     (data.total_tomotoes ?? 0) -
        //     (numTomatoesUnfinished ?? 0) >
        //     0
        //     ? ((data.total_tomotoes ?? 0) - numTomatoesUnfinished)
        //     : 0;
        //
        // previewTime += data.isFinished == false
        //     ? (data.total_tomotoes! >= (data.no_tomotoes_finished ?? 0)
        //     ? (data.total_tomotoes! - (data.no_tomotoes_finished ?? 0)) *
        //     (data.tomato_duration ??
        //         SharePreferenceUtil.getSyncInstance().getTomatoTime())
        //     : 0)
        //     : 0;
        // finishedTime += data?.time_finished ?? 0;
      } catch (e) {}
    });
    String previewTimeString = formatTimestampWithoutZero(previewTime);
    String finishedTimeString = formatTimestampWithoutZero(finishedTime);

    folderTimeModel = new FolderTimeModel(
        numMissionToFinished: numMissionToFinished,
        numMissionFinished: numMissionFinished,
        previewTimeString: previewTimeString,
        finishedTimeString: finishedTimeString,
        numTomatoesFinished: numTomatoesFinished,
        numTomatoesUnfinished: numTomatoesUnfinished,
        previewTime: previewTime,
        finishedTime: finishedTime);
    return folderTimeModel;
  }

  /**
   * 用于计算missionPage头部四个参数时间
   * folderStatus -1:未归档和归档 0 未归档 1 归档
   */
  static FolderTimeModel getFolderTimeModel(List<MissionModel> list,
      [int folderStatus = -1]) {
    FolderTimeModel folderTimeModel = new FolderTimeModel();
    int numMissionToFinished = 0; //待完成任务数量
    int finishedTime = 0; //完成总数量
    int numMissionFinished = 0; //待完成任务数量
    int previewTime = 0; //预计剩下完成时间
    int numTomatoesUnfinished = 0; //未完成番茄数量
    int numTomatoesFinished = 0; //完成番茄数量
    int numTomatoesPlanned = 0; //计划番茄数量
    int numMissionDelayed = 0; //延期任务数量
    double totalObjective = 0;
    double curValObjective = 0;
    list.forEach((data) {
      // totalTime += (data.total_tomotoes - data.no_tomotoes_finished) * getTomatoTime();
      try {
        if (folderStatus == -1 ||
            (folderStatus == 0 &&
                Utility.isMissionModelArchive(data) == false) ||
            (folderStatus == 1 &&
                Utility.isMissionModelArchive(data) == true)) {
          numMissionDelayed += data.isDelayed == true ? 1 : 0;
          numMissionFinished += data.isFinished == true ? 1 : 0;
          numMissionToFinished += data.isFinished == true ? 0 : 1;
          totalObjective += data.objectiveTotalValue ?? 0;
          curValObjective += data.objectiveValue ?? 0;
          numTomatoesFinished += (data.no_tomotoes_finished ?? 0);
          numTomatoesPlanned += (data.total_tomotoes ?? 0);

          previewTime += data.isFinished == false
              ? (data.total_tomotoes! >= (data.no_tomotoes_finished ?? 0)
                  ? (data.total_tomotoes! - (data.no_tomotoes_finished ?? 0)) *
                      (data.tomato_duration ??
                          SharePreferenceUtil.getSyncInstance().getTomatoTime())
                  : 0)
              : 0;
          finishedTime += data?.time_finished ?? 0;
        }
      } catch (e) {}
    });
    String previewTimeString = formatTimestampWithoutZero(previewTime);
    String finishedTimeString = formatTimestampWithoutZero(finishedTime);
    print("~~~~~~~~~~~~~~~~~~~~~~~~");
    print(finishedTimeString);
    print("~~~~~~~~~~~~~~~~~~~~~~~~");
    numTomatoesUnfinished = numTomatoesPlanned - numTomatoesFinished > 0
        ? (numTomatoesPlanned - numTomatoesFinished)
        : 0;
    folderTimeModel = new FolderTimeModel(
        objectivePercentString: Utility.getPercent(
            totalObjective == 0 ? 0 : (curValObjective / totalObjective)),
        numMissionDelayed: numMissionDelayed,
        numMissionToFinished: numMissionToFinished,
        numMissionFinished: numMissionFinished,
        previewTimeString: previewTimeString,
        finishedTimeString: finishedTimeString,
        numTomatoesFinished: numTomatoesFinished,
        numTomatoesUnfinished: numTomatoesUnfinished,
        previewTime: previewTime,
        finishedTime: finishedTime);
    return folderTimeModel;
  }

  Future<ByteData> loadAsset({String path: 'sounds/music.mp3'}) async {
    return await rootBundle.load(path);
  }

  /**
   * 把时间戳转化成 01:02的时间格式
   * 如果是00开那就是 00:01:02的格式
   */
  static String formatTimestamp(int timestamp) {
    if (timestamp == 0) {
      return '00:00';
    }
    int hour = timestamp ~/ (1000 * 60 * 60);
    int min = timestamp ~/ (1000 * 60) % 60;
    int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    // if(hour == 0) {
    //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
    // } else {
    return formatDecimal(hour) + ":" + formatDecimal(min);
    // }
  }

  static String getDifTime(DateTime dateTime) {
    DateTime dateTimeNow = DateTime.now();
    if (dateTime.isAfter(dateTimeNow) == true) {
      //dateTime比较厚
      int year = dateTime.year;
      int yearNow = dateTimeNow.year;
      int month = dateTime.month;
      int monthNow = dateTimeNow.month;
      int day = dateTime.day;
      int dayNow = dateTimeNow.day;
      if (year == yearNow && month == monthNow && day == dayNow) {
        //同一天 显示 00:00 后
        // int mins = Utility.getMinsFromTimeStamp(dateTime.millisecondsSinceEpoch);
        // int secs = Utility.getSecsFromTimeStamp(dateTime.millisecondsSinceEpoch);
        return getI18NKey().time_later(Utility.formatHourAndMinAndSec(
            dateTime.millisecondsSinceEpoch -
                dateTimeNow.millisecondsSinceEpoch));
      } else {
        //不是同一天 显示 n天后
        return getI18NKey().days_later(Utility.getDays(
            dateTime.millisecondsSinceEpoch -
                dateTimeNow.millisecondsSinceEpoch));
      }
    } else if (dateTime.isBefore(dateTimeNow) == true) {
      //几天前
      int year = dateTime.year;
      int yearNow = dateTimeNow.year;
      int month = dateTime.month;
      int monthNow = dateTimeNow.month;
      int day = dateTime.day;
      int dayNow = dateTimeNow.day;

      if ((year == yearNow && month == monthNow && day == dayNow) ||
          ((dateTimeNow.millisecondsSinceEpoch -
                      dateTime.millisecondsSinceEpoch) /
                  (24 * 1000 * 60 * 60)) <
              1) {
        //同一天 显示 00:00 后
        // int mins = Utility.getMinsFromTimeStamp(dateTime.millisecondsSinceEpoch);
        // int secs = Utility.getSecsFromTimeStamp(dateTime.millisecondsSinceEpoch);
        return getI18NKey().time_ago(Utility.formatHourAndMinAndSec(
            dateTimeNow.millisecondsSinceEpoch -
                dateTime.millisecondsSinceEpoch));
      } else {
        //不是同一天 显示 n天后
        return getI18NKey().days_ago(Utility.getDays(
            dateTimeNow.millisecondsSinceEpoch -
                dateTime.millisecondsSinceEpoch));
      }
    } else {
      return getI18NKey().now;
    }
  }

  static int getHourFromTimeStamp(int timestamp) {
    return (timestamp ~/ (1000 * 60 * 60)).toInt();
  }

  static int getMinsFromTimeStamp(int timestamp) {
    return (timestamp ~/ (1000 * 60) % 60).toInt();
  }

  static int getSecsFromTimeStamp(int timestamp) {
    int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    return secs;
  }

  static String formatTimestampHourAndMins(int timestamp) {
    if (timestamp == 0) {
      return '00:00';
    }
    int hour = timestamp ~/ (1000 * 60 * 60);
    int min = timestamp ~/ (1000 * 60) % 60;
    int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    // if(hour == 0) {
    //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
    // } else {

    return getI18NKey().hourAndMin(hour, min);
    // }
  }

  static String formatTimestampWithoutZeroHM(int timestamp) {
    if (timestamp == 0) {
      return '0m';
    }
    int hour = timestamp ~/ (1000 * 60 * 60);
    int min = timestamp ~/ (1000 * 60) % 60;
    int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    // if(hour == 0) {
    //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
    // } else {
    return hour.toString() + "h " + min.toString() + "m";
    // }
  }

  static String formatTimestampWithoutZero(int timestamp) {
    if (timestamp == 0) {
      return '00:00';
    }
    int hour = timestamp ~/ (1000 * 60 * 60);
    int min = timestamp ~/ (1000 * 60) % 60;
    int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    // if(hour == 0) {
    //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
    // } else {
    return hour.toString() + ":" + min.toString();
    // }
  }

  static String getTime(int timestamp) {
    String hour = Utility.formatDecimal(Utility.getHourFromTimeStamp(timestamp),
        shouldAddZero: true);
    String min = Utility.formatDecimal(Utility.getMinsFromTimeStamp(timestamp),
        shouldAddZero: true);
    String secs = Utility.formatDecimal(Utility.getSecsFromTimeStamp(timestamp),
        shouldAddZero: true);
    return '$hour:$min:$secs';
  }

  /**
   * 时间戳转成时分
   * 35时21分
   */
  // static String formatHourAndMinAndSec(int timestamp) {
  //   if (timestamp == null) return '';
  //   if (timestamp == 0) {
  //     return getI18NKey().hourAndMin('0', '0');
  //   }
  //   int hour = timestamp ~/ (1000 * 60 * 60);
  //   int min = ((timestamp) ~/ (1000)) % 3600 ~/ 60;
  //   int secs = timestamp % 60;
  //   // int min = (timestamp - hour * 60 * 1000) ~/ (1000 * 60);
  //   // int secs = timestamp ~/ (1000 * 60 * 60) % 60;
  //   // if(hour == 0) {
  //   //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
  //   // } else {
  //   if (hour > 0) {
  //     return getI18NKey().hourAndMinAndSec(formatDecimal(hour), formatDecimal(min), formatDecimal(secs));
  //   } else {
  //     return getI18NKey().minAndSec(formatDecimal(min), formatDecimal(secs));
  //
  //   }
  //   // }
  // }

  /**
   * 时间戳转成时分
   * 35时21分
   */
  static String formatHourAndMin(int timestamp) {
    if (timestamp == null) return '';
    if (timestamp == 0) {
      return getI18NKey().hourAndMin('0', '0');
    }
    int hour = timestamp ~/ (1000 * 60 * 60);
    int min = ((timestamp) ~/ (1000)) % 3600 ~/ 60;
    int secs = timestamp % 60;
    // int min = (timestamp - hour * 60 * 1000) ~/ (1000 * 60);
    // int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    // if(hour == 0) {
    //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
    // } else {
    return getI18NKey().hourAndMin(formatDecimal(hour), formatDecimal(min));
    // }
  }

  static int getMinNum(int timestamp) {
    return ((timestamp) ~/ (1000)) % 3600 ~/ 60;
  }

  static int getHourNum(int timestamp) {
    return timestamp ~/ (1000 * 60 * 60);
  }

  /**
   * 给我一个函数 把毫秒时间差转换成 格式
      hh:mm MM/DD,weekday
   */
  static String formatTimestampHMDW(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('hh:mm MM/dd, EEEE');
    return formatter.format(date);
  }

  /**
   * 时间戳转成时分
   * 12:11
   */
  static String formatHourAndMin2(int timestamp) {
    if (timestamp == null) return '';
    if (timestamp! < 86400001) {
      if (timestamp == 0) {
        // return getI18NKey().hourAndMin('0', '0');
        return "${formatDecimal(0, shouldAddZero: true)}:${formatDecimal(0, shouldAddZero: true)}";
      }
      int hour = timestamp ~/ (1000 * 60 * 60);
      int min = ((timestamp) ~/ (1000)) % 3600 ~/ 60;
      int secs = timestamp % 60;
      // int min = (timestamp - hour * 60 * 1000) ~/ (1000 * 60);
      // int secs = timestamp ~/ (1000 * 60 * 60) % 60;
      // if(hour == 0) {
      //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
      // } else {
      // formatDecimal(hour), formatDecimal(min)
      return "${formatDecimal(hour, shouldAddZero: true)}:${formatDecimal(min, shouldAddZero: true)}";
    } else {
      return formatTimestampHMDW(timestamp);
    }
    // }
  }

  // hh:mm 字符串转换 timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000
  static int getTimeStampFromHHMM(String time) {
    if (time == null || time.isEmpty) return 0;
    List<String> timeList = time.split(':');
    if (timeList.length != 2) return 0;
    int hour = int.parse(timeList[0]);
    int min = int.parse(timeList[1]);
    return hour * 60 * 60 * 1000 + min * 60 * 1000;
  }

  /**
   * 时间戳转成时分秒
   * 35时21分
   */
  static String formatHourAndMinAndSec(int timestamp) {
    if (timestamp == null) return '';
    if (timestamp == 0) {
      return getI18NKey().hourAndMin('0', '0');
    }
    int hour = timestamp ~/ (1000 * 60 * 60);
    int min = (timestamp ~/ (1000 * 60)) % 60;
    int secs = (timestamp ~/ 1000) % 60;
    // int min = (timestamp - hour * 60 * 1000) ~/ (1000 * 60);
    // int secs = timestamp ~/ (1000 * 60 * 60) % 60;
    // if(hour == 0) {
    //   return formatDecimal(hour) + ":" + formatDecimal(min) + ":" + formatDecimal(secs);
    // } else {
    if (hour > 0) {
      return getI18NKey().hourAndMin(formatDecimal(hour), formatDecimal(min));
    } else {
      return getI18NKey().minAndSec(formatDecimal(min), formatDecimal(secs));
    }
    // }
  }

  /**
   * 把number 1=>01 的字符串
   */
  static String formatDecimal(int number, {bool shouldAddZero: false}) {
    if (number < 10) {
      if (shouldAddZero == true) {
        return '0$number';
      } else {
        return '$number';
      }
    } else {
      return number.toString();
    }
  }

  static String getDays(int timestamp) {
    // return formatDecimal((timestamp / (24 * 1000 * 60 * 60)).ceil(), shouldAddZero: false);
    return formatDecimal(timestamp ~/ (24 * 1000 * 60 * 60),
        shouldAddZero: false);
  }

  /**
   * 算出分
   */
  static String getHour(int timestamp) {
    return formatDecimal(timestamp ~/ (1000 * 60 * 60), shouldAddZero: true);
  }

  /**
   * 算出分
   */
  static String getMins(int timestamp) {
    return formatDecimal(timestamp ~/ (1000 * 60) % 60, shouldAddZero: true);
  }

  /**
   * 算出秒
   */
  static String getSeconds(int timestamp) {
    return formatDecimal(timestamp ~/ (1000) % 60, shouldAddZero: true);
  }

  static int getCurrentUnixTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static int getCurrentUTCTimestamp() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  static DateTime getDateTimeFromTimeStamp2(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp);
  }

  //在ymd时间的打卡次数
  static int getNumClocksMissionFinished(DayModel dayModel) {
    int numClockinMission = 0;
    dayModel.flomoMissionModelList.forEach((element) {
      String ymd = getYMD(dayModel?.dateTime ?? DateTime.now());
      if (element == null || element.clockIn == null) {
        return;
      }
      if (element.isFinished == false &&
          isFlomoMissionModelFinished(flomoMissionModel: element, ymd: ymd)) {
        numClockinMission++;
      }
    });
    return numClockinMission;
  }

  //在ymd时间的打卡次数
  static int getNumClocksMissionFinishedByFlomoMissionModel(
      {required FlomoMissionModel flomoMissionModel, required String ymd}) {
    return flomoMissionModel.clockIn?[ymd]?.length ?? 0;
    // int numClockinMission = 0;
    // dayModel.flomoMissionModelList.forEach((element) {
    //   String ymd = getYMD(dayModel?.dateTime ?? DateTime.now());
    //   if (element == null || element.clockIn == null) {
    //     return;
    //   }
    //   if(isFlomoMissionModelFinished(flomoMissionModel: element,ymd:ymd)) {
    //     numClockinMission++;
    //   }
    //   //ymd打卡总数
    //   // List clocksIn = element.clockIn?[ymd] ?? [];
    //   // numClockinMission = clocksIn.length;
    //   // if ((element?.daily_num_times ?? 0) <= clocksIn.length) {
    //   //   numClockinMission++;
    //   // }
    // });
    // return numClockinMission;
  }

  /**
   * ymd时间是否完成
   */
  static bool isFlomoMissionModelFinished(
      {required FlomoMissionModel flomoMissionModel, required String ymd}) {
    List clockInList = flomoMissionModel.clockIn?[ymd] ?? [];
    return (clockInList.length != 0 &&
            clockInList.length >= flomoMissionModel.daily_num_times)
        ? true
        : false;
  }

  static int totalFlomoMissionClockDaysAlready(
      {required FlomoMissionModel flomoMissionModel, int curTimeStamp = 0}) {
    DateTime startTime = Utility.getFilterDateTimeFromTimeStamp(
        flomoMissionModel.start_time ?? 0);
    DateTime dateTimeNow =
        Utility.getFilterDateTimeFromTimeStamp(curTimeStamp ?? 0);
    return dateTimeNow.difference(startTime).inDays;
  }

  static List<MissionModel> filterMissionModelByFinishedState(
      {required List<MissionModel> list, isFinished = false}) {
    List<MissionModel> listFlomoMissionModel = [];
    list.forEach((element) {
      if ((element.isFinished ?? false) == isFinished) {
        listFlomoMissionModel.add(element);
      }
    });
    return listFlomoMissionModel;
  }

  static List<FlomoMissionModel> filterFlomoMissionModelByFinishedState(
      {required List<FlomoMissionModel> list, isFinished = false}) {
    List<FlomoMissionModel> listFlomoMissionModel = [];
    list.forEach((element) {
      if ((element.isFinished ?? false) == isFinished) {
        listFlomoMissionModel.add(element);
      }
    });
    return listFlomoMissionModel;
  }

  /**
   * ymd时间连续打卡次数
   */
  static Map<String, dynamic> getFlomoMissionModelAtMonth(
      {required DateTime dateTime,
      required FlomoMissionModel flomoMissionModel}) {
    Map<String, dynamic> map = {};
    int year = dateTime.year;
    int month = dateTime.month;
    flomoMissionModel.clockIn?.forEach((key, value) {
      if (key.startsWith(
          '$year-${Utility.formatDecimal(month, shouldAddZero: true)}')) {
        map[key] = value;
      }
    });
    return map;
  }

  /**
   * ymd时间连续打卡次数
   */
  static int totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStamp(
      {required FlomoMissionModel flomoMissionModel, int curTimeStamp = 0}) {
    int daily_num_times = flomoMissionModel.daily_num_times;
    Map? clockInMap = flomoMissionModel?.clockIn;
    return totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStampAndMap(
        curTimeStamp: curTimeStamp,
        clockInMap: clockInMap!,
        daily_num_times: daily_num_times);
  }

  static int
      totalMaxFlomoMissionClockInFinishedContinuouslyAtYmdTimeStampAndMap(
          {required DateTime dateTimeStart,
          required DateTime dateTimeEnd,
          required Map<dynamic, dynamic> clockInMap,
          required int daily_num_times}) {
    DateTime dateTimeCurrentEnd = Utility.getFilterDateTimeFromTimeStamp(
        dateTimeEnd.millisecondsSinceEpoch, true);
    DateTime dateTimeCurrentStart = Utility.getFilterDateTimeFromTimeStamp(
        dateTimeStart.millisecondsSinceEpoch, false);
    DateTime prevDateTime = Utility.getFilterDateTimeFromTimeStamp(0, true);
    DateTime prevDateTimeFinished = Utility.getFilterDateTimeFromTimeStamp(
        0, true); //上次完成的时间 因为有可能有些只是点击没有完成
    int total = 0;
    late List<String> keys;
    try {
      keys = clockInMap?.keys.toList() as List<String>;
    } catch (e) {
      print(e);
      keys = [];
    }
    int maxTotal = 0;
    keys.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a);
      DateTime dateTimeB = DateTime.parse(b);
      return dateTimeA.isAfter(dateTimeB)
          ? 1
          : dateTimeA.isAtSameMomentAs(dateTimeB)
              ? 0
              : -1;
    });
    DateTime dateTimeItem = Utility.getDateTimeFromTimeStamp(0);
    for (int i = 0; i < (keys.length ?? 0); i++) {
      //每个key格式是yyyy-MM-dd 从小到大排序
      String key = keys[i] ?? "";
      List itemList = clockInMap?[key] ?? [];
      bool isFinished =
          isFlomoMissionFinishedByClockInList(itemList, daily_num_times ?? 0);
      if (key == "2023-08-12" || key == "2023-08-13" || key == "2023-08-14") {
        print("11111");
      }
      // flomoMissionModel.clockIn?.forEach((key, value) {
      dateTimeItem = DateTime.parse(key);
      //不在时间范围内跳出循环
      if (!((dateTimeItem.isAtSameMomentAs(dateTimeCurrentStart) ||
              dateTimeItem.isAfter(dateTimeCurrentStart)) &&
          (dateTimeItem.isAtSameMomentAs(dateTimeCurrentEnd) ||
              dateTimeItem.isBefore(dateTimeCurrentEnd)))) {
        break;
      }
      if ((dateTimeItem.difference(prevDateTimeFinished).inDays.abs() < 2 ||
              i == 0) &&
          isFinished == true) {
        prevDateTime = dateTimeItem;
        prevDateTimeFinished = dateTimeItem;
        total++;
      } else {
        //超过今天不计算
        if (dateTimeItem.isAtSameMomentAs(dateTimeCurrentStart) ||
            dateTimeItem.isAfter(dateTimeCurrentStart)) {
          break;
        }
        if (dateTimeItem.difference(prevDateTime).inDays.abs() >= 2) {
          if (total > 0) {
            maxTotal = total;
          }
          total = 0;
        }
        if (isFinished == true) {
          total++;
          prevDateTimeFinished = dateTimeItem;
        } else {
          if (dateTimeItem.difference(prevDateTime).inDays.abs() >= 2) {
            if (total > 0) {
              maxTotal = total;
            }
            total = 0;
          }
        }
      }
      //超过今天不计算
      if (dateTimeItem.isAtSameMomentAs(dateTimeCurrentStart) ||
          dateTimeItem.isAfter(dateTimeCurrentStart)) {
        break;
      }
      if (dateTimeCurrentEnd.year == dateTimeItem.year &&
          dateTimeCurrentEnd.month == dateTimeItem.month &&
          dateTimeCurrentEnd.day == dateTimeItem.day) {
        break;
      }
    }
    if (dateTimeCurrentEnd.difference(prevDateTimeFinished).inDays > 1) {
      return 0;
    }
    dateTimeCurrentStart = dateTimeCurrentStart.add(Duration(days: 1));
    // });
    return maxTotal;
  }

  static int totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStampAndMap(
      {required int curTimeStamp,
      required Map<dynamic, dynamic> clockInMap,
      required int daily_num_times}) {
    DateTime dateTimeCurrentEnd =
        Utility.getFilterDateTimeFromTimeStamp(curTimeStamp, true);
    DateTime dateTimeCurrentStart =
        Utility.getFilterDateTimeFromTimeStamp(curTimeStamp, false);
    DateTime prevDateTime = Utility.getFilterDateTimeFromTimeStamp(0, true);
    DateTime prevDateTimeFinished = Utility.getFilterDateTimeFromTimeStamp(
        0, true); //上次完成的时间 因为有可能有些只是点击没有完成
    int total = 0;
    late List<String> keys;
    try {
      keys = clockInMap?.keys.toList() as List<String>;
    } catch (e) {
      print(e);
      keys = [];
    }
    //Keys ["yyyy-mm-dd"]  keys从小到大排序
    keys.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a);
      DateTime dateTimeB = DateTime.parse(b);
      return dateTimeA.isAfter(dateTimeB)
          ? 1
          : dateTimeA.isAtSameMomentAs(dateTimeB)
              ? 0
              : -1;
    });
    DateTime dateTimeItem = Utility.getDateTimeFromTimeStamp(0);
    for (int i = 0; i < (keys.length ?? 0); i++) {
      //每个key格式是yyyy-MM-dd 从小到大排序

      String key = keys[i] ?? "";
      List itemList = clockInMap?[key] ?? [];
      bool isFinished =
          isFlomoMissionFinishedByClockInList(itemList, daily_num_times ?? 0);
      if (key == "2023-08-12" || key == "2023-08-13" || key == "2023-08-14") {
        print("11111");
      }
      // flomoMissionModel.clockIn?.forEach((key, value) {
      dateTimeItem = DateTime.parse(key);

      if ((dateTimeItem.difference(prevDateTimeFinished).inDays.abs() < 2 ||
              i == 0) &&
          isFinished == true) {
        prevDateTime = dateTimeItem;
        prevDateTimeFinished = dateTimeItem;
        total++;
      } else {
        //超过今天不计算
        if (dateTimeItem.isAtSameMomentAs(dateTimeCurrentStart) ||
            dateTimeItem.isAfter(dateTimeCurrentStart)) {
          break;
        }
        if (dateTimeItem.difference(prevDateTime).inDays.abs() >= 2) {
          total = 0;
        }
        if (isFinished == true) {
          total++;
          prevDateTimeFinished = dateTimeItem;
        } else {
          if (dateTimeItem.difference(prevDateTime).inDays.abs() >= 2) {
            total = 0;
          }
        }
      }
      //超过今天不计算
      if (dateTimeItem.isAtSameMomentAs(dateTimeCurrentStart) ||
          dateTimeItem.isAfter(dateTimeCurrentStart)) {
        break;
      }
      if (dateTimeCurrentEnd.year == dateTimeItem.year &&
          dateTimeCurrentEnd.month == dateTimeItem.month &&
          dateTimeCurrentEnd.day == dateTimeItem.day) {
        break;
      }
    }
    if (dateTimeCurrentEnd.difference(prevDateTimeFinished).inDays > 1) {
      return 0;
    }
    // });
    return total;
  }

  static String parseYMDToYMDWeekend(String ymd) {
    if (ymd != null) {
      DateTime dateTime = DateTime.parse(ymd);
      return getDateTimeYMD(dateTime);
    }
    return "";
  }

  static List<String> sortKeys() {
    List<String> keys = [];
    return keys;
  }

  static String formatYMD(String ymd) {
    List<String> ymdList = ymd.split("-");
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < ymdList.length; i++) {
      String item = ymdList[i];
      if (i == 0) {
        sb.write(item);
      } else {
        sb.write("-");
        sb.write(formatDecimal(int.parse(item), shouldAddZero: true));
      }
    }
    return sb.toString();
  }

  static bool isFlomoMissionFinishedByClockInList(
      List itemList, int daily_num_times) {
    // int numclockin = 0;
    // for(int i = 0; i<itemList.length; i++) {
    //   // int totalClocks = itemList[i]['totalClocks'] ?? 100;
    //   numclockin++;
    // }
    if (daily_num_times <= itemList.length) {
      return true;
    }

    return false;
  }

  /**
   * 获取某个月的开始时间或者结束时间
   */
  static DateTime getFilterDateTimeOfMonth(DateTime dateTime,
      [bool isEnd = false]) {
    if (isEnd == false) {
      return DateTime(dateTime.year, dateTime.month, 1);
    } else {
      return DateTime(dateTime.year, dateTime.month + 1, 1, 23, 59, 59)
          .subtract(Duration(days: 1));
    }
  }

  static int getTotalClockInFlomoMissionModel(
      {required FlomoMissionModel flomoMissionModel,
      required CalendarModel calendarModel,
      required DateTime startDateTime,
      required DateTime endDateTime}) {
    int total = 0;
    List<DayModel> listDayModel = calendarModel.dayModelList;
    listDayModel.forEach((dayModel) {
      if ((dayModel.dateTime!.isAtSameMomentAs(startDateTime) ||
              dayModel.dateTime!.isAfter(startDateTime)) &&
          (dayModel.dateTime!.isAtSameMomentAs(endDateTime) ||
              dayModel.dateTime!.isBefore(endDateTime))) {
        dayModel.flomoMissionModelList?.forEach((flomoMissionModelTmp) {
          if (flomoMissionModelTmp.objectId == flomoMissionModel.objectId) {
            total += 1;
          }
        });
      }
    });
    return total;
  }

  /**
   * 总共打卡次数
   */
  static int totalFlomoMissionClockInFinishedByTime(
      {required Map clockInMap,
      required int daily_num_times,
      required DateTime dateTimeStart,
      required DateTime dateTimeEnd}) {
    int total = 0;
    clockInMap?.forEach((key, value) {
      DateTime dateTime = DateTime.parse(key);
      if ((dateTime.isAtSameMomentAs(dateTimeStart) ||
              dateTime.isAfter(dateTimeStart)) &&
          (dateTime.isAtSameMomentAs(dateTimeEnd) ||
              dateTime.isBefore(dateTimeEnd))) {
        if (value.length >= daily_num_times) {
          total++;
        }
      }
    });
    return total;
  }

  /**
   * 总共打卡次数
   */
  static int totalFlomoMissionClockInFinished(
      {required Map clockInMap, required int daily_num_times}) {
    int total = 0;
    clockInMap?.forEach((key, value) {
      if (value.length >= daily_num_times) {
        total++;
      }
    });
    return total;
  }

  /**
   * 是否缺卡
   */
  static bool isMissClockInAtYMD(
      {FlomoMissionModel? flomoMissionModel, required String ymd}) {
    bool isFinished = isFlomoMissionClockInFinishedAtYMD(
        flomoMissionModel: flomoMissionModel, ymd: ymd);
    DateTime dateTimeNow = Utility.getFilterDateTimeFromTimeStamp(
        DateTime.now().millisecondsSinceEpoch, false);
    return !isFinished && dateTimeNow.isAfter(DateTime.parse(ymd))
        ? false
        : true;
  }

  //提供datetime 和 monthNum，实现datetime的月份加减
  static DateTime getDateTimeAddMonth(DateTime dateTime, int monthNum) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;
    int millisecond = dateTime.millisecond;
    int microsecond = dateTime.microsecond;
    int totalMonth = year * 12 + month + monthNum;
    int newYear = totalMonth ~/ 12;
    int newMonth = totalMonth % 12;
    if (newMonth == 0) {
      newYear--;
      newMonth = 12;
    }
    return DateTime(
        newYear, newMonth, day, hour, minute, second, millisecond, microsecond);
  }

  /**
   * ymd时间是否完成了打卡
   */
  static bool isFlomoMissionClockInFinishedAtYMD(
      {FlomoMissionModel? flomoMissionModel, required String ymd}) {
    List clocksIn = flomoMissionModel?.clockIn?[ymd] ?? [];
    return (flomoMissionModel?.daily_num_times ?? 0) <= clocksIn.length;
  }

  static bool isFlomoMissionModelExistFromList(
      List<FlomoMissionModel> list, FlomoMissionModel model) {
    bool isExist = false;
    list.forEach((element) {
      if (element == model) {
        isExist = true;
      }
    });
    return isExist;
  }

  // 得到今天的 2020-01-01
  static String getYMDToday() {
    DateTime dateTime = DateTime.now();
    return dateTime.year.toString() +
        "-" +
        dateTime.month.toString() +
        "-" +
        dateTime.day.toString();
  }

  static String getYMD(DateTime dateTime) {
    // DateTime dateTime = DateTime.now();
    return dateTime.year.toString() +
        "-" +
        formatDecimal(dateTime.month, shouldAddZero: true) +
        "-" +
        formatDecimal(dateTime.day, shouldAddZero: true);
  }

  /**
   * DateTime.parse("2023-07-15 11:25:23.742568")
   */
  static DateTime getDateTimeFromYMDHMSF(String s) {
    return DateTime.parse(s);
  }

  static DateTime getLocalDateTimeFromUTCTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  }

  static String getPromptsText(
      {required String prompts, required String text}) {
    if (prompts.indexOf("{{text}}") == -1) {
      return prompts + "-" + text;
    }
    return prompts.replaceAll("{{text}}", text);
  }

  static List<Map<String, dynamic>> getJsonFromGpt(String txt) {
    // RegExp regExp = RegExp(r'\[\s*\{(.|\n)*\}\s*\]', multiLine: true);
    // Iterable<RegExpMatch> matches = regExp.allMatches();
    List<Map<String, dynamic>> list = [];
    txt = txt.replaceAll("\n", "");
    // RegExp regExp = RegExp(r'\[\s*\{(.|\n)*\}\s*\]', multiLine: true);
    // Match? match = regExp.firstMatch(txt);

    RegExp regExp = new RegExp(r'\{(.*?)\}');
    Iterable<Match> matches = regExp.allMatches(txt);

    for (Match match in matches) {
      String? matchString = match.group(0);
      if (matchString != null) {
        try {
          Map<String, dynamic> json = jsonDecode(matchString);
          list.add(json);
        } catch (e) {}
      }
      // print(matchString);
    }
    return list;
  }

  static List<SheetDataModel> getSheetDataModelFromFolderModel(
      List<FolderModel> list, IconData icon,
      [double iconSize = 15]) {
    if (list == null) {
      return [];
    }
    List<SheetDataModel> listTmp = [];
    for (var i = 0; i < list.length; i++) {
      FolderModel folderModel = list[i];
      listTmp.add(new SheetDataModel(
          index: i,
          title: folderModel.title,
          icon: Icon(
            folderModel.icon != null
                ? IconData(folderModel.icon ?? 0, fontFamily: 'MaterialIcons')
                : Icons.circle,
            color: Color(folderModel.color),
            size: iconSize,
          ),
          data: folderModel));
    }
    return listTmp;
  }

  static List<SheetDataModel> getSheetDataModelFromWQBFolderModel(
      List<WQBFolderModel> list, IconData icon,
      [double iconSize = 15]) {
    if (list == null) {
      return [];
    }
    List<SheetDataModel> listTmp = [];
    for (var i = 0; i < list.length; i++) {
      WQBFolderModel folderModel = list[i];
      listTmp.add(new SheetDataModel(
          index: i,
          title: folderModel.title,
          icon: Icon(
            folderModel.icon != null
                ? IconData(folderModel.icon ?? 0, fontFamily: 'MaterialIcons')
                : Icons.circle,
            color: Color(folderModel.color),
            size: iconSize,
          ),
          data: folderModel));
    }
    return listTmp;
  }

  static List<SheetDataModel> getSheetDataModelFromPresentModel(
      List<PresentModel> list, IconData icon, double iconSize) {
    if (list == null) {
      return [];
    }
    List<SheetDataModel> listTmp = [];
    for (var i = 0; i < list.length; i++) {
      PresentModel presentModel = list[i];
      listTmp.add(new SheetDataModel(
          index: i,
          title: presentModel.title,
          icon: Icon(
            presentModel.icon != null
                ? IconData(presentModel.icon ?? 0, fontFamily: 'MaterialIcons')
                : Icons.circle,
            size: iconSize,
            color: Color(presentModel.color ?? 0xffff8800),
          ),
          data: presentModel));
    }
    return listTmp;
  }

  /**
   * 1597478400000 , 十三位
   */
  static DateTime getDateTimeFromTimeStamp(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp);
  }

  /**
   * 浮点数得到百分比
   */
  static String getPercent(double percent) {
    return (percent * 100).toInt().toString() + "%";
  }

  static String getPercentByDN(
      {required double denominator, required double nominator}) {
    if (nominator == 0 || denominator == 0) {
      return "0%";
    }
    return (nominator / denominator * 100).toInt().toString() + "%";
  }

  static Map? getDiffPercent(int valuePrev, int value) {
    if (valuePrev == 0 && value == 0) {
      return {'percentDiff': '0%', 'isUp': value > valuePrev ? true : false};
    } else if (valuePrev == 0 && value > 0) {
      return {'percentDiff': '100%', 'isUp': value > valuePrev ? true : false};
    } else if (valuePrev > 0 && value == 0) {
      return {'percentDiff': '100%', 'isUp': value > valuePrev ? true : false};
    } else if (valuePrev > 0 && value > 0) {
      return {
        'percentDiff':
            ((valuePrev - value) / valuePrev).toStringAsFixed(1).toString() +
                '%',
        'isUp': value > valuePrev ? true : false
      };
    }
  }

  /**
   * datetime 2020-08-15 16:00:00.000
   */
  static int getTimestampFromDateTime(String datetime) {
    return DateTime.parse(datetime).millisecondsSinceEpoch;
  }

  static DateTime getDateTimeFromDateTimeString(String datetime) {
    return DateTime.parse(datetime);
  }

  static String toFixed(int number, [int n = 2]) {
    if (number.toString().length < n) {
      String s = number.toString();
      int dif = n - number.toString().length;
      for (int i = 0; i < dif; i++) {
        s = "0" + s;
      }
      return s;
    } else {
      return number.toString();
    }
  }

  /**
   * 显示时间选择对话框
   */
  static Future<DateTimeModel?> showDateTimePickerDialog(
      BuildContext context) async {
    String datetime = '';
    Locale myLocale = Localizations.localeOf(context);
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(DateTime.now().year + 1000),
        locale: myLocale);
    if (picker == null) {
      return null;
    }
    datetime = toFixed(picker.year) +
        "-" +
        toFixed(picker.month) +
        "-" +
        toFixed(picker.day);
    TimeOfDay? res = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    if (res == null) {
      return null;
    }
    String dateTimeToShow =
        datetime + " " + toFixed(res.hour) + ":" + toFixed(res.minute);
    datetime += " " + toFixed(res.hour) + ":" + toFixed(res.minute) + ":00.000";
    DateTimeModel model = DateTimeModel(
        isThisWeek: Utility.isThisWeek(picker),
        isNextWeek: Utility.isNextWeek(picker),
        isLastWeek: Utility.isLastWeek(picker),
        dayOfWeek: picker.weekday,
        timestamp: getTimestampFromDateTime(datetime),
        datetimeToShow: dateTimeToShow,
        datetime: DateTime(
            picker.year, picker.month, picker.day, res.hour, res.minute),
        datetimeString: datetime);
    return model;
  }

  /**
   * 是否是今天
   */
  static bool isTodayByTimestamp(int timestamp) {
    DateTime dateTime = timeStampToDateTime(timestamp);
    DateTime dateTimeNow = DateTime.now();
    return dateTime.year == dateTimeNow.year &&
        dateTime.month == dateTimeNow.month &&
        dateTime.day == dateTimeNow.day;
  }

  static bool isToday(
      {required DateTime datetime1, required DateTime datetime2}) {
    if (datetime1.year == datetime2.year &&
        datetime1.month == datetime2.month &&
        datetime1.day == datetime2.day) {
      return true;
    }
    return false;
  }

  static String getYearMonthAndDay(DateTime datetime) {
    return "${datetime.year}/${datetime.month}/${datetime.day}";
  }

  /**
   * 是否在几天范围内
   */
  static bool getLimitOfDay(int timestamp, int day) {
    DateTime dateTime =
        timeStampToDateTime(timestamp + day * 24 * 60 * 60 * 1000);
    DateTime dateTimeNow = DateTime.now();
    return dateTime.year > dateTimeNow.year ||
        dateTime.month > dateTimeNow.month ||
        dateTime.day > dateTimeNow.day;
  }

  /**
   * 返回 2000年12月12日 12:11
   */
  static String getDateString(int timestamp,
      {required bool year,
      required bool month,
      required bool day,
      required bool hour,
      required bool minute}) {
    DateTime dateTime = timeStampToDateTime(timestamp);
    String s = "";
    if (year == true) {
      s = s + dateTime.year.toString() + '年';
    }
    if (month == true) {
      s = s + dateTime.month.toString() + '月';
    }
    if (day == true) {
      s = s + dateTime.day.toString() + '日';
    }
    s = s + ' ';
    if (hour == true) {
      s = s + hour.toString() + ':';
    }
    if (minute == true) {
      s = s + minute.toString();
    }
    return s;
  }

  /**
   * 获取是星期几
   */
  static String getWeekOfDayByTimeStamp(int timestamp, int delay) {
    DateTime dateTime = timeStampToDateTime(timestamp + delay);
    if (dateTime.weekday == 1) {
      return getI18NKey().monday;
    } else if (dateTime.weekday == 2) {
      return getI18NKey().tuesday;
    } else if (dateTime.weekday == 3) {
      return getI18NKey().wednesday;
    } else if (dateTime.weekday == 4) {
      return getI18NKey().thursday;
    } else if (dateTime.weekday == 5) {
      return getI18NKey().friday;
    } else if (dateTime.weekday == 6) {
      return getI18NKey().saturday;
    } else if (dateTime.weekday == 7) {
      return getI18NKey().sunday;
    }
    return "";
  }

  // static int getWeekDayInt(int weekDay) {
  //   if(weekday == 7) {
  //     return 6;
  //   } else {
  //
  //   }
  // }

  static String getWeekDay(int? weekDay) {
    if (weekDay == 1) {
      return getI18NKey().monday;
    } else if (weekDay == 2) {
      return getI18NKey().tuesday;
    } else if (weekDay == 3) {
      return getI18NKey().wednesday;
    } else if (weekDay == 4) {
      return getI18NKey().thursday;
    } else if (weekDay == 5) {
      return getI18NKey().friday;
    } else if (weekDay == 6) {
      return getI18NKey().saturday;
    } else if (weekDay == 7) {
      return getI18NKey().sunday;
    }
    return "";
  }

  static int getYearDiffByYearFromTimeStamp(int timeStamp1, int timestamp2) {
    DateTime dateTime1 = DateTime(timeStamp1);
    DateTime dateTime2 = DateTime(timestamp2);
    return dateTime1.year - dateTime2.year > 0
        ? 1
        : dateTime1.year - dateTime2.year == 0
            ? 0
            : -1;
  }

  static int getMonthDiffByMonthFromTimeStamp(int timeStamp1, int timestamp2) {
    DateTime dateTime1 = DateTime(timeStamp1);
    DateTime dateTime2 = DateTime(timestamp2);
    int year = (timeStamp1 - timestamp2) % 365;
    int months = year % 12;
    return months > 0
        ? 1
        : months == 0
            ? 0
            : -1;
  }

  static DateTime getFilterDateTimeFromDateTime(DateTime dateTime,
      [bool isEndOfDay = false]) {
    // DateTime dateTime = timeStampToDateTime(timeStamp);
    if (!isEndOfDay) {
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    } else {
      return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
    }
  }

  /**
   * 从时间戳转换时间 默认是
   * 2021-10-01 00:00:00
   * 如果isEndOfDay为true 2021-10-01 23:59:59
   * 2022 12 22 22:11:00 => 2022 12 22 00:00:00
   */
  static DateTime getFilterDateTimeFromTimeStamp(int timeStamp,
      [bool isEndOfDay = false]) {
    DateTime dateTime = timeStampToDateTime(timeStamp);
    if (!isEndOfDay) {
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    } else {
      return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
    }
  }

  /**
   * 从时间戳转换时间 默认是
   * 2021-10-01 00:00:00
   * 如果isEndOfDay为true 2021-10-31 23:59:59
   */
  static DateTime getFilterMonthDateTimeFromTimeStamp(int timeStamp,
      [bool isEndOfDay = false]) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    if (!isEndOfDay) {
      return DateTime(dateTime.year, dateTime.month, 1);
    } else {
      int lastDay = DateTime(dateTime.year, dateTime.month + 1, 0).day;
      return DateTime(dateTime.year, dateTime.month, lastDay, 23, 59, 59);
    }
  }

  static String getTimeString({int? startTime, int? endTime}) {
    if (startTime != null && endTime != null) {
      return Utility.formatHourAndMin2(startTime ?? 0) +
          "-" +
          Utility.formatHourAndMin2(endTime ?? 0);
    } else if (startTime != null) {
      return Utility.formatHourAndMin2(startTime ?? 0);
    } else {
      return getI18NKey().unset;
    }
  }

  static int getDayDiffByDayFromTimeStamp(int timeStamp1, int timeStamp2) {
    int days1 =
        getFilterDateTimeFromTimeStamp(timeStamp1).millisecondsSinceEpoch ~/
            (24 * 60 * 60 * 1000);
    int days2 =
        getFilterDateTimeFromTimeStamp(timeStamp2).millisecondsSinceEpoch ~/
            (24 * 60 * 60 * 1000);
    return days1 - days2;
  }

  static int getWeekDiffByWeekFromTimeStamp(int timeStamp1, int timestamp2) {
    int days1 = timeStamp1 ~/ (7 * 24 * 60 * 60 * 1000);
    int days2 = timeStamp1 ~/ (7 * 24 * 60 * 60 * 1000);
    return days1 - days2;
  }

  static bool isThisWeekLimit(int startTime,
      {int repetiveValue = 0,
      bool monday = false,
      bool tuesday = false,
      bool wednesday = false,
      bool thursday = false,
      bool friday = false,
      bool saturday = false,
      bool sunday = false}) {
    startTime =
        getFilterDateTimeFromTimeStamp(startTime).millisecondsSinceEpoch;
    int nowTime =
        getFilterDateTimeFromTimeStamp(DateTime.now().millisecondsSinceEpoch)
            .millisecondsSinceEpoch;

    int numberthOfWeek = (startTime + 2 * 24 * 60 * 60 * 1000) ~/
        (7 * 24 * 60 * 60 * 1000); //第几个星期
    int numberthOfWeekNow = (nowTime + 2 * 24 * 60 * 60 * 1000) ~/
        (7 * 24 * 60 * 60 * 1000); //第几个星期

    DateTime startDateTime = timeStampToDateTime(startTime);
    List listDayOfWeekend = [];
    listDayOfWeekend.add(monday ? 1 : 0);
    listDayOfWeekend.add(tuesday ? 1 : 0);
    listDayOfWeekend.add(wednesday ? 1 : 0);
    listDayOfWeekend.add(thursday ? 1 : 0);
    listDayOfWeekend.add(friday ? 1 : 0);
    listDayOfWeekend.add(saturday ? 1 : 0);
    listDayOfWeekend.add(sunday ? 1 : 0);
    int minDay = 0;
    int maxDay = listDayOfWeekend.length - 1;
    for (minDay = 0; minDay < listDayOfWeekend.length; minDay++) {
      if (listDayOfWeekend[minDay] == 1) {
        break;
      }
    }

    for (maxDay = listDayOfWeekend.length - 1; maxDay >= 0; maxDay--) {
      if (listDayOfWeekend[maxDay] == 1) {
        break;
      }
    }
    //
    if ((numberthOfWeek - numberthOfWeekNow) % repetiveValue == 0 &&
        startDateTime.weekday < (maxDay + 1)) {
      return true;
    }
    return false;
  }

  static int isThisWeekEndTime(int startTime,
      {int repetiveValue = 0,
      bool monday = false,
      bool tuesday = false,
      bool wednesday = false,
      bool thursday = false,
      bool friday = false,
      bool saturday = false,
      bool sunday = false}) {
    startTime =
        getFilterDateTimeFromTimeStamp(startTime).millisecondsSinceEpoch;
    int nowTime =
        getFilterDateTimeFromTimeStamp(DateTime.now().millisecondsSinceEpoch)
            .millisecondsSinceEpoch;

    int numberthOfWeek = (startTime + 2 * 24 * 60 * 60 * 1000) ~/
        (7 * 24 * 60 * 60 * 1000); //第几个星期
    int numberthOfWeekNow = (nowTime + 2 * 24 * 60 * 60 * 1000) ~/
        (7 * 24 * 60 * 60 * 1000); //第几个星期
    int decalage = (numberthOfWeek - numberthOfWeekNow) % repetiveValue;
    int weekday = DateTime.now().weekday;

    List listDayOfWeekend = [];
    listDayOfWeekend.add(monday ? 1 : 0);
    listDayOfWeekend.add(tuesday ? 1 : 0);
    listDayOfWeekend.add(wednesday ? 1 : 0);
    listDayOfWeekend.add(thursday ? 1 : 0);
    listDayOfWeekend.add(friday ? 1 : 0);
    listDayOfWeekend.add(saturday ? 1 : 0);
    listDayOfWeekend.add(sunday ? 1 : 0);
    int minDay = 0;
    for (minDay = 0; minDay < listDayOfWeekend.length; minDay++) {
      if (minDay > weekday) {
        return decalage * 7 * 24 * 60 * 60 * 1000 +
            startTime +
            (minDay - DateTime.now().weekday) * 24 * 60 * 60 * 1000;
      }
    }
    return 0;
  }

  static int isNextWeekEndTime(int startTime,
      {int repetiveValue = 0,
      bool monday = false,
      bool tuesday = false,
      bool wednesday = false,
      bool thursday = false,
      bool friday = false,
      bool saturday = false,
      bool sunday = false}) {
    startTime =
        getFilterDateTimeFromTimeStamp(startTime).millisecondsSinceEpoch;
    int nowTime =
        getFilterDateTimeFromTimeStamp(DateTime.now().millisecondsSinceEpoch)
            .millisecondsSinceEpoch;

    int numberthOfWeek = (startTime + 2 * 24 * 60 * 60 * 1000) ~/
        (7 * 24 * 60 * 60 * 1000); //第几个星期
    int numberthOfWeekNow = (nowTime + 2 * 24 * 60 * 60 * 1000) ~/
        (7 * 24 * 60 * 60 * 1000); //第几个星期
    int decalage =
        (repetiveValue - (numberthOfWeek - numberthOfWeekNow) % repetiveValue);

    // DateTime startDateTime = timeStampToDateTime(startTime);
    List listDayOfWeekend = [];
    listDayOfWeekend.add(monday ? 1 : 0);
    listDayOfWeekend.add(tuesday ? 1 : 0);
    listDayOfWeekend.add(wednesday ? 1 : 0);
    listDayOfWeekend.add(thursday ? 1 : 0);
    listDayOfWeekend.add(friday ? 1 : 0);
    listDayOfWeekend.add(saturday ? 1 : 0);
    listDayOfWeekend.add(sunday ? 1 : 0);
    int minDay = 0;
    for (minDay = 0; minDay < listDayOfWeekend.length; minDay++) {
      if (listDayOfWeekend[minDay] == 1) {
        break;
      }
    }
    int endTime = numberthOfWeek * 7 * 24 * 60 * 60 * 1000 +
        decalage * 7 * 24 * 60 * 60 * 1000 +
        (1 + minDay + 3) * 24 * 60 * 60 * 1000; // todo  为什么是3
    return endTime;
  }

  /**
   * 用于缓存专注时离开app再次进入时的数据 防止销毁的情况发生
   * 用于重新初始化
   */
  static reinitBottomCounter() {
    String objectId = SharePreferenceUtil.getSyncInstance().getString(
        key: ShareprefrenceKeys.curFocusingMissionObjectIdKey, defaultVal: "");

    if (!TextUtil.isEmpty(objectId)) {
      int timeUsed = SharePreferenceUtil.getSyncInstance().getInt(
          key: ShareprefrenceKeys.curFocusingMissionObjectIdForTimeUsedKey,
          defaultVal: 0);
      int totalTime = SharePreferenceUtil.getSyncInstance().getInt(
          key: ShareprefrenceKeys.curFocusingMissionObjectIdForTotalTimeFKey,
          defaultVal: 0);
      int curTimeF = SharePreferenceUtil.getSyncInstance().getInt(
          key: ShareprefrenceKeys.curFocusingMissionObjectIdForCurTimeFKey,
          defaultVal: 0);

      MissionModel missionModel = MongoApisManager.getInstance()
              ?.queryWhereEqual_missionDataByObjectId(objectId: objectId) ??
          MissionModel();

      FolderModel folderModel = MongoApisManager.getInstance()
              ?.queryfolderModelWithFolderId(missionModel?.folder_id) ??
          FolderModel();
      CounterManagement.getInstance().folderModel = folderModel;
      CounterManagement.getInstance().missionModel = missionModel;
      CounterManagement.getInstance().timeUsed = timeUsed;
      CounterManagement.getInstance().totalTime = totalTime;
      CounterManagement.getInstance().curTimeF = curTimeF;
      CounterManagement.getInstance().counterStatus =
          CounterStatus.pausingFocusing;
      CounterEnum counterEnum = CounterEnum.values[
          SharePreferenceUtil.getSyncInstance()
              .getInt(key: ShareprefrenceKeys.timerModel, defaultVal: 0)];
      CounterManagement.getInstance().init(
        counterEnum: counterEnum,
        missionModel: missionModel,
        folderModel: folderModel,
        // missionDetailPageState: this,
      );

      CounterManagement.getInstance().reset();
      CounterManagement.getInstance().continueFromStartTime(
          missionModel: missionModel,
          counterStatus: CounterStatus.focusing,
          counterEnum: counterEnum,
          timeHasUsed: timeUsed);
    }
  }

  static bool isThisMonthLimit(int startTime, {int repetiveValue = 9}) {
    DateTime dateTime = timeStampToDateTime(startTime);
    DateTime dateTimeNow = DateTime.now();
    return (dateTime.month - dateTimeNow.month) % repetiveValue == 0 &&
        dateTime.day > dateTimeNow.day;
  }

  static DateTimeModel getDateTimeModelFromTimeStamp(int timestamp) {
    DateTime model = timeStampToDateTime(timestamp);
    return DateTimeModel(
        isThisWeek: Utility.isThisWeek(model),
        isNextWeek: Utility.isNextWeek(model),
        isLastWeek: Utility.isLastWeek(model),
        dayOfWeek: model.weekday,
        timestamp: model.millisecondsSinceEpoch,
        datetimeToShow: "",
        datetime: model,
        datetimeString: "");
  }

  static DateTime? getGPTUTCDateTimeFromStringYToDatetime(
      String? dateTimeString,
      {DateTime? defaultDateTime = null}) {
    if (!TextUtil.isEmpty(dateTimeString)) {
      DateTime dateTimeUTCFromGTP =
          getUtcDateTimeToLocalFromString(dateTimeString!);
      DateTime dateTime = DateTime(
          dateTimeUTCFromGTP.year,
          dateTimeUTCFromGTP.month,
          dateTimeUTCFromGTP.day,
          dateTimeUTCFromGTP.hour,
          dateTimeUTCFromGTP.minute,
          dateTimeUTCFromGTP.second);
      return dateTime;
    } else {
      return defaultDateTime;
    }
  }

  static int? getGPTUTCDateTimeFromStringYToTimestamp(String? dateTimeString,
      {DateTime? defaultDateTime = null}) {
    if (!TextUtil.isEmpty(dateTimeString)) {
      DateTime dateTimeUTCFromGTP = getUtcDateTimeFromString(dateTimeString!);
      DateTime dateTime = DateTime(
          dateTimeUTCFromGTP.year,
          dateTimeUTCFromGTP.month,
          dateTimeUTCFromGTP.day,
          dateTimeUTCFromGTP.hour,
          dateTimeUTCFromGTP.minute,
          dateTimeUTCFromGTP.second);
      return dateTime.millisecondsSinceEpoch;
    } else {
      return defaultDateTime?.millisecondsSinceEpoch;
    }
  }

  /**
   * "2023-02-24 15:30:00"转成dateTime
   */
  static DateTime getUtcDateTimeFromString(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  static DateTime getUtcDateTimeToLocalFromString(String utcTimeString) {
    // 解析UTC时间字符串为DateTime对象
    DateTime utcTime = DateTime.parse(utcTimeString);
    // 使用正则表达式匹配年、月、日、小时、分钟、秒 2024-03-26 08:30:00.000Z
    RegExp regExp = RegExp(r'(\d{4})-(\d{2})-(\d{2}).?(\d{2}):(\d{2}):(\d{2})');
    var matches = regExp.firstMatch(utcTimeString);

    if (matches != null) {
      // 提取并转换为整数
      int year = int.parse(matches.group(1)!);
      int month = int.parse(matches.group(2)!);
      int day = int.parse(matches.group(3)!);
      int hour = int.parse(matches.group(4)!);
      int minute = int.parse(matches.group(5)!);
      int second = int.parse(matches.group(6)!);

      // 使用提取的值创建DateTime对象
      DateTime dateTime = DateTime(year, month, day, hour, minute, second);
      return dateTime;
      // 打印结果
      print("DateTime: $dateTime");
    } else {
      print("No matches found!");
    }

    return utcTime.toLocal();
  }

  /**
   * 用于添加奥推送
   * dayoftime的alertTime时间戳
   */
  static DateTime getDateTimeFromDateTimeAndTimeStamp(
      DateTime dateTime, int timestampDayOfTime) {
    DateTime dateTimeDayOfTime = getTimeOfDayFromTimeStamp(timestampDayOfTime);
    return getUtcDateTimeFromString(
        '${Utility.formatDecimal(dateTime.year)}-${Utility.formatDecimal(dateTime.month, shouldAddZero: true)}-${Utility.formatDecimal(dateTime.day, shouldAddZero: true)} ${Utility.formatDecimal(dateTimeDayOfTime.hour, shouldAddZero: true)}:${Utility.formatDecimal(dateTimeDayOfTime.minute, shouldAddZero: true)}:${Utility.formatDecimal(dateTimeDayOfTime.second, shouldAddZero: true)}');
  }

  /**
   * 把时间戳转换成DateTime
   */
  static DateTime getTimeOfDayFromTimeStamp(int timestamp) {
    int hour = Utility.getHourFromTimeStamp(timestamp);
    int min = Utility.getMinsFromTimeStamp(timestamp);
    DateTime dateTime = Utility.getUtcDateTimeFromString(
        "2000-01-01 ${Utility.formatDecimal(hour, shouldAddZero: true)}:${Utility.formatDecimal(min, shouldAddZero: true)}:00");
    return dateTime;
  }

  /**
   * 从dateTime获取对应的小时和分钟
   */
  static String getHourAndMinsFromDateTimeFromTimeStamp(int timestamp) {
    try {
      int hour = Utility.getHourFromTimeStamp(timestamp);
      int min = Utility.getMinsFromTimeStamp(timestamp);
      if (hour < 24) {
        DateTime dateTime = Utility.getUtcDateTimeFromString(
            "2000-01-01 ${Utility.formatDecimal(hour, shouldAddZero: true)}:${Utility.formatDecimal(min, shouldAddZero: true)}:00");
        // return dateTime;
        return "${Utility.formatDecimal(dateTime.hour)}:${Utility.formatDecimal(dateTime.minute)}";
      } else {
        "";
      }
    } catch (e) {}
    return "";
  }

  /**
   * 从dateTime获取对应的小时和分钟
   */
  static String getHourAndMinsFromDateTime(DateTime dateTime) {
    return "${Utility.formatDecimal(dateTime.hour)}:${Utility.formatDecimal(dateTime.minute)}";
  }

  static Future<DateTime?> showDatePickerDialogWithDateTime(
      BuildContext context,
      [int timestamp = 0]) async {
    String datetime = '';
    Locale myLocale = Localizations.localeOf(context);
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: (timestamp != null && timestamp != 0)
            ? getDateTimeFromTimeStamp(timestamp)
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 3),
        locale: myLocale);
    if (picker == null) {
      return null;
    }
    datetime = toFixed(picker.year) +
        "-" +
        toFixed(picker.month + 1) +
        "-" +
        toFixed(picker.day);
    // String dateTimeToShow = datetime + " " + toFixed(res.hour) + ":" + toFixed(res.minute);
    datetime += " " + "00:00.000";
    String dateTimeToShow = "";
    // DateTimeModel model = DateTimeModel(
    //     isThisWeek: Utility.isThisWeek(picker),
    //     isNextWeek: Utility.isNextWeek(picker),
    //     isLastWeek: Utility.isLastWeek(picker),
    //     dayOfWeek: picker.weekday,
    //     timestamp: picker.millisecondsSinceEpoch,
    //     datetimeToShow: dateTimeToShow,
    //     datetime: picker,
    //     datetimeString: datetime);
    return picker;
  }

  static Future<DateTimeModel?> showDatePickerDialog(BuildContext context,
      [int timestamp = 0]) async {
    String datetime = '';
    Locale myLocale = Localizations.localeOf(context);
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: (timestamp != null && timestamp != 0)
            ? getDateTimeFromTimeStamp(timestamp)
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 3),
        locale: myLocale);
    if (picker == null) {
      return null;
    }
    datetime = toFixed(picker.year) +
        "-" +
        toFixed(picker.month + 1) +
        "-" +
        toFixed(picker.day);
    // String dateTimeToShow = datetime + " " + toFixed(res.hour) + ":" + toFixed(res.minute);
    datetime += " " + "00:00.000";
    String dateTimeToShow = "";
    DateTimeModel model = DateTimeModel(
        isThisWeek: Utility.isThisWeek(picker),
        isNextWeek: Utility.isNextWeek(picker),
        isLastWeek: Utility.isLastWeek(picker),
        dayOfWeek: picker.weekday,
        timestamp: picker.millisecondsSinceEpoch,
        datetimeToShow: dateTimeToShow,
        datetime: picker,
        datetimeString: datetime);
    return model;
  }

  static Future<TimeOfDay?> showTimePickerDialog(BuildContext context) async {
    TimeOfDay? res = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    );
    return res;
  }

  static Future<DateTime?> showYearPickerDialogWithDateTime(
      BuildContext context,
      [int timestamp = 0]) async {
    String datetime = '';
    Locale myLocale = Localizations.localeOf(context);
    DateTime? picker = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: (timestamp != null && timestamp != 0)
            ? getDateTimeFromTimeStamp(timestamp)
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 3),
        locale: myLocale);
    if (picker == null) {
      return null;
    }
    return picker;
  }

  static Future<DateTime?> showDayPickerDialogWithDateTime(BuildContext context,
      [int timestamp = 0]) async {
    String datetime = '';
    Locale myLocale = Localizations.localeOf(context);
    DateTime? picker = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: (timestamp != null && timestamp != 0)
            ? getDateTimeFromTimeStamp(timestamp)
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 3),
        locale: myLocale);
    if (picker == null) {
      return null;
    }
    return picker;
  }

  /**
   * 时间戳转换时间
   */
  static DateTime timeStampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /**
   * 是否是本周
   * 周日 一 二 三 四 五 六
   */
  static bool isThisWeek(DateTime dateTimeTmp) {
    DateTime dateTimeNow = DateTime.now();
    int dateTimeStamp =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 0, 0, 0)
            .millisecondsSinceEpoch;
    int dateTimeStampOfFirstDate =
        dateTimeStamp - DateTime.now().weekday * 24 * 60 * 60 * 1000; //周日
    int dateTimeStampOfSaturdayDate =
        dateTimeStamp + (6 - DateTime.now().weekday) * 24 * 60 * 60 * 1000; //周六

    DateTime dateTimeStampOfFirstDateDateTime =
        timeStampToDateTime(dateTimeStampOfFirstDate);
    DateTime dateTimeStampOfSaturdayDateDateTime =
        timeStampToDateTime(dateTimeStampOfSaturdayDate);

    if (dateTimeTmp.isAfter(dateTimeStampOfFirstDateDateTime) &&
        dateTimeTmp.isBefore(dateTimeStampOfSaturdayDateDateTime)) {
      return true;
    }
    return false;
  }

  /**
   * 是否是下周
   */
  static bool isNextWeek(DateTime dateTimeTmp) {
    DateTime dateTimeNow = DateTime.now();
    int dateTimeStamp =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 0, 0, 0)
            .millisecondsSinceEpoch;
    int dateTimeStampOfFirstDate = dateTimeStamp -
        DateTime.now().weekday * 24 * 60 * 60 * 1000 +
        7 * 24 * 60 * 60 * 1000; //周日
    int dateTimeStampOfSaturdayDate = dateTimeStamp +
        (6 - DateTime.now().weekday) * 24 * 60 * 60 * 1000 +
        7 * 24 * 60 * 60 * 1000; //周六

    DateTime dateTimeStampOfFirstDateDateTime =
        timeStampToDateTime(dateTimeStampOfFirstDate);
    DateTime dateTimeStampOfSaturdayDateDateTime =
        timeStampToDateTime(dateTimeStampOfSaturdayDate);

    if (dateTimeTmp.isAfter(dateTimeStampOfFirstDateDateTime) &&
        dateTimeTmp.isBefore(dateTimeStampOfSaturdayDateDateTime)) {
      return true;
    }
    return false;
  }

  /**
   * 注册页和登录页跳转到首页 顺便更新用户Uid
   */
  static toMainPage(BuildContext context) async {
    await MongoApisManager.getInstance().batchUpdate_FolderModel();
    await MongoApisManager.getInstance().batchUpdate_MissionModel();
    await MongoApisManager.getInstance().batchUpdate_StatsModel();
    await MongoApisManager.getInstance().batchUpdate_TimelineMissionModel();
    Utility.pushAndRemoveUntil(context, MobileTabBarHome(), 'BottomTabBarHome');
  }

  /**
   * 是否是上周
   */
  static bool isLastWeek(DateTime dateTimeTmp) {
    DateTime dateTimeNow = DateTime.now();
    int dateTimeStamp =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 0, 0, 0)
            .millisecondsSinceEpoch;
    int dateTimeStampOfFirstDate = dateTimeStamp -
        DateTime.now().weekday * 24 * 60 * 60 * 1000 -
        7 * 24 * 60 * 60 * 1000; //周日
    int dateTimeStampOfSaturdayDate = dateTimeStamp +
        (6 - DateTime.now().weekday) * 24 * 60 * 60 * 1000 -
        7 * 24 * 60 * 60 * 1000; //周六

    DateTime dateTimeStampOfFirstDateDateTime =
        timeStampToDateTime(dateTimeStampOfFirstDate);
    DateTime dateTimeStampOfSaturdayDateDateTime =
        timeStampToDateTime(dateTimeStampOfSaturdayDate);

    if (dateTimeTmp.isAfter(dateTimeStampOfFirstDateDateTime) &&
        dateTimeTmp.isBefore(dateTimeStampOfSaturdayDateDateTime)) {
      return true;
    }
    return false;
  }

  /**
   * 用于设置屏幕是否始终打开
   */
  // void setScreenWakeLockOn({bool enable}) async {
  //   bool wakelockEnabled = await Wakelock.enabled;
  //   if (wakelockEnabled == true) {
  //     Wakelock.disable();
  //   } else {
  //     Wakelock.enable();
  //   }
  // }

  static Future<Uint8List> _loadFileBytes(Uri url, {OnError? onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  /**
   * 下载音乐
   */
  static Future<String?> downloadFileByUrl(String url,
      {String title = "audio", String extension = "mp3"}) async {
    final bytes = await _loadFileBytes(Uri.parse(url),
        onError: (Exception exception) =>
            print('_loadFile => exception $exception'));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$title.$extension');
    await file.writeAsBytes(bytes);
    if (await file.exists()) return file.path;
    return null;
    //   setState(() {
    //     localFilePath = ;
    //   });
  }

  static int compareVersion(String version1, version2) {
    List<String> version1Arr = version1.split('.');
    List<String> version2Arr = version2.split('.');
    int lengMin = version1Arr.length > version2Arr.length
        ? version2Arr.length
        : version1Arr.length;
    for (int i = 0; i < lengMin; i++) {
      try {
        String num1 = version1Arr[i].trim() ?? "0";
        String num2 = version2Arr[i].trim() ?? "0";
        if (int.parse(num1) > int.parse(num2)) {
          return 1;
        } else if (int.parse(num1) < int.parse(num2)) {
          return -1;
        } else {}
      } catch (e) {}
    }
    return 0;
  }

  static void openUrl({url = 'https://flutter.cn'}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  static void exitApp({force = false}) {
    if (force == false) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  /// 检查当前版本是否为最新，若不是，则更新
  static void getCurrentVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // this.curVersion = packageInfo.version;
      Params.curVersion = packageInfo.version;
    });
  }

  static void initMusicModel() async {
    if (SharePreferenceUtil.getSyncInstance().getFinishRestingMusicModel() ==
        null) {
      MusicModel musicModel = CONSTANTS.getMusicModelList()[0];
      //下载音乐
      String? localPath = await Utility.downloadFileByUrl(musicModel.url ?? "",
          title: musicModel.title ?? "");
      musicModel.localPath = localPath ?? "";
      //保存到Model
      SharePreferenceUtil.getSyncInstance()
          .setFinishRestingMusicModel(musicModel);
      //设置专注完成音乐
      SharePreferenceUtil.getSyncInstance()
          .setFinishFocusingMusicModel(musicModel);
    }
  }

  /**
   * 对于比如每日的 每周的 每月的 需要在这里支持
   */
  static initCalendarModelWithRepetiveTypes(
      {required CalendarModel calendarModel,
      List<MissionModel>? listMissionModels}) {
    List<MissionModel> datas = MongoApisManager.getInstance()
        .queryWhereEqual_missionDataByRepetiveTypes(
            listMissionModel: listMissionModels, repetiveType: [1, 2, 3, 4]);
    for (int i = 0; i < datas.length; i++) {
      MissionModel missionModel = datas[i];
      if (missionModel.repetiveType == 1) {
        insertMissionModelWithRepetiveType1(
            calendarModel: calendarModel, missionModel: missionModel);
      } else if (missionModel.repetiveType == 2) {
        insertMissionModelWithRepetiveType2(
            calendarModel: calendarModel, missionModel: missionModel);
      } else if (missionModel.repetiveType == 3) {
        insertMissionModelWithRepetiveType3(
            calendarModel: calendarModel, missionModel: missionModel);
      } else if (missionModel.repetiveType == 4) {
        //todo 每年
      }
    }
  }

  static initCalendarModelWithYearModel(
      {required CalendarModel calendarModel}) {
    List<DayModel> list = calendarModel.dayModelList;
    //把dayModel从周日到周六放到calendarModel.weekModelList中
    WeekModel? weekModel;
    for (int i = 0; i < list.length; i++) {
      DayModel dayModel = list[i];
      if (dayModel.weekday == DateTime.sunday) {
        weekModel = WeekModel();
      }
      weekModel?.dayModelList.add(dayModel);
      // else if (dayModel.weekday == 2) {
      //   calendarModel.weekModelList[1].dayModelList.add(dayModel);
      // } else if (dayModel.weekday == 3) {
      //   calendarModel.weekModelList[2].dayModelList.add(dayModel);
      // } else if (dayModel.weekday == 4) {
      //   calendarModel.weekModelList[3].dayModelList.add(dayModel);
      // } else if (dayModel.weekday == 5) {
      //   calendarModel.weekModelList[4].dayModelList.add(dayModel);
      // } else if (dayModel.weekday == 6) {
      //   calendarModel.weekModelList[5].dayModelList.add(dayModel);
      // } else if (dayModel.weekday == 7) {
      //   calendarModel.weekModelList[6].dayModelList.add(dayModel);
      // }
      if (dayModel.weekday == DateTime.sunday && weekModel != null) {
        calendarModel.weekModelList.add(weekModel);
      }
    }
  }

  /**
   * 获取当前日期所在周的日期范围 周日到周六
   * @param currentDate 当前日期
   * @return 返回一个包含本周开始日期和结束日期的Map
   */
  static Map<String, DateTime> getCurrentThisWeekRange(DateTime currentDate) {
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return {
      'startOfWeek': startOfWeek,
      'endOfWeek': endOfWeek,
    };
  }

  /**
   * 对于比如每日的 每周的 每月的 需要在这里支持
   */
  static initCalendarModelWithRepetiveTypesForFlomoMissionModels(
      {required CalendarModel calendarModel}) {
    try {
      List<FlomoMissionModel> datas = MongoApisManager.getInstance()
          .queryWhereEqual_flomoMissionDataByRepetiveTypes(
              repetiveType: [1, 2, 3, 4]);
      for (int i = 0; i < datas.length; i++) {
        FlomoMissionModel missionModel = datas[i];
        if (missionModel.repetiveType == 1) {
          insertFlomoMissionModelWithRepetiveType1(
              //每日
              calendarModel: calendarModel,
              missionModel: missionModel);
        } else if (missionModel.repetiveType == 2) {
          //每周
          insertFlomoMissionModelWithRepetiveType2(
              calendarModel: calendarModel, missionModel: missionModel);
        } else if (missionModel.repetiveType == 3) {
          //艾宾浩斯记忆曲线
          insertFlomoMissionModelWithRepetiveType4(
              calendarModel: calendarModel, missionModel: missionModel);
        }
        // else if (missionModel.repetiveType == 3) {
        //   insertMissionModelWithRepetiveType3(
        //       calendarModel: calendarModel, missionModel: missionModel);
        // }
        else if (missionModel.repetiveType == 4) {
          //todo 每年
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static bool isSameDay(int timestamp1, int timestamp2) {
    DateTime timestamp1Tmp = Utility.getDateTimeFromTimeStamp(timestamp1);
    DateTime timestamp2Tmp = Utility.getDateTimeFromTimeStamp(timestamp2);
    if (timestamp1Tmp.year == timestamp2Tmp.year ||
        timestamp1Tmp.month == timestamp2Tmp.month ||
        timestamp1Tmp.day == timestamp2Tmp.day) {
      return true;
    }
    return false;
  }

  /**
   * 两个时间相隔几个星期
   * 比如 这周日 和下周一
   * 返回1
   * timeStamp1是参考时间
   * timeStemp2是比较时间
   */
  static getDifferByWeek(int timeStamp1, int timestamp2) {
    DateTime dateTime1 = Utility.getDateTimeFromTimeStamp(timeStamp1);
    DateTime dateTime2 = Utility.getDateTimeFromTimeStamp(timestamp2);
    int day =
        ((dateTime2.millisecondsSinceEpoch - dateTime1.millisecondsSinceEpoch) /
                (24 * 60 * 60 * 1000))
            .ceil();
    if (day > 0) {}
  }

  /**
   * 根据本周timestamp当前时间本周
   * 一 - 时间DateTime weekday 1
   * 二 - 时间DateTime weekday 2
   * 三 - 时间DateTime weekday 3
   * 四 - 时间DateTime weekday 4
   * 五 - 时间DateTime weekday 5
   */
  static DateTime getDateTimeByWeek(int timestamp, int weekDay) {
    DateTime dateTime = Utility.getDateTimeFromTimeStamp(timestamp);
    int weekday2 = dateTime.weekday;
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    DateTime dateTimeFormat = DateTime(
      year,
      month,
      day,
    ); //格式化后的 2022 11 22 0 0 0
    // if (day == DateTime.monday) { // 星期一
    if (weekday2 > weekDay) {
      return dateTimeFormat.subtract(Duration(days: weekday2 - weekDay));
    } else if (weekday2 < weekDay) {
      return dateTimeFormat.add(Duration(days: weekDay - weekday2));
    } else {
      return dateTimeFormat;
    }
    // }
  }

  /**
   * 时间戳转化成
   * 2022-11-12 00：:00：:00
   */
  static DateTime getYearMonthAndDayDateTimeByTimestamp(int timestamp) {
    DateTime dateTime = Utility.getDateTimeFromTimeStamp(timestamp);
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    DateTime dateTimeFormat = DateTime(
      year,
      month,
      day,
    ); //格式化后的 2022 11 22 0 0 0
    return dateTimeFormat;
  }

  static DateTime? getNextDateTime(
      {required CalendarModel calendarModel,
      required MissionModel missionModelParam}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    DateTime dateTimeToday =
        Utility.getYearMonthAndDayDateTimeByTimestamp(getTimeStampToday());
    for (int i = 0; i < listDayModels.length; i++) {
      DayModel dayModel = listDayModels[i];
      for (int j = 0; j < dayModel.missionModelList.length; j++) {
        MissionModel missionModel = dayModel.missionModelList[j];
        DateTime dateTimeMissionModel =
            Utility.getYearMonthAndDayDateTimeByTimestamp(
                (missionModel?.end_time ?? 0));
        if (missionModelParam.objectId == missionModel.objectId &&
            dayModel.dateTime?.isAfter(dateTimeToday) == true) {
          return (dayModel?.dateTime ?? DateTime.now());
        }
      }
    }
    return null;
  }

  /**
   * 按天提醒
   */
  static insertMissionModelWithRepetiveType1(
      {required CalendarModel calendarModel,
      required MissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    for (DayModel dayModel in listDayModels) {
      DateTime dateTime = Utility.getYearMonthAndDayDateTimeByTimestamp(
          missionModel?.end_time ?? 0);
      int repetiveValue = missionModel.repetiveValue ?? 0;
      if (((dateTime.millisecondsSinceEpoch -
                      (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                  (repetiveValue * 24 * 60 * 60 * 1000) ==
              0) &&
          ((missionModel?.end_time == null) ||
              ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                  (missionModel?.end_time ?? 0)))) {
        dayModel.missionModelList.add(missionModel);
        addMissionModelToPushDataModelList(missionModel,
            dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
      }
    }
  }

  /**
   * 按天提醒
   */
  static insertFlomoMissionModelWithRepetiveType1(
      {required CalendarModel calendarModel,
      required FlomoMissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    for (DayModel dayModel in listDayModels) {
      DateTime dateTimeStartTime =
          Utility.getYearMonthAndDayDateTimeByTimestamp(
              missionModel?.start_time ?? 0);
      DateTime dateTimeEndTime = Utility.getYearMonthAndDayDateTimeByTimestamp(
          missionModel?.end_time ?? 0);
      int repetiveValue = 1;
      if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                  dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
              (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
          dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
        dayModel.flomoMissionModelList.add(missionModel);
        addFlomoMissionModelToPushDataModelList(missionModel,
            dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
      }
    }
  }

  static insertFlomoMissionModelWithRepetiveType4(
      {required CalendarModel calendarModel,
      required FlomoMissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    for (DayModel dayModel in listDayModels) {
      bool isEbbingDay = CONSTANTS.isCurrentDateInEbbinghausRange(
          Utility.getDateTimeFromTimeStamp(missionModel?.start_time ?? 0),
          Utility.getDateTimeFromTimeStamp(missionModel.end_time ?? 0),
          dayModel?.dateTime ?? DateTime.now());
      if (isEbbingDay) {
        dayModel.flomoMissionModelList.add(missionModel);
        addFlomoMissionModelToPushDataModelList(missionModel,
            dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
      }
    }
  }

  /**
   * 每月提醒 2月2日 1月2日
   */
  static insertMissionModelWithRepetiveType3(
      {required CalendarModel calendarModel,
      required MissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    DateTime dateTimeMissionModel =
        Utility.getYearMonthAndDayDateTimeByTimestamp(
            missionModel?.end_time ?? 0);
    int yearMissionModel = dateTimeMissionModel.year;
    int monthMissionModel = dateTimeMissionModel.month;
    int dayMissionModel = dateTimeMissionModel.day;
    int repetiveValueMissionModel = missionModel?.repetiveValue ?? 0;
    int totalMonthMissionModel = yearMissionModel * 12 + monthMissionModel;
    for (DayModel dayModel in listDayModels) {
      DateTime dateTimeDayModel = dayModel?.dateTime ?? DateTime.now();
      int yearDayModel = dateTimeDayModel.year;
      int monthDayModel = dateTimeDayModel.month;
      int dayDayModel = dateTimeDayModel.day;
      int totalMonthDayModel = yearDayModel * 12 + monthDayModel;
      if ((totalMonthMissionModel - totalMonthDayModel) %
              (repetiveValueMissionModel) ==
          0) {
        if (dayMissionModel == dayDayModel) {
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      }
    }
  }

  /**
   * 根据weekend获取星期几的字符串
   */
  static getWeekendDayStringByWeekend(int weekend) {
    switch (weekend) {
      case DateTime.monday:
        return getI18NKey().mondayShort;
      case DateTime.tuesday:
        return getI18NKey().tuesdayShort;
      case DateTime.wednesday:
        return getI18NKey().wednesdayShort;
      case DateTime.thursday:
        return getI18NKey().thursdayShort;
      case DateTime.friday:
        return getI18NKey().fridayShort;
      case DateTime.saturday:
        return getI18NKey().saturdayShort;
      case DateTime.sunday:
        return getI18NKey().sundayShort;
    }
    return "";
  }

  static insertMissionModelWithRepetiveType4(
      {required CalendarModel calendarModel,
      required MissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    DateTime dateTimeMissionModel =
        Utility.getYearMonthAndDayDateTimeByTimestamp(
            missionModel?.end_time ?? 0);
    int yearMissionModel = dateTimeMissionModel.year;
    int monthMissionModel = dateTimeMissionModel.month;
    int dayMissionModel = dateTimeMissionModel.day;
    int repetiveValueMissionModel = missionModel.repetiveValue ?? 0;
    // int totalMonthMissionModel = yearMissionModel * 12 + monthMissionModel;
    for (DayModel dayModel in listDayModels) {
      DateTime dateTimeDayModel = dayModel.dateTime ?? DateTime.now();
      int yearDayModel = dateTimeDayModel.year;
      int monthDayModel = dateTimeDayModel.month;
      int dayDayModel = dateTimeDayModel.day;
      // int totalMonthDayModel = yearDayModel * 12 + monthDayModel;
      if ((yearMissionModel - yearDayModel) % (repetiveValueMissionModel) ==
          0) {
        if (dayMissionModel == dayDayModel &&
            monthMissionModel == monthDayModel) {
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      }
    }
  }

  static includeWeekDay({required List repetiveWeekDay, required int weekDay}) {
    bool monday = repetiveWeekDay?[0] ?? false;
    bool tuesday = repetiveWeekDay?[1] ?? false;
    bool wednesday = repetiveWeekDay?[2] ?? false;
    bool thursday = repetiveWeekDay?[3] ?? false;
    bool friday = repetiveWeekDay?[4] ?? false;
    bool saturday = repetiveWeekDay?[5] ?? false;
    bool sunday = repetiveWeekDay?[6] ?? false;
    if (weekDay == DateTime.monday && monday == true) {
      return true;
    } else if (weekDay == DateTime.tuesday && tuesday == true) {
      return true;
    } else if (weekDay == DateTime.wednesday && wednesday == true) {
      return true;
    } else if (weekDay == DateTime.thursday && thursday == true) {
      return true;
    } else if (weekDay == DateTime.friday && friday == true) {
      return true;
    } else if (weekDay == DateTime.saturday && saturday == true) {
      return true;
    } else if (weekDay == DateTime.sunday && sunday == true) {
      return true;
    }
    return false;
  }

  /**
   * 每周提醒
   */
  static insertMissionModelWithRepetiveType2(
      {required CalendarModel calendarModel,
      required MissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    for (DayModel dayModel in listDayModels) {
      // int end_time = missionModel.end_time;
      //得到本周 1 到 日 的timestamp
      DateTime dateTime =
          Utility.getDateTimeFromTimeStamp(missionModel?.end_time ?? 0);
      DateTime dateTimeMonday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.monday);
      DateTime dateTimeTuesday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.tuesday);
      DateTime dateTimeWednesday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.wednesday);
      DateTime dateTimeThursday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.thursday);
      DateTime dateTimeFriday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.friday);
      DateTime dateTimeSaturday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.saturday);
      DateTime dateTimeSunday = Utility.getDateTimeByWeek(
          missionModel?.end_time ?? 0, DateTime.sunday);

      // if (dayModel.weekday == DateTime.monday) {
      //
      // }
      int repetiveValue = missionModel.repetiveValue ?? 0;

      bool monday = missionModel.repetiveWeekDay?[0] ?? false;
      bool tuesday = missionModel.repetiveWeekDay?[1] ?? false;
      bool wednesday = missionModel.repetiveWeekDay?[2] ?? false;
      bool thursday = missionModel.repetiveWeekDay?[3] ?? false;
      bool friday = missionModel.repetiveWeekDay?[4] ?? false;
      bool saturday = missionModel.repetiveWeekDay?[5] ?? false;
      bool sunday = missionModel.repetiveWeekDay?[6] ?? false;
      if (monday == true && dayModel.dateTime?.weekday == DateTime.monday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeMonday.millisecondsSinceEpoch -
                            (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel.dateTime ?? DateTime.now());
        }
      } else if (tuesday == true &&
          dayModel.dateTime?.weekday == DateTime.tuesday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeTuesday.millisecondsSinceEpoch -
                            (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (wednesday == true &&
          dayModel.dateTime?.weekday == DateTime.wednesday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeWednesday.millisecondsSinceEpoch -
                            (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: (dayModel?.dateTime ?? DateTime.now()));
        }
      } else if (thursday == true &&
          dayModel.dateTime?.weekday == DateTime.thursday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeThursday.millisecondsSinceEpoch -
                            (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: (dayModel?.dateTime ?? DateTime.now()));
        }
      } else if (friday == true &&
          dayModel.dateTime?.weekday == DateTime.friday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeFriday.millisecondsSinceEpoch -
                            (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: (dayModel?.dateTime ?? DateTime.now()));
        }
      } else if (saturday == true &&
          dayModel.dateTime?.weekday == DateTime.saturday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeSaturday.millisecondsSinceEpoch -
                            (dayModel.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: (dayModel?.dateTime ?? DateTime.now()));
        }
      } else if (sunday == true &&
          dayModel.dateTime?.weekday == DateTime.sunday) {
        if (missionModel.end_time == 0 ||
            ((dateTimeSunday.millisecondsSinceEpoch -
                            (dayModel?.dateTime?.millisecondsSinceEpoch ?? 0)) %
                        (repetiveValue * 7 * 24 * 60 * 60 * 1000) ==
                    0) &&
                ((missionModel?.end_time == null) ||
                    ((dayModel.dateTime?.millisecondsSinceEpoch ?? 1) <=
                        (missionModel?.end_time ?? 0)))) {
          //无限循环， 基于endTime 每隔 repetiveValue周 添加上去
          dayModel.missionModelList.add(missionModel);
          addMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: (dayModel?.dateTime ?? DateTime.now()));
        }
      }
    }
  }

  static insertFlomoMissionModelWithRepetiveType2(
      {required CalendarModel calendarModel,
      required FlomoMissionModel missionModel}) {
    List<DayModel> listDayModels = calendarModel.dayModelList;
    //判断当前MissionModel属于哪一天
    for (DayModel dayModel in listDayModels) {
      // int end_time = missionModel.end_time;
      //得到本周 1 到 日 的timestamp
      // DateTime dateTime =
      //     Utility.getDateTimeFromTimeStamp(missionModel?.end_time ?? 0);
      // DateTime dateTimeMonday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.monday);
      // DateTime dateTimeTuesday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.tuesday);
      // DateTime dateTimeWednesday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.wednesday);
      // DateTime dateTimeThursday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.thursday);
      // DateTime dateTimeFriday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.friday);
      // DateTime dateTimeSaturday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.saturday);
      // DateTime dateTimeSunday = Utility.getDateTimeByWeek(
      //     missionModel?.end_time ?? 0, DateTime.sunday);
      //超出结束时间则跳出循环
      if (missionModel.end_time != null &&
          dayModel.dateTime?.millisecondsSinceEpoch != null) {
        if (missionModel.end_time! <
            dayModel.dateTime!.millisecondsSinceEpoch) {
          break;
        }
      }
      // if (dayModel.weekday == DateTime.monday) {
      //
      // }
      int repetiveValue = 1;

      bool monday = missionModel.repetiveWeekDay?[0] ?? false;
      bool tuesday = missionModel.repetiveWeekDay?[1] ?? false;
      bool wednesday = missionModel.repetiveWeekDay?[2] ?? false;
      bool thursday = missionModel.repetiveWeekDay?[3] ?? false;
      bool friday = missionModel.repetiveWeekDay?[4] ?? false;
      bool saturday = missionModel.repetiveWeekDay?[5] ?? false;
      bool sunday = missionModel.repetiveWeekDay?[6] ?? false;
      DateTime dateTimeStartTime =
          Utility.getYearMonthAndDayDateTimeByTimestamp(
              missionModel?.start_time ?? 0);
      DateTime dateTimeEndTime = Utility.getYearMonthAndDayDateTimeByTimestamp(
          missionModel?.end_time ?? 0);
      //星期一处理方式
      if (monday == true && dayModel.dateTime?.weekday == DateTime.monday) {
        //如果是周一
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (tuesday == true &&
          dayModel.dateTime?.weekday == DateTime.tuesday) {
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (wednesday == true &&
          dayModel.dateTime?.weekday == DateTime.wednesday) {
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (thursday == true &&
          dayModel.dateTime?.weekday == DateTime.thursday) {
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (friday == true &&
          dayModel.dateTime?.weekday == DateTime.friday) {
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (saturday == true &&
          dayModel.dateTime?.weekday == DateTime.saturday) {
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      } else if (sunday == true &&
          dayModel.dateTime?.weekday == DateTime.sunday) {
        if ((dayModel.dateTime!.isAfter(dateTimeStartTime) ||
                    dayModel.dateTime!.isAtSameMomentAs(dateTimeStartTime)) &&
                (dayModel.dateTime!.isBefore(dateTimeEndTime)) ||
            dayModel.dateTime!.isAtSameMomentAs(dateTimeEndTime)) {
          dayModel.flomoMissionModelList.add(missionModel);
          addFlomoMissionModelToPushDataModelList(missionModel,
              dateTimeOfDayModel: dayModel?.dateTime ?? DateTime.now());
        }
      }
    }
  }

  static bool isProductEnv() {
    //prd环境
    if (Params.env == EnvEnum.prd) {
      return true;
    }
    //sit 和uat环境
    return false;
  }

  // static Future<bool> requestNotificationStatus() async {
  //   bool isNotificationOn = await CounterMethodChannelManager.getInstance().isNotificationOn();
  //   CounterMethodChannelManager.getInstance().openSetting();
  //   if(PermissionManager.getInstance().isNotificationOn() != isNotificationOn) {
  //     return PermissionManager.getInstance().isNotificationOn();
  //   }
  //   PermissionManager.getInstance().isNotificationOn();
  // }

  static String? getObjectIdWithId(String id) {
    if (id != null) {
      String hexStrign = id.substring(0, id.length > 3 ? 3 : id.length);
      return _hexToInt(hexStrign).toString();
    }
    return null;
  }

  //十六进制转10进制
  static int _hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  /**
   * 用于批量推送
   */
  static void addFlomoMissionModelToPushDataModelList(FlomoMissionModel mission,
      {DateTime? dateTimeOfDayModel}) {
    try {
      //todo 我觉得whenMilli这样算会好些 whenMilliseconds: DateTime(dateTimeOfDayModel.year, dateTimeOfDayModel.month, dateTimeOfDayModel.day, dateTimeOfDayModel.hour).millisecondsSinceEpoch + mission.alert_time,
      //
      //   // 按照周 月 年 重复 mission.alert_time最大值是 24 * 60 * 60 * 1000
      //lzb 其实repetevetime 1 2 3 4 用这个逻辑会好些
      mission?.alert_times.forEach((alertTime) {
        if (alertTime! < 86400001) {
          int timestamp = Utility.getDateTimeFromDateTimeAndTimeStamp(
                  dateTimeOfDayModel!, alertTime ?? 0)
              .millisecondsSinceEpoch;
          String? id = Utility.getObjectIdWithId(mission.objectId ?? "");

          if (timestamp != 0 &&
              timestamp != null &&
              timestamp >
                  (Utility.getTimeStampToday() - 1 * 24 * 60 * 60 * 1000)) {
            // getDateTimeFromTimeStamp(DateTime(dateTimeOfDayModel.year, dateTimeOfDayModel.month, dateTimeOfDayModel.day, dateTimeOfDayModel.hour).millisecondsSinceEpoch + alertTime);

            // timestamp > (Utility.getTimeStampToday() - 1 * 24 * 60 * 60 * 1000) && timestamp < (Utility.getTimeStampToday() + 9 * 24 * 60 * 60 * 1000)) {
            String id2 = (id ?? "") +
                (dateTimeOfDayModel?.month?.toString() ?? "") +
                (dateTimeOfDayModel?.day?.toString() ?? "") +
                (dateTimeOfDayModel?.hour?.toString() ?? "") +
                (dateTimeOfDayModel?.minute.toString() ?? "");
            CONSTANTS.pushDataModelList.list.add(PushDataModel(
                title: getI18NKey()
                    .mission_clocks_in_with_name(mission?.title ?? ""),
                content: getI18NKey().your_clockin_mission_with_name_has_begun(
                    mission?.title ?? ""),
                whenMilliseconds: DateTime(
                            dateTimeOfDayModel?.year ?? 0,
                            dateTimeOfDayModel?.month ?? 0,
                            dateTimeOfDayModel?.day ?? 0)
                        .millisecondsSinceEpoch +
                    (alertTime ?? 0), //alertTime
                id: id2));
          }
        } else {
          //0已经MongoDbApisManager单独设置过了
          String? id = Utility.getObjectIdWithId(mission.objectId ?? "");
          if (alertTime != 0 &&
              alertTime != null &&
              alertTime! > Utility.getTimeStampToday()) {
            // print("11111111111" +
            //     Utility.getDateTimeFromTimeStamp(alertTime).toString());
            CONSTANTS.pushDataModelList.list.add(PushDataModel(
                title: getI18NKey()
                    .mission_clocks_in_with_name(mission?.title ?? ""),
                content: getI18NKey().your_clockin_mission_with_name_has_begun(
                    mission?.title ?? ""),
                whenMilliseconds: alertTime ?? 0,
                id: id ?? ""));
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static void addSubMissionModelToPushDataModelList(MissionModel missionModel,
      {DateTime? dateTimeOfDayModel}) {
    try {
      List<SubmissionModel> list = missionModel.subMissionModels;
      //0已经MongoDbApisManager单独设置过了
      for (int i = 0; i < list.length; i++) {
        SubmissionModel model = list[i];
        //todo 我觉得whenMilli这样算会好些 whenMilliseconds: DateTime(dateTimeOfDayModel.year, dateTimeOfDayModel.month, dateTimeOfDayModel.day, dateTimeOfDayModel.hour).millisecondsSinceEpoch + mission.alert_time,
        //lzb 其实repetevetime 1 2 3 4 用这个逻辑会好些
        if (model.notificationTime >= 0 && model.notificationTime < 86400001) {
          int timestamp = Utility.getDateTimeFromDateTimeAndTimeStamp(
                  dateTimeOfDayModel!, model.notificationTime ?? 0)
              .millisecondsSinceEpoch;
          String id = model.id.toString();
          if (timestamp != 0 &&
              timestamp != null &&
              timestamp >
                  (Utility.getTimeStampToday() - 1 * 24 * 60 * 60 * 1000)) {
            // getDateTimeFromTimeStamp(DateTime(dateTimeOfDayModel.year, dateTimeOfDayModel.month, dateTimeOfDayModel.day, dateTimeOfDayModel.hour).millisecondsSinceEpoch + mission.alert_time);

            // timestamp > (Utility.getTimeStampToday() - 1 * 24 * 60 * 60 * 1000) && timestamp < (Utility.getTimeStampToday() + 9 * 24 * 60 * 60 * 1000)) {
            String id2 = (id ?? "") +
                (dateTimeOfDayModel?.month?.toString() ?? "") +
                (dateTimeOfDayModel?.day?.toString() ?? "") +
                (dateTimeOfDayModel?.hour?.toString() ?? "") +
                (dateTimeOfDayModel?.minute.toString() ?? "");
            CONSTANTS.pushDataModelList.list.add(PushDataModel(
                title: getI18NKey().mission_alert_with_name(model?.title ?? ""),
                content: getI18NKey()
                    .your_mission_with_name_has_begun(model?.title ?? ""),
                whenMilliseconds: DateTime(
                            dateTimeOfDayModel?.year ?? 0,
                            dateTimeOfDayModel?.month ?? 0,
                            dateTimeOfDayModel?.day ?? 0)
                        .millisecondsSinceEpoch +
                    (model?.notificationTime ?? 0), //alertTime
                id: id2));
          }
          // }
        } else {
          //0已经MongoDbApisManager单独设置过了
          String? id = Utility.getObjectIdWithId(model.id.toString());
          if (model.notificationTime != 0 &&
              model.notificationTime != null &&
              model.notificationTime! > Utility.getTimeStampToday()) {
            // print("11111111111" +
            //     Utility.getDateTimeFromTimeStamp(alertTime).toString());
            CONSTANTS.pushDataModelList.list.add(PushDataModel(
                title: getI18NKey().mission_submission_started(
                    missionModel?.title ?? "", model?.title ?? ""),
                content: getI18NKey().your_clockin_mission_with_name_has_begun(
                    model?.title ?? ""),
                whenMilliseconds: model.notificationTime,
                id: id ?? ""));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static int calPromptTokensForMessages({required List<Map> messages}) {
    int promptTokens = 0;
    for (int i = 0; i < messages.length; i++) {
      String s = messages[i]['content'].toString();
      if (Utility.containChinese(s)) {
        promptTokens += s.length * 2; //中文字符占两个字符
      } else {
        promptTokens += s.length;
      }
    }
    return promptTokens;
  }

  static int calTokensForResponse(String response) {
    int tokens = 0;
    if (Utility.containChinese(response)) {
      tokens = response.length * 2; //中文字符占两个字符
    } else {
      tokens = response.length;
    }
    return tokens;
  }

  static bool containChinese(String chinese) {
    String pattern = r'[\u4e00-\u9fa5]';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(chinese);
  }

  // static Map? extractCacheContent(String input) {
  //   try {
  //     RegExp exp = RegExp(
  //         r'~~~~~~~~~~CompleteBegin~~~~~~~~~~(.*?)~~~~~~~~~~CompleteEnd~~~~~~~~~~',
  //         dotAll: true);
  //     Match? match = exp.firstMatch(input);
  //     String res = match?.group(1) ?? '';
  //     return jsonDecode(res);
  //   } catch(e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  static Map? extractContent(String input) {
    try {
      RegExp exp = RegExp(
          r'~~~~~~~~~~CompleteBegin~~~~~~~~~~(.*?)~~~~~~~~~~CompleteEnd~~~~~~~~~~',
          dotAll: true);
      Match? match = exp.firstMatch(input);
      String res = match?.group(1) ?? '';
      return jsonDecode(res);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /**
   * 用于批量推送
   */
  static void addMissionModelToPushDataModelList(MissionModel mission,
      {DateTime? dateTimeOfDayModel}) {
    try {
      // if(mission.title == "12345678") {
      //   print("12345678");
      // }
      //0已经MongoDbApisManager单独设置过了
      if (mission.repetiveType == 0) {
        String? id = Utility.getObjectIdWithId(mission.objectId ?? "");
        if (mission.alert_time != 0 &&
            mission.alert_time != null &&
            mission.alert_time! > Utility.getTimeStampToday()) {
          CONSTANTS.pushDataModelList.list.add(PushDataModel(
              title: getI18NKey().mission_alert_with_name(mission?.title ?? ""),
              content: getI18NKey()
                  .your_mission_with_name_has_begun(mission?.title ?? ""),
              whenMilliseconds: mission.alert_time ?? 0,
              id: id ?? ""));
        }
      } else {
        //todo 我觉得whenMilli这样算会好些 whenMilliseconds: DateTime(dateTimeOfDayModel.year, dateTimeOfDayModel.month, dateTimeOfDayModel.day, dateTimeOfDayModel.hour).millisecondsSinceEpoch + mission.alert_time,
        //
        //   // 按照周 月 年 重复 mission.alert_time最大值是 24 * 60 * 60 * 1000
        //lzb 其实repetevetime 1 2 3 4 用这个逻辑会好些
        if (mission.alert_time! < 86400001) {
          //推送准确时间
          int timestamp = Utility.getDateTimeFromDateTimeAndTimeStamp(
                  dateTimeOfDayModel!, mission.alert_time ?? 0)
              .millisecondsSinceEpoch;
          int startTime = mission.start_time ?? 0;
          int endTime = mission.end_time ?? 100000000000000;
          String? id = Utility.getObjectIdWithId(mission.objectId ?? "");
          if (timestamp != 0 &&
              timestamp != null &&
              timestamp >
                  (Utility.getTimeStampToday() - 1 * 24 * 60 * 60 * 1000) &&
              timestamp < endTime &&
              timestamp > startTime) {
            // getDateTimeFromTimeStamp(DateTime(dateTimeOfDayModel.year, dateTimeOfDayModel.month, dateTimeOfDayModel.day, dateTimeOfDayModel.hour).millisecondsSinceEpoch + mission.alert_time);

            // timestamp > (Utility.getTimeStampToday() - 1 * 24 * 60 * 60 * 1000) && timestamp < (Utility.getTimeStampToday() + 9 * 24 * 60 * 60 * 1000)) {
            String id2 = (id ?? "") +
                (dateTimeOfDayModel?.month?.toString() ?? "") +
                (dateTimeOfDayModel?.day?.toString() ?? "") +
                (dateTimeOfDayModel?.hour?.toString() ?? "") +
                (dateTimeOfDayModel?.minute.toString() ?? "");
            CONSTANTS.pushDataModelList.list.add(PushDataModel(
                title:
                    getI18NKey().mission_alert_with_name(mission?.title ?? ""),
                content: getI18NKey()
                    .your_mission_with_name_has_begun(mission?.title ?? ""),
                whenMilliseconds: DateTime(
                            dateTimeOfDayModel?.year ?? 0,
                            dateTimeOfDayModel?.month ?? 0,
                            dateTimeOfDayModel?.day ?? 0)
                        .millisecondsSinceEpoch +
                    (mission?.alert_time ?? 0), //alertTime
                id: id2));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Size getItemSizeByGlobalKey(GlobalKey key) {
    RenderObject? box = key.currentContext?.findRenderObject();
    Size size = box?.paintBounds.size ?? Size(0, 0);
    return size;
  }

  static int getTheLatestTimesFromNow(List times) {
    int hour = DateTime.now().hour;
    int minutes = DateTime.now().minute;
    int second = DateTime.now().second;
    int current = hour * 60 * 60 * 1000 + minutes * 60 * 1000 + second * 1000;
    int prevTime = 0;
    for (int i = 0; i < times.length; i++) {
      int time = times[i];
      if (prevTime == 0 && prevTime < time) {
        //当天
        return time;
      } else if (prevTime <= current && current >= time) {
        return time;
      }
      prevTime = time;
    }
    if (times.length > 0) {
      return times[0];
    } else {
      return 0;
    }
  }

  /**
   * 添加missionmodel的数组到PushDataModelList 用于批量推送
   */
  static void addMissionModelListToPushDataModelList(
      List<MissionModel> listMission) {
    for (int i = 0; i < listMission.length; i++) {
      addMissionModelToPushDataModelList(listMission[i]);
      addSubMissionModelToPushDataModelList(listMission[i]);
    }
  }

  static List<EndTimeMissionModel> sortEndTimeMissionModel(
      List<EndTimeMissionModel> list) {
    int now = getTimeStampToday();
    List<EndTimeMissionModel> listEndTimeMissionModelFinished = [];
    List<EndTimeMissionModel> listEndTimeMissionModelUnFinished = [];
    list.sort((a, b) {
      return (a.end_time ?? 0) > (b.end_time ?? 0)
          ? 1
          : (a.end_time ?? 0) < (b.end_time ?? 0)
              ? -1
              : 0;
    });
    list.forEach((element) {
      if (element.end_time! < now) {
        listEndTimeMissionModelFinished.add(element);
      } else {
        listEndTimeMissionModelUnFinished.add(element);
      }
    });
    listEndTimeMissionModelUnFinished.addAll(listEndTimeMissionModelFinished);
    return listEndTimeMissionModelUnFinished;
    // list.sort((a, b) {
    //   if(a.end_time! < now) {
    //     if ((a.end_time ?? 0) > (b.end_time ?? 0)) {
    //       return 1;
    //     } else if ((a.end_time ?? 0) < (b.end_time ?? 0)) {
    //       return -1;
    //     } else {
    //       return 0;
    //     }
    //   } else {
    //     return -1;
    //   }
    // });
    print(list);
  }

  static List<StartTimeMissionModel> sortStartTimeMissionModel(
      List<StartTimeMissionModel> list) {
    int now = getTimeStampToday();
    List<StartTimeMissionModel> listStartTimeMissionModelFinished = [];
    List<StartTimeMissionModel> listStartTimeMissionModelUnFinished = [];
    list.sort((a, b) {
      return (a.start_time ?? 0) > (b.start_time ?? 0)
          ? 1
          : (a.start_time ?? 0) < (b.start_time ?? 0)
              ? -1
              : 0;
    });
    list.forEach((element) {
      if (element.start_time! < now) {
        listStartTimeMissionModelFinished.add(element);
      } else {
        listStartTimeMissionModelUnFinished.add(element);
      }
    });
    listStartTimeMissionModelUnFinished
        .addAll(listStartTimeMissionModelFinished);
    return listStartTimeMissionModelUnFinished;
  }

  static DateTime? getStartDateTimeFromListMissionModels(
      {required List<MissionModel> list}) {
    int start_time = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].start_time != null) {
        if (start_time == 0 || start_time > list[i].start_time!) {
          start_time = list[i].start_time!;
        }
      }
    }
    if (start_time == 0) {
      return null;
    }
    return Utility.getDateTimeFromTimeStamp(start_time);
  }

  static DateTime? getEndDateTimeFromListMissionModels(
      {required List<MissionModel> list}) {
    int end_time = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].end_time != null) {
        if (end_time == 0 || end_time < list[i].end_time!) {
          end_time = list[i].end_time!;
        }
      }
    }
    if (end_time == 0) {
      return null;
    }
    return Utility.getDateTimeFromTimeStamp(end_time);
  }

  static ProgressFocusModel getPriorityCompleteNumberWithMissionList(
      List<MissionModel> listMissionModelsComplete,
      List<MissionModel> listMissionModels,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    ProgressFocusModel progressFocusModel = ProgressFocusModel();
    // int completeNumber = 0;
    // int totalNumber = 0;
    //当前时间小于结束时间
    progressFocusModel.totalValue = listMissionModels.length;
    progressFocusModel.currentValue = listMissionModelsComplete.length;
    return progressFocusModel;
  }

  static ProgressFocusModel getCompleteNumberWithMissionList(
      List<MissionModel> listMissionModels,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    ProgressFocusModel progressFocusModel = ProgressFocusModel();
    int completeNumber = 0;
    int totalNumber = 0;
    for (int i = 0; i < listMissionModels.length; i++) {
      MissionModel missionModel = listMissionModels[i];
      totalNumber += 1;
      if (missionModel.isFinished == true) {
        completeNumber += 1;
      }
    }
    //当前时间小于结束时间
    progressFocusModel.totalValue = totalNumber;
    progressFocusModel.currentValue = completeNumber;
    return progressFocusModel;
  }

  static ProgressFocusModel getTomatoesWithMissionList(
      List<MissionModel> listMissionModels,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    ProgressFocusModel progressFocusModel = ProgressFocusModel();
    int tomatoes = 0;
    int totalTomatoes = 0;
    for (int i = 0; i < listMissionModels.length; i++) {
      MissionModel missionModel = listMissionModels[i];
      if (missionModel.total_tomotoes != null) {
        totalTomatoes += missionModel.total_tomotoes!;
        if (missionModel.isFinished == true) {
          tomatoes += missionModel.total_tomotoes!;
        }
      }
    }
    //当前时间小于结束时间
    progressFocusModel.totalValue = totalTomatoes;
    progressFocusModel.currentValue = tomatoes;
    return progressFocusModel;
  }

  static ProgressFocusModel getMissionModelDuration(
      {required MissionModel missionModel}) {
    ProgressFocusModel progressFocusModel = ProgressFocusModel();
    try {
      int duration = 0;
      if (missionModel.time_mode == null || missionModel.time_mode == 0) {
        if (missionModel?.daily_start_time == null &&
            missionModel?.daily_end_time == null &&
            missionModel.repetiveType == 0) {
          if (missionModel?.end_time != null) {
            //没有重复
            // DateTime dateTimeStart = Utility.getDateTimeFromTimeStamp(
            //     missionModel?.start_time ?? 0);
            // DateTime dateTimeEnd = Utility.getDateTimeFromTimeStamp(
            //     missionModel?.end_time ?? 0);
            if (missionModel?.start_time == null ||
                missionModel?.end_time == null) {
              return progressFocusModel;
            }
            duration =
                (missionModel?.end_time ?? 0) - (missionModel?.start_time ?? 0);
          }
        } else {
          //有重复
          if (missionModel?.daily_start_time == null ||
              missionModel?.daily_end_time == null) {
            return progressFocusModel;
          }
          // DateTime dateTimeStart = Utility.getDateTimeFromTimeStamp(
          //     missionModel?.start_time ?? 0);
          // DateTime dateTimeEnd = Utility.getDateTimeFromTimeStamp(
          //     missionModel?.end_time ?? 0);
          duration = (missionModel?.daily_end_time ?? 0) -
              (missionModel?.daily_start_time ?? 0);
        }
      } else {
        //时间段模式
        if (missionModel?.start_time == null ||
            missionModel?.end_time == null) {
          return progressFocusModel;
        }
        // DateTime dateTimeStart =
        // Utility.getDateTimeFromTimeStamp(missionModel?.start_time ?? 0);
        // DateTime dateTimeEnd =
        // Utility.getDateTimeFromTimeStamp(missionModel?.end_time ?? 0);
        // duration = dateTimeEnd
        //     .difference(dateTimeStart)
        //     .inMilliseconds;
        duration =
            (missionModel?.end_time ?? 0) - (missionModel?.start_time ?? 0);
      }
      missionModel.localDuration = duration;
      missionModel.localDurationString =
          Utility.formatTimestampWithoutZeroHM(duration);
      progressFocusModel.totalValue = duration;
    } catch (e) {
      print(e.toString());
    }
    return progressFocusModel;
  }

  static ProgressFocusModel getTotalDurationOfDayModel(
      {required DayModel dayModel}) {
    ProgressFocusModel progressFocusModel = ProgressFocusModel();
    // for (int i = 0; i < list.length; i++) {
    //   DayModel dayModel = list[i];
    int duration = 0;
    int focusedDuration = 0;
    dayModel.missionModelList.forEach((MissionModel _missionModel) {
      FolderModel? folderModelWithMission;
      if (!TextUtil.isEmpty(_missionModel.folder_id)) {
        List<FolderModel> folderModelList = MongoApisManager.getInstance()!
            .queryWhereEqual_folderModelWithFolderId(_missionModel.folder_id);
        for (int i = 0; i < folderModelList.length; i++) {
          FolderModel item = folderModelList[i];
          if (item.tag == 2) {
            //
            folderModelWithMission = item;
          }
          if (item.tag == 1) {
            folderModelWithMission = item;
          }
          if (item.tag == 0) {
            folderModelWithMission = item;
          }
        }
      }
      late DateTime dateTimeStart;
      late DateTime? dateTimeEnd;
      if (_missionModel.time_mode == null || _missionModel.time_mode == 0) {
        if (_missionModel?.daily_start_time == null &&
            _missionModel?.daily_end_time == null &&
            _missionModel.repetiveType == 0) {
          if (_missionModel?.end_time != null) {
            //没有重复
            dateTimeStart = Utility.getDateTimeFromTimeStamp(
                _missionModel?.start_time ?? 0);
          }
        } else {
          //有重复
          dateTimeStart = Utility.getDateTimeFromTimeStamp(DateTime(
                      dayModel.dateTime?.year ?? 0,
                      dayModel.dateTime?.month ?? 0,
                      dayModel?.day ?? 0,
                      dayModel.dateTime?.hour ?? 0)
                  .millisecondsSinceEpoch +
              (_missionModel?.daily_start_time ?? 0));
        }

        if (_missionModel?.daily_end_time != null) {
          dateTimeEnd = Utility.getDateTimeFromTimeStamp(DateTime(
                      dayModel.dateTime?.year ?? 0,
                      dayModel.dateTime?.month ?? 0,
                      dayModel?.day ?? 0,
                      dayModel.dateTime?.hour ?? 0)
                  .millisecondsSinceEpoch +
              (_missionModel?.daily_end_time ?? 0));
        } else {
          dateTimeEnd = dateTimeStart.add(Duration(hours: 1));
        }
      } else {
        //时间段模式
        // if (_missionModel?.start_time != null) {
        dateTimeStart =
            Utility.getDateTimeFromTimeStamp(_missionModel?.start_time ?? 0);
        // }
        // if (_missionModel?.end_time != null) {
        dateTimeEnd =
            Utility.getDateTimeFromTimeStamp(_missionModel?.end_time ?? 0);
        // }
      }

      duration += dateTimeEnd!.difference(dateTimeStart).inSeconds;
      // if(Utility._missionModel)
      bool isFinished = Utility.getIsFinishOfMissionModel(
        missionModel: _missionModel,
        curMonthTimeStamp: dayModel.dateTime?.millisecondsSinceEpoch ?? 0,
      );
      if (isFinished) {
        focusedDuration += dateTimeEnd.difference(dateTimeStart).inSeconds;
      }
      // if (listMissionModelsAddedForTimemodeSegment.contains(_missionModel) ==
      //     false) {
      //   // final DateTime startDate =
      //   // DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
      //   appointments.add(Appointment(
      //     id: _missionModel.objectId,
      //     subject: _missionModel.title ?? "",
      //     startTime: dateTimeStart,
      //     endTime: dateTimeEnd,
      //     color: Color(folderModelWithMission?.color ?? 0xffff8800),
      //   ));
      //   //时间段不能重复添加
      //   if (_missionModel.time_mode == 1) {
      //     listMissionModelsAddedForTimemodeSegment.add(_missionModel);
      //   }
      // }
    });
    dayModel.duration = duration;
    dayModel.completeDuration = focusedDuration;
    progressFocusModel.totalValue += duration;
    progressFocusModel.currentValue += focusedDuration;
    // }
    return progressFocusModel;
  }

  static ProgressFocusModel getDurationCalendarModelWithMissionList(
      List<MissionModel> listMissionModels,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    //重新刷新推送列表
    // CONSTANTS.pushDataModelList.refresh();
    // PushDataModelList pushDataModelList = PushDataModelList();
    //定义时间范围
    ProgressFocusModel progressFocusModel = ProgressFocusModel();
    DateTime dateTimeStart = startDateTime ?? new DateTime(2023);
    int timestampStart = dateTimeStart.millisecondsSinceEpoch;
    DateTime dateTimeEnd = endDateTime ?? new DateTime(2025);
    int timestampEnd = dateTimeEnd.millisecondsSinceEpoch;
    int timestampNow = getTimeStampToday();
    DateTime dateTimeNowFiltered = getFilterDateTimeFromTimeStamp(timestampNow);
    int curTimeStamp = timestampStart;
    CalendarModel calendarModel = CalendarModel();
    calendarModel.curDateTime = dateTimeNowFiltered;
    int i = 0;
    int iMonth = 0; //
    int duration = 0;
    int completeDuration = 0;
    //当前时间小于结束时间
    while (curTimeStamp < timestampEnd) {
      //按天过滤
      DateTime curDateTme = getDateTimeFromTimeStamp(curTimeStamp);
      int year = curDateTme.year;
      int month = curDateTme.month;
      int day = curDateTme.day;
      int weekday = curDateTme.weekday; //星期几

      DayModel dayModel = DayModel(
          indexMonth: iMonth,
          lunarDay: Utility.getLunarCalendar(
              year: year, month: curDateTme.month, day: curDateTme.day),
          // weekdayName: Utility.getWeekOfDay(curTimeStamp, 0),
          year: year,
          dateTime: curDateTme,
          weekday: weekday,
          isCurrent: dateTimeNowFiltered.month == curDateTme.month &&
              dateTimeNowFiltered.year == curDateTme.year &&
              dateTimeNowFiltered.day == curDateTme.day);
      List<MissionModel> datasMissionModel = MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByEndTime2(
              listMissionModels: listMissionModels,
              curDayModelDateTime: dayModel.dateTime,
              // repetiveType: 0,
              start_endTime:
                  Utility.getFilterDateTimeFromTimeStamp(curTimeStamp)
                      .millisecondsSinceEpoch,
              end_endTime:
                  Utility.getFilterDateTimeFromTimeStamp(curTimeStamp, true)
                      .millisecondsSinceEpoch);

      //todo 打卡时间要加上
      // Utility.addFlomoMissionModelListToPushDataModelList(datasFlomoMissionModels);
      dayModel.missionModelList = datasMissionModel;
      if (dayModel.missionModelList.length > 0) {
        dayModel.missionModelList.forEach((element) {
          // print("${element.title}");
          // if (element.title == "增加复制按钮") {
          //   print("1111111111");
          // }
          getMissionModelDuration(missionModel: element);
        });
      }
      ProgressFocusModel model = getTotalDurationOfDayModel(dayModel: dayModel);
      dayModel.duration = model.totalValue;
      duration += model.totalValue;
      dayModel.completeDuration = model.currentValue;
      completeDuration += model.currentValue;
      curTimeStamp += 24 * 60 * 60 * 1000;
      i++;
    }
    progressFocusModel.totalValue = duration;
    progressFocusModel.currentValue = completeDuration;
    return progressFocusModel;
  }

  // static ProgressFocusModel getTotalDurationOfDayModel({required DayModel dayModel}) {
  //   ProgressFocusModel progressFocusModel = ProgressFocusModel();
  //   // for (int i = 0; i < list.length; i++) {
  //   //   DayModel dayModel = list[i];
  //     int duration = 0;
  //     int focusedDuration = 0;
  //     dayModel.missionModelList.forEach((MissionModel _missionModel) {
  //       FolderModel? folderModelWithMission;
  //       if (!TextUtil.isEmpty(_missionModel.folder_id)) {
  //         List<FolderModel> folderModelList = MongoApisManager.getInstance()!
  //             .queryWhereEqual_folderModelWithFolderId(_missionModel.folder_id);
  //         for (int i = 0; i < folderModelList.length; i++) {
  //           FolderModel item = folderModelList[i];
  //           if (item.tag == 2) {
  //             //
  //             folderModelWithMission = item;
  //           }
  //           if (item.tag == 1) {
  //             folderModelWithMission = item;
  //           }
  //           if (item.tag == 0) {
  //             folderModelWithMission = item;
  //           }
  //         }
  //       }
  //       late DateTime dateTimeStart;
  //       late DateTime? dateTimeEnd;
  //       if (_missionModel.time_mode == null || _missionModel.time_mode == 0) {
  //         if (_missionModel?.daily_start_time == null &&
  //             _missionModel?.daily_end_time == null &&
  //             _missionModel.repetiveType == 0) {
  //           if (_missionModel?.end_time != null) {
  //             //没有重复
  //             dateTimeStart = Utility.getDateTimeFromTimeStamp(
  //                 _missionModel?.start_time ?? 0);
  //           }
  //         } else {
  //           //有重复
  //           dateTimeStart = Utility.getDateTimeFromTimeStamp(DateTime(
  //               dayModel.dateTime?.year ?? 0,
  //               dayModel.dateTime?.month ?? 0,
  //               dayModel?.day ?? 0,
  //               dayModel.dateTime?.hour ?? 0)
  //               .millisecondsSinceEpoch +
  //               (_missionModel?.daily_start_time ?? 0));
  //         }
  //
  //         if (_missionModel?.daily_end_time != null) {
  //           dateTimeEnd = Utility.getDateTimeFromTimeStamp(DateTime(
  //               dayModel.dateTime?.year ?? 0,
  //               dayModel.dateTime?.month ?? 0,
  //               dayModel?.day ?? 0,
  //               dayModel.dateTime?.hour ?? 0)
  //               .millisecondsSinceEpoch +
  //               (_missionModel?.daily_end_time ?? 0));
  //         } else {
  //           dateTimeEnd = dateTimeStart.add(Duration(hours: 1));
  //         }
  //       } else {
  //         //时间段模式
  //         // if (_missionModel?.start_time != null) {
  //         dateTimeStart =
  //             Utility.getDateTimeFromTimeStamp(_missionModel?.start_time ?? 0);
  //         // }
  //         // if (_missionModel?.end_time != null) {
  //         dateTimeEnd =
  //             Utility.getDateTimeFromTimeStamp(_missionModel?.end_time ?? 0);
  //         // }
  //       }
  //
  //       duration += dateTimeEnd!.difference(dateTimeStart).inSeconds;
  //       // if(Utility._missionModel)
  //       bool isFinished = Utility.getIsFinishOfMissionModel(
  //         missionModel: _missionModel,
  //         curMonthTimeStamp: dayModel
  //             .dateTime
  //             ?.millisecondsSinceEpoch ??
  //             0,
  //       );
  //       if(isFinished) {
  //         focusedDuration += dateTimeEnd.difference(dateTimeStart).inSeconds;
  //       }
  //       // if (listMissionModelsAddedForTimemodeSegment.contains(_missionModel) ==
  //       //     false) {
  //       //   // final DateTime startDate =
  //       //   // DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
  //       //   appointments.add(Appointment(
  //       //     id: _missionModel.objectId,
  //       //     subject: _missionModel.title ?? "",
  //       //     startTime: dateTimeStart,
  //       //     endTime: dateTimeEnd,
  //       //     color: Color(folderModelWithMission?.color ?? 0xffff8800),
  //       //   ));
  //       //   //时间段不能重复添加
  //       //   if (_missionModel.time_mode == 1) {
  //       //     listMissionModelsAddedForTimemodeSegment.add(_missionModel);
  //       //   }
  //       // }
  //     });
  //     dayModel.duration = duration;
  //     dayModel.completeDuration = focusedDuration;
  //     progressFocusModel.totalValue += duration;
  //     progressFocusModel.currentValue += focusedDuration;
  //   // }
  //   return progressFocusModel;
  // }

  /**
   * 只有CreateAIChatGptMissionWidget时用到
   */
  static CalendarModel initCalendarModelWithMissionList(
      List<MissionModel> listMissionModels,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    //重新刷新推送列表
    // CONSTANTS.pushDataModelList.refresh();
    // PushDataModelList pushDataModelList = PushDataModelList();
    DateTime date = DateTime.now();

    //定义时间范围
    // DateTime dateTimeStart = startDateTime ?? new DateTime(2023);
    // int timestampStart = dateTimeStart.millisecondsSinceEpoch;
    // DateTime dateTimeEnd = endDateTime ?? new DateTime(2025);

    DateTime dateTimeStart = new DateTime(date.year - 1);
    int timestampStart = dateTimeStart.millisecondsSinceEpoch;
    DateTime dateTimeEnd = new DateTime(date.year + 2);

    int timestampEnd = dateTimeEnd.millisecondsSinceEpoch;
    int timestampNow = getTimeStampToday();
    DateTime dateTimeNowFiltered = getFilterDateTimeFromTimeStamp(timestampNow);
    int timestampNowFiltered = dateTimeNowFiltered.millisecondsSinceEpoch;
    int curTimeStamp = timestampStart;
    int prevYear = -1;
    int prevMonth = -1;
    int prevDay = -1;
    MonthModel monthModel;
    YearModel yearModel;
    CalendarModel calendarModel = CalendarModel();
    calendarModel.curDateTime = dateTimeNowFiltered;
    List<DayModel> dayModelListTotal = []; //所有的daymodel
    List<DayModel> dayModelListYear = []; //芳年算的daymodel
    List<DayModel> dayModelListMonth = []; //按月算的daymodel
    List<MonthModel> monthModelListForYear = []; //按年算的monthmodel
    List<MonthModel> monthModelListForCalendar = [];
    int i = 0;
    int iMonth = 0; //
    int curDateIndex = -1;
    int indexDaysOfMonth = -1;
    int indexMonth = 0;
    DayModel? todayDayModel = null;
    //当前时间小于结束时间
    while (curTimeStamp < timestampEnd) {
      //按天过滤
      DateTime curDateTme = getDateTimeFromTimeStamp(curTimeStamp);
      int year = curDateTme.year;
      int month = curDateTme.month;
      int day = curDateTme.day;
      int weekday = curDateTme.weekday; //星期几

      if (dateTimeNowFiltered.month == month &&
          dateTimeNowFiltered.year == year &&
          1 == day) {
        indexDaysOfMonth = i;
        indexMonth = iMonth;
      }

      if (prevMonth != -1 && month != prevMonth) {
        monthModel = MonthModel(
            yearName: year.toString(),
            isCurrent: (dateTimeNowFiltered.month) == (curDateTme.month) &&
                dateTimeNowFiltered.year == curDateTme.year,
            month: prevMonth,
            dayModelList: dayModelListMonth,
            monthName: Utility.getMonthName(prevMonth),
            dateTime: curDateTme);
        // monthModel.dayModelList.addAll(dayModelListMonth);
        iMonth++;
        dayModelListMonth = [];
        // yearModel.monthModelList.add(monthModel);
        monthModelListForYear.add(monthModel);
        monthModelListForCalendar.add(monthModel);
      }
      if (prevYear != -1 && year != prevYear) {
        yearModel = YearModel(
            isCurrent: dateTimeNowFiltered.year == curDateTme.year,
            year: prevYear,
            dayModelList: dayModelListYear,
            monthModelList: monthModelListForYear);
        // yearModel.monthModelList.addAll(monthModelListForYear);
        dayModelListYear = [];
        monthModelListForYear = [];
        calendarModel.yearModelList?.add(yearModel);
      }
      DayModel dayModel = DayModel(
          indexMonth: iMonth,
          lunarDay: Utility.getLunarCalendar(
              year: year, month: curDateTme.month, day: curDateTme.day),
          // weekdayName: Utility.getWeekOfDay(curTimeStamp, 0),
          year: year,
          dateTime: curDateTme,
          weekday: weekday,
          isCurrent: dateTimeNowFiltered.month == curDateTme.month &&
              dateTimeNowFiltered.year == curDateTme.year &&
              dateTimeNowFiltered.day == curDateTme.day);

      if (dateTimeNowFiltered.month == curDateTme.month &&
          dateTimeNowFiltered.year == curDateTme.year &&
          dateTimeNowFiltered.day == curDateTme.day) {
        todayDayModel = dayModel;
      }
      List<MissionModel> datasMissionModel = MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByEndTime(
              listMissionModels: listMissionModels,
              repetiveType: 0,
              start_endTime:
                  Utility.getFilterDateTimeFromTimeStamp(curTimeStamp)
                      .millisecondsSinceEpoch,
              end_endTime:
                  Utility.getFilterDateTimeFromTimeStamp(curTimeStamp, true)
                      .millisecondsSinceEpoch);
      datasMissionModel.forEach((element) {
        getMissionModelDuration(missionModel: element);
      });

      Utility.addMissionModelListToPushDataModelList(datasMissionModel);
      //todo 打卡时间要加上
      // Utility.addFlomoMissionModelListToPushDataModelList(datasFlomoMissionModels);
      dayModel.missionModelList = datasMissionModel;
      ProgressFocusModel model = getTotalDurationOfDayModel(dayModel: dayModel);
      dayModel.duration = model.totalValue;
      dayModel.completeDuration = model.currentValue;
      // dayModel.flomoMissionModelList = datasFlomoMissionModels;
      //可能会比较耗时
      // dayModel.hasAlertOfMissionModel = hasAlert(datasMissionModel);
      dayModel.month = Utility.getMonthName(month);
      dayModelListTotal.add(dayModel);
      dayModelListYear.add(dayModel);
      dayModelListMonth.add(dayModel);
      dayModel.day = day;
      curTimeStamp += 24 * 60 * 60 * 1000;

      prevYear = year;
      prevMonth = month;
      i++;
    }

    if (dayModelListMonth.isNotEmpty && prevMonth != -1) {
      // 循环内只会在“进入下一个月”时写入上个月，最后一个月需要在退出循环后补收口，
      // 否则像 2024 年 12 月这种年份末尾月份会直接丢失。
      monthModel = MonthModel(
          yearName: prevYear.toString(),
          isCurrent: dateTimeNowFiltered.month == prevMonth &&
              dateTimeNowFiltered.year == prevYear,
          month: prevMonth,
          dayModelList: dayModelListMonth,
          monthName: Utility.getMonthName(prevMonth),
          dateTime: dayModelListMonth.first.dateTime);
      monthModelListForYear.add(monthModel);
      monthModelListForCalendar.add(monthModel);
    }
    if ((dayModelListYear.isNotEmpty || monthModelListForYear.isNotEmpty) &&
        prevYear != -1) {
      // 同理，最后一年也不会触发“跨年”分支，需要在结尾补一次写入。
      yearModel = YearModel(
          isCurrent: dateTimeNowFiltered.year == prevYear,
          year: prevYear,
          dayModelList: dayModelListYear,
          monthModelList: monthModelListForYear);
      calendarModel.yearModelList?.add(yearModel);
    }
    calendarModel.curDaysIndex = curDateIndex;
    calendarModel.indexDaysOfMonth = indexDaysOfMonth;

    calendarModel.dayModelList = dayModelListTotal;
    calendarModel.monthModelList = monthModelListForCalendar;
    calendarModel.indexMonth = indexMonth;
    calendarModel.curTodayDayModel = todayDayModel;
    //把重复的日子放进去
    initCalendarModelWithRepetiveTypes(
        calendarModel: calendarModel, listMissionModels: listMissionModels);
    // initCalendarModelWithRepetiveTypesForFlomoMissionModels(
    //     calendarModel: calendarModel);
    initCalendarModelWithYearModel(calendarModel: calendarModel);

    // Utility.getGlobalContext()?.read<GlobalStateEnv>().calendarModel =
    //     calendarModel;

    // Utility.getGlobalContext().read<GlobalStateEnv>().calendarModel =
    //     calendarModel;
    /**
     * 往calendarmodel添加重复日期
     */
    //需要加个延迟 否则missionPage的会先执行 造成Utility.getGlobalContext().read<GlobalStateEnv>().calendarModel设置无效
    // Future.delayed(Duration(milliseconds: 100), () {
    //   CounterMethodChannelManager.getInstance()
    //       .storeMyCalendarMissionList(Utility.getGlobalContext());
    //   eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    //   eventBus.fire(EventFn(Params.ACTION_UPDATE_FLOMO_LISTVIEW, {}));
    //   Utility.getGlobalContext().read<Env>().curFolderSelected =
    //       Utility.getGlobalContext().read<Env>().curFolderSelected;
    // });
    // Future.delayed(Duration(milliseconds: 2000), () {
    //   NotificationManager.getInstance()
    //       ?.push8MorningNotification(calendarModel);
    //   NotificationManager.getInstance()?.push20OclockNotifiocation();
    //   if (Params.shouldRefreshPushModelList == true) {
    //     //todo 这个应该没有用了 没有关联
    //     CONSTANTS.pushDataModelListPrev = PushDataModelList.fromJson(
    //         jsonDecode(jsonEncode(CONSTANTS.pushDataModelList)));
    //     CounterMethodChannelManager.getInstance().pushListNotificationWithWhen(
    //         pushDataModelList: CONSTANTS.pushDataModelList);
    //     Params.shouldRefreshPushModelList = false;
    //   }
    // });
    return calendarModel;
  }

  static Future<CalendarModel> initCalendarModel() async {
    //重新刷新推送列表
    CONSTANTS.pushDataModelList.refresh();
    // PushDataModelList pushDataModelList = PushDataModelList();
    DateTime date = DateTime.now();
    //定义时间范围
    DateTime dateTimeStart = new DateTime(date.year - 1);
    int timestampStart = dateTimeStart.millisecondsSinceEpoch;
    DateTime dateTimeEnd = new DateTime(date.year + 2);
    int timestampEnd = dateTimeEnd.millisecondsSinceEpoch;
    int timestampNow = getTimeStampToday();
    DateTime dateTimeNowFiltered = getFilterDateTimeFromTimeStamp(timestampNow);
    int timestampNowFiltered = dateTimeNowFiltered.millisecondsSinceEpoch;
    int curTimeStamp = timestampStart;
    int prevYear = -1;
    int prevMonth = -1;
    int prevDay = -1;
    MonthModel monthModel;
    YearModel yearModel;
    CalendarModel calendarModel = CalendarModel();
    calendarModel.curDateTime = dateTimeNowFiltered;
    List<DayModel> dayModelListTotal = []; //所有的daymodel
    List<DayModel> dayModelListYear = []; //芳年算的daymodel
    List<DayModel> dayModelListMonth = []; //按月算的daymodel
    List<MonthModel> monthModelListForYear = []; //按年算的monthmodel
    List<MonthModel> monthModelListForCalendar = [];
    int i = 0;
    int iMonth = 0; //
    int curDateIndex = -1;
    int indexDaysOfMonth = -1;
    int indexMonth = 0;
    DayModel? todayDayModel = null;
    //当前时间小于结束时间
    while (curTimeStamp < timestampEnd) {
      //按天过滤
      DateTime curDateTme = getDateTimeFromTimeStamp(curTimeStamp);
      int year = curDateTme.year;
      int month = curDateTme.month;
      int day = curDateTme.day;
      int weekday = curDateTme.weekday; //星期几

      if (dateTimeNowFiltered.month == month &&
          dateTimeNowFiltered.year == year &&
          1 == day) {
        indexDaysOfMonth = i;
        indexMonth = iMonth;
      }

      if (prevMonth != -1 && month != prevMonth) {
        monthModel = MonthModel(
            yearName: year.toString(),
            isCurrent: (dateTimeNowFiltered.month) == (curDateTme.month) &&
                dateTimeNowFiltered.year == curDateTme.year,
            month: prevMonth,
            dayModelList: dayModelListMonth,
            monthName: Utility.getMonthName(prevMonth),
            dateTime: curDateTme);
        // monthModel.dayModelList.addAll(dayModelListMonth);
        iMonth++;
        dayModelListMonth = [];
        // yearModel.monthModelList.add(monthModel);
        monthModelListForYear.add(monthModel);
        monthModelListForCalendar.add(monthModel);
      }
      if (prevYear != -1 && year != prevYear) {
        yearModel = YearModel(
            isCurrent: dateTimeNowFiltered.year == curDateTme.year,
            year: prevYear,
            dayModelList: dayModelListYear,
            monthModelList: monthModelListForYear);
        // yearModel.monthModelList.addAll(monthModelListForYear);
        dayModelListYear = [];
        monthModelListForYear = [];
        calendarModel.yearModelList?.add(yearModel);
      }
      DayModel dayModel = DayModel(
          indexMonth: iMonth,
          lunarDay: Utility.getLunarCalendar(
              year: year, month: curDateTme.month, day: curDateTme.day),
          // weekdayName: Utility.getWeekOfDay(curTimeStamp, 0),
          year: year,
          dateTime: curDateTme,
          weekday: weekday,
          isCurrent: dateTimeNowFiltered.month == curDateTme.month &&
              dateTimeNowFiltered.year == curDateTme.year &&
              dateTimeNowFiltered.day == curDateTme.day);

      if (dateTimeNowFiltered.month == curDateTme.month &&
          dateTimeNowFiltered.year == curDateTme.year &&
          dateTimeNowFiltered.day == curDateTme.day) {
        todayDayModel = dayModel;
      }
      List<MissionModel> datasMissionModel =
          await MongoApisManager.getInstance()
              .queryWhereEqual_missionDataByEndTime(
                  repetiveType: 0,
                  start_endTime:
                      Utility.getFilterDateTimeFromTimeStamp(curTimeStamp)
                          .millisecondsSinceEpoch,
                  end_endTime:
                      Utility.getFilterDateTimeFromTimeStamp(curTimeStamp, true)
                          .millisecondsSinceEpoch);
      datasMissionModel.forEach((element) {
        getMissionModelDuration(missionModel: element);
      });
      List<FlomoMissionModel> datasFlomoMissionModels =
          await MongoApisManager.getInstance()
              .queryWhereEqual_flomoMissionDataByEndTime(
                  repetiveType: 0,
                  start_endTime:
                      Utility.getFilterDateTimeFromTimeStamp(curTimeStamp)
                          .millisecondsSinceEpoch,
                  end_endTime:
                      Utility.getFilterDateTimeFromTimeStamp(curTimeStamp, true)
                          .millisecondsSinceEpoch);

      // queryWhereEqual_flomoMissionDataByEndTime

      Utility.addMissionModelListToPushDataModelList(datasMissionModel);
      //todo 打卡时间要加上
      // Utility.addFlomoMissionModelListToPushDataModelList(datasFlomoMissionModels);
      dayModel.missionModelList = datasMissionModel;
      ProgressFocusModel model = getTotalDurationOfDayModel(dayModel: dayModel);
      dayModel.duration = model.totalValue;
      dayModel.completeDuration = model.currentValue;
      dayModel.flomoMissionModelList = datasFlomoMissionModels;
      //可能会比较耗时
      dayModel.hasAlertOfMissionModel = hasAlert(datasMissionModel);
      dayModel.month = Utility.getMonthName(month);
      dayModelListTotal.add(dayModel);
      dayModelListYear.add(dayModel);
      dayModelListMonth.add(dayModel);
      dayModel.day = day;
      curTimeStamp += 24 * 60 * 60 * 1000;

      prevYear = year;
      prevMonth = month;
      i++;
    }

    if (dayModelListMonth.isNotEmpty && prevMonth != -1) {
      // 最后一个月没有“下个月”来触发入列，这里补上收口，避免 12 月缺失。
      monthModel = MonthModel(
          yearName: prevYear.toString(),
          isCurrent: dateTimeNowFiltered.month == prevMonth &&
              dateTimeNowFiltered.year == prevYear,
          month: prevMonth,
          dayModelList: dayModelListMonth,
          monthName: Utility.getMonthName(prevMonth),
          dateTime: dayModelListMonth.first.dateTime);
      monthModelListForYear.add(monthModel);
      monthModelListForCalendar.add(monthModel);
    }
    if ((dayModelListYear.isNotEmpty || monthModelListForYear.isNotEmpty) &&
        prevYear != -1) {
      yearModel = YearModel(
          isCurrent: dateTimeNowFiltered.year == prevYear,
          year: prevYear,
          dayModelList: dayModelListYear,
          monthModelList: monthModelListForYear);
      calendarModel.yearModelList?.add(yearModel);
    }
    calendarModel.curDaysIndex = curDateIndex;
    calendarModel.indexDaysOfMonth = indexDaysOfMonth;

    calendarModel.dayModelList = dayModelListTotal;
    calendarModel.monthModelList = monthModelListForCalendar;
    calendarModel.indexMonth = indexMonth;
    calendarModel.curTodayDayModel = todayDayModel;
    //把重复的日子放进去
    initCalendarModelWithRepetiveTypes(calendarModel: calendarModel);
    initCalendarModelWithRepetiveTypesForFlomoMissionModels(
        calendarModel: calendarModel);
    initCalendarModelWithYearModel(calendarModel: calendarModel);

    Utility.getGlobalContext()?.read<GlobalStateEnv>().calendarModel =
        calendarModel;

    // Utility.getGlobalContext().read<GlobalStateEnv>().calendarModel =
    //     calendarModel;
    /**
     * 往calendarmodel添加重复日期
     */
    //需要加个延迟 否则missionPage的会先执行 造成Utility.getGlobalContext().read<GlobalStateEnv>().calendarModel设置无效
    Future.delayed(Duration(milliseconds: 100), () {
      CounterMethodChannelManager.getInstance()
          .storeMyCalendarMissionList(Utility.getGlobalContext());
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_FLOMO_LISTVIEW, {}));
      Utility.getGlobalContext().read<Env>().curFolderSelected =
          Utility.getGlobalContext().read<Env>().curFolderSelected;
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      NotificationManager.getInstance()
          ?.push8MorningNotification(calendarModel);
      NotificationManager.getInstance()?.push20OclockNotifiocation();
      if (Params.shouldRefreshPushModelList == true) {
        //todo 这个应该没有用了 没有关联
        CONSTANTS.pushDataModelListPrev = PushDataModelList.fromJson(
            jsonDecode(jsonEncode(CONSTANTS.pushDataModelList)));
        CounterMethodChannelManager.getInstance().pushListNotificationWithWhen(
            pushDataModelList: CONSTANTS.pushDataModelList);
        Params.shouldRefreshPushModelList = false;
      }
    });
    return calendarModel;
  }

  /**
   * Calendar显示是否当前时间有预警
   */
  static bool hasAlert(List<MissionModel> list) {
    for (int i = 0; i < list.length; i++) {
      MissionModel missionModel = list[i];
      try {
        if (missionModel.alert_time != null || missionModel.alert_time! > 0) {
          return true;
        }
      } catch (e) {}
    }
    return false;
  }

  /**
   * 是否有alert
   */
  static bool isAlertOn(MissionModel missionModel) {
    if (missionModel.alert_time != null ||
        (missionModel?.alert_time ?? 0) > 0) {
      return true;
    }
    return false;
  }

  /**
   * toast用这个context会造成全局刷新
   */
  static BuildContext getGlobalContext() {
    try {
      BuildContext context = navigatorKey.currentState?.overlay?.context ??
          MyApp.context ??
          Utility.getGlobalContext();
      return context;
    } catch (e) {
      return MyApp.context!;
    }
  }

  /**
   * 得到hash值  xxxx-yyyy-zzzz-aaaa
   */
  static String getUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }

  /**
   * 这里会取androidid eventcollection会用这个 所以要做好判断
   */
  static Future<String> getDeviceId() async {
    String? deviceId;
    if (DeviceInfoManagement.isWEB() == true) {
      return getUUIDDeviceId();
    }
    // if (Utility.isXiaoMi() == false) {
    //   try {
    //     deviceId = await PlatformDeviceId.getDeviceId;
    //     if (TextUtil.isEmpty(deviceId)) {
    //       // deviceId = SharePreferenceUtil.getSyncInstance()
    //       //     .getString(key: ShareprefrenceKeys.deviceId);
    //       // if (TextUtil.isEmpty(deviceId)) {
    //       deviceId = getUUIDDeviceId();
    //       // }
    //
    //       // deviceId = deviceId;
    //       // deviceId =
    //       //     await CounterMethodChannelManager.getInstance().aliyunDeviceId();
    //     }
    //     return deviceId ?? '';
    //   } on PlatformException {
    //     deviceId = '';
    //   }
    //   return '';
    // } else {
    return getUUIDDeviceId();
    // }
  }

  static String getUUIDDeviceId() {
    String deviceId = "";
    deviceId = SharePreferenceUtil.getSyncInstance()
        .getString(key: ShareprefrenceKeys.deviceId);
    if (TextUtil.isEmpty(deviceId)) {
      var uuid = Uuid();
      String uuidString = uuid.v4();
      SharePreferenceUtil.getSyncInstance()
          .setString(key: ShareprefrenceKeys.deviceId, content: uuidString);
      deviceId = SharePreferenceUtil.getSyncInstance()
          .getString(key: ShareprefrenceKeys.deviceId);
    }
    return deviceId;
  }

  /**
   * 图片可以用这个挑选
   * Image.memory(selectedFile)
   */
  static Future<Uint8List?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      Uint8List selectedFile = file.readAsBytesSync();
      return selectedFile;
    }
    return null;
  }

  //Uint8List 和 List<int> 一样
  static saveFileWithExtension(Uint8List data, String extension) async {
    final tempDir = await getApplicationSupportDirectory();
    final path = tempDir.path +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        extension;
    File file = File(path);
    file.writeAsBytesSync(data);
  }

  static bool isMobile() {
    if (Utility.isIOS()) {
      return true;
    } else if (Utility.isAndroid()) {
      return true;
    }
    return false;
  }

  static bool isChina() {
    return DeviceInfoManagement.getCountryCode() == "CN" &&
        DeviceInfoManagement.getLanguage() == 'zh';
  }

  /**
   * 获取font icon图标
   * 图片来源可以在下面这里搜索:
   * https://fontawesome.com/v5.15/icons?d=gallery&p=2
   * https://fontawesome.com/v6.0/icons?q=tomato&s=solid%2Cbrands
   */
  static getFontAwesomeIcon(IconData icon, double size, Color color) {
    return FaIcon(icon, size: size, color: color);
  }

  static int getRandom({int from = 0, int max = 0}) {
    Random rng = new Random(); //随机数生成类
    int randomVal = from + rng.nextInt(max - from);
    return randomVal;
  }

  static EventCollectionModel initEventInfoWithEnvironment(
      EventCollectionModel event) {
    event.appVersion = AutoUpdateManager.getInstance().curVersion;
    event.deviceId = MongoApisManager.getInstance().device_id;
    event.sysCode = Params.sysCode;
    event.deviceKey = MongoApisManager.getInstance().device_id;
    event.timeZoneOffset = Utility.getTimeZoneOffset();
    // event.update_time = Utility.getTimeStampToday();
    event.timezoneName = DeviceInfoManagement.getInstance()?.getTimeZoneName();
    event.country = DeviceInfoManagement.getCountryCode();
    event.lang = DeviceInfoManagement.getLanguage();
    event.brand = DeviceInfoManagement.getInstance()?.getBrand();

    event.brand = DeviceInfoManagement.getInstance()?.getBrand();
    event.productName = 'TimeMachine';

    try {
      event.region =
          DeviceInfoManagement.getInstance()?.ipApiLocationBean?.region;
    } catch (e) {}
    try {
      event.regionName =
          DeviceInfoManagement.getInstance()?.ipApiLocationBean?.regionName;
    } catch (e) {}
    try {
      event.city = DeviceInfoManagement.getInstance()?.ipApiLocationBean?.city;
    } catch (e) {}
    try {
      event.lat = DeviceInfoManagement.getInstance()?.ipApiLocationBean?.lat;
    } catch (e) {}
    try {
      event.lon = DeviceInfoManagement.getInstance()?.ipApiLocationBean?.lon;
    } catch (e) {}
    try {
      event.countryCode =
          DeviceInfoManagement.getInstance()?.ipApiLocationBean?.countryCode;
    } catch (e) {}
    try {
      event.ip = DeviceInfoManagement.getInstance()?.ipApiLocationBean?.query;
    } catch (e) {}
    return event;
  }

  static String getDateTimeNowUtc() {
    return new DateTime.now().toUtc().toString();
  }

  static String getTimeZoneOffset() {
    return new DateTime.now().timeZoneOffset.inHours.toString();
  }

  static getRandomString({int from = 0, int max = 0, int pureInt = 0}) {
    Random rng = new Random(); //随机数生成类
    int randomVal = from + rng.nextInt(max - from);
    if (pureInt == 0) {
      return randomVal;
    } else {
      String randomString = randomVal.toString();
      int length = randomString.length;
      String ret = '';
      if (pureInt > length) {
        for (int i = 0; i < pureInt - length; i++) {
          ret += '0';
        }
      }
      return ret + randomString;
    }
  }

  static String getFixedInt(int val, [int pureInt = 0]) {
    String valString = val.toString();
    int length = valString.length;
    String ret = '';
    if (pureInt > length) {
      for (int i = 0; i < pureInt - length; i++) {
        ret += '0';
      }
    }
    return ret + valString;
  }

  static listModelsToListJson(List listParam) {
    List list = [];
    listParam.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  // static deepCloneDayModelList(List listParam) {
  //   listParam = jsonToList(listToJsonString(listModelsToListJson(listParam)));
  //
  //   List<DayModel> list = [];
  //   listParam.forEach((element) {
  //     list.add(DayModel.fromJson(element));
  //   });
  //   return list;
  // }

  static List<MissionModel> getMissionModelListFromList(
      List<DayModel> listParam) {
    List<MissionModel> list = [];
    listParam.forEach((element) {
      element.missionModelList.forEach((missionModel) {
        if (!list.contains(missionModel)) {
          list.add(missionModel);
        }
      });
    });
    return list;
  }

  static filterDaysModelsByDateTimeRange(List<DayModel> listParam,
      FolderModel? folderModel, DateTime? startDateTime, DateTime? endDateTime,
      [String? curSearchWords = null]) {
    // listParam = deepCloneDayModelList(listParam);
    // listParam = deepCloneList(listParam).cast<DayModel>();
    List<DayModel> list = [];
    if (folderModel != null) {
      listParam.forEach((dayModel) {
        // DayModel dayModelToClone = DayModel.
        DateTime? dateTime = dayModel.dateTime;
        if (dateTime != null && startDateTime != null && endDateTime != null) {
          if ((dateTime.isAfter(startDateTime) ||
                  dateTime.isAtSameMomentAs(startDateTime)) &&
              (dateTime.isBefore(endDateTime))) {
            List<MissionModel> listMissionModels = [];
            dayModel.missionModelList.forEach((missionModel) {
              if (missionModel.folder_id == folderModel.objectId ||
                  TextUtil.isEmpty(folderModel.objectId)) {
                if ((!TextUtil.isEmpty(missionModel.title) &&
                        missionModel.title!.contains(curSearchWords ?? '') ||
                    curSearchWords == null))
                  listMissionModels.add(missionModel);
              }
            });
            list.add(dayModel.deepClone(listMissionModels));
          }
        } else {
          List<MissionModel> listMissionModels = [];
          dayModel.missionModelList.forEach((missionModel) {
            if (missionModel.folder_id == folderModel.objectId) {
              if ((!TextUtil.isEmpty(missionModel.title) &&
                      missionModel.title!.contains(curSearchWords ?? '') ||
                  curSearchWords == null)) listMissionModels.add(missionModel);
            }
          });
          list.add(dayModel.deepClone(listMissionModels));
        }
      });
    } else {
      list = listParam;
    }
    return list;
  }

  static filterDaysModels(List<DayModel> listParam, FolderModel? folderModel,
      [String? curSearchWords = null]) {
    // listParam = deepCloneDayModelList(listParam);
    // listParam = deepCloneList(listParam).cast<DayModel>();
    List<DayModel> list = [];
    if (folderModel != null) {
      listParam.forEach((dayModel) {
        // DayModel dayModelToClone = DayModel.
        List<MissionModel> listMissionModels = [];
        dayModel.missionModelList.forEach((missionModel) {
          if (missionModel.folder_id == folderModel.objectId) {
            if ((!TextUtil.isEmpty(missionModel.title) &&
                    missionModel.title!.contains(curSearchWords ?? '') ||
                curSearchWords == null)) listMissionModels.add(missionModel);
          }
        });
        list.add(dayModel.deepClone(listMissionModels));
      });
    } else {
      list = listParam;
    }
    return list;
  }

  // static void showAwsomeDialog(BuildContext context,
  //     {required VoidCallback cancelCallback,
  //     required VoidCallback confirmCallback,
  //     String? title,
  //       String? btnCancelText,
  // String? btnOkText,
  //     required String content,
  //     }) async {
  //   if(TextUtil.isEmpty(btnOkText)) {
  //     btnOkText = getI18NKey().confirm;
  //   }
  //   // if(TextUtil.isEmpty(btnCancelText)) {
  //   //   btnCancelText = getI18NKey().cancel;
  //   // }
  //   final theme = Theme.of(context);
  //   final adaptiveStyle = style ?? AdaptiveDialog.instance.defaultStyle;
  //   final isMacOS = adaptiveStyle.effectiveStyle(theme) == AdaptiveStyle.macOS;
  //   final result = await showAlertDialog<OkCancelResult>(
  //     routeSettings: routeSettings,
  //     context: context,
  //     title: title,
  //     message: message,
  //     barrierDismissible: barrierDismissible,
  //     style: alertStyle ?? style,
  //     useActionSheetForIOS: useActionSheetForCupertino || useActionSheetForIOS,
  //     useRootNavigator: useRootNavigator,
  //     actionsOverflowDirection: actionsOverflowDirection,
  //     fullyCapitalizedForMaterial: fullyCapitalizedForMaterial,
  //     onWillPop: onWillPop,
  //     builder: builder,
  //     actions: [
  //       AlertDialogAction(
  //         label: okLabel ?? MaterialLocalizations.of(context).okButtonLabel,
  //         key: OkCancelResult.ok,
  //         isDefaultAction: isMacOS,
  //       ),
  //     ],
  //   );
  //   return result ?? OkCancelResult.cancel;
  // }

  static List<ChatGptMessageModelWithExtraData>
      filterChatGptMessageModelWithExtraData(
          List<ChatGptMessageModel> listParam,
          {String? curSearchWords}) {
    List<ChatGptMessageModelWithExtraData> list = [];
    List<ChatGptMessageModel> listFolders = [];
    listParam.forEach((element) {
      if (element.modelType == 1 && !TextUtil.isEmpty(element.folderTitle)) {
        listFolders.add(element);
      }
    });
    //把listFolders 根据create_at时间排序 最新放在最前面
    listFolders.sort((a, b) {
      return (a.updated_at ?? 0) > (b.updated_at ?? 0)
          ? -1
          : (a.updated_at ?? 0) < (b.updated_at ?? 0)
              ? 1
              : 0;
    });
    //把listFolders根据updated_at的时间归类，24小内用 1 hour ago 2 hours agon 23 hours ago
    // 24小时以上用 1 day ago 2 days ago 3 days ago 归类放到
    // ChatGptMessageModelWithExtraData({required this.timeAgo, required this.list});
    List<ChatGptMessageModelWithExtraData>
        listChatGptMessageModelWithExtraData = [];
    List<Map> listTimeSection = [];
    List<String> listTimeSectionForValue = [];
    //遍历 listFolders 判断 listFolders的updated_at有那个时间段 24小时内 24小时外 放到listTimeSection中
    listFolders.forEach((element) {
      Map map = Utility.getTimeAgo(element.updated_at ?? 0);
      int time = map["time"];
      String unit = map["unit"];
      int value = map["value"];
      //不包含 放进去 证明可切割
      if (!listTimeSectionForValue.contains("${value}value${unit}unit")) {
        listTimeSection.add(map);
        listTimeSectionForValue.add("${value}value${unit}unit");
      }
    });

    listTimeSection.sort((a, b) {
      return a['time'] > b['time']
          ? -1
          : a['time'] < b['time']
              ? 1
              : 0;
    });
    int? prevTime1 = null;
    //把切割的时间从Listparams拿到数据 并填充到list里
    listTimeSection.forEach((element) {
      int time = element['time'];
      String unit = element['unit'];
      int value = element['value'];
      ChatGptMessageModelWithExtraData? model;
      if (unit == 'hour') {
        model = Utility.getChatGptMessageModelWithExtraDataByTimeAgo(
            listParam: listFolders,
            time1: prevTime1 ?? 100000000000000,
            time2: time - 60 * 60 * 1000);
      } else {
        //按天
        model = Utility.getChatGptMessageModelWithExtraDataByTimeAgo(
            listParam: listFolders,
            time1: prevTime1 ?? 100000000000000,
            time2: time - 24 * 60 * 60 * 1000);
      }
      prevTime1 = time;
      if (model != null) {
        list.add(model!);
      }
    });
    return list;
  }

  static ChatGptMessageModelWithExtraData?
      getChatGptMessageModelWithExtraDataByTimeAgo(
          {required List<ChatGptMessageModel> listParam,
          int time1 = 100000000000000,
          required int time2}) {
    //复制listParam
    // 从list得到updated_at 在time1和time2之间的 time1可能为空
    // List<ChatGptMessageModelWithExtraData> list = [];
    List<ChatGptMessageModel> listToRemoved = [];
    DateTime dateTime1 = Utility.getDateTimeFromTimeStamp(time1);
    DateTime dateTime2 = Utility.getDateTimeFromTimeStamp(time2);
    List<ChatGptMessageModel> listTmp = [];
    listParam.forEach((ChatGptMessageModel element) {
      DateTime dateTime =
          Utility.getDateTimeFromTimeStamp(element.updated_at ?? 0);
      print("dateTime1 $dateTime1 dateTime2 $dateTime2 dateTime $dateTime");
      if (element?.updated_at != null &&
          ((element?.updated_at ?? 1000000000000) >= time2) &&
          ((element?.updated_at ?? 1000000000000) <= time1)) {
        listToRemoved.add(element);
        // listParam.remove(element);
        // list.add(element);
        listTmp.add(element);
      }
    });
    listToRemoved.forEach((element) {
      listParam.remove(element);
    });

    Map map = Utility.getTimeAgo(time2);
    String timeAgo = map["value"].toString() + " " + map["unit"];
    return ChatGptMessageModelWithExtraData(timeAgo: timeAgo, list: listTmp);
  }

//时间归类，24小内用 1 hour ago 2 hours agon 23 hours ago
// 24小时以上用 1 day ago 2 days ago 3 days ago 归类放到
  static Map getTimeAgo(int timestamp) {
    int now = Utility.getTimeStampToday();
    int diff = now - timestamp;
    if (diff < 24 * 60 * 60 * 1000) {
      return {
        "unit": "hour",
        "value": (diff / (60 * 60 * 1000)).floor(),
        'time': timestamp
      };
    } else {
      int daysAgo = (diff / (24 * 60 * 60 * 1000)).floor();
      int time2 = now - daysAgo * 24 * 60 * 60 * 1000;
      DateTime dateTime = Utility.getDateTimeFromTimeStamp(time2);
      return {"unit": "day", "value": daysAgo, 'time': time2};
    }
  }

  /**
   * 生成 000000 ~ 9999999 字符串
   */
  static String getGroupId({int numDigit = 6}) {
    String groupId = '';
    for (int i = 0; i < numDigit; i++) {
      groupId +=
          Utility.getRandomString(from: 0, max: 9, pureInt: 1).toString();
    }
    return groupId;
  }

  //
  // static List<ChatGptMessageModel> getChatGptMessageModelListByFolderId(
  //     List<ChatGptMessageModel> listParam, String folderId) {
  //   List<ChatGptMessageModel> list = [];
  //   listParam.forEach((element) {
  //     if (element.folder_objectId == folderId) {
  //       list.add(element);
  //     }
  //   });
  //   return list;
  // }

  static List<MissionModel> getMissionModelsForRatioMissionModel(
      List<MissionModel> list, DateTime? startDateTime, DateTime? endDateTime) {
    List<MissionModel> listMissionModels = [];
    for (int i = 0; i < list.length; i++) {
      MissionModel missionModel = list[i];
      if (endDateTime == null && startDateTime != null) {
        endDateTime =
            Utility.getFilterDateTimeFromDateTime(startDateTime, true);
      }
      if (startDateTime != null && endDateTime != null) {
        DateTime? curDateTime =
            Utility.getFilterDateTimeFromTimeStamp(missionModel.end_time ?? 0);
        if (curDateTime != null) {
          if ((curDateTime.isAfter(startDateTime) ||
                  curDateTime.isAtSameMomentAs(startDateTime)) &&
              (curDateTime.isBefore(endDateTime) ||
                  curDateTime.isAtSameMomentAs(endDateTime))) {
            listMissionModels.add(missionModel);
          }
        }
      }
      if (startDateTime == null && endDateTime == null) {
        listMissionModels.add(missionModel);
      }
    }
    return listMissionModels;
  }

  static List<MissionModel> getMissionModelsForRatio(
      List<DayModel> list, DateTime? startDateTime, DateTime? endDateTime) {
    List<MissionModel> listMissionModels = [];
    for (int i = 0; i < list.length; i++) {
      DayModel dayModel = list[i];
      dayModel.missionModelList.forEach((MissionModel _missionModel) {
        if (endDateTime == null && startDateTime != null) {
          endDateTime =
              Utility.getFilterDateTimeFromDateTime(startDateTime!, true);
        }
        if (startDateTime != null && endDateTime != null) {
          DateTime? curDateTime = dayModel.dateTime;
          if (curDateTime != null) {
            if ((curDateTime.isAfter(startDateTime!) ||
                    curDateTime.isAtSameMomentAs(startDateTime!)) &&
                (curDateTime.isBefore(endDateTime!) ||
                    curDateTime.isAtSameMomentAs(endDateTime!))) {
              listMissionModels.add(_missionModel);
            }
          }
        }
        if (startDateTime == null && endDateTime == null) {
          listMissionModels.add(_missionModel);
        }
      });
    }
    return listMissionModels;
  }

  static DateTime getTodayStartTime() {
    DateTime dateTime = DateTime.now();
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0);
  }

  static DateTime getTodayEndTime() {
    DateTime dateTime = DateTime.now();
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 59);
  }

  static DateTime getTomorrowStartTime() {
    DateTime dateTime = DateTime.now();
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day + 1, 0, 0, 0, 0);
  }

  static DateTime getTomorrowEndTime() {
    DateTime dateTime = DateTime.now();
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day + 1, 23, 59, 59, 59);
  }

  static DateTime getWeekStartTime() {
    DateTime dateTime = DateTime.now();
    int weekDay = dateTime.weekday;
    DateTime dateTimeStart = dateTime.subtract(Duration(days: weekDay - 1));
    return DateTime(
        dateTimeStart.year, dateTimeStart.month, dateTimeStart.day, 0, 0, 0, 0);
  }

  static DateTime getWeekEndTime() {
    DateTime dateTime = DateTime.now();
    int weekDay = dateTime.weekday;
    DateTime dateTimeEnd = dateTime.add(Duration(days: 7 - weekDay));
    return DateTime(
        dateTimeEnd.year, dateTimeEnd.month, dateTimeEnd.day, 23, 59, 59, 59);
  }

  static DateTime getNDaysAgoStartTimeByMilliseconds(int n) {
    DateTime dateTime = DateTime.now();
    DateTime dateTimeStart = dateTime.subtract(Duration(milliseconds: n));
    return DateTime(
        dateTimeStart.year, dateTimeStart.month, dateTimeStart.day, 0, 0, 0, 0);
  }

  static DateTime getNDaysAgoStartTime(int n) {
    DateTime dateTime = DateTime.now();
    DateTime dateTimeStart = dateTime.subtract(Duration(days: n));
    return DateTime(
        dateTimeStart.year, dateTimeStart.month, dateTimeStart.day, 0, 0, 0, 0);
  }

  static DateTime getNDaysAgoEndTime(int n) {
    DateTime dateTime = DateTime.now();
    DateTime dateTimeEnd = dateTime.subtract(Duration(days: n));
    return DateTime(
        dateTimeEnd.year, dateTimeEnd.month, dateTimeEnd.day, 23, 59, 59, 59);
  }

  static DateTime getNDaysAfterEndTimeByMilliseconds(int n) {
    DateTime dateTime = DateTime.now();
    DateTime dateTimeEnd = dateTime.add(Duration(milliseconds: n));
    return DateTime(
        dateTimeEnd.year, dateTimeEnd.month, dateTimeEnd.day, 23, 59, 59, 59);
  }

  static DateTime getNDaysAfterEndTime(int n) {
    DateTime dateTime = DateTime.now();
    DateTime dateTimeEnd = dateTime.add(Duration(days: n));
    return DateTime(
        dateTimeEnd.year, dateTimeEnd.month, dateTimeEnd.day, 23, 59, 59, 59);
  }

  /**
   * dateTime1Start 是 设置好的时间 不能为空
   * dateTime1End 是 设置好的时间 可以为空
   * dateTime2Start 是 任务的开始时间 可以为空
   * dateTime2End 是 任务的结束时间 不能为空
   */
  static bool isDateTimeIntersectionByMilliSeconds(
      int? dateTimeSetting1Start,
      int? dateTimeSetting1End,
      int? dateTimeMission2Start,
      int? dateTimeMission2End) {
    if (dateTimeMission2Start == 0) {
      dateTimeMission2Start = null;
    }
    if (dateTimeSetting1Start == 0) {
      dateTimeSetting1Start = null;
    }
    if (dateTimeSetting1End == 0) {
      dateTimeSetting1End = null;
    }
    if ((dateTimeMission2Start == null && dateTimeMission2End == null) &&
        (dateTimeSetting1Start != null || dateTimeSetting1End != null)) {
      // 任务没设置时间 但是设置了时间 任务没有开始时间
      return false;
    }

    if ((dateTimeMission2Start != null && dateTimeMission2End != null) &&
        (dateTimeSetting1Start == null || dateTimeSetting1End == null)) {
      // 任务没设置时间 但是设置了时间 任务没有开始时间
      return false;
    }
    // if (dateTimeSetting1Start != null && dateTimeSetting1End != null) {
    //   return true;
    // }
    // dateTime1Start 不为空 dateTime1End为空 dateTime2Start为空 dateTime2End为空 计算是否有交叉值
    if (dateTimeSetting1Start != null &&
        dateTimeSetting1End == null &&
        dateTimeMission2Start != null &&
        dateTimeMission2End != null) {
      //任务没有设置时间
      if (dateTimeSetting1Start >= dateTimeMission2End) {
        return true;
      }
      return false;
    }
    if (dateTimeSetting1Start != null &&
        dateTimeSetting1End != null &&
        dateTimeMission2Start == null &&
        dateTimeMission2End != null) {
      //任务没有设置时间
      if (dateTimeSetting1Start <= dateTimeMission2End) {
        return true;
      }
    }
    if (dateTimeSetting1Start != null &&
        dateTimeSetting1End != null &&
        dateTimeMission2Start != null &&
        dateTimeMission2End != null) {
      //任务没有设置时间
      if (
          // Case 1: First interval fully contains the second interval.
          (dateTimeSetting1Start <= dateTimeMission2Start &&
                  dateTimeSetting1End >= dateTimeMission2End) ||

              // Case 2: Intervals overlap.
              (dateTimeSetting1Start <= dateTimeMission2End &&
                  dateTimeSetting1End >= dateTimeMission2Start)) {
        return true;
      }
      return false;
    }

    if (dateTimeSetting1Start != null &&
        dateTimeSetting1End != null &&
        dateTimeMission2Start == null &&
        dateTimeMission2End != null) {
      //任务没有设置时间
      if (dateTimeSetting1Start <= dateTimeMission2End) {
        return true;
      }
    }

    return false;
  }

  /**
   * 获取font icon图标
   * 图片来源可以在下面这里搜索:
   * https://fontawesome.com/v5.15/icons?d=gallery&p=2
   * https://fontawesome.com/v6.0/icons?q=tomato&s=solid%2Cbrands
   */
  static Widget getSVGPicture(String icon, {double? size, Color? color}) {
    if (icon.indexOf("svg") != -1) {
      return SvgPicture.asset(icon, width: size, height: size, color: color);
    } else {
      return Image.asset(icon, width: size, height: size, fit: BoxFit.cover);
    }
  }

  /**
   * 获取任务类型和任务目标
   */
  static MissionModelEnum getMissionModelEnumByType(
      {MissionModel? missionModel}) {
    // int? time_mode = 0; // 0 日期 1 时间段 2 目标
    switch (missionModel?.time_mode) {
      case 0:
        return MissionModelEnum.date;
      case 1:
        return MissionModelEnum.time;
      case 2:
        return MissionModelEnum.objective;
      default:
        return MissionModelEnum.date;
    }
  }

  //vip开关是否开
  static bool isVipSwitchOn() {
    //时常出现没返回数据的情况
    if (DeliveryInfoBean.isVIPPurchaseOn?.extendParamsMap?['data'] == null) {
      return false;
    }
    String supportFreeVipCountryAndLanguage =
        DeliveryInfoBean.isVIPPurchaseOn?.extendParamsMap?['data'] ?? "";
    if (TextUtil.isEmpty(supportFreeVipCountryAndLanguage) == 0) {
      return true;
    }
    if (supportFreeVipCountryAndLanguage.indexOf("all_purchase") == 0) {
      return false;
    }
    if (supportFreeVipCountryAndLanguage.indexOf("all") == 0) {
      return true;
    }
    if (TextUtil.isEmpty(supportFreeVipCountryAndLanguage) == false &&
        supportFreeVipCountryAndLanguage
                .indexOf(DeviceInfoManagement.getCountryCode()) !=
            -1) {
      return true;
    }
    if (TextUtil.isEmpty(supportFreeVipCountryAndLanguage) == false &&
        supportFreeVipCountryAndLanguage
                .indexOf(DeviceInfoManagement.getLanguage()) !=
            -1) {
      return true;
    }
    return false;
    // if (supportFreeVipCountry.) {
    //   return true;
    // }
    // return false;
  }

  static List<MissionModel> convertListEventModelToListMissionModel(
      List<EventModel> list) {
    List<MissionModel> listMission = [];
    list.forEach((element) {
      listMission.add(convertEventModelToMissionModel(element));
    });
    return listMission;
  }

  //1734859200000 从这个时间戳 转成date 得到 hour min sec 再转成整形毫秒的函数
  static int getMillisecondFromTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    int hour = dateTime.hour;
    int min = dateTime.minute;
    int sec = dateTime.second;
    return hour * 3600 * 1000 + min * 60 * 1000 + sec * 1000;
  }

  static String getJumpTxt({int? missionModelType}) {
    //null 或者 0是默认的 1是苹果日历 2是苹果提醒 3.google日历
    if (missionModelType == 1) {
      return getI18NKey().apple_calendar;
    } else if (missionModelType == 2) {
      return getI18NKey().apple_alarm;
    } else {
      return "";
    }
  }

  static List<MissionModel> convertReminderListToMissionList(
      List<ReminderModel> reminders) {
    List<MissionModel> missionList = [];

    for (ReminderModel reminder in reminders) {
      missionList.add(convertReminderToMission(reminder));
    }
    return missionList;
  }

  static MissionModel convertReminderToMission(ReminderModel reminder) {
    MissionModel missionModel = MissionModel();
    missionModel.objectId = reminder.id;
    missionModel.title =
        reminder.title ?? '' + "(${getI18NKey().from_reminder})";

    if (missionModel.title?.indexOf("工作日重复-21:00提醒-55555555555555a") != -1) {
      print("5555555555555555");
    }
    if (missionModel.title?.indexOf("Q111222333") != -1) {
      print("5555555555555555");
    }

    missionModel.missionModelType = 2; // 苹果reminder
    missionModel.folder_id = null; // 如果有对应文件夹 ID，可以设置
    missionModel.folder_title = reminder.calendar;
    missionModel.group_id = null; // 分组 ID，根据需求设置
    missionModel.time_mode = 0;
    missionModel.repetive_end_time =
        reminder.recurrence?.endDate?.millisecondsSinceEpoch;
    missionModel.start_time =
        reminder.startDate?.millisecondsSinceEpoch; // 开始时间
    missionModel.end_time = reminder.dueDate?.millisecondsSinceEpoch; // 截止时间
    missionModel.daily_start_time =
        getMillisecondFromTime(reminder.endDate?.millisecondsSinceEpoch ?? 0) -
            60 * 60 * 1000; // 每日结束时间
    missionModel.daily_end_time = getMillisecondFromTime(
        reminder.endDate?.millisecondsSinceEpoch ?? 0); // 每日结束时间
    // reminder.dueDate?.millisecondsSinceEpoch
    missionModel.isFinished = reminder.isCompleted ?? false; // 是否完成
    List<AlarmModel> alarms = reminder.alarms ?? [];

    // missionModel.finish_time =
    //     reminder.endDate?.millisecondsSinceEpoch; // 完成时间
    missionModel.priorityStatus = reminder.priority != null
        ? mapPriorityToPriorityStatus(reminder.priority!)
        : 3; // 优先级映射
    missionModel.message = reminder.notes; // 备注内容
    missionModel.color = 0xffff8800; // 默认颜色
    missionModel.subMissions = []; // 默认子任务为空
    missionModel.do_it_now = []; // 当前未开始

    // 转换 RepetitiveWeekDay
    missionModel.repetiveWeekDay =
        WeekDayConverter.convertFromSundayToSaturdayToMondayToSunday(
            reminder.repetiveWeekDay);

    // 其余未处理字段留空或按逻辑处理
    missionModel.repetiveType = reminder.repetiveType ?? 0;
    missionModel.repetiveValue = reminder.repetiveValue ?? 0;
    missionModel.repetiveWeekDay = reminder.repetiveWeekDay ?? [];
    if (missionModel.repetiveType == 2 ||
        missionModel.repetiveType == 3 ||
        missionModel.repetiveType == 1) {
      // 按周重复 需要把yyyy mm dd切割出来
      if (alarms[0].type == "absolute") {
        missionModel.alert_time = alarms.length > 0
            ? getMillisecondFromTime(
                alarms[0].date?.millisecondsSinceEpoch ?? 0)
            : null; // 提醒时间
      } else {
        // relative 如 62400000
        missionModel.alert_time = alarms.length > 0
            ? (alarms[0].date?.millisecondsSinceEpoch ?? alarms[0].offset)
            : (null); // 提醒时间
      }
    } else {
      missionModel.alert_time = alarms.length > 0
          ? (alarms[0].date?.millisecondsSinceEpoch ?? 0)
          : null; // 提醒时间
    }
    // missionModel.repeativeDate = reminder.repeativeDate ?? [];

    return missionModel;
  }

// 优先级映射方法
//   static int _mapPriorityToPriorityStatus(int priority) {
//     if (priority >= 1 && priority <= 4) {
//       return 0; // 高优先级
//     } else if (priority == 5) {
//       return 1; // 中优先级
//     } else if (priority >= 6 && priority <= 9) {
//       return 2; // 低优先级
//     } else {
//       return 3; // 无优先级
//     }
//   }

// 优先级映射方法
  static int mapPriorityToPriorityStatus(int priority) {
    if (priority >= 1 && priority <= 4) {
      return 0; // 高优先级
    } else if (priority == 5) {
      return 1; // 中优先级
    } else if (priority >= 6 && priority <= 9) {
      return 2; // 低优先级
    } else {
      return 3; // 无优先级
    }
  }

  static MissionModel convertEventModelToMissionModel(EventModel event) {
    MissionModel mission = MissionModel();
    mission.objectId = event?.id;
    // mission.title = event.title ?? "";
    mission.title =
        "${event.title}(${getI18NKey().from_calendar})"; // 为了防止title为空
    // if (mission.title == '低等生物') {
    //   print("低等生物");
    // }
    mission.missionModelType = 1; // 苹果
    mission.time_mode = 1;
    mission.start_time = event.startDate?.millisecondsSinceEpoch;
    mission.end_time = event.endDate?.millisecondsSinceEpoch;
    mission.isDelayed = event.endDate?.isBefore(DateTime.now()) ?? false;
    mission.noteRichContentUrl = event.note ?? "";
    // mission.alert_time = event.travelTime != null
    //     ? DateTime.parse(event.travelTime!).millisecondsSinceEpoch
    //     : null;
    // mission.tagNames = event.calendar;
    // mission.tagIds = event.startLocation;
    mission.repetiveType = event.recurrence?.frequency != null
        ? ((event.recurrence?.frequency ?? -1) + 1)
        : 0; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复 如果0 关闭 end_time不会作用 重复拥有更高优先级
    mission.repetiveValue = event.recurrence?.interval;
    mission.repetiveWeekDay = event.recurrence?.daysOfTheWeek?.map((day) {
      return day != 0; // 将 `daysOfTheWeek` 转换为布尔值表示的数组
    }).toList();
    mission.subMissions = [];
    // mission.location = event.structuredLocation?.geoLocation?.toJson();
    // mission.background_url = event.structuredLocation?.title;

    return mission;
  }

  static DateTime? getStartDateTimeFromCalendar(
      {DateTime? startDateTime,
      DateTime? endDateTime,
      required DateTime displayDateTime,
      required CalendarView calendarView}) {
    if (startDateTime == null && endDateTime == null) {
      switch (calendarView) {
        case CalendarView.day:
          DateTime dateTime = displayDateTime;
          return DateTime(
              dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);
        // return Utility.getFilterDateTimeFromTimeStamp(
        //     startDateTime!.millisecondsSinceEpoch);
        case CalendarView.week:
          //根据displayDateTime得到displayDateTime同一周 周日 00:00 的dateTime 1是monday 7是sunday
          int weekDay = displayDateTime.weekday;
          DateTime dateTime = displayDateTime
              .subtract(Duration(days: weekDay == 7 ? 0 : weekDay)); // weekDay
          return DateTime(
              dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);
        // DateTime dateTime = displayDateTime.subtract(Duration(days: weekDay - 1));
        // return dateTime;
        case CalendarView.month:
          DateTime dateTime = displayDateTime;
          return DateTime(dateTime.year, dateTime.month, 1, 0, 0, 0, 0, 0);

        // return Utility.getFilterDateTimeFromTimeStamp(
        //     startDateTime!.millisecondsSinceEpoch);
        case CalendarView.timelineDay:
          return Utility.getFilterDateTimeFromTimeStamp(
              startDateTime!.millisecondsSinceEpoch);
        case CalendarView.timelineMonth:
          return startDateTime;
        default:
          return startDateTime;
      }
    } else {
      return startDateTime;
    }
  }

  static DateTime? getEndDateTimeFromCalendar(
      {DateTime? startDateTime,
      DateTime? endDateTime,
      required DateTime displayDateTime,
      required CalendarView calendarView}) {
    if (startDateTime == null && endDateTime == null) {
      switch (calendarView) {
        case CalendarView.day:
          DateTime dateTime = displayDateTime;
          return DateTime(
              dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 59, 59);
        // return Utility.getFilterDateTimeFromTimeStamp(
        //     startDateTime!.millisecondsSinceEpoch);
        case CalendarView.week:
          //根据displayDateTime得到displayDateTime同一周 周六 00:00 的dateTime 1是monday 7是sunday
          int weekDay = displayDateTime.weekday;
          // 星期天单独算
          DateTime dateTime = displayDateTime
              .add(Duration(days: weekDay == 7 ? 6 : 6 - weekDay));
          return DateTime(
              dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 59, 59);
        case CalendarView.month:
          DateTime dateTime = displayDateTime;
          int daysInMonth = DateTime(dateTime.year, dateTime.month + 1, 0).day;
          return DateTime(
              dateTime.year, dateTime.month, daysInMonth, 23, 59, 59, 59, 59);
        case CalendarView.timelineDay:
          return Utility.getFilterDateTimeFromTimeStamp(
              startDateTime!.millisecondsSinceEpoch);
        case CalendarView.timelineMonth:
          return endDateTime;
        default:
          return endDateTime;
      }
    } else {
      return endDateTime;
    }
  }

  /**
   * 给url拼接token
   */
  static String getTokenUrl({required String url}) {
    if (LoginManager.getInstance().userBean == null) {
      return url;
    }
    // encodeURIComponent token
    return url +
        (url.indexOf("?") != -1 ? "&" : "?") +
        "token=" +
        Uri.encodeComponent(LoginManager.getInstance().userBean?.token ?? "") +
        "&uid=" +
        LoginManager.getInstance().getUid();
  }

  static Widget getSVGPictureWithSize(String icon,
      {double? width, double? height, Color? color}) {
    if (icon.indexOf("svg") != -1) {
      return SvgPicture.asset(icon, width: width, height: height, color: color);
    } else {
      return Image.asset(icon, width: width, height: height, fit: BoxFit.cover);
    }
  }

  static List<String> getFolderModelObjectIdOrderList(
      List<FolderModelWithExtraData> list) {
    List<String> listFolderModelObjectIdOrderList = [];
    list.forEach((element) {
      if (!TextUtil.isEmpty(element.folderModel.objectId)) {
        listFolderModelObjectIdOrderList.add(element.folderModel.objectId!);
      }
    });
    return listFolderModelObjectIdOrderList;
  }

  static FolderModelWithExtraData? getFolderModelWithExtraDataByObjectId(
      List<FolderModelWithExtraData> list, String objectId) {
    FolderModelWithExtraData? folderModelWithExtraData;
    list.forEach((element) {
      if (element.folderModel.objectId == objectId) {
        folderModelWithExtraData = element;
      }
    });
    return folderModelWithExtraData;
  }

  /**
   * 实现List<String> 里面数据去重
   */
  static List<String> removeDuplicate(List<String> list) {
    List<String> listNew = [];
    list.forEach((element) {
      if (!listNew.contains(element)) {
        listNew.add(element);
      }
    });
    return listNew;
  }

  static Future requestNotification(BuildContext context) async {
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

  static bool shouldShowAlert({missionModelType = 0}) {
    return missionModelType == null ||
        missionModelType == 0 ||
        missionModelType == 2;
  }

  static bool shouldShowCircleFolderId({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowPriority({missionModelType = 0}) {
    return missionModelType == null ||
        missionModelType == 0 ||
        missionModelType == 2;
  }

  static bool shouldShowTag({missionModelType = 0}) {
    return missionModelType == null ||
        missionModelType == 0 ||
        missionModelType == 2;
  }

  static bool shouldShowDailyIcon({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  //创建编辑的时候 null 或者 0是默认的 1是苹果日历 2是苹果提醒 3.google日历
  static bool shouldShowBeginTime({missionModelType = 0}) {
    return missionModelType == null ||
        missionModelType == 0 ||
        missionModelType == 1 ||
        missionModelType == 2;
  }

  static bool shouldTotalVal({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldUnit({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowStartTime({missionModelType = 0}) {
    return missionModelType == null ||
        missionModelType == 0 ||
        missionModelType == 1 ||
        missionModelType == 2;
  }

  //创建编辑的时候
  static bool shouldShowEndTime({missionModelType = 0}) {
    return missionModelType == null ||
        missionModelType == 0 ||
        missionModelType == 1 ||
        missionModelType == 2;
  }

  static bool shouldShowTomatoes({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowDoItNow({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowMissionValue({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowWallpaper({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowAllMissionDetailTab({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  static bool shouldShowTabBar({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  //创建编辑的时候 是否显示价值
  static bool shouldShowValue({missionModelType = 0}) {
    return missionModelType == null || missionModelType == 0;
  }

  /**
   * 把 FolderModelWithExtraData.folderModelObjectIdOrderList 放到 folderModelObjectIdOrderList 里面
   */
  static List<FolderModelWithExtraData> filterFolderModelWithExtraData(
      List<FolderModelWithExtraData> listParams,
      {bool isAddingFolderModel = false,
      List<String> listOrderFolderModelObjectId = const [],
      List<String> listOrderFolderModelObjectIdForOtherFolder = const []}) {
    List<FolderModelWithExtraData> listAllFolderModels = [];
    List<FolderModelWithExtraData> listFolderModelsForFolders = [];
    List<FolderModelWithExtraData> list = [...listParams]; // 重启数组方便删除
    //重启一个数组是因为不能边遍历边删除
    // 得到folders 文件夹
    listParams.forEach((element) {
      if (element.folderModel.tag == 3) {
        listFolderModelsForFolders.add(element);
        list.remove(element);
      }
    });

    //把每个文件夹过滤并填充数据到文件夹
    listFolderModelsForFolders.forEach((element) {
      // 把 FolderModelWithExtraData.folderModelObjectIdOrderList 放到 folderModelObjectIdOrderList 里面
      FolderModelWithExtraData folderModelWithExtraData =
          filterListFolderModelWithExtraDataForFolderModelObjectIdOrderList(
              list, element);
      // folderModelWithExtraData.listFolderModelWithExtraData = list;
      listAllFolderModels.add(folderModelWithExtraData);
    });

    //list现在是剩下的数据
    // 把其他文件夹放到最后 根据listOrderFolderModelObjectIdForOtherFolder 排序
    List<FolderModelWithExtraData> listOthersFolderModelWithExtraData = [];
    List<FolderModelWithExtraData> listOthersFolderModelWithExtraDataRest = [];
    listOrderFolderModelObjectIdForOtherFolder.forEach((itemObjectId) {
      FolderModelWithExtraData? folderModelWithExtraData =
          getFolderModelWithExtraDataByObjectId(list, itemObjectId);
      if (folderModelWithExtraData != null) {
        listOthersFolderModelWithExtraData.add(folderModelWithExtraData);
        list.remove(folderModelWithExtraData);
      }
      // else {
      //   listOthersFolderModelWithExtraDataRest.add(folderModelWithExtraData);
      // }
      // list.forEach((element2) {
      //   if (element2.folderModel.objectId == itemObjectId) {
      //     listOthersFolderModelWithExtraData.add(element2);
      //   } else {
      //     listOthersFolderModelWithExtraDataRest.add(element2);
      //   }
      // });
    });
    //把剩下加进去
    listOthersFolderModelWithExtraData.addAll(list);

    FolderModelWithExtraData folderModelWithExtraData =
        FolderModelWithExtraData();
    folderModelWithExtraData.isOthers = true;
    FolderModel folderModel = FolderModel();
    folderModel.objectId = CONSTANTS.OTHER_OBJECT_ID; // 用于放到缓存排序
    folderModel.title = getI18NKey().others;
    folderModelWithExtraData.folderModel = folderModel;
    folderModelWithExtraData.listFolderModelWithExtraData =
        listOthersFolderModelWithExtraData;
    listAllFolderModels.add(folderModelWithExtraData);

    List<FolderModelWithExtraData> listFolderModelWithExtraData = [];
    // List<FolderModelWithExtraData> listFolderModelWithExtraDataRest = [];
    // listOrderFolderModelObjectId是排序好的 List<FolderModelWithExtraData> 里 FolderModelWithExtraData.fodlerModel的Id
    // 如果listOrderFolderModelObjectId有值 那就将 List<FolderModelWithExtraData> 有排序好的就放到最前面
    if (listOrderFolderModelObjectId.length > 0) {
      //文件夹根据listOrderFolderModelObjectId排序
      listOrderFolderModelObjectId.forEach((objectId) {
        FolderModelWithExtraData? folderModelWithExtraData =
            getFolderModelWithExtraDataByObjectId(
                listAllFolderModels, objectId);
        if (folderModelWithExtraData != null) {
          listFolderModelWithExtraData.add(folderModelWithExtraData);
          listAllFolderModels.remove(folderModelWithExtraData);
        }

        // else {
        //   listFolderModelWithExtraDataRest.add(folderModelWithExtraData);
        // }
      });
      listFolderModelWithExtraData.addAll(listAllFolderModels);
    } else {
      listFolderModelWithExtraData = listAllFolderModels;
    }

    if (isAddingFolderModel) {
      FolderModel folderModel = FolderModel();
      folderModel.tag =
          3; ////1-表示各种图案circle mission;2-表示的是 tag; 3-代表文件夹;null-今天 明天 即将到来
      folderModel.color = CONSTANTS.getColors()[0].color;
      FolderModelWithExtraData folderModelWithExtraData =
          FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: FolderTimeModel());
      folderModelWithExtraData.isEditingTitle = true;
      listFolderModelWithExtraData.length == 0
          ? listFolderModelWithExtraData.add(folderModelWithExtraData)
          : listFolderModelWithExtraData.insert(0, folderModelWithExtraData);
    }
    return listFolderModelWithExtraData;
  }

  /**
   * 如果是删除文件夹 那就删除文件夹和文件夹下的清单
   */
  static deleteFolderModelsList({required FolderModel folderModel}) async {
    List<FolderModel> listFolderModels = [];
    //得到文件夹
    if (folderModel.folderModelObjectIdOrderList != null &&
        (folderModel.folderModelObjectIdOrderList?.length ?? 0) > 0) {
      //得到清单
      listFolderModels = MongoApisManager.getInstance()
          .queryFolderModelListByObjectIdList(
              folderModel.folderModelObjectIdOrderList ?? []);
    }
    //价到文件夹
    listFolderModels.add(folderModel);
    List<Future<dynamic>> listFunction = [];
    //添加批量删除函数
    listFunction.add(MongoApisManager.getInstance()
        .batchDelete_FolderModel(listParam: listFolderModels));
    //批量删除分组
    listFolderModels.forEach((folderModel) {
      MongoApisManager.getInstance()
          .batchdelete_MissionModel(folder_id: folderModel.objectId);
      listFunction.add(MongoApisManager.getInstance()
          .batchdelete_GroupModelByFolderId(
              currentObjectId: folderModel.objectId));
      //批量删除相关课程
      listFunction.add(MongoApisManager.getInstance()
          .delete_CourseModel(folderModel.objectId));
    });
    await Future.wait(listFunction);
  }

  /**
   * 设置文件夹列表的归档状态
   */
  static Future<List?> setFolderModelsListArchiveStatus(
      {required FolderModel folderModel}) async {
    List<FolderModel> listFolderModels = [];
    if (folderModel.folderModelObjectIdOrderList != null) {
      List<FolderModel> list = MongoApisManager.getInstance()
          .queryFolderModelListByObjectIdList(
              folderModel.folderModelObjectIdOrderList ?? []);
      if (folderModel?.folderStatus == 0) {
        folderModel?.folderStatus = 1; //归档
      } else {
        folderModel?.folderStatus = 0; //取消归档
      }
      listFolderModels.add(folderModel);
      list.forEach((folderModelTmp) {
        folderModelTmp.folderStatus = folderModel?.folderStatus;
        listFolderModels.add(folderModelTmp);
      });
    }
    if (listFolderModels.length > 0) {
      List res = await MongoApisManager.getInstance()
          .batchUpdate_folderModelWithParams(listFolderModel: listFolderModels);
      return res;
    }
    return null;
  }

  /**
   * 过滤文件夹列表 folderModel.type = 3 组装进去FolderModelWithExtraData
   */
  static FolderModelWithExtraData
      filterListFolderModelWithExtraDataForFolderModelObjectIdOrderList(
          List<FolderModelWithExtraData> listParams,
          FolderModelWithExtraData folderModelWithExtraData) {
    List<FolderModelWithExtraData> list = [...listParams];
    List<FolderModelWithExtraData> listAllFolderModels = [];
    List<String>? folderModelObjectIdOrderList = folderModelWithExtraData
        .folderModel
        .folderModelObjectIdOrderList; //当folderModel代表文件夹时 用于folderModel objectId的排序
    //folderModelObjectIdOrderList 拿到数据
    folderModelObjectIdOrderList?.forEach((element) {
      list.forEach((folderObjectId) {
        if (folderObjectId.folderModel.objectId == element) {
          listAllFolderModels.add(folderObjectId);
          //从list中移除 方便加入到listAllFolderModels中
          // listParams.remove(element);
          removeFolderModelWithExtraDataByFolderModelObjectId(
              listParams, element);
        }
      });
    });

    // listParams = list;
    folderModelWithExtraData.listFolderModelWithExtraData = listAllFolderModels;
    return folderModelWithExtraData;
  }

  static removeFolderModelWithExtraDataByFolderModelObjectId(
      List<FolderModelWithExtraData> list, String folderModelObjectId) {
    list.removeWhere(
        (element) => element.folderModel?.objectId == folderModelObjectId);
  }

  /**
   * 根据folderModelObjectId获取FolderModelWithExtraData
   */
  static FolderModelWithExtraData?
      getFolderModelWithExtraDataByFolderModelObjectId(
          List<FolderModelWithExtraData> list, String folderModelObjectId) {
    FolderModelWithExtraData? folderModelWithExtraData = null;
    list.forEach((element) {
      if (element.folderModel.objectId == folderModelObjectId) {
        folderModelWithExtraData = element;
      }
    });
    return folderModelWithExtraData;
  }

  static String getMissionValuePerHourByMissionModel(
      {required MissionModel missionModel}) {
    return getMissionValuePerHour(
        totalTomatoes: missionModel.total_tomotoes ?? 0,
        tomatoDuration: missionModel.tomato_duration,
        missionValue: missionModel.mission_value ?? 0);
    // int? totalTomatoes = missionModel.total_tomotoes ?? 0;
    // int totalDuration = missionModel.tomato_duration ?? SharePreferenceUtil.getSyncInstance().getTomatoTime();
    // int totalMinutes = totalTomatoes * totalDuration ~/ (1000 * 60);
    // num mission_value_per_hour = missionModel.mission_value ??0 / totalMinutes;
    // return mission_value_per_hour.toStringAsFixed(2);
  }

  /**
   * 任务每小时价值
   * 总价值/总投入小时数
   */
  static String getMissionValuePerHour(
      {required int totalTomatoes,
      int? tomatoDuration,
      required int missionValue}) {
    // int? totalTomatoes = totalTomatoes ?? 0;
    int totalDuration =
        tomatoDuration ?? SharePreferenceUtil.getSyncInstance().getTomatoTime();
    double totalHour = totalTomatoes * totalDuration / (3600000);
    num mission_value_per_hour = missionValue / totalHour;
    return mission_value_per_hour.toStringAsFixed(2);
  }

  /**
   * 点击正在做 设置时间
   */
  static void onClickUpdateTimeDoItNow(
      BuildContext context, List<MissionModel> listMissionModel,
      {Function? onTapFinish}) {
    GlobalKey<MissionPickPeriodDialogWidgetState>
        MissionPickPeriodDialogWidgetStateGlobalKey = GlobalKey();
    if (ChatGroupManager.isFolderModelEnabledForMissionList(
            uid: LoginManager.getInstance().userBean.uid ?? "",
            list: listMissionModel) ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return;
    }
    DialogManagement.getInstance().showCustomDialogWithSmallButtons(context,
        // okTitle: getI18NKey().i_know,
        child: Container(
            child: MissionPickPeriodDialogWidget(
                key: MissionPickPeriodDialogWidgetStateGlobalKey,
                onChange: (code, isCheck, endTime) {})),
        title: getI18NKey().do_it_now, okCallback: () {
      switch (MissionPickPeriodDialogWidgetStateGlobalKey.currentState?.code) {
        case "30mins":
          Utility.updateBufferTimeOfMissionModelList(
              missionModelList: listMissionModel,
              endTimeDelay: 30 * 60 * 1000,
              bufferTimeDelay: 1 * 24 * 60 * 60 * 1000);
          break;
        case "1hour":
          Utility.updateBufferTimeOfMissionModelList(
              missionModelList: listMissionModel,
              endTimeDelay: 1 * 60 * 60 * 1000,
              bufferTimeDelay: 1 * 24 * 60 * 60 * 1000);
          break;
        case "3hours":
          Utility.updateBufferTimeOfMissionModelList(
              missionModelList: listMissionModel,
              endTimeDelay: 3 * 60 * 60 * 1000,
              bufferTimeDelay: 1 * 24 * 60 * 60 * 1000);
          break;
        case "6hours":
          Utility.updateBufferTimeOfMissionModelList(
              missionModelList: listMissionModel,
              endTimeDelay: 6 * 60 * 60 * 1000,
              bufferTimeDelay: 1 * 24 * 60 * 60 * 1000);
          break;
        case "12hours":
          Utility.updateBufferTimeOfMissionModelList(
              missionModelList: listMissionModel,
              endTimeDelay: 12 * 60 * 60 * 1000,
              bufferTimeDelay: 1 * 24 * 60 * 60 * 1000);
          break;
        case "customize":
          break;
      }
      MongoApisManager.getInstance().batchUpdate_MissionModelWithParams(
          listMissionModel: listMissionModel);
      onTapFinish?.call();
      // updateUI();
      DialogManagement.getInstance().hideDialog(context);
    }, cancelCallback: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  //现在开始做的时间 map {"end_time": 毫秒时间戳, "buffer_end_time": 缓冲时间戳, money: 0, "real_end_time": 0}
  static bool isDoingItNow(MissionModel missionModel) {
    int now = Utility.getTimeStampToday();
    List doItNowList = missionModel.do_it_now ?? [];
    if (doItNowList.length > 0) {
      Map map = doItNowList[0];
      if (map['buffer_end_time'] != null) {
        if (map['buffer_end_time'] > now) {
          return true;
        }
      }
    }
    return false;
  }

  static int getAllWQBSizeByState(List<WQBMissionModel> list,
      {int state = -1}) {
    if (state == -1) {
      return list.length;
    } else {
      int size = 0;
      list.forEach((element) {
        if (element.state == state) {
          size++;
        }
      });
      return size;
    }
  }

  /**
   * 获取月份，todo 这里要翻译
   */
  static String getMonthName(int month) {
    switch (month.toInt()) {
      case DateTime.january:
        return getI18NKey().jan;
      case DateTime.february:
        return getI18NKey().feb;
      case DateTime.march:
        return getI18NKey().mar;
      case DateTime.april:
        return getI18NKey().apr;
      case DateTime.may:
        return getI18NKey().may;
      case DateTime.july:
        return getI18NKey().jul;
      case DateTime.september:
        return getI18NKey().sep;
      case DateTime.october:
        return getI18NKey().oct;
      case DateTime.november:
        return getI18NKey().nov;
      case DateTime.december:
        return getI18NKey().dec;
      default:
        return '';
    }
  }

  /**
   * 获取月份，todo 这里要翻译
   */
  static String getMonthNameFull(int? month) {
    if (month == null) {
      return "";
    }
    switch (month.toInt()) {
      case DateTime.january:
        return getI18NKey().janFull;
      case DateTime.february:
        return getI18NKey().febFull;
      case DateTime.march:
        return getI18NKey().marFull;
      case DateTime.april:
        return getI18NKey().aprFull;
      case DateTime.may:
        return getI18NKey().mayFull;
      case DateTime.july:
        return getI18NKey().julFull;
      case DateTime.september:
        return getI18NKey().sepFull;
      case DateTime.october:
        return getI18NKey().octFull;
      case DateTime.november:
        return getI18NKey().novFull;
      case DateTime.december:
        return getI18NKey().decFull;
      default:
        return '';
    }
  }

  /**
   * 没地方用
   */
  static getWeek(int index) {
    String week = '';
    switch (index % 7) {
      case 0:
        week = 'Mon';
        break;
      case 1:
        week = 'Tue';
        break;
      case 2:
        week = 'Wed';
        break;
      case 3:
        week = 'Thu';
        break;
      case 4:
        week = 'Fri';
        break;
      case 5:
        week = 'Sat';
        break;
      case 6:
        week = 'Sun';
        break;
      default:
    }
    return week;
  }

  static Function debounceWithMissionDetailPage(
    Function func, [
    Duration delay = const Duration(milliseconds: 2000),
  ]) {
    Timer? timer;
    Function target = (state) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
        timer = null;
      }
      timer = Timer(delay, () {
        func?.call(state);
      });
    };
    return target;
  }

  /// 函数防抖
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  static Function debounceWithWQB(
    Function func, [
    Duration delay = const Duration(milliseconds: 2000),
  ]) {
    Timer? timer;
    Function target = (state, val, index) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
        timer = null;
      }
      timer = Timer(delay, () {
        func?.call(state, val, index);
      });
    };
    return target;
  }

  static Function debounceWith(
    Function func, [
    Duration delay = const Duration(milliseconds: 2000),
  ]) {
    Timer? timer;
    Function target = (state) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
        timer = null;
      }
      timer = Timer(delay, () {
        func?.call(state);
      });
    };
    return target;
  }

  /// 函数节流
  ///
  /// [func]: 要执行的方法
  static Function throttle(Function func,
      [Duration delay = const Duration(milliseconds: 300)]) {
    Timer? timer;
    Function target = (state) {
      if (timer?.isActive ?? false) {
        return;
      }
      timer = Timer(delay, () {
        func?.call(state);
      });
    };
    return target;
  }

  /**
   * 打开外部浏览器
   */
  static void openWebViewLaunch(
      {required BuildContext context, required String url, String? title}) {
    if (Utility.isMobile() == true) {
      Utility.pushNavigator(
          context,
          WebviewPage(
            title: title ?? "",
            url: url ?? "",
          ));
    } else {
      launch(url);
    }
  }

  static void openExternalWebView({required String url}) {
    // if(Utility.isMobile() == true) {
    //   Utility.pushNavigator(context,
    //       WebviewPage(title: title, url: url,));
    // } else {
    launch(url);
    // }
  }

  static bool isGooglePlay() {
    return DeviceInfoManagement.getLanguage() != "zh";
  }

  static String getPrivacyProtocolUrl() {
    if (DeviceInfoManagement.getLanguage() == "zh") {
      if (Params.channelEnum == ChannelEnum.xiaomi) {
        return Urls.privacyProtocolXiaoMi;
      } else if (Params.channelEnum == ChannelEnum.vivo) {
        return Urls.privacyProtocolVivo;
      }
      return Urls.privacyProtocol;
    } else {
      return Urls.privacyProtocolOfficial;
    }
  }

  static String getEULAUrl() {
    if (DeviceInfoManagement.getLanguage() == "zh") {
      return Urls.eula_official;
    } else {
      return Urls.eula_official;
    }
  }

  static Color getSubTextColorByPriority(PriorityEnum priorityEnum) {
    switch (priorityEnum) {
      case PriorityEnum.red1:
        return Color(0x5fdc281e);
      case PriorityEnum.yellow2:
        return Color(0x5fed8f03);
      case PriorityEnum.blue3:
        return Color(0x5f2193b0);
      default:
        return Color(0x5f799f0c);
    }
  }

  static Color getSelectedDarkerColorByPriority(PriorityEnum priorityEnum) {
    switch (priorityEnum) {
      case PriorityEnum.red1:
        return Color(0xffdc281e);
      case PriorityEnum.yellow2:
        return Color(0xffed8f03);
      case PriorityEnum.blue3:
        return Color(0xff2193b0);
      default:
        return Color(0xff799f0c);
    }
  }

  /**
   * 更新missionModelList的时间
   * 结束时间时间戳 = now() + endTimeDelay
   * 结束的缓存时间 = now() + endTimeDelay
   */
  static void updateBufferTimeOfMissionModelList(
      {required List<MissionModel> missionModelList,
      int endTimeDelay = 2 * 60 * 60 * 1000,
      int bufferTimeDelay = 24 * 60 * 60 * 1000}) {
    missionModelList.forEach((missionModel) {
      if (missionModel.do_it_now == null) {
        missionModel.do_it_now = [];
      }
      missionModel.do_it_now
          ?.removeRange(0, missionModel.do_it_now?.length ?? 0);
      int timestampNow = Utility.getTimeStampToday();
      missionModel.do_it_now?.add({
        "end_time": timestampNow + endTimeDelay,
        "buffer_end_time": timestampNow + endTimeDelay + bufferTimeDelay,
        "money": 5
      });
    });
  }

  /**
   * 重置missionModelList的时间
   */
  static void resetBufferTimeOfMissionModelList(
      {required List<MissionModel> missionModelList}) {
    missionModelList.forEach((missionModel) {
      missionModel.do_it_now
          ?.removeRange(0, missionModel.do_it_now?.length ?? 0);
    });
  }

  static Color getTextColorByPriority(PriorityEnum priorityEnum) {
    switch (priorityEnum) {
      case PriorityEnum.red1:
        return Color(0xffdc281e);
      case PriorityEnum.yellow2:
        return Color(0xffed8f03);
      case PriorityEnum.blue3:
        return Color(0xff2193b0);
      default:
        return Color(0xff799f0c);
    }
  }

  static List<Color> getBGColorByPrioritySelectedDraggable(
      PriorityEnum priorityEnum) {
    switch (priorityEnum) {
      case PriorityEnum.red1:
        return ColorsConfig.listColorsPriorityRed1BGDraggable;
      case PriorityEnum.yellow2:
        return ColorsConfig.listColorsPriorityOrange2BGDraggable;
      case PriorityEnum.blue3:
        return ColorsConfig.listColorsPriorityBlue3BGDraggable;
      default:
        return ColorsConfig.listColorsPriorityGreen4BGDraggable;
    }
  }

  static List<Color> getBGColorByPrioritySelected(PriorityEnum priorityEnum) {
    switch (priorityEnum) {
      case PriorityEnum.red1:
        return ColorsConfig.listColorsPriorityRed1BGSelected;
      case PriorityEnum.yellow2:
        return ColorsConfig.listColorsPriorityOrange2BGSelected;
      case PriorityEnum.blue3:
        return ColorsConfig.listColorsPriorityBlue3BGSelected;
      default:
        return ColorsConfig.listColorsPriorityGreen4BGSelected;
    }
  }

  static List<Color> getBGColorByPriority(PriorityEnum priorityEnum) {
    switch (priorityEnum) {
      case PriorityEnum.red1:
        return ColorsConfig.listColorsPriorityRed1BG;
      case PriorityEnum.yellow2:
        return ColorsConfig.listColorsPriorityOrange2BG;
      case PriorityEnum.blue3:
        return ColorsConfig.listColorsPriorityBlue3BG;
      default:
        return ColorsConfig.listColorsPriorityGreen4BG;
    }
  }

  static bool isXiaoMi() {
    return Params.channelEnum == ChannelEnum.xiaomi;
  }

  static bool isHuaWei() {
    return Params.channelEnum == ChannelEnum.huawei;
  }

  static void initChannel(String channel) {
    switch (channel) {
      case "HUAWEI":
        Params.channelEnum = ChannelEnum.huawei;
        break;
      case "vivo":
        Params.channelEnum = ChannelEnum.vivo;
        break;
      case "OPPO":
        Params.channelEnum = ChannelEnum.oppo;
        break;
      case "Coolpad":
        Params.channelEnum = ChannelEnum.normal;
        break;
      case "Meizu":
        Params.channelEnum = ChannelEnum.normal;
        break;
      case "Xiaomi":
        Params.channelEnum = ChannelEnum.xiaomi;
        break;
      case "samsung":
        Params.channelEnum = ChannelEnum.samsung;
        break;
      case "Sony":
        Params.channelEnum = ChannelEnum.sony;
        break;
      case "LG":
        Params.channelEnum = ChannelEnum.lg;
        break;
      default:
        if (Utility.isMacOS()) {
          Params.channelEnum = ChannelEnum.Mac;
          break;
        }
        if (Utility.isIOS()) {
          Params.channelEnum = ChannelEnum.Ios;
          break;
        }
        Params.channelEnum = ChannelEnum.normal;
        break;
    }
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static List<TimelineMissionModel> filterTimelineMissionModel(
      String wordSearching, List<TimelineMissionModel> missionModelList) {
    if (wordSearching.isEmpty == false) {
      List<TimelineMissionModel> list = [];
      missionModelList.forEach((element) {
        int index = element.timelineMessage?.indexOf(wordSearching) ?? 0;
        if (index != -1) {
          element.indexSearchingStart = element.title?.indexOf(wordSearching);
          element.indexSearchingEnd = element.title?.indexOf(wordSearching);
          list.add(element);
        }
      });
      return list;
    } else {
      return missionModelList;
    }
  }

  /**
   * 根据missionDataViewTypeEnum过滤missionModel
   */
  static List<MissionModel> filterMissionModelByMissionDataViewTypeEnum(
      MissionDataViewTypeEnum missionDataViewTypeEnum,
      List<MissionModel> missionModelList) {
    if (missionDataViewTypeEnum == MissionDataViewTypeEnum.list) {
      List<MissionModel> list = [];
      missionModelList.forEach((element) {
        if (element.missionModelType == 0 || element.missionModelType == null) {
          list.add(element);
        }
      });
      return list;
    }
    return missionModelList;
  }

  static List<MissionModel> filterMissionModel(
      String wordSearching, List<MissionModel> missionModelList) {
    if (wordSearching.isEmpty == false) {
      List<MissionModel> list = [];
      missionModelList.forEach((element) {
        int index = element.title?.indexOf(wordSearching) ?? 0;
        if (index != -1) {
          element.indexSearchingStart = element.title?.indexOf(wordSearching);
          element.indexSearchingEnd = element.title?.indexOf(wordSearching);
          list.add(element);
        }
      });
      return list;
    } else {
      return missionModelList;
    }
  }

  static List<WQBMissionModel> filterWQBMissionModel(
      String wordSearching, List<WQBMissionModel> missionModelList) {
    if (wordSearching.isEmpty == false) {
      List<WQBMissionModel> list = [];
      missionModelList.forEach((element) {
        int index = element.title?.indexOf(wordSearching) ?? 0;
        if (index != -1) {
          element.indexSearchingStart = element.title?.indexOf(wordSearching);
          element.indexSearchingEnd = element.title?.indexOf(wordSearching);
          list.add(element);
        }
      });
      return list;
    } else {
      return missionModelList;
    }
  }

  static bool isAndroid() {
    return DeviceInfoManagement.isWEB() == false && Platform.isAndroid;
  }

  /**
   * iphone ipad这里没有办法区分
   */
  static bool isIOS() {
    return DeviceInfoManagement.isWEB() == false && Platform.isIOS;
  }

  static bool isMacOS() {
    return DeviceInfoManagement.isWEB() == false && Platform.isMacOS;
  }

  static bool isWindows() {
    return DeviceInfoManagement.isWEB() == false && Platform.isWindows;
  }

  static unfocus({FocusNode? focusNode}) {
    focusNode?.unfocus();
  }

  static StreamSubscription handleKeyBoardVisibility({Function? onChange}) {
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    StreamSubscription keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (onChange != null) {
        onChange(visible);
      }
    });
    return keyboardSubscription;
  }

  static Future<File?> pickImage() async {
    if (Utility.isMobile()) {
      XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
      if (imageFile != null) {
        return imageFile;
        // setState(() {
        //   state = AppState.picked;
        // });
      }
    }
  }

  /**
   * 返回值 kb
   *
   */
  static Future<double> getFilesSizes(List<XFile> files) async {
    double fileSizeInMB = 0;
    for (XFile file in files) {
      int fileSizeInBytes = await file.length();
      fileSizeInMB = fileSizeInBytes / (1024);

      // if (fileSizeInMB > 5) {
      //
      // }
    }
    return fileSizeInMB;
  }

  static List<ImageProvider> getImageProviderFromList(List<String> list) {
    List<ImageProvider> listTmp = [];
    list.forEach((element) {
      listTmp.add(Image.network(element).image);
    });
    return listTmp;
  }

  /**
   * 压缩图片
   * compress file and get file.
   */
  static Future<XFile> compressAndGetFile(
      {required File file, String? targetPath}) async {
    final input = ImageFile(
      rawBytes: file.readAsBytesSync(),
      filePath: file.path,
    );
    final output = await compressInQueue(ImageFileConfiguration(input: input));

    print('Input size = ${file.lengthSync()}');
    print('Output size = ${output.sizeInBytes}');
    File outputFilePath = await writeToFile(
        output.rawBytes, getFileName(file.path, hasExtension: true));
    // return outputFilePath;
    return XFile(outputFilePath.path, length: await outputFilePath.length());
  }

  static String getFileName(String path, {hasExtension: true}) {
    String fileName = path.split('/').last;
    if (hasExtension) {
      return fileName;
    } else {
      return fileName.split('.').first;
    }
  }

  static Future<File> writeToFile(List<int> image, String filePath) async {
    // File file = await File("/Users/linzhibin/Documents/ic_logo_red2.png").writeAsBytes(image, flush: true);
    return saveBytesToTempDirectory(image, filePath);
    // return file;
  }

  static Future<File> saveBytesToTempDirectory(
      List<int> bytes, String fileName) async {
    Directory tempDir = Directory.systemTemp;
    File file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    print('文件已保存到: ${file.path}');
    return file;
  }

  static Future<List<XFile>?> pickMultiImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(
      //   source: ImageSource.gallery,
      //   maxWidth: 1028,
      //   maxHeight: 1028,
      //   imageQuality: 80,
      // );

      // XFile? picker = await ImagePicker()
      //     .pickImage(source: ImageSource.gallery, imageQuality: 80);
      // if (picker == null) return null;
      // return [picker];
      final List<XFile> images = await picker.pickMultiImage();
      return images;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<XFile>?> pickImageWithXFileList() async {
    try {
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(
      //   source: ImageSource.gallery,
      //   maxWidth: 1028,
      //   maxHeight: 1028,
      //   imageQuality: 80,
      // );

      XFile? picker = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picker == null) return null;
      return [picker];
      // final List<XFile> images = await picker.pickMultiImage();
      // return images;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<XFile>?> pickMultiFiles() async {
    try {
      const XTypeGroup jpgsTypeGroup = XTypeGroup(
        label: 'JPEGs',
        extensions: <String>['jpg', 'jpeg'],
      );
      const XTypeGroup pngTypeGroup = XTypeGroup(
        label: 'PNGs',
        extensions: <String>['png'],
      );
      List<XFile> files = await openFiles(acceptedTypeGroups: <XTypeGroup>[
        jpgsTypeGroup,
        pngTypeGroup,
      ]);
      try {
        files = await compressXFileList(files);
      } catch (e) {}
      return files;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<XFile>> compressXFileList(List<XFile> list) async {
    List<XFile> arr = [];
    for (int i = 0; i < list.length; i++) {
      XFile xfile = list[i];
      File file = new File(xfile.path);
      arr.add(await compressAndGetFile(file: file));
    }
    return arr;
  }

  static saveFFiles() async {
    const String fileName = 'suggested_name.txt';
    final String? path = await getSavePath(suggestedName: fileName);
    if (path == null) {
      // Operation was canceled by the user.
      return;
    }

    final Uint8List fileData = Uint8List.fromList('Hello World!'.codeUnits);
    const String mimeType = 'text/plain';
    final XFile textFile =
        XFile.fromData(fileData, mimeType: mimeType, name: fileName);
    await textFile.saveTo(path);
  }

  /**
   * https://pub-web.flutter-io.cn/packages/image_cropper
   */
  static Future<File?> cropImage(File? imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      maxWidth: 300,
      maxHeight: 300,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      sourcePath: imageFile?.path ?? "",
      // aspectRatio:CropAspectRatio(ratioX: 1, ratioY: 1),
      // aspectRatioPresets: Platform.isAndroid
      //     ? [
      //         CropAspectRatioPreset.square,
      //         // CropAspectRatioPreset.ratio3x2,
      //         // CropAspectRatioPreset.original,
      //         // CropAspectRatioPreset.ratio4x3,
      //         // CropAspectRatioPreset.ratio16x9
      //       ]
      //     : [
      //         // CropAspectRatioPreset.original,
      //         CropAspectRatioPreset.square,
      //         // CropAspectRatioPreset.ratio3x2,
      //         // CropAspectRatioPreset.ratio4x3,
      //         // CropAspectRatioPreset.ratio5x3,
      //         // CropAspectRatioPreset.ratio5x4,
      //         // CropAspectRatioPreset.ratio7x5,
      //         // CropAspectRatioPreset.ratio16x9
      //       ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
          rectWidth: 300,
          rectHeight: 300,
        ),
        WebUiSettings(
          context: Utility.getGlobalContext(),
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
      // setState(() {
      //   state = AppState.cropped;
      // });
    }
  }

  // void cropImage(BuildContext context, File originalImage) async {
  //   String result = await Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => CropImageRoute(originalImage)));
  //   if (result.isEmpty) {
  //     print('上传失败');
  //   } else {
  //     //result是图片上传后拿到的url
  //     // setState(() {
  //     //   iconUrl = result;
  //     //   print('上传成功：$iconUrl');
  //     //   _upgradeRemoteInfo();//后续数据处理，这里是更新头像信息
  //     // });
  //   }
  // }

  // static Future<XFile> selectImageFromGallery() async {
  //   final ImagePicker _picker = ImagePicker();
  //   // Pick an image
  //   final XFile image = await _picker.pickImage(source: ImageSource.gallery).then((image) => cropImage(image));
  //   return image;
  // }
  //
  // static Future<XFile> selectImageFromCamera() async {
  //   final ImagePicker _picker = ImagePicker();
  //   // Pick an image
  //   final XFile image = await _picker.pickImage(source: ImageSource.camera);
  //   return image;
  // }

  /**
   * 没地方用得上
   */
  static Future<void> openFile() async {
    String? filePath = '/storage/emulated/0/update.apk';
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      filePath = result.files.single.path;
    } else {
      // User canceled the picker
    }
    final _result = await OpenFile.open(filePath);
    print(_result.message);

    // setState(() {
    print("type=${_result.type}  message=${_result.message}");
    // });
  }

  /**
   * Map to Json
   */
  static String mapToJsonString(Map map) {
    return jsonEncode(map);
  }

  /**
   * List to Json
   */
  static String listToJsonString(List map) {
    return jsonEncode(map);
  }

  /**
   * json to Map
   */
  static Map jsonToMap(String jsonString) {
    return jsonDecode(jsonString);
  }

  /**
   * json to List
   */
  static List jsonToList(String jsonString) {
    return jsonDecode(jsonString);
  }

  /**
   * 根据status获取文案 用于NotificationManager Ios推送
   */
  static String getNextStatusText(CounterStatus counterStatus) {
    if (CounterStatus.pausingFocusing == counterStatus) {
      //专注暂停中
      return getI18NKey().rest;
    } else if (CounterStatus.waitingToStartRelaxing == counterStatus) {
      return getI18NKey().focus;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      //休息暂停中
      return getI18NKey().continueTxt;
    } else if (CounterStatus.relaxing == counterStatus) {
      //休息中
      return getI18NKey().complete;
    } else if (CounterStatus.waitingToFocus == counterStatus) {
      //等待开始专注
      // _timerUtil?.updateTotalTimeAndStartCountDown(
      //     time =  SharePreferenceUtil.getInstance().getTomatoTime());
      return getI18NKey().rest;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      //等待开始休息
      return getI18NKey().continueTxt;
    } else if (CounterStatus.focusing == counterStatus) {
      //专注中
      return getI18NKey().pause;
    }
    return '';
  }

  /**
   * 根据status获取文案
   */
  static String getStatusText(CounterStatus counterStatus) {
    if (CounterStatus.pausingFocusing == counterStatus) {
      //专注暂停中 1111111
      return getI18NKey().focus;
    } else if (CounterStatus.waitingToStartRelaxing == counterStatus) {
      return getI18NKey().rest;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      //休息暂停中
      return getI18NKey().continueTxt;
    } else if (CounterStatus.relaxing == counterStatus) {
      //休息中
      return getI18NKey().complete;
    } else if (CounterStatus.waitingToFocus == counterStatus) {
      //等待开始专注 1111111
      // _timerUtil?.updateTotalTimeAndStartCountDown(
      //     time =  SharePreferenceUtil.getInstance().getTomatoTime());
      return getI18NKey().focus;
    } else if (CounterStatus.pausingRelaixing == counterStatus) {
      //等待开始休息
      return getI18NKey().continueTxt;
    } else if (CounterStatus.focusing == counterStatus) {
      //专注中
      return getI18NKey().pause;
    }
    return '';
  }

  /**
   * game1随机产生SquareModel数组放到页面
   */
  static List<SquareModel> generateRandomSquareModelList(
      {int numberPoint = 100,
      double itemWidth = 40,
      double itemHeight = 40,
      required double containerWidth,
      required double containerHeight}) {
    List<SquareModel> list = [];
    int count = 1;
    int timesToBreak = 0;
    for (int i = 0; i < numberPoint; i++) {
      Map map = getSquareModel(
          containerWidth: containerWidth, containerHeight: containerHeight);
      SquareModel? squareModelTmp = null;
      squareModelTmp = SquareModel(
          val: count.toString(),
          posX: map['x'],
          posY: map['y'],
          width: itemWidth,
          height: itemHeight,
          containerWidth: containerWidth,
          containerHeight: containerHeight);
      if (isIntersect(list, squareModelTmp) == false) {
        count++;
        list.add(squareModelTmp);
        timesToBreak = 0;
      } else {
        if (timesToBreak > 30) {
          break;
        }
        timesToBreak++;
        i--;
      }
    }
    return list;
  }

  /**
   * 游戏中squareModel是否与list有交叉
   */
  static bool isIntersect(List<SquareModel> list, SquareModel squareModel) {
    if (list.length == 0) return false;
    for (SquareModel squareModelTmp in list) {
      // if (squareModelTmp == null) {
      // print('111111');
      // }

      if (squareModel.isIntersect(squareModelTmp)) {
        return true;
      }
    }
    return false;
  }

  /**
   * game1 生成Model类
   */
  static Map getSquareModel(
      {double containerWidth = 0, double containerHeight = 0}) {
    double randX = getRandom(from: 5, max: 90).toDouble();
    double randY = getRandom(from: 5, max: 90).toDouble();
    double x = containerWidth * randX / 100;
    double y = containerHeight * randY / 100;
    return {'randX': randX, 'randY': randY, 'x': x, 'y': y};
  }

  /**
   * gamePage 对应游戏页面跳转
   */
  static void pushToGame(
      {required BuildContext context,
      required ResourceDeliveryInfoBean bean,
      required bool isPC}) {
    switch (bean.deliveryName) {
      case 'focus_game1':
        if (isPC == false) {
          pushNavigator(
              context,
              new Games1Page(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: false,
              ));
        } else {
          DialogManagement.getInstance().showPCCustomDialog(
              context: context,
              widget: new Games1Page(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: false,
              ));
        }
        break;
      case 'focus_game2':
        if (isPC == false) {
          pushNavigator(
              context,
              new Games2Page(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: true,
              ));
        } else {
          DialogManagement.getInstance().showPCCustomDialog(
              context: context,
              widget: new Games2Page(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: true,
              ));
        }
        break;
      case 'focus_game3':
        if (isPC == false) {
          pushNavigator(
              context,
              new Games3GridViewPage(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: true,
              ));
        } else {
          DialogManagement.getInstance().showPCCustomDialog(
              context: context,
              widget: new Games3GridViewPage(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: true,
              ));
        }
        break;
      case 'focus_game4':
        if (isPC == false) {
          pushNavigator(
              context,
              new Games4GridViewPage(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: true,
              ));
        } else {
          DialogManagement.getInstance().showPCCustomDialog(
              context: context,
              widget: new Games4GridViewPage(
                resourceDeliveryInfoBean: bean,
                canFinishedManually: true,
              ));
        }
        break;

        // if (isPC == false) {
        //   pushNavigator(
        //       context,
        //       new Games4Page(
        //         resourceDeliveryInfoBean: bean,
        //         canFinishedManually: true,
        //       ));
        // } else {
        //   DialogManagement.getInstance().showGameCustomDialog(
        //       context: context,
        //       widget: new Games4Page(
        //         resourceDeliveryInfoBean: bean,
        //         canFinishedManually: false,
        //       ));
        // }
        break;
    }
  }

  /**
   * 数据分析头部TodayWidget用得上
   */
  static dynamic deepClone(obj) {
    dynamic newObj = obj is Map ? {} : [];
    if (obj is Map) {
      obj.forEach((key, value) {
        if (obj[key] is Map || obj[key] is List) {
          newObj[key] = deepClone(value);
        } else {
          newObj[key] = value;
        }
      });
    } else {
      for (int i = 0; i < obj.length; i++) {
        if (obj[i] is Map || obj[i] is List) {
          newObj.add(deepClone(obj[i]));
        } else {
          newObj.add(obj[i]);
        }
      }
    }
    return newObj;
  }

  /**
   * 是否全部是数字
   */
  static bool isAllNum(String s) {
    var numberRegExp = RegExp(r'\d+'); //定义pattern，匹配数字正则
    return numberRegExp.hasMatch(s);
  }

  /**
   * 是否全是数字或者字母
   */
  static bool isAllCharAndNum(String s) {
    var numberRegExp = RegExp(r'\w+'); //定义pattern，匹配数字正则
    return numberRegExp.hasMatch(s);
  }

  /**
   * 返回length长的字符串s
   */
  static String getCharBylength(String s, int length) {
    String res = "";
    for (int i = 0; i < length; i++) {
      res = res + s;
    }
    return res;
  }

  /**
   * 游戏深拷贝数据
   */
  static List<List<String>> deepCloneList(obj) {
    List<List<String>> newObj = [];
    for (int i = 0; i < obj.length; i++) {
      List<String> lTmp = [];
      if (obj[i] is List) {
        for (int j = 0; j < obj[i].length; j++) {
          lTmp.add(obj[i][j]);
          // newObj.add(deepCloneList(obj[i]));
        }
      }
      newObj.add(lTmp);
    }
    return newObj;
  }

  /**
   * 游戏生成随机数
   */
  static String getRandomStringForGame({String? mode, int length = 5}) {
    String listTmp = "";
    List<String> list = [];
    switch (mode) {
      case 'random_by_number':
        list.addAll(getNumberList());
        break;
      case 'random_by_alphabet':
        list.addAll(getAlphabetList());
        break;
      case 'random_by_alphabet_lowercase_capital':
        list.addAll(getAlphabetList());
        list.addAll(getAlphabetList(isLowerCase: false));
        break;
      case 'random_by_alphabetAndNumber':
        list.addAll(getNumberList());
        list.addAll(getAlphabetList());
        break;
      case 'random_by_alphabetAndNumber_lowercase_capital':
        list.addAll(getNumberList());
        list.addAll(getAlphabetList());
        list.addAll(getAlphabetList(isLowerCase: false));
        break;
    }
    list.sort((val1, val2) {
      return Utility.getRandom(from: -50, max: 50);
    });
    int listLength = list.length;
    for (int i = 0; i < length; i++) {
      listTmp = list[Utility.getRandom(from: 0, max: listLength - 1)] + listTmp;
      // listTmp.add(list[Utility.getRandom(from: 0, max: listLength - 1)]);
    }

    return listTmp;
  }

  static playAudioList(List<String> urlList,
      {int delayByMicroSecond = 1000}) async {
    AudioPlayUtil.getInstance()?.playUrlList(urlList, completeCB: () {});
    // for (int i = 0; i < urlList.length; i++) {
    //   AudioPlayUtil.getInstance().play(urlList[0], loopMode: LoopMode.one);
    //   await Future.delayed(Duration(microseconds: delayByMicroSecond));
    // }
    // Timer timer = Timer.periodic(Duration(microseconds: delayByMicroSecond), (Timer timer) {
    // });
    //
  }

  static Map getNumChars(String refAnswer, String answer) {
    int numCorrect = 0;
    int numError = 0;
    List<String> refAnswerCharList = refAnswer.split(""); //参考答案
    List<String> answerCharList = answer.split(""); //输入答案
    if (refAnswerCharList.length == answerCharList.length) {
      //用户输入字符 和 参考答案相同
      for (int i = 0; i < refAnswerCharList.length; i++) {
        String ref = refAnswerCharList[i];
        String ans = answerCharList[i];
        if (ref == ans) {
          numCorrect++;
        } else {
          numError++;
        }
      }
    }
    if (refAnswerCharList.length < answerCharList.length) {
      //用户输入比较少 比参考答案多
      for (int i = 0; i < refAnswerCharList.length; i++) {
        String ref = refAnswerCharList[i];
        String ans = answerCharList[i];
        if (ref == ans) {
          numCorrect++;
        } else {
          numError++;
        }
      }
      numError += answerCharList.length - refAnswerCharList.length; //输入多的都要删掉
    }

    if (refAnswerCharList.length > answerCharList.length) {
      //用户输入比较少 比参考答案少
      for (int i = 0; i < answerCharList.length; i++) {
        String ref = refAnswerCharList[i];
        String ans = answerCharList[i];
        if (ref == ans) {
          numCorrect++;
        } else {
          numError++;
        }
      }
      numError += refAnswerCharList.length - answerCharList.length;
    }
    return {"numCorrect": numCorrect, "numError": numError};
  }

  /**
   * game2 记忆words 用于生成 数字数组
   */
  static List<String> getNumberList() {
    List<String> list = [];
    for (int i = 0; i < 10; i++) {
      list.add(i.toString());
    }
    return list;
  }

  /**
   * game2 记忆words 用于生成 字母数组
   */
  static List<String> getAlphabetList({isLowerCase: true}) {
    if (isLowerCase == true) {
      return [
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z'
      ];
    } else {
      return [
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z'
      ];
    }
  }

  /**
   * 获取转化率 最终得到xx%
   */
  static String getFunnel(
      {double numCharsCorrect = 0, double numCharsErrors = 0}) {
    double correctPercent =
        numCharsCorrect / (numCharsCorrect + numCharsErrors);
    String correctPercentString =
        (correctPercent * 100).toStringAsFixed(1) + "%";
    return correctPercentString;
  }

  static String getTimeStringValue(int timeUsed) {
    String s = "";
    if (Utility.getHour(timeUsed) != '00') {
      s = s + Utility.getHour(timeUsed) + ":";
    }
    s = s + Utility.getMins(timeUsed) + ":";
    s = s + Utility.getSeconds(timeUsed);
    return s;
  }

  /**
   * 显示数组 用于table
   * num = 1 total = 2
   * [true, false]
   */
  static List<bool> getTableBoolList({int num = 0, int total = 0}) {
    List<bool> list = [];
    for (int i = 0; i < total; i++) {
      if (i < num) {
        list.add(true);
      } else {
        list.add(false);
      }
    }
    return list;
  }

  static String getRandomBackgroundUrl(BuildContext context) {
    List<ResourceDeliveryInfoBean> list =
        context.read<GlobalStateEnv>().gameBackgroundDeliveryInfoBeanList;
    try {
      return list[Utility.getRandom(
                  from: 0,
                  max: context
                          .read<GlobalStateEnv>()
                          .gameBackgroundDeliveryInfoBeanList
                          .length -
                      1)]
              .resourcePictureUrl ??
          "http://fsclould.timerbell.com/20220914-Snip20220914_31.jpg";
    } catch (e) {
      return "http://fsclould.timerbell.com/20220914-Snip20220914_31.jpg";
    }
  }

  static Color getRandomColor() {
    Random random = new Random();
    double ran = random.nextDouble();
    return Color((0xff000000 + 0x00cccccc * ran).toInt());
  }

  static double getSumFromPresentModels(List<PresentModel> list) {
    double sum = 0;
    list.forEach((element) {
      sum += (element.value ?? 0);
    });
    return sum;
  }

  static String getTitlesFromPresentModels(List<PresentModel> list) {
    List<String> titles = [];
    list.forEach((element) {
      titles.add(element.title);
    });
    return titles.join(",");
  }

  static List<PresentModel> getCheckedModelFromSheetModelList(
      List<SheetDataModel> list) {
    List<PresentModel> listTmp = [];
    for (int i = 0; i < list.length; i++) {
      SheetDataModel item = list[i];
      PresentModel presentModel = item.data;
      if (item.isChecked == true) {
        listTmp.add(presentModel);
      }
    }
    return listTmp;
  }

  static void showRankingDialog(
      {required BuildContext context,
      String? scene,
      required GameRankingBean gameRankingBean,
      String? gameLevel = "",
      String? gameMode = "",
      String? gameCode = ""}) {
    switch (scene) {
      case 'game2':
        if (Utility.isMobile() == true) {
          Game2RankingDialogUtil.show(Utility.getGlobalContext(),
              gameRankingBean: gameRankingBean,
              gameMode: gameMode ?? "",
              title: getI18NKey().ranking,
              gameCode: gameCode ?? "");
        } else {
          OverlayManagement.getInstance().openDialog(
              context,
              GameRanking2Dialog(
                  title: getI18NKey().ranking,
                  gameCode: gameCode ?? "",
                  gameRankingBean: gameRankingBean,
                  autoPopupOnClick: false,
                  okCallBack: () {
                    OverlayManagement.getInstance().removeNewPageOverlay();
                    ;
                  }));
        }
        break;
      case 'game3':
        if (Utility.isMobile() == true) {
          GameRankingDialogUtil.show(
            Utility.getGlobalContext(),
            gameRankingBean: gameRankingBean,
            gameCode: gameCode ?? "",
            gameLevel: gameLevel ?? "",
            title: getI18NKey().ranking,
          );
        } else {
          // OverlayManagement.getInstance().openNewPageOverlay(context, Container(width: 300, height: 300, color: Colors.red));
          OverlayManagement.getInstance().openDialog(
              context,
              GameRankingDialog(
                  title: getI18NKey().ranking,
                  gameCode: gameCode,
                  gameLevel: gameLevel,
                  gameRankingBean: gameRankingBean,
                  autoPopupOnClick: false,
                  okCallBack: () {
                    OverlayManagement.getInstance().removeNewPageOverlay();
                    ;
                  }));
        }
    }
  }

  static String getUrl({String schemaUrl = "", String name = ""}) {
    if (name.indexOf("http") != -1) {
      return name;
    } else if (schemaUrl.lastIndexOf('/') == schemaUrl.length - 1) {
      return schemaUrl + name;
    } else {
      return schemaUrl + "/" + name;
    }
  }

  // static SecVerifyUIConfig getSecVerifyUIConfig() {
  //   SecVerifyUIConfig config = SecVerifyUIConfig();
  //   config.iOSConfig?.manualDismiss = false;
  //
  //   // config.iOSConfig?.navBarHidden = true;
  //   config.iOSConfig?.prefersStatusBarHidden = false;
  //
  //   config.iOSConfig?.shouldAutorotate = true;
  //   config.iOSConfig?.supportedInterfaceOrientations =
  //       iOSInterfaceOrientationMask.all;
  //   config.iOSConfig?.preferredInterfaceOrientationForPresentation =
  //       iOSInterfaceOrientation.portrait;
  //   config.iOSConfig?.overrideUserInterfaceStyle = iOSUserInterfaceStyle.light;
  //   config.iOSConfig?.preferredStatusBarStyle =
  //       iOSStatusBarStyle.styleDarkContent;
  //   config.iOSConfig?.presentingWithAnimate = false;
  //
  //   config.iOSConfig?.backBtnImageName = "assets/icons8-go_back.png";
  //   config.iOSConfig?.loginBtnText = "🐴一键登录🍺";
  //   config.iOSConfig?.loginBtnBgColor = "#c194ff";
  //   config.iOSConfig?.loginBtnTextColor = "bcc2cf";
  //   config.iOSConfig?.loginBtnBorderWidth = 3;
  //   config.iOSConfig?.loginBtnCornerRadius = 15;
  //   config.iOSConfig?.loginBtnBorderColor = "ff5f63";
  //   config.iOSConfig?.loginBtnBgImgNames = [
  //     "assets/icons8-x-file.png",
  //     "assets/icons8-pacify.png",
  //     "assets/icons8-active_directory.png",
  //   ];
  //   // config.iOSConfig?.logoHidden = true;
  //   config.iOSConfig?.logoImageName = "assets/logo.png";
  //   config.iOSConfig?.logoCornerRadius = 20;
  //   config.iOSConfig?.numberColor = "6b3040";
  //   config.iOSConfig?.numberBgColor = "4fbf4a";
  //   config.iOSConfig?.numberTextAlignment = iOSTextAlignment.right;
  //   config.iOSConfig?.phoneCorner = 10;
  //   config.iOSConfig?.phoneBorderWidth = 2;
  //   config.iOSConfig?.phoneBorderColor = "cdffc9";
  //   config.iOSConfig?.checkHidden = false;
  //   config.iOSConfig?.checkDefaultState = true;
  //   config.iOSConfig?.checkedImgName = "assets/icons8-spell_check.png";
  //   config.iOSConfig?.uncheckedImgName = "assets/icons8-round.png";
  //   config.iOSConfig?.privacyLineSpacing = 5;
  //   config.iOSConfig?.privacyTextAlignment = iOSTextAlignment.left;
  //   config.iOSConfig?.sloganHidden = false;
  //   config.iOSConfig?.sloganBgColor = "ffb787";
  //   config.iOSConfig?.sloganTextColor = "ff87b0";
  //   config.iOSConfig?.sloganTextAlignment = iOSTextAlignment.right;
  //   config.iOSConfig?.sloganCorner = 5;
  //   // config.iOSConfig?.sloganBorderWidth = 0;
  //   // config.iOSConfig?.sloganBorderColor;
  //
  //   //隐私文本自定义
  //   SecVerifyUIConfigIOSPrivacyText privacyText0 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //   SecVerifyUIConfigIOSPrivacyText privacyText1 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //   SecVerifyUIConfigIOSPrivacyText privacyText2 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //   SecVerifyUIConfigIOSPrivacyText privacyText3 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //   SecVerifyUIConfigIOSPrivacyText privacyText4 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //   SecVerifyUIConfigIOSPrivacyText privacyText5 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //   SecVerifyUIConfigIOSPrivacyText privacyText6 =
  //   SecVerifyUIConfigIOSPrivacyText();
  //
  //   privacyText0.text = "登录即代表同意";
  //   privacyText0.textColor = "d5ffd1";
  //   privacyText0.textFont = 12;
  //   //运营商协议占位
  //   privacyText1.isOperatorPlaceHolder = true;
  //   privacyText1.textColor = "f1ff73";
  //   privacyText1.textFont = 12;
  //   privacyText2.text = "和";
  //   privacyText2.textColor = "d5ffd1";
  //   privacyText2.textFont = 12;
  //   privacyText3.text = "Mob服务协议";
  //   privacyText3.textLinkString = "http://www.mob.com/policy/zh";
  //   privacyText3.textColor = "ffa373";
  //   privacyText3.textFont = 12;
  //   privacyText4.text = "、";
  //   privacyText4.textColor = "ff73ab";
  //   privacyText4.textFont = 12;
  //   privacyText5.text = "百度服务协议";
  //   privacyText5.textLinkString = "http://www.baidu.com";
  //   privacyText5.textColor = "a259ff";
  //   privacyText5.textFont = 12;
  //   privacyText6.text = "并授权" + "appName" + "获取本机号码";
  //   privacyText6.textColor = "3f2e6b";
  //   privacyText6.textFont = 12;
  //   config.iOSConfig?.privacySettings = [
  //     privacyText0,
  //     privacyText1,
  //     privacyText2,
  //     privacyText3,
  //     privacyText4,
  //     privacyText5,
  //     privacyText6
  //   ];
  //   config.iOSConfig?.privacyTextAlignment = iOSTextAlignment.center;
  //   config.iOSConfig?.privacyLineSpacing = 5;
  //   // config.androidPortraitConfig.navCloseImgHidden = true;
  //   //授权页自带控件布局
  //   final size = MediaQuery.of(Utility.getGlobalContext()).size;
  //   final screenWidth = size.width;
  //   final screenheight = size.height;
  //
  //   //logo布局
  //   SecVerifyUIConfigIOSLayout logoImageViewLayout =
  //   SecVerifyUIConfigIOSLayout();
  //   logoImageViewLayout.layoutTop = 120;
  //   logoImageViewLayout.layoutCenterX = -20;
  //   logoImageViewLayout.layoutWidth = 140;
  //   logoImageViewLayout.layoutHeight = 120;
  //
  //   //手机号label布局
  //   SecVerifyUIConfigIOSLayout phoneLabelLayout = SecVerifyUIConfigIOSLayout();
  //   phoneLabelLayout.layoutCenterX = 0;
  //   phoneLabelLayout.layoutCenterY = -80;
  //   phoneLabelLayout.layoutWidth = screenWidth - 120;
  //   phoneLabelLayout.layoutHeight = 30;
  //
  //   //一键登录按钮布局
  //   SecVerifyUIConfigIOSLayout loginBtnLayout = SecVerifyUIConfigIOSLayout();
  //   loginBtnLayout.layoutCenterX = 0;
  //   loginBtnLayout.layoutCenterY = 0;
  //   loginBtnLayout.layoutWidth = screenWidth - 80;
  //   loginBtnLayout.layoutHeight = 50;
  //
  //   //slogan布局
  //   SecVerifyUIConfigIOSLayout sloganLabelLayout = SecVerifyUIConfigIOSLayout();
  //   sloganLabelLayout.layoutCenterX = 0;
  //   sloganLabelLayout.layoutBottom = -30;
  //   sloganLabelLayout.layoutTrailing = 0;
  //   sloganLabelLayout.layoutLeading = 0;
  //
  //   //隐私协议布局
  //   SecVerifyUIConfigIOSLayout privacyTextViewLayout =
  //   SecVerifyUIConfigIOSLayout();
  //   privacyTextViewLayout.layoutLeading = 100;
  //   privacyTextViewLayout.layoutTrailing = -80;
  //   // phoneLabelLayout.layoutBottom = 50;
  //   // privacyTextViewLayout.layoutCenterX = 0;
  //   privacyTextViewLayout.layoutCenterY = 90;
  //   // privacyTextViewLayout.layoutWidth = screenWidth - 100;
  //   privacyTextViewLayout.layoutHeight = 80;
  //
  //   //checkBox布局
  //   SecVerifyUIConfigIOSPrivacyCheckBoxLayout checkBoxLayout =
  //   SecVerifyUIConfigIOSPrivacyCheckBoxLayout();
  //   checkBoxLayout.layoutTop = 0;
  //   checkBoxLayout.layoutRightSpaceToPrivacyLeft = -8;
  //   // checkBoxLayout.layoutLeftSpaceToPrivacyRight = 8;
  //   // checkBoxLayout.layoutCenterY = 50;
  //   checkBoxLayout.layoutWidth = 40;
  //   checkBoxLayout.layoutHeight = 40;
  //   // checkBoxLayout.layoutToSuperView = true;
  //
  //   // 自定义控件Label
  //   var iosTitleDesc = SecVerifyUIConfigIOSCustomLabel(102);
  //   iosTitleDesc.text = '应国家网络实名制的要求，请绑定您的手机号，保障您的帐号安全，绑定后可通过微信一键登录。';
  //   iosTitleDesc.fontSize = 14;
  //   iosTitleDesc.textColor = '#C4C4C4';
  //   iosTitleDesc.textAlignment = iOSTextAlignment.left;
  //   var iosTitleDescLayout = SecVerifyUIConfigIOSLayout();
  //   iosTitleDescLayout.layoutBottom = -80;
  //   iosTitleDescLayout.layoutCenterX = 0;
  //   iosTitleDescLayout.layoutWidth = screenWidth - 60;
  //   iosTitleDescLayout.layoutHeight = 50;
  //   iosTitleDesc.portraitLayout = iosTitleDescLayout;
  //
  //   // 自定义控件Button
  //   var iosCustomButton = SecVerifyUIConfigIOSCustomButton(103);
  //   iosCustomButton.backgroundColor = '#14F46E';
  //   iosCustomButton.title = '微信一键登录';
  //   iosCustomButton.titleFontSize = 14;
  //   iosCustomButton.titleColor = '#C4F4C4';
  //   iosCustomButton.isBodyFont = true;
  //   iosCustomButton.cornerRadius = 10;
  //   iosCustomButton.normalImage = "assets/checked.png";
  //   iosCustomButton.normalBackgroundImage = "assets/bg_my.png";
  //   var iosCustomButtonLayout = SecVerifyUIConfigIOSLayout();
  //   iosCustomButtonLayout.layoutBottom = -150;
  //   iosCustomButtonLayout.layoutCenterX = 0;
  //   iosCustomButtonLayout.layoutWidth = screenWidth - 60;
  //   iosCustomButtonLayout.layoutHeight = 50;
  //   iosCustomButton.portraitLayout = iosCustomButtonLayout;
  //
  //   // 自定义控件导航栏Button
  //   //navButton的大小根据title image backgroundImage的内容自适应
  //   var iosCustomNavButton = SecVerifyUIConfigIOSCustomNavButton(104);
  //   iosCustomNavButton.navPosition = iOSCustomWidgetNavPosition.navRight;
  //   iosCustomNavButton.backgroundColor = '#44F56F';
  //   iosCustomNavButton.title = '帮助';
  //   iosCustomNavButton.titleFontSize = 14;
  //   iosCustomNavButton.titleColor = '#FE13AC';
  //   iosCustomNavButton.isBodyFont = true;
  //   iosCustomNavButton.cornerRadius = 5;
  //   iosCustomNavButton.normalImage = "assets/checked.png";
  //   // iosCustomNavButton.normalBackgroundImage = "assets/logo.png";
  //
  //   config.iOSConfig?.widgets = [
  //     iosCustomButton,
  //     iosTitleDesc,
  //     iosCustomNavButton
  //   ];
  //
  //   //设置到授权页竖屏布局
  //   SecVerifyUIConfigIOSCustomLayouts portraitLayouts =
  //   SecVerifyUIConfigIOSCustomLayouts();
  //   portraitLayouts.phoneLabelLayout = phoneLabelLayout;
  //   portraitLayouts.loginBtnLayout = loginBtnLayout;
  //   portraitLayouts.logoImageViewLayout = logoImageViewLayout;
  //   portraitLayouts.sloganLabelLayout = sloganLabelLayout;
  //   portraitLayouts.privacyTextViewLayout = privacyTextViewLayout;
  //   portraitLayouts.checkBoxLayout = checkBoxLayout;
  //
  //   config.iOSConfig?.portraitLayouts = portraitLayouts;
  //   config.androidPortraitConfig.navCloseImgHidden = true;
  //   return config;
  // }
  //
  // /// Returns the date range picker widget based on the properties passed.
  static SfDateRangePicker getYearDatePicker(Function onChange) {
    DateRangePickerController controller = DateRangePickerController();

    return SfDateRangePicker(
      controller: controller,
      allowViewNavigation: false,
      initialSelectedDate: DateTime.now(),
      onViewChanged:
          (DateRangePickerViewChangedArgs dateRangePickerViewChangedArgs) {
        onChange(PickerDateRange(DateTime(DateTime.now().year, 1, 1),
            DateTime(DateTime.now().year + 1, 1, 1)));
      },
      onSelectionChanged: (DateRangePickerSelectionChangedArgs
          dateRangePickerSelectionChangedArgs) {
        onChange(PickerDateRange(
            DateTime(dateRangePickerSelectionChangedArgs.value.year, 1, 1),
            DateTime(
                dateRangePickerSelectionChangedArgs.value.year + 1, 1, 1)));
      },
      view: DateRangePickerView.decade,
      showNavigationArrow: Utility.isHandsetBySize(),
      selectableDayPredicate: selectableDayPredicateDates,
    );
  }

  //
  // static List<FolderModelWithExtraData> getDelayMisisonDatas({required List<FolderModelWithExtraData> list}) {
  //   const List<FolderModelWithExtraData> datas = [];
  //   list?.forEach((element) {
  //     datas.add(FolderModelWithExtraData(folderModel: folderModel, folderTimeModel: element.folderTimeModel));
  //     if (element.extraData != null && element.extraData['delay'] != null) {
  //       datas.add(element);
  //     }
  //   });
  //   return datas;
  // }

  /// Returns the date range picker widget based on the properties passed.
  static SfDateRangePicker getMonthDatePicker(Function onChange) {
    return SfDateRangePicker(
      allowViewNavigation: false,
      initialSelectedDate: DateTime.now(),
      onViewChanged:
          (DateRangePickerViewChangedArgs dateRangePickerViewChangedArgs) {
        DateTime dateTimeStart =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        DateTime dateTimeEnd = DateTime(
            DateTime.now().month == 12
                ? DateTime.now().year + 1
                : DateTime.now().year,
            DateTime.now().month == 12 ? 1 : DateTime.now().month + 1,
            1);
        PickerDateRange pickerDateRange =
            PickerDateRange(dateTimeStart, dateTimeEnd);
        onChange(pickerDateRange);
      },
      onSelectionChanged: (DateRangePickerSelectionChangedArgs
          dateRangePickerSelectionChangedArgs) {
        DateTime dateTimeStart = DateTime(
            dateRangePickerSelectionChangedArgs.value.year,
            dateRangePickerSelectionChangedArgs.value.month,
            1);
        DateTime dateTimeEnd = DateTime(
            dateRangePickerSelectionChangedArgs.value.month == 12
                ? dateRangePickerSelectionChangedArgs.value.year + 1
                : dateRangePickerSelectionChangedArgs.value.year,
            dateRangePickerSelectionChangedArgs.value.month == 12
                ? 1
                : dateRangePickerSelectionChangedArgs.value.month + 1,
            1);
        PickerDateRange pickerDateRange =
            PickerDateRange(dateTimeStart, dateTimeEnd);
        onChange(pickerDateRange);
      },
      view: DateRangePickerView.year,
      showNavigationArrow: Utility.isHandsetBySize(),
      selectableDayPredicate: selectableDayPredicateDates,
    );
  }

  /// Returns the date range picker widget based on the properties passed.
  static SfDateRangePicker getDayDatePicker(Function onChange) {
    return SfDateRangePicker(
      initialSelectedDate: DateTime.now(),
      onViewChanged:
          (DateRangePickerViewChangedArgs dateRangePickerViewChangedArgs) {
        DateTime dateTimeStart = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime dateTimeEnd = dateTimeStart.add(Duration(days: 1));
        PickerDateRange pickerDateRange =
            PickerDateRange(dateTimeStart, dateTimeEnd);
        onChange(pickerDateRange);
      },
      onSelectionChanged: (DateRangePickerSelectionChangedArgs
          dateRangePickerSelectionChangedArgs) {
        DateTime dateTimeStart = DateTime(
            dateRangePickerSelectionChangedArgs.value.year,
            dateRangePickerSelectionChangedArgs.value.month,
            dateRangePickerSelectionChangedArgs.value.day);
        DateTime dateTimeEnd = dateTimeStart.add(Duration(days: 1));
        PickerDateRange pickerDateRange =
            PickerDateRange(dateTimeStart, dateTimeEnd);
        onChange(pickerDateRange);
      },
      view: DateRangePickerView.month,
      // monthCellStyle: const DateRangePickerMonthCellStyle(
      //     blackoutDateTextStyle: TextStyle(
      //         color: Colors.red, decoration: TextDecoration.lineThrough)),
      // monthViewSettings: DateRangePickerMonthViewSettings(
      //     showTrailingAndLeadingDates: true, blackoutDates: getBlackoutDates()),
      showNavigationArrow: Utility.isHandsetBySize(),
      selectableDayPredicate: selectableDayPredicateDates,
    );
  }

  /// Returns the date range picker based on the properties passed
  static SfHijriDateRangePicker getSfHijriDateRangePicker(
      HijriDatePickerController controller,
      DateRangePickerSelectionMode mode,
      bool enablePastDates,
      bool enableSwipingSelection,
      bool enableViewNavigation,
      bool showActionButtons,
      HijriDateTime minDate,
      HijriDateTime maxDate,
      bool enableMultiView,
      bool showWeekNumber,
      bool showTodayButton,
      ExtendableRangeSelectionDirection selectionDirection,
      BuildContext context) {
    return SfHijriDateRangePicker(
      enablePastDates: enablePastDates,
      minDate: minDate,
      maxDate: maxDate,
      enableMultiView: enableMultiView,
      allowViewNavigation: enableViewNavigation,
      showActionButtons: showActionButtons,
      selectionMode: mode,
      extendableRangeSelectionDirection: selectionDirection,
      controller: controller,
      showTodayButton: showTodayButton,
      headerStyle: DateRangePickerHeaderStyle(
          textAlign: enableMultiView ? TextAlign.center : TextAlign.left),
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Selection Cancelled',
          ),
          duration: Duration(milliseconds: 200),
        ));
      },
      onSubmit: (Object? value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Selection Confirmed',
          ),
          duration: Duration(milliseconds: 200),
        ));
      },
      monthViewSettings: HijriDatePickerMonthViewSettings(
          enableSwipeSelection: enableSwipingSelection,
          showWeekNumber: showWeekNumber),
    );
  }

  static SfDateRangePicker getDateRangePicker2(
      DateRangePickerSelectionChangedCallback onChange) {
    // return SfDateRangePicker(
    //   enableMultiView: true,
    //   headerStyle: DateRangePickerHeaderStyle(backgroundColor: Colors.green),
    //   navigationDirection: DateRangePickerNavigationDirection.vertical,
    //   selectionMode: DateRangePickerSelectionMode.multiRange,
    //   monthViewSettings:
    //       const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
    //   showNavigationArrow: false,
    //   navigationMode: DateRangePickerNavigationMode.scroll,
    // );
    return SfDateRangePicker(
      viewSpacing: 20,
      // backgroundColor: Colors.red,
      enableMultiView: true,
      onSelectionChanged: onChange,
      selectionShape: DateRangePickerSelectionShape.circle,
      // cellBuilder:DateRangePickerCellBuilder(),
      // rangeSelectionColor: Colors.redAccent,
      // startRangeSelectionColor: Colors.purple,
      // endRangeSelectionColor: Colors.purple,
      selectionTextStyle: TextStyle(
          color: ThemeManager.getInstance()
              .getTextColor(defaultColor: Colors.black)),
      // rangeTextStyle: TextStyle(fontSize: 29, color: Colors.green),
      // selectionColor: Colors.redAccent,
      // rangeTextStyle: TextStyle(fontSize: 20),
      // headerStyle:
      // DateRangePickerHeaderStyle(backgroundColor: Colors.orange),
      navigationDirection: DateRangePickerNavigationDirection.vertical,
      selectionMode: DateRangePickerSelectionMode.range,
      // monthViewSettings:
      //     const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
      showNavigationArrow: Utility.isHandsetBySize(),
      navigationMode: DateRangePickerNavigationMode.scroll,
    );
  }

  static SfDateRangePicker getDateRangePicker(
      DateRangePickerSelectionChangedCallback onChange) {
    return SfDateRangePicker(
      onSelectionChanged: onChange,
      selectionMode: DateRangePickerSelectionMode.range,
      initialSelectedRange: PickerDateRange(
          DateTime.now().subtract(const Duration(days: 4)),
          DateTime.now().add(const Duration(days: 3))),
    );
  }

  static bool selectableDayPredicateDates(DateTime date) {
    // if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
    //   return false;
    // }

    return true;
  }

  /// Returns the list of dates that set to the blackout dates property of
  /// date range picker.
  static List<DateTime> getBlackoutDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate =
        DateTime.now().subtract(const Duration(days: 500));
    final DateTime endDate = DateTime.now().add(const Duration(days: 500));
    final Random random = Random();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(Duration(days: random.nextInt(30)))) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        dates.add(date);
      }
    }

    return dates;
  }

  // static getDatetimeFromUctTime(String utcTime) {
  //   return DateTime.parse(utcTime);
  // }

  static DateTime getDateTime(
      {int? year, int? month, int? day, int? hour, int? minute, int? seconds}) {
    return DateTime(
        year ?? 0, month ?? 0, day ?? 0, hour ?? 0, minute ?? 0, seconds ?? 0);
  }

  /**
   * {year}年{month}月{day}日 {hour}:{min},{weekday}
   */
  static getDateTimeYMDHM(DateTime dateTime) {
    return getI18NKey().missionModelDate4(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        Utility.formatDecimal(dateTime.hour, shouldAddZero: true),
        Utility.formatDecimal(dateTime.minute, shouldAddZero: true),
        CONSTANTS.getTextFromDayOfWeek(dateTime.weekday));
  }

  static String getResultStringFromTimes(List<int> times) {
    List<String> list = [];
    // StringBuffer sb = StringBuffer();
    times.forEach((time) {
      list.add(Utility.formatHourAndMin2(time ?? 0));
    });
    return list.join(',');
  }

  /**
   * {year}年{month}月{day}日,{weekday}
   */
  static String getDateTimeYMD(DateTime dateTime) {
    return getI18NKey().missionModelDate(dateTime.year, dateTime.month,
        dateTime.day, CONSTANTS.getTextFromDayOfWeek(dateTime.weekday));
  }

  static String getLunarCalendar({year, month, day}) {
    // LunarSolarConverter.lunarToSolar(Lunar(lunarYear: 2022, lunarMonth: 4, lunarDay: 1, isLeap: true));

    // Lunar lunar = LunarSolarConverter.solarToLunar(Solar(solarYear: 2023, solarMonth: 9, solarDay: 14));
    String res = LunarSolarConverter.solarToLunar(
            Solar(solarYear: year, solarMonth: month, solarDay: day))
        .toString();
    return res.substring(res.length - 2);
    print(111111);
    return "";
    // return lunar.lunarDay;
  }

  static copyClipboard() {
    // FlutterClipboard.copy('hello flutter friends').then(( value ) => print('copied'));
  }

  static pasteFromClipboard() {
    // FlutterClipboard.paste().then((value) {
    //   // Do what ever you want with the value.
    //   setState(() {
    //     field.text = value;
    //     pasteValue = value;
    //   });
    // });
  }

  /**
   * 复制到剪贴板
   */
  static void copyToClipboard(String text, {bool shouldShowToast = true}) {
    FlutterClipboard.copy(text).then((value) {
      if (shouldShowToast == true) {
        Utility.showToastMsg(
            context: Utility.getGlobalContext(),
            msg: getI18NKey().successfully_copied_to_clipboard);
      }
    });
  }

  static String getContentFromMissionList(
      {required List<MissionModel> datas,
      required List<CheckButtonStateModel> listCheckButtonModel,
      bool isJumpLine = false}) {
    StringBuffer sb = StringBuffer();
    Function getSpace = (int index) {
      if (index < 10) {
        return "  ";
      } else {
        return "   ";
      }
    };
    int index = 1;
    datas.forEach((data) {
      sb.write('${index++}.');
      bool hasAddedEspace = false; //是否添加了空格
      Map<String, dynamic> json = data.toJson();
      listCheckButtonModel.forEach((checkModel) {
        switch (checkModel.code) {
          case 'create_time':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write(
                '${getI18NKey().create_time}:${getDateTimeYMDHM(getDateTimeFromUTCString(data.createdAt ?? "")).toString()}');
            if (isJumpLine == true) {
              sb.write("\n");
            }
            break;
          case 'update_time':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write(
                '${getI18NKey().update_time_last_time}:${getDateTimeYMDHM(getDateTimeFromUTCString(data.updatedAt ?? "")).toString()}');
            if (isJumpLine == true) {
              sb.write("\n");
            }
            break;
          case 'isFinished':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            sb.write(json[checkModel.code] == true
                ? getI18NKey().yes
                : getI18NKey().no);
            break;
          case 'repetiveType':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            sb.write(json[checkModel.code] == false
                ? getI18NKey().no
                : getI18NKey().yes);
            break;
          case 'isDelayed':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            sb.write(json[checkModel.code] == true
                ? getI18NKey().yes
                : getI18NKey().no);
            break;
          case 'alert_time':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            if (json[checkModel.code] == 0) {
              sb.write(getI18NKey().none);
            } else {
              sb.write(getDateTimeYMDHM(
                  Utility.getDateTimeFromTimeStamp(json[checkModel.code])));
            }
            // sb.write(Utility.getDateTimeFromTimeStamp(json[checkModel.code]));
            break;
          case 'end_time':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            sb.write(getDateTimeYMDHM(
                Utility.getDateTimeFromTimeStamp(json[checkModel.code])));
            // sb.write(Utility.getDateTimeFromTimeStamp(json[checkModel.code]));
            break;
          case 'priorityStatus':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res =
                CONSTANTS.getPriorityByIndex(json[checkModel.code] ?? 0);
            sb.write(res);
            break;
          case 'time_finished':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = Utility.formatHourAndMin(json[checkModel.code]);
            sb.write(res);
            break;
          case 'tomato_duration':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = Utility.formatHourAndMin(json[checkModel.code]);
            sb.write(res);
            break;
          case 'total_tomotoes':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = getI18NKey().num_unit(json[checkModel.code]);
            sb.write(res);
            break;
          case 'no_tomotoes_finished':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = getI18NKey().num_unit(json[checkModel.code]);
            sb.write(res);
            break;
          case 'isFinished':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = json[checkModel.code] == 0
                ? getI18NKey().unfinished
                : getI18NKey().finished;
            sb.write(res);
            break;
          case 'message':
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = json[checkModel.code] ?? "";
            sb.write(res);
            break;
          default:
            if (checkModel.isCheck == false) return;
            if (hasAddedEspace == false) {
              hasAddedEspace = true;
            } else {
              sb.write(getSpace(index));
            }
            sb.write((checkModel.title ?? "") + ":");
            String res = json[checkModel.code].toString();
            sb.write(res);
            break;
        }
        if (isJumpLine == true) {
          sb.write("\n");
        }
        sb.write("\n");
      });
      sb.write("\n");
    });
    return sb.toString();
  }

  static void writeExcel() {
    Stopwatch stopwatch = new Stopwatch()..start();

    Excel excel = Excel.createExcel();
    Sheet sh = excel['Sheet1'];
    for (int i = 0; i < 8; i++) {
      sh.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value =
          'Col $i';
      //sh.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).cellStyle =CellStyle(bold: true);
    }
    for (int row = 1; row < 9000; row++) {
      for (int col = 0; col < 80; col++) {
        sh
            .cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: col))
            .value = '$row$col value';
      }
    }
    print('Generating executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    var fileBytes = excel.encode();

    print('Encoding executed in ${stopwatch.elapsed}');
    stopwatch.reset();

    // Excel excel = Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    // Sheet sheetObject = excel['SheetName'];
    // CellStyle cellStyle = CellStyle(backgroundColorHex: "#1AFF1A", fontFamily : getFontFamily(FontFamily.Calibri));
    // cellStyle.underline = Underline.Single; // or Underline.Double
    //
    // var cell = sheetObject.cell(CellIndex.indexByString("A1"));
    // cell.value = 8; // dynamic values support provided;
    // cell.cellStyle = cellStyle;
    //
    // // printing cell-type
    // print("CellType: "+ cell.cellType.toString());
    //
    // ///
    // /// Inserting and removing column and rows
    //
    // // insert column at index = 8
    // // sheetObject.insertColumn(8);
    //
    // // remove column at index = 18
    // // sheetObject.removeColumn(18);
    //
    // // insert row at index = 82
    // // sheetObject.insertRow(82);
    //
    // // remove row at index = 80
    // // sheetObject.removeRow(80);
    // List<int> fileBytes = excel.save();
    saveFileWithExtension(fileBytes as Uint8List, 'xlsx');
  }

  static FolderModel? getFolderModelByObjId(String objId) {
    return MongoApisManager.getInstance()
        .queryWhereEqualFolderModelByObjectId(objectId: objId);
  }

  /**
   * 给类型model的时间得到精确时间Datetime
   * @param {String} time
   */
  static DateTime getDateTimeFromUTCString(String utcTime) {
    if (TextUtil.isEmpty(utcTime)) {
      return DateTime.now();
    }
    return new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(utcTime).toLocal();
  }

  static DateTime getDateTimeFromString(String utcTime) {
    if (TextUtil.isEmpty(utcTime)) {
      return DateTime.now();
    }
    return new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(utcTime).toLocal();
  }

  static bool isDatetime1BeforeDatetime2(
      DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.isBefore(dateTime2);
    // return dateTime1.year == dateTime2.year &&
    //     dateTime1.month == dateTime2.month &&
    //     dateTime1.day == dateTime2.day;
  }

  // static int getBgIntMode() {
  //   SharePreferenceUtil.getSyncInstance().
  // }

  /**
   * 计时器切换字体时用于缓存
   */
  static int switchCounterFont() {
    int fontMode = SharePreferenceUtil.getSyncInstance().getFontMode();
    //fontMode 0到2自循环
    fontMode = (fontMode + 1) % 3;
    SharePreferenceUtil.getSyncInstance().setFontMode(fontMode);
    // fontMode = SharePreferenceUtil.getSyncInstance().getFontMode();
    return fontMode;
  }

  /**
   *
   */
  static TimelineMissionModel getTimelineMissionModelFromMissionModel(
      {String sceneType = "",
      String eventType = "",
      String? object_id = "",
      String? mission_id = "",
      String? folder_id = "",
      String? timelineMessage = "",
      String picUrl = "",
      String url = "",
      String extra = "",
      int icon = 0,
      int color = 0xffff8800,
      MissionModel? missionModel}) {
    FolderModel? folderModel = FolderModel();
    if (missionModel?.folder_id != null) {
      folderModel = MongoApisManager.getInstance()
          .getFolderModelByFolderId(missionModel?.folder_id ?? "");
    }
    TimelineMissionModel timelineMissionModel = TimelineMissionModel();
    switch (eventType) {
      case 'create_mission':
        if (folderModel?.title == null) {
          timelineMissionModel.timelineMessage = timelineMessage ??
              getI18NKey().create_name_mission2(missionModel?.title ?? "");
        } else {
          timelineMissionModel.timelineMessage = timelineMessage ??
              getI18NKey().create_name_mission(
                  folderModel?.title ?? "", missionModel?.title ?? "");
        }
        break;
      default:
        timelineMissionModel.timelineMessage = timelineMessage;
        break;
    }
    int iconTmp = icon ?? folderModel?.icon ?? Icons.shuffle.codePoint;
    timelineMissionModel.icon = iconTmp;
    timelineMissionModel.object_id = object_id;
    timelineMissionModel.tagName = folderModel?.tagName;
    timelineMissionModel.folder_id = folder_id ?? missionModel?.folder_id;
    timelineMissionModel.mission_id = mission_id ?? missionModel?.objectId;
    timelineMissionModel.color = color ?? folderModel?.color;
    timelineMissionModel.url = url;
    timelineMissionModel.picUrl = picUrl;
    timelineMissionModel.extra = extra;
    timelineMissionModel.sceneType = sceneType;
    timelineMissionModel.eventType = eventType;
    if (missionModel != null) {
      timelineMissionModel.mission_id = mission_id ?? missionModel.objectId;
      timelineMissionModel.folder_id = folder_id ?? missionModel.folder_id;
      timelineMissionModel.tagNames = missionModel.tagNames;
      timelineMissionModel.tagIds = missionModel.tagIds;
      timelineMissionModel.no_tomotoes_finished =
          missionModel.no_tomotoes_finished;
      timelineMissionModel.total_tomotoes = missionModel.total_tomotoes;
      timelineMissionModel.tomato_duration = missionModel.tomato_duration;
      timelineMissionModel.order_index = missionModel.order_index;
      timelineMissionModel.end_time_before_finished =
          missionModel.end_time_before_finished;
      timelineMissionModel.end_time = missionModel.end_time;
      timelineMissionModel.alert_time = missionModel.alert_time;
      timelineMissionModel.time_finished = missionModel.time_finished;
      timelineMissionModel.dateStatus = missionModel.dateStatus;
      timelineMissionModel.priorityStatus = missionModel.priorityStatus;
      timelineMissionModel.message = missionModel.message;
      timelineMissionModel.isFinished = missionModel.isFinished;
      timelineMissionModel.isDelayed = missionModel.isDelayed;
      timelineMissionModel.repetiveType = missionModel.repetiveType;
      timelineMissionModel.repetiveValue = missionModel.repetiveValue;
      timelineMissionModel.repetiveWeekDay = missionModel.repetiveWeekDay;
    }
    return timelineMissionModel;
  }

  /**
   * 随机生成背景图
   */
  static String getBackgroundImageUrl() {
    List listBg = [];
    try {
      if (ResourceInfo.allMissionBackgroundResourceLocationInfoBean != null) {
        listBg.addAll(ResourceInfo
                .allMissionBackgroundResourceLocationInfoBean?.deliveryList ??
            []);
      }
      if (Utility.isHandsetBySize() == true) {
        listBg.addAll(ResourceInfo
                .mobileMissionBackgroundResourceLocationInfoBean
                ?.deliveryList ??
            []);
      } else {
        listBg.addAll(ResourceInfo
                .pcMissionBackgroundResourceLocationInfoBean?.deliveryList ??
            []);
      }
      if ((listBg.length ?? 0) > 0) {
        int random = getRandom(from: 0, max: listBg.length);
        ResourceDeliveryInfoBean deliveryInfoBean = listBg[random];
        return deliveryInfoBean?.resourcePictureUrl ?? '';
      }
    } catch (e) {
      print(e);
    }
    return "https://oss.timerbell.com/resourceOss/20230328-astronomy-1867616_1280.jpg";
  }

  //用来解决oss跨域问题
  static String getOSSOriginFromUrl(String url) {
    if (DeviceInfoManagement.isWEB()) {
      return url.replaceAll(
          "http://oss.timerbell.com", "https://www.timerbell.com");
    } else {
      return url;
    }
  }

  static String getSplashFamousSentence() {
    try {
      if ((ResourceInfo.famousSentenceResourceLocationInfoBean?.deliveryList
                  ?.length ??
              0) >
          0) {
        int random = getRandom(
            from: 0,
            max: ResourceInfo.famousSentenceResourceLocationInfoBean
                    ?.deliveryList?.length ??
                0);
        ResourceDeliveryInfoBean deliveryInfoBean = ResourceInfo
                .famousSentenceResourceLocationInfoBean
                ?.deliveryList?[random] ??
            ResourceDeliveryInfoBean();
        SharePreferenceUtil.getSyncInstance().setString(
            key: ShareprefrenceKeys.defaultSplash,
            content: deliveryInfoBean.resourceTitle ?? "");
        return deliveryInfoBean.resourceTitle ?? "";
      }
    } catch (e) {}
    return SharePreferenceUtil.getSyncInstance().getString(
        key: ShareprefrenceKeys.defaultSplash,
        defaultVal:
            "\"The greatest glory in living lies not in never falling, but in rising every time we fall.\" - Nelson Mandela");
  }

  static String getCurMonth() {
    DateTime now = DateTime.now();
    return formatDecimal(now.month, shouldAddZero: true);
  }

  /**
   * 算出剩余天数
   */
  static String formatRemainingTimeByDay(Duration duration) {
    String day = duration.inDays.toString();
    return day;
  }

  static String formatRemainingTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitDays = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return getI18NKey().count_down(
        twoDigitDays, twoDigitHours, twoDigitMinutes, twoDigitSeconds);
  }

  static String getFamousSentence() {
    try {
      if ((ResourceInfo.famousSentenceResourceLocationInfoBean?.deliveryList
                  ?.length ??
              0) >
          0) {
        int random = getRandom(
            from: 0,
            max: ResourceInfo.famousSentenceResourceLocationInfoBean
                    ?.deliveryList?.length ??
                0);
        ResourceDeliveryInfoBean deliveryInfoBean = ResourceInfo
                .famousSentenceResourceLocationInfoBean
                ?.deliveryList?[random] ??
            ResourceDeliveryInfoBean();
        return deliveryInfoBean.resourceTitle ?? "";
      }
    } catch (e) {}
    return "\"The greatest glory in living lies not in never falling, but in rising every time we fall.\" - Nelson Mandela";
  }

  static ChatGptMessageModel? getLastSentence(List<ChatGptMessageModel> list,
      ChatGptMessageModel? chatGptMessageModelTmp) {
    try {
      ChatGptMessageModel? chatGptMessageModel = null;
      for (int i = 0; i < list.length; i++) {
        ChatGptMessageModel item = list[i];
        if (item.isUser == true) {
          chatGptMessageModel = item;
        }
        if (item.objectId == chatGptMessageModelTmp?.objectId) {
          return chatGptMessageModel;
        }
      }
    } catch (e) {}
    return null;
  }

  static bool isGzipped(List<int> byte) {
    if (byte.length < 2) {
      return false;
    }
    return ((byte[0].toUnsigned(64)) & 0xff |
            ((byte[1] << 8).toUnsigned(64) & 0xff00)) ==
        0x8b1f;
  }

  static HttpClientAdapter? getHttp2Adapter() {
    if (Params.env == EnvEnum.prd || Params.env == EnvEnum.uat) {
      return Http2Adapter(
        ConnectionManager(
          idleTimeout: Duration(seconds: 10), // Enable gzip compression
          onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
        ),
      );
    }
    return null;
  }

  static String getGzipDecoder(List<int> responseBytes, RequestOptions options,
      ResponseBody responseBody) {
    //本地web开发环境不能用gzip解密 因为egg没有用gzip
    if (Params.env == EnvEnum.dev) {
      return utf8.decode(responseBytes);
    }
    if (isGzipped(responseBytes)) {
      return utf8.decode(gzip.decode(responseBytes));
    } else {
      return utf8.decode(responseBytes);
    }
  }

/**
 * 获取I18N翻译
 * 如S.of(context).picktime
 */
// static getI18NKey([BuildContext context]) {
//   return S.of(context ?? getGlobalContext());
// }
// static downloadFileByUrl(url) async{
//   Uint8List bytes;     try {       bytes = await readBytes(url);     } on ClientException {       rethrow;     }     return bytes;   }    Future _loadFile() async {     final bytes = await _loadFileBytes(kUrl,         onError: (Exception exception) =>             print('_loadFile => exception $exception'));      final dir = await getApplicationDocumentsDirectory();     final file = File('${dir.path}/audio.mp3');      await file.writeAsBytes(bytes);     if (await file.exists())       setState(() {         localFilePath = file.path;       });
// }
}

class WeekDayConverter {
  /// 从周一到周日转换为周日到周六
  static List<bool> convertFromMondayToSundayToSundayToSaturday(
      List<bool> mondayToSunday) {
    if (mondayToSunday.length != 7) {
      throw ArgumentError("WeekDay array must have exactly 7 elements.");
    }
    return [mondayToSunday.last, ...mondayToSunday.sublist(0, 6)];
  }

  /// 从周日到周六转换为周一到周日
  static List<bool> convertFromSundayToSaturdayToMondayToSunday(
      List<bool> sundayToSaturday) {
    if (sundayToSaturday.length != 7) {
      throw ArgumentError("WeekDay array must have exactly 7 elements.");
    }
    return [...sundayToSaturday.sublist(1), sundayToSaturday.first];
  }
}
