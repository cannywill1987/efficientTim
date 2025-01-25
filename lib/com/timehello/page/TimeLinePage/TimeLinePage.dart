import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/page/RichEditor/ReadOnlyPage.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import '../../common/database/apis/MongoApisManager.dart';
import '../../common/provider/Env.dart';
import '../../common/provider/GlobalStateEnv.dart';
import '../../components/BaseWidget.dart';
import '../../components/CircleWidget.dart';
import '../../components/CommonCalendarHeaderWidget.dart';
import '../../components/TransparentOverlayPage.dart';
import '../../config/ColorsConfig.dart';
import '../../config/Params.dart';
import '../../libs/mongodb/response/MongoDbSaved.dart';
import '../../models/EventFn.dart';
import '../../models/FolderModel.dart';
import '../../models/MissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/LoginManager.dart';
import '../../util/Utility.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../../components/SearchBarWidget.dart';
import '../CreateMissionPage/components/TagsGridViewWidget.dart';
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

  const TimeLinePage(
      {required Key key,
      required this.timelinePageFromEnum,
      this.shouldShowNav = false,
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

  @override
  void initState() {
    super.initState();
    // color = Colors.transparent;
    controller = CommonCalendarHeaderWidgetController();
    this.isAppBarVisible = this.widget.shouldShowNav;

    this.requestDatas();
    this.requestGetTags();
  }

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

  //  根据iconcType 1-今天 2 明天 3 即将到来 4 待定 5 日程 5 已完成
  requestDatas(
      {String? message,
      DateTime? startDateTime,
      DateTime? endDateTime,
      shouldUpdateUI = true}) {
    String? folderId = this.curSearchingFocusModel?.objectId;
    if (this.widget.timelinePageFromEnum ==
        TimelinePageFromEnum.FolderStatisticPage.index) {
      folderId = this.widget.folderObjectId;
    }
    missionListOriginal = MongoApisManager.getInstance()
        .queryWhereEqual_timelineMissionModelsByEndTime(
      fid: folderId,
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
    folderModel.color = Colors.lightGreen.value;
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
                  color: Colors.lime.value,
                  sceneType: "mission",
                  eventType: "insert_manually",
                  timelineMessage: value));
      if (res != null) {
        Utility.showToastMsg(context: context, msg: getI18NKey().insert_success);
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

  @override
  Widget baseBuild(BuildContext context) {
    double innerMargin = Utility.isHandsetBySize() ? 10 : 20.0;
    context.watch<GlobalStateEnv>().listTimelineMissionModel;
    requestDatas();
    requestGetTags();
    return Selector<Env, bool>(
        selector: (_, env) => env.isVip ?? false,
        builder: (_, settingModel, __) {

          if (LoginManager.getInstance().isVIP(
              shouldShowDialog: false,
              paymentPromotionAdsModeEnum: PaymentPromotionAdsModeEnum.Calendar) || TimelinePageFromEnum.normal.index != this.widget.timelinePageFromEnum)
            return getChild(context);
          else
            return Stack(
              children: [
                getChild(context),
                Expanded(child: Container(child: TransparentOverlayPage(onTapCallback: () {
                  LoginManager.getInstance().isVIP(shouldShowDialog: true,
                      paymentPromotionAdsModeEnum: PaymentPromotionAdsModeEnum.TimeLine
                  );
                },),))
              ],
            );
        });

  }

  Container getChild(BuildContext context) {
    return Container(
    color:
        this.widget.timelinePageFromEnum == TimelinePageFromEnum.normal.index
            ? Colors.transparent
            : ThemeManager.getInstance()
                .getBackgroundColor(defaultColor: ColorsConfig.chartBgColor),
    child: Column(
      children: [
        this.widget.timelinePageFromEnum == TimelinePageFromEnum.normal.index
            ? SearchBarWidget(
                key: searchBarWidgetKey,
                defaultValue: this.curSearchWords,
                width: double.infinity,
                onChangeListener: (searchWord) {
                  onClickSearch(searchWord);
                },
                onClickResetListener: () {
                  // setState(() {
                  //   isSearchBarVisible = !isSearchBarVisible;
                  // });
                })
            : SizedBox.shrink(),
        Expanded(
          child: Stack(
            children: [
              TimelineListView(
                timelinePageFromEnum: TimelinePageFromEnum
                    .values[this.widget.timelinePageFromEnum],
                datas: this.missionListForView,
                onTapDelete: (TimelineMissionModel item) {
                  MongoApisManager.getInstance().delete_TimelineMissionModel(
                      currentObjectId: item.objectId);
                },
                onTapListener: (TimelineMissionModel item) {
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
                },
              ),
              if (this.widget.timelinePageFromEnum !=
                  TimelinePageFromEnum.FolderStatisticPage.index)
                TimeLineTagsGridViewWidget(
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
                    FolderModel folderModel = FolderModel();
                    folderModel.tag = 1; //1-normal 2-tag 3-circle
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
                      Utility.pushDesktopNavigator(
                          context, 'CreateFolderPage', {
                        'PageEnum': PageModeEnum.create,
                        'folderModel': folderModel
                      });
                    }
                    // this.onClick('onTapTagListener', data);
                  },
                  onTapDeleteTagListener: (data) {},
                ),
              this.widget.timelinePageFromEnum ==
                      TimelinePageFromEnum.normal.index
                  ? Align(
                      alignment: Utility.isHandsetBySize() == true
                          ? Alignment(0.0, 0.85)
                          : Alignment(0.0, 0.95),
                      child: TimelineButtonListWidget(
                        width: Utility.isHandsetBySize() == true ? 55 : 80,
                        initIndex: timelineModeEnum.index,
                        list: CONSTANTS.getTimelineButtonsList(),
                        onTapListener: (obj) {
                          timelineModeEnum =
                              TimelineModeEnum.values[obj['index']];
                          requestDatas();
                        },
                      ),
                    )
                  : SizedBox.shrink(),
              (this.widget.timelinePageFromEnum ==
                          TimelinePageFromEnum.normal.index &&
                      (timelineModeEnum == TimelineModeEnum.event ||
                          timelineModeEnum == TimelineModeEnum.diary ||
                          timelineModeEnum == TimelineModeEnum.note))
                  ? Positioned(
                      bottom: Utility.isHandsetBySize() == true ? 20 : 40,
                      right: Utility.isHandsetBySize() == true ? 20 : 40,
                      child: getPopupMenu())
                  : SizedBox.shrink()
            ],
          ),
        ),
      ],
    ),
  );
  }
}
