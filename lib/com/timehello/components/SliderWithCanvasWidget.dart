import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
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
              ?  RoundSliderThumbShape(enabledThumbRadius: widget.enable? 10.0: 0)
              : _isHovered
                  ?  RoundSliderThumbShape(enabledThumbRadius:  widget.enable? 10.0: 0)
                  : const RoundSliderThumbShape(enabledThumbRadius: 0.0),
          thumbColor: widget.color,
          activeTrackColor: widget.color,
          inactiveTrackColor: widget.color.withOpacity(0.5),
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
