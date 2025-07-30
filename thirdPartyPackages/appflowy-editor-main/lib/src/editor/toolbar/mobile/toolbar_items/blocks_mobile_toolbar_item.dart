import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor/src/service/default_text_operations/format_rich_text_style.dart';
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
        icon: AFMobileIcons.datetime,
        label: i18nInstanceLocal?.datetime ?? i18nInstanceLocal.datetime,
        // label: i18nInstanceLocal.mobileHeading1,
        name: "DateTime",
        level: 1,
      ),
      // heading
      _ListUnit(
        icon: AFMobileIcons.date,
        label: i18nInstanceLocal?.date ?? i18nInstanceLocal.date,
        // label: i18nInstanceLocal.mobileHeading1,
        name: "Date",
        level: 1,
      ),      // heading
      _ListUnit(
        icon: AFMobileIcons.time,
        label: i18nInstanceLocal?.time ?? i18nInstanceLocal.time,
        // label: i18nInstanceLocal.mobileHeading1,
        name: "Time",
        level: 1,
      ),
      // heading
      _ListUnit(
        icon: AFMobileIcons.h1,
        label: i18nInstanceLocal?.mobileHeading1 ?? i18nInstanceLocal.mobileHeading1,
        // label: i18nInstanceLocal.mobileHeading1,
        name: HeadingBlockKeys.type,
        level: 1,
      ),
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
            if(list.name == 'DateTime') { // lzb
              try {
                // lzb yyyy-mm-dd hh:mm:ss
                String datetime = DateTime.now().toString().substring(0, 19);
                // Selection? selection = editorState.selection;
                final delta = Delta();
                delta.insert(datetime, attributes: {"font_color": "0xff9e9e9e",});
                insertNodeAfterSelection(
                  widget.editorState,
                  paragraphNode(
                    delta: delta,
                  ),
                );
              } catch (e) {
                print(e);
              }
            } else if(list.name == 'Date') { // lzb
              //  yyyy-mm-dd
              String date = DateTime.now().toString().substring(0, 10);
              final delta = Delta();
              delta.insert(date, attributes: {"font_color": "0xff9e9e9e",});
              insertNodeAfterSelection(
                widget.editorState,
                paragraphNode(
                  delta: delta,
                ),
              );
            }  else if(list.name == 'Time') { // lzb
              // hh:mm:ss
              String time = DateTime.now().toString().substring(11, 19);
              final delta = Delta();
              delta.insert(time, attributes: {"font_color": "0xff9e9e9e",});
              insertNodeAfterSelection(
                widget.editorState,
                paragraphNode(
                  delta: delta,
                ),
              );
            }  else {
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
            }
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
