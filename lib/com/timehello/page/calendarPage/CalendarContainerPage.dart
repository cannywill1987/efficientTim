import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/ViewStub.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/page/calendarPage/CalendarPage.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import '../../components/BlackCheckButtonListWidget.dart';
import '../../components/CustomMarquee.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ColorsConfig.dart';
import '../../models/FolderModel.dart';
import '../../util/Utility.dart';
import '../TestPage/TestPage.dart';
import 'TimeManagementPage.dart';

/**
 *时间轴TimeManagementPage和日历CalendarPage的容器
 */
class CalendarContainerPage extends BaseWidget {
  final String title;

  const CalendarContainerPage({required this.title});

  @override
  BaseWidgetState<BaseWidget> getState() => _CalendarContainerPageState();
}

class _CalendarContainerPageState
    extends BaseWidgetState<CalendarContainerPage> {
  int curIndex = 0;
  static GlobalKey<BlackCheckButtonListWidgetState>
      blackCheckButtonListWidgetGlobalKey = GlobalKey();

  GlobalKey<CalendarPageState> CalendarPageStateGlobalKey = GlobalKey();
  GlobalKey<TimeManagementPageState> CalendarPage2StateGlobalKey = GlobalKey();

  @override
  void onCreate() {}

  @override
  void initState() {
    super.initState();
    this.curIndex = SharePreferenceUtil.getSyncInstance().getInt(key: ShareprefrenceKeys.defautCalendarContainerPageIndex, defaultVal: 0);
    this.isAppBarVisible = true;
    isNavBackBtnVisible = false;

    this.centerNavChild = BlackCheckButtonListWidget(
      key: blackCheckButtonListWidgetGlobalKey,
      initIndex: curIndex,
      list: CONSTANTS.getTimelineButtonList(),

      onTapListener: (index) async {
        this.curIndex = index;
        SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.defautCalendarContainerPageIndex, value: this.curIndex);
        setState(() {});
      },
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //
    // });
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    // eventBus.on<EventFn>().listen((event) {
    //   if (event.type == Params.ACTION_UPDATE_CalendarContainerPage) {
    //     this.requestDatas();
    //   }
    // });
  }

  @override
  componentDidMount() {}

  @override
  void dispose() {
    // 为了避免内存泄漏，需要调用_controller.dispose
    super.dispose();
  }

  Future<void> requestDatas() async {
    await Utility.initCalendarModel();
    updateUI();
  }

  void onClick(type, data) async {
    switch (type) {

    }
  }

  Widget baseBuild(BuildContext context) {


    return Container(
        color: ColorsConfig.chartBgColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // StatisticTabbarButtonListWidget(
            //   list: CONSTANTS.getStatsDateButtonList(),
            //   onTapListener: (obj) {
            //     curIndex = obj["index"];
            //     Future.delayed(Duration(milliseconds: 100), () {
            //       updateUI();
            //     });
            //   },
            // ),
            Expanded(
              child: getWidget(),
            ),
          ],
        ));
  }

  Widget getWidget() {
    ///帧布局结合透明布局
    return Stack(
      children: <Widget>[
        ViewStubWidget(
          child: CalendarPage(key: CalendarPageStateGlobalKey, onRefresh: (FolderModel folderModel) async {
            await Utility.initCalendarModel();
          }, title: '',),
          isShowed: curIndex == 0 ? true : false,
        ),
        ViewStubWidget(
          child: TimeManagementPage(key: CalendarPage2StateGlobalKey, onRefresh: () async {
            await Utility.initCalendarModel();
          },),
          isShowed: curIndex == 1 ? true : false,
        ),
        // Offstage(
      ],
    );
  }
}
