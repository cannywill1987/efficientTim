import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/page/FlomoPage/FlomoPage.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../components/EmptyWidget.dart';
import 'FlomoDetailPage.dart';

/**
 * 文件类型：桌面端页面容器
 * 文件作用：承载 Flomo 左侧任务列表与右侧任务详情，在 PC 宽屏下形成双栏工作区。
 * 主要职责：管理当前选中的任务和日期，并为左右两栏提供接近截图的浅暖色工作台视觉层次。
 */
class FlomoPCContainerPage extends BaseWidget {
  const FlomoPCContainerPage({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    return FlomoPCContainerPageState();
  }
}

class FlomoPCContainerPageState extends BaseWidgetState<FlomoPCContainerPage> {
  FlomoMissionModel? flomoMissionModel;
  DateTime? curDateTime = DateTime.now();
  GlobalKey<FlomoDetailPageState> flomoPageStateGlobalKey = GlobalKey();

  /**
   * 功能：构建 PC 端 Flomo 工作区。
   * 时机：Flutter 刷新页面时调用，负责把左侧任务列表与右侧详情区组合成截图里的桌面布局。
   */
  @override
  Widget build(BuildContext context) {
    final ThemeManager themeManager = ThemeManager.getInstance();
    final bool isDark = themeManager.getThemeMode().isDark;
    final Color accentColor = themeManager.getDefautThemeColor();
    final Color pageBackground =
        themeManager.getBackgroundColor(defaultColor: const Color(0xfff5efe6));
    final Color panelColor =
        isDark ? const Color(0xff35302d) : const Color(0xfffffbf6);
    final Color detailColor =
        isDark ? const Color(0xff2d2b29) : const Color(0xfffffcf8);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xff24211f),
                  Color(0xff302d29),
                  Color(0xff202725),
                ]
              : [
                  pageBackground,
                  const Color(0xffffead5),
                  const Color(0xffeef5ea),
                ],
        ),
      ),
      child: Stack(
        children: [
          _buildBackgroundWash(isDark: isDark),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 20, 18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLeftMissionPanel(
                  panelColor: panelColor,
                  accentColor: accentColor,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDetailWorkspace(
                    detailColor: detailColor,
                    accentColor: accentColor,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 功能：生成截图中偏柔和的背景色块。
   * 说明：这里用大面积低透明度色带增强空间感，避免影响真实任务列表和详情区的可读性。
   */
  Widget _buildBackgroundWash({required bool isDark}) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              left: -110,
              top: 40,
              child: _buildSoftBand(
                width: 560,
                height: 180,
                color: isDark
                    ? const Color(0xff4b3d32).withValues(alpha: 0.28)
                    : const Color(0xffffc28d).withValues(alpha: 0.30),
              ),
            ),
            Positioned(
              right: -80,
              top: 120,
              child: _buildSoftBand(
                width: 520,
                height: 210,
                color: isDark
                    ? const Color(0xff2f463d).withValues(alpha: 0.25)
                    : const Color(0xffd7ead8).withValues(alpha: 0.55),
              ),
            ),
            Positioned(
              left: 250,
              bottom: -70,
              child: _buildSoftBand(
                width: 620,
                height: 220,
                color: isDark
                    ? const Color(0xff3f3448).withValues(alpha: 0.20)
                    : const Color(0xffffddbd).withValues(alpha: 0.36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 功能：绘制背景里的柔性色带。
   * 入参：宽高与颜色由调用方传入，方便不同位置复用同一种视觉语言。
   */
  Widget _buildSoftBand({
    required double width,
    required double height,
    required Color color,
  }) {
    return Transform.rotate(
      angle: -0.08,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(42),
        ),
      ),
    );
  }

  /**
   * 功能：构建左侧任务列表面板。
   * 说明：截图左栏是独立浮层卡片，这里统一加圆角、阴影和裁剪，让原 FlomoPage 内容自然嵌入。
   */
  Widget _buildLeftMissionPanel({
    required Color panelColor,
    required Color accentColor,
  }) {
    return Container(
      width: 336,
      decoration: BoxDecoration(
        color: panelColor.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.48),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8f6f55).withValues(alpha: 0.14),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FlomoPage(onTapListener: (data) {
          _handleMissionSelected(data);
        }),
      ),
    );
  }

  /**
   * 功能：处理左侧列表点击后的详情联动。
   * 说明：先同步当前任务和日期，再通知右侧详情页跳转日期，保持两栏状态一致。
   */
  void _handleMissionSelected(dynamic data) {
    flomoMissionModel = data['data'];
    curDateTime = data['curDateTime'];
    flomoPageStateGlobalKey.currentState
        ?.jumpToDateTime(curDateTime ?? DateTime.now());
    updateUI();
  }

  /**
   * 功能：构建右侧详情工作区。
   * 说明：未选中任务时展示轻量空态；选中后把原详情页放进圆角工作台中。
   */
  Widget _buildDetailWorkspace({
    required Color detailColor,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: detailColor.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.48),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xff8f6f55).withValues(alpha: isDark ? 0.08 : 0.12),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: flomoMissionModel == null
            ? _buildEmptyDetailPane(accentColor: accentColor, isDark: isDark)
            : FlomoDetailPage(
                key: flomoPageStateGlobalKey,
                flomoMissionModel: flomoMissionModel ?? FlomoMissionModel(),
                curDateTime: curDateTime,
              ),
      ),
    );
  }

  /**
   * 功能：构建右侧未选择任务时的空状态。
   * 说明：保留原空图标，同时补一个截图风格的顶栏和提示，让初始页面不像大片空白。
   */
  Widget _buildEmptyDetailPane({
    required Color accentColor,
    required bool isDark,
  }) {
    final Color textColor = isDark ? Colors.white : const Color(0xff3b2a20);
    final Color subTextColor =
        isDark ? const Color(0xffc9beb7) : const Color(0xff9b7b67);

    return Column(
      children: [
        Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff34302d) : const Color(0xfffffaf4),
            border: Border(
              bottom: BorderSide(
                color:
                    isDark ? const Color(0xff45413d) : const Color(0xffffe0c4),
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.28 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  CupertinoIcons.square_list,
                  color: accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mission Workspace',
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '今天',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.search,
                color: textColor.withValues(alpha: 0.78),
                size: 23,
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 36),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xff332f2c) : const Color(0xfffffbf6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? const Color(0xff45413d)
                      : const Color(0xffffdfbf),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmptyWidget(text: ''),
                  const SizedBox(height: 12),
                  Text(
                    '从左侧选择一个任务查看详情',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '任务详情、打卡日历和月度统计会在这里展开。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
