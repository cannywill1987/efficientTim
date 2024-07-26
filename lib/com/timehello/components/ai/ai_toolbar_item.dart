
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';

// const _menuWidth = 300;
// const _hasTextHeight = 244;
// const _noTextHeight = 150;
// lzb ai toolbar item
// final ToolbarItem aiItem = ToolbarItem(
//   id: 'editor.ai',
//   group: 0, // 位置
//   isActive: onlyShowInSingleSelectionAndTextType,
//   builder: (context, editorState, highlightColor, iconColor) {
//     final selection = editorState.selection!;
//     final node = editorState.getNodeAtPath(selection.start.path)!;
//     final isHighlight = node.type == 'paragraph';
//     final delta = (node.delta ?? Delta()).toJson();
//     return SVGIconItemWidget(
//         iconName: 'toolbar/ai',
//         name: i18nInstanceLocal.ai,
//         isHighlight: isHighlight,
//         highlightColor: highlightColor,
//         iconColor: iconColor,
//         tooltip: i18nInstanceLocal.ai,
//         onPressed: () {
//           showAIMenu(context, editorState, selection, isHighlight);
//         });
//   },
// );

