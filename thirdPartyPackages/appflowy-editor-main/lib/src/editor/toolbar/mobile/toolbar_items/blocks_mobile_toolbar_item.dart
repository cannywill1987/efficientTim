import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

final blocksMobileToolbarItem = MobileToolbarItem.withMenu(
  itemIconBuilder: (context, __, ___) => AFMobileIcon(
    afMobileIcons: AFMobileIcons.list,
    color: MobileToolbarTheme.of(context).iconColor,
  ),
  itemMenuBuilder: (_, editorState, __) {
    final selection = editorState.selection;
    if (selection == null) {
      return const SizedBox.shrink();
    }
    return _BlocksMenu(editorState, selection);
  },
);

class _BlocksMenu extends StatefulWidget {
  const _BlocksMenu(
    this.editorState,
    this.selection,
  );

  final Selection selection;
  final EditorState editorState;

  @override
  State<_BlocksMenu> createState() => _BlocksMenuState();
}

class _BlocksMenuState extends State<_BlocksMenu> {

  @override
  Widget build(BuildContext context) {
    List lists = [
      // heading
      _ListUnit(
        icon: AFMobileIcons.h1,
        label: i18nInstanceLocal?.mobileHeading1 ?? i18nInstanceLocal.mobileHeading1,
        // label: i18nInstanceLocal.mobileHeading1,
        name: HeadingBlockKeys.type,
        level: 1,
      ),
      _ListUnit(
        icon: AFMobileIcons.h2,
        label: i18nInstanceLocal?.mobileHeading2 ?? i18nInstanceLocal.mobileHeading2,
        name: HeadingBlockKeys.type,
        level: 2,
      ),
      _ListUnit(
        icon: AFMobileIcons.h3,
        label: i18nInstanceLocal?.mobileHeading3 ?? i18nInstanceLocal.mobileHeading3,
        name: HeadingBlockKeys.type,
        level: 3,
      ),
      // list
      _ListUnit(
        icon: AFMobileIcons.bulletedList,
        label: i18nInstanceLocal?.bulletedList ?? i18nInstanceLocal.bulletedList,
        name: BulletedListBlockKeys.type,
      ),
      _ListUnit(
        icon: AFMobileIcons.numberedList,
        label: i18nInstanceLocal?.numberedList ??  i18nInstanceLocal.numberedList,
        name: NumberedListBlockKeys.type,
      ),
      _ListUnit(
        icon: AFMobileIcons.checkbox,
        label: i18nInstanceLocal?.checkbox ??  i18nInstanceLocal.checkbox,
        name: TodoListBlockKeys.type,
      ),
      _ListUnit(
        icon: AFMobileIcons.quote,
        label: i18nInstanceLocal?.quote ??i18nInstanceLocal.quote,
        name: QuoteBlockKeys.type,
      ),
    ];

    final style = MobileToolbarTheme.of(context);

    final children = lists.map((list) {
      // Check if current node is list and its type
      final node = widget.editorState.getNodeAtPath(
        widget.selection.start.path,
      )!;

      final isSelected = node.type == list.name &&
          (list.level == null ||
              node.attributes[HeadingBlockKeys.level] == list.level);

      return MobileToolbarItemMenuBtn(
        icon: AFMobileIcon(
          afMobileIcons: list.icon,
          color: MobileToolbarTheme.of(context).iconColor,
        ),
        label: Text(list.label),
        isSelected: isSelected,
        onPressed: () {
          setState(() {
            widget.editorState.formatNode(
              widget.selection,
              (node) => node.copyWith(
                type: isSelected ? ParagraphBlockKeys.type : list.name,
                attributes: {
                  ParagraphBlockKeys.delta: (node.delta ?? Delta()).toJson(),
                  blockComponentBackgroundColor:
                      node.attributes[blockComponentBackgroundColor],
                  if (!isSelected && list.name == TodoListBlockKeys.type)
                    TodoListBlockKeys.checked: false,
                  if (!isSelected && list.name == HeadingBlockKeys.type)
                    HeadingBlockKeys.level: list.level,
                },
              ),
              selectionExtraInfo: {
                selectionExtraInfoDoNotAttachTextService: true,
              },
            );
          });
        },
      );
    }).toList();

    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: buildMobileToolbarMenuGridDelegate(
        mobileToolbarStyle: style,
        crossAxisCount: 2,
      ),
      children: children,
    );
  }
}

class _ListUnit {
  final AFMobileIcons icon;
  final String label;
  final String name;
  final int? level;

  _ListUnit({
    required this.icon,
    required this.label,
    required this.name,
    this.level,
  });
}
