/**
 * 文件类型：组件
 * 文件作用：展示时间轴页面的事件、笔记、日记和理财流水列表。
 * 主要职责：把原始 TimelineMissionModel 数据渲染成左侧相对时间、中央节点和右侧内容卡片，
 * 并承接条目点击、删除和富文本查看入口。
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/page/TimeLinePage/components/FileMessageWidget.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/ENUMS.dart';
import '../../../models/TimelineMissionModel.dart';
import '../../../util/Utility.dart';

class TimelineListView extends StatefulWidget {
  final List<Widget> children;
  final List<TimelineMissionModel> datas;
  final Function? onTapListener;
  final Function? onTapDelete;
  final TimelinePageFromEnum timelinePageFromEnum;

  const TimelineListView({
    Key? key,
    this.children = const [],
    this.onTapDelete,
    required this.datas,
    this.timelinePageFromEnum = TimelinePageFromEnum.normal,
    this.onTapListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TimelineListViewState();
  }
}

class TimelineListViewState extends State<TimelineListView> {
  static const int _defaultColorValue = 0xffff8800;

  @override
  Widget build(BuildContext context) {
    if (widget.datas.isEmpty) {
      return _buildEmptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isHandset = Utility.isHandsetBySize();
        final double maxWidth = isHandset
            ? constraints.maxWidth
            : (constraints.maxWidth > 1280 ? 1280 : constraints.maxWidth);
        final EdgeInsets listPadding = EdgeInsets.fromLTRB(
          isHandset ? 10 : 24,
          _shouldReserveTopSpace() ? 10 : 18,
          isHandset ? 10 : 24,
          widget.timelinePageFromEnum == TimelinePageFromEnum.normal ? 112 : 28,
        );

        return ListView.builder(
          cacheExtent: 10000,
          padding: listPadding,
          itemCount: widget.children.length + widget.datas.length,
          itemBuilder: (context, index) {
            if (index < widget.children.length) {
              return widget.children[index];
            }

            final int dataIndex = index - widget.children.length;
            final TimelineMissionModel model = widget.datas[dataIndex];
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: getItem(
                  model,
                  isLast: dataIndex == widget.datas.length - 1,
                ),
              ),
            );
          },
        );
      },
    );
  }

  /**
   * 功能：构建空状态，保证时间轴无数据时在亮色和暗色主题下都可读。
   * 调用时机：列表数据为空时由 build 方法直接调用。
   */
  Widget _buildEmptyState(BuildContext context) {
    final bool isDark = _isDarkMode(context);
    return Container(
      alignment: Alignment.center,
      child: Text(
        getI18NKey().no_data,
        style: TextStyle(
          color: isDark ? const Color(0xff8f9bae) : const Color(0xffa0a0a0),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /**
   * 功能：根据页面来源决定列表顶部是否需要让出筛选区域的空间。
   * 返回：普通时间轴页面的筛选标签已经由父级布局承载，这里只保留轻量间距。
   */
  bool _shouldReserveTopSpace() {
    return widget.timelinePageFromEnum !=
            TimelinePageFromEnum.FolderStatisticPage &&
        widget.timelinePageFromEnum != TimelinePageFromEnum.ObjectivePage;
  }

  /**
   * 功能：渲染单条时间轴记录。
   * 入参：model 为业务数据，isLast 用于控制最后一个节点下方连接线是否收束。
   * 说明：这里固定左侧时间和中间节点宽度，让右侧卡片在桌面宽屏和手机上都能稳定排版。
   */
  Widget getItem(TimelineMissionModel model, {required bool isLast}) {
    final bool hasImage = !TextUtil.isEmpty(model.picUrl);
    final bool isVoice =
        model.eventType == "note_voice" || model.eventType == "diary_voice";
    final double minItemHeight = hasImage ? 148 : (isVoice ? 118 : 106);
    final Color accentColor = _getAccentColor(model);
    final DateTime createdAt =
        Utility.getDateTimeFromUTCString(model.createdAt ?? "");

    return GestureDetector(
      onTap: () {
        if (widget.onTapListener != null) {
          widget.onTapListener!(model);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Utility.isHandsetBySize() ? 58 : 86,
              child: Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Text(
                  Utility.getDifTime(createdAt),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Utility.isHandsetBySize() ? 11 : 13,
                    height: 1.2,
                    color: ThemeManager.getInstance().getTextColor(
                      defaultColor: const Color(0xff5f6675),
                      defaultDarkColor: const Color(0xffa6afc2),
                    ),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            _buildTimelineNode(
              model: model,
              accentColor: accentColor,
              minHeight: minItemHeight,
              isLast: isLast,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildContentCard(
                model: model,
                accentColor: accentColor,
                minHeight: minItemHeight,
                createdAt: createdAt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 功能：构建时间轴中间节点，包括竖线、图标和类型文本。
   * 说明：节点颜色沿用业务色，背景色按主题做淡化处理，避免暗色模式下刺眼。
   */
  Widget _buildTimelineNode({
    required TimelineMissionModel model,
    required Color accentColor,
    required double minHeight,
    required bool isLast,
  }) {
    final bool isDark = _isDarkMode(context);
    final Color lineColor =
        isDark ? const Color(0xff2a3242) : const Color(0xffe4e7ee);
    final Color nodeBg = isDark
        ? Color.alphaBlend(
            accentColor.withValues(alpha: 0.18), const Color(0xff171c26))
        : accentColor.withValues(alpha: 0.12);

    return SizedBox(
      width: 54,
      height: minHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            bottom: isLast ? minHeight - 52 : 0,
            child: Container(width: 1, color: lineColor),
          ),
          Positioned(
            top: 15,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ThemeManager.getInstance().getCardBackgroundColor(
                  defaultColor: Colors.white,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xff303849)
                      : const Color(0xffedf0f5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: nodeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  IconData(
                    model.icon ?? Icons.hive.codePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: accentColor,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建右侧内容卡片，承载元信息、正文、图片预览和操作按钮。
   * 说明：图片在宽屏下放在右侧，在窄屏下自然换到正文下方，避免挤压文本。
   */
  Widget _buildContentCard({
    required TimelineMissionModel model,
    required Color accentColor,
    required double minHeight,
    required DateTime createdAt,
  }) {
    final bool isDark = _isDarkMode(context);
    final Color cardColor = ThemeManager.getInstance().getCardBackgroundColor(
      defaultColor: Colors.white,
    );
    final Color borderColor =
        isDark ? const Color(0xff2e3545) : const Color(0xffeef1f6);

    return Container(
      constraints: BoxConstraints(minHeight: minHeight - 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: accentColor, width: 3),
          top: BorderSide(color: borderColor),
          right: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool useVerticalMedia = constraints.maxWidth < 520;
            final bool hasMedia = !TextUtil.isEmpty(model.picUrl);
            final Widget content = _buildTextContent(
              model: model,
              accentColor: accentColor,
              createdAt: createdAt,
            );
            final Widget media = _buildMediaPreview(model, useVerticalMedia);

            if (!hasMedia) {
              return content;
            }

            return useVerticalMedia
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [content, media],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: content),
                      media,
                    ],
                  );
          },
        ),
      ),
    );
  }

  /**
   * 功能：构建卡片里的文字区域，包括类型、时间、删除入口和正文。
   * 说明：删除从红色文本改为图标按钮，减少列表扫描时的视觉噪音。
   */
  Widget _buildTextContent({
    required TimelineMissionModel model,
    required Color accentColor,
    required DateTime createdAt,
  }) {
    final bool isDark = _isDarkMode(context);
    final Color titleColor = ThemeManager.getInstance().getTextColor(
      defaultColor: const Color(0xff242936),
      defaultDarkColor: const Color(0xfff2f5fb),
    );
    final Color subColor =
        isDark ? const Color(0xff9aa4b8) : const Color(0xff646b79);

    if (model.eventType == "note_voice" || model.eventType == "diary_voice") {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: FileMessageWidget(timelineMissionModel: model),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Utility.isHandsetBySize() ? 14 : 20,
        15,
        Utility.isHandsetBySize() ? 12 : 18,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSceneChip(model, accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getSecondaryMeta(model),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildDeleteButton(model, subColor),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            Utility.getDateTimeYMDHM(createdAt) ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: subColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                model.timelineMessage ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: titleColor,
                  fontSize: Utility.isHandsetBySize() ? 13 : 14,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
              getEditModeWidget(model, accentColor),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * 功能：构建类型标签，帮助用户快速区分事件、笔记、日记和理财记录。
   */
  Widget _buildSceneChip(TimelineMissionModel model, Color accentColor) {
    final String sceneText =
        CONSTANTS.getTimelineTypeTextByScene(scene: model.sceneType ?? '');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            accentColor.withValues(alpha: _isDarkMode(context) ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        sceneText.isEmpty ? '--' : sceneText,
        style: TextStyle(
          color: accentColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /**
   * 功能：构建删除按钮，并在统计页面隐藏破坏性操作。
   */
  Widget _buildDeleteButton(TimelineMissionModel model, Color subColor) {
    if (widget.timelinePageFromEnum == TimelinePageFromEnum.StatisticPage) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: getI18NKey().delete,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (widget.onTapDelete != null) {
            widget.onTapDelete!(model);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.delete_outline,
            size: 17,
            color: subColor.withValues(alpha: 0.72),
          ),
        ),
      ),
    );
  }

  /**
   * 功能：构建卡片右侧或下方的图片预览。
   * 说明：只在数据存在 picUrl 时展示，URL 仍沿用项目现有 OSS 过滤逻辑。
   */
  Widget _buildMediaPreview(TimelineMissionModel model, bool useVerticalMedia) {
    if (TextUtil.isEmpty(model.picUrl)) {
      return const SizedBox.shrink();
    }

    final double width = useVerticalMedia ? double.infinity : 190;
    final double height = useVerticalMedia ? 128 : double.infinity;

    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: Utility.filterHttpUrl(model.picUrl ?? "", prefix: "oss"),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          return Container(
            alignment: Alignment.center,
            color: _isDarkMode(context)
                ? const Color(0xff202838)
                : const Color(0xfff1f3f7),
            child: Icon(
              Icons.broken_image_outlined,
              color: ThemeManager.getInstance().getTextColor(
                defaultColor: ColorsConfig.gray_a7,
                defaultDarkColor: const Color(0xff8b95a8),
              ),
            ),
          );
        },
      ),
    );
  }

  /**
   * 功能：为日记和笔记生成查看入口。
   */
  Widget getEditModeWidget(
    TimelineMissionModel timelineMissionModel,
    Color accentColor,
  ) {
    final String scene = timelineMissionModel.sceneType ?? "";
    if (scene.isNotEmpty &&
        timelineMissionModel.url != null &&
        (scene == 'note' || scene == 'diary')) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color:
              accentColor.withValues(alpha: _isDarkMode(context) ? 0.18 : 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          getI18NKey().see,
          style: TextStyle(
            color: accentColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /**
   * 功能：抽取卡片顶部的次级元信息。
   * 说明：优先展示标签、标题，再展示事件类型，避免顶部信息为空造成卡片失衡。
   */
  String _getSecondaryMeta(TimelineMissionModel model) {
    final List<String?> candidates = [
      model.tagName,
      model.tagNames,
      model.title,
      model.eventType,
    ];
    for (final String? value in candidates) {
      if (!TextUtil.isEmpty(value)) {
        return (value ?? '').replaceAll('_', ' ').toUpperCase();
      }
    }
    return '';
  }

  /**
   * 功能：读取当前主题模式，兼容项目 ThemeManager 和 Flutter 上下文主题。
   */
  bool _isDarkMode(BuildContext context) {
    return ThemeManager.getInstance().getThemeMode().isDark ||
        Theme.of(context).brightness == Brightness.dark;
  }

  /**
   * 功能：统一计算时间轴条目的业务强调色。
   */
  Color _getAccentColor(TimelineMissionModel model) {
    return Color(model.color ?? _defaultColorValue);
  }
}
