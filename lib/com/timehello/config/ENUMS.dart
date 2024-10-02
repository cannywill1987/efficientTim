enum TimeUnitEnum {
  days,
  hours,
  minutes,
}

enum SelectTypeEnum {
  single,
  multiple,
}

enum LoadingStatusEnum {
  normal,
  loading,
  success,
  error,
}

enum FileExtension {
  md,
  json,
  txt,
  pdf,
  doc,
  docx,
  xls,
  xlsx,
  ppt,
  pptx,
  jpg,
  jpeg,
  png,
  gif,
  mp3,
  mp4,
  avi,
  flv,
  wmv,
  mov,
  m4a,
  m4v,
  mkv,
  rmvb,
  rm,
  wma,
  wav,
  aac,
  amr,
  zip,
  rar,
  sevenz,
  tar,
  gz,
  bz2,
  apk,
  exe,
  dmg,
  iso,
  deb,
  rpm,
  ipa,
  app,
  appx,

}

enum DocType {
  md,
  document,
  image,
  audio,
  video,
  attachment, //附件
}

enum ProgressSortEnum {
  Lyubichs, // 柳比歇斯
  previewTime, // 预估时长排序
  duration, //时长排序
  tomato, // 番茄钟排序
  priority, // 优先级排序
  tag, // 标签排序
  completeNum, // 完成任务数排序
  focusDuration, // 专注时长排序

}

enum CorrectStatusEnum {
  normal,
  success,
  correct,
  wrong
}

enum OnlineStatusEnum {
  offline,
  online,
  focusing,
  relaxing,
}

enum PageGPTFromEnum {
  RightBarPage,
  AIHelperPage
}

enum WrapModeEnum {
  scroll,
  wrap
}

enum ChatModeEnum {
  text,
  statistic,
  create_missions
}

enum ChatGptPageEnum {
  chatGptPage,
  morePage,
  historyPage,
  none,
}

enum MissionDataViewTypeEnum { list, grid, timeline, table }

enum PageModeEnum { create, edit, delete }

enum MultiSelectModeEnum { normal, multiSelect }

enum FolderPageViewEnum {
  filterer, //筛选
  tag,
  listing_unarchive,
  listing_archive,
  normal
}

enum EditorEditModeEnum {
  normal,
  editing,
  saving,
  saved_success,
  saved_fail,
}

// enum SaveModeEnum {
//   save,
//   update,
//   normal
// }

enum WQBSceneEnum {
  note, //便签
  question_wrong_book, //错题本
  memorandum, //备忘录
  card, //卡片
}

enum SaveModeEnum {
  save, //创建
  normal, //浏览
  update //更新
}

enum WQBWrongQuestBookSceneEnum {
  knowledge_point,
  question_wrong_question,
  correct_answer,
  none
}

enum WQBEditModeEnum {
  image,
  record,
  plain_text,
  rich_text,
  new_rich_text,
  none
}

enum SortEnum {
  ascendant,
  descendant
}

enum PageEnum {
  FolderPage,
  StatisticPage,
  QuadrantPage,
  CalendarPage,
  MinePage,
  TimelinePage,
  TimeManagementPage,
  Normal,
  MissionPage, // 任务页
  LiveActivity, // 从live widget过来
  CountDownListViewPage
}

enum CalendarTypeEnum {
  day,
  last7Days,
  month,
  year,
  all,
  custom
}

enum CompleteStatusEnum {
  finished,
  unfinished,
}

enum RichTextModeEnum {
  diary,
  note,
  getUrl //单纯为了得到ossurl 返回给上一级
}

enum TimelineModeEnum {
  all,
  event,
  note,
  diary,
  transaction,
}

enum WQBModeEnum {
  all,
  wrong_question_book,
  card,
  note,
  memorandum,
}

enum ColorShadowEnum {
  red,
  orange,
  blue
}

enum EditModeEnum { normal, edit, uneditable }

enum PriorityEnum {
  red1,
  yellow2,
  blue3,
  green4
}

//当前渠道
enum ChannelEnum {
  normal, //普通模式
  huawei, //华为应用市场需要特殊处理
  xiaomi,
  vivo,
  oppo,
  Google,
  samsung,
  sony,
  lg,
  Sony,
  Ios,
  Ipad,
  Mac
}

enum EnvEnum {
  dev, //开发
  uat, //灰度
  prd //生产
}

enum PageNavShowEnum {
  none, //页面导航栏不显示
  show, //显示
}

enum AvatarEnum {
  edit, //编辑模式
  defaut //默认模式
}

/**
 * 用于计数和倒数
 */
enum CounterEnum {
  chronograph, //从正数数到0
  timer, //0数到正数
}



enum DeviceTypeEnum {
  MACOS,
  WINDOWS,
  IOS,
  WEB,
  ANDROID
}

//当前渠道
enum LoginTypeEnum {
  normal, //普通模式
  secVerify, //sharesdk秒验
  email,
  phone,
  facebook,
  twitter,
  google,
  apple
}


enum PageFromEnum {
  LoginPage,
  ForgetPassword,
  RegisterPage,
  ScreenLockPage,
  MissionDetailPage,
  Normal,
  MinePage,
  WQBPage,
  MobileMinePage,
  PresentDialog, //从对话框展示
  others, create,
  Default
}

enum MissionOrderEnum {
  orderByWords, //按清单排序
  orderByTime, //按时间排序
  orderByPriority, //按任务优先级排序
  orderByTag, //按任务标签排序
  orderByCreatedTime, //根据创建时间排序
  orderByUpdateTime, //根据更新时间排序

}

/**
 * 位置不能换
 */
enum CounterStatus{
  focusing, //专注中 红色计时中
  pausingFocusing, //专注暂停中
  relaxing, //休息中 蓝色计时中
  waitingToFocus, //等待专注中
  waitingToStartRelaxing, //等待休息启动
  pausingRelaixing, //暂停休息中
  none, //没任何选择
}


/**
 * 用于判断登录或者祖册
 */
enum LoginAndRegisterEnum {
  login,
  register,
  splashScreen //闪屏页初始化
}


enum DateTypeEnum {
  day,
  last7Days,
  last14Days,
  lastMonth,
  lastYear,
  custom,
}

enum LoginMode { none, loginAuto, LoginMSN, LoginPassword, LoginOnePress }

enum ScreenType { Desktop, Tablet, Handset, Watch}

enum StatisticTypeEnum {
  time, //时间
  number //数量
}

/**
 * 用于游戏远点防止的位置
 */
enum GameDotPositionEnum {
  left,
  topLeft,
  topCenter,
  topRight,
  right,
  bottomRight,
  bottomCenter,
  bottomLeft,
  random,
  none
}

enum SingleCharCheckModeEnum {
  normal,
  color,
}

enum CounterMode {
  timer,

}

enum GameStatusModeEnum {
  WaitingToStart,
  ReadyTimeCounting,
  Starting,
  Finished
}

enum Game4EngLevelModeEnum {
  level1_show_words,
  level2_hide_leftpart_words, //隐藏英文
  level3_hide_rightpart_words, //隐藏中文
  level4_hide_all_parts, //隐藏所有词汇
  level5_write_words, //默写
}

enum Game1EngLevelModeEnum {
  level1_num_10,
  level2_num_20, //隐藏英文
  level3_num_50, //隐藏中文
}


enum GameLevelModeEnum {
  Level1,
  Level2,
  Level3,
  Level4,
  Level5,
}

enum TimelinePageFromEnum {
  normal,
  StatisticPage,
  FolderStatisticPage
}

enum GameRankingModeEnum {
  TimeCounting, //计时器计算 在gameCounterWidget请求
  Customized,
}

enum JumpModeEnum{
  backMode,
  pushMode
}

enum GameItemStatusEnum{
  correct,
  fail,
  complete
}

enum GameTableMode{
  SingleCharTextWidget,
  Text,
}

enum FlomoRepeatModeEnum{
  byDay,
  byWeek,
  byMonth,
  byEbbinghaus
}