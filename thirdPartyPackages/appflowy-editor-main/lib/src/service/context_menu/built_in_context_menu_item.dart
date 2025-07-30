import 'package:appflowy_editor/src/editor/l10n/appflowy_editor_l10n.dart';

import '../../../appflowy_editor.dart';
import '../internal_key_event_handlers/copy_paste_handler.dart';
import 'context_menu.dart';

final standardContextMenuItems = [
  [
    // cut
    ContextMenuItem(
      getName: () => i18nInstanceLocal.cut,
      onPressed: (editorState) {
        handleCut(editorState);
      },
    ),
    // copy
    ContextMenuItem(
      getName: () => i18nInstanceLocal.copy,
      onPressed: (editorState) {
        handleCopy(editorState);
      },
    ),
    // Paste
    ContextMenuItem(
      getName: () => i18nInstanceLocal.paste,
      onPressed: (editorState) {
        handlePaste(editorState);
      },
    ),
  ],
];
