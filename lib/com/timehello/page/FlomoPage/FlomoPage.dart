import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

import '../../common/provider/GlobalStateEnv.dart';
import '../../models/CalendarModel.dart';
import '../../models/FlomoMissionModel.dart';
import '../../util/DialogManagement.dart';
import '../../util/Utility.dart';
import 'FlomoCreatePage.dart';
import 'FlomoDetailPage.dart';
import 'components/ClockInSentenceDialog.dart';
import 'components/FlomoDatePagerWidget.dart';
import 'components/FlomoCircleWidget.dart';
import 'components/FlomoMissionSilverList.dart';

/**
 * 文件类型：页面
 * 文件作用：Flomo/打卡模块左侧列表页，负责日期筛选、任务列表展示和创建入口。
 * 主要职责：监听全局打卡数据变化，按当前日期或归档状态过滤任务，并用 FolderPage 统一侧栏视觉承载内容。
 */
class FlomoPage extends BaseWidget {
  final Function? onTapListener;

  FlomoPage({this.onTapListener});

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    return FlomoPageSate();
  }
}

class FlomoPageSate extends BaseWidgetState<FlomoPage> {
  List<FlomoMissionModel> datas = [];
  CalendarModel? calendarModel;
  DateTime curDateTime = DateTime.now();
  bool hasJump = false;
  int curDayIndex = 0;
  bool isFinished = false;
  bool isRequesting = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  GlobalKey<FlomoDatePagerWidgetState> flomoDatePagerWidgetStateKey =
      GlobalKey<FlomoDatePagerWidgetState>();

  /**
   * 功能：初始化 Flomo 左栏状态。
   * 说明：当前页面依赖 componentDidMount 请求日期任务，这里保留父类生命周期初始化。
   */
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /**
   * 功能：页面挂载后默认加载今天的打卡任务。
   */
  componentDidMount() {
    super.componentDidMount();
    curDateTime = DateTime.now();
    requestDatas(curDateTime);
  }

  /**
   * 功能：根据日期和归档状态刷新左侧任务列表。
   * 说明：未归档时从日历 dayModel 里取当天任务，归档时从全量任务里筛完成状态。
   */
  requestDatas(DateTime dateTime, {bool isRefresh = true}) {
    curDateTime = Utility.getFilterDateTimeFromTimeStamp(
        curDateTime.millisecondsSinceEpoch);
    calendarModel = context.read<GlobalStateEnv>().calendarModel;
    if (this.isFinished == false) {
      calendarModel?.dayModelList.forEach((element) {
        element.isCheck = false;
        if (element.dateTime!.isAtSameMomentAs(dateTime)) {
          datas = Utility.filterFlomoMissionModelByFinishedState(
              list: element.flomoMissionModelList, isFinished: this.isFinished);
          // datas = element.flomoMissionModelList ?? [];
        }
      });
      if ((calendarModel?.dayModelList.length ?? 0) > curDayIndex) {
        calendarModel?.dayModelList[curDayIndex].isCheck = true;
      }
    } else {
      datas = Utility.filterFlomoMissionModelByFinishedState(
          list: MongoApisManager.getInstance().listFlomoMissionModel,
          isFinished: this.isFinished);
    }
    datas = _filterDatasByKeyword(datas);
    // CounterMethodChannelManager.getInstance().storeFlomoMissionList(context);
    // datas = MongoApisManager.getInstance().listFlomoMissionModel;
    if (isRefresh) {
      this.updateUI();
    }
  }

  /// 功能：按标题关键字过滤打卡任务。
  /// 说明：搜索放在数据出口统一处理，切日期、切归档和数据库刷新时都能复用同一套过滤规则。
  List<FlomoMissionModel> _filterDatasByKeyword(
      List<FlomoMissionModel> source) {
    if (TextUtil.isEmpty(_searchKeyword)) {
      return source;
    }
    final String keyword = _searchKeyword.trim().toLowerCase();
    return source.where((item) {
      final String title = (item.title ?? '').trim().toLowerCase();
      return title.contains(keyword);
    }).toList();
  }

  @override
  baseBuild(BuildContext context) {
    return Selector<GlobalStateEnv, List<FlomoMissionModel>>(
      selector: (_, globalStateEnv) => globalStateEnv.listFlomoMissionModel,
      builder: (_, listFlomoMissionModel, __) {
        requestDatas(curDateTime, isRefresh: false);
        if (hasJump == false) {
          hasJump = true;
          Future.delayed(Duration(seconds: 3), () {
            flomoDatePagerWidgetStateKey.currentState?.jumpToTodayPage();
          });
        }
        return _buildUnifiedSidebarShell();
      },
    );
  }

  /**
   * 功能：构建参考 FolderPage 的统一左侧壳层。
   * 说明：外层使用渐变和柔性色块，内层使用圆角浅色面板，让打卡列表和 FolderPage 的侧栏一致。
   */
  Widget _buildUnifiedSidebarShell() {
    final bool isDark = ThemeManager.getInstance().isDark();
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF7D6BE),
                  Color(0xFFF5E8DA),
                  Color(0xFFDCEADD),
                ],
              ),
        color: isDark ? ThemeManager.getInstance().getLeftMenuColor() : null,
      ),
      child: Stack(
        children: [
          if (!isDark) ...[
            Positioned(
              left: -70,
              top: 170,
              child: _buildAccentBlob(const Color(0xFFCDE4D6), 168),
            ),
            Positioned(
              right: -55,
              top: 66,
              child: _buildAccentBlob(const Color(0xFFF6E6D3), 148),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeManager.getInstance().getLeftMenuColor()
                    : ColorsConfig.missionSidebarShellBackground,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark
                      ? ThemeManager.getInstance().getLineColor()
                      : const Color(0xFFF0DBC8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _buildSidebarContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：绘制左侧背景柔性色块。
   */
  Widget _buildAccentBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }

  /**
   * 功能：构建左栏真实内容。
   * 说明：顺序参考 FolderPage：桌面端保留顶部品牌区；移动端空间有限，直接从搜索和日期筛选开始。
   */
  Widget _buildSidebarContent() {
    final bool shouldShowUnifiedHeader = !Utility.isHandsetBySize();
    return Stack(
      children: [
        Column(
          children: [
            if (shouldShowUnifiedHeader) _buildUnifiedHeader(),
            _buildSearchBar(),
            FlomoDatePagerWidget(
              key: flomoDatePagerWidgetStateKey,
              dataModels: calendarModel?.dayModelList ?? [],
              dataWeekModel: calendarModel?.weekModelList ?? [],
              onTapTodayListener: (dayModel) {
                curDayIndex =
                    calendarModel?.dayModelList.indexOf(dayModel) ?? 0;
                this.requestDatas(curDateTime = dayModel.dateTime!);
              },
              onTapCheckBoxListener: (value) {
                this.isFinished = (value != 0);
                this.requestDatas(curDateTime);
                if (this.isFinished == false) {
                  jumpToToday();
                }
              },
              isFinished: this.isFinished,
            ),
            SizedBox(
              height: this.isFinished == true ? 4 : 0,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: buildList(),
              ),
            ),
            _buildCreateButton(),
          ],
        ),
        Positioned(
          right: 14,
          bottom: 18,
          child: FlomoCircleWidget(
            color: ThemeManager.getInstance().getDefautThemeColor(),
          ),
        )
      ],
    );
  }

  /// 功能：构建打卡区域顶部搜索栏。
  /// 说明：桌面和移动端都共用这一入口，输入后实时过滤当前列表，便于快速定位某个习惯任务。
  Widget _buildSearchBar() {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color fillColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xfff7efe6);
    final Color borderColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xffead8c7);
    final Color iconColor = ThemeManager.getInstance().getTextColor(
      defaultColor: ColorsConfig.missionSidebarTextSecondary,
      defaultDarkColor: Colors.white70,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            _searchKeyword = value;
            requestDatas(curDateTime);
          },
          style: TextStyle(
            fontSize: 12,
            color: ThemeManager.getInstance().getTextColor(
              defaultColor: ColorsConfig.missionSidebarTextPrimary,
              defaultDarkColor: Colors.white,
            ),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 9),
            border: InputBorder.none,
            hintText: getI18NKey().search,
            hintStyle: TextStyle(
              fontSize: 12,
              color: iconColor,
            ),
            prefixIcon: Icon(Icons.search_rounded, size: 18, color: iconColor),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 36, minHeight: 34),
            suffixIcon: TextUtil.isEmpty(_searchKeyword)
                ? null
                : IconButton(
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                    icon: Icon(Icons.close_rounded, size: 18, color: iconColor),
                    onPressed: () {
                      _searchController.clear();
                      _searchKeyword = '';
                      requestDatas(curDateTime);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  /**
   * 功能：构建参考 FolderPage 的 Time Bureau 顶部区。
   */
  Widget _buildUnifiedHeader() {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color titleColor = ThemeManager.getInstance().getTextColor(
      defaultColor: ColorsConfig.missionSidebarTextPrimary,
      defaultDarkColor: Colors.white,
    );
    final Color subtitleColor = ThemeManager.getInstance().getTextColor(
      defaultColor: ColorsConfig.missionSidebarTextSecondary,
      defaultDarkColor: Colors.white70,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 8),
      child: Row(
        children: [
          Icon(Icons.menu_rounded, size: 20, color: titleColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getI18NKey().time_bureau,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  getI18NKey().unified_workspace,
                  style: TextStyle(fontSize: 11, color: subtitleColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : ColorsConfig.missionSidebarHeaderChipBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 14, color: titleColor),
                const SizedBox(width: 6),
                Text(
                  getI18NKey().focus_short,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /**
   * 功能：构建固定在左栏底部的创建按钮。
   * 说明：参考 FolderPage 截图中底部蓝色创建入口，减少它被长列表挤到不可见位置。
   */
  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 52),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(
              context,
              child: ClockInSentenceDialog(onSubmitted: () {}));
        },
        child: Container(
          alignment: Alignment.center,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ThemeManager.getInstance().getDefautThemeColor(),
          ),
          child: Text(
            getI18NKey().create,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  void jumpToToday() {
    Future.delayed(Duration(seconds: 1), () {
      flomoDatePagerWidgetStateKey.currentState?.jumpToTodayPage();
    });
  }

  List<Widget> buildList() {
    List<Widget> listWidget = [];
    // listWidget
    //     .add(initSliverPersistentHeader(getI18NKey().missionToBeComplete));
    listWidget.add(FlomoMissionSilverList(
      ymd: Utility.getYMD(curDateTime),
      onTapClockInListener: (data) async {
        if (isRequesting == true) {
          return;
        }
        isRequesting = true;
        await MongoApisManager.getInstance().update_FlomoMissionModelClocksIn(
            flomoMissionModel: data,
            ymd: Utility.getYMD(curDateTime),
            callback: () {
              updateUI();
            });
        isRequesting = false;
        if (Utility.isFlomoMissionClockInFinishedAtYMD(
                flomoMissionModel: data, ymd: Utility.getYMD(curDateTime)) ==
            true) {
          DialogManagement.showFlomoRatingDialog(
            context,
            flomoMissionModel: data,
            onSubmitted: (val) async {
              await MongoApisManager.getInstance()
                  .update_FlomoMissionModelMessage(
                      flomoMissionModel: data,
                      ymd: Utility.getYMD(curDateTime),
                      satisfaction: val['code'],
                      message: val['content']);
              DialogManagement.getInstance().hideDialog(context);
            },
          );
        }
      },
      bottomChild: const SizedBox(height: 8),
      // quadrantWidgetGlobalKey: this.widget.quadrantWidgetGlobalKey,
      onDragEndListener: (data) {
        this.onClick("onDragEndListener", data);
      },
      //未完成任务列表
      datas: datas,
      onTapEditTitleListener: (obj) {
        // this.onClick('onTapEditTitleListener', obj); //跳转到任务详情页MissionPage开始任务
      },
      onTapPlayListener: (obj) {
        this.onClick('onClickMissionDetail', obj); //跳转到任务详情页MissionPage开始任务
      },
      onTapListener: (obj) {
        // DialogManagement.showFlomoRatingDialog(context, flomoMissionModel: obj, onSubmitted: (val) async {
        //   await MongoApisManager.getInstance().update_FlomoMissionModelMessage(flomoMissionModel: obj,  satisfaction: val['code'], message: val['content']);
        //   DialogManagement.getInstance().hideDialog(context);
        // }, );
        if (Utility.isHandsetBySize() == true) {
          Utility.pushNavigator(
              context,
              FlomoDetailPage(
                  flomoMissionModel: obj, curDateTime: curDateTime));
        } else {
          this
              .widget
              .onTapListener
              ?.call({"data": obj, "curDateTime": curDateTime});
        }
      },
      onTapDeleteListener: (data) async {
        await MongoApisManager.getInstance().insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.toARGB32(),
                object_id: data?.objectId,
                sceneType: "mission",
                eventType: "clockin_time",
                timelineMessage:
                    getI18NKey().delete_flomo_mission(data.title ?? "?")));

        MongoApisManager.getInstance()
            .delete_FlomoMissionModel(currentObjectId: data?.objectId);
      },
      onTapEditListener: (data) {
        // DialogManagement.getInstance().showFlomoRatingDialogWithOnlyChild(context,
        //     child: ClockInSentenceDialog(onSubmitted: () {}));
        Utility.openPagePCAndMobile(context,
            child: FlomoCreatePage(
              pageModeEnum: 1,
              flomoMissionModel: data,
            ));
        this.onClick('onClickMissionSetting', data);
      },
      onTapFinishListener: (data) async {
        FlomoMissionModel missionModel = data;
        await MongoApisManager.getInstance().insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.toARGB32(),
                object_id: data?.objectId,
                sceneType: "mission",
                eventType: "clockin_time",
                timelineMessage:
                    getI18NKey().complete_flomo_mission(data.title ?? "?")));

        missionModel.isFinished = true;
        MongoApisManager.getInstance()
            .update_FlomoMissionModel(missionModel: missionModel);
        this.onClick('onClickFinishItem', data); //点击完成任务
      },
      curDateTime: curDateTime,
      onTapCancelClockInListener: (missionModel) async {
        if (isRequesting == true) {
          return;
        }
        isRequesting = true;
        await MongoApisManager.getInstance().update_FlomoMissionModelClocksIn(
            shouldInc: false,
            flomoMissionModel: missionModel,
            ymd: Utility.getYMD(curDateTime),
            callback: () {
              updateUI();
            });
        isRequesting = false;
      },
      onTapUnfinishListener: (data) async {
        FlomoMissionModel missionModel = data;
        await MongoApisManager.getInstance().insertTimelineMissionModel(
            missionModel: Utility.getTimelineMissionModelFromMissionModel(
                icon: Icons.check_circle.codePoint,
                color: Colors.greenAccent.toARGB32(),
                object_id: data?.objectId,
                sceneType: "mission",
                eventType: "clockin_time",
                timelineMessage:
                    getI18NKey().uncomplete_flomo_mission(data.title ?? "?")));

        missionModel.isFinished = false;
        MongoApisManager.getInstance()
            .update_FlomoMissionModel(missionModel: missionModel);
      },
    ));
    return listWidget;
  }
}
