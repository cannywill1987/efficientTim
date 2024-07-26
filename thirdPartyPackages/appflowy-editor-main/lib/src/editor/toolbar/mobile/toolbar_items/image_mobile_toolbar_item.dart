import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

final imageMobileToolbarItem = MobileToolbarItem.action(
  itemIconBuilder: (context, __, ___) => AFMobileIcon(
    afMobileIcons: AFMobileIcons.image,
    color: MobileToolbarTheme.of(context).iconColor,
  ),
  actionHandler: (buildContext, editorState) {
    // same as the [handler] of [dividerMenuItem] in Desktop
    final container = Overlay.of(buildContext, rootOverlay: true);
    showImageMenuMobile(container, editorState);
    // final selection = editorState.selection;
    // if (selection == null || !selection.isCollapsed) {
    //   return;
    // }
    // final path = selection.end.path;
    // final node = editorState.getNodeAtPath(path);
    // final delta = node?.delta;
    // if (node == null || delta == null) {
    //   return;
    // }
    // final insertedPath = delta.isEmpty ? path : path.next;
    // final transaction = editorState.transaction;
    // transaction.insertNode(insertedPath, dividerNode());
    // // only insert a new paragraph node when the next node is not a paragraph node
    // //  and its delta is not empty.
    // final next = node.next;
    // if (next == null ||
    //     next.type != ParagraphBlockKeys.type ||
    //     next.delta?.isNotEmpty == true) {
    //   transaction.insertNode(insertedPath, paragraphNode());
    // }
    // transaction.afterSelection =
    //     Selection.collapsed(Position(path: insertedPath.next));
    // editorState.apply(transaction);
  },
);
