import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ai_content.dart';

const _menuWidth = 300;
const _hasTextHeight = 244;
const _noTextHeight = 150;
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

void showAIMenu(
  BuildContext context,
  EditorState editorState,
  Selection selection,
  bool isHighlight,
    Function? onSubmit,
) {
  // Since link format is only available for single line selection,
  // the first rect(also the only rect) is used as the starting reference point for the [overlay] position
  final texts = editorState.getTextInSelection(selection);
  String text = texts.join('\n');
  // get link address if the selection is already a link
  String? linkText;
  if (isHighlight) {
    linkText = editorState.getDeltaAttributeValueInSelection(
      BuiltInAttributeKey.href,
      selection,
    );
  }

  final (left, top, right, bottom) = _getPosition(editorState, linkText);

  // get node, index and length for formatting text when the link is removed
  final node = editorState.getNodeAtPath(selection.end.path);
  if (node == null) {
    return;
  }
  final index = selection.normalized.startIndex;
  final length = selection.length;

  OverlayEntry? overlay;

  void dismissOverlay() {
    keepEditorFocusNotifier.decrease();
    overlay?.remove();
    overlay = null;
  }

  keepEditorFocusNotifier.increase();
  overlay = FullScreenOverlayEntry(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    dismissCallback: () => keepEditorFocusNotifier.decrease(),
    builder: (context) {
      return Container(width: 600, height: 600, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: AIContentWidget(onSubmit: (aiText) {
        onSubmit?.call(aiText, text);
      },));
      // return LinkMenu(
      //   linkText: linkText,
      //   editorState: editorState,
      //   onOpenLink: () async {
      //     await safeLaunchUrl(linkText);
      //   },
      //   onSubmitted: (text) async {
      //     // if (isURL(text)) {
      //     //   await editorState.formatDelta(selection, {
      //     //     BuiltInAttributeKey.href: text,
      //     //   });
      //     //   dismissOverlay();
      //     // }
      //   },
      //   onCopyLink: () {
      //     AppFlowyClipboard.setData(text: linkText);
      //     dismissOverlay();
      //   },
      //   onRemoveLink: () {
      //     final transaction = editorState.transaction
      //       ..formatText(
      //         node,
      //         index,
      //         length,
      //         {BuiltInAttributeKey.href: null},
      //       );
      //     editorState.apply(transaction);
      //     dismissOverlay();
      //   },
      //   onDismiss: dismissOverlay,
      // );
    },
  ).build();

  Overlay.of(context, rootOverlay: true).insert(overlay!);
}

// get a proper position for link menu
(double? left, double? top, double? right, double? bottom) _getPosition(
  EditorState editorState,
  String? linkText,
) {
  final rect = editorState.selectionRects().first;

  double? left, right, top, bottom;
  final offset = rect.center;
  final editorOffset = editorState.renderBox!.localToGlobal(Offset.zero);
  final editorWidth = editorState.renderBox!.size.width;
  (left, right) = _getStartEnd(
    editorWidth,
    offset.dx,
    editorOffset.dx,
    _menuWidth,
    rect.left,
    rect.right,
    true,
  );

  final editorHeight = editorState.renderBox!.size.height;
  (top, bottom) = _getStartEnd(
    editorHeight,
    offset.dy,
    editorOffset.dy,
    linkText != null ? _hasTextHeight : _noTextHeight,
    rect.top,
    rect.bottom,
    false,
  );

  return (left, top, right, bottom);
}

// This method calculates the start and end position for a specific
// direction (either horizontal or vertical) in the layout.
(double? start, double? end) _getStartEnd(
  double editorLength,
  double offsetD,
  double editorOffsetD,
  int menuLength,
  double rectStart,
  double rectEnd,
  bool isHorizontal,
) {
  final threshold = editorOffsetD + editorLength - _menuWidth;
  double? start, end;
  if (offsetD > threshold) {
    end = editorOffsetD + editorLength - rectStart - 5;
  } else if (isHorizontal) {
    start = rectStart;
  } else {
    start = rectEnd + 5;
  }

  return (start, end);
}
