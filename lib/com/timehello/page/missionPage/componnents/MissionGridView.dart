import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/components/unified/UnifiedDesktopShell.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../../r.dart';
import '../../../components/GridSectionTitleWidget.dart';
import '../../../components/MoreWidget.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../interface/OnCallbackListener.dart';
import '../../../models/MissionModel.dart';
import '../../../models/SessionMissionModel.dart';
import 'GridMissionSilverList.dart';
import 'MissionCustomButton.dart';
import 'MissionSilverList.dart';

class MissionGridView extends StatelessWidget {
  MultiSelectModeEnum multiSelectModeEnum;
  List<SessionMissionModel> list;
  OnTapListener onTapListener;
  double width = 300;
  MissionOrderEnum missionOrderEnum;

  // MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  Function onTapCreateListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function? onTapDoItNow;
  Function onTapShowFolderChartListener;
  int folderStatus = -1;
  bool useUnifiedStyle;

  MissionGridView(
      {required this.onTapListener,
      required this.onTapCreateListener,
      this.onTapDoItNow,
      required this.folderStatus,
      required this.missionOrderEnum,
      this.onTapEditTitleListener,
      this.onTapEditListener,
      this.onTapDeleteListener,
      this.onTapFinishListener,
      this.onTapPlayListener,
      required this.onTapShowFolderChartListener,
      this.onTapMultiSelectListener,
      this.onTapUnFinishListener,
      required this.multiSelectModeEnum,
      this.useUnifiedStyle = false,
      required this.list});

  @override
  Widget build(BuildContext context) {
    final bool isModernMobileGrid =
        useUnifiedStyle && Utility.isHandsetBySize();
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        // crossAxisCount: 2,
        maxCrossAxisExtent: width, // 固定宽度
        childAspectRatio: isModernMobileGrid ? 0.82 : 0.7, // 宽高比
        mainAxisSpacing: isModernMobileGrid ? 12.0 : 10.0, // 主轴间距
        crossAxisSpacing: isModernMobileGrid ? 12.0 : 10.0, // 横轴间距
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return SliverGridviewItem(
            onTapListener: this.onTapListener,
            onTapCreateListener: this.onTapCreateListener,
            onTapDoItNow: this.onTapDoItNow,
            onTapEditTitleListener: this.onTapEditTitleListener,
            onTapEditListener: this.onTapEditListener,
            onTapDeleteListener: this.onTapDeleteListener,
            onTapFinishListener: this.onTapFinishListener,
            onTapPlayListener: this.onTapPlayListener,
            onTapMultiSelectListener: this.onTapMultiSelectListener,
            onTapUnFinishListener: this.onTapUnFinishListener,
            missionOrderEnum: this.missionOrderEnum,
            folderStatus: this.folderStatus,
            item: list[index],
            width: width,
            multiSelectModeEnum: this.multiSelectModeEnum,
            onTapShowFolderChartListener: this.onTapShowFolderChartListener,
            useUnifiedStyle: this.useUnifiedStyle,
          );
        },
        childCount: list.length,
      ),
    );
  }
}

class SliverGridviewItem extends StatelessWidget {
  int folderStatus = -1;
  MultiSelectModeEnum multiSelectModeEnum;
  SessionMissionModel item;
  Color color = Colors.red;
  double subFontSize = 12;
  Color subColor = Color(0xff666666);
  double headerHeight = 80;
  FolderModel? folderModel;
  OnTapListener onTapListener;
  MissionOrderEnum missionOrderEnum;

  double width = 300;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  Function? onTapDoItNow;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function onTapCreateListener;
  Function onTapShowFolderChartListener;
  bool useUnifiedStyle;

  SliverGridviewItem({
    required this.multiSelectModeEnum,
    required this.width,
    required this.item,
    required this.onTapListener,
    required this.onTapCreateListener,
    required this.onTapShowFolderChartListener,
    required this.missionOrderEnum,
    required this.folderStatus,
    this.onTapEditTitleListener,
    this.onTapEditListener,
    this.onTapDoItNow,
    this.onTapDeleteListener,
    this.onTapFinishListener,
    this.onTapPlayListener,
    this.onTapMultiSelectListener,
    this.onTapUnFinishListener,
    this.useUnifiedStyle = false,
  });

  double getFinishedPercent() {
    return Utility.getMissionModelFinished(item.datas ?? []).length.toDouble() /
        ((item.datas?.length ?? 0) > 0 ? (item.datas?.length ?? 1) : 1);
  }

  /// 功能：为桌面端 Kanban 列生成低饱和表面色，让每列能继承清单色但不抢任务卡片的视觉层级。
  Color _buildUnifiedColumnSurfaceColor(Color folderTintColor) {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color baseColor = isDark
        ? ColorsConfig.missionGridColumnDarkSurface
        : ColorsConfig.missionGridColumnSurface;
    return Color.alphaBlend(
      folderTintColor.withValues(alpha: isDark ? 0.18 : 0.10),
      baseColor,
    );
  }

  /// 功能：为列体生成参考设计里的半透明色块，空区域也能保留轻微的看板分区感。
  Color _buildUnifiedColumnBoardColor(Color folderTintColor) {
    final bool isDark = ThemeManager.getInstance().isDark();
    final Color baseColor = isDark
        ? ColorsConfig.missionGridColumnDarkBoard
        : ColorsConfig.missionGridColumnBoard;
    return Color.alphaBlend(
      folderTintColor.withValues(alpha: isDark ? 0.20 : 0.14),
      baseColor,
    );
  }

  /// 功能：为列头生成比主体更明确的状态色，避免之前颜色过深导致和正文抢焦点。
  Color _buildUnifiedColumnHeaderColor(Color folderTintColor) {
    final bool isDark = ThemeManager.getInstance().isDark();
    return folderTintColor.withValues(alpha: isDark ? 0.34 : 0.32);
  }

  @override
  Widget build(BuildContext context) {
    // if (!TextUtil.isEmpty(item.folder_id)) {
    //   folderModel = MongoApisManager.getInstance()
    //       .queryfolderModelWithFolderId(item.folder_id);
    // } else if ((item.datas?.length ?? 0) > 0) {
    folderModel = MongoApisManager.getInstance()
        .queryfolderModelWithFolderId(item.folder_id);
    // }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double resolvedHeaderHeight = useUnifiedStyle ? 84 : headerHeight;
      final double resolvedHeaderVerticalGap = useUnifiedStyle ? 3 : 5;
      final Color folderTintColor = Color(folderModel?.color ?? 0xffff8800);
      final Color columnSurfaceColor =
          _buildUnifiedColumnSurfaceColor(folderTintColor);
      final Color columnBoardColor =
          _buildUnifiedColumnBoardColor(folderTintColor);
      final Color columnHeaderColor =
          _buildUnifiedColumnHeaderColor(folderTintColor);
      // print('Stack width: ${constraints.maxWidth}');
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: useUnifiedStyle
            ? buildUnifiedDesktopCardDecoration(
                backgroundColor: columnSurfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: ThemeManager.getInstance().isDark()
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.36),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsConfig.missionGridColumnShadow,
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: folderTintColor.withValues(alpha: 0.10),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              )
            : BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Container(
                  color: folderTintColor.withValues(alpha: 0.20),
                  width: constraints.maxWidth * getFinishedPercent(),
                  height: resolvedHeaderHeight,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: useUnifiedStyle
                        ? columnHeaderColor
                        : Color(
                            (folderModel?.color ?? 0xffff8800) - 0xa0000000),
                    gradient: useUnifiedStyle
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              columnHeaderColor.withValues(alpha: 0.92),
                              columnHeaderColor.withValues(alpha: 0.64),
                            ],
                          )
                        : null,
                  ),
                  height: resolvedHeaderHeight,
                ),
                Container(
                  height: resolvedHeaderHeight,
                  padding: EdgeInsets.symmetric(
                      horizontal: useUnifiedStyle ? 14 : 8,
                      vertical: useUnifiedStyle ? 7 : 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              item.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: subFontSize + 2,
                                  color: ThemeManager.getInstance().isDark()
                                      ? Colors.white
                                      : const Color(0xFF2F251F),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ListingSecurityWidget(
                                folder_id: folderModel?.objectId ?? "",
                                cryptoVersion: folderModel?.cryptoVersion ?? -1,
                                size: 14,
                                marginRight: 4,
                              ),
                              if (folderModel != null)
                                InkWell(
                                  onTap: () {
                                    this
                                        .onTapShowFolderChartListener
                                        .call(folderModel);
                                  },
                                  child: Utility.getSVGPicture(
                                      R.assetsImgIcBarChart,
                                      size: 15),
                                ),
                              if (folderModel != null)
                                SizedBox(
                                  width: 5,
                                ),
                              MissionCustomButton(
                                text: getI18NKey().create,
                                fontSize: 12,
                                color: Color(item.color ?? 0xffff8800),
                                onTapListener: () {
                                  this.onTapCreateListener.call(folderModel);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: resolvedHeaderVerticalGap,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: ThemeManager.getInstance()
                                .getIconColor(defaultColor: subColor),
                          ),
                          Text(
                            Utility.getTimeString(
                                startTime: folderModel?.start_time,
                                endTime: folderModel?.end_time),
                            style: TextStyle(
                                fontSize: subFontSize,
                                color: ThemeManager.getInstance()
                                    .getTextColor(defaultColor: subColor)),
                          ),
                          Spacer(),
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: subFontSize,
                                color: ThemeManager.getInstance()
                                    .getTextColor(defaultColor: subColor)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: resolvedHeaderVerticalGap,
                      ),
                      Row(
                        children: [
                          (item.datas?.length ?? 0) == 0
                              ? SizedBox.shrink()
                              : Text(
                                  getI18NKey().repeative_content(Utility
                                          .getMissionModelRepeativeUnfinished(
                                              item.datas ?? [])
                                      .length),
                                  style: TextStyle(
                                      fontSize: subFontSize,
                                      color: ThemeManager.getInstance()
                                          .getTextColor(
                                              defaultColor: subColor)),
                                ),
                          Spacer(),
                          Text(
                            (item.datas?.length ?? 0) == 0
                                ? getI18NKey().no_data
                                : getI18NKey().num_mission_total(
                                    Utility.getMissionModelFinished(
                                            item.datas ?? [])
                                        .length,
                                    item.datas?.length ?? 0),
                            style: TextStyle(
                                fontSize: subFontSize,
                                color: ThemeManager.getInstance()
                                    .getTextColor(defaultColor: subColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: useUnifiedStyle
                      ? columnBoardColor
                      : ThemeManager.getInstance().getCardBackgroundColor(
                          defaultColor: Color(0xfff0f0f0)),
                  gradient: useUnifiedStyle
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            columnBoardColor.withValues(alpha: 0.96),
                            columnBoardColor.withValues(alpha: 0.76),
                          ],
                        )
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: useUnifiedStyle ? 8 : 0),
                  child: CustomScrollView(slivers: getList()),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> getList() {
    List<Widget> listWidget = [];
    if (useUnifiedStyle && (this.item.datas?.isEmpty ?? true)) {
      listWidget.add(SliverFillRemaining(
        hasScrollBody: false,
        child: _buildUnifiedEmptyState(),
      ));
      return listWidget;
    }
    listWidget.addAll(buildListWidget(
        Utility.getListAfterOrder(
                this.missionOrderEnum,
                Utility.filterMissionModelByFinishedState(
                    list: this.item.datas ?? [], isFinished: false),
                this.folderStatus) ??
            [],
        false));
    listWidget.add(MoreWidget(
      text: getI18NKey().missionCompleted,
      // onTapListener: () {
      //   this.onTapMoreListener.call();
      // },
    ));
    listWidget.addAll(buildListWidget(
        Utility.getListAfterOrder(
                this.missionOrderEnum,
                Utility.filterMissionModelByFinishedState(
                    list: this.item.datas ?? [], isFinished: true),
                this.folderStatus) ??
            [],
        true));
    return listWidget;
  }

  /// 功能：为空看板列提供轻量空状态，避免移动端卡片下半部分大面积灰块显得未完成。
  Widget _buildUnifiedEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Utility.getSVGPicture(R.assetsImgIcNoData, size: 58),
            const SizedBox(height: 12),
            Text(
              getI18NKey().no_task,
              style: ThemeManager.getInstance().getTextStyle(
                defaultTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              getI18NKey().no_mission_desc,
              textAlign: TextAlign.center,
              style: ThemeManager.getInstance().getTextStyle(
                defaultTextStyle: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Color(0xFF777777),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildListWidget(List<SessionMissionModel> list, bool isFinish) {
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      SessionMissionModel model = list[i];
      if ((model.datas?.length ?? 0) > 0) {
        listWidget.add(SliverToBoxAdapter(
          child: GridSectionTitleWidget(
            title: model.title ?? "",
          ),
        ));
        listWidget.add(GridMissionSilverList(
          datas: Utility.parseMissionModelsByIsFinishedAndPriority(
              model.datas ?? []),
          useUnifiedStyle: useUnifiedStyle,
          onTapListener: (v) {
            this.onTapListener.call(v);
          },
          onTapDoItNow: (v) {
            this.onTapDoItNow?.call(v);
          },
          multiSelectModeEnum: this.multiSelectModeEnum,
          onTapMultiSelectListener: (MissionModel? list) {
            this.onTapMultiSelectListener?.call(list);
          },
          //未完成任务列表
          onTapUnFinishListener: (data) {
            this.onTapUnFinishListener?.call(data);
          },
          onTapEditTitleListener: (obj) {
            this.onTapEditTitleListener?.call(obj);
          },
          onTapPlayListener: (obj) {
            this.onTapPlayListener?.call(obj);
          },
          onTapDeleteListener: (data) async {
            this.onTapDeleteListener?.call(data);
          },
          onTapEditListener: (data) {
            this.onTapEditListener?.call(data);
          },
          onTapFinishListener: (data) {
            this.onTapFinishListener?.call(data);
          },
        ));
      }
    }
    return listWidget;
    // return [
    //   SliverPadding(padding: EdgeInsets.only(top: 3)),
    //   SliverToBoxAdapter(
    //     child: SectionTitleWidget(
    //       title: '优先级',
    //     ),
    //   ),
    //
    // ];
  }
}
