import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/list_wheel_scroll_view_x.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/DateTimeModel.dart';
import 'package:time_hello/com/timehello/models/EventFn.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/main.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../components/CustomMarquee.dart';
import '../../util/DialogManagement.dart';
import '../CreateMissionPage/CreateMissionPage.dart';
import '../SettingItemDetailPage/SettingItemDetailPage.dart';
import 'components/CalendarSliverListWidget.dart';

/**
 * 日历页面
 */
class CalendarPage extends BaseWidget {
  String? title;
  Function? onRefresh;
  CalendarPage({Key? key, this.title, this.onRefresh}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() => CalendarPageState();
}

class CalendarPageState extends BaseWidgetState<CalendarPage> {
  Function? debounceFunction;
  int curIndex = 0;
  var timer;
  AutoScrollController? verticalScrollController = AutoScrollController();

  // var isScrollingTimer;
  bool nested = false;
  int currentDateIndex = -1;
  FolderModel? folderModelSearch;

  // bool isScrolling = false;
  // bool enableScrollManually = false;
  FixedExtentScrollController bottomBarScrollController =
      FixedExtentScrollController(
          initialItem: Utility.getGlobalContext()
              .watch<GlobalStateEnv>()
              .calendarModel
              .indexMonth);
  ScrollController _controller = ScrollController();
  int currentBtmIndex = (Utility.getGlobalContext()
          .watch<GlobalStateEnv>()
          .calendarModel
          .indexMonth) +
      1; //MyApp.calendarModel有可能为Null
  int btmIndex = Utility.getGlobalContext()
      .watch<GlobalStateEnv>()
      .calendarModel
      .indexMonth;
  DateTimeModel? currentDateTimeModel;
  CalendarModel? calendarModel;

  @override
  void onCreate() {
    curPage = "CalendarPage";
    bottomBarScrollController =
        FixedExtentScrollController(initialItem: btmIndex);
    currentBtmIndex = btmIndex + 1;
    calendarModel =
        Utility.getGlobalContext().watch<GlobalStateEnv>().calendarModel;
    btmIndex = calendarModel!.indexMonth + 1;
  }

  @override
  void initState() {
    super.initState();
    curPage = "CalendarPage";
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //
    // });
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    // eventBus.on<EventFn>().listen((event) {
    //   if (event.type == Params.ACTION_UPDATE_CALENDARPAGE) {
    //     this.requestDatas();
    //   }
    // });
  }

  @override
  componentDidMount() {
    //延时是为了防止以页面加载出来 却还没有数据
    Future.delayed(Duration(seconds: 2), () {
      horizontalAnimateToItem(this.curIndex = calendarModel!.indexMonth);
      Future.delayed(Duration(seconds: 1), () {
        verticalAnimateToPosition(DateTime.now().day);
      });
    });
  }

  horizontalAnimateToItem(int index) {
    if (calendarModel!.monthModelList.length > 0) {
      this.curIndex = index;
      bottomBarScrollController.animateToItem(index,
          duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
  }

  @override
  void dispose() {
    // 为了避免内存泄漏，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  void onClick(type, data) async {
    switch (type) {
      case 'onClickToMissionDetailPage': //点击跳转专注页
        this.onClickToMissionDetailPage(
            data['missionModel'], data['folderModel']);
        break;
      case 'onClickFinishItem': //点击完成任务
        Utility.onClickFinishItem(missionModel: data['missionModel'], folderModel: data?['folderModel'] ?? null, timestampCurrent: data['timestampCurrent'], context: context, finishCallback: () {
          requestDatas();
        });
        break;
      case 'onClickPreviousPage':
        horizontalAnimateToItem(--curIndex);
        break;
      case 'onClickNextPage':
        horizontalAnimateToItem(++curIndex);
        break;
      case 'onClickSettingItem':
        this.onClickMissionSetting(data['missionModel']);
        break;
      case 'onClickCreateWithData':
        this.onClickCreateWithData(data['dayModel']);
    }
  }

  void onClickCreateWithData(DayModel dayModel) {
    if (Utility.isHandsetBySize() == true) {
      MissionModel missionModel = MissionModel();
      missionModel.end_time = dayModel.dateTime?.millisecondsSinceEpoch;
      Utility.pushNavigator(
          context,
          CreateMissionPage(missionModel: missionModel,onRefresh: () {
            requestDatas();
          }));
    } else {
      MissionModel missionModel = MissionModel();
      missionModel.end_time = dayModel.dateTime?.millisecondsSinceEpoch;
      DialogManagement.getInstance().showPCCustomDialog(
          context: context,
          widget: CreateMissionPage(missionModel: missionModel, onRefresh: () {
            requestDatas();
          }));
    }
  }

  /**
   * 点击跳转专注页
   */
  Future onClickToMissionDetailPage(
      [MissionModel? missionModel, FolderModel? folderModel]) async {
    OverlayManagement.getInstance()!.openMissionDetailPageOverlay(
        context: context, missionModel: missionModel, folderModel: folderModel);
  }

  Future<void> requestDatas() async {
    if(this.widget.onRefresh != null) {
      this.widget.onRefresh!(this.folderModelSearch);
    }
  }



  /**
   * 跳转到设置叶敏
   */
  void onClickMissionSetting(data) {
    Utility.popupDesktopRightNavigator(context);
    if (Utility.isHandsetBySize()) {
      Utility.pushNavigator(
          context,
          new SettingItemDetailPage(
            key: ValueKey("ejzifjf"),
            missionModel: data,
          ), callback: (val) {
        requestDatas();
      });
    } else {
      Utility.openRightSideDesktopNavigator(
          context, 'SettingItemDetailPage', {'missionModel': data});
    }
  }

  /**
   * 获取横坐标Index数
   */
  getHorMonthIndex(DateTimeModel dateTimeModel) {
    for (int index = 0; index < calendarModel!.monthModelList.length; index++) {
      if (dateTimeModel.datetime!.month ==
              calendarModel!.monthModelList[index].month &&
          (dateTimeModel.datetime!.year) ==
              int.parse(calendarModel!.monthModelList[index].yearName)) {
        return index;
      }
    }
    Utility.showToast(msg: getI18NKey().dateOutOfLimit, type: 'error');
    return -1;
  }

  getTotalItems() {
    List<Widget> listWidgets = [];
    for (int index = 1;
        index < (calendarModel?.monthModelList.length ?? 0);
        index++) {
      listWidgets.add(
          getBottomItem(index, false, calendarModel!.monthModelList[index]));
    }
    return listWidgets;
  }

  @override
  Widget build(BuildContext context) {
    calendarModel = context.watch<GlobalStateEnv>().calendarModel;
    List<MonthModel> monthModelList = calendarModel?.monthModelList ?? [];
    return ColoredBox(
      color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomMarquee(
            bean: MarqueInfo.marqueCalendarpage,
          ),
          Expanded(
              flex: 1,
              child: (monthModelList.length > 0 &&
                      ((monthModelList[this.btmIndex].dayModelList.length)) > 0)
                  ? buildCenter()
                  : Container()),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Color(0xfff0f0f0),
          ),
          Container(height: 60, child: buildBottom())
        ],
      ),
    );
  }

  //必须要做这个判断 否则数组为空时会报scrollview异常
  buildCenter() => GestureDetector(
      onTap: () {
        Utility.popupDesktopRightNavigator(context);
      },
      child: CustomScrollView(
          key: ValueKey('CustomScrollView123zefz'),
          controller: verticalScrollController,
          physics: nested ? const NeverScrollableScrollPhysics() : null,
          shrinkWrap: nested,
          cacheExtent: 50,
          slivers: [
            CalendarSliverListWidget(
              key: ValueKey('CalendarSliverListWidget123'),
              onTapFolderFilterListener: (folderModel) {
                    folderModelSearch = folderModel;
                    updateUI();
              },
              listDayModels: Utility.filterDaysModels(calendarModel?.monthModelList[btmIndex].dayModelList ?? [], folderModelSearch),
              onTapHeaderListener: () async {
                int? curTimestemp = currentDateTimeModel?.timestamp;
                currentDateTimeModel = await Utility.showMonthPickerDialog(
                    context, curTimestemp ?? Utility.getTimeStampToday());
                int index = getHorMonthIndex(currentDateTimeModel!);
                if (index > -1) {
                  horizontalAnimateToItem(index - 1);
                  verticalAnimateToPosition(currentDateTimeModel!.datetime?.day ?? 0);
                }
              },
              onTapPlayListener:
                  (FolderModel? folderModel, MissionModel? missionModel) {
                this.onClick('onClickToMissionDetailPage',
                    {'missionModel': missionModel, 'folderModel': folderModel});
              },
              onTapFinishListener:
                  (FolderModel? folderModel, MissionModel? missionModel, int? timestampCurrent) {
                this.onClick('onClickFinishItem',
                    {'missionModel': missionModel, 'folderModel': folderModel, 'timestampCurrent': timestampCurrent});
              },
              onScrollListener: (index) {
                // if(enableScrollManually && !isScrolling) {
                //     bottomBarScrollController.animateToItem(MyApp.calendarModel.dayModelList[index].indexMonth, duration: Duration(seconds: 1), curve: Curves.easeOutCirc);
                // }
                // print('scroll $index');
              },
              onTapSettingListener:
                  (FolderModel? folderModel, MissionModel? missionModel) {
                this.onClick('onClickSettingItem',
                    {'missionModel': missionModel, 'folderModel': folderModel});
              }, onTapCreateListener: (DayModel dayModel) {
              this.onClick('onClickCreateWithData',
                  {'dayModel': dayModel});
            },
            )
          ]));

  Widget buildBottom() {
    return Row(
      children: [
        TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.onClick('onClickPreviousPage', null);
            },
            child: Wrap(
              children: getPreviousPageWidget(),
            )),
        Expanded(
            child: Stack(
          children: [
            //中间的蓝色
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      // child: getBottomItem(
                      //     1, true, MyApp.calendarModel.dayModelList[this.curIndex]),
                      width: 100,
                      height: 40,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: ThemeManager.getInstance().getDefautThemeColor(),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      alignment: Alignment.center,
                    ))),
            Align(
              alignment: Alignment(0, 0),
              child: ListWheelScrollViewX(
                controller: bottomBarScrollController,
                onSelectedItemChanged: (index) {
                  this.currentBtmIndex = index + 1;
                  updateUI();
                  if (timer != null) {
                    timer?.cancel();
                    timer = null;
                  }
                  timer = Timer(Duration(milliseconds: 300), () {
                    verticalScrollController?.scrollToIndex(0);
                    this.btmIndex = index + 1;
                    updateUI();
                    // scrollController.jumpTo(index.toDouble());
                  });
                },
                scrollDirection: Axis.horizontal,
                physics: FixedExtentScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemExtent: 80,
                overAndUnderCenterOpacity: 0.5,
                children: getTotalItems(),
              ),
            ),
          ],
        )),
        TextButton(
            style: StylesConfig.transparentTextButtonStyle,
            onPressed: () {
              this.onClick('onClickNextPage', null);
            },
            child: Wrap(
              children: getNextPageWidget(),
            )),
      ],
    );
  }

  List<Widget> getPreviousPageWidget() {
    if (!Utility.isHandsetBySize()) {
      return [
        Icon(Icons.skip_previous),
        SizedBox(
          width: 3,
        ),
        Text(getI18NKey().previous_page)
      ];
    } else {
      return [Icon(Icons.skip_previous)];
    }
  }

  List<Widget> getNextPageWidget() {
    if (!Utility.isHandsetBySize()) {
      return [
        Text(getI18NKey().next_page),
        SizedBox(
          width: 3,
        ),
        Icon(Icons.skip_next),
      ];
    } else {
      return [
        Icon(Icons.skip_next),
      ];
    }
  }

  verticalAnimateToPosition(int pos) {
    verticalScrollController?.scrollToIndex(pos + 2).then((_) {});
  }

  getCurrentDateIndex() {
    int length = Utility.getGlobalContext()
        .watch<GlobalStateEnv>()
        .calendarModel!
        .dayModelList
        .length;
    for (int i = 0; i < length; i++) {
      if (Utility.getGlobalContext()
              .watch<GlobalStateEnv>()
              .calendarModel!
              .dayModelList[i]
              .isCurrent ==
          true) {
        return i;
      }
    }
    return 0;
  }

  // getIndexFromMonthModelList(index) {
  //   int jumpTo = 0;
  //   for (int i = 0; i < index; i++) {
  //     jumpTo += MyApp.calendarModel.monthModelList[i].dayModelList.length;
  //   }
  //   // print('123:${jumpTo}');
  //   return jumpTo;
  // }

  getBottomItem(int index, bool isSelected, MonthModel monthModel) {
    isSelected = index == this.currentBtmIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${monthModel.monthName}',
          style: isSelected
              ? TextStyle(color: Colors.white, fontWeight: FontWeight.w600)
              : TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black), fontWeight: FontWeight.w600),
        ),
        Text(
          '${1}-${monthModel.dayModelList.length}',
          style: isSelected
              ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Colors.black), fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
