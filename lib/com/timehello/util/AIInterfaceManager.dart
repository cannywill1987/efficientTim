import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:app_ai_plugin/app_ai_plugin.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/models/StatsModel.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/page/CreateAIChatGptMissionPage/CreateAIChatGptMissionWidget.dart';
import 'package:time_hello/com/timehello/page/CreateAIChatGptMissionPage/CreateAIMissionContainerWidget.dart';
import 'package:time_hello/com/timehello/util/NotificationManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:url_launcher/url_launcher.dart';

class AIInterfaceManager {
  AIInterfaceManager._();

  static final AIInterfaceManager _instance = AIInterfaceManager._();

  static const String createMissionsToolName = 'timehello.create_missions';
  static const String batchCreateMissionsToolName =
      'timehello.batch_create_missions';
  static const String deleteMissionToolName = 'timehello.delete_mission';
  static const String batchDeleteMissionsToolName =
      'timehello.batch_delete_missions';
  static const String listMissionsToolName = 'timehello.list_missions';
  static const String updateMissionsToolName = 'timehello.update_missions';
  static const String listFoldersToolName = 'timehello.list_folders';
  static const String createFoldersToolName = 'timehello.create_folders';
  static const String batchCreateFoldersToolName =
      'timehello.batch_create_folders';
  static const String updateFoldersToolName = 'timehello.update_folders';
  static const String deleteFolderToolName = 'timehello.delete_folder';
  static const String batchDeleteFoldersToolName =
      'timehello.batch_delete_folders';
  static const String listStatsToolName = 'timehello.list_stats';
  static const String createStatsToolName = 'timehello.create_stats';
  static const String listTimelineToolName = 'timehello.list_timeline';
  static const String createTimelineToolName = 'timehello.create_timeline';
  static const String generateReportToolName = 'timehello.generate_html_report';
  static const String openHtmlReportToolName = 'timehello.open_html_report';
  static const String getCurrentTimeToolName = 'timehello.get_current_time';

  static const Set<String> _supportedToolNames = <String>{
    createMissionsToolName,
    batchCreateMissionsToolName,
    deleteMissionToolName,
    batchDeleteMissionsToolName,
    listMissionsToolName,
    updateMissionsToolName,
    listFoldersToolName,
    createFoldersToolName,
    batchCreateFoldersToolName,
    updateFoldersToolName,
    deleteFolderToolName,
    batchDeleteFoldersToolName,
    listStatsToolName,
    createStatsToolName,
    listTimelineToolName,
    createTimelineToolName,
    generateReportToolName,
    openHtmlReportToolName,
    getCurrentTimeToolName,
  };

  BuildContext? _context;
  String? _lastHtmlReportPath;
  String? _lastHtmlReportUrl;
  bool _isAiPanelHidden = false;

  static AIInterfaceManager getInstance() {
    return _instance;
  }

  void registerContext(BuildContext context) {
    _log(
        'registerContext mounted=${context.mounted} hasNavigator=${Navigator.maybeOf(context) != null}');
    _context = context;
  }

  void unregisterContext(BuildContext context) {
    if (_context == context) {
      _log('unregisterContext');
      _context = null;
    }
  }

  /// AI 工具直接改 FolderModel 时，需要同时刷新左侧文件夹树。
  ///
  /// FoldersPage 的文件夹树不是直接监听 ACTION_UPDATE_LISTVIEW；
  /// 这里补发文件夹页事件，避免创建成功但侧栏仍停留在旧缓存。
  void _fireFolderChanged({FolderModel? folder}) {
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    eventBus.fire(EventFn(Params.ACTION_UPDATE_FOLDER_PAGE, {}));
    _log('fired folder update events folderId=${folder?.objectId}');
  }

  void setAiPanelHidden(bool hidden) {
    _isAiPanelHidden = hidden;
    _log('setAiPanelHidden hidden=$hidden');
  }

  void notifyAiReplyFinishedIfHidden() {
    if (!_isAiPanelHidden) {
      return;
    }
    _log('notifyAiReplyFinishedIfHidden');
    try {
      Utility.showToastMsg(msg: 'AI 回复已完成');
    } catch (error, stackTrace) {
      _log('show ai finish toast failed', error: error, stackTrace: stackTrace);
    }
    try {
      NotificationManager.getInstance()?.pushNotificationWithdelay(
        title: 'TimeHello AI',
        content: 'AI 回复已完成，重新打开 AI 面板即可继续查看。',
        delay: 0,
        extendsParams: '{}',
        id: 'timehello_ai_reply_finished',
      );
    } catch (error, stackTrace) {
      _log('push ai finish notification failed',
          error: error, stackTrace: stackTrace);
    }
  }

  HostAdapter createHostAdapter() {
    return _AIInterfaceHostAdapter(this);
  }

  List<Map<String, Object?>> getRules() {
    final currentTimeRule = _currentTimeRuleText();
    return <Map<String, Object?>>[
      <String, Object?>{
        'name': 'TimeHello 创建任务参数规范',
        'slug': 'timehello-create-mission-arguments',
        'source': 'rules-block',
        'alwaysApply': true,
        'rule': '''
当用户要求创建、添加、安排任务时，优先使用 timehello.create_missions 工具。
当用户一次创建多条任务时，也可以使用 timehello.batch_create_missions，参数格式与 timehello.create_missions 完全一致。
当用户要求删除任务时，使用 timehello.delete_mission；一次删除多条任务时，使用 timehello.batch_delete_missions。
当用户要求查看/查询任务时，使用 timehello.list_missions；修改任务标题、时间、清单、完成状态、优先级时，使用 timehello.update_missions。
当用户说“把任务 A 改成 B / 将任务 A 重命名为 B”时，必须调用 timehello.update_missions，参数 {"datas":[{"title":"A","new_title":"B"}]}，不要只口头回复成功。
当用户说“把 A 任务改成今天完成 / 标记 A 已完成 / 完成任务 A”时，必须调用 timehello.update_missions，参数 {"datas":[{"title":"A","isFinished":true,"finish_time":当前时间毫秒}]}；不要只口头回复成功。
当用户要求创建、查看、修改、删除清单/文件夹/标签时，使用 timehello.create_folders、timehello.list_folders、timehello.update_folders、timehello.delete_folder 或 timehello.batch_delete_folders。
当用户说“把清单 A 移动到文件夹 B 下”时，必须调用 timehello.update_folders，参数 {"datas":[{"title":"A","lookup_tag":1,"parent_folder_title":"B"}]}；这里移动的是 FolderModel(tag=1) 清单到 FolderModel(tag=3) 文件夹容器，不是移动任务。
当用户要求查询统计、创建统计记录、查询时间线、创建时间线记录或生成报表页面时，使用 timehello.list_stats、timehello.create_stats、timehello.list_timeline、timehello.create_timeline 或 timehello.generate_html_report。
$currentTimeRule
当用户提到“今天、明天、昨天、本周、本月、刚才、现在”等相对时间时，必须先调用 timehello.get_current_time 获取宿主本地时间，不要使用模型内置日期或训练数据日期。
查询“今天完成了哪些任务”时，先调用 timehello.get_current_time，再调用 timehello.list_missions，并传 isFinished=true、completed_start_time=dayStartMillis、completed_end_time=nextDayStartMillis；不要把今天误认为 2023-10-05。
查询“今天未完成/待办任务”时，调用 timehello.list_missions，并传 dateStatus=1、isFinished=false；不要传 completed_start_time/completed_end_time，这两个字段只用于“已完成任务按完成时间过滤”。
查询“明天有什么任务/明天的安排”时，调用 timehello.list_missions，并传 dateStatus=2、isFinished=false；不要只按模型自由生成的日期文本查询。
当用户问“清单 X 有什么 / 清单 X 下有哪些任务”时，必须调用 timehello.list_missions，并传 folder_title/list_title/listing_title=X；不要把 X 当作任务 title 查询。
当用户问“X 标签有什么任务 / 带有 X 标签的任务”时，必须调用 timehello.list_missions，并传 tagName/tagNames=X；不要把 X 当作任务 title 或 folder_title 查询。

timehello.create_missions 必须使用 TimeHello MissionModel / MongoDB 的标准字段，不要使用别名字段：
- 必填：title，字符串，任务标题。
- folder_id 是 FolderModel.objectId，表示任务所属清单；folder_title 只是给 AI/宿主解析用，不是 MissionModel 的持久化字段。
- 查询某个清单下任务时必须先通过 FolderModel.title 精确解析 tag=1 清单，再用 MissionModel.folder_id == FolderModel.objectId 过滤；如果清单不存在或同名清单不唯一，不要返回全量任务。
- 查询某个标签下任务时使用 MissionModel.tagNames/tagIds；标签查询不走 folder_id，也不要把标签名当任务标题。
- group_id 是分组展示时的 GroupModel objectId；用户没说分组时不要随便填写。
- 时间模式 time_mode：0=日期任务，1=时间段任务，2=目标任务。
- 日期任务：使用 time_mode=0，设置 end_time 为本地毫秒时间戳或 ISO8601；可设置 dateStatus，1=今天，2=明天，3=最近7天，4=所有未完成，12=待定任务，13=碎片清单。
- 时间段任务：使用 time_mode=1，同时设置 start_time 和 end_time；如果只有截止日期/今天/明天，一般不要生成 1970 或 0 时间。
- 创建/更新全天任务时，end_time 使用当天 23:59:59.000；不要使用 23:59:59.999，也不要把明天 00:00 当作当天的 end_time。
- 目标任务：使用 time_mode=2，可设置 objectiveUnit、objectiveValue、objectiveTotalValue、objectiveStartValue；不要把目标值写进普通番茄字段。
- priorityStatus：3=无优先级，2=低，1=中，0=高。默认 3。
- isFinished 默认 false；isDelayed 默认 false；total_tomotoes 默认 1；tomato_duration 默认 25*60*1000 毫秒。
- tagNames/tagIds 在 MissionModel 中是逗号分隔字符串；工具可接收数组或字符串，宿主会转成字符串。
- subMissions 是数组，元素至少包含 title，可带 isFinished、notificationTime、numToamatoesFocused、numToamatoTotal、create_time、update_time。
- alert_time 是通知时间毫秒时间戳；重复任务相关字段 repetiveType/repetiveValue/repetiveWeekDay/repetive_end_time 只有用户明确要求重复时才填写。
- 当用户说“在某清单下创建任务”但没有提供 folder_id 时，仍然传 folder_title；宿主会先精确查找 tag=1 的任务清单，不存在则创建 tag=1 清单，再把任务挂到该清单。
- 当用户说“在文件夹 X 下创建任务 Y”时，不要把任务直接挂到 tag=3 文件夹；应先在文件夹 X 下创建或定位一个 tag=1 清单，再把任务挂到该清单。
- 禁止输出 name、taskName、due_date、deadline 等非标准字段；必须先转换为 title、start_time、end_time、time_mode。
- 相对日期要先换算为具体时间：今天、明天、后天、下周等都不要原样放入参数。

示例：
用户：创建"12345"的任务，后天截止
工具参数：
{"datas":[{"title":"12345","time_mode":0,"end_time":"2026-05-02T00:00:00+08:00","total_tomotoes":1}]}

删除任务参数规范：
- 优先使用 objectIds / ids / missionIds 数组，或 objectId / id / mission_id 单个 ID。
- 如果用户只给出任务标题，可以使用 titles / exact_titles 数组，或 title 单个标题；必须是精确标题，不要用模糊词。
- 如果同名任务有多条，工具会返回 ambiguous，不要假装删除成功，应提示用户补充具体任务。

FolderModel / 清单参数规范：
- 创建可承载任务的普通清单/列表时使用 tag=1；创建文件夹/目录容器时使用 tag=3；创建标签时使用 tag=2；创建筛选器时使用 tag=4；创建目标模块时使用 tag=5。用户没有明确说明时，默认创建 tag=1 清单。
- 必填：title，字符串，清单/文件夹/标签标题。
- 可选字段：description、tag、color、icon、iconType、layoutType、folderStatus、filterType、parent_folder_id、parent_folder_title、folderModelObjectIdOrderList、groupModelObjectIdOrderList。
- tag=1：任务清单/列表，MissionModel.folder_id 应指向这类 FolderModel.objectId；可设置 layoutType，0=列表，1=分组，2=时间线；可设置 cryptoVersion，-1=不加密，0=设置加密。
- tag=1 清单必须有 folderTeamWorkId，等价于页面上的群号；创建时如果用户没有传，宿主必须用 Utility.getGroupId() 生成。
- tag=1 清单的默认 icon 应使用 Icons.circle.codePoint；不要使用 Icons.local_offer，后者是标签外观。
- tag=3：文件夹/目录容器，不直接承载任务；它通过 folderModelObjectIdOrderList 保存子 FolderModel.objectId 的排序，通常子项是 tag=1 清单或 tag=5 目标。
- tag=2：标签，tagName 通常等于 title；不要把 tag=2 当作任务清单。颜色必须使用 TimeHello 色板，可传 colorName：红色/橙色/黄色/绿色/蓝色/紫色/粉色/灰色。
- tag=4：过滤器，filterType=1，filterConditionMap 保存筛选条件，例如 priority、keyword、missionType、startTime、endTime、listingId。
- tag=5：目标模块，形态类似清单，但用于目标；用户明确说目标/Objective 时才使用。
- folderStatus：0=未归档，1=归档。没有明确归档意图时填 0。
- iconType 主要用于内置入口，不要随便写今天/明天/日程等内置入口值；普通清单/文件夹默认 0。
- 如果用户说“在文件夹 X 下创建清单 Y”，创建 tag=1 的 Y，并将 Y 的 objectId 写入 tag=3 文件夹 X 的 folderModelObjectIdOrderList。
- 如果用户说“创建清单 X”，不要创建 tag=3 文件夹；应该创建 tag=1。只有用户明确说“文件夹/目录/分组容器”时才创建 tag=3。
- 删除或更新 FolderModel 时优先使用 objectId / objectIds；只有用户明确给出精确标题时，才使用 title / titles。
- 如果同名 FolderModel 有多条，工具会返回 ambiguous，应提示用户补充具体清单。

StatsModel / TimelineMissionModel 参数规范：
- StatsModel 使用数据库标准字段：title、type、tagNames、category、color、icon、value、begin_time、finish_time、folder_id、mission_id。value 是毫秒时长；duration 是 Flutter 客户端派生值，不要作为写入字段。
- TimelineMissionModel 使用标准字段：sceneType、eventType、timelineMessage、extra、picUrl、url、color、icon、tagName、mission_id、object_id、folder_id、title、tagNames、tagIds、end_time、alert_time、time_finished、message、isFinished、isDelayed。
- 生成 HTML 报表页面必须调用 timehello.generate_html_report；报表数据来自宿主缓存 listStatsModels 和 listTimelineMissionModel。
''',
      },
    ];
  }

  String _currentTimeRuleText() {
    // 直接把宿主当前时间写进 rules，避免模型在工具调用前先用训练期日期做推断。
    final now = DateTime.fromMillisecondsSinceEpoch(
      Utility.getTimeStampToday(),
    );
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    final weekStart =
        todayStart.subtract(Duration(days: todayStart.weekday - 1));
    final nextWeekStart = weekStart.add(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month);
    final nextMonthStart = DateTime(now.year, now.month + 1);
    return '''
【宿主当前时间，必须优先相信这里】
- 当前本地时间：${now.toIso8601String()}
- 当前毫秒时间戳：${now.millisecondsSinceEpoch}
- 时区：${now.timeZoneName} UTC${_formatTimezoneOffset(now.timeZoneOffset)}
- 今天日期：${_formatDate(todayStart)}
- 今天开始毫秒：${todayStart.millisecondsSinceEpoch}
- 明天开始毫秒：${tomorrowStart.millisecondsSinceEpoch}
- 昨天开始毫秒：${yesterdayStart.millisecondsSinceEpoch}
- 本周开始毫秒：${weekStart.millisecondsSinceEpoch}
- 下周开始毫秒：${nextWeekStart.millisecondsSinceEpoch}
- 本月开始毫秒：${monthStart.millisecondsSinceEpoch}
- 下月开始毫秒：${nextMonthStart.millisecondsSinceEpoch}
涉及“今天完成的任务”时，必须使用：isFinished=true, completed_start_time=${todayStart.millisecondsSinceEpoch}, completed_end_time=${tomorrowStart.millisecondsSinceEpoch}。
注意：这些毫秒时间戳只允许作为工具参数使用，回复用户时禁止展示毫秒时间戳、completed_start_time、completed_end_time 等内部参数名。
''';
  }

  String getRuntimeSystemPrompt() {
    return '''
你正在 TimeHello 应用内回答用户问题。所有涉及当前日期、今天、昨天、明天、本周、本月、现在、刚才的判断，都必须以宿主时间为准，禁止使用模型训练日期或示例日期。
${_currentTimeRuleText()}
如果用户问“我今天完成了哪几个任务 / 今天完成了哪些任务”，必须使用今天开始毫秒和明天开始毫秒作为 completed_start_time / completed_end_time。
如果用户问“我今天未完成哪些任务 / 今天还有哪些任务没完成”，必须使用 dateStatus=1 和 isFinished=false，不要使用 completed_start_time / completed_end_time。
如果用户问“明天有什么任务 / 明天有哪些任务”，必须使用 dateStatus=2 和 isFinished=false。
回复用户时只说自然语言结果，不要提前解释工具参数，不要展示毫秒时间戳，不要展示 completed_start_time/completed_end_time/isFinished 这类内部参数名。
所有时间都要转成人能看懂的格式，例如“2026-05-01 19:50”或“今天 19:50”。
''';
  }

  List<Map<String, Object?>> getToolDefinitions() {
    return <Map<String, Object?>>[
      _getCurrentTimeToolDefinition(),
      _createMissionsToolDefinition(
        name: createMissionsToolName,
        displayTitle: '创建任务',
        description:
            'Create one or more TimeHello missions directly. Always use MissionModel standard fields: title, time_mode, start_time, end_time, dateStatus, priorityStatus, folder_id, tagNames, subMissions, total_tomotoes. Do not use aliases such as name or due_date.',
      ),
      _createMissionsToolDefinition(
        name: batchCreateMissionsToolName,
        displayTitle: '批量创建任务',
        description:
            'Batch create TimeHello missions. Use this when the user asks to create multiple tasks. Do not use it for folders/lists; use timehello.create_folders for lists.',
      ),
      _deleteMissionsToolDefinition(
        name: deleteMissionToolName,
        displayTitle: '删除任务',
        description:
            'Delete one TimeHello mission. Prefer objectId/id/mission_id. If only a title is available, pass exact title via title or titles; ambiguous titles will not be deleted.',
      ),
      _deleteMissionsToolDefinition(
        name: batchDeleteMissionsToolName,
        displayTitle: '批量删除任务',
        description:
            'Delete multiple TimeHello missions. Prefer objectIds/ids/missionIds. Exact title arrays are supported but ambiguous titles will be skipped.',
      ),
      _listMissionsToolDefinition(),
      _updateMissionsToolDefinition(),
      _listFoldersToolDefinition(),
      _createFoldersToolDefinition(
        name: createFoldersToolName,
        displayTitle: '创建清单',
        description:
            'Create one TimeHello FolderModel. Use tag=1 for task lists, tag=3 for folder containers, tag=2 for tags, tag=4 for filters, and tag=5 for objectives.',
      ),
      _createFoldersToolDefinition(
        name: batchCreateFoldersToolName,
        displayTitle: '批量创建清单',
        description:
            'Batch create TimeHello FolderModel records. Use this for multiple folders, lists, tags, or filters.',
      ),
      _updateFoldersToolDefinition(),
      _deleteFoldersToolDefinition(
        name: deleteFolderToolName,
        displayTitle: '删除清单',
        description:
            'Delete one TimeHello FolderModel. Prefer objectId/id/folder_id; exact titles are supported but ambiguous titles will not be deleted.',
      ),
      _deleteFoldersToolDefinition(
        name: batchDeleteFoldersToolName,
        displayTitle: '批量删除清单',
        description:
            'Delete multiple TimeHello FolderModel records. Prefer objectIds/ids/folderIds; exact title arrays are supported but ambiguous titles will be skipped.',
      ),
      _listStatsToolDefinition(),
      _createStatsToolDefinition(),
      _listTimelineToolDefinition(),
      _createTimelineToolDefinition(),
      _generateReportToolDefinition(),
      _openHtmlReportToolDefinition(),
    ];
  }

  Map<String, Object?> _createMissionsToolDefinition({
    required String name,
    required String displayTitle,
    required String description,
  }) {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': displayTitle,
      'wouldLikeTo': displayTitle,
      'readonly': false,
      'function': <String, Object?>{
        'name': name,
        'description': description,
        'parameters': <String, Object?>{
          'type': 'object',
          'required': <String>['datas'],
          'properties': <String, Object?>{
            'datas': <String, Object?>{
              'type': 'array',
              'description': 'Missions to create. They will be saved directly.',
              'items': <String, Object?>{
                'type': 'object',
                'required': <String>['title'],
                'properties': <String, Object?>{
                  'title': <String, Object?>{
                    'type': 'string',
                    'description': 'Task title.',
                  },
                  'time_mode': <String, Object?>{
                    'type': 'integer',
                    'description':
                        '0 means date task, 1 means time period task, 2 means objective task.',
                  },
                  'start_time': <String, Object?>{
                    'type': 'string',
                    'description':
                        'ISO8601 start time or millisecond timestamp.',
                  },
                  'end_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                    'description': 'ISO8601 end time or millisecond timestamp.',
                  },
                  'startTime': <String, Object?>{
                    'type': 'string',
                    'description': 'Legacy alias for start_time.',
                  },
                  'endTime': <String, Object?>{
                    'type': 'string',
                    'description': 'Legacy alias for end_time.',
                  },
                  'folder_id': <String, Object?>{'type': 'string'},
                  'folder_title': <String, Object?>{'type': 'string'},
                  'group_id': <String, Object?>{'type': 'string'},
                  'dateStatus': <String, Object?>{
                    'type': 'integer',
                    'description': '1=today, 2=tomorrow, 3=next 7 days.',
                  },
                  'priorityStatus': <String, Object?>{'type': 'integer'},
                  'tagNames': <String, Object?>{
                    'oneOf': <Object?>[
                      <String, Object?>{'type': 'string'},
                      <String, Object?>{
                        'type': 'array',
                        'items': <String, Object?>{'type': 'string'},
                      },
                    ],
                  },
                  'subMissions': <String, Object?>{
                    'type': 'array',
                    'items': <String, Object?>{'type': 'object'},
                  },
                  'total_tomotoes': <String, Object?>{'type': 'integer'},
                  'tomato_duration': <String, Object?>{'type': 'integer'},
                  'objectiveUnit': <String, Object?>{'type': 'string'},
                  'objectiveValue': <String, Object?>{'type': 'number'},
                  'objectiveTotalValue': <String, Object?>{'type': 'number'},
                },
                'additionalProperties': false,
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _deleteMissionsToolDefinition({
    required String name,
    required String displayTitle,
    required String description,
  }) {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': displayTitle,
      'wouldLikeTo': displayTitle,
      'readonly': false,
      'function': <String, Object?>{
        'name': name,
        'description': description,
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'objectId': <String, Object?>{
              'type': 'string',
              'description': 'Single MissionModel objectId.',
            },
            'id': <String, Object?>{
              'type': 'string',
              'description': 'Alias of objectId.',
            },
            'objectIds': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
              'description': 'MissionModel objectIds to delete.',
            },
            'ids': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
              'description': 'Alias of objectIds.',
            },
            'title': <String, Object?>{
              'type': 'string',
              'description': 'Exact mission title. Prefer objectId when known.',
            },
            'titles': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
              'description':
                  'Exact mission titles. Ambiguous titles will be skipped.',
            },
            'datas': <String, Object?>{
              'type': 'array',
              'description':
                  'Delete targets, each with objectId/id/mission_id or title.',
              'items': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'objectId': <String, Object?>{'type': 'string'},
                  'id': <String, Object?>{'type': 'string'},
                  'mission_id': <String, Object?>{'type': 'string'},
                  'title': <String, Object?>{'type': 'string'},
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _listMissionsToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '查询任务',
      'wouldLikeTo': '查询 TimeHello 任务',
      'readonly': true,
      'function': <String, Object?>{
        'name': listMissionsToolName,
        'description':
            'List TimeHello missions from the local MongoApisManager cache. For questions like "what is in list X", pass folder_title/list_title/listing_title so the host resolves FolderModel(tag=1) and filters by MissionModel.folder_id. Never pass the list name as task title.',
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'objectIds': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'title': <String, Object?>{'type': 'string'},
            'titles': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'folder_id': <String, Object?>{'type': 'string'},
            'folder_title': <String, Object?>{
              'type': 'string',
              'description':
                  'Exact FolderModel.title of a tag=1 task list. Host resolves this to folder_id before listing missions.',
            },
            'list_title': <String, Object?>{'type': 'string'},
            'listing_title': <String, Object?>{'type': 'string'},
            'tagName': <String, Object?>{
              'type': 'string',
              'description':
                  'Mission tag name. Use this for questions like "bugs 标签有什么任务".',
            },
            'tagNames': <String, Object?>{
              'oneOf': <Object?>[
                <String, Object?>{'type': 'string'},
                <String, Object?>{
                  'type': 'array',
                  'items': <String, Object?>{'type': 'string'},
                },
              ],
            },
            'tagIds': <String, Object?>{
              'oneOf': <Object?>[
                <String, Object?>{'type': 'string'},
                <String, Object?>{
                  'type': 'array',
                  'items': <String, Object?>{'type': 'string'},
                },
              ],
            },
            'time_mode': <String, Object?>{'type': 'integer'},
            'dateStatus': <String, Object?>{
              'type': 'integer',
              'description':
                  'Relative date bucket resolved by host. 1=today, 2=tomorrow, 3=next 7 days. For finished missions, dateStatus=1 with isFinished=true means completed today.',
            },
            'start_time': <String, Object?>{
              'type': <String>['string', 'integer'],
              'description':
                  'Optional mission time range start. Use current-time tool first for relative dates.',
            },
            'end_time': <String, Object?>{
              'type': <String>['string', 'integer'],
              'description':
                  'Optional mission time range end. For whole-day missions, use local 23:59:59.000 of that day, not 23:59:59.999 or nextDayStartMillis.',
            },
            'completed_start_time': <String, Object?>{
              'type': <String>['string', 'integer'],
              'description':
                  'Filter finished missions by actual completion time, inclusive. Use dayStartMillis for "today completed".',
            },
            'completed_end_time': <String, Object?>{
              'type': <String>['string', 'integer'],
              'description':
                  'Filter finished missions by actual completion time, exclusive. Use nextDayStartMillis for "today completed".',
            },
            'isFinished': <String, Object?>{'type': 'boolean'},
            'limit': <String, Object?>{'type': 'integer'},
          },
        },
      },
    };
  }

  Map<String, Object?> _getCurrentTimeToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '获取当前时间',
      'wouldLikeTo': '获取 TimeHello 当前本地时间',
      'readonly': true,
      'function': <String, Object?>{
        'name': getCurrentTimeToolName,
        'description':
            'Get the host app current local time. Always call this before resolving relative dates such as today, tomorrow, yesterday, this week, or now.',
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{},
        },
      },
    };
  }

  Map<String, Object?> _updateMissionsToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '更新任务',
      'wouldLikeTo': '更新 TimeHello 任务',
      'readonly': false,
      'function': <String, Object?>{
        'name': updateMissionsToolName,
        'description':
            'Update one or more TimeHello missions. Prefer objectId. If only title is provided it must match exactly and ambiguous matches are skipped.',
        'parameters': <String, Object?>{
          'type': 'object',
          'required': <String>['datas'],
          'properties': <String, Object?>{
            'datas': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'objectId': <String, Object?>{'type': 'string'},
                  'id': <String, Object?>{'type': 'string'},
                  'title': <String, Object?>{'type': 'string'},
                  'new_title': <String, Object?>{'type': 'string'},
                  'folder_id': <String, Object?>{'type': 'string'},
                  'folder_title': <String, Object?>{'type': 'string'},
                  'time_mode': <String, Object?>{'type': 'integer'},
                  'dateStatus': <String, Object?>{
                    'type': 'integer',
                    'description':
                        'Relative date bucket. 1=today, 2=tomorrow. Use when updating a task to today/tomorrow.',
                  },
                  'start_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                  },
                  'end_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                  },
                  'isFinished': <String, Object?>{'type': 'boolean'},
                  'finish_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                    'description':
                        'Actual completion time in local milliseconds. Required when marking a task completed today.',
                  },
                  'time_finished': <String, Object?>{'type': 'integer'},
                  'end_time_before_finished': <String, Object?>{
                    'type': 'integer',
                  },
                  'priorityStatus': <String, Object?>{'type': 'integer'},
                  'tagNames': <String, Object?>{
                    'oneOf': <Object?>[
                      <String, Object?>{'type': 'string'},
                      <String, Object?>{
                        'type': 'array',
                        'items': <String, Object?>{'type': 'string'},
                      },
                    ],
                  },
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _listFoldersToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '查询清单',
      'wouldLikeTo': '查询 TimeHello 清单',
      'readonly': true,
      'function': <String, Object?>{
        'name': listFoldersToolName,
        'description':
            'List TimeHello FolderModel records. tag=3 means normal folder/list, tag=2 means tag/filter.',
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'objectIds': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'title': <String, Object?>{'type': 'string'},
            'titles': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'tag': <String, Object?>{'type': 'integer'},
            'folderStatus': <String, Object?>{'type': 'integer'},
            'limit': <String, Object?>{'type': 'integer'},
          },
        },
      },
    };
  }

  Map<String, Object?> _createFoldersToolDefinition({
    required String name,
    required String displayTitle,
    required String description,
  }) {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': displayTitle,
      'wouldLikeTo': displayTitle,
      'readonly': false,
      'function': <String, Object?>{
        'name': name,
        'description': description,
        'parameters': <String, Object?>{
          'type': 'object',
          'required': <String>['datas'],
          'properties': <String, Object?>{
            'datas': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{
                'type': 'object',
                'required': <String>['title'],
                'properties': <String, Object?>{
                  'title': <String, Object?>{'type': 'string'},
                  'description': <String, Object?>{'type': 'string'},
                  'tag': <String, Object?>{
                    'type': 'integer',
                    'description':
                        '1=task list, 2=tag, 3=folder container, 4=filter, 5=objective.',
                  },
                  'parent_folder_id': <String, Object?>{
                    'type': 'string',
                    'description':
                        'Optional tag=3 folder container objectId that should contain this list.',
                  },
                  'parent_folder_title': <String, Object?>{
                    'type': 'string',
                    'description':
                        'Optional tag=3 folder container title. For “create list Y under folder X”, set title=Y, tag=1, parent_folder_title=X.',
                  },
                  'color': <String, Object?>{'type': 'integer'},
                  'icon': <String, Object?>{'type': 'integer'},
                  'iconType': <String, Object?>{'type': 'integer'},
                  'layoutType': <String, Object?>{'type': 'integer'},
                  'folderStatus': <String, Object?>{'type': 'integer'},
                  'filterType': <String, Object?>{'type': 'integer'},
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _updateFoldersToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '更新清单',
      'wouldLikeTo': '更新 TimeHello 清单',
      'readonly': false,
      'function': <String, Object?>{
        'name': updateFoldersToolName,
        'description':
            'Update FolderModel records. Prefer objectId. Exact title matching is supported but ambiguous titles are skipped.',
        'parameters': <String, Object?>{
          'type': 'object',
          'required': <String>['datas'],
          'properties': <String, Object?>{
            'datas': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'objectId': <String, Object?>{'type': 'string'},
                  'id': <String, Object?>{'type': 'string'},
                  'title': <String, Object?>{'type': 'string'},
                  'lookup_tag': <String, Object?>{
                    'type': 'integer',
                    'description':
                        'Optional target lookup tag. Use 1 when moving/updating a task list by title, 2 for tag, 3 for folder container.',
                  },
                  'new_title': <String, Object?>{'type': 'string'},
                  'description': <String, Object?>{'type': 'string'},
                  'tag': <String, Object?>{'type': 'integer'},
                  'parent_folder_id': <String, Object?>{
                    'type': 'string',
                    'description':
                        'Optional tag=3 folder container objectId. Moving a list under this folder updates the parent folder order list.',
                  },
                  'parent_folder_title': <String, Object?>{
                    'type': 'string',
                    'description':
                        'Optional tag=3 folder container title. For “move list A under folder B”, set title=A, lookup_tag=1, parent_folder_title=B.',
                  },
                  'color': <String, Object?>{'type': 'integer'},
                  'icon': <String, Object?>{'type': 'integer'},
                  'iconType': <String, Object?>{'type': 'integer'},
                  'layoutType': <String, Object?>{'type': 'integer'},
                  'folderStatus': <String, Object?>{'type': 'integer'},
                  'filterType': <String, Object?>{'type': 'integer'},
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _deleteFoldersToolDefinition({
    required String name,
    required String displayTitle,
    required String description,
  }) {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': displayTitle,
      'wouldLikeTo': displayTitle,
      'readonly': false,
      'function': <String, Object?>{
        'name': name,
        'description': description,
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'objectId': <String, Object?>{'type': 'string'},
            'id': <String, Object?>{'type': 'string'},
            'folder_id': <String, Object?>{'type': 'string'},
            'objectIds': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'ids': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'folderIds': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'title': <String, Object?>{'type': 'string'},
            'titles': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{'type': 'string'},
            },
            'datas': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'objectId': <String, Object?>{'type': 'string'},
                  'id': <String, Object?>{'type': 'string'},
                  'folder_id': <String, Object?>{'type': 'string'},
                  'title': <String, Object?>{'type': 'string'},
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _listStatsToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '查询统计',
      'wouldLikeTo': '查询 TimeHello 统计',
      'readonly': true,
      'function': <String, Object?>{
        'name': listStatsToolName,
        'description':
            'List StatsModel records from MongoApisManager.listStatsModels. Supports folder_id, mission_id, title, category, type, start_time, end_time, and limit.',
        'parameters': _reportFilterParameters(),
      },
    };
  }

  Map<String, Object?> _createStatsToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '创建统计记录',
      'wouldLikeTo': '创建 TimeHello 统计记录',
      'readonly': false,
      'function': <String, Object?>{
        'name': createStatsToolName,
        'description':
            'Create one or more StatsModel records using MongoApisManager.insertStatsModel.',
        'parameters': <String, Object?>{
          'type': 'object',
          'required': <String>['datas'],
          'properties': <String, Object?>{
            'datas': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'title': <String, Object?>{'type': 'string'},
                  'type': <String, Object?>{'type': 'integer'},
                  'tagNames': <String, Object?>{'type': 'string'},
                  'category': <String, Object?>{'type': 'string'},
                  'color': <String, Object?>{'type': 'integer'},
                  'icon': <String, Object?>{'type': 'integer'},
                  'value': <String, Object?>{'type': 'number'},
                  'begin_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                  },
                  'finish_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                  },
                  'folder_id': <String, Object?>{'type': 'string'},
                  'mission_id': <String, Object?>{'type': 'string'},
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _listTimelineToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '查询时间线',
      'wouldLikeTo': '查询 TimeHello 时间线',
      'readonly': true,
      'function': <String, Object?>{
        'name': listTimelineToolName,
        'description':
            'List TimelineMissionModel records from MongoApisManager.listTimelineMissionModel. Supports folder_id, mission_id, sceneType, eventType, title, start_time, end_time, and limit.',
        'parameters': _reportFilterParameters(),
      },
    };
  }

  Map<String, Object?> _createTimelineToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '创建时间线',
      'wouldLikeTo': '创建 TimeHello 时间线记录',
      'readonly': false,
      'function': <String, Object?>{
        'name': createTimelineToolName,
        'description':
            'Create one or more TimelineMissionModel records using MongoApisManager.insertTimelineMissionModel.',
        'parameters': <String, Object?>{
          'type': 'object',
          'required': <String>['datas'],
          'properties': <String, Object?>{
            'datas': <String, Object?>{
              'type': 'array',
              'items': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'sceneType': <String, Object?>{'type': 'string'},
                  'eventType': <String, Object?>{'type': 'string'},
                  'timelineMessage': <String, Object?>{'type': 'string'},
                  'title': <String, Object?>{'type': 'string'},
                  'message': <String, Object?>{'type': 'string'},
                  'extra': <String, Object?>{'type': 'string'},
                  'url': <String, Object?>{'type': 'string'},
                  'picUrl': <String, Object?>{'type': 'string'},
                  'folder_id': <String, Object?>{'type': 'string'},
                  'mission_id': <String, Object?>{'type': 'string'},
                  'object_id': <String, Object?>{'type': 'string'},
                  'color': <String, Object?>{'type': 'integer'},
                  'icon': <String, Object?>{'type': 'integer'},
                  'end_time': <String, Object?>{
                    'type': <String>['string', 'integer'],
                  },
                  'time_finished': <String, Object?>{'type': 'integer'},
                  'end_time_before_finished': <String, Object?>{
                    'type': 'integer'
                  },
                  'dateStatus': <String, Object?>{'type': 'integer'},
                  'priorityStatus': <String, Object?>{'type': 'integer'},
                  'total_tomotoes': <String, Object?>{'type': 'integer'},
                  'no_tomotoes_finished': <String, Object?>{'type': 'integer'},
                  'tomato_duration': <String, Object?>{'type': 'integer'},
                  'order_index': <String, Object?>{'type': 'integer'},
                  'tagNames': <String, Object?>{'type': 'string'},
                  'tagIds': <String, Object?>{'type': 'string'},
                  'isFinished': <String, Object?>{'type': 'boolean'},
                  'isDelayed': <String, Object?>{'type': 'boolean'},
                  'repetiveType': <String, Object?>{'type': 'integer'},
                  'repetiveValue': <String, Object?>{'type': 'integer'},
                  'repetiveWeekDay': <String, Object?>{
                    'type': 'array',
                    'items': <String, Object?>{'type': 'boolean'},
                  },
                },
              },
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _generateReportToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '生成报表页面',
      'wouldLikeTo': '生成 TimeHello HTML 报表页面',
      'readonly': false,
      'function': <String, Object?>{
        'name': generateReportToolName,
        'description':
            'Generate a local HTML report from MongoApisManager.listStatsModels and listTimelineMissionModel, then save it with Utility file helpers.',
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            ...(_reportFilterParameters()['properties']
                as Map<String, Object?>),
            'title': <String, Object?>{'type': 'string'},
            'includeStats': <String, Object?>{'type': 'boolean'},
            'includeTimeline': <String, Object?>{'type': 'boolean'},
            'fileName': <String, Object?>{'type': 'string'},
          },
        },
      },
    };
  }

  Map<String, Object?> _openHtmlReportToolDefinition() {
    return <String, Object?>{
      'type': 'function',
      'displayTitle': '打开报表页面',
      'wouldLikeTo': '用外部浏览器打开 TimeHello HTML 报表',
      'readonly': false,
      'function': <String, Object?>{
        'name': openHtmlReportToolName,
        'description':
            'Open a generated TimeHello HTML report in the system default external browser. If url/path is omitted, open the latest generated report.',
        'parameters': <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'url': <String, Object?>{
              'type': 'string',
              'description': 'file:// URL or normal http(s) URL to open.',
            },
            'path': <String, Object?>{
              'type': 'string',
              'description': 'Local HTML file path to open.',
            },
          },
        },
      },
    };
  }

  Map<String, Object?> _reportFilterParameters() {
    return <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'folder_id': <String, Object?>{'type': 'string'},
        'mission_id': <String, Object?>{'type': 'string'},
        'title': <String, Object?>{'type': 'string'},
        'category': <String, Object?>{'type': 'string'},
        'sceneType': <String, Object?>{'type': 'string'},
        'eventType': <String, Object?>{'type': 'string'},
        'type': <String, Object?>{'type': 'integer'},
        'start_time': <String, Object?>{
          'type': <String>['string', 'integer'],
        },
        'end_time': <String, Object?>{
          'type': <String>['string', 'integer'],
        },
        'limit': <String, Object?>{'type': 'integer'},
        'refresh': <String, Object?>{'type': 'boolean'},
      },
    };
  }

  Future<Map<String, Object?>> callTool(
    String name,
    Map<String, Object?> args,
  ) async {
    _log('callTool name=$name args=${_safeJsonEncode(args)}');
    if (!_supportedToolNames.contains(name)) {
      _log('callTool unsupported name=$name');
      return <String, Object?>{
        'ok': false,
        'errorCode': 'unsupported_tool',
        'message': 'Unsupported tool: $name',
      };
    }

    final toolArgs = _unwrapArguments(args);
    if (!identical(toolArgs, args)) {
      _log('callTool unwrappedArgs=${_safeJsonEncode(toolArgs)}');
    }

    if (name == getCurrentTimeToolName) {
      return getCurrentTime(toolArgs);
    }

    if (name == deleteMissionToolName || name == batchDeleteMissionsToolName) {
      return deleteMissionRecords(toolArgs);
    }

    if (name == listMissionsToolName) {
      return listMissionRecords(toolArgs);
    }

    if (name == updateMissionsToolName) {
      return updateMissionRecords(toolArgs);
    }

    if (name == listFoldersToolName) {
      return listFolderRecords(toolArgs);
    }

    if (name == createFoldersToolName || name == batchCreateFoldersToolName) {
      return createFolderRecordsForTool(toolArgs);
    }

    if (name == updateFoldersToolName) {
      return updateFolderRecords(toolArgs);
    }

    if (name == deleteFolderToolName || name == batchDeleteFoldersToolName) {
      return deleteFolderRecords(toolArgs);
    }

    if (name == listStatsToolName) {
      return listStatsRecords(toolArgs);
    }

    if (name == createStatsToolName) {
      return createStatsRecords(toolArgs);
    }

    if (name == listTimelineToolName) {
      return listTimelineRecords(toolArgs);
    }

    if (name == createTimelineToolName) {
      return createTimelineRecords(toolArgs);
    }

    if (name == generateReportToolName) {
      return generateHtmlReport(toolArgs);
    }

    if (name == openHtmlReportToolName) {
      return openHtmlReport(toolArgs);
    }

    return createMissionRecordsForTool(
      toolArgs,
      preferBatchInsert: name == batchCreateMissionsToolName,
    );
  }

  Map<String, Object?> getCurrentTime(Map<String, Object?> args) {
    // 使用项目统一的时间来源，避免 AI 或插件侧用到模型内置日期。
    final now = DateTime.fromMillisecondsSinceEpoch(
      Utility.getTimeStampToday(),
    );
    final dayStart = DateTime(now.year, now.month, now.day);
    final nextDayStart = dayStart.add(const Duration(days: 1));
    final yesterdayStart = dayStart.subtract(const Duration(days: 1));
    final tomorrowStart = nextDayStart;
    final weekStart = dayStart.subtract(Duration(days: dayStart.weekday - 1));
    final nextWeekStart = weekStart.add(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month);
    final nextMonthStart = DateTime(now.year, now.month + 1);
    final result = <String, Object?>{
      'ok': true,
      'timezoneName': now.timeZoneName,
      'timezoneOffsetMinutes': now.timeZoneOffset.inMinutes,
      'timezoneOffset': _formatTimezoneOffset(now.timeZoneOffset),
      'iso8601': now.toIso8601String(),
      'millisecondsSinceEpoch': now.millisecondsSinceEpoch,
      'secondsSinceEpoch': now.millisecondsSinceEpoch ~/ 1000,
      'date': _formatDate(now),
      'time': _formatClock(now),
      'today': <String, Object?>{
        'date': _formatDate(dayStart),
        'dayStartMillis': dayStart.millisecondsSinceEpoch,
        'nextDayStartMillis': nextDayStart.millisecondsSinceEpoch,
        'dayStartIso8601': dayStart.toIso8601String(),
        'nextDayStartIso8601': nextDayStart.toIso8601String(),
      },
      'yesterday': <String, Object?>{
        'date': _formatDate(yesterdayStart),
        'dayStartMillis': yesterdayStart.millisecondsSinceEpoch,
        'nextDayStartMillis': dayStart.millisecondsSinceEpoch,
      },
      'tomorrow': <String, Object?>{
        'date': _formatDate(tomorrowStart),
        'dayStartMillis': tomorrowStart.millisecondsSinceEpoch,
        'nextDayStartMillis':
            tomorrowStart.add(const Duration(days: 1)).millisecondsSinceEpoch,
      },
      'thisWeek': <String, Object?>{
        'weekStartMillis': weekStart.millisecondsSinceEpoch,
        'nextWeekStartMillis': nextWeekStart.millisecondsSinceEpoch,
      },
      'thisMonth': <String, Object?>{
        'monthStartMillis': monthStart.millisecondsSinceEpoch,
        'nextMonthStartMillis': nextMonthStart.millisecondsSinceEpoch,
      },
    };
    return <String, Object?>{
      ...result,
      'contextItems': <Object?>[
        <String, Object?>{
          'content':
              '当前宿主本地时间：${result['iso8601']}，今天日期：${_formatDate(dayStart)}，今天范围：${dayStart.millisecondsSinceEpoch} <= t < ${nextDayStart.millisecondsSinceEpoch}。',
          'name': 'TimeHello 当前时间',
          'description': 'Host current local time',
        },
      ],
    };
  }

  Future<Map<String, Object?>> createMissionRecordsForTool(
    Map<String, Object?> args, {
    bool preferBatchInsert = false,
  }) async {
    final missions = createMissions(args);
    _log('callTool createdDraftCount=${missions.length}');
    if (missions.isEmpty) {
      _log('callTool failed empty_missions');
      return <String, Object?>{
        'ok': false,
        'errorCode': 'empty_missions',
        'message': '没有可创建的任务，请至少提供一个非空标题。',
      };
    }

    final folderResolution = await _ensureMissionFolders(missions);
    if (folderResolution.ambiguous.isNotEmpty ||
        folderResolution.failed.isNotEmpty) {
      final message = _missionFolderResolutionError(folderResolution);
      return <String, Object?>{
        'ok': false,
        'errorCode': 'folder_resolution_failed',
        'message': message,
        'ambiguous': folderResolution.ambiguous,
        'failed': folderResolution.failed,
        'contextItems': <Object?>[
          <String, Object?>{
            'content': message,
            'name': 'TimeHello 创建任务未执行',
            'description': 'Mission folder resolution failed',
          },
        ],
      };
    }

    final createdMissions = await createMissionRecords(
      missions,
      preferBatchInsert: preferBatchInsert,
    );
    if (createdMissions.isEmpty) {
      _log('callTool failed insert_failed');
      return <String, Object?>{
        'ok': false,
        'errorCode': 'insert_failed',
        'message': '任务创建失败，请检查登录状态或任务参数。',
      };
    }
    _log('callTool directCreated count=${createdMissions.length}');
    return <String, Object?>{
      'ok': true,
      'created': true,
      'previewOpened': false,
      'count': createdMissions.length,
      'createdFolders': folderResolution.created
          .map(_folderDetailMap)
          .toList(growable: false),
      'missions':
          createdMissions.map(_missionDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': _missionCreateSummaryWithFolders(
            createdMissions,
            folderResolution.created,
          ),
          'name': 'TimeHello 创建任务完成',
          'description': 'Missions created successfully',
        },
      ],
    };
  }

  List<MissionModel> createMissions(Map<String, Object?> args) {
    _log('createMissions rawArgs=${_safeJsonEncode(args)}');
    final rawDatas = _extractMissionDatas(args);
    _log('createMissions extractedDatas=${_safeJsonEncode(rawDatas)}');
    final missions = <MissionModel>[];
    final now = DateTime.fromMillisecondsSinceEpoch(
      Utility.getTimeStampToday(),
    );

    for (final rawMission in rawDatas) {
      final normalizedMission = _normalizeMissionInput(rawMission);
      final title = _missionTitle(normalizedMission);
      if (TextUtil.isEmpty(title)) {
        _log('skip mission without title: ${_safeJsonEncode(rawMission)}');
        continue;
      }

      final mission = MissionModel()
        ..title = title
        ..isFinished = false
        ..isDelayed = false
        ..folder_id = _stringOrNull(normalizedMission['folder_id'])
        ..folder_title = _stringOrNull(normalizedMission['folder_title'])
        ..group_id = _stringOrNull(normalizedMission['group_id'])
        ..priorityStatus = _intOrNull(normalizedMission['priorityStatus'])
        ..total_tomotoes = _intOrNull(normalizedMission['total_tomotoes']) ?? 1
        ..tomato_duration =
            _intOrNull(normalizedMission['tomato_duration']) ?? 25 * 60 * 1000
        ..tagNames = _stringListOrString(normalizedMission['tagNames'])
        ..tagIds = _stringListOrString(normalizedMission['tagIds'])
        ..time_mode = _intOrNull(normalizedMission['time_mode']);

      mission.start_time = _timeMillisOrNull(
        normalizedMission['start_time'] ?? normalizedMission['startTime'],
      );
      mission.end_time = _timeMillisOrNull(
        normalizedMission['end_time'] ?? normalizedMission['endTime'],
      );
      mission.alert_time = _timeMillisOrNull(normalizedMission['alert_time']);
      mission.dateStatus = _intOrNull(normalizedMission['dateStatus']);

      final subMissions = normalizedMission['subMissions'];
      if (subMissions is List) {
        mission.subMissions = _normalizeSubMissions(subMissions);
      }

      mission.objectiveUnit = _stringOrNull(normalizedMission['objectiveUnit']);
      mission.objectiveValue =
          _doubleOrNull(normalizedMission['objectiveValue']);
      mission.objectiveTotalValue =
          _doubleOrNull(normalizedMission['objectiveTotalValue']);
      mission.objectiveStartValue =
          _doubleOrNull(normalizedMission['objectiveStartValue']);

      _applyMissionDefaults(mission, now);
      mission.end_time = _normalizeEndOfDayMillis(mission.end_time);
      missions.add(mission);
      _log(
        'missionDraft title=${mission.title} timeMode=${mission.time_mode} '
        'start=${mission.start_time} end=${mission.end_time}',
      );
    }

    return missions;
  }

  List<Map<String, dynamic>> _normalizeSubMissions(List subMissions) {
    final now = Utility.getTimeStampToday();
    return subMissions
        .whereType<Map>()
        .map((item) {
          final raw = item.cast<String, dynamic>();
          final title = _stringOrNull(
              raw['title'] ?? raw['name'] ?? raw['taskName'] ?? raw['任务名称']);
          if (TextUtil.isEmpty(title)) {
            return null;
          }
          return <String, dynamic>{
            'isFinished': _boolOrNull(raw['isFinished']) ?? false,
            'id': _intOrNull(raw['id']) ?? now,
            'shouldFocus': _boolOrNull(raw['shouldFocus']) ?? false,
            'title': title,
            'notificationTime': _timeMillisOrNull(raw['notificationTime']) ?? 0,
            'numToamatoesFocused': _intOrNull(raw['numToamatoesFocused']) ?? 0,
            'numToamatoTotal': _intOrNull(raw['numToamatoTotal']) ?? 1,
            'create_time': _timeMillisOrNull(raw['create_time']) ?? now,
            'update_time': _timeMillisOrNull(raw['update_time']) ?? now,
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  Future<List<MissionModel>> createMissionRecords(
    List<MissionModel> missions, {
    bool preferBatchInsert = false,
  }) async {
    if (missions.length > 1 || preferBatchInsert) {
      final createdByBatch = await _batchCreateMissionRecords(missions);
      if (createdByBatch.isNotEmpty) {
        return createdByBatch;
      }
      _log('batchInsertMission empty result, fallback to single inserts');
    }

    final created = <MissionModel>[];
    for (final mission in missions) {
      _log(
        'insertMission start title=${mission.title} '
        'timeMode=${mission.time_mode} start=${mission.start_time} end=${mission.end_time}',
      );
      final saved = await MongoApisManager.getInstance()
          .insertMissiontData(missionModel: mission);
      if (saved == null) {
        _log('insertMission failed title=${mission.title}');
        continue;
      }
      mission.objectId = saved.objectId;
      created.add(mission);
      _log(
          'insertMission success title=${mission.title} objectId=${saved.objectId}');
    }

    if (created.isNotEmpty) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
      _log('fired update events count=${created.length}');
    }
    return created;
  }

  Future<List<MissionModel>> _batchCreateMissionRecords(
    List<MissionModel> missions,
  ) async {
    if (missions.isEmpty) {
      return const <MissionModel>[];
    }
    _log('batchInsertMission start count=${missions.length}');
    final manager = MongoApisManager.getInstance();
    final result = await manager.batchInsert_MissionModels(
      listParam: missions,
      shouldQuery: true,
    );
    if (result is! List || result.isEmpty) {
      _log('batchInsertMission failed result=${_safeJsonEncode(result)}');
      return const <MissionModel>[];
    }

    final created = <MissionModel>[];
    for (var index = 0; index < missions.length; index += 1) {
      final mission = missions[index];
      final rawResult = index < result.length ? result[index] : null;
      final objectId = _objectIdFromBatchResult(rawResult);
      if (!TextUtil.isEmpty(objectId)) {
        mission.objectId = objectId;
      }
      created.add(mission);
      _log(
        'batchInsertMission success title=${mission.title} '
        'objectId=${mission.objectId ?? ''}',
      );
    }

    if (created.isNotEmpty) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
      _log('fired update events count=${created.length}');
    }
    return created;
  }

  String? _objectIdFromBatchResult(Object? rawResult) {
    if (rawResult is! Map) {
      return null;
    }
    final success = rawResult['success'];
    if (success is Map) {
      return _stringOrNull(success['objectId'] ?? success['object_id']);
    }
    final result = rawResult['result'];
    if (result is Map) {
      return _stringOrNull(result['objectId'] ?? result['object_id']);
    }
    return _stringOrNull(
      rawResult['objectId'] ?? rawResult['object_id'] ?? rawResult['_id'],
    );
  }

  Future<_MissionFolderEnsureResult> _ensureMissionFolders(
    List<MissionModel> missions,
  ) async {
    final folderTitles = <String>{};
    for (final mission in missions) {
      if (!TextUtil.isEmpty(mission.folder_id)) {
        continue;
      }
      final folderTitle = _stringOrNull(mission.folder_title);
      if (folderTitle != null) {
        folderTitles.add(folderTitle);
      }
    }
    if (folderTitles.isEmpty) {
      return const _MissionFolderEnsureResult();
    }

    final manager = MongoApisManager.getInstance();
    if (manager.listFolderModels.isEmpty) {
      await manager.queryWhereEqual_folderModel(shouldRefresh: true);
    }

    final resolvedByTitle = <String, FolderModel>{};
    final created = <FolderModel>[];
    final failed = <Map<String, Object?>>[];
    final ambiguous = <Map<String, Object?>>[];

    for (final title in folderTitles) {
      final matches = _findFolderModelsByExactTitle(title, tag: 1);
      if (matches.length > 1) {
        ambiguous.add(<String, Object?>{
          'folder_title': title,
          'expected_tag': 1,
          'count': matches.length,
          'candidates': matches.map(_folderDetailMap).toList(growable: false),
        });
        continue;
      }
      if (matches.length == 1) {
        final folder = matches.first;
        if (TextUtil.isEmpty(folder.objectId)) {
          failed.add(<String, Object?>{
            'folder_title': title,
            'message': 'matched folder has empty objectId',
          });
          continue;
        }
        await _ensureTeamWorkIdForListing(folder);
        resolvedByTitle[title] = folder;
        continue;
      }

      final folder = FolderModel()
        ..title = title
        // FolderPage 中 tag=1 才是可承载任务的清单；tag=3 只是文件夹容器。
        ..tag = 1
        ..color = 0xFFFFF1A6
        ..icon = Icons.circle.codePoint
        ..iconType = 0
        ..layoutType = 0
        ..folderStatus = 0
        ..filterType = 0
        ..folderTeamWorkId = Utility.getGroupId()
        ..create_time = DateTime.now().millisecondsSinceEpoch
        ..update_time = DateTime.now().millisecondsSinceEpoch;
      _log('ensureMissionFolder create title=$title');
      final saved = await manager.insertFolderModel(folderModel: folder);
      if (saved == null || TextUtil.isEmpty(saved.objectId)) {
        failed.add(<String, Object?>{
          'folder_title': title,
          'message': 'create folder returned null',
        });
        _log('ensureMissionFolder failed title=$title');
        continue;
      }
      folder.objectId = saved.objectId;
      folder.createdAt = saved.createdAt;
      created.add(folder);
      resolvedByTitle[title] = folder;
      _log(
          'ensureMissionFolder created title=$title objectId=${folder.objectId}');
    }

    if (ambiguous.isEmpty && failed.isEmpty) {
      for (final mission in missions) {
        if (!TextUtil.isEmpty(mission.folder_id)) {
          continue;
        }
        final folderTitle = _stringOrNull(mission.folder_title);
        if (folderTitle == null) {
          continue;
        }
        final folder = resolvedByTitle[folderTitle];
        if (folder == null) {
          continue;
        }
        mission.folder_id = folder.objectId;
        mission.folder_title = folder.title ?? folderTitle;
        _log(
          'ensureMissionFolder linked mission=${mission.title} '
          'folderTitle=${mission.folder_title} folderId=${mission.folder_id}',
        );
      }
    }

    if (created.isNotEmpty) {
      _fireFolderChanged(folder: created.first);
    }

    return _MissionFolderEnsureResult(
      created: created,
      failed: failed,
      ambiguous: ambiguous,
    );
  }

  Future<Map<String, Object?>> deleteMissionRecords(
    Map<String, Object?> args,
  ) async {
    _log('deleteMissionRecords rawArgs=${_safeJsonEncode(args)}');
    final targets = await _resolveDeleteTargets(args);
    _log('deleteMissionRecords targets=${_safeJsonEncode(targets)}');

    final resolved = targets['resolved'];
    final notFound = targets['notFound'];
    final ambiguous = targets['ambiguous'];
    final missions =
        resolved is List ? resolved.whereType<MissionModel>().toList() : [];
    final notFoundList = notFound is List ? notFound : const <Object?>[];
    final ambiguousList = ambiguous is List ? ambiguous : const <Object?>[];

    if (missions.isEmpty) {
      final message = ambiguousList.isNotEmpty
          ? '找到多条同名任务，未删除。请提供任务 ID 或更精确的标题。'
          : '没有找到可删除的任务，请提供任务 ID 或精确标题。';
      return <String, Object?>{
        'ok': false,
        'errorCode': 'empty_delete_targets',
        'message': message,
        'notFound': notFoundList,
        'ambiguous': ambiguousList,
        'contextItems': <Object?>[
          <String, Object?>{
            'content': message,
            'name': 'TimeHello 删除任务未执行',
            'description': 'No mission deleted',
          },
        ],
      };
    }

    final deleted = <MissionModel>[];
    final failed = <Map<String, Object?>>[];
    final seenObjectIds = <String>{};

    for (final mission in missions) {
      final objectId = _stringOrNull(mission.objectId);
      if (objectId == null || seenObjectIds.contains(objectId)) {
        continue;
      }
      seenObjectIds.add(objectId);
      try {
        _log('deleteMission start objectId=$objectId title=${mission.title}');
        final result = await MongoApisManager.getInstance()
            .delete_MissionModel(currentObjectId: objectId);
        if (result == null && mission.objectId == null) {
          failed.add(<String, Object?>{
            'objectId': objectId,
            'title': mission.title,
            'message': 'delete returned null',
          });
          _log('deleteMission failed objectId=$objectId result=null');
          continue;
        }
        deleted.add(mission);
        _log('deleteMission success objectId=$objectId title=${mission.title}');
      } catch (error, stackTrace) {
        failed.add(<String, Object?>{
          'objectId': objectId,
          'title': mission.title,
          'message': error.toString(),
        });
        _log('deleteMission failed objectId=$objectId: $error',
            error: error, stackTrace: stackTrace);
      }
    }

    if (deleted.isNotEmpty) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
      _log('fired delete update events count=${deleted.length}');
    }

    final summary = _deletedMissionSummary(
      deleted: deleted,
      failed: failed,
      notFound: notFoundList,
      ambiguous: ambiguousList,
    );
    return <String, Object?>{
      'ok': deleted.isNotEmpty,
      'deleted': deleted.isNotEmpty,
      'count': deleted.length,
      'missions': deleted.map(_missionDetailMap).toList(growable: false),
      'failed': failed,
      'notFound': notFoundList,
      'ambiguous': ambiguousList,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': deleted.isNotEmpty ? 'TimeHello 删除任务完成' : 'TimeHello 删除任务失败',
          'description': 'Missions delete result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> listMissionRecords(
    Map<String, Object?> args,
  ) async {
    _log('listMissionRecords rawArgs=${_safeJsonEncode(args)}');
    final manager = MongoApisManager.getInstance();
    if (manager.listMissionModels.isEmpty ||
        _boolOrNull(args['refresh']) == true) {
      await manager.queryWhereEqual_missionData(shouldRefresh: true);
    }
    final folderTitleFilter = _missionListFolderTitle(args);
    if (folderTitleFilter != null &&
        (manager.listFolderModels.isEmpty ||
            _boolOrNull(args['refresh']) == true)) {
      await manager.queryWhereEqual_folderModel(shouldRefresh: true);
    }

    var missions = List<MissionModel>.from(manager.listMissionModels);
    final objectIds = _extractObjectIds(args, idAliases: const <String>[
      'objectIds',
      'ids',
      'missionIds',
      'mission_ids',
    ]);
    final missionTitles = _extractMissionTitles(args);
    final tagNames = _extractMissionTagNames(args);
    final tagIds = _extractMissionTagIds(args);

    final folderResolution = _resolveMissionListFolderFilter(args);
    if (folderResolution.notFound.isNotEmpty ||
        folderResolution.ambiguous.isNotEmpty) {
      final summary = _missionListFolderFilterError(folderResolution);
      return <String, Object?>{
        'ok': false,
        'count': 0,
        'missions': <Object?>[],
        'folderNotFound': folderResolution.notFound,
        'folderAmbiguous': folderResolution.ambiguous,
        'contextItems': <Object?>[
          <String, Object?>{
            'content': summary,
            'name': 'TimeHello 查询任务失败',
            'description': 'Mission list folder resolution failed',
          },
        ],
      };
    }

    final folderId = folderResolution.folderId;
    if (folderId != null) {
      // 复用 MongoApisManager 里已有的 folder_id 查询封装，避免 AI 查询链路
      // 和页面/数据库管理层各自维护一套过滤逻辑。
      missions = manager.queryWhereEqual_missionDataByFolderId(
        folder_id: folderId,
      );
    }

    if (tagNames.isNotEmpty) {
      final taggedMissions = <MissionModel>[];
      final taggedMissionIds = <String>{};
      for (final tagName in tagNames) {
        for (final mission
            in manager.queryWhereEqual_missionDataByTagName(tagName: tagName)) {
          final id = mission.objectId;
          if (id == null || taggedMissionIds.add(id)) {
            taggedMissions.add(mission);
          }
        }
      }
      final taggedIds = taggedMissions
          .map((mission) => mission.objectId)
          .whereType<String>()
          .toSet();
      missions = missions
          .where((mission) => taggedIds.contains(mission.objectId))
          .toList(growable: false);
    }

    if (tagIds.isNotEmpty) {
      missions = missions.where((mission) {
        final missionTagIds = _stringListFromAny(mission.tagIds);
        return missionTagIds.any(tagIds.contains);
      }).toList(growable: false);
    }

    if (objectIds.isNotEmpty) {
      missions = missions
          .where((mission) => objectIds.contains(mission.objectId))
          .toList(growable: false);
    }

    if (missionTitles.isNotEmpty) {
      missions = missions
          .where(
              (mission) => missionTitles.contains((mission.title ?? '').trim()))
          .toList(growable: false);
    }

    final timeMode = _intOrNull(args['time_mode']);
    if (timeMode != null) {
      missions = missions
          .where((mission) => mission.time_mode == timeMode)
          .toList(growable: false);
    }

    final isFinished = _boolOrNull(args['isFinished'] ?? args['is_finished']);
    if (isFinished != null) {
      missions = missions
          .where((mission) => mission.isFinished == isFinished)
          .toList(growable: false);
    }

    final dateStatus = _intOrNull(args['dateStatus'] ?? args['date_status']);
    final dateStatusRange =
        dateStatus == null ? null : _dateStatusRange(dateStatus);
    var completedStart = _timeMillisOrNull(args['completed_start_time'] ??
            args['completedStartTime'] ??
            args['finish_start_time'] ??
            args['finishStartTime']) ??
        (isFinished == true ? dateStatusRange?.start : null);
    var completedEnd = _timeMillisOrNull(args['completed_end_time'] ??
            args['completedEndTime'] ??
            args['finish_end_time'] ??
            args['finishEndTime']) ??
        (isFinished == true ? dateStatusRange?.endExclusive : null);
    if (isFinished == true &&
        completedStart != null &&
        _boolOrNull(args['allow_historical_date']) != true) {
      final now = DateTime.fromMillisecondsSinceEpoch(
        Utility.getTimeStampToday(),
      );
      final completedDate = DateTime.fromMillisecondsSinceEpoch(completedStart);
      if (completedDate.year != now.year) {
        final todayRange = _dateStatusRange(1);
        completedStart = todayRange?.start;
        completedEnd = todayRange?.endExclusive;
        _log(
          'listMissionRecords override stale completed range '
          'from=${completedDate.toIso8601String()} currentYear=${now.year} '
          'to=$completedStart-$completedEnd',
        );
      }
    }
    if (completedStart != null || completedEnd != null) {
      missions = missions.where((mission) {
        final completedAt = mission.finish_time ??
            (mission.isFinished == true ? mission.end_time : null);
        return _millisInRange(
          completedAt,
          startInclusive: completedStart,
          endExclusive: completedEnd,
        );
      }).toList(growable: false);
    }

    final rangeStart = _timeMillisOrNull(args['start_time'] ??
            args['startTime'] ??
            args['from'] ??
            args['from_time']) ??
        (isFinished == true ? null : dateStatusRange?.start);
    final rangeEnd = _timeMillisOrNull(args['end_time'] ??
            args['endTime'] ??
            args['to'] ??
            args['to_time']) ??
        (isFinished == true ? null : dateStatusRange?.endExclusive);
    if (rangeStart != null || rangeEnd != null) {
      missions = missions.where((mission) {
        if (dateStatus != null &&
            isFinished != true &&
            mission.dateStatus == dateStatus) {
          return true;
        }
        if (_missionIntersectsRange(
          mission,
          startInclusive: rangeStart,
          endExclusive: rangeEnd,
        )) {
          return true;
        }
        final candidateTime = mission.end_time ?? mission.start_time;
        return _millisInRange(
          candidateTime,
          startInclusive: rangeStart,
          endExclusive: rangeEnd,
        );
      }).toList(growable: false);
    }

    final limit = _intOrNull(args['limit']) ?? 20;
    if (limit > 0 && missions.length > limit) {
      missions = missions.take(limit).toList(growable: false);
    }

    final summary = _missionListSummary(
      missions,
      folder: folderResolution.folder,
    );
    return <String, Object?>{
      'ok': true,
      'count': missions.length,
      'folder': folderResolution.folder == null
          ? null
          : _folderDetailMap(folderResolution.folder!),
      'missions': missions.map(_missionDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 查询任务结果',
          'description': 'Mission list result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> updateMissionRecords(
    Map<String, Object?> args,
  ) async {
    _log('updateMissionRecords rawArgs=${_safeJsonEncode(args)}');
    final datas = _extractMissionUpdateDatas(args);
    if (MongoApisManager.getInstance().listMissionModels.isEmpty) {
      await MongoApisManager.getInstance().queryWhereEqual_missionData(
        shouldRefresh: true,
      );
    }
    final updated = <MissionModel>[];
    final failed = <Map<String, Object?>>[];
    final ambiguous = <Map<String, Object?>>[];
    final notFound = <Map<String, Object?>>[];

    for (final item in datas) {
      final target = _resolveSingleMissionTarget(item);
      final missions = target.resolved;
      if (missions.isEmpty) {
        notFound.add(<String, Object?>{'input': item});
        continue;
      }
      if (missions.length > 1) {
        final fallbackMission = _singleRecentDuplicateMission(missions);
        if (fallbackMission == null) {
          ambiguous.add(<String, Object?>{
            'input': item,
            'count': missions.length,
            'candidates':
                missions.map(_missionDetailMap).toList(growable: false),
          });
          continue;
        }
        _log(
          'updateMissionRecords duplicate exact title, choose latest '
          'title=${fallbackMission.title} objectId=${fallbackMission.objectId} '
          'count=${missions.length}',
        );
        missions
          ..clear()
          ..add(fallbackMission);
      }

      final mission = missions.first;
      _applyMissionPatch(mission, item);
      try {
        final result = await MongoApisManager.getInstance().update_MissionModel(
          missionModel: mission,
        );
        if (result == null) {
          failed.add(<String, Object?>{
            'objectId': mission.objectId,
            'title': mission.title,
            'message': 'update returned null',
          });
          continue;
        }
        updated.add(mission);
      } catch (error, stackTrace) {
        failed.add(<String, Object?>{
          'objectId': mission.objectId,
          'title': mission.title,
          'message': error.toString(),
        });
        _log('updateMission failed: $error',
            error: error, stackTrace: stackTrace);
      }
    }

    if (updated.isNotEmpty) {
      eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
      eventBus.fire(EventFn(Params.ACTION_UPDATE_CALENDARPAGE, {}));
    }

    final summary = _updatedMissionSummary(
      updated: updated,
      failed: failed,
      notFound: notFound,
      ambiguous: ambiguous,
    );
    return <String, Object?>{
      'ok': updated.isNotEmpty,
      'updated': updated.isNotEmpty,
      'count': updated.length,
      'missions': updated.map(_missionDetailMap).toList(growable: false),
      'failed': failed,
      'notFound': notFound,
      'ambiguous': ambiguous,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': updated.isNotEmpty ? 'TimeHello 更新任务完成' : 'TimeHello 更新任务未执行',
          'description': 'Mission update result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> createFolderRecordsForTool(
    Map<String, Object?> args,
  ) async {
    final rawDatas = _extractFolderDatas(args);
    final folders = createFolders(args);
    if (folders.isEmpty) {
      return <String, Object?>{
        'ok': false,
        'errorCode': 'empty_folders',
        'message': '没有可创建的清单，请至少提供一个非空标题。',
      };
    }
    final created = <FolderModel>[];
    for (var index = 0; index < folders.length; index += 1) {
      final folder = folders[index];
      _log('insertFolder start title=${folder.title} tag=${folder.tag}');
      final saved = await MongoApisManager.getInstance()
          .insertFolderModel(folderModel: folder);
      if (saved == null) {
        _log('insertFolder failed title=${folder.title}');
        continue;
      }
      folder.objectId = saved.objectId;
      folder.createdAt = saved.createdAt;
      created.add(folder);
      final rawFolder = index < rawDatas.length ? rawDatas[index] : null;
      if (rawFolder != null && folder.tag != 3) {
        await _linkCreatedFolderToParent(folder, rawFolder);
      }
      _log(
          'insertFolder success title=${folder.title} objectId=${folder.objectId}');
    }

    if (created.isNotEmpty) {
      _fireFolderChanged(folder: created.first);
    }

    final summary = _createdFolderSummary(created);
    return <String, Object?>{
      'ok': created.isNotEmpty,
      'created': created.isNotEmpty,
      'count': created.length,
      'folders': created.map(_folderDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 创建清单完成',
          'description': 'FolderModel create result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> listFolderRecords(
    Map<String, Object?> args,
  ) async {
    _log('listFolderRecords rawArgs=${_safeJsonEncode(args)}');
    final manager = MongoApisManager.getInstance();
    if (manager.listFolderModels.isEmpty ||
        _boolOrNull(args['refresh']) == true) {
      await manager.queryWhereEqual_folderModel(shouldRefresh: true);
    }

    var folders = List<FolderModel>.from(manager.listFolderModels);
    final objectIds = _extractObjectIds(args, idAliases: const <String>[
      'objectIds',
      'ids',
      'folderIds',
      'folder_ids',
    ]);
    if (objectIds.isNotEmpty) {
      folders = folders
          .where((folder) => objectIds.contains(folder.objectId))
          .toList(growable: false);
    }

    final titles = _extractTitles(args);
    if (titles.isNotEmpty) {
      folders = folders
          .where((folder) => titles.contains((folder.title ?? '').trim()))
          .toList(growable: false);
    }

    final tag = _intOrNull(args['tag']);
    if (tag != null) {
      folders =
          folders.where((folder) => folder.tag == tag).toList(growable: false);
    }

    final folderStatus = _intOrNull(args['folderStatus']);
    if (folderStatus != null) {
      folders = folders
          .where((folder) => folder.folderStatus == folderStatus)
          .toList(growable: false);
    }

    final limit = _intOrNull(args['limit']) ?? 30;
    if (limit > 0 && folders.length > limit) {
      folders = folders.take(limit).toList(growable: false);
    }

    final summary = _folderListSummary(folders);
    return <String, Object?>{
      'ok': true,
      'count': folders.length,
      'folders': folders.map(_folderDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 查询清单结果',
          'description': 'FolderModel list result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> updateFolderRecords(
    Map<String, Object?> args,
  ) async {
    _log('updateFolderRecords rawArgs=${_safeJsonEncode(args)}');
    final datas = _extractFolderDatas(args);
    final updated = <FolderModel>[];
    final failed = <Map<String, Object?>>[];
    final notFound = <Map<String, Object?>>[];
    final ambiguous = <Map<String, Object?>>[];

    for (final item in datas) {
      final target = await _resolveSingleFolderTarget(item);
      if (target.resolved.isEmpty) {
        notFound.add(<String, Object?>{'input': item});
        continue;
      }
      if (target.resolved.length > 1) {
        ambiguous.add(<String, Object?>{
          'input': item,
          'count': target.resolved.length,
          'candidates':
              target.resolved.map(_folderDetailMap).toList(growable: false),
        });
        continue;
      }

      final folder = target.resolved.first;
      _applyFolderPatch(folder, item);
      try {
        final shouldMoveFolder = _hasParentFolderInput(item);
        final result = shouldMoveFolder
            ? await _moveFolderToParent(folder, item)
            : await MongoApisManager.getInstance()
                .update_FolderModelWithFM(folderModel: folder);
        if (result == null) {
          failed.add(<String, Object?>{
            'objectId': folder.objectId,
            'title': folder.title,
            'message': 'update returned null',
          });
          continue;
        }
        updated.add(folder);
      } catch (error, stackTrace) {
        failed.add(<String, Object?>{
          'objectId': folder.objectId,
          'title': folder.title,
          'message': error.toString(),
        });
        _log('updateFolder failed: $error',
            error: error, stackTrace: stackTrace);
      }
    }

    if (updated.isNotEmpty) {
      _fireFolderChanged(folder: updated.first);
    }

    final summary = _updatedFolderSummary(
      updated: updated,
      failed: failed,
      notFound: notFound,
      ambiguous: ambiguous,
    );
    return <String, Object?>{
      'ok': updated.isNotEmpty,
      'updated': updated.isNotEmpty,
      'count': updated.length,
      'folders': updated.map(_folderDetailMap).toList(growable: false),
      'failed': failed,
      'notFound': notFound,
      'ambiguous': ambiguous,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': updated.isNotEmpty ? 'TimeHello 更新清单完成' : 'TimeHello 更新清单未执行',
          'description': 'FolderModel update result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> deleteFolderRecords(
    Map<String, Object?> args,
  ) async {
    _log('deleteFolderRecords rawArgs=${_safeJsonEncode(args)}');
    final targets = await _resolveFolderDeleteTargets(args);
    final folders = targets.resolved;
    final notFound = targets.notFound;
    final ambiguous = targets.ambiguous;
    if (folders.isEmpty) {
      final message = ambiguous.isNotEmpty
          ? '找到多条同名清单，未删除。请提供清单 ID 或更精确的标题。'
          : '没有找到可删除的清单，请提供清单 ID 或精确标题。';
      return <String, Object?>{
        'ok': false,
        'errorCode': 'empty_folder_delete_targets',
        'message': message,
        'notFound': notFound,
        'ambiguous': ambiguous,
        'contextItems': <Object?>[
          <String, Object?>{
            'content': message,
            'name': 'TimeHello 删除清单未执行',
            'description': 'No folder deleted',
          },
        ],
      };
    }

    final deleted = <FolderModel>[];
    final failed = <Map<String, Object?>>[];
    final seenObjectIds = <String>{};
    for (final folder in folders) {
      final objectId = _stringOrNull(folder.objectId);
      if (objectId == null || seenObjectIds.contains(objectId)) {
        continue;
      }
      seenObjectIds.add(objectId);
      try {
        final result = await MongoApisManager.getInstance()
            .delete_FolderModel(currentObjectId: objectId);
        if (result == null) {
          failed.add(<String, Object?>{
            'objectId': objectId,
            'title': folder.title,
            'message': 'delete returned null',
          });
          continue;
        }
        deleted.add(folder);
      } catch (error, stackTrace) {
        failed.add(<String, Object?>{
          'objectId': objectId,
          'title': folder.title,
          'message': error.toString(),
        });
        _log('deleteFolder failed: $error',
            error: error, stackTrace: stackTrace);
      }
    }

    if (deleted.isNotEmpty) {
      _fireFolderChanged(folder: deleted.first);
    }

    final summary = _deletedFolderSummary(
      deleted: deleted,
      failed: failed,
      notFound: notFound,
      ambiguous: ambiguous,
    );
    return <String, Object?>{
      'ok': deleted.isNotEmpty,
      'deleted': deleted.isNotEmpty,
      'count': deleted.length,
      'folders': deleted.map(_folderDetailMap).toList(growable: false),
      'failed': failed,
      'notFound': notFound,
      'ambiguous': ambiguous,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': deleted.isNotEmpty ? 'TimeHello 删除清单完成' : 'TimeHello 删除清单失败',
          'description': 'FolderModel delete result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> listStatsRecords(
    Map<String, Object?> args,
  ) async {
    final stats = await _filteredStatsModels(args);
    final summary = _statsListSummary(stats);
    return <String, Object?>{
      'ok': true,
      'count': stats.length,
      'stats': stats.map(_statsDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 查询统计结果',
          'description': 'StatsModel list result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> createStatsRecords(
    Map<String, Object?> args,
  ) async {
    final datas = _extractGenericDatas(args);
    final created = <Map<String, Object?>>[];
    for (final item in datas) {
      final saved = await MongoApisManager.getInstance().insertStatsModel(
        title: _stringOrNull(item['title']),
        fid: _stringOrNull(item['folder_id'] ?? item['folderId']),
        mission_id: _stringOrNull(item['mission_id'] ?? item['missionId']),
        type: _intOrNull(item['type']) ?? 0,
        tagName: _stringOrNull(item['tagNames'] ?? item['tagName']),
        category: _stringOrNull(item['category']),
        color: _intOrNull(item['color']),
        icon: _intOrNull(item['icon']),
        value: _doubleOrNull(item['value']),
        begin_time: _timeMillisOrNull(item['begin_time'] ?? item['beginTime']),
        finish_time:
            _timeMillisOrNull(item['finish_time'] ?? item['finishTime']),
      );
      if (saved != null) {
        created.add(<String, Object?>{
          'objectId': saved.objectId,
          'title': _stringOrNull(item['title']),
          'type': _intOrNull(item['type']) ?? 0,
        });
      }
    }
    final summary = created.isEmpty
        ? '统计记录创建失败，请检查参数或登录状态。'
        : '已创建 ${created.length} 条统计记录：${_safeJsonEncode(created)}';
    return <String, Object?>{
      'ok': created.isNotEmpty,
      'created': created.isNotEmpty,
      'count': created.length,
      'stats': created,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 创建统计完成',
          'description': 'StatsModel create result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> listTimelineRecords(
    Map<String, Object?> args,
  ) async {
    final timelines = await _filteredTimelineModels(args);
    final summary = _timelineListSummary(timelines);
    return <String, Object?>{
      'ok': true,
      'count': timelines.length,
      'timelines': timelines.map(_timelineDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 查询时间线结果',
          'description': 'TimelineMissionModel list result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> createTimelineRecords(
    Map<String, Object?> args,
  ) async {
    final datas = _extractGenericDatas(args);
    final created = <TimelineMissionModel>[];
    for (final item in datas) {
      final timeline = _timelineFromRaw(item);
      final saved = await MongoApisManager.getInstance()
          .insertTimelineMissionModel(missionModel: timeline);
      if (saved != null) {
        timeline.objectId = saved.objectId;
        timeline.createdAt = saved.createdAt;
        created.add(timeline);
      }
    }
    final summary = created.isEmpty
        ? '时间线记录创建失败，请检查参数或登录状态。'
        : _timelineListSummary(created,
            prefix: '已创建 ${created.length} 条时间线记录：');
    return <String, Object?>{
      'ok': created.isNotEmpty,
      'created': created.isNotEmpty,
      'count': created.length,
      'timelines': created.map(_timelineDetailMap).toList(growable: false),
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello 创建时间线完成',
          'description': 'TimelineMissionModel create result',
        },
      ],
    };
  }

  Future<Map<String, Object?>> generateHtmlReport(
    Map<String, Object?> args,
  ) async {
    final includeStats = _boolOrNull(args['includeStats']) ?? true;
    final includeTimeline = _boolOrNull(args['includeTimeline']) ?? true;
    final stats =
        includeStats ? await _filteredStatsModels(args) : const <StatsModel>[];
    final timelines = includeTimeline
        ? await _filteredTimelineModels(args)
        : const <TimelineMissionModel>[];
    final title = _stringOrNull(args['title']) ?? 'TimeHello AI 报表';
    final html = _buildHtmlReport(
      title: title,
      stats: stats,
      timelines: timelines,
    );
    final fileName =
        '${_sanitizeFileName(_stringOrNull(args['fileName']) ?? title)}_${DateTime.now().millisecondsSinceEpoch}.html';
    final file = await Utility.saveBytesToTempDirectory(
      utf8.encode(html),
      fileName,
    );
    final fileUrl = Uri.file(file.path).toString();
    _lastHtmlReportPath = file.path;
    _lastHtmlReportUrl = fileUrl;
    final markdownLink = '[打开 HTML 报表]($fileUrl)';
    final summary =
        '已生成 HTML 报表：$markdownLink\n\n报表路径：$fileUrl\n\n统计记录：${stats.length} 条，时间线记录：${timelines.length} 条。';
    return <String, Object?>{
      'ok': true,
      'created': true,
      'path': file.path,
      'url': fileUrl,
      'markdownLink': markdownLink,
      'statsCount': stats.length,
      'timelineCount': timelines.length,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': summary,
          'name': 'TimeHello HTML 报表完成',
          'description': file.path,
        },
      ],
    };
  }

  Future<Map<String, Object?>> openHtmlReport(Map<String, Object?> args) async {
    final rawUrl = _stringOrNull(args['url']);
    final rawPath = _stringOrNull(args['path']);
    final target =
        rawUrl ?? rawPath ?? _lastHtmlReportUrl ?? _lastHtmlReportPath;
    if (TextUtil.isEmpty(target)) {
      return <String, Object?>{
        'ok': false,
        'opened': false,
        'errorCode': 'empty_report_url',
        'message': '没有可打开的报表路径，请先生成 HTML 报表。',
      };
    }

    final uri = _uriFromPathOrUrl(target!);
    final opened = await _launchExternalUri(uri);
    final content = opened
        ? '已用外部浏览器打开 HTML 报表：${uri.toString()}'
        : '打开 HTML 报表失败：${uri.toString()}';
    return <String, Object?>{
      'ok': opened,
      'opened': opened,
      'url': uri.toString(),
      'path': uri.isScheme('file') ? uri.toFilePath() : null,
      'contextItems': <Object?>[
        <String, Object?>{
          'content': content,
          'name': opened ? 'TimeHello HTML 报表已打开' : 'TimeHello HTML 报表打开失败',
          'description': uri.toString(),
        },
      ],
    };
  }

  Future<Map<String, Object?>> openExternalUrl(Object? data) async {
    final target = _extractUrlFromHostPayload(data);
    if (TextUtil.isEmpty(target)) {
      return <String, Object?>{
        'ok': false,
        'opened': false,
        'errorCode': 'empty_url',
        'message': 'openUrl requires a url/path payload.',
      };
    }
    final uri = _uriFromPathOrUrl(target!);
    final opened = await _launchExternalUri(uri);
    return <String, Object?>{
      'ok': opened,
      'opened': opened,
      'url': uri.toString(),
      'path': uri.isScheme('file') ? uri.toFilePath() : null,
    };
  }

  void openCreateMissionPreview(List<MissionModel> missions) {
    final context = _resolveNavigatorContext();
    if (context == null) {
      _log('openPreview failed no navigator context');
      throw StateError('AIInterfaceManager has no active BuildContext.');
    }

    _log(
      'openPreview count=${missions.length} '
      'isHandset=${Utility.isHandsetBySize()} hasNavigator=${Navigator.maybeOf(context) != null}',
    );
    if (Utility.isHandsetBySize()) {
      Utility.openPagePCAndMobile(
        context,
        child: CreateAIChatGptMissionWidget(listMissionModel: missions),
      );
    } else {
      Utility.openPagePCAndMobile(
        context,
        child: CreateAIMissionContainerWidget(list: missions),
      );
    }
  }

  BuildContext? _resolveNavigatorContext() {
    final localContext = _context;
    if (localContext != null &&
        localContext.mounted &&
        Navigator.maybeOf(localContext) != null) {
      _log('resolveNavigatorContext source=registered');
      return localContext;
    }

    try {
      final globalContext = Utility.getGlobalContext();
      if (globalContext.mounted &&
          Navigator.maybeOf(globalContext, rootNavigator: true) != null) {
        _log('resolveNavigatorContext source=global');
        return globalContext;
      }
      _log(
        'resolveNavigatorContext global unusable mounted=${globalContext.mounted} '
        'hasNavigator=${Navigator.maybeOf(globalContext, rootNavigator: true) != null}',
      );
    } catch (error, stackTrace) {
      _log('resolveNavigatorContext global failed: $error',
          error: error, stackTrace: stackTrace);
    }
    return null;
  }

  void _applyMissionDefaults(MissionModel mission, DateTime now) {
    if (mission.time_mode == 2) {
      // 目标任务的类型必须保持 time_mode=2，同时也需要日期归属，
      // 否则“今天”列表里看不到它。没有明确日期时默认放到今天全天。
      final dateStatusRange = _dateStatusRangeFromNow(mission.dateStatus, now);
      _applyAllDayRange(
        mission,
        dateStatusRange == null
            ? now
            : DateTime.fromMillisecondsSinceEpoch(dateStatusRange.start),
        timeMode: 2,
      );
      mission.dateStatus ??= 1;
      mission.objectiveValue ??= 0;
      mission.objectiveStartValue ??= 0;
      mission.objectiveTotalValue ??= 0;
      mission.objectiveUnit ??= '';
      return;
    }

    final dateStatusRange = _dateStatusRangeFromNow(mission.dateStatus, now);
    if (mission.time_mode == 0 && dateStatusRange != null) {
      // dateStatus 是 TimeHello 对“今天/明天/最近7天”的业务语义。
      // 即使模型误传了旧日期，也以本机当前日期重算，避免“今天”落到历史日期。
      _applyAllDayRange(
        mission,
        DateTime.fromMillisecondsSinceEpoch(dateStatusRange.start),
      );
    }

    if ((mission.start_time == null || mission.start_time == 0) &&
        mission.end_time != null &&
        mission.end_time != 0 &&
        (mission.time_mode == null || mission.time_mode == 1)) {
      // 用户只说“明天的任务/某天截止”时，模型可能只给 end_time，
      // 但仍错误保留 time_mode=1。没有 start_time 就不是时间段任务，
      // 应保存成这一天的全天范围，避免 UI 显示“当前时间 - 明天 00:00”。
      _applyAllDayRange(
        mission,
        DateTime.fromMillisecondsSinceEpoch(mission.end_time!),
      );
    }

    if (mission.time_mode == 1 &&
        mission.start_time != null &&
        mission.end_time != null &&
        mission.end_time! <= mission.start_time!) {
      // 模型偶尔会给出“当前时间 -> 今天 00:00”的反向区间。
      // 这种时间段无业务意义，按 end_time 所在日期的全天任务兜底。
      _applyAllDayRange(
        mission,
        DateTime.fromMillisecondsSinceEpoch(mission.end_time!),
      );
    }

    if ((mission.start_time == null || mission.start_time == 0) &&
        (mission.end_time == null || mission.end_time == 0)) {
      // AI 有时会把“无时间”写成 time_mode=0/end_time=0；0 是 Unix epoch，
      // 直接保存会在 UI 里显示 1970。用户没写时间时，TimeHello 语义上默认
      // 归到“今天全天”，而不是凭空创建当前时间后一小时的时间段任务。
      mission.dateStatus = 1;
      _applyAllDayRange(mission, now);
    }
    mission.time_mode ??= mission.start_time != null ? 1 : 0;
    if (mission.time_mode == 1) {
      mission.start_time ??=
          now.add(const Duration(hours: 1)).millisecondsSinceEpoch;
      mission.end_time ??=
          now.add(const Duration(hours: 2)).millisecondsSinceEpoch;
    }
  }

  void _applyAllDayRange(
    MissionModel mission,
    DateTime dateTime, {
    int timeMode = 1,
  }) {
    final dayStart = DateTime(dateTime.year, dateTime.month, dateTime.day);
    // MissionPage / CalendarModel 的当天筛选上限来自
    // Utility.getFilterDateTimeFromTimeStamp(..., true)，精度是 23:59:59.000。
    // 这里如果保存成 23:59:59.999，会因为毫秒大于页面上限而从“今天”列表漏掉。
    final dayEnd =
        DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
    mission.time_mode = timeMode;
    mission.start_time = dayStart.millisecondsSinceEpoch;
    mission.end_time = dayEnd.millisecondsSinceEpoch;
  }

  int? _normalizeEndOfDayMillis(int? millis) {
    if (millis == null || millis == 0) {
      return millis;
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(millis);
    if (dateTime.hour == 23 &&
        dateTime.minute == 59 &&
        dateTime.second == 59 &&
        dateTime.millisecond > 0) {
      // MissionPage 的日期筛选上限固定到 23:59:59.000。
      // 模型常见输出 23:59:59.999，保存前压平，避免当天任务漏出列表。
      return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59)
          .millisecondsSinceEpoch;
    }
    return millis;
  }

  _DateRange? _dateStatusRangeFromNow(int? dateStatus, DateTime now) {
    final startMillis = _dateStatusEndMillis(dateStatus, now);
    if (startMillis == null) {
      return null;
    }
    final start = DateTime.fromMillisecondsSinceEpoch(startMillis);
    final endExclusive = start.add(const Duration(days: 1));
    return _DateRange(
      start.millisecondsSinceEpoch,
      endExclusive.millisecondsSinceEpoch,
    );
  }

  int? _dateStatusEndMillis(int? dateStatus, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (dateStatus == 1) {
      return today.millisecondsSinceEpoch;
    }
    if (dateStatus == 2) {
      return today.add(const Duration(days: 1)).millisecondsSinceEpoch;
    }
    if (dateStatus == 3) {
      return today.add(const Duration(days: 7)).millisecondsSinceEpoch;
    }
    return null;
  }

  List<Map<String, Object?>> _extractMissionDatas(Map<String, Object?> args) {
    final unwrapped = _unwrapArguments(args);
    _log('extractMissionDatas unwrapped=${_safeJsonEncode(unwrapped)}');
    final datas = unwrapped['datas'] ??
        unwrapped['data'] ??
        unwrapped['missions'] ??
        unwrapped['tasks'];
    if (datas is List) {
      return datas.whereType<Map>().map(_castMap).toList(growable: false);
    }
    if (datas is Map) {
      return <Map<String, Object?>>[_castMap(datas)];
    }
    if (_missionTitle(unwrapped).isNotEmpty) {
      return <Map<String, Object?>>[unwrapped];
    }
    return const <Map<String, Object?>>[];
  }

  List<Map<String, Object?>> _extractMissionUpdateDatas(
    Map<String, Object?> args,
  ) {
    final unwrapped = _unwrapArguments(args);
    final datas = unwrapped['datas'] ??
        unwrapped['data'] ??
        unwrapped['missions'] ??
        unwrapped['tasks'];
    if (datas is List) {
      return datas.whereType<Map>().map(_castMap).toList(growable: false);
    }
    if (datas is Map) {
      return <Map<String, Object?>>[_castMap(datas)];
    }
    if (_extractObjectIds(unwrapped, idAliases: const <String>[
          'objectIds',
          'ids',
          'missionIds',
          'mission_ids',
        ]).isNotEmpty ||
        _missionTitle(unwrapped).isNotEmpty) {
      return <Map<String, Object?>>[unwrapped];
    }
    return const <Map<String, Object?>>[];
  }

  List<Map<String, Object?>> _extractFolderDatas(Map<String, Object?> args) {
    final unwrapped = _unwrapArguments(args);
    final datas = unwrapped['datas'] ??
        unwrapped['data'] ??
        unwrapped['folders'] ??
        unwrapped['folderModels'] ??
        unwrapped['lists'];
    if (datas is List) {
      return datas.whereType<Map>().map(_castMap).toList(growable: false);
    }
    if (datas is Map) {
      return <Map<String, Object?>>[_castMap(datas)];
    }
    if (_folderTitle(unwrapped).isNotEmpty ||
        _extractObjectIds(unwrapped, idAliases: const <String>[
          'objectIds',
          'ids',
          'folderIds',
          'folder_ids',
        ]).isNotEmpty) {
      return <Map<String, Object?>>[unwrapped];
    }
    return const <Map<String, Object?>>[];
  }

  List<Map<String, Object?>> _extractGenericDatas(Map<String, Object?> args) {
    final unwrapped = _unwrapArguments(args);
    final datas = unwrapped['datas'] ??
        unwrapped['data'] ??
        unwrapped['items'] ??
        unwrapped['records'];
    if (datas is List) {
      return datas.whereType<Map>().map(_castMap).toList(growable: false);
    }
    if (datas is Map) {
      return <Map<String, Object?>>[_castMap(datas)];
    }
    return <Map<String, Object?>>[unwrapped];
  }

  Future<List<StatsModel>> _filteredStatsModels(
    Map<String, Object?> args,
  ) async {
    final manager = MongoApisManager.getInstance();
    if (manager.listStatsModels.isEmpty ||
        _boolOrNull(args['refresh']) == true) {
      await manager.queryWhereEqual_statsModel(shouldRefresh: true);
    }
    var stats = List<StatsModel>.from(manager.listStatsModels);
    final folderId = _stringOrNull(args['folder_id'] ?? args['folderId']);
    final missionId = _stringOrNull(args['mission_id'] ?? args['missionId']);
    final title = _stringOrNull(args['title']);
    final category = _stringOrNull(args['category']);
    final type = _intOrNull(args['type']);
    final startTime =
        _timeMillisOrNull(args['start_time'] ?? args['startTime']);
    final endTime = _timeMillisOrNull(args['end_time'] ?? args['endTime']);

    if (folderId != null) {
      stats = stats.where((item) => item.folder_id == folderId).toList();
    }
    if (missionId != null) {
      stats = stats.where((item) => item.mission_id == missionId).toList();
    }
    if (title != null) {
      stats =
          stats.where((item) => (item.title ?? '').contains(title)).toList();
    }
    if (category != null) {
      stats = stats
          .where((item) => (item.category ?? '').contains(category))
          .toList();
    }
    if (type != null) {
      stats = stats.where((item) => item.type == type).toList();
    }
    if (startTime != null || endTime != null) {
      stats = stats.where((item) {
        final time = item.begin_time ??
            (item.createdAt != null
                ? Utility.getTimestampFromDateTime(item.createdAt!)
                : null);
        if (time == null) {
          return false;
        }
        if (startTime != null && time < startTime) {
          return false;
        }
        if (endTime != null && time > endTime) {
          return false;
        }
        return true;
      }).toList();
    }
    return _limitList(stats, _intOrNull(args['limit']) ?? 50);
  }

  Future<List<TimelineMissionModel>> _filteredTimelineModels(
    Map<String, Object?> args,
  ) async {
    final manager = MongoApisManager.getInstance();
    if (manager.listTimelineMissionModel.isEmpty ||
        _boolOrNull(args['refresh']) == true) {
      await manager.queryWhereEqual_TimelineMissionModel(shouldRefresh: true);
    }
    var timelines =
        List<TimelineMissionModel>.from(manager.listTimelineMissionModel);
    final folderId = _stringOrNull(args['folder_id'] ?? args['folderId']);
    final missionId = _stringOrNull(args['mission_id'] ?? args['missionId']);
    final title = _stringOrNull(args['title']);
    final sceneType = _stringOrNull(args['sceneType']);
    final eventType = _stringOrNull(args['eventType']);
    final startTime =
        _timeMillisOrNull(args['start_time'] ?? args['startTime']);
    final endTime = _timeMillisOrNull(args['end_time'] ?? args['endTime']);

    if (folderId != null) {
      timelines =
          timelines.where((item) => item.folder_id == folderId).toList();
    }
    if (missionId != null) {
      timelines =
          timelines.where((item) => item.mission_id == missionId).toList();
    }
    if (title != null) {
      timelines = timelines
          .where((item) => (item.title ?? '').contains(title))
          .toList();
    }
    if (sceneType != null) {
      timelines =
          timelines.where((item) => item.sceneType == sceneType).toList();
    }
    if (eventType != null) {
      timelines =
          timelines.where((item) => item.eventType == eventType).toList();
    }
    if (startTime != null || endTime != null) {
      timelines = timelines.where((item) {
        final time = item.end_time ??
            (item.createdAt != null
                ? Utility.getTimestampFromDateTime(item.createdAt!)
                : null);
        if (time == null) {
          return false;
        }
        if (startTime != null && time < startTime) {
          return false;
        }
        if (endTime != null && time > endTime) {
          return false;
        }
        return true;
      }).toList();
    }
    return _limitList(timelines, _intOrNull(args['limit']) ?? 80);
  }

  List<T> _limitList<T>(List<T> list, int limit) {
    if (limit <= 0 || list.length <= limit) {
      return list;
    }
    return list.take(limit).toList(growable: false);
  }

  TimelineMissionModel _timelineFromRaw(Map<String, Object?> raw) {
    final timeline = TimelineMissionModel(
      sceneType: _stringOrNull(raw['sceneType']),
      eventType: _stringOrNull(raw['eventType']),
      timelineMessage: _stringOrNull(raw['timelineMessage']),
      title: _stringOrNull(raw['title']),
      message: _stringOrNull(raw['message']),
      extra: _stringOrNull(raw['extra']),
      picUrl: _stringOrNull(raw['picUrl']),
      url: _stringOrNull(raw['url']),
      color: _intOrNull(raw['color']) ?? 0,
      icon: _intOrNull(raw['icon']) ?? 0,
      tagName: _stringOrNull(raw['tagName']),
      folder_id: _stringOrNull(raw['folder_id'] ?? raw['folderId']),
      tagNames: _stringOrNull(raw['tagNames']),
      tagIds: _stringOrNull(raw['tagIds']),
      total_tomotoes: _intOrNull(raw['total_tomotoes']),
      no_tomotoes_finished: _intOrNull(raw['no_tomotoes_finished']),
      tomato_duration: _intOrNull(raw['tomato_duration']),
      end_time: _timeMillisOrNull(raw['end_time'] ?? raw['endTime']),
      alert_time: _timeMillisOrNull(raw['alert_time'] ?? raw['alertTime']),
      time_finished: _intOrNull(raw['time_finished']),
      end_time_before_finished: _intOrNull(raw['end_time_before_finished']),
      dateStatus: _intOrNull(raw['dateStatus']),
      priorityStatus: _intOrNull(raw['priorityStatus']),
      isFinished: _boolOrNull(raw['isFinished'] ?? raw['is_finished']),
      isDelayed: _boolOrNull(raw['isDelayed'] ?? raw['is_delayed']),
      repetiveType: _intOrNull(raw['repetiveType']),
      repetiveValue: _intOrNull(raw['repetiveValue']),
    );
    timeline.mission_id = _stringOrNull(raw['mission_id'] ?? raw['missionId']);
    timeline.object_id = _stringOrNull(raw['object_id'] ?? raw['objectId']);
    final repetiveWeekDay = raw['repetiveWeekDay'];
    if (repetiveWeekDay is List) {
      timeline.repetiveWeekDay = repetiveWeekDay;
    }
    return timeline;
  }

  List<FolderModel> createFolders(Map<String, Object?> args) {
    final rawDatas = _extractFolderDatas(args);
    final now = DateTime.now().millisecondsSinceEpoch;
    final folders = <FolderModel>[];
    for (final rawFolder in rawDatas) {
      final title = _folderTitle(rawFolder);
      if (TextUtil.isEmpty(title)) {
        _log('skip folder without title: ${_safeJsonEncode(rawFolder)}');
        continue;
      }
      final tag = _folderTagFromInput(rawFolder);
      final resolvedColor = _folderColorFromInput(rawFolder, tag: tag);

      final folder = FolderModel()
        ..title = title
        ..description = _stringOrNull(rawFolder['description'])
        ..tag = tag
        ..color = resolvedColor
        ..tagColor = _intOrNull(rawFolder['tagColor']) ?? resolvedColor
        ..icon = _intOrNull(rawFolder['icon']) ?? _defaultFolderIcon(tag)
        ..iconType = _intOrNull(rawFolder['iconType']) ?? 0
        ..layoutType = _intOrNull(rawFolder['layoutType']) ?? 0
        ..folderStatus = _intOrNull(rawFolder['folderStatus']) ?? 0
        ..filterType = _intOrNull(rawFolder['filterType']) ?? 0
        ..create_time = _intOrNull(rawFolder['create_time']) ?? now
        ..update_time = _intOrNull(rawFolder['update_time']) ?? now;

      // FolderPage 里 tag=1 清单会带团队 ID；AI 直写时补齐，避免和页面创建链路不一致。
      if (tag == 1) {
        folder.folderTeamWorkId = Utility.getGroupId();
      }
      folder.folderModelObjectIdOrderList =
          _stringListFromAny(rawFolder['folderModelObjectIdOrderList']);
      folder.groupModelObjectIdOrderList =
          _stringListFromAny(rawFolder['groupModelObjectIdOrderList']);
      folders.add(folder);
    }
    return folders;
  }

  int _defaultFolderIcon(int? tag) {
    if (tag == 1) {
      return Icons.circle.codePoint;
    }
    if (tag == 2) {
      return Icons.local_offer.codePoint;
    }
    return 0;
  }

  int _folderColorFromInput(Map<String, Object?> rawFolder, {int? tag}) {
    final explicitColor = _intOrNull(rawFolder['color']);
    if (explicitColor != null && explicitColor != 0) {
      return explicitColor;
    }
    final colorName = _stringOrNull(rawFolder['colorName']) ??
        _stringOrNull(rawFolder['color_name']) ??
        _stringOrNull(rawFolder['颜色']) ??
        _stringOrNull(rawFolder['颜色名称']);
    final fromName = _paletteColorByName(colorName);
    if (fromName != null) {
      return fromName;
    }
    return CONSTANTS.getColors()[0].color;
  }

  int? _paletteColorByName(String? colorName) {
    if (colorName == null) {
      return null;
    }
    final text = colorName.toLowerCase();
    if (text.contains('red') || text.contains('红')) {
      return 0xffed7573;
    }
    if (text.contains('orange') || text.contains('橙')) {
      return 0xfff1a068;
    }
    if (text.contains('yellow') || text.contains('黄')) {
      return 0xfffff2b1;
    }
    if (text.contains('green') || text.contains('绿')) {
      return 0xff7bd497;
    }
    if (text.contains('blue') || text.contains('蓝')) {
      return 0xff6083f6;
    }
    if (text.contains('purple') ||
        text.contains('violet') ||
        text.contains('紫')) {
      return 0xffe1ccff;
    }
    if (text.contains('pink') || text.contains('粉')) {
      return 0xffff88ff;
    }
    if (text.contains('gray') || text.contains('grey') || text.contains('灰')) {
      return 0xffb4b6b9;
    }
    return null;
  }

  int _folderTagFromInput(Map<String, Object?> rawFolder) {
    final typeText = [
      rawFolder['type'],
      rawFolder['folderType'],
      rawFolder['folder_type'],
      rawFolder['kind'],
      rawFolder['类型'],
    ]
        .whereType<Object>()
        .map((item) => item.toString())
        .join(' ')
        .toLowerCase();
    final titleText = [
      rawFolder['title'],
      rawFolder['name'],
      rawFolder['folder_title'],
      rawFolder['folderTitle'],
      rawFolder['清单名称'],
      rawFolder['文件夹名称'],
      rawFolder['标签名称'],
    ]
        .whereType<Object>()
        .map((item) => item.toString())
        .join(' ')
        .toLowerCase();
    final combined = '$typeText $titleText';
    final hasListTitleKey = rawFolder.containsKey('listName') ||
        rawFolder.containsKey('list_name') ||
        rawFolder.containsKey('清单名称') ||
        rawFolder.containsKey('清单名');
    final hasFolderContainerTitleKey = rawFolder.containsKey('folderName') ||
        rawFolder.containsKey('folder_name') ||
        rawFolder.containsKey('文件夹名称') ||
        rawFolder.containsKey('文件夹名');
    final explicitTag = _intOrNull(rawFolder['tag']);

    // AI 有时会把“创建清单 X”错误解析成 tag=3。清单/列表语义优先级
    // 必须高于显式 tag，因为 tag=1 才能承载 MissionModel.folder_id。
    if (combined.contains('list') ||
        combined.contains('listing') ||
        combined.contains('清单') ||
        combined.contains('列表') ||
        hasListTitleKey) {
      return 1;
    }

    if (explicitTag != null) {
      return explicitTag;
    }

    if (_intOrNull(rawFolder['filterType']) == 1 ||
        rawFolder['filterConditionMap'] != null ||
        combined.contains('filter') ||
        combined.contains('过滤器')) {
      return 4;
    }
    if (combined.contains('tag') || combined.contains('标签')) {
      return 2;
    }
    if (combined.contains('goal') ||
        combined.contains('objective') ||
        combined.contains('目标')) {
      return 5;
    }
    if (combined.contains('folder') ||
        combined.contains('directory') ||
        combined.contains('container') ||
        combined.contains('文件夹') ||
        combined.contains('目录') ||
        combined.contains('分组') ||
        (hasFolderContainerTitleKey && !hasListTitleKey)) {
      return 3;
    }
    if (combined.contains('circle') ||
        combined.contains('圆形') ||
        combined.contains('图案')) {
      return 1;
    }

    // FolderPage 中 tag=1 是任务清单，tag=3 只是承载子清单的文件夹容器。
    // AI 未明确说明类型时，默认创建可直接挂任务的普通清单。
    return 1;
  }

  Map<String, Object?> _unwrapArguments(Map<String, Object?> args) {
    final argumentCandidates = <Object?>[
      args['arguments'],
      args['args'],
      args['input'],
      args['params'],
      (args['toolCall'] is Map) ? (args['toolCall'] as Map)['function'] : null,
      args['function'],
    ];

    for (final candidate in argumentCandidates) {
      if (candidate is String && candidate.trim().isNotEmpty) {
        _log('unwrapArguments decode string candidate=${candidate.trim()}');
        final decoded = jsonDecode(candidate);
        if (decoded is Map) {
          return _castMap(decoded);
        }
      }
      if (candidate is Map) {
        final casted = _castMap(candidate);
        final nestedArguments = casted['arguments'];
        if (nestedArguments is String && nestedArguments.trim().isNotEmpty) {
          _log(
              'unwrapArguments decode nested arguments=${nestedArguments.trim()}');
          final decoded = jsonDecode(nestedArguments);
          if (decoded is Map) {
            return _castMap(decoded);
          }
        }
        if (casted['datas'] != null ||
            casted['data'] != null ||
            casted['missions'] != null ||
            casted['tasks'] != null ||
            _missionTitle(casted).isNotEmpty) {
          return casted;
        }
      }
    }

    return args;
  }

  Future<Map<String, Object?>> _resolveDeleteTargets(
    Map<String, Object?> args,
  ) async {
    final unwrapped = _unwrapArguments(args);
    _log('resolveDeleteTargets unwrapped=${_safeJsonEncode(unwrapped)}');
    final objectIds = <String>{};
    final titles = <String>{};

    objectIds.addAll(_stringListFromAny(unwrapped['objectIds']));
    objectIds.addAll(_stringListFromAny(unwrapped['ids']));
    objectIds.addAll(_stringListFromAny(unwrapped['missionIds']));
    objectIds.addAll(_stringListFromAny(unwrapped['mission_ids']));
    final singleObjectId = _stringOrNull(unwrapped['objectId']) ??
        _stringOrNull(unwrapped['id']) ??
        _stringOrNull(unwrapped['mission_id']);
    if (singleObjectId != null) {
      objectIds.add(singleObjectId);
    }

    titles.addAll(_stringListFromAny(unwrapped['exact_titles']));
    titles.addAll(_stringListFromAny(unwrapped['titles']));
    final singleTitle = _stringOrNull(unwrapped['title']) ??
        _stringOrNull(unwrapped['name']) ??
        _stringOrNull(unwrapped['taskName']) ??
        _stringOrNull(unwrapped['task_name']) ??
        _stringOrNull(unwrapped['missionName']) ??
        _stringOrNull(unwrapped['任务名称']) ??
        _stringOrNull(unwrapped['任务名']) ??
        _stringOrNull(unwrapped['名称']);
    if (singleTitle != null) {
      titles.add(singleTitle);
    }

    final datas = unwrapped['datas'] ??
        unwrapped['data'] ??
        unwrapped['missions'] ??
        unwrapped['tasks'];
    if (datas is List) {
      for (final item in datas.whereType<Map>()) {
        final target = _castMap(item);
        final objectId = _stringOrNull(target['objectId']) ??
            _stringOrNull(target['id']) ??
            _stringOrNull(target['mission_id']);
        if (objectId != null) {
          objectIds.add(objectId);
          continue;
        }
        final title = _missionTitle(target);
        if (title.isNotEmpty) {
          titles.add(title);
        }
      }
    } else if (datas is Map) {
      final target = _castMap(datas);
      final objectId = _stringOrNull(target['objectId']) ??
          _stringOrNull(target['id']) ??
          _stringOrNull(target['mission_id']);
      if (objectId != null) {
        objectIds.add(objectId);
      } else {
        final title = _missionTitle(target);
        if (title.isNotEmpty) {
          titles.add(title);
        }
      }
    }

    final manager = MongoApisManager.getInstance();
    if (titles.isNotEmpty && manager.listMissionModels.isEmpty) {
      await manager.queryWhereEqual_missionData(shouldRefresh: true);
    }

    final resolved = <MissionModel>[];
    final notFound = <Map<String, Object?>>[];
    final ambiguous = <Map<String, Object?>>[];

    for (final objectId in objectIds) {
      final cached = manager.queryWhereEqual_missionDataByObjectId(
        objectId: objectId,
      );
      if (cached != null) {
        resolved.add(cached);
      } else {
        // 这里仍保留按 ID 删除的能力：缓存可能尚未刷新，但用户给出的 objectId
        // 已经足够精确，底层 Mongo 删除会再次校验当前登录用户范围。
        resolved.add(MissionModel()..objectId = objectId);
      }
    }

    for (final title in titles) {
      final matches = _findMissionModelsByExactTitle(title);
      if (matches.length == 1) {
        resolved.add(matches.first);
      } else if (matches.isEmpty) {
        notFound.add(<String, Object?>{'title': title});
      } else {
        ambiguous.add(<String, Object?>{
          'title': title,
          'count': matches.length,
          'candidates': matches.map(_missionDetailMap).toList(growable: false),
        });
      }
    }

    return <String, Object?>{
      'resolved': resolved,
      'notFound': notFound,
      'ambiguous': ambiguous,
    };
  }

  Future<_FolderDeleteResolution> _resolveFolderDeleteTargets(
    Map<String, Object?> args,
  ) async {
    final unwrapped = _unwrapArguments(args);
    final manager = MongoApisManager.getInstance();
    if (manager.listFolderModels.isEmpty) {
      await manager.queryWhereEqual_folderModel(shouldRefresh: true);
    }

    final objectIds = _extractObjectIds(
      unwrapped,
      idAliases: const <String>[
        'objectIds',
        'ids',
        'folderIds',
        'folder_ids',
      ],
      singleAliases: const <String>['objectId', 'id', 'folder_id'],
    );
    final titles = _extractTitles(unwrapped);

    final datas = unwrapped['datas'] ??
        unwrapped['data'] ??
        unwrapped['folders'] ??
        unwrapped['folderModels'] ??
        unwrapped['lists'];
    if (datas is List) {
      for (final item in datas.whereType<Map>()) {
        final target = _castMap(item);
        objectIds.addAll(_extractObjectIds(
          target,
          idAliases: const <String>[],
          singleAliases: const <String>['objectId', 'id', 'folder_id'],
        ));
        final title = _folderTitle(target);
        if (title.isNotEmpty) {
          titles.add(title);
        }
      }
    } else if (datas is Map) {
      final target = _castMap(datas);
      objectIds.addAll(_extractObjectIds(
        target,
        idAliases: const <String>[],
        singleAliases: const <String>['objectId', 'id', 'folder_id'],
      ));
      final title = _folderTitle(target);
      if (title.isNotEmpty) {
        titles.add(title);
      }
    }

    final resolved = <FolderModel>[];
    final notFound = <Map<String, Object?>>[];
    final ambiguous = <Map<String, Object?>>[];
    for (final objectId in objectIds) {
      final folder = manager.queryfolderModelWithFolderId(objectId);
      if (folder != null) {
        resolved.add(folder);
      } else {
        // 用户显式给出 objectId 时，直接交给 Mongo 删除；缓存可能尚未刷新。
        resolved.add(FolderModel()..objectId = objectId);
      }
    }

    for (final title in titles) {
      final matches = _findFolderModelsByExactTitle(title);
      if (matches.length == 1) {
        resolved.add(matches.first);
      } else if (matches.isEmpty) {
        notFound.add(<String, Object?>{'title': title});
      } else {
        ambiguous.add(<String, Object?>{
          'title': title,
          'count': matches.length,
          'candidates': matches.map(_folderDetailMap).toList(growable: false),
        });
      }
    }

    return _FolderDeleteResolution(
      resolved: resolved,
      notFound: notFound,
      ambiguous: ambiguous,
    );
  }

  List<MissionModel> _findMissionModelsByExactTitle(String title) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return const <MissionModel>[];
    }
    final missions = MongoApisManager.getInstance().listMissionModels;
    final exactMatches = missions
        .where((mission) => (mission.title ?? '').trim() == normalizedTitle)
        .toList(growable: false);
    if (exactMatches.isNotEmpty) {
      return exactMatches;
    }

    // 用户口述任务标题时经常省略中间空格，如“修复线上bug”。
    // 精确匹配失败后只做空白折叠兜底，避免把真正不同的标题模糊合并。
    final compactTitle = _compactTitle(normalizedTitle);
    if (compactTitle.isEmpty) {
      return const <MissionModel>[];
    }
    return missions
        .where((mission) => _compactTitle(mission.title ?? '') == compactTitle)
        .toList(growable: false);
  }

  String _compactTitle(String value) {
    return value.replaceAll(RegExp(r'\s+'), '').trim();
  }

  List<FolderModel> _findFolderModelsByExactTitle(String title, {int? tag}) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return const <FolderModel>[];
    }
    final manager = MongoApisManager.getInstance();
    final folders = tag == 1
        ? manager.queryWhereEqual_folderModelWithCircle()
        : tag == 3
            ? manager.queryWhereEqual_folderModelWithFolderTag()
            : manager.listFolderModels;
    return folders
        .where((folder) =>
            (folder.title ?? '').trim() == normalizedTitle &&
            (tag == null || folder.tag == tag))
        .toList(growable: false);
  }

  String _missionTitle(Map<String, Object?> rawMission) {
    final value = rawMission['title'] ??
        rawMission['name'] ??
        rawMission['taskName'] ??
        rawMission['task_name'] ??
        rawMission['missionName'] ??
        rawMission['mission_name'] ??
        rawMission['任务名称'] ??
        rawMission['任务名'] ??
        rawMission['名称'];
    return (value ?? '').toString().trim();
  }

  String _folderTitle(Map<String, Object?> rawFolder) {
    final value = rawFolder['title'] ??
        rawFolder['name'] ??
        rawFolder['folderTitle'] ??
        rawFolder['folder_title'] ??
        rawFolder['folderName'] ??
        rawFolder['folder_name'] ??
        rawFolder['listName'] ??
        rawFolder['list_name'] ??
        rawFolder['清单名称'] ??
        rawFolder['文件夹名称'] ??
        rawFolder['标签名称'] ??
        rawFolder['名称'];
    return (value ?? '').toString().trim();
  }

  String? _folderIdByExactTitle(String? title) {
    if (TextUtil.isEmpty(title)) {
      return null;
    }
    final matches = _findFolderModelsByExactTitle(title!, tag: 1);
    return matches.length == 1 ? matches.first.objectId : null;
  }

  String? _missionListFolderTitle(Map<String, Object?> args) {
    return _stringOrNull(args['folder_title']) ??
        _stringOrNull(args['folderTitle']) ??
        _stringOrNull(args['list_title']) ??
        _stringOrNull(args['listTitle']) ??
        _stringOrNull(args['listing_title']) ??
        _stringOrNull(args['listingTitle']) ??
        _stringOrNull(args['清单名称']) ??
        _stringOrNull(args['清单名']);
  }

  _MissionListFolderResolution _resolveMissionListFolderFilter(
    Map<String, Object?> args,
  ) {
    final folderId =
        _stringOrNull(args['folder_id']) ?? _stringOrNull(args['folderId']);
    if (folderId != null) {
      return _MissionListFolderResolution(
        folderId: folderId,
        folder: _findFolderModelByObjectId(folderId),
      );
    }

    final folderTitle = _missionListFolderTitle(args);
    if (folderTitle == null) {
      return const _MissionListFolderResolution();
    }

    final matches = _findFolderModelsByExactTitle(folderTitle, tag: 1);
    if (matches.isEmpty) {
      return _MissionListFolderResolution(
        notFound: <Map<String, Object?>>[
          <String, Object?>{
            'folder_title': folderTitle,
            'expected_tag': 1,
            'message': '未找到同名 tag=1 清单，已停止查询，避免返回全量任务。',
          }
        ],
      );
    }
    if (matches.length > 1) {
      return _MissionListFolderResolution(
        ambiguous: <Map<String, Object?>>[
          <String, Object?>{
            'folder_title': folderTitle,
            'expected_tag': 1,
            'count': matches.length,
            'candidates': matches.map(_folderDetailMap).toList(growable: false),
            'message': '找到多个同名 tag=1 清单，已停止查询，避免返回错误清单任务。',
          }
        ],
      );
    }
    final folder = matches.first;
    return _MissionListFolderResolution(
      folderId: folder.objectId,
      folder: folder,
    );
  }

  Future<void> _ensureTeamWorkIdForListing(FolderModel folder) async {
    if (folder.tag != 1 || !TextUtil.isEmpty(folder.folderTeamWorkId)) {
      return;
    }
    folder.folderTeamWorkId = Utility.getGroupId();
    folder.update_time = DateTime.now().millisecondsSinceEpoch;
    await MongoApisManager.getInstance().update_FolderModelWithFM(
      folderModel: folder,
    );
    _log(
      'ensureTeamWorkIdForListing title=${folder.title} '
      'objectId=${folder.objectId} groupId=${folder.folderTeamWorkId}',
    );
  }

  String? _parentFolderId(Map<String, Object?> rawFolder) {
    return _stringOrNull(rawFolder['parent_folder_id']) ??
        _stringOrNull(rawFolder['parentFolderId']) ??
        _stringOrNull(rawFolder['folder_parent_id']) ??
        _stringOrNull(rawFolder['folderParentId']);
  }

  String? _parentFolderTitle(Map<String, Object?> rawFolder) {
    final explicitParentTitle =
        _stringOrNull(rawFolder['parent_folder_title']) ??
            _stringOrNull(rawFolder['parentFolderTitle']) ??
            _stringOrNull(rawFolder['folder_parent_title']) ??
            _stringOrNull(rawFolder['folderParentTitle']) ??
            _stringOrNull(rawFolder['container_title']) ??
            _stringOrNull(rawFolder['containerTitle']) ??
            _stringOrNull(rawFolder['folder_title_for_parent']) ??
            _stringOrNull(rawFolder['folderTitleForParent']) ??
            _stringOrNull(rawFolder['父文件夹']) ??
            _stringOrNull(rawFolder['父目录']);
    if (explicitParentTitle != null) {
      return explicitParentTitle;
    }

    // 兼容模型把父文件夹写成 folder_title/文件夹名称 的情况。
    // 只有子清单标题已经由独立字段表达时才启用，避免“创建清单 X”
    // 被误判成“在文件夹 X 下创建清单 X”。
    final childTitle = _explicitChildFolderTitle(rawFolder);
    final ambiguousParentTitle = _stringOrNull(rawFolder['folder_title']) ??
        _stringOrNull(rawFolder['folderTitle']) ??
        _stringOrNull(rawFolder['文件夹名称']) ??
        _stringOrNull(rawFolder['文件夹名']);
    if (childTitle != null &&
        ambiguousParentTitle != null &&
        childTitle != ambiguousParentTitle) {
      return ambiguousParentTitle;
    }
    return null;
  }

  String? _explicitChildFolderTitle(Map<String, Object?> rawFolder) {
    return _stringOrNull(rawFolder['title']) ??
        _stringOrNull(rawFolder['name']) ??
        _stringOrNull(rawFolder['listName']) ??
        _stringOrNull(rawFolder['list_name']) ??
        _stringOrNull(rawFolder['清单名称']) ??
        _stringOrNull(rawFolder['清单名']);
  }

  FolderModel? _findFolderModelByObjectId(String? objectId) {
    if (TextUtil.isEmpty(objectId)) {
      return null;
    }
    return MongoApisManager.getInstance()
        .queryfolderModelWithFolderId(objectId);
  }

  Future<FolderModel?> _ensureFolderContainerByTitle(String title) async {
    final matches = _findFolderModelsByExactTitle(title, tag: 3);
    if (matches.length == 1) {
      return matches.first;
    }
    if (matches.length > 1) {
      _log('parentFolder ambiguous title=$title count=${matches.length}');
      return null;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final folder = FolderModel()
      ..title = title
      // tag=3 是 FolderPage 中的文件夹容器，只通过 folderModelObjectIdOrderList 挂子清单。
      ..tag = 3
      ..color = 0
      ..icon = 0
      ..iconType = 0
      ..layoutType = 0
      ..folderStatus = 0
      ..filterType = 0
      ..create_time = now
      ..update_time = now
      ..folderModelObjectIdOrderList = <String>[];
    final saved = await MongoApisManager.getInstance()
        .insertFolderModel(folderModel: folder);
    if (saved == null || TextUtil.isEmpty(saved.objectId)) {
      _log('parentFolder create failed title=$title');
      return null;
    }
    folder.objectId = saved.objectId;
    folder.createdAt = saved.createdAt;
    _log('parentFolder created title=$title objectId=${folder.objectId}');
    return folder;
  }

  Future<void> _linkCreatedFolderToParent(
    FolderModel child,
    Map<String, Object?> rawFolder,
  ) async {
    if (TextUtil.isEmpty(child.objectId)) {
      return;
    }
    final parentId = _parentFolderId(rawFolder);
    final parentTitle = _parentFolderTitle(rawFolder);
    FolderModel? parent = _findFolderModelByObjectId(parentId);
    if (parent == null && parentTitle != null) {
      parent = await _ensureFolderContainerByTitle(parentTitle);
    }
    if (parent == null) {
      return;
    }
    if (parent.tag != 3) {
      _log(
        'skip parent link because parent is not folder container '
        'title=${parent.title} tag=${parent.tag}',
      );
      return;
    }
    parent.folderModelObjectIdOrderList ??= <String>[];
    if (parent.folderModelObjectIdOrderList?.contains(child.objectId) != true) {
      parent.folderModelObjectIdOrderList?.add(child.objectId!);
    }
    await MongoApisManager.getInstance().updateFolderModelsForFolderObjectId(
      objectId: child.objectId!,
      folderModelForFolder: parent,
    );
    _log(
      'linkedFolderToParent child=${child.title}/${child.objectId} '
      'parent=${parent.title}/${parent.objectId}',
    );
  }

  bool _hasParentFolderInput(Map<String, Object?> rawFolder) {
    return _parentFolderId(rawFolder) != null ||
        _parentFolderTitle(rawFolder) != null;
  }

  Future<Object?> _moveFolderToParent(
    FolderModel child,
    Map<String, Object?> rawFolder,
  ) async {
    if (TextUtil.isEmpty(child.objectId)) {
      _log('moveFolderToParent skipped because child objectId is empty');
      return null;
    }
    final parentId = _parentFolderId(rawFolder);
    final parentTitle = _parentFolderTitle(rawFolder);
    FolderModel? parent = _findFolderModelByObjectId(parentId);
    if (parent == null && parentTitle != null) {
      parent = await _ensureFolderContainerByTitle(parentTitle);
    }
    if (parent == null) {
      _log('moveFolderToParent failed parent not found title=$parentTitle');
      return null;
    }
    if (parent.tag != 3) {
      _log(
        'moveFolderToParent failed because parent is not folder container '
        'title=${parent.title} tag=${parent.tag}',
      );
      return null;
    }

    // FolderPage 不在子清单上保存 parentId，而是由 tag=3 文件夹的
    // folderModelObjectIdOrderList 记录子清单 objectId。移动时必须先从所有
    // 旧父文件夹移除，再加入目标文件夹，避免同一个清单出现在多个文件夹下。
    final result = await MongoApisManager.getInstance()
        .updateFolderModelsForFolderObjectId(
      objectId: child.objectId!,
      folderModelForFolder: parent,
    );
    _log(
      'moveFolderToParent child=${child.title}/${child.objectId} '
      'parent=${parent.title}/${parent.objectId}',
    );
    return result;
  }

  MissionModel? _singleRecentDuplicateMission(List<MissionModel> missions) {
    if (missions.isEmpty) {
      return null;
    }
    final first = missions.first;
    final sameEditableIdentity = missions.every(
      (mission) =>
          (mission.title ?? '').trim() == (first.title ?? '').trim() &&
          mission.folder_id == first.folder_id &&
          mission.time_mode == first.time_mode &&
          mission.start_time == first.start_time &&
          mission.end_time == first.end_time &&
          mission.isFinished == first.isFinished,
    );
    if (!sameEditableIdentity) {
      return null;
    }
    final sorted = List<MissionModel>.from(missions)
      ..sort((left, right) =>
          _missionCreatedMillis(right).compareTo(_missionCreatedMillis(left)));
    return sorted.first;
  }

  int _missionCreatedMillis(MissionModel mission) {
    final createdAt = mission.createdAt;
    if (createdAt == null || createdAt.isEmpty) {
      return 0;
    }
    return Utility.getTimestampFromDateTime(createdAt);
  }

  _MissionTargetResolution _resolveSingleMissionTarget(
    Map<String, Object?> raw,
  ) {
    // 标题定位依赖 MongoApisManager 的本地缓存；缓存为空时上层列表页可能还没初始化。
    // 这里保持同步查缓存，缺失时由调用方返回 notFound，避免在更新链路里做宽泛查询误改。
    final objectId = _stringOrNull(raw['objectId']) ??
        _stringOrNull(raw['id']) ??
        _stringOrNull(raw['mission_id']);
    if (objectId != null) {
      final cached = MongoApisManager.getInstance()
          .queryWhereEqual_missionDataByObjectId(objectId: objectId);
      return _MissionTargetResolution(
        cached != null ? <MissionModel>[cached] : <MissionModel>[],
      );
    }
    final title = _missionTitle(raw);
    if (title.isEmpty) {
      return const _MissionTargetResolution(<MissionModel>[]);
    }
    return _MissionTargetResolution(_findMissionModelsByExactTitle(title));
  }

  Future<_FolderTargetResolution> _resolveSingleFolderTarget(
    Map<String, Object?> raw,
  ) async {
    final manager = MongoApisManager.getInstance();
    if (manager.listFolderModels.isEmpty) {
      await manager.queryWhereEqual_folderModel(shouldRefresh: true);
    }
    final objectId = _stringOrNull(raw['objectId']) ??
        _stringOrNull(raw['id']) ??
        _stringOrNull(raw['folder_id']);
    if (objectId != null) {
      final cached = manager.queryfolderModelWithFolderId(objectId);
      return _FolderTargetResolution(
        cached != null ? <FolderModel>[cached] : <FolderModel>[],
      );
    }
    final title = _folderTitle(raw);
    if (title.isEmpty) {
      return const _FolderTargetResolution(<FolderModel>[]);
    }
    return _FolderTargetResolution(
      _findFolderModelsByExactTitle(
        title,
        tag: _intOrNull(raw['lookup_tag'] ?? raw['lookupTag']),
      ),
    );
  }

  void _applyMissionPatch(MissionModel mission, Map<String, Object?> raw) {
    final newTitle = _stringOrNull(raw['new_title']) ??
        _stringOrNull(raw['newTitle']) ??
        _stringOrNull(raw['updatedTitle']);
    if (newTitle != null) {
      mission.title = newTitle;
    } else if (_stringOrNull(raw['objectId']) != null ||
        _stringOrNull(raw['id']) != null ||
        _stringOrNull(raw['mission_id']) != null) {
      final title = _stringOrNull(raw['title']);
      if (title != null) {
        mission.title = title;
      }
    }

    mission.folder_id = _stringOrNull(raw['folder_id']) ??
        _stringOrNull(raw['folderId']) ??
        _folderIdByExactTitle(_stringOrNull(raw['folder_title'])) ??
        mission.folder_id;
    mission.folder_title =
        _stringOrNull(raw['folder_title']) ?? mission.folder_title;
    mission.time_mode = _intOrNull(raw['time_mode']) ?? mission.time_mode;
    mission.dateStatus = _intOrNull(raw['dateStatus'] ?? raw['date_status']) ??
        mission.dateStatus;
    mission.start_time =
        _timeMillisOrNull(raw['start_time'] ?? raw['startTime']) ??
            mission.start_time;
    mission.end_time = _timeMillisOrNull(raw['end_time'] ?? raw['endTime']) ??
        mission.end_time;
    mission.end_time = _normalizeEndOfDayMillis(mission.end_time);
    mission.alert_time =
        _timeMillisOrNull(raw['alert_time']) ?? mission.alert_time;
    final nextIsFinished = _boolOrNull(raw['isFinished'] ??
        raw['is_finished'] ??
        raw['finished'] ??
        raw['completed']);
    if (nextIsFinished != null) {
      if (nextIsFinished == true && mission.isFinished != true) {
        mission.end_time_before_finished ??= mission.end_time;
      }
      mission.isFinished = nextIsFinished;
      if (nextIsFinished == true) {
        mission.finish_time = _timeMillisOrNull(
              raw['finish_time'] ??
                  raw['finishTime'] ??
                  raw['completed_time'] ??
                  raw['completedTime'],
            ) ??
            mission.finish_time ??
            Utility.getTimeStampToday();
      } else {
        mission.finish_time = _timeMillisOrNull(
              raw['finish_time'] ??
                  raw['finishTime'] ??
                  raw['completed_time'] ??
                  raw['completedTime'],
            ) ??
            mission.finish_time;
      }
    }
    mission.finish_time = _timeMillisOrNull(raw['finish_time'] ??
            raw['finishTime'] ??
            raw['completed_time'] ??
            raw['completedTime']) ??
        mission.finish_time;
    mission.end_time_before_finished = _timeMillisOrNull(
            raw['end_time_before_finished'] ?? raw['endTimeBeforeFinished']) ??
        mission.end_time_before_finished;
    mission.time_finished =
        _intOrNull(raw['time_finished'] ?? raw['timeFinished']) ??
            mission.time_finished;
    mission.isDelayed =
        _boolOrNull(raw['isDelayed'] ?? raw['is_delayed']) ?? mission.isDelayed;
    mission.priorityStatus =
        _intOrNull(raw['priorityStatus']) ?? mission.priorityStatus;
    mission.total_tomotoes =
        _intOrNull(raw['total_tomotoes']) ?? mission.total_tomotoes;
    mission.tomato_duration =
        _intOrNull(raw['tomato_duration']) ?? mission.tomato_duration;
    mission.tagNames = _stringListOrString(raw['tagNames']) ?? mission.tagNames;
    mission.tagIds = _stringListOrString(raw['tagIds']) ?? mission.tagIds;
  }

  void _applyFolderPatch(FolderModel folder, Map<String, Object?> raw) {
    final newTitle = _stringOrNull(raw['new_title']) ??
        _stringOrNull(raw['newTitle']) ??
        _stringOrNull(raw['updatedTitle']);
    if (newTitle != null) {
      folder.title = newTitle;
    } else if (_stringOrNull(raw['objectId']) != null ||
        _stringOrNull(raw['id']) != null ||
        _stringOrNull(raw['folder_id']) != null) {
      final title = _stringOrNull(raw['title']);
      if (title != null) {
        folder.title = title;
      }
    }
    folder.description =
        _stringOrNull(raw['description']) ?? folder.description;
    folder.tag = _intOrNull(raw['tag']) ?? folder.tag;
    folder.color = _intOrNull(raw['color']) ?? folder.color;
    folder.tagColor = _intOrNull(raw['tagColor']) ?? folder.tagColor;
    folder.icon = _intOrNull(raw['icon']) ?? folder.icon;
    folder.iconType = _intOrNull(raw['iconType']) ?? folder.iconType;
    folder.layoutType = _intOrNull(raw['layoutType']) ?? folder.layoutType;
    folder.folderStatus =
        _intOrNull(raw['folderStatus']) ?? folder.folderStatus;
    folder.filterType = _intOrNull(raw['filterType']) ?? folder.filterType;
    final folderOrder = _stringListFromAny(raw['folderModelObjectIdOrderList']);
    if (folderOrder.isNotEmpty) {
      folder.folderModelObjectIdOrderList = folderOrder;
    }
    final groupOrder = _stringListFromAny(raw['groupModelObjectIdOrderList']);
    if (groupOrder.isNotEmpty) {
      folder.groupModelObjectIdOrderList = groupOrder;
    }
    folder.update_time = DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, Object?> _normalizeMissionInput(Map<String, Object?> rawMission) {
    final normalized = Map<String, Object?>.from(rawMission);
    final title = _missionTitle(normalized);
    if (title.isNotEmpty) {
      normalized['title'] = title;
    }

    final folderTitle = _stringOrNull(normalized['folder_title']) ??
        _stringOrNull(normalized['folderTitle']) ??
        _stringOrNull(normalized['folderName']) ??
        _stringOrNull(normalized['folder_name']) ??
        _stringOrNull(normalized['listName']) ??
        _stringOrNull(normalized['list_name']) ??
        _stringOrNull(normalized['清单名称']) ??
        _stringOrNull(normalized['清单名']) ??
        _stringOrNull(normalized['文件夹名称']) ??
        _stringOrNull(normalized['文件夹名']);
    if (folderTitle != null) {
      normalized['folder_title'] = folderTitle;
    }

    final dueValue = normalized['due_date'] ??
        normalized['dueDate'] ??
        normalized['deadline'] ??
        normalized['截止时间'] ??
        normalized['截止日期'];
    if (normalized['end_time'] == null && normalized['endTime'] == null) {
      final parsedDueDate = _dateMillisOrNull(dueValue);
      if (parsedDueDate != null) {
        normalized['end_time'] = parsedDueDate.millis;
        normalized['time_mode'] ??= 0;
        if (parsedDueDate.dateStatus != null) {
          normalized['dateStatus'] ??= parsedDueDate.dateStatus;
        }
        _log(
          'normalized due_date=$dueValue -> end_time=${parsedDueDate.millis} '
          'dateStatus=${parsedDueDate.dateStatus}',
        );
      }
    }

    if (normalized['time_mode'] == null && normalized['start_time'] != null) {
      normalized['time_mode'] = 1;
    }
    _log(
        'normalizeMissionInput ${_safeJsonEncode(rawMission)} -> ${_safeJsonEncode(normalized)}');
    return normalized;
  }

  Map<String, Object?> _castMap(Map raw) {
    return raw.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
  }

  int? _timeMillisOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value == 0 ? null : value;
    }
    if (value is num) {
      final intValue = value.toInt();
      return intValue == 0 ? null : intValue;
    }
    final text = value.toString().trim();
    if (text.isEmpty) {
      return null;
    }
    final numericValue = int.tryParse(text);
    if (numericValue != null) {
      return numericValue == 0 ? null : numericValue;
    }
    final parsedDueDate = _dateMillisOrNull(text);
    if (parsedDueDate != null) {
      return parsedDueDate.millis;
    }
    return Utility.getUtcDateTimeToLocalFromString(text).millisecondsSinceEpoch;
  }

  _DateRange? _dateStatusRange(int dateStatus) {
    // dateStatus 查询也统一从 Utility.getTimeStampToday() 派生当天范围。
    final now = DateTime.fromMillisecondsSinceEpoch(
      Utility.getTimeStampToday(),
    );
    final today = DateTime(now.year, now.month, now.day);
    if (dateStatus == 1) {
      return _DateRange(today.millisecondsSinceEpoch,
          today.add(const Duration(days: 1)).millisecondsSinceEpoch);
    }
    if (dateStatus == 2) {
      final tomorrow = today.add(const Duration(days: 1));
      return _DateRange(tomorrow.millisecondsSinceEpoch,
          tomorrow.add(const Duration(days: 1)).millisecondsSinceEpoch);
    }
    if (dateStatus == 3) {
      return _DateRange(today.millisecondsSinceEpoch,
          today.add(const Duration(days: 7)).millisecondsSinceEpoch);
    }
    return null;
  }

  bool _millisInRange(
    int? millis, {
    int? startInclusive,
    int? endExclusive,
  }) {
    if (millis == null || millis == 0) {
      return false;
    }
    if (startInclusive != null && millis < startInclusive) {
      return false;
    }
    if (endExclusive != null && millis >= endExclusive) {
      return false;
    }
    return true;
  }

  bool _missionIntersectsRange(
    MissionModel mission, {
    int? startInclusive,
    int? endExclusive,
  }) {
    final missionStart = mission.start_time;
    final missionEnd = mission.end_time;
    if (missionStart == null ||
        missionStart == 0 ||
        missionEnd == null ||
        missionEnd == 0) {
      return false;
    }
    if (endExclusive != null && missionStart >= endExclusive) {
      return false;
    }
    if (startInclusive != null && missionEnd <= startInclusive) {
      return false;
    }
    return true;
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
  }

  String _formatClock(DateTime dateTime) {
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  String _formatTimezoneOffset(Duration offset) {
    final sign = offset.isNegative ? '-' : '+';
    final absoluteMinutes = offset.inMinutes.abs();
    final hours = absoluteMinutes ~/ 60;
    final minutes = absoluteMinutes % 60;
    return '$sign${_twoDigits(hours)}:${_twoDigits(minutes)}';
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  _ParsedDueDate? _dateMillisOrNull(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    int? offsetDays;
    int? dateStatus;
    if (text.contains('今天') || text.contains('今日')) {
      offsetDays = 0;
      dateStatus = 1;
    } else if (text.contains('明天') || text.contains('明日')) {
      offsetDays = 1;
      dateStatus = 2;
    } else if (text.contains('大后天')) {
      offsetDays = 3;
    } else if (text.contains('后天')) {
      offsetDays = 2;
    } else if (text.contains('下周')) {
      offsetDays = 7;
      dateStatus = 3;
    } else if (text.contains('一周') || text.contains('7天')) {
      offsetDays = 7;
      dateStatus = 3;
    }

    if (offsetDays != null) {
      final date = DateTime(now.year, now.month, now.day)
          .add(Duration(days: offsetDays));
      return _ParsedDueDate(date.millisecondsSinceEpoch, dateStatus);
    }

    final normalizedText = text
        .replaceAll('年', '-')
        .replaceAll('月', '-')
        .replaceAll('日', '')
        .replaceAll('/', '-');
    final parsed = DateTime.tryParse(normalizedText);
    if (parsed != null) {
      return _ParsedDueDate(
        DateTime(parsed.year, parsed.month, parsed.day).millisecondsSinceEpoch,
        null,
      );
    }

    final monthDayMatch =
        RegExp(r'(\d{1,2})-(\d{1,2})').firstMatch(normalizedText);
    if (monthDayMatch != null) {
      final month = int.tryParse(monthDayMatch.group(1) ?? '');
      final day = int.tryParse(monthDayMatch.group(2) ?? '');
      if (month != null && day != null) {
        return _ParsedDueDate(
          DateTime(now.year, month, day).millisecondsSinceEpoch,
          null,
        );
      }
    }
    return null;
  }

  Map<String, Object?> normalizeToolArgs(Map<String, Object?> args) {
    final unwrapped = _unwrapArguments(args);
    final rawDatas = _extractMissionDatas(unwrapped);
    return <String, Object?>{
      'datas': rawDatas.map(_normalizeMissionInput).toList(growable: false),
    };
  }

  Map<String, Object?> normalizeDeleteToolArgs(Map<String, Object?> args) {
    final unwrapped = _unwrapArguments(args);
    final objectIds = <String>[
      ..._stringListFromAny(unwrapped['objectIds']),
      ..._stringListFromAny(unwrapped['ids']),
      ..._stringListFromAny(unwrapped['missionIds']),
      ..._stringListFromAny(unwrapped['mission_ids']),
    ];
    final singleObjectId = _stringOrNull(unwrapped['objectId']) ??
        _stringOrNull(unwrapped['id']) ??
        _stringOrNull(unwrapped['mission_id']);
    if (singleObjectId != null) {
      objectIds.add(singleObjectId);
    }

    final titles = <String>[
      ..._stringListFromAny(unwrapped['exact_titles']),
      ..._stringListFromAny(unwrapped['titles']),
    ];
    final title = _stringOrNull(unwrapped['title']) ??
        _stringOrNull(unwrapped['name']) ??
        _stringOrNull(unwrapped['taskName']) ??
        _stringOrNull(unwrapped['task_name']) ??
        _stringOrNull(unwrapped['missionName']) ??
        _stringOrNull(unwrapped['任务名称']) ??
        _stringOrNull(unwrapped['任务名']) ??
        _stringOrNull(unwrapped['名称']);
    if (title != null) {
      titles.add(title);
    }

    return <String, Object?>{
      if (objectIds.isNotEmpty) 'objectIds': objectIds.toSet().toList(),
      if (titles.isNotEmpty) 'titles': titles.toSet().toList(),
    };
  }

  Map<String, Object?> normalizeFolderToolArgs(Map<String, Object?> args) {
    final unwrapped = _unwrapArguments(args);
    final rawDatas = _extractFolderDatas(unwrapped);
    return <String, Object?>{
      'datas': rawDatas.toList(growable: false),
    };
  }

  Map<String, Object?> normalizeDeleteFolderToolArgs(
    Map<String, Object?> args,
  ) {
    final unwrapped = _unwrapArguments(args);
    final objectIds = _extractObjectIds(
      unwrapped,
      idAliases: const <String>[
        'objectIds',
        'ids',
        'folderIds',
        'folder_ids',
      ],
      singleAliases: const <String>['objectId', 'id', 'folder_id'],
    );
    final titles = _extractTitles(unwrapped);
    return <String, Object?>{
      if (objectIds.isNotEmpty) 'objectIds': objectIds.toList(),
      if (titles.isNotEmpty) 'titles': titles.toList(),
    };
  }

  Map<String, Object?> normalizePassthroughToolArgs(Map<String, Object?> args) {
    return _unwrapArguments(args);
  }

  int? _intOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  double? _doubleOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  String? _stringOrNull(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) {
      return null;
    }
    return text;
  }

  String? _stringListOrString(Object? value) {
    if (value is List) {
      return value.map((item) => item.toString().trim()).where((item) {
        return item.isNotEmpty;
      }).join(',');
    }
    return _stringOrNull(value);
  }

  List<String> _stringListFromAny(Object? value) {
    if (value == null) {
      return const <String>[];
    }
    if (value is List) {
      return value
          .map(_stringOrNull)
          .whereType<String>()
          .toList(growable: false);
    }
    final text = _stringOrNull(value);
    if (text == null) {
      return const <String>[];
    }
    if (!text.contains(',')) {
      return <String>[text];
    }
    return text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  Set<String> _extractObjectIds(
    Map<String, Object?> args, {
    required List<String> idAliases,
    List<String> singleAliases = const <String>['objectId', 'id'],
  }) {
    final objectIds = <String>{};
    for (final alias in idAliases) {
      objectIds.addAll(_stringListFromAny(args[alias]));
    }
    for (final alias in singleAliases) {
      final value = _stringOrNull(args[alias]);
      if (value != null) {
        objectIds.add(value);
      }
    }
    return objectIds;
  }

  Set<String> _extractTitles(Map<String, Object?> args) {
    final titles = <String>{};
    titles.addAll(_stringListFromAny(args['exact_titles']));
    titles.addAll(_stringListFromAny(args['titles']));
    final title = _stringOrNull(args['title']) ??
        _stringOrNull(args['name']) ??
        _stringOrNull(args['folderTitle']) ??
        _stringOrNull(args['folder_title']) ??
        _stringOrNull(args['missionTitle']) ??
        _stringOrNull(args['mission_title']) ??
        _stringOrNull(args['任务名称']) ??
        _stringOrNull(args['任务名']) ??
        _stringOrNull(args['清单名称']) ??
        _stringOrNull(args['文件夹名称']) ??
        _stringOrNull(args['名称']);
    if (title != null) {
      titles.add(title);
    }
    return titles;
  }

  Set<String> _extractMissionTitles(Map<String, Object?> args) {
    final titles = <String>{};
    titles.addAll(_stringListFromAny(args['exact_titles']));
    titles.addAll(_stringListFromAny(args['titles']));
    titles.addAll(_stringListFromAny(args['mission_titles']));
    final title = _stringOrNull(args['title']) ??
        _stringOrNull(args['name']) ??
        _stringOrNull(args['missionTitle']) ??
        _stringOrNull(args['mission_title']) ??
        _stringOrNull(args['taskTitle']) ??
        _stringOrNull(args['task_title']) ??
        _stringOrNull(args['任务名称']) ??
        _stringOrNull(args['任务名']) ??
        _stringOrNull(args['名称']);
    if (title != null) {
      titles.add(title);
    }
    return titles;
  }

  Set<String> _extractMissionTagNames(Map<String, Object?> args) {
    final tagNames = <String>{};
    tagNames.addAll(_stringListFromAny(args['tagNames']));
    tagNames.addAll(_stringListFromAny(args['tag_names']));
    final tagName = _stringOrNull(args['tagName']) ??
        _stringOrNull(args['tag_name']) ??
        _stringOrNull(args['tagTitle']) ??
        _stringOrNull(args['tag_title']) ??
        _stringOrNull(args['标签名称']) ??
        _stringOrNull(args['标签名']) ??
        _stringOrNull(args['标签']);
    if (tagName != null) {
      tagNames.add(tagName);
    }
    return tagNames;
  }

  Set<String> _extractMissionTagIds(Map<String, Object?> args) {
    final tagIds = <String>{};
    tagIds.addAll(_stringListFromAny(args['tagIds']));
    tagIds.addAll(_stringListFromAny(args['tag_ids']));
    final tagId = _stringOrNull(args['tagId']) ??
        _stringOrNull(args['tag_id']) ??
        _stringOrNull(args['标签ID']) ??
        _stringOrNull(args['标签Id']);
    if (tagId != null) {
      tagIds.add(tagId);
    }
    return tagIds;
  }

  bool? _boolOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    final text = value.toString().trim().toLowerCase();
    if (text == 'true' || text == '1' || text == 'yes' || text == '已完成') {
      return true;
    }
    if (text == 'false' || text == '0' || text == 'no' || text == '未完成') {
      return false;
    }
    return null;
  }

  String _createdMissionSummary(List<MissionModel> missions) {
    final buffer = StringBuffer('已创建 ${missions.length} 个任务：');
    for (var index = 0; index < missions.length; index += 1) {
      final mission = missions[index];
      buffer
        ..writeln()
        ..write('${index + 1}. ${mission.title ?? ''}');
      final timeText = mission.isFinished == true
          ? _missionFinishedTimeText(mission)
          : _missionTimeText(mission);
      if (timeText.isNotEmpty) {
        buffer
            .write('，${mission.isFinished == true ? '完成时间' : '时间'}：$timeText');
      }
      if (!TextUtil.isEmpty(mission.folder_title)) {
        buffer.write('，清单：${mission.folder_title}');
      }
      if (!TextUtil.isEmpty(mission.tagNames)) {
        buffer.write('，标签：${mission.tagNames}');
      }
      if (mission.total_tomotoes != null) {
        buffer.write('，番茄数：${mission.total_tomotoes}');
      }
      if (!TextUtil.isEmpty(mission.objectId)) {
        buffer.write('，ID：${mission.objectId}');
      }
    }
    return buffer.toString();
  }

  String _missionListSummary(
    List<MissionModel> missions, {
    FolderModel? folder,
  }) {
    if (missions.isEmpty) {
      if (folder != null) {
        return '清单「${folder.title ?? folder.objectId ?? ''}」下没有找到任务。';
      }
      return '没有找到符合条件的任务。';
    }
    final buffer = StringBuffer();
    if (folder != null) {
      buffer.write(
        '清单「${folder.title ?? folder.objectId ?? ''}」下找到 ${missions.length} 个任务：',
      );
    } else {
      buffer.write('找到 ${missions.length} 个任务：');
    }
    for (var index = 0; index < missions.length; index += 1) {
      final mission = missions[index];
      buffer
        ..writeln()
        ..write('${index + 1}. ${mission.title ?? ''}');
      final timeText = _missionTimeText(mission);
      if (timeText.isNotEmpty) {
        buffer.write('，时间：$timeText');
      }
      if (!TextUtil.isEmpty(mission.objectId)) {
        buffer.write('，ID：${mission.objectId}');
      }
      if (mission.isFinished != null) {
        buffer.write('，状态：${mission.isFinished == true ? '已完成' : '未完成'}');
      }
    }
    return buffer.toString();
  }

  String _missionListFolderFilterError(
    _MissionListFolderResolution resolution,
  ) {
    if (resolution.ambiguous.isNotEmpty) {
      return '找到多个同名清单，无法确定要查询哪一个。请提供清单 ID。${_safeJsonEncode(resolution.ambiguous)}';
    }
    return '没有找到指定清单，已停止查询，避免返回错误任务。${_safeJsonEncode(resolution.notFound)}';
  }

  String _updatedMissionSummary({
    required List<MissionModel> updated,
    required List<Map<String, Object?>> failed,
    required List<Map<String, Object?>> notFound,
    required List<Map<String, Object?>> ambiguous,
  }) {
    final buffer = StringBuffer();
    if (updated.isNotEmpty) {
      buffer.write('已更新 ${updated.length} 个任务：');
      for (var index = 0; index < updated.length; index += 1) {
        final mission = updated[index];
        buffer
          ..writeln()
          ..write('${index + 1}. ${mission.title ?? mission.objectId ?? ''}');
        if (!TextUtil.isEmpty(mission.objectId)) {
          buffer.write('，ID：${mission.objectId}');
        }
      }
    } else {
      buffer.write('没有更新任何任务。');
    }
    if (failed.isNotEmpty) {
      buffer
        ..writeln()
        ..write('更新失败 ${failed.length} 个：${_safeJsonEncode(failed)}');
    }
    if (notFound.isNotEmpty) {
      buffer
        ..writeln()
        ..write('未找到：${_safeJsonEncode(notFound)}');
    }
    if (ambiguous.isNotEmpty) {
      buffer
        ..writeln()
        ..write('同名任务过多，已跳过：${_safeJsonEncode(ambiguous)}');
    }
    return buffer.toString();
  }

  String _missionCreateSummaryWithFolders(
    List<MissionModel> missions,
    List<FolderModel> createdFolders,
  ) {
    final buffer = StringBuffer();
    if (createdFolders.isNotEmpty) {
      buffer.write('已先创建 ${createdFolders.length} 个清单：');
      for (var index = 0; index < createdFolders.length; index += 1) {
        final folder = createdFolders[index];
        if (index > 0) {
          buffer.write('、');
        }
        buffer.write('${folder.title ?? ''}');
        if (!TextUtil.isEmpty(folder.objectId)) {
          buffer.write('（ID：${folder.objectId}）');
        }
      }
      buffer.writeln();
    }
    buffer.write(_createdMissionSummary(missions));
    return buffer.toString();
  }

  String _missionFolderResolutionError(_MissionFolderEnsureResult result) {
    final buffer = StringBuffer('任务创建前需要先确认清单，但清单处理失败，未创建任务。');
    if (result.ambiguous.isNotEmpty) {
      buffer
        ..writeln()
        ..write('找到多条同名清单，请提供清单 ID 或更精确的清单名称：')
        ..write(_safeJsonEncode(result.ambiguous));
    }
    if (result.failed.isNotEmpty) {
      buffer
        ..writeln()
        ..write('清单创建失败：')
        ..write(_safeJsonEncode(result.failed));
    }
    return buffer.toString();
  }

  String _deletedMissionSummary({
    required List<MissionModel> deleted,
    required List<Map<String, Object?>> failed,
    required List<Object?> notFound,
    required List<Object?> ambiguous,
  }) {
    final buffer = StringBuffer();
    if (deleted.isNotEmpty) {
      buffer.write('已删除 ${deleted.length} 个任务：');
      for (var index = 0; index < deleted.length; index += 1) {
        final mission = deleted[index];
        buffer
          ..writeln()
          ..write('${index + 1}. ${mission.title ?? mission.objectId ?? ''}');
        if (!TextUtil.isEmpty(mission.objectId)) {
          buffer.write('，ID：${mission.objectId}');
        }
      }
    } else {
      buffer.write('没有删除任何任务。');
    }

    if (failed.isNotEmpty) {
      buffer
        ..writeln()
        ..write('删除失败 ${failed.length} 个：${_safeJsonEncode(failed)}');
    }
    if (notFound.isNotEmpty) {
      buffer
        ..writeln()
        ..write('未找到：${_safeJsonEncode(notFound)}');
    }
    if (ambiguous.isNotEmpty) {
      buffer
        ..writeln()
        ..write('同名任务过多，已跳过：${_safeJsonEncode(ambiguous)}');
    }
    return buffer.toString();
  }

  String _createdFolderSummary(List<FolderModel> folders) {
    if (folders.isEmpty) {
      return '清单创建失败，请检查登录状态或清单参数。';
    }
    final buffer = StringBuffer('已创建 ${folders.length} 个清单：');
    for (var index = 0; index < folders.length; index += 1) {
      final folder = folders[index];
      buffer
        ..writeln()
        ..write('${index + 1}. ${folder.title ?? ''}');
      buffer.write('，类型：${_folderTagText(folder.tag)}');
      if (!TextUtil.isEmpty(folder.objectId)) {
        buffer.write('，ID：${folder.objectId}');
      }
    }
    return buffer.toString();
  }

  String _folderListSummary(List<FolderModel> folders) {
    if (folders.isEmpty) {
      return '没有找到符合条件的清单。';
    }
    final buffer = StringBuffer('找到 ${folders.length} 个清单：');
    for (var index = 0; index < folders.length; index += 1) {
      final folder = folders[index];
      buffer
        ..writeln()
        ..write('${index + 1}. ${folder.title ?? ''}');
      buffer.write('，类型：${_folderTagText(folder.tag)}');
      if (!TextUtil.isEmpty(folder.objectId)) {
        buffer.write('，ID：${folder.objectId}');
      }
    }
    return buffer.toString();
  }

  String _updatedFolderSummary({
    required List<FolderModel> updated,
    required List<Map<String, Object?>> failed,
    required List<Map<String, Object?>> notFound,
    required List<Map<String, Object?>> ambiguous,
  }) {
    final buffer = StringBuffer();
    if (updated.isNotEmpty) {
      buffer.write('已更新 ${updated.length} 个清单：');
      for (var index = 0; index < updated.length; index += 1) {
        final folder = updated[index];
        buffer
          ..writeln()
          ..write('${index + 1}. ${folder.title ?? folder.objectId ?? ''}');
        if (!TextUtil.isEmpty(folder.objectId)) {
          buffer.write('，ID：${folder.objectId}');
        }
      }
    } else {
      buffer.write('没有更新任何清单。');
    }
    if (failed.isNotEmpty) {
      buffer
        ..writeln()
        ..write('更新失败 ${failed.length} 个：${_safeJsonEncode(failed)}');
    }
    if (notFound.isNotEmpty) {
      buffer
        ..writeln()
        ..write('未找到：${_safeJsonEncode(notFound)}');
    }
    if (ambiguous.isNotEmpty) {
      buffer
        ..writeln()
        ..write('同名清单过多，已跳过：${_safeJsonEncode(ambiguous)}');
    }
    return buffer.toString();
  }

  String _deletedFolderSummary({
    required List<FolderModel> deleted,
    required List<Map<String, Object?>> failed,
    required List<Map<String, Object?>> notFound,
    required List<Map<String, Object?>> ambiguous,
  }) {
    final buffer = StringBuffer();
    if (deleted.isNotEmpty) {
      buffer.write('已删除 ${deleted.length} 个清单：');
      for (var index = 0; index < deleted.length; index += 1) {
        final folder = deleted[index];
        buffer
          ..writeln()
          ..write('${index + 1}. ${folder.title ?? folder.objectId ?? ''}');
        if (!TextUtil.isEmpty(folder.objectId)) {
          buffer.write('，ID：${folder.objectId}');
        }
      }
    } else {
      buffer.write('没有删除任何清单。');
    }
    if (failed.isNotEmpty) {
      buffer
        ..writeln()
        ..write('删除失败 ${failed.length} 个：${_safeJsonEncode(failed)}');
    }
    if (notFound.isNotEmpty) {
      buffer
        ..writeln()
        ..write('未找到：${_safeJsonEncode(notFound)}');
    }
    if (ambiguous.isNotEmpty) {
      buffer
        ..writeln()
        ..write('同名清单过多，已跳过：${_safeJsonEncode(ambiguous)}');
    }
    return buffer.toString();
  }

  Map<String, Object?> _missionDetailMap(MissionModel mission) {
    return <String, Object?>{
      'objectId': mission.objectId,
      'title': mission.title,
      'time_mode': mission.time_mode,
      'start_time': mission.start_time,
      'end_time': mission.end_time,
      'finish_time': mission.finish_time,
      'time': _missionTimeText(mission),
      'finished_time': _missionFinishedTimeText(mission),
      'folder_title': mission.folder_title,
      'folder_id': mission.folder_id,
      'tagNames': mission.tagNames,
      'total_tomotoes': mission.total_tomotoes,
    };
  }

  String _missionFinishedTimeText(MissionModel mission) {
    final millis = mission.finish_time ??
        (mission.isFinished == true ? mission.end_time : null);
    if (millis == null || millis == 0) {
      return '';
    }
    return _formatMillis(millis);
  }

  Map<String, Object?> _folderDetailMap(FolderModel folder) {
    return <String, Object?>{
      'objectId': folder.objectId,
      'title': folder.title,
      'description': folder.description,
      'tag': folder.tag,
      'tagText': _folderTagText(folder.tag),
      'color': folder.color,
      'icon': folder.icon,
      'iconType': folder.iconType,
      'layoutType': folder.layoutType,
      'folderStatus': folder.folderStatus,
      'folderTeamWorkId': folder.folderTeamWorkId,
      'filterType': folder.filterType,
      'folderModelObjectIdOrderList': folder.folderModelObjectIdOrderList,
    };
  }

  Map<String, Object?> _statsDetailMap(StatsModel stats) {
    return <String, Object?>{
      'objectId': stats.objectId,
      'title': stats.title,
      'type': stats.type,
      'category': stats.category,
      'tagNames': stats.tagNames,
      'value': stats.value,
      'duration': stats.duration,
      'begin_time': stats.begin_time,
      'finish_time': stats.finish_time,
      'folder_id': stats.folder_id,
      'mission_id': stats.mission_id,
    };
  }

  Map<String, Object?> _timelineDetailMap(TimelineMissionModel timeline) {
    return <String, Object?>{
      'objectId': timeline.objectId,
      'title': timeline.title,
      'sceneType': timeline.sceneType,
      'eventType': timeline.eventType,
      'timelineMessage': timeline.timelineMessage,
      'message': timeline.message,
      'folder_id': timeline.folder_id,
      'mission_id': timeline.mission_id,
      'end_time': timeline.end_time,
      'time_finished': timeline.time_finished,
      'isFinished': timeline.isFinished,
      'isDelayed': timeline.isDelayed,
    };
  }

  String _statsListSummary(List<StatsModel> stats) {
    if (stats.isEmpty) {
      return '没有找到符合条件的统计记录。';
    }
    final totalDuration = stats.fold<int>(
      0,
      (sum, item) => sum + (item.duration ?? item.value?.toInt() ?? 0),
    );
    final buffer = StringBuffer(
        '找到 ${stats.length} 条统计记录，总时长：${_formatDuration(totalDuration)}：');
    for (var index = 0; index < stats.length; index += 1) {
      final item = stats[index];
      buffer
        ..writeln()
        ..write('${index + 1}. ${item.title ?? ''}');
      if (!TextUtil.isEmpty(item.category)) {
        buffer.write('，分类：${item.category}');
      }
      buffer.write(
          '，时长：${_formatDuration(item.duration ?? item.value?.toInt() ?? 0)}');
    }
    return buffer.toString();
  }

  String _timelineListSummary(
    List<TimelineMissionModel> timelines, {
    String? prefix,
  }) {
    if (timelines.isEmpty) {
      return '没有找到符合条件的时间线记录。';
    }
    final buffer = StringBuffer(prefix ?? '找到 ${timelines.length} 条时间线记录：');
    for (var index = 0; index < timelines.length; index += 1) {
      final item = timelines[index];
      buffer
        ..writeln()
        ..write('${index + 1}. ${item.title ?? item.timelineMessage ?? ''}');
      if (!TextUtil.isEmpty(item.eventType)) {
        buffer.write('，事件：${item.eventType}');
      }
      if (item.end_time != null && item.end_time != 0) {
        buffer.write('，时间：${_formatMillis(item.end_time!)}');
      }
    }
    return buffer.toString();
  }

  String _buildHtmlReport({
    required String title,
    required List<StatsModel> stats,
    required List<TimelineMissionModel> timelines,
  }) {
    final copy = _reportCopy();
    final displayTitle = title == 'TimeHello AI 报表' ? copy.reportTitle : title;
    final totalDuration = stats.fold<int>(
      0,
      (sum, item) => sum + _statsDuration(item),
    );
    final delayedTimelines =
        timelines.where((item) => item.isDelayed == true).toList();
    final unfinishedTimelines =
        timelines.where((item) => item.isFinished != true).toList();
    final completedTimelines =
        timelines.where((item) => item.isFinished == true).toList();
    final statsGroups = _topReportGroups(_buildStatsReportGroups(stats));
    final delayedGroups =
        _topReportGroups(_buildTimelineReportGroups(delayedTimelines));
    final unfinishedGroups =
        _topReportGroups(_buildTimelineReportGroups(unfinishedTimelines));
    final completionRate = timelines.isEmpty
        ? 0
        : (completedTimelines.length * 100 / timelines.length).round();
    final delayedRate = timelines.isEmpty
        ? 0
        : (delayedTimelines.length * 100 / timelines.length).round();
    final statsRows = _reportStatsRows(stats, copy);
    final timelineRows = _reportTimelineRows(timelines, copy);
    final generatedAt = _formatMillis(DateTime.now().millisecondsSinceEpoch);
    return '''
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${_escapeHtml(displayTitle)}</title>
  <style>
    :root {
      --bg: #f7f2ea;
      --surface: #fffdf8;
      --surface-soft: #fbf5ea;
      --panel: #e7e7e5;
      --line: rgba(255, 255, 255, .78);
      --text: #242326;
      --muted: #827b73;
      --orange: #ff7a00;
      --yellow: #ffe186;
      --blue: #5b7cff;
      --border: #eadfce;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      color: var(--text);
      background: var(--bg);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", sans-serif;
    }
    .report {
      width: min(1480px, calc(100vw - 48px));
      margin: 32px auto 44px;
    }
    .header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 24px;
      margin-bottom: 18px;
    }
    h1 {
      margin: 0;
      font-size: 30px;
      letter-spacing: 0;
      line-height: 1.18;
    }
    .subtitle {
      margin-top: 8px;
      color: var(--muted);
      font-size: 14px;
    }
    .stamp {
      min-width: 210px;
      padding: 12px 16px;
      border: 1px solid var(--border);
      border-radius: 8px;
      background: rgba(255, 253, 248, .74);
      color: var(--muted);
      text-align: right;
      font-size: 13px;
      line-height: 1.6;
    }
    .stamp strong {
      display: block;
      color: var(--text);
      font-size: 18px;
      line-height: 1.2;
    }
    .notice {
      margin-bottom: 22px;
      padding: 11px 18px;
      border-radius: 18px;
      color: #fff;
      background: #ffad00;
      font-size: 14px;
      font-weight: 700;
    }
    .overview {
      display: grid;
      grid-template-columns: repeat(4, minmax(150px, 1fr));
      gap: 16px;
      margin-bottom: 26px;
    }
    .metric {
      min-height: 112px;
      padding: 18px 20px;
      background: rgba(255, 253, 248, .82);
      border: 1px solid rgba(234, 223, 206, .86);
      border-radius: 8px;
      box-shadow: 0 10px 28px rgba(77, 58, 37, .04);
    }
    .metric span { display: block; color: var(--muted); font-size: 13px; font-weight: 700; }
    .metric strong { display: block; margin-top: 8px; font-size: 26px; line-height: 1.15; }
    .metric em { display: block; margin-top: 6px; color: var(--muted); font-style: normal; font-size: 12px; }
    .charts { display: grid; gap: 24px; }
    .chartBlock { min-width: 0; }
    .sectionTitle {
      margin: 0 0 12px;
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 16px;
      font-weight: 800;
      color: #5f5a54;
    }
    .sectionTitle::before { content: ""; width: 9px; height: 18px; background: #57595f; }
    .chart {
      display: grid;
      gap: 12px;
      padding: 18px;
      background: rgba(255, 253, 248, .72);
      border: 1px solid rgba(234, 223, 206, .9);
      border-radius: 8px;
      box-shadow: 0 16px 34px rgba(77, 58, 37, .05);
    }
    .row {
      display: grid;
      grid-template-columns: minmax(150px, 260px) minmax(0, 1fr) auto;
      gap: 16px;
      align-items: center;
      min-height: 48px;
      padding: 8px 0;
      border-bottom: 1px solid rgba(234, 223, 206, .62);
    }
    .row:last-child { border-bottom: 0; }
    .labelBox { min-width: 0; }
    .label {
      display: block;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: #292621;
      font-size: 14px;
      font-weight: 800;
    }
    .hint {
      display: block;
      margin-top: 4px;
      color: var(--muted);
      font-size: 12px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .barline {
      position: relative;
      height: 10px;
      min-width: 0;
      border-radius: 999px;
      background: #eee7dc;
      overflow: hidden;
    }
    .bar {
      display: block;
      height: 100%;
      border-radius: inherit;
      background: linear-gradient(90deg, var(--orange), #ffae1a);
      min-width: 4px;
    }
    .value {
      min-width: 88px;
      text-align: right;
      white-space: nowrap;
      font-size: 13px;
      font-weight: 800;
      color: #2b2825;
    }
    .chart.empty {
      min-height: 160px;
      display: grid;
      place-items: center;
      color: #8b8580;
      font-weight: 700;
    }
    details {
      margin-top: 4px;
      background: rgba(255,255,255,.48);
      border: 1px solid rgba(255,255,255,.72);
      border-radius: 8px;
      overflow: hidden;
    }
    summary { cursor: pointer; padding: 14px 16px; font-weight: 800; }
    table { width: 100%; border-collapse: collapse; font-size: 13px; background: #fffaf5; }
    th, td { text-align: left; padding: 10px 12px; border-top: 1px solid #efe7dc; vertical-align: top; }
    th { color: #6f6a64; background: #f4ebdf; font-weight: 800; }
    td { color: #2c2a28; }
    @media (max-width: 980px) {
      .report { width: min(100vw - 28px, 980px); margin-top: 18px; }
      .header { align-items: stretch; flex-direction: column; }
      .stamp { text-align: left; }
      .overview { grid-template-columns: 1fr 1fr; }
      .row { grid-template-columns: minmax(120px, 190px) minmax(0, 1fr) auto; }
    }
    @media (max-width: 640px) {
      .overview { grid-template-columns: 1fr; }
      .row { grid-template-columns: 1fr; gap: 8px; }
      .value { text-align: left; }
      .value { font-size: 12px; }
    }
  </style>
</head>
<body>
  <main class="report">
    <header class="header">
      <div>
        <h1>${_escapeHtml(displayTitle)}</h1>
        <div class="subtitle">${_escapeHtml(copy.subtitle)}</div>
      </div>
      <div class="stamp">
        <span>${_escapeHtml(copy.generatedAt)}</span>
        <strong>$generatedAt</strong>
      </div>
    </header>
    <div class="notice">${_escapeHtml(copy.notice)}</div>
    <section class="overview">
      <div class="metric"><span>${_escapeHtml(copy.totalDuration)}</span><strong>${_formatDuration(totalDuration)}</strong><em>${copy.statsCount(stats.length)}</em></div>
      <div class="metric"><span>${_escapeHtml(copy.completionRate)}</span><strong>$completionRate%</strong><em>${copy.timelineRatio(completedTimelines.length, timelines.length)}</em></div>
      <div class="metric"><span>${_escapeHtml(copy.delayedTasks)}</span><strong>${delayedTimelines.length}</strong><em>${copy.delayedRate(delayedRate)}</em></div>
      <div class="metric"><span>${_escapeHtml(copy.unfinishedPlans)}</span><strong>${unfinishedTimelines.length}</strong><em>${_escapeHtml(copy.needContinue)}</em></div>
    </section>
    <section class="charts">
      <div class="chartBlock">
        <div class="sectionTitle">${_escapeHtml(copy.focusDurationByCategory)}</div>
          ${_buildDurationChart(statsGroups, copy)}
      </div>
      <div class="chartBlock">
        <div class="sectionTitle">${_escapeHtml(copy.delayedTasks)}</div>
          ${_buildCountChart(delayedGroups, copy: copy, emptyText: copy.noDelayedTasks)}
      </div>
      <div class="chartBlock">
        <div class="sectionTitle">${_escapeHtml(copy.unfinishedPlansByCategory)}</div>
          ${_buildCountChart(unfinishedGroups, copy: copy, emptyText: copy.noUnfinishedPlans)}
      </div>
      <details>
        <summary>${_escapeHtml(copy.statsDetails)}</summary>
        <table>
          <thead><tr><th>${_escapeHtml(copy.titleColumn)}</th><th>${_escapeHtml(copy.categoryColumn)}</th><th>${_escapeHtml(copy.typeColumn)}</th><th>${_escapeHtml(copy.durationColumn)}</th><th>${_escapeHtml(copy.startColumn)}</th><th>${_escapeHtml(copy.finishColumn)}</th></tr></thead>
          <tbody>$statsRows</tbody>
        </table>
      </details>
      <details>
        <summary>${_escapeHtml(copy.timelineDetails)}</summary>
        <table>
          <thead><tr><th>${_escapeHtml(copy.titleColumn)}</th><th>${_escapeHtml(copy.sceneColumn)}</th><th>${_escapeHtml(copy.eventColumn)}</th><th>${_escapeHtml(copy.contentColumn)}</th><th>${_escapeHtml(copy.timeColumn)}</th></tr></thead>
          <tbody>$timelineRows</tbody>
        </table>
      </details>
    </section>
  </main>
</body>
</html>
''';
  }

  List<_AiReportGroup> _buildStatsReportGroups(List<StatsModel> stats) {
    final groupMap = <String, _AiReportGroup>{};
    for (final item in stats) {
      final name = _statsReportGroupName(item);
      final group = groupMap.putIfAbsent(name, () => _AiReportGroup(name));
      group.count += 1;
      group.duration += _statsDuration(item);
    }
    return groupMap.values.toList()
      ..sort((left, right) => right.duration.compareTo(left.duration));
  }

  List<_AiReportGroup> _buildTimelineReportGroups(
    List<TimelineMissionModel> timelines,
  ) {
    final groupMap = <String, _AiReportGroup>{};
    for (final item in timelines) {
      final name = _timelineReportGroupName(item);
      final group = groupMap.putIfAbsent(name, () => _AiReportGroup(name));
      group.count += 1;
      if (item.isDelayed == true) {
        group.delayed += 1;
      }
      if (item.isFinished != true) {
        group.unfinished += 1;
      }
    }
    return groupMap.values.toList()
      ..sort((left, right) => right.count.compareTo(left.count));
  }

  List<_AiReportGroup> _topReportGroups(
    List<_AiReportGroup> groups, {
    int limit = 10,
  }) {
    if (groups.length <= limit) {
      return groups;
    }
    return groups.take(limit).toList();
  }

  String _statsReportGroupName(StatsModel item) {
    return _firstNonEmpty(<String?>[
      item.category,
      _firstTagName(item.tagNames),
      item.title,
      item.folder_id,
    ]);
  }

  String _timelineReportGroupName(TimelineMissionModel item) {
    return _firstNonEmpty(<String?>[
      _firstTagName(item.tagNames),
      item.tagName,
      item.title,
      item.timelineMessage,
      item.eventType,
      item.sceneType,
      item.folder_id,
    ]);
  }

  String _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (!TextUtil.isEmpty(value)) {
        return value!.trim();
      }
    }
    return '未分类';
  }

  String? _firstTagName(String? value) {
    if (TextUtil.isEmpty(value)) {
      return null;
    }
    final parts = value!
        .split(RegExp(r'[,，/]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty);
    return parts.isEmpty ? null : parts.first;
  }

  int _statsDuration(StatsModel item) {
    // StatsModel 后台真实字段里 value 是番茄/专注时长；duration 是客户端
    // fromJson 根据 begin/finish 二次计算出来的展示字段，优先用 value 更贴近数据库。
    final value = item.value?.toInt();
    if (value != null && value > 0) {
      return value;
    }
    final duration = item.duration;
    if (duration != null && duration > 0) {
      return duration;
    }
    return 0;
  }

  String _buildDurationChart(List<_AiReportGroup> groups, _AiReportCopy copy) {
    if (groups.isEmpty) {
      return '<div class="chart empty">${_escapeHtml(copy.noStatsDuration)}</div>';
    }
    final maxValue = groups.fold<int>(
      1,
      (max, item) => item.duration > max ? item.duration : max,
    );
    final rows = groups.map((item) {
      final width = (item.duration * 100 / maxValue).clamp(2, 100).round();
      return '''
        <div class="row">
          <div class="labelBox">
            <span class="label">${_escapeHtml(item.title)}</span>
            <span class="hint">${copy.statsCount(item.count)}</span>
          </div>
          <div class="barline"><span class="bar" style="width:$width%"></span></div>
          <span class="value">${_formatDuration(item.duration)}</span>
        </div>
      ''';
    }).join();
    return '<div class="chart">$rows</div>';
  }

  String _buildCountChart(
    List<_AiReportGroup> groups, {
    required _AiReportCopy copy,
    required String emptyText,
  }) {
    if (groups.isEmpty) {
      return '<div class="chart empty">${_escapeHtml(emptyText)}</div>';
    }
    final maxValue =
        groups.fold<int>(1, (max, item) => item.count > max ? item.count : max);
    final rows = groups.map((item) {
      final width = (item.count * 100 / maxValue).clamp(2, 100).round();
      return '''
        <div class="row">
          <div class="labelBox">
            <span class="label">${_escapeHtml(item.title)}</span>
            <span class="hint">${item.delayed > 0 ? copy.delayedCount(item.delayed) : copy.unfinishedCount(item.unfinished)}</span>
          </div>
          <div class="barline"><span class="bar" style="width:$width%"></span></div>
          <span class="value">${copy.taskCount(item.count)}</span>
        </div>
      ''';
    }).join();
    return '<div class="chart">$rows</div>';
  }

  String _reportStatsRows(List<StatsModel> stats, _AiReportCopy copy) {
    if (stats.isEmpty) {
      return '<tr><td colspan="6">${_escapeHtml(copy.noStatsRecords)}</td></tr>';
    }
    return stats.take(50).map((item) {
      return '''
        <tr>
          <td>${_escapeHtml(item.title ?? '')}</td>
          <td>${_escapeHtml(item.category ?? '')}</td>
          <td>${item.type ?? ''}</td>
          <td>${_formatDuration(_statsDuration(item))}</td>
          <td>${_formatReportMillis(item.begin_time)}</td>
          <td>${_formatReportMillis(item.finish_time)}</td>
        </tr>
      ''';
    }).join();
  }

  String _reportTimelineRows(
    List<TimelineMissionModel> timelines,
    _AiReportCopy copy,
  ) {
    if (timelines.isEmpty) {
      return '<tr><td colspan="5">${_escapeHtml(copy.noTimelineRecords)}</td></tr>';
    }
    return timelines.take(50).map((item) {
      return '''
        <tr>
          <td>${_escapeHtml(item.title ?? '')}</td>
          <td>${_escapeHtml(_timelineSceneLabel(item.sceneType, copy))}</td>
          <td>${_escapeHtml(_timelineEventLabel(item.eventType, copy))}</td>
          <td>${_escapeHtml(item.timelineMessage ?? item.message ?? '')}</td>
          <td>${_formatReportMillis(item.end_time)}</td>
        </tr>
      ''';
    }).join();
  }

  String _formatReportMillis(int? millis) {
    if (millis == null || millis <= 0) {
      return '-';
    }
    return _formatMillis(millis);
  }

  String? _extractUrlFromHostPayload(Object? data) {
    if (data is String) {
      return data;
    }
    if (data is Map) {
      for (final key in <String>['url', 'uri', 'href', 'path', 'value']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }

  Uri _uriFromPathOrUrl(String value) {
    final trimmed = value.trim();
    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme) {
      return parsed;
    }
    return Uri.file(trimmed);
  }

  Future<bool> _launchExternalUri(Uri uri) async {
    try {
      _log('openExternalUrl uri=$uri');
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      _log('openExternalUrl result=$opened uri=$uri');
      return opened;
    } catch (error, stackTrace) {
      _log('openExternalUrl failed uri=$uri error=$error',
          error: error, stackTrace: stackTrace);
      return false;
    }
  }

  _AiReportCopy _reportCopy() {
    Locale? locale;
    final context = _context;
    if (context != null && context.mounted) {
      locale = Localizations.maybeLocaleOf(context);
    }
    final languageCode = locale?.languageCode.toLowerCase();
    final isZh = languageCode == null || languageCode.startsWith('zh');
    return isZh ? _AiReportCopy.zh() : _AiReportCopy.en();
  }

  String _timelineSceneLabel(String? value, _AiReportCopy copy) {
    return _localizedEnumLabel(value, copy.sceneLabels);
  }

  String _timelineEventLabel(String? value, _AiReportCopy copy) {
    return _localizedEnumLabel(value, copy.eventLabels);
  }

  String _localizedEnumLabel(String? value, Map<String, String> labels) {
    if (TextUtil.isEmpty(value)) {
      return '-';
    }
    final key = value!.trim();
    return labels[key] ?? _humanizeEnumValue(key);
  }

  String _humanizeEnumValue(String value) {
    final normalized = value.trim().replaceAll(RegExp(r'[_-]+'), ' ');
    if (normalized.isEmpty) {
      return '-';
    }
    return normalized.split(RegExp(r'\s+')).map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word.substring(0, 1).toUpperCase() +
          (word.length == 1 ? '' : word.substring(1));
    }).join(' ');
  }

  String _escapeHtml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _sanitizeFileName(String value) {
    final sanitized = value.replaceAll(RegExp(r'[^\w\u4e00-\u9fa5-]+'), '_');
    return sanitized.isEmpty ? 'timehello_report' : sanitized;
  }

  String _formatDuration(int millis) {
    if (millis <= 0) {
      return '0 分钟';
    }
    final minutes = (millis / 60000).round();
    final hours = minutes ~/ 60;
    final leftMinutes = minutes % 60;
    if (hours <= 0) {
      return '$leftMinutes 分钟';
    }
    if (leftMinutes == 0) {
      return '$hours 小时';
    }
    return '$hours 小时 $leftMinutes 分钟';
  }

  String _folderTagText(int? tag) {
    if (tag == 2) {
      return '标签';
    }
    if (tag == 3) {
      return '清单/文件夹';
    }
    if (tag == 1) {
      return '圆形清单';
    }
    if (tag == 4) {
      return '过滤器';
    }
    if (tag == 5) {
      return '目标模块';
    }
    return '其他';
  }

  String _missionTimeText(MissionModel mission) {
    final start = mission.start_time;
    final end = mission.end_time;
    if (start == null && end == null) {
      return '';
    }
    if (mission.time_mode == 1 && start != null && end != null) {
      return '${_formatMillis(start)} - ${_formatMillis(end)}';
    }
    if (end != null) {
      return _formatMillis(end);
    }
    return _formatMillis(start!);
  }

  String _formatMillis(int millis) {
    if (millis <= 0) {
      return '';
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(millis);
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
        '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }

  void _log(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'TimeHelloAIInterface',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _safeJsonEncode(Object? value) {
    try {
      return jsonEncode(value);
    } catch (error) {
      return value.toString();
    }
  }
}

class _AiReportGroup {
  _AiReportGroup(this.title);

  final String title;
  int count = 0;
  int duration = 0;
  int delayed = 0;
  int unfinished = 0;
}

class _AiReportCopy {
  _AiReportCopy({
    required this.reportTitle,
    required this.subtitle,
    required this.generatedAt,
    required this.notice,
    required this.totalDuration,
    required this.completionRate,
    required this.delayedTasks,
    required this.unfinishedPlans,
    required this.needContinue,
    required this.focusDurationByCategory,
    required this.unfinishedPlansByCategory,
    required this.statsDetails,
    required this.timelineDetails,
    required this.titleColumn,
    required this.categoryColumn,
    required this.typeColumn,
    required this.durationColumn,
    required this.startColumn,
    required this.finishColumn,
    required this.sceneColumn,
    required this.eventColumn,
    required this.contentColumn,
    required this.timeColumn,
    required this.noStatsDuration,
    required this.noDelayedTasks,
    required this.noUnfinishedPlans,
    required this.noStatsRecords,
    required this.noTimelineRecords,
    required this.sceneLabels,
    required this.eventLabels,
    required this.statsCount,
    required this.timelineRatio,
    required this.delayedRate,
    required this.delayedCount,
    required this.unfinishedCount,
    required this.taskCount,
  });

  factory _AiReportCopy.zh() {
    return _AiReportCopy(
      reportTitle: 'TimeHello AI 报表',
      subtitle: '基于 TimeHello 统计记录与时间线生成，用于快速复盘专注、延期和完成情况。',
      generatedAt: '生成时间',
      notice: '本地生成报表，仅保留和复盘相关的数据视图。',
      totalDuration: '统计总时长',
      completionRate: '完成率',
      delayedTasks: '延期任务',
      unfinishedPlans: '未完成计划',
      needContinue: '需要继续推进',
      focusDurationByCategory: '专注时长分类',
      unfinishedPlansByCategory: '未完成计划分类',
      statsDetails: '统计明细（前 50 条）',
      timelineDetails: '时间线明细（前 50 条）',
      titleColumn: '标题',
      categoryColumn: '分类',
      typeColumn: '类型',
      durationColumn: '时长',
      startColumn: '开始',
      finishColumn: '完成',
      sceneColumn: '场景',
      eventColumn: '事件',
      contentColumn: '内容',
      timeColumn: '时间',
      noStatsDuration: '没有找到统计时长记录',
      noDelayedTasks: '没有找到延期任务记录',
      noUnfinishedPlans: '没有找到未完成计划记录',
      noStatsRecords: '没有统计记录',
      noTimelineRecords: '没有时间线记录',
      sceneLabels: const <String, String>{
        'mission': '任务',
        'transaction': '消费',
        'system': '系统',
        'RegisterPage': '注册',
      },
      eventLabels: const <String, String>{
        'create_mission': '创建任务',
        'batch_update_mission': '批量更新任务',
        'batch_delete_mission': '批量删除任务',
        'update_mission': '更新任务',
        'copy_mission': '复制任务',
        'realize_mission': '完成目标任务',
        'start_focusing_mission': '开始专注任务',
        'stop_focusing_mission': '停止专注任务',
        'create_flomo_mission': '创建打卡任务',
        'clockin_time': '打卡',
        'create_folder_model': '创建清单',
        'create_tag': '创建标签',
        'spend_money_manually': '手动记账',
        'spend_money_buy_present': '购买礼物',
        'request_error': '请求错误',
        'request_error_mongodb_error_get': 'MongoDB 查询错误',
        'request_error_mongodb_error_post': 'MongoDB 创建错误',
        'request_error_mongodb_error_delete': 'MongoDB 删除错误',
        'request_error_mongodb_error_put': 'MongoDB 更新错误',
      },
      statsCount: (count) => '$count 条统计记录',
      timelineRatio: (finished, total) => '$finished/$total 条时间线',
      delayedRate: (rate) => '延期占比 $rate%',
      delayedCount: (count) => '延期 $count 条',
      unfinishedCount: (count) => '未完成 $count 条',
      taskCount: (count) => '$count 个任务',
    );
  }

  factory _AiReportCopy.en() {
    return _AiReportCopy(
      reportTitle: 'TimeHello AI Report',
      subtitle:
          'Generated from TimeHello stats and timeline records for reviewing focus, delays, and completion.',
      generatedAt: 'Generated',
      notice: 'Local report. Only review-related data views are included.',
      totalDuration: 'Total focus time',
      completionRate: 'Completion rate',
      delayedTasks: 'Delayed tasks',
      unfinishedPlans: 'Unfinished plans',
      needContinue: 'Needs follow-up',
      focusDurationByCategory: 'Focus time by category',
      unfinishedPlansByCategory: 'Unfinished plans by category',
      statsDetails: 'Stats details (first 50)',
      timelineDetails: 'Timeline details (first 50)',
      titleColumn: 'Title',
      categoryColumn: 'Category',
      typeColumn: 'Type',
      durationColumn: 'Duration',
      startColumn: 'Start',
      finishColumn: 'Finish',
      sceneColumn: 'Scene',
      eventColumn: 'Event',
      contentColumn: 'Content',
      timeColumn: 'Time',
      noStatsDuration: 'No focus duration records found',
      noDelayedTasks: 'No delayed task records found',
      noUnfinishedPlans: 'No unfinished plan records found',
      noStatsRecords: 'No stats records',
      noTimelineRecords: 'No timeline records',
      sceneLabels: const <String, String>{
        'mission': 'Task',
        'transaction': 'Transaction',
        'system': 'System',
        'RegisterPage': 'Registration',
      },
      eventLabels: const <String, String>{
        'create_mission': 'Create task',
        'batch_update_mission': 'Batch update tasks',
        'batch_delete_mission': 'Batch delete tasks',
        'update_mission': 'Update task',
        'copy_mission': 'Copy task',
        'realize_mission': 'Complete objective task',
        'start_focusing_mission': 'Start focus',
        'stop_focusing_mission': 'Stop focus',
        'create_flomo_mission': 'Create habit task',
        'clockin_time': 'Check in',
        'create_folder_model': 'Create list',
        'create_tag': 'Create tag',
        'spend_money_manually': 'Manual expense',
        'spend_money_buy_present': 'Gift purchase',
        'request_error': 'Request error',
        'request_error_mongodb_error_get': 'MongoDB query error',
        'request_error_mongodb_error_post': 'MongoDB create error',
        'request_error_mongodb_error_delete': 'MongoDB delete error',
        'request_error_mongodb_error_put': 'MongoDB update error',
      },
      statsCount: (count) => '$count stats records',
      timelineRatio: (finished, total) => '$finished/$total timeline records',
      delayedRate: (rate) => 'Delayed $rate%',
      delayedCount: (count) => '$count delayed',
      unfinishedCount: (count) => '$count unfinished',
      taskCount: (count) => '$count tasks',
    );
  }

  final String reportTitle;
  final String subtitle;
  final String generatedAt;
  final String notice;
  final String totalDuration;
  final String completionRate;
  final String delayedTasks;
  final String unfinishedPlans;
  final String needContinue;
  final String focusDurationByCategory;
  final String unfinishedPlansByCategory;
  final String statsDetails;
  final String timelineDetails;
  final String titleColumn;
  final String categoryColumn;
  final String typeColumn;
  final String durationColumn;
  final String startColumn;
  final String finishColumn;
  final String sceneColumn;
  final String eventColumn;
  final String contentColumn;
  final String timeColumn;
  final String noStatsDuration;
  final String noDelayedTasks;
  final String noUnfinishedPlans;
  final String noStatsRecords;
  final String noTimelineRecords;
  final Map<String, String> sceneLabels;
  final Map<String, String> eventLabels;
  final String Function(int count) statsCount;
  final String Function(int finished, int total) timelineRatio;
  final String Function(int rate) delayedRate;
  final String Function(int count) delayedCount;
  final String Function(int count) unfinishedCount;
  final String Function(int count) taskCount;
}

class _ParsedDueDate {
  const _ParsedDueDate(this.millis, this.dateStatus);

  final int millis;
  final int? dateStatus;
}

class _DateRange {
  const _DateRange(this.start, this.endExclusive);

  final int start;
  final int endExclusive;
}

class _MissionTargetResolution {
  const _MissionTargetResolution(this.resolved);

  final List<MissionModel> resolved;
}

class _FolderTargetResolution {
  const _FolderTargetResolution(this.resolved);

  final List<FolderModel> resolved;
}

class _MissionListFolderResolution {
  const _MissionListFolderResolution({
    this.folderId,
    this.folder,
    this.notFound = const <Map<String, Object?>>[],
    this.ambiguous = const <Map<String, Object?>>[],
  });

  final String? folderId;
  final FolderModel? folder;
  final List<Map<String, Object?>> notFound;
  final List<Map<String, Object?>> ambiguous;
}

class _FolderDeleteResolution {
  const _FolderDeleteResolution({
    required this.resolved,
    required this.notFound,
    required this.ambiguous,
  });

  final List<FolderModel> resolved;
  final List<Map<String, Object?>> notFound;
  final List<Map<String, Object?>> ambiguous;
}

class _MissionFolderEnsureResult {
  const _MissionFolderEnsureResult({
    this.created = const <FolderModel>[],
    this.failed = const <Map<String, Object?>>[],
    this.ambiguous = const <Map<String, Object?>>[],
  });

  final List<FolderModel> created;
  final List<Map<String, Object?>> failed;
  final List<Map<String, Object?>> ambiguous;
}

class _AIInterfaceHostAdapter extends HostAdapter {
  const _AIInterfaceHostAdapter(this.manager);

  final AIInterfaceManager manager;

  @override
  bool canHandle(String messageType) {
    return messageType == 'tools/call' ||
        messageType == 'tools/preprocessArgs' ||
        messageType == 'tools/evaluatePolicy' ||
        messageType == 'openUrl' ||
        messageType == 'controlPlane/openUrl';
  }

  @override
  Future<Object?> handle(ContinueMessage message) async {
    switch (message.messageType) {
      case 'tools/call':
        return _handleToolCall(message.data);
      case 'tools/preprocessArgs':
        return _handlePreprocessArgs(message.data);
      case 'tools/evaluatePolicy':
        final data = message.data;
        final basePolicy = data is Map ? data['basePolicy'] : null;
        return <String, Object?>{'policy': basePolicy, 'displayValue': null};
      case 'openUrl':
      case 'controlPlane/openUrl':
        return manager.openExternalUrl(message.data);
    }
    throw UnsupportedError(
        'Unsupported AI interface route: ${message.messageType}');
  }

  Future<Object?> _handleToolCall(Object? data) async {
    _log('tools/call data=${_safeJsonEncode(data)}');
    if (data is! Map) {
      _log('tools/call invalid data type=${data.runtimeType}');
      return _unsupportedToolResult(
          'invalid_data', 'tools/call requires a map payload.');
    }

    final payload = data.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
    final toolName = _extractToolName(payload);
    _log(
        'tools/call extractedToolName=$toolName payload=${_safeJsonEncode(payload)}');
    if (toolName == null ||
        !AIInterfaceManager._supportedToolNames.contains(toolName)) {
      _log('tools/call unsupported toolName=$toolName');
      return _unsupportedToolResult(
        'unsupported_tool',
        'Unsupported tool: ${toolName ?? 'unknown'}',
      );
    }

    try {
      final result = await manager.callTool(toolName, payload);
      return <String, Object?>{
        'contextItems': result['contextItems'] ??
            <Object?>[
              <String, Object?>{
                'content': jsonEncode(result),
                'name': 'TimeHello Tool Result',
                'description': toolName,
              },
            ],
      };
    } catch (error, stackTrace) {
      _log('tools/call failed: $error', error: error, stackTrace: stackTrace);
      return _unsupportedToolResult('tool_error', error.toString());
    }
  }

  Object? _handlePreprocessArgs(Object? data) {
    _log('tools/preprocessArgs data=${_safeJsonEncode(data)}');
    if (data is! Map) {
      return <String, Object?>{'preprocessedArgs': null};
    }
    final payload = data.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
    final toolName = payload['toolName']?.toString();
    if (toolName == null ||
        !AIInterfaceManager._supportedToolNames.contains(toolName)) {
      return <String, Object?>{'preprocessedArgs': null};
    }
    final rawArgs = payload['args'];
    if (rawArgs is! Map) {
      return <String, Object?>{'preprocessedArgs': null};
    }
    final args = rawArgs.map<String, Object?>(
      (key, value) => MapEntry<String, Object?>(key.toString(), value),
    );
    final normalizedArgs = _preprocessArgsForTool(toolName, args);
    _log('tools/preprocessArgs normalized=${_safeJsonEncode(normalizedArgs)}');
    return <String, Object?>{'preprocessedArgs': normalizedArgs};
  }

  Map<String, Object?> _preprocessArgsForTool(
    String toolName,
    Map<String, Object?> args,
  ) {
    if (toolName == AIInterfaceManager.deleteMissionToolName ||
        toolName == AIInterfaceManager.batchDeleteMissionsToolName) {
      return manager.normalizeDeleteToolArgs(args);
    }
    if (toolName == AIInterfaceManager.createMissionsToolName ||
        toolName == AIInterfaceManager.batchCreateMissionsToolName) {
      return manager.normalizeToolArgs(args);
    }
    if (toolName == AIInterfaceManager.deleteFolderToolName ||
        toolName == AIInterfaceManager.batchDeleteFoldersToolName) {
      return manager.normalizeDeleteFolderToolArgs(args);
    }
    if (toolName == AIInterfaceManager.createFoldersToolName ||
        toolName == AIInterfaceManager.batchCreateFoldersToolName ||
        toolName == AIInterfaceManager.updateFoldersToolName) {
      return manager.normalizeFolderToolArgs(args);
    }
    return manager.normalizePassthroughToolArgs(args);
  }

  String? _extractToolName(Map<String, Object?> payload) {
    final directName = payload['name'] ?? payload['toolName'];
    if (directName is String && directName.trim().isNotEmpty) {
      return directName.trim();
    }

    final toolCall = payload['toolCall'];
    if (toolCall is Map) {
      final function = toolCall['function'];
      if (function is Map && function['name'] is String) {
        return (function['name'] as String).trim();
      }
      if (toolCall['name'] is String) {
        return (toolCall['name'] as String).trim();
      }
    }

    final function = payload['function'];
    if (function is Map && function['name'] is String) {
      return (function['name'] as String).trim();
    }
    return null;
  }

  Map<String, Object?> _unsupportedToolResult(String code, String message) {
    _log('tools/call result errorCode=$code message=$message');
    return <String, Object?>{
      'contextItems': <Object?>[
        <String, Object?>{
          'content': jsonEncode(<String, Object?>{
            'ok': false,
            'errorCode': code,
            'message': message,
          }),
          'name': 'TimeHello Tool Error',
          'description': code,
        },
      ],
    };
  }

  void _log(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'TimeHelloAIInterface',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _safeJsonEncode(Object? value) {
    try {
      return jsonEncode(value);
    } catch (error) {
      return value.toString();
    }
  }
}
