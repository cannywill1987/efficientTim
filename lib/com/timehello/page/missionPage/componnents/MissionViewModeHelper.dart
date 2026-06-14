import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

/**
 * 文件类型：工具函数
 * 文件作用：统一任务页内容视图类型和右上角视图切换按钮的映射关系。
 * 主要职责：解决 MissionDataViewTypeEnum 的 index 与“列表/分类/表格”三段按钮 index 不一致时的同步问题。
 */
class MissionViewModeHelper {
  /**
   * 功能：把任务内容视图枚举转换成右上角按钮索引。
   * 说明：table 在 MissionDataViewTypeEnum 中是 index 3，但按钮只有 0/1/2 三项，因此必须显式映射到按钮 index 2。
   */
  static int switcherIndexFromViewType(MissionDataViewTypeEnum viewType) {
    switch (viewType) {
      case MissionDataViewTypeEnum.list:
        return 0;
      case MissionDataViewTypeEnum.grid:
      case MissionDataViewTypeEnum.timeline:
        return 1;
      case MissionDataViewTypeEnum.table:
        return 2;
      case MissionDataViewTypeEnum.week_view:
        return 0;
    }
  }

  /**
   * 功能：把本地缓存里的视图枚举 index 转换成右上角按钮索引。
   * 说明：缓存值可能来自旧版本或异常数据，越界时兜底成列表，避免首次进入页面崩溃。
   */
  static int switcherIndexFromViewTypeIndex(int viewTypeIndex) {
    if (viewTypeIndex < 0 ||
        viewTypeIndex >= MissionDataViewTypeEnum.values.length) {
      return 0;
    }
    return switcherIndexFromViewType(
      MissionDataViewTypeEnum.values[viewTypeIndex],
    );
  }

  /**
   * 功能：同步右上角按钮列表的选中态。
   * 说明：首次进入页面时按钮组件可能还没挂载，先写父级 list 数据，保证首帧构建就能显示正确选中项。
   */
  static void syncSwitcherSelection(
    List<CheckButtonStateModel> buttons,
    int switcherIndex,
  ) {
    if (buttons.isEmpty) {
      return;
    }
    final int safeIndex = switcherIndex.clamp(0, buttons.length - 1).toInt();
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].isCheck = i == safeIndex;
    }
  }
}
