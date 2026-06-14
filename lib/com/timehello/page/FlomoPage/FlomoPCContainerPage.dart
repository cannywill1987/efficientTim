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
 * 文件作用：承载 Flomo 左侧打卡列表与右侧详情页。
 * 主要职责：同步当前选中的打卡任务和日期，并提供与 FolderPage 统一的桌面背景层次。
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
   * 功能：构建 Flomo 桌面双栏页面。
   * 说明：左侧固定宽度参考 FolderPage，右侧详情保留 Expanded 自适应宽屏空间。
   */
  @override
  Widget build(BuildContext context) {
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
        color: isDark ? ThemeManager.getInstance().getBackgroundColor() : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 400,
            child: FlomoPage(onTapListener: (data) {
              flomoMissionModel = data['data'];
              curDateTime = data['curDateTime'];
              flomoPageStateGlobalKey.currentState
                  ?.jumpToDateTime(curDateTime ?? DateTime.now());
              updateUI();
            }),
          ),
          Expanded(
            child: flomoMissionModel == null
                ? EmptyWidget(text: "")
                : FlomoDetailPage(
                    key: flomoPageStateGlobalKey,
                    flomoMissionModel:
                        this.flomoMissionModel ?? FlomoMissionModel(),
                    curDateTime: this.curDateTime,
                  ),
          )
        ],
      ),
    );
  }
}
