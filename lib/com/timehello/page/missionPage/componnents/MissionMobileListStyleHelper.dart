import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';

/**
 * 文件类型：任务列表样式工具
 * 文件作用：集中维护移动端现代任务列表的尺寸参数，避免卡片、分组标题和测试里散落魔法数字。
 * 主要职责：为 MissionSilverList 与 MissionPage 的移动端列表模式提供统一布局指标。
 */

class MissionMobileListStyleMetrics {
  final double cardMinHeight;
  final double cardRadius;
  final double horizontalMargin;
  final double bottomSpacing;
  final double sectionHeaderHeight;

  const MissionMobileListStyleMetrics({
    required this.cardMinHeight,
    required this.cardRadius,
    required this.horizontalMargin,
    required this.bottomSpacing,
    required this.sectionHeaderHeight,
  });

  EdgeInsets get cardMargin => EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: bottomSpacing,
      );
}

class MissionMobileObjectiveProgressData {
  final double progress;
  final double sliderMin;
  final double sliderMax;
  final double sliderValue;
  final String percentText;
  final String countText;

  const MissionMobileObjectiveProgressData({
    required this.progress,
    required this.sliderMin,
    required this.sliderMax,
    required this.sliderValue,
    required this.percentText,
    required this.countText,
  });
}

class MissionMobileListStyleHelper {
  /**
   * 功能：移动端现代列表的统一尺寸。
   * 说明：这些数值对应设计稿里的大圆角白色任务卡、紧凑分组标题和底部留白。
   */
  static const MissionMobileListStyleMetrics mobileModernMetrics =
      MissionMobileListStyleMetrics(
    cardMinHeight: 90,
    cardRadius: 14,
    horizontalMargin: 12,
    bottomSpacing: 10,
    sectionHeaderHeight: 44,
  );

  /**
   * 功能：把目标任务里的进度字段整理成移动端卡片可以直接展示的数据。
   * 说明：移动端列表复用 PC 端 objectiveValue/objectiveTotalValue 语义，避免同一任务两端进度口径不一致。
   */
  static MissionMobileObjectiveProgressData buildObjectiveProgressData(
    MissionModel? missionModel,
  ) {
    final double start = missionModel?.objectiveStartValue ?? 0;
    final double total = missionModel?.objectiveTotalValue ?? 0;
    final double current = missionModel?.objectiveValue ?? 0;
    final double sliderMax = total <= start ? start + 1 : total;
    final double sliderValue = current.clamp(start, sliderMax).toDouble();
    final double progress =
        total <= 0 ? 0 : (current / total).clamp(0.0, 1.0).toDouble();
    final String unit = (missionModel?.objectiveUnit ?? '').trim();
    final String unitText = unit.isEmpty ? '' : ' $unit';

    return MissionMobileObjectiveProgressData(
      progress: progress,
      sliderMin: start,
      sliderMax: sliderMax,
      sliderValue: sliderValue,
      percentText: '${(progress * 100).toStringAsFixed(1)}%',
      countText: '${current.toInt()} / ${total.toInt()}$unitText',
    );
  }
}
