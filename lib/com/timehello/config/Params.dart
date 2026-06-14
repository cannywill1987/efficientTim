import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import '../beans/ResourceDeliveryInfoBean.dart';
import '../beans/ResourceLocationInfoBean.dart';

class Params {
  // kDebugMode可以用来做全局开发环境测试
  static final EnvEnum env = EnvEnum
      .prd; //dev uat prd 发版前记得改local.properties的版本号才起作用 androidmanifest不起作用
  static final String mOssUrl = "http://oss.timerbell.com";
  static final String mBaseUrl = env == EnvEnum.dev
      ? "http://127.0.0.1:9999"
      : EnvEnum.uat == env
          ? "https://www.timerbell.com"
          : "https://www.timerbell.com";
  static final String mUrl = env == EnvEnum.dev
      ? "http://localhost:3000/web"
      : EnvEnum.uat == env
          ? "http://localhost:3000/web"
          : "https://www.timerbell.com/web";

  static final isMongoDbCacheOn = true; // mongodb的缓存是否开启
  static bool useGmail = false; //是否使用gmail 完成登录注册等
  static final isHttpCacheOn = false; // mongodb的缓存是否开启
  static Locale? local; // 本机语言
  static int mongoDBTimeout = (env == EnvEnum.uat) ? 100000 : 10000;
  static String curVersion = '3.6.7';
  static String curLatestVersionAndroid = '';
  static String curLatestVersionIOS = '';
  static String curLatestVersionMAC = '';
  static String curLatestVersionWin = '';
  static String appName = "";
  static bool isFirstTime = false;
  static String sysCode = "TimerBell"; //埋点用得上 系统编码
  static final bool isDebug = env == EnvEnum.dev;
  static bool hasGuidMissionDataInit = false;
  static bool hasDesktopNoteWidgetInit = false; //桌面小组件是否刷新 第一次打开app要刷新
  static bool shouldRefreshPushModelList = true; // 每次进来更新一遍pushmodel
  static ChannelEnum channelEnum = ChannelEnum.normal;

  static LoginTypeEnum loginTypeEnum = LoginTypeEnum.normal;
  static final String vocabularyBaseUrl =
      "https://phoneticen.timerbell.com/"; //单词url
  // static final String version = '1.0.0';
  static String latestVersion = '';
  static BuildContext? curContext;
  static ResourceDeliveryInfoBean? updateInfoDeliveryInfoBean; //用于判断更新信息展示更新对话框
  static List<ResourceLocationInfoBean>?
      gamePagesResourceLocationInfoBeanList; //游戏中心游戏列表
  // static final int version = '1.0.0';bl

  static final int REQUEST_TIMEOUT = 40000;
  static final int CONNECT_TIMEOUT = 40000;
  static final int RECEIVE_TIMEOUT = 40000;

  static final int RINGTONE_DURATION = 10000;
  static final String mMemberBaseUrl = "";
  static final String MSN_REGISTER_SCENE = "MSN_REGISTER_SCENE";
  static final String MSN_UNREGISTER_SCENE = "MSN_UNREGISTER_SCENE";
  static final String MSN_FORGET_PWD = "MSN_FORGET_PWD";

  static String databaseName = 'time';
  // 更新value_per_day的组件的数据
  static String ACTION_UPDATE_GLOBAL_THEME = 'ACTION_UPDATE_GLOBAL_THEME';
  static String ACTION_UPDATE_VALUE_PER_DAY = 'ACTION_UPDATE_VALUE_PER_DAY';
  static String ACTION_UPDATE_MISSION_CONTAINER =
      'ACTION_UPDATE_MISSION_CONTAINER';

  static String ACTION_UPDATE_WQB_FOLDER_PAGE = 'ACTION_UPDATE_WQB_FOLDER_PAGE';
  static String ACTION_UPDATE_FOLDER_PAGE = 'ACTION_UPDATE_FOLDER_PAGE';
  static String ACTION_UPDATE_LISTVIEW =
      'ACTION_UPDATE_LISTVIEW'; //用于更新Foldertage的silver list,但
  static String ACTION_UPDATE_SETTING_ITEM_DETAIL =
      'ACTION_UPDATE_SETTING_ITEM_DETAIL'; //
  static String ACTION_UPDATE_TIME_MANAGEMENT_PAGE =
      'ACTION_UPDATE_TIME_MANAGEMENT_PAGE'; //
  static String ACTION_UPDATE_ALL_UI = 'ACTION_UPDATE_ALL_UI'; //

  static String ACTION_UPDATE_FLOMO_LISTVIEW =
      'ACTION_UPDATE_FLOMO_LISTVIEW'; //用于更新Foldertage的silver list,但

  static String ACTION_UPDATE_USERINFO_AVATAR = 'ACTION_UPDATE_USERINFO_AVATAR';
  static String ACTION_COUNTER_PUSH_NOTIFICATION =
      'ACTION_COUNTER_PUSH_NOTIFICATION';
  static String ACTION_UPDATE_CALENDARPAGE = 'ACTION_UPDATE_CALENDARPAGE';
  static String ACTION_FINISH_MISSIONMODEL =
      'ACTION_FINISH_MISSIONMODEL'; //点击完成某个mission
  static String ACTION_FINISH_FLOMO_MISSIONMODEL =
      'ACTION_FINISH_FLOMO_MISSIONMODEL'; //点击完成某个mission
  static String ACTION_FINISH_MISSIONMODEL_DETAIL =
      'ACTION_FINISH_MISSIONMODEL_DETAIL';
  static String ACTION_UPDATE_MONEY = 'ACTION_UPDATE_MONEY';
  static String ACTION_UPDATE_TOTAL_FOCUS_TIME =
      'ACTION_UPDATE_TOTAL_FOCUS_TIME';
  static String ACTION_UPDATE_SCREEN_SIZE = 'ACTION_UPDATE_SCREEN_SIZE';
  static String ACTION_UPDATE_STATISTIC = 'ACTION_UPDATE_STATISTIC'; //更新统计
  static String AES_LISTING_GROUP_PWD = "ArvinIsSoGentgfe"; // 清单群密码
  static String AES_PWD = "ArvinIsSoGentrye";
  static String AES_IV = "AJEJIFEIWJFISJIF";
  static String AES_MY_MISSION_PASSWORD = "ArvinIsSoGefwqws";

  static String PUSH_COUNTER_NOTIFICATION_ID = '1';
  static String PUSH_NOTIFICATION_ID = '2';

  static const String appAiBailianBaseUrl =
      'https://dashscope.aliyuncs.com/compatible-mode/v1';
  static const String appAiBailianDefaultModel = 'qwen-plus';
  static const String appAiBailianApiKey = String.fromEnvironment(
    'BAILIAN_API_KEY',
    defaultValue: '',
  );
  static String appAiBailianRuntimeBaseUrl = appAiBailianBaseUrl;
  static String appAiBailianRuntimeModel = appAiBailianDefaultModel;
  static String appAiBailianRuntimeApiKey = appAiBailianApiKey;
  static String appAiBailianRuntimeModelName = '通义千问 Plus';

  static List<Map<String, Object?>> appAiBailianModels =
      buildAppAiBailianModels();

  /// 功能：把资源位/环境变量解析出来的百炼配置写入全局运行时配置。
  /// 说明：AIPage、移动端语音建任务和语音转写都从这里读取，避免每个入口各自硬编码 key。
  static void updateAppAiBailianConfig({
    String? apiKey,
    String? baseUrl,
    String? model,
    String? modelName,
  }) {
    final nextApiKey = (apiKey ?? '').trim();
    final nextBaseUrl = (baseUrl ?? '').trim();
    final nextModel = (model ?? '').trim();
    final nextModelName = (modelName ?? '').trim();

    if (nextApiKey.isNotEmpty) {
      appAiBailianRuntimeApiKey = nextApiKey;
    }
    if (nextBaseUrl.isNotEmpty) {
      appAiBailianRuntimeBaseUrl = nextBaseUrl;
    }
    if (nextModel.isNotEmpty) {
      appAiBailianRuntimeModel = nextModel;
    }
    if (nextModelName.isNotEmpty) {
      appAiBailianRuntimeModelName = nextModelName;
    }
    appAiBailianModels = buildAppAiBailianModels(
      apiKey: appAiBailianRuntimeApiKey,
      baseUrl: appAiBailianRuntimeBaseUrl,
      model: appAiBailianRuntimeModel,
      modelName: appAiBailianRuntimeModelName,
    );
  }

  /// 功能：按当前运行时配置生成 AppAIPlugin 和移动端任务解析共用的模型列表。
  static List<Map<String, Object?>> buildAppAiBailianModels({
    String? apiKey,
    String? baseUrl,
    String? model,
    String? modelName,
  }) {
    final resolvedApiKey = (apiKey ?? appAiBailianRuntimeApiKey).trim();
    final resolvedBaseUrl = (baseUrl ?? appAiBailianRuntimeBaseUrl).trim();
    final resolvedModel = (model ?? appAiBailianRuntimeModel).trim();
    final resolvedModelName =
        (modelName ?? appAiBailianRuntimeModelName).trim();
    return <Map<String, Object?>>[
      <String, Object?>{
        // 默认模型放在 first，AIPage 和移动端语音 AI 建任务都会优先使用它。
        'name': resolvedModelName.isNotEmpty ? resolvedModelName : '通义千问 Plus',
        'baseUrl':
            resolvedBaseUrl.isNotEmpty ? resolvedBaseUrl : appAiBailianBaseUrl,
        'model':
            resolvedModel.isNotEmpty ? resolvedModel : appAiBailianDefaultModel,
        'apiKey': resolvedApiKey,
        'contextLength': 1000000,
        'maxTokens': 8192,
        'roles': <String>['chat', 'edit', 'apply'],
      },
      /*
    // 暂时只开放 Qwen2.5 Coder 32B；其他百炼模型先保留配置，后续需要时再恢复。
    <String, Object?>{
      'name': '通义千问 Max',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen-max',
      'apiKey': appAiBailianApiKey,
      'contextLength': 32768,
      'maxTokens': 8192,
      'roles': <String>['chat', 'edit', 'apply'],
    },
    <String, Object?>{
      'name': '通义千问 Plus (1M)',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen-plus',
      'apiKey': appAiBailianApiKey,
      'contextLength': 1000000,
      'maxTokens': 8192,
      'roles': <String>['chat', 'edit'],
    },
    <String, Object?>{
      'name': '通义千问 Turbo',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen-turbo',
      'apiKey': appAiBailianApiKey,
      'contextLength': 1000000,
      'maxTokens': 8192,
      'roles': <String>['chat'],
    },
    <String, Object?>{
      'name': '通义千问 Long (10M)',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen-long',
      'apiKey': appAiBailianApiKey,
      'contextLength': 10000000,
      'maxTokens': 6000,
      'roles': <String>['chat'],
    },
    <String, Object?>{
      'name': 'Qwen3 Max',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen3-max',
      'apiKey': appAiBailianApiKey,
      'contextLength': 262144,
      'maxTokens': 32768,
      'roles': <String>['chat', 'edit', 'apply'],
    },
    <String, Object?>{
      'name': 'QwQ Plus (推理)',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwq-plus',
      'apiKey': appAiBailianApiKey,
      'contextLength': 131072,
      'maxTokens': 8192,
      'roles': <String>['chat'],
    },
    <String, Object?>{
      'name': 'Qwen2.5 72B Instruct',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen2.5-72b-instruct',
      'apiKey': appAiBailianApiKey,
      'contextLength': 131072,
      'maxTokens': 8192,
      'roles': <String>['chat', 'edit'],
    },
    <String, Object?>{
      'name': 'Qwen2.5 32B Instruct',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'qwen2.5-32b-instruct',
      'apiKey': appAiBailianApiKey,
      'contextLength': 131072,
      'maxTokens': 8192,
      'roles': <String>['chat'],
    },
    <String, Object?>{
      'name': 'DeepSeek V3',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'deepseek-v3',
      'apiKey': appAiBailianApiKey,
      'contextLength': 65536,
      'maxTokens': 8192,
      'roles': <String>['chat', 'edit'],
    },
    <String, Object?>{
      'name': 'DeepSeek R1 (推理)',
      'baseUrl': appAiBailianBaseUrl,
      'model': 'deepseek-r1',
      'apiKey': appAiBailianApiKey,
      'contextLength': 65536,
      'maxTokens': 8192,
      'roles': <String>['chat'],
    },
    */
    ];
  }
}

class ResourceInfo {
  static ResourceLocationInfoBean? pcMissionBackgroundResourceLocationInfoBean;
  static ResourceLocationInfoBean?
      mobileMissionBackgroundResourceLocationInfoBean;
  static ResourceLocationInfoBean? allMissionBackgroundResourceLocationInfoBean;
  static ResourceLocationInfoBean? famousSentenceResourceLocationInfoBean;
  static List<ResourceLocationInfoBean>?
      clockInSentenceResourceLocationInfoBeanList; //打卡默认语句
  static ResourceLocationInfoBean? promptsGptResourceLocationInfoBean; //打卡默认语句
  static ResourceLocationInfoBean? missionItemBackgroundLocationInfoBean;

  static ResourceLocationInfoBean? chatGptRolesResourceLocationInfoBean;
  static ResourceLocationInfoBean?
      chatGptRolesForCreateMissionResourceLocationInfoBean;
}

class DeliveryInfoBean {
  static ResourceDeliveryInfoBean? isVIPPurchaseOn;
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
  static bool isRatingDialogOn = true; //华为秒验开关
  static bool isCourseOn = true; //华为秒验开关

  static bool isRegisterDynamicCode = false;
  static bool isHuaweiSecVerifyOn = false; //华为秒验开关

  static bool isAppleLoginOn = false; //apple秒验开关
  static bool isGoogleLoginOn = false; //google秒验开关

  static bool isRegister123456 = false; // 123456注册开关
}

class Urls {
  static String missionNoteSharing =
      "https://www.timerbell.com/web/app/md/"; // 任务管理分享
  static String isUserExistByEmail =
      "/api/common/isUserExistByEmail"; // 判断用户是否存在
  static String ratingGuide =
      "https://www.timerbell.com/views/ratingGuide"; // 评分引导
  static String eula_official =
      "https://www.timerbell.com/views/eula/eulaOfficial"; // eula 支付需要使用

  static String facebook =
      "https://www.facebook.com/profile.php?id=100090694350100"; // facebook
  static String privacyProtocol =
      "https://www.timerbell.com/views/protocol/privacyProtocol"; // 隐私协议
  static String privacyProtocolOfficial =
      "https://www.timerbell.com/views/protocol/privacyProtocolOfficial"; // 官方隐私协议
  static String privacyProtocolXiaoMi =
      "https://www.timerbell.com/views/protocol/privacyProtocolXiaomi"; // 小米隐私协议
  static String privacyProtocolVivo =
      "https://www.timerbell.com/views/protocol/privacyProtocolVivo"; // vivo隐私协议
  static String mgmHomeUrl = Params.mUrl + "/mgm/home";
}

class Apis {
  static String getRedis = "/api/redis/getRedis"; // get
  static String setRedis = "/api/redis/setRedis"; // post
  static String getOssToken = "/api/common/getOssToken"; // 获取aliyun token
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
  static String getEmailDynamicCode = "/api/common/getEmailDynamicCode";
  static String resetPwdByEmail = "/api/timehello/resetPwdByEmail";
  static String unregisterAccount = "/api/common/unregisterAccount";
  static String updateUser = "/api/timehello/updateUser";
  static String resetPwd = "/api/timehello/resetPwd"; //重置密码
  static String updateAvatar = "/api/timehello/updateAvatar"; //更新用户头像
  static String updateVipProductList =
      "/api/timehello/updateVipProductList"; //更新vip产品列表

  static String loginWithTokenUid =
      "/api/timehello/loginWithTokenUid"; //闪屏页更新用户信息
  // static String upload = '/api/common/upload'; //上传图片
  static String uploadOss = '/api/common/uploadOss'; //上传图片
  static String uploadOSSFile = '/api/common/uploadOSSFile'; //上传图片
  static String getResourceList = "/api/resource/scene/getList"; //资源位请求
  static String updateTotalFocusTime = "/api/timehello/updateTotalFocusTime";
  static String getUserRankingList = "/api/timehello/getUserRankingList"; //
  static String sendAliyunNotificationRule =
      "/api/timehello/sendAliyunNotificationRule"; //发送推送
  static String delAliyunSchedule = "/api/timehello/delAliyunSchedule"; //删除定时任务
  static String unbindAliyunAlias =
      "/api/timehello/unbindAliyunAlias"; //绑定alias
  static String bindAliyunAlias = "/api/timehello/bindAliyunAlias"; //绑定alias
  static String pushAliyunNotificationWithAlias =
      "/api/timehello/pushAliyunNotificationWithAlias"; //根据alias推送 alias指单个用户
  static String gameRankingAdd = "/api/timehello/gameRankingAdd"; //添加游戏分数
  static String gameRankingGetList =
      "/api/timehello/gameRankingGetList"; //游戏排名列表
  static String focusRankingHeartbeat =
      "/api/timehello/focusRankingHeartbeat"; //专注榜心跳
  static String focusRankingStop = "/api/timehello/focusRankingStop"; //专注榜停止
  static String focusRankingGetList =
      "/api/timehello/focusRankingGetList"; //专注榜列表
  static String getRandomItem =
      "/api/timehello/gameComparePictureController/getRandomItem"; //拉取随机图片
  static String getComparePicturesList =
      "/api/timehello/gameComparePictureController/getList"; //拉取随机图片
  static String getVocabulariLevelList =
      "/api/timehello/vocabularyController/getVocabulariLevelList"; //获取图片登记列表
  static String getVocabulariUnits =
      "/api/timehello/vocabularyController/getVocabulariUnits"; //获取单元...登下载链接
  static String shareSdkSecLogin = "/api/common/shareSdkSecLogin"; //秒验登录
  static String aliSdkSecLogin = "/api/common/aliSdkSecLogin"; //秒验登录

  static String getTextVoiceList =
      "/api/timehello/textVoiceController/getList"; //获取文字声音mp3
  static String uploadOssJSON = "/api/common/uploadOssJSON"; //上传json到阿里云

  static String getReceipt = "/api/storekit/receipt/verify";
  static String vipCodeInfo = "/api/vipcode/info"; // 查询 VIP Code 信息
}

//Shareprefrence的key
class ShareprefrenceKeys {
  static String isProtocolShowed = "ezjzifjezfzefzf";
  static String missionColumnOrder = "ezjzifjezf";
  static String missionColumnVisible = "jezijfizjefczf";
  static String missionColumnWidth = "jeifziefizefzfefz";
  static String insertMissionCount = "jeifziefizef";
  static String needResetPassword = "jewijfizfc";
  static String default9DigitPasswordsNeedShowWhenLoginAppLock = "efzfsace";
  static String default9DigitPasswordsNeedShowWhenLogin =
      "eififizsifizefizefijzefceizf";
  static String default9DigitPasswords = "eififizsifizefizefij";
  static String defaultPasswordKey = "wjeifjeidsqw";
  static String defaultThemeColor = "defaultThemeColor";
  static String themeMode = "themeMode";
  static String defaultSplash = "defaultSplash";
  static String defautCalendarContainerPageIndex =
      "defautCalendarContainerPageIndex";
  static String defautTimerContainerPageIndex = "defautTimerContainerPageIndex";
  static String flomoRatingDialogDontRemindAgain =
      "flomoRatingDialogDontRemindAgain";
  static String isMissionDetailStatsOpen = "isMissionDetailStatsOpen";
  static String isMissionDetailFocusRankingOpen =
      "isMissionDetailFocusRankingOpen";
  static String isMissionDetailFocusRankingShareOpen =
      "isMissionDetailFocusRankingShareOpen";
  static String listAndGridView = "listAndGridView";
  static String hasCameraPermissionRequested = 'hasCameraPermissionRequested';
  static String hasMicrophonePermissionRequested =
      'hasMicrophonePermissionRequested';
  static String pcBackground = "pcBackground";
  static String numTimesOpen = "numTimesOpen";
  static String mobleBackground = "mobleBackground";
  static String timerModel = "timerModel";
  static String hasRating = "hasRating";
  static String deviceId = "deviceId";
  static String fourquadrantVisible = "fourquadrantVisible";
  static String fourQuadrantOrderMode = "fourQuadrantOrderMode";
  static String folderOrderObjectId = "folderOrderObjectId";
  static String folderOrderObjectIdForOtherFolders =
      "folderOrderObjectIdForOtherFolders"; // 其他文件夹的排序
  static String folderOrderObjectIdArchived = "folderOrderObjectIdArchived";
  static String folderOrderObjectIdForOtherFoldersArchived =
      "folderOrderObjectIdForOtherFoldersArchived"; // 其他文件夹的排序
  static String gptUserSystemMessage = "gptUserSystemMessage";
  static String objectiveUnitHistory = "objectiveUnitHistory";
  // AI 回复助手本地配置（Profile/当前 Profile/LLM 模式与密钥/模型）。
  static String aiReplyProfiles = "aiReplyProfiles";
  static String aiReplyActiveProfileId = "aiReplyActiveProfileId";
  static String aiReplyLlmMode = "aiReplyLlmMode";
  static String aiReplyOpenAiKey = "aiReplyOpenAiKey";
  static String aiReplyClaudeKey = "aiReplyClaudeKey";
  static String aiReplyOpenAiModel = "aiReplyOpenAiModel";
  static String aiReplyClaudeModel = "aiReplyClaudeModel";
  static String SettingModelKey = "SettingModelKey";
  static String SettingItemDetailTimeModeKey = "SettingItemDetailTimeModeKey";
  static String curFocusingMissionObjectIdKey = "curFocusingMissionObjectIdKey";
  static String curFocusingMissionObjectIdForTimeUsedKey =
      "curFocusingMissionObjectIdForTimeUsedKey";
  static String curFocusingMissionObjectIdForCurTimeFKey =
      "curFocusingMissionObjectIdForCurTimeFKey";
  static String curFocusingMissionObjectIdForTotalTimeFKey =
      "curFocusingMissionObjectIdForTotalTimeFKey";
  static String UserInfoModelKey = "jeizfjizejfizewf";
  static String TimeRatioProgressSortEnumKey = "zefczefzejfjizefji";
  static String curSelectedFindWidgetScene =
      "curSelectedFindWidgetScene1"; //桌面当前选择组件
  static String curSelectedFindWidgetIndex =
      "curSelectedFindWidgetIndwx1"; //桌面当前选择组件
  static String curLocaleLanguage = "curLocaleSelected123"; //桌面当前选择组件
  static String curLocaleCountryCode = "curLocaleCountryCode321"; //桌面当前选择组件

  static String layoutIconType14 = "zefzezefzfw"; //桌面当前选择组件
  static String layoutIconType15 = "zzefzwfsdefzezefzfw"; //桌面当前选择组件
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
