/**
 * 文件类型：侧边抽屉样式工具
 * 文件作用：集中维护移动端新版清单抽屉的布局尺寸，避免 FoldersPage、列表项和外层 Drawer 重复写魔法数字。
 * 主要职责：为移动端抽屉宽度、圆角、头部、菜单项和底部升级卡提供统一指标。
 */

class FoldersMobileDrawerStyleMetrics {
  final double widthFactor;
  final double cornerRadius;
  final double headerHeight;
  final double menuItemMinHeight;
  final double upgradeCardHeight;

  const FoldersMobileDrawerStyleMetrics({
    required this.widthFactor,
    required this.cornerRadius,
    required this.headerHeight,
    required this.menuItemMinHeight,
    required this.upgradeCardHeight,
  });
}

class FoldersMobileDrawerStyleHelper {
  /**
   * 功能：移动端新版抽屉统一尺寸。
   * 说明：抽屉宽度保留右侧内容透出，同时给清单标题留足换行空间，避免移动端只剩很窄的文字列。
   */
  static const FoldersMobileDrawerStyleMetrics modernMetrics =
      FoldersMobileDrawerStyleMetrics(
    widthFactor: 0.88,
    cornerRadius: 28,
    headerHeight: 108,
    menuItemMinHeight: 50,
    upgradeCardHeight: 84,
  );
}
