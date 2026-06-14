/**
 * 文件类型：公共组件
 * 文件作用：渲染单选分段按钮列表，支持默认、统一胶囊和专注详情三种视觉形态。
 * 主要职责：维护当前选中项状态，并把文字、图标和强调色配置传递给每个按钮项。
 */
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../util/Utility.dart';

class BlackCheckButtonListWidget extends StatefulWidget {
  final List<CheckButtonStateModel> list;
  final OnTapListener onTapListener;
  final String unit;
  final int? initIndex;
  final Color backgroundColor;
  final bool useUnifiedStyle;
  final bool useFocusDetailStyle;
  final bool useThemeColorForUnifiedStyle;

  BlackCheckButtonListWidget({
    Key? key,
    Color? backgroundColor,
    this.initIndex = 0,
    required this.list,
    required this.onTapListener,
    this.useUnifiedStyle = false,
    this.useFocusDetailStyle = false,
    this.useThemeColorForUnifiedStyle = false,
    String? unit,
  })  : backgroundColor =
            backgroundColor ?? ThemeManager.getInstance().getDefautThemeColor(),
        unit = unit ?? getI18NKey().min_en,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BlackCheckButtonListWidgetState(list: list);
  }
}

class BlackCheckButtonListWidgetState
    extends State<BlackCheckButtonListWidget> {
  List<CheckButtonStateModel> list;

  BlackCheckButtonListWidgetState({required this.list});

  @override
  void didUpdateWidget(BlackCheckButtonListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if(oldWidget.list != this.widget.list) {
    //   this.list = this.widget.list;
    // }
  }

  /**
   * 功能：外部更新按钮数据后同步本组件内部状态。
   * 入参：list 为新的按钮状态列表，通常由父组件在筛选项变化后传入。
   */
  updateList(List<CheckButtonStateModel> list) {
    this.list = list;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useUnifiedStyle) {
      final Color borderColor = widget.useThemeColorForUnifiedStyle
          ? widget.backgroundColor.withValues(alpha: 0.52)
          : const Color(0xFFE6D6C5);
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ThemeManager.getInstance()
              .getCardBackgroundColor(defaultColor: const Color(0xFFFFFBF4)),
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: getList(this.list),
        ),
      );
    }
    if (widget.useFocusDetailStyle) {
      return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: const Color(0xff121820).withValues(alpha: 0.82),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08), width: 1),
              borderRadius: BorderRadius.circular(999)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: getList(this.list)));
    }
    return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
            border: Border.all(color: this.widget.backgroundColor, width: 1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: getList(this.list)));
  }

  @override
  void initState() {
    super.initState();
    if (this.widget.initIndex != null) {
      for (int i = 0; i < this.list.length; i++) {
        CheckButtonStateModel model = this.list[i];
        if (this.widget.initIndex == i) {
          model.isCheck = true;
        } else {
          model.isCheck = false;
        }
      }
    }
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    list.forEach((element) {
      listTmp.add(getCheckButton(element, list.indexOf(element)));
    });
    return listTmp;
  }

  void setCurIndex(int index) {
    initModelListState();
    list[index].isCheck = true;
    if (mounted) setState(() {});
  }

  /**
   * 功能：构建单个可点击按钮，并在点击后维护单选状态和回调父组件。
   */
  Widget getCheckButton(CheckButtonStateModel model, int index) {
    return GestureDetector(
        onTap: () {
          initModelListState();
          model.isCheck = true;
          this.widget.onTapListener(index);
          if (mounted) setState(() {});
        },
        child: BlackCheckButtonListWidgetItem(
          backgroundColor: this.widget.backgroundColor,
          text: model.title ?? "",
          isChecked: model.isCheck,
          checkIcon: model.checkIcon,
          uncheckIcon: model.uncheckIcon,
          useUnifiedStyle: this.widget.useUnifiedStyle,
          useFocusDetailStyle: this.widget.useFocusDetailStyle,
          useThemeColorForUnifiedStyle:
              this.widget.useThemeColorForUnifiedStyle,
        ));
    // if (model.isCheck == true) {
    // } else {
    //   return BlackCheckButtonListWidgetItem(text: model.title, isChecked: model.isCheck,);
    // }
  }

  void initModelListState() {
    this.list.forEach((element) {
      element.isCheck = false;
    });
  }
}

class BlackCheckButtonListWidgetItem extends StatelessWidget {
  final bool isChecked;
  final String text;
  final double paddingHor = 10;
  final double paddingVer = 3;
  final Color backgroundColor;
  final Widget? checkIcon;
  final Widget? uncheckIcon;
  final bool useUnifiedStyle;
  final bool useFocusDetailStyle;
  final bool useThemeColorForUnifiedStyle;
  BlackCheckButtonListWidgetItem({
    required this.backgroundColor,
    required this.isChecked,
    required this.text,
    this.checkIcon,
    this.uncheckIcon,
    this.useUnifiedStyle = false,
    this.useFocusDetailStyle = false,
    this.useThemeColorForUnifiedStyle = false,
  });

  /**
   * 功能：把按钮图标和文字组合成同一行，避免各个样式分支重复处理 icon 间距。
   * 入参：textStyle 控制当前选中态的文字颜色和字重。
   */
  Widget _buildContent(TextStyle textStyle) {
    final Widget? icon = isChecked ? checkIcon : (uncheckIcon ?? checkIcon);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon,
          const SizedBox(width: 4),
        ],
        Text(text, style: textStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (useFocusDetailStyle) {
      final Color themeColor = backgroundColor;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minWidth: 76),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isChecked
              ? themeColor.withValues(alpha: 0.14)
              : Colors.transparent,
          border: Border.all(
              color: isChecked ? themeColor : Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: _buildContent(
          TextStyle(
            color:
                isChecked ? Colors.white : Colors.white.withValues(alpha: 0.62),
            fontSize: 13,
            fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }
    if (useUnifiedStyle) {
      final bool isDark = ThemeManager.getInstance().getThemeMode().isDark;
      final Color selectedBackgroundColor = useThemeColorForUnifiedStyle
          ? backgroundColor.withValues(alpha: isDark ? 0.22 : 0.14)
          : const Color(0xFFFFEFD9);
      final Color selectedBorderColor = useThemeColorForUnifiedStyle
          ? backgroundColor.withValues(alpha: 0.86)
          : const Color(0xFFD8BFA2);
      final Color selectedTextColor = useThemeColorForUnifiedStyle
          ? ThemeManager.getInstance().getSelectedIconColor(
              defaultColor: Colors.white,
              defaultDarkColor: Colors.white,
            )
          : const Color(0xFF5B4332);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isChecked ? selectedBackgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isChecked ? selectedBorderColor : Colors.transparent,
          ),
        ),
        child: _buildContent(
          TextStyle(
            color: isChecked
                ? selectedTextColor
                : ThemeManager.getInstance()
                    .getTextColor(defaultColor: const Color(0xFF8B7767)),
            fontSize: 13,
            fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }
    if (this.isChecked == true) {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor, vertical: paddingVer),
          decoration: BoxDecoration(
              color: this.backgroundColor,
              borderRadius: BorderRadius.circular(20)),
          child: _buildContent(
            TextStyle(color: Colors.white, fontSize: 12),
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHor, vertical: paddingVer),
          child: _buildContent(
            TextStyle(
                color: ThemeManager.getInstance()
                    .getTextColor(defaultColor: this.backgroundColor),
                fontSize: 12),
          ));
    }
  }
}
