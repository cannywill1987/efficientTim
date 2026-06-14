import 'package:flutter/widgets.dart';

/// 文件类型：拖拽看板布局日志工具。
/// 文件作用：统一输出 DragAndDropLists 布局链路日志，排查横向看板空白、约束异常和拖拽重排问题。
/// 日志格式遵循全局规范：[MMDD HH:mm:ss][DRAG_BOARD_LAYOUT][board-xxx] key=value。
const String _dragBoardLogTag = 'DRAG_BOARD_LAYOUT';
final Set<String> _dragBoardOnceKeys = <String>{};

/// 功能：输出拖拽看板布局日志。
/// 说明：布局阶段 build 可能高频触发，onceKey 用来避免同一帧链路重复刷屏。
void dragBoardLog(String event, String message, {String? onceKey}) {
  if (onceKey != null && !_dragBoardOnceKeys.add(onceKey)) {
    return;
  }
  debugPrint(
      '[${_dragBoardLogTimestamp()}][$_dragBoardLogTag][$event] $message');
}

/// 功能：生成统一日志时间前缀，格式固定为 MMDD HH:mm:ss，方便 grep 时间段。
String _dragBoardLogTimestamp() {
  final DateTime now = DateTime.now();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(now.month)}${two(now.day)} ${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
}

/// 功能：压缩输出 Flutter 约束，避免日志里出现过长对象字符串。
String dragBoardConstraints(BoxConstraints constraints) {
  return 'minW=${constraints.minWidth}, maxW=${constraints.maxWidth}, minH=${constraints.minHeight}, maxH=${constraints.maxHeight}';
}
