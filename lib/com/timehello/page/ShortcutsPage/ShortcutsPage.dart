
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../util/Utility.dart';

class ShortcutsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 超级工具快捷键
              SectionTitle(getI18NKey().super_tool_shortcuts),
              buildShortcutRow(getI18NKey().open_search_taskbar, 'cmd(⌘)+F'),

              SizedBox(height: 20),

// 代办清单页快捷键
              SectionTitle(getI18NKey().todo_list_shortcuts),
              buildShortcutRow(getI18NKey().fullscreen, 'ctrl/cmd(⌘)+~'),

              SizedBox(height: 20),

// 日历视图快捷键
              SectionTitle(getI18NKey().calendar_view_shortcuts),
              buildShortcutRow(getI18NKey().switch_mode, 'ctrl/cmd(⌘)+1~6'),
              buildShortcutRow(getI18NKey().today, 'ctrl/cmd(⌘)+t'),
              buildShortcutRow(getI18NKey().previous_page, 'ctrl/cmd(⌘)+a'),
              buildShortcutRow(getI18NKey().next_page, 'ctrl/cmd(⌘)+d'),
              buildShortcutRow(getI18NKey().fullscreen, 'ctrl/cmd(⌘)+~'),

              SizedBox(height: 20),

// 番茄钟快捷键
              SectionTitle(getI18NKey().pomodoro_shortcuts),
              buildShortcutRow(getI18NKey().focus_start, 'ctrl/cmd(⌘)+b'),
              buildShortcutRow(getI18NKey().focus_stop, 'ctrl/cmd(⌘)+s'),
              buildShortcutRow(getI18NKey().focus_pause, 'ctrl/cmd(⌘)+p'),
            ],
          ),
      ),
    );
  }

  // 快捷键项目布局
  Widget buildShortcutRow(String title, String shortcut) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.0),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeManager.getInstance().getDefautThemeColor(),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              shortcut,
              style: TextStyle(fontSize: 13.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 标题部分
  Widget SectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}