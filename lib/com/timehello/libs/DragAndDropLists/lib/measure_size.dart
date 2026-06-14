import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef void OnWidgetSizeChange(Size? size);

/// 拖拽列表内部使用的尺寸测量组件。
///
/// 拖拽、折叠、页面切换时，子节点可能会短暂处于未布局或已 detach 状态，
/// 所以这里不能直接读 `context.size`，必须先确认 RenderBox 已完成 layout。
class MeasureSize extends StatefulWidget {
  final Widget? child;
  final OnWidgetSizeChange onSizeChange;

  const MeasureSize({
    Key? key,
    required this.onSizeChange,
    required this.child,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  final GlobalKey widgetKey = GlobalKey();
  Size? oldSize;
  final Offset topLeftPosition = Offset.zero;
  bool _isCallbackScheduled = false;

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  /// 每帧只安排一次测量，避免 build 频繁触发时重复读取同一个节点尺寸。
  void _scheduleMeasure() {
    if (_isCallbackScheduled) return;
    _isCallbackScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  void postFrameCallback(_) {
    _isCallbackScheduled = false;
    if (!mounted) return;

    final context = widgetKey.currentContext;
    if (context == null) return;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      // 拖拽列表在切换/重排时，节点可能还没完成 layout；跳过本帧等待下一次 build。
      return;
    }

    final newSize = renderObject.size;
    if (oldSize != newSize) {
      widget.onSizeChange(newSize);
      oldSize = newSize;
    }
  }
}
