
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/page/CountDownListViewPage/CountDownListViewPage.dart';
import 'package:time_hello/com/timehello/page/FourQuadrant/FourQuadrantPage.dart';
import 'package:time_hello/com/timehello/page/TimeLinePage/TimeLinePage.dart';
import '../../common/provider/Env.dart';
import '../../components/BlackCheckButtonListWidget.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ColorsConfig.dart';
import '../../config/Params.dart';
import '../../util/SharePreferenceUtil.dart';
import '../createFolderPage/components/IconsGridViewWidget.dart';

class TimeContainerPage extends BaseWidget {
  final String title;

  const TimeContainerPage({required this.title});

  @override
  BaseWidgetState<BaseWidget> getState() => _TimeContainerPageState();
}

class _TimeContainerPageState extends BaseWidgetState<TimeContainerPage> {
  int curIndex = 0;
  GlobalKey<BlackCheckButtonListWidgetState> blackCheckButtonListWidgetGlobalKey = GlobalKey();
  @override
  void onCreate() {
    super.onCreate();
    curPage = "TimeContainerPage";
  }

  @override
  void initState() {
    super.initState();
    this.curIndex = SharePreferenceUtil.getSyncInstance().getInt(key: ShareprefrenceKeys.defautTimerContainerPageIndex, defaultVal: 0);
    this.isAppBarVisible = false;
    isNavBackBtnVisible = false;
    forceAppBarVisible = false;
    this.rightNavChildren = [];
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //
    // });
    //监听广播 设置页面过来后用得上 todo 应该加一个action
    // eventBus.on<EventFn>().listen((event) {
    //   if (event.type == Params.ACTION_UPDATE_TimeContainerPage) {
    //     this.requestDatas();
    //   }
    // });
  }

  @override
  componentDidMount() {

  }

  @override
  void dispose() {
    // 为了避免内存泄漏，需要调用_controller.dispose
    super.dispose();
  }

  void onClick(type, data) async {
    switch (type) {
    }
  }


  Widget baseBuild(BuildContext context) {
    Env env = context.watch<Env>();
    this.curIndex = env.routerData != null ? (env.routerData['curTab'] ?? 0) : this.curIndex;
    // blackCheckButtonListWidgetGlobalKey.currentState?.setCurIndex(this.curIndex);
    // this.centerNavChild = BlackCheckButtonListWidget(
    //   key: blackCheckButtonListWidgetGlobalKey,
    //   initIndex: curIndex,
    //   list: CONSTANTS.getTimerContainerButtonList(),
    //   onTapListener: (index) async {
    //     // this.curIndex = index;
    //     SharePreferenceUtil.getSyncInstance().setInt(key: ShareprefrenceKeys.defautTimerContainerPageIndex, value: this.curIndex);
    //
    //     context.read<Env>().routerData = {"curTab": index};
    //     setState(() {});
    //   },
    // );
    return Container(
        color: ColorsConfig.chartBgColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // CustomMarquee(
            //   bean: MarqueInfo.marqueStatispage,
            // ),
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
        Offstage(
          offstage: curIndex == 0 ? false : true,
          child: FourQuadrantPage(),
        ),
      // Offstage(
      //   offstage: curIndex == 1 ? false : true,
      //   child: CountDownListViewPage(pageFromEnum: PageFromEnum.others),
      //   ),
      //   Offstage(
      //     offstage: curIndex == 2 ? false : true,
      //     child: const TimeLinePage(key: ValueKey("eaf"), timelinePageFromEnum: 0,),
      //   ),
      ],
    );
  }
}
