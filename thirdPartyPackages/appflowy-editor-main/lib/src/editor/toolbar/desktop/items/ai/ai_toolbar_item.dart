import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor/src/editor/toolbar/desktop/items/ai/ai_search_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ai_content.dart';
import 'ai_content_confirm.dart';

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

void showAISearchBarMenuWithoutText({
    required BuildContext context,
    required EditorState editorState,
    required String prompt,
    required String title,
    required String placeholder,
    // bool isHighlight,
    Function? onSubmit,
    Function? onContinue,
    Function? onCopy,
}) {
  // Since link format is only available for single line selection,
  // the first rect(also the only rect) is used as the starting reference point for the [overlay] position
  // final texts = editorState.getTextInSelection(selection);
  // String text = texts.join('\n');
  // get link address if the selection is already a link
  String? linkText;
  // if (isHighlight) {
  //   linkText = editorState.getDeltaAttributeValueInSelection(
  //     BuiltInAttributeKey.href,
  //     selection,
  //   );
  // }

  final (left, top, right, bottom) = _getPosition(editorState, linkText);
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  // get node, index and length for formatting text when the link is removed
  // final node = editorState.getNodeAtPath(selection.end.path);
  // if (node == null) {
  //   return;
  // }
  // final index = selection.normalized.startIndex;
  // final length = selection.length;

  OverlayEntry? overlay;

  void dismissOverlay() {
    keepEditorFocusNotifier.decrease();
    overlay?.remove();
    overlay = null;
  }

  keepEditorFocusNotifier.increase();
  overlay = FullScreenOverlayEntry(
    top: height / 2 - 200,
    bottom: bottom,
    left: width / 2 - 300,
    right: right,
    dismissCallback: () => keepEditorFocusNotifier.decrease(),
    builder: (context) {
      return Container(
          width: 600,
          // height: 600,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: AISearchContentWidget(
            title: title,
            prompt: prompt,
            placeholder: placeholder,
            onSubmit: (prompt, aiText) async {
              String res = await onSubmit?.call(aiText, prompt);
              showAIConfirmMenu(context: context, editorState: editorState, selection: null, isHighlight: false,
                  text: res, prompt: prompt, onSubmit: onSubmit, onContinue: onContinue, onCopy: onCopy);

              // showAIConfirmMenu(context, editorState, prompt, false,
              //     res, null, onSubmit, onContinue, onCopy);
              // showAIConfirmMenu(context, editorState, selection, isHighlight,
              //     res, onSubmit, onContinue, onCopy);
              dismissOverlay();
            },
          ));
    },
  ).build();

  Overlay.of(context, rootOverlay: true).insert(overlay!);
}

void showAIMenu(
  BuildContext context,
  EditorState editorState,
  Selection selection,
  bool isHighlight,
  Function? onSubmit,
  Function? onContinue,
    Function? onCopy,
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
      return Container(
          width: 400,
          height: 600,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: AIContentWidget(
            onSubmit: (aiText) async {
              String res = await onSubmit?.call(aiText, text);
              showAIConfirmMenu(context: context, editorState: editorState, selection: selection, isHighlight: isHighlight,
                  text: res, prompt: null, onSubmit: onSubmit, onContinue: onContinue, onCopy: onCopy);
              dismissOverlay();
            },
          ));
    },
  ).build();

  Overlay.of(context, rootOverlay: true).insert(overlay!);
}

void showAIConfirmMenu( {
  required BuildContext context,
  required EditorState editorState,
  Selection? selection,
  bool isHighlight = false,
  String? text,
  String? prompt,
  Function? onSubmit,
  Function? onContinue,
    Function? onCopy,
}
) {
  // Since link format is only available for single line selection,
  // the first rect(also the only rect) is used as the starting reference point for the [overlay] position
  // final texts = editorState.getTextInSelection(selection);
  // String text = texts.join('\n');
  // get link address if the selection is already a link
  String? linkText;
    OverlayEntry? overlay;
    final (left, top, right, bottom) = _getPosition(editorState, linkText);
  if(selection != null) {
    if (isHighlight) {
      linkText = editorState.getDeltaAttributeValueInSelection(
        BuiltInAttributeKey.href,
        selection,
      );
    }


    // get node, index and length for formatting text when the link is removed
    final node = editorState.getNodeAtPath(selection!.end.path);
    if (node == null) {
      return;
    }
    // final index = selection.normalized.startIndex;
    // final length = selection.length;

  }
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  void dismissOverlay() {
    keepEditorFocusNotifier.decrease();
    overlay?.remove();
    overlay = null;
  }

  keepEditorFocusNotifier.increase();
  overlay = FullScreenOverlayEntry(
    top: height / 2 - 200,
    bottom: bottom,
    left: width / 2 - 200,
    right: right,
    dismissCallback: () => keepEditorFocusNotifier.decrease(),
    builder: (context) {
      return Container(
          width: 400,
          height: 600,
          // decoration: BoxDecoration(
          //     color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: AiContentConfirmWidget(
            shouldShowReplace: selection != null,
            text: text ?? "",
            onCopy: (text) {
              print('复制');
              onCopy?.call(text);
              dismissOverlay();
              // _controller.text = this.widget.text;
            },
            onReplace: (text) {
              print('替换');
              editorState.replaceTextAtPosition(text, selection: selection!);
            },
            onInsert: (text) {
              print('插入');
              editorState.insertTextAtLastCurrentSelection(
                text,
                // position: selection.end,
                // forceInsert: true
              );
              // setState({});
            },
            onContinue: (text) async {
              print('继续写作');
              String res = await onContinue?.call(i18nInstanceLocal.continue_writing_prompt + "-" + (prompt ?? ""),  text);
              text = res;
              showAIConfirmMenu(context: context, editorState: editorState, selection: selection, isHighlight: isHighlight,
                  text: res, prompt: null, onSubmit: onSubmit, onContinue: onContinue, onCopy: onCopy);
              // showAIConfirmMenu(context, editorState, selection, isHighlight,
              //     res, null, onSubmit, onContinue,onCopy);
            },
            onGiveUp: (text) {
              print('放弃');
              dismissOverlay();
            },
            onSubmit: (aiText) async {
              String res = await onSubmit?.call(aiText, text);
              dismissOverlay();
              showAIConfirmMenu(context: context, editorState: editorState, selection: selection, isHighlight: isHighlight,
                  text: res, prompt: null, onSubmit: onSubmit, onContinue: onContinue, onCopy: onCopy);
              // showAIConfirmMenu(context, editorState, selection, isHighlight,
              //     res, null, onSubmit, onContinue,onCopy);
            },
          ));
    },
  ).build();

  Overlay.of(context, rootOverlay: true).insert(overlay!);
}

// get a proper position for link menu
(double? left, double? top, double? right, double? bottom) _getPosition(
  EditorState editorState,
  String? linkText,
) {
  Rect rect = Rect.fromLTRB(0, 0, 0, 0);
  if(editorState.selectionRects().length > 0) {
    rect = editorState.selectionRects().first;
  }

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
