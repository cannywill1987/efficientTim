/**
 * 文件类型：工具函数
 * 文件作用：为习惯打卡详情页整理本月打卡日志点数量。
 * 主要职责：从 FlomoMissionModel.clockIn 的 ymd -> List 结构里统计当前月份实际打卡次数，供右侧日志点渲染使用。
 */
class FlomoDetailClockLogHelper {
  /**
   * 功能：统计指定月份真实打卡次数。
   * 说明：clockIn 每个日期下面可能有多条记录；日志点要按点击打卡次数展示，而不是按固定日期占位。
   */
  static int countMonthClockLogs({
    required Map? clockInMap,
    required DateTime monthDate,
  }) {
    if (clockInMap == null || clockInMap.isEmpty) {
      return 0;
    }
    int total = 0;
    clockInMap.forEach((key, value) {
      final DateTime? date = DateTime.tryParse(key.toString());
      if (date == null ||
          date.year != monthDate.year ||
          date.month != monthDate.month) {
        return;
      }
      if (value is List) {
        total += value.length;
      }
    });
    return total;
  }
}
