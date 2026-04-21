import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';

/// 统一风格的带图标按钮组，仅用于桌面端的任务视图切换
class UnifiedCheckButtonListWithIconWidget extends StatefulWidget {
  final List<CheckButtonStateModel> list;
  final OnTapListener onTapListener;
  final int? initIndex;

  const UnifiedCheckButtonListWithIconWidget({
    super.key,
    required this.list,
    required this.onTapListener,
    this.initIndex = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return UnifiedCheckButtonListWithIconWidgetState(list: list);
  }
}

class UnifiedCheckButtonListWithIconWidgetState
    extends State<UnifiedCheckButtonListWithIconWidget> {
  List<CheckButtonStateModel> list;

  UnifiedCheckButtonListWithIconWidgetState({required this.list});

  @override
  void initState() {
    super.initState();
    if (widget.initIndex != null) {
      for (int i = 0; i < list.length; i++) {
        list[i].isCheck = i == widget.initIndex;
      }
    }
  }

  @override
  void didUpdateWidget(UnifiedCheckButtonListWithIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list) {
      list = widget.list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color containerColor = const Color(0xFFFFF2E8);
    final Color borderColor = const Color(0xFFF2E0D3);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildButtons(),
      ),
    );
  }

  List<Widget> _buildButtons() {
    return List<Widget>.generate(list.length, (index) {
      final CheckButtonStateModel model = list[index];
      return _UnifiedCheckButtonItem(
        model: model,
        onTap: () {
          _resetChecks();
          model.isCheck = true;
          widget.onTapListener(index);
          if (mounted) {
            setState(() {});
          }
        },
      );
    });
  }

  void _resetChecks() {
    for (final item in list) {
      item.isCheck = false;
    }
  }
}

class _UnifiedCheckButtonItem extends StatelessWidget {
  final CheckButtonStateModel model;
  final VoidCallback onTap;

  const _UnifiedCheckButtonItem({
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isChecked = model.isCheck == true;
    final Color activeColor = const Color(0xFF6C8AF6);
    final Color inactiveColor = const Color(0xFF9B7C66);
    final Widget? icon = isChecked ? model.checkIcon : model.uncheckIcon;
    final Widget iconWidget = icon ?? const SizedBox.shrink();
    final bool hasIcon = icon != null;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isChecked ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: isChecked ? Colors.white : inactiveColor,
            fontSize: 12,
            fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: isChecked ? Colors.white : inactiveColor,
              size: 14,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasIcon) iconWidget,
                if (hasIcon) const SizedBox(width: 4),
                Text(model.title ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
