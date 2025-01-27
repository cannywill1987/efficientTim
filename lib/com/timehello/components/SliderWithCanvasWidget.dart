import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SliderWithCanvasWidget extends StatelessWidget {
  final double min;
  final double max;
  final double? curVal;
  final ValueChanged<double> onChange;

  const SliderWithCanvasWidget({
    super.key,
    required this.min,
    required this.max,
    this.curVal,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CanvasSlider(
            width: constraints.maxWidth ,
            min: min,
            max: max,
            curVal: curVal,
            onChange: onChange,
          );
        },
      ),
    );
  }
}

class CanvasSlider extends StatefulWidget {
  final double? width;
  final double min;
  final double max;
  final double? curVal;
  final ValueChanged<double> onChange;
  final Key? key;

  const CanvasSlider({
    this.key,
    this.width,
    required this.min,
    required this.max,
    this.curVal,
    required this.onChange,
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
    _value = widget.curVal?.clamp(widget.min, widget.max) ?? (widget.min + widget.max) / 2;
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
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _value = (_value + details.delta.dx).clamp(widget.min, widget.max);
            widget.onChange(_value);
          });
        },
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              setState(() {
                _value = (_value - event.scrollDelta.dy).clamp(widget.min, widget.max);
                widget.onChange(_value);
              });
            }
          },
          child: CustomPaint(
            size: Size(widget.width ?? MediaQuery.of(context).size.width, 18),
            painter: _SliderPainter(
              value: _value,
              min: widget.min,
              max: widget.max,
              isHovered: _isHovered,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final bool isHovered;

  _SliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final RRect trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 2 - 2, size.width, 4),
      const Radius.circular(2),
    );

    final RRect progressRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 2 - 2, ((value - min) / (max - min)) * size.width, 4),
      const Radius.circular(2),
    );

    // Draw the track
    canvas.drawRRect(trackRect, trackPaint);

    // Draw the progress
    canvas.drawRRect(progressRect, progressPaint);

    // Draw the circle if hovered
    if (isHovered) {
      canvas.drawCircle(
        Offset(((value - min) / (max - min)) * size.width, size.height / 2),
        10,
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}