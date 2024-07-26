import 'package:appflowy_editor/appflowy_editor.dart';

void formatHighlightColor(
  EditorState editorState,
  Selection? selection,
  String? color, {
  bool withUpdateSelection = false,
}) {
  editorState.formatDelta(
    selection,
    {AppFlowyRichTextKeys.backgroundColor: color},
    withUpdateSelection: withUpdateSelection,
  );
}

/**
 * lzb
 * 格式化字体颜色
 */
void formatFontColor(
  EditorState editorState,
  Selection? selection,
  String? color, {
  bool withUpdateSelection = false,
}) {
  editorState.formatDelta(
    selection,
    {AppFlowyRichTextKeys.textColor: color},
    withUpdateSelection: withUpdateSelection,
  );
}
