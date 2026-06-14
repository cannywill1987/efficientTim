/**
 * 文件类型：页面
 * 文件作用：展示时间轴主页面，支持按清单标签、时间轴类型和搜索关键词筛选记录。
 * 主要职责：负责时间轴数据查询、筛选条件同步、记录入口跳转，以及桌面端和移动端的页面布局编排。
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/page/RichEditor/ReadOnlyPage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/provider/Env.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/BaseWidget.dart';
import '../../components/CircleWidget.dart';
import '../../components/CommonCalendarHeaderWidget.dart';
import '../../components/TransparentOverlayPage.dart';
import '../../config/Params.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/EventFn.dart';
import '../../models/FolderModel.dart';
import '../../models/MissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';
import '../../util/Utility.dart';
import '../../components/SearchBarWidget.dart';
import '../RecorderPage/RecordPage2.dart';
import '../RichEditor/RichEditorPage.dart';
import '../createFolderPage/CreateFolderPage.dart';
import 'components/TimeLineTagsGridViewWidget.dart';
import 'components/TimelineButtonListWidget.dart';
import 'components/TimelineListView.dart';

class TimeLinePage extends BaseWidget {
  final int timelinePageFromEnum;
  final bool shouldShowNav;
  final String folderObjectId;
  final String missionObjectId;

  const TimeLinePage(
      {required Key key,
      required this.timelinePageFromEnum,
      this.shouldShowNav = false,
      this.missionObjectId = "",
      this.folderObjectId = ""})
      : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    return TimeLinePageState();
  }
}

class TimeLinePageState extends BaseWidgetState<TimeLinePage> {
  List<TimelineMissionModel> missionListOriginal = []; //原始数据
  List<TimelineMissionModel> missionListForView = []; //原始数据

  PickerDateRange? dateTimePickerDateRange;
  CommonCalendarHeaderWidgetController? controller;

  FolderModel? curSearchingFocusModel;
  TimelineModeEnum timelineModeEnum = TimelineModeEnum.event;
  List<TimelineMissionModel>? list;
  List<FolderModel> folderModelTags = [];
  GlobalKey<SearchBarWidgetState>? searchBarWidgetKey = GlobalKey();

  // BuildContext? mContext;
  String curSearchWords = "";

  /**
   * 功能：初始化时间轴页面状态，并立即拉取时间轴数据和清单标签。
   * 说明：页面入口需要先创建日历控制器，再根据当前来源决定是否展示导航栏。
   */
  @override
  void initState() {
    super.initState();
    // color = Colors.transparent;
    controller = CommonCalendarHeaderWidgetController();
    this.isAppBarVisible = this.widget.shouldShowNav;

    this.requestDatas();
    this.requestGetTags();
  }

  /**
   * 功能：注册全局列表刷新事件。
   * 说明：其他页面修改任务或时间轴记录后，通过事件总线触发当前页面重新查询。
   */
  componentDidMount() {
    // if (this.widget.timelinePageFromEnum == TimelinePageFromEnum.normal) {
    eventBus.on<EventFn>().listen((EventFn event) {
      if (event.type == Params.ACTION_UPDATE_LISTVIEW) {
        this.requestDatas();
      }
    });
    // }
  }

  // requestDatasWithTime(
  //     {required DateTime startDateTime, required DateTime endDateTime}) async {
  //   list = context.watch<GlobalStateEnv>().listTimelineMissionModel;
  //   if (controller?.dateTimePicker != null)
  //     await requestDatas(
  //         startDateTime: startDateTime, endDateTime: endDateTime);
  // }

  /**
   * 功能：把当前时间轴模式转换成查询层需要的 scene 参数。
   * 返回：全部模式返回 null，其余模式返回数据库里约定的 scene 字符串。
   */
  String? getScene() {
    String? scene = '';
    if (timelineModeEnum == TimelineModeEnum.all) {
      scene = null;
    } else if (timelineModeEnum == TimelineModeEnum.event) {
      scene = "mission";
    } else if (timelineModeEnum == TimelineModeEnum.diary) {
      scene = "diary";
    } else if (timelineModeEnum == TimelineModeEnum.note) {
      scene = "note";
    } else if (timelineModeEnum == TimelineModeEnum.transaction) {
      scene = "transaction";
    }
    return scene;
  }

  requestDatasWithObjectiveId(
      {String? message,
      DateTime? startDateTime,
      DateTime? endDateTime,
      shouldUpdateUI = true}) {
    // String? folderId = this.curSearchingFocusModel?.objectId;
    // if (this.widget.timelinePageFromEnum ==
    //     TimelinePageFromEnum.FolderStatisticPage.index) {
    //   folderId = this.widget.folderObjectId;
    // }
    missionListOriginal = MongoApisManager.getInstance()
        .queryWhereEqual_timelineMissionModelsByEndTime(
      missionId: this.widget.missionObjectId,
      fid: this.widget.folderObjectId,
      scene: getScene(),
      start_endTime: startDateTime?.millisecondsSinceEpoch ??
          controller?.dateTimePicker?.startDate?.millisecondsSinceEpoch,
      end_endTime: endDateTime?.millisecondsSinceEpoch ??
          controller?.dateTimePicker?.endDate?.millisecondsSinceEpoch,
    );
    List missionListForViewFilteredd = Utility.filterTimelineMissionModel(
        this.curSearchWords, this.missionListOriginal);
    this.missionListForView = Utility.sortByCreatedTime(
        missionListForViewFilteredd,
        sortEnum: SortEnum.ascendant);

    if (mounted && shouldUpdateUI) {
      updateUI();
    }
  }

  /**
   * 功能：根据当前页面来源、清单标签、任务 ID、时间范围和搜索词重建时间轴列表。
   * 说明：这里保持查询和本地过滤集中在同一个入口，避免标签切换、搜索和类型切换后列表状态不同步。
   */
  requestDatas(
      {String? message,
      DateTime? startDateTime,
      DateTime? endDateTime,
      shouldUpdateUI = true}) {
    String? folderId = this.curSearchingFocusModel?.objectId;
    String? missionId = this.widget.missionObjectId;
    if (this.widget.timelinePageFromEnum ==
        TimelinePageFromEnum.FolderStatisticPage.index) {
      folderId = this.widget.folderObjectId;
    }
    if (this.widget.timelinePageFromEnum ==
        TimelinePageFromEnum.ObjectivePage.index) {
      folderId = this.widget.folderObjectId;
    }
    missionListOriginal = MongoApisManager.getInstance()
        .queryWhereEqual_timelineMissionModelsByEndTime(
      fid: folderId,
      missionId: missionId,
      scene: getScene(),
      start_endTime: startDateTime?.millisecondsSinceEpoch ??
          controller?.dateTimePicker?.startDate?.millisecondsSinceEpoch,
      end_endTime: endDateTime?.millisecondsSinceEpoch ??
          controller?.dateTimePicker?.endDate?.millisecondsSinceEpoch,
    );
    List missionListForViewFilteredd = Utility.filterTimelineMissionModel(
        this.curSearchWords, this.missionListOriginal);
    this.missionListForView = Utility.sortByCreatedTime(
        missionListForViewFilteredd,
        sortEnum: SortEnum.ascendant);

    if (mounted && shouldUpdateUI) {
      updateUI();
    }
  }

  @override
  void didUpdateWidget(TimeLinePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    //todo 这里可以优化 否则会请求几遍 但是通过 this._folderModelObjId == this.widget.folderModel?.objectId有点问题
    // this.requestDatas();
    // context.watch();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickSearch':
        this.onClickSearch(data);
        break;
      case 'onClickSegmentControl':
        this.onClickSegmentControl(data);
        break;
      case 'onRefreshListener':
        this.onRefreshListener(data);
        break;
    }
  }

  void onRefreshListener(MissionModel missionMdeo) {
    requestDatas();
  }

  void onClickSegmentControl(index) {
    // switch (index) {
    //   case 0:fr
    //     this.calendarTypeEnum = CalendarTypeEnum.day;
    //     break;
    //   case 1:
    //     this.calendarTypeEnum = CalendarTypeEnum.month;
    //     break;
    //   case 2:
    //     this.calendarTypeEnum = CalendarTypeEnum.year;
    //     break;
    //   case 3:
    //     this.calendarTypeEnum = CalendarTypeEnum.all;
    //     break;
    //   case 4:
    //     this.calendarTypeEnum = CalendarTypeEnum.custom;
    //     break;
    // }
    requestDatas();
    // updateUI();
  }

  requestGetTags() {
    List<FolderModel> list = [];
    FolderModel folderModel = FolderModel();
    folderModel.title = getI18NKey().all;
    folderModel.color = Colors.lightGreen.toARGB32();
    folderModel.objectId = "-1"; //代表所有
    list.add(folderModel);
    list.addAll(
        MongoApisManager.getInstance().queryWhereEqual_folderModelWithCircle());

    this.folderModelTags = list;
    // this.updateUI();
  }

  Future onClickInsertEvent() async {
    DialogManagement.getInstance().showEditTitleDialog(
        Utility.getGlobalContext(),
        title: getI18NKey().insert_event,
        initVal: "", okCallBack: (String value) async {
      if (value.isEmpty) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().content_cannot_be_empty);
        return;
      }
      MongoDbSaved? res = await MongoApisManager.getInstance()
          .insertTimelineMissionModel(
              missionModel: Utility.getTimelineMissionModelFromMissionModel(
                  icon: Icons.event.codePoint,
                  color: Colors.lime.toARGB32(),
                  sceneType: "mission",
                  eventType: "insert_manually",
                  timelineMessage: value));
      if (res != null) {
        Utility.showToastMsg(
            context: context, msg: getI18NKey().insert_success);
        DialogManagement.getInstance().hideDialog(context);
      }
    }, cancelCallBack: () {
      DialogManagement.getInstance().hideDialog(context);
    });
  }

  void onClickSearch(wordSearch) {
    // if (TextUtil.isEmpty(wordSearch) == false) {
    // missionListForView =
    //     Utility.filterMissionModel(wordSearch, missionListOriginal);
    //   updateUI();
    // } else {
    this.curSearchWords = wordSearch;
    this.requestDatas();
    // }
  }

  /**
   * 功能：根据当前时间轴类型构建右下角新增入口。
   * 说明：事件模式直接新建事件；笔记和日记模式提供语音与文字两种新增方式。
   */
  Widget getPopupMenu() {
    //事件页面 不需要popup
    if (this.timelineModeEnum == TimelineModeEnum.event) {
      return CircleWidget(
        onTapListener: (e) {
          this.onClickInsertEvent();
        },
        color: Color(CONSTANTS.getTimelineColorBySceneWithTimelineModeEnum(
            timelineModeEnum: timelineModeEnum)),
      );
    } else {
      //笔记 日记需要
      return PopupMenuButton<String>(
        tooltip: '',
        offset: Offset(-30, -110),
        position: PopupMenuPosition.over,
        child: CircleWidget(
          color: Color(CONSTANTS.getTimelineColorBySceneWithTimelineModeEnum(
              timelineModeEnum: timelineModeEnum)),
        ),
        onSelected: (String val) {
          this.updateUI();
        },
        itemBuilder: (context) {
          // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'voice',
              onTap: () {
                // Navigator.of(context).pop();
                if (LoginManager.isLogin() == false) {
                  LoginManager.getInstance().doAliSdkSecVerifyLogin(context);
                }
                if (Utility.isHandsetBySize() == true) {
                  if (this.timelineModeEnum == TimelineModeEnum.diary) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Utility.pushNavigator(
                          context,
                          const RecordPage2(
                            richTextModeEnum: RichTextModeEnum.diary,
                            shouldShowTitle: null,
                            onSubmit: null,
                          ));
                    });
                  } else if (this.timelineModeEnum == TimelineModeEnum.note) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Utility.pushNavigator(
                          context,
                          const RecordPage2(
                            richTextModeEnum: RichTextModeEnum.note,
                            shouldShowTitle: null,
                            onSubmit: null,
                          ));
                    });
                  }
                } else {
                  if (this.timelineModeEnum == TimelineModeEnum.diary) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      DialogManagement.getInstance().showPCCustomDialog(
                          context: context,
                          widget: const RecordPage2(
                            richTextModeEnum: RichTextModeEnum.diary,
                            shouldShowTitle: null,
                            onSubmit: null,
                          ));
                    });
                  } else if (this.timelineModeEnum == TimelineModeEnum.note) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      DialogManagement.getInstance().showPCCustomDialog(
                          context: context,
                          widget: const RecordPage2(
                            richTextModeEnum: RichTextModeEnum.note,
                            shouldShowTitle: null,
                            onSubmit: null,
                          ));
                    });
                  }
                }
              },
              child: Text(getI18NKey().voice, style: TextStyle(fontSize: 13)),
            ),
            PopupMenuItem<String>(
              value: 'write',
              onTap: () {
                if (LoginManager.isLogin() == false) {
                  LoginManager.getInstance().doAliSdkSecVerifyLogin(context);
                }
                if (this.timelineModeEnum == TimelineModeEnum.event) {
                  this.onClickInsertEvent();
                }
                if (Utility.isHandsetBySize() == true) {
                  if (this.timelineModeEnum == TimelineModeEnum.diary) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Utility.pushNavigator(
                          context,
                          RichEditorPage(
                              richTextModeEnum: RichTextModeEnum.diary));
                    });
                  } else if (this.timelineModeEnum == TimelineModeEnum.note) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Utility.pushNavigator(
                          context,
                          RichEditorPage(
                              richTextModeEnum: RichTextModeEnum.note));
                    });
                  }
                } else {
                  if (this.timelineModeEnum == TimelineModeEnum.diary) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      DialogManagement.getInstance().showPCCustomDialog(
                          context: context,
                          widget: RichEditorPage(
                              richTextModeEnum: RichTextModeEnum.diary));
                    });
                  } else if (this.timelineModeEnum == TimelineModeEnum.note) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      DialogManagement.getInstance().showPCCustomDialog(
                          context: context,
                          widget: RichEditorPage(
                              richTextModeEnum: RichTextModeEnum.note));
                    });
                  }
                }
              },
              child: Text(
                getI18NKey().type,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ];
        },
      );
    }
  }

  /**
   * 功能：构建页面主体并处理 VIP 遮罩逻辑。
   * 说明：数据由 GlobalStateEnv 驱动刷新，非普通入口不受当前 VIP 遮罩限制。
   */
  @override
  Widget baseBuild(BuildContext context) {
    context.watch<GlobalStateEnv>().listTimelineMissionModel;
    requestGetTags();
    return Selector<GlobalStateEnv, List<TimelineMissionModel>>(
        selector: (_, env) => env.listTimelineMissionModel,
        builder: (_, listTimeline, __) {
          requestDatas(shouldUpdateUI: false);
          return Selector<Env, bool>(
              selector: (_, env) => env.isVip,
              builder: (_, settingModel, __) {
                if (LoginManager.getInstance().isVIP(
                        shouldShowDialog: false,
                        paymentPromotionAdsModeEnum:
                            PaymentPromotionAdsModeEnum.Calendar) ||
                    TimelinePageFromEnum.normal.index !=
                        this.widget.timelinePageFromEnum)
                  return getChild(context);
                else
                  return Stack(
                    children: [
                      getChild(context),
                      Column(
                        children: [
                          Expanded(child: Container(
                            child: TransparentOverlayPage(
                              onTapCallback: () {
                                LoginManager.getInstance().isVIP(
                                    shouldShowDialog: true,
                                    paymentPromotionAdsModeEnum:
                                        PaymentPromotionAdsModeEnum.TimeLine);
                              },
                            ),
                          )),
                        ],
                      )
                    ],
                  );
              });
        });
  }

  /**
   * 功能：构建时间轴实际内容区。
   * 说明：顶部搜索和标签筛选固定在列表上方，底部类型切换与新增按钮悬浮在列表之上。
   */
  Container getChild(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    final Color pageBg = ThemeManager.getInstance().getBackgroundColor(
      context: context,
      defaultColor: const Color(0xfff7f3ed),
      defaultDarkColor: const Color(0xff10141d),
    );

    return Container(
      color: pageBg,
      child: Column(
        children: [
          _buildSearchBar(),
          _buildTagsHeader(isDark),
          Expanded(
            child: Stack(
              children: [
                _buildTimelineList(),
                _buildModeSwitcher(),
                _buildFloatingInsertButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建顶部搜索栏。
   */
  Widget _buildSearchBar() {
    if (this.widget.timelinePageFromEnum != TimelinePageFromEnum.normal.index) {
      return SizedBox.shrink();
    }

    return SearchBarWidget(
        key: searchBarWidgetKey,
        defaultValue: this.curSearchWords,
        width: double.infinity,
        onChangeListener: (searchWord) {
          onClickSearch(searchWord);
        },
        onClickResetListener: () {
          // 搜索栏状态由 SearchBarWidget 内部维护，这里保留回调入口方便后续扩展。
        });
  }

  /**
   * 功能：构建清单标签筛选区。
   * 说明：从原先覆盖在列表上的 Stack 子元素移到列表上方，避免标签和首条时间轴内容重叠。
   */
  Widget _buildTagsHeader(bool isDark) {
    if (!_shouldShowTagsHeader()) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff111722) : const Color(0xfff7f3ed),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xff232b3a) : const Color(0xffece5db),
          ),
        ),
      ),
      child: TimeLineTagsGridViewWidget(
        datas: this.folderModelTags,
        onTapSelectedListener: (data) {
          FolderModel folderModel = data;
          if (folderModel.objectId == "-1") {
            this.curSearchingFocusModel = null;
          } else {
            this.curSearchingFocusModel = data;
          }
          requestDatas();
        },
        onTapAddTagListener: (data) {
          _openCreateFolderPage();
        },
        onTapDeleteTagListener: (data) {},
      ),
    );
  }

  /**
   * 功能：构建时间轴列表，并处理删除和详情跳转。
   */
  Widget _buildTimelineList() {
    return TimelineListView(
      timelinePageFromEnum:
          TimelinePageFromEnum.values[this.widget.timelinePageFromEnum],
      datas: this.missionListForView,
      onTapDelete: (TimelineMissionModel item) {
        MongoApisManager.getInstance()
            .delete_TimelineMissionModel(currentObjectId: item.objectId);
        requestDatas();
      },
      onTapListener: (TimelineMissionModel item) {
        _openTimelineDetail(item);
      },
    );
  }

  /**
   * 功能：构建底部类型切换器。
   */
  Widget _buildModeSwitcher() {
    if (this.widget.timelinePageFromEnum != TimelinePageFromEnum.normal.index) {
      return SizedBox.shrink();
    }

    return Align(
      alignment: Utility.isHandsetBySize() == true
          ? Alignment(0.0, 0.85)
          : Alignment(0.0, 0.95),
      child: TimelineButtonListWidget(
        width: Utility.isHandsetBySize() == true ? 55 : 80,
        initIndex: timelineModeEnum.index,
        list: CONSTANTS.getTimelineButtonsList(),
        onTapListener: (obj) {
          timelineModeEnum = TimelineModeEnum.values[obj['index']];
          requestDatas();
        },
      ),
    );
  }

  /**
   * 功能：构建右下角新增按钮。
   */
  Widget _buildFloatingInsertButton() {
    if (this.widget.timelinePageFromEnum == TimelinePageFromEnum.normal.index &&
        (timelineModeEnum == TimelineModeEnum.event ||
            timelineModeEnum == TimelineModeEnum.diary ||
            timelineModeEnum == TimelineModeEnum.note)) {
      return Positioned(
        bottom: Utility.isHandsetBySize() == true ? 20 : 40,
        right: Utility.isHandsetBySize() == true ? 20 : 40,
        child: getPopupMenu(),
      );
    }
    return SizedBox.shrink();
  }

  /**
   * 功能：判断当前页面是否需要展示标签筛选区。
   */
  bool _shouldShowTagsHeader() {
    return this.widget.timelinePageFromEnum !=
            TimelinePageFromEnum.FolderStatisticPage.index &&
        this.widget.timelinePageFromEnum !=
            TimelinePageFromEnum.ObjectivePage.index;
  }

  /**
   * 功能：打开新建清单页面。
   * 说明：移动端走普通 Navigator，桌面端复用 DesktopNavigator，保持项目既有页面切换方式。
   */
  void _openCreateFolderPage() {
    FolderModel folderModel = FolderModel();
    folderModel.tag = 1; // 1-normal 2-tag 3-circle
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new CreateFolderPage(
            pageEnum: PageModeEnum.create,
            folderModel: folderModel,
          ), callback: (res) {
        requestGetTags();
      });
    } else {
      Utility.pushDesktopNavigator(context, 'CreateFolderPage',
          {'PageEnum': PageModeEnum.create, 'folderModel': folderModel});
    }
  }

  /**
   * 功能：根据时间轴记录类型打开详情页。
   * 说明：目前只有日记和笔记需要进入只读富文本页，事件类记录保持列表内展示。
   */
  void _openTimelineDetail(TimelineMissionModel item) {
    if (item.sceneType == 'diary') {
      if (Utility.isHandsetBySize() == true) {
        Utility.pushNavigator(
            context,
            ReadOnlyPage(
                timelineMissionModel: item,
                richTextModeEnum: RichTextModeEnum.diary));
      } else {
        DialogManagement.getInstance().showPCCustomDialog(
            context: context,
            widget: ReadOnlyPage(
              richTextModeEnum: RichTextModeEnum.diary,
              timelineMissionModel: item,
            ));
      }
    } else if (item.sceneType == 'note') {
      if (Utility.isHandsetBySize() == true) {
        Utility.pushNavigator(
            context,
            ReadOnlyPage(
                timelineMissionModel: item,
                richTextModeEnum: RichTextModeEnum.note));
      } else {
        DialogManagement.getInstance().showPCCustomDialog(
            context: context,
            widget: ReadOnlyPage(
                timelineMissionModel: item,
                richTextModeEnum: RichTextModeEnum.note));
      }
    }
  }

  /**
   * 功能：读取当前主题模式，兼容 ThemeManager 和 Flutter 上下文主题。
   */
  bool _isDarkMode(BuildContext context) {
    return ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
  }
}
