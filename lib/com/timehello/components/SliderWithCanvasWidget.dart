import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * 文件类型：公共组件
 * 文件作用：封装任务目标、计数器等场景复用的滑杆组件。
 * 主要职责：在移动端和桌面端统一处理滑杆值、可用态和 hover/拖拽交互。
 */
class SliderWithCanvasWidget extends StatelessWidget {
  final double min;
  final double max;
  final double? curVal;
  final ValueChanged<double> onChange;
  final Color color;
  final bool? shouldOnlyShowSlider;
  final bool enable;

  const SliderWithCanvasWidget({
    super.key,
    required this.min,
    required this.max,
    this.curVal,
    this.shouldOnlyShowSlider = false,
    required this.onChange,
    this.color = const Color(0xFFFF8800),
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CanvasSlider(
          width: constraints.maxWidth,
          min: min,
          max: max,
          shouldOnlyShowSlider: shouldOnlyShowSlider,
          curVal: curVal,
          onChange: onChange,
          color: color,
          enable: enable,
        );
      },
    );
  }
}

class CanvasSlider extends StatefulWidget {
  final double? width;
  final double min;
  final double max;
  final double? curVal;
  final ValueChanged<double> onChange;
  final Color color;
  final double trackHeight;
  final Key? key;
  final bool? shouldOnlyShowSlider;
  final bool enable;

  const CanvasSlider({
    this.key,
    this.width,
    this.shouldOnlyShowSlider = false,
    required this.min,
    required this.max,
    this.curVal,
    required this.onChange,
    this.color = const Color(0xFFFF8800),
    this.trackHeight = 1.0,
    this.enable = true,
  });

  @override
  State<CanvasSlider> createState() => _CanvasSliderState();
}

class _CanvasSliderState extends State<CanvasSlider> {
  late double _value;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _value = widget.curVal?.clamp(widget.min, widget.max) ??
        (widget.min + widget.max) / 2;
  }

  void setCurValue(double value) {
    setState(() {
      _value = value.clamp(widget.min, widget.max);
      widget.onChange(_value);
    });
  }

  @override
  void didUpdateWidget(covariant CanvasSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部修改最大值、最小值或当前值时，需要把内部缓存值同步回合法区间，
    // 否则总量变化后滑杆仍可能卡在旧区间，表现成“看起来不能拖动”。
    final double nextValue =
        (widget.curVal ?? _value).clamp(widget.min, widget.max);
    if (nextValue != _value ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max ||
        oldWidget.curVal != widget.curVal) {
      _value = nextValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Utility.isHandsetBySize() == true) {
      return Slider(
        value: _value,
        min: widget.min,
        max: widget.max,
        onChanged: widget.enable ? (newValue) => setCurValue(newValue) : null,
      );
    }
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: widget.trackHeight,
          thumbShape: widget.shouldOnlyShowSlider == true
              ? RoundSliderThumbShape(
                  enabledThumbRadius: widget.enable ? 10.0 : 0)
              : _isHovered
                  ? RoundSliderThumbShape(
                      enabledThumbRadius: widget.enable ? 10.0 : 0)
                  : const RoundSliderThumbShape(enabledThumbRadius: 0.0),
          thumbColor: widget.color,
          activeTrackColor: widget.color,
          inactiveTrackColor: widget.color.withValues(alpha: 0.5),
        ),
        child: Slider(
          value: _value,
          min: widget.min,
          max: widget.max,
          onChanged: widget.enable && _isHovered
              ? (newValue) => setCurValue(newValue)
              : null,
        ),
      ),
    );
  }
}
