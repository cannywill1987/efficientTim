import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/r.dart';

/**
 * 文件类型：移动端头部状态工具
 * 文件作用：把 CounterManagement 和 FolderModel 返回的状态转换成移动端头部可展示的视觉信息。
 * 主要职责：集中维护状态胶囊、标题左侧图标的资源映射，避免 UI 里继续写死占位图标。
 */

class HeaderMobileCounterStatusData {
  final bool isVisible;
  final Color color;
  final String iconAsset;

  const HeaderMobileCounterStatusData({
    required this.isVisible,
    required this.color,
    required this.iconAsset,
  });
}

class HeaderMobileFolderIconData {
  final String? iconAsset;
  final double size;
  final Color? color;
  final IconData? fallbackIcon;

  const HeaderMobileFolderIconData({
    required this.size,
    this.iconAsset,
    this.color,
    this.fallbackIcon,
  });
}

class HeaderMobileCounterStatusHelper {
  /**
   * 功能：根据 CounterStatus 返回移动端状态胶囊的视觉配置。
   * 说明：none 表示当前没有可展示的计时状态，其它状态都保留入口，让用户能看到真实计时阶段。
   */
  static HeaderMobileCounterStatusData dataForStatus(CounterStatus status) {
    switch (status) {
      case CounterStatus.focusing:
        return HeaderMobileCounterStatusData(
          isVisible: true,
          color: Color(0xFF16B540),
          iconAsset: R.assetsImgIcFocusOrange,
        );
      case CounterStatus.pausingFocusing:
        return HeaderMobileCounterStatusData(
          isVisible: true,
          color: Color(0xFFFF8A00),
          iconAsset: R.assetsImgIcFocusOrange,
        );
      case CounterStatus.relaxing:
        return HeaderMobileCounterStatusData(
          isVisible: true,
          color: Color(0xFF1D9BF0),
          iconAsset: R.assetsImgIcRest,
        );
      case CounterStatus.waitingToFocus:
        return HeaderMobileCounterStatusData(
          isVisible: true,
          color: Color(0xFF9BD42D),
          iconAsset: R.assetsImgIcFocusOrange,
        );
      case CounterStatus.waitingToStartRelaxing:
        return HeaderMobileCounterStatusData(
          isVisible: true,
          color: Color(0xFFFF8A00),
          iconAsset: R.assetsImgIcFocusOrange,
        );
      case CounterStatus.pausingRelaixing:
        return HeaderMobileCounterStatusData(
          isVisible: true,
          color: Color(0xFFFF8A00),
          iconAsset: R.assetsImgIcRest,
        );
      case CounterStatus.none:
        return HeaderMobileCounterStatusData(
          isVisible: false,
          color: Colors.transparent,
          iconAsset: R.assetsImgIcFocusOrange,
        );
    }
  }

  /**
   * 功能：根据 FolderModel.iconType 返回移动端标题左侧图标配置。
   * 说明：这里复用抽屉里的同一批 SVG 资源，保证“今天 / 现在做 / 周显示”等状态图标和菜单图标一致。
   */
  static HeaderMobileFolderIconData folderIconDataForFolder(
      FolderModel? folderModel) {
    final int iconType = folderModel?.iconType ?? 1;
    switch (iconType) {
      case 1:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcToday,
          size: 22,
        );
      case 2:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcTomorrow,
          size: 22,
        );
      case 3:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcThisWeek,
          size: 20,
        );
      case 4:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcUnfinishMissions,
          size: 20,
        );
      case 5:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcCalendar,
          size: 20,
        );
      case 6:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcFinished,
          size: 20,
        );
      case 9:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcInstantly,
          size: 22,
        );
      case 10:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcAllMission,
          size: 18,
        );
      case 12:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcTodo,
          size: 20,
        );
      case 13:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcFragment,
          size: 20,
        );
      case 14:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcCalendarToday,
          size: 20,
        );
      case 15:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIcAppleAlarm,
          size: 20,
        );
      case 16:
        return HeaderMobileFolderIconData(
          iconAsset: R.assetsImgIc7Week,
          size: 20,
        );
      default:
        return _fallbackFolderIconData(folderModel);
    }
  }

  /**
   * 功能：处理自定义清单、标签和过滤器的兜底图标。
   * 说明：系统状态优先走 SVG；用户自定义图标仍保留 MaterialIcons，避免破坏已有自定义清单配置。
   */
  static HeaderMobileFolderIconData _fallbackFolderIconData(
      FolderModel? folderModel) {
    if (folderModel == null ||
        folderModel.tag == 0 ||
        folderModel.tag == null) {
      return HeaderMobileFolderIconData(
        iconAsset: R.assetsImgIcToday,
        size: 22,
      );
    }
    if (folderModel.tag == 4) {
      return HeaderMobileFolderIconData(
        size: 22,
        color: _customFolderIconColor(folderModel),
        fallbackIcon: Icons.filter_alt_outlined,
      );
    }
    if (folderModel.tag == 1 || folderModel.tag == 5) {
      return HeaderMobileFolderIconData(
        size: 22,
        color: _customFolderIconColor(folderModel),
        fallbackIcon: IconData(
          folderModel.icon ?? Icons.task.codePoint,
          fontFamily: 'MaterialIcons',
        ),
      );
    }
    return HeaderMobileFolderIconData(
      size: 22,
      color: _customFolderIconColor(folderModel),
      fallbackIcon: Icons.local_offer,
    );
  }

  /**
   * 功能：给自定义清单图标提供可靠颜色。
   * 说明：部分旧数据 color 为 0，直接转 Color 会变成透明色，所以这里沿用旧清单常见的橙色兜底。
   */
  static Color _customFolderIconColor(FolderModel folderModel) {
    final int colorValue =
        folderModel.color == 0 ? 0xffff8800 : folderModel.color;
    return Color(colorValue);
  }
}
