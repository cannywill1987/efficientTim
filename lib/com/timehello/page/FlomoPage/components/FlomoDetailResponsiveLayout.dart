/**
 * 文件类型：布局配置工具
 * 文件作用：统一管理习惯打卡详情页右侧区域的响应式断点与侧栏宽度。
 * 主要职责：让页面布局判断可测试，避免不同组件各自写一套宽度规则导致桌面和窄屏表现不一致。
 */
class FlomoDetailResponsiveLayout {
  static const double dashboardBreakpoint = 900;
  static const double calendarColumns = 7;
  static const double calendarDayRowHeight = 58;

  /**
   * 功能：判断当前详情区域是否适合使用参考图里的仪表盘式横向布局。
   * 入参：availableWidth 表示 Flomo 详情页右侧可用宽度，不包含左侧任务列表。
   */
  static bool shouldUseDashboardLayout(double availableWidth) {
    return availableWidth >= dashboardBreakpoint;
  }

  /**
   * 功能：根据详情区宽度给右侧习惯详情栏分配稳定宽度。
   * 说明：宽屏给详情栏更多空间，临界桌面宽度收窄到 300，窄屏返回 0 表示改为纵向堆叠。
   */
  static double sidePanelWidth(double availableWidth) {
    if (!shouldUseDashboardLayout(availableWidth)) {
      return 0;
    }
    return availableWidth >= 1200 ? 340 : 300;
  }

  /**
   * 功能：计算月历日期格的宽高比。
   * 说明：Flutter Grid 默认宽高比为 1，宽屏下会把每一行撑得过高；这里固定日期行高，让月历保持紧凑。
   */
  static double calendarDayChildAspectRatio(double availableWidth) {
    if (availableWidth <= 0) {
      return 1;
    }
    return (availableWidth / calendarColumns) / calendarDayRowHeight;
  }
}
