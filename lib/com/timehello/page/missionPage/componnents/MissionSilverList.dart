/**
 * 文件类型：任务列表组件
 * 文件作用：负责渲染普通列表模式下的任务分组内容，并处理完成、播放、编辑、侧滑等交互入口。
 * 主要职责：在保留旧列表和桌面统一样式的同时，为手机端提供更贴近新版视觉的圆角卡片列表。
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/components/StateImage.dart';
import 'package:time_hello/com/timehello/components/unified/UnifiedDesktopShell.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../components/IsNoteWidget.dart';
import '../../../components/ListingSecurityWidget.dart';
import '../../../components/MissionCountDownTextWidget.dart';
import '../../../components/SliderWithCanvasWidget.dart';
import '../../../components/SubmissionColumnList.dart';
import '../../../config/ENUMS.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/WidgetManager.dart';
import 'MissionMobileListStyleHelper.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapEditTitleListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapPlayListener = void Function(dynamic obj);
typedef OnTapUnFinishListener = void Function(dynamic obj);
typedef OnTapMultiSelectListener = void Function(MissionModel? obj);

class MissionSilverList extends StatefulWidget {
  List? _datas = [];
  OnTapListener? onTapListener;
  MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  Function? onTapDoItNow;
  bool? isSlideEnable;
  MultiSelectModeEnum multiSelectModeEnum;
  bool useUnifiedStyle;
  bool useMobileModernStyle;

  MissionSilverList(
      {Key? key,
      List? datas,
      OnTapListener? onTapListener,
      this.multiSelectModeEnum = MultiSelectModeEnum.normal,
      this.onTapMultiSelectListener,
      this.onTapFinishListener,
      this.onTapDoItNow,
      this.onTapUnFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.isSlideEnable = true,
      this.useUnifiedStyle = false,
      this.useMobileModernStyle = false})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this._datas = datas;
  }

  set datas(List datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new MissionSilverState();
  }
}

class MissionSilverState extends State<MissionSilverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return MissionSilverListItem(
          useUnifiedStyle: widget.useUnifiedStyle,
          useMobileModernStyle: widget.useMobileModernStyle,
          multiSelectModeEnum: this.widget.multiSelectModeEnum,
          isSlideEnable: this.widget.isSlideEnable ?? false,
          onTapListener: this.widget.onTapListener,
          index: index,
          missionModel: this.widget._datas?[index],
          onTapDoItNow: this.widget.onTapDoItNow,
          onTapUnFinishListener: this.widget.onTapUnFinishListener,
          onTapEditTitleListener: this.widget.onTapEditTitleListener,
          onTapEditListener: this.widget.onTapEditListener,
          onTapDeleteListener: this.widget.onTapDeleteListener,
          onTapFinishListener: this.widget.onTapFinishListener,
          onTapMultiSelectListener: this.widget.onTapMultiSelectListener,
          onTapPlayListener: this.widget.onTapPlayListener,
        );
      }, childCount: this.widget._datas?.length ?? 0),
    );
  }
}

class MissionSilverListItem extends StatefulWidget {
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  int index = 0;
  bool isVisible = false;
  bool isSlideEnable = true;
  MissionModel? _missionModel;
  OnTapFinishListener? onTapFinishListener;
  Function? onTapDoItNow;

  OnTapMultiSelectListener? onTapMultiSelectListener;
  OnTapUnFinishListener? onTapUnFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapEditTitleListener? onTapEditTitleListener;
  MultiSelectModeEnum multiSelectModeEnum;
  bool useUnifiedStyle;
  bool useMobileModernStyle;

  // Map<int, Image> map = {};
  MissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      OnTapListener? onTapListener,
      MissionModel? missionModel,
      int index = 0,
      required this.multiSelectModeEnum,
      this.onTapMultiSelectListener,
      this.onTapDoItNow,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.onTapUnFinishListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.isSlideEnable = false,
      this.useUnifiedStyle = false,
      this.useMobileModernStyle = false})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this.index = index;
    this.isVisible = isVisible;
    this._missionModel = missionModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw MenuSilverListItem(onTapListener);
    return MissionSilverListItemState();
  }
}

class MissionSilverListItemState extends State<MissionSilverListItem> {
  bool isHover = false;
  double height = 125;
  ImageProvider? imageProvider;
  double fontSize = Utility.isHandsetBySize() ? 11 : 12;
  double space = 15;
  MissionModel? tmpMissionModel;
  FolderModel? getFolderModel(MissionModel? missionModel) {
    if (!TextUtil.isEmpty(this.widget._missionModel?.folder_id)) {
      List<FolderModel> wqbFolderModelList = MongoApisManager.getInstance()
          .queryWhereEqual_folderModelWithFolderId(
              this.widget._missionModel?.folder_id);
      if (wqbFolderModelList.length > 0) {
        return wqbFolderModelList[0];
      }
    }
    return null;
  }

  bool isDoItNow(MissionModel? _missionModel) =>
      (_missionModel != null && Utility.isDoingItNow(_missionModel));
  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );

  bool _isUnifiedObjectiveCard(MissionModel? missionModel) {
    return widget.useUnifiedStyle &&
        Utility.getMissionModelEnumByType(missionModel: missionModel) ==
            MissionModelEnum.objective;
  }

  double _getObjectiveSliderValue(MissionModel? missionModel) {
    if (missionModel == null) {
      return 0;
    }
    final double min = missionModel.objectiveStartValue ?? 0;
    final double max = missionModel.objectiveTotalValue ?? 0;
    if (max <= min) {
      return min;
    }
    return (missionModel.objectiveValue ?? 0).clamp(min, max).toDouble();
  }

  String _getObjectiveProgressLabel(MissionModel? missionModel) {
    final int current = missionModel?.objectiveValue?.toInt() ?? 0;
    final int total = missionModel?.objectiveTotalValue?.toInt() ?? 0;
    final String unit = missionModel?.objectiveUnit ?? "";
    return "$current / $total ${TextUtil.isEmpty(unit) ? getI18NKey().unitMissions : unit}";
  }

  void _handleObjectiveSliderChange(MissionModel? missionModel, double value) {
    if (missionModel == null) {
      return;
    }
    missionModel.objectiveValue = value;
    if ((missionModel.objectiveTotalValue ?? 0) > 0) {
      missionModel.isFinished =
          (missionModel.objectiveTotalValue ?? 0) <= value;
    }
    tmpMissionModel = missionModel;
    funcDebounceWithUpdateSliderVal(this);
    setState(() {});
  }

  Widget _buildUnifiedObjectiveCardContent(
      MissionModel? missionModel, FolderModel? folderModel, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 18, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionModel?.title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeManager.getInstance().getTextStyle(
                    defaultTextStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F2A26),
                    ),
                  ),
                ),
                if (folderModel != null) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      WidgetManager.getFolderModelIcon(folderModel, 12) ??
                          const SizedBox.shrink(),
                      Text(
                        folderModel.title ?? "",
                        style: ThemeManager.getInstance().getTextStyle(
                          defaultTextStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E7E6F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 156,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "目标进度",
                            style: ThemeManager.getInstance().getTextStyle(
                              defaultTextStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF66754B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            missionModel?.objectivePercentString ?? "0.0%",
                            style: ThemeManager.getInstance().getTextStyle(
                              defaultTextStyle: TextStyle(
                                fontSize: 18,
                                height: 1,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: PopupMenuButton<String>(
                        tooltip: '',
                        padding: EdgeInsets.zero,
                        iconSize: 15,
                        icon: Icon(
                          Icons.more_vert,
                          color: ThemeManager.getInstance().getIconColor(
                            defaultColor: const Color(0xFF8C8175),
                          ),
                        ),
                        onCanceled: () {},
                        itemBuilder: (context) {
                          if (missionModel?.isFinished == false) {
                            return getUnfinishedPopupList(
                                missionModel ?? MissionModel());
                          } else {
                            return getFinishedPopupList(
                                missionModel ?? MissionModel());
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // thumb 半径保持恒定，只切换透明度；否则 hover 时 Flutter 会重算 track inset，滑条左端会抖动。
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5,
                    activeTrackColor: accentColor.withValues(alpha: 0.92),
                    inactiveTrackColor: accentColor.withValues(alpha: 0.16),
                    thumbColor: isHover ? accentColor : Colors.transparent,
                    overlayColor: Colors.transparent,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 0,
                    ),
                  ),
                  child: SizedBox(
                    height: 14,
                    child: Slider(
                      value: _getObjectiveSliderValue(missionModel),
                      min: missionModel?.objectiveStartValue ?? 0,
                      max: (missionModel?.objectiveTotalValue ?? 0) <=
                              (missionModel?.objectiveStartValue ?? 0)
                          ? (missionModel?.objectiveStartValue ?? 0) + 1
                          : (missionModel?.objectiveTotalValue ?? 0),
                      onChanged: (missionModel?.objectiveTotalValue ?? 0) > 0
                          ? (value) =>
                              _handleObjectiveSliderChange(missionModel, value)
                          : null,
                    ),
                  ),
                ),
                Text(
                  _getObjectiveProgressLabel(missionModel),
                  style: ThemeManager.getInstance().getTextStyle(
                    defaultTextStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: accentColor.withValues(alpha: 0.88),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedTextProtectionOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xF7FFFDF8),
                const Color(0xDEFFFDF8),
                const Color(0x9CFFFDF8),
                const Color(0x30FFFDF8),
                const Color(0x00FFFDF8),
              ],
              stops: const [0.0, 0.22, 0.42, 0.68, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  /**
   * 功能：统一处理任务卡片点击。
   * 说明：移动端新版列表和旧列表都走这里，避免多选模式下的选择逻辑出现两套行为。
   */
  void _handleMissionTap(MissionModel? missionModel) {
    if (this.widget.multiSelectModeEnum == MultiSelectModeEnum.multiSelect) {
      if (this.widget.onTapMultiSelectListener != null) {
        missionModel?.isSelected = missionModel.isSelected ? false : true;
        this.widget.onTapMultiSelectListener?.call(missionModel);
        setState(() {});
      }
      return;
    }
    if (this.widget.onTapListener != null) {
      this.widget.onTapListener!(missionModel);
    }
  }

  /**
   * 功能：构建手机端新版列表任务卡。
   * 说明：该分支只在 MissionPage 显式传入 useMobileModernStyle 时启用，避免影响旧列表和桌面端统一样式。
   */
  Widget _buildMobileModernMissionItem({
    required MissionModel? missionModel,
    required Color priorityAccentColor,
  }) {
    final MissionMobileListStyleMetrics metrics =
        MissionMobileListStyleHelper.mobileModernMetrics;
    final bool isObjective =
        Utility.getMissionModelEnumByType(missionModel: missionModel) ==
            MissionModelEnum.objective;
    final bool isSelected = this.widget._missionModel?.isSelected == true;

    return Slidable(
      key: ValueKey(missionModel),
      enabled: DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: ratio,
        children: missionModel?.isFinished == false
            ? getUnfinishIconSlideActions(missionModel ?? MissionModel())
            : getFinishIconSlideActions(missionModel ?? MissionModel()),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(metrics.cardRadius),
        onTap: () {
          _handleMissionTap(missionModel);
        },
        child: Container(
          margin: metrics.cardMargin,
          // 普通任务按内容自然撑开，避免固定最小高度把底部留白撑大；目标任务仍保留进度面板需要的高度。
          constraints: BoxConstraints(
            minHeight: isObjective ? metrics.cardMinHeight : 0,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ThemeManager.getInstance().getCardBackgroundColor(
              defaultColor: Colors.white,
            ),
            borderRadius: BorderRadius.circular(metrics.cardRadius),
            border: Border.all(
              width:
                  this.widget.multiSelectModeEnum == MultiSelectModeEnum.normal
                      ? 0.5
                      : (isSelected ? 2.0 : 0.5),
              color:
                  this.widget.multiSelectModeEnum == MultiSelectModeEnum.normal
                      ? const Color(0xFFF0F0F0)
                      : (isSelected
                          ? priorityAccentColor
                          : const Color(0xFFF0F0F0)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.72),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 移动端现代列表补齐桌面端同款优先级识别色，方便用户扫列表时快速区分象限。
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 6,
                  color: priorityAccentColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  isObjective ? 14 : 10,
                  12,
                  isObjective ? 14 : 10,
                ),
                child: isObjective
                    ? _buildMobileModernObjectiveContent(
                        missionModel: missionModel,
                        accentColor: priorityAccentColor,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildMobileModernCheckButton(missionModel),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMobileModernTitleLine(missionModel),
                                const SizedBox(height: 8),
                                _buildMobileModernMetaRow(missionModel),
                                if ((missionModel?.subMissions?.length ?? 0) >
                                    0) ...[
                                  const SizedBox(height: 8),
                                  SubmissionColumnList(
                                    missionModel:
                                        missionModel ?? MissionModel(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildMobileModernPlayButton(
                              missionModel, isObjective),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * 功能：构建移动端目标任务卡片内容。
   * 说明：目标任务不显示普通完成圈和开始按钮，右侧改为 PC 端同款目标进度区。
   */
  Widget _buildMobileModernObjectiveContent({
    required MissionModel? missionModel,
    required Color accentColor,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 320;
        final double progressWidth = compact ? 124 : 156;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    missionModel?.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeManager.getInstance().getTextStyle(
                      defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 17 : 18,
                        height: 1.18,
                        decoration: missionModel?.isFinished == true
                            ? TextDecoration.lineThrough
                            : null,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: const Color(0xffa0a0a0),
                        decorationThickness: 2,
                        color: const Color(0xFF252525),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMobileModernMetaRow(missionModel),
                ],
              ),
            ),
            SizedBox(width: compact ? 10 : 16),
            SizedBox(
              width: progressWidth,
              child: _buildMobileModernObjectiveProgressPanel(
                missionModel: missionModel,
                accentColor: accentColor,
              ),
            ),
          ],
        );
      },
    );
  }

  /**
   * 功能：构建移动端目标任务进度面板。
   * 说明：滑条沿用 PC 端目标进度交互，用户可直接在列表里拖动更新 objectiveValue。
   */
  Widget _buildMobileModernObjectiveProgressPanel({
    required MissionModel? missionModel,
    required Color accentColor,
  }) {
    final MissionMobileObjectiveProgressData progressData =
        MissionMobileListStyleHelper.buildObjectiveProgressData(missionModel);
    final bool canEditProgress = (missionModel?.objectiveTotalValue ?? 0) > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "目标进度",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ThemeManager.getInstance().getTextStyle(
                  defaultTextStyle: const TextStyle(
                    fontSize: 11,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF66754B),
                  ),
                ),
              ),
            ),
            if (this.widget.onTapEditTitleListener != null)
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  this.widget.onTapEditTitleListener?.call(missionModel);
                },
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.edit_square,
                    size: 16,
                    color: Color(0xFF9A9A9A),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          progressData.percentText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ThemeManager.getInstance().getTextStyle(
            defaultTextStyle: TextStyle(
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
        ),
        const SizedBox(height: 5),
        // 移动端这里必须保留可见 thumb，否则 0% 的目标任务看起来像没有进度条。
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            activeTrackColor: accentColor.withValues(alpha: 0.92),
            inactiveTrackColor: accentColor.withValues(alpha: 0.18),
            disabledActiveTrackColor: accentColor.withValues(alpha: 0.28),
            disabledInactiveTrackColor: accentColor.withValues(alpha: 0.12),
            thumbColor: canEditProgress ? accentColor : const Color(0xFFB8B8B8),
            disabledThumbColor: const Color(0xFFB8B8B8),
            overlayColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
          ),
          child: SizedBox(
            height: 18,
            child: Slider(
              value: progressData.sliderValue,
              min: progressData.sliderMin,
              max: progressData.sliderMax,
              onChanged: canEditProgress
                  ? (double value) {
                      _handleObjectiveSliderChange(missionModel, value);
                    }
                  : null,
            ),
          ),
        ),
        Text(
          progressData.countText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ThemeManager.getInstance().getTextStyle(
            defaultTextStyle: TextStyle(
              fontSize: 11,
              height: 1,
              fontWeight: FontWeight.w700,
              color: accentColor.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  /**
   * 功能：构建新版移动端的完成勾选按钮。
   */
  Widget _buildMobileModernCheckButton(MissionModel? missionModel) {
    return CheckImage(
      width: 34,
      height: 34,
      isSizeConfigured: true,
      onTapListener: (res) {
        if (missionModel?.isFinished == true) {
          this.widget.onTapUnFinishListener?.call(missionModel);
        } else {
          this.widget.onTapFinishListener?.call(missionModel);
        }
      },
      checked: missionModel?.isFinished ?? false,
      checkIcon: Icon(
        Icons.check_circle,
        size: 24,
        color: ColorsConfig.calendar_green,
      ),
      uncheckIcon: const Icon(
        Icons.radio_button_unchecked_outlined,
        color: Color(0xFF969696),
        size: 30,
      ),
    );
  }

  /**
   * 功能：构建新版移动端任务标题行。
	 * 说明：保留标签、笔记和子任务标识；移动端允许标题换到两行，避免长标题被过早截断。
	 */
  Widget _buildMobileModernTitleLine(MissionModel? missionModel) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: missionModel?.title ?? "",
                  style: ThemeManager.getInstance().getTextStyle(
                    defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      height: 1.18,
                      decoration: missionModel?.isFinished == true
                          ? TextDecoration.lineThrough
                          : null,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationColor: const Color(0xffa0a0a0),
                      decorationThickness: 2,
                      color: const Color(0xFF252525),
                    ),
                  ),
                ),
                ...WidgetManager.getTagsWidgetSpan(
                  missionModel ?? MissionModel(),
                  fontSize: 14,
                ),
                ...WidgetManager.getIsNoteWidget(
                  missionModel ?? MissionModel(),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (this.widget.onTapEditTitleListener != null) ...[
          const SizedBox(width: 6),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              this.widget.onTapEditTitleListener?.call(missionModel);
            },
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.edit_square,
                size: 17,
                color: Color(0xFF9A9A9A),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /**
   * 功能：构建新版移动端任务元信息行。
   * 说明：番茄数、日期和价值信息仍复用原字段，只调整字号和间距。
   */
  Widget _buildMobileModernMetaRow(MissionModel? missionModel) {
    final List<Widget> metaChildren = [];
    if (Utility.shouldShowTomatoes(
            missionModelType: missionModel?.missionModelType) &&
        Utility.getMissionModelEnumByType(missionModel: missionModel) !=
            MissionModelEnum.objective) {
      metaChildren.add(RatingBar(
        size: 12,
        curNumber: missionModel?.no_tomotoes_finished ?? 0,
        number: missionModel?.total_tomotoes ?? 0,
      ));
      metaChildren.add(const SizedBox(width: 10));
    }
    if (missionModel != null) {
      metaChildren.addAll(_getMobileModernDateWidgets(missionModel));
      metaChildren.add(const SizedBox(width: 10));
    }
    if (missionModel?.mission_value != null) {
      metaChildren.add(Text(
        getI18NKey().value(missionModel?.mission_value ?? "") +
            getI18NKey().dollar +
            "(" +
            getI18NKey().value_per_hour(
                Utility.getMissionValuePerHourByMissionModel(
                    missionModel: missionModel!)) +
            ")",
        style: TextStyle(
          color: ColorsConfig.colorGold,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ));
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 5,
      children: metaChildren,
    );
  }

  List<Widget> _getMobileModernDateWidgets(MissionModel missionModel) {
    final String dateText = missionModel.time_mode == 1
        ? CONSTANTS.getSegmentDateStringSubtitleByMissionModel(missionModel)
        : CONSTANTS.getDateStringSubtitle(missionModel);
    if (TextUtil.isEmpty(dateText)) {
      return [];
    }
    return [
      Icon(
        Icons.calendar_today_rounded,
        color: ColorsConfig.darkRed,
        size: 13,
      ),
      const SizedBox(width: 4),
      Text(
        dateText,
        style: TextStyle(
          fontSize: 14,
          height: 1.18,
          fontWeight: FontWeight.w600,
          color: ColorsConfig.darkRed,
        ),
      ),
    ];
  }

  /**
   * 功能：构建新版移动端任务开始按钮。
   */
  Widget _buildMobileModernPlayButton(
      MissionModel? missionModel, bool isObjective) {
    if (isObjective || missionModel?.isFinished == true) {
      return const SizedBox.shrink();
    }
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        this.widget.onTapPlayListener?.call(missionModel);
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFFF4B43),
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Color(0xFFFF4B43),
          size: 28,
        ),
      ),
    );
  }

  Widget getSliderValue({required MissionModel missionModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          missionModel.objectivePercentString ?? "",
          style: TextStyle(
            fontSize: 13,
            color: ThemeManager.getInstance().isDark()
                ? Colors.white
                : Colors.black,
          ),
        ),
        Text(
          "${missionModel?.objectiveValue?.toInt() ?? 0}/${missionModel?.objectiveTotalValue?.toInt()} ${missionModel?.objectiveUnit}",
          style: TextStyle(
            fontSize: 10,
            color: ThemeManager.getInstance().isDark()
                ? Colors.white70
                : Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MissionModel? _missionModel = this.widget._missionModel;
    FolderModel? folderModel = getFolderModel(_missionModel);
    bool isDoItNow = this.isDoItNow(_missionModel);
    final Color priorityAccentColor =
        Color(CONSTANTS.getPriorityColor(_missionModel?.priorityStatus ?? 3));
    final bool isUnifiedObjectiveCard = _isUnifiedObjectiveCard(_missionModel);
    final bool isMobileModernList =
        widget.useMobileModernStyle && Utility.isHandsetBySize();

    if (isMobileModernList) {
      return _buildMobileModernMissionItem(
        missionModel: _missionModel,
        priorityAccentColor: priorityAccentColor,
      );
    }

    // TODO: implement build
    //左边文案和角标
    List<Widget> childrenRow = <Widget>[
      if (widget.useUnifiedStyle)
        const SizedBox(
          width: 18,
        )
      else ...[
        Container(
            height: 30,
            width: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: priorityAccentColor,
            )),
        const SizedBox(
          width: 5,
        ),
      ],
      if (Utility.getMissionModelEnumByType(missionModel: _missionModel) !=
          MissionModelEnum.objective)
        Container(
            // margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: CheckImage(
          width: 40,
          height: 40,
          isSizeConfigured: true,
          onTapListener: (res) {
            if (_missionModel?.isFinished == true) {
              if (this.widget.onTapUnFinishListener != null)
                this.widget.onTapUnFinishListener?.call(_missionModel);
            } else {
              if (this.widget.onTapFinishListener != null)
                this.widget.onTapFinishListener!(_missionModel);
            }
          },
          checked: _missionModel?.isFinished ?? false,
          checkIcon: Icon(Icons.check_circle,
              size: 20, color: ColorsConfig.calendar_green),
          uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
              color: ColorsConfig.gray_a7, size: 20),
        )),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: this.widget._missionModel?.title ?? "" ?? "",
                      style: ThemeManager.getInstance().getTextStyle(
                          defaultTextStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              decoration: _missionModel?.isFinished == true
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Color(0xffa0a0a0),
                              decorationThickness: 2,
                              color: ColorsConfig.gray_40))),
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          if ((_missionModel?.subMissions?.length ?? 0) >
                              0) ...[
                            Utility.getSVGPicture(R.assetsImgIcSubmission,
                                size: 14),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              _missionModel?.subMissions?.length.toString() ??
                                  "0",
                              textAlign: TextAlign.left,
                              style: ThemeManager.getInstance().getTextStyle(
                                  defaultTextStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xff9DA7B2))),
                            ),
                          ],
                        ],
                      )),
                  ...WidgetManager.getTagsWidgetSpan(
                      _missionModel ?? MissionModel(),
                      fontSize: 14),
                  ...WidgetManager.getIsNoteWidget(
                    _missionModel ?? MissionModel(),
                  ),
                ])),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SubmissionColumnList(
                    missionModel: _missionModel ?? MissionModel(),
                  ),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SizedBox(
                    height: 3,
                  ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (Utility.shouldShowTomatoes(
                        missionModelType: _missionModel?.missionModelType))
                      if (Utility.getMissionModelEnumByType(
                              missionModel: _missionModel) !=
                          MissionModelEnum.objective)
                        RatingBar(
                          size: this.fontSize,
                          curNumber: _missionModel?.no_tomotoes_finished ?? 0,
                          number: _missionModel?.total_tomotoes ?? 0,
                        ),
                    if (Utility.shouldShowTomatoes(
                        missionModelType: _missionModel?.missionModelType))
                      SizedBox(
                        width: this.space,
                      ),
                    if (_missionModel?.time_mode == 1)
                      ...getSegmentdateWidget(_missionModel ?? MissionModel()),
                    if (_missionModel?.time_mode == 0 ||
                        _missionModel?.time_mode == null)
                      ...getDateWidget(_missionModel ?? MissionModel()),
                    // Icon(
                    //   Icons.calendar_today_rounded,
                    //   color: ColorsConfig.darkRed,
                    //   size: this.fontSize,
                    // ),
                    // SizedBox(width: 2),
                    // Text(
                    //   CONSTANTS.getDateStringSubtitle(
                    //       _missionModel ?? MissionModel()),
                    //   style: TextStyle(
                    //       fontSize: this.fontSize, color: ColorsConfig.darkRed),
                    // ),
                    SizedBox(
                      width: this.space,
                    ),
                    if (this.widget._missionModel?.mission_value != null)
                      Text(
                        getI18NKey().value(
                                this.widget._missionModel?.mission_value ??
                                    "") +
                            getI18NKey().dollar +
                            "(" +
                            getI18NKey().value_per_hour(
                                Utility.getMissionValuePerHourByMissionModel(
                                    missionModel: this.widget._missionModel!)) +
                            ")",
                        style: TextStyle(
                            color: ColorsConfig.colorGold,
                            fontSize: this.fontSize),
                      )
                    // SizedBox(width: 2),
                    // Row(
                    //   children: [
                    //
                    //   ],
                    // )
                  ],
                ),
              ]),
          flex: 3),
      // 完成不需要显示
      if (Utility.getMissionModelEnumByType(missionModel: _missionModel) !=
          MissionModelEnum.objective)
        _missionModel?.isFinished == true
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.fromLTRB(
                    0, 0, widget.useUnifiedStyle ? 14 : 10, 0),
                child: widget.useUnifiedStyle
                    ? InkWell(
                        onTap: () {
                          if (this.widget.onTapPlayListener != null) {
                            this.widget.onTapPlayListener!(_missionModel);
                          }
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFF2E1),
                            border: Border.all(color: const Color(0xFFE3C7AA)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            getI18NKey().start_focus,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.05,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5E412F),
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (this.widget.onTapPlayListener != null) {
                            this.widget.onTapPlayListener!(_missionModel);
                          }
                        },
                        icon: Icon(
                          Icons.play_circle_outline,
                          color: Color(0xfffd5553),
                        ))),
      if (Utility.getMissionModelEnumByType(missionModel: _missionModel) ==
          MissionModelEnum.objective)
        this.getSliderValue(missionModel: _missionModel ?? MissionModel()),
      DeviceInfoManagement.isMoible() == false
          ? SizedBox(
              width: 15,
            )
          : SizedBox(
              width: 0,
            )
    ];
    return Slidable(
      key: ValueKey(_missionModel),
      enabled: DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: ratio,
        children: _missionModel?.isFinished == false
            ? getUnfinishIconSlideActions(_missionModel ?? MissionModel())
            : getFinishIconSlideActions(_missionModel ?? MissionModel()),
      ),
      child: InkWell(
        onTap: () {
          if (this.widget.multiSelectModeEnum ==
              MultiSelectModeEnum.multiSelect) {
            if (this.widget.onTapMultiSelectListener != null) {
              _missionModel?.isSelected =
                  _missionModel.isSelected ? false : true;
              this.widget.onTapMultiSelectListener?.call(_missionModel);
              setState(() {});
            }
          } else {
            if (this.widget.onTapListener != null) {
              this.widget.onTapListener!(_missionModel);
            }
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              this.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              this.isHover = false;
            });
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: widget.useUnifiedStyle ? 8 : 2,
              left: CONSTANTS.missionPageMargin +
                  (widget.useUnifiedStyle ? 10 : 0),
              right: CONSTANTS.missionPageMargin,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.useUnifiedStyle)
                  Positioned(
                    left: -10,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 23,
                      decoration: BoxDecoration(
                        color: priorityAccentColor.withValues(alpha: 0.48),
                        boxShadow: [
                          BoxShadow(
                            color: priorityAccentColor.withValues(alpha: 0.16),
                            blurRadius: 12,
                            offset: const Offset(-2, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
                      ),
                    ),
                  ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: widget.useUnifiedStyle
                      ? buildUnifiedDesktopCardDecoration(
                          backgroundColor:
                              ThemeManager.getInstance().getCardBackgroundColor(
                            defaultColor:
                                ColorsConfig.missionTaskCardBackground,
                            alpha: 150,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: this.widget.multiSelectModeEnum ==
                                  MultiSelectModeEnum.normal
                              ? Border.all(
                                  width: 0,
                                  color: Colors.transparent,
                                )
                              : Border.all(
                                  width:
                                      this.widget._missionModel?.isSelected ==
                                              true
                                          ? 2.0
                                          : 0,
                                  color: Color(
                                    CONSTANTS.getPriorityColor(
                                            _missionModel?.priorityStatus ??
                                                3) -
                                        (this
                                                    .widget
                                                    ._missionModel
                                                    ?.isSelected ==
                                                true
                                            ? 0x00000000
                                            : 0x00000000),
                                  ),
                                ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  priorityAccentColor.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(-3, 6),
                            ),
                            BoxShadow(
                              color: ColorsConfig.missionTaskCardShadow,
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.65),
                              blurRadius: 10,
                              offset: const Offset(-2, -2),
                            ),
                          ],
                        ).copyWith(
                          image: imageProvider == null
                              ? null
                              : DecorationImage(
                                  image: imageProvider!,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    ThemeManager.getInstance()
                                        .getCardBackgroundColor(
                                      defaultColor: Colors.white,
                                      alpha: 150,
                                    ),
                                    BlendMode.colorBurn,
                                  ),
                                ),
                        )
                      : BoxDecoration(
                          border: this.widget.multiSelectModeEnum ==
                                  MultiSelectModeEnum.normal
                              ? Border.all(
                                  width: 1.0,
                                  color:
                                      ThemeManager.getInstance().getShadowColor(
                                    defaultColor: Color(0xfff0f0f0),
                                    defaultDarkColor: ColorsConfig
                                        .standardBorderLineColorDarkMode,
                                  ),
                                )
                              : Border.all(
                                  width: 2.0,
                                  color: Color(
                                    CONSTANTS.getPriorityColor(
                                            _missionModel?.priorityStatus ??
                                                3) -
                                        (this
                                                    .widget
                                                    ._missionModel
                                                    ?.isSelected ==
                                                true
                                            ? 0x00000000
                                            : 0xe0000000),
                                  ),
                                ),
                          image: imageProvider == null
                              ? null
                              : DecorationImage(
                                  image: imageProvider!,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    ThemeManager.getInstance()
                                        .getCardBackgroundColor(
                                      defaultColor: Colors.white,
                                      alpha: 150,
                                    ),
                                    BlendMode.colorBurn,
                                  ),
                                ),
                          color:
                              ThemeManager.getInstance().getCardBackgroundColor(
                            defaultColor: Colors.white,
                            alpha: 150,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                  child: Stack(
                    children: [
                      TextUtil.isEmpty(_missionModel?.background_url ?? "")
                          ? SizedBox.shrink()
                          : CachedNetworkImage(
                              imageUrl: Utility.filterHttpUrl(
                                _missionModel?.background_url ?? '',
                                prefix: "oss",
                              ),
                              imageBuilder: (context, imageProviderTmp) {
                                Future.delayed(Duration(seconds: 0), () {
                                  imageProvider = imageProviderTmp;
                                  if (mounted) {
                                    // setState(() {});
                                  }
                                });
                                return Container();
                              },
                            ),
                      if (widget.useUnifiedStyle &&
                          TextUtil.isEmpty(
                                  _missionModel?.background_url ?? "") ==
                              false)
                        _buildUnifiedTextProtectionOverlay(),
                      Container(
                        color: widget.useUnifiedStyle
                            ? Colors.transparent
                            : ThemeManager.getInstance().getCardBackgroundColor(
                                defaultColor: Color(0xb0ffffff),
                                alpha: 150,
                              ),
                        constraints: BoxConstraints(
                            minHeight: isUnifiedObjectiveCard
                                ? 92
                                : (widget.useUnifiedStyle ? 86 : 66)),
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        alignment: Alignment.centerLeft,
                        child: isUnifiedObjectiveCard
                            ? _buildUnifiedObjectiveCardContent(
                                _missionModel,
                                folderModel,
                                priorityAccentColor,
                              )
                            : Stack(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: childrenRow,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                if (!isUnifiedObjectiveCard)
                  Positioned(
                    right: 3,
                    top: 0,
                    child: this.isHover == true
                        ? Container(
                            width: 30,
                            height: 30,
                            child: PopupMenuButton<String>(
                              tooltip: '',
                              iconSize: 14,
                              icon: Icon(
                                Icons.more_vert,
                                color: ThemeManager.getInstance().getIconColor(
                                  defaultColor: Color(0xff909090),
                                ),
                              ),
                              onCanceled: () {},
                              itemBuilder: (context) {
                                if (_missionModel?.isFinished == false) {
                                  return getUnfinishedPopupList(
                                      _missionModel ?? MissionModel());
                                } else {
                                  return getFinishedPopupList(
                                      _missionModel ?? MissionModel());
                                }
                              },
                            ),
                          )
                        : isDoItNow
                            ? MissionCountDownTextWidget(
                                fontSize: 12,
                                color: 0xff909090,
                                end_time: _missionModel?.do_it_now?[0]
                                    ['end_time'] as int,
                                end_buffer_time: _missionModel?.do_it_now?[0]
                                    ['buffer_end_time'],
                                isFinished: _missionModel?.isFinished ?? false,
                              )
                            : ListingSecurityWidget(
                                missionModdel_id: _missionModel?.objectId,
                                folder_id: _missionModel?.folder_id ?? "",
                                cryptoVersion:
                                    _missionModel?.cryptoVersion ?? -1,
                                marginRight: 5,
                                marginTop: 5,
                                size: 14,
                              ),
                  ),
                if (!isUnifiedObjectiveCard &&
                    Utility.isObjectiveForMissionModel(
                        missionModel: _missionModel ?? MissionModel()))
                  Positioned(
                    bottom: 3,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 5,
                          child: SliderWithCanvasWidget(
                            onChange: (double value) {
                              _missionModel?.objectiveValue = value;
                              if ((_missionModel?.objectiveTotalValue ?? 0) >
                                  0) {
                                if ((_missionModel?.objectiveTotalValue ?? 0) <=
                                    value) {
                                  _missionModel?.isFinished = true;
                                } else {
                                  _missionModel?.isFinished = false;
                                }
                              }
                              tmpMissionModel = _missionModel;
                              // MongoApisManager.getInstance().update_MissionModel(
                              //     missionModel: _missionModel ?? MissionModel());
                              funcDebounceWithUpdateSliderVal(this);
                              setState(() {});
                            },
                            min: _missionModel?.objectiveStartValue ?? 0,
                            max: _missionModel?.objectiveTotalValue ?? 0,
                            curVal: _missionModel?.objectiveValue,
                            // onChange: (double value) {},
                          ),
                        ),
                        folderModel == null
                            ? SizedBox.shrink()
                            : WidgetManager.getFolderModelIcon(
                                    folderModel!, 12) ??
                                SizedBox.shrink(),
                        SizedBox(width: 4),
                        Text(
                          folderModel?.title ?? "",
                          style: ThemeManager.getInstance().getTextStyle(
                            defaultTextStyle: TextStyle(
                              fontSize: 10,
                              color: Color(0xff666666),
                            ),
                          ),
                        ),
                        // Wrap(
                        //   children: [
                        //     folderModel == null
                        //         ? SizedBox.shrink()
                        //         : WidgetManager.getFolderModelIcon(
                        //         folderModel!, 12) ??
                        //         SizedBox.shrink(),
                        //     SizedBox(width: 4),
                        //     Text(
                        //       folderModel?.title ?? "",
                        //       style: ThemeManager.getInstance().getTextStyle(
                        //         defaultTextStyle: TextStyle(
                        //           fontSize: 10,
                        //           color: Color(0xff666666),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getSegmentdateWidget(MissionModel _missionModel) {
    if (_missionModel.objectId == '65c079ec59321612ecbbb6da' ||
        _missionModel.objectId == '65c079aa59321612ecbbb6c5') {
      print('getSegmentdateWidget');
    }
    return [
      Icon(
        Icons.calendar_today_rounded,
        color: ColorsConfig.darkRed,
        size: this.fontSize,
      ),
      SizedBox(width: 2),
      Text(
        CONSTANTS.getSegmentDateStringSubtitleByMissionModel(
            _missionModel ?? MissionModel()),
        style: TextStyle(fontSize: this.fontSize, color: ColorsConfig.darkRed),
      ),
    ];
  }

  Function funcDebounceWithUpdateSliderVal =
      Utility.debounceWith((MissionSilverListItemState state) async {
    // state.isLoading = true;
    // state.tmpMissionModel?.objectiveValue = value;
    // print("value:$value");
    MongoApisManager.getInstance().update_MissionModel(
        shouldUpdateLog: false,
        missionModel: state.tmpMissionModel ?? MissionModel());

    MongoApisManager.getInstance().insertTimelineMissionModel(
        shouldQueryMissionModel: false,
        missionModel: Utility.getTimelineMissionModelFromMissionModel(
            icon: Icons.check_circle.codePoint,
            color: Colors.greenAccent.value,
            sceneType: "mission",
            eventType: "realize_mission",
            mission_id: state.tmpMissionModel?.objectId,
            folder_id: state.tmpMissionModel?.folder_id,
            timelineMessage: getI18NKey().realize_percent(
                state.tmpMissionModel?.title ?? "?",
                state.tmpMissionModel?.objectivePercentString ?? "")));
  }, Duration(milliseconds: 3000));

  List<Widget> getDateWidget(MissionModel _missionModel) {
    if (_missionModel.objectId == '65c079ec59321612ecbbb6da' ||
        _missionModel.objectId == '65c079aa59321612ecbbb6c5') {
      print('getSegmentdateWidget');
    }
    return [
      Icon(
        Icons.calendar_today_rounded,
        color: ColorsConfig.darkRed,
        size: this.fontSize,
      ),
      SizedBox(width: 2),
      Text(
        CONSTANTS.getDateStringSubtitle(_missionModel ?? MissionModel()),
        style: TextStyle(fontSize: this.fontSize, color: ColorsConfig.darkRed),
      ),
    ];
  }

  List<Widget> getFinishIconSlideActions(MissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapUnFinishListener != null)
            this.widget.onTapUnFinishListener!(_missionModel);
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().unfinished,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapMultiSelectListener != null)
            this.widget.onTapMultiSelectListener!(null);
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.select_all,
        label: getI18NKey().multi_select,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<Widget> getUnfinishIconSlideActions(MissionModel _missionModel) {
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (_missionModel.isFinished == false) {
            if (this.widget.onTapFinishListener != null)
              this.widget.onTapFinishListener!(_missionModel);
          } else {
            if (this.widget.onTapUnFinishListener != null)
              this.widget.onTapUnFinishListener!(_missionModel);
          }
        },
        // flex: Fl
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().finish,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDoItNow != null)
            this.widget.onTapDoItNow!(_missionModel);
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: Icons.bolt,
        label: getI18NKey().do_it_now,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapEditListener != null)
            this.widget.onTapEditListener!(_missionModel);
        },
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        label: getI18NKey().edit,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapMultiSelectListener != null)
            this.widget.onTapMultiSelectListener!(null);
        },
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        icon: Icons.select_all,
        label: getI18NKey().multi_select,
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete,
      ),
    ];
  }

  List<PopupMenuEntry<String>> getUnfinishedPopupList(
      MissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      // PopupMenuItem<String>(
      //   value: 'start_focus',
      //   onTap: () {
      //     //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
      //     Future.delayed(Duration(milliseconds: 100), () {
      //       this.widget.onTapPlayListener!(_missionModel);
      //     });
      //   },
      //   child: Wrap(
      //     crossAxisAlignment: WrapCrossAlignment.center,
      //     children: [
      //       Icon(Icons.center_focus_strong,
      //           color: Colors.red, size: fontSize),
      //       SizedBox(width: 5),
      //       Text(getI18NKey().start_focus,
      //           style: TextStyle(fontSize: 15, color: Colors.red)),
      //     ],
      //   ),
      // ),
      PopupMenuItem<String>(
        value: 'complete',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapFinishListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.check, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().finish, style: TextStyle(fontSize: 15))
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'doItNow',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
            this.widget.onTapDoItNow!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Utility.getSVGPicture(R.assetsImgIcInstantly, size: fontSize),
            // Icon(Icons.check, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().do_it_now,
                style: TextStyle(fontSize: 15, color: Color(0xffff8800)))
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'edit',
        onTap: () {
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapEditListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.green, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().edit,
                style: TextStyle(color: Colors.green, fontSize: 15))
          ],
        ),
      ),
      PopupMenuItem<String>(
          value: 'multi_select',
          onTap: () {
            this.widget.onTapMultiSelectListener?.call(null);
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.select_all, color: Colors.blue, size: fontSize),
              SizedBox(width: 5),
              Text(getI18NKey().multi_select,
                  style: TextStyle(color: Colors.blue, fontSize: 15)),
            ],
          )),
      PopupMenuItem<String>(
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          value: 'delete',
          onTap: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.widget.onTapDeleteListener!(_missionModel);
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.grey, size: fontSize),
              SizedBox(width: 5),
              Text(
                getI18NKey().delete,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          )),
    ];
  }

  List<PopupMenuEntry<String>> getFinishedPopupList(
      MissionModel _missionModel) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'unfinished',
        onTap: () {
          if (this.widget.onTapUnFinishListener != null)
            this.widget.onTapUnFinishListener?.call(_missionModel);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.green, size: fontSize),
            Text(
              getI18NKey().unfinished,
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'multi_select',
        onTap: () {
          this.widget.onTapMultiSelectListener?.call(null);
          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
          // Future.delayed(Duration(milliseconds: 100), () {
          //   this.widget.onTapEditListener!(_missionModel);
          // });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.select_all, color: Colors.blue, size: fontSize),
            SizedBox(width: 5),
            Text(getI18NKey().multi_select,
                style: TextStyle(color: Colors.blue, fontSize: 15)),
          ],
        ),
      ),
      PopupMenuItem<String>(
        //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
        value: 'delete',
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            this.widget.onTapDeleteListener!(_missionModel);
          });
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.grey, size: fontSize),
            SizedBox(width: 5),
            Text(
              getI18NKey().delete,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    ];
  }
}
