import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/GptSuggestionBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/TimeRatioComponent.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/models/ColorsModel.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/EndTimeMissionModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/FolderModelWithExtraData.dart';
import 'package:time_hello/com/timehello/models/FolderTimeModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/beans/ResourceDeliveryInfoBean.dart';
import 'package:time_hello/com/timehello/models/ProgressFocusModel.dart';
import 'package:time_hello/com/timehello/models/SelectObjectTypeModel.dart';
import 'package:time_hello/com/timehello/models/SettingModel.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/SettingManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../models/CommentModel.dart';
import '../models/FlomoMissionModel.dart';
import '../models/GroupModel.dart';
import '../models/PushDataModel.dart';
import '../models/PushDataModelList.dart';
import '../models/WQBFolderModel.dart';
import '../models/WQBFolderModelWithExtraData.dart';
import '../models/WQBMissionModel.dart';
import '../util/CounterManagement.dart';
import '../util/DeviceInfoManagement.dart';
import '../util/LoginManager.dart';
import '../util/SharePreferenceUtil.dart';
import 'ColorsConfig.dart';
import 'ENUMS.dart';
import 'Params.dart';

const kTabletBreakpoint = 768.0;
const kDesktopBreakpoint = 1440.0;

const kSdieMenuWidth = 300.0;
const kNavigationRailWidth = 72.0;
ScreenType screenType = ScreenType.Handset;

class CONSTANTS {
  static String CODE_CAPTCHA_INCORRECT = "0000CPI";
  static String CODE_DYNAMIC_CODE_INCORRECT = "0000CDCI";
  static String CODE_GPT_TOKEN_EXPIRED = "0000FEWF";
  static String CODE_USER_EXIST = "0000D2DE";
  static String CODE_USER_NOT_EXIST = "0000AESE";
  static String CODE_USER_OR_PASSWORD_NOT_CORRECT = "0000AFED";
  static String CODE_USER_TOKEN_EXPIRED = "0000AFEI";
  static String CODE_LOGIN_FIRST = "0000JFED";
  static String CODE_LOCAL_MONEY_NOT_ENOUGH = "0000CDEF";
  static String CODE_FAIL = "0000VEWF";



  static const double missionPageMargin = 0;
  static List<FolderModel> folderModelList = [];
  static List<WQBFolderModel> wqbFolderModelList = [];
  static PushDataModelList pushDataModelList = PushDataModelList();
  static PushDataModelList pushDataModelListPrev = PushDataModelList();
  static String OTHER_OBJECT_ID = "other_object_id";

  static int getCurPage(PageEnum pageEnum) {
    switch (pageEnum) {
      case PageEnum.CalendarPage:
        return 3;
      case PageEnum.StatisticPage:
        return 1;
      case PageEnum.FolderPage:
        return 0;
      case PageEnum.MinePage:
        return 4;
      case PageEnum.QuadrantPage:
        return 2;
      case PageEnum.TimelinePage:
        return 6;
    }
    return 0;
  }

  static List<ResourceDeliveryInfoBean> getFolderModelHeaderGridViewList() {
    List<ResourceDeliveryInfoBean> list = [];
    list.add(ResourceDeliveryInfoBean(
        deliveryName: "timeline",
        resourceTitle: Utility.isHuaWei()
            ? getI18NKey().tasks_list
            : getI18NKey().timeline,
        resourceIconUrl: R.assetsImgIcTimeline,
        // resourcePictureUrl: R.assetsImgBgTimeline,
        extendParamsMap: {"color": 0xffb12c00}));
    list.add(ResourceDeliveryInfoBean(
        deliveryName: "addnote",
        resourceTitle: getI18NKey().add_note,
        resourceIconUrl: R.assetsImgIcAddnote,
        resourcePictureUrl: R.assetsImgBgAddlink,
        extendParamsMap: {"color": 0xff8400b1}));

    list.add(ResourceDeliveryInfoBean(
        deliveryName: "voicenote",
        resourceTitle: getI18NKey().note_diary,
        resourceIconUrl: R.assetsImgIcVoiceNote,
        // resourcePictureUrl: R.assetsImgBgVoicenote,
        extendParamsMap: {"color": 0xffb10043}));

    list.add(ResourceDeliveryInfoBean(
        deliveryName: "writediary",
        resourceTitle: getI18NKey().write_diary,
        resourceIconUrl: R.assetsImgIcNote,
        // resourcePictureUrl: R.assetsImgBgWriteNote,
        extendParamsMap: {"color": 0xff0031b1}));

    list.add(ResourceDeliveryInfoBean(
        deliveryName: "voicediary",
        resourceTitle: getI18NKey().voice_diary,
        resourceIconUrl: R.assetsImgIcVoiceDiary,
        // resourcePictureUrl: R.assetsImgBgVoiceDiary,
        extendParamsMap: {"color": 0xffb12c00}));

    list.add(ResourceDeliveryInfoBean(
        deliveryName: "CountDownListViewPage",
        resourceTitle: getI18NKey().count_down_text,
        resourceIconUrl: R.assetsImgIcCountdownTimerSelected,
        resourcePictureUrl: R.assetsImgIcCountdownTimerSelected,
        extendParamsMap: {"color": 0xffb12c00}));
    return list;
  }

  static String getErrorMessage(code) {
    switch (code) {
      case '0000FEWF':
        return getI18NKey().gpt_token_expired;
      case '0000CDCI':
        return getI18NKey().code_dynamic_code_incorrect;
      case '0000D2DE':
        return getI18NKey().code_user_exist;
      case '0000AESE':
        return getI18NKey().code_user_not_exist;
      case '0000AFED':
        return getI18NKey().code_user_password_not_correct;
      case '0000JFED':
        LoginManager.getInstance().logout(Utility.getGlobalContext());
        return getI18NKey().loginFirst;
      case '0000AFEI':
        LoginManager.getInstance().logout(Utility.getGlobalContext());
        return getI18NKey().tokenExpired;
    }
    return "";
  }

  static List<String> getAvatarListWidget() {
    List<String> listWidgets = [];
    for (int i = 0; i < 41; i++) {
      String fixInt = Utility.getFixedInt(i, 2);
      listWidgets.add('avatar_${fixInt}');
    }
    return listWidgets;
  }

  static Widget getAvatarFromAvatarList(
      String avatarCode, @required double width) {
    String img;
    switch (avatarCode) {
      case 'avatar_01':
        img = R.assetsImgAvatar01;
        break;
      case 'avatar_02':
        img = R.assetsImgAvatar02;
        break;
      case 'avatar_03':
        img = R.assetsImgAvatar03;
        break;
      case 'avatar_04':
        img = R.assetsImgAvatar04;
        break;
      case 'avatar_05':
        img = R.assetsImgAvatar05;
        break;
      case 'avatar_06':
        img = R.assetsImgAvatar06;
        break;
      case 'avatar_07':
        img = R.assetsImgAvatar07;
        break;
      case 'avatar_08':
        img = R.assetsImgAvatar08;
        break;
      case 'avatar_09':
        img = R.assetsImgAvatar09;
        break;
      case 'avatar_10':
        img = R.assetsImgAvatar10;
        break;
      case 'avatar_11':
        img = R.assetsImgAvatar11;
        break;
      case 'avatar_12':
        img = R.assetsImgAvatar12;
        break;
      case 'avatar_13':
        img = R.assetsImgAvatar13;
        break;
      case 'avatar_14':
        img = R.assetsImgAvatar14;
        break;
      case 'avatar_15':
        img = R.assetsImgAvatar15;
        break;
      case 'avatar_16':
        img = R.assetsImgAvatar16;
        break;
      case 'avatar_17':
        img = R.assetsImgAvatar17;
        break;
      case 'avatar_18':
        img = R.assetsImgAvatar18;
        break;
      case 'avatar_19':
        img = R.assetsImgAvatar19;
        break;
      case 'avatar_20':
        img = R.assetsImgAvatar20;
        break;
      case 'avatar_21':
        img = R.assetsImgAvatar21;
        break;
      case 'avatar_22':
        img = R.assetsImgAvatar22;
        break;
      case 'avatar_23':
        img = R.assetsImgAvatar23;
        break;
      case 'avatar_24':
        img = R.assetsImgAvatar24;
        break;
      case 'avatar_25':
        img = R.assetsImgAvatar25;
        break;
      case 'avatar_26':
        img = R.assetsImgAvatar26;
        break;
      case 'avatar_27':
        img = R.assetsImgAvatar27;
        break;
      case 'avatar_28':
        img = R.assetsImgAvatar28;
        break;
      case 'avatar_29':
        img = R.assetsImgAvatar29;
        break;
      case 'avatar_30':
        img = R.assetsImgAvatar30;
        break;
      case 'avatar_31':
        img = R.assetsImgAvatar31;
        break;
      case 'avatar_32':
        img = R.assetsImgAvatar32;
        break;
      case 'avatar_33':
        img = R.assetsImgAvatar33;
        break;
      case 'avatar_34':
        img = R.assetsImgAvatar34;
        break;
      case 'avatar_35':
        img = R.assetsImgAvatar35;
        break;
      case 'avatar_36':
        img = R.assetsImgAvatar36;
        break;
      case 'avatar_37':
        img = R.assetsImgAvatar37;
        break;
      case 'avatar_38':
        img = R.assetsImgAvatar38;
        break;
      case 'avatar_39':
        img = R.assetsImgAvatar39;
        break;
      case 'avatar_40':
        img = R.assetsImgAvatar40;
        break;
      default:
        img = R.assetsImgAvatar01;
        break;
    }
    return Utility.getSVGPicture(img, size: width.toDouble());
  }

  /**
   * 右上角卡片 初始默认值
   */
  static List<ResourceDeliveryInfoBean> getPCRightTopRessourceData(
      {String? sceneCode,
      int? totalTimePrev,
      int? totalTime,
      int? numTomatoes,
      int? numTomatoesPrev,
      int? missionCompleted,
      int? missionCompletedPrev,
      DateTypeEnum? dateTypeEnum}) {
    List<ResourceDeliveryInfoBean> list = [];
    Map? totalTimeMap = Utility.getDiffPercent(totalTimePrev!, totalTime!);
    Map? numTomatoesMap =
        Utility.getDiffPercent(numTomatoesPrev!, numTomatoes!);
    Map? missionCompletedMap =
        Utility.getDiffPercent(missionCompletedPrev!, missionCompleted!);
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().totalTime,
        isChecked: sceneCode == null || sceneCode == 'wholeComepleteTime',
        resourceContent: dateTypeEnum == DateTypeEnum.day
            ? getI18NKey().today_duration_completed
            : dateTypeEnum == DateTypeEnum.last7Days
                ? getI18NKey().week_duration_completed
                : dateTypeEnum == DateTypeEnum.lastMonth
                    ? getI18NKey().month_duration_completed
                    : dateTypeEnum == DateTypeEnum.custom
                        ? getI18NKey().custom
                        : getI18NKey().year_duration_completed,
        extendParamsMap: {
          "unit": getI18NKey().mins2,
          "isArrowUp": totalTimeMap?['isUp'] ?? true,
          "sceneCode": "wholeComepleteTime",
          "value": totalTime.toString(),
          "resourceIconWidgetChecked": Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: 18,
          ),
          "resourceIconWidgetUnChecked": Icon(
            Icons.timer_outlined,
            color: Colors.blue,
            size: 18,
          ),
          'isUp': true,
          'percentGrowth': totalTimeMap?['percentDiff'] ?? "0%"
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().tomatoNums,
        isChecked: sceneCode == 'tomatoNums',
        resourceContent: dateTypeEnum == DateTypeEnum.day
            ? getI18NKey().today_tomatoes_completed
            : dateTypeEnum == DateTypeEnum.last7Days
                ? getI18NKey().week_tomatoes_completed
                : dateTypeEnum == DateTypeEnum.lastMonth
                    ? getI18NKey().month_tomatoes_completed
                    : dateTypeEnum == DateTypeEnum.custom
                        ? getI18NKey().custom
                        : getI18NKey().year_tomatoes_completed,
        extendParamsMap: {
          "unit": getI18NKey().unitTomatoes,
          "isArrowUp": numTomatoesMap?['isUp'] ?? true,
          "sceneCode": "tomatoNums",
          "value": numTomatoes,
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcTomatoWhite, size: 15),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: 15),
          'isUp': true,
          'percentGrowth': numTomatoesMap?['percentDiff'] ?? "0%"
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().missionNums,
        isChecked: sceneCode == 'missionNums',
        resourceContent: dateTypeEnum == DateTypeEnum.day
            ? getI18NKey().today_mission_completed
            : dateTypeEnum == DateTypeEnum.last7Days
                ? getI18NKey().week_mission_completed
                : dateTypeEnum == DateTypeEnum.lastMonth
                    ? getI18NKey().month_mission_completed
                    : dateTypeEnum == DateTypeEnum.custom
                        ? getI18NKey().custom
                        : getI18NKey().year_mission_completed,
        extendParamsMap: {
          "unit": getI18NKey().unitMissions,
          "isArrowUp": numTomatoesMap?['isUp'] ?? true,
          "sceneCode": "missionNums",
          "value": missionCompleted.toString(),
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcFolderWhite, size: 18),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcFolder, size: 18),
          'isUp': true,
          'percentGrowth': missionCompletedMap?['percentDiff'] ?? "0%"
        }));
    return list;
  }

  /**
   * 每天20点开始推送 每日工作安排
   */
  static PushDataModelList getPushDataModelList() {
    PushDataModelList pushDataModelList = PushDataModelList();
    DateTime dateTime = DateTime.now();
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = 20;
    // int minute = dateTime.minute + 1;
    // int second = dateTime.second;

    DateTime dateTimeCur = Utility.getDateTime(
        year: year, month: month, day: day, hour: hour, minute: 0, seconds: 0);
    int totalDays = 100;
    int flag = hour <= 20 ? 0 : 1; //8点以内不用加1跳转到下一天
    List<String> list = [
      getI18NKey().notification0,
      getI18NKey().notification1,
      getI18NKey().notification2,
      getI18NKey().notification3,
      getI18NKey().notification4,
      getI18NKey().notification5,
      getI18NKey().notification6,
      getI18NKey().notification7,
      getI18NKey().notification8,
      getI18NKey().notification9,
      getI18NKey().notification10,
      getI18NKey().notification11,
      getI18NKey().notification12,
      getI18NKey().notification13,
      getI18NKey().notification14,
      getI18NKey().notification15,
      getI18NKey().notification16,
      getI18NKey().notification17,
      getI18NKey().notification18,
      getI18NKey().notification19,
      getI18NKey().notification20
    ];
    for (int i = 0; i < totalDays; i++) {
      if (i < list.length) {
        // DateTime i = dateTimeCur
        //     .add(Duration(minutes: 1 + i));
        pushDataModelList.list.add(PushDataModel(
            title: getI18NKey().notification_title,
            content: list[i],
            whenMilliseconds: dateTimeCur
                .add(Duration(days: flag + i))
                .millisecondsSinceEpoch,
            id: "1000$i",
            summaryText: ''));
      } else {
        pushDataModelList.list.add(PushDataModel(
            title: getI18NKey().notification_title,
            content: getI18NKey().notification_more,
            whenMilliseconds: dateTimeCur
                .add(Duration(days: flag + i))
                .millisecondsSinceEpoch,
            id: "1000$i",
            summaryText: ''));
      }
      // print("${dateTimeCur.add(Duration(days: flag + i)).toUtc()}");
    }

    return pushDataModelList;
  }

  static List<ResourceDeliveryInfoBean> getMinePageHeaderRessourceData() {
    List<ResourceDeliveryInfoBean> list = [];
    if (ABTestSetting.isOpenAiOn == true && Utility.isChina() == false) {
      list.add(ResourceDeliveryInfoBean(
          deliveryName: "chatGPT",
          resourceTitle: getI18NKey().chatgpt,
          resourceContent: Utility.isHuaWei()
              ? getI18NKey().chatgpt_desc_huawei
              : getI18NKey().chatgpt_desc,
          extendParamsMap: {
            "icon": Utility.getSVGPicture(R.assetsImgIcChatgptSelect, size: 50),
          }));
    }
    if (ABTestSetting.isCourseOn == true &&
        MongoApisManager.getInstance().listCourseModel.length > 0) {
      list.add(ResourceDeliveryInfoBean(
          deliveryName: "training",
          resourceTitle: getI18NKey().course,
          resourceContent: getI18NKey().course_desc,
          extendParamsMap: {
            "icon": Utility.getSVGPicture(R.assetsImgIcCourseTrain, size: 50),
          }));
    }
    return list;
  }

  static List<ResourceDeliveryInfoBean> getWQBMENUSilverListRessourceData() {
    List<ResourceDeliveryInfoBean> list = [];
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().all,
        isChecked: true,
        resourceContent: getI18NKey().today_duration_completed,
        extendParamsMap: {
          "code": "all",
          // "unit": getI18NKey().mins2,
          "isArrowUp": true,
          "sceneCode": "wholeComepleteTime",
          // "value": "0",
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcCardAllWhite, size: 15),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcCardAllBlack, size: 15),
          // 'isUp': true,
          // 'percentGrowth': '0%'
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().new_card,
        isChecked: false,
        resourceContent: getI18NKey().today_tomatoes_completed,
        extendParamsMap: {
          "code": "new",
          // "unit": getI18NKey().unitTomatoes,
          "isArrowUp": false,
          "sceneCode": "tomatoNums",
          // "value": "0%",
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcCardNewWhite, size: 15),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcCardNewBlack, size: 15),
          // 'isUp': true,
          // 'percentGrowth': '0%'
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().memorizing,
        isChecked: false,
        resourceContent: getI18NKey().today_mission_completed,
        extendParamsMap: {
          "code": "memorizing",
          // "unit": getI18NKey().unitMissions,
          "isArrowUp": false,
          "sceneCode": "missionNums",
          // "value": "0%",
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcLightningWhite, size: 15),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcLightningBlack, size: 15),
          // 'isUp': true,
          // 'percentGrowth': '0%'
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().memorized,
        isChecked: false,
        resourceContent: getI18NKey().today_mission_completed,
        extendParamsMap: {
          "code": "memorized",
          // "unit": getI18NKey().unitMissions,
          "isArrowUp": false,
          "sceneCode": "missionNums12",
          // "value": "0%",
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcFinishedWhite, size: 18),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcFinishedBlack, size: 18),
          // 'isUp': true,
          // 'percentGrowth': '0%'
        }));
    return list;
  }

  // "micro_mastery_step4": "创造可复验性",
  // "micro_mastery_step3": "创造明确回报",
  // "micro_mastery_step2": "获取背景支持",
  // "micro_mastery_step1": "找到入门技巧",
  static List<GroupModel> getMicroMasteryList({required String folderId}) {
    List<GroupModel> list = [];
    GroupModel groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().micro_mastery_step1;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().micro_mastery_step2;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().micro_mastery_step3;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().micro_mastery_step4;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    return list;
  }

  // "four_seasons_step4" : "Fourth Quarter",
  // "four_seasons_step3" : "Third Quarter",
  // "four_seasons_step2" : "Second Quarter",
  // "four_seasons_step1" : "First Quarter",
  static List<GroupModel> getFourSeasonsList({required String folderId}) {
    List<GroupModel> list = [];
    GroupModel groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().four_seasons_step1;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().four_seasons_step2;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().four_seasons_step3;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().four_seasons_step4;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    return list;
  }

  // "jan": "Jan",
  // "feb": "Feb",
  // "mar": "Mar",
  // "apr": "Apr",
  // "may": "May",
  // "jun": "Jun",
  // "jul": "Jul",
  // "aug": "Aug",
  // "sep": "Sep",
  // "oct": "Oct",
  // "nov": "Nov",
  // "dec": "Dec",

  static List<GroupModel> getJanToDec({required String folderId}) {
    List<GroupModel> list = [];
    GroupModel groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().jan;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().feb;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().mar;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().apr;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().may;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().jun;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().jul;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().aug;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().sep;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().oct;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().nov;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().dec;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    return list;
  }

  // "pdpa_step1": "Plan",
  // "pdpa_step2": "Do",
  // "pdpa_step3": "Check",
  // "pdpa_step4": "Action",
  static List<GroupModel> getPDPAList({required String folderId}) {
    List<GroupModel> list = [];
    GroupModel groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().pdpa_step1;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().pdpa_step2;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().pdpa_step3;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().pdpa_step4;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    return list;
  }

  // "gtd_step5": "Review and Summary",
  // "gtd_step4": "Take Action",
  // "gtd_step3": "Organize",
  // "gtd_step2": "Clarify Meaning",
  // "gtd_step1": "Collect Information",
  static List<GroupModel> getGTDList({required String folderId}) {
    List<GroupModel> list = [];
    GroupModel groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().gtd_step1;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().gtd_step2;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().gtd_step3;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().gtd_step4;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    groupModel = GroupModel();
    groupModel.folder_id = folderId;
    groupModel.title = getI18NKey().gtd_step5;
    groupModel.color = 0xFFF7F2F9;
    list.add(groupModel);
    return list;
  }

  /**
   * 右上角卡片 初始默认值
   */
  static List<ResourceDeliveryInfoBean> getPCRightTopDefaultRessourceData() {
    List<ResourceDeliveryInfoBean> list = [];
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().totalTime,
        isChecked: true,
        resourceContent: getI18NKey().today_duration_completed,
        extendParamsMap: {
          "unit": getI18NKey().mins2,
          "isArrowUp": true,
          "sceneCode": "wholeComepleteTime",
          "value": "0",
          "resourceIconWidgetChecked": Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: 18,
          ),
          "resourceIconWidgetUnChecked": Icon(
            Icons.timer_outlined,
            color: Colors.blue,
            size: 18,
          ),
          'isUp': true,
          'percentGrowth': '0%'
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().tomatoNums,
        isChecked: false,
        resourceContent: getI18NKey().today_tomatoes_completed,
        extendParamsMap: {
          "unit": getI18NKey().unitTomatoes,
          "isArrowUp": false,
          "sceneCode": "tomatoNums",
          "value": "0%",
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcTomatoWhite, size: 15),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: 15),
          'isUp': true,
          'percentGrowth': '0%'
        }));
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().missionNums,
        isChecked: false,
        resourceContent: getI18NKey().today_mission_completed,
        extendParamsMap: {
          "unit": getI18NKey().unitMissions,
          "isArrowUp": false,
          "sceneCode": "missionNums",
          "value": "0%",
          "resourceIconWidgetChecked":
              Utility.getSVGPicture(R.assetsImgIcFolderWhite, size: 18),
          "resourceIconWidgetUnChecked":
              Utility.getSVGPicture(R.assetsImgIcFolder, size: 18),
          'isUp': true,
          'percentGrowth': '0%'
        }));
    return list;
  }

  /**
   * 休息滑动时间
   */
  static List<CheckButtonStateModel> getSliderDialogList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: "50", isCheck: true));
    list.add(CheckButtonStateModel(title: "100", isCheck: false));
    list.add(CheckButtonStateModel(title: "200", isCheck: false));
    list.add(CheckButtonStateModel(title: "500", isCheck: false));
    list.add(CheckButtonStateModel(title: "1000", isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getRepayDialogList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "bank",
        title: getI18NKey().bank,
        isCheck: true,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcBank, size: 14)));
    list.add(CheckButtonStateModel(
        code: "alipay",
        title: getI18NKey().alipay,
        isCheck: false,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcAlipay, size: 14)));
    list.add(CheckButtonStateModel(
        code: "wechat",
        title: getI18NKey().wechat,
        isCheck: false,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcWechat, size: 14)));
    list.add(CheckButtonStateModel(
        code: "cash",
        title: getI18NKey().others,
        isCheck: false,
        checkIcon: Icon(
          Icons.more_horiz,
          size: 14,
        )));

    return list;
  }

  /**
   * 设置金额选择
   */
  static List<CheckButtonStateModel> getSelectMoneyDialogList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: "1", isCheck: true));
    list.add(CheckButtonStateModel(title: "10", isCheck: false));
    list.add(CheckButtonStateModel(title: "100", isCheck: false));
    return list;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getPCDateButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().byday, isCheck: true));
    list.add(CheckButtonStateModel(title: getI18NKey().week, isCheck: false));
    list.add(CheckButtonStateModel(title: getI18NKey().month, isCheck: false));
    if (hasAll == true) {
      list.add(CheckButtonStateModel(title: getI18NKey().all, isCheck: false));
    }
    return list;
  }

  static List<CheckButtonStateModel> getGridAndListCheckList(
      {int defaultCheckedIndex = 0}) {
    double fontSize = 15;
    Color colorChecked = Colors.white;
    Color colorUnchecked = Color(0xff404040);
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "list",
        title: getI18NKey().list,
        isCheck: false,
        uncheckIcon: Icon(
          Icons.list,
          color: ThemeManager.getInstance().getUncheckIconColor(),
          size: fontSize,
        ),
        checkIcon: Icon(
          Icons.list,
          color: colorChecked,
          size: fontSize,
        )));
    list.add(CheckButtonStateModel(
        code: "grid",
        title: getI18NKey().grid,
        isCheck: false,
        uncheckIcon: Icon(
          Icons.grid_view,
          color: ThemeManager.getInstance().getUncheckIconColor(),
          size: fontSize,
        ),
        checkIcon: Icon(
          Icons.grid_view,
          color: colorChecked,
          size: fontSize,
        )));
    list[defaultCheckedIndex].isCheck = true;
    return list;
  }

  static List<CheckButtonStateModel> getWQBButtonsList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "all", title: getI18NKey().all, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "wrong_question_page",
        title: getI18NKey().wrong_question_book,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "card", title: getI18NKey().card, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note", title: getI18NKey().note2, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "memorandum", title: getI18NKey().memorandum, isCheck: false));
    return list;
  }

  /**
   * 导出对话框的选择方式
   */
  static List<CheckButtonStateModel> getTimelineButtonsList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "all", title: getI18NKey().all, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "event", title: getI18NKey().event, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note", title: getI18NKey().note_short, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "diary", title: getI18NKey().diary, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "comsumption", title: getI18NKey().transaction, isCheck: false));
    return list;
  }

  /**
   * 导出对话框的选择方式
   */
  static List<CheckButtonStateModel> getExportButtonsList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "create_time", title: getI18NKey().create_time, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "update_time",
        title: getI18NKey().update_time_last_time,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "end_time", title: getI18NKey().end_time, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "alert_time", title: getI18NKey().alert_time, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "isDelayed", title: getI18NKey().isDelayed, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "title", title: getI18NKey().title, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "priorityStatus", title: getI18NKey().priority, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "tagNames", title: getI18NKey().tagNames, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "no_tomotoes_finished",
        title: getI18NKey().no_tomotoes_finished,
        isCheck: true));
    list.add(CheckButtonStateModel(
        code: "total_tomotoes",
        title: getI18NKey().total_tasks_count,
        isCheck: true));
    list.add(CheckButtonStateModel(
        code: "tomato_duration",
        title: getI18NKey().tomato_duration,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "time_finished",
        title: getI18NKey().time_finished,
        isCheck: true));
    list.add(CheckButtonStateModel(
        code: "isFinished", title: getI18NKey().isFinished, isCheck: true));
    // list.add(CheckButtonStateModel(code: "repetiveType",title: getI18NKey().repetiveType, isCheck: false));
    // list.add(CheckButtonStateModel(code: "repetiveValue",title: getI18NKey().repetiveValue, isCheck: false));
    // list.add(CheckButtonStateModel(code: "repetiveWeekDay",title: getI18NKey().repetiveWeekDay, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "message", title: getI18NKey().message, isCheck: false));
    return list;
  }

  /**
   * 获取StatisTabbar数据
   */
  static List<CheckButtonStateModel> getStatsDateButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().summary, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().ranking, isCheck: false));
    list.add(
        CheckButtonStateModel(title: getI18NKey().analyse, isCheck: false));
    return list;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getTimerContainerButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        title: getI18NKey().four_quadrant, isCheck: true));
    list.add(CheckButtonStateModel(
        title: getI18NKey().count_down_text, isCheck: false));
    list.add(CheckButtonStateModel(
        title: Utility.isHuaWei()
            ? getI18NKey().tasks_list
            : getI18NKey().timeline,
        isCheck: false));
    return list;
  }

  /**
   * 重复时间
   */
  static List<CheckButtonStateModel> getFlomoRepeativeButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "byDay", title: getI18NKey().repeative1, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "byWeek", title: getI18NKey().repeative2, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "byEbbinghaus", title: getI18NKey().repeative3, isCheck: false));
    return list;
  }

  static String getFlomoRepeativeString(int type) {
    switch (type) {
      case 1:
        return getI18NKey().repeative1;
      case 2:
        return getI18NKey().repeative2;
      default:
        return getI18NKey().repeative3;
    }
    return getI18NKey().repeative3;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getcourseButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().free_open, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().private, isCheck: false));
    // list.add(CheckButtonStateModel(title: getI18NKey().sales, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getYesNoButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().yes, isCheck: true));
    list.add(CheckButtonStateModel(title: getI18NKey().no, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getArchivedButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().continuously, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().archived, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getWQBEditTypeModelList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "plain_text", title: getI18NKey().plain_text, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "image", title: getI18NKey().image, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "record", title: getI18NKey().record, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "rich_text", title: getI18NKey().rich_text, isCheck: false));
    return list;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getTimelineButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().calendar, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().calendar2, isCheck: false));
    return list;
  }

  /**
   * 信用卡详情tab数据
   */
  static List<CheckButtonStateModel> getCreditCardDetailButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().bill_detail, isCheck: true));
    list.add(CheckButtonStateModel(
        title: getI18NKey().repayment_record, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getMissionDetailSetting(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        title: getI18NKey().note_and_multimission, isCheck: true));
    // list.add(
    //     CheckButtonStateModel(title: getI18NKey().super_notebook, isCheck: false));
    list.add(CheckButtonStateModel(
        title: getI18NKey().mission_setting, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getLoginRegisterTabBarWidget(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        title: getI18NKey().phoneNo, isCheck: true));
    // list.add(
    //     CheckButtonStateModel(title: getI18NKey().super_notebook, isCheck: false));
    list.add(CheckButtonStateModel(
        title: getI18NKey().email, isCheck: false));
    return list;
  }

  /**
   * 显示/隐藏 button list
   */
  static List<CheckButtonStateModel> getVisibleButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().hidden, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().visible, isCheck: false));
    return list;
  }

  /**
   * 显示/隐藏 button list
   */
  static List<CheckButtonStateModel> getFlomoDurationButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "21", title: getI18NKey().twenty_one_days, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "one_month", title: getI18NKey().one_month, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "three_month", title: getI18NKey().three_months, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "six_month", title: getI18NKey().six_months, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "one_year", title: getI18NKey().one_year, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "customize", title: getI18NKey().customize, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getDoItNowMissionModelsDurationButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "30mins", title: getI18NKey().thirty_mins, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "1hour", title: getI18NKey().one_hour, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "3hours", title: getI18NKey().three_hours, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "6hours", title: getI18NKey().six_hours, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "12hours", title: getI18NKey().twelve_12hours, isCheck: false));
    return list;
  }

  /**
   * 自动切换
   */
  static List<CheckButtonStateModel> getManualOnAndOffButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().manual, isCheck: false));
    list.add(CheckButtonStateModel(title: getI18NKey().auto, isCheck: true));
    return list;
  }

  static List<CheckButtonStateModel> getOnAndOffButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().off, isCheck: true));
    list.add(CheckButtonStateModel(title: getI18NKey().on, isCheck: false));
    return list;
  }

  /**
   * SettingItemDetail页面的自动切换
   */
  static List<CheckButtonStateModel> getSettingItemDetailCheckButtonList(
      {int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        title: getI18NKey().date, isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        title: getI18NKey().time_segment, isCheck: defaultVal == 1));
    return list;
  }

  static List<CheckButtonStateModel> getBGOnAndOffButtonList(
      {int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        title: getI18NKey().manual, isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        title: getI18NKey().auto, isCheck: defaultVal == 1));
    list.add(CheckButtonStateModel(
        title: getI18NKey().pure_mode, isCheck: defaultVal == 2));
    return list;
  }

  /**
   * 未分组
   */
  static List<CheckButtonStateModel> getUnorderGroupHeaderPopup(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;

    list.add(CheckButtonStateModel(
        code: "add_right_column",
        value: 0,
        title: getI18NKey().add_group_on_the_right,
        checkIcon:
            Image.asset(R.assetsImgIcAddColumnRight, width: size, height: size),
        color: 0xff404040,
        content: "",
        isCheck: false));

    return list;
  }

  static List<CheckButtonStateModel> getRatioPopup(
      {double size = 16,
      ProgressSortEnum defaultIndex = ProgressSortEnum.Lyubichs}) {
    List<CheckButtonStateModel> list = [];
    // const double size = 16;
    list.add(CheckButtonStateModel(
        code: "Lyubichs",
        value: 0,
        title: getI18NKey().lyubichs,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcLyubichs, size: 20),
        // color: 0xff404040,
        content: "",
        isCheck: defaultIndex == ProgressSortEnum.Lyubichs));

    list.add(CheckButtonStateModel(
        code: "num_mission",
        value: 0,
        title: getI18NKey().num_mission,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcTotalCheck, size: 15),
        // color: 0xff404040,
        content: "",
        isCheck: defaultIndex == ProgressSortEnum.completeNum));

    list.add(CheckButtonStateModel(
        code: "four_quadrant",
        value: 0,
        title: getI18NKey().four_quadrant,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcFourQuadrant, size: size),
        // color: 0xff404040,
        content: "",
        isCheck: defaultIndex == ProgressSortEnum.priority));

    list.add(CheckButtonStateModel(
        code: "tomato",
        value: 0,
        title: getI18NKey().tomato,
        checkIcon:
            Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: size),
        // color: 0xff404040,
        content: "",
        isCheck: defaultIndex == ProgressSortEnum.tomato));

    // list[defaultIndex].isCheck = true;

    return list;
  }

  static List<CheckButtonStateModel> getGroupHeaderPopup(
      {bool? hasAll = false, bool isFirst = false, bool isLast = false}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;
    // list.add(CheckButtonStateModel(
    //     code: "bg_color",
    //     value: 0,
    //     title: getI18NKey().select_background_color,
    //     checkIcon: Utility.getSVGPicture(R.assetsImgIcColors, size: size),
    //     color: 0xff404040,
    //     content: "",
    //     isCheck: false));

    list.add(CheckButtonStateModel(
        code: "add_left_column",
        value: 0,
        title: getI18NKey().add_group_on_the_left,
        checkIcon:
            Image.asset(R.assetsImgIcAddColumnLeft, width: size, height: size),
        color: 0xff404040,
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "add_right_column",
        value: 0,
        title: getI18NKey().add_group_on_the_right,
        checkIcon:
            Image.asset(R.assetsImgIcAddColumnRight, width: size, height: size),
        color: 0xff404040,
        content: "",
        isCheck: false));
    if (isFirst == false) {
      list.add(CheckButtonStateModel(
          code: "go_to_left",
          value: 0,
          title: getI18NKey().move_to_previous,
          checkIcon:
              Image.asset(R.assetsImgIcPrevious, width: size, height: size),
          color: 0xff404040,
          content: "",
          isCheck: false));
    }
    if (isLast == false) {
      list.add(CheckButtonStateModel(
          code: "go_to_right",
          value: 0,
          title: getI18NKey().move_to_next,
          checkIcon: Image.asset(R.assetsImgIcNext, width: size, height: size),
          color: 0xff404040,
          content: "",
          isCheck: false));
    }
    list.add(CheckButtonStateModel(
        code: "delete",
        value: 0,
        title: getI18NKey().delete,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcDelete, size: size),
        color: 0xff404040,
        content: "",
        isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getFolderModelCheckButtonStateModel(
      {bool isArchived = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: isArchived == false ? "archive" : "unarchive",
        value: 0,
        title:
            isArchived == false ? getI18NKey().archive : getI18NKey().unarchive,
        color: ThemeManager.getInstance()
            .getTextColor(defaultColor: Colors.black)!
            .value,
        checkIcon: isArchived == false
            ? Utility.getSVGPicture(R.assetsImgIcArchive, size: 16)
            : Utility.getSVGPicture(R.assetsImgIcArchive, size: 16),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "delete",
        value: 1,
        title: getI18NKey().delete,
        color: ThemeManager.getInstance()
            .getTextColor(defaultColor: Colors.black)!
            .value,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcDelete, size: 16),
        content: "",
        isCheck: false));

    return list;
  }

  /**
   * 创建者角色的下拉框
   */
  static List<CheckButtonStateModel> getCreatorCheckList(
      {bool isAdministrator = false, bool isSlide = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: isAdministrator
            ? "cancel_setting_administrator"
            : "setting_administrator",
        value: 0,
        color: isAdministrator ? Colors.blue.value : Colors.green.value,
        title: isAdministrator
            ? getI18NKey().cancel_setting_administrator
            : getI18NKey().setting_administrator,
        // color: Colors.green.value,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcAdmin,
            size: 16, color: isSlide ? Colors.white : Colors.blue),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "delete",
        value: 0,
        title: getI18NKey().remove_user,
        color: Colors.red.value,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcRemoveUser,
            size: 16, color: isSlide ? Colors.white : Colors.red),
        content: "",
        isCheck: false));
    return list;
  }

  /**
   * 管理员角色的下拉框
   */
  static List<CheckButtonStateModel> getAdministratorCheckList(
      {bool isAdministrator = false, bool isSlide = false}) {
    List<CheckButtonStateModel> list = [];

    list.add(CheckButtonStateModel(
        code: "delete",
        value: 0,
        title: getI18NKey().remove_user,
        color: Colors.red.value,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcRemoveUser,
            size: 16, color: isSlide ? Colors.white : Colors.red),
        content: "",
        isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getAdminsCheckList(
      {bool isAdministrator = false, bool isSlide = false}) {
    List<CheckButtonStateModel> list = [];

    list.add(CheckButtonStateModel(
        code: "delete",
        value: 0,
        title: getI18NKey().setting_administrator,
        color: Colors.green.value,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcRemoveUser,
            size: 16, color: isSlide ? Colors.white : Colors.green),
        content: "",
        isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getCreditCardList({bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "update",
        value: 0,
        title: getI18NKey().edit,
        color: Colors.green.value,
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "mark_repayment_amount",
        value: 3,
        title: getI18NKey().mark_repayment_amount,
        color: Colors.black.value,
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "delete",
        value: 4,
        title: getI18NKey().delete,
        color: Colors.red.value,
        content: "",
        isCheck: false));
    return list;
  }

  /**
   * 便签popup的按钮
   */
  static List<CheckButtonStateModel> getWQBNoteButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "note1",
        value: 1,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_1,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note2",
        value: 2,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_2,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note3",
        value: 3,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_3,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note4",
        value: 4,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_4,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note5",
        value: 5,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_5,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note6",
        value: 6,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_6,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note7",
        value: 7,
        title: getI18NKey().set_to_desktop_widget + ":" + getI18NKey().note_7,
        content: getI18NKey().content,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "delete",
        title: getI18NKey().delete,
        color: Colors.red.value,
        isCheck: true));
    // list.add(CheckButtonStateModel(code: "2", title: getI18NKey().memorized, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getWQBButtonList({bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "0", title: getI18NKey().not_started, isCheck: true));
    list.add(CheckButtonStateModel(
        code: "1", title: getI18NKey().memorizing, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "2", title: getI18NKey().memorized, isCheck: false));
    return list;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getOnOffButtonList(
      {bool defaultVal = true}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().off, isCheck: !defaultVal));
    list.add(
        CheckButtonStateModel(title: getI18NKey().on, isCheck: defaultVal));
    return list;
  }

  static List<CheckButtonStateModel> getWQBCreateMissionButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "memorandum", title: getI18NKey().memorandum, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "wrong_question_book",
        title: getI18NKey().wrong_question_book,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "note2", title: getI18NKey().note2, isCheck: false));
    list.add(CheckButtonStateModel(
        code: "card", title: getI18NKey().card, isCheck: false));
    return list;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getCompleteButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().finished, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().unfinished, isCheck: false));
    return list;
  }

  /**
   *
   */
  static List<CheckButtonStateModel> getCounterModeButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(
        CheckButtonStateModel(title: getI18NKey().chronograph, isCheck: true));
    list.add(CheckButtonStateModel(title: getI18NKey().timer, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getPriorityButtonList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        title: getI18NKey().four_quadrant_priority1, code: "0", isCheck: true));
    list.add(CheckButtonStateModel(
        title: getI18NKey().four_quadrant_priority2,
        code: "1",
        isCheck: false));
    list.add(CheckButtonStateModel(
        title: getI18NKey().four_quadrant_priority3,
        code: "2",
        isCheck: false));
    list.add(CheckButtonStateModel(
        title: getI18NKey().four_quadrant_priority4,
        code: "3",
        isCheck: false));
    return list;
  }

  /**
   * 获取PC端右上角展示按钮的数据
   */
  static List<CheckButtonStateModel> getCommonCalendarPCDateButtonList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(title: getI18NKey().byday, isCheck: true));
    list.add(
        CheckButtonStateModel(title: getI18NKey().last_7_days, isCheck: true));
    list.add(CheckButtonStateModel(title: getI18NKey().month, isCheck: false));
    list.add(CheckButtonStateModel(title: getI18NKey().year, isCheck: false));
    // if (hasAll == true) {
    list.add(CheckButtonStateModel(title: getI18NKey().all, isCheck: false));
    list.add(CheckButtonStateModel(title: getI18NKey().custom, isCheck: false));
    // }
    return list;
  }

  static List<CheckButtonStateModel> getCreateFolderButtonList(
      {int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 14;
    list.add(CheckButtonStateModel(
        code: 'customized',
        // checkIcon: Utility.getSVGPicture(R.assetsImgIcCustomized, size: size),
        // uncheckIcon: Utility.getSVGPicture(R.assetsImgIcViewListview, size: size),
        title: getI18NKey().customize,
        isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        code: 'pdpa',
        // checkIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        // uncheckIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        title: getI18NKey().pdpa,
        isCheck: defaultVal == 1));

    list.add(CheckButtonStateModel(
        code: 'gtd',
        // checkIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        // uncheckIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        title: getI18NKey().gtd,
        isCheck: defaultVal == 2));

    list.add(CheckButtonStateModel(
        code: 'four_season',
        // checkIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        // uncheckIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        title: getI18NKey().four_seasons,
        isCheck: defaultVal == 3));

    list.add(CheckButtonStateModel(
        code: 'jan_to_dec',
        // checkIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        // uncheckIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        title: getI18NKey().jan_to_dec,
        isCheck: defaultVal == 4));

    list.add(CheckButtonStateModel(
        code: 'micro_mastery',
        title: getI18NKey().micro_mastery,
        isCheck: defaultVal == 5));
    return list;
  }

  static List<CheckButtonStateModel> getChatGptMessageButtonList(
      {int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 14;
    list.add(CheckButtonStateModel(
        code: 'chat',
        checkIcon: Icon(
          Icons.chat,
          size: size,
          color: Colors.white,
        ),
        uncheckIcon: Icon(
          Icons.chat,
          size: size,
          color: ThemeManager.getInstance().isDark()
              ? ThemeManager.getInstance().getDefautThemeColor()
              : Colors.white,
        ),
        title: getI18NKey().chat,
        isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        code: 'create_mission_by_gpt',
        checkIcon: Icon(
          Icons.add_circle,
          size: size,
          color: Colors.white,
        ),
        uncheckIcon: Icon(
          Icons.add_circle,
          size: size,
          color: ThemeManager.getInstance().isDark()
              ? ThemeManager.getInstance().getDefautThemeColor()
              : Colors.white,
        ),
        title: getI18NKey().create_mission_by_gpt,
        list: [
          GptSuggestionBean(
              suggestion: getI18NKey().create_mission_by_gpt,
              suggestionContent: getI18NKey().create_mission_by_content)
        ],
        isCheck: defaultVal == 1));
    list.add(CheckButtonStateModel(
        code: 'search_listing_by_gpt',
        checkIcon: Icon(
          Icons.search,
          size: size,
          color: Colors.white,
        ),
        uncheckIcon: Icon(
          Icons.search,
          size: size,
          color: ThemeManager.getInstance().isDark()
              ? ThemeManager.getInstance().getDefautThemeColor()
              : Colors.white,
        ),
        title: getI18NKey().search_listing_by_gpt,
        list: [
          GptSuggestionBean(
              suggestion: getI18NKey().search_listing_title,
              suggestionContent: getI18NKey().search_listing_content)
        ],
        isCheck: defaultVal == 2));
    list.add(CheckButtonStateModel(
        code: 'search_chart_by_gpt',
        checkIcon: Icon(
          Icons.query_stats,
          size: size,
          color: Colors.white,
        ),
        uncheckIcon: Icon(
          Icons.query_stats,
          size: size,
          color: ThemeManager.getInstance().isDark()
              ? ThemeManager.getInstance().getDefautThemeColor()
              : Colors.white,
        ),
        list: [
          GptSuggestionBean(
              suggestion: getI18NKey().search_chart_title,
              suggestionContent: getI18NKey().search_chart_title_content),
          GptSuggestionBean(
              suggestion: getI18NKey().search_chart_listingtitle,
              suggestionContent:
                  getI18NKey().search_chart_listing_title_content)
        ],
        title: getI18NKey().search_chart_by_gpt,
        isCheck: defaultVal == 2));
    return list;
  }

  static List<CheckButtonStateModel> getEncrypteButtonList(
      {int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 14;
    list.add(CheckButtonStateModel(
        code: 'normal',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcNormal, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcNormal, size: size),
        title: getI18NKey().normal,
        isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        code: 'encrypted',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcSecure, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcSecure, size: size),
        title: getI18NKey().encrypt,
        isCheck: defaultVal == 1));
    return list;
  }

  static List<CheckButtonStateModel> getFolderButtonList({int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 14;
    list.add(CheckButtonStateModel(
        code: 'listing',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcListing, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcListing, size: size),
        title: getI18NKey().listing,
        isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        code: 'folder',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcFolder, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcFolder, size: size),
        title: getI18NKey().folder,
        isCheck: defaultVal == 1));
    list.add(CheckButtonStateModel(
        code: 'group',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcAddFriend, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcAddFriend, size: size),
        title: getI18NKey().add_group_listing,
        isCheck: defaultVal == 1));
    return list;
  }

  static List<CheckButtonStateModel> getViewsButtonList({int defaultVal = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 14;
    list.add(CheckButtonStateModel(
        code: 'listview',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcViewListview, size: size),
        uncheckIcon:
            Utility.getSVGPicture(R.assetsImgIcViewListview, size: size),
        title: getI18NKey().listview,
        isCheck: defaultVal == 0));
    list.add(CheckButtonStateModel(
        code: 'group',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcViewColumn, size: size),
        title: getI18NKey().groupview,
        isCheck: defaultVal == 1));
    list.add(CheckButtonStateModel(
        code: 'timeline',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcViewTimeline, size: size),
        uncheckIcon:
            Utility.getSVGPicture(R.assetsImgIcViewTimeline, size: size),
        title: getI18NKey().timelineview,
        isCheck: defaultVal == 2));
    return list;
  }

  static List<CheckButtonStateModel> getMissionDetailSettingButtonList() {
    List<CheckButtonStateModel> list = [];

    list.add(CheckButtonStateModel(
        code: 'screen_rorate',
        checkIconUrl: R.assetsImgIcScreenrotation,
        uncheckIconUrl: R.assetsImgIcScreenrotation,
        title: getI18NKey().screen_rorate,
        isCheck: true));
    list.add(CheckButtonStateModel(
        code: 'background',
        checkIconUrl: R.assetsImgIcBackground,
        uncheckIconUrl: R.assetsImgIcBackground,
        title: getI18NKey().background_setting,
        isCheck: true));
    list.add(CheckButtonStateModel(
        code: 'focus_duration',
        checkIconUrl: R.assetsImgIcFocus,
        uncheckIconUrl: R.assetsImgIcFocus,
        title: getI18NKey().focus_duration,
        isCheck: true));
    // list.add(CheckButtonStateModel(code: 'music', checkIconUrl: R.assetsImgIcMusic, uncheckIconUrl: R.assetsImgIcMusic, title: getI18NKey().account, isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'rest_duration',
        checkIconUrl: R.assetsImgIcRest,
        uncheckIconUrl: R.assetsImgIcRest,
        title: getI18NKey().rest_duration,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'music',
        checkIconUrl: R.assetsImgIcMusic,
        uncheckIconUrl: R.assetsImgIcMusic,
        title: getI18NKey().music,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'volume',
        checkIconUrl: R.assetsImgIcVolume,
        uncheckIconUrl: R.assetsImgIcVolume,
        title: getI18NKey().volume,
        isCheck: false));
    bool isOn = SharePreferenceUtil.getSyncInstance().getLoopOnRelaxing();
    list.add(CheckButtonStateModel(
        code: 'auto_next',
        checkIconUrl: R.assetsImgIcAutorenew,
        uncheckIconUrl: R.assetsImgIcAutorenewOne,
        title: getI18NKey().loop_setting,
        isCheck: false));
    // list.add(CheckButtonStateModel(code: 'info', checkIconUrl: R.assetsImgIcInformation, uncheckIconUrl: R.assetsImgIcMusic, title: getI18NKey().about, isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getPCSettingButtonList() {
    List<CheckButtonStateModel> list = [];
    const double size = 30;
    list.add(CheckButtonStateModel(
        code: 'clock',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcFunction, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcFunction, size: size),
        // checkIconUrl: R.assetsImgIcClock,
        // uncheckIconUrl: R.assetsImgIcClock,
        title: getI18NKey().tomatoClock,
        isCheck: true));
    list.add(CheckButtonStateModel(
        code: 'theme',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcTheme, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcTheme, size: size),
        // checkIconUrl: R.assetsImgIcTheme,
        // uncheckIconUrl: R.assetsImgIcTheme,
        title: getI18NKey().theme,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'feedback',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcFeedback, size: size - 8),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcFeedback,
            size: size - 8, color: Color(0xffa0a0a0)),
        // checkIconUrl: R.assetsImgIcFeedback,
        // uncheckIconUrl: R.assetsImgIcFeedback,
        title: getI18NKey().feedback,
        isCheck: false));
    // list.add(CheckButtonStateModel(code: 'music', checkIconUrl: R.ic_music, uncheckIconUrl: R.ic_music, title: getI18NKey().account, isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'account',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcAccount, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcAccount,
            size: size, color: Color(0xffa0a0a0)),
        // checkIconUrl: R.assetsImgIcAccount,
        // uncheckIconUrl: R.assetsImgIcAccount,
        title: getI18NKey().account,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'permission',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcPermission, size: size),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcPermission,
            size: size, color: Color(0xffa0a0a0)),
        // checkIconUrl: R.assetsImgIcPermission,
        // uncheckIconUrl: R.assetsImgIcPermission,
        title: getI18NKey().permission_setting,
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: 'privacy',
        checkIcon: Utility.getSVGPicture(R.assetsImgIcPrivacy,
            size: size + 10,
            color: ThemeManager.getInstance().getDefautThemeColor()),
        uncheckIcon: Utility.getSVGPicture(R.assetsImgIcPrivacy,
            size: size + 10, color: Color(0xffa0a0a0)),
        // checkIconUrl: R.assetsImgIcPrivacy,
        // uncheckIconUrl: R.assetsImgIcPrivacy,
        title: getI18NKey().privacy,
        isCheck: false));
    // list.add(CheckButtonStateModel(code: 'info', checkIconUrl: R.assetsImgIcInformation, uncheckIconUrl: R.ic_music, title: getI18NKey().about, isCheck: false));
    return list;
  }

  static int getTimelineColorBySceneWithTimelineModeEnum(
      {TimelineModeEnum? timelineModeEnum}) {
    int color = Colors.lime.value;
    switch (timelineModeEnum) {
      case TimelineModeEnum.event:
        return Colors.greenAccent.value;
      case TimelineModeEnum.transaction:
        return 0xffff8800;
      case TimelineModeEnum.note:
        return Colors.grey.value;
      case TimelineModeEnum.diary:
        return Colors.blueAccent.value;
    }
    return color;
  }

  static int getTimelineColorByScene({String? scene}) {
    int color = 0xffff8800;
    switch (scene) {
      case 'mission':
        return Colors.greenAccent.value;
      case 'transaction':
        return 0xffff8800;
      case 'note':
        return Colors.grey.value;
      case 'diary':
        return Colors.blueAccent.value;
    }
    return color;
  }

  static String getTimelineTypeTextByScene({required String scene}) {
    switch (scene) {
      case 'mission':
        return getI18NKey().event;
      case 'transaction':
        return getI18NKey().transaction;
      case 'note':
        return getI18NKey().note_short;
      case 'diary':
        return getI18NKey().diary;
    }
    return '';
  }

  static Widget getFlomoEmoji({sceneCode: "score_6", double iconSize: 16}) {
    if (sceneCode == "score_6") {
      return Image.asset(R.assetsImgIcEmoji6,
          fit: BoxFit.fill, width: iconSize, height: iconSize);
    } else if (sceneCode == "score_5") {
      return Image.asset(R.assetsImgIcEmoji5,
          fit: BoxFit.fill, width: iconSize, height: iconSize);
    } else if (sceneCode == "score_4") {
      return Image.asset(R.assetsImgIcEmoji4,
          fit: BoxFit.fill, width: iconSize, height: iconSize);
    } else if (sceneCode == "score_3") {
      return Image.asset(R.assetsImgIcEmoji3,
          fit: BoxFit.fill, width: iconSize, height: iconSize);
    } else if (sceneCode == "score_2") {
      return Image.asset(R.assetsImgIcEmoji2,
          fit: BoxFit.fill, width: iconSize, height: iconSize);
    } else {
      return Image.asset(R.assetsImgIcEmoji1,
          fit: BoxFit.fill, width: iconSize, height: iconSize);
    }
  }

  static List getEmojiList() {
    double size = 45;
    List list = [];
    list.add({
      'sceneCode': 'score_6',
      'icon': Image.asset(R.assetsImgIcEmoji6Unselected,
          fit: BoxFit.fill, width: size, height: size),
      'iconChecked': Image.asset(R.assetsImgIcEmoji6,
          fit: BoxFit.fill, width: size, height: size),
      'title': "",
      'isChecked': false
    });

    list.add({
      'sceneCode': 'score_5',
      'icon': Image.asset(R.assetsImgIcEmoji5Unselected,
          fit: BoxFit.fill, width: size, height: size),
      'iconChecked': Image.asset(R.assetsImgIcEmoji5,
          fit: BoxFit.fill, width: size, height: size),
      'title': "",
      'isChecked': false
    });

    list.add({
      'sceneCode': 'score_4',
      'icon': Image.asset(R.assetsImgIcEmoji4Unselected,
          fit: BoxFit.fill, width: size, height: size),
      'iconChecked': Image.asset(R.assetsImgIcEmoji4,
          fit: BoxFit.fill, width: size, height: size),
      'title': "",
      'isChecked': false
    });

    list.add({
      'sceneCode': 'score_3',
      'icon': Image.asset(R.assetsImgIcEmoji3Unselected,
          fit: BoxFit.fill, width: size, height: size),
      'iconChecked': Image.asset(R.assetsImgIcEmoji3,
          fit: BoxFit.fill, width: size, height: size),
      'title': "",
      'isChecked': false
    });

    list.add({
      'sceneCode': 'score_2',
      'icon': Image.asset(R.assetsImgIcEmoji2Unselected,
          fit: BoxFit.fill, width: size, height: size),
      'iconChecked': Image.asset(R.assetsImgIcEmoji2,
          fit: BoxFit.fill, width: size, height: size),
      'title': "",
      'isChecked': false
    });

    list.add({
      'sceneCode': 'score_1',
      'icon': Image.asset(R.assetsImgIcEmoji1Unselected,
          fit: BoxFit.fill, width: size, height: size),
      'iconChecked': Image.asset(R.assetsImgIcEmoji1,
          fit: BoxFit.fill, width: size, height: size),
      'title': "",
      'isChecked': true
    });
    return list;
  }

  /**
   * PC桌面菜单栏
   */
  static List getLeftDesktopMenubar({required SettingModel settingModel}) {
    List list = [];
    if (settingModel.isTomatoPageOn == 1)
      list.add({
        'sceneCode': 'TomatoPage',
        'icon': Utility.getSVGPicture(R.assetsImgIcTomatoWhite,
            size: 20, color: Colors.white),
        'iconChecked':
            Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: 20),
        'title': getI18NKey().tomatoClock
      });
    if (settingModel.isTimeManagementPageOn == 1)
      list.add({
        'sceneCode': 'TimeManagementPage',
        'icon': Utility.getSVGPicture(R.assetsImgIcTimeManagement, size: 20),
        'iconChecked': Utility.getSVGPicture(
            R.assetsImgIcTimeManagementSelected,
            size: 20),
        'title': getI18NKey().calendar2
      });
    if (settingModel.isCalendarContainerPageOn == 1)
      list.add({
        'sceneCode': 'CalendarContainerPage',
        'icon': Icon(
          Icons.date_range,
          size: 20,
          color: Colors.white,
        ),
        'iconChecked': Icon(
          Icons.date_range,
          size: 20,
          color: Colors.green,
        ),
        'title': getI18NKey().schedule
      });
    if (settingModel.isFourQuadrantPageOn == 1)
      list.add({
        'sceneCode': 'FourQuadrantPage',
        'icon': Image(
          width: 20,
          height: 20,
          image: AssetImage(R.assetsImgIcFourQuadrantWhite),
          fit: BoxFit.cover,
        ),
        'iconChecked': Image(
          width: 20,
          height: 20,
          image: AssetImage(R.assetsImgIcFourQuadrant),
          fit: BoxFit.cover,
        ),
        'title': getI18NKey().four_quadrant
      });
    if (settingModel.isTimelinePageOn == 1)
      list.add({
        'sceneCode': 'TimelinePage',
        'icon': Utility.getSVGPicture(R.assetsImgIcTimelineUnclicked, size: 20),
        'iconChecked':
            Utility.getSVGPicture(R.assetsImgIcTimelineClicked, size: 20),
        'title': getI18NKey().timeline
      });
    if (settingModel.isClockInPCPageOn == 1)
      list.add({
        'sceneCode': 'ClockInPCPage',
        'icon': Utility.getSVGPicture(R.assetsImgIcClockinUnselected,
            size: 20, color: Colors.white),
        'iconChecked':
            Utility.getSVGPicture(R.assetsImgIcClockinSelected, size: 20),
        'title': getI18NKey().clock_in
      });
    // if (!Utility.isProductEnv()) {
    if (settingModel.isWQBContainerOn == 1)
      list.add({
        'sceneCode': 'WQBContainer',
        'icon': Icon(
          Icons.book,
          size: 20,
          color: Colors.white,
        ),
        'iconChecked': Icon(
          Icons.book,
          size: 20,
          color: Colors.purpleAccent,
        ),
        'title': getI18NKey().super_notebook
      });
    // }

    if (settingModel.isCountDownListViewPageOn == 1)
      list.add({
        'sceneCode': 'CountDownListViewPage',
        'icon': Utility.getSVGPicture(R.assetsImgIcCountdownTimer, size: 20),
        'iconChecked': Utility.getSVGPicture(
            R.assetsImgIcCountdownTimerSelected,
            size: 20),
        'title': getI18NKey().count_down_text
      });
    if (settingModel.isGamePageOn == 1)
      list.add({
        'sceneCode': 'GamePage',
        'icon': Icon(
          Icons.filter_center_focus,
          size: 20,
          color: Colors.white,
        ),
        'iconChecked': Icon(
          Icons.filter_center_focus,
          size: 20,
          color: Color(0xffff8800),
        ),
        'title': getI18NKey().practice
      });
    // list.add({
    //   'sceneCode': 'CreditCardPage',
    //   'icon': Container(
    //     width: 20,
    //     height: 20,
    //     child: Utility.getSVGPicture(R.assetsImgIcCreditCard, size: 15),
    //   ),
    //   'iconChecked': Container(
    //     width: 20,
    //     height: 20,
    //     decoration:
    //         BoxDecoration(color: Colors.purpleAccent, shape: BoxShape.circle),
    //     child: Utility.getSVGPicture(R.assetsImgIcCreditCard, size: 15),
    //   ),
    //   'title': getI18NKey().credit_bag
    // });

    if (MongoApisManager.getInstance().listCourseModel.length > 0) {
      list.add({
        'sceneCode': 'CoursePage',
        'icon': Utility.getSVGPicture(R.assetsImgIcCourse, size: 20),
        'iconChecked':
            Utility.getSVGPicture(R.assetsImgIcCourseSelected, size: 20),
        'title': getI18NKey().course
      });
    }
    if (Utility.isIOS()) {
      list.add({
        'sceneCode': 'LockScreenPage',
        'icon': Utility.getSVGPicture(R.assetsImgIcLockscreenView, size: 20),
        'iconChecked':
            Utility.getSVGPicture(R.assetsImgIcLockscreenSelected, size: 20),
        'title': getI18NKey().lock_app
      });
    }
    // if (LoginManager.getInstance().isLogin2() && Utility.isChina() == false) {
    //   list.add({
    //     'sceneCode': 'ChatGptPage',
    //     'icon': Container(
    //       width: 35,
    //       height: 35,
    //       margin: EdgeInsets.symmetric(horizontal: 12),
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //           color: Color(0xff74ab9d),
    //           border: Border.all(width: 2, color: Color(0xff74ab9d)),
    //           borderRadius: BorderRadius.circular(40)),
    //       child: Text(
    //         getI18NKey().chatgpt,
    //         style: TextStyle(fontSize: 12, color: Colors.white),
    //       ),
    //     ),
    //     'iconChecked': Container(
    //       width: 35,
    //       height: 35,
    //       margin: EdgeInsets.symmetric(horizontal: 12),
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //           color: Colors.red, borderRadius: BorderRadius.circular(40)),
    //       child: Text(
    //         getI18NKey().chatgpt,
    //         style: TextStyle(fontSize: 12, color: Colors.white),
    //       ),
    //     ),
    //     'title': getI18NKey().chatgpt
    //   });
    // }
    if (settingModel.isStatisticPageOn == 1)
      list.add({
        'sceneCode': 'StatisticPage',
        'icon': Icon(
          Icons.show_chart,
          size: 20,
          color: Colors.white,
        ),
        'iconChecked': Icon(
          Icons.show_chart,
          size: 20,
          color: Colors.purpleAccent,
        ),
        'title': getI18NKey().analytics
      });
    if (settingModel.isAIHelperPageOn == 1)
      list.add({
        'sceneCode': 'AIHelper',
        'icon': Utility.getSVGPicture(R.assetsImgIcAiHelper, size: 20),
        'iconChecked': Utility.getSVGPicture(R.assetsImgIcAiHelper, size: 20),
        'title': getI18NKey().ai_helper
      });
    if (settingModel.isSettingPageOn == 1)
      list.add({
        'sceneCode': 'SettingPage',
        'icon': Icon(
          Icons.settings,
          size: 20,
          color: Colors.white,
        ),
        'iconChecked': Icon(
          Icons.settings,
          size: 20,
          color: Colors.grey,
        ),
        'title': getI18NKey().setting
      });
    return list;
  }

  static List<SheetDataModel> getShareModels() {
    double size = 30;
    List<SheetDataModel> list = [];
    list.add(SheetDataModel(
        index: 0,
        title: getI18NKey().qq_share,
        icon: Utility.getSVGPicture(R.assetsImgIcQq, size: size),
        data: 0)); // 0 今天 1 明天 2 7天后 3待定
    list.add(SheetDataModel(
        index: 1,
        title: getI18NKey().wechat_share,
        icon: Utility.getSVGPicture(R.assetsImgIcWechat, size: size),
        data: 1));
    return list;
  }

  // static List<SheetDataModel> getDateModels() {
  //   double size = 30;
  //   List<SheetDataModel> list = [];
  //   list.add(SheetDataModel(
  //       index: 0,
  //       title: getI18NKey().today,
  //       icon: Utility.getSVGPicture(R.assetsImgIcToday, size: size),
  //       data: 0)); // 0 今天 1 明天 2 7天后 3待定
  //   list.add(SheetDataModel(
  //       index: 1,
  //       title: getI18NKey().tomorrow,
  //       icon: Utility.getSVGPicture(R.assetsImgIcTomorrow, size: size),
  //       data: 1));
  //   list.add(SheetDataModel(
  //       index: 2,
  //       title: getI18NKey().inSevenDays,
  //       icon: Utility.getSVGPicture(R.assetsImgIcThisWeek, size: size),
  //       data: 2));
  //   list.add(SheetDataModel(
  //       index: 3,
  //       title: getI18NKey().allUnfinishedMissions,
  //       icon: Utility.getSVGPicture(R.assetsImgIcUnfinishMissions, size: size),
  //       data: 3));
  //   list.add(SheetDataModel( //代办清单
  //       index: 4,
  //       title: getI18NKey().todo_listing,
  //       icon: Utility.getSVGPicture(R.assetsImgIcTodo, size: size),
  //       data: 4));
  //   list.add(SheetDataModel( //碎片清单
  //       index: 5,
  //       title: getI18NKey().fragment_listing,
  //       icon: Utility.getSVGPicture(R.assetsImgIcFragment, size: size),
  //       data: 5));
  //   return list;
  // }

  static List<SheetDataModel> getPCFolderListEditDialogModels() {
    List<SheetDataModel> list = [];
    list.add(SheetDataModel(
        index: 0,
        scene: 'edit',
        title: getI18NKey().edit,
        icon: Icon(
          Icons.edit,
          size: 30,
          color: Colors.blue,
        ),
        data: 0)); // 0 今天 1 明天 2 7天后 3待定
    list.add(SheetDataModel(
        index: 1,
        scene: 'delete',
        title: getI18NKey().delete,
        icon: Icon(Icons.delete_outline, size: 30, color: Colors.red),
        data: 1));
    return list;
  }

  //3 无优先级  2 低优先级 1 中优先级 0 高优先级
  static String getPriorityByIndex(int priority) {
    switch (priority) {
      case 0:
        return getI18NKey().priority1;
      case 1:
        return getI18NKey().priority2;
      case 2:
        return getI18NKey().priority3;
      case 3:
        return getI18NKey().priority4;
    }
    return '';
  }

  static int getPriorityColor(int priorityIndex) {
    if (priorityIndex == 0) {
      return 0xffdc281e;
    } else if (priorityIndex == 1) {
      return 0xffed8f03;
    } else if (priorityIndex == 2) {
      return 0xff2193b0;
    } else if (priorityIndex == 3) {
      return 0xff799f0c;
    }
    return 0xffff8800;
  }

  static List<SheetDataModel> getPriorityModels({double iconSize = 30}) {
    List<SheetDataModel> list = [];
    list.add(SheetDataModel(
        index: 0,
        title: getI18NKey().priority1 +
            "(" +
            getI18NKey().four_quadrant_priority1 +
            ")",
        desc: getI18NKey().four_quadrant_priority1_desc,
        icon: Icon(
          Icons.golf_course,
          size: iconSize,
          color: Color(0xffdc281e),
        ),
        data: 0)); // 0 今天 1 明天 2 7天后 3待定
    list.add(SheetDataModel(
        index: 1,
        title: getI18NKey().priority2 +
            "(" +
            getI18NKey().four_quadrant_priority2 +
            ")",
        desc: getI18NKey().four_quadrant_priority2_desc,
        icon: Icon(Icons.golf_course, size: iconSize, color: Color(0xffed8f03)),
        data: 1));
    list.add(SheetDataModel(
        index: 2,
        title: getI18NKey().priority3 +
            "(" +
            getI18NKey().four_quadrant_priority3 +
            ")",
        desc: getI18NKey().four_quadrant_priority3_desc,
        icon: Icon(Icons.golf_course, size: iconSize, color: Color(0xff2193b0)),
        data: 2));
    list.add(SheetDataModel(
        index: 3,
        title: getI18NKey().priority4 +
            "(" +
            getI18NKey().four_quadrant_priority4 +
            ")",
        desc: getI18NKey().four_quadrant_priority4_desc,
        icon: Icon(Icons.golf_course, size: iconSize, color: Color(0xff799f0c)),
        data: 3));
    return list;
  }

  static List<CheckModel> getTomatoesTabbar() {
    List<CheckModel> list = [];
    list.add(CheckModel(
        index: 0, title: getI18NKey().previewTomatoesNum, isChecked: true));
    list.add(CheckModel(
        index: 1, title: getI18NKey().tomatoesDuration, isChecked: false));
    return list;
  }

  /**
   * 一天天的生成艾宾浩斯记忆方法的日期
   */
  static List<DateTime?> generateEbbinghausDatesWithEmptyDayByDay(
      DateTime startDate, int days) {
    List<DateTime?> dates = List<DateTime?>.filled(days, null);
    List<int> ebbinghausIntervals = [1, 2, 4, 7, 15]; // 艾宾浩斯记忆法的复习间隔

    for (int interval in ebbinghausIntervals) {
      for (int i = 0; i < days; i += interval) {
        if (i < days) {
          dates[i] = startDate.add(Duration(days: i));
        }
      }
    }

    return dates;
  }

  /**
   * 一天天的生成艾宾浩斯记忆方法的日期
   */
  static List<DateTime?> generateEbbinghausDatesByDayByDay(
      DateTime startDate, DateTime endTime) {
    List<DateTime> dates = generateEbbinghausDatesByEndTime(startDate, endTime);
    if (dates.length == 0) {
      return [];
    }
    int numDays = dates[dates.length - 1].difference(startDate).inDays + 1;
    List<DateTime?> ebbinghausDates = List<DateTime?>.filled(numDays, null);
    for (int i = 0; i < dates.length; i++) {
      // 这里你可以添加你的逻辑来决定是否要添加日期
      int day = dates[i].difference(startDate).inDays;
      ebbinghausDates[day] = dates[i];
    }
    return ebbinghausDates;
  }

  static List<DateTime> generateEbbinghausDatesByEndTime(
      DateTime startDate, DateTime endTime) {
    List<DateTime> dates = [];
    int i = 0;
    while (true) {
      startDate = startDate.add(Duration(days: i));
      if (startDate.isAfter(endTime)) {
        break;
      }
      dates.add(startDate);
      i++;
    }
    return dates;
  }

  //艾宾浩斯记忆方法生成的datetime
  static List<DateTime> generateEbbinghausDatesByTimes(
      DateTime startDate, int times) {
    List<DateTime> dates = [];
    for (int i = 0; i < times; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  // 假如这个艾宾浩斯记忆方法知道开始时间是 yy-mm-dd 00:00:00 的datetime 开始计算
  // 提供给我一个现在的时间是否是在
  // 艾宾浩斯记忆方法生成的datetime的范围里
  static bool isCurrentDateInEbbinghausRange(
      DateTime startDate, DateTime endDate, DateTime currentDate) {
    List<DateTime> ebbinghausDates =
        generateEbbinghausDatesByEndTime(startDate, endDate);
    // DateTime minDate = ebbinghausDates.first;
    // DateTime maxDate = ebbinghausDates.last;
    for (int i = 0; i < ebbinghausDates.length; i++) {
      DateTime dateTime = ebbinghausDates[i];
      if (currentDate.isAtSameMomentAs(
          DateTime(dateTime.year, dateTime.month, dateTime.day))) {
        return true;
      }
    }
    return false;
    // bool res = (currentDate.isAtSameMomentAs(minDate) || currentDate.isAfter(minDate)) && (currentDate.isAtSameMomentAs(maxDate) || currentDate.isBefore(maxDate));
    // if(res == true) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  static List<CheckModel> getWeekendCheckModels(
      {List<dynamic>? defaultChecked}) {
    if (defaultChecked == null) {
      defaultChecked = [false, false, false, false, false, false, false];
    }
    List<CheckModel> list = [];
    list.add(CheckModel(
        index: 0,
        title: getI18NKey().mondayShort,
        isChecked: defaultChecked[0]));
    list.add(CheckModel(
        index: 1,
        title: getI18NKey().tuesdayShort,
        isChecked: defaultChecked[1]));
    list.add(CheckModel(
        index: 2,
        title: getI18NKey().wednesdayShort,
        isChecked: defaultChecked[2]));
    list.add(CheckModel(
        index: 3,
        title: getI18NKey().thursdayShort,
        isChecked: defaultChecked[3]));
    list.add(CheckModel(
        index: 4,
        title: getI18NKey().fridayShort,
        isChecked: defaultChecked[4]));
    list.add(CheckModel(
        index: 5,
        title: getI18NKey().saturdayShort,
        isChecked: defaultChecked[5]));
    list.add(CheckModel(
        index: 6,
        title: getI18NKey().sundayShort,
        isChecked: defaultChecked[6]));
    return list;
  }

  static int getTomatoDuration() {
    return 25 * 60 * 1000;
  }

  static List<ColorsModel> getThemes() {
    List<ColorsModel> listColorsModel = [];
    ColorsModel colorsModel = new ColorsModel();
    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff0f0f0;
    colorsModel.code = "light";
    colorsModel.title = getI18NKey().light_mode;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff424242;
    colorsModel.code = "dark";
    colorsModel.title = getI18NKey().dark_mode;
    listColorsModel.add(colorsModel);

    return listColorsModel;
  }

  static List<ColorsModel> getThemeColors() {
    List<ColorsModel> listColorsModel = [];
    ColorsModel colorsModel = new ColorsModel();
    colorsModel = new ColorsModel();
    colorsModel.color = ColorsConfig.color_background_menu.value;
    listColorsModel.add(colorsModel);

    //  colorsModel = new ColorsModel();
    // colorsModel = new ColorsModel();
    // colorsModel.color = 0xffd9fcd1;
    // listColorsModel.add(colorsModel);

    // colorsModel = new ColorsModel();
    // colorsModel.color = 0xffd1e8fc;
    // listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffe1ccff;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff8c7c7;
    listColorsModel.add(colorsModel);

    // colorsModel.color = 0xffed7573;
    // listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff1a068;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff1bf6b;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffc9e478;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff7bd497;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffff88ff;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff6083f6;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffc9a9ff;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfffd9fb3;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff82f3e1;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffd6bb51;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff91cd7e;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfffbde6a;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfffad4c1;
    listColorsModel.add(colorsModel);

    // colorsModel = new ColorsModel();
    // colorsModel.color = 0xff424242;
    // listColorsModel.add(colorsModel);

    // colorsModel = new ColorsModel();
    // colorsModel.color = 0xff424242;
    // listColorsModel.add(colorsModel);

    return listColorsModel;
  }

  static List<ColorsModel> getColors() {
    List<ColorsModel> listColorsModel = [];
    ColorsModel colorsModel = new ColorsModel();

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfffff2b1;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff7d889;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffd9fcd1;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffd1e8fc;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffe1ccff;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff8c7c7;
    listColorsModel.add(colorsModel);

    colorsModel.color = 0xffed7573;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff1a068;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xfff1bf6b;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffc9e478;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff7bd497;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xffff88ff;
    listColorsModel.add(colorsModel);

    colorsModel = new ColorsModel();
    colorsModel.color = 0xff6083f6;
    listColorsModel.add(colorsModel);

    return listColorsModel;
  }

  static int getSelectIconIndex(int iconPoint) {
    // int index = 0;
    List<SelectObjectTypeModel> list = CONSTANTS.getSelectIcons();
    for (int i = 0; i < list.length; i++) {
      if (list[i].icon?.codePoint == iconPoint) {
        // index = i;
        return i;
      }
    }
    return 0;

    // CONSTANTS.getSelectIcons().forEach((element) {
    //   if (element.icon == CONSTANTS.getIcon()) {
    //     return CONSTANTS.getSelectIcons().indexOf(element);
    //   }
    // });
  }

  static List<SelectObjectTypeModel> getSelectIcons() {
    List<SelectObjectTypeModel> listSelectObjectTypeModel = [];
    SelectObjectTypeModel selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xffb4b6b9;
    selectObjectTypeModel.icon = Icons.circle;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xffb4b6b9;
    selectObjectTypeModel.icon = Icons.timer;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.alarm_add;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.flight;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.fitness_center;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.directions_car_sharp;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.public;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.share;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.engineering;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.shopping_bag;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.work_outline;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.local_mall;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.business_center;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.directions_run;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.directions_walk;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.brunch_dining;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.alarm_add;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.self_improvement;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.shopping_bag;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.loyalty;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.tour;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.shop;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.turned_in;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.anchor;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.notifications_active;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.whatshot;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_baseball_outlined;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.king_bed;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_football;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_golf;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_soccer;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_volleyball;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_tennis;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_volleyball_outlined;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_esports_outlined;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_handball_outlined;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    //1111111111111

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.deck;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.icecream;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.edit;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.auto_stories;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.palette;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.wb_sunny;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.local_airport;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.local_taxi;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.train;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.airline_seat_flat;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.laptop;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.keyboard;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.phone_android;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.headset;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.airplanemode_active;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.note;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.hotel;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.fastfood;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.miscellaneous_services;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.place;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.local_shipping;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.anchor;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.notifications_active;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.whatshot;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.sports_baseball_outlined;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    selectObjectTypeModel = new SelectObjectTypeModel();
    selectObjectTypeModel.color = 0xfff1a068;
    selectObjectTypeModel.icon = Icons.restaurant;
    listSelectObjectTypeModel.add(selectObjectTypeModel);

    return listSelectObjectTypeModel;
  }

  // 根据iconcType 1-今天 2 明天 3 本周 - end_time为今天 4 待定 5 日程 5 已完成
  static int? getDeadLineTme(int folderStatus) {
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    switch (folderStatus) {
      case 0: //0是 文件夹
        return Utility.getFilterDateTimeFromTimeStamp(nowTime)
            .millisecondsSinceEpoch;
      case 1:
        return Utility.getFilterDateTimeFromTimeStamp(nowTime)
            .millisecondsSinceEpoch;
      case 2:
        return Utility.getFilterDateTimeFromTimeStamp(
                nowTime + 24 * 60 * 60 * 1000)
            .millisecondsSinceEpoch;
      case 3:
        return Utility.getFilterDateTimeFromTimeStamp(nowTime)
            .millisecondsSinceEpoch;
      default:
        return Utility.getTimeStampToday();
    }
  }

  static List<DayModel> getDayModelList(CalendarModel? calendarModel,
      {DateTime? startDateTime, required DateTime endDateTime}) {
    List<DayModel> list = calendarModel?.dayModelList ?? [];
    List<DayModel> listDayModel = [];
    for (DayModel dayModel in list) {
      // if (dayModel.dateTime?.year == 2023 &&
      //     dayModel.dateTime?.month == 6 &&
      //     dayModel.dateTime?.day == 22) {
      //   print(111);
      // }
      // if((dayModel.missionModelList?.length ?? 0)> 3) {
      //   print(222);
      // }
      if (startDateTime == null) {
        if (dayModel.dateTime != null &&
            endDateTime.isAfter(dayModel.dateTime!) == true) {
          listDayModel.add(dayModel);
        }
      } else {
        if ((dayModel.dateTime!.isAfter(startDateTime) == true ||
                dayModel.dateTime!.isAtSameMomentAs(startDateTime) == true) &&
            (dayModel.dateTime!.isBefore(endDateTime) == true ||
                dayModel.dateTime!.isAtSameMomentAs(endDateTime) == true)) {
          {
            listDayModel.add(dayModel);
          }
        }
      }
    }
    return listDayModel;
  }

  /**
   * 从daymodel得到MissionModel
   */
  static List<MissionModel> getMissionModelFromDayModel(List<DayModel> list,
      {bool shouldRequireIsNotFinished = false}) {
    List<MissionModel> listMissionModel = [];
    DateTime nowDateTime = DateTime.now();
    DateTime todayDateTime =
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day);

    for (DayModel dayModel in list) {
      for (MissionModel missionModel in dayModel.missionModelList) {
        if (listMissionModel.indexOf(missionModel) == -1) {
          // 如果需要未完成的任务
          if (shouldRequireIsNotFinished == true) {
            if (missionModel.isFinished == false) {
              listMissionModel.add(missionModel);
            } else if (missionModel.isFinished == true) {
              DateTime dateTimeMissionModel =
                  Utility.getDateTimeFromDateTimeString(
                      missionModel.updatedAt ?? "");
              if (dateTimeMissionModel.isBefore(todayDateTime) == false) {
                // 今天之前都允许添加
                listMissionModel.add(missionModel);
              }
            }
          } else {
            listMissionModel.add(missionModel);
          }

          // listMissionModel.add(missionModel);
        }
      }
    }
    return listMissionModel;
  }

  /**
   * 系统消息加上中国特殊处理
   */
  static String getSystemMessage(String systemMessage) {
    return systemMessage + "-" + getI18NKey().gpt_system_msg_forbidden;
  }

  /**
   * 从daymodel得到MissionModel
   */
  static List<WQBMissionModel> getWQBMissionModelFromDayModel(
      List<DayModel> list) {
    List<WQBMissionModel> listMissionModel = [];
    for (DayModel dayModel in list) {
      for (WQBMissionModel missionModel in dayModel.wqbmissionModelList) {
        if (listMissionModel.indexOf(missionModel) == -1) {
          listMissionModel.add(missionModel);
        }
      }
    }
    return listMissionModel;
  }

  // 0-就是自己创建的FolderModel  1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他 9 所有
  static FolderTimeModel getWQBFolderTime(
      {required int folderStatus,
      CalendarModel? calendarModel,
      DateTime? startDateTime,
      DateTime? endDateTime,
      String? objectId}) {
    List<WQBMissionModel> datas = [];
    if (folderStatus == 9) {
      datas = MongoApisManager.getInstance()!.listWQBMissionModel;
    } else {
      // folderStatus == 0
      datas = MongoApisManager.getInstance()!
          .listWQBMissionModel
          .where((WQBMissionModel element) => element.folder_id == objectId)
          .toList();
    }

    FolderTimeModel model = Utility.getWQBFolderTimeModel(datas);
    return model;
  }

  // 0-就是自己创建的FolderModel 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成
  static FolderTimeModel getFolderTimeByTag({
    required String tagName,
    int folderStatus = -1,
  }) {
    List<MissionModel> datas = [];
    datas = MongoApisManager.getInstance().queryWhereEqual_missionDataByTagName(
      tagName: tagName,
    );

    FolderTimeModel model = Utility.getFolderTimeModel(datas, folderStatus);
    return model;
  }

  // 0-就是自己创建的FolderModel 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成
  static FolderTimeModel getFolderTime(
      {required int folderStatusDate,
      CalendarModel? calendarModel,
      DateTime? startDateTime,
      DateTime? endDateTime,
      int folderStatus = -1,
      String? objectId}) {
    List<MissionModel> datas = [];
    if (calendarModel != null) {
      if (folderStatusDate == 1) {
        //今天
        datas = getMissionModelFromDayModel(getDayModelList(calendarModel!,
            endDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch, true)));
      } else if (folderStatusDate == 2) {
        datas = getMissionModelFromDayModel(getDayModelList(calendarModel!,
            startDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 1000),
            endDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 1000,
                true)));
      } else if (folderStatusDate == 3) {
        datas = getMissionModelFromDayModel(getDayModelList(calendarModel!,
            endDateTime: Utility.getFilterDateTimeFromTimeStamp(
                DateTime.now().millisecondsSinceEpoch + 6 * 24 * 60 * 60 * 1000,
                true)));
      } else if (folderStatusDate == 4) {
        datas = MongoApisManager.getInstance()!
            .queryWhereEqual_missionDataByEndTime();
      } else if (folderStatusDate == 12) {
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByDateStatus(dateStatus: 12);
      } else if (folderStatusDate == 13) {
        datas = MongoApisManager.getInstance()
            .queryWhereEqual_missionDataByDateStatus(dateStatus: 13);
      } else if (folderStatusDate == 6) {
        datas = MongoApisManager.getInstance()!
            .queryWhereEqual_missionDataByFinishedMission();
      } else if (folderStatusDate == 9) {
        datas = MongoApisManager.getInstance()!
            .queryWhereEqual_missionDataByDoItNowMissionWithoutFinish();
      } else if (folderStatusDate == 10) {
        datas = MongoApisManager.getInstance()!.listMissionModels;
      } else if (folderStatusDate == 0 || folderStatusDate == 8) {
        //8是其他 0是目录
        //FolderPage走这里
        if (endDateTime == null && startDateTime == null) {
          //文件夹 标签等的data
          datas = MongoApisManager.getInstance()
              .queryWhereEqual_missionDataByFolderModelObjectId(
                  objectId: objectId);
        } else {
          //数据分析需要用来时间分析
          datas = MongoApisManager.getInstance()
              .queryWhereEqual_missionDataByEndTime(
            fid: objectId,
            start_endTime: startDateTime?.millisecondsSinceEpoch,
            end_endTime: endDateTime?.millisecondsSinceEpoch,
          );
        }
      }
    }

    FolderTimeModel model = Utility.getFolderTimeModel(datas, folderStatus);
    return model;
  }

  /**
   * 高考
   */
  static List<EndTimeMissionModel> getGuideEndTimeMissionModels() {
    Params.hasGuidMissionDataInit = true;
    List<EndTimeMissionModel> list = [];
    list.add(EndTimeMissionModel.fromJson({
      "createdAt": null,
      "updatedAt": null,
      "_id": null,
      "folder_id": "",
      "title": getI18NKey().guide_examine_time,
      "device_id": MongoApisManager.getInstance().device_id ?? '',
      "tagNames": "",
      "tagIds": "",
      "no_tomotoes_finished": 0,
      "total_tomotoes": 0,
      "tomato_duration": 0,
      "order_index": -1,
      "background_url": "http://oss.timerbell.com/resourceOss/4KA壁纸102.jpg",
      "end_time_before_finished": null,
      "end_time": Utility.getDateTime(
              year: DateTime.now().compareTo(Utility.getDateTime(
                          year: DateTime.now().year, month: 6, day: 5)) >
                      1
                  ? DateTime.now().year + 1
                  : DateTime.now().year,
              month: 6,
              day: 5,
              hour: 9)
          .millisecondsSinceEpoch,
      "alert_time": null,
      "time_finished": 0,
      "dateStatus": 0,
      "priorityStatus": null,
      "message": null,
      "isFinished": false,
      "isDelayed": false,
      "repetiveType": 0,
      "repetiveValue": 0,
      "repetiveWeekDay": [false, false, false, false, false, false, false],
      "uid": null
    }));
    return list;
  }

  /**
   * 首次进入app会提供指引
   */
  static List<MissionModel> getGuideMissionModels() {
    Params.hasGuidMissionDataInit = true;
    List<MissionModel> list = [];
    list.add(MissionModel.fromJson({
      "createdAt": null,
      "updatedAt": null,
      "_id": null,
      "folder_id": "",
      "title": getI18NKey().guide1,
      "device_id": MongoApisManager.getInstance().device_id ?? '',
      "tagNames": "",
      "tagIds": "",
      "no_tomotoes_finished": 0,
      "total_tomotoes": 1,
      "tomato_duration": 25 * 60 * 1000,
      "order_index": -1,
      "background_url": "http://oss.timerbell.com/resourceOss/4KA壁纸102.jpg",
      "end_time_before_finished": null,
      "end_time": Utility.getTimeStampToday(),
      "alert_time": null,
      "time_finished": 0,
      "dateStatus": 0,
      "priorityStatus": null,
      "message": null,
      "isFinished": false,
      "isDelayed": false,
      "repetiveType": 0,
      "repetiveValue": 0,
      "repetiveWeekDay": [false, false, false, false, false, false, false],
      "uid": null
    }));
    return list;
  }

  /**
   * ismobile主要判断是否需要显示创建清单
   * 否则显示在底部
   */
  static List<WQBFolderModelWithExtraData> getWQBMenuList(
      List<WQBFolderModel> folderModelList,
      {bool? isMobile,
      DateTime? startDateTime,
      DateTime? endDateTime,
      bool shouldAddDayType =
          true, //true来自folderlistPage false为summaryPage 不需要加 今天 明天 本周等
      CalendarModel? calendarModel}) {
    List<WQBFolderModelWithExtraData> listFolderModel =
        <WQBFolderModelWithExtraData>[];
    WQBFolderModel folderModel;

    folderModel = new WQBFolderModel();
    // folderModel.id = 'id';
    folderModel.title = getI18NKey().all;
    folderModel.color = ThemeManager.getInstance()
        .getIconColor(
            defaultColor: ThemeManager.getInstance().getDefautThemeColor())
        .value;
    folderModel.iconType =
        9; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他 9 所有
    folderModel.type = 2;
    listFolderModel.add(WQBFolderModelWithExtraData(
        folderModel: folderModel,
        folderTimeModel: CONSTANTS.getWQBFolderTime(
            folderStatus: folderModel.iconType ?? 0,
            calendarModel: calendarModel)));

    /**
     * 文件夹等
     */
    folderModelList.forEach((element) {
      listFolderModel.add(WQBFolderModelWithExtraData(
          folderModel: element,
          folderTimeModel: CONSTANTS.getWQBFolderTime(
              folderStatus: element.iconType ?? 0,
              startDateTime: startDateTime,
              endDateTime: endDateTime,
              calendarModel: calendarModel,
              objectId: element.objectId)));
    });
    // if (isMobile == true && shouldAddDayType == true) {
    //   listFolderModel.add(getCreateFolderModel());
    // }
    return listFolderModel;
  }

  static List<FolderModelWithExtraData> getMenuListByFid(
      List<FolderModel> folderModelList,
      {bool? isMobile,
      FolderPageViewEnum? folderPageViewEnum,
      DateTime? startDateTime,
      DateTime? endDateTime,
      bool shouldAddDayType =
          true, //true来自folderlistPage false为summaryPage 不需要加 今天 明天 本周等
      CalendarModel? calendarModel}) {
    List<FolderModelWithExtraData> listFolderModel =
        <FolderModelWithExtraData>[];
    FolderModel folderModel;
    if (folderPageViewEnum == null ||
        folderPageViewEnum == FolderPageViewEnum.normal) {
      if (shouldAddDayType == true) {
        folderModel = getTodayFolderModel();

        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().do_it_now;
        folderModel.iconType =
            9; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单 8 其他 9 现在做 Do it now
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().tomorrow;
        folderModel.iconType = 2; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().comingSoon;
        folderModel.iconType = 3; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().allUnfinishedMissions;
        folderModel.iconType = 4; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));

        folderModel = new FolderModel();
        folderModel.title = getI18NKey().schedule;
        folderModel.iconType = 5; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));
        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().completed;
        folderModel.iconType = 6; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));
      }
    }

    /**
     * 文件夹等
     */
    // if (folderPageViewEnum == FolderPageViewEnum.listing) {
    //   folderModelList.forEach((element) {
    //     listFolderModel.add(FolderModelWithExtraData(
    //         folderModel: element,
    //         folderTimeModel: CONSTANTS.getFolderTime(
    //             folderStatus: element.iconType ?? 0,
    //             startDateTime: startDateTime,
    //             endDateTime: endDateTime,
    //             calendarModel: calendarModel,
    //             objectId: element.objectId)));
    //   });
    // }

    folderModelList.forEach((element) {
      if (folderPageViewEnum == null) {
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: element,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: element.iconType ?? 0,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                calendarModel: calendarModel,
                objectId: element.objectId)));
      } else {
        //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来
        if (folderPageViewEnum == FolderPageViewEnum.tag && element.tag == 2) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: element,
              folderTimeModel: CONSTANTS.getFolderTimeByTag(
                tagName: element.title ?? "",
              )));
        } else if (folderPageViewEnum == FolderPageViewEnum.listing_unarchive &&
            element.tag == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: element,
              folderTimeModel: CONSTANTS.getFolderTime(
                  folderStatusDate: element.iconType ?? 0,
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                  calendarModel: calendarModel,
                  objectId: element.objectId)));
        }
      }
    });
    if (folderPageViewEnum == FolderPageViewEnum.tag) {
      if (isMobile == true && shouldAddDayType == true) {
        listFolderModel.add(getCreateFolderModel());
      }
    }
    return listFolderModel;
  }

  /**
   * ismobile主要判断是否需要显示创建清单
   * 否则显示在底部
   */
  static List<FolderModelWithExtraData> getMenuList(
      List<FolderModel> folderModelList,
      {bool? isMobile,
      FolderPageViewEnum? folderPageViewEnum,
      DateTime? startDateTime,
      DateTime? endDateTime,
      int folderStatus = -1,
      bool shouldAddDayType =
          true, //true来自folderlistPage false为summaryPage 不需要加 今天 明天 本周等
      CalendarModel? calendarModel}) {
    List<FolderModelWithExtraData> listFolderModel =
        <FolderModelWithExtraData>[];
    FolderModel folderModel;
    if (folderPageViewEnum == null ||
        folderPageViewEnum == FolderPageViewEnum.normal) {
      if (shouldAddDayType == true) {
        // int isListingTodayOn = 1;
        // int isListingDoItNowOn = 1;
        // int isListingTomorrowOn = 1;
        // int isListingLatest7DaysOn = 1;
        // int isListingTodoListOn = 1;
        // int isListingFragmentOn = 1;
        // int isListingAllUnfinishedMIssion = 1;
        // int isListingFinishedOn = 1;
        // int isListingAllOn = 1;
        // 1默认显示 0 隐藏 -1 有数据显示
        int isListingTodayOn =
            SettingManager.getSyncInstance().isListingTodayOn;
        int isListingDoItNowOn =
            SettingManager.getSyncInstance().isListingDoItNowOn;
        int isListingTomorrowOn =
            SettingManager.getSyncInstance().isListingTomorrowOn;
        int isListingLatest7DaysOn =
            SettingManager.getSyncInstance().isListingLatest7DaysOn;
        int isListingTodoListOn =
            SettingManager.getSyncInstance().isListingTodoListOn;
        int isListingFragmentOn =
            SettingManager.getSyncInstance().isListingFragmentOn;
        int isListingAllUnfinishedMission =
            SettingManager.getSyncInstance().isListingAllUnfinishedMission;
        int isListingFinishedOn =
            SettingManager.getSyncInstance().isListingFinishedOn;
        int isListingAllOn = SettingManager.getSyncInstance().isListingAllOn;

        folderModel = getTodayFolderModel();
        FolderTimeModel folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingTodayOn == -1) ||
            isListingTodayOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().do_it_now;
        folderModel.iconType =
            9; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务  12 待定任务 13 碎片清单
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingDoItNowOn == -1) ||
            isListingDoItNowOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().tomorrow;
        folderModel.iconType =
            2; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务  12 待定任务 13 碎片清单
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingTomorrowOn == -1) ||
            isListingTomorrowOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().comingSoon;
        folderModel.iconType =
            3; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务  12 待定任务 13 碎片清单
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingLatest7DaysOn == -1) ||
            isListingLatest7DaysOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().todo_listing;
        folderModel.iconType =
            12; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务 12 待定任务 13 碎片清单  12 待定任务 13 碎片清单
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingTodoListOn == -1) ||
            isListingTodoListOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().fragment_listing;
        folderModel.iconType =
            13; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务 12 待定任务 13 碎片清单
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingFragmentOn == -1) ||
            isListingFragmentOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().allUnfinishedMissions;
        folderModel.iconType =
            4; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionToFinished ?? 0) > 0 &&
                isListingAllUnfinishedMission == -1) ||
            isListingAllUnfinishedMission == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        folderModel.title = getI18NKey().schedule;
        folderModel.iconType =
            5; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务
        folderModel.type = 2;
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: folderModel,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: folderModel.iconType ?? 0,
                calendarModel: calendarModel,
                folderStatus: 0)));
        folderModel = new FolderModel();
        // folderModel.id = 'id';
        folderModel.title = getI18NKey().completed;
        folderModel.iconType =
            6; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if (((folderTimeModel?.numMissionFinished ?? 0) > 0 &&
                isListingFinishedOn == -1) ||
            isListingFinishedOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }

        folderModel = new FolderModel();
        folderModel.title = getI18NKey().all_mission;
        folderModel.iconType =
            10; // 1-今天 2 明天 3 本周 4 待定 5 日程 6 已完成 7 创建清单 8 其他 9 现在做 Do it now 10 所有任务
        folderModel.type = 2;
        folderTimeModel = CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            calendarModel: calendarModel,
            folderStatus: 0);
        if ((((folderTimeModel?.numMissionToFinished ?? 0) +
                        (folderTimeModel?.numMissionFinished ?? 0)) >
                    0 &&
                isListingAllOn == -1) ||
            isListingAllOn == 1) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: folderModel, folderTimeModel: folderTimeModel));
        }
      }
    }

    /**
     * 文件夹等
     */
    // if (folderPageViewEnum == FolderPageViewEnum.listing) {
    //   folderModelList.forEach((element) {
    //     listFolderModel.add(FolderModelWithExtraData(
    //         folderModel: element,
    //         folderTimeModel: CONSTANTS.getFolderTime(
    //             folderStatus: element.iconType ?? 0,
    //             startDateTime: startDateTime,
    //             endDateTime: endDateTime,
    //             calendarModel: calendarModel,
    //             objectId: element.objectId)));
    //   });
    // }

    folderModelList.forEach((element) {
      if (folderPageViewEnum == null) {
        listFolderModel.add(FolderModelWithExtraData(
            folderModel: element,
            folderTimeModel: CONSTANTS.getFolderTime(
                folderStatusDate: element.iconType ?? 0,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                calendarModel: calendarModel,
                objectId: element.objectId)));
      } else {
        //1-表示各种图案circle mission;2-表示的是 tag;null-今天 明天 即将到来
        if (folderPageViewEnum == FolderPageViewEnum.tag && element.tag == 2) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: element,
              folderTimeModel: CONSTANTS.getFolderTimeByTag(
                tagName: element.title ?? "",
              )));
        } else if (folderPageViewEnum == FolderPageViewEnum.listing_unarchive &&
            (element.tag == 1 || element.tag == 3) &&
            (element.folderStatus == 0 || element.folderStatus == null)) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: element,
              folderTimeModel: CONSTANTS.getFolderTime(
                  folderStatusDate: element.iconType ?? 0,
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                  calendarModel: calendarModel,
                  objectId: element.objectId)));
        } else if (folderPageViewEnum == FolderPageViewEnum.listing_archive &&
            (element.tag == 1 || element.tag == 3) &&
            (element.folderStatus == 1)) {
          listFolderModel.add(FolderModelWithExtraData(
              folderModel: element,
              folderTimeModel: CONSTANTS.getFolderTime(
                  folderStatusDate: element.iconType ?? 0,
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                  calendarModel: calendarModel,
                  objectId: element.objectId)));
        }
      }
    });
    // if (folderPageViewEnum == FolderPageViewEnum.tag) {
    //   if (isMobile == true && shouldAddDayType == true) {
    //     listFolderModel.add(getCreateFolderModel());
    //   }
    // }
    return listFolderModel;
  }

  static FolderModelWithExtraData getFolderModelWithExtraDataByFolderModel(
      {required FolderModel folderModel,
      DateTime? startDateTime,
      DateTime? endDateTime,
      required CalendarModel calendarModel}) {
    return FolderModelWithExtraData(
        folderModel: folderModel,
        folderTimeModel: CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            calendarModel: calendarModel,
            objectId: folderModel.objectId));
  }

  static FolderModel getTodayFolderModel() {
    FolderModel folderModel = new FolderModel();
    // folderModel.id = 'id';
    folderModel.title = getI18NKey().today;
    folderModel.iconType = 1; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成
    folderModel.type = 2;
    return folderModel;
  }

  static FolderModelWithExtraData getCreateFolderModel() {
    FolderModel folderModel = new FolderModel();
    // folderModel.id = 'id';
    folderModel.title = getI18NKey().createMission;
    folderModel.iconType = 7; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
    folderModel.type = 3;
    return FolderModelWithExtraData(
        folderModel: folderModel,
        folderTimeModel: CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0, calendarModel: null));
  }

  static WQBFolderModelWithExtraData getCreateWQBFolderModel() {
    WQBFolderModel folderModel = new WQBFolderModel();
    // folderModel.id = 'id';
    folderModel.title = getI18NKey().createMission;
    folderModel.iconType = 8; // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
    folderModel.type = 3;
    return WQBFolderModelWithExtraData(
        folderModel: folderModel,
        folderTimeModel: CONSTANTS.getFolderTime(
            folderStatusDate: folderModel.iconType ?? 0, calendarModel: null));
  }

  static List<CheckButtonStateModel>
      getGPTHeaderControlCheckButtonStateModelList({int? defaultIndex = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;
    list.add(CheckButtonStateModel(
        code: 'previous_chat',
        checkIcon: Icon(
          Icons.manage_history,
          size: size,
        )));
    list.add(CheckButtonStateModel(
        code: 'new_chat',
        checkIcon: Icon(
          Icons.add_circle,
          size: size,
        )));

    return list;
  }

  static List<CheckButtonStateModel> getGPTTabBarCheckButtonStateModelList(
      {int? defaultIndex = 0}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;
    list.add(CheckButtonStateModel(
        code: "chat",
        value: 0,
        title: getI18NKey().chat,
        color: 0xff404040,
        content: "",
        isCheck: defaultIndex == 0));
    list.add(CheckButtonStateModel(
        code: "more",
        value: 1,
        title: getI18NKey().more,
        color: 0xff404040,
        content: "",
        isCheck: defaultIndex == 1));
    return list;
  }

  static List<CheckButtonStateModel> getPCSettingCheckButtonStateModelList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;
    list.add(CheckButtonStateModel(
        code: "focus_setting",
        value: 1,
        title: getI18NKey().focus_setting,
        color: 0xff404040,
        checkIcon:
            Utility.getSVGPicture(R.assetsImgIcTomatoChecked, size: size),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "filtering_setting",
        value: 2,
        title: getI18NKey().filtering_setting,
        color: 0xff404040,
        checkIcon: Icon(Icons.filter_alt, size: size),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "module_filtering_setting",
        value: 3,
        title: getI18NKey().module_filtering_setting,
        color: 0xff404040,
        checkIcon: Icon(Icons.view_module, size: size),
        content: "",
        isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getModuleCheckButtonStateModelList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "popup_visible2",
        value: 1,
        title: getI18NKey().popup_visible2,
        color: 0xff404040,
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "popup_invisible3",
        value: 0,
        title: getI18NKey().popup_invisible3,
        color: 0xff404040,
        content: "",
        isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getMenuCheckButtonStateModelList() {
    List<CheckButtonStateModel> list = [];
    list.add(CheckButtonStateModel(
        code: "popup_select1",
        value: -1,
        title: getI18NKey().popup_select1,
        color: 0xff404040,
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "popup_visible2",
        value: 1,
        title: getI18NKey().popup_visible2,
        color: 0xff404040,
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "popup_invisible3",
        value: 0,
        title: getI18NKey().popup_invisible3,
        color: 0xff404040,
        content: "",
        isCheck: false));
    return list;
  }

  static List<CheckButtonStateModel> getModuleFilerintCheckButtonStateModelList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;
    list.add(CheckButtonStateModel(
        code: "TomatoPage",
        value: 1,
        title: getI18NKey().tomatoClock,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcTomato, size: size),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "TimeManagementPage",
        value: 2,
        title: getI18NKey().calendar2,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcTimeManagementSelected,
            size: 20),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "CalendarContainerPage",
        value: 3,
        title: getI18NKey().schedule,
        color: 0xff404040,
        checkIcon: Icon(Icons.date_range, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "FourQuadrantPage",
        value: 3,
        title: getI18NKey().four_quadrant,
        color: 0xff404040,
        checkIcon: Image(
          width: size,
          height: size,
          image: AssetImage(R.assetsImgIcFourQuadrant),
          fit: BoxFit.cover,
        ),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "TimelinePage",
        value: 3,
        title: getI18NKey().timeline,
        color: 0xff404040,
        checkIcon:
            Utility.getSVGPicture(R.assetsImgIcTimelineClicked, size: 20),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "ClockInPCPage",
        value: 3,
        title: getI18NKey().clock_in,
        color: 0xff404040,
        checkIcon:
            Utility.getSVGPicture(R.assetsImgIcClockinSelected, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "WQBContainer",
        value: 3,
        title: getI18NKey().super_notebook,
        color: 0xff404040,
        checkIcon: Icon(
          Icons.book,
          size: size,
          color: Colors.purpleAccent,
        ),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "CountDownListViewPage",
        value: 3,
        title: getI18NKey().count_down_text,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcCountdownTimer,
            size: size, color: ThemeManager.getInstance().getIconColor()),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "GamePage",
        value: 3,
        title: getI18NKey().practice,
        color: 0xff404040,
        checkIcon: Icon(
          Icons.filter_center_focus,
          size: size,
          color: ThemeManager.getInstance().getIconColor(),
          // color: Colors.white,
        ),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "LockScreenPage",
        value: 3,
        title: getI18NKey().lock_app,
        color: 0xff404040,
        checkIcon:
            Utility.getSVGPicture(R.assetsImgIcLockscreenSelected, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "StatisticPage",
        value: 3,
        title: getI18NKey().analytics,
        color: 0xff404040,
        checkIcon: Icon(
          Icons.show_chart,
          size: 20,
          color: ThemeManager.getInstance().getIconColor(),
        ),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "AIHelper",
        value: 3,
        title: getI18NKey().ai_helper,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcAiHelper, size: size),
        content: "",
        isCheck: false));

    return list;
  }

  /**
   * // 1 今天 2 明天 3 7天后 4 所有为完成任务 11 待定任务 12 碎片清单
   */
  static List<CheckButtonStateModel> getCheckButtonStateModelList(
      {bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    const double size = 16;
    list.add(CheckButtonStateModel(
        code: "today",
        value: 1,
        title: getI18NKey().today,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcToday, size: size),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "do_it_now",
        value: 9,
        title: getI18NKey().do_it_now,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcInstantly, size: size),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "tomorrow",
        value: 2,
        title: getI18NKey().tomorrow,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcTomorrow, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "this_week",
        value: 3,
        title: getI18NKey().inSevenDays,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcThisWeek, size: size),
        content: "",
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "todo_listing_mission",
        value: 12,
        title: getI18NKey().todo_listing,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcTodo, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "fragment_listing_mission",
        value: 13,
        title: getI18NKey().fragment_listing,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcFragment, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "all_unfinished_missions",
        value: 4,
        title: getI18NKey().allUnfinishedMissions,
        color: 0xff404040,
        checkIcon:
            Utility.getSVGPicture(R.assetsImgIcUnfinishMissions, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "all_finished_missions",
        value: 6,
        title: getI18NKey().completed,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcFinished, size: size),
        content: "",
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "all_missions",
        value: 10,
        title: getI18NKey().all_mission,
        color: 0xff404040,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcAllMission, size: size),
        content: "",
        isCheck: false));

    return list;
  }

  static List<CheckButtonStateModel> getPriorityList({bool? hasAll = false}) {
    List<CheckButtonStateModel> list = [];
    const double size = 20;
    list.add(CheckButtonStateModel(
        code: "priority_1",
        value: 0,
        title: getI18NKey().four_quadrant_priority1,
        content: getI18NKey().four_quadrant_priority1_desc,
        color: 0xffdc281e,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.red1)),
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "priority_2",
        value: 1,
        title: getI18NKey().four_quadrant_priority2,
        content: getI18NKey().four_quadrant_priority2_desc,
        color: 0xffed8f03,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.yellow2)),
        isCheck: false));

    list.add(CheckButtonStateModel(
        code: "priority_3",
        value: 2,
        title: getI18NKey().four_quadrant_priority3,
        content: getI18NKey().four_quadrant_priority3_desc,
        color: 0xff2193b0,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.blue3)),
        isCheck: false));
    list.add(CheckButtonStateModel(
        code: "priority_4",
        value: 3,
        title: getI18NKey().four_quadrant_priority4,
        content: getI18NKey().four_quadrant_priority4_desc,
        color: 0xff799f0c,
        checkIcon: Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.green4)),
        isCheck: false));
    return list;
  }

  // 1-今天 2 明天 3 本周 4 待定 5 日程 5 已完成 6 创建清单 7 创建清单
  static Widget getDateIcon(int iconType, [double iconSize = 25]) {
    switch (iconType) {
      case 1:
        return Utility.getSVGPicture(R.assetsImgIcToday, size: iconSize);
      case 2:
        return Utility.getSVGPicture(R.assetsImgIcTomorrow, size: iconSize);
      case 3:
        return Utility.getSVGPicture(R.assetsImgIcThisWeek, size: iconSize);

      case 12:
        return Utility.getSVGPicture(R.assetsImgIcTodo, size: iconSize);
      case 13:
        return Utility.getSVGPicture(R.assetsImgIcFragment, size: iconSize);

      default:
        return Utility.getSVGPicture(R.assetsImgIcUnfinishMissions,
            size: iconSize);
    }
  }

  static Widget getPriorityIcon(int priority, {double size = 25}) {
    switch (priority) {
      case 0:
        return Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.red1));
      case 1:
        return Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.yellow2));
      case 2:
        return Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.blue3));
      // case 4:
      //   return Icon(Icons.golf_course, size: 30, color: Colors.grey);
      //   break;
      default:
        return Utility.getSVGPicture(R.assetsImgIcPriority,
            size: size,
            color: Utility.getTextColorByPriority(PriorityEnum.green4));
    }
  }

  /**
   * 从missionModel得到番茄总时长 SettingItemPage用得到
   */
  static String getDurationString(MissionModel model) {
    // int numTomatoes = model.total_tomotoes;
    int duration = (model.tomato_duration ?? 0) ~/ 1000 ~/ 60;
    if (duration >= 60) {
      return (duration / 60).toInt().toString() +
          getI18NKey().hour +
          (duration % 60).toInt().toString() +
          getI18NKey().mins;
    } else {
      return (duration % 60).toInt().toString() + getI18NKey().mins;
    }
  }

  /**
   *
   */
  static String getDateStringSubtitle(MissionModel missionModel) {
    if (missionModel.end_time == null) {
      return "";
    }
    DateTime endDateTime = Utility.timeStampToDateTime(missionModel.end_time!);
    String s = getI18NKey().monthDay(
        (endDateTime.month).toString(),
        endDateTime.day.toString(),
        Utility.getWeekOfDayByTimeStamp(missionModel.end_time!, 0));
    return s;
  }

  static String getSegmentDateStringSubtitle(MissionModel missionModel) {
    if (missionModel.end_time == null) {
      return "";
    }
    String s1 = CONSTANTS.getAlertDateString(
        Utility.getDateTimeModelFromTimeStamp(missionModel?.start_time ?? 0));

    String s2 = CONSTANTS.getAlertDateString(
        Utility.getDateTimeModelFromTimeStamp(missionModel?.end_time ?? 0));

    return getI18NKey().date1_to_date2(s1, s2);
  }

  static String getSegmentDateString(
      {DateTime? dateTime1, DateTime? dateTime2}) {
    if (dateTime1 == null && dateTime2 == null) {
      return getI18NKey().all_maju;
    } else if (dateTime1 == null && dateTime2 != null) {
      return getI18NKey().before_date(CONSTANTS.getAlertDateString(
          Utility.getDateTimeModelFromTimeStamp(
              dateTime2.millisecondsSinceEpoch ?? 0)));
    } else if (dateTime1 != null && dateTime2 == null) {
      return getI18NKey().after_date(CONSTANTS.getAlertDateString(
          Utility.getDateTimeModelFromTimeStamp(
              dateTime1?.millisecondsSinceEpoch ?? 0)));
    } else {
      return getI18NKey().between_date(
          CONSTANTS.getAlertDateString(Utility.getDateTimeModelFromTimeStamp(
              dateTime1?.millisecondsSinceEpoch ?? 0)),
          CONSTANTS.getAlertDateString(Utility.getDateTimeModelFromTimeStamp(
              dateTime2?.millisecondsSinceEpoch ?? 0)));
    }
    return "";
  }

  /**
   *
   */
  static String getWQBDateStringSubtitle(WQBMissionModel model) {
    if (model.update_time == null) {
      return "";
    }

    DateTime endDateTime = Utility.timeStampToDateTime(model.update_time!);
    String s = getI18NKey().monthDay(
        (endDateTime.month).toString(),
        endDateTime.day.toString(),
        Utility.getWeekOfDayByTimeStamp(model.update_time!, 0));
    return s;
  }

  static String getDateStringSubtitleByFlomoMissionModel(
      FlomoMissionModel model) {
    if (model.end_time == null) {
      return "";
    }

    DateTime endDateTime = Utility.timeStampToDateTime(model.end_time!);
    String s = getI18NKey().monthDay(
        (endDateTime.month).toString(),
        endDateTime.day.toString(),
        Utility.getWeekOfDayByTimeStamp(model.end_time!, 0));
    return s;
  }

  static String getWeekDayString(DateTimeModel model) {
    if (model == null) {
      return getI18NKey().none;
    }
    String s = "";

    if (Utility.getYearMonthAndDayDateTimeByTimestamp(
            Utility.getTimeStampToday())
        .isAtSameMomentAs(model.datetime ?? DateTime.now())) {
      s = getI18NKey().today;
    } else if (((model.datetime?.millisecondsSinceEpoch ?? 0) -
            Utility.getYearMonthAndDayDateTimeByTimestamp(
                    Utility.getTimeStampToday())
                .millisecondsSinceEpoch) ==
        24 * 60 * 60 * 1000) {
      s = getI18NKey().tomorrow;
    } else if (model.isThisWeek!) {
      s = getI18NKey().thisWeek;
    } else if (model.isNextWeek!) {
      s = getI18NKey().nextWeek;
    } else if (model.isLastWeek!) {
      s = getI18NKey().lastWeek;
    } else {
      s = getI18NKey().dateFromMonth(
          model.datetime!.month.toString(), model.datetime!.day.toString());
    }
    s = s + "," + getTextFromDayOfWeek(model.dayOfWeek!);
    return s;
  }

  static String getRepetiveDateString(
      int midVal, int rightVal, List<CheckModel> model) {
    String s = getI18NKey().eachSpace;
    s = s + midVal.toString();

    if (rightVal == 1) {
      s = s + " " + getI18NKey().day;
    } else if (rightVal == 2) {
      s = s + getI18NKey().week;
    } else if (rightVal == 3) {
      s = s + getI18NKey().month;
    } else if (rightVal == 4) {
      s = s + getI18NKey().year;
    }
    if (model.length > 0) {
      s = s + getI18NKey().de;
      if (model[0].isChecked!) {
        s = s + getI18NKey().monday + ",";
      }
      if (model[1].isChecked!) {
        s = s + getI18NKey().tuesday + ",";
      }
      if (model[2].isChecked!) {
        s = s + getI18NKey().wednesday + ",";
      }
      if (model[3].isChecked!) {
        s = s + getI18NKey().thursday + ",";
      }
      if (model[4].isChecked!) {
        s = s + getI18NKey().friday + ",";
      }
      if (model[5].isChecked!) {
        s = s + getI18NKey().saturday + ",";
      }
      if (model[6].isChecked!) {
        s = s + getI18NKey().sunday + ",";
      }
      if (model.length > 0) {
        s = s.substring(0, s.length - 1);
      }
    }
    return s;
  }

  static String getRepetiveDateString3(
      {required int repetiveType,
      required int repetiveValue,
      required List repetiveWeekDay}) {
    if (repetiveType == 0) {
      return getI18NKey().none;
    }
    String s = getI18NKey().eachSpace;
    s = s + repetiveValue.toString();

    if (repetiveType == 1) {
      s = s + getI18NKey().day;
    } else if (repetiveType == 3) {
      s = s + getI18NKey().month;
    } else if (repetiveType == 4) {
      s = s + getI18NKey().year;
    } else if (repetiveType == 2) {
      s = s + getI18NKey().week;
      bool isMark = false;
      if (repetiveWeekDay == null || repetiveWeekDay!.length == 0)
        repetiveWeekDay = [
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ];
      if (repetiveWeekDay != null && repetiveWeekDay![0]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().monday + "，";
      }
      if (repetiveWeekDay != null && repetiveWeekDay![1]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().tuesday + "，";
      }
      if (repetiveWeekDay != null && repetiveWeekDay![2]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().wednesday + "，";
      }
      if (repetiveWeekDay != null && repetiveWeekDay![3]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().thursday + "，";
      }
      if (repetiveWeekDay != null && repetiveWeekDay![4]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().friday + "，";
      }
      if (repetiveWeekDay != null && repetiveWeekDay![5]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().saturday + "，";
      }
      if (repetiveWeekDay != null && repetiveWeekDay![6]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().sunday + "，";
      }
      if (s.lastIndexOf("，") == s.length - 1) {
        s = s.substring(0, s.length - 1);
      }
    }

    return s;
  }

  static String getRepetiveDateString1(MissionModel model) {
    if (model.repetiveType == 0) {
      return getI18NKey().none;
    }
    String s = getI18NKey().eachSpace;
    s = s + model.repetiveValue.toString();

    if (model.repetiveType == 1) {
      s = s + getI18NKey().day;
    } else if (model.repetiveType == 3) {
      s = s + getI18NKey().month;
    } else if (model.repetiveType == 4) {
      s = s + getI18NKey().year;
    } else if (model.repetiveType == 2) {
      s = s + getI18NKey().week;
      bool isMark = false;
      if (model.repetiveWeekDay == null || model.repetiveWeekDay!.length == 0)
        model.repetiveWeekDay = [
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ];
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![0]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().monday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![1]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().tuesday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![2]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().wednesday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![3]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().thursday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![4]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().friday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![5]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().saturday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![6]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().sunday + "，";
      }
      if (s.lastIndexOf("，") == s.length - 1) {
        s = s.substring(0, s.length - 1);
      }
    }

    return s;
  }

  static String getRepetiveDateString1E(EndTimeMissionModel model) {
    if (model.repetiveType == 0) {
      return getI18NKey().none;
    }
    String s = getI18NKey().eachSpace;
    s = s + model.repetiveValue.toString();

    if (model.repetiveType == 1) {
      s = s + getI18NKey().day;
    } else if (model.repetiveType == 3) {
      s = s + getI18NKey().month;
    } else if (model.repetiveType == 4) {
      s = s + getI18NKey().year;
    } else if (model.repetiveType == 2) {
      s = s + getI18NKey().week;
      bool isMark = false;
      if (model.repetiveWeekDay == null || model.repetiveWeekDay!.length == 0)
        model.repetiveWeekDay = [
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ];
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![0]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().monday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![1]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().tuesday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![2]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().wednesday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![3]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().thursday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![4]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().friday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![5]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().saturday + "，";
      }
      if (model.repetiveWeekDay != null && model.repetiveWeekDay![6]) {
        if (!isMark) {
          s = s + getI18NKey().de;
          isMark = true;
        }
        s = s + getI18NKey().sunday + "，";
      }
      if (s.lastIndexOf("，") == s.length - 1) {
        s = s.substring(0, s.length - 1);
      }
    }

    return s;
  }

  static String getRepetiveDateString2(DateTime dateTime) {
    String s = "";
    s = s +
        getI18NKey().missionModelDate(
            (dateTime.year).toString(),
            (dateTime.month).toString(),
            dateTime.day.toString(),
            CONSTANTS.getTextFromDayOfWeek(dateTime.weekday));

    // s = s + "("+ CONSTANTS.getTextFromDayOfWeek(dateTime.weekday) + ")";
    // if (model.repetiveType == 0) {
    //   return getI18NKey().none;
    // }
    // if (model.end_time == null) {
    //   return "";
    // }
    // String s = "";
    // //结束日期是否是今天 是今天要重新算时间 并且返回几天后
    // bool isToday = Utility.isToday(model.end_time!);
    // //是否在限定时间内 限定时间内
    // // bool isLimitOfDay = Utility.getLimitOfDay(model.end_time, model.repetiveValue);
    // int now = Utility.getFilterDateTimeFromTimeStamp(
    //         DateTime.now().millisecondsSinceEpoch)
    //     .millisecondsSinceEpoch;
    // int repetiveValue = model.repetiveValue!;
    // int endTime = model.end_time!;
    // int nextTime;
    // if (model.repetiveType == 1) {
    //   // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复
    //   s = getI18NKey().nextMission;
    //   if (now > endTime) {
    //     nextTime = endTime +
    //         (endTime - now) +
    //         (now - endTime) %
    //             (repetiveValue * 24 * 60 * 60 * 1000); //结束时间 + 时间差 +
    //   } else if (now == endTime) {
    //     nextTime = endTime +
    //         (endTime - now) +
    //         (repetiveValue * 24 * 60 * 60 * 1000); //结束时间 + 时间差 +
    //   } else {
    //     nextTime = endTime;
    //   }
    //   s = s +
    //       Utility.getDayDiffByDayFromTimeStamp(
    //               nextTime,
    //               Utility.getFilterDateTimeFromTimeStamp(
    //                       DateTime.now().millisecondsSinceEpoch)
    //                   .millisecondsSinceEpoch)
    //           .toString() +
    //       getI18NKey().daysLater;
    //   s = s + "(" + (Utility.getWeekOfDayByTimeStamp(nextTime, 0) ?? "") + ")";
    // } else if (model.repetiveType == 2) {
    //   // 按周
    //   if (model.repetiveWeekDay == null || model.repetiveWeekDay!.length == 0)
    //     model.repetiveWeekDay = [
    //       false,
    //       false,
    //       false,
    //       false,
    //       false,
    //       false,
    //       false,
    //     ];
    //   if (Utility.isThisWeekLimit(endTime,
    //           monday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![0],
    //           tuesday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![1],
    //           wednesday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![2],
    //           thursday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![3],
    //           friday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![4],
    //           saturday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![5],
    //           sunday:
    //               model.repetiveWeekDay != null && model.repetiveWeekDay![6],
    //           repetiveValue: model.repetiveValue!) ==
    //       true) {
    //     nextTime = Utility.isThisWeekEndTime(endTime,
    //         monday: model.repetiveWeekDay != null && model.repetiveWeekDay![0],
    //         tuesday: model.repetiveWeekDay != null && model.repetiveWeekDay![1],
    //         wednesday:
    //             model.repetiveWeekDay != null && model.repetiveWeekDay![2],
    //         thursday:
    //             model.repetiveWeekDay != null && model.repetiveWeekDay![3],
    //         friday: model.repetiveWeekDay != null && model.repetiveWeekDay![4],
    //         saturday:
    //             model.repetiveWeekDay != null && model.repetiveWeekDay![5],
    //         sunday: model.repetiveWeekDay != null && model.repetiveWeekDay![6],
    //         repetiveValue: model.repetiveValue!);
    //   } else {
    //     nextTime = Utility.isNextWeekEndTime(endTime,
    //         monday: model.repetiveWeekDay != null && model.repetiveWeekDay![0],
    //         tuesday: model.repetiveWeekDay != null && model.repetiveWeekDay![1],
    //         wednesday:
    //             model.repetiveWeekDay != null && model.repetiveWeekDay![2],
    //         thursday:
    //             model.repetiveWeekDay != null && model.repetiveWeekDay![3],
    //         friday: model.repetiveWeekDay != null && model.repetiveWeekDay![4],
    //         saturday:
    //             model.repetiveWeekDay != null && model.repetiveWeekDay![5],
    //         sunday: model.repetiveWeekDay != null && model.repetiveWeekDay![6],
    //         repetiveValue: model.repetiveValue!);
    //     if (nextTime > endTime) {
    //       nextTime = endTime;
    //     }
    //   }
    //
    //   s = s +
    //       Utility.getDayDiffByDayFromTimeStamp(
    //               nextTime,
    //               Utility.getFilterDateTimeFromTimeStamp(
    //                       DateTime.now().millisecondsSinceEpoch)
    //                   .millisecondsSinceEpoch)
    //           .toString() +
    //       getI18NKey().daysLater;
    //   s = s + "(" + (Utility.getWeekOfDayByTimeStamp(nextTime, 0) ?? "") + ")";
    // } else if (model.repetiveValue == 3) {
    //   //按月
    //   DateTime endDateTime = Utility.getFilterDateTimeFromTimeStamp(endTime);
    //   DateTime nowDateTme = Utility.getFilterDateTimeFromTimeStamp(
    //       DateTime.now().millisecondsSinceEpoch);
    //   if (Utility.isThisMonthLimit(endTime,
    //       repetiveValue: model.repetiveValue!)) {
    //     if (endDateTime.isAtSameMomentAs(nowDateTme) ||
    //         nowDateTme.isAfter(endDateTime)) {
    //       //同一月份
    //       int year = endDateTime.year;
    //       int month = endDateTime.month;
    //       int days = endDateTime.day;
    //       int nextYear = year + repetiveValue ~/ 12;
    //       int nextMonth = month + repetiveValue % 12;
    //       nextTime = DateTime(nextYear, nextMonth, days).millisecondsSinceEpoch;
    //     } else {
    //       nextTime = endTime;
    //       s = s +
    //           Utility.getDayDiffByDayFromTimeStamp(
    //                   nextTime,
    //                   Utility.getFilterDateTimeFromTimeStamp(
    //                           DateTime.now().millisecondsSinceEpoch)
    //                       .millisecondsSinceEpoch)
    //               .toString() +
    //           getI18NKey().daysLater;
    //       s = s +
    //           "(" +
    //           (Utility.getWeekOfDayByTimeStamp(nextTime, 0) ?? "") +
    //           ")";
    //     }
    //   } else {
    //     int year = endDateTime.year;
    //     int month = endDateTime.month;
    //     int totalMonths = year * 12 + month;
    //     int days = endDateTime.day;
    //     int nowYear = nowDateTme.year;
    //     int nowMonth = nowDateTme.month;
    //     int nextNowTotalMonths = nowYear * 12 + nowMonth;
    //     int decalage = 0;
    //     if (totalMonths < nextNowTotalMonths) {
    //       //总的月份 > 下个启动月份
    //       decalage = totalMonths - nextNowTotalMonths + repetiveValue;
    //       int totalNextMonth = totalMonths + repetiveValue;
    //       int nextYear = totalNextMonth ~/ 12;
    //       int nextMonth = totalNextMonth % 12;
    //       nextTime = DateTime(nextYear, nextMonth, days).millisecondsSinceEpoch;
    //       // s = s + "(" + Utility.getWeekOfDay(nextTime, 0) + ")";
    //       s = decalage.toString() +
    //           getI18NKey().monthsLater +
    //           days.toString() +
    //           "，" +
    //           (Utility.getWeekOfDayByTimeStamp(nextTime, 0) ?? "");
    //     } else {
    //       decalage = totalMonths - nextNowTotalMonths;
    //       nextTime = endTime;
    //       DateTime nextDateTime = Utility.timeStampToDateTime(nextTime);
    //       s = decalage.toString() +
    //           getI18NKey().monthsLater +
    //           nextDateTime.day.toString() +
    //           "，" +
    //           (Utility.getWeekOfDayByTimeStamp(nextTime, 0) ?? "");
    //     }
    //
    //     int nextYear = year + repetiveValue ~/ 12;
    //     int nextMonth = month + repetiveValue % 12;
    //   }
    // }
    // else if (model.repetiveType == 3) {
    //   s = s + "月";
    // } else if (model.repetiveType == 4) {
    //   s = s + "年";
    // }

    return s;
  }

  /**
   * dateFromMonthToMins 得到月日分
   */
  static String getAlertDateString(DateTimeModel model) {
    if (model == null || model.datetime?.millisecondsSinceEpoch == 0) {
      return getI18NKey().none;
    }
    String s = getI18NKey().dateFromMonthToMins(
        (model.datetime!.month).toString(),
        Utility.toFixed(model.datetime!.day).toString(),
        Utility.toFixed(model.datetime!.hour).toString(),
        Utility.toFixed(model.datetime!.minute).toString());
    return s;
  }

  /**
   *
   * 得到周一 ~ 周日
   */
  static getTextFromDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case DateTime.monday:
        return getI18NKey().monday;
      case DateTime.tuesday:
        return getI18NKey().tuesday;
      case DateTime.wednesday:
        return getI18NKey().wednesday;
      case DateTime.thursday:
        return getI18NKey().thursday;
      case DateTime.friday:
        return getI18NKey().friday;
      case DateTime.saturday:
        return getI18NKey().saturday;
      default:
        return getI18NKey().sunday;
    }
  }

  /**
   * 专注和休息时的音乐
   */
  static List<MusicModel> getFocusAndRestingMusicModelList() {
    return [
      MusicModel(
          title: '深海', url: 'http://timehello.timerbell.com/deepocean.mp3'),
    ];
  }

  /**
   * 音乐的播放音乐,先下载，再播放
   */
  static List<MusicModel> getMusicModelList() {
    return [
      MusicModel(
          title: 'Apple Iphone Ringtone',
          url:
              'http://timehello.timerbell.com/Apple%20I%20Phone%20ringtone.mp3'),
      MusicModel(
          title: 'Aravind Some One As Colling',
          url:
              'http://timehello.timerbell.com/Aravind%20Some%20One%20As%20Colling%20.mp3'),
      MusicModel(
          title: 'Car Lock Sound',
          url: 'http://timehello.timerbell.com/Car%20Lock%20Sound.mp3'),
      MusicModel(
          title: 'Coin Sound',
          url: 'http://timehello.timerbell.com/Coin%20Sound.mp3'),
      MusicModel(
          title: 'Iphone Messenger',
          url: 'http://timehello.timerbell.com/IPhone%20Messenger%20.mp3'),
      MusicModel(
          title: 'Iphone Original Ringtone',
          url:
              'http://timehello.timerbell.com/IPhone%20Original%20Ringtone.mp3'),
      MusicModel(
          title: 'One Plus', url: 'http://timehello.timerbell.com/Oneplus.mp3'),
      MusicModel(
          title: 'Phone Bell',
          url: 'http://timehello.timerbell.com/Phone%20Bell.mp3'),
      MusicModel(
          title: 'Funny Picachu Ringtone',
          url: 'http://timehello.timerbell.com/Picachu2.mp3'),
      MusicModel(
          title: 'Picachu Ringtone',
          url: 'http://timehello.timerbell.com/Pikachu.mp3'),
      MusicModel(title: 'Sms', url: 'http://timehello.timerbell.com/Sms.mp3'),
      MusicModel(
          title: 'Success', url: 'http://timehello.timerbell.com/Success.mp3'),
      MusicModel(
          title: 'Whistle',
          url: 'http://timehello.timerbell.com/Whistle%20Sms.mp3'),
      MusicModel(
          title: 'Vintage', url: 'http://timehello.timerbell.com/vintage.mp3'),
      MusicModel(
          title: 'Vintage2',
          url: 'http://timehello.timerbell.com/vintage2.mp3'),
    ];
  }

  /**
   * 用于MissionDetailPage的counterStatus title
   */
  static String getMissionDetailCounterStatusTitle() {
    CounterStatus status = CounterManagement.getInstance().counterStatus;
    switch (status) {
      case CounterStatus.focusing:
        return getI18NKey().focusing;
      case CounterStatus.pausingFocusing:
        return getI18NKey().focusPausing;
      case CounterStatus.relaxing:
        return getI18NKey().resting;
      case CounterStatus.waitingToFocus:
        return getI18NKey().startFocusing;
      case CounterStatus.waitingToStartRelaxing:
        return getI18NKey().focusFinished;
      case CounterStatus.pausingRelaixing:
        return getI18NKey().restPausing;
      default:
        return "";
    }
  }

  /**
   * 早上锻炼15分钟，然后工作2小时，帮我规划下
   */
  static String getChatGptMessagge(
      String role, DateTime dateTime, String content) {
    String timestampFormat = "当地时间格式 YYYY-MM-DD HH:MM:SS.FFFFFF";
    DateTime dateTimeNow = new DateTime.now();
    int timestamp = dateTimeNow.millisecondsSinceEpoch;
    String res = getI18NKey().role_chatgpt_msg(role, dateTimeNow.toString(),
        content, timestampFormat, timestampFormat, timestampFormat);
    // String res = "我想让你扮演一个${role}, 您需要规划下以下内容,时间是${dateTimeNow.toString()},${content}，并返回json objects数组, 返回JSON Objects\njson每个字段key值和解释如下\nString? title = ''; //标题 必填 \nint? total_tomotoes; //直接算出结果 完成番茄的数量 (daily_end_time - daily_start_time)/tomato_duration \nint? tomato_duration = 1500000;  //直接算出结果 值永远为为 25 * 60 * 1000毫秒，代表一个番茄专注25分钟 \nString? end_time; //直接算出结果 ${timestampFormat}格式 结束时间 必填 \nint? priorityStatus; //3 无优先级  2 低优先级 1 中优先级 0 高优先级 必填 \nString? daily_start_time; //直接算出结果 ${timestampFormat}格式 任务开始时间   \nString? daily_end_time; //直接算出结果 ${timestampFormat}格式 任务结束时间 \nString? message; //任务提醒 \n注意:不能为null, key:value中的value直接给结果,每个任务的daily_start_time和daily_end_time时间不能重叠 \ntitle需要标题描述清楚，不需要别的解释,每个任务至少间隔5分钟\n 只返回 数组为根的json字符串 如[{object},{object},]";
    print(res);
    return res;
  }

  static List<ResourceDeliveryInfoBean>
      getGptRoleResourceDeliveryInfoBeanList() {
    List<ResourceDeliveryInfoBean> list = [];
    list.add(ResourceDeliveryInfoBean(
        resourceTitle: getI18NKey().role_time_manager));
    list.addAll(ResourceInfo
            .chatGptRolesForCreateMissionResourceLocationInfoBean
            ?.deliveryList ??
        []);

    return list;
  }

  static List<WQBFolderModel> getWQBFolderModelListFromStringList(List? list) {
    if (list == null) return [];
    List<WQBFolderModel> listFolderModel = [];
    List<WQBFolderModel> listFolderModelTags =
        MongoApisManager.getInstance().queryWhereEqual_WQBFolderModelWithTag();
    for (int i = 0; i < list.length; i++) {
      String item = list[i]['title'];
      // list
      WQBFolderModel? folderModel =
          getWQBFolderModelFromList(listFolderModelTags, item);
      if (folderModel != null) {
        listFolderModel.add(folderModel);
      }
    }
    return listFolderModel;
  }

  /**
   * 从FolderModel从得到只有tag类型的folderModelList
   */
  static List<FolderModel> getFolderModelListFromStringList(
      List<String>? list) {
    if (list == null) return [];
    List<FolderModel> listFolderModel = [];
    List<FolderModel> listFolderModelTags =
        MongoApisManager.getInstance().queryWhereEqual_folderModelWithTag();
    for (int i = 0; i < list.length; i++) {
      String item = list[i];
      // list
      FolderModel? folderModel =
          getFolderModelFromList(listFolderModelTags, item);
      if (folderModel != null) {
        listFolderModel.add(folderModel);
      }
    }
    return listFolderModel;
  }

  static WQBFolderModel? getWQBFolderModelFromList(
      List<WQBFolderModel> listFolderModelTags, String title) {
    for (int i = 0; i < listFolderModelTags.length; i++) {
      WQBFolderModel folderModel = listFolderModelTags[i];
      if (folderModel.title == title) {
        return folderModel;
      }
    }
    return null;
  }

  static FolderModel? getFolderModelFromList(
      List<FolderModel> listFolderModelTags, String title) {
    for (int i = 0; i < listFolderModelTags.length; i++) {
      FolderModel folderModel = listFolderModelTags[i];
      if (folderModel.title == title) {
        return folderModel;
      }
    }
    return null;
  }

  static String getComment(int status) {
    String title = "";
    switch (status) {
      case 0: //等待处理中
        title = getI18NKey().status_waiting;
        break;
      case 1: //处理中
        title = getI18NKey().status_handling;
        break;
      case 2: //开发中
        title = getI18NKey().status_developping;
        break;
      case 3: //完成
        title = getI18NKey().status_complete;
        break;
      case 4: //不处理
        title = getI18NKey().not_handling;
        break;
    }
    return title;
  }

  static List<CommentModel> getCommentModelsList(List<CommentModel> list) {
    List<CommentModel> datas = [];
    if (list != null) {
      list.forEach((element) {
        if ((element.status != 0 && element.status != 4) ||
            element.device_id == MongoApisManager.getInstance().device_id ||
            element.uid == LoginManager.getInstance().getUserBean().uid) {
          if ((TextUtil.isEmpty(element.countryCode) == true &&
                  DeviceInfoManagement.getCountryCode() == "CN") ||
              DeviceInfoManagement.getCountryCode() == element.countryCode) {
            datas.add(element);
          }
        }
      });
    }
    return datas;
  }

  // 0 错题本 1 便签 2 记忆卡片 3 备忘录
  static String getWQBStringType(int type) {
    if (type == 0) {
      return getI18NKey().wrong_question_book;
    } else if (type == 1) {
      return getI18NKey().note2;
    } else if (type == 2) {
      return getI18NKey().card;
    } else if (type == 3) {
      return getI18NKey().memorandum;
    } else {
      return "";
    }
  }

  static String getNewLineText() {
    if (Utility.isMacOS()) {
      return "option+enter";
    } else if (Utility.isWindows()) {
      return "ctrl+enter";
    } else {
      if (DeviceInfoManagement.isWEB()) {
        return getI18NKey().browser_not_support_multiline;
      }
      return "";
    }
  }

  static int getIndexFromColors(List<ColorsModel> list, int color) {
    for (int i = 0; i < list.length; i++) {
      ColorsModel colorsModel = list[i];
      if (colorsModel.color == color) {
        return i;
      }
    }
    return 0;
  }

  static void sortByPriorityFolderTimeForCompleteNum(
      List<Map<dynamic, dynamic>?> listFolderIds,
      List<FolderTimeModel> listFolderTimeModel,
      List<TimeSegment> list,
      [DateTime? startDateTime,
        DateTime? endDateTime]) {
    List<MissionModel> listMissionModels = [];
    List<MissionModel> listMissionModelRed1Complete = [];
    List<MissionModel> listMissionModelRed1 = [];
    List<MissionModel> listMissionModelYellow2Complete = [];
    List<MissionModel> listMissionModelYellow2 = [];
    List<MissionModel> listMissionModelGreen3Complete = [];
    List<MissionModel> listMissionModelGreen3 = [];
    List<MissionModel> listMissionModelBlue4Complete = [];
    List<MissionModel> listMissionModelBlue4 = [];
    listFolderIds.forEach((element) {
      List<MissionModel> listMissionModel = element?['listMissionModels'];
      listMissionModels.addAll(listMissionModel);
    });
    listMissionModels.forEach((element) {
      //3 无优先级  2 低优先级 1 中优先级 0 高优先级
      if(element.priorityStatus == 0){
        if(element?.isFinished == true)
          listMissionModelRed1Complete.add(element);
        listMissionModelRed1.add(element);
      }
      if(element.priorityStatus == 1){
        if(element?.isFinished == true)
          listMissionModelYellow2Complete.add(element);
        listMissionModelYellow2.add(element);
      }
      if(element.priorityStatus == 2){
        if(element?.isFinished == true)
          listMissionModelGreen3Complete.add(element);
        listMissionModelGreen3.add(element);

      }
      if(element.priorityStatus == 3){
        if(element?.isFinished == true)
          listMissionModelBlue4Complete.add(element);
        listMissionModelBlue4.add(element);


      }
    });
    ProgressFocusModel progressFocusModel = Utility.getPriorityCompleteNumberWithMissionList(
        listMissionModelRed1Complete, listMissionModelRed1);
    if(progressFocusModel.totalValue > 0)
    list.add(TimeSegment(
        label: getI18NKey().priority1 +
            "(${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)})",
        value: progressFocusModel.currentValue,
        color: Color(CONSTANTS.getPriorityColor(0)),
        totalValue: progressFocusModel.totalValue == 0
            ? 1
            : progressFocusModel.totalValue,
        onTap: () => print("Segment 1 clicked")));

     progressFocusModel = Utility.getPriorityCompleteNumberWithMissionList(
        listMissionModelYellow2Complete, listMissionModelYellow2);
    if(progressFocusModel.totalValue > 0)
    list.add(TimeSegment(
        label: getI18NKey().priority2 +
            "(${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)})",
        value: progressFocusModel.currentValue,
        color: Color(CONSTANTS.getPriorityColor(1)),
        totalValue: progressFocusModel.totalValue == 0
            ? 1
            : progressFocusModel.totalValue,
        onTap: () => print("Segment 1 clicked")));
     progressFocusModel = Utility.getPriorityCompleteNumberWithMissionList(
        listMissionModelGreen3Complete, listMissionModelGreen3);
    if(progressFocusModel.totalValue > 0)
    list.add(TimeSegment(
        label: getI18NKey().priority3 +
            "(${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)})",
        value: progressFocusModel.currentValue,
        color: Color(CONSTANTS.getPriorityColor(2)),
        totalValue: progressFocusModel.totalValue == 0
            ? 1
            : progressFocusModel.totalValue,
        onTap: () => print("Segment 1 clicked")));
     progressFocusModel = Utility.getPriorityCompleteNumberWithMissionList(
        listMissionModelBlue4Complete, listMissionModelBlue4);
    if(progressFocusModel.totalValue > 0)
    list.add(TimeSegment(
        label: getI18NKey().priority4 +
            "(${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)})",
        value: progressFocusModel.currentValue,
        color: Color(CONSTANTS.getPriorityColor(3)),
        totalValue: progressFocusModel.totalValue == 0
            ? 1
            : progressFocusModel.totalValue,
        onTap: () => print("Segment 1 clicked")));
  }

  static void sortByFolderTimeForCompleteNum(
      List<Map<dynamic, dynamic>?> listFolderIds,
      List<FolderTimeModel> listFolderTimeModel,
      List<TimeSegment> list,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    listFolderIds.forEach((element) {
      List<MissionModel> listMissionModel = element?['listMissionModels'];
      String title = element?['folderTitle'];
      int color = element?["color"] ?? Utility.getRandomColor();
      DateTime? dateTimeStart =
          Utility.getStartDateTimeFromListMissionModels(list: listMissionModel);
      DateTime? dateTimeEnd =
          Utility.getEndDateTimeFromListMissionModels(list: listMissionModel);
      if (startDateTime != null) {
        dateTimeStart = startDateTime;
      } else if (endDateTime != null) {
        dateTimeEnd = endDateTime;
      } else if (dateTimeStart == null && dateTimeEnd == null) {
        return;
      } else if (dateTimeEnd != null) {
        dateTimeEnd = Utility.getFilterDateTimeFromDateTime(dateTimeEnd, true);
      } else {
        if (dateTimeStart != null) {
          dateTimeEnd =
              Utility.getFilterDateTimeFromDateTime(dateTimeStart, true);
        }
      }
      ProgressFocusModel progressFocusModel =
          Utility.getCompleteNumberWithMissionList(
              listMissionModel, startDateTime ?? dateTimeStart, endDateTime ?? dateTimeEnd);

      list.add(TimeSegment(
          label: title +
              "(${getI18NKey().num_mission_percent(progressFocusModel.currentValue, progressFocusModel.totalValue)})",
          value: progressFocusModel.currentValue,
          color: Color(color),
          totalValue: progressFocusModel.totalValue == 0
              ? 1
              : progressFocusModel.totalValue,
          onTap: () => print("Segment 1 clicked")));
    });
  }

  static void sortByFolderTimeForTomatoes(
      List<Map<dynamic, dynamic>?> listFolderIds,
      List<FolderTimeModel> listFolderTimeModel,
      List<TimeSegment> list,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    listFolderIds.forEach((element) {
      List<MissionModel> listMissionModel = element?['listMissionModels'];
      String title = element?['folderTitle'];
      int color = element?["color"] ?? Utility.getRandomColor();
      DateTime? dateTimeStart =
          Utility.getStartDateTimeFromListMissionModels(list: listMissionModel);
      DateTime? dateTimeEnd =
          Utility.getEndDateTimeFromListMissionModels(list: listMissionModel);
      if (startDateTime != null) {
        dateTimeStart = startDateTime;
      } else if (endDateTime != null) {
        dateTimeEnd = endDateTime;
      } else if (dateTimeStart == null && dateTimeEnd == null) {
        return;
      } else if (dateTimeEnd != null) {
        dateTimeEnd = Utility.getFilterDateTimeFromDateTime(dateTimeEnd, true);
      } else {
        if (dateTimeStart != null) {
          dateTimeEnd =
              Utility.getFilterDateTimeFromDateTime(dateTimeStart, true);
        }
      }
      ProgressFocusModel progressFocusModel =
          Utility.getTomatoesWithMissionList(
              listMissionModel, dateTimeStart, dateTimeEnd);

      list.add(TimeSegment(
          label: title +
              "(${getI18NKey().num_tomatoes(progressFocusModel.currentValue)}/${getI18NKey().num_tomatoes(progressFocusModel.totalValue)})",
          value: progressFocusModel.currentValue,
          color: Color(color),
          totalValue: progressFocusModel.totalValue == 0
              ? 1
              : progressFocusModel.totalValue,
          onTap: () => print("Segment 1 clicked")));
    });
  }

  static void sortByFolderTimeForLyubichs(
      List<Map<dynamic, dynamic>?> listFolderIds,
      List<FolderTimeModel> listFolderTimeModel,
      List<TimeSegment> list,
      [DateTime? startDateTime,
      DateTime? endDateTime]) {
    listFolderIds.forEach((element) {
      List<MissionModel> listMissionModel = element?['listMissionModels'];
      String title = element?['folderTitle'];
      int color = element?["color"] ?? Utility.getRandomColor();
      DateTime? dateTimeStart =
          Utility.getStartDateTimeFromListMissionModels(list: listMissionModel);
      DateTime? dateTimeEnd =
          Utility.getEndDateTimeFromListMissionModels(list: listMissionModel);
      if (startDateTime != null) {
        dateTimeStart = startDateTime;
      } else if (endDateTime != null) {
        dateTimeEnd = endDateTime;
      } else if (dateTimeStart == null && dateTimeEnd == null) {
        return;
      } else if (dateTimeEnd != null) {
        dateTimeEnd = Utility.getFilterDateTimeFromDateTime(dateTimeEnd, true);
      } else {
        if (dateTimeStart != null) {
          dateTimeEnd =
              Utility.getFilterDateTimeFromDateTime(dateTimeStart, true);
        }
      }
      ProgressFocusModel progressFocusModel =
          Utility.getDurationCalendarModelWithMissionList(
              listMissionModel, startDateTime ?? dateTimeStart, endDateTime ?? dateTimeEnd);

      list.add(TimeSegment(
          label: title +
              "(${Utility.formatTimestampWithoutZeroHM(progressFocusModel.currentValue * 1000)} / ${Utility.formatTimestampWithoutZeroHM(progressFocusModel.totalValue == 0 ? 1 : (progressFocusModel.totalValue * 1000))})",
          value: progressFocusModel.currentValue,
          color: Color(color),
          totalValue: progressFocusModel.totalValue == 0
              ? 1
              : progressFocusModel.totalValue,
          onTap: () => print("Segment 1 clicked")));
    });
  }

  static void sortByFolderTime(List<Map<dynamic, dynamic>?> listFolderIds,
      List<FolderTimeModel> listFolderTimeModel, List<TimeSegment> list) {
    listFolderIds.forEach((element) {
      List<MissionModel> listMissionModel = element?['listMissionModels'];
      String title = element?['folderTitle'];
      FolderTimeModel folderTimeModel =
          Utility.getFolderTimeModel(listMissionModel);
      folderTimeModel.folderTitle = title;
      folderTimeModel.listDatas = listMissionModel;
      listFolderTimeModel.add(folderTimeModel);
    });
    listFolderTimeModel.forEach((element) {
      int totalTime =
          ((element.previewTime ?? 0) + (element.finishedTime ?? 0));
      list.add(TimeSegment(
          label: element.folderTitle ?? '',
          value: element.previewTime ?? 0,
          color: Utility.getRandomColor(),
          totalValue: totalTime == 0 ? 1 : totalTime,
          onTap: () => print("Segment 1 clicked")));
    });
  }

  static List<TimeSegment> parseFolderModelListToTimeSegmentByDateTime(
      List<MissionModel> data, DateTime dateTimeStart, DateTime dateTimeEnd) {
    CalendarModel calendarModel =
        Utility.initCalendarModelWithMissionList(data);
    List<FolderTimeModel> listFolderTimeModel = [];
    List<MissionModel> listMissionModel = getMissionModelsFromCalendarModel(
        calendarModel: calendarModel,
        dateTimeStart: dateTimeStart,
        dateTimeEnd: dateTimeEnd);
    List<Map?> listFolderIds =
        sortMissionModelListToFolderIds(listMissionModel);
    List<TimeSegment> listTimeSegment = [];
    listFolderIds.forEach((element) {
      List<MissionModel> listMissionModel = element?['listMissionModels'];
      String title = element?['folderTitle'];
      String folderObjectId = element?['folderObjectId'];
      FolderTimeModel folderTimeModel =
          Utility.getFolderTimeModel(listMissionModel);
      folderTimeModel.folderTitle = title;
      folderTimeModel.folderObjectId = folderObjectId;
      listFolderTimeModel.add(folderTimeModel);
    });
    listFolderTimeModel.forEach((element) {
      listTimeSegment.add(TimeSegment(
          label: element.folderTitle ?? '',
          value: element.previewTime ?? 0,
          color: Utility.getRandomColor(),
          totalValue: element.previewTime ?? 0,
          onTap: () => print("Segment 1 clicked")));
    });
    return [];
  }

  static List<MissionModel> getMissionModelsFromCalendarModel(
      {required CalendarModel calendarModel,
      required DateTime dateTimeStart,
      required DateTime dateTimeEnd}) {
    List<DayModel> listMissionModels = calendarModel.dayModelList;
    List<MissionModel> list = [];
    listMissionModels.forEach((element) {
      list.addAll(element.missionModelList);
    });
    return list;
  }

  /**
   * 将任务列表按照folder_id排序 放到listMissionModels中
   * {"folderObjectId": element?.folder_id, "folderTitle": element?.title, "listMissionModels": []}
   */
  static List<Map?> sortMissionModelListToFolderIds(
    List<MissionModel> listMissionModels,
  ) {
    List<String> listFolderObjectId = [];

    List<Map?> list = [];

    listMissionModels.forEach((element) {
      if (!TextUtil.isEmpty(element.folder_id) &&
          !listFolderObjectId.contains(element.folder_id)) {
        listFolderObjectId.add(element.folder_id!);
      } else {
        listFolderObjectId.add("");
      }
    });
    // 查询folder列表
    List<FolderModel?> listFolderModels = MongoApisManager.getInstance()
        .queryFolderModelListByObjectIdList(listFolderObjectId);
    // 如果folder_id为空则添加一个空的folder
    if (listFolderObjectId.contains("")) {
      listFolderModels.add(FolderModel());
    }
    List colorExist = [];
    listFolderModels.forEach((element) {
      List<MissionModel> listTmp = [];
      int color = element?.color != 0
          ? (element?.color ?? Colors.orange.value)
          : Colors.orange.value;
      if (colorExist.contains(color)) {
        color = Utility.getRandomColor().value;
      }
      colorExist.add(color);
      if (element?.objectId == null) {
        list.add({
          "folderObjectId": null,
          "folderTitle": getI18NKey().no_project_parenthese,
          "color": color,
          "listMissionModels": listTmp
        });
      } else {
        list.add({
          "folderObjectId": element?.objectId,
          "folderTitle": element?.title,
          "color": color,
          "listMissionModels": listTmp
        });
      }
    });
    listMissionModels.forEach((element) {
      list.forEach((element2) {
        if (element.folder_id == element2?['folderObjectId']) {
          if(element2?['listMissionModels'].contains(element) == false)
            element2?['listMissionModels'].add(element);
        }
      });
    });

    return list;
  }
}
