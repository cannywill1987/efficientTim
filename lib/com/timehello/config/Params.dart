import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import '../beans/ResourceDeliveryInfoBean.dart';
import '../beans/ResourceLocationInfoBean.dart';

class Params {
  // kDebugMode可以用来做全局开发环境测试
  static final EnvEnum env = EnvEnum.prd; //dev uat prd 发版前记得改local.properties的版本号才起作用 androidmanifest不起作用
  static String curVersion = '3.5.0';
  static String curLatestVersionAndroid = '';
  static String curLatestVersionIOS = '';
  static String curLatestVersionMAC = '';
  static String curLatestVersionWin = '';
  static String appName = "";
  static String sysCode = "TimerBell"; //埋点用得上 系统编码
  static final bool isDebug = env == EnvEnum.dev;
  static bool hasGuidMissionDataInit = false;
  static bool hasDesktopNoteWidgetInit = false; //桌面小组件是否刷新 第一次打开app要刷新
  static bool shouldRefreshPushModelList = true;// 每次进来更新一遍pushmodel
  static ChannelEnum channelEnum = ChannelEnum.normal;

  static LoginTypeEnum loginTypeEnum = LoginTypeEnum.normal;
  static final String vocabularyBaseUrl = "https://phoneticen.timerbell.com/"; //单词url
  // static final String version = '1.0.0';
  static String latestVersion = '';
  static BuildContext? curContext;
  static ResourceDeliveryInfoBean? updateInfoDeliveryInfoBean; //用于判断更新信息展示更新对话框
  static List<ResourceLocationInfoBean>? gamePagesResourceLocationInfoBeanList; //游戏中心游戏列表
  // static final int version = '1.0.0';bl

  static final int REQUEST_TIMEOUT = 40000;
  static final int CONNECT_TIMEOUT = 40000;
  static final int RECEIVE_TIMEOUT = 40000;

  static final int RINGTONE_DURATION = 10000;
  static final String mBaseUrl = env == EnvEnum.dev ? "http://localhost:7001" : EnvEnum.uat == env? "https://www.timerbell.com" : "https://www.timerbell.com";
  static final String mUrl = env == EnvEnum.dev ? "http://localhost:3000/web" : EnvEnum.uat == env? "https://www.timerbell.com/web" : "https://www.timerbell.com/web";
  static final String mMemberBaseUrl = "";
  static final String MSN_REGISTER_SCENE = "MSN_REGISTER_SCENE";
  static final String MSN_UNREGISTER_SCENE = "MSN_UNREGISTER_SCENE";
  static final String MSN_FORGET_PWD = "MSN_FORGET_PWD";


  static String databaseName = 'time';
  // 更新value_per_day的组件的数据
  static String ACTION_UPDATE_GLOBAL_THEME = 'ACTION_UPDATE_GLOBAL_THEME';
  static String ACTION_UPDATE_VALUE_PER_DAY = 'ACTION_UPDATE_VALUE_PER_DAY';

  static String ACTION_UPDATE_WQB_FOLDER_PAGE = 'ACTION_UPDATE_WQB_FOLDER_PAGE';
  static String ACTION_UPDATE_FOLDER_PAGE = 'ACTION_UPDATE_FOLDER_PAGE';
  static String ACTION_UPDATE_LISTVIEW = 'ACTION_UPDATE_LISTVIEW'; //用于更新Foldertage的silver list,但
  static String ACTION_UPDATE_SETTING_ITEM_DETAIL = 'ACTION_UPDATE_SETTING_ITEM_DETAIL';  //
  static String ACTION_UPDATE_FLOMO_LISTVIEW = 'ACTION_UPDATE_FLOMO_LISTVIEW'; //用于更新Foldertage的silver list,但

  static String ACTION_UPDATE_USERINFO_AVATAR = 'ACTION_UPDATE_USERINFO_AVATAR';
  static String ACTION_COUNTER_PUSH_NOTIFICATION = 'ACTION_COUNTER_PUSH_NOTIFICATION';
  static String ACTION_UPDATE_CALENDARPAGE = 'ACTION_UPDATE_CALENDARPAGE';
  static String ACTION_FINISH_MISSIONMODEL = 'ACTION_FINISH_MISSIONMODEL'; //点击完成某个mission
  static String ACTION_FINISH_FLOMO_MISSIONMODEL = 'ACTION_FINISH_FLOMO_MISSIONMODEL'; //点击完成某个mission
  static String ACTION_FINISH_MISSIONMODEL_DETAIL = 'ACTION_FINISH_MISSIONMODEL_DETAIL';
  static String ACTION_UPDATE_MONEY = 'ACTION_UPDATE_MONEY';
  static String ACTION_UPDATE_TOTAL_FOCUS_TIME = 'ACTION_UPDATE_TOTAL_FOCUS_TIME';
  static String ACTION_UPDATE_SCREEN_SIZE = 'ACTION_UPDATE_SCREEN_SIZE';
  static String ACTION_UPDATE_STATISTIC = 'ACTION_UPDATE_STATISTIC'; //更新统计
  static String AES_LISTING_GROUP_PWD = "ArvinIsSoGentgfe"; // 清单群密码
  static String AES_PWD = "ArvinIsSoGentrye";
  static String AES_IV = "AJEJIFEIWJFISJIF";
  static String AES_MY_MISSION_PASSWORD = "ArvinIsSoGefwqws";

  static String PUSH_COUNTER_NOTIFICATION_ID = '1';
  static String PUSH_NOTIFICATION_ID = '2';
}

class ResourceInfo {
  static ResourceLocationInfoBean? pcMissionBackgroundResourceLocationInfoBean;
  static ResourceLocationInfoBean? mobileMissionBackgroundResourceLocationInfoBean;
  static ResourceLocationInfoBean? allMissionBackgroundResourceLocationInfoBean;
  static ResourceLocationInfoBean? famousSentenceResourceLocationInfoBean;
  static List<ResourceLocationInfoBean>? clockInSentenceResourceLocationInfoBeanList; //打卡默认语句
  static ResourceLocationInfoBean? promptsGptResourceLocationInfoBean; //打卡默认语句
  static ResourceLocationInfoBean? missionItemBackgroundLocationInfoBean;

  static ResourceLocationInfoBean? chatGptRolesResourceLocationInfoBean;
  static ResourceLocationInfoBean? chatGptRolesForCreateMissionResourceLocationInfoBean;

}

class MarqueInfo {
  static ResourceDeliveryInfoBean? marqueFolderpage;
  static ResourceDeliveryInfoBean? marqueMissionpage;
  static ResourceDeliveryInfoBean? marqueCalendarpage;
  static ResourceDeliveryInfoBean? marqueGamepage;
  static ResourceDeliveryInfoBean? marqueStatispage;
  static ResourceDeliveryInfoBean? marqueFourQuadrantPage;
  static ResourceDeliveryInfoBean? marqueExportXls;
  static ResourceDeliveryInfoBean? marqueSettingVolume;
  static ResourceDeliveryInfoBean? marqueSettingItemDetail;
  static ResourceDeliveryInfoBean? marqueChatGptPage;
  static ResourceDeliveryInfoBean? marqueTimemanagement;
  static ResourceDeliveryInfoBean? marqueCreateAIChatGptMissionPage;
  static ResourceDeliveryInfoBean? marquePCBackgroundList;
  static ResourceDeliveryInfoBean? marqueGPTPage;

}

class ABTestSetting {
  static bool isGoogleOn = false;
  static bool isFacebookOn = false; //华为秒验开关
  static bool isOpenAiOn = true; //华为秒验开关
  static bool isCourseOn = true; //华为秒验开关

  static bool isRegisterDynamicCode = false;
  static bool isHuaweiSecVerifyOn = false; //华为秒验开关
}

class Urls {
  static String ratingGuide = "https://www.timerbell.com/views/ratingGuide";
  static String facebook = "https://www.facebook.com/profile.php?id=100090694350100";
  static String privacyProtocol = "https://www.timerbell.com/views/protocol/privacyProtocol";
  static String privacyProtocolOfficial = "https://www.timerbell.com/views/protocol/privacyProtocolOfficial";
  static String privacyProtocolXiaoMi = "https://www.timerbell.com/views/protocol/privacyProtocolXiaomi";
  static String privacyProtocolVivo = "https://www.timerbell.com/views/protocol/privacyProtocolVivo";
  static String mgmHomeUrl = Params.mUrl + "/mgm/home";
}

class Apis {

  static String captcha = "/api/captcha";
  static String chatGptWithOpenAi = "/api/chatGptWithOpenAi";
  static String streamTestApi = "/api/streamTest";
  static String getChatGptRedis = "/api/getChatGptRedis";
  // static String chatGpt = "/api/chatGpt";
  static String chatGpt = "/api/chatGpt";
  // static String getResourceList = "/api/resource/scene/getList";
  static String login = "/api/timehello/login";
  static String register = "/api/timehello/register";
  static String registerWithEmail = "/api/timehello/registerByEmail";
  static String updateValuePerHour = "/api/timehello/updateValuePerHour";
  static String updateLocalMoney = "/api/timehello/updateLocalMoney";
  static String getDynamicCode = "/api/common/getDynamicCode";
  static String unregisterAccount = "/api/common/unregisterAccount";
  static String updateUser = "/api/timehello/updateUser";
  static String resetPwd = "/api/timehello/resetPwd"; //重置密码
  static String updateAvatar = "/api/timehello/updateAvatar"; //更新用户头像
  static String loginWithTokenUid = "/api/timehello/loginWithTokenUid"; //闪屏页更新用户信息
  // static String upload = '/api/common/upload'; //上传图片
  static String uploadOss = '/api/common/uploadOss'; //上传图片
  static String uploadOSSFile = '/api/common/uploadOSSFile'; //上传图片
  static String getResourceList = "/api/resource/scene/getList"; //资源位请求
  static String updateTotalFocusTime = "/api/timehello/updateTotalFocusTime";
  static String getUserRankingList = "/api/timehello/getUserRankingList"; //
  static String sendAliyunNotificationRule = "/api/timehello/sendAliyunNotificationRule"; //发送推送
  static String delAliyunSchedule = "/api/timehello/delAliyunSchedule"; //删除定时任务
  static String unbindAliyunAlias = "/api/timehello/unbindAliyunAlias"; //绑定alias
  static String bindAliyunAlias = "/api/timehello/bindAliyunAlias"; //绑定alias
  static String pushAliyunNotificationWithAlias = "/api/timehello/pushAliyunNotificationWithAlias"; //根据alias推送 alias指单个用户
  static String gameRankingAdd = "/api/timehello/gameRankingAdd"; //添加游戏分数
  static String gameRankingGetList = "/api/timehello/gameRankingGetList"; //游戏排名列表
  static String getRandomItem = "/api/timehello/gameComparePictureController/getRandomItem"; //拉取随机图片
  static String getComparePicturesList = "/api/timehello/gameComparePictureController/getList"; //拉取随机图片
  static String getVocabulariLevelList = "/api/timehello/vocabularyController/getVocabulariLevelList"; //获取图片登记列表
  static String getVocabulariUnits = "/api/timehello/vocabularyController/getVocabulariUnits"; //获取单元...登下载链接
  static String shareSdkSecLogin = "/api/common/shareSdkSecLogin"; //秒验登录
  static String aliSdkSecLogin = "/api/common/aliSdkSecLogin"; //秒验登录

  static String getTextVoiceList = "/api/timehello/textVoiceController/getList"; //获取文字声音mp3
  static String uploadOssJSON = "/api/common/uploadOssJSON"; //上传json到阿里云
}

//Shareprefrence的key
class ShareprefrenceKeys {
  static String default9DigitPasswordsNeedShowWhenLoginAppLock = "efzfsace";
  static String default9DigitPasswordsNeedShowWhenLogin = "eififizsifizefizefijzefceizf";
  static String default9DigitPasswords = "eififizsifizefizefij";
  static String defaultPasswordKey = "wjeifjeidsqw";
  static String defaultThemeColor = "defaultThemeColor";
  static String themeMode = "themeMode";
  static String defaultSplash = "defaultSplash";
  static String defautCalendarContainerPageIndex = "defautCalendarContainerPageIndex";
  static String defautTimerContainerPageIndex = "defautTimerContainerPageIndex";
  static String flomoRatingDialogDontRemindAgain = "flomoRatingDialogDontRemindAgain";
  static String isMissionDetailStatsOpen = "isMissionDetailStatsOpen";
  static String listAndGridView = "listAndGridView";
  static String hasCameraPermissionRequested = 'hasCameraPermissionRequested';
  static String hasMicrophonePermissionRequested = 'hasMicrophonePermissionRequested';
  static String pcBackground = "pcBackground";
  static String numTimesOpen = "numTimesOpen";
  static String mobleBackground = "mobleBackground";
  static String timerModel = "timerModel";
  static String hasRating = "hasRating";
  static String deviceId = "deviceId";
  static String fourquadrantVisible = "fourquadrantVisible";
  static String folderOrderObjectId = "folderOrderObjectId";
  static String folderOrderObjectIdForOtherFolders = "folderOrderObjectIdForOtherFolders"; // 其他文件夹的排序
  static String folderOrderObjectIdArchived = "folderOrderObjectIdArchived";
  static String folderOrderObjectIdForOtherFoldersArchived = "folderOrderObjectIdForOtherFoldersArchived"; // 其他文件夹的排序
  static String gptUserSystemMessage = "gptUserSystemMessage";
  static String SettingModelKey = "SettingModelKey";
  static String SettingItemDetailTimeModeKey = "SettingItemDetailTimeModeKey";
  static String curFocusingMissionObjectIdKey = "curFocusingMissionObjectIdKey";
  static String curFocusingMissionObjectIdForTimeUsedKey = "curFocusingMissionObjectIdForTimeUsedKey";
  static String curFocusingMissionObjectIdForCurTimeFKey = "curFocusingMissionObjectIdForCurTimeFKey";
  static String curFocusingMissionObjectIdForTotalTimeFKey = "curFocusingMissionObjectIdForTotalTimeFKey";
  static String UserInfoModelKey = "jeizfjizejfizewf";


}

class Keys {
  // static GlobalKey GameWindowWidgetStateGlobalKey = GlobalKey();
  // static GlobalKey<ScaffoldState>? scaffoldStateGlobalKey;
  // // static GlobalKey? QuadrantWidgetGlobalKey = GlobalKey();
  // static GlobalKey<IconsGridViewWidgetState> IconsGridViewWidgetStateGlobalKey = GlobalKey();
  // static GlobalKey<GameCounterWidgetState> GameCounterWidgetGlobalKey = GlobalKey();
  // static GlobalKey<GameCounterWidgetState> GameCounterGame3WidgetGlobalKey = GlobalKey();
  // static GlobalKey<SelectCircleDialogContentState> SelectCircleDialogUtilStateGlobalKey = GlobalKey();
  // static GlobalKey<WrongWidgetState> ErrorWidgetGlobalKey = GlobalKey();
  // static GlobalKey<WrongWidgetState> WordListviewGlobalKey = GlobalKey();
  // static GlobalKey<TodayDataWidgetState>? TodayDataWidgetGlobalKey = GlobalKey();
  // static GlobalKey<AllDataWidgetState> AllDataWidgetGlobalKey = GlobalKey();
  // static GlobalKey<SummaryHeaderWidgetState>? SummaryHeaderWidgetGlobalKey = GlobalKey();
  // static GlobalKey<TimeLinePageState>? TimeLinePageStateGlobalKey = GlobalKey();
}