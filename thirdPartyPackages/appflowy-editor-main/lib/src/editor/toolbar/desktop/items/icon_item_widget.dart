import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

class SVGIconItemWidget extends StatelessWidget {
  const SVGIconItemWidget({
    super.key,
    this.size = const Size.square(30.0),
    this.iconSize = const Size.square(18.0),
    this.iconName,
    this.name,
    this.iconBuilder,
    required this.isHighlight,
    required this.highlightColor,
    this.iconColor,
    this.tooltip,
    this.onPressed,
  });
  final String? name;
  final Size size;
  final Size iconSize;
  final String? iconName;
  final WidgetBuilder? iconBuilder;
  final bool isHighlight;
  final Color highlightColor;
  final Color? iconColor;
  final String? tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget child = iconBuilder != null
        ? iconBuilder!(context)
        : this.name == null ? EditorSvg(
      name: iconName,
      color: isHighlight ? highlightColor : iconColor,
      width: iconSize.width,
      height: iconSize.height,
    ) : Row(

        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
      EditorSvg(
        name: iconName,
        color: isHighlight ? highlightColor : iconColor,
        width: iconSize.width,
        height: iconSize.height,
      ),
      SizedBox(width: 4.0),
      Text(name!, style: TextStyle(fontSize: 12, color: isHighlight ? highlightColor : iconColor)),
    ]);
    if (onPressed != null) {
      child = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          padding: EdgeInsets.zero,
          icon: child,
          iconSize: size.width,
          onPressed: onPressed,
        ),
      );
    }
    if (tooltip != null) {
      child = Tooltip(
        textAlign: TextAlign.center,
        preferBelow: false,
        message: tooltip,
        waitDuration: const Duration(milliseconds: 500),
        child: child,
      );
    }
    return SizedBox(
      width: this.name == null ? size.width : null,
      height: size.height,
      child: child,
    );
  }
}
